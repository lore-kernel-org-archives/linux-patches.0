Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF0D187FED;
	Tue, 30 Jul 2024 16:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355367; cv=none; b=Er2K8nMZ1lfzIEqx6Gpn9WzVe9GDCu2ptiyKSwq45hMxkd2sfbDQWMgjd8GdKgw3cI5nv/Ods/WqWOd/GuYfUJhB/C/255a/HhuDvxCQffGQh/2Xi6YPYcjsMWYu4GCMVgocHVqFSqrw3407RL4dHmoX4KdGgPg4cA50JPXdIy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355367; c=relaxed/simple;
	bh=GTepVtNejsySncP+9NV3lGHaiHy2lbl7w2nNDalrKtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=as6pnjvaYp57sAT8mBv8PP5DkTLHee3/29Lc2WIgRQ+cgyFeN4l+N5VzPwiW1cyFniKgTJfg9r7yRvGBnv8Rk+Coj8+GVrwdAmKujvR9l1BSbW/3IIovlMDW5B1WSdX36GqKvd5BBoiiB0Jv0bOQR5J0nDTkG7H7nBmO86fWj8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R2w+JzeP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R2w+JzeP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB6BC32782;
	Tue, 30 Jul 2024 16:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355367;
	bh=GTepVtNejsySncP+9NV3lGHaiHy2lbl7w2nNDalrKtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R2w+JzeP0yJESQZcpnV2HAdncHcDdrE/5tT1ziLZjhL6CjX62QHY6D7d6P48CHFeG
	 whvQBgW9IyVpOcdzIno+l5hI8bCgekzkXtW7pQJSgHWJBsaDzvPlaAa+H3aHr7pVmA
	 g0HkO/Gi6KF0dSqTyhiMbMsuGSgunCZ7WbVKLVFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 087/440] tcp: annotate lockless access to sk->sk_err
Date: Tue, 30 Jul 2024 17:45:20 +0200
Message-ID: <20240730151619.158655615@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2d4f697d338f5..7e162a34baec2 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -591,7 +591,8 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 	}
 	/* This barrier is coupled with smp_wmb() in tcp_reset() */
 	smp_rmb();
-	if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
+	if (READ_ONCE(sk->sk_err) ||
+	    !skb_queue_empty_lockless(&sk->sk_error_queue))
 		mask |= EPOLLERR;
 
 	return mask;
@@ -3119,7 +3120,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	if (old_state == TCP_LISTEN) {
 		inet_csk_listen_stop(sk);
 	} else if (unlikely(tp->repair)) {
-		sk->sk_err = ECONNABORTED;
+		WRITE_ONCE(sk->sk_err, ECONNABORTED);
 	} else if (tcp_need_reset(old_state) ||
 		   (tp->snd_nxt != tp->write_seq &&
 		    (1 << old_state) & (TCPF_CLOSING | TCPF_LAST_ACK))) {
@@ -3127,9 +3128,9 @@ int tcp_disconnect(struct sock *sk, int flags)
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
@@ -4735,7 +4736,7 @@ int tcp_abort(struct sock *sk, int err)
 	bh_lock_sock(sk);
 
 	if (!sock_flag(sk, SOCK_DEAD)) {
-		sk->sk_err = err;
+		WRITE_ONCE(sk->sk_err, err);
 		/* This barrier is coupled with smp_rmb() in tcp_poll() */
 		smp_wmb();
 		sk_error_report(sk);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index fa15c6951cd78..d72255e5262b3 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4370,15 +4370,15 @@ void tcp_reset(struct sock *sk, struct sk_buff *skb)
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
index 8fbb6deed3216..16098fcafde2b 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -603,7 +603,7 @@ int tcp_v4_err(struct sk_buff *skb, u32 info)
 		ip_icmp_error(sk, skb, err, th->dest, info, (u8 *)th);
 
 		if (!sock_owned_by_user(sk)) {
-			sk->sk_err = err;
+			WRITE_ONCE(sk->sk_err, err);
 
 			sk_error_report(sk);
 
@@ -632,7 +632,7 @@ int tcp_v4_err(struct sk_buff *skb, u32 info)
 
 	inet = inet_sk(sk);
 	if (!sock_owned_by_user(sk) && inet->recverr) {
-		sk->sk_err = err;
+		WRITE_ONCE(sk->sk_err, err);
 		sk_error_report(sk);
 	} else	{ /* Only an error on timeout */
 		WRITE_ONCE(sk->sk_err_soft, err);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 15f814c1e1693..19b5a6179c061 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3764,7 +3764,7 @@ static void tcp_connect_init(struct sock *sk)
 	tp->rx_opt.rcv_wscale = rcv_wscale;
 	tp->rcv_ssthresh = tp->rcv_wnd;
 
-	sk->sk_err = 0;
+	WRITE_ONCE(sk->sk_err, 0);
 	sock_reset_flag(sk, SOCK_DONE);
 	tp->snd_wnd = 0;
 	tcp_init_wl(tp, 0);
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index fe23a427f6a9d..117fc7031bc10 100644
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
index 848175e0be081..35bfca93af6ad 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -493,7 +493,7 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 		ipv6_icmp_error(sk, skb, err, th->dest, ntohl(info), (u8 *)th);
 
 		if (!sock_owned_by_user(sk)) {
-			sk->sk_err = err;
+			WRITE_ONCE(sk->sk_err, err);
 			sk_error_report(sk);		/* Wake people up to see the error (see connect in sock.c) */
 
 			tcp_done(sk);
@@ -513,7 +513,7 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	}
 
 	if (!sock_owned_by_user(sk) && np->recverr) {
-		sk->sk_err = err;
+		WRITE_ONCE(sk->sk_err, err);
 		sk_error_report(sk);
 	} else {
 		WRITE_ONCE(sk->sk_err_soft, err);
-- 
2.43.0



