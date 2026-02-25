Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B271118DB2A;
	Wed, 25 Feb 2026 01:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983248; cv=none; b=kyeYYhKGZ/0GSfuWwSlHIHvnAjuCqT6FQlcwDU8z5O3PS3p01cq8jt4Wza35Yw1YY9f/flqGSYatd2F66N65NaLbOxkCjGlqbic8l3Umx4R9/+mgwF7b5Rqrwbj+0ebk6SNcN3kb3sJuP+ViVGEdOqw+5uaXiGpIVw9CpezIRiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983248; c=relaxed/simple;
	bh=QRoww3ty/0XUsKdVjn3pBfaQL8n9Vl8XMRmm5E2+gkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BLkYaPrJUDLIkvkxq72OTmKTOeZvQn/7jwM2W1QWttlOCOu9yGnEVlSMuxii5mCBBP/yCdVnO6v0wPH7Z7TWGZORshgIANxMgsX7aSvLTPhxf+wx7haG/Vv3r0eTsdjQ0t04kzLjQJEnqlC7uuRTF1i4vVwu7FD9SijEVJYv9xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N8OhEFP6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N8OhEFP6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733C1C116D0;
	Wed, 25 Feb 2026 01:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983248;
	bh=QRoww3ty/0XUsKdVjn3pBfaQL8n9Vl8XMRmm5E2+gkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N8OhEFP6iU1Kb+9u040v3ZgxAjRypCXOI+LVTmxX93qsEiP7iglb4FXeTSI7VTqgw
	 I421SgKojB3vuO49JmwFyIlNJDO5n42AQfdcGEgNKmymY8I4d1bxJiRANT9Mf0uQkp
	 W1hH8jgDYWZ7X9wxx1SjNUp9EwZDo31CaxJGHMvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 388/781] tcp: disable RFC3168 fallback identifier for CC modules
Date: Tue, 24 Feb 2026 17:18:17 -0800
Message-ID: <20260225012409.211884517@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>

[ Upstream commit e68c28f22f46ecfdec3656ae785dd8ccbb4d557d ]

When AccECN is not successfully negociated for a TCP flow, it defaults
fallback to classic ECN (RFC3168). However, L4S service will fallback
to non-ECN.

This patch enables congestion control module to control whether it
should not fallback to classic ECN after unsuccessful AccECN negotiation.
A new CA module flag (TCP_CONG_NO_FALLBACK_RFC3168) identifies this
behavior expected by the CA.

Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260131222515.8485-6-chia-yu.chang@nokia-bell-labs.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: c5ff6b837159 ("tcp: accecn: handle unexpected AccECN negotiation feedback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h        | 12 +++++++++++-
 include/net/tcp_ecn.h    | 11 ++++++++---
 net/ipv4/tcp_input.c     |  2 +-
 net/ipv4/tcp_minisocks.c |  7 ++++---
 4 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index c4c25f2e0c0dd..e0a5cf2f78181 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1207,8 +1207,11 @@ enum tcp_ca_ack_event_flags {
 #define TCP_CONG_NEEDS_ACCECN		BIT(2)
 /* Use ECT(1) instead of ECT(0) while the CA is uninitialized */
 #define TCP_CONG_ECT_1_NEGOTIATION	BIT(3)
+/* Cannot fallback to RFC3168 during AccECN negotiation */
+#define TCP_CONG_NO_FALLBACK_RFC3168	BIT(4)
 #define TCP_CONG_MASK  (TCP_CONG_NON_RESTRICTED | TCP_CONG_NEEDS_ECN | \
-			TCP_CONG_NEEDS_ACCECN | TCP_CONG_ECT_1_NEGOTIATION)
+			TCP_CONG_NEEDS_ACCECN | TCP_CONG_ECT_1_NEGOTIATION | \
+			TCP_CONG_NO_FALLBACK_RFC3168)
 
 union tcp_cc_info;
 
@@ -1354,6 +1357,13 @@ static inline bool tcp_ca_ect_1_negotiation(const struct sock *sk)
 	return icsk->icsk_ca_ops->flags & TCP_CONG_ECT_1_NEGOTIATION;
 }
 
