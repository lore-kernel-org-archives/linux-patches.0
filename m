Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A015A3EFD05;
	Wed, 20 May 2026 17:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296505; cv=none; b=koAMPpkjBdpjOh9qqgVbWG4pCOxpm+6b+Axic//yeLiDY84ojjQnAynaGtwi8nGulWhxOgk4oq/Wjk+7a+Qw5+gTXKCGDSB6vMXcfCXfe/Tm0TYsbLFrXNSoOK8nEwviyaE0nCEflgLU6fyZs6D7vVaWaCJvEbtzs3SvNJ/rXVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296505; c=relaxed/simple;
	bh=Mnhx2IB1ZiwOM7VZnM0BSBTLr5WRJuZ7MBQVhwEvtiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQN+BLKgFi54WVAcJcOn+QQ0ikcCZ5NvCNdbgwbMYV4wR7IGP41IXQ++29YyAfN07FTWgNe0bkgkby19FDhTyOUQJ7NAuf6dOfwQpY6KZRHfaTdNZncbZRBtYnFeRxxlWN65dT5pavVkUqsOjCN351JC7QtC4Iveoxe+cLkJaPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rt/fOXcA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rt/fOXcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5901F000E9;
	Wed, 20 May 2026 17:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296503;
	bh=3EA9CZQ6n6CnMzn6RTyWlD8+a/DOZF7BUPDwuVipOss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rt/fOXcAwD4TIGZtQaFtpoNjE7m++KRUEVNnc6fsR2l8Qiz+mi4gx8qG/MgkSuNlP
	 p/HOjpGzh5T0VK0LrMKgVEGwic/P/RlV7Kare6aixRi18tpXDp0DtACY1Bo6AIjMkn
	 U/wyL+EODQr/KQXvrMQk+dVVwQKxIfDvvjEQUd+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0783/1146] tcp: annotate data-races around tp->snd_ssthresh
Date: Wed, 20 May 2026 18:17:13 +0200
Message-ID: <20260520162205.937834130@linuxfoundation.org>
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

[ Upstream commit fd571afb05ebaeac5d8f09460a0640d4cf6755f8 ]

tcp_get_timestamping_opt_stats() intentionally runs lockless, we must
add READ_ONCE() and WRITE_ONCE() annotations to keep KCSAN happy.

