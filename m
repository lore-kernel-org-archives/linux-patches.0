Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC383181B9E;
	Wed,  3 Jul 2024 11:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006172; cv=none; b=txgyEqBRMN4SlvGnRAaKHd6JHF0pCcqCYcvnzuVtU0FX18OW4kUiTprA994n8Prhqa9KKfm63bYIcivbgNfHmkEfYI9sBupccTTF5w3mXwenRuVkTAxtUvjlUzp372J1I+bIR9ZHVbS+iKDELUpYF8dOjkytla1ZJESQkYOQGwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006172; c=relaxed/simple;
	bh=ClmWp9mjtDPsbDQN4npAmTFojRKzLROqvkQl/z0T2AE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YN07/Z2VHzrZ+pDoCprgPWXwQ58MZzjwPsDZawvuLUOYni9yp43vl/oowDNf5aSnkPaDcNltGs+swXzHLZ0ewc9jyzIZP9CKQhXFq6A2c0jBsh1uq/8ZuUoc8pEMjnzgsO9QF51moHinlPjUvyfZkqBT+Ag7S9wi9vbfVqYBtmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bHI954qG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bHI954qG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B5EC2BD10;
	Wed,  3 Jul 2024 11:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006172;
	bh=ClmWp9mjtDPsbDQN4npAmTFojRKzLROqvkQl/z0T2AE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bHI954qGuyJQ6s2vq4rPCEEOTJ69T4FsZcXYJq5QAcuddHtZWbGpmTXjHD2RsOP0P
	 x5aglrrpdO47CKnqPDfwWqXswpP8cK2TjdKnbbNlU7oJ3oNfST1L9FqXm6/MCNvns/
	 z6u1eKUAahms0bGX4z3K63SHC4D2k9EecBBEVgac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Shigeru Yoshida <syoshida@redhat.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	syzbot+5681e40d297b30f5b513@syzkaller.appspotmail.com
Subject: [PATCH 5.15 325/356] net: can: j1939: Initialize unused data in j1939_send_one()
Date: Wed,  3 Jul 2024 12:41:01 +0200
Message-ID: <20240703102925.409527422@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shigeru Yoshida <syoshida@redhat.com>

commit b7cdf1dd5d2a2d8200efd98d1893684db48fe134 upstream.

syzbot reported kernel-infoleak in raw_recvmsg() [1]. j1939_send_one()
creates full frame including unused data, but it doesn't initialize
it. This causes the kernel-infoleak issue. Fix this by initializing
unused data.

