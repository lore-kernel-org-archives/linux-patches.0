Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6198B4CF477;
	Sat, 17 Oct 2026 16:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254148; cv=none; b=jX2a9gWhap0xdDPvIO7bzv+gjgt9FB3CbWGpePkipmBoCDKQahGNd5z74vZJsJZkI33aJxh4Z30iT9psSAhtwk/dvifzJbkzfc+U0ASKKcHhrttCMni2vc1Gp3Ipwo8GbBgmam9kTW6yz7j8w1iEJEhLQPlaQoxd5+DeEBWedJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254148; c=relaxed/simple;
	bh=DOvP2VJStZIY5znzpr6Epq7aDLRQhWzdx2qqTDqVtdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DECeNBTtrB9ojivMgMHDYWbabIha6k9DqDBoQRY1p140dYSwVTQRjNM6RJV0HEKWF7RXt0In4pra3ANyxrx7TrXhWduq8CIfmEgg6rK0pcMO1CKocm+BDgC/okizM13KySMlMW52afza/PxLgG/YlrkjOa+aivbxr7PKgvG95T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HedVF7rt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HedVF7rt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88CFA1F000C4;
	Sat, 17 Oct 2026 16:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254147;
	bh=KbGXpZj2YQVaQgA5evEscxO3XfoJNOJlfLX/IckBWH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HedVF7rt8IKwmhkX2j7Q89HorP7FlDkOUZ8Yj5zgP2lr7x5P1Q+in+OOpAQWnoIVi
	 lCz6J8aaW8qkFuQrmKT6hGnZx3V9y8Lxoo7+khvBPSoL8vH7NxvCbbXVD020V5Re4E
	 J7lSaP0xBEEqsSKr4GuhbJTZIe3rPhqEGwgJp3vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 352/869] tcp: fix stale per-CPU tcp_tw_isn leak enabling ISN prediction
Date: Sat, 17 Oct 2026 17:53:13 +0200
Message-ID: <20261017160046.127738840@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 1bbf0ced1d9db73ac7893c2187f3459288603e0d ]

Blamed commit moved the TIME_WAIT-derived ISN from the skb control
block to a per-CPU variable, assuming the value would always be consumed
by tcp_conn_request() for the same packet that wrote it. That assumption
is violated by multiple drop paths between the producer
(__this_cpu_write(tcp_tw_isn, isn) in tcp_v{4,6}_rcv()) and the consumer
(tcp_conn_request()):

 - min_ttl / min_hopcount check
 - xfrm policy check
 - tcp_inbound_hash() MD5/AO mismatch
 - tcp_filter() eBPF/SO_ATTACH_FILTER drop
 - th->syn && th->fin discard in tcp_rcv_state_process() TCP_LISTEN
 - psp_sk_rx_policy_check() in tcp_v{4,6}_do_rcv()
 - tcp_checksum_complete() in tcp_v{4,6}_do_rcv()
 - tcp_v{4,6}_cookie_check() returning NULL

When a packet is dropped on any of these paths, tcp_tw_isn is left set.

The next SYN processed on the same CPU then consumes the non zero value in
tcp_conn_request(), receiving a potentially predictable ISN.

This patch moves back tcp_tw_isn to skb->cb[], getting rid of the per-cpu
variable.

Note that tcp_v{4,6}_fill_cb() do not set it.

Very litle impact on overall code size/complexity:

$ scripts/bloat-o-meter -t vmlinux.old vmlinux.new
add/remove: 0/0 grow/shrink: 2/1 up/down: 8/-15 (-7)
Function                                     old     new   delta
tcp_v6_rcv                                  3038    3042      +4
tcp_v4_rcv                                  3035    3039      +4
tcp_conn_request                            2938    2923     -15
Total: Before=24436060, After=24436053, chg -0.00%

Fixes: 41eecbd712b7 ("tcp: replace TCP_SKB_CB(skb)->tcp_tw_isn with a per-cpu field")
Reported-by: Chris Mason <clm@meta.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260519084611.2485277-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h    |  7 ++++---
 net/ipv4/tcp.c       |  3 ---
 net/ipv4/tcp_input.c | 15 ++++++---------
 net/ipv4/tcp_ipv4.c  |  3 ++-
 net/ipv6/tcp_ipv6.c  |  3 ++-
 5 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 115f878540768..77f6c40ead438 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -64,8 +64,6 @@ static inline void tcp_orphan_count_dec(void)
 	this_cpu_dec(tcp_orphan_count);
 }
 