Fixes: 7156d194a077 ("tcp: add snd_ssthresh stat in SCM_TIMESTAMPING_OPT_STATS")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260416200319.3608680-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c       | 2 +-
 net/ipv4/tcp.c          | 4 ++--
 net/ipv4/tcp_bbr.c      | 6 +++---
 net/ipv4/tcp_bic.c      | 2 +-
 net/ipv4/tcp_cdg.c      | 4 ++--
 net/ipv4/tcp_cubic.c    | 6 +++---
 net/ipv4/tcp_dctcp.c    | 2 +-
 net/ipv4/tcp_input.c    | 8 ++++----
 net/ipv4/tcp_metrics.c  | 4 ++--
 net/ipv4/tcp_nv.c       | 4 ++--
 net/ipv4/tcp_output.c   | 4 ++--
 net/ipv4/tcp_vegas.c    | 9 +++++----
 net/ipv4/tcp_westwood.c | 4 ++--
 net/ipv4/tcp_yeah.c     | 3 ++-
 14 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index d4fe9e4a45d11..d8a853a61b53f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5397,7 +5397,7 @@ static int bpf_sol_tcp_setsockopt(struct sock *sk, int optname,
 		if (val <= 0)
 			return -EINVAL;
 		tp->snd_cwnd_clamp = val;
-		tp->snd_ssthresh = val;
+		WRITE_ONCE(tp->snd_ssthresh, val);
 		break;
 	case TCP_BPF_DELACK_MAX:
 		timeout = usecs_to_jiffies(val);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index c3253a810ea6e..3eaaebc69eed7 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3458,7 +3458,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	icsk->icsk_rto = TCP_TIMEOUT_INIT;
 	WRITE_ONCE(icsk->icsk_rto_min, TCP_RTO_MIN);
 	WRITE_ONCE(icsk->icsk_delack_max, TCP_DELACK_MAX);
-	tp->snd_ssthresh = TCP_INFINITE_SSTHRESH;
+	WRITE_ONCE(tp->snd_ssthresh, TCP_INFINITE_SSTHRESH);
 	tcp_snd_cwnd_set(tp, TCP_INIT_CWND);
 	tp->snd_cwnd_cnt = 0;
 	tp->is_cwnd_limited = 0;
@@ -4486,7 +4486,7 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
 	nla_put_u8(stats, TCP_NLA_RECUR_RETRANS,
 		   READ_ONCE(inet_csk(sk)->icsk_retransmits));
 	nla_put_u8(stats, TCP_NLA_DELIVERY_RATE_APP_LMT, data_race(!!tp->rate_app_limited));
-	nla_put_u32(stats, TCP_NLA_SND_SSTHRESH, tp->snd_ssthresh);
+	nla_put_u32(stats, TCP_NLA_SND_SSTHRESH, READ_ONCE(tp->snd_ssthresh));
 	nla_put_u32(stats, TCP_NLA_DELIVERED, tp->delivered);
 	nla_put_u32(stats, TCP_NLA_DELIVERED_CE, tp->delivered_ce);
 
diff --git a/net/ipv4/tcp_bbr.c b/net/ipv4/tcp_bbr.c
index 760941e55153e..3df6160f51567 100644
--- a/net/ipv4/tcp_bbr.c
+++ b/net/ipv4/tcp_bbr.c
@@ -896,8 +896,8 @@ static void bbr_check_drain(struct sock *sk, const struct rate_sample *rs)
 
 	if (bbr->mode == BBR_STARTUP && bbr_full_bw_reached(sk)) {
 		bbr->mode = BBR_DRAIN;	/* drain queue we created */
-		tcp_sk(sk)->snd_ssthresh =
-				bbr_inflight(sk, bbr_max_bw(sk), BBR_UNIT);
+		WRITE_ONCE(tcp_sk(sk)->snd_ssthresh,
+			   bbr_inflight(sk, bbr_max_bw(sk), BBR_UNIT));
 	}	/* fall through to check if in-flight is already small: */
 	if (bbr->mode == BBR_DRAIN &&
 	    bbr_packets_in_net_at_edt(sk, tcp_packets_in_flight(tcp_sk(sk))) <=
@@ -1042,7 +1042,7 @@ __bpf_kfunc static void bbr_init(struct sock *sk)
 	struct bbr *bbr = inet_csk_ca(sk);
 
 	bbr->prior_cwnd = 0;
-	tp->snd_ssthresh = TCP_INFINITE_SSTHRESH;
+	WRITE_ONCE(tp->snd_ssthresh, TCP_INFINITE_SSTHRESH);
 	bbr->rtt_cnt = 0;
 	bbr->next_rtt_delivered = tp->delivered;
 	bbr->prev_ca_state = TCP_CA_Open;
diff --git a/net/ipv4/tcp_bic.c b/net/ipv4/tcp_bic.c
index 58358bf92e1b8..65444ff142413 100644
--- a/net/ipv4/tcp_bic.c
+++ b/net/ipv4/tcp_bic.c
@@ -74,7 +74,7 @@ static void bictcp_init(struct sock *sk)
 	bictcp_reset(ca);
 
 	if (initial_ssthresh)
-		tcp_sk(sk)->snd_ssthresh = initial_ssthresh;
+		WRITE_ONCE(tcp_sk(sk)->snd_ssthresh, initial_ssthresh);
 }
 
 /*
diff --git a/net/ipv4/tcp_cdg.c b/net/ipv4/tcp_cdg.c
index ceabfd690a296..0812c390aee56 100644
--- a/net/ipv4/tcp_cdg.c
+++ b/net/ipv4/tcp_cdg.c
@@ -162,7 +162,7 @@ static void tcp_cdg_hystart_update(struct sock *sk)
 				NET_ADD_STATS(sock_net(sk),
 					      LINUX_MIB_TCPHYSTARTTRAINCWND,
 					      tcp_snd_cwnd(tp));
-				tp->snd_ssthresh = tcp_snd_cwnd(tp);
+				WRITE_ONCE(tp->snd_ssthresh, tcp_snd_cwnd(tp));
 				return;
 			}
 		}
@@ -181,7 +181,7 @@ static void tcp_cdg_hystart_update(struct sock *sk)
 				NET_ADD_STATS(sock_net(sk),
 					      LINUX_MIB_TCPHYSTARTDELAYCWND,
 					      tcp_snd_cwnd(tp));
-				tp->snd_ssthresh = tcp_snd_cwnd(tp);
+				WRITE_ONCE(tp->snd_ssthresh, tcp_snd_cwnd(tp));
 			}
 		}
 	}
diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index 76c23675ae50a..f891e8d1e5458 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -136,7 +136,7 @@ __bpf_kfunc static void cubictcp_init(struct sock *sk)
 		bictcp_hystart_reset(sk);
 
 	if (!hystart && initial_ssthresh)
-		tcp_sk(sk)->snd_ssthresh = initial_ssthresh;
+		WRITE_ONCE(tcp_sk(sk)->snd_ssthresh, initial_ssthresh);
 }
 
 __bpf_kfunc static void cubictcp_cwnd_event(struct sock *sk, enum tcp_ca_event event)
@@ -423,7 +423,7 @@ static void hystart_update(struct sock *sk, u32 delay)
 				NET_ADD_STATS(sock_net(sk),
 					      LINUX_MIB_TCPHYSTARTTRAINCWND,
 					      tcp_snd_cwnd(tp));
-				tp->snd_ssthresh = tcp_snd_cwnd(tp);
+				WRITE_ONCE(tp->snd_ssthresh, tcp_snd_cwnd(tp));
 			}
 		}
 	}
@@ -443,7 +443,7 @@ static void hystart_update(struct sock *sk, u32 delay)
 				NET_ADD_STATS(sock_net(sk),
 					      LINUX_MIB_TCPHYSTARTDELAYCWND,
 					      tcp_snd_cwnd(tp));
-				tp->snd_ssthresh = tcp_snd_cwnd(tp);
+				WRITE_ONCE(tp->snd_ssthresh, tcp_snd_cwnd(tp));
 			}
 		}
 	}
diff --git a/net/ipv4/tcp_dctcp.c b/net/ipv4/tcp_dctcp.c
index 03abe0848420d..6f103038b0152 100644
--- a/net/ipv4/tcp_dctcp.c
+++ b/net/ipv4/tcp_dctcp.c
@@ -177,7 +177,7 @@ static void dctcp_react_to_loss(struct sock *sk)
 	struct tcp_sock *tp = tcp_sk(sk);
 
 	ca->loss_cwnd = tcp_snd_cwnd(tp);
-	tp->snd_ssthresh = max(tcp_snd_cwnd(tp) >> 1U, 2U);
+	WRITE_ONCE(tp->snd_ssthresh, max(tcp_snd_cwnd(tp) >> 1U, 2U));
 }
 
 __bpf_kfunc static void dctcp_state(struct sock *sk, u8 new_state)
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 891a7f74432bb..177f87f2b7885 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2568,7 +2568,7 @@ void tcp_enter_loss(struct sock *sk)
 	    (icsk->icsk_ca_state == TCP_CA_Loss && !icsk->icsk_retransmits)) {
 		tp->prior_ssthresh = tcp_current_ssthresh(sk);
 		tp->prior_cwnd = tcp_snd_cwnd(tp);
-		tp->snd_ssthresh = icsk->icsk_ca_ops->ssthresh(sk);
+		WRITE_ONCE(tp->snd_ssthresh, icsk->icsk_ca_ops->ssthresh(sk));
 		tcp_ca_event(sk, CA_EVENT_LOSS);
 		tcp_init_undo(tp);
 	}
@@ -2861,7 +2861,7 @@ static void tcp_undo_cwnd_reduction(struct sock *sk, bool unmark_loss)
 		tcp_snd_cwnd_set(tp, icsk->icsk_ca_ops->undo_cwnd(sk));
 
 		if (tp->prior_ssthresh > tp->snd_ssthresh) {
-			tp->snd_ssthresh = tp->prior_ssthresh;
+			WRITE_ONCE(tp->snd_ssthresh, tp->prior_ssthresh);
 			tcp_ecn_withdraw_cwr(tp);
 		}
 	}
@@ -2979,7 +2979,7 @@ static void tcp_init_cwnd_reduction(struct sock *sk)
 	tp->prior_cwnd = tcp_snd_cwnd(tp);
 	tp->prr_delivered = 0;
 	tp->prr_out = 0;
-	tp->snd_ssthresh = inet_csk(sk)->icsk_ca_ops->ssthresh(sk);
+	WRITE_ONCE(tp->snd_ssthresh, inet_csk(sk)->icsk_ca_ops->ssthresh(sk));
 	tcp_ecn_queue_cwr(tp);
 }
 
@@ -3121,7 +3121,7 @@ static void tcp_non_congestion_loss_retransmit(struct sock *sk)
 
 	if (icsk->icsk_ca_state != TCP_CA_Loss) {
 		tp->high_seq = tp->snd_nxt;
-		tp->snd_ssthresh = tcp_current_ssthresh(sk);
+		WRITE_ONCE(tp->snd_ssthresh, tcp_current_ssthresh(sk));
 		tp->prior_ssthresh = 0;
 		tp->undo_marker = 0;
 		tcp_set_ca_state(sk, TCP_CA_Loss);
diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index 7a9d6d9006f65..dc0c081fc1f33 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -490,9 +490,9 @@ void tcp_init_metrics(struct sock *sk)
 	val = READ_ONCE(net->ipv4.sysctl_tcp_no_ssthresh_metrics_save) ?
 	      0 : tcp_metric_get(tm, TCP_METRIC_SSTHRESH);
 	if (val) {
-		tp->snd_ssthresh = val;
+		WRITE_ONCE(tp->snd_ssthresh, val);
 		if (tp->snd_ssthresh > tp->snd_cwnd_clamp)
-			tp->snd_ssthresh = tp->snd_cwnd_clamp;
+			WRITE_ONCE(tp->snd_ssthresh, tp->snd_cwnd_clamp);
 	}
 	val = tcp_metric_get(tm, TCP_METRIC_REORDERING);
 	if (val && tp->reordering != val)
diff --git a/net/ipv4/tcp_nv.c b/net/ipv4/tcp_nv.c
index a60662f4bdf92..f345897a68dfc 100644
--- a/net/ipv4/tcp_nv.c
+++ b/net/ipv4/tcp_nv.c
@@ -396,8 +396,8 @@ static void tcpnv_acked(struct sock *sk, const struct ack_sample *sample)
 
 			/* We have enough data to determine we are congested */
 			ca->nv_allow_cwnd_growth = 0;
-			tp->snd_ssthresh =
-				(nv_ssthresh_factor * max_win) >> 3;
+			WRITE_ONCE(tp->snd_ssthresh,
+				   (nv_ssthresh_factor * max_win) >> 3);
 			if (tcp_snd_cwnd(tp) - max_win > 2) {
 				/* gap > 2, we do exponential cwnd decrease */
 				int dec;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 87fa26603276c..6603331ec589e 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -171,7 +171,7 @@ void tcp_cwnd_restart(struct sock *sk, s32 delta)
 
 	tcp_ca_event(sk, CA_EVENT_CWND_RESTART);
 
-	tp->snd_ssthresh = tcp_current_ssthresh(sk);
+	WRITE_ONCE(tp->snd_ssthresh, tcp_current_ssthresh(sk));
 	restart_cwnd = min(restart_cwnd, cwnd);
 
 	while ((delta -= inet_csk(sk)->icsk_rto) > 0 && cwnd > restart_cwnd)
@@ -2125,7 +2125,7 @@ static void tcp_cwnd_application_limited(struct sock *sk)
 		u32 init_win = tcp_init_cwnd(tp, __sk_dst_get(sk));
 		u32 win_used = max(tp->snd_cwnd_used, init_win);
 		if (win_used < tcp_snd_cwnd(tp)) {
-			tp->snd_ssthresh = tcp_current_ssthresh(sk);
+			WRITE_ONCE(tp->snd_ssthresh, tcp_current_ssthresh(sk));
 			tcp_snd_cwnd_set(tp, (tcp_snd_cwnd(tp) + win_used) >> 1);
 		}
 		tp->snd_cwnd_used = 0;
diff --git a/net/ipv4/tcp_vegas.c b/net/ipv4/tcp_vegas.c
index 786848ad37ea8..3ec7308441a78 100644
--- a/net/ipv4/tcp_vegas.c
+++ b/net/ipv4/tcp_vegas.c
@@ -240,7 +240,8 @@ static void tcp_vegas_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 				 */
 				tcp_snd_cwnd_set(tp, min(tcp_snd_cwnd(tp),
 							 (u32)target_cwnd + 1));
-				tp->snd_ssthresh = tcp_vegas_ssthresh(tp);
+				WRITE_ONCE(tp->snd_ssthresh,
+					   tcp_vegas_ssthresh(tp));
 
 			} else if (tcp_in_slow_start(tp)) {
 				/* Slow start.  */
@@ -256,8 +257,8 @@ static void tcp_vegas_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 					 * we slow down.
 					 */
 					tcp_snd_cwnd_set(tp, tcp_snd_cwnd(tp) - 1);
-					tp->snd_ssthresh
-						= tcp_vegas_ssthresh(tp);
+					WRITE_ONCE(tp->snd_ssthresh,
+						   tcp_vegas_ssthresh(tp));
 				} else if (diff < alpha) {
 					/* We don't have enough extra packets
 					 * in the network, so speed up.
@@ -275,7 +276,7 @@ static void tcp_vegas_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 			else if (tcp_snd_cwnd(tp) > tp->snd_cwnd_clamp)
 				tcp_snd_cwnd_set(tp, tp->snd_cwnd_clamp);
 
-			tp->snd_ssthresh = tcp_current_ssthresh(sk);
+			WRITE_ONCE(tp->snd_ssthresh, tcp_current_ssthresh(sk));
 		}
 
 		/* Wipe the slate clean for the next RTT. */
diff --git a/net/ipv4/tcp_westwood.c b/net/ipv4/tcp_westwood.c
index c6e97141eef25..b5a42adfd6ca1 100644
--- a/net/ipv4/tcp_westwood.c
+++ b/net/ipv4/tcp_westwood.c
@@ -244,11 +244,11 @@ static void tcp_westwood_event(struct sock *sk, enum tcp_ca_event event)
 
 	switch (event) {
 	case CA_EVENT_COMPLETE_CWR:
-		tp->snd_ssthresh = tcp_westwood_bw_rttmin(sk);
+		WRITE_ONCE(tp->snd_ssthresh, tcp_westwood_bw_rttmin(sk));
 		tcp_snd_cwnd_set(tp, tp->snd_ssthresh);
 		break;
 	case CA_EVENT_LOSS:
-		tp->snd_ssthresh = tcp_westwood_bw_rttmin(sk);
+		WRITE_ONCE(tp->snd_ssthresh, tcp_westwood_bw_rttmin(sk));
 		/* Update RTT_min when next ack arrives */
 		w->reset_rtt_min = 1;
 		break;
diff --git a/net/ipv4/tcp_yeah.c b/net/ipv4/tcp_yeah.c
index 18b07ff5d20e6..74a2538e79e06 100644
--- a/net/ipv4/tcp_yeah.c
+++ b/net/ipv4/tcp_yeah.c
@@ -147,7 +147,8 @@ static void tcp_yeah_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 					tcp_snd_cwnd_set(tp, max(tcp_snd_cwnd(tp),
 								 yeah->reno_count));
 
-					tp->snd_ssthresh = tcp_snd_cwnd(tp);
+					WRITE_ONCE(tp->snd_ssthresh,
+						   tcp_snd_cwnd(tp));
 				}
 
 				if (yeah->reno_count <= 2)
-- 
2.53.0



