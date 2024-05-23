Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF52C14A634;
	Thu, 23 May 2024 13:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470202; cv=none; b=Y+JSRovNk2unueEK8Y5nPr4Mym7/dfE9LeRCamNYLipSL6I0IDbOAhpGrCOlYWJaZ/tAieGSxSstc1TtCTjrVK6/tWJtjK+tHf1BVVYZas8ZOFa7cylqnVGmSfPpM0dXSux8YyNnjmDoUQxEzKSkhKNtVSwE966zDTTqaRvduwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470202; c=relaxed/simple;
	bh=VylK7EqrcXpIvDC74OQMzKS/2IsPFBOjqKML2obJmZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s4iaDBkVinUbXaCtjmaJrjvgsNepnKgO7kFuO6MEN+2y3/q7sEnygJphAnAPIUq2GEv9lF4RzRf29Z/Paj0nfyORsmiNMzR3gOrHa+shhT+kLSEJxFsegGyqZOOgGR7BdfPuzW7NzMDJGdSFdyA/WJNJQ96CsEtgWNXhTPBdPTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tg4h5o1r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tg4h5o1r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581AAC2BD10;
	Thu, 23 May 2024 13:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470202;
	bh=VylK7EqrcXpIvDC74OQMzKS/2IsPFBOjqKML2obJmZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tg4h5o1rzarAVaC7Z/qb2jWKd+IuOKIQ6j+bcgJf0S4g3BGM6wyeu71bcK+LmGxB4
	 sba5yr/bjl5/WhPq9KXqtKUEaTjUf72RsJfD9gikgmqpxu5/At2P2gIycZfa4h/JHu
	 9jbVqqmQUyh1k0IvaKm9lw2jHYgcnwhhLULzW6YY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"yenchia.chen" <yenchia.chen@mediatek.com>
Subject: [PATCH 5.10 07/15] netlink: annotate lockless accesses to nlk->max_recvmsg_len
Date: Thu, 23 May 2024 15:12:49 +0200
Message-ID: <20240523130326.734443380@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130326.451548488@linuxfoundation.org>
References: <20240523130326.451548488@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit a1865f2e7d10dde00d35a2122b38d2e469ae67ed upstream.

syzbot reported a data-race in data-race in netlink_recvmsg() [1]

Indeed, netlink_recvmsg() can be run concurrently,
and netlink_dump() also needs protection.

[1]
BUG: KCSAN: data-race in netlink_recvmsg / netlink_recvmsg

read to 0xffff888141840b38 of 8 bytes by task 23057 on cpu 0:
netlink_recvmsg+0xea/0x730 net/netlink/af_netlink.c:1988
sock_recvmsg_nosec net/socket.c:1017 [inline]
sock_recvmsg net/socket.c:1038 [inline]
__sys_recvfrom+0x1ee/0x2e0 net/socket.c:2194
__do_sys_recvfrom net/socket.c:2212 [inline]
__se_sys_recvfrom net/socket.c:2208 [inline]
__x64_sys_recvfrom+0x78/0x90 net/socket.c:2208
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

write to 0xffff888141840b38 of 8 bytes by task 23037 on cpu 1:
netlink_recvmsg+0x114/0x730 net/netlink/af_netlink.c:1989
sock_recvmsg_nosec net/socket.c:1017 [inline]
sock_recvmsg net/socket.c:1038 [inline]
____sys_recvmsg+0x156/0x310 net/socket.c:2720
___sys_recvmsg net/socket.c:2762 [inline]
do_recvmmsg+0x2e5/0x710 net/socket.c:2856
__sys_recvmmsg net/socket.c:2935 [inline]
__do_sys_recvmmsg net/socket.c:2958 [inline]
__se_sys_recvmmsg net/socket.c:2951 [inline]
__x64_sys_recvmmsg+0xe2/0x160 net/socket.c:2951
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

value changed: 0x0000000000000000 -> 0x0000000000001000

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 23037 Comm: syz-executor.2 Not tainted 6.3.0-rc4-syzkaller-00195-g5a57b48fdfcb #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023

Fixes: 9063e21fb026 ("netlink: autosize skb lengthes")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230403214643.768555-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: yenchia.chen <yenchia.chen@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netlink/af_netlink.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1927,7 +1927,7 @@ static int netlink_recvmsg(struct socket
 	struct sock *sk = sock->sk;
 	struct netlink_sock *nlk = nlk_sk(sk);
 	int noblock = flags & MSG_DONTWAIT;
-	size_t copied;
+	size_t copied, max_recvmsg_len;
 	struct sk_buff *skb, *data_skb;
 	int err, ret;
 
@@ -1960,9 +1960,10 @@ static int netlink_recvmsg(struct socket
 #endif
 
 	/* Record the max length of recvmsg() calls for future allocations */
-	nlk->max_recvmsg_len = max(nlk->max_recvmsg_len, len);
-	nlk->max_recvmsg_len = min_t(size_t, nlk->max_recvmsg_len,
-				     SKB_WITH_OVERHEAD(32768));
+	max_recvmsg_len = max(READ_ONCE(nlk->max_recvmsg_len), len);
+	max_recvmsg_len = min_t(size_t, max_recvmsg_len,
+				SKB_WITH_OVERHEAD(32768));
+	WRITE_ONCE(nlk->max_recvmsg_len, max_recvmsg_len);
 
 	copied = data_skb->len;
 	if (len < copied) {
@@ -2211,6 +2212,7 @@ static int netlink_dump(struct sock *sk)
 	struct netlink_ext_ack extack = {};
 	struct netlink_callback *cb;
 	struct sk_buff *skb = NULL;
+	size_t max_recvmsg_len;
 	struct module *module;
 	int err = -ENOBUFS;
 	int alloc_min_size;
@@ -2233,8 +2235,9 @@ static int netlink_dump(struct sock *sk)
 	cb = &nlk->cb;
 	alloc_min_size = max_t(int, cb->min_dump_alloc, NLMSG_GOODSIZE);
 
-	if (alloc_min_size < nlk->max_recvmsg_len) {
-		alloc_size = nlk->max_recvmsg_len;
+	max_recvmsg_len = READ_ONCE(nlk->max_recvmsg_len);
+	if (alloc_min_size < max_recvmsg_len) {
+		alloc_size = max_recvmsg_len;
 		skb = alloc_skb(alloc_size,
 				(GFP_KERNEL & ~__GFP_DIRECT_RECLAIM) |
 				__GFP_NOWARN | __GFP_NORETRY);


