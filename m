Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019107;
	b=N8SQcXkEio9xPJxuDxhcDcoCaRnC+TEJQ+v09o4N6Rk6SHlegfA2yvLN0CqU06etSKvy
	 pUI7wjt0CD0WrB9DR031vtuaveQ02vXvBWVSognDrCaW9cX9hE+hdtmEBFZi2a8zPkEd+
	 9RASCY6pMsRMd163AUvTpkrV2SAnL8+lwGc4fCSam2kQxQqdMeunyb2LFCO7YvxfBI4j3
	 TslFAWVKWhk1zE0dvDDpvlx/ootziXqzPT/RexS1QMezVSjLHhQwFmDT00NUTER84y/39
	 NEJv1Kh+R4EtzH0FViYpERgaEyTrX3LcM3/P4sLjzP6qak1Cr99XHFD+p7ZmUyIeyJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EOYMqOtk9OWYdq4v0yhLbZp3a+4d3GkYZB+6ykYsQ+Y=;
	b=Ym7hphAvaGn6HJ+7QtHiEn5gyslCYG9hFwrO88MCAnYlZpcs+ECvELims1UDrSMHrD1u
	 ZGsRlLF54mN+oQBg6769U8gCyHZTqlYMyMAZh31/r78LY/elUmZlOkg+GXtC2MN03Khsb
	 MlFbzTvQNE/s/YROfv3/GJ/40xN8aqu0OOt/40FhX//LSSc6xp10nbMQ92sG6umL5PTPE
	 /3qa967Q71jC/K6RfbGPusiZEtRgdyGz1BPlKlDn0xRFvZq5jLW6q4qWgI2NtuthlZJgy
	 D9c1UHubFP28Wg8mr5166IVd+yHkzBhxqalWauq50IMCodIfrc7N33PcoeJLz9Fn2ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sdoUjRMm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8469060A2602;
	Wed, 18 Nov 2026 16:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sdoUjRMm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D758D1F000C5;
	Wed, 18 Nov 2026 16:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019107;
	bh=EOYMqOtk9OWYdq4v0yhLbZp3a+4d3GkYZB+6ykYsQ+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sdoUjRMmrIyqyM4CwkjrW3sPPoclFvhaUr6xTzGZAmIxKsNM8MBbNJDHdUqOJGHyU
	 mZ+N0aKL2Wosuw50iUw4sayQ2qlm4iF2ez4ew5dtJTBJ+5FjSVzKfAx1rRCPLTXTDA
	 RxtbxpzuYm8kJY911g7g3sr2qKB4W+c1rmO5Bp78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1476/2651] wifi: mt76: mt7996: pick the secondary link from links with driver state
Date: Wed, 18 Nov 2026 15:45:16 +0100
Message-ID: <20261118150341.165077589@linuxfoundation.org>
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

[ Upstream commit 53eadd11e92729976168d74f27345461a5e1ef46 ]

mt7996_mac_sta_init_link() takes the secondary link from
sta->valid_links. On a station interface mac80211 creates driver state
only for active links, since drv_change_sta_links() masks both link
sets with vif->active_links. With three valid links of which links 0
and 2 are active, seclink_id then points at link 1, which has no
mt7996_sta_link. mt7996_tx_prepare_skb() maps odd TIDs to seclink_id,
keeps the primary wcid for them and passes the inactive link id to
mt7996_mac_write_txwi(), which finds no vif link and falls back to OMAC
and WMM index 0.

Choose the secondary link among the links that have driver state and
are valid, and choose it again whenever such a link is added, restored
or removed. A removed secondary link now hands over to another
remaining link instead of the primary one, and a secondary link that
was promoted to primary gets a successor.

Fixes: 85cd5534a3f2 ("wifi: mt76: mt7996: use correct link_id when filling TXD and TXP")
Link: https://patch.msgid.link/20261006205936.669125-12-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 42 +++++++++++++------
 1 file changed, 30 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 6ef399b7f72e1..f6e1bc73c7317 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1140,6 +1140,32 @@ mt7996_sta_init_txq_wcid(struct ieee80211_sta *sta, int idx)
 	}
 }
 
