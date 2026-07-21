Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1514398FB;
	Tue, 21 Jul 2026 21:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669814; cv=none; b=cvAe0yrQCgd9h2ObPKVzYB6G0kFdjMJg5naYpJ4Ugw63iScBTWDgJhhoNXZ7vIH4Iz2z3YiiKeazTJQRTmNXRNxWqmMMqH0zGekETIsb6XhagGQMziVqfWQxYdzz0RHsiXgIEkwpGGb8X2w/z6l+damptgotFX73q6yuvtDxNFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669814; c=relaxed/simple;
	bh=5Dg7jEGJrwFEono/VSUnNOzyyyDWzG+hPpbgKlpbjIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gU4asqkoHgSmMPszm+3u3YGKKrcz5A2a4YjPxncohe5yMLowhLhqR/kxl8XQG7LIqNC+GPXtoP0oX1fRxWGvyIYSS5FHePUgSsu1soyQ/JlZxExRbrbotmD8VGnuk/ieZ7bwqu1QvALnOmS9ZcC44obP/TrJeE3KH8Ng1kY5iyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ThHl5vLd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ThHl5vLd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1E31F00A3A;
	Tue, 21 Jul 2026 21:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669812;
	bh=J8uAk7ZXPVwOQIyz5BbaG98W1uU/nD2Tzzt1P2TNq6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ThHl5vLdnU3fCZ4Kh8WJ319Qt1Yn9AX39MyXOHM0wIWU1a875BtRnZopfJf76LrPx
	 86nK6pAiKlitBfu7cipkIyFSBv+NrCvZqkEKi4lswntKP0YBwWxpJOW3nZn1LvIOtp
	 3N0LSfYHg3h+JM2lp2MWEV6hDED8v1jqSIkbtocc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0694/1067] Bluetooth: MGMT: Fix adv monitor add failure cleanup
Date: Tue, 21 Jul 2026 17:21:35 +0200
Message-ID: <20260721152440.119759065@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 384a4b2fef9ffe5e270ee5558975c0504881c5fb ]

hci_add_adv_monitor() publishes a new adv_monitor in
hdev->adv_monitors_idr before the powered MSFT setup step. The MSFT
offload add path can then fail either locally before the controller add
command completes, or in the MSFT add callback. In the current queued
management add flow, hci_cmd_sync_work() still invokes
mgmt_add_adv_patterns_monitor_complete() with the original pending command
after msft_add_monitor_pattern() returns.

The buggy scenario involves two paths, with each column showing the order
within that path:

MSFT add handling                  MGMT completion
1. insert monitor and handle       1. receive sync error
2. send MSFT add command           2. call add-monitor completion
3. callback sees bad response      3. load cmd->user_data
4. callback frees monitor          4. read monitor->handle

Local MSFT setup failures have the other half of the same ownership bug:
they return an error after the IDR insertion, but no later code removes the
failed monitor from the IDR.

Keep ownership with the pending management command until its completion.
For normal management adds, the MSFT add callback now records successful
controller state and returns errors to its caller. The management
completion frees the monitor on non-success after copying the response
handle, while resume/reregister callback-error cleanup remains in the
MSFT callback. The success path keeps the existing bookkeeping.

Validation reproduced this kernel report:
BUG: KASAN: slab-use-after-free in mgmt_add_adv_patterns_monitor_complete+0xfb/0x260 [bluetooth]

Call Trace:
 <TASK>
 dump_stack_lvl+0x66/0xa0
 print_report+0xce/0x5f0
 ? mgmt_add_adv_patterns_monitor_complete+0xfb/0x260 [bluetooth]
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __virt_addr_valid+0x19f/0x330
 ? mgmt_add_adv_patterns_monitor_complete+0xfb/0x260 [bluetooth]
 kasan_report+0xe0/0x110
 ? mgmt_add_adv_patterns_monitor_complete+0xfb/0x260 [bluetooth]
 mgmt_add_adv_patterns_monitor_complete+0xfb/0x260 [bluetooth]
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? 0xffffffffc00d00da
 ? __pfx_mgmt_add_adv_patterns_monitor_complete+0x10/0x10 [bluetooth]
 ? __pfx_mgmt_add_adv_patterns_monitor_complete+0x10/0x10 [bluetooth]
 ? hci_cmd_sync_work+0x1ab/0x210 [bluetooth]
 hci_cmd_sync_work+0x1c0/0x210 [bluetooth]
 ? __pfx_mgmt_add_adv_patterns_monitor_complete+0x10/0x10 [bluetooth]
 process_one_work+0x4fd/0xbc0
 ? __pfx_process_one_work+0x10/0x10
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __list_add_valid_or_report+0x37/0xf0
 ? __pfx_hci_cmd_sync_work+0x10/0x10 [bluetooth]
 ? srso_alias_return_thunk+0x5/0xfbef5
 worker_thread+0x2d8/0x570
 ? __pfx_worker_thread+0x10/0x10
 kthread+0x1ad/0x1f0
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x3c9/0x540
 ? __pfx_ret_from_fork+0x10/0x10
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __switch_to+0x2e9/0x730
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Allocated by task 471 on cpu 3 at 285.205389s:
 kasan_save_stack+0x33/0x60
 kasan_save_track+0x17/0x60
 __kasan_kmalloc+0xaa/0xb0
 add_adv_patterns_monitor_rssi+0xd5/0x230 [bluetooth]
 hci_sock_sendmsg+0x96b/0xf80 [bluetooth]
 __sys_sendto+0x2bc/0x2d0
 __x64_sys_sendto+0x76/0x90
 do_syscall_64+0x115/0x6a0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 454 on cpu 2 at 285.217112s:
 kasan_save_stack+0x33/0x60
 kasan_save_track+0x17/0x60
 kasan_save_free_info+0x3b/0x60
 __kasan_slab_free+0x5f/0x80
 kfree+0x313/0x590
 msft_add_monitor_sync+0x54a/0x570 [bluetooth]
 hci_add_adv_monitor+0x133/0x180 [bluetooth]
 hci_cmd_sync_work+0x187/0x210 [bluetooth]
 process_one_work+0x4fd/0xbc0
 worker_thread+0x2d8/0x570
 kthread+0x1ad/0x1f0
 ret_from_fork+0x3c9/0x540
 ret_from_fork_asm+0x1a/0x30

Fixes: a2a4dedf88ab ("Bluetooth: advmon offload MSFT add monitor")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 2 ++
 net/bluetooth/msft.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index cd494f5ebb4dba..5a4a9f716e5de6 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -5343,6 +5343,8 @@ static void mgmt_add_adv_patterns_monitor_complete(struct hci_dev *hdev,
 		if (monitor->state == ADV_MONITOR_STATE_NOT_REGISTERED)
 			monitor->state = ADV_MONITOR_STATE_REGISTERED;
 		hci_update_passive_scan(hdev);
+	} else {
+		hci_free_adv_monitor(hdev, monitor);
 	}
 
 	mgmt_cmd_complete(cmd->sk, cmd->index, cmd->opcode,
diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index 076cf8bce4d9e3..39c7fc8c5a17ed 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -246,7 +246,7 @@ static int msft_le_monitor_advertisement_cb(struct hci_dev *hdev, u16 opcode,
 	monitor->state = ADV_MONITOR_STATE_OFFLOADED;
 
 unlock:
-	if (status)
+	if (status && msft->resuming)
 		hci_free_adv_monitor(hdev, monitor);
 
 	hci_dev_unlock(hdev);
-- 
2.53.0