+static inline bool tcp_ca_no_fallback_rfc3168(const struct sock *sk)
+{
+	const struct inet_connection_sock *icsk = inet_csk(sk);
+
+	return icsk->icsk_ca_ops->flags & TCP_CONG_NO_FALLBACK_RFC3168;
+}
+
 static inline void tcp_ca_event(struct sock *sk, const enum tcp_ca_event event)
 {
 	const struct inet_connection_sock *icsk = inet_csk(sk);
diff --git a/include/net/tcp_ecn.h b/include/net/tcp_ecn.h
index fdde1c342b35c..2e1637edf1d3c 100644
--- a/include/net/tcp_ecn.h
+++ b/include/net/tcp_ecn.h
@@ -507,7 +507,9 @@ static inline void tcp_ecn_rcv_synack(struct sock *sk, const struct sk_buff *skb
 		 * | ECN    | AccECN | 0   0   1  | Classic ECN |
 		 * +========+========+============+=============+
 		 */
-		if (tcp_ecn_mode_pending(tp))
+		if (tcp_ca_no_fallback_rfc3168(sk))
+			tcp_ecn_mode_set(tp, TCP_ECN_DISABLED);
+		else if (tcp_ecn_mode_pending(tp))
 			/* Downgrade from AccECN, or requested initially */
 			tcp_ecn_mode_set(tp, TCP_ECN_MODE_RFC3168);
 		break;
@@ -531,9 +533,11 @@ static inline void tcp_ecn_rcv_synack(struct sock *sk, const struct sk_buff *skb
 	}
 }
 
-static inline void tcp_ecn_rcv_syn(struct tcp_sock *tp, const struct tcphdr *th,
+static inline void tcp_ecn_rcv_syn(struct sock *sk, const struct tcphdr *th,
 				   const struct sk_buff *skb)
 {
+	struct tcp_sock *tp = tcp_sk(sk);
+
 	if (tcp_ecn_mode_pending(tp)) {
 		if (!tcp_accecn_syn_requested(th)) {
 			/* Downgrade to classic ECN feedback */
@@ -545,7 +549,8 @@ static inline void tcp_ecn_rcv_syn(struct tcp_sock *tp, const struct tcphdr *th,
 			tcp_ecn_mode_set(tp, TCP_ECN_MODE_ACCECN);
 		}
 	}
-	if (tcp_ecn_mode_rfc3168(tp) && (!th->ece || !th->cwr))
+	if (tcp_ecn_mode_rfc3168(tp) &&
+	    (!th->ece || !th->cwr || tcp_ca_no_fallback_rfc3168(sk)))
 		tcp_ecn_mode_set(tp, TCP_ECN_DISABLED);
 }
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 736f8f55ab5a6..0d080a3e27d6f 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6843,7 +6843,7 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 		tp->snd_wl1    = TCP_SKB_CB(skb)->seq;
 		tp->max_window = tp->snd_wnd;
 
-		tcp_ecn_rcv_syn(tp, th, skb);
+		tcp_ecn_rcv_syn(sk, th, skb);
 
 		tcp_mtup_init(sk);
 		tcp_sync_mss(sk, icsk->icsk_pmtu_cookie);
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index bd5462154f970..9776c921d1bb4 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -485,9 +485,10 @@ static void tcp_ecn_openreq_child(struct sock *sk,
 		tp->accecn_opt_demand = 1;
 		tcp_ecn_received_counters_payload(sk, skb);
 	} else {
-		tcp_ecn_mode_set(tp, inet_rsk(req)->ecn_ok ?
-				     TCP_ECN_MODE_RFC3168 :
-				     TCP_ECN_DISABLED);
+		if (inet_rsk(req)->ecn_ok && !tcp_ca_no_fallback_rfc3168(sk))
+			tcp_ecn_mode_set(tp, TCP_ECN_MODE_RFC3168);
+		else
+			tcp_ecn_mode_set(tp, TCP_ECN_DISABLED);
 	}
 }
 
-- 
2.51.0



