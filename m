Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAE8256C84;
	Wed, 25 Feb 2026 01:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983859; cv=none; b=Gge+KTVwoIZHqZPvPy5a29sJDLae6aUVdbVInHCWlWIzmTAJ7tfgCCr5qb3hlJeFYJWaRNEYY1k3SgGtm3hecFQv9r9zeQe9nSqiy+oG5oOXIPT76zaZiu/uLx4MSrX8DmRZlKLi6TlnwM/u0FCnW4WcE89ymPTBd3XM/z5wMgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983859; c=relaxed/simple;
	bh=wbq6iNPhKZC5cljK/7taG8GX4ZZng1sO9Oc6Yw8WHKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WG/gZJhNtgNMhjdOlMcD4XGf6FJR55ZgM7dDGsfFdLcv4h6QRg3XMXg6y898eBFlUE/izgsvjjtX9VFLcSM2cJ/j0MGwVBaYwLM7jrVsJ3JctBPxjJFOI5KZdzrIU7WiETTt1VzQ+Kqmz1Ya23y05heYjqFfCQybJa1QdD1cLe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RnQT4l7J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RnQT4l7J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C200EC116D0;
	Wed, 25 Feb 2026 01:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983858;
	bh=wbq6iNPhKZC5cljK/7taG8GX4ZZng1sO9Oc6Yw8WHKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RnQT4l7J+sbaS0A22tvE3czsFQCpwA1iZtcgp/Gtsi6EPZTfsxlsOT9R3Y2mOJcje
	 tykHJ3bGlW+3+lMpNAHfotr/SV+TDcI7hlLI+WhReb2dy/Sr+ryZ7bFBMZIMCTtvXx
	 pqp5tRr8qYPesA8i8xie6jPkOoflNhx9G7QksrsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Sitnicki <jakub@cloudflare.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 093/641] bpf, sockmap: Fix incorrect copied_seq calculation
Date: Tue, 24 Feb 2026 17:16:59 -0800
Message-ID: <20260225012351.354329506@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit b40cc5adaa80e1471095a62d78233b611d7a558c ]

A socket using sockmap has its own independent receive queue: ingress_msg.
This queue may contain data from its own protocol stack or from other
sockets.

The issue is that when reading from ingress_msg, we update tp->copied_seq
by default. However, if the data is not from its own protocol stack,
tcp->rcv_nxt is not increased. Later, if we convert this socket to a
native socket, reading from this socket may fail because copied_seq might
be significantly larger than rcv_nxt.

This fix also addresses the syzkaller-reported bug referenced in the
Closes tag.

This patch marks the skmsg objects in ingress_msg. When reading, we update
copied_seq only if the data is from its own protocol stack.

                                                     FD1:read()
                                                     --  FD1->copied_seq++
                                                         |  [read data]
                                                         |
                                [enqueue data]           v
                  [sockmap]     -> ingress to self ->  ingress_msg queue
FD1 native stack  ------>                                 ^
-- FD1->rcv_nxt++               -> redirect to other      | [enqueue data]
                                       |                  |
                                       |             ingress to FD1
                                       v                  ^
                                      ...                 |  [sockmap]
                                                     FD2 native stack

Closes: https://syzkaller.appspot.com/bug?extid=06dbd397158ec0ea4983
Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://lore.kernel.org/r/20260124113314.113584-2-jiayuan.chen@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skmsg.h |  2 ++
 net/core/skmsg.c      | 27 ++++++++++++++++++++++++---
 net/ipv4/tcp_bpf.c    |  5 +++--
 3 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 49847888c287a..dfdc158ab88c8 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -141,6 +141,8 @@ int sk_msg_memcopy_from_iter(struct sock *sk, struct iov_iter *from,
 			     struct sk_msg *msg, u32 bytes);
 int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 		   int len, int flags);
