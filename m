Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C734A42188F;
	Wed,  4 Feb 2026 14:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216943; cv=none; b=LAA/ELGrsS4YNbZEldjf2grmN7TwGCqc/LpyoMlIG5/KCz4G4dM4/pU35X6i2YgxCnNp+IUgTK/KgVoRRIV6Y6KBU82HkNIc2YMhp1V59id96YiVzW94nEtFUSLLsMCl1JyaKOQ/dXTPNdt/ig2yQhOlmXXa38KPtmLX9GNDtmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216943; c=relaxed/simple;
	bh=WHVh8Quo9K3HVFArLRWfmLx5f7mq8KF0+Q2NHE0yQVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BIDdCY+a68DVMbDtVFHY7/M4aB9jXhaRIaaPcX9cXS3Jh7jMEFIRPVzQAHuMWQFgq2FKjfwWg4eoLz9lUY1EPS/i11U3Tm2HhJiPMpxz+X8qgpSzA/dVxgqwvu76YPXG47rz4MWEwZSe/4HpEJgTv3k72CUi2/bp2ZlvBj4oWJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KZNm4u2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KZNm4u2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238ECC4CEF7;
	Wed,  4 Feb 2026 14:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216943;
	bh=WHVh8Quo9K3HVFArLRWfmLx5f7mq8KF0+Q2NHE0yQVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZNm4u2tskqWS8K1K53NEdxFSWI05UbwCf1o9cKt8o+hAFjnqHvNfqZR+T6QJeEFt
	 PBXMfWRs1/xIduBaedU3CB7zCq0dTFBssbTdeuEhAGVohKmMP+FdLqrqiQA83t/mrH
	 Pl4gJMpAxsF7Z2FClghS/92sq7dnCzXTjPCytjbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Skorodumov <skorodumov.dmitry@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 078/206] ipvlan: Make the addrs_lock be per port
Date: Wed,  4 Feb 2026 15:38:29 +0100
Message-ID: <20260204143901.021670574@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Skorodumov <dskr99@gmail.com>

[ Upstream commit d3ba32162488283c0a4c5bedd8817aec91748802 ]

Make the addrs_lock be per port, not per ipvlan dev.

Initial code seems to be written in the assumption,
that any address change must occur under RTNL.
But it is not so for the case of IPv6. So

1) Introduce per-port addrs_lock.

2) It was needed to fix places where it was forgotten
to take lock (ipvlan_open/ipvlan_close)

This appears to be a very minor problem though.
Since it's highly unlikely that ipvlan_add_addr() will
be called on 2 CPU simultaneously. But nevertheless,
this could cause:

1) False-negative of ipvlan_addr_busy(): one interface
iterated through all port->ipvlans + ipvlan->addrs
under some ipvlan spinlock, and another added IP
under its own lock. Though this is only possible
for IPv6, since looks like only ipvlan_addr6_event() can be
called without rtnl_lock.

2) Race since ipvlan_ht_addr_add(port) is called under
different ipvlan->addrs_lock locks

This should not affect performance, since add/remove IP
is a rare situation and spinlock is not taken on fast
paths.

Fixes: 8230819494b3 ("ipvlan: use per device spinlock to protect addrs list updates")
Signed-off-by: Dmitry Skorodumov <skorodumov.dmitry@huawei.com>
Reviewed-by: Paolo Abeni <pabeni@redhat.com>
Link: https://patch.msgid.link/20260112142417.4039566-2-skorodumov.dmitry@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipvlan/ipvlan.h      |  2 +-
 drivers/net/ipvlan/ipvlan_core.c | 16 +++++------
 drivers/net/ipvlan/ipvlan_main.c | 49 +++++++++++++++++++-------------
 3 files changed, 37 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ipvlan/ipvlan.h b/drivers/net/ipvlan/ipvlan.h
