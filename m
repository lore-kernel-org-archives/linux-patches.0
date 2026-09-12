Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B52315785;
	Sat, 12 Sep 2026 13:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221101; cv=none; b=ZBM5QN1iVo2waKX9KWtg/E08gMzj04nJaiuwdUwivHX1PmDzw3uYSG56rbjDdL16556hWizdP26q6I4WfrBb1xWgfrjf9MTeSE3Pj7czzw9Mm9uNxyLJu7pk2OUUCHqICNMfd1XXYhk9yNWZZeEMWSzbKS3L3lxjssSa4aXKWUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221101; c=relaxed/simple;
	bh=M8jE0aDd6DAEJXawaGA5Tac+vc7/ibmbaZ3RvfIRuEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9Do5iiypQ1QE9Hddai1k0D8QyH47mL0mzEEWIrJK0wDCuVeSKL6nEDJ4S7ydfk8MnsyRTJQyhXcAcwF6Ssv+O6SiBO26CMQQNVv1//eDN8h10fvZDkRaD8SyQ5LmEDMxXH5HDUzZnuIeVL90DWGwM0u52AbZZmWb1T5/aafU44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XhMFEBwM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XhMFEBwM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028001F000FF;
	Sat, 12 Sep 2026 13:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221100;
	bh=xdS23kkutuhPNx2pjpiSjFfXthAseXYVD1GOBMEfys8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XhMFEBwMUACFu3diLBjhvZBQ0lqVJ3kfAvhPpxxLaPjNH1kLsX53Py3rg960XTyxO
	 Ny6Vs1Z3VJo4atJtfSH9iWr53yOAB0q1FiJGi/eJGZCCUaoRyfTgRUqkerYu+4vHzP
	 +OBCbAz7qo0Tx8Y4oAFY9SArBcQTTH1A69x5em88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+937b5bbb6a815b3e5d0b@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0315/1424] tcp: fix potential race in tcp_v6_syn_recv_sock()
Date: Sat, 12 Sep 2026 08:45:47 +0200
Message-ID: <20260912065614.338311138@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

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

