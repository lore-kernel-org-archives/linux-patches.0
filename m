Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3B83ECBF3;
	Wed, 20 May 2026 16:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294607; cv=none; b=oyvTVPPt0pAAJwqgnFYXpjpdT1ZYB5CwDPArJGrwnO2iVeDGegWJNGmukuQ52EA5P+DPYehmjQ/pnaNNZc6P/diJnayjZKTIFUFlxiFcVyjuLl5ByQEU37QSJN9cNJYSHDYPt6W2DuoqaNtSOFXcvpUFGY1KkF6JGZzQy/m+hB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294607; c=relaxed/simple;
	bh=tLiqxDgaUBocsrs0ihMFCcVFfKsaVN/ylZ64k93U2Pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AhFtNx4D10HQiLb4obZhCj4CCXWBmZsTLu9wlyppblNSBYBpVjooRwvow0KGVjXPFetu7SFITnLIhm845V2FbWjA8wHVd+LNCe4ox/G2Hx7+3R9UP7VuZVeiwRBNPGTUzMLQ+zAfXUd+iR2TiHAkRsT5SdPdfSAglrMM97gwT7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=crziZLx0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="crziZLx0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB8C1F000E9;
	Wed, 20 May 2026 16:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294605;
	bh=Zh0AcL8bxIDBJUOB9KzI87IFiwBY+49Qae/H19284Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=crziZLx0U8D9KECudm9bsSXhrn8KphcRzVgo+o5UYj71OrAiJ+SL6p9hocxWjN6XU
	 RbpUVUxlldfWhx3opOvEVLVlqYx8/BeGF0GNUNDH14Fm+E9m+1NocBg31xqdfwBWOs
	 cSIGpwmVtP+YVV9YzaLpFr+FjCc5cD9J216cTkXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0103/1146] wifi: mt76: mt7915: fix use_cts_prot support
Date: Wed, 20 May 2026 18:05:53 +0200
Message-ID: <20260520162150.674589621@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit 8b2c26562b95c6397e132d21f2bd3d73aaee0c0a ]

With this fix, when driver needs to adjust its behavior for compatibility,
especially concerning older 11g/n devices, by enabling or disabling CTS
protection frames, often for hidden SSIDs or to manage legacy clients.

Fixes: 150b91419d3d ("wifi: mt76: mt7915: enable use_cts_prot support")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Link: https://patch.msgid.link/eb8db4d0bf1c89b7486e89facb788ae3e510dd8b.1768879119.git.ryder.lee@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7915/mac.c   | 13 ----
 .../net/wireless/mediatek/mt76/mt7915/main.c  |  7 ++-
 .../net/wireless/mediatek/mt76/mt7915/mcu.c   | 62 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7915/mcu.h   | 11 ++++
 .../wireless/mediatek/mt76/mt7915/mt7915.h    |  4 ++
 5 files changed, 81 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index cefe56c05731d..cec2c4208255f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -232,19 +232,6 @@ static void mt7915_mac_sta_poll(struct mt7915_dev *dev)
 	rcu_read_unlock();
 }
 
