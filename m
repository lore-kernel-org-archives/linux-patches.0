Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FA11A9B2A;
	Wed, 20 Nov 2024 12:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107506; cv=none; b=Xpp/SnLbKJnSXQcVZkJOCGjEpCzTWA0UjmixEy2OEnP0D2mmoBR6wJqeIqUnomUFshY2HA9XL8Zf6ZFT7TkYHCshgDvN7b3sE5FoWo3u/2ZmpWJwAAFAXYHX5d2D7qUjTNw0XAnlEpfpCrRQWMFc0DaQ2iWj3Q+fMcSPgPi9B18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107506; c=relaxed/simple;
	bh=c6pbXdfFwb3eZ7hkr09eiiKIuDKAYc54XUEUcjYkQho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ARG4r/+asyOsfXhzB5wZOPIII5iK3aeEV7zvhOODcyH50xlfuhOOv1irEbtdxy3CKOUzv74MKXrMrF6AMc7M9kn8mCYkn2/lZ8aASuc0SQB53avmNBukNTY70Rin6TcE48FCJFP6ysem0UYGbJWgsqH0ZmQwg4B5BmRrOi5YaT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gwPTHoY/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gwPTHoY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2BFC4CED1;
	Wed, 20 Nov 2024 12:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107506;
	bh=c6pbXdfFwb3eZ7hkr09eiiKIuDKAYc54XUEUcjYkQho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gwPTHoY/noBH7nUI8q7pqt/+M71bnI1Nc80DhSh79c2uGPSsoo92XwaTXh/FBlNR8
	 4wi6uVhqPRAhhVrpOCI58YsFDUhK0VfGlIHRV+d+R5KyzfQLNydyiQ/LgDxV+Fq4v1
	 efjCzPqQlhfpG97RmzrgKKf/cGNfltAhr5cp3NOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 031/107] bonding: add ns target multicast address to slave device
Date: Wed, 20 Nov 2024 13:56:06 +0100
Message-ID: <20241120125630.383034042@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 8eb36164d1a6769a20ed43033510067ff3dab9ee ]

Commit 4598380f9c54 ("bonding: fix ns validation on backup slaves")
tried to resolve the issue where backup slaves couldn't be brought up when
receiving IPv6 Neighbor Solicitation (NS) messages. However, this fix only
worked for drivers that receive all multicast messages, such as the veth
interface.

For standard drivers, the NS multicast message is silently dropped because
the slave device is not a member of the NS target multicast group.

To address this, we need to make the slave device join the NS target
multicast group, ensuring it can receive these IPv6 NS messages to validate
the slave’s status properly.

There are three policies before joining the multicast group:
1. All settings must be under active-backup mode (alb and tlb do not support
   arp_validate), with backup slaves and slaves supporting multicast.
2. We can add or remove multicast groups when arp_validate changes.
3. Other operations, such as enslaving, releasing, or setting NS targets,
   need to be guarded by arp_validate.

Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c    | 16 +++++-
 drivers/net/bonding/bond_options.c | 82 +++++++++++++++++++++++++++++-
 include/net/bond_options.h         |  2 +
 3 files changed, 98 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index e20bee1bdffd7..66725c1632635 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -934,6 +934,8 @@ static void bond_hw_addr_swap(struct bonding *bond, struct slave *new_active,
 
 		if (bond->dev->flags & IFF_UP)
 			bond_hw_addr_flush(bond->dev, old_active->dev);
+
+		bond_slave_ns_maddrs_add(bond, old_active);
 	}
 
 	if (new_active) {
@@ -950,6 +952,8 @@ static void bond_hw_addr_swap(struct bonding *bond, struct slave *new_active,
 			dev_mc_sync(new_active->dev, bond->dev);
 			netif_addr_unlock_bh(bond->dev);
 		}
+
+		bond_slave_ns_maddrs_del(bond, new_active);
 	}
 }
 
@@ -2267,6 +2271,11 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	bond_compute_features(bond);
 	bond_set_carrier(bond);
 
