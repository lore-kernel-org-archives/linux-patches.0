Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE7E3FB1B;
	Mon, 23 Jun 2025 22:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716211; cv=none; b=s8pc3CVmzVEGKkB0aLC4RgO0BLMKojANLGjVDL74HyOYZym199KEr+H/QOfvGRYxKpyR3wXyv9B/MIiRIts/eGP2LJoBmBDwLmrZwjmw7vwzvJrOTQCXmU9LKEDK7jwr79dMfe2f8kNQDfdMMSnbNboFO4U/Fto+xnHKGx3iCPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716211; c=relaxed/simple;
	bh=JDERcSYk3lvqCErd6sKVVzXZjcgRzeR3v5rJ0FAaU+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVvgA8lR49hLSJs0fEOFx8q88ITL5s44PnSZN1+rbazQueGq4YE2n5Bb6U9UVELmsbtS5/zUMP/5r48CQtHMf269a+Vw2LV9uzxvED1xC2OM/HcOTe07z7Wu5XwFQnQ/I/OyA41cUzqY2r5rpOXM60qmvEfq6QBfeW6LAB5JEH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vahki/B5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vahki/B5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECACBC4CEEA;
	Mon, 23 Jun 2025 22:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716211;
	bh=JDERcSYk3lvqCErd6sKVVzXZjcgRzeR3v5rJ0FAaU+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vahki/B50CoMSEXCTqs/eanABxmTzXKL7Hg1fbuFAnYrcf5hwOn9Be/nf1Y+a7XT1
	 F6XTbwDI1fD9j9vLHrMNV/ysNSFPRW48XA3D+XXtTVZ2rS0+ljfGer9WU+P+kQX1gZ
	 zkjXLZzxoNBUVSr7JHsvNTG+sZwDoutFQ9uo+Vj4=
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
Subject: [PATCH 6.12 257/414] net: bridge: mcast: re-implement br_multicast_{enable, disable}_port functions
Date: Mon, 23 Jun 2025 15:06:34 +0200
Message-ID: <20250623130648.466210427@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 net/bridge/br_multicast.c | 77 +++++++++++++++++++++++++++++++++++----
 1 file changed, 69 insertions(+), 8 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 7a91897ac6e87..733ff6b758f69 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -2105,12 +2105,17 @@ static void __br_multicast_enable_port_ctx(struct net_bridge_mcast_port *pmctx)
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
 
@@ -2137,11 +2142,67 @@ static void __br_multicast_disable_port_ctx(struct net_bridge_mcast_port *pmctx)
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
@@ -4330,9 +4391,9 @@ int br_multicast_toggle_vlan_snooping(struct net_bridge *br, bool on,
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



