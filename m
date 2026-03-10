Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B98387362;
	Tue, 10 Mar 2026 11:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141206; cv=none; b=sbR75I25AGr+rWZqpviJf1bTjwfGNHgmnlhnqrv6bDR2vnYLWP9Bv56WMr0y7qPf8HBSj46F6JDApZfhiijqgye8mvL5FmNJIQ7xF8e/ZfEG58y0Kz4asCxe6qDs2lq2xnnXD3BQpZ1fvZvJPior3SX5sHRPdw1EEM8VWjokZS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141206; c=relaxed/simple;
	bh=FfFyr1DUk+VQUoxlOj6+FV0S6Tfd7g7L4nG4kXmuoYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BWRdSmJjf7OcqjP8NHeafVn8WLGcaL8+dojMTJi5AJTordvEdVR8QcgHqw3IOJNO8cFK//KhMwujpFJxNAcW4POemIEIgjhXVB05aYf3GXFJQyH7vJahxdlnVMCB6LeViBNHL8WlRs7Qz/ZE68bAmaz+M7Q148D4hwakW/P4Pzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ux8tP2jU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ux8tP2jU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D21C2BC86;
	Tue, 10 Mar 2026 11:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141206;
	bh=FfFyr1DUk+VQUoxlOj6+FV0S6Tfd7g7L4nG4kXmuoYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ux8tP2jUw//bOmGSSMlZqa6iXvOFbYJ01vCNFiFVlosnwUt64BaRYGKNgl+d0DtAW
	 q5a4CNyzkSlbUu3h1XyCQs/Sst6Bz+VBrPCPWFb7Vt5pzi6Lq+zMki/O/OTVpxwOJd
	 OHIKOE82LprYJMh/RW6ikZan7HSVm1NXfkRDfpZNHeWXAkxb55lNE/SV1YDS59o/gr
	 EdZRbpR7lqXo3fvi3fXbXzcleVU6vxjU0zXy8YwUpd+kr3S6ocZg2rQJHQ8dEMcK7h
	 CeHm6r7DhClQdiKmJaTyU2honvvjsw1JKoYxMwN4XkKhI1IpNfrnSFrccjumyzdiul
	 FPt2MXE0HbLyw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 206/311] inet: annotate data-races around isk->inet_num
Date: Tue, 10 Mar 2026 07:04:13 -0400
Message-ID: <4cde93823642660dbf498b3be14ba220b9ef562d.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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

[ Upstream commit 29252397bcc1e0a1f85e5c3bee59c325f5c26341 ]

UDP/TCP lookups are using RCU, thus isk->inet_num accesses
should use READ_ONCE() and WRITE_ONCE() where needed.

Fixes: 3ab5aee7fe84 ("net: Convert TCP & DCCP hash tables to use RCU / hlist_nulls")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260225203545.1512417-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet6_hashtables.h | 2 +-
 include/net/inet_hashtables.h  | 2 +-
 include/net/ip.h               | 2 +-
 net/ipv4/inet_hashtables.c     | 8 ++++----
 net/ipv4/tcp_diag.c            | 2 +-
 net/ipv6/inet6_hashtables.c    | 3 ++-
 6 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/include/net/inet6_hashtables.h b/include/net/inet6_hashtables.h
