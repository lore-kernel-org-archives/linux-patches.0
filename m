Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621929;
	b=t+XA4FOICQ/VW3LEYtNsn1vVTViy0C905hAMXKrKsLEJvhIBvkvKueItPnl93INuiyBj
	 TR2TunEbTC2bfSQry9Se34ZYDMWn2HcjGVPJKWA4FjywoMJdQ5eAANpRL7ZSvQSncHDV9
	 QS9wn51XO43rr6iA55F4TH1CNyhOg9LHg/L24fz5D8zD5KmsiKzWd1Cr2v5tecJT0UWFt
	 kiwecSolx+/LmlEucVX0lhQp9/3CfsZGNjm2cSeV72ZugfRzkxnaQlLFU5sWzH+GHaYLN
	 B+vCuw44OoYjHCTb2Ra9KNTqtirCs0mkpA3/TJVgEmhzfvHlyXK01UdSqmnWpEC5rtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621929;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YksZQOxMhyJWaJIkTKw6I6iqK3a3saZE4Z6GFbhE0Go=;
	b=GdOTsL4+VRS/QGF6/LWDdpsUha3bbWy9g/uJKEXswjw4Y7vrxveDeiQ2kAUFjNOsNzpA
	 ZV0tXytInK+RCQyawi9ySVr+1iVo8zRfNfIp6Gwx9LJacKLUMQC1FYiaqcfzr1mZrGEJq
	 4E28lfNJYbYBSGsV9SqELfztklu3iGnlWtsbxDXA31w0ZA1FjwgpL9bcQvkAi/RswyUuI
	 mDxojB4fSLN9kHsHjlLA1gIBSw1ZtqIjEt9PkVMdtvOCLAyuZi0Fn4iqhhCvY3gvFIeHY
	 ppuUIkw7PX/O/4XVat613sJReoJH9N/kFdWgFFPu2tNWqZ+DHs3rP4dPXy0tOcswaKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rfx5X3jt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9D3606A31E;
	Wed, 25 Nov 2026 15:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rfx5X3jt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 299D01F000C0;
	Wed, 25 Nov 2026 15:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621928;
	bh=YksZQOxMhyJWaJIkTKw6I6iqK3a3saZE4Z6GFbhE0Go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rfx5X3jtk7Pi+T4C6VKfU6+z3xJnysVAieDoTyBJb/5mo5dT0JVqK3sWvkaZDyGgp
	 BV+zd0n/Fu69R9qyzwRJkOQKJFwT9kuu1iaYdDlc3jQRgprYegoiyFnePAQ62hoPfs
	 +vccUIAGq9/N/+36iCUH5AIBBeZqilegp47OKlc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Eric Dumazet <edumazet@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 377/990] tcp: rate limit receive queue collapsing
Date: Wed, 25 Nov 2026 15:29:04 +0100
Message-ID: <20261125143830.925409567@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit c2213d9b61c1d6e99645a636630ee767c7542f78 ]

When a socket is over its receive buffer limit and its sk_rcvbuf can
not grow, every incoming segment that needs memory goes through
tcp_prune_queue(), which runs tcp_collapse_ofo_queue() and tcp_collapse()
on the receive queue. Both walk their whole queue, even when there is
nothing left to collapse.

A peer can trigger this walk per packet, without refilling memory:

1) The segment lands last in the out-of-order queue. Since commit
   b0e01253a764 ("tcp: refine tcp_prune_ofo_queue() logic"),
   tcp_prune_ofo_queue() drops nothing, the segment is dropped and
   the queues are unchanged. The peer can send it again forever.

2) The segment lands second to last: one skb is pruned, and one small
   segment fills that space again.

3) The out-of-order queue is empty and the receive queue alone is over
   the limit (application not reading). Collapsing frees nothing,
   the out-of-order segment is dropped, and the window is not closed.

4) Collapsing frees just one skb, enough to queue the segment. The next
   segment is over the limit again.

Only allow a collapse if at least 1/8 of sk_rcvbuf of new memory was
queued in the receive queues since the previous collapse. This restores
the "12.5 % of the queue capacity" amortization of the 2018 SegmentSmack
fixes (CVE-2018-5390), using the same unit as the sk_rcvbuf limit, so
that peers sending small (bloated) segments are not penalized.

The credit is the net growth of sk_rmem_alloc in tcp_queue_rcv() and
tcp_data_queue_ofo(), so that:

- Coalescing a segment into the tailroom of the previous skb charges no
  memory, and earns no credit.
- An out-of-order segment replacing or covering queued skbs only earns
  the memory it adds.
- Duplicates earn nothing.
- Data moved from the out-of-order queue to the receive queue
  (tcp_ofo_queue()) is not credited twice.

In-order data is credited too, so that a receive queue filled by
bloated in-order segments can still be collapsed when a hole appears.

In-order segments are rate limited as well: a peer could otherwise send
small in-order segments that each trigger a collapse freeing a single
skb, enough to queue the segment, while the out-of-order queue holds
many skbs that can not be collapsed.

The credit is tracked in a new u32 tp->rcv_collapse_credit, placed in a
hole of the tcp_sock_write_rx group: no other field moves, and tcp_sock
size is unchanged. tcp_queue_rcv() now samples sk_rmem_alloc, and
writes the credit until it saturates at sk_rcvbuf, so that the fast path
stops writing it after a full buffer of new memory. Saturating at the
goal would not work: sk_rcvbuf, and the goal with it, can grow later
(for instance in tcp_clamp_window(), just before the goal is checked),
and a socket over its limit can not earn more credit until the
application reads.

When collapsing is not allowed, tcp_prune_queue() goes directly to
tcp_prune_ofo_queue(), which is cheap in the cases above.

A regular flow can see a difference when it goes over its limit before
1/8 of sk_rcvbuf of new memory was queued since the previous collapse:
out-of-order skbs can be pruned (even for an in-order segment filling a
hole), and an in-order segment that still does not fit is dropped,
with a zero window advertised, where a collapse might have made room.

Fixes: b0e01253a764 ("tcp: refine tcp_prune_ofo_queue() logic")
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Link: https://patch.msgid.link/20261105124043.1543405-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../networking/net_cachelines/tcp_sock.rst    |  1 +
 include/linux/tcp.h                           |  1 +
 net/ipv4/tcp.c                                |  2 +
 net/ipv4/tcp_input.c                          | 55 +++++++++++++++----
 4 files changed, 48 insertions(+), 11 deletions(-)

diff --git a/Documentation/networking/net_cachelines/tcp_sock.rst b/Documentation/networking/net_cachelines/tcp_sock.rst
index 430317cdb8f64..48fbc27044bf2 100644
--- a/Documentation/networking/net_cachelines/tcp_sock.rst
+++ b/Documentation/networking/net_cachelines/tcp_sock.rst
@@ -106,6 +106,7 @@ u32[3]                        received_ecn_bytes      read_mostly         read_w
 u8:4                          received_ce_pending     read_mostly         read_write
 u32[3]                        delivered_ecn_bytes                         read_write
 u16                           pkts_acked_ewma                             read_write
+u32                           rcv_collapse_credit                         read_write          tcp_queue_rcv,tcp_data_queue_ofo,tcp_prune_queue
 u8:2                          syn_ect_snt             write_mostly        read_write
 u8:2                          syn_ect_rcv             read_mostly         read_write
 u8:2                          accecn_minlen           write_mostly        read_write
diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index db348f06ec3e0..7cc2ddcd9bc0d 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -355,6 +355,7 @@ struct tcp_sock {
 	u32	rcv_rtt_last_tsecr;
 	u32	delivered_ecn_bytes[3];
 	u16	pkts_acked_ewma;/* Pkts acked EWMA for AccECN cep heuristic */
+	u32	rcv_collapse_credit; /* memory queued since last collapse */
 	struct {
 		u32	rtt_us;
 		u32	seq;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index fb571e0dd40c9..9e861f346e45c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3477,6 +3477,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	tp->rx_opt.dsack = 0;
 	tp->rx_opt.num_sacks = 0;
 	tp->rcv_ooopack = 0;
+	tp->rcv_collapse_credit = 0;
 
 
 	/* Clean up fastopen related fields */
@@ -5248,6 +5249,7 @@ static void __init tcp_struct_check(void)
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_rx, rcv_rtt_last_tsecr);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_rx, delivered_ecn_bytes);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_rx, pkts_acked_ewma);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_rx, rcv_collapse_credit);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_rx, rcv_rtt_est);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_rx, rcvq_space);
 }
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 13373917c5a99..7b5839236f77c 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5184,6 +5184,20 @@ static int tcp_try_rmem_schedule(struct sock *sk, const struct sk_buff *skb,
 	return 0;
 }
 
