Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11364BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:19:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522C1C433D2;
	Tue,  7 Mar 2023 17:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209548;
	bh=LGEzAMYWbYY42wr4lpgE8e5TWArRvlRd9jb6HRScyms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PZEfzpzeMQYLAt8DXFrYCCS0s+cQDLuS62IdHYp80P2ja0vfEDekQz9F2cVxFjarq
	 aChaXau36N54AP53g7jaYS5GmxV3QkeF0K701vuqYkbr54DAFiStYvEyhwvdgb617z
	 0vEMRqZ7VJOghH94UGBoXEe66G9gSdn0zJ9Il7hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0253/1001] wifi: mt76: mt7996: rely on mt76_connac2_mac_tx_rate_val
Date: Tue,  7 Mar 2023 17:50:25 +0100
Message-Id: <20230307170032.749480020@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 0b8e2d69467f78a7c9d87b452220e87012435e33 ]

In order to fix a possible NULL pointer dereference in
mt7996_mac_write_txwi() of vif pointer, export
mt76_connac2_mac_tx_rate_val utility routine and reuse it
in mt7996 driver.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt76_connac.h  |  3 ++
 .../wireless/mediatek/mt76/mt76_connac_mac.c  |  7 +--
 .../net/wireless/mediatek/mt76/mt7996/mac.c   | 48 +------------------
 3 files changed, 9 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac.h b/drivers/net/wireless/mediatek/mt76/mt76_connac.h
index 8ba883b03e500..2ee9a3c8e25c4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac.h
@@ -370,6 +370,9 @@ void mt76_connac2_mac_write_txwi(struct mt76_dev *dev, __le32 *txwi,
 				 struct sk_buff *skb, struct mt76_wcid *wcid,
 				 struct ieee80211_key_conf *key, int pid,
 				 enum mt76_txq_id qid, u32 changed);
+u16 mt76_connac2_mac_tx_rate_val(struct mt76_phy *mphy,
+				 struct ieee80211_vif *vif,
+				 bool beacon, bool mcast);
 bool mt76_connac2_mac_fill_txs(struct mt76_dev *dev, struct mt76_wcid *wcid,
 			       __le32 *txs_data);
 bool mt76_connac2_mac_add_txs_skb(struct mt76_dev *dev, struct mt76_wcid *wcid,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
index c8d0c84e688b8..aed4ee95fb2ec 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
@@ -267,9 +267,9 @@ int mt76_connac_init_tx_queues(struct mt76_phy *phy, int idx, int n_desc,
 }
 EXPORT_SYMBOL_GPL(mt76_connac_init_tx_queues);
 
-static u16
-mt76_connac2_mac_tx_rate_val(struct mt76_phy *mphy, struct ieee80211_vif *vif,
-			     bool beacon, bool mcast)
+u16 mt76_connac2_mac_tx_rate_val(struct mt76_phy *mphy,
+				 struct ieee80211_vif *vif,
+				 bool beacon, bool mcast)
 {
 	u8 mode = 0, band = mphy->chandef.chan->band;
 	int rateidx = 0, mcast_rate;
@@ -319,6 +319,7 @@ mt76_connac2_mac_tx_rate_val(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 	return FIELD_PREP(MT_TX_RATE_IDX, rateidx) |
 	       FIELD_PREP(MT_TX_RATE_MODE, mode);
 }
+EXPORT_SYMBOL_GPL(mt76_connac2_mac_tx_rate_val);
 
 static void
 mt76_connac2_mac_write_txwi_8023(__le32 *txwi, struct sk_buff *skb,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 96ced4c039ce1..0eb9e4d73f2c1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -959,51 +959,6 @@ mt7996_mac_write_txwi_80211(struct mt7996_dev *dev, __le32 *txwi,
 	}
 }
 
-static u16
-mt7996_mac_tx_rate_val(struct mt76_phy *mphy, struct ieee80211_vif *vif,
-		       bool beacon, bool mcast)
-{
-	u8 mode = 0, band = mphy->chandef.chan->band;
-	int rateidx = 0, mcast_rate;
-
-	if (beacon) {
-		struct cfg80211_bitrate_mask *mask;
-
-		mask = &vif->bss_conf.beacon_tx_rate;
-		if (hweight16(mask->control[band].he_mcs[0]) == 1) {
-			rateidx = ffs(mask->control[band].he_mcs[0]) - 1;
-			mode = MT_PHY_TYPE_HE_SU;
-			goto out;
-		} else if (hweight16(mask->control[band].vht_mcs[0]) == 1) {
-			rateidx = ffs(mask->control[band].vht_mcs[0]) - 1;
-			mode = MT_PHY_TYPE_VHT;
-			goto out;
-		} else if (hweight8(mask->control[band].ht_mcs[0]) == 1) {
-			rateidx = ffs(mask->control[band].ht_mcs[0]) - 1;
-			mode = MT_PHY_TYPE_HT;
-			goto out;
-		} else if (hweight32(mask->control[band].legacy) == 1) {
-			rateidx = ffs(mask->control[band].legacy) - 1;
-			goto legacy;
-		}
-	}
-
-	mcast_rate = vif->bss_conf.mcast_rate[band];
-	if (mcast && mcast_rate > 0)
-		rateidx = mcast_rate - 1;
-	else
-		rateidx = ffs(vif->bss_conf.basic_rates) - 1;
-
-legacy:
-	rateidx = mt76_calculate_default_rate(mphy, rateidx);
-	mode = rateidx >> 8;
-	rateidx &= GENMASK(7, 0);
-
-out:
-	return FIELD_PREP(MT_TX_RATE_IDX, rateidx) |
-	       FIELD_PREP(MT_TX_RATE_MODE, mode);
-}
-
 void mt7996_mac_write_txwi(struct mt7996_dev *dev, __le32 *txwi,
 			   struct sk_buff *skb, struct mt76_wcid *wcid, int pid,
 			   struct ieee80211_key_conf *key, u32 changed)
@@ -1091,7 +1046,8 @@ void mt7996_mac_write_txwi(struct mt7996_dev *dev, __le32 *txwi,
 		/* Fixed rata is available just for 802.11 txd */
 		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 		bool multicast = is_multicast_ether_addr(hdr->addr1);
-		u16 rate = mt7996_mac_tx_rate_val(mphy, vif, beacon, multicast);
+		u16 rate = mt76_connac2_mac_tx_rate_val(mphy, vif, beacon,
+							multicast);
 
 		/* fix to bw 20 */
 		val = MT_TXD6_FIXED_BW |
-- 
2.39.2



