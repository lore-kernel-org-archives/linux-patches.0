Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C3C8F58;
	Mon,  4 Mar 2024 21:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588606; cv=none; b=nNn4KZyvZz7bX4OGn3v5Qor7gRQneMiRBAX9Sk1xjb8W726hQ3qvvsjZ7zLbg5NBW/Zi6y9hmzWpVaD+e8yYCFHncFYn2whC/Csla511bKIBiJKQ3BLEEh2DbE9uDmUppHYskEQnbDXyVRhf0fbwNhTVrObdDo9z0PjkUipPrnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588606; c=relaxed/simple;
	bh=/hYETJbAfB7PAXyLZYlrMNfLMVvAC9YtiAQGlWkoAvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+5sO1Ty5yY+c9lVh3zJqqVKOeiVE9uGB0vq5afPrhN+3kElVKqS0+YzfB3c+ywscjWgftWna3Q1ee2hOdGuJyQElLXHXiT9hpQPV+o+uJk6FuQ1B7puMQ17OyB7sq7V7KJyL7746Ksvl8plR5vX+dbvM5ja+q6alb4Nh4k/vG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1czY7+iK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1czY7+iK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62987C433C7;
	Mon,  4 Mar 2024 21:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588606;
	bh=/hYETJbAfB7PAXyLZYlrMNfLMVvAC9YtiAQGlWkoAvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1czY7+iKWEmEhhvuGr0ypnOAN+h3grfgUCNhsHHFGhvCmX0WxAcy9jZ8IEcWZ7Gt4
	 jcZIWGbCnfSkxkuWax2URoqt9m9f+YvGh4NBkngC7HLsZUeZWnY21MQQ3MI8uvKT3b
	 JsaNwCGQQUPOFx8c1i2aDRsbanRZ7ZcqWdh63IHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryosuke Yasuoka <ryasuoka@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+34ad5fab48f7bf510349@syzkaller.appspotmail.com
Subject: [PATCH 6.1 028/215] netlink: Fix kernel-infoleak-after-free in __skb_datagram_iter
Date: Mon,  4 Mar 2024 21:21:31 +0000
Message-ID: <20240304211557.886317854@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ryosuke Yasuoka <ryasuoka@redhat.com>

[ Upstream commit 661779e1fcafe1b74b3f3fe8e980c1e207fea1fd ]

syzbot reported the following uninit-value access issue [1]:

netlink_to_full_skb() creates a new `skb` and puts the `skb->data`
passed as a 1st arg of netlink_to_full_skb() onto new `skb`. The data
size is specified as `len` and passed to skb_put_data(). This `len`
is based on `skb->end` that is not data offset but buffer offset. The
`skb->end` contains data and tailroom. Since the tailroom is not
initialized when the new `skb` created, KMSAN detects uninitialized
memory area when copying the data.

This patch resolved this issue by correct the len from `skb->end` to
`skb->len`, which is the actual data offset.

BUG: KMSAN: kernel-infoleak-after-free in instrument_copy_to_user include/linux/instrumented.h:114 [inline]
BUG: KMSAN: kernel-infoleak-after-free in copy_to_user_iter lib/iov_iter.c:24 [inline]
BUG: KMSAN: kernel-infoleak-after-free in iterate_ubuf include/linux/iov_iter.h:29 [inline]
BUG: KMSAN: kernel-infoleak-after-free in iterate_and_advance2 include/linux/iov_iter.h:245 [inline]
BUG: KMSAN: kernel-infoleak-after-free in iterate_and_advance include/linux/iov_iter.h:271 [inline]
BUG: KMSAN: kernel-infoleak-after-free in _copy_to_iter+0x364/0x2520 lib/iov_iter.c:186
 instrument_copy_to_user include/linux/instrumented.h:114 [inline]
 copy_to_user_iter lib/iov_iter.c:24 [inline]
 iterate_ubuf include/linux/iov_iter.h:29 [inline]
 iterate_and_advance2 include/linux/iov_iter.h:245 [inline]
 iterate_and_advance include/linux/iov_iter.h:271 [inline]
 _copy_to_iter+0x364/0x2520 lib/iov_iter.c:186
 copy_to_iter include/linux/uio.h:197 [inline]
 simple_copy_to_iter+0x68/0xa0 net/core/datagram.c:532
 __skb_datagram_iter+0x123/0xdc0 net/core/datagram.c:420
 skb_copy_datagram_iter+0x5c/0x200 net/core/datagram.c:546
 skb_copy_datagram_msg include/linux/skbuff.h:3960 [inline]
 packet_recvmsg+0xd9c/0x2000 net/packet/af_packet.c:3482
 sock_recvmsg_nosec net/socket.c:1044 [inline]
 sock_recvmsg net/socket.c:1066 [inline]
 sock_read_iter+0x467/0x580 net/socket.c:1136
 call_read_iter include/linux/fs.h:2014 [inline]
 new_sync_read fs/read_write.c:389 [inline]
 vfs_read+0x8f6/0xe00 fs/read_write.c:470
 ksys_read+0x20f/0x4c0 fs/read_write.c:613
 __do_sys_read fs/read_write.c:623 [inline]
 __se_sys_read fs/read_write.c:621 [inline]
 __x64_sys_read+0x93/0xd0 fs/read_write.c:621
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0x44/0x110 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

