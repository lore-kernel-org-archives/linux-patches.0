Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624348;
	b=f1dmZ4pMnpW2mPjNt6Jw7CG4RI5+pT/1Fv1FKSdi9UVsBKWzdmqSj79EC5BIx6xBa7Lm
	 IJUfB8qotkyURI7zqKFMj05hENze4M1rigkQejD2oLsyG5z2NAFRLvRv6JUnY4+Bm+KfW
	 ZzR6w2qa0kbml5EWVXQlES1nEQoyjy4vNkmXS/xH+02EgDEdOnT7xQq+3lFoj/Add/kcW
	 CNO6M0lBmdmatDhEXQ4AACvhI+W6xWxPXx/Q+PHj7KYe33dYBhUBXECPJAke7is7C7Krl
	 ylWh6qMqYoGb3Wp69bAIwwNWprDwUxyB4WNigekXm7VyNPoU12eqZCy45lNr09T/joQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624348;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fIwtf9ldTNnBFE4kNbEmXN6vYh/PA7crYVr8C9xrRuw=;
	b=ra07g08Tj0xWdcKVsBxAdxrTc5Zf0cQKgnxsXlNBS5YcZ8InH+Wf5vbwWwqsNAbmFC7q
	 hfizn3NbTyD9/pdoJWVwDMXRp++hF6P8bjLFVZSapkZ2g17zFQF/BQaS7xIoFA+/4gJeP
	 EjeqRELBufIGxz0e0nwbCzJgw05n8Y2OR/Ic01VsZcOT/34b2OWivCXK/ffKyhSYt4sdQ
	 pdn/qSFeWAHw1JLwlpylX5lhrwI383Xrv3noTqLlwyKPZFJlO2QaAytLv5NI+VnTTtnxf
	 Bprzl0UwC+mHUOSTeN999xmSV67pb9zTMugHX6wW8p0w1L9H0BnsRsIA/JMcugIoJlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sX71U5gA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C404606A332;
	Wed, 25 Nov 2026 16:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sX71U5gA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9251F000C0;
	Wed, 25 Nov 2026 16:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624348;
	bh=fIwtf9ldTNnBFE4kNbEmXN6vYh/PA7crYVr8C9xrRuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sX71U5gA1Bsg4jLP6NxMNKPDW7trbGizD+XIwpClDsrff5kEGBi2KgITYXZfkV13Q
	 jHrkQVFZl8Cw0HoK2ps8ocBxlXWo8uEAe2J4BQluT292g0s1CWbd8dFwW9QpsJ8Wf6
	 HZEJjTjil2Bw0PEY/UURMIwR2qDFOmk29hyalyiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 163/816] Bluetooth: hci_sync: Copy the resolving-list IRK under RCU
Date: Wed, 25 Nov 2026 15:28:31 +0100
Message-ID: <20261125143852.969437106@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 9ff737119177a6c1ce6083ef8c0fc06355f11869 ]

hci_le_add_resolve_list_sync() copies the peer IRK into the LE Add
Device To Resolving List command after hci_find_irk_by_addr() has
returned. The finder ends its RCU read-side section before returning
the borrowed entry, and neither the request worker nor
interleave_scan_work() holds hdev->lock here. The resolving-list
membership check between the lookup and the copy takes hdev->lock and
may sleep on it, which widens the window.

When LL privacy programs a peer with address resolution enabled,
MGMT_OP_LOAD_IRKS can free its IRK before the copy:

  Request worker                   Management / RCU reclamation
  hci_le_add_resolve_list_sync()
    irk = hci_find_irk_by_addr()
                                   load_irks()
                                     hci_dev_lock(hdev)
                                     hci_smp_irks_clear(hdev)
                                       list_del_rcu(), kfree_rcu()
                                     hci_dev_unlock(hdev)
                                   grace period ends, irk is freed
    resolving-list membership check
    memcpy(cp.peer_irk, irk->val, 16)

Copy the IRK value in an RCU read-side section right after the lookup,
as hci_le_set_privacy_mode_sync() does for the identity address. The
section ends before hdev->lock is taken and before the synchronous HCI
command is sent.

KASAN reported this on a test kernel with scheduling hooks, whose
frames appear in the trace. The report predates the hdev->lock taken
by the membership check.

