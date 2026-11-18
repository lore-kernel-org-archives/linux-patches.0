Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031939;
	b=DYl/+VXwT3l/YUHqmmUkdAoihrLoRfPIvvyJ8f0YLnxyUDPgSntu3TAstqAM3BN6FOvr
	 vEdxADtZcWeAKaZweRvUP1HsvQ1Mq/YRNRYU3LBe64oWsFdlZt/BBI0hCg7d8wRAJw87J
	 6F+bXAwRNuMRusu2EGjBp8jNFVh5cCfN8kTF2Oh6P2SB7FnTBNqCrezIMs6MBzrQEOkl1
	 2BgOFDn+OIerIeVkx2Gz60k29n6aDQ3+FtlTCuAis7KPUZQmmu9//Pae1usBW4+5c3McV
	 kzrsWzUs4q1aitDB+3lszJVJtpHdgpH7tuURz8afZJJeG2JcaKTDa1XjvqjjOP6klQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031939;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wj5HV2AIlNVoRKcCeP6F5f7qXg+YbennWMjxBMJCao4=;
	b=sZLOG6bNprQOnWXoz8JAoFUy6/u7/YM3jy36+dViauVbgBsFwLNZXOzJIwAAIiRyjs79
	 vB6OE/OHOoqIdptNCXKal8PB/m2KR8rmNJmSpWcZADhEJB8QpxxbIUNJW4iq6A0Pa0B13
	 dMFgU7MDHiPSUnR661nGh14qiXk4m2WXKs8pfsoRZMX/f53qLGHy3iF+PVN1faG2fL9Lx
	 0elJz5xX3p3+g/5YgCkLwmy0AcwgU0kUyqfCgClgjxJoQOhCSEao+ZFQCBg4OtRk/930D
	 J/TOXmL0+B3HF0ioepOaH+04RWAkS5I4VzynO735ztu+tFOw0O8009HxU02FA3rSAkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1X3e77iH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EFB606A320;
	Wed, 18 Nov 2026 19:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1X3e77iH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CE91F000C5;
	Wed, 18 Nov 2026 19:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031939;
	bh=wj5HV2AIlNVoRKcCeP6F5f7qXg+YbennWMjxBMJCao4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1X3e77iHezFJJ2SUr7Y9ApPv/JwZik4/146ck23FgMIi1t/6nP41k+Y9S4fU3SxJi
	 pz4b8Z9xCOxDebnH68oNLCtEJkpu3zNCopNsWV5rQk1YVUfrwiu30RHw1m+6y1EVmX
	 +l5SBC0qvxAGZmWLSTAjtG+Prn5j/dd7YhRKBv00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1233/1756] Bluetooth: ISO: Hold the listener during disconnect notification
Date: Wed, 18 Nov 2026 15:56:00 +0100
Message-ID: <20261118150058.875047349@linuxfoundation.org>
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

[ Upstream commit b4a00dedc5cc6f6f98c07ec1b54d24a817d9fc88 ]

An ISO listener must remain alive until a queued child's disconnect
notification completes. bt_accept_enqueue() retains only the child and
stores a raw parent pointer; iso_conn_ready() drops its temporary
listener reference after setup. iso_chan_del() saves that pointer,
unlinks the child and then calls parent->sk_data_ready() without holding
a listener reference.

With an incoming CIS child still queued, disconnect and listener release
can proceed in this order:

  HCI disconnect                   Listener release
  iso_conn_del(): lock child
  iso_chan_del(): save parent
  bt_accept_unlink(child)
                                   iso_sock_cleanup_listen():
                                     drain empty accept queue
                                   iso_sock_release():
                                     orphan and kill listener
                                     final sock_put(listener)
  parent->sk_data_ready(parent)

After unlink, listener cleanup no longer has to take the child socket
lock. The listener can therefore be freed before iso_chan_del() reads
sk_data_ready, causing a use-after-free.

Take a temporary parent reference before bt_accept_unlink() and drop it
after the notification. The child lock excludes accept dequeue while the
child is still queued, so listener cleanup cannot complete before
sock_hold(). The reference then keeps the listener alive across unlink
and through the callback without changing lock order.