+	/* Needs to be called before bond_select_active_slave(), which will
+	 * remove the maddrs if the slave is selected as active slave.
+	 */
+	bond_slave_ns_maddrs_add(bond, new_slave);
+
 	if (bond_uses_primary(bond)) {
 		block_netpoll_tx();
 		bond_select_active_slave(bond);
@@ -2276,7 +2285,6 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	if (bond_mode_can_use_xmit_hash(bond))
 		bond_update_slave_arr(bond, NULL);
 
-
 	if (!slave_dev->netdev_ops->ndo_bpf ||
 	    !slave_dev->netdev_ops->ndo_xdp_xmit) {
 		if (bond->xdp_prog) {
@@ -2474,6 +2482,12 @@ static int __bond_release_one(struct net_device *bond_dev,
 	if (oldcurrent == slave)
 		bond_change_active_slave(bond, NULL);
 
+	/* Must be called after bond_change_active_slave () as the slave
+	 * might change from an active slave to a backup slave. Then it is
+	 * necessary to clear the maddrs on the backup slave.
+	 */
+	bond_slave_ns_maddrs_del(bond, slave);
+
 	if (bond_is_lb(bond)) {
 		/* Must be called only after the slave has been
 		 * detached from the list and the curr_active_slave
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 95d59a18c0223..327b6ecdc77e0 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -15,6 +15,7 @@
 #include <linux/sched/signal.h>
 
 #include <net/bonding.h>
+#include <net/ndisc.h>
 
 static int bond_option_active_slave_set(struct bonding *bond,
 					const struct bond_opt_value *newval);
@@ -1234,6 +1235,68 @@ static int bond_option_arp_ip_targets_set(struct bonding *bond,
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
+static bool slave_can_set_ns_maddr(const struct bonding *bond, struct slave *slave)
+{
+	return BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP &&
+	       !bond_is_active_slave(slave) &&
+	       slave->dev->flags & IFF_MULTICAST;
+}
+
+static void slave_set_ns_maddrs(struct bonding *bond, struct slave *slave, bool add)
+{
+	struct in6_addr *targets = bond->params.ns_targets;
+	char slot_maddr[MAX_ADDR_LEN];
+	int i;
+
+	if (!slave_can_set_ns_maddr(bond, slave))
+		return;
+
+	for (i = 0; i < BOND_MAX_NS_TARGETS; i++) {
+		if (ipv6_addr_any(&targets[i]))
+			break;
+
+		if (!ndisc_mc_map(&targets[i], slot_maddr, slave->dev, 0)) {
+			if (add)
+				dev_mc_add(slave->dev, slot_maddr);
+			else
+				dev_mc_del(slave->dev, slot_maddr);
+		}
+	}
+}
+
+void bond_slave_ns_maddrs_add(struct bonding *bond, struct slave *slave)
+{
+	if (!bond->params.arp_validate)
+		return;
+	slave_set_ns_maddrs(bond, slave, true);
+}
+
+void bond_slave_ns_maddrs_del(struct bonding *bond, struct slave *slave)
+{
+	if (!bond->params.arp_validate)
+		return;
+	slave_set_ns_maddrs(bond, slave, false);
+}
+
+static void slave_set_ns_maddr(struct bonding *bond, struct slave *slave,
+			       struct in6_addr *target, struct in6_addr *slot)
+{
+	char target_maddr[MAX_ADDR_LEN], slot_maddr[MAX_ADDR_LEN];
+
+	if (!bond->params.arp_validate || !slave_can_set_ns_maddr(bond, slave))
+		return;
+
+	/* remove the previous maddr from slave */
+	if (!ipv6_addr_any(slot) &&
+	    !ndisc_mc_map(slot, slot_maddr, slave->dev, 0))
+		dev_mc_del(slave->dev, slot_maddr);
+
+	/* add new maddr on slave if target is set */
+	if (!ipv6_addr_any(target) &&
+	    !ndisc_mc_map(target, target_maddr, slave->dev, 0))
+		dev_mc_add(slave->dev, target_maddr);
+}
+
 static void _bond_options_ns_ip6_target_set(struct bonding *bond, int slot,
 					    struct in6_addr *target,
 					    unsigned long last_rx)
@@ -1243,8 +1306,10 @@ static void _bond_options_ns_ip6_target_set(struct bonding *bond, int slot,
 	struct slave *slave;
 
 	if (slot >= 0 && slot < BOND_MAX_NS_TARGETS) {
-		bond_for_each_slave(bond, slave, iter)
+		bond_for_each_slave(bond, slave, iter) {
 			slave->target_last_arp_rx[slot] = last_rx;
+			slave_set_ns_maddr(bond, slave, target, &targets[slot]);
+		}
 		targets[slot] = *target;
 	}
 }
@@ -1296,15 +1361,30 @@ static int bond_option_ns_ip6_targets_set(struct bonding *bond,
 {
 	return -EPERM;
 }
+
+static void slave_set_ns_maddrs(struct bonding *bond, struct slave *slave, bool add) {}
+
+void bond_slave_ns_maddrs_add(struct bonding *bond, struct slave *slave) {}
+
+void bond_slave_ns_maddrs_del(struct bonding *bond, struct slave *slave) {}
 #endif
 
 static int bond_option_arp_validate_set(struct bonding *bond,
 					const struct bond_opt_value *newval)
 {
+	bool changed = !!bond->params.arp_validate != !!newval->value;
+	struct list_head *iter;
+	struct slave *slave;
+
 	netdev_dbg(bond->dev, "Setting arp_validate to %s (%llu)\n",
 		   newval->string, newval->value);
 	bond->params.arp_validate = newval->value;
 
+	if (changed) {
+		bond_for_each_slave(bond, slave, iter)
+			slave_set_ns_maddrs(bond, slave, !!bond->params.arp_validate);
+	}
+
 	return 0;
 }
 
diff --git a/include/net/bond_options.h b/include/net/bond_options.h
index 473a0147769eb..18687ccf06383 100644
--- a/include/net/bond_options.h
+++ b/include/net/bond_options.h
@@ -161,5 +161,7 @@ void bond_option_arp_ip_targets_clear(struct bonding *bond);
 #if IS_ENABLED(CONFIG_IPV6)
 void bond_option_ns_ip6_targets_clear(struct bonding *bond);
 #endif
+void bond_slave_ns_maddrs_add(struct bonding *bond, struct slave *slave);
+void bond_slave_ns_maddrs_del(struct bonding *bond, struct slave *slave);
 
 #endif /* _NET_BOND_OPTIONS_H */
-- 
2.43.0



