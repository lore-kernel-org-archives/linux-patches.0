Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A9833B6CC;
	Thu,  2 Jul 2026 16:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010256; cv=none; b=UbuYyvWiqKEdvVsQpl5LZvV3Ft0ptyoq1DtpUj6f6WP5wIQshCa6GRd0o0Hz6T/19eb1qWDTbv92rJQXjNGIOmR5jzgCPpxzEZ2JSX8m1pkAy4NgVT1UaF6SkfG8cKA5VHTR47lDKx2n4zWpBsUeXqWNl+BIDXb6S+5CvAOWTPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010256; c=relaxed/simple;
	bh=DG1cEfaraOMyac4PSPse6TIZh9FQDMG2bOU0vwG2hsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rz+x+OoY7Y46tsfWtY5H0wS3eNjwWP+aut1qOEa+vL8q5k+FjeG//92ys1PNpPQxWrQK9thZMtqdf3U4vfdgaqRhpLLAvS6uqqpL39mt5vkCmmBYeeU4weFHm7rcfClP7eUQwYlpBkPQ6pSo/HnAYu50mziEQt+9rrXBSxOw1u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yw9+7o15; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yw9+7o15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482FD1F000E9;
	Thu,  2 Jul 2026 16:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010253;
	bh=uShvp0Z7lULP4qY8tmtPZVg7jaSi8rzUCj/NaIyuBNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yw9+7o15RwroBuS5Kakaz8fIIihkbRNdz0f2p4Yvvuk42OkOkE4eHDTc7sAyAq+5n
	 oF79vGkiQFHRoKfZwMzBCQg4Pdr9fjR2i/jOYoxP65jBCjk3L7wz/hldFA9I7JUeQ4
	 aj60LCOdg9rOc/bFNABd4xfmMa/C8SqGW6pbmq5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Vosburgh <jv@jvosburgh.net>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Tonghao Zhang <tonghao@bamaicloud.com>,
	Zengbing Tu <tuzengbing@didiglobal.com>,
	Kevin Berry <kpberry@google.com>
Subject: [PATCH 6.12 039/204] net: bonding: add broadcast_neighbor option for 802.3ad
Date: Thu,  2 Jul 2026 18:18:16 +0200
Message-ID: <20260702155119.475177855@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tonghao Zhang <tonghao@bamaicloud.com>

[ Upstream commit ce7a381697cb3958ffe0b45e5028ac69444e9288 ]

Stacking technology is a type of technology used to expand ports on
Ethernet switches. It is widely used as a common access method in
large-scale Internet data center architectures. Years of practice
have proved that stacking technology has advantages and disadvantages
in high-reliability network architecture scenarios. For instance,
in stacking networking arch, conventional switch system upgrades
require multiple stacked devices to restart at the same time.
Therefore, it is inevitable that the business will be interrupted
for a while. It is for this reason that "no-stacking" in data centers
has become a trend. Additionally, when the stacking link connecting
the switches fails or is abnormal, the stack will split. Although it is
not common, it still happens in actual operation. The problem is that
after the split, it is equivalent to two switches with the same
configuration appearing in the network, causing network configuration
conflicts and ultimately interrupting the services carried by the
stacking system.

To improve network stability, "non-stacking" solutions have been
increasingly adopted, particularly by public cloud providers and
tech companies like Alibaba, Tencent, and Didi. "non-stacking" is
a method of mimicing switch stacking that convinces a LACP peer,
bonding in this case, connected to a set of "non-stacked" switches
that all of its ports are connected to a single switch
(i.e., LACP aggregator), as if those switches were stacked. This
enables the LACP peer's ports to aggregate together, and requires
(a) special switch configuration, described in the linked article,
and (b) modifications to the bonding 802.3ad (LACP) mode to send
all ARP/ND packets across all ports of the active aggregator.

Note that, with multiple aggregators, the current broadcast mode
logic will send only packets to the selected aggregator(s).

 +-----------+   +-----------+
 |  switch1  |   |  switch2  |
 +-----------+   +-----------+
         ^           ^
         |           |
      +-----------------+
      |   bond4 lacp    |
      +-----------------+
         |           |
         | NIC1      | NIC2
      +-----------------+
      |     server      |
      +-----------------+

- https://www.ruijie.com/fr-fr/support/tech-gallery/de-stack-data-center-network-architecture/

Cc: Jay Vosburgh <jv@jvosburgh.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Tonghao Zhang <tonghao@bamaicloud.com>
Signed-off-by: Zengbing Tu <tuzengbing@didiglobal.com>
Link: https://patch.msgid.link/84d0a044514157bb856a10b6d03a1028c4883561.1751031306.git.tonghao@bamaicloud.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Kevin Berry <kpberry@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/networking/bonding.rst |    6 +++
 drivers/net/bonding/bond_main.c      |   66 +++++++++++++++++++++++++++++++----
 drivers/net/bonding/bond_options.c   |   42 ++++++++++++++++++++++
 include/net/bond_options.h           |    1 
 include/net/bonding.h                |    3 +
 5 files changed, 112 insertions(+), 6 deletions(-)

