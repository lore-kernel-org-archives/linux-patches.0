Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8A9366075;
	Wed, 20 May 2026 17:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297711; cv=none; b=uWi2N5W33HXytdrs4IfDY93s32Ji/jdwUFgiR8wmcdqqxzPbCbcMWwauD2Y1Hk27x6JtV+mG/gh2TS59mPpHEtlBjfcWQ/eTtWz+mZ5fVrCbpx5UFj4a53TfsoGODI4ZiiEL9dCh6/VdoMBii3WF45YevXO7ukxdocdf/VCX2oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297711; c=relaxed/simple;
	bh=xyY1lMVIRYgzGcolczlV5V7xNvMyA6AhcStYNNQhCqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3vnPaQzqQH5x5+3/yL1KenB+BQzcklgZ+D8ghCyVQIe+40ieIy2Bgm6ppSHwQ0dbf6T8wxhvpUIfFTCEP8z3qta2q+fY1jTE8kOJ2tePhA40SHaJEgO131bERJJFI+GBpjPVADfZry4h5lYiazKBNN+8lcxv6bwFxzCrBqXsaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ntqVr0iR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ntqVr0iR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB081F000E9;
	Wed, 20 May 2026 17:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297709;
	bh=z0IFn4LH28Qz5RjxJuSyd0LIUM71ZwIp5LtJ65eCJgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ntqVr0iRq3ejHNbcVnmOiGfwPtB8mWTbxEpqVCp+OHs5TATnbD9+MGZqVh6sMRs5j
	 1FeUHJ1daUI6SQZqhMfRoLFOmsHLEesCZEjiet+vVhj8Ypak4KxniM5ACwIwstZPAX
	 LiKnKysK+cauWie0X7MRIi3Aep8D/VNpsNL5Ovg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 082/957] wifi: mt76: mt7615: fix use_cts_prot support
Date: Wed, 20 May 2026 18:09:25 +0200
Message-ID: <20260520162136.338342842@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit 1974a67d9b65c29a0a9426e32e8cd8c056de48b7 ]

Driver should not directly write WTBL to prevent overwritten issues.

With this fix, when driver needs to adjust its behavior for compatibility,
especially concerning older 11g/n devices, by enabling or disabling CTS
protection frames, often for hidden SSIDs or to manage legacy clients.

Fixes: e34235ccc5e3 ("wifi: mt76: mt7615: enable use_cts_prot support")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Link: https://patch.msgid.link/edb87088b0111b32fafc6c4179f54a5286dd37d8.1768879119.git.ryder.lee@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7615/mac.c   | 15 ------
 .../net/wireless/mediatek/mt76/mt7615/main.c  |  7 +--
 .../net/wireless/mediatek/mt76/mt7615/mcu.c   | 47 +++++++++++++++++++
 .../wireless/mediatek/mt76/mt7615/mt7615.h    |  5 +-
 .../net/wireless/mediatek/mt76/mt7615/regs.h  |  2 -
 5 files changed, 53 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index f8d2cc94b742c..13c9dbeaee84e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -1167,21 +1167,6 @@ void mt7615_mac_set_rates(struct mt7615_phy *phy, struct mt7615_sta *sta,
 }
 EXPORT_SYMBOL_GPL(mt7615_mac_set_rates);
 
-void mt7615_mac_enable_rtscts(struct mt7615_dev *dev,
-			      struct ieee80211_vif *vif, bool enable)
-{
-	struct mt7615_vif *mvif = (struct mt7615_vif *)vif->drv_priv;
-	u32 addr;
-
-	addr = mt7615_mac_wtbl_addr(dev, mvif->sta.wcid.idx) + 3 * 4;
-
-	if (enable)
-		mt76_set(dev, addr, MT_WTBL_W3_RTS);
-	else
-		mt76_clear(dev, addr, MT_WTBL_W3_RTS);
-}
-EXPORT_SYMBOL_GPL(mt7615_mac_enable_rtscts);
-
 static int
 mt7615_mac_wtbl_update_key(struct mt7615_dev *dev, struct mt76_wcid *wcid,
 			   struct ieee80211_key_conf *key,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
index 15fe155ac3f3b..87a2e5163699c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -583,9 +583,6 @@ static void mt7615_bss_info_changed(struct ieee80211_hw *hw,
 		}
 	}
 
-	if (changed & BSS_CHANGED_ERP_CTS_PROT)
-		mt7615_mac_enable_rtscts(dev, vif, info->use_cts_prot);
-
 	if (changed & BSS_CHANGED_BEACON_ENABLED && info->enable_beacon) {
 		mt7615_mcu_add_bss_info(phy, vif, NULL, true);
 		mt7615_mcu_sta_add(phy, vif, NULL, true);
@@ -598,6 +595,10 @@ static void mt7615_bss_info_changed(struct ieee80211_hw *hw,
 		       BSS_CHANGED_BEACON_ENABLED))
 		mt7615_mcu_add_beacon(dev, hw, vif, info->enable_beacon);
 