-DECLARE_PER_CPU(u32, tcp_tw_isn);
-
 void tcp_time_wait(struct sock *sk, int state, int timeo);
 
 #define MAX_TCP_HEADER	L1_CACHE_ALIGN(128 + MAX_HEADER)
@@ -947,10 +945,13 @@ struct tcp_skb_cb {
 	__u32		seq;		/* Starting sequence number	*/
 	__u32		end_seq;	/* SEQ + FIN + SYN + datalen	*/
 	union {
-		/* Note :
+		/* Notes :
+		 *	tcp_tw_isn is used in input path only
+		 *	(isn chosen by tcp_timewait_state_process())
 		 * 	  tcp_gso_segs/size are used in write queue only,
 		 *	  cf tcp_skb_pcount()/tcp_skb_mss()
 		 */
+		u32		tcp_tw_isn;
 		struct {
 			u16	tcp_gso_segs;
 			u16	tcp_gso_size;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 2ab07164eba19..7df7ce86b6904 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -297,9 +297,6 @@ enum {
 DEFINE_PER_CPU(unsigned int, tcp_orphan_count);
 EXPORT_PER_CPU_SYMBOL_GPL(tcp_orphan_count);
 
-DEFINE_PER_CPU(u32, tcp_tw_isn);
-EXPORT_PER_CPU_SYMBOL_GPL(tcp_tw_isn);
-
 long sysctl_tcp_mem[3] __read_mostly;
 EXPORT_IPV6_MOD(sysctl_tcp_mem);
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 5c581d4821c1d..96eb6d2421413 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -7242,6 +7242,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 		     struct sock *sk, struct sk_buff *skb)
 {
 	struct tcp_fastopen_cookie foc = { .len = -1 };
+	u32 isn = TCP_SKB_CB(skb)->tcp_tw_isn;
 	struct tcp_options_received tmp_opt;
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct net *net = sock_net(sk);
@@ -7252,20 +7253,16 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 	struct dst_entry *dst;
 	struct flowi fl;
 	u8 syncookies;
-	u32 isn;
 
 #ifdef CONFIG_TCP_AO
 	const struct tcp_ao_hdr *aoh;
 #endif
 
-	isn = __this_cpu_read(tcp_tw_isn);
-	if (isn) {
-		/* TW buckets are converted to open requests without
-		 * limitations, they conserve resources and peer is
-		 * evidently real one.
-		 */
-		__this_cpu_write(tcp_tw_isn, 0);
-	} else {
+	/* If isn is non-zero, this SYN originally matched a TIME_WAIT socket.
+	 * TW sockets are converted to open requests without limitations,
+	 * we skip the queue limits and syncookie checks in the block below.
+	 */
+	if (!isn) {
 		syncookies = READ_ONCE(net->ipv4.sysctl_tcp_syncookies);
 
 		if (syncookies == 2 || inet_csk_reqsk_queue_is_full(sk)) {
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 48af4b0d77f26..c32ec598930b1 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2311,6 +2311,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		}
 	}
 
+	isn = 0;
 process:
 	if (static_branch_unlikely(&ip4_min_ttl)) {
 		/* min_ttl can be changed concurrently from do_ip_setsockopt() */
@@ -2340,6 +2341,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	th = (const struct tcphdr *)skb->data;
 	iph = ip_hdr(skb);
 	tcp_v4_fill_cb(skb, iph, th);
+	TCP_SKB_CB(skb)->tcp_tw_isn = isn;
 
 	skb->dev = NULL;
 
@@ -2424,7 +2426,6 @@ int tcp_v4_rcv(struct sk_buff *skb)
 			sk = sk2;
 			tcp_v4_restore_cb(skb);
 			refcounted = false;
-			__this_cpu_write(tcp_tw_isn, isn);
 			goto process;
 		}
 	}
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 69e37c3d4b1c8..ae2a91e3f15c9 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1853,6 +1853,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		}
 	}
 
+	isn = 0;
 process:
 	if (static_branch_unlikely(&ip6_min_hopcount)) {
 		/* min_hopcount can be changed concurrently from do_ipv6_setsockopt() */
@@ -1882,6 +1883,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	th = (const struct tcphdr *)skb->data;
 	hdr = ipv6_hdr(skb);
 	tcp_v6_fill_cb(skb, hdr, th);
+	TCP_SKB_CB(skb)->tcp_tw_isn = isn;
 
 	skb->dev = NULL;
 
@@ -1968,7 +1970,6 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 			sk = sk2;
 			tcp_v6_restore_cb(skb);
 			refcounted = false;
-			__this_cpu_write(tcp_tw_isn, isn);
 			goto process;
 		}
 	}
-- 
2.53.0



