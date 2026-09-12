Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A87C3002B3;
	Sat, 12 Sep 2026 10:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209257; cv=none; b=jSxlyMKhfsanHU6fm6M3VK2ZypYc7BaKwk2s22PqIA2mNnoDnXGrp8MMrMFACr8K/Np9UkO2NrxZuk82z3KIXIpR62K3BcFRs/1Tx1Muqct1dPgLQq4QFwZ2i83cQZEw3U7XlM9gRZxzuFWq9pZv2Y5Tmiax+1H2S8X28VF8H44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209257; c=relaxed/simple;
	bh=iLiFDGGkh0E1jDXD0IqRLVUMRDxct+ibD7NSsSIxz1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lt+LZOKjMTtErc6uB8xnPU1rj2Nfy/vVxSwoMGmqyM2+a0cZ+ZRu0j7/jBoavHkxXtZmzGqOGxqwy+scUz+RS005MEoXKuz/GBxAQ27CySSFQeOaTBAFNi6Y94jJ0W3M39KWre9cfbXKJsNrbHVAXvfw4ZRED2G3C4QEKRrrYF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ksxHN9Xs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ksxHN9Xs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24CA91F000FF;
	Sat, 12 Sep 2026 10:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209256;
	bh=dZDk1R7efeCRFF/lmDhTRLKzKHiOeVap3iakPLo15C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ksxHN9XsFREhFrN2oVoLGFmY4VeNeqLty/IWwhA08pjI8PkWA3QYaWpqWoP3X9MNT
	 NO8Xf7fupmXudhX5xsEmteq/pNyW68qW8uCQUh5jZ9/zjUtDAZDjsI9GpkCBX9dLRt
	 4ah2DHIZyGp09vE8iaTRHYDL1jwiXgcc9JnF/97M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chad Monroe <chad@monroe.io>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0741/1518] wifi: mt76: mt7996: fix out-of-bounds array access during hardware restart
Date: Sat, 12 Sep 2026 08:48:30 +0200
Message-ID: <20260912065640.195668456@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 7ec087fef32a88410488b764b0f5eef68e51175f ]

During hardware restart, link_id can be IEEE80211_LINK_UNSPECIFIED,
causing an out-of-bounds array access on msta->link[].

Add mt7996_sta_link() and mt7996_sta_link_protected() helper functions
for accessing sta links with proper RCU handling and bounds checking.
Use them for any sta link RCU access.

Reported-by: Chad Monroe <chad@monroe.io>
Link: https://patch.msgid.link/20260324154904.2555603-1-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: ce35ecffc96e ("wifi: mt76: mt7996: fix MLD ID in MAC TXD and HIF TXP")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/mediatek/mt76/mt7996/debugfs.c   |  4 ++--
 .../net/wireless/mediatek/mt76/mt7996/mac.c   |  6 ++---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 17 +++++++-------
 .../net/wireless/mediatek/mt76/mt7996/mcu.c   | 22 +++++++++----------
 .../wireless/mediatek/mt76/mt7996/mt7996.h    | 19 ++++++++++++++++
 5 files changed, 43 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c
index 0526fa1c26ad2..1d8b8bec8e0e5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c
@@ -645,7 +645,7 @@ mt7996_sta_hw_queue_read(void *data, struct ieee80211_sta *sta)
 		if (!mlink)
 			continue;
 
-		msta_link = rcu_dereference(msta->link[link_id]);
+		msta_link = mt7996_sta_link(msta, link_id);
 		if (!msta_link)
 			continue;
 
