Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DBB26E6F8;
	Wed, 25 Feb 2026 01:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983602; cv=none; b=U0VwBkRo5KYk4Zdeahy/V/QW9G9MK1spbyqniQbTcNVKpU4oZqdsY1WrhebB/KXmRK60ZxzS3rEHC/lX7dJ/gbIe4IHxV8DmezP6Qn66xhNmaf3pPliHsS0FvgxItrthYZorYv9AXm1aklj1WV6mvsPwQvsx3yUp3Tsi85nmnaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983602; c=relaxed/simple;
	bh=eXNfrQ6D0F3R/UC318r6tpj4HCNadCbLoap5pPUNjfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8VzNh1mfQGWIHbg5kSjv4dl4TQl6Zt0FhCdEhYUVD/B4opLeYHMAm6f4oEiYE6EXvFNhq51Ce+CfnuPUAbXl0rMdaz0Cs+VfgAeZc+a2ZPK6dd0dyxJpzdFgLZD2ihtIxyK53xvS/Ssf9reR82FAUuqBRk6z6w1QHQBmoQoj1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HKZb7ebQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HKZb7ebQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05452C116D0;
	Wed, 25 Feb 2026 01:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983602;
	bh=eXNfrQ6D0F3R/UC318r6tpj4HCNadCbLoap5pPUNjfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HKZb7ebQXsZcVwv4GO65vVTpeKl0UiIWVY0Ade/EzXJNtRLdLsCN0T3+vlTCIq4yx
	 phbRNrnCmjOQBSXQC42ts+GkF+bbgrpTjOLmePr7odJIVa5NqxsL+wE6/OgVe7c7Ad
	 Fqk3lySjv3hbUZEki8eECvI3DvL6uOnn9XpLgIug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 674/781] ping: annotate data-races in ping_lookup()
Date: Tue, 24 Feb 2026 17:23:03 -0800
Message-ID: <20260225012416.312156029@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index cfbd563498e85..0fec4e5645667 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -148,7 +148,7 @@ void ping_unhash(struct sock *sk)
 	pr_debug("ping_unhash(isk=%p,isk->num=%u)\n", isk, isk->inet_num);
 	spin_lock(&ping_table.lock);
 	if (sk_del_node_init_rcu(sk)) {
-		isk->inet_num = 0;
+		WRITE_ONCE(isk->inet_num, 0);
 		isk->inet_sport = 0;
 		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
 	}
@@ -181,31 +181,35 @@ static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
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
@@ -216,8 +220,8 @@ static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
 			continue;
 		}
 
-		if (sk->sk_bound_dev_if && sk->sk_bound_dev_if != dif &&
-		    sk->sk_bound_dev_if != sdif)
+		if (bound_dev_if && bound_dev_if != dif &&
+		    bound_dev_if != sdif)
 			continue;
 
 		goto exit;
@@ -392,7 +396,9 @@ static void ping_set_saddr(struct sock *sk, struct sockaddr_unsized *saddr)
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
@@ -849,7 +855,8 @@ int ping_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags,
 	struct sk_buff *skb;
 	int copied, err;
 
-	pr_debug("ping_recvmsg(sk=%p,sk->num=%u)\n", isk, isk->inet_num);
+	pr_debug("ping_recvmsg(sk=%p,sk->num=%u)\n", isk,
+		 READ_ONCE(isk->inet_num));
 
 	err = -EOPNOTSUPP;
 	if (flags & MSG_OOB)
-- 
2.51.0