+/* Credit the memory added to the receive queues since @rmem was sampled
+ * toward the next allowed collapse. Saturate at sk_rcvbuf, not at the goal
+ * checked in tcp_prune_queue(): sk_rcvbuf (and the goal) can grow later,
+ * for instance in tcp_clamp_window().
+ */
+static void tcp_collapse_credit_add(struct sock *sk, int rmem)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	int delta = atomic_read(&sk->sk_rmem_alloc) - rmem;
+
+	if (delta > 0 && tp->rcv_collapse_credit < (u32)sk->sk_rcvbuf)
+		tp->rcv_collapse_credit += delta;
+}
+
 static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
@@ -5191,6 +5205,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 	struct sk_buff *skb1;
 	u32 seq, end_seq;
 	bool fragstolen;
+	int rmem;
 
 	tcp_save_lrcv_flowlabel(sk, skb);
 	tcp_data_ecn_check(sk, skb);
@@ -5201,6 +5216,8 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 		tcp_drop_reason(sk, skb, SKB_DROP_REASON_PROTO_MEM);
 		return;
 	}
+	/* Sampled after tcp_try_rmem_schedule(), which can prune. */
+	rmem = atomic_read(&sk->sk_rmem_alloc);
 
 	tcp_measure_rcv_mss(sk, skb);
 	/* Disable header prediction. */
@@ -5330,6 +5347,10 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 		skb_condense(skb);
 		skb_set_owner_r(skb, sk);
 	}
+	/* Net growth: coalescing can charge nothing, and covered skbs
+	 * were freed.
+	 */
+	tcp_collapse_credit_add(sk, rmem);
 	/* do not grow rcvbuf for not-yet-accepted or orphaned sockets. */
 	if (sk->sk_socket)
 		tcp_rcvbuf_grow(sk, tp->rcvq_space.space);
@@ -5338,8 +5359,9 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 static int __must_check tcp_queue_rcv(struct sock *sk, struct sk_buff *skb,
 				      bool *fragstolen)
 {
-	int eaten;
+	int rmem = atomic_read(&sk->sk_rmem_alloc);
 	struct sk_buff *tail = skb_peek_tail(&sk->sk_receive_queue);
+	int eaten;
 
 	eaten = (tail &&
 		 tcp_try_coalesce(sk, tail,
@@ -5349,6 +5371,7 @@ static int __must_check tcp_queue_rcv(struct sock *sk, struct sk_buff *skb,
 		tcp_add_receive_queue(sk, skb);
 		skb_set_owner_r(skb, sk);
 	}
+	tcp_collapse_credit_add(sk, rmem);
 	return eaten;
 }
 
@@ -5836,18 +5859,28 @@ static int tcp_prune_queue(struct sock *sk, const struct sk_buff *in_skb)
 	if (tcp_can_ingest(sk, in_skb))
 		return 0;
 
-	tcp_collapse_ofo_queue(sk);
-	if (!skb_queue_empty(&sk->sk_receive_queue))
-		tcp_collapse(sk, &sk->sk_receive_queue, NULL,
-			     skb_peek(&sk->sk_receive_queue),
-			     NULL,
-			     tp->copied_seq, tp->rcv_nxt);
+	/* Collapsing walks both queues and is expensive, and can free
+	 * almost nothing. Require at least 1/8 of sk_rcvbuf of new memory
+	 * in the receive queues since the previous collapse, otherwise
+	 * a stream of segments could trigger one collapse per packet.
+	 */
+	if (tp->rcv_collapse_credit >= (u32)sk->sk_rcvbuf >> 3) {
+		tp->rcv_collapse_credit = 0;
 
-	if (tcp_can_ingest(sk, in_skb))
-		return 0;
+		tcp_collapse_ofo_queue(sk);
+		if (!skb_queue_empty(&sk->sk_receive_queue))
+			tcp_collapse(sk, &sk->sk_receive_queue, NULL,
+				     skb_peek(&sk->sk_receive_queue),
+				     NULL,
+				     tp->copied_seq, tp->rcv_nxt);
 
-	/* Collapsing did not help, destructive actions follow.
-	 * This must not ever occur. */
+		if (tcp_can_ingest(sk, in_skb))
+			return 0;
+	}
+
+	/* Collapsing did not help (or was not allowed),
+	 * destructive actions follow.
+	 */
 
 	tcp_prune_ofo_queue(sk, in_skb);
 
-- 
2.53.0



