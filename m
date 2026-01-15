Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680924C81;
	Thu, 15 Jan 2026 17:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498801; cv=none; b=RddZDQLDSTJ62qstIenyiBDJ4CQd4tyxcgiw0+6yOYUbTG1p1OKVY98AO7nO1xkMyUiDmMV/2VX+8ynJrV/h7AE6zk25xrF9WjNj0n+d95u4wqQzGHfAWZklPFoCuCEwCIVjrD3o1ZodeEmu0riADGr+IGSlL4Yg13ZX/EFw9cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498801; c=relaxed/simple;
	bh=/xlR0LqAhrxXMgMLIo3h969ilsD6NepZn2PfpK1/kFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETmw2a6JkzbU6SUFC5u7fsdUb+bvSoc4F2+8J7YDZqDpgAVVWRRmFvXo0X+m5b1fc8TDH0Rdyn27aEecJ4qT7CAo7RoCbJE7Y5SekdeRkcFrpgUKhzSO6ao5NaE7mnW2+C8P4X1haeWFSbzazZWfQdXJBALNGrGo3oCvLusi+F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDTq2ePD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDTq2ePD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92B6C116D0;
	Thu, 15 Jan 2026 17:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498801;
	bh=/xlR0LqAhrxXMgMLIo3h969ilsD6NepZn2PfpK1/kFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wDTq2ePDXNh68SjJkYXPEvHgrFf7sPmjJ7dTkdXwhrhey5f3dDg8Hjmxht46O2nFn
	 mKuYX/2+zFzJ1U+EFwiTBEcx1m5iRsyfruYwsDKO+NgVxsHTROCRItVNIowMEwnLfk
	 yGxElVvys8htINj9WAYyLAkJ7BaOx1n/l03R8BJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 532/554] net: sock: fix hardened usercopy panic in sock_recv_errqueue
Date: Thu, 15 Jan 2026 17:49:58 +0100
Message-ID: <20260115164305.582917142@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 2a71a1a8d0ed718b1c7a9ac61f07e5755c47ae20 ]

skbuff_fclone_cache was created without defining a usercopy region,
[1] unlike skbuff_head_cache which properly whitelists the cb[] field.
[2] This causes a usercopy BUG() when CONFIG_HARDENED_USERCOPY is
enabled and the kernel attempts to copy sk_buff.cb data to userspace
via sock_recv_errqueue() -> put_cmsg().

The crash occurs when: 1. TCP allocates an skb using alloc_skb_fclone()
   (from skbuff_fclone_cache) [1]
2. The skb is cloned via skb_clone() using the pre-allocated fclone
[3] 3. The cloned skb is queued to sk_error_queue for timestamp
reporting 4. Userspace reads the error queue via recvmsg(MSG_ERRQUEUE)
5. sock_recv_errqueue() calls put_cmsg() to copy serr->ee from skb->cb
[4] 6. __check_heap_object() fails because skbuff_fclone_cache has no
   usercopy whitelist [5]

When cloned skbs allocated from skbuff_fclone_cache are used in the
socket error queue, accessing the sock_exterr_skb structure in skb->cb
via put_cmsg() triggers a usercopy hardening violation:

[    5.379589] usercopy: Kernel memory exposure attempt detected from SLUB object 'skbuff_fclone_cache' (offset 296, size 16)!
[    5.382796] kernel BUG at mm/usercopy.c:102!
[    5.383923] Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
[    5.384903] CPU: 1 UID: 0 PID: 138 Comm: poc_put_cmsg Not tainted 6.12.57 #7
[    5.384903] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
[    5.384903] RIP: 0010:usercopy_abort+0x6c/0x80
[    5.384903] Code: 1a 86 51 48 c7 c2 40 15 1a 86 41 52 48 c7 c7 c0 15 1a 86 48 0f 45 d6 48 c7 c6 80 15 1a 86 48 89 c1 49 0f 45 f3 e8 84 27 88 ff <0f> 0b 490
[    5.384903] RSP: 0018:ffffc900006f77a8 EFLAGS: 00010246
[    5.384903] RAX: 000000000000006f RBX: ffff88800f0ad2a8 RCX: 1ffffffff0f72e74
[    5.384903] RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffffffff87b973a0
[    5.384903] RBP: 0000000000000010 R08: 0000000000000000 R09: fffffbfff0f72e74
[    5.384903] R10: 0000000000000003 R11: 79706f6372657375 R12: 0000000000000001
[    5.384903] R13: ffff88800f0ad2b8 R14: ffffea00003c2b40 R15: ffffea00003c2b00
[    5.384903] FS:  0000000011bc4380(0000) GS:ffff8880bf100000(0000) knlGS:0000000000000000
[    5.384903] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    5.384903] CR2: 000056aa3b8e5fe4 CR3: 000000000ea26004 CR4: 0000000000770ef0
[    5.384903] PKRU: 55555554
[    5.384903] Call Trace:
[    5.384903]  <TASK>
[    5.384903]  __check_heap_object+0x9a/0xd0
[    5.384903]  __check_object_size+0x46c/0x690
[    5.384903]  put_cmsg+0x129/0x5e0
[    5.384903]  sock_recv_errqueue+0x22f/0x380
[    5.384903]  tls_sw_recvmsg+0x7ed/0x1960
[    5.384903]  ? srso_alias_return_thunk+0x5/0xfbef5
[    5.384903]  ? schedule+0x6d/0x270
[    5.384903]  ? srso_alias_return_thunk+0x5/0xfbef5
[    5.384903]  ? mutex_unlock+0x81/0xd0
[    5.384903]  ? __pfx_mutex_unlock+0x10/0x10
[    5.384903]  ? __pfx_tls_sw_recvmsg+0x10/0x10
[    5.384903]  ? _raw_spin_lock_irqsave+0x8f/0xf0
[    5.384903]  ? _raw_read_unlock_irqrestore+0x20/0x40
[    5.384903]  ? srso_alias_return_thunk+0x5/0xfbef5

The crash offset 296 corresponds to skb2->cb within skbuff_fclones:
  - sizeof(struct sk_buff) = 232 - offsetof(struct sk_buff, cb) = 40 -
  offset of skb2.cb in fclones = 232 + 40 = 272 - crash offset 296 =
  272 + 24 (inside sock_exterr_skb.ee)

This patch uses a local stack variable as a bounce buffer to avoid the hardened usercopy check failure.

[1] https://elixir.bootlin.com/linux/v6.12.62/source/net/ipv4/tcp.c#L885
[2] https://elixir.bootlin.com/linux/v6.12.62/source/net/core/skbuff.c#L5104
[3] https://elixir.bootlin.com/linux/v6.12.62/source/net/core/skbuff.c#L5566
[4] https://elixir.bootlin.com/linux/v6.12.62/source/net/core/skbuff.c#L5491
[5] https://elixir.bootlin.com/linux/v6.12.62/source/mm/slub.c#L5719

Fixes: 6d07d1cd300f ("usercopy: Restrict non-usercopy caches to size 0")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20251223203534.1392218-2-bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index b4e605ac79c9f..bf2bec10d5d6a 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3377,7 +3377,7 @@ void sock_enable_timestamp(struct sock *sk, enum sock_flags flag)
 int sock_recv_errqueue(struct sock *sk, struct msghdr *msg, int len,
 		       int level, int type)
 {
-	struct sock_exterr_skb *serr;
+	struct sock_extended_err ee;
 	struct sk_buff *skb;
 	int copied, err;
 
@@ -3397,8 +3397,9 @@ int sock_recv_errqueue(struct sock *sk, struct msghdr *msg, int len,
 
 	sock_recv_timestamp(msg, sk, skb);
 
-	serr = SKB_EXT_ERR(skb);
-	put_cmsg(msg, level, type, sizeof(serr->ee), &serr->ee);
+	/* We must use a bounce buffer for CONFIG_HARDENED_USERCOPY=y */
+	ee = SKB_EXT_ERR(skb)->ee;
+	put_cmsg(msg, level, type, sizeof(ee), &ee);
 
 	msg->msg_flags |= MSG_ERRQUEUE;
 	err = copied;
-- 
2.51.0



