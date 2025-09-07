Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CC31DF246;
	Sun,  7 Sep 2025 20:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277500; cv=none; b=EdVPTh5a9O/iJ+hsTTDa6XfwzQdd4qCkucVT2LetBsiwP3JlqpPDt2iq1LP5LNU8OkXQfhkxLsJCkiqnjrz284JgqB0Q1GVoJ6IU3SqeF6LUZ8c866EtbrbkvYLqPcd9fgBGWvnpooJbhUET9oBuGnychZsX3LnjrwlmDZEzREI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277500; c=relaxed/simple;
	bh=oO6NO3amkGwQmS3g6AS6dA6jwrzJa6uzUJc51YmRvTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gyYbxds99YXOn3QYvaPjwW/OJgmwv51gYsbZG73oCLiDgf7PhJsC9/5bs15UpmvJx41te0SqQ1ckw/LsaxUNzu3WjzyYFX/tH/kDmnInShJnbNWVEsNbC/w/pbBMCiEUzOGfW+1Z7DAFbzHG5qxUJzFpv2a54s0tagQog2h9nMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1myebY2u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1myebY2u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DAFCC4CEF0;
	Sun,  7 Sep 2025 20:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277500;
	bh=oO6NO3amkGwQmS3g6AS6dA6jwrzJa6uzUJc51YmRvTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1myebY2unhzuEgV4vnf/ocPmpJh3CvN1tKUmpR9jIBhcAvJQAtlqNfBjXvUktK5U8
	 grz+nmncF5qVYXFctXzFAvDJj7JUAkpmDta0TBM277D2twjrS8SS37kA5Rv28t8AzY
	 I8vbgHsnkbrs1YJrIO6NlQ4jbIxPq706yclD/fFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chad Monroe <chad.monroe@adtran.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 035/183] wifi: mt76: mt7996: disable beacons when going offchannel
Date: Sun,  7 Sep 2025 21:57:42 +0200
Message-ID: <20250907195616.608516434@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit f30906c55a400a9b7fc677e3f4c614b9069bd4a8 ]

Avoid leaking beacons on unrelated channels during scanning/roc

Fixes: c56d6edebc1f ("wifi: mt76: mt7996: use emulated hardware scan support")
Reported-by: Chad Monroe <chad.monroe@adtran.com>
Link: https://patch.msgid.link/20250813121106.81559-1-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/mac.c   | 46 +++++++++++--------
 .../net/wireless/mediatek/mt76/mt7996/main.c  |  5 ++
 .../net/wireless/mediatek/mt76/mt7996/mcu.c   | 11 +++--
 .../wireless/mediatek/mt76/mt7996/mt7996.h    |  1 +
 4 files changed, 42 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 37b21ad828b96..f675cf537898a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1696,43 +1696,53 @@ mt7996_wait_reset_state(struct mt7996_dev *dev, u32 state)
 static void
 mt7996_update_vif_beacon(void *priv, u8 *mac, struct ieee80211_vif *vif)
 {
-	struct ieee80211_hw *hw = priv;
+	struct ieee80211_bss_conf *link_conf;
+	struct mt7996_phy *phy = priv;
+	struct mt7996_dev *dev = phy->dev;
+	unsigned int link_id;
+
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_AP:
-		mt7996_mcu_add_beacon(hw, vif, &vif->bss_conf);
 		break;
 	default:
-		break;
+		return;
+	}
+
+	for_each_vif_active_link(vif, link_conf, link_id) {
+		struct mt7996_vif_link *link;
+
+		link = mt7996_vif_link(dev, vif, link_id);
+		if (!link || link->phy != phy)
+			continue;
+
+		mt7996_mcu_add_beacon(dev->mt76.hw, vif, link_conf);
 	}
 }
 
