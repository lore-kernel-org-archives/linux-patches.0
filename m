Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA556318BB3;
	Sun,  7 Jun 2026 10:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827307; cv=none; b=l63/roBwSywev3/uYK8mxRMfI6i2dUwwTdukhf53SLKwgEIiCde9I2enmK3ATxetdWeuJ2Wbc3GvvsVRnTtkwrqQZvmNjaVkQ5n/KtnZnmTscpefyGoaHY/Z8nZCau2WxxE24JbcgAUMrr7521mPEZVQNDzPT42j/uyAwUEoEnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827307; c=relaxed/simple;
	bh=DYmMbkxT6Gm5TiCAKte1wUImLUhz78bXW8r5L+RRQ4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyJRQ728B7281NKaP8wR416gpgpbMVtuWYaZRsiPmET7C4V3pO694OuFpkMnoaDEyu9gGQaOCHAqwQxepK/2dWY4k8MQjfkxX64LRKMUf3Or3JwDk5opKxOEOOhQkV237VgkQpEmTuI7TeA6RTgYVETFlAS/jx+0SVRysRcZCe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sN37Q6m9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sN37Q6m9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180081F00893;
	Sun,  7 Jun 2026 10:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827306;
	bh=fp1jc6GYO7cJbaKRl9qP7N6WADNF8fCkFpqs/lJQbXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sN37Q6m9HQKqzMJMBp+GL1pSEPBGNsAwwEkf3Je0Qz6UwvpKbtVbztHeGLTr7bOJE
	 DruLMXVzMsT0VQ1h+BfrSAPE6jcQfrHkQvwvwVKs8w9i9gJFiZphjO9L3t+axA7MMh
	 okygfyw+zUnBkXc2DpPkV1u6E6buu76kodqkzomo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <nikolay@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 062/315] bridge: Fix sleep in atomic context in netlink path
Date: Sun,  7 Jun 2026 11:57:29 +0200
Message-ID: <20260607095729.882803021@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 5eec4427b89c2fb2beac54920101e55a2f1c0c21 ]

Since the introduction of the netlink configuration path for bridge
ports in commit 25c71c75ac87 ("bridge: bridge port parameters over
netlink"), br_setport() was always called with the bridge lock held
around it. Back then this decision made sense: The bridge lock protects
the STP state of the bridge and its ports and at that time the function
only processed three STP related netlink attributes (cost, priority and
state).

Nowadays, br_setport() processes a lot more attributes and most of them
do not need the bridge lock:

* Bridge flags: Only require RTNL. Read locklessly by the data path.
  Annotations can be added in net-next.

* FDB port flushing: Only requires the FDB lock.

* Multicast attributes: Only require the multicast lock.

* Group forward mask: Only requires RTNL. Read locklessly by the data
  path. Annotations can be added in net-next.

* Backup port and NHID: Only require RTNL. Read locklessly by the data
  path.

This is a problem as the bridge calls dev_set_promiscuity() when certain
bridge port flags change and this function can sleep since the commit
cited below, resulting in a splat such as [1].

Fix this by reducing the scope of the bridge lock and only take it when
processing the three STP related attributes that require it. This is
consistent with the multicast attributes where each attribute acquires
the multicast lock instead of having one critical section for all
relevant attributes.

[1]
BUG: sleeping function called from invalid context at net/core/dev_addr_lists.c:1262
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 356, name: bridge
preempt_count: 201, expected: 0
RCU nest depth: 0, expected: 0
2 locks held by bridge/356:
#0: ffffffff919473a0 (rtnl_mutex){+.+.}-{4:4}, at: rtnetlink_rcv_msg (net/core/rtnetlink.c:80 net/core/rtnetlink.c:7002)
#1: ffff888115072d58 (&br->lock){+...}-{3:3}, at: br_setlink (./include/linux/spinlock.h:348 net/bridge/br_netlink.c:1117)
Preemption disabled at:
 0x0
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
Call Trace:
<TASK>
dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
__might_resched.cold (kernel/sched/core.c:9163)
netif_rx_mode_run (net/core/dev_addr_lists.c:1262)
netif_rx_mode_sync (net/core/dev_addr_lists.c:1428)
dev_set_promiscuity (net/core/dev_api.c:289)
br_manage_promisc (net/bridge/br_if.c:135 net/bridge/br_if.c:172)
br_port_flags_change (net/bridge/br_if.c:242 net/bridge/br_if.c:747)
br_setport (net/bridge/br_netlink.c:1000)
br_setlink (net/bridge/br_netlink.c:1118)
rtnl_bridge_setlink (net/core/rtnetlink.c:5572)
rtnetlink_rcv_msg (net/core/rtnetlink.c:7005)
netlink_rcv_skb (net/netlink/af_netlink.c:2550)
netlink_unicast (net/netlink/af_netlink.c:1318 net/netlink/af_netlink.c:1344)
netlink_sendmsg (net/netlink/af_netlink.c:1894)
__sock_sendmsg (net/socket.c:787 (discriminator 4) net/socket.c:802 (discriminator 4))
____sys_sendmsg (net/socket.c:2698)
___sys_sendmsg (net/socket.c:2752)
__sys_sendmsg (net/socket.c:2784)
do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)

