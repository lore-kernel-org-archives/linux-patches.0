Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624488;
	b=lHCDtW1J8f79IaKoXz8BveOqdbpNQLW0hLWXA7zqjRmcCN24kXVbXT3cFlqixqNKgSBL
	 czzUpI8FrMtQCbkkYiOgJUge36aQiss5XA3n7zyoWKMPCwGp1vBUflQQ8v6j+OeENlBaS
	 Rcl6Echo04ULchCFWgLQ/xUAqtv9U0117P/bQaFpjS9sqmUb8r5KMjTCaTCFgg73Xgavc
	 t7Rgt91Hdo5qY2FIj2vZQ/O5ZbHhX3usKtn+7ovKgc7RZoSC6mMzoPpT07Uv24b+XMb+E
	 DWmjTAF+UPFSga8jabOlg3Ah/vpapM/FLmuiT5fqHtR3AsT1EykWuMNTITMcOKXgH9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624488;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S+qZkEd+HqSJ64xQobGoRx0q18y9H4ljCIfuTZyK4g8=;
	b=MdJAmuq8+SW8d2vwB1HaS6cOawMoc0dcDI4TWyadKQTaEi1qjjqizkdS5e12hoh8EQPp
	 Azo/xcgF+W1BZvcJ3nTetvFD5YFLDm50ekkIALt/uaIgF3fRgc+h0pCBptjBAThBzIlyb
	 2rIQpnRbVg5FgwiqcBNVrO+TwEBTJgzzNfsYiGUvPkdD4zwmjnlaWT+2uYeT1y++AxNeB
	 og/LxW/SF0bhKS/jrwFtKG9aVdxClFeRTdaXRvkFj+7Pg4Ionyz9V42BkGKOsXFAnL6PX
	 3Jfyvapug033EmUKR4K8QVpI2vhSYX863DtaRZ9hXx0Nh03/qk9VRPNLmA6f1mD+rsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QRxy4i3n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B026606A33A;
	Wed, 25 Nov 2026 16:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QRxy4i3n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6F51F000C4;
	Wed, 25 Nov 2026 16:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624488;
	bh=S+qZkEd+HqSJ64xQobGoRx0q18y9H4ljCIfuTZyK4g8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QRxy4i3nUzOyEPVhEsPptMnPUhdU1+mTJe7wmYH55a8zme043YL3EFIDRzXM4JaAl
	 aNXqmeGeH1+vSEA48Er8XhFBZtpxUWag0M0cbnjmAdLnDlO3vrfLx0syvEZb4gvUca
	 il3Lv/yZ9xxruEquCLUgo14rWCQm5G7Kxa2XNGSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 208/816] inet: consolidate inet_csk_clone_lock()
Date: Wed, 25 Nov 2026 15:29:16 +0100
Message-ID: <20261125143854.013229518@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a3a128f611a965fddf8a02dd45716f96e0738e00 ]

Current inet_sock_set_state trace from inet_csk_clone_lock() is missing
many details :

... sock:inet_sock_set_state: family=AF_INET6 protocol=IPPROTO_TCP \
    sport=4901 dport=0 \
    saddr=127.0.0.6 daddr=0.0.0.0 \
    saddrv6=:: daddrv6=:: \
    oldstate=TCP_LISTEN newstate=TCP_SYN_RECV

Only the sport gives the listener port, no other parts of the n-tuple are correct.

In this patch, I initialize relevant fields of the new socket before
calling inet_sk_set_state(newsk, TCP_SYN_RECV).

We now have a trace including all the source/destination bits.

