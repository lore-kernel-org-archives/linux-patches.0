Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5101B4FDA55;
	Thu, 17 Sep 2026 17:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667128; cv=none; b=tY/GgNYTB2dC9HVc/Xs93NILvsvarAIcTfJaGiWjpetVbNLebnCf4YtPhPzx8ai1Q6oX2kQ8d7PsPGABXDyHdhU61W6fK8pn41fyZuP6YhFWRbuztHbem6eTf/Ppzm1IFULMSYBg38f/Lmc1KIJtvTeE5L/116g4t77h+abq53k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667128; c=relaxed/simple;
	bh=sX+yple0IwTGoepLJL4jecMIK8Q+ebZ7jyY/jMSSgnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dI/WhaqHsXINZwPE66KdnUwYMxWJfe/xPUGQ73OibrxPq7my+PJy8Xh90SWf6BevyV/x4oyxL95G0icbl4PA40nJiOMb2KrnlUpd0WuHT6qUB7HjcuailAStSPhUEFwZT6E2JKo9wln7D+6/a2roqh+UN5PfxLQyNSRpvC7Bt3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kyDuGNSI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kyDuGNSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB9F1F0089A;
	Thu, 17 Sep 2026 17:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667125;
	bh=fk/q/MOMbKYSWIYyinqbiZ+Zi28K1EDsdTClMBLnyoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kyDuGNSIE3BdI++fjS3cvk54hyUmpZaKeY4aALrzxQC7OpScnf+tyKnNJqrlf+xLi
	 YyAIBSWupI+WvBf4X5Cy4fw5pxmUSv783QKoyEk7TsnJBGhWMdMMEAMTsJ0tqgS811
	 Qj909y4SraSKcwn/KjbJ2Bjj2S8KFReAxEAgMWKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1238/1250] tcp: introduce icsk->icsk_keepalive_timer
Date: Thu, 17 Sep 2026 16:17:13 +0100
Message-ID: <20260917151625.849543436@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

[ Upstream commit 08dfe370239e53494453cee1e2ded2cdaa1efd12 ]

sk->sk_timer has been used for TCP keepalives.

Keepalive timers are not in fast path, we want to use sk->sk_timer
storage for retransmit timers, for better cache locality.

Create icsk->icsk_keepalive_timer and change keepalive
code to no longer use sk->sk_timer.

Added space is reclaimed in the following patch.

This includes changes to MPTCP, which was also using sk_timer.