@@ -1018,7 +1018,7 @@ static ssize_t mt7996_link_sta_fixed_rate_set(struct file *file,
 
 	mutex_lock(&dev->mt76.mutex);
 
-	msta_link = mt76_dereference(msta->link[link_sta->link_id], &dev->mt76);
+	msta_link = mt7996_sta_link_protected(dev, msta, link_sta->link_id);
 	if (!msta_link) {
 		ret = -EINVAL;
 		goto out;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 60687064f7368..1b695823533d3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -87,7 +87,7 @@ static struct mt76_wcid *mt7996_rx_get_wcid(struct mt7996_dev *dev,
 		if (mlink->band_idx != band_idx)
 			continue;
 
-		msta_link = rcu_dereference(msta->link[i]);
+		msta_link = mt7996_sta_link(msta, i);
 		break;
 	}
 
@@ -1077,7 +1077,7 @@ int mt7996_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	if (link_id != wcid->link_id && link_id != IEEE80211_LINK_UNSPECIFIED) {
 		if (msta) {
 			struct mt7996_sta_link *msta_link =
-				rcu_dereference(msta->link[link_id]);
+				mt7996_sta_link(msta, link_id);
 
 			if (msta_link)
 				wcid = &msta_link->wcid;
@@ -1413,7 +1413,7 @@ mt7996_mac_tx_free(struct mt7996_dev *dev, void *data, int len)
 					 IEEE80211_MLD_MAX_NUM_LINKS) {
 				struct mt7996_sta_link *msta_link;
 
-				msta_link = rcu_dereference(msta->link[id]);
+				msta_link = mt7996_sta_link(msta, id);
 				if (!msta_link)
 					continue;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index d363f9022c4a6..58bc6f30ab772 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -207,8 +207,7 @@ mt7996_set_hw_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		struct mt7996_sta *msta;
 
 		msta = (struct mt7996_sta *)sta->drv_priv;
-		msta_link = mt76_dereference(msta->link[link_id],
-					     &dev->mt76);
+		msta_link = mt7996_sta_link_protected(dev, msta, link_id);
 		if (!msta_link)
 			return 0;
 
@@ -1236,7 +1235,7 @@ mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 		if (!link)
 			continue;
 
-		msta_link = mt76_dereference(msta->link[link_id], &dev->mt76);
+		msta_link = mt7996_sta_link_protected(dev, msta, link_id);
 		if (!msta_link)
 			continue;
 
@@ -1426,7 +1425,7 @@ static void mt7996_tx(struct ieee80211_hw *hw,
 	if (msta) {
 		struct mt7996_sta_link *msta_link;
 
-		msta_link = rcu_dereference(msta->link[link_id]);
+		msta_link = mt7996_sta_link(msta, link_id);
 		if (msta_link)
 			wcid = &msta_link->wcid;
 	}
@@ -1792,7 +1791,7 @@ static void mt7996_link_sta_rc_update(struct ieee80211_hw *hw,
 
 	rcu_read_lock();
 
-	msta_link = rcu_dereference(msta->link[link_sta->link_id]);
+	msta_link = mt7996_sta_link(msta, link_sta->link_id);
 	if (msta_link) {
 		struct mt7996_dev *dev = mt7996_hw_dev(hw);
 
@@ -1813,7 +1812,7 @@ static void mt7996_sta_rate_ctrl_update(void *data, struct ieee80211_sta *sta)
 	if (msta->vif != mvif)
 		return;
 
-	msta_link = rcu_dereference(msta->link[msta->deflink_id]);
+	msta_link = mt7996_sta_link(msta, msta->deflink_id);
 	if (msta_link)
 		mt7996_link_rate_ctrl_update(&changed, msta_link);
 }
@@ -1862,7 +1861,7 @@ static void mt7996_sta_set_4addr(struct ieee80211_hw *hw,
 		if (!link)
 			continue;
 
-		msta_link = mt76_dereference(msta->link[link_id], &dev->mt76);
+		msta_link = mt7996_sta_link_protected(dev, msta, link_id);
 		if (!msta_link)
 			continue;
 
@@ -1900,7 +1899,7 @@ static void mt7996_sta_set_decap_offload(struct ieee80211_hw *hw,
 		if (!link)
 			continue;
 
-		msta_link = mt76_dereference(msta->link[link_id], &dev->mt76);
+		msta_link = mt7996_sta_link_protected(dev, msta, link_id);
 		if (!msta_link)
 			continue;
 
@@ -2242,7 +2241,7 @@ mt7996_net_fill_forward_path(struct ieee80211_hw *hw,
 	if (!mlink)
 		return -EIO;
 
-	msta_link = rcu_dereference(msta->link[msta->deflink_id]);
+	msta_link = mt7996_sta_link(msta, msta->deflink_id);
 	if (!msta_link)
 		return -EIO;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index c591606c1765c..5df5c3a2121f5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -1063,7 +1063,7 @@ mt7996_mcu_bss_basic_tlv(struct sk_buff *skb,
 				struct mt7996_sta_link *msta_link;
 				int link_id = link_conf->link_id;
 
-				msta_link = rcu_dereference(msta->link[link_id]);
+				msta_link = mt7996_sta_link(msta, link_id);
 				if (msta_link)
 					sta_wlan_idx = msta_link->wcid.idx;
 			}
@@ -1255,7 +1255,7 @@ int mt7996_mcu_add_tx_ba(struct mt7996_dev *dev,
 		struct mt7996_sta_link *msta_link;
 		struct mt7996_vif_link *link;
 
-		msta_link = mt76_dereference(msta->link[link_id], &dev->mt76);
+		msta_link = mt7996_sta_link_protected(dev, msta, link_id);
 		if (!msta_link)
 			continue;
 
@@ -1289,7 +1289,7 @@ int mt7996_mcu_add_rx_ba(struct mt7996_dev *dev,
 		struct mt7996_sta_link *msta_link;
 		struct mt7996_vif_link *link;
 
-		msta_link = mt76_dereference(msta->link[link_id], &dev->mt76);
+		msta_link = mt7996_sta_link_protected(dev, msta, link_id);
 		if (!msta_link)
 			continue;
 
@@ -2023,7 +2023,7 @@ int mt7996_mcu_set_fixed_field(struct mt7996_dev *dev, struct mt7996_sta *msta,
 	if (!mlink)
 		goto error_unlock;
 
-	msta_link = rcu_dereference(msta->link[link_id]);
+	msta_link = mt7996_sta_link(msta, link_id);
 	if (!msta_link)
 		goto error_unlock;
 
@@ -2112,7 +2112,7 @@ mt7996_mcu_add_rate_ctrl_fixed(struct mt7996_dev *dev, struct mt7996_sta *msta,
 	if (!link)
 		goto error_unlock;
 
-	msta_link = rcu_dereference(msta->link[link_id]);
+	msta_link = mt7996_sta_link(msta, link_id);
 	if (!msta_link)
 		goto error_unlock;
 
@@ -2319,7 +2319,7 @@ int mt7996_mcu_add_rate_ctrl(struct mt7996_dev *dev, struct mt7996_sta *msta,
 	if (!link)
 		goto error_unlock;
 
-	msta_link = rcu_dereference(msta->link[link_id]);
+	msta_link = mt7996_sta_link(msta, link_id);
 	if (!msta_link)
 		goto error_unlock;
 
@@ -2408,7 +2408,7 @@ mt7996_mcu_sta_mld_setup_tlv(struct mt7996_dev *dev, struct sk_buff *skb,
 	unsigned int link_id;
 	struct tlv *tlv;
 
-	msta_link = mt76_dereference(msta->link[msta->deflink_id], &dev->mt76);
+	msta_link = mt7996_sta_link_protected(dev, msta, msta->deflink_id);
 	if (!msta_link)
 		return;
 
@@ -2422,8 +2422,8 @@ mt7996_mcu_sta_mld_setup_tlv(struct mt7996_dev *dev, struct sk_buff *skb,
 	mld_setup->primary_id = cpu_to_le16(msta_link->wcid.idx);
 
 	if (nlinks > 1) {
-		msta_link = mt76_dereference(msta->link[msta->seclink_id],
-					     &dev->mt76);
+		msta_link = mt7996_sta_link_protected(dev, msta,
+						      msta->seclink_id);
 		if (!msta_link)
 			return;
 	}
@@ -2434,7 +2434,7 @@ mt7996_mcu_sta_mld_setup_tlv(struct mt7996_dev *dev, struct sk_buff *skb,
 	for_each_sta_active_link(vif, sta, link_sta, link_id) {
 		struct mt7996_vif_link *link;
 
-		msta_link = mt76_dereference(msta->link[link_id], &dev->mt76);
+		msta_link = mt7996_sta_link_protected(dev, msta, link_id);
 		if (!msta_link)
 			continue;
 
@@ -2578,7 +2578,7 @@ void mt7996_mcu_update_sta_rec_bw(void *data, struct ieee80211_sta *sta)
 	if (!link_sta)
 		return;
 
-	msta_link = mt76_dereference(msta->link[link_id], &dev->mt76);
+	msta_link = mt7996_sta_link_protected(dev, msta, link_id);
 	if (!msta_link)
 		return;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index 26c04cd08caea..e1af2a2b24bda 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -618,6 +618,25 @@ mt7996_vif_conf_link(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 							    link_conf);
 }
 
+static inline struct mt7996_sta_link *
+mt7996_sta_link(struct mt7996_sta *msta, u8 link_id)
+{
+	if (link_id >= IEEE80211_MLD_MAX_NUM_LINKS)
+		return NULL;
+
+	return rcu_dereference(msta->link[link_id]);
+}
+
+static inline struct mt7996_sta_link *
+mt7996_sta_link_protected(struct mt7996_dev *dev, struct mt7996_sta *msta,
+			  u8 link_id)
+{
+	if (link_id >= IEEE80211_MLD_MAX_NUM_LINKS)
+		return NULL;
+
+	return mt76_dereference(msta->link[link_id], &dev->mt76);
+}
+
 #define mt7996_for_each_phy(dev, phy)					\
 	for (int __i = 0; __i < ARRAY_SIZE((dev)->radio_phy); __i++)	\
 		if (((phy) = (dev)->radio_phy[__i]) != NULL)
-- 
2.53.0



