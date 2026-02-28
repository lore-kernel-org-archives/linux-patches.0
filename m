Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C333446C0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301663; cv=none; b=S0q2AH90sFOjX15dm1pHfqLc+1awAEdiJtZnixQJo2K/6IaV1I9TPIek4M8N1or7S7D1Ivx3XRjd82WpCQZ2Ga1llI/ppcAemWJ+ApIG6ewpBmBLHZfqeuTqKl5mJpBcRNFEoh6xhsKITO0b00r5NzmoAmuB4FQdWWPzhlR/aqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301663; c=relaxed/simple;
	bh=bj7b6GLVScgwN8GW1A4RZg/ktbXFfw77NIq4lrI/ex0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ke6GsgsACYtrtWqAUWUMbhToS2BUQlxJLMvXH412f2EfLtose9PHaOh6iKENdWZGnHcMPv4o0ztXAGPmW0qMJPkALkj4S8AgGxg7Ed8m9rpSnKfljhGPeF8A8w2l0IstxJ/DNP7r7L44IQa3wk2PoJICniKo6KgD4w/6RIGn/b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mspXWk4b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mspXWk4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015A9C116D0;
	Sat, 28 Feb 2026 18:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301663;
	bh=bj7b6GLVScgwN8GW1A4RZg/ktbXFfw77NIq4lrI/ex0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mspXWk4bPpjKf0ubiGRVvePfSEKfFbPSYFPZ0QXXOcoLKgx6+S8aznLyrVL8e6FFz
	 RWrZH2ygPosZez1mr4d7SFT+OhBDyCm4Kg7inWjTVaPERL3xrCws7+LIjZuYN0BE7E
	 00s6R1Gal1y5aGJCwjTMJQWIQ7zkGXbzs4t4lB/OgJU8nUk1qVUsBV4OxaMYJ/+Hpa
	 EXuZ4uUPYX4J04Kodt4JzFTYk67Q+2lW4ySwtDJ6NseZua4cyRWQ9N93kcoLDQhueq
	 Fcv64IxjlWKrd3OzVbnA0H+Ue01jm7x/rgrmAH2CE4IG+7fBYCMwPsyvmLqxARgBj0
	 yVj5sJC/48VJA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/385] bpf, sockmap: Fix incorrect copied_seq calculation
Date: Sat, 28 Feb 2026 12:54:44 -0500
Message-ID: <20260228180011.1568201-62-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 0b9095a281b89..da1e6274c5586 100644
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
index adb3166ede972..4a274caf75fc6 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -408,22 +408,26 @@ int sk_msg_memcopy_from_iter(struct sock *sk, struct iov_iter *from,
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
@@ -442,6 +446,9 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 			}
 
 			copied += copy;
+			if (from_self && copied_from_self)
+				*copied_from_self += copy;
+
 			if (likely(!peek)) {
 				sge->offset += copy;
 				sge->length -= copy;
@@ -486,6 +493,13 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
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
@@ -615,6 +629,12 @@ static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb
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
@@ -908,6 +928,7 @@ int sk_psock_msg_verdict(struct sock *sk, struct sk_psock *psock,
 	sk_msg_compute_data_pointers(msg);
 	msg->sk = sk;
 	ret = bpf_prog_run_pin_on_cpu(prog, msg);
+	msg->sk = NULL;
 	ret = sk_psock_map_verd(ret, msg->sk_redir);
 	psock->apply_bytes = msg->apply_bytes;
 	if (ret == __SK_REDIRECT) {
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 8372ca512a755..8bd3d8b8dddab 100644
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

