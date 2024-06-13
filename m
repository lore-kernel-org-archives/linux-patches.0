Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9260144313;
	Thu, 13 Jun 2024 12:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280853; cv=none; b=NhsR/MYS7k7BFI6L5v63VGLwc4F8IIfO4biDA6rxGqnagb0QbzQ06DPJoymyCQSdk0feZZdhRxpN61eE/WwSiFT4fwi9p8WvaAfPA0RUtwvZIWfpOGSLzD4vds8NhBHbxjXVbvAIh4JBg6PsYa4uAK+B8LQ3fx4FUameOaeSPXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280853; c=relaxed/simple;
	bh=rv7tVCJNHaRVZ0a4Nad/Upmni0256kwWxG58zEJPCB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0rK9PcTEjlDR1mBsrxsgo+usIBL4WYbSMluO3dOZ8dC99oXoxpX0VI+PwQ977V2IxaOYTQRrMTLcoo/VEdKkn64SEsjsx9d4cs1NI4i/LdqgEdoTYCHHKvVWkAhiASPulpjVE2QwUwaOcB068B0aadAqMizV08gIZxZyf/YsDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PtE0O6CC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PtE0O6CC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40179C2BBFC;
	Thu, 13 Jun 2024 12:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280853;
	bh=rv7tVCJNHaRVZ0a4Nad/Upmni0256kwWxG58zEJPCB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PtE0O6CCPkj3w1yQltpdnCuxdMmqX9pAIkXFOEYgL4hEmMXr9OQvDkng0fuxM1whT
	 lPe11PRRTZt2R5vKfOtB5YDZs5qNFiVvuqkiwHw5fZt6ZfJN/S7k3gpUCm6T8LBamn
	 /9Mtfb6q5+7SMQND2owA/CVXCQbe8TFYHkhV4NfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Lorenz Bauer <lmb@isovalent.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/317] net: export inet_lookup_reuseport and inet6_lookup_reuseport
Date: Thu, 13 Jun 2024 13:31:14 +0200
Message-ID: <20240613113249.715200221@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenz Bauer <lmb@isovalent.com>

[ Upstream commit ce796e60b3b196b61fcc565df195443cbb846ef0 ]

Rename the existing reuseport helpers for IPv4 and IPv6 so that they
can be invoked in the follow up commit. Export them so that building
DCCP and IPv6 as a module works.

No change in functionality.

Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Lorenz Bauer <lmb@isovalent.com>
Link: https://lore.kernel.org/r/20230720-so-reuseport-v6-3-7021b683cdae@isovalent.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Stable-dep-of: 50aee97d1511 ("udp: Avoid call to compute_score on multiple sites")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet6_hashtables.h |  7 +++++++
 include/net/inet_hashtables.h  |  5 +++++
 net/ipv4/inet_hashtables.c     | 15 ++++++++-------
 net/ipv6/inet6_hashtables.c    | 19 ++++++++++---------
 4 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/include/net/inet6_hashtables.h b/include/net/inet6_hashtables.h
index 56f1286583d3c..032ddab48f8f8 100644
--- a/include/net/inet6_hashtables.h
+++ b/include/net/inet6_hashtables.h
@@ -48,6 +48,13 @@ struct sock *__inet6_lookup_established(struct net *net,
 					const u16 hnum, const int dif,
 					const int sdif);
 
