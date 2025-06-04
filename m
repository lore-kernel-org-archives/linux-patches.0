Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCC986338;
	Wed,  4 Jun 2025 01:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748999106; cv=none; b=gU95c4ndJKxnxJRseOS65uSTKRChc4LqpPfc4vqkP75auiGy6NUch8wCwvPHXJEHs8cO35P2yqi/zIvMed8JT91lNdV5hRwLWh5uwqRGR5bmiGnAVICRpiPTIuF3nj1w71w/zGJ7O/ZYVaWAMXdAqpC5TukV9CDxXtPNDFbSvnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748999106; c=relaxed/simple;
	bh=bKjb3MdHecNid5RytToYoSK2DoVq4NjozOK0DBunt5o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qV7HDRYQHgWTTdveyvs4L6pdG3xSp/fshiYioHvC+YgK1hTK+LEKpIf6CD/NCy9WQWC5WE4z58/QT089MXIT4tTXQ2IP6dVU5pHeZ2b9lxEIP8tiJyhO1H0JykdCX1lSlslwuSeNA1EnG+BcvpjrvFT9ugp6I+sJsbgUk89UZkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NPmMXTPn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NPmMXTPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B651C4CEED;
	Wed,  4 Jun 2025 01:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748999105;
	bh=bKjb3MdHecNid5RytToYoSK2DoVq4NjozOK0DBunt5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NPmMXTPn72Mnt3vNt023M5VL5jWJ3NrSRgV3ofgSET5iw+pSvuKxQu5AbtRJ4DfaR
	 aGS55KiXI9ropMXrVF9O9gzaS+kB6RMLIxMqwzDOgFGaK4WBD3k4p0b2api11u32fd
	 S+PFyZEutY011KMqBAwAVM6oPAvA5mFbM5Cr2rXxBJkrFTZ45r6eMsz1PyjRrmnVfs
	 aTfZJB52AkFvXLfcTR+Wj6H4mfsedd4JWrVaCiTb/1wFNhmjwbsnhA3RPK2KDfl3gQ
	 qajWtQibifB6J3b21QpBPeVMSr6BsmOamJCNoveSbmWPUhDx/21rEOOlhWyXpkjPeN
	 MkeBdloGkCQ+g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yong Wang <yongwang@nvidia.com>,
	Andy Roulin <aroulin@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S . Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 35/46] net: bridge: mcast: update multicast contex when vlan state is changed
Date: Tue,  3 Jun 2025 21:03:53 -0400
Message-Id: <20250604010404.5109-35-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604010404.5109-1-sashal@kernel.org>
References: <20250604010404.5109-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.140
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

