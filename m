Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184C84119FA;
	Wed, 30 Sep 2026 19:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797206; cv=none; b=juK7tLQqY26BttPsJR0s2L1KtnFWQPXvzf7m3ZGVTGCGJDemunsAAGfBB/AJxc5IbNv5/nZ1O+2XHaiqjC+xxoo6tTpqdAcX4xBK2OtDdKZ/zNceo35Fd59S8UqCOXuP7eKxLdPaNqRXkH63nNX9dUbjIlZawUs0RpvV7MxlHjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797206; c=relaxed/simple;
	bh=6nPGATclVZPT+ByLHMmf4w4/y7yCyAfdtxBFyfy5yrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bLasWTdu7Z8Hp0c3xuqc8iMQVGhu28W148L0NMEzWAgONTRowYtajdkoGkNNyDfhi9XlyfiuoQ/FodGGUvg5LFmWia+5fGiT4/d/mEew4tercojr18Z4GiDU686U3eVbBixhk1ygeKueaAXduphld3Ds/T2co+eLyiP4vchazOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PTRbMZyH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PTRbMZyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797F21F00898;
	Wed, 30 Sep 2026 19:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797205;
	bh=NXxWLZXXbpHKDHKgzzO7EFLnVsnJSyZ95x1xLLYsZgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PTRbMZyHpDrC7XzIKzC296k0BS+/zv19U1wr7W/Lrz2PaQXzV9kGv8P8ZXLlQGAgq
	 qwpqyx8zdDx2B2LuB4LFCIDcyWT4VF9r9vUh3pE7fjJRmc/UpPhj+DEzAwV1Nydo2V
	 H8zshXxK9spE2c2Fvh6k2fyP8tedw481jhpJGPOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+09da62a8b78959ceb8bb@syzkaller.appspotmail.com,
	syzbot+cb67c392b0b8f0fd0fc1@syzkaller.appspotmail.com,
	syzbot+9bb8bd77f3966641f298@syzkaller.appspotmail.com,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1182/1193] vlan: defer real device state propagation to netdev_work
Date: Wed, 30 Sep 2026 17:31:06 +0200
Message-ID: <20260930152500.501956937@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit cd1c188db1091991fc1d7f565824d077d659425b ]

vlan_device_event() generates nested UP/DOWN, MTU and feature
change events. It executes an event for the VLAN device directly
from the notifier - while the locks of the lower device are held.

This causes deadlocks, for example:

  bond    (3) bond_update_speed_duplex(vlan)
    |           ^                v
  vlan    (2) UP(vlan)    (4) vlan_ethtool_get_link_ksettings()
    |           ^                v
  dummy   (1) UP(dummy)   (5) __ethtool_get_link_ksettings()

The dummy device is ops locked, vlan creates a nested event (2),
then bond wants to ask vlan for link state (3). bond uses the
"I'm already holding the instance lock" flavor of API. But in
this case the lock held refers to vlan itself. We hit vlan's
link settings trampoline (4) and call __ethtool_get_link_ksettings()
which tries to lock dummy. Deadlock. There's no clean way for us
to tell the vlan_ethtool_get_link_ksettings() that the caller
is already in lower device's critical section.

Defer the propagation to the per-netdev work facility instead:
the notifier only schedules netdev_work_sched(vlandev, VLAN_WORK_*),
and ndo_work (vlan_dev_work) applies the change later. Hopefully
nobody expects the VLAN state changes to be instantaneous.

If someone does expect the changes to be instantaneous we will
have to do the same thing Stan did for rx_mode and "strategically"
place sync calls, to make sure such delayed works are executed
after we drop the ops lock but before we drop rtnl_lock.

Stan suggests that if we need that down the line we may
consider reshaping the mechanism into "async notifications".
AFAICT only vlan does this sort of netdev open chaining,
so as a first try I think that sticking the complexity into
the vlan code makes sense.

One corner case is that we need to cancel the event if user
explicitly changes the state before work could run. Consider
the following operations with vlan0 on top of dummy0:

  ip link set dev dummy0 up    # queues work to up vlan0
  ip link set dev vlan0 down   # user explicitly downs the vlan
  ndo_work                     # acts on the stale event

