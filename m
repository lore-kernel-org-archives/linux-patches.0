Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683161CDFAC;
	Sun,  7 Sep 2025 20:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275789; cv=none; b=qfsygKsTB6BgMOH6hv5IwLhhdcCNayYJNxfg0HdT4jeNholp8ulfTBxd6zC08vITJGzdDWAjsQFiy74tt6oK+2MIbPBhDlU3Co7h+ubAA4byNw6LXqyacHdSPiNMItudM2whBojnduIIzuTRX8mxNG6z1KEf/rnkQpxUFhjjpzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275789; c=relaxed/simple;
	bh=NNT3shMF8ejOInz+DnvguARXIei6FPYsFiOee11dfbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QmwF623WfxbFDZC49BCEPM3JHFRsoW9HKlTA0EfK0UzdmxUgNP3+AmoWbCx6l/2iuZZPvmGlbM7WZNxbJLVni8A1L+V+PprOL5SPH20sV3MMAbb/1YKVhDE66U6Kel4XEYyZgVs3CoRhZDyEHCRPox6KNBP8MeOkSa+t90CmXIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hnQ9RbqL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hnQ9RbqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F2CC4CEF0;
	Sun,  7 Sep 2025 20:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275789;
	bh=NNT3shMF8ejOInz+DnvguARXIei6FPYsFiOee11dfbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hnQ9RbqL3wWfzylw0gvKFd3StPuwRLmZC9jMSz99EJBKf4ShJWJ2iPKbDTxZ8nKEl
	 vpo1LQpo5NUyQTjRjR6ZCm+rbz8dEoebHeBFuHKkhGlkCwSuYmfhSmfuwqEpau9DOQ
	 MaPzqK5MRMyUhop26n+U7KCQhUp7/mVOeyTLcSuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e5e64cdf8e92046dd3e1@syzkaller.appspotmail.com,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 04/45] Bluetooth: Fix use-after-free in l2cap_sock_cleanup_listen()
Date: Sun,  7 Sep 2025 21:57:50 +0200
Message-ID: <20250907195601.088010226@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195600.953058118@linuxfoundation.org>
References: <20250907195600.953058118@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 862c628108562d8c7a516a900034823b381d3cba ]

syzbot reported the splat below without a repro.

In the splat, a single thread calling bt_accept_dequeue() freed sk
and touched it after that.

The root cause would be the racy l2cap_sock_cleanup_listen() call
added by the cited commit.

bt_accept_dequeue() is called under lock_sock() except for
l2cap_sock_release().

Two threads could see the same socket during the list iteration
in bt_accept_dequeue():

  CPU1                        CPU2 (close())
  ----                        ----
  sock_hold(sk)               sock_hold(sk);
  lock_sock(sk)   <-- block close()
  sock_put(sk)
  bt_accept_unlink(sk)
    sock_put(sk)  <-- refcnt by bt_accept_enqueue()
  release_sock(sk)
                              lock_sock(sk)
                              sock_put(sk)
                              bt_accept_unlink(sk)
                                sock_put(sk)        <-- last refcnt
                              bt_accept_unlink(sk)  <-- UAF

Depending on the timing, the other thread could show up in the
"Freed by task" part.

Let's call l2cap_sock_cleanup_listen() under lock_sock() in
l2cap_sock_release().

[0]:
BUG: KASAN: slab-use-after-free in debug_spin_lock_before kernel/locking/spinlock_debug.c:86 [inline]
BUG: KASAN: slab-use-after-free in do_raw_spin_lock+0x26f/0x2b0 kernel/locking/spinlock_debug.c:115
Read of size 4 at addr ffff88803b7eb1c4 by task syz.5.3276/16995
CPU: 3 UID: 0 PID: 16995 Comm: syz.5.3276 Not tainted syzkaller #0 PREEMPT(full)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xcd/0x630 mm/kasan/report.c:482
 kasan_report+0xe0/0x110 mm/kasan/report.c:595
 debug_spin_lock_before kernel/locking/spinlock_debug.c:86 [inline]
 do_raw_spin_lock+0x26f/0x2b0 kernel/locking/spinlock_debug.c:115
 spin_lock_bh include/linux/spinlock.h:356 [inline]
 release_sock+0x21/0x220 net/core/sock.c:3746
 bt_accept_dequeue+0x505/0x600 net/bluetooth/af_bluetooth.c:312
 l2cap_sock_cleanup_listen+0x5c/0x2a0 net/bluetooth/l2cap_sock.c:1451
 l2cap_sock_release+0x5c/0x210 net/bluetooth/l2cap_sock.c:1425
 __sock_release+0xb3/0x270 net/socket.c:649
 sock_close+0x1c/0x30 net/socket.c:1439
 __fput+0x3ff/0xb70 fs/file_table.c:468
 task_work_run+0x14d/0x240 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop+0xeb/0x110 kernel/entry/common.c:43
 exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
 do_syscall_64+0x3f6/0x4c0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2accf8ebe9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdb6cb1378 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 00000000000426fb RCX: 00007f2accf8ebe9
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 00007f2acd1b7da0 R08: 0000000000000001 R09: 00000012b6cb166f
R10: 0000001b30e20000 R11: 0000000000000246 R12: 00007f2acd1b609c
R13: 00007f2acd1b6090 R14: ffffffffffffffff R15: 00007ffdb6cb1490
 </TASK>

