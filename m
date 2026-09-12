Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DC12D0C94;
	Sat, 12 Sep 2026 19:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241804; cv=none; b=cN09I9XRYuLlouUr+0lqyLTk23IcWBD36hf7tKAcD9JFo7/Qljtu7RegWMlX7BFHtPcZ2e7thC1lpq18/Y65yEekbyZ2pdy7ZHR81KUyzZjhBk18/IBsEBfDaZVkFEe88t6sHdpUBuMtioKUvzvpwidv5LncToCJ/9nOTG9dSS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241804; c=relaxed/simple;
	bh=6IaD4NXWdfpkBZbjA+1WMHXVzQVHrSF4FX0mF1EUYz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8HJLWT/n5gHKmyzKSkokYlvFTCIVRDoRRamopLAG8MJXU+kxT16a98sUcK8TrQfYHWo8mH9+Raa8+ebWYsaMLaW6yoO69Rnd6OVux7SmhahVF7vC1uR14KTQHvC3K9T9GocOX3Dj6y9CxNnlMHCzfkNh1CXlxEsomHlfMFYY4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZfAlUX2O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZfAlUX2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580E41F00893;
	Sat, 12 Sep 2026 19:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241803;
	bh=G3Oyvs3swztPiK4B/DXXPR2Ox1CH2lNgSjY27RrRYI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZfAlUX2OsCy+PrI43ZgzMsWpwOgXk603Zq04rWGNt+B1tnJFw8iBNVRye5+t2uaT+
	 LRBmyjnKCrfxgfESw2ri9dJVwqEgXlRo+cpKegEj99Bds9lVqOKBQkQ3OY0XfUJtpN
	 RsPVeelX4qNfEBloyH8KOBwsmmhouFIILSGFjWmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 212/798] espintcp: remove encap socket caching to avoid reference leak
Date: Sat, 12 Sep 2026 08:57:20 +0200
Message-ID: <20260912065521.965285418@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 028363685bd0b7a19b4a820f82dd905b1dc83999 ]

The current scheme for caching the encap socket can lead to reference
leaks when we try to delete the netns.

The reference chain is: xfrm_state -> enacp_sk -> netns

Since the encap socket is a userspace socket, it holds a reference on
the netns. If we delete the espintcp state (through flush or
individual delete) before removing the netns, the reference on the
socket is dropped and the netns is correctly deleted. Otherwise, the
netns may not be reachable anymore (if all processes within the ns
have terminated), so we cannot delete the xfrm state to drop its
reference on the socket.

This patch results in a small (~2% in my tests) performance
regression.

A GC-type mechanism could be added for the socket cache, to clear
references if the state hasn't been used "recently", but it's a lot
more complex than just not caching the socket.

Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xfrm.h    |  1 -
 net/ipv4/esp4.c       | 49 ++++---------------------------------------
 net/ipv6/esp6.c       | 49 ++++---------------------------------------
 net/xfrm/xfrm_state.c |  3 ---
 4 files changed, 8 insertions(+), 94 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 695b73b355eed..bde58fa26d576 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -206,7 +206,6 @@ struct xfrm_state {
 
 	/* Data for encapsulator */
 	struct xfrm_encap_tmpl	*encap;
-	struct sock __rcu	*encap_sk;
 
 	/* Data for care-of address */
 	xfrm_address_t	*coaddr;
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 496c7d40facf5..4be911588db0c 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -120,46 +120,15 @@ static void esp_ssg_unref(struct xfrm_state *x, void *tmp)
 }
 
 #ifdef CONFIG_INET_ESPINTCP
-struct esp_tcp_sk {
-	struct sock *sk;
-	struct rcu_head rcu;
-};
-
-static void esp_free_tcp_sk(struct rcu_head *head)
-{
-	struct esp_tcp_sk *esk = container_of(head, struct esp_tcp_sk, rcu);
-
-	sock_put(esk->sk);
-	kfree(esk);
-}
-
 static struct sock *esp_find_tcp_sk(struct xfrm_state *x)
 {
 	struct xfrm_encap_tmpl *encap = x->encap;
-	struct esp_tcp_sk *esk;
 	__be16 sport, dport;
-	struct sock *nsk;
 	struct sock *sk;
 
-	sk = rcu_dereference(x->encap_sk);
-	if (sk && sk->sk_state == TCP_ESTABLISHED)
-		return sk;
-
 	spin_lock_bh(&x->lock);
 	sport = encap->encap_sport;
 	dport = encap->encap_dport;
-	nsk = rcu_dereference_protected(x->encap_sk,
-					lockdep_is_held(&x->lock));
-	if (sk && sk == nsk) {
-		esk = kmalloc(sizeof(*esk), GFP_ATOMIC);
-		if (!esk) {
-			spin_unlock_bh(&x->lock);
-			return ERR_PTR(-ENOMEM);
-		}
-		RCU_INIT_POINTER(x->encap_sk, NULL);
-		esk->sk = sk;
-		call_rcu(&esk->rcu, esp_free_tcp_sk);
-	}
 	spin_unlock_bh(&x->lock);
 
 	sk = inet_lookup_established(xs_net(x), &tcp_hashinfo, x->id.daddr.a4,
@@ -172,20 +141,6 @@ static struct sock *esp_find_tcp_sk(struct xfrm_state *x)
 		return ERR_PTR(-EINVAL);
 	}
 
-	spin_lock_bh(&x->lock);
-	nsk = rcu_dereference_protected(x->encap_sk,
-					lockdep_is_held(&x->lock));
-	if (encap->encap_sport != sport ||
-	    encap->encap_dport != dport) {
-		sock_put(sk);
-		sk = nsk ?: ERR_PTR(-EREMCHG);
-	} else if (sk == nsk) {
-		sock_put(sk);
-	} else {
-		rcu_assign_pointer(x->encap_sk, sk);
-	}
-	spin_unlock_bh(&x->lock);
-
 	return sk;
 }
 
