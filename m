Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E14D3546F6;
	Sat, 30 May 2026 17:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162573; cv=none; b=rBYlotDe6HaHXQNqLTRgV0P4jy1j2IWF3T2kCycDIqIOXl3GTVizC81Wkdy5c/SGtzyX04wAJviLot7RrTulw6F7vbyBtzeEvgs3Fo6J/9lGMTCdI4YtFskdeefnMo3qtbXMkcrCSH18etH+9N8H3NSCdo1W+Ra8yBAXZ9Ov4rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162573; c=relaxed/simple;
	bh=5PLQ4OKydXpF82ur+eBeC7Q6IO6KeTXd0R7tuUoHyzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fwuhoSs4jxrdJzMdC1tiAP6hPeuUs2teNF4N2evy6+qfp4DTEKUxxyP1KHOelumKuqLf2UMh+5XX3LdSWPm3PQ44u4paiaoukVeN5m2+s53CVP0sK5154hsTFWgZ8+AgcGYcp8+924bJUkYYvD9HT6ipV/ETjZjIro13xZtLz8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/EsyrA3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/EsyrA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 653181F00893;
	Sat, 30 May 2026 17:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162570;
	bh=OmCBLliS4aZ5V3wIw0zxCmxjvBjuHRPXeh9fHH2Rw1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a/EsyrA3n1l7TsKMaf2peM5yGIV/UP7w8iENJ0pPScPhlXdCJ88Efr8mQ3g+LIx13
	 o6AbeoOJdWe8YpGWR23Q4+dvsV1/gV1NWPmplmscHfkpgPtBe4RRXCgoyExmRl5egL
	 Y11659bqu2eu8x4LeCitiV9WBAbDE6lhVorsqaZ0=
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
Subject: [PATCH 6.1 962/969] bridge: mcast: Fix a possible use-after-free when removing a bridge port
Date: Sat, 30 May 2026 18:08:06 +0200
Message-ID: <20260530160327.336700193@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a58b85d21468e..9b54fe10d280a 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -4468,10 +4468,24 @@ static void br_multicast_start_querier(struct net_bridge_mcast *brmctx,
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
@@ -4479,7 +4493,6 @@ static void br_multicast_del_grps(struct net_bridge *br)
 int br_multicast_toggle(struct net_bridge *br, unsigned long val,
 			struct netlink_ext_ack *extack)
 {
-	struct net_bridge_port *port;
 	bool change_snoopers = false;
 	int err = 0;
 
@@ -4496,7 +4509,7 @@ int br_multicast_toggle(struct net_bridge *br, unsigned long val,
 	br_opt_toggle(br, BROPT_MULTICAST_ENABLED, !!val);
 	if (!br_opt_get(br, BROPT_MULTICAST_ENABLED)) {
 		change_snoopers = true;
-		br_multicast_del_grps(br);
+		br_multicast_disable_all_ports(br);
 		goto unlock;
 	}
 
@@ -4504,8 +4517,7 @@ int br_multicast_toggle(struct net_bridge *br, unsigned long val,
 		goto unlock;
 
 	br_multicast_open(br);
-	list_for_each_entry(port, &br->port_list, list)
-		__br_multicast_enable_port_ctx(&port->multicast_ctx);
+	br_multicast_enable_all_ports(br);
 
 	change_snoopers = true;
 
-- 
2.53.0