-void mt7915_mac_enable_rtscts(struct mt7915_dev *dev,
-			      struct ieee80211_vif *vif, bool enable)
-{
-	struct mt7915_vif *mvif = (struct mt7915_vif *)vif->drv_priv;
-	u32 addr;
-
-	addr = mt7915_mac_wtbl_lmac_addr(dev, mvif->sta.wcid.idx, 5);
-	if (enable)
-		mt76_set(dev, addr, BIT(5));
-	else
-		mt76_clear(dev, addr, BIT(5));
-}
-
 static void
 mt7915_wed_check_ppe(struct mt7915_dev *dev, struct mt76_queue *q,
 		     struct mt7915_sta *msta, struct sk_buff *skb,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index 90d5e79fbf74d..0892291616ead 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -68,7 +68,7 @@ int mt7915_run(struct ieee80211_hw *hw)
 	if (ret)
 		goto out;
 
-	ret = mt76_connac_mcu_set_rts_thresh(&dev->mt76, 0x92b,
+	ret = mt76_connac_mcu_set_rts_thresh(&dev->mt76, MT7915_RTS_LEN_THRES,
 					     phy->mt76->band_idx);
 	if (ret)
 		goto out;
@@ -633,8 +633,9 @@ static void mt7915_bss_info_changed(struct ieee80211_hw *hw,
 	if (set_sta == 1)
 		mt7915_mcu_add_sta(dev, vif, NULL, CONN_STATE_PORT_SECURE, false);
 
-	if (changed & BSS_CHANGED_ERP_CTS_PROT)
-		mt7915_mac_enable_rtscts(dev, vif, info->use_cts_prot);
+	if (changed & BSS_CHANGED_HT || changed & BSS_CHANGED_ERP_CTS_PROT)
+		mt7915_mcu_set_protection(phy, vif, info->ht_operation_mode,
+					  info->use_cts_prot);
 
 	if (changed & BSS_CHANGED_ERP_SLOT) {
 		int slottime = 9;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 00bff4d3aab80..95b8f34a7b1df 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -3954,6 +3954,68 @@ int mt7915_mcu_get_rx_rate(struct mt7915_phy *phy, struct ieee80211_vif *vif,
 	return ret;
 }
 
+int mt7915_mcu_set_protection(struct mt7915_phy *phy, struct ieee80211_vif *vif,
+			      u8 ht_mode, bool use_cts_prot)
+{
+	struct mt7915_dev *dev = phy->dev;
+	int len = sizeof(struct sta_req_hdr) + sizeof(struct bss_info_prot);
+	struct mt7915_vif *mvif = (struct mt7915_vif *)vif->drv_priv;
+	struct bss_info_prot *prot;
+	struct sk_buff *skb;
+	struct tlv *tlv;
+	enum {
+		PROT_NONMEMBER	 = BIT(1),
+		PROT_20MHZ	 = BIT(2),
+		PROT_NONHT_MIXED = BIT(3),
+		PROT_LEGACY_ERP	 = BIT(5),
+		PROT_NONGF_STA	 = BIT(7),
+	};
+	u32 rts_threshold;
+
+	skb = __mt76_connac_mcu_alloc_sta_req(&dev->mt76, &mvif->mt76,
+					      NULL, len);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	tlv = mt76_connac_mcu_add_tlv(skb, BSS_INFO_PROTECT_INFO,
+				      sizeof(*prot));
+	prot = (struct bss_info_prot *)tlv;
+
+	switch (ht_mode & IEEE80211_HT_OP_MODE_PROTECTION) {
+	case IEEE80211_HT_OP_MODE_PROTECTION_NONMEMBER:
+		prot->prot_mode = cpu_to_le32(PROT_NONMEMBER);
+		break;
+	case IEEE80211_HT_OP_MODE_PROTECTION_20MHZ:
+		prot->prot_mode = cpu_to_le32(PROT_20MHZ);
+		break;
+	case IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED:
+		prot->prot_mode = cpu_to_le32(PROT_NONHT_MIXED);
+		break;
+	}
+
+	if (ht_mode & IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT)
+		prot->prot_mode |= cpu_to_le32(PROT_NONGF_STA);
+
+	if (use_cts_prot)
+		prot->prot_mode |= cpu_to_le32(PROT_LEGACY_ERP);
+
+	/* reuse current RTS setting */
+	rts_threshold = phy->mt76->hw->wiphy->rts_threshold;
+	if (rts_threshold == (u32)-1)
+		prot->rts_len_thres = cpu_to_le32(MT7915_RTS_LEN_THRES);
+	else
+		prot->rts_len_thres = cpu_to_le32(rts_threshold);
+
+	prot->rts_pkt_thres = 0x2;
+
+	prot->he_rts_thres = cpu_to_le16(vif->bss_conf.frame_time_rts_th);
+	if (!prot->he_rts_thres)
+		prot->he_rts_thres = cpu_to_le16(DEFAULT_HE_DURATION_RTS_THRES);
+
+	return mt76_mcu_skb_send_msg(&dev->mt76, skb,
+				     MCU_EXT_CMD(BSS_INFO_UPDATE), true);
+}
+
 int mt7915_mcu_update_bss_color(struct mt7915_dev *dev, struct ieee80211_vif *vif,
 				struct cfg80211_he_bss_color *he_bss_color)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h
index 3af11a075a2f4..22f73a5ed4259 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h
@@ -399,6 +399,17 @@ struct bss_info_inband_discovery {
 	__le16 prob_rsp_len;
 } __packed __aligned(4);
 
+struct bss_info_prot {
+	__le16 tag;
+	__le16 len;
+	__le32 prot_type;
+	__le32 prot_mode;
+	__le32 rts_len_thres;
+	__le16 he_rts_thres;
+	u8 rts_pkt_thres;
+	u8 rsv[5];
+} __packed;
+
 enum {
 	BSS_INFO_BCN_CSA,
 	BSS_INFO_BCN_BCC,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
index b5c06201b7078..bf1d915a3ca23 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
@@ -84,6 +84,8 @@
 #define MT7915_CRIT_TEMP		110
 #define MT7915_MAX_TEMP			120
 
+#define MT7915_RTS_LEN_THRES		0x92b
+
 struct mt7915_vif;
 struct mt7915_sta;
 struct mt7915_dfs_pulse;
@@ -473,6 +475,8 @@ int mt7915_mcu_add_inband_discov(struct mt7915_dev *dev, struct ieee80211_vif *v
 				 u32 changed);
 int mt7915_mcu_add_beacon(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			  int enable, u32 changed);
+int mt7915_mcu_set_protection(struct mt7915_phy *phy, struct ieee80211_vif *vif,
+			      u8 ht_mode, bool use_cts_prot);
 int mt7915_mcu_add_obss_spr(struct mt7915_phy *phy, struct ieee80211_vif *vif,
 			    struct ieee80211_he_obss_pd *he_obss_pd);
 int mt7915_mcu_add_rate_ctrl(struct mt7915_dev *dev, struct ieee80211_vif *vif,
-- 
2.53.0