[florian:
 - net/ipv6/tcp_ipv6.c:
   - Set `newnp->ipv6_fl_list = NULL` instead of `newinet->ipv6_fl_list = NULL`,
     as `ipv6_fl_list` is in `struct ipv6_pinfo`.
   - Guarded `af_specific` assignment with `#ifdef CONFIG_TCP_MD5SIG` instead
     of checking `CONFIG_TCP_AO`.
   - Used `if (tcp_inet6_sk(sk)->repflow)` instead of `inet6_test_bit(REPFLOW, sk)`.
 - net/dccp/:
   - Updated `syn_recv_sock` implementations and call sites for DCCP, which was
     removed in upstream kernels prior to this commit.]

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+937b5bbb6a815b3e5d0b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/69949275.050a0220.2eeac1.0145.GAE@google.com/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260217161205.2079883-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Assisted-by: Cursor:gemini-3.7-flash
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_connection_sock.h |  4 +-
 include/net/tcp.h                  |  4 +-
 net/dccp/dccp.h                    |  4 +-
 net/dccp/ipv4.c                    |  4 +-
 net/dccp/ipv6.c                    |  7 ++-
 net/dccp/minisocks.c               |  2 +-
 net/ipv4/syncookies.c              |  2 +-
 net/ipv4/tcp_fastopen.c            |  2 +-
 net/ipv4/tcp_ipv4.c                |  8 ++-
 net/ipv4/tcp_minisocks.c           |  2 +-
 net/ipv6/tcp_ipv6.c                | 97 +++++++++++++-----------------
 net/mptcp/subflow.c                |  6 +-
 net/smc/af_smc.c                   |  6 +-
 13 files changed, 78 insertions(+), 70 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 3eb715f66cbf6..b7935e2937577 100644
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
 	u16	    net_frag_header_len;
 	u16	    sockaddr_len;
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 23d830a7a6c82..7392f51a3479b 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -461,7 +461,9 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
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
diff --git a/net/dccp/dccp.h b/net/dccp/dccp.h
index 1f748ed1279d3..e4e055493203a 100644
--- a/net/dccp/dccp.h
+++ b/net/dccp/dccp.h
@@ -267,7 +267,9 @@ struct sock *dccp_v4_request_recv_sock(const struct sock *sk, struct sk_buff *sk
 				       struct request_sock *req,
 				       struct dst_entry *dst,
 				       struct request_sock *req_unhash,
-				       bool *own_req);
+				       bool *own_req,
+				       void (*opt_child_init)(struct sock *newsk,
+							      const struct sock *sk));
 struct sock *dccp_check_req(struct sock *sk, struct sk_buff *skb,
 			    struct request_sock *req);
 
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index ca31c3b096bbf..41667dcb66022 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -409,7 +409,9 @@ struct sock *dccp_v4_request_recv_sock(const struct sock *sk,
 				       struct request_sock *req,
 				       struct dst_entry *dst,
 				       struct request_sock *req_unhash,
-				       bool *own_req)
+				       bool *own_req,
+				       void (*opt_child_init)(struct sock *newsk,
+							      const struct sock *sk))
 {
 	struct inet_request_sock *ireq;
 	struct inet_sock *newinet;
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 2839ca8053ba6..ae617bd8afab8 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -417,7 +417,9 @@ static struct sock *dccp_v6_request_recv_sock(const struct sock *sk,
 					      struct request_sock *req,
 					      struct dst_entry *dst,
 					      struct request_sock *req_unhash,
-					      bool *own_req)
+					      bool *own_req,
+					      void (*opt_child_init)(struct sock *newsk,
+								     const struct sock *sk))
 {
 	struct inet_request_sock *ireq = inet_rsk(req);
 	struct ipv6_pinfo *newnp;
@@ -432,7 +434,8 @@ static struct sock *dccp_v6_request_recv_sock(const struct sock *sk,
 		 *	v6 mapped
 		 */
 		newsk = dccp_v4_request_recv_sock(sk, skb, req, dst,
-						  req_unhash, own_req);
+						  req_unhash, own_req,
+						  opt_child_init);
 		if (newsk == NULL)
 			return NULL;
 
diff --git a/net/dccp/minisocks.c b/net/dccp/minisocks.c
index 64d805b27adde..0210d38442ec8 100644
--- a/net/dccp/minisocks.c
+++ b/net/dccp/minisocks.c
@@ -193,7 +193,7 @@ struct sock *dccp_check_req(struct sock *sk, struct sk_buff *skb,
 		 goto drop;
 
 	child = inet_csk(sk)->icsk_af_ops->syn_recv_sock(sk, skb, req, NULL,
-							 req, &own_req);
+							 req, &own_req, NULL);
 	if (child) {
 		child = inet_csk_complete_hashdance(sk, child, req, own_req);
 		goto out;
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index e143562077958..9deeb3f8215ea 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -199,7 +199,7 @@ struct sock *tcp_get_cookie_sock(struct sock *sk, struct sk_buff *skb,
 	bool own_req;
 
 	child = icsk->icsk_af_ops->syn_recv_sock(sk, skb, req, dst,
-						 NULL, &own_req);
+						 NULL, &own_req, NULL);
 	if (child) {
 		refcount_set(&req->rsk_refcnt, 1);
 		tcp_sk(child)->tsoffset = tsoff;
diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 86c995dc1c5e5..e874ec597014d 100644
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
index 3055478860c19..638303d6691eb 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1567,7 +1567,9 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
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
@@ -1623,6 +1625,10 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 	}
 	sk_setup_caps(newsk, dst);
 
+#if IS_ENABLED(CONFIG_IPV6)
+	if (opt_child_init)
+		opt_child_init(newsk, sk);
+#endif
 	tcp_ca_openreq_child(newsk, dst);
 
 	tcp_sync_mss(newsk, dst_mtu(dst));
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 86f0feb2497f1..d6d64697ce896 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -817,7 +817,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 	 * socket is created, wait for troubles.
 	 */
 	child = inet_csk(sk)->icsk_af_ops->syn_recv_sock(sk, skb, req, NULL,
-							 req, &own_req);
+							 req, &own_req, NULL);
 	if (!child)
 		goto listen_overflow;
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 689c0b383ebf9..f13fdd1214aaa 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1180,11 +1180,48 @@ static void tcp_v6_restore_cb(struct sk_buff *skb)
 		sizeof(struct inet6_skb_parm));
 }
 
