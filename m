Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB36436405A;
	Wed, 20 May 2026 17:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299021; cv=none; b=m7dCYAv2d9r6PGIA8Ja2zSH+EPonnGNFqLFSQenskVhfFJUasCjUyhpSqxoUl77TSxMcq2fONhELhPCwbdfCbea6jKiKksx8H5lbYPkWe44CtLVTfIhweEZJbQhfeOVdug9feKyQi2SKIz/1VwGdqGXupCzkSTs8qN2WqIlRx/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299021; c=relaxed/simple;
	bh=CQR55dXvZnCy7bBhvbvc/He+ewZ4CLHR4pz9WpmEZd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FgJUGJhitaBM6hAjkGdz9K6R+/Ybp7BYHOei8LHEW4n3g0YxShmuKkAxA6tNKcWOLuIgw37iFr0N4zAjt6TtVVEPh26dKUnQDLVSkZMNMtA4rJF9AoX3LciEa2Kv2f7ltm82wrcgy20BQUlNYsUj6DYO3MCTh6jfGChXg2LQFhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CYGc0uaB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CYGc0uaB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC2A1F000E9;
	Wed, 20 May 2026 17:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299019;
	bh=UFsF542/kYqKLYdpX0iq8LEQZiwDGi0LbTzzMz4o+1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CYGc0uaBLKnBLJAw5mlB1lRDVFSyRWjYL9dDwU3G4sYC0r6fVKbwQH6dr2mkBUvSo
	 RuUQE6tjjPO+z9r0WdRBfHcYd7B/4PyDKmP3iVoCSH4eJPU/qyUZZ6odHkP8rv3DT7
	 tAppFZCOK/tgrNI7SUBvYBXJUoqOOkVawmFEjJ8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 633/957] tcp: add data-races annotations around tp->reordering, tp->snd_cwnd
Date: Wed, 20 May 2026 18:18:36 +0200
Message-ID: <20260520162148.257901042@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index 236d9e0d35ed7..18381f4086d04 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1429,7 +1429,7 @@ static inline u32 tcp_snd_cwnd(const struct tcp_sock *tp)
 static inline void tcp_snd_cwnd_set(struct tcp_sock *tp, u32 val)
 {
 	WARN_ON_ONCE((int)val <= 0);
-	tp->snd_cwnd = val;
+	WRITE_ONCE(tp->snd_cwnd, val);
 }
 
 static inline bool tcp_in_slow_start(const struct tcp_sock *tp)
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4695b03f866f8..9e7e5ebcf14d5 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4397,13 +4397,13 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
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
index 96486eea26724..64e7bcbb42993 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1260,8 +1260,9 @@ static void tcp_check_sack_reordering(struct sock *sk, const u32 low_seq,
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
@@ -2220,8 +2221,9 @@ static void tcp_check_reno_reordering(struct sock *sk, const int addend)
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
@@ -2360,8 +2362,8 @@ void tcp_enter_loss(struct sock *sk)
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
index 45b6ecd164126..170ca11edf6b9 100644
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



