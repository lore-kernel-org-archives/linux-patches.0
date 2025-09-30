Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314F61EE02F;
	Tue, 30 Sep 2025 15:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244624; cv=none; b=Vl/woG/kvijPN3VVu7gLbYfAlkmpIggCwsCK7UACYLX7V8hFqVJ4FQxQJHvA3LGJOpzeAD/4MyL06+M7jS81nNQbCDPWxsxXmp7qQJ0RZSAMHBAFiWsicSxu7AYEF5i78Ok4vr1IdLhDQruvScBL86ZNk0gSjXgiudROQBvuM2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244624; c=relaxed/simple;
	bh=rn5DSqe9TVMrErglLhBdGyEyiA1zCxc0vf/pg1Mqvlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=duWVYDieJ5+WHjEVm14lQdV7WH0CfoqOs1OG5As9Opo8aiaBN/DMtRpN7T6p7kkboY0YnWrIlOxqxRfc28iq1Yn1fqcXtyFsXVC4m71BW1OG6sCsQuadhOd7bMTyAb0cZEzjby9ZNREly2XyFJVIZvBsPehQuzy+o4/L5Lt9wWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q+/J8cKg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q+/J8cKg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8D3C4CEF0;
	Tue, 30 Sep 2025 15:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244623;
	bh=rn5DSqe9TVMrErglLhBdGyEyiA1zCxc0vf/pg1Mqvlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q+/J8cKgxS/ZRM+qDGdG4CVanNsHC3nhyPgaacSUVE6ZOqNO0K+ZQFT2jL3BXpz9F
	 +dPylM3ZYtp+fcn9G7VhyWssvfLYU+GlvNMZrFiozvK2ep3oe+ET6G0ficMQGam3Fw
	 rRszoZOQBdZyHQC5GlhJ26Gwqm4hZTtqoi3muDjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+64e24275ad95a915a313@syzkaller.appspotmail.com,
	Wang Liang <wangliang74@huawei.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 065/143] net: tun: Update napi->skb after XDP process
Date: Tue, 30 Sep 2025 16:46:29 +0200
Message-ID: <20250930143833.826641745@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Liang <wangliang74@huawei.com>

[ Upstream commit 1091860a16a86ccdd77c09f2b21a5f634f5ab9ec ]

The syzbot report a UAF issue:

  BUG: KASAN: slab-use-after-free in skb_reset_mac_header include/linux/skbuff.h:3150 [inline]
  BUG: KASAN: slab-use-after-free in napi_frags_skb net/core/gro.c:723 [inline]
  BUG: KASAN: slab-use-after-free in napi_gro_frags+0x6e/0x1030 net/core/gro.c:758
  Read of size 8 at addr ffff88802ef22c18 by task syz.0.17/6079
  CPU: 0 UID: 0 PID: 6079 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full)
  Call Trace:
   <TASK>
   dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
   print_address_description mm/kasan/report.c:378 [inline]
   print_report+0xca/0x240 mm/kasan/report.c:482
   kasan_report+0x118/0x150 mm/kasan/report.c:595
   skb_reset_mac_header include/linux/skbuff.h:3150 [inline]
   napi_frags_skb net/core/gro.c:723 [inline]
   napi_gro_frags+0x6e/0x1030 net/core/gro.c:758
   tun_get_user+0x28cb/0x3e20 drivers/net/tun.c:1920
   tun_chr_write_iter+0x113/0x200 drivers/net/tun.c:1996
   new_sync_write fs/read_write.c:593 [inline]
   vfs_write+0x5c9/0xb30 fs/read_write.c:686
   ksys_write+0x145/0x250 fs/read_write.c:738
   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
   do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>

  Allocated by task 6079:
   kasan_save_stack mm/kasan/common.c:47 [inline]
   kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
   unpoison_slab_object mm/kasan/common.c:330 [inline]
   __kasan_mempool_unpoison_object+0xa0/0x170 mm/kasan/common.c:558
   kasan_mempool_unpoison_object include/linux/kasan.h:388 [inline]
   napi_skb_cache_get+0x37b/0x6d0 net/core/skbuff.c:295
   __alloc_skb+0x11e/0x2d0 net/core/skbuff.c:657
   napi_alloc_skb+0x84/0x7d0 net/core/skbuff.c:811
   napi_get_frags+0x69/0x140 net/core/gro.c:673
   tun_napi_alloc_frags drivers/net/tun.c:1404 [inline]
   tun_get_user+0x77c/0x3e20 drivers/net/tun.c:1784
   tun_chr_write_iter+0x113/0x200 drivers/net/tun.c:1996
   new_sync_write fs/read_write.c:593 [inline]
   vfs_write+0x5c9/0xb30 fs/read_write.c:686
   ksys_write+0x145/0x250 fs/read_write.c:738
   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
   do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

  Freed by task 6079:
   kasan_save_stack mm/kasan/common.c:47 [inline]
   kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
   kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:576
   poison_slab_object mm/kasan/common.c:243 [inline]
   __kasan_slab_free+0x5b/0x80 mm/kasan/common.c:275
   kasan_slab_free include/linux/kasan.h:233 [inline]
   slab_free_hook mm/slub.c:2422 [inline]
   slab_free mm/slub.c:4695 [inline]
   kmem_cache_free+0x18f/0x400 mm/slub.c:4797
   skb_pp_cow_data+0xdd8/0x13e0 net/core/skbuff.c:969
   netif_skb_check_for_xdp net/core/dev.c:5390 [inline]
   netif_receive_generic_xdp net/core/dev.c:5431 [inline]
   do_xdp_generic+0x699/0x11a0 net/core/dev.c:5499
   tun_get_user+0x2523/0x3e20 drivers/net/tun.c:1872
   tun_chr_write_iter+0x113/0x200 drivers/net/tun.c:1996
   new_sync_write fs/read_write.c:593 [inline]
   vfs_write+0x5c9/0xb30 fs/read_write.c:686
   ksys_write+0x145/0x250 fs/read_write.c:738
   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
   do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

After commit e6d5dbdd20aa ("xdp: add multi-buff support for xdp running in
generic mode"), the original skb may be freed in skb_pp_cow_data() when
XDP program was attached, which was allocated in tun_napi_alloc_frags().
However, the napi->skb still point to the original skb, update it after
XDP process.

Reported-by: syzbot+64e24275ad95a915a313@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=64e24275ad95a915a313
Fixes: e6d5dbdd20aa ("xdp: add multi-buff support for xdp running in generic mode")
Signed-off-by: Wang Liang <wangliang74@huawei.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20250917113919.3991267-1-wangliang74@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index f8c5e2fd04dfa..0fffa023cb736 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1863,6 +1863,9 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 				local_bh_enable();
 				goto unlock_frags;
 			}
+
+			if (frags && skb != tfile->napi.skb)
+				tfile->napi.skb = skb;
 		}
 		rcu_read_unlock();
 		local_bh_enable();
-- 
2.51.0



