Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC65339866;
	Thu, 28 May 2026 20:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999184; cv=none; b=O1l1lZniSHl2F8cZ1N0tD61/gj1Bhv6zTzyUhX7BzoK65z/m8cEE7kz17L8d5ThxA16DkKF6i2rSG193jrb6LFK2L+49AA8q2GQ3lsgW3Vh3mNIBj9bFJu8pFpeM8uGU4Sh94CJ0Ot3nMTWMI6TsnjNZPMwmDrGHhZEpLCreGrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999184; c=relaxed/simple;
	bh=VNuZ2B1PRlUK+RdMVHyMOGEaA/UN4rMudwYlhTybmB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMEm42tCUcqlIYt/mkPWhBFyVsO+avON7lakgiQixGj721d8ZNziXciZixT3AGlJnC1SeM2dEzLBXqBYJOCl+egVCcqH6CUt4L+iM4JdPGQaIz26iZjd/XqoZTA4i5yE/hl/C4/p2vB9iDDwOLN5hHtYRXzU7CTwjK55tCx1Eg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H6MGLjaG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H6MGLjaG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB7E1F000E9;
	Thu, 28 May 2026 20:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999183;
	bh=0dBZBG2+tnq8NvbiDofXsTxZn9nFKNhg5tLkJZoOHAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H6MGLjaGDJ0Ghm7tPv1UK2PIR0oI/Yd9o+8WwBxWTDvfwjBuZbqEootf0EmYyymAP
	 Gr11TgFGDcLTJE/p58Ghpf2cAXJeqffCPj4XMEqmQUAV9cCrLnvJrKCkaMrTnvTvyu
	 8ScGxa8+NV6moM0Yj6jNo3F+brluV0Fv/WRksMu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 431/461] tcp: fix stale per-CPU tcp_tw_isn leak enabling ISN prediction
Date: Thu, 28 May 2026 21:49:20 +0200
Message-ID: <20260528194659.998816497@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index ebc72dce4134d..e29d73118d82e 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -65,8 +65,6 @@ static inline void tcp_orphan_count_dec(void)
 	this_cpu_dec(tcp_orphan_count);
 }
 
-DECLARE_PER_CPU(u32, tcp_tw_isn);
-
 void tcp_time_wait(struct sock *sk, int state, int timeo);
 
 #define MAX_TCP_HEADER	L1_CACHE_ALIGN(128 + MAX_HEADER)
@@ -1060,10 +1058,13 @@ struct tcp_skb_cb {
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
index cee51749df16c..f27f50111172c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -299,9 +299,6 @@ enum {
 DEFINE_PER_CPU(unsigned int, tcp_orphan_count);
 EXPORT_PER_CPU_SYMBOL_GPL(tcp_orphan_count);
 
-DEFINE_PER_CPU(u32, tcp_tw_isn);
-EXPORT_PER_CPU_SYMBOL_GPL(tcp_tw_isn);
-
 long sysctl_tcp_mem[3] __read_mostly;
 EXPORT_IPV6_MOD(sysctl_tcp_mem);
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index cb4bcc5a85787..a8b626ac1ade1 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -7648,6 +7648,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 		     struct sock *sk, struct sk_buff *skb)
 {
 	struct tcp_fastopen_cookie foc = { .len = -1 };
+	u32 isn = TCP_SKB_CB(skb)->tcp_tw_isn;
 	struct tcp_options_received tmp_opt;
 	const struct tcp_sock *tp = tcp_sk(sk);
 	struct net *net = sock_net(sk);
@@ -7658,20 +7659,16 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
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
index c7b2463c2e254..0bda739f3d68e 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2274,6 +2274,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		}
 	}
 
+	isn = 0;
 process:
 	if (static_branch_unlikely(&ip4_min_ttl)) {
 		/* min_ttl can be changed concurrently from do_ip_setsockopt() */
@@ -2302,6 +2303,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	th = (const struct tcphdr *)skb->data;
 	iph = ip_hdr(skb);
 	tcp_v4_fill_cb(skb, iph, th);
+	TCP_SKB_CB(skb)->tcp_tw_isn = isn;
 
 	skb->dev = NULL;
 
@@ -2387,7 +2389,6 @@ int tcp_v4_rcv(struct sk_buff *skb)
 			sk = sk2;
 			tcp_v4_restore_cb(skb);
 			refcounted = false;
-			__this_cpu_write(tcp_tw_isn, isn);
 			goto process;
 		}
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index bb09d5ccf5990..a41ea2a866ee3 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1818,6 +1818,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		}
 	}
 
+	isn = 0;
 process:
 	if (static_branch_unlikely(&ip6_min_hopcount)) {
 		/* min_hopcount can be changed concurrently from do_ipv6_setsockopt() */
@@ -1846,6 +1847,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	th = (const struct tcphdr *)skb->data;
 	hdr = ipv6_hdr(skb);
 	tcp_v6_fill_cb(skb, hdr, th);
+	TCP_SKB_CB(skb)->tcp_tw_isn = isn;
 
 	skb->dev = NULL;
 
@@ -1933,7 +1935,6 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 			sk = sk2;
 			tcp_v6_restore_cb(skb);
 			refcounted = false;
-			__this_cpu_write(tcp_tw_isn, isn);
 			goto process;
 		}
 
-- 
2.53.0



