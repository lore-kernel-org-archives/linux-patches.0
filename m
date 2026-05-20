Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D878E277C88;
	Wed, 20 May 2026 17:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296502; cv=none; b=XwqdTI0GVMi6LNJSKCDCFyuOobpWbevohGWRk6TH9cbhDqs6o89YZFrDsgEwag9OQZ0K6HKO8q0d8ogOoNOj20U3f2AiumpIJvGj87dxsvvHarHokP5fmca4F5TrIT2OSRLgpLgZDDKg8RwMXuJJ7RXHuUoFcCpaHuhP95fAqGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296502; c=relaxed/simple;
	bh=TZbpr4QYOu1Pi9CM9V4bLjEIjV18PUH7GJN1Ebrq8/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQKYPZhRNu0CrFjTYDUcVGJwWfXlKxdlBSpLGCD/6dSywFhKX7g+WtIB1vvM9t4//BMgvhXt9KOSapT1eNlOVQLLRzTn9M+rp7PhxiKfM31cSDYok+CY0bmyvkWosUS74oZFYVUvfRG/DB6RBJtY26bzAHMYiAcQ/oAQW+2AtSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LPO7ZrvH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LPO7ZrvH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45ED21F00894;
	Wed, 20 May 2026 17:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296500;
	bh=y7BvFigNdQex7DEfIWTWeJDk+0aETz8F52oMCcwdw3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LPO7ZrvHMK3v66CfIWyuwqBjEHHpl0FB9SjI8PLynV6wg3OlzCc85b7bOXqQe5o/3
	 +taF1ByBgb2iEAmR7RJ3nDzK5pVC1m2z2D81YofwW5cO5blw+yo2+Di8y0AxQSXGMJ
	 ClKGw/zChQ5Vw+5pWMONnUKh2duEQ/ICvVTmARh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0782/1146] tcp: add data-races annotations around tp->reordering, tp->snd_cwnd
Date: Wed, 20 May 2026 18:17:12 +0200
Message-ID: <20260520162205.913018461@linuxfoundation.org>
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

[ Upstream commit 829ba1f329cb7cbd56d599a6d225997fba66dc32 ]

tcp_get_timestamping_opt_stats() intentionally runs lockless, we must
add READ_ONCE(), WRITE_ONCE() data_race() annotations to keep KCSAN happy.

Fixes: bb7c19f96012 ("tcp: add related fields into SCM_TIMESTAMPING_OPT_STATS")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260416200319.3608680-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h      |  2 +-
 net/ipv4/tcp.c         |  8 ++++----
 net/ipv4/tcp_input.c   | 14 ++++++++------
 net/ipv4/tcp_metrics.c |  2 +-
 4 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 1946935388be6..ebc72dce4134d 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1465,7 +1465,7 @@ static inline u32 tcp_snd_cwnd(const struct tcp_sock *tp)
 static inline void tcp_snd_cwnd_set(struct tcp_sock *tp, u32 val)
 {
 	WARN_ON_ONCE((int)val <= 0);
-	tp->snd_cwnd = val;
+	WRITE_ONCE(tp->snd_cwnd, val);
 }
 
 static inline bool tcp_in_slow_start(const struct tcp_sock *tp)
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index d1953c6376f8b..c3253a810ea6e 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4479,13 +4479,13 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
 	rate64 = tcp_compute_delivery_rate(tp);
 	nla_put_u64_64bit(stats, TCP_NLA_DELIVERY_RATE, rate64, TCP_NLA_PAD);
 
-	nla_put_u32(stats, TCP_NLA_SND_CWND, tcp_snd_cwnd(tp));
-	nla_put_u32(stats, TCP_NLA_REORDERING, tp->reordering);
-	nla_put_u32(stats, TCP_NLA_MIN_RTT, tcp_min_rtt(tp));
+	nla_put_u32(stats, TCP_NLA_SND_CWND, READ_ONCE(tp->snd_cwnd));
+	nla_put_u32(stats, TCP_NLA_REORDERING, READ_ONCE(tp->reordering));
+	nla_put_u32(stats, TCP_NLA_MIN_RTT, data_race(tcp_min_rtt(tp)));
 
 	nla_put_u8(stats, TCP_NLA_RECUR_RETRANS,
 		   READ_ONCE(inet_csk(sk)->icsk_retransmits));
-	nla_put_u8(stats, TCP_NLA_DELIVERY_RATE_APP_LMT, !!tp->rate_app_limited);
+	nla_put_u8(stats, TCP_NLA_DELIVERY_RATE_APP_LMT, data_race(!!tp->rate_app_limited));
 	nla_put_u32(stats, TCP_NLA_SND_SSTHRESH, tp->snd_ssthresh);
 	nla_put_u32(stats, TCP_NLA_DELIVERED, tp->delivered);
 	nla_put_u32(stats, TCP_NLA_DELIVERED_CE, tp->delivered_ce);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index cba89733d1216..891a7f74432bb 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1294,8 +1294,9 @@ static void tcp_check_sack_reordering(struct sock *sk, const u32 low_seq,
 			 tp->sacked_out,
 			 tp->undo_marker ? tp->undo_retrans : 0);
 #endif
-		tp->reordering = min_t(u32, (metric + mss - 1) / mss,
-				       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_max_reordering));
+		WRITE_ONCE(tp->reordering,
+			   min_t(u32, (metric + mss - 1) / mss,
+				 READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_max_reordering)));
 	}
 
 	/* This exciting event is worth to be remembered. 8) */
@@ -2440,8 +2441,9 @@ static void tcp_check_reno_reordering(struct sock *sk, const int addend)
 	if (!tcp_limit_reno_sacked(tp))
 		return;
 
-	tp->reordering = min_t(u32, tp->packets_out + addend,
-			       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_max_reordering));
+	WRITE_ONCE(tp->reordering,
+		   min_t(u32, tp->packets_out + addend,
+			 READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_max_reordering)));
 	tp->reord_seen++;
 	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPRENOREORDER);
 }
@@ -2580,8 +2582,8 @@ void tcp_enter_loss(struct sock *sk)
 	reordering = READ_ONCE(net->ipv4.sysctl_tcp_reordering);
 	if (icsk->icsk_ca_state <= TCP_CA_Disorder &&
 	    tp->sacked_out >= reordering)
-		tp->reordering = min_t(unsigned int, tp->reordering,
-				       reordering);
+		WRITE_ONCE(tp->reordering,
+			   min_t(unsigned int, tp->reordering, reordering));
 
 	tcp_set_ca_state(sk, TCP_CA_Loss);
 	tp->high_seq = tp->snd_nxt;
diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index 06b1d5d3b6df7..7a9d6d9006f65 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -496,7 +496,7 @@ void tcp_init_metrics(struct sock *sk)
 	}
 	val = tcp_metric_get(tm, TCP_METRIC_REORDERING);
 	if (val && tp->reordering != val)
-		tp->reordering = val;
+		WRITE_ONCE(tp->reordering, val);
 
 	crtt = tcp_metric_get(tm, TCP_METRIC_RTT);
 	rcu_read_unlock();
-- 
2.53.0