Uninit was stored to memory at:
 skb_put_data include/linux/skbuff.h:2622 [inline]
 netlink_to_full_skb net/netlink/af_netlink.c:181 [inline]
 __netlink_deliver_tap_skb net/netlink/af_netlink.c:298 [inline]
 __netlink_deliver_tap+0x5be/0xc90 net/netlink/af_netlink.c:325
 netlink_deliver_tap net/netlink/af_netlink.c:338 [inline]
 netlink_deliver_tap_kernel net/netlink/af_netlink.c:347 [inline]
 netlink_unicast_kernel net/netlink/af_netlink.c:1341 [inline]
 netlink_unicast+0x10f1/0x1250 net/netlink/af_netlink.c:1368
 netlink_sendmsg+0x1238/0x13d0 net/netlink/af_netlink.c:1910
 sock_sendmsg_nosec net/socket.c:730 [inline]
 __sock_sendmsg net/socket.c:745 [inline]
 ____sys_sendmsg+0x9c2/0xd60 net/socket.c:2584
 ___sys_sendmsg+0x28d/0x3c0 net/socket.c:2638
 __sys_sendmsg net/socket.c:2667 [inline]
 __do_sys_sendmsg net/socket.c:2676 [inline]
 __se_sys_sendmsg net/socket.c:2674 [inline]
 __x64_sys_sendmsg+0x307/0x490 net/socket.c:2674
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0x44/0x110 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

Uninit was created at:
 free_pages_prepare mm/page_alloc.c:1087 [inline]
 free_unref_page_prepare+0xb0/0xa40 mm/page_alloc.c:2347
 free_unref_page_list+0xeb/0x1100 mm/page_alloc.c:2533
 release_pages+0x23d3/0x2410 mm/swap.c:1042
 free_pages_and_swap_cache+0xd9/0xf0 mm/swap_state.c:316
 tlb_batch_pages_flush mm/mmu_gather.c:98 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:293 [inline]
 tlb_flush_mmu+0x6f5/0x980 mm/mmu_gather.c:300
 tlb_finish_mmu+0x101/0x260 mm/mmu_gather.c:392
 exit_mmap+0x49e/0xd30 mm/mmap.c:3321
 __mmput+0x13f/0x530 kernel/fork.c:1349
 mmput+0x8a/0xa0 kernel/fork.c:1371
 exit_mm+0x1b8/0x360 kernel/exit.c:567
 do_exit+0xd57/0x4080 kernel/exit.c:858
 do_group_exit+0x2fd/0x390 kernel/exit.c:1021
 __do_sys_exit_group kernel/exit.c:1032 [inline]
 __se_sys_exit_group kernel/exit.c:1030 [inline]
 __x64_sys_exit_group+0x3c/0x50 kernel/exit.c:1030
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0x44/0x110 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

Bytes 3852-3903 of 3904 are uninitialized
Memory access of size 3904 starts at ffff88812ea1e000
Data copied to user address 0000000020003280

CPU: 1 PID: 5043 Comm: syz-executor297 Not tainted 6.7.0-rc5-syzkaller-00047-g5bd7ef53ffe5 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/10/2023

Fixes: 1853c9496460 ("netlink, mmap: transform mmap skb into full skb on taps")
Reported-and-tested-by: syzbot+34ad5fab48f7bf510349@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=34ad5fab48f7bf510349 [1]
Signed-off-by: Ryosuke Yasuoka <ryasuoka@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240221074053.1794118-1-ryasuoka@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 6857a4965fe87..e9b81cba1e2b4 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -167,7 +167,7 @@ static inline u32 netlink_group_mask(u32 group)
 static struct sk_buff *netlink_to_full_skb(const struct sk_buff *skb,
 					   gfp_t gfp_mask)
 {
-	unsigned int len = skb_end_offset(skb);
+	unsigned int len = skb->len;
 	struct sk_buff *new;
 
 	new = alloc_skb(len, gfp_mask);
-- 
2.43.0



