Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B63A1714A8;
	Thu, 15 Aug 2024 13:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729285; cv=none; b=HV+UVUzNOYKCk3UtSwwWRU9VxOau+dG/4fyUiAZcI41Gvmrbdd7NI+1z/VHaMDng5fwlYCRVufyhi7titl3Q89Cs5U/eVciTdcRVTErzdcL6VE8UsYczGl21fhSxVVk3XhmlEnKEBVoWLQAdy7nA09RunXTxi5OVREOzpyfI5WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729285; c=relaxed/simple;
	bh=VDcfrurUrzbNz5+xXwvJPbC/Ln8L8Kf5s8dHYDOIgEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i220AcydJWy4al7q2h8DMniDdpXXVgx67rfIrNCWsiHluVURgdfcC6VVNKMC6GkVlbdMc5m9pdiwt0qULhUGT8O28pmuMQDUWSGybGQcsdY3i25wtlJlC0RT9/Xyaj6NHSqcmq1bngHCtG6nB3TX3zQZaJjUTdV7JwlrPjp08ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TvfK4zS9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TvfK4zS9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA34FC4AF0A;
	Thu, 15 Aug 2024 13:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729285;
	bh=VDcfrurUrzbNz5+xXwvJPbC/Ln8L8Kf5s8dHYDOIgEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TvfK4zS9D7VqbYhSMwur7+hGMPPpe67LbPyhrb91zlsR4wqmS0mn28SHY3m9Twc6B
	 VgyHIJrSF/qj/f95P5NjSLJBmdgfrVFB6AY6UQ5Pu+En57uaFGpzQmX85le0+6bN8f
	 9DP152m8jnvHoSrb6t/UF7EFCVabjw7p/XuUYd/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/484] tcp: annotate lockless access to sk->sk_err
Date: Thu, 15 Aug 2024 15:18:27 +0200
Message-ID: <20240815131943.175508557@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e13ec3da05d130f0d10da8e1fbe1be26dcdb0e27 ]

tcp_poll() reads sk->sk_err without socket lock held/owned.

We should used READ_ONCE() here, and update writers
to use WRITE_ONCE().

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 853c3bd7b791 ("tcp: fix race in tcp_write_err()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c        | 11 ++++++-----
 net/ipv4/tcp_input.c  |  6 +++---
 net/ipv4/tcp_ipv4.c   |  4 ++--
 net/ipv4/tcp_output.c |  2 +-
 net/ipv4/tcp_timer.c  |  2 +-
 net/ipv6/tcp_ipv6.c   |  4 ++--
 6 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index c1602b36dee42..db3bfe1a8443c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -594,7 +594,8 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 	}
 	/* This barrier is coupled with smp_wmb() in tcp_reset() */
 	smp_rmb();
-	if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
+	if (READ_ONCE(sk->sk_err) ||
+	    !skb_queue_empty_lockless(&sk->sk_error_queue))
 		mask |= EPOLLERR;
 
 	return mask;
@@ -2995,7 +2996,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	if (old_state == TCP_LISTEN) {
 		inet_csk_listen_stop(sk);
 	} else if (unlikely(tp->repair)) {
-		sk->sk_err = ECONNABORTED;
+		WRITE_ONCE(sk->sk_err, ECONNABORTED);
 	} else if (tcp_need_reset(old_state) ||
 		   (tp->snd_nxt != tp->write_seq &&
 		    (1 << old_state) & (TCPF_CLOSING | TCPF_LAST_ACK))) {
@@ -3003,9 +3004,9 @@ int tcp_disconnect(struct sock *sk, int flags)
 		 * states
 		 */
 		tcp_send_active_reset(sk, gfp_any());
-		sk->sk_err = ECONNRESET;
+		WRITE_ONCE(sk->sk_err, ECONNRESET);
 	} else if (old_state == TCP_SYN_SENT)
-		sk->sk_err = ECONNRESET;
+		WRITE_ONCE(sk->sk_err, ECONNRESET);
 
 	tcp_clear_xmit_timers(sk);
 	__skb_queue_purge(&sk->sk_receive_queue);
