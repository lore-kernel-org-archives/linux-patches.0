Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049969;
	b=FraKonh5CyiVPd+PzmYacMWGDJC9t0X/vCvMvKyNF/mPoDxUBsVzcFN+qdhC+6VAjHng
	 n6ngKkUS6ZquENsqFbDd6qFC1h96dI91QrDp1gM2GXHCejRuRjO/PuOM+KmbKnvfLe9mq
	 UXr78xAmp2kfhUUAl6NKAT0A+TP0YUFBhr81LcnH2xPZ+zWSVmXLYE/Tw4lJbOPw5YzEA
	 oP+kFk3K/WHZRVMdjXj7Yy0P8VB9i1BE/7spOFUlzC3mmHciyoLjWyNyQ4qtEBBvfWRYY
	 tm+HOUvwfeZc5ab+pv5vhsmxYThf20WThOcErRs7nxlEhxXGo+EAAUCwMKAGyuc5dhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049969;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e8iiXOq1nXZAnFfJDrfBNMH7TOVNOutJBqfZ4cpxjmI=;
	b=5ez8tGEK9gJ5YFX/wcO19gnOIFozi/36hHEBMU2QVai9rjrgnJeheT0DWAzRIsxJWKR3
	 RC/GblYSyXUxKlRuAZPQxK0aOTogDuWzzhMfxkqwe2wmRF8qNWscjfyx9f7D0fIwt1B1j
	 ucjeG0JkGUsN0wZ0VxRcW7vZX2CVSng5nx8dgdEXYZzho7J9QlNwIXZjQIrXV2+9LrU6R
	 O4qq3cfI9msih1Lhwwpav+GT+uew2CIFWQL6u4lvrq/vdBn8hRWoNJBwuezEfVj081VpN
	 ScU/9ztwxlJG7JHr26bHIOaSJfwpl7UmyZA1MTT7vj2noBT3NWzD1xD8h/ZUJzWLqdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iT8vjvCN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F98C606A31C;
	Thu, 19 Nov 2026 00:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iT8vjvCN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F241F000C4;
	Thu, 19 Nov 2026 00:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049969;
	bh=e8iiXOq1nXZAnFfJDrfBNMH7TOVNOutJBqfZ4cpxjmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iT8vjvCNWOS90MVIlYkd23OST4nrfCDe2ROItu+fCsKJKotv5FKtx+T3Q20kunW7U
	 FUk1XVJFJGX7UrtCwE7ONbR/SGR+SxT3SVlRxj/CLK9OkbhcMYiPelQtivVxbR6aV0
	 XPl2XZEDEgLYVaJEs19Fnr9PKpglQNsojNwj6+40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2500/2857] Bluetooth: msft: Lock failed probe cleanup against feature readers
Date: Wed, 18 Nov 2026 15:58:54 +0100
Message-ID: <20261118150331.572215313@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 21895f20fedc4504474bcb1022850b532ea4358e ]

The MSFT data must remain allocated while msft_get_features() reads
its features. read_adv_mon_features() protects that access with
hdev->lock, but msft_do_open() clears hdev->msft_data and frees the
object without that lock when read_supported_features() fails.

After a successful probe, the data survives a normal close. A later
open can fail the probe while a management feature request is running.
hci_mgmt_cmd() permits requests during HCI_INIT, and the opener's
hdev->req_lock does not serialize the management reader:

  Management feature request            HCI open
                                        hold hdev->req_lock
                                        msft_do_open()
  hold hdev->lock
  msft_get_features(): save msft
                                        read_supported_features() fails
                                        hdev->msft_data = NULL
                                        kfree(msft)
  read msft->features
  release hdev->lock                     release hdev->req_lock

The saved pointer then refers to freed memory, causing a use-after-free
read. Advertisement reporting through mgmt_device_found() also reads
the features with hdev->lock held.

Take hdev->lock around clearing and freeing msft_data in the failure
branch. An existing feature reader finishes before the free, while a
reader starting after cleanup sees NULL. Keep the synchronous probe
outside this critical section, following the existing req_lock to
hdev->lock ordering.

