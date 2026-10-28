Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211938;
	b=eLxCsg2MB1tHYsEMI4Ey44gIW/kxTbmeO9ejhkQ0wXbTfk41dVKMgXbDm8yKIA86Geuf
	 JREeow1Mw0a5d5IPYYjzgBuyhYvduzWRLpONsXl2nRFi2wb2kmAMLTvnfg6kmQIJm7+2F
	 aGlCi0CFJxAYbBbHlSkdblbk17TU4I0DV6KDk4yYe2vzxy8EpUEzyxQu9qrCM3H6uF2Oc
	 HVedT+Bw61LEKI+vTH1Vh2OAkBWXNNpJleoYDAZe+h6dXvcLQVfgZxe4RPE0JQaQPCPDg
	 KTVrvVg/kTywie0TzYPsQNk+JClFKazJ0mFI07PFtuxx3pur9lDXakbzGf3qIBqJiGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211938;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e0NaAZiigYZQcCV84NDHCQN7MZ9sBji++2VJd2vOAbc=;
	b=uTeL978YUb5fw4bkYcWZAbdhPK7P6dK+6BVSorF5zm2BE4PkXFJJmicuf4GlrJa0jPrl
	 +4SHQPOZRbC/Cw9mEdNrw/eMzPw2ExarZhEAeXsY8sWgZUKzTaZxFH7FZFdXIF1o75bpI
	 ELw6tpMqQEfwfpyVcUhwIeHOHkH1GQjPZe9RgWxulm9hlg4S28kSq630M5hWgnt9yDwbF
	 x4IvxPcI96yvVtSVT6NPaUTTHEO3XkDNC0WSkKv0OF6EA/6oway36iw1cTQamD6G+/NrH
	 VY6xV8txZKYs2W7sVVsrqAR64X8GFCD1RRhhabCn9kYSPejMkts35+6kV9w8m8I1PqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f26q03xt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2915606A31C;
	Wed, 28 Oct 2026 18:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f26q03xt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F38F1F01825;
	Wed, 28 Oct 2026 18:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211937;
	bh=e0NaAZiigYZQcCV84NDHCQN7MZ9sBji++2VJd2vOAbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f26q03xt3Ev6aUdzYjFlXPP540aAmyUD6sS4fBBhBu9/Besd8YZAlzMAFcOsEcuZP
	 30G2h4MBpJ5bsp/2VJhJuNV7899lHhFqC/ofEpOJqEJ8AADXMuTcNwpC8iJDczotWI
	 r/aDTAwCmt/FDf6T/NI9xOUZHnxjzpxnECOyOsuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Paolo Abeni <pabeni@redhat.com>,
	Steffen Pfendtner <steffen.pfendtner@kernelscan.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 551/571] net: bonding: fix use-after-free in bond_xmit_broadcast()
Date: Wed, 28 Oct 2026 18:01:38 +0100
Message-ID: <20261028170021.110901331@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 2884bf72fb8f03409e423397319205de48adca16 ]

bond_xmit_broadcast() reuses the original skb for the last slave
(determined by bond_is_last_slave()) and clones it for others.
Concurrent slave enslave/release can mutate the slave list during
RCU-protected iteration, changing which slave is "last" mid-loop.
This causes the original skb to be double-consumed (double-freed).

Replace the racy bond_is_last_slave() check with a simple index
comparison (i + 1 == slaves_count) against the pre-snapshot slave
count taken via READ_ONCE() before the loop.  This preserves the
zero-copy optimization for the last slave while making the "last"
determination stable against concurrent list mutations.

The UAF can trigger the following crash:

==================================================================
BUG: KASAN: slab-use-after-free in skb_clone
Read of size 8 at addr ffff888100ef8d40 by task exploit/147

