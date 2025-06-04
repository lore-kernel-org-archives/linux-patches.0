Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFAC554739;
	Wed,  4 Jun 2025 01:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748999011; cv=none; b=EM4zhRu7UNtetEH3ETVWYCDw+8MqWsr2eBpf17GLVMpu8+FVX585KeK4p1I9DqlpLG9ffNsetC6PpNew4ERQVa9y4psa++/eRiyOXhIPrBN0PZdWGefXY2DYSYKFlfyeeWBwciKyqxXGsbqKQ1KIp2frEQUycqZKDn+FLm410Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748999011; c=relaxed/simple;
	bh=PxZqQCf0aEMQFz7X4zXItMKtlisNtkMnUgXwOnQ4MlY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AL1etETrm0gehXLBzM5ec6pCRKPTmj6dBgBizqcEfesQkL8drh6pLMOZnI5GNqi3W+FVHmmwsWWYPQWt5fwffJWzEOg6X0jhPren8CuAWvZZeq+B2fHh9l13ONvb4EglXo/OlAduipuZhyCmA2yTBap/WEjkgTqRB55Hkr4X0iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vI7yCDKO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vI7yCDKO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9538BC4CEED;
	Wed,  4 Jun 2025 01:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748999010;
	bh=PxZqQCf0aEMQFz7X4zXItMKtlisNtkMnUgXwOnQ4MlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vI7yCDKOM3EB03XMyJ64dfc1q/Y4C1WFsEzV96fOWehFYPpEBFH5UpfAKxPXBGiN7
	 Qpcu0/lJmjlq11TgK2g5VNgN5RbtOdpm8Y0p0clzLU4W3WDz/ig+pWstTHJXi5ivbq
	 yRcJrpYF8X//IbSP4gHwFsl1ZCdXpUZlPeFC3rY9D1HJWbPpoHpElzDO4qiJZDWF+m
	 k9UvO42XM+g2MdsSY8sn+X1Aq2dv5Xhl0QUZv7BUsbHtnwLsUopS7jeObeE0aTe6Mq
	 fBv7TI4sOf2Hh9np8ofoLIo22yqNLFLjVp2Uxr4nqWb4v6U7NCydS9rtzLJQjrnowB
	 nKjOfyiqnK3yA==
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
Subject: [PATCH AUTOSEL 6.6 44/62] net: bridge: mcast: re-implement br_multicast_{enable, disable}_port functions
Date: Tue,  3 Jun 2025 21:01:55 -0400
Message-Id: <20250604010213.3462-44-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604010213.3462-1-sashal@kernel.org>
References: <20250604010213.3462-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.92
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yong Wang <yongwang@nvidia.com>

[ Upstream commit 4b30ae9adb047dd0a7982975ec3933c529537026 ]

When a bridge port STP state is changed from BLOCKING/DISABLED to
FORWARDING, the port's igmp query timer will NOT re-arm itself if the
bridge has been configured as per-VLAN multicast snooping.

Solve this by choosing the correct multicast context(s) to enable/disable
port multicast based on whether per-VLAN multicast snooping is enabled or
not, i.e. using per-{port, VLAN} context in case of per-VLAN multicast
snooping by re-implementing br_multicast_enable_port() and
br_multicast_disable_port() functions.

Before the patch, the IGMP query does not happen in the last step of the
following test sequence, i.e. no growth for tx counter:
 # ip link add name br1 up type bridge vlan_filtering 1 mcast_snooping 1 mcast_vlan_snooping 1 mcast_querier 1 mcast_stats_enabled 1
 # bridge vlan global set vid 1 dev br1 mcast_snooping 1 mcast_querier 1 mcast_query_interval 100 mcast_startup_query_count 0
 # ip link add name swp1 up master br1 type dummy
 # bridge link set dev swp1 state 0
 # ip -j -p stats show dev swp1 group xstats_slave subgroup bridge suite mcast | jq '.[]["multicast"]["igmp_queries"]["tx_v2"]'
1
 # sleep 1
 # ip -j -p stats show dev swp1 group xstats_slave subgroup bridge suite mcast | jq '.[]["multicast"]["igmp_queries"]["tx_v2"]'
