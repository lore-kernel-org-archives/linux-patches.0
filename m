Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A1A331220;
	Wed, 20 May 2026 17:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297554; cv=none; b=HnqKW0WadH6Fa+0v85FZvbGlrALRP2iC2xZV88cOZpG+aky4YSW7NhXFpGi1HyMgAt430yQAwFxlX5jTTTiqaztBBal/8l+DPWTOF/bhmm481Ly3C5qqg9RhyN6rzCQgUqNMfcv1tSaEjrPxoIBl1qYnjZWnQgQVS6EjmB72W1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297554; c=relaxed/simple;
	bh=m2VchlFIxAuIecgFycbpgVC8ZBg+Kmq+criZxeHj3tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s40+qrI9WT2RG3jvXzlcIuViN9wXyZuP43cdsp1nel6LEFDER+Db/b1wfBjk2jxwkMOP1umv+3EJOcosF3SMgJwSN0DXE9REdmwtDH9OVb6q6WJEr5lh6W/vXEOzVoZpK/3T2NbOosU7FQiEn53+zGXWHF7go3Rx+rf3QDbAiGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pUzFlP3p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pUzFlP3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBBE1F000E9;
	Wed, 20 May 2026 17:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297553;
	bh=oPGhklvCAsZyVE10rSc1btm1gYf3MnaazLQnWHvPOYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pUzFlP3pGlY96aNAvUtdUa6jIlqpq6XJ0e+1HWDKCoB0WGIGQsfiLzPVJhJTmrLG4
	 1AdgbG1kBRFlaruhTFqjui2nx75rhLLaHDi5rrRHWwwUHEZec2JD8Y8h/BMkfycsmT
	 TlKmaGobdPzYPOWAH8+3ScvU6cM4Xg6H8n3Y+s2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shayne Chen <shayne.chen@mediatek.com>,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 074/957] wifi: mt76: mt7996: fix the behavior of radar detection
Date: Wed, 20 May 2026 18:09:17 +0200
Message-ID: <20260520162136.169110616@linuxfoundation.org>
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

From: StanleyYP Wang <StanleyYP.Wang@mediatek.com>

[ Upstream commit 45a09251d610f3b8a1fb02039146e42f1f4efe90 ]

RDD_DET_MODE is a firmware command intended for testing and does not
pause TX after radar detection, so remove it from the normal flow;
instead, use the MAC_ENABLE_CTRL firmware command to resume TX after
the radar-triggered channel switch completes.

Fixes: 1529e335f93d ("wifi: mt76: mt7996: rework radar HWRDD idx")
Co-developed-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Link: https://patch.msgid.link/20251215063728.3013365-2-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/mac.c   |  8 +--
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 20 ++++++++
 .../net/wireless/mediatek/mt76/mt7996/mcu.c   | 49 ++++++++++++++++---
 .../net/wireless/mediatek/mt76/mt7996/mcu.h   |  1 +
 .../wireless/mediatek/mt76/mt7996/mt7996.h    |  2 +
 5 files changed, 68 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 0958961d2758e..24b404f35409b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2944,7 +2944,7 @@ static void mt7996_dfs_stop_radar_detector(struct mt7996_phy *phy)
 
 static int mt7996_dfs_start_rdd(struct mt7996_dev *dev, int rdd_idx)
 {
-	int err, region;
+	int region;
 
 	switch (dev->mt76.region) {
 	case NL80211_DFS_ETSI:
@@ -2959,11 +2959,7 @@ static int mt7996_dfs_start_rdd(struct mt7996_dev *dev, int rdd_idx)
 		break;
 	}
 
-	err = mt7996_mcu_rdd_cmd(dev, RDD_START, rdd_idx, region);
-	if (err < 0)
-		return err;
-
-	return mt7996_mcu_rdd_cmd(dev, RDD_DET_MODE, rdd_idx, 1);
+	return mt7996_mcu_rdd_cmd(dev, RDD_START, rdd_idx, region);
 }
 
 static int mt7996_dfs_start_radar_detector(struct mt7996_phy *phy)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 2ad52ae2c5f55..2c8a088a170c6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -79,6 +79,7 @@ static void mt7996_stop_phy(struct mt7996_phy *phy)
 
 	mutex_lock(&dev->mt76.mutex);
 
+	mt7996_mcu_rdd_resume_tx(phy);
 	mt7996_mcu_set_radio_en(phy, false);
 
 	clear_bit(MT76_STATE_RUNNING, &phy->mt76->state);
@@ -933,6 +934,24 @@ mt7996_channel_switch_beacon(struct ieee80211_hw *hw,
 	mutex_unlock(&dev->mt76.mutex);
 }
 