+	if (changed & BSS_CHANGED_HT || changed & BSS_CHANGED_ERP_CTS_PROT)
+		mt7615_mcu_set_protection(phy, vif, info->ht_operation_mode,
+					  info->use_cts_prot);
+
 	if (changed & BSS_CHANGED_PS)
 		mt76_connac_mcu_set_vif_ps(&dev->mt76, vif);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 08ee2e861c4e2..91c9d787d553c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -2564,3 +2564,50 @@ int mt7615_mcu_set_roc(struct mt7615_phy *phy, struct ieee80211_vif *vif,
 	return mt76_mcu_send_msg(&dev->mt76, MCU_CE_CMD(SET_ROC),
 				 &req, sizeof(req), false);
 }
+
+int mt7615_mcu_set_protection(struct mt7615_phy *phy, struct ieee80211_vif *vif,
+			      u8 ht_mode, bool use_cts_prot)
+{
+	struct mt7615_dev *dev = phy->dev;
+	struct {
+		u8 prot_idx;
+		u8 band;
+		u8 rsv[2];
+
+		bool long_nav;
+		bool prot_mm;
+		bool prot_gf;
+		bool prot_bw40;
+		bool prot_rifs;
+		bool prot_bw80;
+		bool prot_bw160;
+		u8 prot_erp_mask;
+	} __packed req = {
+		.prot_idx = 0x2,
+		.band = phy != &dev->phy,
+	};
+
+	switch (ht_mode & IEEE80211_HT_OP_MODE_PROTECTION) {
+	case IEEE80211_HT_OP_MODE_PROTECTION_NONMEMBER:
+	case IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED:
+		req.prot_mm = true;
+		req.prot_gf = true;
+		fallthrough;
+	case IEEE80211_HT_OP_MODE_PROTECTION_20MHZ:
+		req.prot_bw40 = true;
+		break;
+	}
+
+	if (ht_mode & IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT)
+		req.prot_gf = true;
+
+	if (use_cts_prot) {
+		struct mt7615_vif *mvif = (struct mt7615_vif *)vif->drv_priv;
+		u8 i = mvif->mt76.omac_idx > HW_BSSID_MAX ? HW_BSSID_0 : mvif->mt76.omac_idx;
+
+		req.prot_erp_mask = BIT(i);
+	}
+
+	return mt76_mcu_send_msg(&dev->mt76, MCU_EXT_CMD(PROTECT_CTRL), &req,
+				 sizeof(req), true);
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h b/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
index 9bdd29e8d25e9..c655f64772de2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
@@ -466,8 +466,6 @@ void mt7615_mac_reset_counters(struct mt7615_phy *phy);
 void mt7615_mac_cca_stats_reset(struct mt7615_phy *phy);
 void mt7615_mac_set_scs(struct mt7615_phy *phy, bool enable);
 void mt7615_mac_enable_nf(struct mt7615_dev *dev, bool ext_phy);
-void mt7615_mac_enable_rtscts(struct mt7615_dev *dev,
-			      struct ieee80211_vif *vif, bool enable);
 void mt7615_mac_sta_poll(struct mt7615_dev *dev);
 int mt7615_mac_write_txwi(struct mt7615_dev *dev, __le32 *txwi,
 			  struct sk_buff *skb, struct mt76_wcid *wcid,
@@ -522,7 +520,8 @@ int mt7615_mcu_set_sku_en(struct mt7615_phy *phy, bool enable);
 int mt7615_mcu_apply_rx_dcoc(struct mt7615_phy *phy);
 int mt7615_mcu_apply_tx_dpd(struct mt7615_phy *phy);
 int mt7615_dfs_init_radar_detector(struct mt7615_phy *phy);
-
+int mt7615_mcu_set_protection(struct mt7615_phy *phy, struct ieee80211_vif *vif,
+			      u8 ht_mode, bool use_cts_prot);
 int mt7615_mcu_set_roc(struct mt7615_phy *phy, struct ieee80211_vif *vif,
 		       struct ieee80211_channel *chan, int duration);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/regs.h b/drivers/net/wireless/mediatek/mt76/mt7615/regs.h
index 806b3887c541c..9e6d55c91b269 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/regs.h
@@ -455,8 +455,6 @@ enum mt7615_reg_base {
 #define MT_WTBL_RIUCR3_RATE6		GENMASK(19, 8)
 #define MT_WTBL_RIUCR3_RATE7		GENMASK(31, 20)
 
-#define MT_WTBL_W3_RTS			BIT(22)
-
 #define MT_WTBL_W5_CHANGE_BW_RATE	GENMASK(7, 5)
 #define MT_WTBL_W5_SHORT_GI_20		BIT(8)
 #define MT_WTBL_W5_SHORT_GI_40		BIT(9)
-- 
2.53.0



