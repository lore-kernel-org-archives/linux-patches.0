Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2348C2BE02A;
	Wed, 20 May 2026 17:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296507; cv=none; b=JKEOFn23sLpoAFn5Qcdgt1ZIVp9fKeRZYH36mzbKC0aaE8fc7fVqW35CIZeUNBvEzSNqYBx7iu5CZzzuXSI53v5KrBk5SLrvlgfXAEJFYks59sopETP0rXSmxHBblEp4lkfX44B94yMgrfB/h2OitHotOkm4OP0FEAjowHsI05Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296507; c=relaxed/simple;
	bh=I2k9oZCetRtkf/qe2AvSJML0bl/W7EfRojIHAmi+sMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NAc+BJRfxE9KPkO7tM3YjRxk6QKXA1FCG5j5Yzp7Y4dccsliOjiSopV2CWuaNR4wGdH1aW8xZ336/WK7+jv+p3tEystZF2Q/IqxOunYliTKIwe4cyek0RW3wMgc7WIKkrHYuAJUM0WMRHsBJiKZS7yorsueHcdKZ0w1lVGyrb44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8682xjv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8682xjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 887DC1F00893;
	Wed, 20 May 2026 17:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296506;
	bh=W6Tja8dnj1vjIrJNVwai+nJd99g9TCwr4OrEYVvLzuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d8682xjvNata67EJ/wbO3lSfS3lKOLmNP55qkulKuiE6bM6mZiY42P9FbpdKyFLwJ
	 PHNboRnBm4OC77dtlwGw5wWL7v2sMZL//tM6XKYr6R+A4Y1xanewCHpPvcgj+QyOs7
	 yVyEroDCjrNCxvi77YE9TOR77SYbVyUfoeuyqQXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0784/1146] tcp: annotate data-races around tp->delivered and tp->delivered_ce
Date: Wed, 20 May 2026 18:17:14 +0200
Message-ID: <20260520162205.960359169@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

[ Upstream commit faa886ad3ce5fc8f5156493491fe189b2b726bc9 ]

tcp_get_timestamping_opt_stats() intentionally runs lockless, we must
add READ_ONCE() and WRITE_ONCE() annotations to keep KCSAN happy.

Fixes: feb5f2ec6464 ("tcp: export packets delivery info")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260416200319.3608680-6-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp_ecn.h | 2 +-
 net/ipv4/tcp.c        | 4 ++--
 net/ipv4/tcp_input.c  | 8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/net/tcp_ecn.h b/include/net/tcp_ecn.h
index e9a933641636e..865d5c5a7718d 100644
--- a/include/net/tcp_ecn.h
+++ b/include/net/tcp_ecn.h
@@ -181,7 +181,7 @@ static inline void tcp_accecn_third_ack(struct sock *sk,
 		    tcp_accecn_validate_syn_feedback(sk, ace, sent_ect)) {
 			if ((tcp_accecn_extract_syn_ect(ace) == INET_ECN_CE) &&
 			    !tp->delivered_ce)
-				tp->delivered_ce++;
+				WRITE_ONCE(tp->delivered_ce, 1);
 		}
 		break;
 	}
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 3eaaebc69eed7..ee50b2d3ed976 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4487,8 +4487,8 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
 		   READ_ONCE(inet_csk(sk)->icsk_retransmits));
 	nla_put_u8(stats, TCP_NLA_DELIVERY_RATE_APP_LMT, data_race(!!tp->rate_app_limited));
 	nla_put_u32(stats, TCP_NLA_SND_SSTHRESH, READ_ONCE(tp->snd_ssthresh));
-	nla_put_u32(stats, TCP_NLA_DELIVERED, tp->delivered);
-	nla_put_u32(stats, TCP_NLA_DELIVERED_CE, tp->delivered_ce);
+	nla_put_u32(stats, TCP_NLA_DELIVERED, READ_ONCE(tp->delivered));
+	nla_put_u32(stats, TCP_NLA_DELIVERED_CE, READ_ONCE(tp->delivered_ce));
 
 	nla_put_u32(stats, TCP_NLA_SNDQ_SIZE, tp->write_seq - tp->snd_una);
 	nla_put_u8(stats, TCP_NLA_CA_STATE, inet_csk(sk)->icsk_ca_state);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 177f87f2b7885..f1bb0ad2eead1 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -476,14 +476,14 @@ static bool tcp_accecn_process_option(struct tcp_sock *tp,
 
 static void tcp_count_delivered_ce(struct tcp_sock *tp, u32 ecn_count)
 {
-	tp->delivered_ce += ecn_count;
+	WRITE_ONCE(tp->delivered_ce, tp->delivered_ce + ecn_count);
 }
 
 /* Updates the delivered and delivered_ce counts */
 static void tcp_count_delivered(struct tcp_sock *tp, u32 delivered,
 				bool ece_ack)
 {
-	tp->delivered += delivered;
+	WRITE_ONCE(tp->delivered, tp->delivered + delivered);
 	if (tcp_ecn_mode_rfc3168(tp) && ece_ack)
 		tcp_count_delivered_ce(tp, delivered);
 }
@@ -6838,7 +6838,7 @@ static bool tcp_rcv_fastopen_synack(struct sock *sk, struct sk_buff *synack,
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPFASTOPENACTIVE);
 		/* SYN-data is counted as two separate packets in tcp_ack() */
 		if (tp->delivered > 1)
-			--tp->delivered;
+			WRITE_ONCE(tp->delivered, tp->delivered - 1);
 	}
 
 	tcp_fastopen_add_skb(sk, synack);
@@ -7269,7 +7269,7 @@ tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 	SKB_DR_SET(reason, NOT_SPECIFIED);
 	switch (sk->sk_state) {
 	case TCP_SYN_RECV:
-		tp->delivered++; /* SYN-ACK delivery isn't tracked in tcp_ack */
+		WRITE_ONCE(tp->delivered, tp->delivered + 1); /* SYN-ACK delivery isn't tracked in tcp_ack */
 		if (!tp->srtt_us)
 			tcp_synack_rtt_meas(sk, req);
 
-- 
2.53.0



