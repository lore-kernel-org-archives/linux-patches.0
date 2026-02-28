Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E37F32ED2A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301946; cv=none; b=NkoZ1TWwACyPChupuZ3UJ1VwKYhfwhyV5Uk71kqW7dmyzqC4Ss0mAIII978/QqE3Kf2PHi6wO3K96cDt7qj4JTaeVtomEXFH7vLVW26AIH1jFWrrjeN8D1kzfw7LI+zR0cUXftVcFBEwI6b8+jNKD2WYKzfllcNyEXsDfJymfMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301946; c=relaxed/simple;
	bh=Q/lGpJXeTxX0fJsFL1UrtiKpM2Ph9zj4Cd0eeFvzG6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLW1erPhtFRiyS5qyiRlQdwpz91vhU6mJhXd/bAl221NQLGtcwxU8NdTQWgFRfF9g7eY26swaa8+/tmn1VtXbeMdp9ULxdZzbFzwu/2u6JBzF5jQd2MhtlQB517BUEiB3WngF+Gaaqgbsx6V/ry2zcFxPO6xcIiyHYs0EKXKtOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p64UAflY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p64UAflY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D892C19425;
	Sat, 28 Feb 2026 18:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301946;
	bh=Q/lGpJXeTxX0fJsFL1UrtiKpM2Ph9zj4Cd0eeFvzG6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p64UAflYyEZE/NhR9Or/fOHaDG00U5tv8kx9/GuCpHV2wQ4BttYvJwHjAhOe20A9z
	 Zwj8vSFwUfWW7czz4/YrmyfRNYeg2XE16GS/9Tnzr9xefHVjOvJ/CF5sUSDa2GOGtL
	 1514ylG731u9+/K+52p5rfz6ukLm5vyAXzQeEq26pGzrp9Z39upJls64C4mNS6nfu7
	 siskHoS3i5a8PnvIuNExMkQAOpTZuwzD7D8mtHR4qMsJSGvCeo67Zb693es+fcPCE5
	 jEnIX+f+QJKvfLTKQ3W2tjBdpshYUVsp7/8Q/ksCMvFNIssylYggCwkMBlReVXLi6B
	 1FY8+njEvzDWg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 384/385] ping: annotate data-races in ping_lookup()
Date: Sat, 28 Feb 2026 13:00:06 -0500
Message-ID: <20260228180011.1568201-384-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index f62b17f59bb4a..0089c1605acfe 100644
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
@@ -860,7 +866,8 @@ int ping_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags,
 	struct sk_buff *skb;
 	int copied, err;
 
-	pr_debug("ping_recvmsg(sk=%p,sk->num=%u)\n", isk, isk->inet_num);
+	pr_debug("ping_recvmsg(sk=%p,sk->num=%u)\n", isk,
+		 READ_ONCE(isk->inet_num));
 
 	err = -EOPNOTSUPP;
 	if (flags & MSG_OOB)
-- 
2.51.0

