Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA57146AA91;
	Tue, 21 Jul 2026 15:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649474; cv=none; b=BRkVEl5OV+OcsAqF/35t19dSs/ZFWjzDKgydPj7tFr8lFPnQn2VU3dIXvKJdIm5uEvKCFkxp5RO3QvdUUz7Cn6FI8waRU8KkBkIFVMMO+u9ZUmFH8EDTXHv3JJnOhSJNXj8iHPSil0znII9VCvY3ZwRi7bKozLbrhsmXyU66BKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649474; c=relaxed/simple;
	bh=l/Sa/WSyzEmS+K8jyjg1GHGzpC+xGoO4SQ9fZBkeHnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=spIrlXVuPKmxMCKBSKBstQW3vMnwcnjZT1pAwxKzn0g/PlmQgR23T95sslwnOYQ4ZRSFJzuqxCQG5v2f6O3GZG8lK323WRX8bHDuyKw2VWP5ofGflYjQq4HHeGY+NArPdOtTh4mGpznW45e43OsiTp9pZDiTMYI9RXHpVor8VLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DAyBsijA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DAyBsijA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6641F000E9;
	Tue, 21 Jul 2026 15:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649471;
	bh=2D8U1HQqJ5q7IsxL8IF8Y2AodVXRY8fmXIrWLlM1trc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DAyBsijA7da3JPrEfOQFsf8RZi/rpYFwHE6no/i1B7+4jQ//jwKTbIzcsz4V+b93U
	 GMQgmFF3DOlwRdR8jg1KvauY1vUfdGJFvo7L0Bt4MjfBAEP64U7O1BSnS30stO0Ssr
	 PfSuEExwZbaV67DubapGFsu6pV+WutGZpYMibz9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0589/2077] wifi: mt76: mt7996: fix reading zeroed info->control.flags after mt76_tx_status_skb_add()
Date: Tue, 21 Jul 2026 17:04:22 +0200
Message-ID: <20260721152606.702690583@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 729c83a3330c0a56662cd0d8e40db96d41c00a54 ]

mt76_tx_status_skb_add() zeroes the mt76_tx_cb struct stored at
info->status.status_driver_data via memset(). Since info->control and
info->status are members of the same union in ieee80211_tx_info,
this overwrites info->control.flags.
In mt7996_tx_prepare_skb(), mt76_tx_status_skb_add() is called before
mt7996_mac_write_txwi(), which re-reads info->control.flags to extract
IEEE80211_TX_CTRL_MLO_LINK. Because the field has been zeroed, the
link_id always resolves to 0 for frames using global_wcid, leading to
incorrect TXWI configuration.
Fix this by passing link_id as an explicit parameter to
mt7996_mac_write_txwi(). In mt7996_tx_prepare_skb(), the link_id is
already extracted from info->control.flags before the destructive
mt76_tx_status_skb_add() call. For the beacon and inband discovery
callers in mcu.c, use link_conf->link_id directly.

Fixes: f0b0b239b8f36 ("wifi: mt76: mt7996: rework mt7996_mac_write_txwi() for MLO support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260531-mt76_tx_status_skb_add-overwrite-fix-v2-1-b73c4b4a9798@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    | 14 ++++----------
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |  5 +++--
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h |  3 ++-
 3 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 7533146b772b35..ffa15f32c250c9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -857,7 +857,8 @@ mt7996_mac_write_txwi_80211(struct mt7996_dev *dev, __le32 *txwi,
 void mt7996_mac_write_txwi(struct mt7996_dev *dev, __le32 *txwi,
 			   struct sk_buff *skb, struct mt76_wcid *wcid,
 			   struct ieee80211_key_conf *key, int pid,
-			   enum mt76_txq_id qid, u32 changed)
+			   enum mt76_txq_id qid, u32 changed,
+			   unsigned int link_id)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -867,7 +868,6 @@ void mt7996_mac_write_txwi(struct mt7996_dev *dev, __le32 *txwi,
 	bool is_8023 = info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP;
 	struct mt76_vif_link *mlink = NULL;
 	struct mt7996_vif *mvif;
-	unsigned int link_id;
 	u16 tx_count = 15;
 	u32 val;
 	bool inband_disc = !!(changed & (BSS_CHANGED_UNSOL_BCAST_PROBE_RESP |
@@ -875,17 +875,11 @@ void mt7996_mac_write_txwi(struct mt7996_dev *dev, __le32 *txwi,
 	bool beacon = !!(changed & (BSS_CHANGED_BEACON |
 				    BSS_CHANGED_BEACON_ENABLED)) && (!inband_disc);
 
-	if (wcid != &dev->mt76.global_wcid)
-		link_id = wcid->link_id;
-	else
-		link_id = u32_get_bits(info->control.flags,
-				       IEEE80211_TX_CTRL_MLO_LINK);
-
 	mvif = vif ? (struct mt7996_vif *)vif->drv_priv : NULL;
 	if (mvif) {
 		if (wcid->offchannel)
 			mlink = rcu_dereference(mvif->mt76.offchannel_link);
-		if (!mlink)
+		if (!mlink && link_id != IEEE80211_LINK_UNSPECIFIED)
 			mlink = rcu_dereference(mvif->mt76.link[link_id]);
 	}
 
@@ -1097,7 +1091,7 @@ int mt7996_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	/* Transmit non qos data by 802.11 header and need to fill txd by host*/
 	if (!is_8023 || pid >= MT_PACKET_ID_FIRST)
 		mt7996_mac_write_txwi(dev, txwi_ptr, tx_info->skb, wcid, key,
-				      pid, qid, 0);
+				      pid, qid, 0, link_id);
 
 	/* MT7996 and MT7992 require driver to provide the MAC TXP for AddBA
 	 * req
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 16420375112d1e..2748bfeb479744 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -3098,7 +3098,7 @@ mt7996_mcu_beacon_cont(struct mt7996_dev *dev,
 
 	buf = (u8 *)bcn + sizeof(*bcn);
 	mt7996_mac_write_txwi(dev, (__le32 *)buf, skb, wcid, NULL, 0, 0,
-			      BSS_CHANGED_BEACON);
+			      BSS_CHANGED_BEACON, link_conf->link_id);
 
 	memcpy(buf + MT_TXD_SIZE, skb->data, skb->len);
 }
@@ -3244,7 +3244,8 @@ int mt7996_mcu_beacon_inband_discov(struct mt7996_dev *dev,
 
 	buf = (u8 *)tlv + sizeof(*discov);
 
-	mt7996_mac_write_txwi(dev, (__le32 *)buf, skb, wcid, NULL, 0, 0, changed);
+	mt7996_mac_write_txwi(dev, (__le32 *)buf, skb, wcid, NULL, 0, 0,
+			      changed, link_conf->link_id);
 
 	memcpy(buf + MT_TXD_SIZE, skb->data, skb->len);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index bdcf7245795497..5f39a583bd3725 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -855,7 +855,8 @@ void mt7996_mac_enable_nf(struct mt7996_dev *dev, u8 band);
 void mt7996_mac_write_txwi(struct mt7996_dev *dev, __le32 *txwi,
 			   struct sk_buff *skb, struct mt76_wcid *wcid,
 			   struct ieee80211_key_conf *key, int pid,
-			   enum mt76_txq_id qid, u32 changed);
+			   enum mt76_txq_id qid, u32 changed,
+			   unsigned int link_id);
 void mt7996_mac_update_beacons(struct mt7996_phy *phy);
 void mt7996_mac_set_coverage_class(struct mt7996_phy *phy);
 void mt7996_mac_work(struct work_struct *work);
-- 
2.53.0