+struct sock *inet6_lookup_reuseport(struct net *net, struct sock *sk,
+				    struct sk_buff *skb, int doff,
+				    const struct in6_addr *saddr,
+				    __be16 sport,
+				    const struct in6_addr *daddr,
+				    unsigned short hnum);
+
 struct sock *inet6_lookup_listener(struct net *net,
 				   struct inet_hashinfo *hashinfo,
 				   struct sk_buff *skb, int doff,
diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index c9e387d174c63..94c418d2e345e 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -313,6 +313,11 @@ struct sock *__inet_lookup_established(struct net *net,
 				       const __be32 daddr, const u16 hnum,
 				       const int dif, const int sdif);
 
+struct sock *inet_lookup_reuseport(struct net *net, struct sock *sk,
+				   struct sk_buff *skb, int doff,
+				   __be32 saddr, __be16 sport,
+				   __be32 daddr, unsigned short hnum);
+
 static inline struct sock *
 	inet_lookup_established(struct net *net, struct inet_hashinfo *hashinfo,
 				const __be32 saddr, const __be16 sport,
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index ad050f8476b8e..bea88219d5313 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -252,10 +252,10 @@ static inline int compute_score(struct sock *sk, struct net *net,
 	return score;
 }
 
-static inline struct sock *lookup_reuseport(struct net *net, struct sock *sk,
-					    struct sk_buff *skb, int doff,
-					    __be32 saddr, __be16 sport,
-					    __be32 daddr, unsigned short hnum)
+struct sock *inet_lookup_reuseport(struct net *net, struct sock *sk,
+				   struct sk_buff *skb, int doff,
+				   __be32 saddr, __be16 sport,
+				   __be32 daddr, unsigned short hnum)
 {
 	struct sock *reuse_sk = NULL;
 	u32 phash;
@@ -266,6 +266,7 @@ static inline struct sock *lookup_reuseport(struct net *net, struct sock *sk,
 	}
 	return reuse_sk;
 }
+EXPORT_SYMBOL_GPL(inet_lookup_reuseport);
 
 /*
  * Here are some nice properties to exploit here. The BSD API
@@ -290,8 +291,8 @@ static struct sock *inet_lhash2_lookup(struct net *net,
 		sk = (struct sock *)icsk;
 		score = compute_score(sk, net, hnum, daddr, dif, sdif);
 		if (score > hiscore) {
-			result = lookup_reuseport(net, sk, skb, doff,
-						  saddr, sport, daddr, hnum);
+			result = inet_lookup_reuseport(net, sk, skb, doff,
+						       saddr, sport, daddr, hnum);
 			if (result)
 				return result;
 
@@ -320,7 +321,7 @@ static inline struct sock *inet_lookup_run_bpf(struct net *net,
 	if (no_reuseport || IS_ERR_OR_NULL(sk))
 		return sk;
 
-	reuse_sk = lookup_reuseport(net, sk, skb, doff, saddr, sport, daddr, hnum);
+	reuse_sk = inet_lookup_reuseport(net, sk, skb, doff, saddr, sport, daddr, hnum);
 	if (reuse_sk)
 		sk = reuse_sk;
 	return sk;
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index b4a5e01e12016..2267f973e2df3 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -113,12 +113,12 @@ static inline int compute_score(struct sock *sk, struct net *net,
 	return score;
 }
 
-static inline struct sock *lookup_reuseport(struct net *net, struct sock *sk,
-					    struct sk_buff *skb, int doff,
-					    const struct in6_addr *saddr,
-					    __be16 sport,
-					    const struct in6_addr *daddr,
-					    unsigned short hnum)
+struct sock *inet6_lookup_reuseport(struct net *net, struct sock *sk,
+				    struct sk_buff *skb, int doff,
+				    const struct in6_addr *saddr,
+				    __be16 sport,
+				    const struct in6_addr *daddr,
+				    unsigned short hnum)
 {
 	struct sock *reuse_sk = NULL;
 	u32 phash;
@@ -129,6 +129,7 @@ static inline struct sock *lookup_reuseport(struct net *net, struct sock *sk,
 	}
 	return reuse_sk;
 }
+EXPORT_SYMBOL_GPL(inet6_lookup_reuseport);
 
 /* called with rcu_read_lock() */
 static struct sock *inet6_lhash2_lookup(struct net *net,
@@ -146,8 +147,8 @@ static struct sock *inet6_lhash2_lookup(struct net *net,
 		sk = (struct sock *)icsk;
 		score = compute_score(sk, net, hnum, daddr, dif, sdif);
 		if (score > hiscore) {
-			result = lookup_reuseport(net, sk, skb, doff,
-						  saddr, sport, daddr, hnum);
+			result = inet6_lookup_reuseport(net, sk, skb, doff,
+							saddr, sport, daddr, hnum);
 			if (result)
 				return result;
 
@@ -178,7 +179,7 @@ static inline struct sock *inet6_lookup_run_bpf(struct net *net,
 	if (no_reuseport || IS_ERR_OR_NULL(sk))
 		return sk;
 
-	reuse_sk = lookup_reuseport(net, sk, skb, doff, saddr, sport, daddr, hnum);
+	reuse_sk = inet6_lookup_reuseport(net, sk, skb, doff, saddr, sport, daddr, hnum);
 	if (reuse_sk)
 		sk = reuse_sk;
 	return sk;
-- 
2.43.0



