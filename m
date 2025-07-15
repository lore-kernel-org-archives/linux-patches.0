Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60252E6D35;
	Tue, 15 Jul 2025 13:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587028; cv=none; b=QdHUiyUzSWQhcvxFbe7DgYJ7cHsb8TdRvl4amSPEcx0iVbB1LTPKL4auKPv++EoeSpad+NAOCvyElw+VTofUM9P/r0iWLkr0isdS1Z1GmS5tzbneIChXDQq5N6KNYqSr2n3FUDUrZa5bK676J/FoqACVBnNgGzGhA/4AY6fM4g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587028; c=relaxed/simple;
	bh=kRBbFmqkr9IBia0hhb1tknX32x+K0I+MOENhc8JiDzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=si/3/aq9yPwjsG5PkyG5atSi4iURGPGZBxH25zuNjdiW+0ViZRrVl8xMloXZVgVj8ucgPKhacrBkg7u1ToKwP36YCnt92bSTI3rVO+aAgf/jzX/CKIT0eMVu/S3axO2ZfBe1EI76TvxRHNetcSLA7lnBDralPLRAfLc8Sa6hdI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GIc2bcjx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GIc2bcjx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699AAC4CEE3;
	Tue, 15 Jul 2025 13:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587028;
	bh=kRBbFmqkr9IBia0hhb1tknX32x+K0I+MOENhc8JiDzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GIc2bcjxI2fioujitgkDukbWnypq1h1GA0SyxKl/tAi8FGMW95krNk75RpXqAiZoh
	 hVrdtcnWOrbg/A05a0Co9JEhkKIwtWKCXfWsMGAup2FgzBfpQMG6+J8f84CArkE13/
	 mr/5DYX6ZcgVGDBdoavkasIcp0mAKXlSdLQIrxgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 140/192] wifi: mt76: Move RCU section in mt7996_mcu_set_fixed_field()
Date: Tue, 15 Jul 2025 15:13:55 +0200
Message-ID: <20250715130820.521426782@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit c772cd726eea6fe8fb81d2aeeacb18cecff73a7b ]

Since mt76_mcu_skb_send_msg() routine can't be executed in atomic context,
move RCU section in mt7996_mcu_set_fixed_field() and execute
mt76_mcu_skb_send_msg() in non-atomic context. This is a preliminary
patch to fix a 'sleep while atomic' issue in mt7996_mac_sta_rc_work().

Fixes: 0762bdd30279 ("wifi: mt76: mt7996: rework mt7996_mac_sta_rc_work to support MLO")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250605-mt7996-sleep-while-atomic-v1-2-d46d15f9203c@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/mac.c   |  5 +-
 .../net/wireless/mediatek/mt76/mt7996/main.c  |  3 +-
 .../net/wireless/mediatek/mt76/mt7996/mcu.c   | 68 +++++++++++++------
 .../wireless/mediatek/mt76/mt7996/mt7996.h    | 10 ++-
 4 files changed, 57 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 2108361543a0c..5cf2d6669ee68 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2370,11 +2370,10 @@ void mt7996_mac_sta_rc_work(struct work_struct *work)
 			       IEEE80211_RC_BW_CHANGED))
 			mt7996_mcu_add_rate_ctrl(dev, vif, link_conf,
 						 link_sta, link, msta_link,
-						 true);
+						 link_id, true);
 
 		if (changed & IEEE80211_RC_SMPS_CHANGED)
-			mt7996_mcu_set_fixed_field(dev, link_sta, link,
-						   msta_link, NULL,
+			mt7996_mcu_set_fixed_field(dev, msta, NULL, link_id,
 						   RATE_PARAM_MMPS_UPDATE);
 
 		spin_lock_bh(&dev->mt76.sta_poll_lock);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index b11dd3dd5c46f..bb2eef6b934b5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1114,7 +1114,8 @@ mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 
 			err = mt7996_mcu_add_rate_ctrl(dev, vif, link_conf,
 						       link_sta, link,
-						       msta_link, false);
+						       msta_link, link_id,
+						       false);
 			if (err)
 				return err;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index ddd555942c738..d67ed58d7126d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -1883,22 +1883,35 @@ int mt7996_mcu_set_fixed_rate_ctrl(struct mt7996_dev *dev,
 				     MCU_WM_UNI_CMD(RA), true);
 }
 