**YES** This commit should be backported to stable kernel trees. Here's
my extensive analysis: ## Bug Fix Classification This is clearly a **bug
fix** that resolves broken IGMP query functionality when VLAN states
change. The commit message and test output demonstrate a clear
before/after scenario where IGMP queries fail to increment after VLAN
state transitions to forwarding, then work correctly after the patch. ##
Code Analysis ### 1. Core Issue and Fix The bug occurs because VLAN
state changes weren't properly synchronizing with multicast contexts.
The fix adds a call to `br_multicast_update_vlan_mcast_ctx(v, state)` in
the `br_vlan_set_state()` function: ```c static inline void
br_vlan_set_state(struct net_bridge_vlan *v, u8 state) {
WRITE_ONCE(v->state, state); + br_multicast_update_vlan_mcast_ctx(v,
state); // NEW LINE } ``` ### 2. Low Risk Assessment The changes are
**low risk** because: - **Conservative approach**: The fix reuses
existing, well-tested multicast context update logic - **Targeted
scope**: Only affects VLAN state → multicast context synchronization -
**Built-in safeguards**: The `br_multicast_update_vlan_mcast_ctx()`
function includes multiple safety checks: ```c if
(!br_vlan_should_use(v)) return; if (br_vlan_is_master(v)) return; if
(!br_opt_get(br, BROPT_MCAST_VLAN_SNOOPING_ENABLED)) return; ``` ### 3.
Production Impact This bug affects **critical networking
functionality**: - **Broken multicast in VLAN environments**: IGMP
queries fail when VLANs transition to forwarding state - **Real-world
scenarios**: Common in enterprise networks using VLAN filtering with
multicast applications (video conferencing, IPTV, gaming) - **STP
convergence issues**: After network topology changes, multicast
functionality remains broken until manual intervention ### 4. Minimal
Code Footprint The changes are **minimal and contained**: - **3 files
changed**: All within bridge multicast/VLAN subsystem - **Small
additions**: New function + one-line addition to existing inline
function - **No API changes**: Internal synchronization fix only - **No
architectural changes**: Uses existing code paths and patterns ### 5.
Comparison with Historical Examples Looking at the similar commits
provided: - **Similar to Commit #4 (YES)**: Also fixes a helper function
in bridge multicast VLAN logic with minimal risk - **Unlike Commits
#1-3, #5 (NO)**: Those add new features or make architectural changes,
while this purely fixes broken existing functionality ### 6. Critical
Networking Subsystem Bridge multicast snooping is a **core networking
feature** that: - Prevents multicast flooding in switched networks -
Essential for network performance in multicast-heavy environments -
Widely deployed in production networks ### 7. Test Evidence The commit
message provides concrete test evidence showing: - **Before**: IGMP
query counter remains at 1 (broken) - **After**: IGMP query counter
increases to 3 (working) This demonstrates the fix resolves a
measurable, reproducible issue. ## Conclusion This commit meets all the
criteria for stable backporting: it's a low-risk fix for broken
functionality in a critical networking subsystem, with minimal code
changes and clear test evidence of the problem and solution. The
synchronization issue between VLAN state management and multicast
contexts represents exactly the type of bug that stable trees are
designed to address.

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
index 3cd2b648408d6..5972821ce1950 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -4037,6 +4037,32 @@ static void __br_multicast_stop(struct net_bridge_mcast *brmctx)
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
index 940de95167689..b8fe4e70a45c8 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -976,6 +976,7 @@ void br_multicast_port_ctx_init(struct net_bridge_port *port,
 				struct net_bridge_vlan *vlan,
 				struct net_bridge_mcast_port *pmctx);
 void br_multicast_port_ctx_deinit(struct net_bridge_mcast_port *pmctx);
+void br_multicast_update_vlan_mcast_ctx(struct net_bridge_vlan *v, u8 state);
 void br_multicast_toggle_one_vlan(struct net_bridge_vlan *vlan, bool on);
 int br_multicast_toggle_vlan_snooping(struct net_bridge *br, bool on,
 				      struct netlink_ext_ack *extack);
@@ -1402,6 +1403,11 @@ static inline void br_multicast_port_ctx_deinit(struct net_bridge_mcast_port *pm
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
@@ -1751,7 +1757,9 @@ bool br_vlan_global_opts_can_enter_range(const struct net_bridge_vlan *v_curr,
 bool br_vlan_global_opts_fill(struct sk_buff *skb, u16 vid, u16 vid_range,
 			      const struct net_bridge_vlan *v_opts);
 
-/* vlan state manipulation helpers using *_ONCE to annotate lock-free access */
+/* vlan state manipulation helpers using *_ONCE to annotate lock-free access,
+ * while br_vlan_set_state() may access data protected by multicast_lock.
+ */
 static inline u8 br_vlan_get_state(const struct net_bridge_vlan *v)
 {
 	return READ_ONCE(v->state);
@@ -1760,6 +1768,7 @@ static inline u8 br_vlan_get_state(const struct net_bridge_vlan *v)
 static inline void br_vlan_set_state(struct net_bridge_vlan *v, u8 state)
 {
 	WRITE_ONCE(v->state, state);
+	br_multicast_update_vlan_mcast_ctx(v, state);
 }
 
 static inline u8 br_vlan_get_pvid_state(const struct net_bridge_vlan_group *vg)
-- 
2.39.5

