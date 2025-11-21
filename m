Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5483834DCD2;
	Fri, 21 Nov 2025 13:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732912; cv=none; b=hlnq95w8POoJtmuZJ0TNeCYnBFmnLL0OroMLNh7kY/HF9hULfrouTYlSe9W0mOW/NgtqU8tVP/NM4tfCZnetNzPQtySDQIO0grSXmpXsg1hYqqszWx+9rr6t6h8/3dPzy7t8jPbcpCL4qFDccC0N11GTE67xbv9Z2JlNWEZgrGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732912; c=relaxed/simple;
	bh=ed39UO4U51EyAPsuwmJ3SLVhLrg1AV+JebrtNI2wPho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bffmtfqSplBlV2oQqFPenhUm+x5sxJz797XphKchpbc7ToRUoBLlEO6hIJxEoCxLWkZZ94UTKEOxLkMBBmHGnRCGHuGknAv6+6l3MKnuGl8le7HNUmrGzTUtTPNF226xtlY3zI/klBDCzO3uBUmcLuaF5xduystyogk7400gbWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FHBpczXt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FHBpczXt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC0C0C4CEF1;
	Fri, 21 Nov 2025 13:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732912;
	bh=ed39UO4U51EyAPsuwmJ3SLVhLrg1AV+JebrtNI2wPho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FHBpczXtsBTrj6vwlNxmQSzefrshzr45DrIuxUUFOUlKvnlrF0oU3jowNR8s5L1TF
	 a0jgXAu3BgBjqnFIsabgLDPx6kXOMaSVyrK1AcLof6Nq7Zswb/aRwI1BJQri1wpgxu
	 PSikwPiE4TOIYLJaLcRvAJFAcuzjUzzP8HfIrBr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	cen zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 287/529] Bluetooth: SCO: Fix UAF on sco_conn_free
Date: Fri, 21 Nov 2025 14:09:46 +0100
Message-ID: <20251121130241.241367877@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit ecb9a843be4d6fd710d7026e359f21015a062572 ]

BUG: KASAN: slab-use-after-free in sco_conn_free net/bluetooth/sco.c:87 [inline]
BUG: KASAN: slab-use-after-free in kref_put include/linux/kref.h:65 [inline]
BUG: KASAN: slab-use-after-free in sco_conn_put+0xdd/0x410
net/bluetooth/sco.c:107
Write of size 8 at addr ffff88811cb96b50 by task kworker/u17:4/352

CPU: 1 UID: 0 PID: 352 Comm: kworker/u17:4 Not tainted
6.17.0-rc5-g717368f83676 #4 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
Workqueue: hci13 hci_cmd_sync_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x10b/0x170 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x191/0x550 mm/kasan/report.c:482
 kasan_report+0xc4/0x100 mm/kasan/report.c:595
 sco_conn_free net/bluetooth/sco.c:87 [inline]
 kref_put include/linux/kref.h:65 [inline]
 sco_conn_put+0xdd/0x410 net/bluetooth/sco.c:107
 sco_connect_cfm+0xb4/0xae0 net/bluetooth/sco.c:1441
 hci_connect_cfm include/net/bluetooth/hci_core.h:2082 [inline]
 hci_conn_failed+0x20a/0x2e0 net/bluetooth/hci_conn.c:1313
 hci_conn_unlink+0x55f/0x810 net/bluetooth/hci_conn.c:1121
 hci_conn_del+0xb6/0x1110 net/bluetooth/hci_conn.c:1147
 hci_abort_conn_sync+0x8c5/0xbb0 net/bluetooth/hci_sync.c:5689
 hci_cmd_sync_work+0x281/0x380 net/bluetooth/hci_sync.c:332
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0x77e/0x1040 kernel/workqueue.c:3319
 worker_thread+0xbee/0x1200 kernel/workqueue.c:3400
 kthread+0x3c7/0x870 kernel/kthread.c:463
 ret_from_fork+0x13a/0x1e0 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Allocated by task 31370:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x30/0x70 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:388 [inline]
 __kasan_kmalloc+0x82/0x90 mm/kasan/common.c:405
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __do_kmalloc_node mm/slub.c:4382 [inline]
 __kmalloc_noprof+0x22f/0x390 mm/slub.c:4394
 kmalloc_noprof include/linux/slab.h:909 [inline]
 sk_prot_alloc+0xae/0x220 net/core/sock.c:2239
 sk_alloc+0x34/0x5a0 net/core/sock.c:2295
 bt_sock_alloc+0x3c/0x330 net/bluetooth/af_bluetooth.c:151
 sco_sock_alloc net/bluetooth/sco.c:562 [inline]
 sco_sock_create+0xc0/0x350 net/bluetooth/sco.c:593
 bt_sock_create+0x161/0x3b0 net/bluetooth/af_bluetooth.c:135
 __sock_create+0x3ad/0x780 net/socket.c:1589
 sock_create net/socket.c:1647 [inline]
 __sys_socket_create net/socket.c:1684 [inline]
 __sys_socket+0xd5/0x330 net/socket.c:1731
 __do_sys_socket net/socket.c:1745 [inline]
 __se_sys_socket net/socket.c:1743 [inline]
 __x64_sys_socket+0x7a/0x90 net/socket.c:1743
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xc7/0x240 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 31374:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x30/0x70 mm/kasan/common.c:68
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:576
 poison_slab_object mm/kasan/common.c:243 [inline]
 __kasan_slab_free+0x3d/0x50 mm/kasan/common.c:275
 kasan_slab_free include/linux/kasan.h:233 [inline]
 slab_free_hook mm/slub.c:2428 [inline]
 slab_free mm/slub.c:4701 [inline]
 kfree+0x199/0x3b0 mm/slub.c:4900
 sk_prot_free net/core/sock.c:2278 [inline]
 __sk_destruct+0x4aa/0x630 net/core/sock.c:2373
 sco_sock_release+0x2ad/0x300 net/bluetooth/sco.c:1333
 __sock_release net/socket.c:649 [inline]
 sock_close+0xb8/0x230 net/socket.c:1439
 __fput+0x3d1/0x9e0 fs/file_table.c:468
 task_work_run+0x206/0x2a0 kernel/task_work.c:227
 get_signal+0x1201/0x1410 kernel/signal.c:2807
 arch_do_signal_or_restart+0x34/0x740 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop+0x68/0xc0 kernel/entry/common.c:40
 exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
 do_syscall_64+0x1dd/0x240 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Reported-by: cen zhang <zzzccc427@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/sco.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 64d4d57c7033a..6635d155e360b 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -433,6 +433,13 @@ static void sco_sock_kill(struct sock *sk)
 
 	BT_DBG("sk %p state %d", sk, sk->sk_state);
 
+	/* Sock is dead, so set conn->sk to NULL to avoid possible UAF */
+	if (sco_pi(sk)->conn) {
+		sco_conn_lock(sco_pi(sk)->conn);
+		sco_pi(sk)->conn->sk = NULL;
+		sco_conn_unlock(sco_pi(sk)->conn);
+	}
+
 	/* Kill poor orphan */
 	bt_sock_unlink(&sco_sk_list, sk);
 	sock_set_flag(sk, SOCK_DEAD);
-- 
2.51.0