1
 # bridge link set dev swp1 state 3
 # sleep 2
 # ip -j -p stats show dev swp1 group xstats_slave subgroup bridge suite mcast | jq '.[]["multicast"]["igmp_queries"]["tx_v2"]'
1

After the patch, the IGMP query happens in the last step of the test:
 # ip link add name br1 up type bridge vlan_filtering 1 mcast_snooping 1 mcast_vlan_snooping 1 mcast_querier 1 mcast_stats_enabled 1
 # bridge vlan global set vid 1 dev br1 mcast_snooping 1 mcast_querier 1 mcast_query_interval 100 mcast_startup_query_count 0
 # ip link add name swp1 up master br1 type dummy
 # bridge link set dev swp1 state 0
 # ip -j -p stats show dev swp1 group xstats_slave subgroup bridge suite mcast | jq '.[]["multicast"]["igmp_queries"]["tx_v2"]'
1
 # sleep 1
 # ip -j -p stats show dev swp1 group xstats_slave subgroup bridge suite mcast | jq '.[]["multicast"]["igmp_queries"]["tx_v2"]'
1
 # bridge link set dev swp1 state 3
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

Based on my comprehensive analysis, here's my assessment: **YES** ##
Analysis Summary This commit should be backported to stable kernel
trees. Here's my detailed reasoning: ### **What the Bug Fixes** The
commit fixes a critical bug where **IGMP query timers fail to re-arm**
when a bridge port transitions from BLOCKING/DISABLED to FORWARDING
state in **per-VLAN multicast snooping** configurations. ### **Technical
Problem** 1. **Context**: When `BROPT_MCAST_VLAN_SNOOPING_ENABLED` is
active, each VLAN has its own multicast context (`port_mcast_ctx`) with
separate query timers 2. **Bug**: The old implementation in
`br_multicast_enable_port()` and `br_multicast_disable_port()` only
operated on the port's main multicast context (`port->multicast_ctx`) 3.
**Impact**: Per-VLAN multicast contexts were never properly
enabled/disabled during STP state transitions 4. **Result**: IGMP/MLD
query timers for VLANs remain permanently disabled, causing multicast
flooding instead of proper snooping ### **Evidence from Commit** The
commit message provides clear **before/after test results**: -
**Before**: IGMP query count stays at 1 (timer not re-arming) -
**After**: IGMP query count increases to 3 (timer properly re-arming)
This demonstrates the fix works and solves a real, testable problem. ###
**Code Analysis** The fix **re-implements** `br_multicast_enable_port()`
and `br_multicast_disable_port()` to: 1. **Check VLAN snooping status**:
If `BROPT_MCAST_VLAN_SNOOPING_ENABLED` is set 2. **Iterate through
VLANs**: Process each VLAN's multicast context individually 3. **Proper
state handling**: Only enable contexts for VLANs in LEARNING/FORWARDING
states 4. **Fallback behavior**: Use old behavior when VLAN snooping is
disabled ### **Backporting Criteria Met** ✅ **Bug Fix**: Fixes
functional regression in multicast snooping ✅ **Self-contained**:
Changes isolated to bridge multicast code ✅ **No API changes**: Pure
internal refactoring with same public interface ✅ **Production Impact**:
Affects real-world VLAN multicast deployments ✅ **Well-tested**:
Includes specific test case demonstrating the fix ✅ **Minimal Risk**:
Well-reviewed code from experienced maintainers (Nvidia networking team)
### **Stability Impact** - **Risk Level**: Low - internal refactoring
with clear improvement - **Regression Potential**: Very low - maintains
backward compatibility - **User Impact**: High - fixes broken multicast
functionality in VLAN scenarios This is exactly the type of targeted bug
fix that stable trees are designed to include: it fixes a clear
functional regression affecting production deployments while carrying
minimal risk of introducing new issues.

 net/bridge/br_multicast.c | 77 +++++++++++++++++++++++++++++++++++----
 1 file changed, 69 insertions(+), 8 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index ea71a64f915f9..fa16ee88ec396 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -2104,12 +2104,17 @@ static void __br_multicast_enable_port_ctx(struct net_bridge_mcast_port *pmctx)
 	}
 }
 
