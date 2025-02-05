Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F408634E;
	Wed,  5 Feb 2025 14:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765638; cv=none; b=szOkaKV7RkgJhAEuZdfxQ3q/CX5gZHANTXn1SHkhm9BtzGwHL75Qo1/swyTzRmB3Y82sfI4MUJe+fdPhDVhR+1uGr0RDrZvmvjXiAbBCNhHRRMUoQMNeLjE85GxZ1slenqLxXJScYTSdUjzU74R0maLPRBUSvm8KpW03ga3vevc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765638; c=relaxed/simple;
	bh=rmBthefYviJ9KjTJHvRPwpypmz69lSCSKA1LlBLuyo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DBzqucdsAORkSNgNRAENrY+/Pn1Oh6yFQBpqjnj4BliOFfpjFY/J0PgTjBLPcc2QRCkx46Z6g9S2k+zxuQK+LZr0U1z5BG9plmfcjMDJfW44wZFz+vyUXu96Lb7IACGBMiOPdWDWE7HzN1gILYAx8yV5yMs7UAnz9VOznf0yfoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OO7Q0A4l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OO7Q0A4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7CB5C4CED1;
	Wed,  5 Feb 2025 14:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765638;
	bh=rmBthefYviJ9KjTJHvRPwpypmz69lSCSKA1LlBLuyo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OO7Q0A4lRsUWMgLaWLKlwQe9li/cfKVuC04CrOoGWrAJaWSn/SrJpxZqnsLJpPbyZ
	 Gxt11/bDkGwvAdRwDk4K7fu4ztIhHir7n03iYbP0Q7FJXLKr1q5f0BsQJJTa1s/nfn
	 zXN8CXc+H93Cl/7BxcolYXJIQ0MhXQ/JDRYSfTUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 200/623] wifi: mt76: mt7925: Update mt7925_mcu_uni_[tx,rx]_ba for MLO
Date: Wed,  5 Feb 2025 14:39:02 +0100
Message-ID: <20250205134503.883179184@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

[ Upstream commit eb2a9a12c6092a26f632468d6610497d4f0e40da ]

Update mt7925_mcu_uni_[tx,rx]_ba for MLO support in firmware.

Fixes: 86c051f2c418 ("wifi: mt76: mt7925: enabling MLO when the firmware supports it")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/20241211011926.5002-15-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7925/main.c  | 10 ++--
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   | 50 +++++++++++++++----
 .../wireless/mediatek/mt76/mt7925/mt7925.h    |  2 +
 3 files changed, 48 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index a2d1c43098d3c..a4ffa34d58a41 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -1258,22 +1258,22 @@ mt7925_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	case IEEE80211_AMPDU_RX_START:
 		mt76_rx_aggr_start(&dev->mt76, &msta->deflink.wcid, tid, ssn,
 				   params->buf_size);
-		mt7925_mcu_uni_rx_ba(dev, params, true);
+		mt7925_mcu_uni_rx_ba(dev, vif, params, true);
 		break;
 	case IEEE80211_AMPDU_RX_STOP:
 		mt76_rx_aggr_stop(&dev->mt76, &msta->deflink.wcid, tid);
-		mt7925_mcu_uni_rx_ba(dev, params, false);
+		mt7925_mcu_uni_rx_ba(dev, vif, params, false);
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
 		mtxq->aggr = true;
 		mtxq->send_bar = false;
-		mt7925_mcu_uni_tx_ba(dev, params, true);
+		mt7925_mcu_uni_tx_ba(dev, vif, params, true);
 		break;
 	case IEEE80211_AMPDU_TX_STOP_FLUSH:
 	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
 		mtxq->aggr = false;
 		clear_bit(tid, &msta->deflink.wcid.ampdu_state);
-		mt7925_mcu_uni_tx_ba(dev, params, false);
+		mt7925_mcu_uni_tx_ba(dev, vif, params, false);
 		break;
 	case IEEE80211_AMPDU_TX_START:
 		set_bit(tid, &msta->deflink.wcid.ampdu_state);
@@ -1282,7 +1282,7 @@ mt7925_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	case IEEE80211_AMPDU_TX_STOP_CONT:
 		mtxq->aggr = false;
 		clear_bit(tid, &msta->deflink.wcid.ampdu_state);