+/* Called from tcp_v4_syn_recv_sock() for v6_mapped children. */
+static void tcp_v6_mapped_child_init(struct sock *newsk, const struct sock *sk)
+{
+	struct inet_sock *newinet = inet_sk(newsk);
+	struct ipv6_pinfo *newnp;
+
+	newinet->pinet6 = newnp = tcp_inet6_sk(newsk);
+
+	memcpy(newnp, tcp_inet6_sk(sk), sizeof(struct ipv6_pinfo));
+
+	newnp->saddr = newsk->sk_v6_rcv_saddr;
+
+	inet_csk(newsk)->icsk_af_ops = &ipv6_mapped;
+	if (sk_is_mptcp(newsk))
+		mptcpv6_handle_mapped(newsk, true);
+	newsk->sk_backlog_rcv = tcp_v4_do_rcv;
+#ifdef CONFIG_TCP_MD5SIG
+	tcp_sk(newsk)->af_specific = &tcp_sock_ipv6_mapped_specific;
+#endif
+
+	newnp->ipv6_mc_list = NULL;
+	newnp->ipv6_ac_list = NULL;
+	newnp->ipv6_fl_list = NULL;
+	newnp->pktoptions  = NULL;
+	newnp->opt	   = NULL;
+
+	/* tcp_v4_syn_recv_sock() has initialized newinet->mc_{index,ttl} */
+	newnp->mcast_oif   = newinet->mc_index;
+	newnp->mcast_hops  = newinet->mc_ttl;
+
+	newnp->rcv_flowinfo = 0;
+	if (tcp_inet6_sk(sk)->repflow)
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
@@ -1200,60 +1237,10 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
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
-		inet_sk(newsk)->pinet6 = tcp_inet6_sk(newsk);
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
-#ifdef CONFIG_TCP_MD5SIG
-		newtp->af_specific = &tcp_sock_ipv6_mapped_specific;
-#endif
-
-		newnp->ipv6_mc_list = NULL;
-		newnp->ipv6_ac_list = NULL;
-		newnp->ipv6_fl_list = NULL;
-		newnp->pktoptions  = NULL;
-		newnp->opt	   = NULL;
-		newnp->mcast_oif   = inet_iif(skb);
-		newnp->mcast_hops  = ip_hdr(skb)->ttl;
-		newnp->rcv_flowinfo = 0;
-		if (np->repflow)
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
index d3b5c2d48b530..db2e3a1ebb6ed 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -788,7 +788,9 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
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
@@ -834,7 +836,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 
 create_child:
 	child = listener->icsk_af_ops->syn_recv_sock(sk, skb, req, dst,
-						     req_unhash, own_req);
+						     req_unhash, own_req, opt_child_init);
 
 	if (child && *own_req) {
 		struct mptcp_subflow_context *ctx = mptcp_subflow_ctx(child);
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 1b8fe0402a2da..65632bf8e3c7a 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -119,7 +119,9 @@ static struct sock *smc_tcp_syn_recv_sock(const struct sock *sk,
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
@@ -144,7 +146,7 @@ static struct sock *smc_tcp_syn_recv_sock(const struct sock *sk,
 
 	/* passthrough to original syn recv sock fct */
 	child = smc->ori_af_ops->syn_recv_sock(sk, skb, req, dst, req_unhash,
-					       own_req);
+					       own_req, opt_child_init);
 	/* child must not inherit smc or its ops */
 	if (child) {
 		rcu_assign_sk_user_data(child, NULL);
-- 
2.53.0