Alias icsk->mptcp_tout_timer and icsk->icsk_keepalive_timer
for inet_sk_diag_fill() sake.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20251124175013.1473655-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e2ab913f68c7 ("mptcp: do not reschedule the RTX timer for fallback sockets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/networking/net_cachelines/inet_connection_sock.rst |    1 
 include/net/inet_connection_sock.h                               |   11 ++++++++--
 net/ipv4/inet_connection_sock.c                                  |    6 ++---
 net/ipv4/inet_diag.c                                             |    4 +--
 net/ipv4/tcp_ipv4.c                                              |    4 +--
 net/ipv4/tcp_timer.c                                             |    9 ++++----
 net/ipv6/tcp_ipv6.c                                              |    4 +--
 net/mptcp/protocol.c                                             |   10 +++++----
 net/mptcp/protocol.h                                             |    2 -
 tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c                |    4 +--
 tools/testing/selftests/bpf/progs/bpf_iter_tcp6.c                |    4 +--
 11 files changed, 35 insertions(+), 24 deletions(-)

--- a/Documentation/networking/net_cachelines/inet_connection_sock.rst
+++ b/Documentation/networking/net_cachelines/inet_connection_sock.rst
@@ -14,6 +14,7 @@ struct inet_bind_bucket             icsk
 struct inet_bind2_bucket            icsk_bind2_hash        read_mostly                             tcp_set_state,inet_put_port
 struct timer_list                   icsk_retransmit_timer  read_write                              inet_csk_reset_xmit_timer,tcp_connect
 struct timer_list                   icsk_delack_timer      read_mostly                             inet_csk_reset_xmit_timer,tcp_connect
+struct timer_list                   icsk_keepalive_timer
 u32                                 icsk_rto               read_write                              tcp_cwnd_validate,tcp_schedule_loss_probe,tcp_connect_init,tcp_connect,tcp_write_xmit,tcp_push_one
 u32                                 icsk_rto_min
 u32                                 icsk_rto_max           read_mostly                             tcp_reset_xmit_timer
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -59,6 +59,9 @@ struct inet_connection_sock_af_ops {
  * @icsk_bind_hash:	   Bind node
  * @icsk_bind2_hash:	   Bind node in the bhash2 table
  * @icsk_retransmit_timer: Resend (no ack)
+ * @icsk_delack_timer:     Delayed ACK timer
+ * @icsk_keepalive_timer:  Keepalive timer
+ * @mptcp_tout_timer: mptcp timer
  * @icsk_rto:		   Retransmit timeout
  * @icsk_pmtu_cookie	   Last pmtu seen by socket
  * @icsk_ca_ops		   Pluggable congestion control hook
@@ -83,8 +86,12 @@ struct inet_connection_sock {
 	struct request_sock_queue icsk_accept_queue;
 	struct inet_bind_bucket	  *icsk_bind_hash;
 	struct inet_bind2_bucket  *icsk_bind2_hash;
- 	struct timer_list	  icsk_retransmit_timer;
- 	struct timer_list	  icsk_delack_timer;
+	struct timer_list	  icsk_retransmit_timer;
+	struct timer_list	  icsk_delack_timer;
+	union {
+		struct timer_list icsk_keepalive_timer;
+		struct timer_list mptcp_tout_timer;
+	};
 	__u32			  icsk_rto;
 	__u32                     icsk_rto_min;
 	u32			  icsk_rto_max;
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -750,7 +750,7 @@ void inet_csk_init_xmit_timers(struct so
 
 	timer_setup(&icsk->icsk_retransmit_timer, retransmit_handler, 0);
 	timer_setup(&icsk->icsk_delack_timer, delack_handler, 0);
-	timer_setup(&sk->sk_timer, keepalive_handler, 0);
+	timer_setup(&icsk->icsk_keepalive_timer, keepalive_handler, 0);
 	icsk->icsk_pending = icsk->icsk_ack.pending = 0;
 }
 
@@ -763,7 +763,7 @@ void inet_csk_clear_xmit_timers(struct s
 
 	sk_stop_timer(sk, &icsk->icsk_retransmit_timer);
 	sk_stop_timer(sk, &icsk->icsk_delack_timer);
-	sk_stop_timer(sk, &sk->sk_timer);
+	sk_stop_timer(sk, &icsk->icsk_keepalive_timer);
 }
 
 void inet_csk_clear_xmit_timers_sync(struct sock *sk)
@@ -778,7 +778,7 @@ void inet_csk_clear_xmit_timers_sync(str
 
 	sk_stop_timer_sync(sk, &icsk->icsk_retransmit_timer);
 	sk_stop_timer_sync(sk, &icsk->icsk_delack_timer);
-	sk_stop_timer_sync(sk, &sk->sk_timer);
+	sk_stop_timer_sync(sk, &icsk->icsk_keepalive_timer);
 }
 
 struct dst_entry *inet_csk_route_req(const struct sock *sk,
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -293,11 +293,11 @@ int inet_sk_diag_fill(struct sock *sk, s
 		r->idiag_retrans = READ_ONCE(icsk->icsk_probes_out);
 		r->idiag_expires =
 			jiffies_delta_to_msecs(tcp_timeout_expires(sk) - jiffies);
-	} else if (timer_pending(&sk->sk_timer)) {
+	} else if (timer_pending(&icsk->icsk_keepalive_timer)) {
 		r->idiag_timer = 2;
 		r->idiag_retrans = READ_ONCE(icsk->icsk_probes_out);
 		r->idiag_expires =
-			jiffies_delta_to_msecs(sk->sk_timer.expires - jiffies);
+			jiffies_delta_to_msecs(icsk->icsk_keepalive_timer.expires - jiffies);
 	}
 
 	if ((ext & (1 << (INET_DIAG_INFO - 1))) && handler->idiag_info_size) {
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2932,9 +2932,9 @@ static void get_tcp4_sock(struct sock *s
 	} else if (icsk_pending == ICSK_TIME_PROBE0) {
 		timer_active	= 4;
 		timer_expires	= tcp_timeout_expires(sk);
-	} else if (timer_pending(&sk->sk_timer)) {
+	} else if (timer_pending(&icsk->icsk_keepalive_timer)) {
 		timer_active	= 2;
-		timer_expires	= sk->sk_timer.expires;
+		timer_expires	= icsk->icsk_keepalive_timer.expires;
 	} else {
 		timer_active	= 0;
 		timer_expires = jiffies;
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -759,12 +759,12 @@ EXPORT_IPV6_MOD(tcp_syn_ack_timeout);
 
 void tcp_reset_keepalive_timer(struct sock *sk, unsigned long len)
 {
-	sk_reset_timer(sk, &sk->sk_timer, jiffies + len);
+	sk_reset_timer(sk, &inet_csk(sk)->icsk_keepalive_timer, jiffies + len);
 }
 
 static void tcp_delete_keepalive_timer(struct sock *sk)
 {
-	sk_stop_timer(sk, &sk->sk_timer);
+	sk_stop_timer(sk, &inet_csk(sk)->icsk_keepalive_timer);
 }
 
 void tcp_set_keepalive(struct sock *sk, int val)
@@ -781,8 +781,9 @@ EXPORT_IPV6_MOD_GPL(tcp_set_keepalive);
 
 static void tcp_keepalive_timer(struct timer_list *t)
 {
-	struct sock *sk = timer_container_of(sk, t, sk_timer);
-	struct inet_connection_sock *icsk = inet_csk(sk);
+	struct inet_connection_sock *icsk =
+		timer_container_of(icsk, t, icsk_keepalive_timer);
+	struct sock *sk = &icsk->icsk_inet.sk;
 	struct tcp_sock *tp = tcp_sk(sk);
 	u32 elapsed;
 
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2204,9 +2204,9 @@ static void get_tcp6_sock(struct seq_fil
 	} else if (icsk_pending == ICSK_TIME_PROBE0) {
 		timer_active	= 4;
 		timer_expires	= tcp_timeout_expires(sp);
-	} else if (timer_pending(&sp->sk_timer)) {
+	} else if (timer_pending(&icsk->icsk_keepalive_timer)) {
 		timer_active	= 2;
-		timer_expires	= sp->sk_timer.expires;
+		timer_expires	= icsk->icsk_keepalive_timer.expires;
 	} else {
 		timer_active	= 0;
 		timer_expires = jiffies;
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2348,7 +2348,9 @@ static void mptcp_retransmit_timer(struc
 
 static void mptcp_tout_timer(struct timer_list *t)
 {
-	struct sock *sk = timer_container_of(sk, t, sk_timer);
+	struct inet_connection_sock *icsk =
+		timer_container_of(icsk, t, mptcp_tout_timer);
+	struct sock *sk = &icsk->icsk_inet.sk;
 
 	mptcp_schedule_work(sk);
 	sock_put(sk);
@@ -2804,7 +2806,7 @@ void mptcp_reset_tout_timer(struct mptcp
 	 */
 	timeout = inet_csk(sk)->icsk_mtup.probe_timestamp ? close_timeout : fail_tout;
 
-	sk_reset_timer(sk, &sk->sk_timer, timeout);
+	sk_reset_timer(sk, &inet_csk(sk)->mptcp_tout_timer, timeout);
 }
 
 static void mptcp_mp_fail_no_response(struct mptcp_sock *msk)
@@ -2935,7 +2937,7 @@ static void __mptcp_init_sock(struct soc
 
 	/* re-use the csk retrans timer for MPTCP-level retrans */
 	timer_setup(&msk->sk.icsk_retransmit_timer, mptcp_retransmit_timer, 0);
-	timer_setup(&sk->sk_timer, mptcp_tout_timer, 0);
+	timer_setup(&msk->sk.mptcp_tout_timer, mptcp_tout_timer, 0);
 }
 
 static void mptcp_ca_reset(struct sock *sk)
@@ -3137,7 +3139,7 @@ static void __mptcp_destroy_sock(struct
 	might_sleep();
 
 	mptcp_stop_rtx_timer(sk);
-	sk_stop_timer(sk, &sk->sk_timer);
+	sk_stop_timer(sk, &inet_csk(sk)->mptcp_tout_timer);
 	msk->pm.status = 0;
 	mptcp_release_sched(msk);
 
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -880,7 +880,7 @@ static inline void mptcp_stop_tout_timer
 	if (!inet_csk(sk)->icsk_mtup.probe_timestamp)
 		return;
 
-	sk_stop_timer(sk, &sk->sk_timer);
+	sk_stop_timer(sk, &inet_csk(sk)->mptcp_tout_timer);
 	inet_csk(sk)->icsk_mtup.probe_timestamp = 0;
 }
 
--- a/tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c
@@ -103,9 +103,9 @@ static int dump_tcp_sock(struct seq_file
 	} else if (icsk->icsk_pending == ICSK_TIME_PROBE0) {
 		timer_active = 4;
 		timer_expires = icsk->icsk_retransmit_timer.expires;
-	} else if (timer_pending(&sp->sk_timer)) {
+	} else if (timer_pending(&icsk->icsk_keepalive_timer)) {
 		timer_active = 2;
-		timer_expires = sp->sk_timer.expires;
+		timer_expires = icsk->icsk_keepalive_timer.expires;
 	} else {
 		timer_active = 0;
 		timer_expires = bpf_jiffies64();
--- a/tools/testing/selftests/bpf/progs/bpf_iter_tcp6.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_tcp6.c
@@ -103,9 +103,9 @@ static int dump_tcp6_sock(struct seq_fil
 	} else if (icsk->icsk_pending == ICSK_TIME_PROBE0) {
 		timer_active = 4;
 		timer_expires = icsk->icsk_retransmit_timer.expires;
-	} else if (timer_pending(&sp->sk_timer)) {
+	} else if (timer_pending(&icsk->icsk_keepalive_timer)) {
 		timer_active = 2;
-		timer_expires = sp->sk_timer.expires;
+		timer_expires = icsk->icsk_keepalive_timer.expires;
 	} else {
 		timer_active = 0;
 		timer_expires = bpf_jiffies64();