Reported-by: syzbot+09da62a8b78959ceb8bb@syzkaller.appspotmail.com
Reported-by: syzbot+cb67c392b0b8f0fd0fc1@syzkaller.appspotmail.com
Reported-by: syzbot+9bb8bd77f3966641f298@syzkaller.appspotmail.com
Fixes: 9f275c2e9020 ("net: ethtool: make sure __ethtool_get_link_ksettings() is ops-locked")
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20260624182018.2445732-4-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

[ sashal: Reduced backport -- upstream cd1c188db1091 touches 5 file(s), this
  backport carries 3. Not backported here:
  Documentation/networking/netdevices.rst
  net/core/dev.c
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: 447cbe95ebb9 ("vlan: fix skb_under_panic and races when toggling HW VLAN offload")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/8021q/vlan.c     |   23 -----------------------
 net/8021q/vlan.h     |    2 ++
 net/8021q/vlan_dev.c |   25 ++++++++++++++++++++++++-
 3 files changed, 26 insertions(+), 24 deletions(-)

--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -317,29 +317,6 @@ out:
 	ether_addr_copy(vlan->real_dev_addr, dev->dev_addr);
 }
 
-static void vlan_transfer_features(struct net_device *dev,
-				   struct net_device *vlandev)
-{
-	struct vlan_dev_priv *vlan = vlan_dev_priv(vlandev);
-
-	netif_inherit_tso_max(vlandev, dev);
-
-	if (vlan_hw_offload_capable(dev->features, vlan->vlan_proto))
-		vlandev->hard_header_len = dev->hard_header_len;
-	else
-		vlandev->hard_header_len = dev->hard_header_len + VLAN_HLEN;
-
-#if IS_ENABLED(CONFIG_FCOE)
-	vlandev->fcoe_ddp_xid = dev->fcoe_ddp_xid;
-#endif
-
-	vlandev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
-	vlandev->priv_flags |= (vlan->real_dev->priv_flags & IFF_XMIT_DST_RELEASE);
-	vlandev->hw_enc_features = vlan_tnl_features(vlan->real_dev);
-
-	netdev_update_features(vlandev);
-}
-
 static int __vlan_device_event(struct net_device *dev, unsigned long event)
 {
 	int err = 0;
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -126,6 +126,8 @@ int vlan_filter_push_vids(struct vlan_in
 void vlan_filter_drop_vids(struct vlan_info *vlan_info, __be16 proto);
 
 /* found in vlan_dev.c */
+void vlan_transfer_features(struct net_device *dev,
+			    struct net_device *vlandev);
 void vlan_dev_set_ingress_priority(const struct net_device *dev,
 				   u32 skb_prio, u16 vlan_prio);
 int vlan_dev_set_egress_priority(const struct net_device *dev,
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -541,7 +541,7 @@ static const struct header_ops vlan_pass
 	.parse_protocol = vlan_parse_protocol,
 };
 
-static struct device_type vlan_type = {
+static const struct device_type vlan_type = {
 	.name	= "vlan",
 };
 
@@ -1046,6 +1046,29 @@ static const struct ethtool_ops vlan_eth
 	.get_ts_info		= vlan_ethtool_get_ts_info,
 };
 
+void vlan_transfer_features(struct net_device *dev,
+			    struct net_device *vlandev)
+{
+	struct vlan_dev_priv *vlan = vlan_dev_priv(vlandev);
+
+	netif_inherit_tso_max(vlandev, dev);
+
+	if (vlan_hw_offload_capable(dev->features, vlan->vlan_proto))
+		vlandev->hard_header_len = dev->hard_header_len;
+	else
+		vlandev->hard_header_len = dev->hard_header_len + VLAN_HLEN;
+
+#if IS_ENABLED(CONFIG_FCOE)
+	vlandev->fcoe_ddp_xid = dev->fcoe_ddp_xid;
+#endif
+
+	vlandev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
+	vlandev->priv_flags |= (vlan->real_dev->priv_flags & IFF_XMIT_DST_RELEASE);
+	vlandev->hw_enc_features = vlan_tnl_features(vlan->real_dev);
+
+	netdev_update_features(vlandev);
+}
+
 static const struct net_device_ops vlan_netdev_ops = {
 	.ndo_change_mtu		= vlan_dev_change_mtu,
 	.ndo_init		= vlan_dev_init,