[1]
BUG: KMSAN: kernel-infoleak in instrument_copy_to_user include/linux/instrumented.h:114 [inline]
BUG: KMSAN: kernel-infoleak in copy_to_user_iter lib/iov_iter.c:24 [inline]
BUG: KMSAN: kernel-infoleak in iterate_ubuf include/linux/iov_iter.h:29 [inline]
BUG: KMSAN: kernel-infoleak in iterate_and_advance2 include/linux/iov_iter.h:245 [inline]
BUG: KMSAN: kernel-infoleak in iterate_and_advance include/linux/iov_iter.h:271 [inline]
BUG: KMSAN: kernel-infoleak in _copy_to_iter+0x366/0x2520 lib/iov_iter.c:185
 instrument_copy_to_user include/linux/instrumented.h:114 [inline]
 copy_to_user_iter lib/iov_iter.c:24 [inline]
 iterate_ubuf include/linux/iov_iter.h:29 [inline]
 iterate_and_advance2 include/linux/iov_iter.h:245 [inline]
 iterate_and_advance include/linux/iov_iter.h:271 [inline]
 _copy_to_iter+0x366/0x2520 lib/iov_iter.c:185
 copy_to_iter include/linux/uio.h:196 [inline]
 memcpy_to_msg include/linux/skbuff.h:4113 [inline]
 raw_recvmsg+0x2b8/0x9e0 net/can/raw.c:1008
 sock_recvmsg_nosec net/socket.c:1046 [inline]
 sock_recvmsg+0x2c4/0x340 net/socket.c:1068
 ____sys_recvmsg+0x18a/0x620 net/socket.c:2803
 ___sys_recvmsg+0x223/0x840 net/socket.c:2845
 do_recvmmsg+0x4fc/0xfd0 net/socket.c:2939
 __sys_recvmmsg net/socket.c:3018 [inline]
 __do_sys_recvmmsg net/socket.c:3041 [inline]
 __se_sys_recvmmsg net/socket.c:3034 [inline]
 __x64_sys_recvmmsg+0x397/0x490 net/socket.c:3034
 x64_sys_call+0xf6c/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:300
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 slab_post_alloc_hook mm/slub.c:3804 [inline]
 slab_alloc_node mm/slub.c:3845 [inline]
 kmem_cache_alloc_node+0x613/0xc50 mm/slub.c:3888
 kmalloc_reserve+0x13d/0x4a0 net/core/skbuff.c:577
 __alloc_skb+0x35b/0x7a0 net/core/skbuff.c:668
 alloc_skb include/linux/skbuff.h:1313 [inline]
 alloc_skb_with_frags+0xc8/0xbf0 net/core/skbuff.c:6504
 sock_alloc_send_pskb+0xa81/0xbf0 net/core/sock.c:2795
 sock_alloc_send_skb include/net/sock.h:1842 [inline]
 j1939_sk_alloc_skb net/can/j1939/socket.c:878 [inline]
 j1939_sk_send_loop net/can/j1939/socket.c:1142 [inline]
 j1939_sk_sendmsg+0xc0a/0x2730 net/can/j1939/socket.c:1277
 sock_sendmsg_nosec net/socket.c:730 [inline]
 __sock_sendmsg+0x30f/0x380 net/socket.c:745
 ____sys_sendmsg+0x877/0xb60 net/socket.c:2584
 ___sys_sendmsg+0x28d/0x3c0 net/socket.c:2638
 __sys_sendmsg net/socket.c:2667 [inline]
 __do_sys_sendmsg net/socket.c:2676 [inline]
 __se_sys_sendmsg net/socket.c:2674 [inline]
 __x64_sys_sendmsg+0x307/0x4a0 net/socket.c:2674
 x64_sys_call+0xc4b/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:47
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Bytes 12-15 of 16 are uninitialized
Memory access of size 16 starts at ffff888120969690
Data copied to user address 00000000200017c0

CPU: 1 PID: 5050 Comm: syz-executor198 Not tainted 6.9.0-rc5-syzkaller-00031-g71b1543c83d6 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Reported-and-tested-by: syzbot+5681e40d297b30f5b513@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5681e40d297b30f5b513
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Link: https://lore.kernel.org/all/20240517035953.2617090-1-syoshida@redhat.com
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/j1939/main.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/net/can/j1939/main.c
+++ b/net/can/j1939/main.c
@@ -30,10 +30,6 @@ MODULE_ALIAS("can-proto-" __stringify(CA
 /* CAN_HDR: #bytes before can_frame data part */
 #define J1939_CAN_HDR (offsetof(struct can_frame, data))
 
-/* CAN_FTR: #bytes beyond data part */
-#define J1939_CAN_FTR (sizeof(struct can_frame) - J1939_CAN_HDR - \
-		 sizeof(((struct can_frame *)0)->data))
-
 /* lowest layer */
 static void j1939_can_recv(struct sk_buff *iskb, void *data)
 {
@@ -338,7 +334,7 @@ int j1939_send_one(struct j1939_priv *pr
 	memset(cf, 0, J1939_CAN_HDR);
 
 	/* make it a full can frame again */
-	skb_put(skb, J1939_CAN_FTR + (8 - dlc));
+	skb_put_zero(skb, 8 - dlc);
 
 	canid = CAN_EFF_FLAG |
 		(skcb->priority << 26) |


