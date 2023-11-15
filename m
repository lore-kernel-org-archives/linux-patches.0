Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388833EA89
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CHurR7yY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C74CC433C8;
	Wed, 15 Nov 2023 19:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077000;
	bh=cKrpt4ANUCgw0FgMqygiSfSu1F0AuDWxpi0mZgj3HIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CHurR7yYVWqXzuYPBHg4LQ3xQqPgCWgqe/J1x2pkfLIX40xLsiR5r/eJ+WmkdveJ+
	 Dp1mnl+0xnEEqFqv31Y7d9AIugBkwpb8aCpiDvZTGdvg9Q2ShyfZhTj/z/wPsZVoZ4
	 ej+zV4pP2zMcIQz41dReDBxDT7SmegGAM4BVD2nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	David Ruth <druth@chromium.org>,
	Deren Wu <deren.wu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 094/603] wifi: mt76: move struct ieee80211_chanctx_conf up to struct mt76_vif
Date: Wed, 15 Nov 2023 14:10:39 -0500
Message-ID: <20231115191619.666665636@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit f50206555992abb802cee4e3f951d1ea669cb8bc ]

Move struct ieee80211_chanctx_conf up to struct mt76_vif to allow the
connac2 library can access the struct ieee80211_chanctx_conf * member in
struct mt76_vif.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Reviewed-by: David Ruth <druth@chromium.org>
Tested-by: David Ruth <druth@chromium.org>
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: 32b1000db221 ("wifi: mt76: mt7921: fix the wrong rate pickup for the chanctx driver")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76.h        |  1 +
 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 12 ++++++------
 drivers/net/wireless/mediatek/mt76/mt792x.h      |  1 -
 drivers/net/wireless/mediatek/mt76/mt792x_core.c |  4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index e8757865a3d06..13ed07c5ccc60 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -709,6 +709,7 @@ struct mt76_vif {
 	u8 basic_rates_idx;
 	u8 mcast_rates_idx;
 	u8 beacon_rates_idx;
+	struct ieee80211_chanctx_conf *ctx;
 };
 
 struct mt76_phy {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 0844d28b3223d..d8851cb5f400b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -756,7 +756,7 @@ void mt7921_mac_sta_assoc(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 
 	if (vif->type == NL80211_IFTYPE_STATION && !sta->tdls)
 		mt76_connac_mcu_uni_add_bss(&dev->mphy, vif, &mvif->sta.wcid,
-					    true, mvif->ctx);
+					    true, mvif->mt76.ctx);
 
 	ewma_avg_signal_init(&msta->avg_ack_signal);
 
@@ -791,7 +791,7 @@ void mt7921_mac_sta_remove(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 		if (!sta->tdls)
 			mt76_connac_mcu_uni_add_bss(&dev->mphy, vif,
 						    &mvif->sta.wcid, false,
-						    mvif->ctx);
+						    mvif->mt76.ctx);
 	}
 
 	spin_lock_bh(&dev->mt76.sta_poll_lock);
@@ -1208,7 +1208,7 @@ mt7921_start_ap(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	mt792x_mutex_acquire(dev);
 
 	err = mt76_connac_mcu_uni_add_bss(phy->mt76, vif, &mvif->sta.wcid,
-					  true, mvif->ctx);
+					  true, mvif->mt76.ctx);
 	if (err)
 		goto out;
 
@@ -1240,7 +1240,7 @@ mt7921_stop_ap(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		goto out;
 
 	mt76_connac_mcu_uni_add_bss(phy->mt76, vif, &mvif->sta.wcid, false,
-				    mvif->ctx);
+				    mvif->mt76.ctx);
 
 out:
 	mt792x_mutex_release(dev);
@@ -1265,7 +1265,7 @@ static void mt7921_ctx_iter(void *priv, u8 *mac,
 	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
 	struct ieee80211_chanctx_conf *ctx = priv;
 
-	if (ctx != mvif->ctx)
+	if (ctx != mvif->mt76.ctx)
 		return;
 
 	if (vif->type == NL80211_IFTYPE_MONITOR)
@@ -1298,7 +1298,7 @@ static void mt7921_mgd_prepare_tx(struct ieee80211_hw *hw,
 		       jiffies_to_msecs(HZ);
 
 	mt792x_mutex_acquire(dev);
-	mt7921_set_roc(mvif->phy, mvif, mvif->ctx->def.chan, duration,
+	mt7921_set_roc(mvif->phy, mvif, mvif->mt76.ctx->def.chan, duration,
 		       MT7921_ROC_REQ_JOIN);
 	mt792x_mutex_release(dev);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index 5d5ab8630041b..6c347495e1185 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -91,7 +91,6 @@ struct mt792x_vif {
 	struct ewma_rssi rssi;
 
 	struct ieee80211_tx_queue_params queue_params[IEEE80211_NUM_ACS];
-	struct ieee80211_chanctx_conf *ctx;
 };
 
 struct mt792x_phy {
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_core.c b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
index 46be7f996c7e1..ec98450a938ff 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
@@ -243,7 +243,7 @@ int mt792x_assign_vif_chanctx(struct ieee80211_hw *hw,
 	struct mt792x_dev *dev = mt792x_hw_dev(hw);
 
 	mutex_lock(&dev->mt76.mutex);
-	mvif->ctx = ctx;
+	mvif->mt76.ctx = ctx;
 	mutex_unlock(&dev->mt76.mutex);
 
 	return 0;
@@ -259,7 +259,7 @@ void mt792x_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	struct mt792x_dev *dev = mt792x_hw_dev(hw);
 
 	mutex_lock(&dev->mt76.mutex);
-	mvif->ctx = NULL;
+	mvif->mt76.ctx = NULL;
 	mutex_unlock(&dev->mt76.mutex);
 }
 EXPORT_SYMBOL_GPL(mt792x_unassign_vif_chanctx);
-- 
2.42.0