+static int
+mt7996_post_channel_switch(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			   struct ieee80211_bss_conf *link_conf)
+{
+	struct cfg80211_chan_def *chandef = &link_conf->chanreq.oper;
+	struct mt7996_dev *dev = mt7996_hw_dev(hw);
+	struct mt7996_phy *phy = mt7996_band_phy(dev, chandef->chan->band);
+	int ret;
+
+	mutex_lock(&dev->mt76.mutex);
+
+	ret = mt7996_mcu_rdd_resume_tx(phy);
+
+	mutex_unlock(&dev->mt76.mutex);
+
+	return ret;
+}
+
 static int
 mt7996_mac_sta_init_link(struct mt7996_dev *dev,
 			 struct ieee80211_bss_conf *link_conf,
@@ -2295,6 +2314,7 @@ const struct ieee80211_ops mt7996_ops = {
 	.release_buffered_frames = mt76_release_buffered_frames,
 	.get_txpower = mt7996_get_txpower,
 	.channel_switch_beacon = mt7996_channel_switch_beacon,
+	.post_channel_switch = mt7996_post_channel_switch,
 	.get_stats = mt7996_get_stats,
 	.get_et_sset_count = mt7996_get_et_sset_count,
 	.get_et_stats = mt7996_get_et_stats,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 5bde9959bbb99..321098496a39e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -413,24 +413,32 @@ mt7996_mcu_rx_radar_detected(struct mt7996_dev *dev, struct sk_buff *skb)
 		break;
 	case MT_RDD_IDX_BACKGROUND:
 		if (!dev->rdd2_phy)
-			return;
+			goto err;
 		mphy = dev->rdd2_phy->mt76;
 		break;
 	default:
-		dev_err(dev->mt76.dev, "Unknown RDD idx %d\n", r->rdd_idx);
-		return;
+		goto err;
 	}
 
 	if (!mphy)
-		return;
+		goto err;
 
-	if (r->rdd_idx == MT_RDD_IDX_BACKGROUND)
+	if (r->rdd_idx == MT_RDD_IDX_BACKGROUND) {
 		cfg80211_background_radar_event(mphy->hw->wiphy,
 						&dev->rdd2_chandef,
 						GFP_ATOMIC);
-	else
+	} else {
+		struct mt7996_phy *phy = mphy->priv;
+
+		phy->rdd_tx_paused = true;
 		ieee80211_radar_detected(mphy->hw, NULL);
+	}
 	dev->hw_pattern++;
+
+	return;
+
+err:
+	dev_err(dev->mt76.dev, "Invalid RDD idx %d\n", r->rdd_idx);
 }
 
 static void
@@ -4554,6 +4562,35 @@ int mt7996_mcu_set_radio_en(struct mt7996_phy *phy, bool enable)
 				 &req, sizeof(req), true);
 }
 
+int mt7996_mcu_rdd_resume_tx(struct mt7996_phy *phy)
+{
+	struct {
+		u8 band_idx;
+		u8 _rsv[3];
+
+		__le16 tag;
+		__le16 len;
+		u8 mac_enable;
+		u8 _rsv2[3];
+	} __packed req = {
+		.band_idx = phy->mt76->band_idx,
+		.tag = cpu_to_le16(UNI_BAND_CONFIG_MAC_ENABLE_CTRL),
+		.len = cpu_to_le16(sizeof(req) - 4),
+		.mac_enable = 2,
+	};
+	int ret;
+
+	if (!phy->rdd_tx_paused)
+		return 0;
+
+	ret = mt76_mcu_send_msg(&phy->dev->mt76, MCU_WM_UNI_CMD(BAND_CONFIG),
+				&req, sizeof(req), true);
+	if (!ret)
+		phy->rdd_tx_paused = false;
+
+	return ret;
+}
+
 int mt7996_mcu_rdd_cmd(struct mt7996_dev *dev, int cmd, u8 rdd_idx, u8 val)
 {
 	struct {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
index c841da1c60e5d..abfd7e5a775b3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
@@ -837,6 +837,7 @@ enum {
 enum {
 	UNI_BAND_CONFIG_RADIO_ENABLE,
 	UNI_BAND_CONFIG_RTS_THRESHOLD = 0x08,
+	UNI_BAND_CONFIG_MAC_ENABLE_CTRL = 0x0c,
 };
 
 enum {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index b942928c79e28..6190fbcd4df7e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -376,6 +376,7 @@ struct mt7996_phy {
 
 	bool has_aux_rx;
 	bool counter_reset;
+	bool rdd_tx_paused;
 };
 
 struct mt7996_dev {
@@ -725,6 +726,7 @@ int mt7996_mcu_get_temperature(struct mt7996_phy *phy);
 int mt7996_mcu_set_thermal_throttling(struct mt7996_phy *phy, u8 state);
 int mt7996_mcu_set_thermal_protect(struct mt7996_phy *phy, bool enable);
 int mt7996_mcu_set_txpower_sku(struct mt7996_phy *phy);
+int mt7996_mcu_rdd_resume_tx(struct mt7996_phy *phy);
 int mt7996_mcu_rdd_cmd(struct mt7996_dev *dev, int cmd, u8 rdd_idx, u8 val);
 int mt7996_mcu_rdd_background_enable(struct mt7996_phy *phy,
 				     struct cfg80211_chan_def *chandef);
-- 
2.53.0



