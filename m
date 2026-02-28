Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBA636C9C4
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302255; cv=none; b=a2Ath9V9kgYTX4WQusu9T2xLfsaSmbZqb5ajAPqHlZNsw8t3thwrpAPfq9gl6MILURnQd7hBwYq3auHfKQBHhMifVOd4z/6GqVp+c3rYsICOpVwHhGuN3X8FZwUZhTdidkwimcK2qJJ6jUMkDeQ0/INSumbHa8eSlO6cpPsMJpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302255; c=relaxed/simple;
	bh=6jpQytVG0jNCniZbu12WCuqytnxv/7c4rXSDmEBQnSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O7u5JoLw4QUv00ccaqDwcJE6a1itc1HUAYVzQJS9s1P1qkY5n/a2hQhBJq33fmSS2a4gduaKku7MNq9oyOnmGcFtWKMbHecFHaU+8QH1E2IGw8JqNlC/5nIe6ZgzTkVwSuT/LbsPW2RPdZ2E/BWi7Pk+ygUOrRMkX3wLAuAcARg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jLvmoouw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jLvmoouw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A428CC19424;
	Sat, 28 Feb 2026 18:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302255;
	bh=6jpQytVG0jNCniZbu12WCuqytnxv/7c4rXSDmEBQnSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLvmoouwB7eEqcxVyf9A1IDVlWA1kCxELXSm2aiqHdLhGQXbqGaqNQrssyDBQuiQ1
	 AUPapzB2l0iCgfOPkdMqR8Gx8yOJiYUzXBPDPYEJYDMcpi0157a+V4HVktrRMEVKoi
	 aAXrEFIjDFKkxgUlqeIxUqW4p2WrRNJLjee6dV8GKgCQFebxTX1kyT5TUbxcuu7c7O
	 8kdmVeHDW3EJ7ZCOI0EvU74/0PRb5mf+4AWgZlFh7mA4u5ba315XbCN7c4AdcZX6LD
	 4IjRRafG8hgjaccjwJyN8bxzEfXN527emO07KxuKZhmxSCmPmrX7QHBIaWFQ1mJLLk
	 5iyU6p9OpA8QA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Kuniyuki Iwashima <kuniyu@google.com>,
	syzbot+707d6a5da1ab9e0c6f9d@syzkaller.appspotmail.com,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Shigeru Yoshida <syoshida@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 269/283] ipv6: Fix out-of-bound access in fib6_add_rt2node().
Date: Sat, 28 Feb 2026 13:06:51 -0500
Message-ID: <20260228180709.1583486-269-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 8244f959e2c125c849e569f5b23ed49804cce695 ]

syzbot reported out-of-bound read in fib6_add_rt2node(). [0]

When IPv6 route is created with RTA_NH_ID, struct fib6_info
does not have the trailing struct fib6_nh.

The cited commit started to check !iter->fib6_nh->fib_nh_gw_family
to ensure that rt6_qualify_for_ecmp() will return false for iter.

If iter->nh is not NULL, rt6_qualify_for_ecmp() returns false anyway.

Let's check iter->nh before reading iter->fib6_nh and avoid OOB read.

[0]:
BUG: KASAN: slab-out-of-bounds in fib6_add_rt2node+0x349c/0x3500 net/ipv6/ip6_fib.c:1142
Read of size 1 at addr ffff8880384ba6de by task syz.0.18/5500

CPU: 0 UID: 0 PID: 5500 Comm: syz.0.18 Not tainted syzkaller #0 PREEMPT(full)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xba/0x230 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 fib6_add_rt2node+0x349c/0x3500 net/ipv6/ip6_fib.c:1142
 fib6_add_rt2node_nh net/ipv6/ip6_fib.c:1363 [inline]
 fib6_add+0x910/0x18c0 net/ipv6/ip6_fib.c:1531
 __ip6_ins_rt net/ipv6/route.c:1351 [inline]
 ip6_route_add+0xde/0x1b0 net/ipv6/route.c:3957
 inet6_rtm_newroute+0x268/0x19e0 net/ipv6/route.c:5660
 rtnetlink_rcv_msg+0x7d5/0xbe0 net/core/rtnetlink.c:6958
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0xa68/0xad0 net/socket.c:2592
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9316b9aeb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd8809b678 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f9316e15fa0 RCX: 00007f9316b9aeb9
RDX: 0000000000000000 RSI: 0000200000004380 RDI: 0000000000000003
RBP: 00007f9316c08c1f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f9316e15fac R14: 00007f9316e15fa0 R15: 00007f9316e15fa0
 </TASK>

Allocated by task 5499:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __do_kmalloc_node mm/slub.c:5657 [inline]
 __kmalloc_noprof+0x40c/0x7e0 mm/slub.c:5669
 kmalloc_noprof include/linux/slab.h:961 [inline]
 kzalloc_noprof include/linux/slab.h:1094 [inline]
 fib6_info_alloc+0x30/0xf0 net/ipv6/ip6_fib.c:155
 ip6_route_info_create+0x142/0x860 net/ipv6/route.c:3820
 ip6_route_add+0x49/0x1b0 net/ipv6/route.c:3949
 inet6_rtm_newroute+0x268/0x19e0 net/ipv6/route.c:5660
 rtnetlink_rcv_msg+0x7d5/0xbe0 net/core/rtnetlink.c:6958
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0xa68/0xad0 net/socket.c:2592
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: bbf4a17ad9ff ("ipv6: Fix ECMP sibling count mismatch when clearing RTF_ADDRCONF")
Reported-by: syzbot+707d6a5da1ab9e0c6f9d@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/698cbfba.050a0220.2eeac1.009d.GAE@google.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Shigeru Yoshida <syoshida@redhat.com>
Link: https://patch.msgid.link/20260211175133.3657034-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_fib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index fe57884ca7238..6fe867579118b 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1137,7 +1137,7 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 					fib6_add_gc_list(iter);
 				}
 				if (!(rt->fib6_flags & (RTF_ADDRCONF | RTF_PREFIX_RT)) &&
-				    !iter->fib6_nh->fib_nh_gw_family) {
+				    (iter->nh || !iter->fib6_nh->fib_nh_gw_family)) {
 					iter->fib6_flags &= ~RTF_ADDRCONF;
 					iter->fib6_flags &= ~RTF_PREFIX_RT;
 				}
-- 
2.51.0

