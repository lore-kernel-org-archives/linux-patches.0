Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E045F1E871;
	Fri,  6 Dec 2024 15:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497274; cv=none; b=QBbl2nK5pXyfQXaEbdNFFZbByV0PHHLjj2Vye1e1d6If4ZF+R4RXdyOQ6qIEHJehHQtaBai5wBK0+aEKxUFlLZJvegIGtvQ2U4LUOJyd9cR0TQdckfWnG1+qoFjLhVjmZ80/YTETsdbG8ciTIT1sn8tKDbcJllxOwASEcP6iSlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497274; c=relaxed/simple;
	bh=UTlUjbh6pQHPLj3iG14rOnf6EbFoeHoHSON52BgXgwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MnHqpYnw+j2yo2N3RvgU84L9Tw3bymuiJbY3VBG+/oILJ3l/DdCVsO00UOzy8AoGOfW4WwEn8lS5vYRlDUecaISiiCGAuDEYKfIRwie9UtDyK32o4vl6N5KSAMZUPSpYpCncRYWNtB3yiP8Ku2gdlnJpl2/hDkv60gtQKAyNMbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WiQS9HDH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WiQS9HDH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE92C4CED1;
	Fri,  6 Dec 2024 15:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497273;
	bh=UTlUjbh6pQHPLj3iG14rOnf6EbFoeHoHSON52BgXgwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WiQS9HDHJrgHUi7CDQN7GoJTNPXNTsYUtCgBzqfV8Dg8XEoy4AsGmX3JJo6lk8uP+
	 91UJLw9PItEEvFS7iYyZaKbXYaEdbGFyUAEBS19KA1eI9K0cdTyu99Qtl4ynNxZ4MN
	 q0y0lva2DESCFPjJT0AqyGHlr8Mnaz7OgS80B9m8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 243/676] net: use unrcu_pointer() helper
Date: Fri,  6 Dec 2024 15:31:02 +0100
Message-ID: <20241206143702.822958315@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b4cb4a1391dcdc640c4ade003aaf0ee19cc8d509 ]

Toke mentioned unrcu_pointer() existence, allowing
to remove some of the ugly casts we have when using
xchg() for rcu protected pointers.

Also make inet_rcv_compat const.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Toke Høiland-Jørgensen <toke@redhat.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/r/20240604111603.45871-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: eb02688c5c45 ("ipv6: release nexthop on device removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h       | 2 +-
 net/core/gen_estimator.c | 2 +-
 net/core/sock_diag.c     | 8 +++-----
 net/ipv4/cipso_ipv4.c    | 2 +-
 net/ipv4/tcp.c           | 2 +-
 net/ipv4/tcp_fastopen.c  | 7 ++++---
 net/ipv4/udp.c           | 2 +-
 net/ipv6/af_inet6.c      | 2 +-
 net/ipv6/ip6_fib.c       | 2 +-
 net/ipv6/ipv6_sockglue.c | 3 +--
 net/ipv6/route.c         | 6 +++---
 net/sched/act_api.c      | 2 +-
 12 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index e0be8bd983960..a6b795ec7c9cb 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2219,7 +2219,7 @@ sk_dst_set(struct sock *sk, struct dst_entry *dst)
 
 	sk_tx_queue_clear(sk);
 	WRITE_ONCE(sk->sk_dst_pending_confirm, 0);
-	old_dst = xchg((__force struct dst_entry **)&sk->sk_dst_cache, dst);
+	old_dst = unrcu_pointer(xchg(&sk->sk_dst_cache, RCU_INITIALIZER(dst)));
 	dst_release(old_dst);
 }
 
