Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F92B332628
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301225; cv=none; b=gV51PTEHxG5RkQ6IwuBjE83S99yFIGno6d3IusPT2+VJH8I+ZpdUlDujhVHFpbZ9Ets4SxwfV2y2IUe9PDlCFHHkjmOYVPvtYt3ihhcscDgHFvFGuM9xrwLaiYfkFOhU2+iQqfGdhGwt2EnQVjdZiPmtF7aRlFfw86HeMVSJNik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301225; c=relaxed/simple;
	bh=Wn5Wil5SZijED6HEpJr8NWNLSVhz3vk4CQ5JQd3wZ7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Unwdxk/VaVlHu424X73K3b0TpzQ7My6ZayQoj7RPGdmAOaXxRYXvbplRyj47j4fvLWKTUXtXwZGNby1aFQRwp4edbVuqUkbN//LikIBCY0cTKKIJ9fRoQD7iUyUANRUZt0HkQMEYaSfb0BxS25qCPqCFZwHPZQRqete/Ew6di40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QGNxI0XH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QGNxI0XH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89523C19423;
	Sat, 28 Feb 2026 17:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301225;
	bh=Wn5Wil5SZijED6HEpJr8NWNLSVhz3vk4CQ5JQd3wZ7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QGNxI0XHV9TbYD/lkhzlDpUckdB71I3BRJ74lW+haCmf9iRRWTFpr0XR3i2FwpDSB
	 J+WcB1xlDXVGd/v2zVzuMMAImJ94c38IGw+h5gp1EuKNGfuPD3sOpXC2rg361463la
	 Bd3aDxqzlN0sfaFIoj6r3B1YtJnROhVMnscE3qIrK8GJ4uQTRpFk6OJBFuCZYpT8nn
	 ddUGWGKOayDiCNsz0px/at3A0JN+m6T1nPZigK8pjL94XJgoJsJlVgpeclDz30g6++
	 3/gR15718lRQ+QBMVXZOrZ6UlHHGdh9hUTQJrxgaTDvwlNYLGcC9YuWYnpW/8QBFZf
	 Ds5zjbiEE1ltw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Eric Dumazet <edumazet@google.com>,
	syzbot+937b5bbb6a815b3e5d0b@syzkaller.appspotmail.com,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 402/752] tcp: fix potential race in tcp_v6_syn_recv_sock()
Date: Sat, 28 Feb 2026 12:41:53 -0500
Message-ID: <20260228174750.1542406-402-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 858d2a4f67ff69e645a43487ef7ea7f28f06deae ]

Code in tcp_v6_syn_recv_sock() after the call to tcp_v4_syn_recv_sock()
is done too late.

After tcp_v4_syn_recv_sock(), the child socket is already visible
from TCP ehash table and other cpus might use it.

Since newinet->pinet6 is still pointing to the listener ipv6_pinfo
bad things can happen as syzbot found.

Move the problematic code in tcp_v6_mapped_child_init()
and call this new helper from tcp_v4_syn_recv_sock() before
the ehash insertion.

This allows the removal of one tcp_sync_mss(), since
tcp_v4_syn_recv_sock() will call it with the correct
context.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+937b5bbb6a815b3e5d0b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/69949275.050a0220.2eeac1.0145.GAE@google.com/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260217161205.2079883-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_connection_sock.h |  4 +-
 include/net/tcp.h                  |  4 +-
 net/ipv4/syncookies.c              |  2 +-
 net/ipv4/tcp_fastopen.c            |  2 +-
 net/ipv4/tcp_ipv4.c                |  8 ++-
 net/ipv4/tcp_minisocks.c           |  2 +-
 net/ipv6/tcp_ipv6.c                | 98 +++++++++++++-----------------
 net/mptcp/subflow.c                |  6 +-
 net/smc/af_smc.c                   |  6 +-
 9 files changed, 66 insertions(+), 66 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index b4b8866476075..afec146b8bafd 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -42,7 +42,9 @@ struct inet_connection_sock_af_ops {
 				      struct request_sock *req,
 				      struct dst_entry *dst,
 				      struct request_sock *req_unhash,
-				      bool *own_req);
+				      bool *own_req,
+				      void (*opt_child_init)(struct sock *newsk,
+							     const struct sock *sk));
 	u16	    net_header_len;
 	int	    (*setsockopt)(struct sock *sk, int level, int optname,
 				  sockptr_t optval, unsigned int optlen);
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 3c84d95cdba81..aa4d24c42a270 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -528,7 +528,9 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 				  struct request_sock *req,
 				  struct dst_entry *dst,
 				  struct request_sock *req_unhash,
