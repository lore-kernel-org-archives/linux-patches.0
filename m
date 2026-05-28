Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54074223328;
	Thu, 28 May 2026 20:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000261; cv=none; b=pZToTA6tnHTXUFxoeug8iGaBeyTqFlgqukMJVTTFHWflH/VGjV7i5VPo+DSJBaUnYeGgynQJ3925NQfT2kVLHjjiJIq8s1xOOOsJfwTACEFnjQSEXhJUuMJZjjTdcLB2y8dZWoP8OJ+HtTuiBYOhn2OYddOKZnVuu6/WBH8g+X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000261; c=relaxed/simple;
	bh=2IftqMaVtYCePBvYW0RB2s0yy2I9RCQaR8uaOHGcZI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5Jm3lHbt4mRHKunxtij/RnmMookkOTbZuwiRIvaiq0vh3tMl1nbvhIYSM/QUYI6xnjZznOK5tiUuX2oOTWF5RrsLC+TTxHNbxazMcBmWEgJdNxpJaXrxR/sHSvWPx/RqBH/rMGA9/k1nA+5Mry+moqUlxYQY5kgzTB2HLL5hUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rdV5EFOx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rdV5EFOx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5B11F000E9;
	Thu, 28 May 2026 20:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000260;
	bh=0Q6qcQ6zABfUkxglVqDPfzrPoDA5h/+6/XzROa6assQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rdV5EFOxjItRY5EKPts92ZADbxZJVXKcA7400SkWo3WfOOkYhVv08492oaG5uI5wP
	 eJZ+2yBxxvDUuIgPsJmxn6WZto2SMIcurA6LSKJSZMtqKy5dlEQw1OwyKvK0IbZCMZ
	 c2Mqutpxer/QWi/HFcc8WH3rYCXVXvsRwvF9QEV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 360/377] tcp: fix stale per-CPU tcp_tw_isn leak enabling ISN prediction
Date: Thu, 28 May 2026 21:49:58 +0200
Message-ID: <20260528194648.855155086@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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
index cf507b989bff1..f460d2c391deb 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -65,8 +65,6 @@ static inline void tcp_orphan_count_dec(void)
 	this_cpu_dec(tcp_orphan_count);
 }
 
-DECLARE_PER_CPU(u32, tcp_tw_isn);
-
 void tcp_time_wait(struct sock *sk, int state, int timeo);
 
 #define MAX_TCP_HEADER	L1_CACHE_ALIGN(128 + MAX_HEADER)
@@ -1028,10 +1026,13 @@ struct tcp_skb_cb {
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
index 2de4748269ca9..6fc00b38695ba 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -300,9 +300,6 @@ enum {
 DEFINE_PER_CPU(unsigned int, tcp_orphan_count);
 EXPORT_PER_CPU_SYMBOL_GPL(tcp_orphan_count);
 
-DEFINE_PER_CPU(u32, tcp_tw_isn);
-EXPORT_PER_CPU_SYMBOL_GPL(tcp_tw_isn);
-
 long sysctl_tcp_mem[3] __read_mostly;
 EXPORT_IPV6_MOD(sysctl_tcp_mem);
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index b5cf32a56c04a..c650398e91998 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -7387,6 +7387,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 		     struct sock *sk, struct sk_buff *skb)
 {
 	struct tcp_fastopen_cookie foc = { .len = -1 };
+	u32 isn = TCP_SKB_CB(skb)->tcp_tw_isn;
 	struct tcp_options_received tmp_opt;
 	const struct tcp_sock *tp = tcp_sk(sk);
 	struct net *net = sock_net(sk);
@@ -7397,20 +7398,16 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
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
index 702fdff58f7a3..36206fc6aed2d 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2333,6 +2333,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		}
 	}
 
+	isn = 0;
 process:
 	if (static_branch_unlikely(&ip4_min_ttl)) {
 		/* min_ttl can be changed concurrently from do_ip_setsockopt() */
@@ -2361,6 +2362,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	th = (const struct tcphdr *)skb->data;
 	iph = ip_hdr(skb);
 	tcp_v4_fill_cb(skb, iph, th);
+	TCP_SKB_CB(skb)->tcp_tw_isn = isn;
 
 	skb->dev = NULL;
 
@@ -2446,7 +2448,6 @@ int tcp_v4_rcv(struct sk_buff *skb)
 			sk = sk2;
 			tcp_v4_restore_cb(skb);
 			refcounted = false;
-			__this_cpu_write(tcp_tw_isn, isn);
 			goto process;
 		}
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 7f20db11e8ce9..59b5900dd42bd 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1863,6 +1863,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		}
 	}
 
+	isn = 0;
 process:
 	if (static_branch_unlikely(&ip6_min_hopcount)) {
 		/* min_hopcount can be changed concurrently from do_ipv6_setsockopt() */
@@ -1891,6 +1892,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	th = (const struct tcphdr *)skb->data;
 	hdr = ipv6_hdr(skb);
 	tcp_v6_fill_cb(skb, hdr, th);
+	TCP_SKB_CB(skb)->tcp_tw_isn = isn;
 
 	skb->dev = NULL;
 
@@ -1978,7 +1980,6 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 			sk = sk2;
 			tcp_v6_restore_cb(skb);
 			refcounted = false;
-			__this_cpu_write(tcp_tw_isn, isn);
 			goto process;
 		}
 
-- 
2.53.0



