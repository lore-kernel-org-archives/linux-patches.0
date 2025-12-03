Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB43341650;
	Wed,  3 Dec 2025 16:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779884; cv=none; b=JFWHouvSZwrGz/ieuQlFb8is4LA1vtYx1xhxOf/gSWktFofuVUz5yklSj2L161K8hFt3/d++DLcsg5LOwD3Ks1DUxDdW7ZOr6DoL2L4tdG3moTT4QOaKqf0+hZb2SQAPCoOYa8OMVg8iZx2bFksbkJuvM6yEdDaEDvPviHAkTGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779884; c=relaxed/simple;
	bh=jaWmwgfrJkBeDPgXYCuHzVi8JIt3EcZasZx9p07wZKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hshlT0CdVz8kPDkcxPb8IcDREn9JMKjb+OUHh7YRPFhdPbfuUXTJt9YI86P+BkX9hSRQfSOCqkbNI3NfWkZrCM0Y/bc1vDNaIvzGnDraxKoJkNzT5Kb7QGQgCVfNZZzEdGxNbrRibcdfwlG/wfZJR1RXQfQu2N7mnuRfxKkvITQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ta1RHDNw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ta1RHDNw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B893C4CEF5;
	Wed,  3 Dec 2025 16:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779883;
	bh=jaWmwgfrJkBeDPgXYCuHzVi8JIt3EcZasZx9p07wZKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ta1RHDNwqx6/KYJrz8DF/SrrkymhverQUdbNQVbJOebmNXm99sOwXSh0SbZdUCeYR
	 JJTdKbZ6hcndl10fAiewbvtkb211OBYLu+rkSzJ5qN3pbLW5u6O8yLnD4H8bi0F8y0
	 O4GrLx9pM50zD5yRiXiCPchUtJVPNdE9Kun3axGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d7dad7fd4b3921104957@syzkaller.appspotmail.com,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 358/568] tipc: Fix use-after-free in tipc_mon_reinit_self().
Date: Wed,  3 Dec 2025 16:26:00 +0100
Message-ID: <20251203152453.814894230@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 0725e6afb55128be21a2ca36e9674f573ccec173 ]

syzbot reported use-after-free of tipc_net(net)->monitors[]
in tipc_mon_reinit_self(). [0]

The array is protected by RTNL, but tipc_mon_reinit_self()
iterates over it without RTNL.

tipc_mon_reinit_self() is called from tipc_net_finalize(),
which is always under RTNL except for tipc_net_finalize_work().

Let's hold RTNL in tipc_net_finalize_work().

[0]:
BUG: KASAN: slab-use-after-free in __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
BUG: KASAN: slab-use-after-free in _raw_spin_lock_irqsave+0xa7/0xf0 kernel/locking/spinlock.c:162
Read of size 1 at addr ffff88805eae1030 by task kworker/0:7/5989

