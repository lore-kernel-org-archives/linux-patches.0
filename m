Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6C61EB1BF;
	Thu, 17 Apr 2025 18:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913283; cv=none; b=OjxcJI3clWRU6b8vd/2A+NjQkqb3vJuWQnpcm/i/FaFgxu6qZr9s64sfcASX1+AcKlT/vKRtVpryePNGP1flHmfVXqDInuPPFShsZ9OmQUcaTpsf7u3Vd+r5puXiNqKtDwFCJqsQ4AVeQa2vxMtRH1brsegWi2OMCUTSP+QVdbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913283; c=relaxed/simple;
	bh=WDjwvFkgt9TXGAugwzDI2/FxUhAewtIWwvdWcjz4Bc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=treAnoQQQxsa8P3wN1MnnWC9qSYaSzUdOk/puhOsjg5jISKbOmdpkHctLJXjsw7JIZ4cAoZFAT/iojn7F7tnfUVYPZWckIjRpLNgkWc4EP4pLQqPu5yI/vFVwpcMfzZxhAVYh3t7EK66MkhOB3bDnKwMm/nufeg9DJzGQuhnG44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s6QnoYMp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s6QnoYMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938E7C4CEE4;
	Thu, 17 Apr 2025 18:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913283;
	bh=WDjwvFkgt9TXGAugwzDI2/FxUhAewtIWwvdWcjz4Bc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s6QnoYMp8QvQ/0/8/XGTH68F0ZUqStb2YJX0t6bU+BxAMkuUAVXNwycO3ww5MujGb
	 V7fTKpGYsxawC9oozrdSwoA9Yiy5OT8ReY5oPYSufO8QGF40UNMSthWK+ZSdlNXOPj
	 9z1SEYjo9qjYM3oemGAXpnzusZ+YMeIaixJtf06w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Caleb Jorden <cjorden@gmail.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.14 287/449] wifi: mt76: mt7925: update the power-saving flow
Date: Thu, 17 Apr 2025 19:49:35 +0200
Message-ID: <20250417175129.632861137@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

commit 276a568832577c81ec90b62dc506bbdc3781ca46 upstream.

After joining MLO, ensure that all links are setup before
enabling power-saving.

Fixes: 86c051f2c418 ("wifi: mt76: mt7925: enabling MLO when the firmware supports it")
Cc: stable@vger.kernel.org
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Tested-by: Caleb Jorden <cjorden@gmail.com>
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250305000851.493671-6-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/init.c   |    1 
 drivers/net/wireless/mediatek/mt76/mt7925/main.c   |   68 +++++++++++++++++----
 drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h |    1 
 drivers/net/wireless/mediatek/mt76/mt792x.h        |    9 ++
 4 files changed, 68 insertions(+), 11 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7925/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/init.c
