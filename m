Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624332;
	b=VDEkLokbv4pPf2EV+foXW9B1r4TAUlykH4qDAxZZJ/BHhHM09EBgk8d7gJO+b06h9o4Q
	 c+LO/8HCPBCucShI3yEXiYww9DOnVdmksGJPVNLtCePlgn+LscpBatS+WIXZsmSPfKX+J
	 qwI8yhVMbBxoxGS43UKFMacHP8OZZz2NJ8UY3CZ18Sj3nCj5FW+NihJ/BXVyJmvk+cJM7
	 GyvbUYfK6pCVl8CwAW6CFb1um7mW3wkZS24vouNq/JrxvJaTbL4/ReChpGGPObn+D5JH2
	 nBiLnlAQjz8pkA5KnatjsZJTYYNh6sH0AApFgiA1JDMfsrPY3Tu14sdkGSMJZrxTL0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624332;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zCxcN1LYHLhD4qHH0lmKbiV45NaW5O4E0WDAJKNeO84=;
	b=4E7TzwN3u6H793ymB8IEnsg8TrzDhhZJzfdIE8YOFijE9n4AE423nip4EXGiyoN47aiX
	 KcA6OvClaYICqEjmNowm0d+RnEt2/0WMCevBVgs7pmzavbWJ0Td7OjXavq4EcOu47tVdX
	 kdHoG4zXcHcJICjqpHkRGaxDsarNPK8lFcp1mmiP1sVkETbIbnNdnZFEW2xBA037vhDjA
	 G95G3OjSuXrbsMdBO/3tsJHBYd/PlEy9YBlq3uD3FiB1gJV8/xlwhvyYcCT1fVfFNVJKH
	 me3ESxAIwG0NSS91ZsTBokJ5qMttE1RvApUwhy63xwiVVt6fcCgNc6X2Gtu8MD4Or6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G5k5stKC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC0D606A338;
	Wed, 25 Nov 2026 16:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G5k5stKC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C2911F000C0;
	Wed, 25 Nov 2026 16:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624331;
	bh=zCxcN1LYHLhD4qHH0lmKbiV45NaW5O4E0WDAJKNeO84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G5k5stKCKI0Cbf2sYXs9coTxGX/zD5FHjE5np088i3Mb27dnIGOEKE/ZO6pnorUjU
	 1MYGfukj7El690/iTW6g9AUr6uKUVyRx4BXb3MZ00Z9u+VymmnC4PPOdGwWvwpoCVM
	 JqyUga7xRLXHD+9b3OcAkytZJk7MZHtYHh6Yz9CQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 158/816] Bluetooth: hci_sync: Protect resolving-list lookups
Date: Wed, 25 Nov 2026 15:28:26 +0100
Message-ID: <20261125143852.852823037@linuxfoundation.org>
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

[ Upstream commit f05bd61a3213613de7848c8df2865492d5225023 ]

The host resolving list is updated under hdev->lock, and each
bdaddr_list_with_irk entry must remain alive throughout a lookup.
hci_le_del_resolve_list_sync() and hci_le_add_resolve_list_sync()
traverse that list without taking the lock.

On an LE privacy-capable controller with a programmed entry, passive
scan reconciliation can reach hci_le_del_resolve_list_sync() while a
privileged HCI_RAW client sends LE Clear Resolving List. The raw
command does not take req_lock, and its successful completion runs
on the controller workqueue independently of request work:

  Request work                     Raw HCI / event work
  hci_le_del_resolve_list_sync()
    lookup loads a list node
                                   hci_sock_sendmsg()
                                     queue LE Clear Resolving List
                                   hci_cc_le_clear_resolv_list()
                                     take hdev->lock
                                     unlink and free the node
                                     release hdev->lock
    read the node's address/type

The clear can free the node after the lookup loads it and before its
address/type read, causing a use-after-free. The report below shows
this access with the delete helper on the faulting stack. The add
helper uses the same unprotected lookup.

Take hdev->lock around each resolving-list membership lookup and
retain only a boolean result. This serializes traversal with clear
completion and keeps entry pointers inside the protected section.
Release the lock before issuing a synchronous HCI command, whose
completion also needs the lock.

