Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D561D5AD7;
	Wed,  6 Nov 2024 12:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895089; cv=none; b=kRh8nbiNJqjxlU8svq9l3N1Ui+GH8hjmNDsWeU9lilWCXRXkAMu2y+oPPBN4xYIjhoJjjglr4K5Aj3KXuWwfYuzL+UYI/7gboVYZ3ePGKM5H2K2Rc5A1rg4SquA3FFbA5j/elhAw+Jehlk/kBAm+r3ELJXe+FK3m10LRRWbStLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895089; c=relaxed/simple;
	bh=cT+RKRM8llO9R+mHOVAKEE9DW5nEtNue5MkfqlUGpbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=um5NkqhXpPZBpTa6ZeYLX9vpSTuGJ5SRbvnvqh8VUtIbVagKE4aeOk3LQmC9zZi9kEUkqVkPAeatpaZ5jkmgmX1XMLmTBEGzYltz9AWoRJZaYBEhqAuejMVSimMI4zQhU5XEHjvvZu90xINA8BKkqi0BWhHUSaS4QVm45pkVtCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rONFB3Ws; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rONFB3Ws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC93FC4CECD;
	Wed,  6 Nov 2024 12:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895089;
	bh=cT+RKRM8llO9R+mHOVAKEE9DW5nEtNue5MkfqlUGpbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rONFB3Wsxm6csrOyZSgady5nWnf6qu4tDIfyviYZgJTS6tnU8A9gARV7JzRCN2Tif
	 tApPUFtZrUtN69+3KLAPSLdGmBun4yx++1ARnLT7w7o2CEebgOsEOKzOxfpg47qWOM
	 nBfu/j5+5NJKcLOehPSUgVVH9mt9e+tgh+VGLC00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 102/350] tcp: introduce tcp_skb_timestamp_us() helper
Date: Wed,  6 Nov 2024 13:00:30 +0100
Message-ID: <20241106120323.423094065@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 2fd66ffba50716fc5ab481c48db643af3bda2276 ]

There are few places where TCP reads skb->skb_mstamp expecting
a value in usec unit.

skb->tstamp (aka skb->skb_mstamp) will soon store CLOCK_TAI nsec value.

Add tcp_skb_timestamp_us() to provide proper conversion when needed.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: c8770db2d544 ("tcp: check skb is non-NULL in tcp_rto_delta_us()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h       |  8 +++++++-
 net/ipv4/tcp_input.c    | 11 ++++++-----
 net/ipv4/tcp_ipv4.c     |  2 +-
 net/ipv4/tcp_output.c   |  2 +-
 net/ipv4/tcp_rate.c     | 15 ++++++++-------
 net/ipv4/tcp_recovery.c |  5 +++--
 6 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 49da4d4a3c3d3..3138f01db6699 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -794,6 +794,12 @@ static inline u32 tcp_skb_timestamp(const struct sk_buff *skb)
 	return div_u64(skb->skb_mstamp, USEC_PER_SEC / TCP_TS_HZ);
 }
 
+/* provide the departure time in us unit */
+static inline u64 tcp_skb_timestamp_us(const struct sk_buff *skb)
+{
+	return skb->skb_mstamp;
+}
+
 
 #define tcp_flag_byte(th) (((u_int8_t *)th)[13])
 
@@ -2003,7 +2009,7 @@ static inline s64 tcp_rto_delta_us(const struct sock *sk)
 {
 	const struct sk_buff *skb = tcp_rtx_queue_head(sk);
 	u32 rto = inet_csk(sk)->icsk_rto;
-	u64 rto_time_stamp_us = skb->skb_mstamp + jiffies_to_usecs(rto);
+	u64 rto_time_stamp_us = tcp_skb_timestamp_us(skb) + jiffies_to_usecs(rto);
 
 	return rto_time_stamp_us - tcp_sk(sk)->tcp_mstamp;
 }
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 9254705afa869..2437a196c1392 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1301,7 +1301,7 @@ static bool tcp_shifted_skb(struct sock *sk, struct sk_buff *prev,
 	 */
 	tcp_sacktag_one(sk, state, TCP_SKB_CB(skb)->sacked,
 			start_seq, end_seq, dup_sack, pcount,
-			skb->skb_mstamp);
+			tcp_skb_timestamp_us(skb));
 	tcp_rate_skb_delivered(sk, skb, state->rate);
 
 	if (skb == tp->lost_skb_hint)
@@ -1590,7 +1590,7 @@ static struct sk_buff *tcp_sacktag_walk(struct sk_buff *skb, struct sock *sk,
 						TCP_SKB_CB(skb)->end_seq,
 						dup_sack,
 						tcp_skb_pcount(skb),
-						skb->skb_mstamp);
+						tcp_skb_timestamp_us(skb));
 			tcp_rate_skb_delivered(sk, skb, state->rate);
 			if (TCP_SKB_CB(skb)->sacked & TCPCB_SACKED_ACKED)
 				list_del_init(&skb->tcp_tsorted_anchor);
@@ -3140,7 +3140,7 @@ static int tcp_clean_rtx_queue(struct sock *sk, u32 prior_fack,
 				tp->retrans_out -= acked_pcount;
 			flag |= FLAG_RETRANS_DATA_ACKED;
 		} else if (!(sacked & TCPCB_SACKED_ACKED)) {
-			last_ackt = skb->skb_mstamp;
+			last_ackt = tcp_skb_timestamp_us(skb);
 			WARN_ON_ONCE(last_ackt == 0);
 			if (!first_ackt)
 				first_ackt = last_ackt;
@@ -3158,7 +3158,7 @@ static int tcp_clean_rtx_queue(struct sock *sk, u32 prior_fack,
 			tp->delivered += acked_pcount;
 			if (!tcp_skb_spurious_retrans(tp, skb))
 				tcp_rack_advance(tp, sacked, scb->end_seq,
-						 skb->skb_mstamp);
+						 tcp_skb_timestamp_us(skb));
 		}
 		if (sacked & TCPCB_LOST)
 			tp->lost_out -= acked_pcount;