Allocated by task 5326:
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
 kasan_save_track+0x14/0x30 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:388 [inline]
 __kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:405
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __do_kmalloc_node mm/slub.c:4365 [inline]
 __kmalloc_noprof+0x223/0x510 mm/slub.c:4377
 kmalloc_noprof include/linux/slab.h:909 [inline]
 sk_prot_alloc+0x1a8/0x2a0 net/core/sock.c:2239
 sk_alloc+0x36/0xc20 net/core/sock.c:2295
 bt_sock_alloc+0x3b/0x3a0 net/bluetooth/af_bluetooth.c:151
 l2cap_sock_alloc.constprop.0+0x33/0x1d0 net/bluetooth/l2cap_sock.c:1894
 l2cap_sock_new_connection_cb+0x101/0x240 net/bluetooth/l2cap_sock.c:1482
 l2cap_connect_cfm+0x4c4/0xf80 net/bluetooth/l2cap_core.c:7287
 hci_connect_cfm include/net/bluetooth/hci_core.h:2050 [inline]
 hci_remote_features_evt+0x4dd/0x970 net/bluetooth/hci_event.c:3712
 hci_event_func net/bluetooth/hci_event.c:7519 [inline]
 hci_event_packet+0xa0d/0x11c0 net/bluetooth/hci_event.c:7573
 hci_rx_work+0x2c5/0x16b0 net/bluetooth/hci_core.c:4071
 process_one_work+0x9cf/0x1b70 kernel/workqueue.c:3236
 process_scheduled_works kernel/workqueue.c:3319 [inline]
 worker_thread+0x6c8/0xf10 kernel/workqueue.c:3400
 kthread+0x3c2/0x780 kernel/kthread.c:463
 ret_from_fork+0x5d7/0x6f0 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Freed by task 16995:
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
 kasan_save_track+0x14/0x30 mm/kasan/common.c:68
 kasan_save_free_info+0x3b/0x60 mm/kasan/generic.c:576
 poison_slab_object mm/kasan/common.c:243 [inline]
 __kasan_slab_free+0x60/0x70 mm/kasan/common.c:275
 kasan_slab_free include/linux/kasan.h:233 [inline]
 slab_free_hook mm/slub.c:2417 [inline]
 slab_free mm/slub.c:4680 [inline]
 kfree+0x2b4/0x4d0 mm/slub.c:4879
 sk_prot_free net/core/sock.c:2278 [inline]
 __sk_destruct+0x75f/0x9a0 net/core/sock.c:2373
 sk_destruct+0xc2/0xf0 net/core/sock.c:2401
 __sk_free+0xf4/0x3e0 net/core/sock.c:2412
 sk_free+0x6a/0x90 net/core/sock.c:2423
 sock_put include/net/sock.h:1960 [inline]
 bt_accept_unlink+0x245/0x2e0 net/bluetooth/af_bluetooth.c:262
 bt_accept_dequeue+0x517/0x600 net/bluetooth/af_bluetooth.c:308
 l2cap_sock_cleanup_listen+0x5c/0x2a0 net/bluetooth/l2cap_sock.c:1451
 l2cap_sock_release+0x5c/0x210 net/bluetooth/l2cap_sock.c:1425
 __sock_release+0xb3/0x270 net/socket.c:649
 sock_close+0x1c/0x30 net/socket.c:1439
 __fput+0x3ff/0xb70 fs/file_table.c:468
 task_work_run+0x14d/0x240 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop+0xeb/0x110 kernel/entry/common.c:43
 exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
 do_syscall_64+0x3f6/0x4c0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: 1728137b33c0 ("Bluetooth: L2CAP: Fix use-after-free in l2cap_sock_ready_cb")
Reported-by: syzbot+e5e64cdf8e92046dd3e1@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-bluetooth/68af6b9d.a70a0220.3cafd4.0032.GAE@google.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_sock.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 93df53f2b76e3..dfffc5bb292dd 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1226,7 +1226,10 @@ static int l2cap_sock_release(struct socket *sock)
 	if (!sk)
 		return 0;
 
+	lock_sock_nested(sk, L2CAP_NESTING_PARENT);
 	l2cap_sock_cleanup_listen(sk);
+	release_sock(sk);
+
 	bt_sock_unlink(&l2cap_sk_list, sk);
 
 	err = l2cap_sock_shutdown(sock, 2);
-- 
2.50.1