KASAN report as below:

    ==================================================================
    BUG: KASAN: slab-use-after-free in msft_monitor_supported+0xa9/0xb0
    Read of size 8 at addr ffff88811573ee00 by task mgmt-read-adv-m/532

        CPU: 2 UID: 0 PID: 532 Comm: mgmt-read-adv-m Not tainted
    7.2.0-rc6-pmb-bt-functional-v1+ #1 PREEMPT(lazy)
        Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps
    fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     ? msft_monitor_supported+0xa9/0xb0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __virt_addr_valid+0x20d/0x410
     ? msft_monitor_supported+0xa9/0xb0
     kasan_report+0xe0/0x110
     ? msft_monitor_supported+0xa9/0xb0
     msft_monitor_supported+0xa9/0xb0
     read_adv_mon_features+0xdf/0x640
     ? trace_hardirqs_on+0x18/0x160
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_read_adv_mon_features+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? do_raw_read_unlock+0x49/0xe0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? _raw_read_unlock+0x23/0x40
     hci_sock_sendmsg+0x12b5/0x2270
     ? __pfx_hci_sock_sendmsg+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? selinux_socket_sendmsg+0x160/0x280
     __sys_sendto+0x425/0x470
     ? __pfx_hci_sock_sendmsg+0x10/0x10
     ? __pfx___sys_sendto+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __sys_setsockopt+0x119/0x180
     __x64_sys_sendto+0xe5/0x1c0
     ? lockdep_hardirqs_on_prepare+0xea/0x1a0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? trace_hardirqs_on+0x18/0x160
     do_syscall_64+0x115/0x6a0
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
    RIP: 0033:0x7f9ceb04a687
        Code: 48 89 fa 4c 89 df e8 58 b3 00 00 8b 93 08 03 00 00 59 5e 48
    83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b>
    c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
    RSP: 002b:00007ffe6ab96a70 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
    RAX: ffffffffffffffda RBX: 00007f9ceafb8780 RCX: 00007f9ceb04a687
    RDX: 0000000000000006 RSI: 00007ffe6ab96aea RDI: 0000000000000003
    RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000000
    R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000003
    R13: 00007ffe6ab96d50 R14: 00007f9ceb1f6000 R15: 00005625e427dd68
     </TASK>

    Allocated by task 506:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_kmalloc+0xaa/0xb0
     __kmalloc_cache_noprof+0x251/0x610
     msft_register+0x54/0x260
     hci_register_dev+0x6b7/0xc80
     __vhci_create_device+0x330/0x840
     vhci_write+0x287/0x440
     vfs_write+0x637/0x1010
     ksys_write+0x111/0x200
     do_syscall_64+0x115/0x6a0
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    Freed by task 529:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     kasan_save_free_info+0x3b/0x60
     __kasan_slab_free+0x5f/0x80
     kfree+0x307/0x580
     msft_do_open+0x604/0x9e0
     hci_dev_open_sync+0x94a/0x2110
     hci_dev_do_open+0x2f/0xb0
     hci_dev_open+0x17d/0x300
     hci_sock_ioctl+0x3c6/0x710
     sock_do_ioctl+0x120/0x2b0
     sock_ioctl+0x41b/0x670
     __x64_sys_ioctl+0x163/0x1d0
     do_syscall_64+0x115/0x6a0
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    The buggy address belongs to the object at ffff88811573ee00
     which belongs to the cache kmalloc-256 of size 256
    The buggy address is located 0 bytes inside of
     freed 256-byte region [ffff88811573ee00, ffff88811573ef00)

    The buggy address belongs to the physical page:
        page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0
    pfn:0x11573e
    head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
    flags: 0x200000000000040(head|node=0|zone=2)
    page_type: f5(slab)
        raw: 0200000000000040 ffff888100042b40 dead000000000100
    dead000000000122
        raw: 0000000000000000 0000000000100010 00000000f5000000
    0000000000000000
        head: 0200000000000040 ffff888100042b40 dead000000000100
    dead000000000122
        head: 0000000000000000 0000000000100010 00000000f5000000
    0000000000000000
        head: 0200000000000001 ffffffffffffff81 00000000ffffffff
    00000000ffffffff
        head: 0000000000000000 0000000000000000 00000000ffffffff
    0000000000000000
    page dumped because: kasan: bad access detected

    Memory state around the buggy address:
     ffff88811573ed00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
     ffff88811573ed80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
    >ffff88811573ee00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                       ^
     ffff88811573ee80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
     ffff88811573ef00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
    ==================================================================

Fixes: 5031ffcc79b8 ("Bluetooth: Keep MSFT ext info throughout a hci_dev's life cycle")
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/msft.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index c27e137a23475..5fa89c2a294dd 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -524,8 +524,10 @@ void msft_do_open(struct hci_dev *hdev)
 	msft->features = 0;
 
 	if (!read_supported_features(hdev, msft)) {
+		hci_dev_lock(hdev);
 		hdev->msft_data = NULL;
 		kfree(msft);
+		hci_dev_unlock(hdev);
 		return;
 	}
 
-- 
2.53.0



