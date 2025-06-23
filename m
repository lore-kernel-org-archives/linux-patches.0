Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761741E5B71;
	Mon, 23 Jun 2025 21:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714133; cv=none; b=P1erMIfc8eCDRelleWjwVO8Le40+PweeajgAcmUR5AvJRNQkxn9cGtdQNeA65VcsaVU/AIMgE+NaNvx8PlSJZUSOleNO0X5D2xNe2ZEnXrKQd2QdN2V7p1EgAJcLsDdsypjTgiokJ4XZP96PGfu1/wyOmtXE5+EEnRLgo6Ho5SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714133; c=relaxed/simple;
	bh=Y2aUbctOq4H1U7kYl8BXF3hEPLq6fWd1xYcyypWQmag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Thdn/pxu2/9T0xGiKL48pIJADLwKcO+3UOPQRwiUZH0rRXzXUf652A53wUMvfstw8H6xt0w/e+2NEayKea0VdPQ2EvjoqxVo7d2+DcJro1P7NYmkpSsuyGljk4bmiHdDKYNcT9PyNfDgoEeDmzCugT6y3D+Dfy9FbJRxpXmgUU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ceusHB2l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ceusHB2l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42B4C4CEEA;
	Mon, 23 Jun 2025 21:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714133;
	bh=Y2aUbctOq4H1U7kYl8BXF3hEPLq6fWd1xYcyypWQmag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ceusHB2lEQqAGw8NudxIcOhptosGDa5SQGvNtM3iyyvW4SK+0b0SG2uZ6wuadKbAb
	 0K/nKHOojudDslf9Os17OwQP9Y81qdzwEdyPUBc2Zvej/AKDslTMJBg0RLd2Lnv4bq
	 briUSwUxxdOGIYnwN5H83PMnuzoDt7OlLnFUBuCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong Wang <yongwang@nvidia.com>,
	Andy Roulin <aroulin@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 392/592] net: bridge: mcast: update multicast contex when vlan state is changed
Date: Mon, 23 Jun 2025 15:05:50 +0200
Message-ID: <20250623130709.768612978@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yong Wang <yongwang@nvidia.com>

[ Upstream commit 6c131043eaf1be2a6cc2d228f92ceb626fbcc0f3 ]

When the vlan STP state is changed, which could be manipulated by
"bridge vlan" commands, similar to port STP state, this also impacts
multicast behaviors such as igmp query. In the scenario of per-VLAN
snooping, there's a need to update the corresponding multicast context
to re-arm the port query timer when vlan state becomes "forwarding" etc.

Update br_vlan_set_state() function to enable vlan multicast context
in such scenario.

Before the patch, the IGMP query does not happen in the last step of the
following test sequence, i.e. no growth for tx counter:
 # ip link add name br1 up type bridge vlan_filtering 1 mcast_snooping 1 mcast_vlan_snooping 1 mcast_querier 1 mcast_stats_enabled 1
 # bridge vlan global set vid 1 dev br1 mcast_snooping 1 mcast_querier 1 mcast_query_interval 100 mcast_startup_query_count 0
 # ip link add name swp1 up master br1 type dummy
 # sleep 1
 # bridge vlan set vid 1 dev swp1 state 4
 # ip -j -p stats show dev swp1 group xstats_slave subgroup bridge suite mcast | jq '.[]["multicast"]["igmp_queries"]["tx_v2"]'
1
 # sleep 1
 # ip -j -p stats show dev swp1 group xstats_slave subgroup bridge suite mcast | jq '.[]["multicast"]["igmp_queries"]["tx_v2"]'
1
 # bridge vlan set vid 1 dev swp1 state 3
 # sleep 2
 # ip -j -p stats show dev swp1 group xstats_slave subgroup bridge suite mcast | jq '.[]["multicast"]["igmp_queries"]["tx_v2"]'
1

After the patch, the IGMP query happens in the last step of the test:
 # ip link add name br1 up type bridge vlan_filtering 1 mcast_snooping 1 mcast_vlan_snooping 1 mcast_querier 1 mcast_stats_enabled 1
 # bridge vlan global set vid 1 dev br1 mcast_snooping 1 mcast_querier 1 mcast_query_interval 100 mcast_startup_query_count 0
 # ip link add name swp1 up master br1 type dummy
 # sleep 1
 # bridge vlan set vid 1 dev swp1 state 4
 # ip -j -p stats show dev swp1 group xstats_slave subgroup bridge suite mcast | jq '.[]["multicast"]["igmp_queries"]["tx_v2"]'
1
 # sleep 1
 # ip -j -p stats show dev swp1 group xstats_slave subgroup bridge suite mcast | jq '.[]["multicast"]["igmp_queries"]["tx_v2"]'
