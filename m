Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AC130D3F6;
	Thu, 16 Jul 2026 14:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210781; cv=none; b=TMnwKIAa/ePS8l+rotPW6mlTE29seHWEdV305DPdqLHCe7SugCFnIYNcTiRTlZomEkTKySL0hTYAP78Hj/ErMV6/aYs3WgAWQH6mc7wbYTTQ32b41L9QKxF//AjiAcW0u2aYYhZe2Xk4wAuqdgtABChsxxfLSp8dgzCzof2/U84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210781; c=relaxed/simple;
	bh=S9KSm71HcWXofqLTMGRj8FBNwZjaxveRaruXr4rZSxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4AQTEeEpjHcGuMktr9ugUOq16nBHTln4VqOJwASdeMl2K35MrslwJqwZpEk/IqRNOndOXnLdBcu8xu6INQMAm5s9gvBTN4Zer2viJdrJma4y7OFh6NRr0L+HZaivq2jsl/vdszqdNBC3O0TWl5voKED49hRKCaWFIFMSCFWTnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fv3O0Vor; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fv3O0Vor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E841F000E9;
	Thu, 16 Jul 2026 14:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210776;
	bh=POsWuDtwKFw2o8ezmLJM2mxmfckrlZe51K9orDihMC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fv3O0Voru7KeBHVdBs4Wbu3JVczGShfM1mOB6FZs5dowQzN7xoBGfLD7HwEZ/v969
	 edYT7sQ4QW4yRNAG3CDD+sYmfgpWFUzhVWgPLFR+I1igv4pt4d0No116R7CiwJ/vaM
	 hBsqZGpqwcJTWCQljDTfwSUTWs5DWIh8MO46gs2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Page <sam@bynar.io>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 175/480] Bluetooth: MGMT: Fix UAF of hci_conn_params in add_device_complete
Date: Thu, 16 Jul 2026 15:28:42 +0200
Message-ID: <20260716133048.499230104@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Samuel Page <sam@bynar.io>

commit fa85d985f614bc3feb343000f14a1072e99b0df1 upstream.

add_device_complete() runs from the hci_cmd_sync_work kworker, which
holds only hci_req_sync_lock and *not* hci_dev_lock.  It calls
hci_conn_params_lookup() and then dereferences the returned object
(params->flags) without taking hci_dev_lock:

	params = hci_conn_params_lookup(hdev, &cp->addr.bdaddr,
					le_addr_type(cp->addr.type));
	...
	device_flags_changed(NULL, hdev, &cp->addr.bdaddr,
			     cp->addr.type, hdev->conn_flags,
			     params ? params->flags : 0);

hci_conn_params_lookup() walks hdev->le_conn_params and is documented to
require hdev->lock.  A concurrent MGMT_OP_REMOVE_DEVICE
(remove_device()), which does run under hci_dev_lock, can call
hci_conn_params_free() to list_del() and kfree() the very object the
lookup returned, so the subsequent params->flags read touches freed
memory [0].

Hold hci_dev_lock() across the hci_conn_params_lookup() and the read of
params->flags (and the matching event emission) so the lookup result
cannot be freed by a concurrent remove_device() before it is used,
honouring the locking contract of hci_conn_params_lookup().

[0]: (trailing page/memory-state dump trimmed)
BUG: KASAN: slab-use-after-free in add_device_complete+0x358/0x3d8 net/bluetooth/mgmt.c:7671
Read of size 1 at addr ffff000017ab26c1 by task kworker/u9:8/388

CPU: 1 UID: 0 PID: 388 Comm: kworker/u9:8 Not tainted 7.0.11 #20 PREEMPT
Hardware name: linux,dummy-virt (DT)
Workqueue: hci0 hci_cmd_sync_work
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0xb4/0xd4 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x118/0x5d8 mm/kasan/report.c:482
 kasan_report+0xb0/0xf4 mm/kasan/report.c:595
 __asan_report_load1_noabort+0x20/0x2c mm/kasan/report_generic.c:378
 add_device_complete+0x358/0x3d8 net/bluetooth/mgmt.c:7671
 hci_cmd_sync_work+0x14c/0x240 net/bluetooth/hci_sync.c:334
 process_one_work+0x628/0xd38 kernel/workqueue.c:3289
 process_scheduled_works kernel/workqueue.c:3372 [inline]
 worker_thread+0x7a8/0xac0 kernel/workqueue.c:3453
 kthread+0x39c/0x444 kernel/kthread.c:436
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:860