-				  bool *own_req);
+				  bool *own_req,
+				  void (*opt_child_init)(struct sock *newsk,
+							 const struct sock *sk));
 int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb);
 int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len);
 int tcp_connect(struct sock *sk);
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 569befcf021ba..061751aabc8e1 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -203,7 +203,7 @@ struct sock *tcp_get_cookie_sock(struct sock *sk, struct sk_buff *skb,
 	bool own_req;
 
 	child = icsk->icsk_af_ops->syn_recv_sock(sk, skb, req, dst,
-						 NULL, &own_req);
+						 NULL, &own_req, NULL);
 	if (child) {
 		refcount_set(&req->rsk_refcnt, 1);
 		sock_rps_save_rxhash(child, skb);
diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 7d945a527daf0..444306af444ae 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -247,7 +247,7 @@ static struct sock *tcp_fastopen_create_child(struct sock *sk,
 	bool own_req;
 
 	child = inet_csk(sk)->icsk_af_ops->syn_recv_sock(sk, skb, req, NULL,
-							 NULL, &own_req);
+							 NULL, &own_req, NULL);
 	if (!child)
 		return NULL;
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index b1fcf3e4e1ce0..0fbf13dcf3c2b 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1756,7 +1756,9 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 				  struct request_sock *req,
 				  struct dst_entry *dst,
 				  struct request_sock *req_unhash,
-				  bool *own_req)
+				  bool *own_req,
+				  void (*opt_child_init)(struct sock *newsk,
+							 const struct sock *sk))
 {
 	struct inet_request_sock *ireq;
 	bool found_dup_sk = false;
@@ -1808,6 +1810,10 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 	}
 	sk_setup_caps(newsk, dst);
 
+#if IS_ENABLED(CONFIG_IPV6)
+	if (opt_child_init)
+		opt_child_init(newsk, sk);
+#endif
 	tcp_ca_openreq_child(newsk, dst);
 
 	tcp_sync_mss(newsk, dst_mtu(dst));
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 1fade94813c62..95c30b6ec44cd 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -911,7 +911,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 	 * socket is created, wait for troubles.
 	 */
 	child = inet_csk(sk)->icsk_af_ops->syn_recv_sock(sk, skb, req, NULL,
-							 req, &own_req);
+							 req, &own_req, NULL);
 	if (!child)
 		goto listen_overflow;
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 0937d69658310..5faa46f4cf9a2 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1356,11 +1356,48 @@ static void tcp_v6_restore_cb(struct sk_buff *skb)
 		sizeof(struct inet6_skb_parm));
 }
 
+/* Called from tcp_v4_syn_recv_sock() for v6_mapped children. */
+static void tcp_v6_mapped_child_init(struct sock *newsk, const struct sock *sk)
+{
+	struct inet_sock *newinet = inet_sk(newsk);
+	struct ipv6_pinfo *newnp;
+
+	newinet->pinet6 = newnp = tcp_inet6_sk(newsk);
+	newinet->ipv6_fl_list = NULL;
+
+	memcpy(newnp, tcp_inet6_sk(sk), sizeof(struct ipv6_pinfo));
+
+	newnp->saddr = newsk->sk_v6_rcv_saddr;
+
+	inet_csk(newsk)->icsk_af_ops = &ipv6_mapped;
+	if (sk_is_mptcp(newsk))
+		mptcpv6_handle_mapped(newsk, true);
+	newsk->sk_backlog_rcv = tcp_v4_do_rcv;
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
+	tcp_sk(newsk)->af_specific = &tcp_sock_ipv6_mapped_specific;
+#endif
+
+	newnp->ipv6_mc_list = NULL;
+	newnp->ipv6_ac_list = NULL;
+	newnp->pktoptions  = NULL;
+	newnp->opt	   = NULL;
+
+	/* tcp_v4_syn_recv_sock() has initialized newinet->mc_{index,ttl} */
+	newnp->mcast_oif   = newinet->mc_index;
+	newnp->mcast_hops  = newinet->mc_ttl;
+
+	newnp->rcv_flowinfo = 0;
+	if (inet6_test_bit(REPFLOW, sk))
+		newnp->flow_label = 0;
+}
+
 static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 					 struct request_sock *req,
 					 struct dst_entry *dst,
 					 struct request_sock *req_unhash,
