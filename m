Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025762;
	b=2ohyMOLLZBykn00LbSl5SymqUdqDxiD9MVvIvKlRkErHlE00kx/oQdSmmFsTxrV3gwYk
	 k8bKuaZcT9i4VL5RfHWscZ6FlcoIINRseTiepbBBqJ+wrYEyzFPqUX5u7OAy/r2FVU2kX
	 ibssSHCbvuCqfyQgjeX8mMDNNcIMuv8Veu5GWpktUEGkRllBgVwZKB4p+w8cGlVkVuJr+
	 vPUwkVeqkwKfXjfMkm58p1ySJzT+Nn9LpHjoWoAQg8pYSt5fCA8pZ6AcS8T7434+RJjhX
	 Nq+7+wP9lWT946D1eODyuvRnQls6IH6HRcR9hn+zbXozOyZakYf/OUblCBmFTtWqocg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025762;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vkobh+OEq7YGcJO9KTBzWFG0U76KM5q76reJ0lF6ArY=;
	b=3CO3ecBeRUKIAW6dl8/KuaSfPIOv4/To9EdSeJO27QOyBD9wBmyImHB0I3fogf/T8Gs7
	 td11uzzfMnoxe860713muoQKcygLQU1598qn/PVkybESet0Qvdfa/fy7LXCE+55boEmFL
	 wjGoJmNNvJNUQFChCYauRD4uXmbtlX4+TJqz6ch1M/zZBuwX7EV/ho/HdA5GeYyB7pYWQ
	 dDVvN5mspnQnNXzByVmf1IfzjsBuuqE3oIaljwIwIPDxFuIAfyFfbQOZ8fXcTNOqeNsNq
	 8HUSRYAwYcCM7mw4cmj4HYPvNn7ZSZDH0RbPp9YmLU8DtXqbqsGupo7Ov3fTulNZ+vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O3gAwdHh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8D2606A31C;
	Wed, 18 Nov 2026 18:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O3gAwdHh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E2B1F000C4;
	Wed, 18 Nov 2026 18:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025762;
	bh=vkobh+OEq7YGcJO9KTBzWFG0U76KM5q76reJ0lF6ArY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O3gAwdHh+bGqoqHWoxxqR9rZVJ0LZqdobTb892fc+u/qcPSUQX2ljPoSZLBs5nG4g
	 Olq5buwsFBiWs5YexQkUiTbxwl67U5gRlQ2iOuc5lQAVLm/3+uNg/vcPxe81rrcjMF
	 O6z7iASAK0NZdMpLqVux9YXTRzL5tXdlsV/Wvf1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1192/2151] wifi: mt76: send nullfunc PS frames on offchannel transitions
Date: Wed, 18 Nov 2026 15:48:47 +0100
Message-ID: <20261118150205.639970676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 381733b3a14aaef36b421571c1e99856304311f1 ]

Since mt76 uses chanctx, mac80211 does not send nullfunc power save
notifications when the driver goes offchannel for scan or ROC.
Add mt76_offchannel_notify() to send nullfunc PM=1 before going
offchannel and PM=0 after returning, so that the AP can buffer
frames during the absence.

For MLO, iterate all vif links on the phy and set
IEEE80211_TX_CTRL_MLO_LINK so that the driver's tx_prepare_skb
resolves the correct per-link wcid.

Link: https://patch.msgid.link/20260309060730.87840-7-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: 3aaa4871006d ("wifi: mt76: clear offchannel state if a scan has no channel to restore")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/channel.c  | 12 ++-
 drivers/net/wireless/mediatek/mt76/mac80211.c | 99 +++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76.h     |  1 +
 drivers/net/wireless/mediatek/mt76/scan.c     |  7 +-
 4 files changed, 115 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/channel.c b/drivers/net/wireless/mediatek/mt76/channel.c