index 282e29237d936..c16de5b7963fd 100644
--- a/include/net/inet6_hashtables.h
+++ b/include/net/inet6_hashtables.h
@@ -175,7 +175,7 @@ static inline bool inet6_match(const struct net *net, const struct sock *sk,
 {
 	if (!net_eq(sock_net(sk), net) ||
 	    sk->sk_family != AF_INET6 ||
-	    sk->sk_portpair != ports ||
+	    READ_ONCE(sk->sk_portpair) != ports ||
 	    !ipv6_addr_equal(&sk->sk_v6_daddr, saddr) ||
 	    !ipv6_addr_equal(&sk->sk_v6_rcv_saddr, daddr))
 		return false;
diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index ac05a52d9e138..5a979dcab5383 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -345,7 +345,7 @@ static inline bool inet_match(const struct net *net, const struct sock *sk,
 			      int dif, int sdif)
 {
 	if (!net_eq(sock_net(sk), net) ||
-	    sk->sk_portpair != ports ||
+	    READ_ONCE(sk->sk_portpair) != ports ||
 	    sk->sk_addrpair != cookie)
 	        return false;
 
diff --git a/include/net/ip.h b/include/net/ip.h
index 69d5cef460040..7f9abd457e018 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -101,7 +101,7 @@ static inline void ipcm_init_sk(struct ipcm_cookie *ipcm,
 
 	ipcm->oif = READ_ONCE(inet->sk.sk_bound_dev_if);
 	ipcm->addr = inet->inet_saddr;
-	ipcm->protocol = inet->inet_num;
+	ipcm->protocol = READ_ONCE(inet->inet_num);
 }
 
 #define IPCB(skb) ((struct inet_skb_parm*)((skb)->cb))
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index f5826ec4bcaa8..46817b4c141b6 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -200,7 +200,7 @@ static bool inet_bind2_bucket_addr_match(const struct inet_bind2_bucket *tb2,
 void inet_bind_hash(struct sock *sk, struct inet_bind_bucket *tb,
 		    struct inet_bind2_bucket *tb2, unsigned short port)
 {
-	inet_sk(sk)->inet_num = port;
+	WRITE_ONCE(inet_sk(sk)->inet_num, port);
 	inet_csk(sk)->icsk_bind_hash = tb;
 	inet_csk(sk)->icsk_bind2_hash = tb2;
 	sk_add_bind_node(sk, &tb2->owners);
@@ -224,7 +224,7 @@ static void __inet_put_port(struct sock *sk)
 	spin_lock(&head->lock);
 	tb = inet_csk(sk)->icsk_bind_hash;
 	inet_csk(sk)->icsk_bind_hash = NULL;
-	inet_sk(sk)->inet_num = 0;
+	WRITE_ONCE(inet_sk(sk)->inet_num, 0);
 	sk->sk_userlocks &= ~SOCK_CONNECT_BIND;
 
 	spin_lock(&head2->lock);
@@ -352,7 +352,7 @@ static inline int compute_score(struct sock *sk, const struct net *net,
 {
 	int score = -1;
 
-	if (net_eq(sock_net(sk), net) && sk->sk_num == hnum &&
+	if (net_eq(sock_net(sk), net) && READ_ONCE(sk->sk_num) == hnum &&
 			!ipv6_only_sock(sk)) {
 		if (sk->sk_rcv_saddr != daddr)
 			return -1;
@@ -1206,7 +1206,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 
 		sk->sk_hash = 0;
 		inet_sk(sk)->inet_sport = 0;
-		inet_sk(sk)->inet_num = 0;
+		WRITE_ONCE(inet_sk(sk)->inet_num, 0);
 
 		if (tw)
 			inet_twsk_bind_unhash(tw, hinfo);
diff --git a/net/ipv4/tcp_diag.c b/net/ipv4/tcp_diag.c
index d83efd91f461c..7935702e394b2 100644
--- a/net/ipv4/tcp_diag.c
+++ b/net/ipv4/tcp_diag.c
@@ -509,7 +509,7 @@ static void tcp_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 			if (r->sdiag_family != AF_UNSPEC &&
 			    sk->sk_family != r->sdiag_family)
 				goto next_normal;
-			if (r->id.idiag_sport != htons(sk->sk_num) &&
+			if (r->id.idiag_sport != htons(READ_ONCE(sk->sk_num)) &&
 			    r->id.idiag_sport)
 				goto next_normal;
 			if (r->id.idiag_dport != sk->sk_dport &&
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index 5e1da088d8e11..182d38e6d6d8d 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -95,7 +95,8 @@ static inline int compute_score(struct sock *sk, const struct net *net,
 {
 	int score = -1;
 
-	if (net_eq(sock_net(sk), net) && inet_sk(sk)->inet_num == hnum &&
+	if (net_eq(sock_net(sk), net) &&
+	    READ_ONCE(inet_sk(sk)->inet_num) == hnum &&
 	    sk->sk_family == PF_INET6) {
 		if (!ipv6_addr_equal(&sk->sk_v6_rcv_saddr, daddr))
 			return -1;
-- 
2.51.0

