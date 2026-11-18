Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061712;
	b=1SKEyb3IDJHHt2l3hnEwJiCbjhB4EL/pzRptGlYVHkBDs5KfQCyuRIbrjFnY8kquwGom
	 adzs+Y+uoTm2O77e+LYN6deqaMxzcq/4Cyw2OkzpgxBuZtZj7KH7aFb9cogr9AIXXLjMQ
	 OHoGUQZHBgkz8jXdev+5nm1/+fgDsmmrVlmKF8MWW2dEvSDCZzpKIC1HPzOliJZowLAgR
	 RVcoEsBylT1lOeQIjj95DYMfbXvbE0RT9aBK/fTtwOsghYBGL2v7hTTPaC5o9QMFGq6Xe
	 QK5FnCDig6XNlCklHrrP1UZrJSAMTTzntjYI49S/6N+ovAsmaG9L9yNh8yiRIE6X3FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061712;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=34Dsb2D4rXevL74H2vwVPudCNyN609NQTNcaOIWs4bM=;
	b=4mNquUJw7dRlMudIPwB/8wYbu1RnbdaFo1jYCIrsmpkbMVCRzmiH3EaNkMAc/HsA0Sxr
	 3n+9xFRp9P7gBImvDCmCjBWFNlZphJrgfecM30bJ9FCY9HiYnMJtBwzr0GyIVyQ8m2jQS
	 E7Web7CNMN7qVPYXfdxo1LAFJxd5FnDDIcZxI3mhIiXbROQDfM2WjbdanhwjcFEOtBACI
	 5vRhFL2vYpQowjuh0WU3Rr3ek0OsK6jK8kgBmPvkwfVfT+tw1puE2Lv2g6M+rxyNNpSoB
	 l5o1YQ6gaYH9K/XmcOJCjPOwcybWdCYk2X9jXQcAZkPV2Rq3NHJLqhbpDyWqo/QqGDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ycgEpz7b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6851D606A32C;
	Thu, 19 Nov 2026 04:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ycgEpz7b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799721F000C4;
	Thu, 19 Nov 2026 04:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061712;
	bh=34Dsb2D4rXevL74H2vwVPudCNyN609NQTNcaOIWs4bM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ycgEpz7byfItMaCbFBJZ4cLSDwGeEKT4G3AE7L9bg/SpGWcSUYFN7Ev0W194WzXdQ
	 CT+yDPtny2pXmOqTeIx4LmsqwB/b9Ga/KuKjgADW0E+vF4oR/JO4aUL52oa1yz24K9
	 QcP8JIRti9hovBAnEV6vffixAMEpMwB3BeSb49kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1652/1848] Bluetooth: 6lowpan: Drain RCU readers on registration failure
Date: Wed, 18 Nov 2026 16:01:30 +0100
Message-ID: <20261118150028.875397829@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

[ Upstream commit ebba800d140b580540ad55f670d943e4a7edaffd ]

A lowpan_btle_dev is embedded in its net_device allocation and must
remain alive until readers of bt_6lowpan_devices have left their RCU
sections. setup_netdev() publishes it before registration, but its
error path only unlinks it before calling free_netdev().

If a second controller's registration fails while multicast is sent
on an existing 6LoWPAN interface, send_mcast_pkt() can already have
selected the new entry. It reads entry->netdev before checking which
interface owns it. An early failure, such as allocating the device's
name node, leaves NETREG_UNINITIALIZED, so free_netdev() releases the
storage immediately.

The following ordering frees the selected entry before the reader
loads its netdev field:

  Adapter creation (controller B)       Multicast on controller A
  setup_netdev()
    list_add_rcu()
                                       rcu_read_lock()
                                       select B's entry
    lowpan_register_netdev() fails
    list_del_rcu()
    free_netdev()
                                       read entry->netdev
                                       rcu_read_unlock()

Removing the list node does not wait for that reader, and
devices_lock does not serialize the multicast reader. The subsequent
field load is a use-after-free, reported by KASAN in bt_xmit().

Wait for an RCU grace period after dropping devices_lock and before
free_netdev(). This keeps the failed adapter allocated until traversals
that could have selected it complete. The callback is already sleepable,
and the wait happens outside the list spinlock.