KASAN report as below:

    ==================================================================
    BUG: KASAN: slab-use-after-free in iso_chan_del+0x302/0x320
    Read of size 8 at addr ffff888105ca2188 by task kworker/2:1/50

        CPU: 2 UID: 0 PID: 50 Comm: kworker/2:1 Not tainted
    7.2.0-rc6-pmb-bt-functional-v1+ #1 PREEMPT(lazy)
        Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps
    fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    Workqueue: events iso_fixture_disconnect_work
    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     ? iso_chan_del+0x302/0x320
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __virt_addr_valid+0x20d/0x410
     ? iso_chan_del+0x302/0x320
     kasan_report+0xe0/0x110
     ? iso_chan_del+0x302/0x320
     iso_chan_del+0x302/0x320
     iso_conn_del+0x19d/0x3c0
     ? __pfx_iso_disconn_cfm+0x10/0x10
     iso_disconn_cfm+0x78/0x120
     hci_disconn_complete_evt+0x319/0xa30
     ? find_held_lock+0x2b/0x80
     hci_test_iso_disconn_event+0x85/0xb0
     ? __pfx_hci_test_iso_disconn_event+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? _raw_read_unlock+0x23/0x40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __hci_dev_get+0x15d/0x280
     iso_fixture_disconnect_work+0x67/0x290
     process_one_work+0x908/0x19c0
     ? __pfx_process_one_work+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_is_held_type+0x8f/0x100
     ? srso_alias_return_thunk+0x5/0xfbef5
     worker_thread+0x65c/0xe40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __kthread_parkme+0x175/0x220
     ? srso_alias_return_thunk+0x5/0xfbef5
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

    Allocated by task 521:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_kmalloc+0xaa/0xb0
     __kmalloc_noprof+0x2d7/0x770
     sk_prot_alloc+0x13e/0x260
     sk_alloc+0x37/0xb40
     bt_sock_alloc+0x40/0x3b0
     iso_sock_alloc.constprop.0+0x3a/0x360
     iso_sock_create+0xc7/0x160
     bt_sock_create+0x171/0x330
     __sock_create+0x2c4/0x730
     __sys_socket+0x141/0x210
     __x64_sys_socket+0x77/0xc0
     do_syscall_64+0x115/0x6a0
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    Freed by task 521:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     kasan_save_free_info+0x3b/0x60
     __kasan_slab_free+0x5f/0x80
     kfree+0x307/0x580
     __sk_destruct+0x64f/0x790
     sk_destruct+0xb3/0xd0
     __sk_free+0xdd/0x370
     sk_free+0x51/0x80
     iso_sock_release+0x46d/0x5b0
     __sock_release+0xb8/0x270
     sock_close+0x21/0x30
     __fput+0x39f/0xa60
     task_work_run+0x144/0x230
     do_exit+0x834/0x2830
     do_group_exit+0xc7/0x280
     get_signal+0x20a9/0x2400
     arch_do_signal_or_restart+0x94/0x6f0
     exit_to_user_mode_loop+0xcf/0x570
     do_syscall_64+0x4f0/0x6a0
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    The buggy address belongs to the object at ffff888105ca2000
                                                                which
                                belongs to the cache kmalloc-2k of size
                                2048
    The buggy address is located 392 bytes inside of
                                                                freed
                                2048-byte region [ffff888105ca2000,
                                ffff888105ca2800)

    The buggy address belongs to the physical page:
        page: refcount:0 mapcount:0 mapping:0000000000000000
    index:0xffff888105ca5000 pfn:0x105ca0
    head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
    flags: 0x200000000000240(workingset|head|node=0|zone=2)
    page_type: f5(slab)
        raw: 0200000000000240 ffff888100042f00 ffffea00042cd010
    ffffea00042c9210
        raw: ffff888105ca5000 0000000000080005 00000000f5000000
    0000000000000000
        head: 0200000000000240 ffff888100042f00 ffffea00042cd010
    ffffea00042c9210
        head: ffff888105ca5000 0000000000080005 00000000f5000000
    0000000000000000
        head: 0200000000000003 fffffffffffffe01 00000000ffffffff
    00000000ffffffff
        head: ffff888105ca1000 0000000000000000 00000000ffffffff
    0000000000000000
    page dumped because: kasan: bad access detected

    Memory state around the buggy address:
     ffff888105ca2080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
     ffff888105ca2100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
    >ffff888105ca2180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                          ^
     ffff888105ca2200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
     ffff888105ca2280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
    ==================================================================

Fixes: f764a6c2c1e4 ("Bluetooth: ISO: Add broadcast support")
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 98261072aa050..2733cc8b8f89c 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -248,8 +248,11 @@ static void iso_chan_del(struct sock *sk, int err)
 
 	parent = bt_sk(sk)->parent;
 	if (parent) {
+		/* Unlinking the child allows the parent to be freed. */
+		sock_hold(parent);
 		bt_accept_unlink(sk);
 		parent->sk_data_ready(parent);
+		sock_put(parent);
 	} else {
 		sk->sk_state_change(sk);
 	}
-- 
2.53.0



