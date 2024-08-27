Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC8C1CB126;
	Tue, 27 Aug 2024 15:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772496; cv=none; b=gVTgLrFqSC/f700Npm1ilRUWgjsqErIxIAnBNiFCAztnNy4dGzcAyuwEJF8Sji8yL+0+PUB28P17wpJmMbHDsEw9YxKr1aZzgCOCW0DzKI9EvNtNrsrktEzQSVTMMdcfxC555ZxjlW0xqIGLWMSbWMqB/4gEaHuJi1dLNGwdg8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772496; c=relaxed/simple;
	bh=QmWfzQphO7UR/u2c13Ld5o9yJpTWXvBzcu4hJ/J6Ewo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=of2/8XJuowrKRmUlZ2t6UrSJSXL3MdTbOiyO4e4lgRgEDfFmqFCHMudceOHajPiPgUipBnslxqN9SwPjuYyGxLCt/GyvfFpEvt4w+1FzHSU6spRtcexh49myL2pqdBt9dBk3QOEAxP5vVyKTfMl0hxZzW/1HHcorA9Hf5hBaTzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z/yEDKym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z/yEDKym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE4FC61047;
	Tue, 27 Aug 2024 15:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772496;
	bh=QmWfzQphO7UR/u2c13Ld5o9yJpTWXvBzcu4hJ/J6Ewo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z/yEDKymC6XzRHsnIUfn6GG4rm0dzD7oXu9rVlhy50KKXOcOH35ypWLTEIgmeyHgU
	 E8crOifzgoNkceG4yFoXSm4VfT6gBrvsDZGqW9unidYKUmvebfHNlMkkpujfVxs/zt
	 4TQlzFvxOaqjuWCTpVjElqRI31LN7jJa8i9x1JVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 231/321] tcp/dccp: do not care about families in inet_twsk_purge()
Date: Tue, 27 Aug 2024 16:38:59 +0200
Message-ID: <20240827143847.031097280@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

[ Upstream commit 1eeb5043573981f3a1278876515851b7f6b1df1b ]

We lost ability to unload ipv6 module a long time ago.

Instead of calling expensive inet_twsk_purge() twice,
we can handle all families in one round.

Also remove an extra line added in my prior patch,
per Kuniyuki Iwashima feedback.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/netdev/20240327192934.6843-1-kuniyu@amazon.com/
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20240329153203.345203-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 565d121b6998 ("tcp: prevent concurrent execution of tcp_sk_exit_batch")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_timewait_sock.h | 2 +-
 include/net/tcp.h                | 2 +-
 net/dccp/ipv4.c                  | 2 +-
 net/dccp/ipv6.c                  | 6 ------
 net/ipv4/inet_timewait_sock.c    | 9 +++------
 net/ipv4/tcp_ipv4.c              | 2 +-
 net/ipv4/tcp_minisocks.c         | 6 +++---
 net/ipv6/tcp_ipv6.c              | 6 ------
 8 files changed, 10 insertions(+), 25 deletions(-)

diff --git a/include/net/inet_timewait_sock.h b/include/net/inet_timewait_sock.h
index 4a8e578405cb3..9365e5af8d6da 100644
--- a/include/net/inet_timewait_sock.h
+++ b/include/net/inet_timewait_sock.h
@@ -114,7 +114,7 @@ static inline void inet_twsk_reschedule(struct inet_timewait_sock *tw, int timeo
 
 void inet_twsk_deschedule_put(struct inet_timewait_sock *tw);
 
-void inet_twsk_purge(struct inet_hashinfo *hashinfo, int family);
+void inet_twsk_purge(struct inet_hashinfo *hashinfo);
 
 static inline
 struct net *twsk_net(const struct inet_timewait_sock *twsk)
diff --git a/include/net/tcp.h b/include/net/tcp.h
index cc314c383c532..c7501ca66dd34 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -352,7 +352,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb);
 void tcp_rcv_space_adjust(struct sock *sk);
 int tcp_twsk_unique(struct sock *sk, struct sock *sktw, void *twp);
 void tcp_twsk_destructor(struct sock *sk);
-void tcp_twsk_purge(struct list_head *net_exit_list, int family);
+void tcp_twsk_purge(struct list_head *net_exit_list);
 ssize_t tcp_splice_read(struct socket *sk, loff_t *ppos,
 			struct pipe_inode_info *pipe, size_t len,
 			unsigned int flags);
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index f4a2dce3e1048..db8d54fb88060 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -1042,7 +1042,7 @@ static void __net_exit dccp_v4_exit_net(struct net *net)
 
 static void __net_exit dccp_v4_exit_batch(struct list_head *net_exit_list)
 {
-	inet_twsk_purge(&dccp_hashinfo, AF_INET);
+	inet_twsk_purge(&dccp_hashinfo);
 }
 
 static struct pernet_operations dccp_v4_ops = {
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 016af0301366d..d90bb941f2ada 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -1121,15 +1121,9 @@ static void __net_exit dccp_v6_exit_net(struct net *net)
 	inet_ctl_sock_destroy(pn->v6_ctl_sk);
 }
 