-void br_multicast_enable_port(struct net_bridge_port *port)
+static void br_multicast_enable_port_ctx(struct net_bridge_mcast_port *pmctx)
 {
-	struct net_bridge *br = port->br;
+	struct net_bridge *br = pmctx->port->br;
 
 	spin_lock_bh(&br->multicast_lock);
-	__br_multicast_enable_port_ctx(&port->multicast_ctx);
+	if (br_multicast_port_ctx_is_vlan(pmctx) &&
+	    !(pmctx->vlan->priv_flags & BR_VLFLAG_MCAST_ENABLED)) {
+		spin_unlock_bh(&br->multicast_lock);
+		return;
+	}
+	__br_multicast_enable_port_ctx(pmctx);
 	spin_unlock_bh(&br->multicast_lock);
 }
 
@@ -2136,11 +2141,67 @@ static void __br_multicast_disable_port_ctx(struct net_bridge_mcast_port *pmctx)
 	br_multicast_rport_del_notify(pmctx, del);
 }
 
+static void br_multicast_disable_port_ctx(struct net_bridge_mcast_port *pmctx)
+{
+	struct net_bridge *br = pmctx->port->br;
+
+	spin_lock_bh(&br->multicast_lock);
+	if (br_multicast_port_ctx_is_vlan(pmctx) &&
+	    !(pmctx->vlan->priv_flags & BR_VLFLAG_MCAST_ENABLED)) {
+		spin_unlock_bh(&br->multicast_lock);
+		return;
+	}
+
+	__br_multicast_disable_port_ctx(pmctx);
+	spin_unlock_bh(&br->multicast_lock);
+}
+
+static void br_multicast_toggle_port(struct net_bridge_port *port, bool on)
+{
+#if IS_ENABLED(CONFIG_BRIDGE_VLAN_FILTERING)
+	if (br_opt_get(port->br, BROPT_MCAST_VLAN_SNOOPING_ENABLED)) {
+		struct net_bridge_vlan_group *vg;
+		struct net_bridge_vlan *vlan;
+
+		rcu_read_lock();
+		vg = nbp_vlan_group_rcu(port);
+		if (!vg) {
+			rcu_read_unlock();
+			return;
+		}
+
+		/* iterate each vlan, toggle vlan multicast context */
+		list_for_each_entry_rcu(vlan, &vg->vlan_list, vlist) {
+			struct net_bridge_mcast_port *pmctx =
+						&vlan->port_mcast_ctx;
+			u8 state = br_vlan_get_state(vlan);
+			/* enable vlan multicast context when state is
+			 * LEARNING or FORWARDING
+			 */
+			if (on && br_vlan_state_allowed(state, true))
+				br_multicast_enable_port_ctx(pmctx);
+			else
+				br_multicast_disable_port_ctx(pmctx);
+		}
+		rcu_read_unlock();
+		return;
+	}
+#endif
+	/* toggle port multicast context when vlan snooping is disabled */
+	if (on)
+		br_multicast_enable_port_ctx(&port->multicast_ctx);
+	else
+		br_multicast_disable_port_ctx(&port->multicast_ctx);
+}
+
+void br_multicast_enable_port(struct net_bridge_port *port)
+{
+	br_multicast_toggle_port(port, true);
+}
+
 void br_multicast_disable_port(struct net_bridge_port *port)
 {
-	spin_lock_bh(&port->br->multicast_lock);
-	__br_multicast_disable_port_ctx(&port->multicast_ctx);
-	spin_unlock_bh(&port->br->multicast_lock);
+	br_multicast_toggle_port(port, false);
 }
 
 static int __grp_src_delete_marked(struct net_bridge_port_group *pg)
@@ -4329,9 +4390,9 @@ int br_multicast_toggle_vlan_snooping(struct net_bridge *br, bool on,
 		__br_multicast_open(&br->multicast_ctx);
 	list_for_each_entry(p, &br->port_list, list) {
 		if (on)
-			br_multicast_disable_port(p);
+			br_multicast_disable_port_ctx(&p->multicast_ctx);
 		else
-			br_multicast_enable_port(p);
+			br_multicast_enable_port_ctx(&p->multicast_ctx);
 	}
 
 	list_for_each_entry(vlan, &vg->vlan_list, vlist)
-- 
2.39.5

