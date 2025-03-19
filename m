Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1981DE899;
	Wed, 19 Mar 2025 14:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395174; cv=none; b=LX/g/3q3xBq5yE+SGhFuh4D1Twww6UqCP6xPz7XLOtb1/ZGMB7WjErjNZIhTBvxRKDPKBKAk1nOVRF8/3Jamm530q2pcWpzQ3CM2oIRsFmSlc2n8q7T4tCeqmKxptYzmK7vD3WLRJfcbqqSyHRyBhcd4jl5ZuI7W5Ut3wxokdwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395174; c=relaxed/simple;
	bh=oXlRM4Y93X+aoNsRSWqeO08bn7PSXXo+uH3jqo/5oQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XPlnlFkmEwr8bD1cgeAX3xS8OcrXJuWbz6OrjjrA4VvH1dWI2NvqXU22RCoSq1mCN5RjgxLrxwiQnbRRA68vhRLOtA5YShEx0ys/NXEpaenHjxPcOHOl6l14Zo97cdRR96u7v680OxUYyDSzcnMGVE1rL7FF6TsLGDQneD4llb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ds/Xl87J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ds/Xl87J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4539EC4CEE4;
	Wed, 19 Mar 2025 14:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395174;
	bh=oXlRM4Y93X+aoNsRSWqeO08bn7PSXXo+uH3jqo/5oQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ds/Xl87JOWEbEenY87v7VRHivlBYCGxOtWoEo99YFEMEFJd/iSk50A1OlVkGMmXja
	 uRXV0DkrABseNa2cCg5s6rAVWRbzNCFUB+5CUMm8rNS0ta0wd/4QYZriCguatXBVj3
	 VlhvbsAx41l+HV39oJJyY5OMd2eC3RiB73U8sFIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Vosburgh <jv@jvosburgh.net>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/166] bonding: fix incorrect MAC address setting to receive NS messages
Date: Wed, 19 Mar 2025 07:29:57 -0700
Message-ID: <20250319143020.694162060@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 0c5e145a350de3b38cd5ae77a401b12c46fb7c1d ]

When validation on the backup slave is enabled, we need to validate the
Neighbor Solicitation (NS) messages received on the backup slave. To
receive these messages, the correct destination MAC address must be added
to the slave. However, the target in bonding is a unicast address, which
we cannot use directly. Instead, we should first convert it to a
Solicited-Node Multicast Address and then derive the corresponding MAC
address.

Fix the incorrect MAC address setting on both slave_set_ns_maddr() and
slave_set_ns_maddrs(). Since the two function names are similar. Add
some description for the functions. Also only use one mac_addr variable
in slave_set_ns_maddr() to save some code and logic.

Fixes: 8eb36164d1a6 ("bonding: add ns target multicast address to slave device")
Acked-by: Jay Vosburgh <jv@jvosburgh.net>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250306023923.38777-2-liuhangbin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_options.c | 55 +++++++++++++++++++++++++-----
 1 file changed, 47 insertions(+), 8 deletions(-)

diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 8c326e41b8d63..6d003c0ef6698 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -1226,10 +1226,28 @@ static bool slave_can_set_ns_maddr(const struct bonding *bond, struct slave *sla
 	       slave->dev->flags & IFF_MULTICAST;
 }
 
+/**
+ * slave_set_ns_maddrs - add/del all NS mac addresses for slave
+ * @bond: bond device
+ * @slave: slave device
+ * @add: add or remove all the NS mac addresses
+ *
+ * This function tries to add or delete all the NS mac addresses on the slave
+ *
+ * Note, the IPv6 NS target address is the unicast address in Neighbor
+ * Solicitation (NS) message. The dest address of NS message should be
+ * solicited-node multicast address of the target. The dest mac of NS message
+ * is converted from the solicited-node multicast address.
+ *
+ * This function is called when
+ *   * arp_validate changes
+ *   * enslaving, releasing new slaves
+ */
 static void slave_set_ns_maddrs(struct bonding *bond, struct slave *slave, bool add)
 {
 	struct in6_addr *targets = bond->params.ns_targets;
 	char slot_maddr[MAX_ADDR_LEN];
+	struct in6_addr mcaddr;
 	int i;
 
 	if (!slave_can_set_ns_maddr(bond, slave))
@@ -1239,7 +1257,8 @@ static void slave_set_ns_maddrs(struct bonding *bond, struct slave *slave, bool
 		if (ipv6_addr_any(&targets[i]))
 			break;
 
-		if (!ndisc_mc_map(&targets[i], slot_maddr, slave->dev, 0)) {
+		addrconf_addr_solict_mult(&targets[i], &mcaddr);
+		if (!ndisc_mc_map(&mcaddr, slot_maddr, slave->dev, 0)) {
 			if (add)
 				dev_mc_add(slave->dev, slot_maddr);
 			else
@@ -1262,23 +1281,43 @@ void bond_slave_ns_maddrs_del(struct bonding *bond, struct slave *slave)
 	slave_set_ns_maddrs(bond, slave, false);
 }
 
+/**
+ * slave_set_ns_maddr - set new NS mac address for slave
+ * @bond: bond device
+ * @slave: slave device
+ * @target: the new IPv6 target
+ * @slot: the old IPv6 target in the slot
+ *
+ * This function tries to replace the old mac address to new one on the slave.
+ *
+ * Note, the target/slot IPv6 address is the unicast address in Neighbor
+ * Solicitation (NS) message. The dest address of NS message should be
+ * solicited-node multicast address of the target. The dest mac of NS message
+ * is converted from the solicited-node multicast address.
+ *
+ * This function is called when
+ *   * An IPv6 NS target is added or removed.
+ */
 static void slave_set_ns_maddr(struct bonding *bond, struct slave *slave,
 			       struct in6_addr *target, struct in6_addr *slot)
 {
-	char target_maddr[MAX_ADDR_LEN], slot_maddr[MAX_ADDR_LEN];
+	char mac_addr[MAX_ADDR_LEN];
+	struct in6_addr mcast_addr;
 
 	if (!bond->params.arp_validate || !slave_can_set_ns_maddr(bond, slave))
 		return;
 
-	/* remove the previous maddr from slave */
+	/* remove the previous mac addr from slave */
+	addrconf_addr_solict_mult(slot, &mcast_addr);
 	if (!ipv6_addr_any(slot) &&
-	    !ndisc_mc_map(slot, slot_maddr, slave->dev, 0))
-		dev_mc_del(slave->dev, slot_maddr);
+	    !ndisc_mc_map(&mcast_addr, mac_addr, slave->dev, 0))
+		dev_mc_del(slave->dev, mac_addr);
 
-	/* add new maddr on slave if target is set */
+	/* add new mac addr on slave if target is set */
+	addrconf_addr_solict_mult(target, &mcast_addr);
 	if (!ipv6_addr_any(target) &&
-	    !ndisc_mc_map(target, target_maddr, slave->dev, 0))
-		dev_mc_add(slave->dev, target_maddr);
+	    !ndisc_mc_map(&mcast_addr, mac_addr, slave->dev, 0))
+		dev_mc_add(slave->dev, mac_addr);
 }
 
 static void _bond_options_ns_ip6_target_set(struct bonding *bond, int slot,
-- 
2.39.5



