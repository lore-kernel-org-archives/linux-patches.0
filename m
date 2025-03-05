Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF7F6ADD;
	Wed,  5 Mar 2025 17:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197198; cv=none; b=sHMCPtsS1hYlzOyerTx1rU8QqCv4IdR3wCy9gNbHn59ouGaQiqHpEI3/BgYftvcIXVXBOJQQYfjIqqhw1ctE+e6JGgi6J73xqvDfK7zNC/54uNEyZ3qxGRk7M8JnsWIP4a4hZ816TBEpJosFIqNk0cf1wNzZo7Vh3no1i6AZE8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197198; c=relaxed/simple;
	bh=M4JQwqEXMLSF2icrTsgVI4OSm4ewh+bimGxT793AzmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oLQYpwwzyrV33Ga+hoChg5USeoumROhNnK8OUGzbT0gGEL6qMvgXYZBkNnluxT6/XfpR9mbBCYsQviIi4Luwa94rruQSqpyLkfNwbUDR7LexnraG/3BnhhCxSNY0hBIJ1LhU4mS7UDovJuvq/qphbTj8eU/lWB7BY0bmeKrrHt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EzfYcH0O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EzfYcH0O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF57C4CEE0;
	Wed,  5 Mar 2025 17:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197198;
	bh=M4JQwqEXMLSF2icrTsgVI4OSm4ewh+bimGxT793AzmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EzfYcH0O5emE3lLba8wZlsxMZ/64fXdAWsON4mVqgc3KfCjfAidjN7egqbOvYA3vR
	 AMDM8zf1e9lOIN/ZKiFe59whjKpG4+1s297giyKZDOXkDqFwsFKibYNIoacPE7onWq
	 icEIuOZ6eMNfUE6MGNHLiajmuR+TRUmVM1f+xJw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Jiayuan Chen <mrpre@163.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 066/176] bpf: Fix wrong copied_seq calculation
Date: Wed,  5 Mar 2025 18:47:15 +0100
Message-ID: <20250305174508.106225868@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <mrpre@163.com>

[ Upstream commit 36b62df5683c315ba58c950f1a9c771c796c30ec ]

'sk->copied_seq' was updated in the tcp_eat_skb() function when the action
of a BPF program was SK_REDIRECT. For other actions, like SK_PASS, the
update logic for 'sk->copied_seq' was moved to tcp_bpf_recvmsg_parser()
to ensure the accuracy of the 'fionread' feature.

It works for a single stream_verdict scenario, as it also modified
sk_data_ready->sk_psock_verdict_data_ready->tcp_read_skb
to remove updating 'sk->copied_seq'.

However, for programs where both stream_parser and stream_verdict are
active (strparser purpose), tcp_read_sock() was used instead of
tcp_read_skb() (sk_data_ready->strp_data_ready->tcp_read_sock).
tcp_read_sock() now still updates 'sk->copied_seq', leading to duplicate
updates.

In summary, for strparser + SK_PASS, copied_seq is redundantly calculated
in both tcp_read_sock() and tcp_bpf_recvmsg_parser().

The issue causes incorrect copied_seq calculations, which prevent
correct data reads from the recv() interface in user-land.

We do not want to add new proto_ops to implement a new version of
tcp_read_sock, as this would introduce code complexity [1].

We could have added noack and copied_seq to desc, and then called
ops->read_sock. However, unfortunately, other modules didn’t fully
initialize desc to zero. So, for now, we are directly calling
tcp_read_sock_noack() in tcp_bpf.c.

[1]: https://lore.kernel.org/bpf/20241218053408.437295-1-mrpre@163.com

Fixes: e5c6de5fa025 ("bpf, sockmap: Incorrectly handling copied_seq")
Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Jiayuan Chen <mrpre@163.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://patch.msgid.link/20250122100917.49845-3-mrpre@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skmsg.h |  2 ++
 include/net/tcp.h     |  8 ++++++++
 net/core/skmsg.c      |  7 +++++++
 net/ipv4/tcp.c        | 29 ++++++++++++++++++++++++-----
 net/ipv4/tcp_bpf.c    | 36 ++++++++++++++++++++++++++++++++++++
 5 files changed, 77 insertions(+), 5 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 6ccfd9236387c..32bbebf5b71e3 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -87,6 +87,8 @@ struct sk_psock {
 	struct sk_psock_progs		progs;
 #if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
 	struct strparser		strp;
+	u32				copied_seq;
+	u32				ingress_bytes;
 #endif
 	struct sk_buff_head		ingress_skb;
 	struct list_head		ingress_msg;
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 14a00cdd31f42..83e0362e3b721 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -700,6 +700,9 @@ void tcp_get_info(struct sock *, struct tcp_info *);
 /* Read 'sendfile()'-style from a TCP socket */
 int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 		  sk_read_actor_t recv_actor);
+int tcp_read_sock_noack(struct sock *sk, read_descriptor_t *desc,
+			sk_read_actor_t recv_actor, bool noack,
+			u32 *copied_seq);
 int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor);
 struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off);
 void tcp_read_done(struct sock *sk, size_t len);