KASAN report as below:

    ==================================================================
    BUG: KASAN: slab-use-after-free in
    hci_bdaddr_list_lookup_with_irk+0x106/0x120
    Read of size 1 at addr ffff88810b036e16 by task kworker/u17:0/495

    CPU: 2 UID: 0 PID: 495 Comm: kworker/u17:0 Not tainted
    7.2.0-rc6-pmb-bt-functional-v1+ #3 PREEMPT(lazy)
    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix,
    1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    Workqueue: hci0 hci_cmd_sync_work
    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     ? hci_bdaddr_list_lookup_with_irk+0x106/0x120
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __virt_addr_valid+0x20d/0x410
     ? hci_bdaddr_list_lookup_with_irk+0x106/0x120
     kasan_report+0xe0/0x110
     ? hci_bdaddr_list_lookup_with_irk+0x106/0x120
     hci_bdaddr_list_lookup_with_irk+0x106/0x120
     hci_le_del_resolve_list_sync.isra.0+0xd6/0x3f0
     ? __pfx_hci_le_del_resolve_list_sync.isra.0+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     hci_le_del_accept_list_sync.isra.0+0x11c/0x290
     ? __pfx_hci_le_del_accept_list_sync.isra.0+0x10/0x10
     ? hci_passive_scan_sync+0x551/0x1e80
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_release+0xc8/0x280
     hci_passive_scan_sync+0x71c/0x1e80
     ? __pfx_hci_passive_scan_sync+0x10/0x10
     ? find_held_lock+0x2b/0x80
     ? hci_lookup_le_connect+0xe1/0x3c0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? find_held_lock+0x2b/0x80
     ? hci_update_passive_scan_sync+0x437/0x950
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_release+0xc8/0x280
     hci_update_passive_scan_sync+0x461/0x950
     hci_cmd_sync_work+0x1b3/0x450
     ? srso_alias_return_thunk+0x5/0xfbef5
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

    Allocated by task 495:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_kmalloc+0xaa/0xb0
     __kmalloc_cache_noprof+0x251/0x610
     hci_bdaddr_list_add_with_irk+0x183/0x3e0
     hci_cc_le_add_to_resolv_list+0x18c/0x240
     hci_cmd_complete_evt+0x373/0xab0
     hci_event_packet+0x4e8/0xc70
     hci_rx_work+0x367/0xf00
     process_one_work+0x908/0x19c0
     worker_thread+0x65c/0xe40
     kthread+0x34f/0x460
     ret_from_fork+0x659/0x940
     ret_from_fork_asm+0x1a/0x30

    Freed by task 497:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     kasan_save_free_info+0x3b/0x60
     __kasan_slab_free+0x5f/0x80
     kfree+0x307/0x580
     hci_bdaddr_list_clear+0x134/0x230
     hci_cc_le_clear_resolv_list+0x13d/0x240
     hci_cmd_complete_evt+0x373/0xab0
     hci_event_packet+0x4e8/0xc70
     hci_rx_work+0x367/0xf00
     process_one_work+0x908/0x19c0
     worker_thread+0x65c/0xe40
     kthread+0x34f/0x460
     ret_from_fork+0x659/0x940
     ret_from_fork_asm+0x1a/0x30

    The buggy address belongs to the object at ffff88810b036e00
    which belongs to the cache kmalloc-64 of size 64
    The buggy address is located 22 bytes inside of
    freed 64-byte region [ffff88810b036e00, ffff88810b036e40)

    The buggy address belongs to the physical page:
    page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0
    pfn:0x10b036
    flags: 0x200000000000000(node=0|zone=2)
    page_type: f5(slab)
    raw: 0200000000000000 ffff8881000428c0 dead000000000100
    dead000000000122
    raw: 0000000000000000 0000000000200020 00000000f5000000
    0000000000000000
    page dumped because: kasan: bad access detected

    Memory state around the buggy address:
     ffff88810b036d00: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
     ffff88810b036d80: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
    >ffff88810b036e00: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                             ^
     ffff88810b036e80: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
     ffff88810b036f00: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
    ==================================================================
    Disabling lock debugging due to kernel taint

Fixes: e8907f76544f ("Bluetooth: hci_sync: Make use of hci_cmd_sync_queue set 3")
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index ddfa09b8176a1..c6ae135f1b3b6 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2491,15 +2491,17 @@ static int hci_le_del_resolve_list_sync(struct hci_dev *hdev,
 					bdaddr_t *bdaddr, u8 bdaddr_type)
 {
 	struct hci_cp_le_del_from_resolv_list cp;
-	struct bdaddr_list_with_irk *entry;
+	bool exists;
 
 	if (!use_ll_privacy(hdev))
 		return 0;
 
 	/* Check if the IRK has been programmed */
-	entry = hci_bdaddr_list_lookup_with_irk(&hdev->le_resolv_list, bdaddr,
-						bdaddr_type);
-	if (!entry)
+	hci_dev_lock(hdev);
+	exists = hci_bdaddr_list_lookup_with_irk(&hdev->le_resolv_list,
+						 bdaddr, bdaddr_type);
+	hci_dev_unlock(hdev);
+	if (!exists)
 		return 0;
 
 	cp.bdaddr_type = bdaddr_type;
@@ -2555,8 +2557,8 @@ static int hci_le_add_resolve_list_sync(struct hci_dev *hdev,
 {
 	struct hci_cp_le_add_to_resolv_list cp;
 	struct smp_irk *irk;
-	struct bdaddr_list_with_irk *entry;
 	struct hci_conn_params *p;
+	bool exists;
 
 	if (!use_ll_privacy(hdev))
 		return 0;
@@ -2578,10 +2580,11 @@ static int hci_le_add_resolve_list_sync(struct hci_dev *hdev,
 		return 0;
 
 	/* Check if the IK has _not_ been programmed yet. */
-	entry = hci_bdaddr_list_lookup_with_irk(&hdev->le_resolv_list,
-						&params->addr,
-						params->addr_type);
-	if (entry)
+	hci_dev_lock(hdev);
+	exists = hci_bdaddr_list_lookup_with_irk(
+		&hdev->le_resolv_list, &params->addr, params->addr_type);
+	hci_dev_unlock(hdev);
+	if (exists)
 		return 0;
 
 	cp.bdaddr_type = params->addr_type;
-- 
2.53.0



