Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FD730FF36;
	Mon, 13 Oct 2025 15:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369740; cv=none; b=Ed1RuBkjujXpSqCnxsEJp1hQoLMFIbvIQCNfF6Uztlk6mqxFw/I0IEfGj6DWzz4+rrZOmiqFcnw5L+AqdcW95y2ivxB2uCHoNxVRYr3XFcYhD06B4YjKyEHofaLiNsapbazlLILRUrBh4jzBERPXIT1Gx4XSSIC7ZWCbXLoH+kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369740; c=relaxed/simple;
	bh=AJSIbboQUCB5UG3bSXpohaCrmQl6IvYpvm6BZjArdtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=daCKQhB56tob4oyd8K3vo2wnzlBKsCymXSDYaCoRygxwA9qlaG5TNdDMf4XKy4mbkDsKEd0bhDUmeQWXNMoKUHuI3eyc8qTBmZ1L1//EgrcHCTaGB+ra5Z5D7WkJp+HJvFvx9vLDEwbRpxXIqqOW+oopxcyB9RSM02qeKV0iHjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vvpbWOWC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vvpbWOWC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E52C2BC86;
	Mon, 13 Oct 2025 15:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369740;
	bh=AJSIbboQUCB5UG3bSXpohaCrmQl6IvYpvm6BZjArdtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vvpbWOWC+56DJmAWvvA94x4hCIHUNM8exkZT4NdMCeNUD2QZMDX72byISpKCfehgM
	 62HPCbo0N4ikiuV8popsPCt77ZRuDLoOQfwYvI9B3laZbOJohmTPUsW5o5TG1Qur0C
	 l6oW7DIYS5VKpOIqe8h5ggUBGN0MgmLCKXl/7A78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 353/563] wifi: mt76: mt7996: Fix mt7996_mcu_sta_ba wcid configuration
Date: Mon, 13 Oct 2025 16:43:34 +0200
Message-ID: <20251013144424.057829948@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit fe219a41adaf5354c59e75ebb642b8cb8a851d38 ]

Fix the wcid pointer used in mt7996_mcu_sta_ba routine to properly
support MLO scenario.

Fixes: 98686cd21624c ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250708-mt7996-mlo-fixes-v2-v1-2-f2682818a8a3@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   |  6 ++++--
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    | 12 +++++++-----
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h |  3 ++-
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 84f731b387d20..8a8a478391646 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1327,11 +1327,13 @@ mt7996_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		case IEEE80211_AMPDU_RX_START:
 			mt76_rx_aggr_start(&dev->mt76, &msta_link->wcid, tid,
 					   ssn, params->buf_size);
-			ret = mt7996_mcu_add_rx_ba(dev, params, link, true);
+			ret = mt7996_mcu_add_rx_ba(dev, params, link,
+						   msta_link, true);
 			break;
 		case IEEE80211_AMPDU_RX_STOP:
 			mt76_rx_aggr_stop(&dev->mt76, &msta_link->wcid, tid);
-			ret = mt7996_mcu_add_rx_ba(dev, params, link, false);
+			ret = mt7996_mcu_add_rx_ba(dev, params, link,
+						   msta_link, false);
 			break;
 		case IEEE80211_AMPDU_TX_OPERATIONAL:
 			mtxq->aggr = true;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 0be03eb3cf461..e6db3e0b2ffda 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -1149,9 +1149,8 @@ int mt7996_mcu_set_timing(struct mt7996_phy *phy, struct ieee80211_vif *vif,
 static int
 mt7996_mcu_sta_ba(struct mt7996_dev *dev, struct mt76_vif_link *mvif,
 		  struct ieee80211_ampdu_params *params,
-		  bool enable, bool tx)
+		  struct mt76_wcid *wcid, bool enable, bool tx)
 {
-	struct mt76_wcid *wcid = (struct mt76_wcid *)params->sta->drv_priv;
 	struct sta_rec_ba_uni *ba;
 	struct sk_buff *skb;
 	struct tlv *tlv;
@@ -1185,14 +1184,17 @@ int mt7996_mcu_add_tx_ba(struct mt7996_dev *dev,
 	if (enable && !params->amsdu)
 		msta_link->wcid.amsdu = false;
 
-	return mt7996_mcu_sta_ba(dev, &link->mt76, params, enable, true);
+	return mt7996_mcu_sta_ba(dev, &link->mt76, params, &msta_link->wcid,
+				 enable, true);
 }
 
 int mt7996_mcu_add_rx_ba(struct mt7996_dev *dev,
 			 struct ieee80211_ampdu_params *params,
-			 struct mt7996_vif_link *link, bool enable)
+			 struct mt7996_vif_link *link,
+			 struct mt7996_sta_link *msta_link, bool enable)
 {
-	return mt7996_mcu_sta_ba(dev, &link->mt76, params, enable, false);
+	return mt7996_mcu_sta_ba(dev, &link->mt76, params, &msta_link->wcid,
+				 enable, false);
 }
 
 static void
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index 8509d508e1e19..bbd4679edc9d3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -608,7 +608,8 @@ int mt7996_mcu_add_tx_ba(struct mt7996_dev *dev,
 			 struct mt7996_sta_link *msta_link, bool enable);
 int mt7996_mcu_add_rx_ba(struct mt7996_dev *dev,
 			 struct ieee80211_ampdu_params *params,
-			 struct mt7996_vif_link *link, bool enable);
+			 struct mt7996_vif_link *link,
+			 struct mt7996_sta_link *msta_link, bool enable);
 int mt7996_mcu_update_bss_color(struct mt7996_dev *dev,
 				struct mt76_vif_link *mlink,
 				struct cfg80211_he_bss_color *he_bss_color);
-- 
2.51.0



