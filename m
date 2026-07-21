Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502B3379960;
	Tue, 21 Jul 2026 23:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674845; cv=none; b=nK6CiF0YuPmecO2JIXwHKpxlF3uFa5OLHKWaSRemGY2uOWIu4IAIDBfU6YLsExT1gXajRuJQzaFSwmvZvqdAAYGg51pRFrDg02X23/22OewK1ZzDDO0kJazQ/YAn1krr+aCS0C0AmDnGEajOgRnVft7WB+pbhuINIGaDo999GxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674845; c=relaxed/simple;
	bh=tl8+9shVT6edxN8Wv/nBxean06oDQyH3OGSfNKqE/qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DkhCMQpp986AxGaukRGKLloFWgKmaoKoPq6t9hQdWuIgLsQ0Q1qulph3Z3rxsQB6RCVrkyojQoEsyQV25eEaWP0tuz5kidz9hUThC9oFksG8pwnofNgvLGtYtKYt1ZXqLzngFfDbJCL0jY5OZw77xrD4rG+Fh95/GFeYy4lFxBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FY51d2CQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FY51d2CQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59DD1F000E9;
	Tue, 21 Jul 2026 23:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674844;
	bh=eqvXvmWORp8Rey7D7CZBeHyiIKL4bbYKN+5sYuim7Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FY51d2CQvAPQlo8TwCEWCG3ecNrNSG4VyCFoIA3Prs+hEow+NzVqG7D7fBScCzkaj
	 HNC3rx8TixK598G5C8+NgEJq7UXytANCxMC8Movh90q1uFZpE2Mcg+4FhVjJs9Rfcn
	 qL1RXc5Fu7JtEDSR+4P+6yzN5b72D/hnjimRLYgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Taehee Yoo <ap420073@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 695/699] ipv6: fix lockdep splat in in6_dump_addrs()
Date: Tue, 21 Jul 2026 17:27:34 +0200
Message-ID: <20260721152411.456933398@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 4e43e64d0f1332fcc503babad4dc31aead7131ca upstream.

As reported by syzbot, we should not use rcu_dereference()
when rcu_read_lock() is not held.

WARNING: suspicious RCU usage
5.19.0-rc2-syzkaller #0 Not tainted

net/ipv6/addrconf.c:5175 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
1 lock held by syz-executor326/3617:
 #0: ffffffff8d5848e8 (rtnl_mutex){+.+.}-{3:3}, at: netlink_dump+0xae/0xc20 net/netlink/af_netlink.c:2223

stack backtrace:
CPU: 0 PID: 3617 Comm: syz-executor326 Not tainted 5.19.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 in6_dump_addrs+0x12d1/0x1790 net/ipv6/addrconf.c:5175
 inet6_dump_addr+0x9c1/0xb50 net/ipv6/addrconf.c:5300
 netlink_dump+0x541/0xc20 net/netlink/af_netlink.c:2275
 __netlink_dump_start+0x647/0x900 net/netlink/af_netlink.c:2380
 netlink_dump_start include/linux/netlink.h:245 [inline]
 rtnetlink_rcv_msg+0x73e/0xc90 net/core/rtnetlink.c:6046
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2501
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 ____sys_sendmsg+0x6eb/0x810 net/socket.c:2492
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2546
 __sys_sendmsg net/socket.c:2575 [inline]
 __do_sys_sendmsg net/socket.c:2584 [inline]
 __se_sys_sendmsg net/socket.c:2582 [inline]
 __x64_sys_sendmsg+0x132/0x220 net/socket.c:2582
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Fixes: 88e2ca308094 ("mld: convert ifmcaddr6 to RCU")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Taehee Yoo <ap420073@gmail.com>
Link: https://lore.kernel.org/r/20220628121248.858695-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5178,9 +5178,9 @@ next:
 		fillargs->event = RTM_GETMULTICAST;
 
 		/* multicast address */
-		for (ifmca = rcu_dereference(idev->mc_list);
+		for (ifmca = rtnl_dereference(idev->mc_list);
 		     ifmca;
-		     ifmca = rcu_dereference(ifmca->next), ip_idx++) {
+		     ifmca = rtnl_dereference(ifmca->next), ip_idx++) {
 			if (ip_idx < s_ip_idx)
 				continue;
 			err = inet6_fill_ifmcaddr(skb, ifmca, fillargs);


