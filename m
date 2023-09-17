Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A1A7461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1288C433C8;
	Sun, 17 Sep 2023 19:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980725;
	bh=5DrVpYTssS+E7IAE61X66L5ZIlUXgmiuzZqaQmQhVPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AREbjO0bHm0l+3MTr9gPeBUVzXLMuI4EkzfW4RzbOOP1hU4PVPJLhyTMJ9xfxAwRT
	 ZGwmfZYMEs1ZMGrsa50AAbWUaSc6Cbx8eGdkAeJZZHTVgL0AegFYCFaQnUu3b9xBRO
	 RCXwwQIjh+smOV4A+APmJI7ZrU5jEAMNJOesH8V8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 276/285] tcp: Factorise sk_family-independent comparison in inet_bind2_bucket_match(_addr_any).
Date: Sun, 17 Sep 2023 21:14:36 +0200
Message-ID: <20230917191100.704518449@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit c6d277064b1da7f9015b575a562734de87a7e463 ]

This is a prep patch to make the following patches cleaner that touch
inet_bind2_bucket_match() and inet_bind2_bucket_match_addr_any().

Both functions have duplicated comparison for netns, port, and l3mdev.
Let's factorise them.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: aa99e5f87bd5 ("tcp: Fix bind() regression for v4-mapped-v6 wildcard address.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_hashtables.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 0819d6001b9ab..1ab81534f8c55 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -795,41 +795,39 @@ static bool inet_bind2_bucket_match(const struct inet_bind2_bucket *tb,
 				    const struct net *net, unsigned short port,
 				    int l3mdev, const struct sock *sk)
 {
+	if (!net_eq(ib2_net(tb), net) || tb->port != port ||
+	    tb->l3mdev != l3mdev)
+		return false;
+
 #if IS_ENABLED(CONFIG_IPV6)
 	if (sk->sk_family != tb->family)
 		return false;
 
 	if (sk->sk_family == AF_INET6)
-		return net_eq(ib2_net(tb), net) && tb->port == port &&
-			tb->l3mdev == l3mdev &&
-			ipv6_addr_equal(&tb->v6_rcv_saddr, &sk->sk_v6_rcv_saddr);
-	else
+		return ipv6_addr_equal(&tb->v6_rcv_saddr, &sk->sk_v6_rcv_saddr);
 #endif
-		return net_eq(ib2_net(tb), net) && tb->port == port &&
-			tb->l3mdev == l3mdev && tb->rcv_saddr == sk->sk_rcv_saddr;
+	return tb->rcv_saddr == sk->sk_rcv_saddr;
 }
 
 bool inet_bind2_bucket_match_addr_any(const struct inet_bind2_bucket *tb, const struct net *net,
 				      unsigned short port, int l3mdev, const struct sock *sk)
 {
+	if (!net_eq(ib2_net(tb), net) || tb->port != port ||
+	    tb->l3mdev != l3mdev)
+		return false;
+
 #if IS_ENABLED(CONFIG_IPV6)
 	if (sk->sk_family != tb->family) {
 		if (sk->sk_family == AF_INET)
-			return net_eq(ib2_net(tb), net) && tb->port == port &&
-				tb->l3mdev == l3mdev &&
-				ipv6_addr_any(&tb->v6_rcv_saddr);
+			return ipv6_addr_any(&tb->v6_rcv_saddr);
 
 		return false;
 	}
 
 	if (sk->sk_family == AF_INET6)
-		return net_eq(ib2_net(tb), net) && tb->port == port &&
-			tb->l3mdev == l3mdev &&
-			ipv6_addr_any(&tb->v6_rcv_saddr);
-	else
+		return ipv6_addr_any(&tb->v6_rcv_saddr);
 #endif
-		return net_eq(ib2_net(tb), net) && tb->port == port &&
-			tb->l3mdev == l3mdev && tb->rcv_saddr == 0;
+	return tb->rcv_saddr == 0;
 }
 
 /* The socket's bhash2 hashbucket spinlock must be held when this is called */
-- 
2.40.1



