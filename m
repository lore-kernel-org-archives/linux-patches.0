Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2957730BF68;
	Wed, 20 May 2026 17:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297636; cv=none; b=JmT4YDNAeUYyA3wZkDcsq1u6JFC6XAOSLzA0azF3E8DJLNMnZv+exJvLXeJfioeYjAXJC9RcrNLmW7nAgDRL4NObUa8eLO4kVuxstccgsT2soDgeiqjeXOcCjFXGpFYlJ4VhNG/mo/VSRtMI21tfyATHLon0I47HQSg8yFTrcdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297636; c=relaxed/simple;
	bh=rnT0sHK1u/K3Q+8ZNjgkKAyvSWKK5As5t/f6+yYMglk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEhoPDlx7hH561Uiia2s/O2Vu5jMgi1zMmlmOj/QKCdBDYTaoTjyRml+GhWpmif+ITUWx/bLiYIkxAB2Dsn5Uny1t96xUV+d7ECRe1DUyLfAa32YWgLO2gi/8cPKLS8AxYy5w75Z4ppfj50D5ivAgT0qJ9sn3Mi3FXiofks6uis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JU2ziaPP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JU2ziaPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F43F1F00893;
	Wed, 20 May 2026 17:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297635;
	bh=OaY3SPB8CRvbMUUanZeOTMTGSklGUpma5+qIvCYnPNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JU2ziaPPbFyGxLFUOYj/i10TZxoStyM0FD3ACLQvXoGg9SGIYht0AGcT+H/S8GL2z
	 XFx5KhgRKnAd3Xgpyd+9TmzKzAEkRwTYz4B3Uju1JrU5Z76OKFrr1a2cW27LE9LQzB
	 +8H3+8lXhbZziVDBKux3RejXyNVMYbGcDxSth8ZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piotr Kubik <piotr.kubik@adtran.com>,
	Chad Monroe <chad@monroe.io>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 106/957] wifi: mt76: support upgrading passive scans to active
Date: Wed, 20 May 2026 18:09:49 +0200
Message-ID: <20260520162136.860810938@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Chad Monroe <chad@monroe.io>

[ Upstream commit 360552c8592dab3c69e0bbff786b55137f1a81bb ]

On channels with NO_IR or RADAR flags, wait for beacon before sending
probe requests. Allows active scanning and WPS on restricted channels
if another AP is already present.