@@ -4513,7 +4514,7 @@ int tcp_abort(struct sock *sk, int err)
 	bh_lock_sock(sk);
 
 	if (!sock_flag(sk, SOCK_DEAD)) {
-		sk->sk_err = err;
+		WRITE_ONCE(sk->sk_err, err);
 		/* This barrier is coupled with smp_rmb() in tcp_poll() */
 		smp_wmb();
 		sk_error_report(sk);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index d3273d6dce7e9..bb20ae8dba09b 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4362,15 +4362,15 @@ void tcp_reset(struct sock *sk, struct sk_buff *skb)
 	/* We want the right error as BSD sees it (and indeed as we do). */
 	switch (sk->sk_state) {
 	case TCP_SYN_SENT:
-		sk->sk_err = ECONNREFUSED;
+		WRITE_ONCE(sk->sk_err, ECONNREFUSED);
 		break;
 	case TCP_CLOSE_WAIT:
-		sk->sk_err = EPIPE;
+		WRITE_ONCE(sk->sk_err, EPIPE);
 		break;
 	case TCP_CLOSE:
 		return;
 	default:
-		sk->sk_err = ECONNRESET;
+		WRITE_ONCE(sk->sk_err, ECONNRESET);
 	}
 	/* This barrier is coupled with smp_rmb() in tcp_poll() */
 	smp_wmb();
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 901c873fbaf5a..a1ed81ff9a81d 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -593,7 +593,7 @@ int tcp_v4_err(struct sk_buff *skb, u32 info)
 		ip_icmp_error(sk, skb, err, th->dest, info, (u8 *)th);
 
 		if (!sock_owned_by_user(sk)) {
-			sk->sk_err = err;
+			WRITE_ONCE(sk->sk_err, err);
 
 			sk_error_report(sk);
 
@@ -622,7 +622,7 @@ int tcp_v4_err(struct sk_buff *skb, u32 info)
 
 	inet = inet_sk(sk);
 	if (!sock_owned_by_user(sk) && inet->recverr) {
-		sk->sk_err = err;
+		WRITE_ONCE(sk->sk_err, err);
 		sk_error_report(sk);
 	} else	{ /* Only an error on timeout */
 		WRITE_ONCE(sk->sk_err_soft, err);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 0fb84e57a2d49..2c9670c832020 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3724,7 +3724,7 @@ static void tcp_connect_init(struct sock *sk)
 	tp->rx_opt.rcv_wscale = rcv_wscale;
 	tp->rcv_ssthresh = tp->rcv_wnd;
 
-	sk->sk_err = 0;
+	WRITE_ONCE(sk->sk_err, 0);
 	sock_reset_flag(sk, SOCK_DONE);
 	tp->snd_wnd = 0;
 	tcp_init_wl(tp, 0);
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 1a26130807f73..ed01b775b8947 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -67,7 +67,7 @@ u32 tcp_clamp_probe0_to_user_timeout(const struct sock *sk, u32 when)
 
 static void tcp_write_err(struct sock *sk)
 {
-	sk->sk_err = READ_ONCE(sk->sk_err_soft) ? : ETIMEDOUT;
+	WRITE_ONCE(sk->sk_err, READ_ONCE(sk->sk_err_soft) ? : ETIMEDOUT);
 	sk_error_report(sk);
 
 	tcp_write_queue_purge(sk);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index afdaa2e3cb6ef..c9aee34ae469f 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -486,7 +486,7 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 		ipv6_icmp_error(sk, skb, err, th->dest, ntohl(info), (u8 *)th);
 
 		if (!sock_owned_by_user(sk)) {
-			sk->sk_err = err;
+			WRITE_ONCE(sk->sk_err, err);
 			sk_error_report(sk);		/* Wake people up to see the error (see connect in sock.c) */
 
 			tcp_done(sk);
@@ -506,7 +506,7 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	}
 
 	if (!sock_owned_by_user(sk) && np->recverr) {
-		sk->sk_err = err;
+		WRITE_ONCE(sk->sk_err, err);
 		sk_error_report(sk);
 	} else {
 		WRITE_ONCE(sk->sk_err_soft, err);
-- 
2.43.0



