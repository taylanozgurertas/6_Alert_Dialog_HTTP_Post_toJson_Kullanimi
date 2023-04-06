import 'dart:convert';

import 'package:deneme8/model/book.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //http package ı http diyerek çalıştırabilmemiz için gerekli

class FirebaseBookView extends StatefulWidget {
  const FirebaseBookView({Key? key}) : super(key: key);

  @override
  State<FirebaseBookView> createState() => _FirebaseBookViewState();
}

class _FirebaseBookViewState extends State<FirebaseBookView> {
  late TextEditingController _bookNameTEC;
  late TextEditingController _bookIDTEC;
  late TextEditingController _bookAuthorTEC;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bookNameTEC = TextEditingController();
    _bookIDTEC = TextEditingController();
    _bookAuthorTEC = TextEditingController();
  }

  //post metodumuzu yazıyoruz şimdi bu fonksiyonu yazmadan önce model klasörü oluşturduk içine de book.dart model sınıfı oluşturduk
  Future<bool> _postBookData() async{
    final _book = Book(); //Book model sınıfımızdan bir nesne oluştur
    _book.author = _bookAuthorTEC.text;
    _book.id= int.parse(_bookIDTEC.text);
    _book.title = _bookNameTEC.text; //textfieldların içerisindeki textleri oluşturulan nesnenin özelliklerine koy

    var url = Uri.parse('https://hwasampleapi.firebaseio.com/api/books.json');
    var response = await http.post(url, body: _book.toJson());

    //bodye sen git _book nesnesindeki toJson metodunu kullan
    if(response.statusCode==200){ //başarılıysa
      debugPrint("başarılı response");
      return true;
    }else{ //başarısızsa
      debugPrint(response.body);
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Book View"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      //bunu verdik ki tüm alana boşuna yayılmasın dialog widgetındaki
                      children: [
                        TextField(
                          controller: _bookNameTEC,
                          decoration: InputDecoration(
                            labelText: "NAME",
                          ),
                        ),

                        TextField(
                          controller: _bookIDTEC,
                          decoration: InputDecoration(
                            labelText: "ID",
                          ),
                        ),

                        TextField(
                          controller: _bookAuthorTEC,
                          decoration: InputDecoration(
                            labelText: "AUTHOR",
                          ),
                        ),

                        IconButton(
                            onPressed: () async{
                             final _result = await _postBookData();
                             debugPrint(_result as String?);
                            },
                            icon: Icon(Icons.send)
                        ),


                      ],
                    ),
                  ),
                );
              });
        },
        child: Icon(Icons.add),
      ),
      //floating action button scaffoldun bir özelligi bir buton sağ alt ya da aşağıdaki buton

      floatingActionButtonLocation: FloatingActionButtonLocation
          .endFloat, //floating action button'ı en sağa atar
    );
  }

  /*
  şimdi buradaki mevzu nedir?
  aslında pratik olarak bir Widget fonksiyonu yazıyoruz burada
  AppBar döndüren bir _appBar adlı fonksiyonumuz geriye tabiiki AppBar döndürüyor pratik olarak
  bu şekilde yazıyoruz yani bana bir AppBar getir ismi de _appBar olsun diyerek AppBarımızı kodluyoruz
  mantık böyle böyle widgetlara böle böle küçük küçük parçalara ayırarak aynı yerde tutmak ve temiz bir kod
  yazmak tüm meselemiz.
   */
  AppBar get _appBar => AppBar(
        title: Text("Post Book View"),
      );
}
