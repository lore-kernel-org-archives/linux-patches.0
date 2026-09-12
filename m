Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D963345CCE;
	Sat, 12 Sep 2026 15:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227814; cv=none; b=ZmEhFTy+J8sWJoMui03rV220c54SohowoLUp3IdL2ahfCpCyq6G1fxDDj6IuUryDnSXmF1DXEhaxw42Q6K6ZB86OGBt6uBaZOnb3MA+YkgY7PMrTAtt5kksnRsXa53QcF5wpQMU4OHrruCxau/XmJQ79JYUHz1H7uncmxUCSKLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227814; c=relaxed/simple;
	bh=s4cLqFi6/WLJpG9DjPNUIgVkGEuLNr41rg0OQDm/JcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NaNrrMaIq3JhIotb5HoonTzFDaem9+2UDmUZvdVOGf2iHdX8cJd2CxA0aVXLKRP6RaK7jvW31STYh39EVFqer9+zd/Gfy5psMQSYzKcz2S9kIj/izXw+G3yzwmvdmXcYK67IT9NqX5npld16oBZb2m93Ih3SS/QFCs9ZLd25Pg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ibw7Xy3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ibw7Xy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4091F000FF;
	Sat, 12 Sep 2026 15:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227812;
	bh=DfEGxa+3gZEvmrYeynqHPv1A0pS71t5hfyFqVo4CfVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ibw7Xy3100PGeupbWXD4tlZqV8oiOTKwkscZvX3ITPJnFRb/gLKu1Bry2CaOEv8M
	 osLMAUKP0B24Nd68lcslLV8pijif836DHcIJD64bfB0Z8LATdyPwxyzYajPsmMlW+C
	 HnZ8pazWVvpWDFth3cGBheXs75Tad832rkNOpTJY=
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
Subject: [PATCH 6.1 0258/1191] tcp: fix potential race in tcp_v6_syn_recv_sock()
Date: Sat, 12 Sep 2026 08:49:46 +0200
Message-ID: <20260912065554.014924723@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7649d4901f0c4..3d19420dce511 100644
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
index 9632ac801e016..b54fd01c5bedb 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -468,7 +468,9 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
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
index 9ddc3a9e89e40..c4dc2d1b5fb18 100644
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
index db8d54fb88060..98ac28fb07e1f 100644
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
index 8f5f56b1e5f8f..aa74fe3beafe5 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -416,7 +416,9 @@ static struct sock *dccp_v6_request_recv_sock(const struct sock *sk,
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
@@ -431,7 +433,8 @@ static struct sock *dccp_v6_request_recv_sock(const struct sock *sk,
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
index f9514cf87649e..d7202f86566a4 100644
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
index cbce1306bb08c..c99f10786c1f9 100644
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
index 753a881ce3cdf..ec3b0aa0a6260 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1509,7 +1509,9 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
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
@@ -1565,6 +1567,10 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 	}
 	sk_setup_caps(newsk, dst);
 
+#if IS_ENABLED(CONFIG_IPV6)
+	if (opt_child_init)
+		opt_child_init(newsk, sk);
+#endif
 	tcp_ca_openreq_child(newsk, dst);
 
 	tcp_sync_mss(newsk, dst_mtu(dst));
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 22b5748a6ee2c..67735100f9acf 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -780,7 +780,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 	 * socket is created, wait for troubles.
 	 */
 	child = inet_csk(sk)->icsk_af_ops->syn_recv_sock(sk, skb, req, NULL,
-							 req, &own_req);
+							 req, &own_req, NULL);
 	if (!child)
 		goto listen_overflow;
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 3d909982d8187..d3952b058453f 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1191,11 +1191,48 @@ static void tcp_v6_restore_cb(struct sk_buff *skb)
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
@@ -1211,60 +1248,10 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
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
index bdf7f439cf2c3..d9734bfb7283b 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -699,7 +699,9 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
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
@@ -745,7 +747,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 
 create_child:
 	child = listener->icsk_af_ops->syn_recv_sock(sk, skb, req, dst,
-						     req_unhash, own_req);
+						     req_unhash, own_req, opt_child_init);
 
 	if (child && *own_req) {
 		struct mptcp_subflow_context *ctx = mptcp_subflow_ctx(child);
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index d069e5b156e51..6713296fffd99 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -118,7 +118,9 @@ static struct sock *smc_tcp_syn_recv_sock(const struct sock *sk,
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
@@ -143,7 +145,7 @@ static struct sock *smc_tcp_syn_recv_sock(const struct sock *sk,
 
 	/* passthrough to original syn recv sock fct */
 	child = smc->ori_af_ops->syn_recv_sock(sk, skb, req, dst, req_unhash,
-					       own_req);
+					       own_req, opt_child_init);
 	/* child must not inherit smc or its ops */
 	if (child) {
 		rcu_assign_sk_user_data(child, NULL);
-- 
2.53.0