-		mt7925_mcu_uni_tx_ba(dev, params, false);
+		mt7925_mcu_uni_tx_ba(dev, vif, params, false);
 		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 0976f3dffbe46..e4c0f234aeed2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -529,10 +529,10 @@ void mt7925_mcu_rx_event(struct mt792x_dev *dev, struct sk_buff *skb)
 
 static int
 mt7925_mcu_sta_ba(struct mt76_dev *dev, struct mt76_vif *mvif,
+		  struct mt76_wcid *wcid,
 		  struct ieee80211_ampdu_params *params,
 		  bool enable, bool tx)
 {
-	struct mt76_wcid *wcid = (struct mt76_wcid *)params->sta->drv_priv;
 	struct sta_rec_ba_uni *ba;
 	struct sk_buff *skb;
 	struct tlv *tlv;
@@ -560,28 +560,60 @@ mt7925_mcu_sta_ba(struct mt76_dev *dev, struct mt76_vif *mvif,
 
 /** starec & wtbl **/
 int mt7925_mcu_uni_tx_ba(struct mt792x_dev *dev,
+			 struct ieee80211_vif *vif,
 			 struct ieee80211_ampdu_params *params,
 			 bool enable)
 {
 	struct mt792x_sta *msta = (struct mt792x_sta *)params->sta->drv_priv;
-	struct mt792x_vif *mvif = msta->vif;
+	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
+	struct mt792x_link_sta *mlink;
+	struct mt792x_bss_conf *mconf;
+	unsigned long usable_links = ieee80211_vif_usable_links(vif);
+	struct mt76_wcid *wcid;
+	u8 link_id, ret;
 
-	if (enable && !params->amsdu)
-		msta->deflink.wcid.amsdu = false;
+	for_each_set_bit(link_id, &usable_links, IEEE80211_MLD_MAX_NUM_LINKS) {
+		mconf = mt792x_vif_to_link(mvif, link_id);
+		mlink = mt792x_sta_to_link(msta, link_id);
+		wcid = &mlink->wcid;
 
-	return mt7925_mcu_sta_ba(&dev->mt76, &mvif->bss_conf.mt76, params,
-				 enable, true);
+		if (enable && !params->amsdu)
+			mlink->wcid.amsdu = false;
+
+		ret = mt7925_mcu_sta_ba(&dev->mt76, &mconf->mt76, wcid, params,
+					enable, true);
+		if (ret < 0)
+			break;
+	}
+
+	return ret;
 }
 
 int mt7925_mcu_uni_rx_ba(struct mt792x_dev *dev,
+			 struct ieee80211_vif *vif,
 			 struct ieee80211_ampdu_params *params,
 			 bool enable)
 {
 	struct mt792x_sta *msta = (struct mt792x_sta *)params->sta->drv_priv;
-	struct mt792x_vif *mvif = msta->vif;
+	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
+	struct mt792x_link_sta *mlink;
+	struct mt792x_bss_conf *mconf;
+	unsigned long usable_links = ieee80211_vif_usable_links(vif);
+	struct mt76_wcid *wcid;
+	u8 link_id, ret;
 
-	return mt7925_mcu_sta_ba(&dev->mt76, &mvif->bss_conf.mt76, params,
-				 enable, false);
+	for_each_set_bit(link_id, &usable_links, IEEE80211_MLD_MAX_NUM_LINKS) {
+		mconf = mt792x_vif_to_link(mvif, link_id);
+		mlink = mt792x_sta_to_link(msta, link_id);
+		wcid = &mlink->wcid;
+
+		ret = mt7925_mcu_sta_ba(&dev->mt76, &mconf->mt76, wcid, params,
+					enable, false);
+		if (ret < 0)
+			break;
+	}
+
+	return ret;
 }
 
 static int mt7925_load_clc(struct mt792x_dev *dev, const char *fw_name)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
index f5c02e5f50663..df3c705d1cb3f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
@@ -242,9 +242,11 @@ int mt7925_mcu_set_beacon_filter(struct mt792x_dev *dev,
 				 struct ieee80211_vif *vif,
 				 bool enable);
 int mt7925_mcu_uni_tx_ba(struct mt792x_dev *dev,
+			 struct ieee80211_vif *vif,
 			 struct ieee80211_ampdu_params *params,
 			 bool enable);
 int mt7925_mcu_uni_rx_ba(struct mt792x_dev *dev,
+			 struct ieee80211_vif *vif,
 			 struct ieee80211_ampdu_params *params,
 			 bool enable);
 void mt7925_scan_work(struct work_struct *work);
-- 
2.39.5



