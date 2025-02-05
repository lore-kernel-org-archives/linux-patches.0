Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB7114B959;
	Wed,  5 Feb 2025 14:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765360; cv=none; b=DRx1l6+nKWQhzxFTg7R4CDE4OkdnkRgpOSYcy0lRLmF9a4TiE5gn0aCXEB5dNrbK8fIk35XrHOVE8ZecYlHBIM6XatYhYZl8WJGWrs2FeQWifCdAQ5BVY4J2cvlsNYs7pA2r9Wo3eSHg0DvbhOVXquzgf3mW/G1wSXCH5LswstY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765360; c=relaxed/simple;
	bh=smCUGx7abtBUVrW6QL575mRgbtpmTmC/qhqnMQyWjZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aftnus1tu+oO3MRSXabkdFEZOQZYHJeyZxInIQDCIzso+LhtmGaoHeOgOnBxRg5evno62Mv91o4lH+hKonQlS9GdklPnliM5HcKk+GgKkPTXUU1pidrXmFIbtTdY5b1HdkQfawhpy7HksByiKSDT5mMQWrCGPGy87SWWWCGy7/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TSxiN9UU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TSxiN9UU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80DBBC4CED1;
	Wed,  5 Feb 2025 14:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765359;
	bh=smCUGx7abtBUVrW6QL575mRgbtpmTmC/qhqnMQyWjZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TSxiN9UU5pm0jDjJCd5lMXT3mkyEvKS1jmDwLCBzy4ak9rIIq705zb2Dj9YN8nIXR
	 BBdx727RYFIEPW7sBSjgvZFLrzwEB3+bc/glFm1h8Fwq4Lbi7aSuPfIgSCuPowRaYE
	 R98Bozbpt3odebaCinDkMclu8jIJSq77r+sD5ilc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 194/590] wifi: mt76: mt7925: Update mt7925_mcu_uni_[tx,rx]_ba for MLO
Date: Wed,  5 Feb 2025 14:39:09 +0100
Message-ID: <20250205134502.700679089@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