... sock:inet_sock_set_state: family=AF_INET6 protocol=IPPROTO_TCP \
    sport=4901 dport=47648 \
    saddr=127.0.0.6 daddr=127.0.0.6 \
    saddrv6=2002:a05:6830:1f85:: daddrv6=2001:4860:f803:65::3 \
    oldstate=TCP_LISTEN newstate=TCP_SYN_RECV

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250212131328.1514243-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8e069fd3fd39 ("tcp: ipv6: do not read ireq->pktopts from tcp_v6_send_synack()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dccp/ipv4.c                 |  3 ---
 net/dccp/ipv6.c                 |  9 +++------
 net/ipv4/inet_connection_sock.c | 24 ++++++++++++++++++++----
 net/ipv4/tcp_ipv4.c             |  4 ----
 net/ipv6/tcp_ipv6.c             |  8 ++------
 5 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index b8f5e20368ec5..bf1ac878009d5 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -427,9 +427,6 @@ struct sock *dccp_v4_request_recv_sock(const struct sock *sk,
 
 	newinet		   = inet_sk(newsk);
 	ireq		   = inet_rsk(req);
-	sk_daddr_set(newsk, ireq->ir_rmt_addr);
-	sk_rcv_saddr_set(newsk, ireq->ir_loc_addr);
-	newinet->inet_saddr	= ireq->ir_loc_addr;
 	RCU_INIT_POINTER(newinet->inet_opt, rcu_dereference(ireq->ireq_opt));
 	newinet->mc_index  = inet_iif(skb);
 	newinet->mc_ttl	   = ip_hdr(skb)->ttl;
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 3c43dd8561f8e..b4c30bc2431c7 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -365,6 +365,9 @@ static int dccp_v6_conn_request(struct sock *sk, struct sk_buff *skb)
 	ireq = inet_rsk(req);
 	ireq->ir_v6_rmt_addr = ipv6_hdr(skb)->saddr;
 	ireq->ir_v6_loc_addr = ipv6_hdr(skb)->daddr;
+	ireq->ir_rmt_addr = LOOPBACK4_IPV6;
+	ireq->ir_loc_addr = LOOPBACK4_IPV6;
+
 	ireq->ireq_family = AF_INET6;
 	ireq->ir_mark = inet_request_mark(sk, skb);
 
@@ -507,10 +510,7 @@ static struct sock *dccp_v6_request_recv_sock(const struct sock *sk,
 
 	memcpy(newnp, np, sizeof(struct ipv6_pinfo));
 
-	newsk->sk_v6_daddr	= ireq->ir_v6_rmt_addr;
 	newnp->saddr		= ireq->ir_v6_loc_addr;
-	newsk->sk_v6_rcv_saddr	= ireq->ir_v6_loc_addr;
-	newsk->sk_bound_dev_if	= ireq->ir_iif;
 
 	/* Now IPv6 options...
 
@@ -549,9 +549,6 @@ static struct sock *dccp_v6_request_recv_sock(const struct sock *sk,
 
 	dccp_sync_mss(newsk, dst_mtu(dst));
 
-	newinet->inet_daddr = newinet->inet_saddr = LOOPBACK4_IPV6;
-	newinet->inet_rcv_saddr = LOOPBACK4_IPV6;
-
 	if (__inet_inherit_port(sk, newsk) < 0) {
 		inet_csk_prepare_forced_close(newsk);
 		dccp_done(newsk);
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index c78291ea4ff6f..64093410f6d52 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1258,19 +1258,33 @@ struct sock *inet_csk_clone_lock(const struct sock *sk,
 {
 	struct sock *newsk = sk_clone_lock(sk, priority);
 	struct inet_connection_sock *newicsk;
+	struct inet_request_sock *ireq;
+	struct inet_sock *newinet;
 
 	if (!newsk)
 		return NULL;
 
 	newicsk = inet_csk(newsk);
+	newinet = inet_sk(newsk);
+	ireq = inet_rsk(req);
 
-	inet_sk_set_state(newsk, TCP_SYN_RECV);
 	newicsk->icsk_bind_hash = NULL;
 	newicsk->icsk_bind2_hash = NULL;
 
-	inet_sk(newsk)->inet_dport = inet_rsk(req)->ir_rmt_port;
-	inet_sk(newsk)->inet_num = inet_rsk(req)->ir_num;
-	inet_sk(newsk)->inet_sport = htons(inet_rsk(req)->ir_num);
+	newinet->inet_dport = ireq->ir_rmt_port;
+	newinet->inet_num = ireq->ir_num;
+	newinet->inet_sport = htons(ireq->ir_num);
+
+	newsk->sk_bound_dev_if = ireq->ir_iif;
+
+	newsk->sk_daddr = ireq->ir_rmt_addr;
+	newsk->sk_rcv_saddr = ireq->ir_loc_addr;
+	newinet->inet_saddr = ireq->ir_loc_addr;
+
+#if IS_ENABLED(CONFIG_IPV6)
+	newsk->sk_v6_daddr = ireq->ir_v6_rmt_addr;
+	newsk->sk_v6_rcv_saddr = ireq->ir_v6_loc_addr;
+#endif
 
 	/* listeners have SOCK_RCU_FREE, not the children */
 	sock_reset_flag(newsk, SOCK_RCU_FREE);
@@ -1290,6 +1304,8 @@ struct sock *inet_csk_clone_lock(const struct sock *sk,
 	memset(&newicsk->icsk_accept_queue, 0,
 	       sizeof(newicsk->icsk_accept_queue));
 
+	inet_sk_set_state(newsk, TCP_SYN_RECV);
+
 	inet_clone_ulp(req, newsk, priority);
 
 	security_inet_csk_clone(newsk, req);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index b92f040a3eaab..4d1b3c4602a36 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1770,10 +1770,6 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 	newtp		      = tcp_sk(newsk);
 	newinet		      = inet_sk(newsk);
 	ireq		      = inet_rsk(req);
-	sk_daddr_set(newsk, ireq->ir_rmt_addr);
-	sk_rcv_saddr_set(newsk, ireq->ir_loc_addr);
-	newsk->sk_bound_dev_if = ireq->ir_iif;
-	newinet->inet_saddr   = ireq->ir_loc_addr;
 	inet_opt	      = rcu_dereference(ireq->ireq_opt);
 	RCU_INIT_POINTER(newinet->inet_opt, inet_opt);
 	newinet->mc_index     = inet_iif(skb);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index ae2a91e3f15c9..ee4712f7d9708 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -798,6 +798,8 @@ static void tcp_v6_init_req(struct request_sock *req,
 
 	ireq->ir_v6_rmt_addr = ipv6_hdr(skb)->saddr;
 	ireq->ir_v6_loc_addr = ipv6_hdr(skb)->daddr;
+	ireq->ir_rmt_addr = LOOPBACK4_IPV6;
+	ireq->ir_loc_addr = LOOPBACK4_IPV6;
 
 	/* So that link locals have meaning */
 	if ((!sk_listener->sk_bound_dev_if || l3_slave) &&
@@ -1439,10 +1441,7 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 
 	ip6_dst_store(newsk, dst, NULL, false);
 
-	newsk->sk_v6_daddr = ireq->ir_v6_rmt_addr;
 	newnp->saddr = ireq->ir_v6_loc_addr;
-	newsk->sk_v6_rcv_saddr = ireq->ir_v6_loc_addr;
-	newsk->sk_bound_dev_if = ireq->ir_iif;
 
 	/* Now IPv6 options...
 
@@ -1493,9 +1492,6 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 
 	tcp_initialize_rcv_mss(newsk);
 
-	newinet->inet_daddr = newinet->inet_saddr = LOOPBACK4_IPV6;
-	newinet->inet_rcv_saddr = LOOPBACK4_IPV6;
-
 #ifdef CONFIG_TCP_MD5SIG
 	l3index = l3mdev_master_ifindex_by_index(sock_net(sk), ireq->ir_iif);
 
-- 
2.53.0