+int __sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
+		     int len, int flags, int *copied_from_self);
 bool sk_msg_is_readable(struct sock *sk);
 
 static inline void sk_msg_check_to_free(struct sk_msg *msg, u32 i, u32 bytes)
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 2ac7731e1e0a7..d402da5caadd6 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -409,22 +409,26 @@ int sk_msg_memcopy_from_iter(struct sock *sk, struct iov_iter *from,
 }
 EXPORT_SYMBOL_GPL(sk_msg_memcopy_from_iter);
 
-/* Receive sk_msg from psock->ingress_msg to @msg. */
-int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
-		   int len, int flags)
+int __sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
+		     int len, int flags, int *copied_from_self)
 {
 	struct iov_iter *iter = &msg->msg_iter;
 	int peek = flags & MSG_PEEK;
 	struct sk_msg *msg_rx;
 	int i, copied = 0;
+	bool from_self;
 
 	msg_rx = sk_psock_peek_msg(psock);
+	if (copied_from_self)
+		*copied_from_self = 0;
+
 	while (copied != len) {
 		struct scatterlist *sge;
 
 		if (unlikely(!msg_rx))
 			break;
 
+		from_self = msg_rx->sk == sk;
 		i = msg_rx->sg.start;
 		do {
 			struct page *page;
@@ -443,6 +447,9 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 			}
 
 			copied += copy;
+			if (from_self && copied_from_self)
+				*copied_from_self += copy;
+
 			if (likely(!peek)) {
 				sge->offset += copy;
 				sge->length -= copy;
@@ -487,6 +494,13 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 out:
 	return copied;
 }
+
+/* Receive sk_msg from psock->ingress_msg to @msg. */
+int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
+		   int len, int flags)
+{
+	return __sk_msg_recvmsg(sk, psock, msg, len, flags, NULL);
+}
 EXPORT_SYMBOL_GPL(sk_msg_recvmsg);
 
 bool sk_msg_is_readable(struct sock *sk)
@@ -616,6 +630,12 @@ static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb
 	if (unlikely(!msg))
 		return -EAGAIN;
 	skb_set_owner_r(skb, sk);
+
+	/* This is used in tcp_bpf_recvmsg_parser() to determine whether the
+	 * data originates from the socket's own protocol stack. No need to
+	 * refcount sk because msg's lifetime is bound to sk via the ingress_msg.
+	 */
+	msg->sk = sk;
 	err = sk_psock_skb_ingress_enqueue(skb, off, len, psock, sk, msg, take_ref);
 	if (err < 0)
 		kfree(msg);
@@ -909,6 +929,7 @@ int sk_psock_msg_verdict(struct sock *sk, struct sk_psock *psock,
 	sk_msg_compute_data_pointers(msg);
 	msg->sk = sk;
 	ret = bpf_prog_run_pin_on_cpu(prog, msg);
+	msg->sk = NULL;
 	ret = sk_psock_map_verd(ret, msg->sk_redir);
 	psock->apply_bytes = msg->apply_bytes;
 	if (ret == __SK_REDIRECT) {
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index a268e1595b22a..5c698fd7fbf81 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -226,6 +226,7 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 	int peek = flags & MSG_PEEK;
 	struct sk_psock *psock;
 	struct tcp_sock *tcp;
+	int copied_from_self = 0;
 	int copied = 0;
 	u32 seq;
 
@@ -262,7 +263,7 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 	}
 
 msg_bytes_ready:
-	copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
+	copied = __sk_msg_recvmsg(sk, psock, msg, len, flags, &copied_from_self);
 	/* The typical case for EFAULT is the socket was gracefully
 	 * shutdown with a FIN pkt. So check here the other case is
 	 * some error on copy_page_to_iter which would be unexpected.
@@ -277,7 +278,7 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 			goto out;
 		}
 	}
-	seq += copied;
+	seq += copied_from_self;
 	if (!copied) {
 		long timeo;
 		int data;
-- 
2.51.0