Fixes: 78cd408356fe ("net: add missing instance lock to dev_set_promiscuity")
Reviewed-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260526064818.272516-2-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_netlink.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 4e2d53b2722104..6d5b2ef5f18d3d 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1000,19 +1000,25 @@ static int br_setport(struct net_bridge_port *p, struct nlattr *tb[],
 	br_port_flags_change(p, changed_mask);
 
 	if (tb[IFLA_BRPORT_COST]) {
+		spin_lock_bh(&p->br->lock);
 		err = br_stp_set_path_cost(p, nla_get_u32(tb[IFLA_BRPORT_COST]));
+		spin_unlock_bh(&p->br->lock);
 		if (err)
 			return err;
 	}
 
 	if (tb[IFLA_BRPORT_PRIORITY]) {
+		spin_lock_bh(&p->br->lock);
 		err = br_stp_set_port_priority(p, nla_get_u16(tb[IFLA_BRPORT_PRIORITY]));
+		spin_unlock_bh(&p->br->lock);
 		if (err)
 			return err;
 	}
 
 	if (tb[IFLA_BRPORT_STATE]) {
+		spin_lock_bh(&p->br->lock);
 		err = br_set_port_state(p, nla_get_u8(tb[IFLA_BRPORT_STATE]));
+		spin_unlock_bh(&p->br->lock);
 		if (err)
 			return err;
 	}
@@ -1114,9 +1120,7 @@ int br_setlink(struct net_device *dev, struct nlmsghdr *nlh, u16 flags,
 			if (err)
 				return err;
 
-			spin_lock_bh(&p->br->lock);
 			err = br_setport(p, tb, extack);
-			spin_unlock_bh(&p->br->lock);
 		} else {
 			/* Binary compatibility with old RSTP */
 			if (nla_len(protinfo) < sizeof(u8))
@@ -1203,17 +1207,10 @@ static int br_port_slave_changelink(struct net_device *brdev,
 				    struct nlattr *data[],
 				    struct netlink_ext_ack *extack)
 {
-	struct net_bridge *br = netdev_priv(brdev);
-	int ret;
-
 	if (!data)
 		return 0;
 
-	spin_lock_bh(&br->lock);
-	ret = br_setport(br_port_get_rtnl(dev), data, extack);
-	spin_unlock_bh(&br->lock);
-
-	return ret;
+	return br_setport(br_port_get_rtnl(dev), data, extack);
 }
 
 static int br_port_fill_slave_info(struct sk_buff *skb,
-- 
2.53.0



