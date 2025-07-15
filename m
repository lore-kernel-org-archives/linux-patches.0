Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15BC2E611D;
	Tue, 15 Jul 2025 13:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587036; cv=none; b=oGpoIkefrkvCit5NLvnPsGGoos+YcuVvZrbFR+CZL4V/fPhnjZ6SJ+S4JQKEgj7RLejK4G/1PVm2/sqJkNhx0JU+FrmHo8uXHO/XuxuJB3x3AxqN2c8odJRpjtyQP/B2ZS09cn2IYRbCGQPEyiJ+zfmkn4zy/4y97c6vj2SZcRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587036; c=relaxed/simple;
	bh=GDZhZ+Eoh5d6SdtUJguc6WEM2GTV7oKYdHZPWAA8pVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DUT65pMBq2I0nxxwJ2NPzQSpj4LwyYXxz9cVkbauY+AAxRg/JQuHev2737VS5TnVTkWMQ4KebduD4xSydRBgZLVMUbSuZ0QPNTFeE6iVT+FKJuHLypjn+ZYEXozRhBU7atO5Qfv2y8lF9QLQ8d7q/jdm2te4vUALMg7KyOE8EhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gMMX4RhC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gMMX4RhC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5626FC4CEE3;
	Tue, 15 Jul 2025 13:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587036;
	bh=GDZhZ+Eoh5d6SdtUJguc6WEM2GTV7oKYdHZPWAA8pVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gMMX4RhCpKSjMrbTbBJcqOOXjSU/h8AUxVoB87pCsGBFONcSj+Pi0c9aifCkgFX7+
	 Y5DK44IMsjxU0uBOqj3UgQPRotSu7qrN9j7ENhZ/oAqCvm75oVvozZuVgzS/dCXLGR
	 vugxz/JDcPDrI6DIClgfRI10XgdBRT+4K5nfyJY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 142/192] wifi: mt76: Move RCU section in mt7996_mcu_add_rate_ctrl()
Date: Tue, 15 Jul 2025 15:13:57 +0200
Message-ID: <20250715130820.603289584@linuxfoundation.org>
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

[ Upstream commit 3dd6f67c669c860b93ff533f790f23ee1cb36f25 ]

Since mt76_mcu_skb_send_msg() routine can't be executed in atomic context,
move RCU section in mt7996_mcu_add_rate_ctrl() and execute
mt76_mcu_skb_send_msg() in non-atomic context. This is a preliminary
patch to fix a 'sleep while atomic' issue in mt7996_mac_sta_rc_work().

Fixes: 0762bdd30279 ("wifi: mt76: mt7996: rework mt7996_mac_sta_rc_work to support MLO")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250605-mt7996-sleep-while-atomic-v1-4-d46d15f9203c@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/mac.c   |  6 +--
 .../net/wireless/mediatek/mt76/mt7996/main.c  |  6 +--
 .../net/wireless/mediatek/mt76/mt7996/mcu.c   | 50 +++++++++++++++----
 .../wireless/mediatek/mt76/mt7996/mt7996.h    | 10 ++--
 4 files changed, 45 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 5cf2d6669ee68..20a201e336759 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2321,7 +2321,6 @@ void mt7996_mac_sta_rc_work(struct work_struct *work)
 	struct ieee80211_bss_conf *link_conf;
 	struct ieee80211_link_sta *link_sta;
 	struct mt7996_sta_link *msta_link;
-	struct mt7996_vif_link *link;
 	struct mt76_vif_link *mlink;
 	struct ieee80211_sta *sta;
 	struct ieee80211_vif *vif;
@@ -2363,13 +2362,10 @@ void mt7996_mac_sta_rc_work(struct work_struct *work)
 
 		spin_unlock_bh(&dev->mt76.sta_poll_lock);
 
-		link = (struct mt7996_vif_link *)mlink;
-
 		if (changed & (IEEE80211_RC_SUPP_RATES_CHANGED |
 			       IEEE80211_RC_NSS_CHANGED |
 			       IEEE80211_RC_BW_CHANGED))
