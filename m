Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704250;
	b=JpCb4DJv9qpPAGC2ro/G81HIL0/wsBAvCgpf2yM/9GMx4q0xY250tg+a4XOGDlXaPv8E
	 3Y0wCNd/1/3aot6nNTW+6HYbKSc31XaeWWge2ICcMPTGmwfd8WvfUTXHQMzKkmbaX3xIF
	 IyViqZtPHt7savj0C6Y1X06tFV8cuOd8TNSkgWZYHqgvpukIa3SWeUshCtioDv3mLv3Yp
	 FK+VRBMRVqviUM38DcGHjDpAtnZnQt1JY5tofkzEAJi2H8sg+G0qD4riPRxogifqzdPAn
	 WFw+YQEfVnOD77lQiKrJ9EmcLYgAqkydctX5eivEtDqwgiI2Gu/wiQGdd8HwbdRd5iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704250;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A0Phoob8t4BlvU4g/jQmlAXHF39Kz3rID2/lpm6lnX4=;
	b=1ei0qh+wNAJCwjCWmf34oDBeqc3ApXNDPZeGtVwjjf4mj4XmwzuMxf7HEVtJYOKA3tzl
	 TiSBenJWBYHAsJe80Digj3A4rIRQPIbGl9AbTMmJSGW9qNUqDZG4f5zz10gv0nN8jtu/d
	 YFh4Eycrl8fYVM1JC8JbUxLrQymgObc00Gx1SzNwdgXvkQ8HG2J0mesup7pRE84ipcLTb
	 DPOn9JlU0sxmf1TBo271f6A+w+XgEvviOX3RvsourlP/yECLkyF+v2wRuJJ0qfF7YSlmW
	 YmG42Ad6byYSdtUgvMs/CqxceNJFGfY/w0Qgf4rdL1xzmJgnslegusYIlUkUHCrVTBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="RZavrd/M";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B405606A31C;
	Thu, 26 Nov 2026 14:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RZavrd/M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC6E1F000C6;
	Thu, 26 Nov 2026 14:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704249;
	bh=A0Phoob8t4BlvU4g/jQmlAXHF39Kz3rID2/lpm6lnX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RZavrd/MM9CZ1oNO9tQ66yxTxhOJF5jegZ0jDM4ymYvWgw7V4aF4O3j+T22QGzBbT
	 0gTjU9Rol1ltS2v29QK6EYTKfhv2LPYA9RqbSQ5OGyA9bNe0XH9BQz1UJYBwYXXzzA
	 vxC95po+mvCyHz6ZxVFjfoIKGIhw0wvyKI/b3mIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/265] Bluetooth: hci_core: Keep link-key filtering inside RCU
Date: Thu, 26 Nov 2026 15:36:29 +0100
Message-ID: <20261126143609.208411186@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 281ddc4e01ab54cab07995f2a1b72cf81bf90eb5 ]

hci_find_link_key() must keep the matching link key allocated while it
checks the key against the blocked-key list. It currently leaves the
key-list RCU read-side section before passing k->val to
hci_is_blocked_key(). That helper's own RCU section protects the
blocked-key list, but it cannot keep an unlinked link key from being
reclaimed.

The SMP receive path calls the finder without hdev->lock: Secure
Connections key distribution over BR/EDR reaches it through
smp_distribute_keys() and sc_generate_ltk(). With a stored peer link
key and a link-key entry in the blocked-key list,
MGMT_OP_LOAD_LINK_KEYS can free the selected key before the comparison:

  HCI RX worker (SMP)              Management / RCU reclamation
  hci_find_link_key()
    rcu_read_lock()
    select k
    rcu_read_unlock()
                                   load_link_keys()
                                     hci_dev_lock(hdev)
                                     hci_link_keys_clear(hdev)
                                       list_del_rcu(), kfree_rcu()
                                     hci_dev_unlock(hdev)
                                   grace period ends, k is freed
    hci_is_blocked_key(hdev, ..., k->val)
      memcmp() reads the freed key

Keep the RCU read-side section active through the blocked-key
comparison and the warning that prints k->bdaddr, and release it before
returning on both matched-key paths. hci_find_ltk() already handles its
blocked-key check this way.

KASAN reported this on a test kernel whose scheduling hook paused the
receive worker after the lookup until the key had been freed.