CPU: 0 UID: 0 PID: 5989 Comm: kworker/0:7 Not tainted syzkaller #0 PREEMPT_{RT,(full)}
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/18/2025
Workqueue: events tipc_net_finalize_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x240 mm/kasan/report.c:482
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 __kasan_check_byte+0x2a/0x40 mm/kasan/common.c:568
 kasan_check_byte include/linux/kasan.h:399 [inline]
 lock_acquire+0x8d/0x360 kernel/locking/lockdep.c:5842
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0xa7/0xf0 kernel/locking/spinlock.c:162
 rtlock_slowlock kernel/locking/rtmutex.c:1894 [inline]
 rwbase_rtmutex_lock_state kernel/locking/spinlock_rt.c:160 [inline]
 rwbase_write_lock+0xd3/0x7e0 kernel/locking/rwbase_rt.c:244
 rt_write_lock+0x76/0x110 kernel/locking/spinlock_rt.c:243
 write_lock_bh include/linux/rwlock_rt.h:99 [inline]
 tipc_mon_reinit_self+0x79/0x430 net/tipc/monitor.c:718
 tipc_net_finalize+0x115/0x190 net/tipc/net.c:140
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xade/0x17b0 kernel/workqueue.c:3319
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
 kthread+0x70e/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x439/0x7d0 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Allocated by task 6089:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:388 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:405
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __kmalloc_cache_noprof+0x1a8/0x320 mm/slub.c:4407
 kmalloc_noprof include/linux/slab.h:905 [inline]
 kzalloc_noprof include/linux/slab.h:1039 [inline]
 tipc_mon_create+0xc3/0x4d0 net/tipc/monitor.c:657
 tipc_enable_bearer net/tipc/bearer.c:357 [inline]
 __tipc_nl_bearer_enable+0xe16/0x13f0 net/tipc/bearer.c:1047
 __tipc_nl_compat_doit net/tipc/netlink_compat.c:371 [inline]
 tipc_nl_compat_doit+0x3bc/0x5f0 net/tipc/netlink_compat.c:393
 tipc_nl_compat_handle net/tipc/netlink_compat.c:-1 [inline]
 tipc_nl_compat_recv+0x83c/0xbe0 net/tipc/netlink_compat.c:1321
 genl_family_rcv_msg_doit+0x215/0x300 net/netlink/genetlink.c:1115
 genl_family_rcv_msg net/netlink/genetlink.c:1195 [inline]
 genl_rcv_msg+0x60e/0x790 net/netlink/genetlink.c:1210
 netlink_rcv_skb+0x208/0x470 net/netlink/af_netlink.c:2552
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1219
 netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
 netlink_unicast+0x846/0xa10 net/netlink/af_netlink.c:1346
 netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
 sock_sendmsg_nosec net/socket.c:714 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:729
 ____sys_sendmsg+0x508/0x820 net/socket.c:2614
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2668
 __sys_sendmsg net/socket.c:2700 [inline]
 __do_sys_sendmsg net/socket.c:2705 [inline]
 __se_sys_sendmsg net/socket.c:2703 [inline]
 __x64_sys_sendmsg+0x1a1/0x260 net/socket.c:2703
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 6088:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:576
 poison_slab_object mm/kasan/common.c:243 [inline]
 __kasan_slab_free+0x5b/0x80 mm/kasan/common.c:275
 kasan_slab_free include/linux/kasan.h:233 [inline]
 slab_free_hook mm/slub.c:2422 [inline]
 slab_free mm/slub.c:4695 [inline]
 kfree+0x195/0x550 mm/slub.c:4894
 tipc_l2_device_event+0x380/0x650 net/tipc/bearer.c:-1
 notifier_call_chain+0x1b3/0x3e0 kernel/notifier.c:85
 call_netdevice_notifiers_extack net/core/dev.c:2267 [inline]
 call_netdevice_notifiers net/core/dev.c:2281 [inline]
 unregister_netdevice_many_notify+0x14d7/0x1fe0 net/core/dev.c:12166
 unregister_netdevice_many net/core/dev.c:12229 [inline]
 unregister_netdevice_queue+0x33c/0x380 net/core/dev.c:12073
 unregister_netdevice include/linux/netdevice.h:3385 [inline]
 __tun_detach+0xe4d/0x1620 drivers/net/tun.c:621
 tun_detach drivers/net/tun.c:637 [inline]
 tun_chr_close+0x10d/0x1c0 drivers/net/tun.c:3433
 __fput+0x458/0xa80 fs/file_table.c:468
 task_work_run+0x1d4/0x260 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop+0xec/0x110 kernel/entry/common.c:43
 exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
 do_syscall_64+0x2bd/0x3b0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: 46cb01eeeb86 ("tipc: update mon's self addr when node addr generated")
Reported-by: syzbot+d7dad7fd4b3921104957@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/690c323a.050a0220.baf87.007f.GAE@google.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251107064038.2361188-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/net.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/tipc/net.c b/net/tipc/net.c
index 0e95572e56b41..7e65d0b0c4a8d 100644
--- a/net/tipc/net.c
+++ b/net/tipc/net.c
@@ -145,7 +145,9 @@ void tipc_net_finalize_work(struct work_struct *work)
 {
 	struct tipc_net *tn = container_of(work, struct tipc_net, work);
 
+	rtnl_lock();
 	tipc_net_finalize(tipc_link_net(tn->bcl), tn->trial_addr);
+	rtnl_unlock();
 }
 
 void tipc_net_stop(struct net *net)
-- 
2.51.0