CPU: 1 UID: 0 PID: 147 Comm: exploit Not tainted 7.0.0-rc3+ #4 PREEMPTLAZY
Call Trace:
 <TASK>
 dump_stack_lvl (lib/dump_stack.c:123)
 print_report (mm/kasan/report.c:379 mm/kasan/report.c:482)
 kasan_report (mm/kasan/report.c:597)
 skb_clone (include/linux/skbuff.h:1724 include/linux/skbuff.h:1792 include/linux/skbuff.h:3396 net/core/skbuff.c:2108)
 bond_xmit_broadcast (drivers/net/bonding/bond_main.c:5334)
 bond_start_xmit (drivers/net/bonding/bond_main.c:5567 drivers/net/bonding/bond_main.c:5593)
 dev_hard_start_xmit (include/linux/netdevice.h:5325 include/linux/netdevice.h:5334 net/core/dev.c:3871 net/core/dev.c:3887)
 __dev_queue_xmit (include/linux/netdevice.h:3601 net/core/dev.c:4838)
 ip6_finish_output2 (include/net/neighbour.h:540 include/net/neighbour.h:554 net/ipv6/ip6_output.c:136)
 ip6_finish_output (net/ipv6/ip6_output.c:208 net/ipv6/ip6_output.c:219)
 ip6_output (net/ipv6/ip6_output.c:250)
 ip6_send_skb (net/ipv6/ip6_output.c:1985)
 udp_v6_send_skb (net/ipv6/udp.c:1442)
 udpv6_sendmsg (net/ipv6/udp.c:1733)
 __sys_sendto (net/socket.c:730 net/socket.c:742 net/socket.c:2206)
 __x64_sys_sendto (net/socket.c:2209)
 do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
 </TASK>

Allocated by task 147:

Freed by task 147:

The buggy address belongs to the object at ffff888100ef8c80
 which belongs to the cache skbuff_head_cache of size 224
The buggy address is located 192 bytes inside of
 freed 224-byte region [ffff888100ef8c80, ffff888100ef8d60)

Memory state around the buggy address:
 ffff888100ef8c00: fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888100ef8c80: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888100ef8d00: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                                                    ^
 ffff888100ef8d80: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
 ffff888100ef8e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

Fixes: 4e5bd03ae346 ("net: bonding: fix bond_xmit_broadcast return value error bug")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Link: https://patch.msgid.link/20260326075553.3960562-1-xmei5@asu.edu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ Backport to 5.15.y: 5.15's bond_xmit_broadcast() walks the live slave
  list, not the all_slaves array upstream indexes into (that walk came
  with ce7a381697cb "net: bonding: add broadcast_neighbor option for
  802.3ad"), so there is no index/count pair that stays consistent
  while the list changes. Instead of choosing the "last" slave up
  front, defer it: clone the skb for each up slave as the next one is
  found, and transmit the original skb to the last up slave seen only
  after the walk has finished. The original skb is consumed exactly
  once and not touched afterwards, however the list changes during
  the RCU walk; slave pointers stay valid under rcu_read_lock() since
  __bond_release_one() does synchronize_rcu() before freeing. ]
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index b74732d2924b1..12dc1d3c6e2b6 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4915,35 +4915,36 @@ static netdev_tx_t bond_xmit_broadcast(struct sk_buff *skb,
 				       struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
-	struct slave *slave = NULL;
+	struct slave *slave = NULL, *last = NULL;
 	struct list_head *iter;
 	bool xmit_suc = false;
-	bool skb_used = false;
 
+	/* The slave list can change under us during the RCU walk, so which
+	 * slave is "last" is only known once the walk is over: clone for
+	 * every up slave but the last one seen, then hand the original skb
+	 * to that one after the loop.
+	 */
 	bond_for_each_slave_rcu(bond, slave, iter) {
 		struct sk_buff *skb2;
 
 		if (!(bond_slave_is_up(slave) && slave->link == BOND_LINK_UP))
 			continue;
 
-		if (bond_is_last_slave(bond, slave)) {
-			skb2 = skb;
-			skb_used = true;
-		} else {
+		if (last) {
 			skb2 = skb_clone(skb, GFP_ATOMIC);
-			if (!skb2) {
+			if (!skb2)
 				net_err_ratelimited("%s: Error: %s: skb_clone() failed\n",
 						    bond_dev->name, __func__);
-				continue;
-			}
+			else if (bond_dev_queue_xmit(bond, skb2, last->dev) == NETDEV_TX_OK)
+				xmit_suc = true;
 		}
-
-		if (bond_dev_queue_xmit(bond, skb2, slave->dev) == NETDEV_TX_OK)
-			xmit_suc = true;
+		last = slave;
 	}
 
-	if (!skb_used)
+	if (!last)
 		dev_kfree_skb_any(skb);
+	else if (bond_dev_queue_xmit(bond, skb, last->dev) == NETDEV_TX_OK)
+		xmit_suc = true;
 
 	if (xmit_suc)
 		return NETDEV_TX_OK;
-- 
2.53.0



