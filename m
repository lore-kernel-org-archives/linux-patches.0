Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06ADF34104E;
	Thu,  2 Jul 2026 16:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009997; cv=none; b=Km61UKWFzRFRRRNo7KurUw3BoBRmZ3c6vIgEObBsuj9lCVrl9XMhrWpthnWDU9hIPkOEOwBo9iN59EI4Dii4VQYugRJtS1Uht2bJJeJlWa0UihldRgGpX0EmbtP+JKePh5IlyPm0BIRXQnFpWuYyhm8rqhLqctnIRyr3/AkVDJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009997; c=relaxed/simple;
	bh=ZNS46mOQB8gsKwsGIX9FK2xpjWeuWZ1R50cdYxFAgs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RxdDxp5LqymtWz5udZJ1jt15/MSjqmoEBcTQsIuvKL7wwuMNuWx9HNrx0bV3xGaHy5UDCrx4Nlx3DdAXkSwpeQJ3MjatAs0B7z599QsXNliLI8bJ6EmRGCVPp20pAszV2Yg+Q51y0EydXoxwJ5LvsdsKdI5QYnFjk8KWg35WhHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q1CekFTQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q1CekFTQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0551F000E9;
	Thu,  2 Jul 2026 16:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009995;
	bh=0ZAydgfGvoNo50DGjM6wevirOdVX0r3KcUT88/P0/Yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q1CekFTQ8YKtKH4Lfx36gYgcS4FrcB87gJti5uE+3Qs+5rOR9npgy2013AdBcYRyX
	 WPA8Xh6AQATISF3ie+coOihwmyAH/Mw7V5N2z8D4KirAALW277znBUz2ozw6H3j9JF
	 5dbAy0DcU22X4MBIvCOT/Twv3csLhjXib20gq+gQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/129] batman-adv: dat: prevent false sharing between VLANs
Date: Thu,  2 Jul 2026 18:19:51 +0200
Message-ID: <20260702155113.634081687@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 20d7658b74169f86d4ac01b9185b3eadddf71f28 upstream.

The local hash of DAT entries is supposed to be VLAN (VID) aware. But
the adding to the hash and the search in the hash were not checking the VID
information of the hash entries. The entries would therefore only be
correctly separated when batadv_hash_dat() didn't select the same buckets
for different VIDs.

Cc: stable@kernel.org
Fixes: be1db4f6615b ("batman-adv: make the Distributed ARP Table vlan aware")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/distributed-arp-table.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/distributed-arp-table.c b/net/batman-adv/distributed-arp-table.c
index e8d706d86aa82a..36462d9288c7ee 100644
--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -215,10 +215,13 @@ static void batadv_dat_purge(struct work_struct *work)
  */
 static bool batadv_compare_dat(const struct hlist_node *node, const void *data2)
 {
-	const void *data1 = container_of(node, struct batadv_dat_entry,
-					 hash_entry);
+	const struct batadv_dat_entry *entry1;
+	const struct batadv_dat_entry *entry2;
 
-	return memcmp(data1, data2, sizeof(__be32)) == 0;
+	entry1 = container_of(node, struct batadv_dat_entry, hash_entry);
+	entry2 = data2;
+
+	return entry1->ip == entry2->ip && entry1->vid == entry2->vid;
 }
 
 /**
@@ -345,6 +348,9 @@ batadv_dat_entry_hash_find(struct batadv_priv *bat_priv, __be32 ip,
 		if (dat_entry->ip != ip)
 			continue;
 
+		if (dat_entry->vid != vid)
+			continue;
+
 		if (!kref_get_unless_zero(&dat_entry->refcount))
 			continue;
 
-- 
2.53.0