Allocated by task 3401:
 kasan_save_stack+0x3c/0x64 mm/kasan/common.c:57
 kasan_save_track+0x20/0x3c mm/kasan/common.c:78
 kasan_save_alloc_info+0x40/0x54 mm/kasan/generic.c:570
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0xd4/0xd8 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __kmalloc_cache_noprof+0x1b0/0x458 mm/slub.c:5385
 kmalloc_noprof include/linux/slab.h:950 [inline]
 kzalloc_noprof include/linux/slab.h:1188 [inline]
 hci_conn_params_add+0x10c/0x4b0 net/bluetooth/hci_core.c:2279
 hci_conn_params_set net/bluetooth/mgmt.c:5162 [inline]
 add_device+0x5b4/0xa54 net/bluetooth/mgmt.c:7755
 hci_mgmt_cmd net/bluetooth/hci_sock.c:1721 [inline]
 hci_sock_sendmsg+0x10b4/0x1dd0 net/bluetooth/hci_sock.c:1841
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg+0xe0/0x128 net/socket.c:742
 sock_write_iter+0x250/0x390 net/socket.c:1195
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x66c/0xab0 fs/read_write.c:688
 ksys_write+0x1fc/0x24c fs/read_write.c:740
 __do_sys_write fs/read_write.c:751 [inline]
 __se_sys_write fs/read_write.c:748 [inline]
 __arm64_sys_write+0x70/0xa4 fs/read_write.c:748
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x84/0x2a8 arch/arm64/kernel/syscall.c:49
 el0_svc_common.constprop.0+0xe4/0x294 arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x44/0x5c arch/arm64/kernel/syscall.c:151
 el0_svc+0x38/0xac arch/arm64/kernel/entry-common.c:724
 el0t_64_sync_handler+0xa0/0xe4 arch/arm64/kernel/entry-common.c:743
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

Freed by task 3740:
 kasan_save_stack+0x3c/0x64 mm/kasan/common.c:57
 kasan_save_track+0x20/0x3c mm/kasan/common.c:78
 kasan_save_free_info+0x4c/0x74 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x88/0xb8 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2685 [inline]
 slab_free mm/slub.c:6170 [inline]
 kfree+0x14c/0x458 mm/slub.c:6488
 hci_conn_params_free+0x288/0x484 net/bluetooth/hci_core.c:2312
 remove_device+0x4b0/0x968 net/bluetooth/mgmt.c:7919
 hci_mgmt_cmd net/bluetooth/hci_sock.c:1721 [inline]
 hci_sock_sendmsg+0x10b4/0x1dd0 net/bluetooth/hci_sock.c:1841
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg+0xe0/0x128 net/socket.c:742
 sock_write_iter+0x250/0x390 net/socket.c:1195
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x66c/0xab0 fs/read_write.c:688
 ksys_write+0x1fc/0x24c fs/read_write.c:740
 __do_sys_write fs/read_write.c:751 [inline]
 __se_sys_write fs/read_write.c:748 [inline]
 __arm64_sys_write+0x70/0xa4 fs/read_write.c:748
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x84/0x2a8 arch/arm64/kernel/syscall.c:49
 el0_svc_common.constprop.0+0xe4/0x294 arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x44/0x5c arch/arm64/kernel/syscall.c:151
 el0_svc+0x38/0xac arch/arm64/kernel/entry-common.c:724
 el0t_64_sync_handler+0xa0/0xe4 arch/arm64/kernel/entry-common.c:743
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

Fixes: 1e2e3044c1bc ("Bluetooth: MGMT: Fix MGMT_OP_ADD_DEVICE invalid device flags")
Cc: stable@vger.kernel.org
Assisted-by: Bynario AI
Signed-off-by: Samuel Page <sam@bynar.io>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/mgmt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -7641,6 +7641,8 @@ static void add_device_complete(struct h
 	if (!err) {
 		struct hci_conn_params *params;
 
+		hci_dev_lock(hdev);
+
 		params = hci_conn_params_lookup(hdev, &cp->addr.bdaddr,
 						le_addr_type(cp->addr.type));
 
@@ -7649,6 +7651,7 @@ static void add_device_complete(struct h
 		device_flags_changed(NULL, hdev, &cp->addr.bdaddr,
 				     cp->addr.type, hdev->conn_flags,
 				     params ? params->flags : 0);
+		hci_dev_unlock(hdev);
 	}
 
 	mgmt_cmd_complete(cmd->sk, hdev->id, MGMT_OP_ADD_DEVICE,