KASAN report as below:

    ==================================================================
    BUG: KASAN: slab-use-after-free in bt_xmit+0x1d06/0x21e0
    Read of size 8 at addr ffff88810ef45030 by task python3/556

    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     ? bt_xmit+0x1d06/0x21e0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __virt_addr_valid+0x20d/0x410
     ? bt_xmit+0x1d06/0x21e0
     kasan_report+0xe0/0x110
     ? bt_xmit+0x1d06/0x21e0
     bt_xmit+0x1d06/0x21e0
     ? __pfx_bt_xmit+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_acquire+0x17b/0x2f0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_is_held_type+0x8f/0x100
     ? dev_hard_start_xmit+0x187/0x660
     ? __pfx_bt_xmit+0x10/0x10
     dev_hard_start_xmit+0x187/0x660
     sch_direct_xmit+0x153/0x850
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_sch_direct_xmit+0x10/0x10
     ? do_raw_spin_lock+0x130/0x270
     ? __pfx_do_raw_spin_lock+0x10/0x10
     ? lock_is_held_type+0x8f/0x100
     __dev_queue_xmit+0x3111/0x3aa0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? look_up_lock_class+0x59/0x130
     ? register_lock_class+0x41/0x790
     ? __pfx___dev_queue_xmit+0x10/0x10
     ? __lock_acquire+0x466/0x2260
     ? find_held_lock+0x2b/0x80
     ? ___neigh_create+0x1690/0x2540
     ? __local_bh_enable_ip+0xa6/0x120
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lockdep_hardirqs_on_prepare+0xea/0x1a0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_acquire+0x17b/0x2f0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? find_held_lock+0x2b/0x80
     ? ip6_finish_output2+0x8be/0x1840
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? neigh_connected_output+0x39f/0x4e0
     ? srso_alias_return_thunk+0x5/0xfbef5
     neigh_connected_output+0x33f/0x4e0
     ip6_finish_output2+0x8be/0x1840
     ip6_finish_output+0x424/0xd50
     ip6_output+0x210/0x640
     ? __pfx_ip6_mr_output+0x10/0x10
     ip6_local_out+0x193/0x1c0
     ip6_send_skb+0xfb/0x3e0
     udp_v6_send_skb+0x6e1/0x1180
     udpv6_sendmsg+0x1f9b/0x2a00
     ? get_random_u32+0xaf/0x640
     ? __pfx_udpv6_sendmsg+0x10/0x10
     ? lock_release+0xc8/0x280
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lockdep_hardirqs_on_prepare+0xea/0x1a0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? trace_hardirqs_on+0x18/0x160
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __local_bh_enable_ip+0xa6/0x120
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_udpv6_sendmsg+0x10/0x10
     ? inet6_sendmsg+0xff/0x140
     inet6_sendmsg+0xff/0x140
     __sys_sendto+0x320/0x470
     ? __pfx___sys_sendto+0x10/0x10
     ? exc_page_fault+0x5c/0xc0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_release+0xc8/0x280
     ? handle_mm_fault+0x12e/0x580
     __x64_sys_sendto+0xe5/0x1c0
     ? lockdep_hardirqs_on_prepare+0xea/0x1a0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? trace_hardirqs_on+0x18/0x160
     do_syscall_64+0x115/0x6a0
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
    Allocated by task 502:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_kmalloc+0xaa/0xb0
     __kvmalloc_node_noprof+0x353/0x930
     alloc_netdev_mqs+0xa0/0x1250
     chan_ready_cb+0x198/0x1110
     l2cap_recv_frame+0x6dc0/0x8830
     l2cap_recv_acldata+0xe9f/0x10e0
     hci_rx_work+0x5a6/0xf00
     process_one_work+0x908/0x19c0
     worker_thread+0x65c/0xe40
     kthread+0x34f/0x460
     ret_from_fork+0x659/0x940
     ret_from_fork_asm+0x1a/0x30

    Freed by task 502:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     kasan_save_free_info+0x3b/0x60
     __kasan_slab_free+0x5f/0x80
     kfree+0x307/0x580
     free_netdev+0x6ca/0x8f0
     chan_ready_cb+0xd91/0x1110
     l2cap_recv_frame+0x6dc0/0x8830
     l2cap_recv_acldata+0xe9f/0x10e0
     hci_rx_work+0x5a6/0xf00
     process_one_work+0x908/0x19c0
     worker_thread+0x65c/0xe40
     kthread+0x34f/0x460
     ret_from_fork+0x659/0x940
     ret_from_fork_asm+0x1a/0x30

    The buggy address belongs to the object at ffff88810ef44000
                                                                which
                                belongs to the cache kmalloc-8k of size
                                8192
    The buggy address is located 4144 bytes inside of
                                                                freed
                                8192-byte region [ffff88810ef44000,
                                ffff88810ef46000)

    The buggy address belongs to the physical page:
        page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0
    pfn:0x10ef40
    head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
    flags: 0x200000000000040(head|node=0|zone=2)
    page_type: f5(slab)
        raw: 0200000000000040 ffff888100043180 dead000000000100
    dead000000000122
        raw: 0000000000000000 0000000000020002 00000000f5000000
    0000000000000000
        head: 0200000000000040 ffff888100043180 dead000000000100
    dead000000000122
        head: 0000000000000000 0000000000020002 00000000f5000000
    0000000000000000
        head: 0200000000000003 fffffffffffffe01 00000000ffffffff
    00000000ffffffff
        head: ffff88810ef41a80 0000000000000000 00000000ffffffff
    0000000000000000
    page dumped because: kasan: bad access detected

    Memory state around the buggy address:
     ffff88810ef44f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
     ffff88810ef44f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
    >ffff88810ef45000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                         ^
     ffff88810ef45080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
     ffff88810ef45100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
    ==================================================================
    Disabling lock debugging due to kernel taint

Fixes: 5857d1dbae7d ("Bluetooth: 6lowpan: Fix possible race")
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/6lowpan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index f0a70743360f8..bf5a9df612dfc 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -733,6 +733,7 @@ static int setup_netdev(struct l2cap_chan *chan, struct lowpan_btle_dev **dev)
 		spin_lock(&devices_lock);
 		list_del_rcu(&(*dev)->list);
 		spin_unlock(&devices_lock);
+		synchronize_rcu();
 		free_netdev(netdev);
 		goto out;
 	}
-- 
2.53.0