Fixes: c56d6edebc1f ("wifi: mt76: mt7996: use emulated hardware scan support")
Tested-by: Piotr Kubik <piotr.kubik@adtran.com>
Signed-off-by: Chad Monroe <chad@monroe.io>
Link: https://patch.msgid.link/20251118102723.47997-2-nbd@nbd.name
Link: https://patch.msgid.link/20260309060730.87840-2-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c |  1 +
 drivers/net/wireless/mediatek/mt76/mt76.h     |  4 ++
 .../net/wireless/mediatek/mt76/mt7996/mac.c   |  3 ++
 drivers/net/wireless/mediatek/mt76/scan.c     | 51 +++++++++++++++++--
 4 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 5e75861bf6f99..76eb740428b8d 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -724,6 +724,7 @@ mt76_alloc_device(struct device *pdev, unsigned int size,
 	INIT_LIST_HEAD(&dev->rxwi_cache);
 	dev->token_size = dev->drv->token_size;
 	INIT_DELAYED_WORK(&dev->scan_work, mt76_scan_work);
+	spin_lock_init(&dev->scan_lock);
 
 	for (i = 0; i < ARRAY_SIZE(dev->q_rx); i++)
 		skb_queue_head_init(&dev->rx_skb[i]);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 7753afa3d883d..125ac1eb2d541 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -985,6 +985,7 @@ struct mt76_dev {
 	u32 rxfilter;
 
 	struct delayed_work scan_work;
+	spinlock_t scan_lock;
 	struct {
 		struct cfg80211_scan_request *req;
 		struct ieee80211_channel *chan;
@@ -992,6 +993,8 @@ struct mt76_dev {
 		struct mt76_vif_link *mlink;
 		struct mt76_phy *phy;
 		int chan_idx;
+		bool beacon_wait;
+		bool beacon_received;
 	} scan;
 
 #ifdef CONFIG_NL80211_TESTMODE
@@ -1571,6 +1574,7 @@ int mt76_get_rate(struct mt76_dev *dev,
 int mt76_hw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		 struct ieee80211_scan_request *hw_req);
 void mt76_cancel_hw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
+void mt76_scan_rx_beacon(struct mt76_dev *dev, struct ieee80211_channel *chan);
 void mt76_sw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		  const u8 *mac);
 void mt76_sw_scan_complete(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index dce9f48637927..c375b4dd68a20 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -554,6 +554,9 @@ mt7996_mac_fill_rx(struct mt7996_dev *dev, enum mt76_rxq_id q,
 		qos_ctl = FIELD_GET(MT_RXD10_QOS_CTL, v2);
 		seq_ctrl = FIELD_GET(MT_RXD10_SEQ_CTRL, v2);
 
+		if (ieee80211_is_beacon(fc))
+			mt76_scan_rx_beacon(&dev->mt76, mphy->chandef.chan);
+
 		rxd += 4;
 		if ((u8 *)rxd - skb->data >= skb->len)
 			return -EINVAL;
diff --git a/drivers/net/wireless/mediatek/mt76/scan.c b/drivers/net/wireless/mediatek/mt76/scan.c
index efcf79d9d60e0..6cfca5108bc7e 100644
--- a/drivers/net/wireless/mediatek/mt76/scan.c
+++ b/drivers/net/wireless/mediatek/mt76/scan.c
@@ -27,6 +27,10 @@ static void mt76_scan_complete(struct mt76_dev *dev, bool abort)
 
 void mt76_abort_scan(struct mt76_dev *dev)
 {
+	spin_lock_bh(&dev->scan_lock);
+	dev->scan.beacon_wait = false;
+	spin_unlock_bh(&dev->scan_lock);
+
 	cancel_delayed_work_sync(&dev->scan_work);
 	mt76_scan_complete(dev, true);
 }
@@ -77,6 +81,28 @@ mt76_scan_send_probe(struct mt76_dev *dev, struct cfg80211_ssid *ssid)
 	rcu_read_unlock();
 }
 
+void mt76_scan_rx_beacon(struct mt76_dev *dev, struct ieee80211_channel *chan)
+{
+	struct mt76_phy *phy;
+
+	spin_lock(&dev->scan_lock);
+
+	if (!dev->scan.beacon_wait || dev->scan.beacon_received ||
+	    dev->scan.chan != chan)
+		goto out;
+
+	phy = dev->scan.phy;
+	if (!phy)
+		goto out;
+
+	dev->scan.beacon_received = true;
+	ieee80211_queue_delayed_work(phy->hw, &dev->scan_work, 0);
+
+out:
+	spin_unlock(&dev->scan_lock);
+}
+EXPORT_SYMBOL_GPL(mt76_scan_rx_beacon);
+
 void mt76_scan_work(struct work_struct *work)
 {
 	struct mt76_dev *dev = container_of(work, struct mt76_dev,
@@ -85,9 +111,20 @@ void mt76_scan_work(struct work_struct *work)
 	struct cfg80211_chan_def chandef = {};
 	struct mt76_phy *phy = dev->scan.phy;
 	int duration = HZ / 9; /* ~110 ms */
-	bool offchannel = true;
+	bool beacon_rx, offchannel = true;
 	int i;
 
+	if (!phy || !req)
+		return;
+
+	spin_lock_bh(&dev->scan_lock);
+	beacon_rx = dev->scan.beacon_wait && dev->scan.beacon_received;
+	dev->scan.beacon_wait = false;
+	spin_unlock_bh(&dev->scan_lock);
+
+	if (beacon_rx)
+		goto probe;
+
 	if (dev->scan.chan_idx >= req->n_channels) {
 		mt76_scan_complete(dev, false);
 		return;
@@ -108,10 +145,18 @@ void mt76_scan_work(struct work_struct *work)
 
 	mt76_set_channel(phy, &chandef, offchannel);
 
-	if (!req->n_ssids ||
-	    chandef.chan->flags & (IEEE80211_CHAN_NO_IR | IEEE80211_CHAN_RADAR))
+	if (!req->n_ssids)
 		goto out;
 
+	if (chandef.chan->flags & (IEEE80211_CHAN_NO_IR | IEEE80211_CHAN_RADAR)) {
+		spin_lock_bh(&dev->scan_lock);
+		dev->scan.beacon_received = false;
+		dev->scan.beacon_wait = true;
+		spin_unlock_bh(&dev->scan_lock);
+		goto out;
+	}
+
+probe:
 	if (phy->offchannel)
 		duration = HZ / 16; /* ~60 ms */
 	local_bh_disable();
-- 
2.53.0