index 3837c897832ea..befb61e00d07d 100644
--- a/drivers/net/ipvlan/ipvlan.h
+++ b/drivers/net/ipvlan/ipvlan.h
@@ -69,7 +69,6 @@ struct ipvl_dev {
 	DECLARE_BITMAP(mac_filters, IPVLAN_MAC_FILTER_SIZE);
 	netdev_features_t	sfeatures;
 	u32			msg_enable;
-	spinlock_t		addrs_lock;
 };
 
 struct ipvl_addr {
@@ -90,6 +89,7 @@ struct ipvl_port {
 	struct net_device	*dev;
 	possible_net_t		pnet;
 	struct hlist_head	hlhead[IPVLAN_HASH_SIZE];
+	spinlock_t		addrs_lock; /* guards hash-table and addrs */
 	struct list_head	ipvlans;
 	u16			mode;
 	u16			flags;
diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
index 35ec6d1af6ea6..3d8b646c16b71 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -104,17 +104,15 @@ void ipvlan_ht_addr_del(struct ipvl_addr *addr)
 struct ipvl_addr *ipvlan_find_addr(const struct ipvl_dev *ipvlan,
 				   const void *iaddr, bool is_v6)
 {
-	struct ipvl_addr *addr, *ret = NULL;
+	struct ipvl_addr *addr;
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(addr, &ipvlan->addrs, anode) {
-		if (addr_equal(is_v6, addr, iaddr)) {
-			ret = addr;
-			break;
-		}
+	assert_spin_locked(&ipvlan->port->addrs_lock);
+
+	list_for_each_entry(addr, &ipvlan->addrs, anode) {
+		if (addr_equal(is_v6, addr, iaddr))
+			return addr;
 	}
-	rcu_read_unlock();
-	return ret;
+	return NULL;
 }
 
 bool ipvlan_addr_busy(struct ipvl_port *port, void *iaddr, bool is_v6)
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 8660d452f642b..fe4399af8eea7 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -74,6 +74,7 @@ static int ipvlan_port_create(struct net_device *dev)
 	for (idx = 0; idx < IPVLAN_HASH_SIZE; idx++)
 		INIT_HLIST_HEAD(&port->hlhead[idx]);
 
+	spin_lock_init(&port->addrs_lock);
 	skb_queue_head_init(&port->backlog);
 	INIT_WORK(&port->wq, ipvlan_process_multicast);
 	ida_init(&port->ida);
@@ -179,6 +180,7 @@ static void ipvlan_uninit(struct net_device *dev)
 static int ipvlan_open(struct net_device *dev)
 {
 	struct ipvl_dev *ipvlan = netdev_priv(dev);
+	struct ipvl_port *port = ipvlan->port;
 	struct ipvl_addr *addr;
 
 	if (ipvlan->port->mode == IPVLAN_MODE_L3 ||
@@ -187,10 +189,10 @@ static int ipvlan_open(struct net_device *dev)
 	else
 		dev->flags &= ~IFF_NOARP;
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(addr, &ipvlan->addrs, anode)
+	spin_lock_bh(&port->addrs_lock);
+	list_for_each_entry(addr, &ipvlan->addrs, anode)
 		ipvlan_ht_addr_add(ipvlan, addr);
-	rcu_read_unlock();
+	spin_unlock_bh(&port->addrs_lock);
 
 	return 0;
 }
@@ -204,10 +206,10 @@ static int ipvlan_stop(struct net_device *dev)
 	dev_uc_unsync(phy_dev, dev);
 	dev_mc_unsync(phy_dev, dev);
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(addr, &ipvlan->addrs, anode)
+	spin_lock_bh(&ipvlan->port->addrs_lock);
+	list_for_each_entry(addr, &ipvlan->addrs, anode)
 		ipvlan_ht_addr_del(addr);
-	rcu_read_unlock();
+	spin_unlock_bh(&ipvlan->port->addrs_lock);
 
 	return 0;
 }
@@ -574,7 +576,6 @@ int ipvlan_link_new(struct net *src_net, struct net_device *dev,
 	if (!tb[IFLA_MTU])
 		ipvlan_adjust_mtu(ipvlan, phy_dev);
 	INIT_LIST_HEAD(&ipvlan->addrs);
-	spin_lock_init(&ipvlan->addrs_lock);
 
 	/* TODO Probably put random address here to be presented to the
 	 * world but keep using the physical-dev address for the outgoing
@@ -652,13 +653,13 @@ void ipvlan_link_delete(struct net_device *dev, struct list_head *head)
 	struct ipvl_dev *ipvlan = netdev_priv(dev);
 	struct ipvl_addr *addr, *next;
 
-	spin_lock_bh(&ipvlan->addrs_lock);
+	spin_lock_bh(&ipvlan->port->addrs_lock);
 	list_for_each_entry_safe(addr, next, &ipvlan->addrs, anode) {
 		ipvlan_ht_addr_del(addr);
 		list_del_rcu(&addr->anode);
 		kfree_rcu(addr, rcu);
 	}
-	spin_unlock_bh(&ipvlan->addrs_lock);
+	spin_unlock_bh(&ipvlan->port->addrs_lock);
 
 	ida_simple_remove(&ipvlan->port->ida, dev->dev_id);
 	list_del_rcu(&ipvlan->pnode);
@@ -806,6 +807,8 @@ static int ipvlan_add_addr(struct ipvl_dev *ipvlan, void *iaddr, bool is_v6)
 {
 	struct ipvl_addr *addr;
 
+	assert_spin_locked(&ipvlan->port->addrs_lock);
+
 	addr = kzalloc(sizeof(struct ipvl_addr), GFP_ATOMIC);
 	if (!addr)
 		return -ENOMEM;
@@ -836,16 +839,16 @@ static void ipvlan_del_addr(struct ipvl_dev *ipvlan, void *iaddr, bool is_v6)
 {
 	struct ipvl_addr *addr;
 
-	spin_lock_bh(&ipvlan->addrs_lock);
+	spin_lock_bh(&ipvlan->port->addrs_lock);
 	addr = ipvlan_find_addr(ipvlan, iaddr, is_v6);
 	if (!addr) {
-		spin_unlock_bh(&ipvlan->addrs_lock);
+		spin_unlock_bh(&ipvlan->port->addrs_lock);
 		return;
 	}
 
 	ipvlan_ht_addr_del(addr);
 	list_del_rcu(&addr->anode);
-	spin_unlock_bh(&ipvlan->addrs_lock);
+	spin_unlock_bh(&ipvlan->port->addrs_lock);
 	kfree_rcu(addr, rcu);
 }
 
@@ -867,14 +870,14 @@ static int ipvlan_add_addr6(struct ipvl_dev *ipvlan, struct in6_addr *ip6_addr)
 {
 	int ret = -EINVAL;
 
-	spin_lock_bh(&ipvlan->addrs_lock);
+	spin_lock_bh(&ipvlan->port->addrs_lock);
 	if (ipvlan_addr_busy(ipvlan->port, ip6_addr, true))
 		netif_err(ipvlan, ifup, ipvlan->dev,
 			  "Failed to add IPv6=%pI6c addr for %s intf\n",
 			  ip6_addr, ipvlan->dev->name);
 	else
 		ret = ipvlan_add_addr(ipvlan, ip6_addr, true);
-	spin_unlock_bh(&ipvlan->addrs_lock);
+	spin_unlock_bh(&ipvlan->port->addrs_lock);
 	return ret;
 }
 
@@ -913,21 +916,24 @@ static int ipvlan_addr6_validator_event(struct notifier_block *unused,
 	struct in6_validator_info *i6vi = (struct in6_validator_info *)ptr;
 	struct net_device *dev = (struct net_device *)i6vi->i6vi_dev->dev;
 	struct ipvl_dev *ipvlan = netdev_priv(dev);
+	int ret = NOTIFY_OK;
 
 	if (!ipvlan_is_valid_dev(dev))
 		return NOTIFY_DONE;
 
 	switch (event) {
 	case NETDEV_UP:
+		spin_lock_bh(&ipvlan->port->addrs_lock);
 		if (ipvlan_addr_busy(ipvlan->port, &i6vi->i6vi_addr, true)) {
 			NL_SET_ERR_MSG(i6vi->extack,
 				       "Address already assigned to an ipvlan device");
-			return notifier_from_errno(-EADDRINUSE);
+			ret = notifier_from_errno(-EADDRINUSE);
 		}
+		spin_unlock_bh(&ipvlan->port->addrs_lock);
 		break;
 	}
 
-	return NOTIFY_OK;
+	return ret;
 }
 #endif
 
@@ -935,14 +941,14 @@ static int ipvlan_add_addr4(struct ipvl_dev *ipvlan, struct in_addr *ip4_addr)
 {
 	int ret = -EINVAL;
 
-	spin_lock_bh(&ipvlan->addrs_lock);
+	spin_lock_bh(&ipvlan->port->addrs_lock);
 	if (ipvlan_addr_busy(ipvlan->port, ip4_addr, false))
 		netif_err(ipvlan, ifup, ipvlan->dev,
 			  "Failed to add IPv4=%pI4 on %s intf.\n",
 			  ip4_addr, ipvlan->dev->name);
 	else
 		ret = ipvlan_add_addr(ipvlan, ip4_addr, false);
-	spin_unlock_bh(&ipvlan->addrs_lock);
+	spin_unlock_bh(&ipvlan->port->addrs_lock);
 	return ret;
 }
 
@@ -984,21 +990,24 @@ static int ipvlan_addr4_validator_event(struct notifier_block *unused,
 	struct in_validator_info *ivi = (struct in_validator_info *)ptr;
 	struct net_device *dev = (struct net_device *)ivi->ivi_dev->dev;
 	struct ipvl_dev *ipvlan = netdev_priv(dev);
+	int ret = NOTIFY_OK;
 
 	if (!ipvlan_is_valid_dev(dev))
 		return NOTIFY_DONE;
 
 	switch (event) {
 	case NETDEV_UP:
+		spin_lock_bh(&ipvlan->port->addrs_lock);
 		if (ipvlan_addr_busy(ipvlan->port, &ivi->ivi_addr, false)) {
 			NL_SET_ERR_MSG(ivi->extack,
 				       "Address already assigned to an ipvlan device");
-			return notifier_from_errno(-EADDRINUSE);
+			ret = notifier_from_errno(-EADDRINUSE);
 		}
+		spin_unlock_bh(&ipvlan->port->addrs_lock);
 		break;
 	}
 
-	return NOTIFY_OK;
+	return ret;
 }
 
 static struct notifier_block ipvlan_addr4_notifier_block __read_mostly = {
-- 
2.51.0