-static void __net_exit dccp_v6_exit_batch(struct list_head *net_exit_list)
-{
-	inet_twsk_purge(&dccp_hashinfo, AF_INET6);
-}
-
 static struct pernet_operations dccp_v6_ops = {
 	.init   = dccp_v6_init_net,
 	.exit   = dccp_v6_exit_net,
-	.exit_batch = dccp_v6_exit_batch,
 	.id	= &dccp_v6_pernet_id,
 	.size   = sizeof(struct dccp_v6_pernet),
 };
diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
index 15d6ce41e5de7..6356a8a47b345 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -282,7 +282,7 @@ void __inet_twsk_schedule(struct inet_timewait_sock *tw, int timeo, bool rearm)
 EXPORT_SYMBOL_GPL(__inet_twsk_schedule);
 
 /* Remove all non full sockets (TIME_WAIT and NEW_SYN_RECV) for dead netns */
-void inet_twsk_purge(struct inet_hashinfo *hashinfo, int family)
+void inet_twsk_purge(struct inet_hashinfo *hashinfo)
 {
 	struct inet_ehash_bucket *head = &hashinfo->ehash[0];
 	unsigned int ehash_mask = hashinfo->ehash_mask;
@@ -291,7 +291,6 @@ void inet_twsk_purge(struct inet_hashinfo *hashinfo, int family)
 	struct sock *sk;
 
 	for (slot = 0; slot <= ehash_mask; slot++, head++) {
-
 		if (hlist_nulls_empty(&head->chain))
 			continue;
 
@@ -306,15 +305,13 @@ void inet_twsk_purge(struct inet_hashinfo *hashinfo, int family)
 					     TCPF_NEW_SYN_RECV))
 				continue;
 
-			if (sk->sk_family != family ||
-			    refcount_read(&sock_net(sk)->ns.count))
+			if (refcount_read(&sock_net(sk)->ns.count))
 				continue;
 
 			if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
 				continue;
 
-			if (unlikely(sk->sk_family != family ||
-				     refcount_read(&sock_net(sk)->ns.count))) {
+			if (refcount_read(&sock_net(sk)->ns.count)) {
 				sock_gen_put(sk);
 				goto restart;
 			}
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index c64ba4f8ddaa9..167de693981a8 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3242,7 +3242,7 @@ static void __net_exit tcp_sk_exit_batch(struct list_head *net_exit_list)
 {
 	struct net *net;
 
-	tcp_twsk_purge(net_exit_list, AF_INET);
+	tcp_twsk_purge(net_exit_list);
 
 	list_for_each_entry(net, net_exit_list, exit_list) {
 		inet_pernet_hashinfo_free(net->ipv4.tcp_death_row.hashinfo);
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index b3bfa1a09df68..000dce7d0e2d0 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -347,7 +347,7 @@ void tcp_twsk_destructor(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(tcp_twsk_destructor);
 
-void tcp_twsk_purge(struct list_head *net_exit_list, int family)
+void tcp_twsk_purge(struct list_head *net_exit_list)
 {
 	bool purged_once = false;
 	struct net *net;
@@ -355,9 +355,9 @@ void tcp_twsk_purge(struct list_head *net_exit_list, int family)
 	list_for_each_entry(net, net_exit_list, exit_list) {
 		if (net->ipv4.tcp_death_row.hashinfo->pernet) {
 			/* Even if tw_refcount == 1, we must clean up kernel reqsk */
-			inet_twsk_purge(net->ipv4.tcp_death_row.hashinfo, family);
+			inet_twsk_purge(net->ipv4.tcp_death_row.hashinfo);
 		} else if (!purged_once) {
-			inet_twsk_purge(&tcp_hashinfo, family);
+			inet_twsk_purge(&tcp_hashinfo);
 			purged_once = true;
 		}
 	}
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index eb6fc0e2a4533..06b4acbfd314b 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2217,15 +2217,9 @@ static void __net_exit tcpv6_net_exit(struct net *net)
 	inet_ctl_sock_destroy(net->ipv6.tcp_sk);
 }
 
-static void __net_exit tcpv6_net_exit_batch(struct list_head *net_exit_list)
-{
-	tcp_twsk_purge(net_exit_list, AF_INET6);
-}
-
 static struct pernet_operations tcpv6_net_ops = {
 	.init	    = tcpv6_net_init,
 	.exit	    = tcpv6_net_exit,
-	.exit_batch = tcpv6_net_exit_batch,
 };
 
 int __init tcpv6_init(void)
-- 
2.43.0