@@ -2351,6 +2354,11 @@ struct sk_psock;
 struct proto *tcp_bpf_get_proto(struct sock *sk, struct sk_psock *psock);
 int tcp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore);
 void tcp_bpf_clone(const struct sock *sk, struct sock *newsk);
+#ifdef CONFIG_BPF_STREAM_PARSER
+struct strparser;
+int tcp_bpf_strp_read_sock(struct strparser *strp, read_descriptor_t *desc,
+			   sk_read_actor_t recv_actor);
+#endif /* CONFIG_BPF_STREAM_PARSER */
 #endif /* CONFIG_BPF_SYSCALL */
 
 #ifdef CONFIG_INET
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 65764952bc681..5a790cd1121b1 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -547,6 +547,9 @@ static int sk_psock_skb_ingress_enqueue(struct sk_buff *skb,
 			return num_sge;
 	}
 
+#if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
+	psock->ingress_bytes += len;
+#endif
 	copied = len;
 	msg->sg.start = 0;
 	msg->sg.size = copied;
@@ -1140,6 +1143,10 @@ int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock)
 	if (!ret)
 		sk_psock_set_state(psock, SK_PSOCK_RX_STRP_ENABLED);
 
+	if (sk_is_tcp(sk)) {
+		psock->strp.cb.read_sock = tcp_bpf_strp_read_sock;
+		psock->copied_seq = tcp_sk(sk)->copied_seq;
+	}
 	return ret;
 }
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e27a9a9bb1623..7d591a0cf0c70 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1699,12 +1699,13 @@ EXPORT_SYMBOL(tcp_recv_skb);
  *	  or for 'peeking' the socket using this routine
  *	  (although both would be easy to implement).
  */
-int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
-		  sk_read_actor_t recv_actor)
+static int __tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
+			   sk_read_actor_t recv_actor, bool noack,
+			   u32 *copied_seq)
 {
 	struct sk_buff *skb;
 	struct tcp_sock *tp = tcp_sk(sk);
-	u32 seq = tp->copied_seq;
+	u32 seq = *copied_seq;
 	u32 offset;
 	int copied = 0;
 
@@ -1758,9 +1759,12 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 		tcp_eat_recv_skb(sk, skb);
 		if (!desc->count)
 			break;
-		WRITE_ONCE(tp->copied_seq, seq);
+		WRITE_ONCE(*copied_seq, seq);
 	}
-	WRITE_ONCE(tp->copied_seq, seq);
+	WRITE_ONCE(*copied_seq, seq);
+
+	if (noack)
+		goto out;
 
 	tcp_rcv_space_adjust(sk);
 
@@ -1769,10 +1773,25 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 		tcp_recv_skb(sk, seq, &offset);
 		tcp_cleanup_rbuf(sk, copied);
 	}
+out:
 	return copied;
 }
+
+int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
+		  sk_read_actor_t recv_actor)
+{
+	return __tcp_read_sock(sk, desc, recv_actor, false,
+			       &tcp_sk(sk)->copied_seq);
+}
 EXPORT_SYMBOL(tcp_read_sock);
 
+int tcp_read_sock_noack(struct sock *sk, read_descriptor_t *desc,
+			sk_read_actor_t recv_actor, bool noack,
+			u32 *copied_seq)
+{
+	return __tcp_read_sock(sk, desc, recv_actor, noack, copied_seq);
+}
+
 int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 {
 	struct sk_buff *skb;
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index a8db010e9e611..bf10fa3c37b76 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -691,6 +691,42 @@ static int tcp_bpf_assert_proto_ops(struct proto *ops)
 	       ops->sendpage == tcp_sendpage ? 0 : -ENOTSUPP;
 }
 
+#if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
+int tcp_bpf_strp_read_sock(struct strparser *strp, read_descriptor_t *desc,
+			   sk_read_actor_t recv_actor)
+{
+	struct sock *sk = strp->sk;
+	struct sk_psock *psock;
+	struct tcp_sock *tp;
+	int copied = 0;
+
+	tp = tcp_sk(sk);
+	rcu_read_lock();
+	psock = sk_psock(sk);
+	if (WARN_ON_ONCE(!psock)) {
+		desc->error = -EINVAL;
+		goto out;
+	}
+
+	psock->ingress_bytes = 0;
+	copied = tcp_read_sock_noack(sk, desc, recv_actor, true,
+				     &psock->copied_seq);
+	if (copied < 0)
+		goto out;
+	/* recv_actor may redirect skb to another socket (SK_REDIRECT) or
+	 * just put skb into ingress queue of current socket (SK_PASS).
+	 * For SK_REDIRECT, we need to ack the frame immediately but for
+	 * SK_PASS, we want to delay the ack until tcp_bpf_recvmsg_parser().
+	 */
+	tp->copied_seq = psock->copied_seq - psock->ingress_bytes;
+	tcp_rcv_space_adjust(sk);
+	__tcp_cleanup_rbuf(sk, copied - psock->ingress_bytes);
+out:
+	rcu_read_unlock();
+	return copied;
+}
+#endif /* CONFIG_BPF_STREAM_PARSER */
+
 int tcp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
 {
 	int family = sk->sk_family == AF_INET6 ? TCP_BPF_IPV6 : TCP_BPF_IPV4;
-- 
2.39.5



