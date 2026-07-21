Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FB0356746;
	Tue, 21 Jul 2026 19:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663315; cv=none; b=eqasNDuAxI50hqkpEBv2v7Fg29gAMij9SyeVcH6eFzmMRJzFY/0+f2onvZxGPANjdW7SFv30cGRgZCCXfAtJV9kFDjJFTohv8Ey8vNhQ/sZCZDWiFst54iSyoHu8Uw7VDUk241gz30AlIjySJ8Wsl/kNC0xojQnyIDyyp6P7q0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663315; c=relaxed/simple;
	bh=bMpS79zY4Y+oHY0SlnM9MP68pT3BP5n4W88nf3G4i60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=na9QOzXwoz21cxWBI80cA2MjP95A5VfI+CF+NuoGOyfaWKEZ4gmx3arXtlXNJeg+c11fyPVTAPG/EgdA/lJq6w7r0ZPsZGaoAujqIDiO8AB8kxjLXxv+NOCP/Im5/RH5SyAIg0M0deG9QMbpceDmP7o6Ol1gKs7ndL+KXK6eC1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nNaRRwYU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nNaRRwYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5911F000E9;
	Tue, 21 Jul 2026 19:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663313;
	bh=Zxno7IGbO7uwngipd8AE6zK70tDcZ8jz2GjehksVuWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nNaRRwYUbNQTETH9l+gsafx3mBky6DQZdWfkg8x97/TAzNi6bc/Uqhm1yz4Xt/+S8
	 no+TtVvQ0OuPj6jXYjiDwQ1/UhbDdCl49Aj80e4ebeNM3b35keeRlqzaJzGTzWgXm0
	 iIkFR9j9q0pgukZd3/6745sOjWyU/IE7RKBans9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0775/1276] Bluetooth: MGMT: Fix adv monitor add failure cleanup
Date: Tue, 21 Jul 2026 17:20:18 +0200
Message-ID: <20260721152503.420099682@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 06067fc406553b..0a971e374dc20b 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -5355,6 +5355,8 @@ static void mgmt_add_adv_patterns_monitor_complete(struct hci_dev *hdev,
 		if (monitor->state == ADV_MONITOR_STATE_NOT_REGISTERED)
 			monitor->state = ADV_MONITOR_STATE_REGISTERED;
 		hci_update_passive_scan(hdev);
+	} else {
+		hci_free_adv_monitor(hdev, monitor);
 	}
 
 	mgmt_cmd_complete(cmd->sk, cmd->hdev->id, cmd->opcode,
diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index 5a8ccc491b1444..0da28910d00b83 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -291,7 +291,7 @@ static int msft_le_monitor_advertisement_cb(struct hci_dev *hdev, u16 opcode,
 	monitor->state = ADV_MONITOR_STATE_OFFLOADED;
 
 unlock:
-	if (status)
+	if (status && msft->resuming)
 		hci_free_adv_monitor(hdev, monitor);
 
 	hci_dev_unlock(hdev);
-- 
2.53.0