@@ -244,6 +244,7 @@ int mt7925_register_device(struct mt792x
 	dev->mt76.tx_worker.fn = mt792x_tx_worker;
 
 	INIT_DELAYED_WORK(&dev->pm.ps_work, mt792x_pm_power_save_work);
+	INIT_DELAYED_WORK(&dev->mlo_pm_work, mt7925_mlo_pm_work);
 	INIT_WORK(&dev->pm.wake_work, mt792x_pm_wake_work);
 	spin_lock_init(&dev->pm.wake.lock);
 	mutex_init(&dev->pm.mutex);
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -427,6 +427,7 @@ mt7925_add_interface(struct ieee80211_hw
 	mvif->bss_conf.vif = mvif;
 	mvif->sta.vif = mvif;
 	mvif->deflink_id = IEEE80211_LINK_UNSPECIFIED;
+	mvif->mlo_pm_state = MT792x_MLO_LINK_DISASSOC;
 
 	ret = mt7925_mac_link_bss_add(dev, &vif->bss_conf, &mvif->sta.deflink);
 	if (ret < 0)
@@ -1242,6 +1243,7 @@ void mt7925_mac_sta_remove(struct mt76_d
 {
 	struct mt792x_dev *dev = container_of(mdev, struct mt792x_dev, mt76);
 	struct mt792x_sta *msta = (struct mt792x_sta *)sta->drv_priv;
+	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
 	unsigned long rem;
 
 	rem = ieee80211_vif_is_mld(vif) ? msta->valid_links : BIT(0);
@@ -1252,11 +1254,11 @@ void mt7925_mac_sta_remove(struct mt76_d
 		mt7925_mcu_del_dev(mdev, vif);
 
 	if (vif->type == NL80211_IFTYPE_STATION) {
-		struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
-
 		mvif->wep_sta = NULL;
 		ewma_rssi_init(&mvif->bss_conf.rssi);
 	}
+
+	mvif->mlo_pm_state = MT792x_MLO_LINK_DISASSOC;
 }
 EXPORT_SYMBOL_GPL(mt7925_mac_sta_remove);
 
@@ -1328,6 +1330,38 @@ mt7925_ampdu_action(struct ieee80211_hw
 	return ret;
 }
 
+static void
+mt7925_mlo_pm_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct mt792x_dev *dev = priv;
+	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
+	unsigned long valid = ieee80211_vif_is_mld(vif) ?
+				    mvif->valid_links : BIT(0);
+	struct ieee80211_bss_conf *bss_conf;
+	int i;
+
+	if (mvif->mlo_pm_state != MT792x_MLO_CHANGED_PS)
+		return;
+
+	mt792x_mutex_acquire(dev);
+	for_each_set_bit(i, &valid, IEEE80211_MLD_MAX_NUM_LINKS) {
+		bss_conf = mt792x_vif_to_bss_conf(vif, i);
+		mt7925_mcu_uni_bss_ps(dev, bss_conf);
+	}
+	mt792x_mutex_release(dev);
+}
+
+void mt7925_mlo_pm_work(struct work_struct *work)
+{
+	struct mt792x_dev *dev = container_of(work, struct mt792x_dev,
+					      mlo_pm_work.work);
+	struct ieee80211_hw *hw = mt76_hw(dev);
+
+	ieee80211_iterate_active_interfaces(hw,
+					    IEEE80211_IFACE_ITER_RESUME_ALL,
+					    mt7925_mlo_pm_iter, dev);
+}
+
 static bool is_valid_alpha2(const char *alpha2)
 {
 	if (!alpha2)
@@ -1877,6 +1911,9 @@ static void mt7925_vif_cfg_changed(struc
 		mt7925_mcu_sta_update(dev, NULL, vif, true,
 				      MT76_STA_INFO_STATE_ASSOC);
 		mt7925_mcu_set_beacon_filter(dev, vif, vif->cfg.assoc);
+
+		if (ieee80211_vif_is_mld(vif))
+			mvif->mlo_pm_state = MT792x_MLO_LINK_ASSOC;
 	}
 
 	if (changed & BSS_CHANGED_ARP_FILTER) {
@@ -1887,9 +1924,19 @@ static void mt7925_vif_cfg_changed(struc
 	}
 
 	if (changed & BSS_CHANGED_PS) {
-		for_each_set_bit(i, &valid, IEEE80211_MLD_MAX_NUM_LINKS) {
-			bss_conf = mt792x_vif_to_bss_conf(vif, i);
+		if (hweight16(mvif->valid_links) < 2) {
+			/* legacy */
+			bss_conf = &vif->bss_conf;
 			mt7925_mcu_uni_bss_ps(dev, bss_conf);
+		} else {
+			if (mvif->mlo_pm_state == MT792x_MLO_LINK_ASSOC) {
+				mvif->mlo_pm_state = MT792x_MLO_CHANGED_PS_PENDING;
+			} else if (mvif->mlo_pm_state == MT792x_MLO_CHANGED_PS) {
+				for_each_set_bit(i, &valid, IEEE80211_MLD_MAX_NUM_LINKS) {
+					bss_conf = mt792x_vif_to_bss_conf(vif, i);
+					mt7925_mcu_uni_bss_ps(dev, bss_conf);
+				}
+			}
 		}
 	}
 
@@ -1940,11 +1987,12 @@ static void mt7925_link_info_changed(str
 	if (changed & (BSS_CHANGED_QOS | BSS_CHANGED_BEACON_ENABLED))
 		mt7925_mcu_set_tx(dev, info);
 
-	if (changed & BSS_CHANGED_BSSID) {
-		if (ieee80211_vif_is_mld(vif) &&
-		    hweight16(mvif->valid_links) == 2)
-			/* Indicate the secondary setup done */
-			mt7925_mcu_uni_bss_bcnft(dev, info, true);
+	if (mvif->mlo_pm_state == MT792x_MLO_CHANGED_PS_PENDING) {
+		/* Indicate the secondary setup done */
+		mt7925_mcu_uni_bss_bcnft(dev, info, true);
+
+		ieee80211_queue_delayed_work(hw, &dev->mlo_pm_work, 5 * HZ);
+		mvif->mlo_pm_state = MT792x_MLO_CHANGED_PS;
 	}
 
 	mt792x_mutex_release(dev);
@@ -2028,8 +2076,6 @@ mt7925_change_vif_links(struct ieee80211
 			goto free;
 
 		if (mconf != &mvif->bss_conf) {
-			mt7925_mcu_set_bss_pm(dev, link_conf, true);
-
 			err = mt7925_set_mlo_roc(phy, &mvif->bss_conf,
 						 vif->active_links);
 			if (err < 0)
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
@@ -268,6 +268,7 @@ int mt7925_mcu_uni_tx_ba(struct mt792x_d
 int mt7925_mcu_uni_rx_ba(struct mt792x_dev *dev,
 			 struct ieee80211_ampdu_params *params,
 			 bool enable);
+void mt7925_mlo_pm_work(struct work_struct *work);
 void mt7925_scan_work(struct work_struct *work);
 void mt7925_roc_work(struct work_struct *work);
 int mt7925_mcu_uni_bss_ps(struct mt792x_dev *dev,
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -81,6 +81,13 @@ enum mt792x_reg_power_type {
 	MT_AP_VLP,
 };
 
+enum mt792x_mlo_pm_state {
+	MT792x_MLO_LINK_DISASSOC,
+	MT792x_MLO_LINK_ASSOC,
+	MT792x_MLO_CHANGED_PS_PENDING,
+	MT792x_MLO_CHANGED_PS,
+};
+
 DECLARE_EWMA(avg_signal, 10, 8)
 
 struct mt792x_link_sta {
@@ -134,6 +141,7 @@ struct mt792x_vif {
 	struct mt792x_phy *phy;
 	u16 valid_links;
 	u8 deflink_id;
+	enum mt792x_mlo_pm_state mlo_pm_state;
 
 	struct work_struct csa_work;
 	struct timer_list csa_timer;
@@ -239,6 +247,7 @@ struct mt792x_dev {
 	const struct mt792x_irq_map *irq_map;
 
 	struct work_struct ipv6_ns_work;
+	struct delayed_work mlo_pm_work;
 	/* IPv6 addresses for WoWLAN */
 	struct sk_buff_head ipv6_ns_list;
 


