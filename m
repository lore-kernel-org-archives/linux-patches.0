Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032024;
	b=taI2TqJzBG78WsjHd4ABQrI/8dieaOP8p0Y7tdSygAnn5I/qKyYlsVQpdZOZOapuvf07
	 t9THuF8yFx1PZfLMJD0l30vXaWurCOTiQM6GA4RpqrqhdXODemwqlUpuv0FRHJqL+eTP9
	 Z5tZaPkS2wUPZcZM3YTTBIwpaYuLXVFmZIY3YbuvHz3lTNSQL8R7ULeMwjxW2nNKwva1+
	 psjIcK77r8KebRWd1E+xNXiEJcBqa1tHqyDRIpY56/SDaSKZhRRGWeD+sejaopxuy7zql
	 0afKwXxDp4RAwHAUrit4BVUjgfMelC7LuixjrQSVhKiFVfQ2UwM6UpvA868fI/0bqZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032024;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z6yh7EXkaxszmRA7RLzcd597XkBYLZK1VkPP9URIXfA=;
	b=0q7o/5QQgTzRtKTQ+5aMKgr6C6r6nd7ffYoSwTiAuoWvt5dCnq/lmE1wULspusVZw0gg
	 7l46jM1hf98mvS0o9GdrnKSqc8xERC/S0M9UnliGODVl4LNGwL2Wb0NCaMyBvpbO0WgB8
	 Kk6ek3V9uy/Q20+aevrH/rtjmSrXSWCTGTiHIOgCDjAl+kK5NTdyDBc3DePYffnd9e89y
	 LaW7Nq3AdQ0qIlHiXQfq+fGRcNgq+34x9qkrOd8wLcSJH5pkfRyBCHlXAuz/gNXsUlzUz
	 fn3T6t6QbV3uEfTgSsh1O6bWrnlDpD+9ubuIbduf+DU/C3D+Sq3LqgcOG0u2wf2p/6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2I60VJi3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6340160A2600;
	Wed, 18 Nov 2026 20:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2I60VJi3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72601F000C4;
	Wed, 18 Nov 2026 20:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032024;
	bh=Z6yh7EXkaxszmRA7RLzcd597XkBYLZK1VkPP9URIXfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2I60VJi3KnZwfqH6rmzmfB+6Vq9Pap+LO9Hg27mBP2urr9ZZy9KKW8ovTkF6rpMXn
	 QajwMA9XihFwezOGeSM7OoBvofhRbHpaZZxCB44LSGr5DQs5FQ+5v3e5Ool66hH/7d
	 NYIYOTca6S3F6gY65rwEOCkYzMCI/VAHQ1m71rUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1238/1756] Bluetooth: hci_sync: Protect IRK identity reads with RCU
Date: Wed, 18 Nov 2026 15:56:05 +0100
Message-ID: <20261118150059.048823041@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

[ Upstream commit 4b76fa362110cf1b74a0263c14406b71de99894c ]

hci_le_set_privacy_mode_sync() needs the IRK returned by
hci_find_irk_by_addr() to remain allocated until its identity address
and type have been copied into the command. The finder drops its RCU
read lock before returning this borrowed pointer, leaving the later
field reads unprotected.

When a privacy-capable controller has a pending peer with address
resolution and device privacy enabled, accept-list programming can
reach this helper while management reloads the IRKs. The request
worker holds hdev->req_lock, whereas load_irks() takes hdev->lock,
allowing the following ordering:

  Request worker                     Management / RCU reclaim
  hci_le_set_privacy_mode_sync()
    hci_find_irk_by_addr()
      rcu_read_lock()
      find matching IRK
      rcu_read_unlock()
      return borrowed IRK
                                     load_irks()
                                       hci_dev_lock(hdev)
                                       hci_smp_irks_clear()
                                         list_del_rcu()
                                         kfree_rcu()
                                       hci_dev_unlock(hdev)
                                     RCU grace period and IRK free
    read irk->addr_type
    copy irk->bdaddr

The request then accesses a freed IRK. KASAN reports a one-byte
use-after-free read of addr_type on this path.

Keep an outer RCU read-side critical section across the lookup and
both identity-field copies. The finder's nested unlock then leaves
the IRK protected until the caller finishes copying it. Release RCU
on a lookup miss and after copying the fields, before the synchronous
HCI command can sleep.

KASAN report as below:

    ==================================================================
        BUG: KASAN: slab-use-after-free in
    hci_le_add_accept_list_sync+0x90f/0x940
    Read of size 1 at addr ffff88810aa6072c by task kworker/u17:0/493

    Workqueue: hci0 hci_cmd_sync_work
    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     ? hci_le_add_accept_list_sync+0x90f/0x940
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __virt_addr_valid+0x20d/0x410
     ? hci_le_add_accept_list_sync+0x90f/0x940
     kasan_report+0xe0/0x110
     ? hci_le_add_accept_list_sync+0x90f/0x940
     hci_le_add_accept_list_sync+0x90f/0x940
     ? __pfx_hci_le_add_accept_list_sync+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? conn_params_copy+0x3a0/0x650
     hci_passive_scan_sync+0x8c9/0x1e80
     ? __pfx_hci_passive_scan_sync+0x10/0x10
     ? find_held_lock+0x2b/0x80
     ? hci_lookup_le_connect+0x181/0x3c0
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

    Allocated by task 507:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_kmalloc+0xaa/0xb0
     __kmalloc_cache_noprof+0x251/0x610
     hci_add_irk+0xb6/0x220
     load_irks+0x5ef/0x7e0
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

    The buggy address belongs to the object at ffff88810aa60700
     which belongs to the cache kmalloc-64 of size 64
    The buggy address is located 44 bytes inside of
     freed 64-byte region [ffff88810aa60700, ffff88810aa60740)

    The buggy address belongs to the physical page:
        page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0
    pfn:0x10aa60
    flags: 0x200000000000000(node=0|zone=2)
    page_type: f5(slab)
        raw: 0200000000000000 ffff8881000428c0 dead000000000100
    dead000000000122
        raw: 0000000000000000 0000000000200020 00000000f5000000
    0000000000000000
    page dumped because: kasan: bad access detected

    Memory state around the buggy address:
     ffff88810aa60600: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
     ffff88810aa60680: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
    >ffff88810aa60700: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                                      ^
     ffff88810aa60780: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
     ffff88810aa60800: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
    ==================================================================
    Disabling lock debugging due to kernel taint

Fixes: adae20cb2d20 ("Bluetooth: Convert IRK list to RCU")
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 96da05eb380a5..fdf073a8f8b9b 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2629,13 +2629,19 @@ static int hci_le_set_privacy_mode_sync(struct hci_dev *hdev,
 	if (!(params->flags & HCI_CONN_FLAG_DEVICE_PRIVACY))
 		return 0;
 
+	rcu_read_lock();
+
 	irk = hci_find_irk_by_addr(hdev, &params->addr, params->addr_type);
-	if (!irk)
+	if (!irk) {
+		rcu_read_unlock();
 		return 0;
+	}
 
 	memset(&cp, 0, sizeof(cp));
 	cp.bdaddr_type = irk->addr_type;
 	bacpy(&cp.bdaddr, &irk->bdaddr);
+	rcu_read_unlock();
+
 	cp.mode = HCI_DEVICE_PRIVACY;
 
 	/* Note: params->privacy_mode is not updated since it is a copy */
-- 
2.53.0