-			mt7996_mcu_add_rate_ctrl(dev, vif, link_conf,
-						 link_sta, link, msta_link,
+			mt7996_mcu_add_rate_ctrl(dev, msta_link->sta, vif,
 						 link_id, true);
 
 		if (changed & IEEE80211_RC_SMPS_CHANGED)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index bb2eef6b934b5..5584bea9e2a3f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1112,10 +1112,8 @@ mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 			if (err)
 				return err;
 
-			err = mt7996_mcu_add_rate_ctrl(dev, vif, link_conf,
-						       link_sta, link,
-						       msta_link, link_id,
-						       false);
+			err = mt7996_mcu_add_rate_ctrl(dev, msta_link->sta, vif,
+						       link_id, false);
 			if (err)
 				return err;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 6c2b258ce4ff6..63dc6df20c3e4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -2179,23 +2179,44 @@ mt7996_mcu_sta_rate_ctrl_tlv(struct sk_buff *skb, struct mt7996_dev *dev,
 	memset(ra->rx_rcpi, INIT_RCPI, sizeof(ra->rx_rcpi));
 }
 
-int mt7996_mcu_add_rate_ctrl(struct mt7996_dev *dev,
-			     struct ieee80211_vif *vif,
-			     struct ieee80211_bss_conf *link_conf,
-			     struct ieee80211_link_sta *link_sta,
-			     struct mt7996_vif_link *link,
-			     struct mt7996_sta_link *msta_link,
-			     u8 link_id, bool changed)
+int mt7996_mcu_add_rate_ctrl(struct mt7996_dev *dev, struct mt7996_sta *msta,
+			     struct ieee80211_vif *vif, u8 link_id,
+			     bool changed)
 {
-	struct mt7996_sta *msta = msta_link->sta;
+	struct ieee80211_bss_conf *link_conf;
+	struct ieee80211_link_sta *link_sta;
+	struct mt7996_sta_link *msta_link;
+	struct mt7996_vif_link *link;
+	struct ieee80211_sta *sta;
 	struct sk_buff *skb;
-	int ret;
+	int ret = -ENODEV;
+
+	rcu_read_lock();
+
+	link = mt7996_vif_link(dev, vif, link_id);
+	if (!link)
+		goto error_unlock;
+
+	msta_link = rcu_dereference(msta->link[link_id]);
+	if (!msta_link)
+		goto error_unlock;
+
+	sta = wcid_to_sta(&msta_link->wcid);
+	link_sta = rcu_dereference(sta->link[link_id]);
+	if (!link_sta)
+		goto error_unlock;
+
+	link_conf = rcu_dereference(vif->link_conf[link_id]);
+	if (!link_conf)
+		goto error_unlock;
 
 	skb = __mt76_connac_mcu_alloc_sta_req(&dev->mt76, &link->mt76,
 					      &msta_link->wcid,
 					      MT7996_STA_UPDATE_MAX_SIZE);
-	if (IS_ERR(skb))
-		return PTR_ERR(skb);
+	if (IS_ERR(skb)) {
+		ret = PTR_ERR(skb);
+		goto error_unlock;
+	}
 
 	/* firmware rc algorithm refers to sta_rec_he for HE control.
 	 * once dev->rc_work changes the settings driver should also
@@ -2209,12 +2230,19 @@ int mt7996_mcu_add_rate_ctrl(struct mt7996_dev *dev,
 	 */
 	mt7996_mcu_sta_rate_ctrl_tlv(skb, dev, vif, link_conf, link_sta, link);
 
+	rcu_read_unlock();
+
 	ret = mt76_mcu_skb_send_msg(&dev->mt76, skb,
 				    MCU_WMWA_UNI_CMD(STA_REC_UPDATE), true);
 	if (ret)
 		return ret;
 
 	return mt7996_mcu_add_rate_ctrl_fixed(dev, msta, vif, link_id);
+
+error_unlock:
+	rcu_read_unlock();
+
+	return ret;
 }
 
 static int
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index 16a4a465b9b27..8220a7310f285 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -604,13 +604,9 @@ int mt7996_mcu_beacon_inband_discov(struct mt7996_dev *dev,
 int mt7996_mcu_add_obss_spr(struct mt7996_phy *phy,
 			    struct mt7996_vif_link *link,
 			    struct ieee80211_he_obss_pd *he_obss_pd);
-int mt7996_mcu_add_rate_ctrl(struct mt7996_dev *dev,
-			     struct ieee80211_vif *vif,
-			     struct ieee80211_bss_conf *link_conf,
-			     struct ieee80211_link_sta *link_sta,
-			     struct mt7996_vif_link *link,
-			     struct mt7996_sta_link *msta_link,
-			     u8 link_id, bool changed);
+int mt7996_mcu_add_rate_ctrl(struct mt7996_dev *dev, struct mt7996_sta *msta,
+			     struct ieee80211_vif *vif, u8 link_id,
+			     bool changed);
 int mt7996_set_channel(struct mt76_phy *mphy);
 int mt7996_mcu_set_chan_info(struct mt7996_phy *phy, u16 tag);
 int mt7996_mcu_set_tx(struct mt7996_dev *dev, struct ieee80211_vif *vif,
-- 
2.39.5



