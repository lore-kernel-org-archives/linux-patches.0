Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318AB522A;
	Wed,  5 Feb 2025 14:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765614; cv=none; b=JjaroGZS7ac2XVdkmnEIa2tIiF26jzDzlTxzhp4cURzjTOzM0vjJ6dC6DJWL9nZ2CEdsFVISPFC6KZ5FzKHnXr2sBJ7RuqB5GmGGOm1y4/pDn9p7zKDRAPNfdULYQ43CZvbQu7gmZ8gMFZKjg5pWPBmoUm+OaHzIP01NuC7xteE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765614; c=relaxed/simple;
	bh=AKNM53m8ve3yZOCxeN7bD0SmwV4clm7/OS133com8x4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfB5A4S5Jdl4ouivTiYC96EHdJU5tYepGnwJRFKatZCMeNVu9/mvpuNXrY9UT+hfkrf2TC5RDRVtoTQZslKRVw1RAn8K+5wZ0AKXZKoevj8cJ3W69rCwW4Ul7ueQybAybimxTgpObf+PGD4lkKfmkKTSzNLTREPx/khH3mC0kgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bxumh+V7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bxumh+V7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E45EC4CED6;
	Wed,  5 Feb 2025 14:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765614;
	bh=AKNM53m8ve3yZOCxeN7bD0SmwV4clm7/OS133com8x4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bxumh+V7LZKcLplHS49sHBTH92p9D1RGJnbcHLoBuKumPNQCLSPf3xUAsCQc4hV7b
	 Yc5KhO2xrvKDf+HyuVACwLuifitTGUy6bGmxNWcmODRAqRsb9i2uE6cVZPtEL/LA6+
	 GulGLC9MElne3p1Xyfbq4DNRjDGdQcLV2Pf17/KQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 198/623] wifi: mt76: mt7925: Update secondary link PS flow
Date: Wed,  5 Feb 2025 14:39:00 +0100
Message-ID: <20250205134503.807968269@linuxfoundation.org>
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

[ Upstream commit 8dafab9c4116a6a4fd870be03a3d9b66771dc5a8 ]

Update the power-saving flow for secondary links.

Fixes: 86c051f2c418 ("wifi: mt76: mt7925: enabling MLO when the firmware supports it")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/20241211011926.5002-13-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7925/main.c  |  7 ++++++
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   | 25 ++++++-------------
 .../net/wireless/mediatek/mt76/mt7925/mcu.h   |  3 +++
 drivers/net/wireless/mediatek/mt76/mt792x.h   |  7 ++++--
 4 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index a78aae7d10886..dcdb9bcff3c40 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -1903,6 +1903,13 @@ static void mt7925_link_info_changed(struct ieee80211_hw *hw,
 	if (changed & (BSS_CHANGED_QOS | BSS_CHANGED_BEACON_ENABLED))
 		mt7925_mcu_set_tx(dev, info);
 
+	if (changed & BSS_CHANGED_BSSID) {
+		if (ieee80211_vif_is_mld(vif) &&
+		    hweight16(mvif->valid_links) == 2)
+			/* Indicate the secondary setup done */
+			mt7925_mcu_uni_bss_bcnft(dev, info, true);
+	}
+
 	mt792x_mutex_release(dev);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 4577e838f5872..0976f3dffbe46 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -1362,7 +1362,7 @@ int mt7925_mcu_uni_bss_ps(struct mt792x_dev *dev,
 				 &ps_req, sizeof(ps_req), true);
 }
 
-static int
+int
 mt7925_mcu_uni_bss_bcnft(struct mt792x_dev *dev,
 			 struct ieee80211_bss_conf *link_conf, bool enable)
 {
@@ -1923,32 +1923,21 @@ int mt7925_mcu_set_beacon_filter(struct mt792x_dev *dev,
 {
 #define MT7925_FIF_BIT_CLR		BIT(1)
 #define MT7925_FIF_BIT_SET		BIT(0)
-	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
-	unsigned long valid = ieee80211_vif_is_mld(vif) ?
-				      mvif->valid_links : BIT(0);
-	struct ieee80211_bss_conf *bss_conf;
 	int err = 0;
-	int i;
 
 	if (enable) {
-		for_each_set_bit(i, &valid, IEEE80211_MLD_MAX_NUM_LINKS) {
-			bss_conf = mt792x_vif_to_bss_conf(vif, i);
-			err = mt7925_mcu_uni_bss_bcnft(dev, bss_conf, true);
-			if (err < 0)
-				return err;
-		}
+		err = mt7925_mcu_uni_bss_bcnft(dev, &vif->bss_conf, true);
+		if (err < 0)
+			return err;
 
 		return mt7925_mcu_set_rxfilter(dev, 0,
 					       MT7925_FIF_BIT_SET,
 					       MT_WF_RFCR_DROP_OTHER_BEACON);
 	}
 
-	for_each_set_bit(i, &valid, IEEE80211_MLD_MAX_NUM_LINKS) {
-		bss_conf = mt792x_vif_to_bss_conf(vif, i);
-		err = mt7925_mcu_set_bss_pm(dev, bss_conf, false);
-		if (err)
-			return err;
-	}
+	err = mt7925_mcu_set_bss_pm(dev, &vif->bss_conf, false);
+	if (err < 0)
+		return err;
 
 	return mt7925_mcu_set_rxfilter(dev, 0,
 				       MT7925_FIF_BIT_CLR,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
index ac53bdc993322..31bb8ed2ec513 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
@@ -643,4 +643,7 @@ int mt7925_mcu_set_chctx(struct mt76_phy *phy, struct mt76_vif *mvif,
 int mt7925_mcu_set_rate_txpower(struct mt76_phy *phy);
 int mt7925_mcu_update_arp_filter(struct mt76_dev *dev,
 				 struct ieee80211_bss_conf *link_conf);
+int
+mt7925_mcu_uni_bss_bcnft(struct mt792x_dev *dev,
+			 struct ieee80211_bss_conf *link_conf, bool enable);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index ab12616ec2b87..2b8b9b2977f74 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -241,6 +241,7 @@ static inline struct mt792x_bss_conf *
 mt792x_vif_to_link(struct mt792x_vif *mvif, u8 link_id)
 {
 	struct ieee80211_vif *vif;
+	struct mt792x_bss_conf *bss_conf;
 
 	vif = container_of((void *)mvif, struct ieee80211_vif, drv_priv);
 
@@ -248,8 +249,10 @@ mt792x_vif_to_link(struct mt792x_vif *mvif, u8 link_id)
 	    link_id >= IEEE80211_LINK_UNSPECIFIED)
 		return &mvif->bss_conf;
 
-	return rcu_dereference_protected(mvif->link_conf[link_id],
-		lockdep_is_held(&mvif->phy->dev->mt76.mutex));
+	bss_conf = rcu_dereference_protected(mvif->link_conf[link_id],
+					     lockdep_is_held(&mvif->phy->dev->mt76.mutex));
+
+	return bss_conf ? bss_conf : &mvif->bss_conf;
 }
 
 static inline struct mt792x_link_sta *
-- 
2.39.5