--- a/Documentation/networking/bonding.rst
+++ b/Documentation/networking/bonding.rst
@@ -562,6 +562,12 @@ lacp_rate
 
 	The default is slow.
 
+broadcast_neighbor
+
+	Option specifying whether to broadcast ARP/ND packets to all
+	active slaves.  This option has no effect in modes other than
+	802.3ad mode.  The default is off (0).
+
 max_bonds
 
 	Specifies the number of bonding devices to create for this
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -211,6 +211,8 @@ atomic_t netpoll_block_tx = ATOMIC_INIT(
 
 unsigned int bond_net_id __read_mostly;
 
+DEFINE_STATIC_KEY_FALSE(bond_bcast_neigh_enabled);
+
 static const struct flow_dissector_key flow_keys_bonding_keys[] = {
 	{
 		.key_id = FLOW_DISSECTOR_KEY_CONTROL,
@@ -4445,6 +4447,9 @@ static int bond_open(struct net_device *
 
 		bond_for_each_slave(bond, slave, iter)
 			dev_mc_add(slave->dev, lacpdu_mcast_addr);
+
+		if (bond->params.broadcast_neighbor)
+			static_branch_inc(&bond_bcast_neigh_enabled);
 	}
 
 	if (bond_mode_can_use_xmit_hash(bond))
@@ -4468,6 +4473,10 @@ static int bond_close(struct net_device
 	if (bond_is_lb(bond))
 		bond_alb_deinitialize(bond);
 
+	if (BOND_MODE(bond) == BOND_MODE_8023AD &&
+	    bond->params.broadcast_neighbor)
+		static_branch_dec(&bond_bcast_neigh_enabled);
+
 	if (bond_uses_primary(bond)) {
 		rcu_read_lock();
 		slave = rcu_dereference(bond->curr_active_slave);
@@ -5304,6 +5313,37 @@ static struct slave *bond_xdp_xmit_3ad_x
 	return slaves->arr[hash % count];
 }
 
+static bool bond_should_broadcast_neighbor(struct sk_buff *skb,
+					   struct net_device *dev)
+{
+	struct bonding *bond = netdev_priv(dev);
+	struct {
+		struct ipv6hdr ip6;
+		struct icmp6hdr icmp6;
+	} *combined, _combined;
+
+	if (!static_branch_unlikely(&bond_bcast_neigh_enabled))
+		return false;
+
+	if (!bond->params.broadcast_neighbor)
+		return false;
+
+	if (skb->protocol == htons(ETH_P_ARP))
+		return true;
+
+	if (skb->protocol == htons(ETH_P_IPV6)) {
+		combined = skb_header_pointer(skb, skb_mac_header_len(skb),
+					      sizeof(_combined),
+					      &_combined);
+		if (combined && combined->ip6.nexthdr == NEXTHDR_ICMP &&
+		    (combined->icmp6.icmp6_type == NDISC_NEIGHBOUR_SOLICITATION ||
+		     combined->icmp6.icmp6_type == NDISC_NEIGHBOUR_ADVERTISEMENT))
+			return true;
+	}
+
+	return false;
+}
+
 /* Use this Xmit function for 3AD as well as XOR modes. The current
  * usable slave array is formed in the control path. The xmit function
  * just calculates hash and sends the packet out.
@@ -5323,17 +5363,27 @@ static netdev_tx_t bond_3ad_xor_xmit(str
 	return bond_tx_drop(dev, skb);
 }
 
-/* in broadcast mode, we send everything to all usable interfaces. */
+/* in broadcast mode, we send everything to all or usable slave interfaces.
+ * under rcu_read_lock when this function is called.
+ */
 static netdev_tx_t bond_xmit_broadcast(struct sk_buff *skb,
-				       struct net_device *bond_dev)
+				       struct net_device *bond_dev,
+				       bool all_slaves)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
-	struct slave *slave = NULL;
-	struct list_head *iter;
+	struct bond_up_slave *slaves;
 	bool xmit_suc = false;
 	bool skb_used = false;
+	int slaves_count, i;
 
-	bond_for_each_slave_rcu(bond, slave, iter) {
+	if (all_slaves)
+		slaves = rcu_dereference(bond->all_slaves);
+	else
+		slaves = rcu_dereference(bond->usable_slaves);
+
+	slaves_count = slaves ? READ_ONCE(slaves->count) : 0;
+	for (i = 0; i < slaves_count; i++) {
+		struct slave *slave = slaves->arr[i];
 		struct sk_buff *skb2;
 
 		if (!(bond_slave_is_up(slave) && slave->link == BOND_LINK_UP))
@@ -5571,10 +5621,13 @@ static netdev_tx_t __bond_start_xmit(str
 	case BOND_MODE_ACTIVEBACKUP:
 		return bond_xmit_activebackup(skb, dev);
 	case BOND_MODE_8023AD:
+		if (bond_should_broadcast_neighbor(skb, dev))
+			return bond_xmit_broadcast(skb, dev, false);
+		fallthrough;
 	case BOND_MODE_XOR:
 		return bond_3ad_xor_xmit(skb, dev);
 	case BOND_MODE_BROADCAST:
-		return bond_xmit_broadcast(skb, dev);
+		return bond_xmit_broadcast(skb, dev, true);
 	case BOND_MODE_ALB:
 		return bond_alb_xmit(skb, dev);
 	case BOND_MODE_TLB:
@@ -6450,6 +6503,7 @@ static int __init bond_check_params(stru
 	eth_zero_addr(params->ad_actor_system);
 	params->ad_user_port_key = ad_user_port_key;
 	params->coupled_control = 1;
+	params->broadcast_neighbor = 0;
 	if (packets_per_slave > 0) {
 		params->reciprocal_packets_per_slave =
 			reciprocal_value(packets_per_slave);
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -87,6 +87,8 @@ static int bond_option_missed_max_set(st
 				      const struct bond_opt_value *newval);
 static int bond_option_coupled_control_set(struct bonding *bond,
 					   const struct bond_opt_value *newval);
+static int bond_option_broadcast_neigh_set(struct bonding *bond,
+					   const struct bond_opt_value *newval);
 
 static const struct bond_opt_value bond_mode_tbl[] = {
 	{ "balance-rr",    BOND_MODE_ROUNDROBIN,   BOND_VALFLAG_DEFAULT},
@@ -240,6 +242,12 @@ static const struct bond_opt_value bond_
 	{ NULL,  -1, 0},
 };
 
+static const struct bond_opt_value bond_broadcast_neigh_tbl[] = {
+	{ "off", 0, BOND_VALFLAG_DEFAULT},
+	{ "on",	 1, 0},
+	{ NULL,  -1, 0}
+};
+
 static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 	[BOND_OPT_MODE] = {
 		.id = BOND_OPT_MODE,
@@ -513,6 +521,14 @@ static const struct bond_option bond_opt
 		.flags = BOND_OPTFLAG_IFDOWN,
 		.values = bond_coupled_control_tbl,
 		.set = bond_option_coupled_control_set,
+	},
+	[BOND_OPT_BROADCAST_NEIGH] = {
+		.id = BOND_OPT_BROADCAST_NEIGH,
+		.name = "broadcast_neighbor",
+		.desc = "Broadcast neighbor packets to all active slaves",
+		.unsuppmodes = BOND_MODE_ALL_EX(BIT(BOND_MODE_8023AD)),
+		.values = bond_broadcast_neigh_tbl,
+		.set = bond_option_broadcast_neigh_set,
 	}
 };
 
@@ -894,6 +910,13 @@ static int bond_option_mode_set(struct b
 	bond->params.arp_validate = BOND_ARP_VALIDATE_NONE;
 	bond->params.mode = newval->value;
 
+	/* When changing mode, the bond device is down, we may reduce
+	 * the bond_bcast_neigh_enabled in bond_close() if broadcast_neighbor
+	 * enabled in 8023ad mode. Therefore, only clear broadcast_neighbor
+	 * to 0.
+	 */
+	bond->params.broadcast_neighbor = 0;
+
 	if (bond->dev->reg_state == NETREG_REGISTERED) {
 		bool update = false;
 
@@ -1843,3 +1866,22 @@ static int bond_option_coupled_control_s
 	bond->params.coupled_control = newval->value;
 	return 0;
 }
+
+static int bond_option_broadcast_neigh_set(struct bonding *bond,
+					   const struct bond_opt_value *newval)
+{
+	if (bond->params.broadcast_neighbor == newval->value)
+		return 0;
+
+	bond->params.broadcast_neighbor = newval->value;
+	if (bond->dev->flags & IFF_UP) {
+		if (bond->params.broadcast_neighbor)
+			static_branch_inc(&bond_bcast_neigh_enabled);
+		else
+			static_branch_dec(&bond_bcast_neigh_enabled);
+	}
+
+	netdev_dbg(bond->dev, "Setting broadcast_neighbor to %s (%llu)\n",
+		   newval->string, newval->value);
+	return 0;
+}
--- a/include/net/bond_options.h
+++ b/include/net/bond_options.h
@@ -77,6 +77,7 @@ enum {
 	BOND_OPT_NS_TARGETS,
 	BOND_OPT_PRIO,
 	BOND_OPT_COUPLED_CONTROL,
+	BOND_OPT_BROADCAST_NEIGH,
 	BOND_OPT_LAST
 };
 
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -115,6 +115,8 @@ static inline int is_netpoll_tx_blocked(
 #define is_netpoll_tx_blocked(dev) (0)
 #endif
 
+DECLARE_STATIC_KEY_FALSE(bond_bcast_neigh_enabled);
+
 struct bond_params {
 	int mode;
 	int xmit_policy;
@@ -149,6 +151,7 @@ struct bond_params {
 	struct in6_addr ns_targets[BOND_MAX_NS_TARGETS];
 #endif
 	int coupled_control;
+	int broadcast_neighbor;
 
 	/* 2 bytes of padding : see ether_addr_equal_64bits() */
 	u8 ad_actor_system[ETH_ALEN + 2];


