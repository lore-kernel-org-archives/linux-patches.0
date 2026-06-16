Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B28478E55;
	Tue, 16 Jun 2026 17:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630251; cv=none; b=B16qNFlSKs2QpZCeCz/z2L5Y9AslDP6cyVHzw4QQdIcOG4zUPGvDsmfCkWpiTSZZLuPhVvnB90md1vrUn4Phu7GlTfAOWrSiQJubwnkl3eTkNksPIeeHcMvo5N/M9JgoAfNBMVWepPQtyDFuqKBhtW3DLZZzy96eKbi6FMgkm4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630251; c=relaxed/simple;
	bh=60qmcipv6CuNlcws3ZVZI7fwBcmdudbnNXPVJVcY5TA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ok9j9j/3Wde082mH1N3es2bpOQkLKqyqda496Re9sPFlFri1a2UG+oS0VLwPGv5KxQK/sDMPYQvLBFbASXwLwePMeB6zaCvFcAvgdgzhCPD3dYBLbuZIXSVa3o1CMTfJpNQdy7EPQOyULheBvFe6z1RuH5X/6I8UdGwh12UOdQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nWRaffkc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nWRaffkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74C21F000E9;
	Tue, 16 Jun 2026 17:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630248;
	bh=AbkOioVE9Ba0kBhavjXuKDcF94Y3Xsxb6k+H8oLtEAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nWRaffkcg0YBznEpe8MvE8rje1cA7p3uMd3+HT09LJ9k29+wetBv/uwHYbWlfe7/L
	 OTVBcA8g0TvgAqLSLCe9UU5ZOzyq68bZekh8ZhKtE6MC6TDij65OcMFPbjwwdinhks
	 fT+HEToZWJ1ayJUd1Xmvy2CEBqBpiY4uat+jIM1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 438/452] net: bonding: fix use-after-free in bond_xmit_broadcast()
Date: Tue, 16 Jun 2026 20:31:05 +0530
Message-ID: <20260616145139.611832981@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

commit 2884bf72fb8f03409e423397319205de48adca16 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5349,7 +5349,7 @@ static netdev_tx_t bond_xmit_broadcast(s
 		if (!(bond_slave_is_up(slave) && slave->link == BOND_LINK_UP))
 			continue;
 
-		if (bond_is_last_slave(bond, slave)) {
+		if (i + 1 == slaves_count) {
 			skb2 = skb;
 			skb_used = true;
 		} else {