-int mt7996_mcu_set_fixed_field(struct mt7996_dev *dev,
-			       struct ieee80211_link_sta *link_sta,
-			       struct mt7996_vif_link *link,
-			       struct mt7996_sta_link *msta_link,
-			       void *data, u32 field)
+int mt7996_mcu_set_fixed_field(struct mt7996_dev *dev, struct mt7996_sta *msta,
+			       void *data, u8 link_id, u32 field)
 {
-	struct sta_phy_uni *phy = data;
+	struct mt7996_vif *mvif = msta->vif;
+	struct mt7996_sta_link *msta_link;
 	struct sta_rec_ra_fixed_uni *ra;
+	struct sta_phy_uni *phy = data;
+	struct mt76_vif_link *mlink;
 	struct sk_buff *skb;
+	int err = -ENODEV;
 	struct tlv *tlv;
 
-	skb = __mt76_connac_mcu_alloc_sta_req(&dev->mt76, &link->mt76,
+	rcu_read_lock();
+
+	mlink = rcu_dereference(mvif->mt76.link[link_id]);
+	if (!mlink)
+		goto error_unlock;
+
+	msta_link = rcu_dereference(msta->link[link_id]);
+	if (!msta_link)
+		goto error_unlock;
+
+	skb = __mt76_connac_mcu_alloc_sta_req(&dev->mt76, mlink,
 					      &msta_link->wcid,
 					      MT7996_STA_UPDATE_MAX_SIZE);
-	if (IS_ERR(skb))
-		return PTR_ERR(skb);
+	if (IS_ERR(skb)) {
+		err = PTR_ERR(skb);
+		goto error_unlock;
+	}
 
 	tlv = mt76_connac_mcu_add_tlv(skb, STA_REC_RA_UPDATE, sizeof(*ra));
 	ra = (struct sta_rec_ra_fixed_uni *)tlv;
@@ -1913,27 +1926,45 @@ int mt7996_mcu_set_fixed_field(struct mt7996_dev *dev,
 		if (phy)
 			ra->phy = *phy;
 		break;
-	case RATE_PARAM_MMPS_UPDATE:
+	case RATE_PARAM_MMPS_UPDATE: {
+		struct ieee80211_sta *sta = wcid_to_sta(&msta_link->wcid);
+		struct ieee80211_link_sta *link_sta;
+
+		link_sta = rcu_dereference(sta->link[link_id]);
+		if (!link_sta) {
+			dev_kfree_skb(skb);
+			goto error_unlock;
+		}
+
 		ra->mmps_mode = mt7996_mcu_get_mmps_mode(link_sta->smps_mode);
 		break;
+	}
 	default:
 		break;
 	}
 	ra->field = cpu_to_le32(field);
 
+	rcu_read_unlock();
+
 	return mt76_mcu_skb_send_msg(&dev->mt76, skb,
 				     MCU_WMWA_UNI_CMD(STA_REC_UPDATE), true);
+error_unlock:
+	rcu_read_unlock();
+
+	return err;
 }
 
 static int
 mt7996_mcu_add_rate_ctrl_fixed(struct mt7996_dev *dev,
 			       struct ieee80211_link_sta *link_sta,
 			       struct mt7996_vif_link *link,
-			       struct mt7996_sta_link *msta_link)
+			       struct mt7996_sta_link *msta_link,
+			       u8 link_id)
 {
 	struct cfg80211_chan_def *chandef = &link->phy->mt76->chandef;
 	struct cfg80211_bitrate_mask *mask = &link->bitrate_mask;
 	enum nl80211_band band = chandef->chan->band;
+	struct mt7996_sta *msta = msta_link->sta;
 	struct sta_phy_uni phy = {};
 	int ret, nrates = 0;
 
@@ -1974,8 +2005,7 @@ mt7996_mcu_add_rate_ctrl_fixed(struct mt7996_dev *dev,
 
 	/* fixed single rate */
 	if (nrates == 1) {
-		ret = mt7996_mcu_set_fixed_field(dev, link_sta, link,
-						 msta_link, &phy,
+		ret = mt7996_mcu_set_fixed_field(dev, msta, &phy, link_id,
 						 RATE_PARAM_FIXED_MCS);
 		if (ret)
 			return ret;
@@ -1996,8 +2026,7 @@ mt7996_mcu_add_rate_ctrl_fixed(struct mt7996_dev *dev,
 		else
 			mt76_rmw_field(dev, addr, GENMASK(15, 12), phy.sgi);
 
-		ret = mt7996_mcu_set_fixed_field(dev, link_sta, link,
-						 msta_link, &phy,
+		ret = mt7996_mcu_set_fixed_field(dev, msta, &phy, link_id,
 						 RATE_PARAM_FIXED_GI);
 		if (ret)
 			return ret;
@@ -2005,8 +2034,7 @@ mt7996_mcu_add_rate_ctrl_fixed(struct mt7996_dev *dev,
 
 	/* fixed HE_LTF */
 	if (mask->control[band].he_ltf != GENMASK(7, 0)) {
-		ret = mt7996_mcu_set_fixed_field(dev, link_sta, link,
-						 msta_link, &phy,
+		ret = mt7996_mcu_set_fixed_field(dev, msta, &phy, link_id,
 						 RATE_PARAM_FIXED_HE_LTF);
 		if (ret)
 			return ret;
@@ -2128,7 +2156,8 @@ int mt7996_mcu_add_rate_ctrl(struct mt7996_dev *dev,
 			     struct ieee80211_bss_conf *link_conf,
 			     struct ieee80211_link_sta *link_sta,
 			     struct mt7996_vif_link *link,
-			     struct mt7996_sta_link *msta_link, bool changed)
+			     struct mt7996_sta_link *msta_link,
+			     u8 link_id, bool changed)
 {
 	struct sk_buff *skb;
 	int ret;
@@ -2156,7 +2185,8 @@ int mt7996_mcu_add_rate_ctrl(struct mt7996_dev *dev,
 	if (ret)
 		return ret;
 
-	return mt7996_mcu_add_rate_ctrl_fixed(dev, link_sta, link, msta_link);
+	return mt7996_mcu_add_rate_ctrl_fixed(dev, link_sta, link, msta_link,
+					      link_id);
 }
 
 static int
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index 77605403b3966..16a4a465b9b27 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -609,18 +609,16 @@ int mt7996_mcu_add_rate_ctrl(struct mt7996_dev *dev,
 			     struct ieee80211_bss_conf *link_conf,
 			     struct ieee80211_link_sta *link_sta,
 			     struct mt7996_vif_link *link,
-			     struct mt7996_sta_link *msta_link, bool changed);
+			     struct mt7996_sta_link *msta_link,
+			     u8 link_id, bool changed);
 int mt7996_set_channel(struct mt76_phy *mphy);
 int mt7996_mcu_set_chan_info(struct mt7996_phy *phy, u16 tag);
 int mt7996_mcu_set_tx(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 		      struct ieee80211_bss_conf *link_conf);
 int mt7996_mcu_set_fixed_rate_ctrl(struct mt7996_dev *dev,
 				   void *data, u16 version);
-int mt7996_mcu_set_fixed_field(struct mt7996_dev *dev,
-			       struct ieee80211_link_sta *link_sta,
-			       struct mt7996_vif_link *link,
-			       struct mt7996_sta_link *msta_link,
-			       void *data, u32 field);
+int mt7996_mcu_set_fixed_field(struct mt7996_dev *dev, struct mt7996_sta *msta,
+			       void *data, u8 link_id, u32 field);
 int mt7996_mcu_set_eeprom(struct mt7996_dev *dev);
 int mt7996_mcu_get_eeprom(struct mt7996_dev *dev, u32 offset, u8 *buf, u32 buf_len);
 int mt7996_mcu_get_eeprom_free_block(struct mt7996_dev *dev, u8 *block_num);
-- 
2.39.5