+static u8
+mt7996_sta_seclink_get(struct mt7996_dev *dev, struct mt7996_sta *msta)
+{
+	struct mt7996_sta_link *msta_link;
+	unsigned int link_id;
+
+	if (msta->deflink_id == IEEE80211_LINK_UNSPECIFIED)
+		return IEEE80211_LINK_UNSPECIFIED;
+
+	msta_link = mt7996_sta_link_protected(dev, msta, msta->seclink_id);
+	if (msta->seclink_id != msta->deflink_id && msta_link &&
+	    msta_link->wcid.link_valid)
+		return msta->seclink_id;
+
+	for (link_id = 0; link_id < ARRAY_SIZE(msta->link); link_id++) {
+		if (link_id == msta->deflink_id)
+			continue;
+
+		msta_link = mt7996_sta_link_protected(dev, msta, link_id);
+		if (msta_link && msta_link->wcid.link_valid)
+			return link_id;
+	}
+
+	return msta->deflink_id;
+}
+
 static int
 mt7996_mac_sta_init_link(struct mt7996_dev *dev,
 			 struct ieee80211_bss_conf *link_conf,
@@ -1162,7 +1188,6 @@ mt7996_mac_sta_init_link(struct mt7996_dev *dev,
 	if (msta->deflink_id == IEEE80211_LINK_UNSPECIFIED) {
 		msta_link = &msta->deflink;
 		msta->deflink_id = link_id;
-		msta->seclink_id = msta->deflink_id;
 		mt7996_sta_init_txq_wcid(sta, idx);
 	} else {
 		msta_link = kzalloc_obj(*msta_link);
@@ -1170,11 +1195,6 @@ mt7996_mac_sta_init_link(struct mt7996_dev *dev,
 			mt76_wcid_mask_clear(dev->mt76.wcid_mask, idx);
 			return -ENOMEM;
 		}
-
-		if (msta->seclink_id == msta->deflink_id &&
-		    (sta->valid_links & ~BIT(msta->deflink_id)))
-			msta->seclink_id = __ffs(sta->valid_links &
-						 ~BIT(msta->deflink_id));
 	}
 
 	INIT_LIST_HEAD(&msta_link->rc_list);
@@ -1193,6 +1213,7 @@ mt7996_mac_sta_init_link(struct mt7996_dev *dev,
 	ewma_signal_init(&msta_link->wcid.rssi);
 
 	rcu_assign_pointer(msta->link[link_id], msta_link);
+	msta->seclink_id = mt7996_sta_seclink_get(dev, msta);
 
 	mt7996_mac_wtbl_update(dev, idx, MT_WTBL_UPDATE_ADM_COUNT_CLEAR);
 	mt7996_mcu_add_sta(dev, link_conf, link_sta, link, msta_link,
@@ -1230,10 +1251,7 @@ void mt7996_mac_sta_remove_link(struct mt7996_dev *dev,
 
 		if (msta->deflink_id == link_id) {
 			msta->deflink_id = IEEE80211_LINK_UNSPECIFIED;
-			if (msta->seclink_id == link_id) {
-				/* no secondary link available */
-				msta->seclink_id = msta->deflink_id;
-			} else {
+			if (msta->seclink_id != link_id) {
 				struct mt7996_sta_link *msta_seclink;
 
 				/* switch to the secondary link */
@@ -1246,10 +1264,9 @@ void mt7996_mac_sta_remove_link(struct mt7996_dev *dev,
 						msta_seclink->wcid.idx);
 				}
 			}
-		} else if (msta->seclink_id == link_id) {
-			msta->seclink_id = msta->deflink_id;
 		}
 		msta_link->wcid.link_valid = false;
+		msta->seclink_id = mt7996_sta_seclink_get(dev, msta);
 	}
 
 	if (flush) {
@@ -1326,6 +1343,7 @@ mt7996_mac_sta_add_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 		msta_link = mt76_dereference(msta->link[link_id], &dev->mt76);
 		if (msta_link) {
 			msta_link->wcid.link_valid = true;
+			msta->seclink_id = mt7996_sta_seclink_get(dev, msta);
 			continue;
 		}
 
-- 
2.53.0



