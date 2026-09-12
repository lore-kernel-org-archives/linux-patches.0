Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C4B332610;
	Sat, 12 Sep 2026 11:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212751; cv=none; b=cu3WP53Ov3T07Al5nuZ4YJBjtePQOGDnm7STTomZRVm4gZ5coIOLb+nDJY1dMeXPiGH39WNGmcqVAHkjF6vaT8FkQhDZUQ97GdE3IzwtrcpcroG1A3gCZTdUnxcpsfuUlJWwvfJO/uZQu9G6fJXEZ4d+Lxgh8Is1OfMv5XBhspY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212751; c=relaxed/simple;
	bh=ai6TidUzftyYbAeHMldaXNW1Ef80Snv3E7d22iQ4Pqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJfb7TsTUY01dqAgEowu1E87siwpuWg9CY2dKivXhzEpjt7Z3mQgfiRy1Lg11rDoExihp/Zjsp2fKnbeirVdAg5vVoRBHQFUy9GyFW09q6kDcXazAeA+UwxP8tdYe1ov5u1BYAzNe1yGWPSviIVvI5naVKLEg6FkWMKhElN7OfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eFTqpxnB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eFTqpxnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2371F000FF;
	Sat, 12 Sep 2026 11:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212749;
	bh=BbfXieX4EC9umV49eHYCgZ6kJVRNPTPSvrwhqYtfCSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eFTqpxnBuAQpIUgKdogCOW6i+wM3HkYVn2YucfMw6/08uetPYSBnGUavWNefXNTBH
	 k0G/vyBBHY2gcwDb3fmJtpFNMhTLpGmwU+bsVjYozO+UB96iisK4VcMscFnsFQdw5B
	 cJ7zmUPIjOOOvMq8AIc0K8zl8oG+hml9nNnnmPEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzkaller <syzkaller@googlegroups.com>,
	Yi Lai <yi1.lai@intel.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1499/1518] ipmr: Call ipmr_fib_lookup() under RCU.
Date: Sat, 12 Sep 2026 09:01:08 +0200
Message-ID: <20260912065657.472886178@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 019c892e46544af0ae94ec833f79aa903c837666 ]

Yi Lai reported RCU splat in reg_vif_xmit() below. [0]

When CONFIG_IP_MROUTE_MULTIPLE_TABLES=n, ipmr_fib_lookup()
uses rcu_dereference() without explicit rcu_read_lock().

Although rcu_read_lock_bh() is already held by the caller
__dev_queue_xmit(), lockdep requires explicit rcu_read_lock()
for rcu_dereference().

Let's move up rcu_read_lock() in reg_vif_xmit() to
cover ipmr_fib_lookup().

[0]:
WARNING: suspicious RCU usage
7.1.0-rc2-next-20260504-9d0d467c3572 #1 Not tainted
 -----------------------------
net/ipv4/ipmr.c:329 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
2 locks held by syz.2.17/1779:
 #0: ffffffff87896440 (rcu_read_lock_bh){....}-{1:3}, at: local_bh_disable include/linux/bottom_half.h:20 [inline]
 #0: ffffffff87896440 (rcu_read_lock_bh){....}-{1:3}, at: rcu_read_lock_bh include/linux/rcupdate.h:891 [inline]
 #0: ffffffff87896440 (rcu_read_lock_bh){....}-{1:3}, at: __dev_queue_xmit+0x239/0x4140 net/core/dev.c:4792
 #1: ffff88801a199d18 (_xmit_PIMREG#2){+...}-{3:3}, at: spin_lock include/linux/spinlock.h:342 [inline]
 #1: ffff88801a199d18 (_xmit_PIMREG#2){+...}-{3:3}, at: __netif_tx_lock include/linux/netdevice.h:4795 [inline]
 #1: ffff88801a199d18 (_xmit_PIMREG#2){+...}-{3:3}, at: __dev_queue_xmit+0x1d5d/0x4140 net/core/dev.c:4865

stack backtrace:
CPU: 1 UID: 0 PID: 1779 Comm: syz.2.17 Not tainted 7.1.0-rc2-next-20260504-9d0d467c3572 #1 PREEMPT(lazy)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x121/0x150 lib/dump_stack.c:120
 dump_stack+0x19/0x20 lib/dump_stack.c:129
 lockdep_rcu_suspicious+0x15b/0x1f0 kernel/locking/lockdep.c:6878
 ipmr_fib_lookup net/ipv4/ipmr.c:329 [inline]
 reg_vif_xmit+0x2ee/0x3c0 net/ipv4/ipmr.c:540
 __netdev_start_xmit include/linux/netdevice.h:5382 [inline]
 netdev_start_xmit include/linux/netdevice.h:5391 [inline]
 xmit_one net/core/dev.c:3889 [inline]
 dev_hard_start_xmit+0x170/0x700 net/core/dev.c:3905
 __dev_queue_xmit+0x1df1/0x4140 net/core/dev.c:4871
 dev_queue_xmit include/linux/netdevice.h:3423 [inline]
 packet_xmit+0x252/0x370 net/packet/af_packet.c:276
 packet_snd net/packet/af_packet.c:3082 [inline]
 packet_sendmsg+0x39ad/0x5650 net/packet/af_packet.c:3114
 sock_sendmsg_nosec net/socket.c:797 [inline]
 __sock_sendmsg net/socket.c:812 [inline]
 ____sys_sendmsg+0xa21/0xba0 net/socket.c:2716
 ___sys_sendmsg+0x121/0x1c0 net/socket.c:2770
 __sys_sendmsg+0x177/0x220 net/socket.c:2802
 __do_sys_sendmsg net/socket.c:2807 [inline]
 __se_sys_sendmsg net/socket.c:2805 [inline]
 __x64_sys_sendmsg+0x80/0xc0 net/socket.c:2805
 x64_sys_call+0x1d9c/0x21c0 arch/x86/include/generated/asm/syscalls_64.h:47
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xc1/0x1020 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7f37e563ee5d
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 93 af 1b 00 f7 d8 64 89 01 48
RSP: 002b:00007ffe5caa7fa8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000005c5fa0 RCX: 00007f37e563ee5d
RDX: 0000000000000000 RSI: 00002000000012c0 RDI: 0000000000000004
RBP: 00000000005c5fa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00000000005c5fac R15: 00000000005c5fa0
 </TASK>

Fixes: b3b6babf4751 ("ipmr: Free mr_table after RCU grace period.")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Reported-by: Yi Lai <yi1.lai@intel.com>
Closes: https://lore.kernel.org/netdev/afrY34dLXNUboevf@ly-workstation/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260506065955.1695753-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ipmr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index c6d5d30a98301..6cf95defb01e1 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -530,15 +530,16 @@ static netdev_tx_t reg_vif_xmit(struct sk_buff *skb, struct net_device *dev)
 	};
 	int err;
 
+	rcu_read_lock();
 	err = ipmr_fib_lookup(net, &fl4, &mrt);
 	if (err < 0) {
+		rcu_read_unlock();
 		kfree_skb(skb);
 		return err;
 	}
 
 	DEV_STATS_ADD(dev, tx_bytes, skb->len);
 	DEV_STATS_INC(dev, tx_packets);
-	rcu_read_lock();
 
 	/* Pairs with WRITE_ONCE() in vif_add() and vif_delete() */
 	ipmr_cache_report(mrt, skb, READ_ONCE(mrt->mroute_reg_vif_num),
-- 
2.53.0