@@ -208,6 +163,8 @@ static int esp_output_tcp_finish(struct xfrm_state *x, struct sk_buff *skb)
 		err = espintcp_push_skb(sk, skb);
 	bh_unlock_sock(sk);
 
+	sock_put(sk);
+
 out:
 	rcu_read_unlock();
 	return err;
@@ -395,6 +352,8 @@ static struct ip_esp_hdr *esp_output_tcp_encap(struct xfrm_state *x,
 	if (IS_ERR(sk))
 		return ERR_CAST(sk);
 
+	sock_put(sk);
+
 	*lenp = htons(len);
 	esph = (struct ip_esp_hdr *)(lenp + 1);
 
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index f743d7474bdcc..74c0dbb2b0e95 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -136,46 +136,15 @@ static void esp_ssg_unref(struct xfrm_state *x, void *tmp)
 }
 
 #ifdef CONFIG_INET6_ESPINTCP
-struct esp_tcp_sk {
-	struct sock *sk;
-	struct rcu_head rcu;
-};
-
-static void esp_free_tcp_sk(struct rcu_head *head)
-{
-	struct esp_tcp_sk *esk = container_of(head, struct esp_tcp_sk, rcu);
-
-	sock_put(esk->sk);
-	kfree(esk);
-}
-
 static struct sock *esp6_find_tcp_sk(struct xfrm_state *x)
 {
 	struct xfrm_encap_tmpl *encap = x->encap;
-	struct esp_tcp_sk *esk;
 	__be16 sport, dport;
-	struct sock *nsk;
 	struct sock *sk;
 
-	sk = rcu_dereference(x->encap_sk);
-	if (sk && sk->sk_state == TCP_ESTABLISHED)
-		return sk;
-
 	spin_lock_bh(&x->lock);
 	sport = encap->encap_sport;
 	dport = encap->encap_dport;
-	nsk = rcu_dereference_protected(x->encap_sk,
-					lockdep_is_held(&x->lock));
-	if (sk && sk == nsk) {
-		esk = kmalloc(sizeof(*esk), GFP_ATOMIC);
-		if (!esk) {
-			spin_unlock_bh(&x->lock);
-			return ERR_PTR(-ENOMEM);
-		}
-		RCU_INIT_POINTER(x->encap_sk, NULL);
-		esk->sk = sk;
-		call_rcu(&esk->rcu, esp_free_tcp_sk);
-	}
 	spin_unlock_bh(&x->lock);
 
 	sk = __inet6_lookup_established(xs_net(x), &tcp_hashinfo, &x->id.daddr.in6,
@@ -188,20 +157,6 @@ static struct sock *esp6_find_tcp_sk(struct xfrm_state *x)
 		return ERR_PTR(-EINVAL);
 	}
 
-	spin_lock_bh(&x->lock);
-	nsk = rcu_dereference_protected(x->encap_sk,
-					lockdep_is_held(&x->lock));
-	if (encap->encap_sport != sport ||
-	    encap->encap_dport != dport) {
-		sock_put(sk);
-		sk = nsk ?: ERR_PTR(-EREMCHG);
-	} else if (sk == nsk) {
-		sock_put(sk);
-	} else {
-		rcu_assign_pointer(x->encap_sk, sk);
-	}
-	spin_unlock_bh(&x->lock);
-
 	return sk;
 }
 
@@ -224,6 +179,8 @@ static int esp_output_tcp_finish(struct xfrm_state *x, struct sk_buff *skb)
 		err = espintcp_push_skb(sk, skb);
 	bh_unlock_sock(sk);
 
+	sock_put(sk);
+
 out:
 	rcu_read_unlock();
 	return err;
@@ -430,6 +387,8 @@ static struct ip_esp_hdr *esp6_output_tcp_encap(struct xfrm_state *x,
 	if (IS_ERR(sk))
 		return ERR_CAST(sk);
 
+	sock_put(sk);
+
 	*lenp = htons(len);
 	esph = (struct ip_esp_hdr *)(lenp + 1);
 
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index c5412f2e3b208..69e3153ecdcd5 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -667,9 +667,6 @@ int __xfrm_state_delete(struct xfrm_state *x)
 		net->xfrm.state_num--;
 		spin_unlock(&net->xfrm.xfrm_state_lock);
 
-		if (x->encap_sk)
-			sock_put(rcu_dereference_raw(x->encap_sk));
-
 		xfrm_dev_state_delete(x);
 
 		xfrm_state_delete_tunnel(x);
-- 
2.53.0



