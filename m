Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E63154426;
	Mon,  6 Jan 2025 15:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176800; cv=none; b=rphIWGr2pgkWgBJzO9Cl0peYXSFx9o/xdNKaBcW7hB9b7hPf+Gg5YsV3UOXKjJMnV6gPQG0mkphtO8TYLNnpIQ3BGOye6KMPfsCbm9wltcM5TZ69oxdeK1i08ecd1Ot/9XcROxCEhbh7R7CY0SLmvKRYY6M6qAQwdosqdbHBGcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176800; c=relaxed/simple;
	bh=8gE0V9lwFldYNzEfsdE9Hl45n3suPtMZEygjOO5qKwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ricTRmpHdEiBuKBZF5YeTbFSOF7r83EE7F2a+yCFTmwJJBCy3ou7mvj7cFe+5cjJZzaPyhuhmn97OSkDDEJ1SU8nEmSSXYlFablZR5GR7Ui5aUSUNNVb36N6WnspwX1ABJhLvpKC69esIph9mq41GyB2Su/mYC82mNcIWxmWBBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iwhmGfbo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iwhmGfbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89670C4CED6;
	Mon,  6 Jan 2025 15:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176799;
	bh=8gE0V9lwFldYNzEfsdE9Hl45n3suPtMZEygjOO5qKwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iwhmGfbobIZLMkg8SmyA/q44rvwfpy3f05TX3rF5nkPKGun4fiiXXJnKQ4/wLCOjG
	 c2TK/B8qvV9+bfRgZ1J5Rp9PxJYg60RiBo34IoJYO3F2HjuYSBcybjLiWKXqfeXfby
	 0WK4zZn1Oyi0bUixI/dAwWxC+prdz4MM8rKCurZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Marushkin <hfggklm@gmail.com>,
	Ilya Shchipletsov <rabbelkin@mail.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 36/81] netrom: check buffer length before accessing it
Date: Mon,  6 Jan 2025 16:16:08 +0100
Message-ID: <20250106151130.801386353@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ilya Shchipletsov <rabbelkin@mail.ru>

[ Upstream commit a4fd163aed2edd967a244499754dec991d8b4c7d ]

Syzkaller reports an uninit value read from ax25cmp when sending raw message
through ieee802154 implementation.

=====================================================
BUG: KMSAN: uninit-value in ax25cmp+0x3a5/0x460 net/ax25/ax25_addr.c:119
 ax25cmp+0x3a5/0x460 net/ax25/ax25_addr.c:119
 nr_dev_get+0x20e/0x450 net/netrom/nr_route.c:601
 nr_route_frame+0x1a2/0xfc0 net/netrom/nr_route.c:774
 nr_xmit+0x5a/0x1c0 net/netrom/nr_dev.c:144
 __netdev_start_xmit include/linux/netdevice.h:4940 [inline]
 netdev_start_xmit include/linux/netdevice.h:4954 [inline]
 xmit_one net/core/dev.c:3548 [inline]
 dev_hard_start_xmit+0x247/0xa10 net/core/dev.c:3564
 __dev_queue_xmit+0x33b8/0x5130 net/core/dev.c:4349
 dev_queue_xmit include/linux/netdevice.h:3134 [inline]
 raw_sendmsg+0x654/0xc10 net/ieee802154/socket.c:299
 ieee802154_sock_sendmsg+0x91/0xc0 net/ieee802154/socket.c:96
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
 slab_post_alloc_hook+0x129/0xa70 mm/slab.h:768
 slab_alloc_node mm/slub.c:3478 [inline]
 kmem_cache_alloc_node+0x5e9/0xb10 mm/slub.c:3523
 kmalloc_reserve+0x13d/0x4a0 net/core/skbuff.c:560
 __alloc_skb+0x318/0x740 net/core/skbuff.c:651
 alloc_skb include/linux/skbuff.h:1286 [inline]
 alloc_skb_with_frags+0xc8/0xbd0 net/core/skbuff.c:6334
 sock_alloc_send_pskb+0xa80/0xbf0 net/core/sock.c:2780
 sock_alloc_send_skb include/net/sock.h:1884 [inline]
 raw_sendmsg+0x36d/0xc10 net/ieee802154/socket.c:282
 ieee802154_sock_sendmsg+0x91/0xc0 net/ieee802154/socket.c:96
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

CPU: 0 PID: 5037 Comm: syz-executor166 Not tainted 6.7.0-rc7-syzkaller-00003-gfbafc3e621c3 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/17/2023
=====================================================

This issue occurs because the skb buffer is too small, and it's actual
allocation is aligned. This hides an actual issue, which is that nr_route_frame
does not validate the buffer size before using it.

Fix this issue by checking skb->len before accessing any fields in skb->data.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Co-developed-by: Nikita Marushkin <hfggklm@gmail.com>
Signed-off-by: Nikita Marushkin <hfggklm@gmail.com>
Signed-off-by: Ilya Shchipletsov <rabbelkin@mail.ru>
Link: https://patch.msgid.link/20241219082308.3942-1-rabbelkin@mail.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/nr_route.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netrom/nr_route.c b/net/netrom/nr_route.c
index bd2b17b219ae..0b270893ee14 100644
--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -754,6 +754,12 @@ int nr_route_frame(struct sk_buff *skb, ax25_cb *ax25)
 	int ret;
 	struct sk_buff *skbn;
 
+	/*
+	 * Reject malformed packets early. Check that it contains at least 2
+	 * addresses and 1 byte more for Time-To-Live
+	 */
+	if (skb->len < 2 * sizeof(ax25_address) + 1)
+		return 0;
 
 	nr_src  = (ax25_address *)(skb->data + 0);
 	nr_dest = (ax25_address *)(skb->data + 7);
-- 
2.39.5