1
 # bridge vlan set vid 1 dev swp1 state 3
 # sleep 2
 # ip -j -p stats show dev swp1 group xstats_slave subgroup bridge suite mcast | jq '.[]["multicast"]["igmp_queries"]["tx_v2"]'
3

Signed-off-by: Yong Wang <yongwang@nvidia.com>
Reviewed-by: Andy Roulin <aroulin@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_mst.c       |  4 ++--
 net/bridge/br_multicast.c | 26 ++++++++++++++++++++++++++
 net/bridge/br_private.h   | 11 ++++++++++-
 3 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_mst.c b/net/bridge/br_mst.c
index 1820f09ff59ce..3f24b4ee49c27 100644
--- a/net/bridge/br_mst.c
+++ b/net/bridge/br_mst.c
@@ -80,10 +80,10 @@ static void br_mst_vlan_set_state(struct net_bridge_vlan_group *vg,
 	if (br_vlan_get_state(v) == state)
 		return;
 
-	br_vlan_set_state(v, state);
-
 	if (v->vid == vg->pvid)
 		br_vlan_set_pvid_state(vg, state);
+
+	br_vlan_set_state(v, state);
 }
 
 int br_mst_set_state(struct net_bridge_port *p, u16 msti, u8 state,
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index dcbf058de1e3b..35e1fd4ec82ea 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -4211,6 +4211,32 @@ static void __br_multicast_stop(struct net_bridge_mcast *brmctx)
 #endif
 }
 
+void br_multicast_update_vlan_mcast_ctx(struct net_bridge_vlan *v, u8 state)
+{
+#if IS_ENABLED(CONFIG_BRIDGE_VLAN_FILTERING)
+	struct net_bridge *br;
+
+	if (!br_vlan_should_use(v))
+		return;
+
+	if (br_vlan_is_master(v))
+		return;
+
+	br = v->port->br;
+
+	if (!br_opt_get(br, BROPT_MCAST_VLAN_SNOOPING_ENABLED))
+		return;
+
+	if (br_vlan_state_allowed(state, true))
+		br_multicast_enable_port_ctx(&v->port_mcast_ctx);
+
+	/* Multicast is not disabled for the vlan when it goes in
+	 * blocking state because the timers will expire and stop by
+	 * themselves without sending more queries.
+	 */
+#endif
+}
+
 void br_multicast_toggle_one_vlan(struct net_bridge_vlan *vlan, bool on)
 {
 	struct net_bridge *br;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 4715a8d6dc326..c41d315b09d32 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1052,6 +1052,7 @@ void br_multicast_port_ctx_init(struct net_bridge_port *port,
 				struct net_bridge_vlan *vlan,
 				struct net_bridge_mcast_port *pmctx);
 void br_multicast_port_ctx_deinit(struct net_bridge_mcast_port *pmctx);
+void br_multicast_update_vlan_mcast_ctx(struct net_bridge_vlan *v, u8 state);
 void br_multicast_toggle_one_vlan(struct net_bridge_vlan *vlan, bool on);
 int br_multicast_toggle_vlan_snooping(struct net_bridge *br, bool on,
 				      struct netlink_ext_ack *extack);
@@ -1502,6 +1503,11 @@ static inline void br_multicast_port_ctx_deinit(struct net_bridge_mcast_port *pm
 {
 }
 
+static inline void br_multicast_update_vlan_mcast_ctx(struct net_bridge_vlan *v,
+						      u8 state)
+{
+}
+
 static inline void br_multicast_toggle_one_vlan(struct net_bridge_vlan *vlan,
 						bool on)
 {
@@ -1862,7 +1868,9 @@ bool br_vlan_global_opts_can_enter_range(const struct net_bridge_vlan *v_curr,
 bool br_vlan_global_opts_fill(struct sk_buff *skb, u16 vid, u16 vid_range,
 			      const struct net_bridge_vlan *v_opts);
 
-/* vlan state manipulation helpers using *_ONCE to annotate lock-free access */
+/* vlan state manipulation helpers using *_ONCE to annotate lock-free access,
+ * while br_vlan_set_state() may access data protected by multicast_lock.
+ */
 static inline u8 br_vlan_get_state(const struct net_bridge_vlan *v)
 {
 	return READ_ONCE(v->state);
@@ -1871,6 +1879,7 @@ static inline u8 br_vlan_get_state(const struct net_bridge_vlan *v)
 static inline void br_vlan_set_state(struct net_bridge_vlan *v, u8 state)
 {
 	WRITE_ONCE(v->state, state);
+	br_multicast_update_vlan_mcast_ctx(v, state);
 }
 
 static inline u8 br_vlan_get_pvid_state(const struct net_bridge_vlan_group *vg)
-- 
2.39.5



