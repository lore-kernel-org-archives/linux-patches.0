Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056DA347FED
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302484; cv=none; b=oc9bJahfFh2OroawwO8aD9nBn3K6uVSa8MRtxsTVgdqo+WQgrph1XOBbpMiZaaTpQiHPYuHMu6O/G9zeipsHWtYoTef60mCwBWx5gizdNlOB1loZQJydQ6ZTjXu/hkrJkoevXuRGBD3X8yooZzolh1Nv4xUaDFQXeCeFfudnfw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302484; c=relaxed/simple;
	bh=VBdUIFvKnhYPfTpXauJvVkKGV+FN5nphzp7g8Blzurk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dN47CWcTfadurIOssU+CoZqcwxm2PSkQPCRwbtSkjAeAkUO6dXBWfnq9wQyEjbMrzSrUa9H7Lc2DDPG9EDGeVczQw1+y+SuNFJzZPrhr9OCsw99kLtC3g+if9xujktm6a6iusfU+BHxLKSgcmnhzwqqw3Oirvx2LvqFuvffA2hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YP+tGrGS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YP+tGrGS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5228EC19423;
	Sat, 28 Feb 2026 18:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302483;
	bh=VBdUIFvKnhYPfTpXauJvVkKGV+FN5nphzp7g8Blzurk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YP+tGrGS9jX7wo8oQ7BgpK0zr5jozDGtjlJ6URovHKYIaf9+KLbmyrc1s17Nnzm4q
	 Z6VnCHhUOKov9UvcS/T8kUxNf37oocfwiaWh07cawMa4a2MiCvOlz50opNuz7BqD9b
	 v95L7w6m3wIIV+ELXkTEQs3fcjGHMhg7JVd03/F/R6Ef20vX5Wasphpjlf0KeI2PAX
	 8b/Hzm9Ox50qGbYk/Lqt10b4N4FXh2nuDUI5yIO9sAsMsI2fFscO+3XdZpbwh4wvWE
	 dkCCSkPkUBXPNZ3LDRksojpHRDtvpUSnnUyLu2NfgX03uSfK+fui0x2wd8n9CBJjel
	 x7Akf1Bk+FSrQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 231/232] ping: annotate data-races in ping_lookup()
Date: Sat, 28 Feb 2026 13:11:24 -0500
Message-ID: <20260228181127.1592657-231-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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

[ Upstream commit ad5dfde2a5733aaf652ea3e40c8c5e071e935901 ]

isk->inet_num, isk->inet_rcv_saddr and sk->sk_bound_dev_if
are read locklessly in ping_lookup().

Add READ_ONCE()/WRITE_ONCE() annotations.

The race on isk->inet_rcv_saddr is probably coming from IPv6 support,
but does not deserve a specific backport.

Fixes: dbca1596bbb0 ("ping: convert to RCU lookups, get rid of rwlock")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260216100149.3319315-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ping.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index ee0e2df5d62e0..effe91a19a7a2 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -159,7 +159,7 @@ void ping_unhash(struct sock *sk)
 	pr_debug("ping_unhash(isk=%p,isk->num=%u)\n", isk, isk->inet_num);
 	spin_lock(&ping_table.lock);
 	if (sk_del_node_init_rcu(sk)) {
-		isk->inet_num = 0;
+		WRITE_ONCE(isk->inet_num, 0);
 		isk->inet_sport = 0;
 		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
 	}
@@ -192,31 +192,35 @@ static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
 	}
 
 	sk_for_each_rcu(sk, hslot) {
+		int bound_dev_if;
+
 		if (!net_eq(sock_net(sk), net))
 			continue;
 		isk = inet_sk(sk);
 
 		pr_debug("iterate\n");
-		if (isk->inet_num != ident)
+		if (READ_ONCE(isk->inet_num) != ident)
 			continue;
 
+		bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
 		if (skb->protocol == htons(ETH_P_IP) &&
 		    sk->sk_family == AF_INET) {
+			__be32 rcv_saddr = READ_ONCE(isk->inet_rcv_saddr);
+
 			pr_debug("found: %p: num=%d, daddr=%pI4, dif=%d\n", sk,
-				 (int) isk->inet_num, &isk->inet_rcv_saddr,
-				 sk->sk_bound_dev_if);
+				 ident, &rcv_saddr,
+				 bound_dev_if);
 
-			if (isk->inet_rcv_saddr &&
-			    isk->inet_rcv_saddr != ip_hdr(skb)->daddr)
+			if (rcv_saddr && rcv_saddr != ip_hdr(skb)->daddr)
 				continue;
 #if IS_ENABLED(CONFIG_IPV6)
 		} else if (skb->protocol == htons(ETH_P_IPV6) &&
 			   sk->sk_family == AF_INET6) {
 
 			pr_debug("found: %p: num=%d, daddr=%pI6c, dif=%d\n", sk,
-				 (int) isk->inet_num,
+				 ident,
 				 &sk->sk_v6_rcv_saddr,
-				 sk->sk_bound_dev_if);
+				 bound_dev_if);
 
 			if (!ipv6_addr_any(&sk->sk_v6_rcv_saddr) &&
 			    !ipv6_addr_equal(&sk->sk_v6_rcv_saddr,
@@ -227,8 +231,8 @@ static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
 			continue;
 		}
 
-		if (sk->sk_bound_dev_if && sk->sk_bound_dev_if != dif &&
-		    sk->sk_bound_dev_if != sdif)
+		if (bound_dev_if && bound_dev_if != dif &&
+		    bound_dev_if != sdif)
 			continue;
 
 		goto exit;
@@ -403,7 +407,9 @@ static void ping_set_saddr(struct sock *sk, struct sockaddr *saddr)
 	if (saddr->sa_family == AF_INET) {
 		struct inet_sock *isk = inet_sk(sk);
 		struct sockaddr_in *addr = (struct sockaddr_in *) saddr;
-		isk->inet_rcv_saddr = isk->inet_saddr = addr->sin_addr.s_addr;
+
+		isk->inet_saddr = addr->sin_addr.s_addr;
+		WRITE_ONCE(isk->inet_rcv_saddr, addr->sin_addr.s_addr);
 #if IS_ENABLED(CONFIG_IPV6)
 	} else if (saddr->sa_family == AF_INET6) {
 		struct sockaddr_in6 *addr = (struct sockaddr_in6 *) saddr;
@@ -865,7 +871,8 @@ int ping_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags,
 	struct sk_buff *skb;
 	int copied, err;
 
-	pr_debug("ping_recvmsg(sk=%p,sk->num=%u)\n", isk, isk->inet_num);
+	pr_debug("ping_recvmsg(sk=%p,sk->num=%u)\n", isk,
+		 READ_ONCE(isk->inet_num));
 
 	err = -EOPNOTSUPP;
 	if (flags & MSG_OOB)
-- 
2.51.0