+void mt7996_mac_update_beacons(struct mt7996_phy *phy)
+{
+	ieee80211_iterate_active_interfaces(phy->mt76->hw,
+					    IEEE80211_IFACE_ITER_RESUME_ALL,
+					    mt7996_update_vif_beacon, phy);
+}
+
 static void
 mt7996_update_beacons(struct mt7996_dev *dev)
 {
 	struct mt76_phy *phy2, *phy3;
 
-	ieee80211_iterate_active_interfaces(dev->mt76.hw,
-					    IEEE80211_IFACE_ITER_RESUME_ALL,
-					    mt7996_update_vif_beacon, dev->mt76.hw);
+	mt7996_mac_update_beacons(&dev->phy);
 
 	phy2 = dev->mt76.phys[MT_BAND1];
-	if (!phy2)
-		return;
-
-	ieee80211_iterate_active_interfaces(phy2->hw,
-					    IEEE80211_IFACE_ITER_RESUME_ALL,
-					    mt7996_update_vif_beacon, phy2->hw);
+	if (phy2)
+		mt7996_mac_update_beacons(phy2->priv);
 
 	phy3 = dev->mt76.phys[MT_BAND2];
-	if (!phy3)
-		return;
-
-	ieee80211_iterate_active_interfaces(phy3->hw,
-					    IEEE80211_IFACE_ITER_RESUME_ALL,
-					    mt7996_update_vif_beacon, phy3->hw);
+	if (phy3)
+		mt7996_mac_update_beacons(phy3->priv);
 }
 
 void mt7996_tx_token_put(struct mt7996_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index f41b2c98bc451..f6590ef85c0d0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -516,6 +516,9 @@ int mt7996_set_channel(struct mt76_phy *mphy)
 	struct mt7996_phy *phy = mphy->priv;
 	int ret;
 
+	if (mphy->offchannel)
+		mt7996_mac_update_beacons(phy);
+
 	ret = mt7996_mcu_set_chan_info(phy, UNI_CHANNEL_SWITCH);
 	if (ret)
 		goto out;
@@ -533,6 +536,8 @@ int mt7996_set_channel(struct mt76_phy *mphy)
 
 	mt7996_mac_reset_counters(phy);
 	phy->noise = 0;
+	if (!mphy->offchannel)
+		mt7996_mac_update_beacons(phy);
 
 out:
 	ieee80211_queue_delayed_work(mphy->hw, &mphy->mac_work,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index dd4b7b8c34ea1..655950276840d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -2755,13 +2755,15 @@ int mt7996_mcu_add_beacon(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			  struct ieee80211_bss_conf *link_conf)
 {
 	struct mt7996_dev *dev = mt7996_hw_dev(hw);
-	struct mt76_vif_link *mlink = mt76_vif_conf_link(&dev->mt76, vif, link_conf);
+	struct mt7996_vif_link *link = mt7996_vif_conf_link(dev, vif, link_conf);
+	struct mt76_vif_link *mlink = link ? &link->mt76 : NULL;
 	struct ieee80211_mutable_offsets offs;
 	struct ieee80211_tx_info *info;
 	struct sk_buff *skb, *rskb;
 	struct tlv *tlv;
 	struct bss_bcn_content_tlv *bcn;
 	int len, extra_len = 0;
+	bool enabled = link_conf->enable_beacon;
 
 	if (link_conf->nontransmitted)
 		return 0;
@@ -2769,13 +2771,16 @@ int mt7996_mcu_add_beacon(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	if (!mlink)
 		return -EINVAL;
 
+	if (link->phy && link->phy->mt76->offchannel)
+		enabled = false;
+
 	rskb = __mt7996_mcu_alloc_bss_req(&dev->mt76, mlink,
 					  MT7996_MAX_BSS_OFFLOAD_SIZE);
 	if (IS_ERR(rskb))
 		return PTR_ERR(rskb);
 
 	skb = ieee80211_beacon_get_template(hw, vif, &offs, link_conf->link_id);
-	if (link_conf->enable_beacon && !skb) {
+	if (enabled && !skb) {
 		dev_kfree_skb(rskb);
 		return -EINVAL;
 	}
@@ -2794,7 +2799,7 @@ int mt7996_mcu_add_beacon(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	len = ALIGN(sizeof(*bcn) + MT_TXD_SIZE + extra_len, 4);
 	tlv = mt7996_mcu_add_uni_tlv(rskb, UNI_BSS_INFO_BCN_CONTENT, len);
 	bcn = (struct bss_bcn_content_tlv *)tlv;
-	bcn->enable = link_conf->enable_beacon;
+	bcn->enable = enabled;
 	if (!bcn->enable)
 		goto out;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index 33ac16b64ef11..8509d508e1e19 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -732,6 +732,7 @@ void mt7996_mac_write_txwi(struct mt7996_dev *dev, __le32 *txwi,
 			   struct sk_buff *skb, struct mt76_wcid *wcid,
 			   struct ieee80211_key_conf *key, int pid,
 			   enum mt76_txq_id qid, u32 changed);
+void mt7996_mac_update_beacons(struct mt7996_phy *phy);
 void mt7996_mac_set_coverage_class(struct mt7996_phy *phy);
 void mt7996_mac_work(struct work_struct *work);
 void mt7996_mac_reset_work(struct work_struct *work);
-- 
2.50.1