@@ -3253,7 +3253,8 @@ static int tcp_clean_rtx_queue(struct sock *sk, u32 prior_fack,
 			tp->lost_cnt_hint -= min(tp->lost_cnt_hint, delta);
 		}
 	} else if (skb && rtt_update && sack_rtt_us >= 0 &&
-		   sack_rtt_us > tcp_stamp_us_delta(tp->tcp_mstamp, skb->skb_mstamp)) {
+		   sack_rtt_us > tcp_stamp_us_delta(tp->tcp_mstamp,
+						    tcp_skb_timestamp_us(skb))) {
 		/* Do not re-arm RTO if the sack RTT is measured from data sent
 		 * after when the head was last (re)transmitted. Otherwise the
 		 * timeout may continue to extend in loss recovery.
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index aa9aa38471f95..d08e9d33e4d79 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -556,7 +556,7 @@ void tcp_v4_err(struct sk_buff *icmp_skb, u32 info)
 		icsk->icsk_rto = inet_csk_rto_backoff(icsk, TCP_RTO_MAX);
 
 		tcp_mstamp_refresh(tp);
-		delta_us = (u32)(tp->tcp_mstamp - skb->skb_mstamp);
+		delta_us = (u32)(tp->tcp_mstamp - tcp_skb_timestamp_us(skb));
 		remaining = icsk->icsk_rto -
 			    usecs_to_jiffies(delta_us);
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index fbeb40a481fcb..20bce57a19f09 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1993,7 +1993,7 @@ static bool tcp_tso_should_defer(struct sock *sk, struct sk_buff *skb,
 	head = tcp_rtx_queue_head(sk);
 	if (!head)
 		goto send_now;
-	age = tcp_stamp_us_delta(tp->tcp_mstamp, head->skb_mstamp);
+	age = tcp_stamp_us_delta(tp->tcp_mstamp, tcp_skb_timestamp_us(head));
 	/* If next ACK is likely to come too late (half srtt), do not defer */
 	if (age < (tp->srtt_us >> 4))
 		goto send_now;
diff --git a/net/ipv4/tcp_rate.c b/net/ipv4/tcp_rate.c
index 4dff40dad4dc5..baed2186c7c62 100644
--- a/net/ipv4/tcp_rate.c
+++ b/net/ipv4/tcp_rate.c
@@ -55,8 +55,10 @@ void tcp_rate_skb_sent(struct sock *sk, struct sk_buff *skb)
 	  * bandwidth estimate.
 	  */
 	if (!tp->packets_out) {
-		tp->first_tx_mstamp  = skb->skb_mstamp;
-		tp->delivered_mstamp = skb->skb_mstamp;
+		u64 tstamp_us = tcp_skb_timestamp_us(skb);
+
+		tp->first_tx_mstamp  = tstamp_us;
+		tp->delivered_mstamp = tstamp_us;
 	}
 
 	TCP_SKB_CB(skb)->tx.first_tx_mstamp	= tp->first_tx_mstamp;
@@ -88,13 +90,12 @@ void tcp_rate_skb_delivered(struct sock *sk, struct sk_buff *skb,
 		rs->is_app_limited   = scb->tx.is_app_limited;
 		rs->is_retrans	     = scb->sacked & TCPCB_RETRANS;
 
+		/* Record send time of most recently ACKed packet: */
+		tp->first_tx_mstamp  = tcp_skb_timestamp_us(skb);
 		/* Find the duration of the "send phase" of this window: */
-		rs->interval_us      = tcp_stamp_us_delta(
-						skb->skb_mstamp,
-						scb->tx.first_tx_mstamp);
+		rs->interval_us = tcp_stamp_us_delta(tp->first_tx_mstamp,
+						     scb->tx.first_tx_mstamp);
 
-		/* Record send time of most recently ACKed packet: */
-		tp->first_tx_mstamp  = skb->skb_mstamp;
 	}
 	/* Mark off the skb delivered once it's sacked to avoid being
 	 * used again when it's cumulatively acked. For acked packets
diff --git a/net/ipv4/tcp_recovery.c b/net/ipv4/tcp_recovery.c
index 844ff390f7263..db3469c95c49d 100644
--- a/net/ipv4/tcp_recovery.c
+++ b/net/ipv4/tcp_recovery.c
@@ -51,7 +51,7 @@ static u32 tcp_rack_reo_wnd(const struct sock *sk)
 s32 tcp_rack_skb_timeout(struct tcp_sock *tp, struct sk_buff *skb, u32 reo_wnd)
 {
 	return tp->rack.rtt_us + reo_wnd -
-	       tcp_stamp_us_delta(tp->tcp_mstamp, skb->skb_mstamp);
+	       tcp_stamp_us_delta(tp->tcp_mstamp, tcp_skb_timestamp_us(skb));
 }
 
 /* RACK loss detection (IETF draft draft-ietf-tcpm-rack-01):
@@ -92,7 +92,8 @@ static void tcp_rack_detect_loss(struct sock *sk, u32 *reo_timeout)
 		    !(scb->sacked & TCPCB_SACKED_RETRANS))
 			continue;
 
-		if (!tcp_rack_sent_after(tp->rack.mstamp, skb->skb_mstamp,
+		if (!tcp_rack_sent_after(tp->rack.mstamp,
+					 tcp_skb_timestamp_us(skb),
 					 tp->rack.end_seq, scb->end_seq))
 			break;
 
-- 
2.43.0



