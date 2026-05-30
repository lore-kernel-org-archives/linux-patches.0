Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5548C17555;
	Sat, 30 May 2026 18:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165174; cv=none; b=sEL2dJYYK684WxdZ92usLIiV2R404rmJz4EYjpc/fLpJX1s66PCPLaIs42n06HM492+r9KfLhVXcGdsd75o1WzGv3G3aK99Xvitk0kW6+l1w715mPC+o7tJHvADE9M2ga0TUKV66QBURjLdfBvOGAz2oFhyOzNWXFNLb33w2qOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165174; c=relaxed/simple;
	bh=kZTJguA1zZbOm3WaBx41IRQb0PopZcvlfZKceKNXFHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BQjOibn4N0nrLdN2+natLAzpWz3131R/7KsHU47zYFyprsXWSkBAtMGOd7AAlYhTvhjFBVtKW5L0e0rBHH3qFp849X7o/TgBNsCKc8wcKfhJkaVTKbkT2lSencfdeMcJq3NqmzZaGN8mrKBDwspHwTjDX+lLI5jrleB4UtU9wgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=npnvnGdX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="npnvnGdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565CC1F00893;
	Sat, 30 May 2026 18:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165173;
	bh=n+LPnXiiTkUZt5fCPDI8P3SpK7ZFT0iC97LNDTmoVfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=npnvnGdXkE62tu+RTL7RM8oJA/gQVrpl/6NsLimE5mtIeXMbBc6eUhjSK8cckv86X
	 e73Ycjv1l2ATEUi6w5lmX7AkBcZl5dTYR62dc1SYSbMXsFse2gc6hLXu54prKX+C+0
	 YxdjdD4Gd22ZjtMpkr5SQl0dQSedMRdKfud5DdWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ae231e0552fa77b26ea1@syzkaller.appspotmail.com,
	Thomas Gleixner <tglx@kernel.org>,
	Nikolay Aleksandrov <nikolay@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 770/776] bridge: mcast: Fix a possible use-after-free when removing a bridge port
Date: Sat, 30 May 2026 18:08:04 +0200
Message-ID: <20260530160259.616711505@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 4df78ff02629c7729168f0696a7a2123c389818d ]

When per-VLAN multicast snooping is enabled, the bridge iterates over
all the bridge ports, disables the per-port multicast context on each
port and enables the per-{port, VLAN} multicast contexts instead. The
reverse happens when per-VLAN multicast snooping is disabled.

When global multicast snooping is enabled, the bridge iterates over all
the bridge ports and enables the per-port multicast context on each
port. The reverse happens when multicast snooping is disabled.

The above scheme can result in a situation where both types of contexts
(per-port and per-{port, VLAN}) are enabled on a single bridge port:

 # ip link add name br1 up type bridge mcast_snooping 1 mcast_querier 1 vlan_filtering 1
 # ip link add name dummy1 up master br1 type dummy
 # ip link set dev br1 type bridge mcast_vlan_snooping 1
 # ip link set dev br1 type bridge mcast_snooping 0
 # ip link set dev br1 type bridge mcast_snooping 1

This is not intended and it is a problem since the commit cited below.
Prior to this commit, when removing a bridge port,
br_multicast_disable_port() would disable the per-port multicast context
and the per-{port, VLAN} multicast contexts would get disabled when
flushing VLANs.

After this commit, br_multicast_disable_port() only disables the
per-port multicast context if per-VLAN multicast snooping is disabled.
If both types of contexts were enabled on the port when it was removed,
the per-port multicast context would remain enabled when freeing the
bridge port, leading to a use-after-free [1].

Fix by preventing the bridge from enabling / disabling the per-port
multicast contexts when toggling global multicast snooping if per-VLAN
multicast snooping is enabled.

[1]
ODEBUG: free active (active state 0) object: ffff88810f8bda78 object type: timer_list hint: br_ip6_multicast_port_query_expired (net/bridge/br_multicast.c:1927)
WARNING: lib/debugobjects.c:629 at debug_print_object+0x1b1/0x3e0, CPU#5: swapper/5/0
[...]
Call Trace:
<IRQ>
__debug_check_no_obj_freed (lib/debugobjects.c:1116)
kfree (mm/slub.c:2620 mm/slub.c:6250 mm/slub.c:6565)
kobject_cleanup (lib/kobject.c:689)
rcu_do_batch (kernel/rcu/tree.c:2617)
rcu_core (kernel/rcu/tree.c:2869)
handle_softirqs (kernel/softirq.c:622)
__irq_exit_rcu (kernel/softirq.c:656 kernel/softirq.c:496 kernel/softirq.c:735)
irq_exit_rcu (kernel/softirq.c:752)
sysvec_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:1061 (discriminator 47) arch/x86/kernel/apic/apic.c:1061 (discriminator 47))
</IRQ>

Fixes: 4b30ae9adb04 ("net: bridge: mcast: re-implement br_multicast_{enable, disable}_port functions")
Reported-by: syzbot+ae231e0552fa77b26ea1@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/87qznowlfs.ffs@tglx/
Reported-by: Thomas Gleixner <tglx@kernel.org>
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260517121122.188333-2-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_multicast.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 38e1efb20aef5..3bd46fb38d5f6 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -4442,10 +4442,24 @@ static void br_multicast_start_querier(struct net_bridge_mcast *brmctx,
 	rcu_read_unlock();
 }
 
-static void br_multicast_del_grps(struct net_bridge *br)
+static void br_multicast_enable_all_ports(struct net_bridge *br)
 {
 	struct net_bridge_port *port;
 
+	if (br_opt_get(br, BROPT_MCAST_VLAN_SNOOPING_ENABLED))
+		return;
+
+	list_for_each_entry(port, &br->port_list, list)
+		__br_multicast_enable_port_ctx(&port->multicast_ctx);
+}
+
+static void br_multicast_disable_all_ports(struct net_bridge *br)
+{
+	struct net_bridge_port *port;
+
+	if (br_opt_get(br, BROPT_MCAST_VLAN_SNOOPING_ENABLED))
+		return;
+
 	list_for_each_entry(port, &br->port_list, list)
 		__br_multicast_disable_port_ctx(&port->multicast_ctx);
 }
@@ -4453,7 +4467,6 @@ static void br_multicast_del_grps(struct net_bridge *br)
 int br_multicast_toggle(struct net_bridge *br, unsigned long val,
 			struct netlink_ext_ack *extack)
 {
-	struct net_bridge_port *port;
 	bool change_snoopers = false;
 	int err = 0;
 
@@ -4470,7 +4483,7 @@ int br_multicast_toggle(struct net_bridge *br, unsigned long val,
 	br_opt_toggle(br, BROPT_MULTICAST_ENABLED, !!val);
 	if (!br_opt_get(br, BROPT_MULTICAST_ENABLED)) {
 		change_snoopers = true;
-		br_multicast_del_grps(br);
+		br_multicast_disable_all_ports(br);
 		goto unlock;
 	}
 
@@ -4478,8 +4491,7 @@ int br_multicast_toggle(struct net_bridge *br, unsigned long val,
 		goto unlock;
 
 	br_multicast_open(br);
-	list_for_each_entry(port, &br->port_list, list)
-		__br_multicast_enable_port_ctx(&port->multicast_ctx);
+	br_multicast_enable_all_ports(br);
 
 	change_snoopers = true;
 
-- 
2.53.0