-					 bool *own_req)
+					 bool *own_req,
+					 void (*opt_child_init)(struct sock *newsk,
+								const struct sock *sk))
 {
 	struct inet_request_sock *ireq;
 	struct ipv6_pinfo *newnp;
@@ -1376,61 +1413,10 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 #endif
 	struct flowi6 fl6;
 
-	if (skb->protocol == htons(ETH_P_IP)) {
-		/*
-		 *	v6 mapped
-		 */
-
-		newsk = tcp_v4_syn_recv_sock(sk, skb, req, dst,
-					     req_unhash, own_req);
-
-		if (!newsk)
-			return NULL;
-
-		newinet = inet_sk(newsk);
-		newinet->pinet6 = tcp_inet6_sk(newsk);
-		newinet->ipv6_fl_list = NULL;
-
-		newnp = tcp_inet6_sk(newsk);
-		newtp = tcp_sk(newsk);
-
-		memcpy(newnp, np, sizeof(struct ipv6_pinfo));
-
-		newnp->saddr = newsk->sk_v6_rcv_saddr;
-
-		inet_csk(newsk)->icsk_af_ops = &ipv6_mapped;
-		if (sk_is_mptcp(newsk))
-			mptcpv6_handle_mapped(newsk, true);
-		newsk->sk_backlog_rcv = tcp_v4_do_rcv;
-#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
-		newtp->af_specific = &tcp_sock_ipv6_mapped_specific;
-#endif
-
-		newnp->ipv6_mc_list = NULL;
-		newnp->ipv6_ac_list = NULL;
-		newnp->pktoptions  = NULL;
-		newnp->opt	   = NULL;
-		newnp->mcast_oif   = inet_iif(skb);
-		newnp->mcast_hops  = ip_hdr(skb)->ttl;
-		newnp->rcv_flowinfo = 0;
-		if (inet6_test_bit(REPFLOW, sk))
-			newnp->flow_label = 0;
-
-		/*
-		 * No need to charge this sock to the relevant IPv6 refcnt debug socks count
-		 * here, tcp_create_openreq_child now does this for us, see the comment in
-		 * that function for the gory details. -acme
-		 */
-
-		/* It is tricky place. Until this moment IPv4 tcp
-		   worked with IPv6 icsk.icsk_af_ops.
-		   Sync it now.
-		 */
-		tcp_sync_mss(newsk, inet_csk(newsk)->icsk_pmtu_cookie);
-
-		return newsk;
-	}
-
+	if (skb->protocol == htons(ETH_P_IP))
+		return tcp_v4_syn_recv_sock(sk, skb, req, dst,
+					    req_unhash, own_req,
+					    tcp_v6_mapped_child_init);
 	ireq = inet_rsk(req);
 
 	if (sk_acceptq_is_full(sk))
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index a8c281bc53778..838203e2740e5 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -807,7 +807,9 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 					  struct request_sock *req,
 					  struct dst_entry *dst,
 					  struct request_sock *req_unhash,
-					  bool *own_req)
+					  bool *own_req,
+					  void (*opt_child_init)(struct sock *newsk,
+								 const struct sock *sk))
 {
 	struct mptcp_subflow_context *listener = mptcp_subflow_ctx(sk);
 	struct mptcp_subflow_request_sock *subflow_req;
@@ -854,7 +856,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 
 create_child:
 	child = listener->icsk_af_ops->syn_recv_sock(sk, skb, req, dst,
-						     req_unhash, own_req);
+						     req_unhash, own_req, opt_child_init);
 
 	if (child && *own_req) {
 		struct mptcp_subflow_context *ctx = mptcp_subflow_ctx(child);
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 77b99e8ef35a4..efdadb2d8d390 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -124,7 +124,9 @@ static struct sock *smc_tcp_syn_recv_sock(const struct sock *sk,
 					  struct request_sock *req,
 					  struct dst_entry *dst,
 					  struct request_sock *req_unhash,
-					  bool *own_req)
+					  bool *own_req,
+					  void (*opt_child_init)(struct sock *newsk,
+								 const struct sock *sk))
 {
 	struct smc_sock *smc;
 	struct sock *child;
@@ -142,7 +144,7 @@ static struct sock *smc_tcp_syn_recv_sock(const struct sock *sk,
 
 	/* passthrough to original syn recv sock fct */
 	child = smc->ori_af_ops->syn_recv_sock(sk, skb, req, dst, req_unhash,
-					       own_req);
+					       own_req, opt_child_init);
 	/* child must not inherit smc or its ops */
 	if (child) {
 		rcu_assign_sk_user_data(child, NULL);
-- 
2.51.0