KASAN report as below:

    ==================================================================
    BUG: KASAN: slab-use-after-free in hci_is_blocked_key+0x2db/0x300
    Read of size 1 at addr ffff88810b5f89a7 by task kworker/u17:0/502

    CPU: 1 UID: 0 PID: 502 Comm: kworker/u17:0 Not tainted 7.2.0-rc6-pmb-bt-functional-v1+ #5 PREEMPT(lazy)
    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    Workqueue: hci1 hci_rx_work
    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     ? hci_is_blocked_key+0x2db/0x300
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __virt_addr_valid+0x20d/0x410
     ? hci_is_blocked_key+0x2db/0x300
     kasan_report+0xe0/0x110
     ? hci_is_blocked_key+0x2db/0x300
     hci_is_blocked_key+0x2db/0x300
     hci_find_link_key+0x12e/0x400
     smp_distribute_keys+0x1830/0x2950
     ? trace_hardirqs_on+0x18/0x160
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? queue_delayed_work_on+0xb3/0xf0
     ? __pfx_smp_distribute_keys+0x10/0x10
     ? __pfx_smp_send_cmd.isra.0+0x10/0x10
     ? __cancel_work+0x1b0/0x290
     ? __entry_text_end+0x1020f7/0x1020f9
     ? lockdep_hardirqs_on_prepare+0xea/0x1a0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __asan_memset+0x23/0x50
     ? smp_recv_cb+0x12c7/0x8d80
     ? srso_alias_return_thunk+0x5/0xfbef5
     smp_recv_cb+0x12c7/0x8d80
     ? __pfx_smp_recv_cb+0x10/0x10
     ? __pfx___might_resched+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? stack_depot_save_flags+0x29/0x9a0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __mutex_lock+0x182c/0x2590
     ? kasan_save_stack+0x42/0x60
     ? l2cap_recv_frame+0x9ef/0x8830
     ? __kasan_slab_free+0x5f/0x80
     ? kmem_cache_free+0x242/0x580
     ? kfree_skbmem+0x15e/0x1d0
     ? sk_skb_reason_drop+0x12f/0x490
     ? hci_event_packet+0x556/0xc70
     ? hci_rx_work+0x367/0xf00
     ? process_one_work+0x908/0x19c0
     ? worker_thread+0x65c/0xe40
     ? __pfx___mutex_lock+0x10/0x10
     ? __lock_acquire+0x466/0x2260
     ? __pfx_l2cap_chan_hold_unless_zero+0x10/0x10
     ? l2cap_recv_frame+0x13cc/0x8830
     ? __pfx_smp_recv_cb+0x10/0x10
     l2cap_recv_frame+0x13cc/0x8830
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __mutex_lock+0x182c/0x2590
     ? __pfx_l2cap_recv_frame+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? find_held_lock+0x2b/0x80
     ? l2cap_recv_acldata+0x1eb/0x10e0
     ? __pfx___mutex_lock+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __mutex_unlock_slowpath+0x147/0x920
     ? __pfx_l2cap_conn_hold_unless_zero+0x10/0x10
     ? __pfx_hci_conn_enter_active_mode+0x10/0x10
     ? l2cap_recv_acldata+0x13d/0x10e0
     ? srso_alias_return_thunk+0x5/0xfbef5
     l2cap_recv_acldata+0xe9f/0x10e0
     ? srso_alias_return_thunk+0x5/0xfbef5
     hci_rx_work+0x5a6/0xf00
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

    Allocated by task 504:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_kmalloc+0xaa/0xb0
     __kmalloc_cache_noprof+0x251/0x610
     hci_add_link_key+0x474/0x840
     hci_link_key_notify_evt+0x492/0xce0
     hci_event_packet+0x894/0xc70
     hci_rx_work+0x367/0xf00
     process_one_work+0x908/0x19c0
     worker_thread+0x65c/0xe40
     kthread+0x34f/0x460
     ret_from_fork+0x659/0x940
     ret_from_fork_asm+0x1a/0x30

    Freed by task 29:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     kasan_save_free_info+0x3b/0x60
     __kasan_slab_free+0x5f/0x80
     __rcu_free_sheaf_prepare+0x65/0x2a0
     rcu_free_sheaf_nobarn+0x1d/0x50
     rcu_core+0x661/0x1d10
     handle_softirqs+0x201/0x930
     run_ksoftirqd+0x33/0x60
     smpboot_thread_fn+0x3bd/0x9a0
     kthread+0x34f/0x460
     ret_from_fork+0x659/0x940
     ret_from_fork_asm+0x1a/0x30

    The buggy address belongs to the object at ffff88810b5f8980
     which belongs to the cache kmalloc-64 of size 64
    The buggy address is located 39 bytes inside of
     freed 64-byte region [ffff88810b5f8980, ffff88810b5f89c0)

    The buggy address belongs to the physical page:
    page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x10b5f8
    flags: 0x200000000000000(node=0|zone=2)
    page_type: f5(slab)
    raw: 0200000000000000 ffff8881000428c0 dead000000000100 dead000000000122
    raw: 0000000000000000 0000000000200020 00000000f5000000 0000000000000000
    page dumped because: kasan: bad access detected

    Memory state around the buggy address:
     ffff88810b5f8880: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
     ffff88810b5f8900: 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc
    >ffff88810b5f8980: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                                   ^
     ffff88810b5f8a00: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
     ffff88810b5f8a80: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
    ==================================================================

Fixes: 600a87490ff9 ("Bluetooth: Implementation of MGMT_OP_SET_BLOCKED_KEYS.")
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 9b297578bc01d..b06a408efeb9d 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2300,17 +2300,16 @@ struct link_key *hci_find_link_key(struct hci_dev *hdev, bdaddr_t *bdaddr)
 	rcu_read_lock();
 	list_for_each_entry_rcu(k, &hdev->link_keys, list) {
 		if (bacmp(bdaddr, &k->bdaddr) == 0) {
-			rcu_read_unlock();
-
 			if (hci_is_blocked_key(hdev,
 					       HCI_BLOCKED_KEY_TYPE_LINKKEY,
 					       k->val)) {
 				bt_dev_warn_ratelimited(hdev,
 							"Link key blocked for %pMR",
 							&k->bdaddr);
-				return NULL;
+				k = NULL;
 			}
 
+			rcu_read_unlock();
 			return k;
 		}
 	}
-- 
2.53.0



