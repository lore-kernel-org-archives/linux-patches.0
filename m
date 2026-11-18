Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019110;
	b=p36PNsZVYTtwNF21FL4AERzqC0D8VBtq9uhMdW9uKmAWcztPBmuaZfqQQcjwfbWyVKpp
	 sB34aA0oLyGYcpdnKnxzLkCu6Dy9rmd0yD524vhkVmI5ViVEREeOjcNwdlxbAxbg5t79z
	 X+xZaxu5TTbjpOfpXrfZqMBeKz6+r++/TdVwfTAb+GinDQsIfDp7HPvOLD2hmeNu7nWKz
	 PfQLYTjLxb7H1zKjMVLMThnC36jLIRPI32dQiqaKayFnFgTDyqlsW5vDwMBjxlqD+EzJY
	 5VWyZsjHT70PT7j8kGTBUr4djC1+2GVwR9k77wjWtoYgigdWCdp2tECbkjymGhdhung==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PBVEvlonBAImGeNM2RoVSrXLVu2yVC1DNRQ73BaRB7o=;
	b=KvbaToDDPwg8AZTFFHW72RDpCpSGB8seBIitx22UvpZBcno26lX+bMgX1JY8laT6lrxw
	 d+vTpdNMeRfpkhKMftVMf7fxBOFMXSNz3a8tBDrHEMk4AKa0D89m4U4Xfk8XsvVLw4PBY
	 w7Wb1/8mBBpWdSAOGLvOW3ldZDe61ga18dMD8/+CbtoqpTebwp20foRakEiI5Ry0IW/2Y
	 77vT6d82D6KW08ESjiF37/AS0l4mAF6igxCA6asyiDdObsnZsn9Tj0uu48gCLVUgwVctd
	 LLNrFm4+0vNSJjKEogy8O9BwsE92TKNVkaXhsuPFOzRe8CTE8PcjYJTnZcujvySH5+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vKh0mFtu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6EE606A331;
	Wed, 18 Nov 2026 16:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vKh0mFtu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B810A1F000C5;
	Wed, 18 Nov 2026 16:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019110;
	bh=PBVEvlonBAImGeNM2RoVSrXLVu2yVC1DNRQ73BaRB7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vKh0mFtuObbaceG9zmmacWmwr4F4Gj5jbl4P74SHTMkcQ0uBFZF/nhCdWGELL3+wK
	 0Dpt4CWIkkYTipr5r6yESqXE/dQwqwqxGmmQGL7yGyo8IL3rvT5I30DQuRCx1RJBSH
	 p7jeKw1TDtG+9/mlQfvA55MYby3eQRD9KuGE6zH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1477/2651] wifi: mt76: mt7996: make a returning link primary if a station has none
Date: Wed, 18 Nov 2026 15:45:17 +0100
Message-ID: <20261118150341.200507118@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit db6282754bcfa8b6ba9c4e1c02dff076247a96b9 ]

mt7996_mac_sta_remove_link() clears deflink_id when it removes the
primary link and no secondary link is left to take its place. If the
removed link then comes back, mt7996_mac_sta_add_links() finds its
existing msta_link and only marks it valid again. deflink_id stays
IEEE80211_LINK_UNSPECIFIED, so the station has no primary link: the TXQs
keep the WLAN index that they had before, seclink_id stays unspecified,
mt7996_sta_rate_ctrl_update() finds no primary link, and
mt7996_sta_set_4addr() treats every link as a secondary link.

Make a returning link the primary link when the station has none, in
the same way as mt7996_mac_sta_init_link() does for a new link. Move the
two steps that set the primary link, and the switch to the secondary
link on removal, to helpers.

Fixes: e8c819df0243 ("wifi: mt76: mt7996: Destroy active sta links in mt7996_mac_sta_remove()")
Link: https://patch.msgid.link/20261006205936.669125-13-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 55 +++++++++++++------
 1 file changed, 37 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index f6e1bc73c7317..7b9ec454b39ce 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1140,6 +1140,38 @@ mt7996_sta_init_txq_wcid(struct ieee80211_sta *sta, int idx)
 	}
 }
 
+static void
+mt7996_sta_deflink_set(struct ieee80211_sta *sta, unsigned int link_id,
+		       int idx)
+{
+	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
+
+	msta->deflink_id = link_id;
+	mt7996_sta_init_txq_wcid(sta, idx);
+}
+
+static void
+mt7996_sta_deflink_release(struct mt7996_dev *dev, struct ieee80211_sta *sta,
+			   unsigned int link_id)
+{
+	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
+	struct mt7996_sta_link *msta_seclink;
+
+	if (msta->deflink_id != link_id)
+		return;
+
+	msta->deflink_id = IEEE80211_LINK_UNSPECIFIED;
+	if (msta->seclink_id == link_id)
+		return;
+
+	/* switch to the secondary link */
+	msta_seclink = mt76_dereference(msta->link[msta->seclink_id],
+					&dev->mt76);
+	if (msta_seclink)
+		mt7996_sta_deflink_set(sta, msta->seclink_id,
+				       msta_seclink->wcid.idx);
+}
+
 static u8
 mt7996_sta_seclink_get(struct mt7996_dev *dev, struct mt7996_sta *msta)
 {
@@ -1187,8 +1219,7 @@ mt7996_mac_sta_init_link(struct mt7996_dev *dev,
 
 	if (msta->deflink_id == IEEE80211_LINK_UNSPECIFIED) {
 		msta_link = &msta->deflink;
-		msta->deflink_id = link_id;
-		mt7996_sta_init_txq_wcid(sta, idx);
+		mt7996_sta_deflink_set(sta, link_id, idx);
 	} else {
 		msta_link = kzalloc_obj(*msta_link);
 		if (!msta_link) {
@@ -1249,22 +1280,7 @@ void mt7996_mac_sta_remove_link(struct mt7996_dev *dev,
 		mt7996_mac_wtbl_update(dev, msta_link->wcid.idx,
 				       MT_WTBL_UPDATE_ADM_COUNT_CLEAR);
 
-		if (msta->deflink_id == link_id) {
-			msta->deflink_id = IEEE80211_LINK_UNSPECIFIED;
-			if (msta->seclink_id != link_id) {
-				struct mt7996_sta_link *msta_seclink;
-
-				/* switch to the secondary link */
-				msta_seclink = mt76_dereference(
-						msta->link[msta->seclink_id],
-						&dev->mt76);
-				if (msta_seclink) {
-					msta->deflink_id = msta->seclink_id;
-					mt7996_sta_init_txq_wcid(sta,
-						msta_seclink->wcid.idx);
-				}
-			}
-		}
+		mt7996_sta_deflink_release(dev, sta, link_id);
 		msta_link->wcid.link_valid = false;
 		msta->seclink_id = mt7996_sta_seclink_get(dev, msta);
 	}
@@ -1343,6 +1359,9 @@ mt7996_mac_sta_add_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 		msta_link = mt76_dereference(msta->link[link_id], &dev->mt76);
 		if (msta_link) {
 			msta_link->wcid.link_valid = true;
+			if (msta->deflink_id == IEEE80211_LINK_UNSPECIFIED)
+				mt7996_sta_deflink_set(sta, link_id,
+						       msta_link->wcid.idx);
 			msta->seclink_id = mt7996_sta_seclink_get(dev, msta);
 			continue;
 		}
-- 
2.53.0