index 286a98fae760b..5d377ce501787 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -331,8 +331,10 @@ void mt76_roc_complete(struct mt76_phy *phy)
 	if (mlink)
 		mlink->mvif->roc_phy = NULL;
 	if (phy->chanctx && phy->main_chandef.chan && phy->offchannel &&
-	    !test_bit(MT76_MCU_RESET, &dev->phy.state))
+	    !test_bit(MT76_MCU_RESET, &dev->phy.state)) {
 		__mt76_set_channel(phy, &phy->main_chandef, false);
+		mt76_offchannel_notify(phy, false);
+	}
 	mt76_put_vif_phy_link(phy, phy->roc_vif, phy->roc_link);
 	phy->roc_vif = NULL;
 	phy->roc_link = NULL;
@@ -370,6 +372,7 @@ int mt76_remain_on_channel(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct mt76_phy *phy = hw->priv;
 	struct mt76_dev *dev = phy->dev;
 	struct mt76_vif_link *mlink;
+	bool offchannel;
 	int ret = 0;
 
 	phy = dev->band_phys[chan->band];
@@ -395,8 +398,11 @@ int mt76_remain_on_channel(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	mlink->mvif->roc_phy = phy;
 	phy->roc_vif = vif;
 	phy->roc_link = mlink;
-	ret = __mt76_set_channel(phy, &chandef,
-				 mt76_offchannel_chandef(phy, chan, &chandef));
+
+	offchannel = mt76_offchannel_chandef(phy, chan, &chandef);
+	if (offchannel)
+		mt76_offchannel_notify(phy, true);
+	ret = __mt76_set_channel(phy, &chandef, offchannel);
 	if (ret) {
 		mlink->mvif->roc_phy = NULL;
 		phy->roc_vif = NULL;
diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index f44b7dd2a2e10..ae1623215894a 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -2155,3 +2155,102 @@ u16 mt76_select_links(struct ieee80211_vif *vif, int max_active_links)
 	return sel_links;
 }
 EXPORT_SYMBOL_GPL(mt76_select_links);
+
+struct mt76_offchannel_cb_data {
+	struct mt76_phy *phy;
+	bool offchannel;
+};
+
+static void
+mt76_offchannel_send_nullfunc(struct mt76_offchannel_cb_data *data,
+			      struct ieee80211_vif *vif, int link_id)
+{
+	struct mt76_phy *phy = data->phy;
+	struct ieee80211_tx_info *info;
+	struct ieee80211_sta *sta = NULL;
+	struct ieee80211_hdr *hdr;
+	struct mt76_wcid *wcid;
+	struct sk_buff *skb;
+
+	skb = ieee80211_nullfunc_get(phy->hw, vif, link_id, true);
+	if (!skb)
+		return;
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+	if (data->offchannel)
+		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
+
+	skb->priority = 7;
+	skb_set_queue_mapping(skb, IEEE80211_AC_VO);
+
+	if (!ieee80211_tx_prepare_skb(phy->hw, vif, skb,
+				      phy->main_chandef.chan->band,
+				      &sta))
+		return;
+
+	if (sta)
+		wcid = (struct mt76_wcid *)sta->drv_priv;
+	else
+		wcid = ((struct mt76_vif_link *)vif->drv_priv)->wcid;
+
+	if (link_id >= 0) {
+		info = IEEE80211_SKB_CB(skb);
+		info->control.flags &= ~IEEE80211_TX_CTRL_MLO_LINK;
+		info->control.flags |=
+			u32_encode_bits(link_id, IEEE80211_TX_CTRL_MLO_LINK);
+	}
+
+	mt76_tx(phy, sta, wcid, skb);
+}
+
+static void
+mt76_offchannel_notify_iter(void *_data, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct mt76_offchannel_cb_data *data = _data;
+	struct mt76_vif_link *mlink;
+	struct mt76_vif_data *mvif;
+	int link_id;
+
+	if (vif->type != NL80211_IFTYPE_STATION || !vif->cfg.assoc)
+		return;
+
+	mlink = (struct mt76_vif_link *)vif->drv_priv;
+	mvif = mlink->mvif;
+
+	if (!ieee80211_vif_is_mld(vif)) {
+		if (mt76_vif_link_phy(mlink) == data->phy)
+			mt76_offchannel_send_nullfunc(data, vif, -1);
+		return;
+	}
+
+	for (link_id = 0; link_id < IEEE80211_MLD_MAX_NUM_LINKS; link_id++) {
+		if (link_id == mvif->deflink_id)
+			mlink = (struct mt76_vif_link *)vif->drv_priv;
+		else
+			mlink = rcu_dereference(mvif->link[link_id]);
+		if (!mlink)
+			continue;
+		if (mt76_vif_link_phy(mlink) != data->phy)
+			continue;
+
+		mt76_offchannel_send_nullfunc(data, vif, link_id);
+	}
+}
+
+void mt76_offchannel_notify(struct mt76_phy *phy, bool offchannel)
+{
+	struct mt76_offchannel_cb_data data = {
+		.phy = phy,
+		.offchannel = offchannel,
+	};
+
+	if (!phy->num_sta)
+		return;
+
+	local_bh_disable();
+	ieee80211_iterate_active_interfaces_atomic(phy->hw,
+		IEEE80211_IFACE_ITER_NORMAL,
+		mt76_offchannel_notify_iter, &data);
+	local_bh_enable();
+}
+EXPORT_SYMBOL_GPL(mt76_offchannel_notify);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 7de5e5f19a66a..9fb00d33bdff6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -1804,6 +1804,7 @@ struct mt76_vif_link *mt76_get_vif_phy_link(struct mt76_phy *phy,
 					    struct ieee80211_vif *vif);
 void mt76_put_vif_phy_link(struct mt76_phy *phy, struct ieee80211_vif *vif,
 			   struct mt76_vif_link *mlink);
+void mt76_offchannel_notify(struct mt76_phy *phy, bool offchannel);
 
 /* usb */
 static inline bool mt76u_urb_error(struct urb *urb)
diff --git a/drivers/net/wireless/mediatek/mt76/scan.c b/drivers/net/wireless/mediatek/mt76/scan.c
index 69a6b793b1fcc..a8a038737de7a 100644
--- a/drivers/net/wireless/mediatek/mt76/scan.c
+++ b/drivers/net/wireless/mediatek/mt76/scan.c
@@ -17,8 +17,10 @@ static void mt76_scan_complete(struct mt76_dev *dev, bool abort)
 	clear_bit(MT76_SCANNING, &phy->state);
 
 	if (dev->scan.chan && phy->main_chandef.chan && phy->offchannel &&
-	    !test_bit(MT76_MCU_RESET, &dev->phy.state))
+	    !test_bit(MT76_MCU_RESET, &dev->phy.state)) {
 		mt76_set_channel(phy, &phy->main_chandef, false);
+		mt76_offchannel_notify(phy, false);
+	}
 	mt76_put_vif_phy_link(phy, dev->scan.vif, dev->scan.mlink);
 	memset(&dev->scan, 0, sizeof(dev->scan));
 	if (!test_bit(MT76_MCU_RESET, &dev->phy.state))
@@ -138,12 +140,15 @@ void mt76_scan_work(struct work_struct *work)
 	if (dev->scan.chan && phy->num_sta && phy->offchannel) {
 		dev->scan.chan = NULL;
 		mt76_set_channel(phy, &phy->main_chandef, false);
+		mt76_offchannel_notify(phy, false);
 		goto out;
 	}
 
 	dev->scan.chan = req->channels[dev->scan.chan_idx++];
 	offchannel = mt76_offchannel_chandef(phy, dev->scan.chan, &chandef);
 
+	if (offchannel)
+		mt76_offchannel_notify(phy, true);
 	mt76_set_channel(phy, &chandef, offchannel);
 
 	if (!req->n_ssids)
-- 
2.53.0