diff --git a/net/core/gen_estimator.c b/net/core/gen_estimator.c
index fae9c4694186e..412816076b8bc 100644
--- a/net/core/gen_estimator.c
+++ b/net/core/gen_estimator.c
@@ -206,7 +206,7 @@ void gen_kill_estimator(struct net_rate_estimator __rcu **rate_est)
 {
 	struct net_rate_estimator *est;
 
-	est = xchg((__force struct net_rate_estimator **)rate_est, NULL);
+	est = unrcu_pointer(xchg(rate_est, NULL));
 	if (est) {
 		timer_shutdown_sync(&est->timer);
 		kfree_rcu(est, rcu);
diff --git a/net/core/sock_diag.c b/net/core/sock_diag.c
index 5c3666431df49..70007fc578a13 100644
--- a/net/core/sock_diag.c
+++ b/net/core/sock_diag.c
@@ -18,7 +18,7 @@
 
 static const struct sock_diag_handler __rcu *sock_diag_handlers[AF_MAX];
 
-static struct sock_diag_inet_compat __rcu *inet_rcv_compat;
+static const struct sock_diag_inet_compat __rcu *inet_rcv_compat;
 
 static struct workqueue_struct *broadcast_wq;
 
@@ -187,8 +187,7 @@ void sock_diag_broadcast_destroy(struct sock *sk)
 
 void sock_diag_register_inet_compat(const struct sock_diag_inet_compat *ptr)
 {
-	xchg((__force const struct sock_diag_inet_compat **)&inet_rcv_compat,
-	     ptr);
+	xchg(&inet_rcv_compat, RCU_INITIALIZER(ptr));
 }
 EXPORT_SYMBOL_GPL(sock_diag_register_inet_compat);
 
@@ -196,8 +195,7 @@ void sock_diag_unregister_inet_compat(const struct sock_diag_inet_compat *ptr)
 {
 	const struct sock_diag_inet_compat *old;
 
-	old = xchg((__force const struct sock_diag_inet_compat **)&inet_rcv_compat,
-		   NULL);
+	old = unrcu_pointer(xchg(&inet_rcv_compat, NULL));
 	WARN_ON_ONCE(old != ptr);
 }
 EXPORT_SYMBOL_GPL(sock_diag_unregister_inet_compat);
diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 685474ef11c40..8daa6418e25a0 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -1955,7 +1955,7 @@ int cipso_v4_req_setattr(struct request_sock *req,
 	buf = NULL;
 
 	req_inet = inet_rsk(req);
-	opt = xchg((__force struct ip_options_rcu **)&req_inet->ireq_opt, opt);
+	opt = unrcu_pointer(xchg(&req_inet->ireq_opt, RCU_INITIALIZER(opt)));
 	if (opt)
 		kfree_rcu(opt, rcu);
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 75371928d94f6..5e6615f69f175 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3065,7 +3065,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	icsk->icsk_ack.rcv_mss = TCP_MIN_MSS;
 	memset(&tp->rx_opt, 0, sizeof(tp->rx_opt));
 	__sk_dst_reset(sk);
-	dst_release(xchg((__force struct dst_entry **)&sk->sk_rx_dst, NULL));
+	dst_release(unrcu_pointer(xchg(&sk->sk_rx_dst, NULL)));
 	tcp_saved_syn_free(tp);
 	tp->compressed_ack = 0;
 	tp->segs_in = 0;
diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 8ed54e7334a9c..0f523cbfe329e 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -49,7 +49,7 @@ void tcp_fastopen_ctx_destroy(struct net *net)
 {
 	struct tcp_fastopen_context *ctxt;
 
-	ctxt = xchg((__force struct tcp_fastopen_context **)&net->ipv4.tcp_fastopen_ctx, NULL);
+	ctxt = unrcu_pointer(xchg(&net->ipv4.tcp_fastopen_ctx, NULL));
 
 	if (ctxt)
 		call_rcu(&ctxt->rcu, tcp_fastopen_ctx_free);
@@ -80,9 +80,10 @@ int tcp_fastopen_reset_cipher(struct net *net, struct sock *sk,
 
 	if (sk) {
 		q = &inet_csk(sk)->icsk_accept_queue.fastopenq;
-		octx = xchg((__force struct tcp_fastopen_context **)&q->ctx, ctx);
+		octx = unrcu_pointer(xchg(&q->ctx, RCU_INITIALIZER(ctx)));
 	} else {
-		octx = xchg((__force struct tcp_fastopen_context **)&net->ipv4.tcp_fastopen_ctx, ctx);
+		octx = unrcu_pointer(xchg(&net->ipv4.tcp_fastopen_ctx,
+					  RCU_INITIALIZER(ctx)));
 	}
 
 	if (octx)
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 73fb814460b6b..2e4e535603948 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2232,7 +2232,7 @@ bool udp_sk_rx_dst_set(struct sock *sk, struct dst_entry *dst)
 	struct dst_entry *old;
 
 	if (dst_hold_safe(dst)) {
-		old = xchg((__force struct dst_entry **)&sk->sk_rx_dst, dst);
+		old = unrcu_pointer(xchg(&sk->sk_rx_dst, RCU_INITIALIZER(dst)));
 		dst_release(old);
 		return old != dst;
 	}
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index b9c50cceba568..99843eb4d49b9 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -507,7 +507,7 @@ void inet6_cleanup_sock(struct sock *sk)
 
 	/* Free tx options */
 
-	opt = xchg((__force struct ipv6_txoptions **)&np->opt, NULL);
+	opt = unrcu_pointer(xchg(&np->opt, NULL));
 	if (opt) {
 		atomic_sub(opt->tot_len, &sk->sk_omem_alloc);
 		txopt_put(opt);
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 4356806b52bd5..afa9073567dc4 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -982,7 +982,7 @@ static void __fib6_drop_pcpu_from(struct fib6_nh *fib6_nh,
 		if (pcpu_rt && rcu_access_pointer(pcpu_rt->from) == match) {
 			struct fib6_info *from;
 
-			from = xchg((__force struct fib6_info **)&pcpu_rt->from, NULL);
+			from = unrcu_pointer(xchg(&pcpu_rt->from, NULL));
 			fib6_info_release(from);
 		}
 	}
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 0e2a0847b387f..f106b19b74dd7 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -111,8 +111,7 @@ struct ipv6_txoptions *ipv6_update_options(struct sock *sk,
 			icsk->icsk_sync_mss(sk, icsk->icsk_pmtu_cookie);
 		}
 	}
-	opt = xchg((__force struct ipv6_txoptions **)&inet6_sk(sk)->opt,
-		   opt);
+	opt = unrcu_pointer(xchg(&inet6_sk(sk)->opt, RCU_INITIALIZER(opt)));
 	sk_dst_reset(sk);
 
 	return opt;
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index a9104c4c1c02d..341a42c2d6f14 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -368,7 +368,7 @@ static void ip6_dst_destroy(struct dst_entry *dst)
 		in6_dev_put(idev);
 	}
 
-	from = xchg((__force struct fib6_info **)&rt->from, NULL);
+	from = unrcu_pointer(xchg(&rt->from, NULL));
 	fib6_info_release(from);
 }
 
@@ -1430,7 +1430,7 @@ static struct rt6_info *rt6_make_pcpu_route(struct net *net,
 	if (res->f6i->fib6_destroying) {
 		struct fib6_info *from;
 
-		from = xchg((__force struct fib6_info **)&pcpu_rt->from, NULL);
+		from = unrcu_pointer(xchg(&pcpu_rt->from, NULL));
 		fib6_info_release(from);
 	}
 
@@ -1459,7 +1459,7 @@ static void rt6_remove_exception(struct rt6_exception_bucket *bucket,
 	/* purge completely the exception to allow releasing the held resources:
 	 * some [sk] cache may keep the dst around for unlimited time
 	 */
-	from = xchg((__force struct fib6_info **)&rt6_ex->rt6i->from, NULL);
+	from = unrcu_pointer(xchg(&rt6_ex->rt6i->from, NULL));
 	fib6_info_release(from);
 	dst_dev_put(&rt6_ex->rt6i->dst);
 
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 4572aa6e0273f..e509ac28c4929 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -62,7 +62,7 @@ static void tcf_set_action_cookie(struct tc_cookie __rcu **old_cookie,
 {
 	struct tc_cookie *old;
 
-	old = xchg((__force struct tc_cookie **)old_cookie, new_cookie);
+	old = unrcu_pointer(xchg(old_cookie, RCU_INITIALIZER(new_cookie)));
 	if (old)
 		call_rcu(&old->rcu, tcf_free_cookie_rcu);
 }
-- 
2.43.0