KASAN report as below:

    ==================================================================
    BUG: KASAN: slab-use-after-free in hci_le_add_resolve_list_sync+0x8d9/0x910
    Read of size 16 at addr ffff88810d21452d by task kworker/u17:0/504

    CPU: 2 UID: 0 PID: 504 Comm: kworker/u17:0 Not tainted 7.2.0-rc6-pmb-bt-functional-v1+ #2 PREEMPT(lazy)
    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    Workqueue: hci0 interleave_scan_work
    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     ? hci_le_add_resolve_list_sync+0x8d9/0x910
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __virt_addr_valid+0x20d/0x410
     ? hci_le_add_resolve_list_sync+0x8d9/0x910
     kasan_report+0xe0/0x110
     ? hci_le_add_resolve_list_sync+0x8d9/0x910
     hci_le_add_resolve_list_sync+0x8d9/0x910
     ? __pfx_hci_le_add_resolve_list_sync+0x10/0x10
     ? pmbd_probe_hit_cookie+0xe7/0x1c0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? pmbd_probe_hit_cookie+0xee/0x1c0
     ? __pfx_pmbd_probe_hit_cookie+0x10/0x10
     hci_le_add_accept_list_sync+0x18e/0x820
     ? conn_params_copy+0x36e/0x650
     ? __pfx_hci_le_add_accept_list_sync+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? conn_params_copy+0x3a0/0x650
     hci_passive_scan_sync+0x95f/0x1f10
     ? __pfx_hci_passive_scan_sync+0x10/0x10
     ? debug_object_deactivate+0x2f8/0x3c0
     ? pwq_dec_nr_in_flight+0x880/0xdf0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_acquire+0x17b/0x2f0
     ? process_one_work+0x895/0x19c0
     interleave_scan_work+0x11b/0x470
     process_one_work+0x908/0x19c0
     ? __pfx_process_one_work+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_is_held_type+0x8f/0x100
     ? srso_alias_return_thunk+0x5/0xfbef5
     worker_thread+0x65c/0xe40
     ? __pfx_worker_thread+0x10/0x10
     kthread+0x34f/0x460
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_kthread+0x10/0x10
     ret_from_fork+0x659/0x940
     ? __pfx_ret_from_fork+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __switch_to+0x74f/0xf80
     ? __pfx_kthread+0x10/0x10
     ret_from_fork_asm+0x1a/0x30
     </TASK>

    Allocated by task 535:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_kmalloc+0xaa/0xb0
     __kmalloc_cache_noprof+0x251/0x610
     hci_add_irk+0xb6/0x220
     load_irks+0x5f9/0x840
     hci_sock_sendmsg+0x128b/0x22e0
     __sys_sendto+0x425/0x470
     __x64_sys_sendto+0xe5/0x1c0
     do_syscall_64+0x115/0x6a0
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    Freed by task 0:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     kasan_save_free_info+0x3b/0x60
     __kasan_slab_free+0x5f/0x80
     __rcu_free_sheaf_prepare+0x65/0x2a0
     rcu_free_sheaf+0x1f/0xe0
     rcu_core+0x661/0x1d10
     handle_softirqs+0x201/0x930
     __irq_exit_rcu+0x110/0x1e0
     irq_exit_rcu+0xe/0x20
     sysvec_apic_timer_interrupt+0x6c/0x80
     asm_sysvec_apic_timer_interrupt+0x1a/0x20

    The buggy address belongs to the object at ffff88810d214500
     which belongs to the cache kmalloc-64 of size 64
    The buggy address is located 45 bytes inside of
     freed 64-byte region [ffff88810d214500, ffff88810d214540)

    The buggy address belongs to the physical page:
    page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x10d214
    flags: 0x200000000000000(node=0|zone=2)
    page_type: f5(slab)
    raw: 0200000000000000 ffff8881000428c0 dead000000000100 dead000000000122
    raw: 0000000000000000 0000000000200020 00000000f5000000 0000000000000000
    page dumped because: kasan: bad access detected

    Memory state around the buggy address:
     ffff88810d214400: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
     ffff88810d214480: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
    >ffff88810d214500: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                                      ^
     ffff88810d214580: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
     ffff88810d214600: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
    ==================================================================

Fixes: e8907f76544f ("Bluetooth: hci_sync: Make use of hci_cmd_sync_queue set 3")
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index c6ae135f1b3b6..d0ae0e01c52f7 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2575,9 +2575,17 @@ static int hci_le_add_resolve_list_sync(struct hci_dev *hdev,
 		goto done;
 	}
 
+	rcu_read_lock();
+
 	irk = hci_find_irk_by_addr(hdev, &params->addr, params->addr_type);
-	if (!irk)
+	if (!irk) {
+		rcu_read_unlock();
 		return 0;
+	}
+
+	memcpy(cp.peer_irk, irk->val, 16);
+
+	rcu_read_unlock();
 
 	/* Check if the IK has _not_ been programmed yet. */
 	hci_dev_lock(hdev);
@@ -2589,7 +2597,6 @@ static int hci_le_add_resolve_list_sync(struct hci_dev *hdev,
 
 	cp.bdaddr_type = params->addr_type;
 	bacpy(&cp.bdaddr, &params->addr);
-	memcpy(cp.peer_irk, irk->val, 16);
 
 	/* Default privacy mode is always Network */
 	params->privacy_mode = HCI_NETWORK_PRIVACY;
-- 
2.53.0



