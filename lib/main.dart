import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Pentru citirea fișierelor din assets

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: FutureBuilder(
          future: _loadData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              var data = snapshot.data as Map<String, dynamic>;
              return MyHomePage(data: data);
            }
          },
        ),
      ),
    );
  }

  // Funcția pentru a citi și decoda fișierul JSON
  Future<Map<String, dynamic>> _loadData() async {
    String jsonString = await rootBundle.loadString('assets/data.json');
    print(jsonString); // Adăugați această linie pentru a verifica dacă fișierul este citit corect.
    return jsonDecode(jsonString);
  }
}

class MyHomePage extends StatelessWidget {
  final Map<String, dynamic> data;

  MyHomePage({required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          _buildHeaderSection(data['profile']), // corectat pentru a folosi 'profile'

          // Home Card
          _buildHomeCard(data['homeCard']['image']), // corectat pentru a accesa 'image'

          // Search and Filter Section
          _buildSearchAndFilter(),

          // Nearest Barbershop Section
          _buildNearestBarbershopSection(data['barbershops']), // corectat pentru a folosi 'barbershops'

          // Most Recommended Section
          _buildMostRecommendedSection(data['mostRecommended']), // corectat pentru a folosi 'mostRecommended'
        ],
      ),
    );
  }

  // Header Section
  Widget _buildHeaderSection(Map<String, dynamic> headerData) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Row(
                children: [
                  SizedBox(width: 4),
                  Text(
                    headerData['location'],
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                headerData['name'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(height: 20),
              ClipOval(
                child: Image.asset(
                  headerData['profileImage'],
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Home Card
  Widget _buildHomeCard(String imagePath) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: [
            SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                height: 250,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Nearest Barbershop Section
  Widget _buildNearestBarbershopSection(List<dynamic> barbershops) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Nearest Barbershop',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 12),
        for (var barbershop in barbershops)
          _buildBarbershopTile(barbershop['title'], barbershop['location'],
              barbershop['rating'], barbershop['image']),
      ],
    );
  }

  Widget _buildBarbershopTile(String title, String location, String rating,
      String imagePath) {
    return Container(
      width: 339,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            height: 100,
            width: 100,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(location, style: TextStyle(color: Colors.purple)),
            SizedBox(height: 4),
            Text(rating, style: TextStyle(color: Colors.purple)),
          ],
        ),
      ),
    );
  }

  // Most Recommended Section
  Widget _buildMostRecommendedSection(List<dynamic> recommendedBarbershops) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Most Recommended',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 12),
        for (var barbershop in recommendedBarbershops)
          _buildLargeRecommendedTile(
            barbershop['title'],
            barbershop['subtitle'], // corectat pentru a accesa 'subtitle'
            barbershop['rating'],
            barbershop['image'],
          ),
      ],
    );
  }

  // Large Image Tile for Most Recommended
  Widget _buildLargeRecommendedTile(
      String title, String location, String rating, String imagePath) {
    return Container(
      width: 339,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            height: 100,
            width: 100,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(location, style: TextStyle(color: Colors.purple)),
            SizedBox(height: 4),
            Text(rating, style: TextStyle(color: Colors.purple)),
          ],
        ),
      ),
    );
  }

  // Search and Filter Section
  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Search and Filter',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Icon(Icons.filter_list),
        ],
      ),
    );
  }
}
