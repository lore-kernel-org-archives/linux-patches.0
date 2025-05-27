Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69855194A45;
	Tue, 27 May 2025 17:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368363; cv=none; b=bd7xjG9fSvSnVhINaT6SjCb4fHAWesHpGVm+dab7v3PL95E6dCI0f3D21jBdzLEXzR6+pNc0juWbUuCd+4MeL0i9m+NzoSCFO++pSGwk0N1W6tLqlWc9AY3IBgh7whBDqPVdhtwL/W7t3WDUWCHLmCr25wfyjBrZNchBMoZsv6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368363; c=relaxed/simple;
	bh=JY+IM0aS5V2rQSBxRzcMMLUkTyDHAzm+Nlkdtr+RzVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M1hoHYcEO05bbS9RoQMVQmZpAeh9+mOigVMnLSeeLX8T2Fs3iGG0R5T5Lmiqz0ytMFAcO8iAiEYYmHGXHLGgeKGJPn1uAMKqX50IOh/N6dzS466NIjn3zC5VrB8f0SQ0uozUc+NCRB8P2ZjrAbYaw17xHPO+1rgPV9xfDCcWhNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AXaZH9X3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AXaZH9X3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B84C4CEE9;
	Tue, 27 May 2025 17:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368362;
	bh=JY+IM0aS5V2rQSBxRzcMMLUkTyDHAzm+Nlkdtr+RzVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AXaZH9X3CAOtE7EuHbfKk/GNIL/x03e63YY7IU8K/y0pRqA5/B/Z3nmNTNukkw/jW
	 KOpN9rSfD9vHtrLhLgKRkfRIDw8Thu7MJsBWkO8v0682xEa86B7tXAGdsPjR0GXdJM
	 uZmWP+uvX0aqIvxReNlhEVmT/BjUcBmzuz4SPY3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 683/783] espintcp: remove encap socket caching to avoid reference leak
Date: Tue, 27 May 2025 18:28:00 +0200
Message-ID: <20250527162540.941707066@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index e1eed5d47d072..03a1ed1e610b2 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -236,7 +236,6 @@ struct xfrm_state {
 
 	/* Data for encapsulator */
 	struct xfrm_encap_tmpl	*encap;
-	struct sock __rcu	*encap_sk;
 
 	/* NAT keepalive */
 	u32			nat_keepalive_interval; /* seconds */
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 876df672c0bfa..f14a41ee4aa10 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -120,47 +120,16 @@ static void esp_ssg_unref(struct xfrm_state *x, void *tmp, struct sk_buff *skb)
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
 	struct net *net = xs_net(x);
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
 
 	sk = inet_lookup_established(net, net->ipv4.tcp_death_row.hashinfo, x->id.daddr.a4,
@@ -173,20 +142,6 @@ static struct sock *esp_find_tcp_sk(struct xfrm_state *x)
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
 
@@ -211,6 +166,8 @@ static int esp_output_tcp_finish(struct xfrm_state *x, struct sk_buff *skb)
 		err = espintcp_push_skb(sk, skb);
 	bh_unlock_sock(sk);
 
+	sock_put(sk);
+
 out:
 	rcu_read_unlock();
 	return err;
@@ -394,6 +351,8 @@ static struct ip_esp_hdr *esp_output_tcp_encap(struct xfrm_state *x,
 	if (IS_ERR(sk))
 		return ERR_CAST(sk);
 
+	sock_put(sk);
+
 	*lenp = htons(len);
 	esph = (struct ip_esp_hdr *)(lenp + 1);
 
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 574989b82179c..72adfc107b557 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -137,47 +137,16 @@ static void esp_ssg_unref(struct xfrm_state *x, void *tmp, struct sk_buff *skb)
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
 	struct net *net = xs_net(x);
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
 
 	sk = __inet6_lookup_established(net, net->ipv4.tcp_death_row.hashinfo, &x->id.daddr.in6,
@@ -190,20 +159,6 @@ static struct sock *esp6_find_tcp_sk(struct xfrm_state *x)
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
 
@@ -228,6 +183,8 @@ static int esp_output_tcp_finish(struct xfrm_state *x, struct sk_buff *skb)
 		err = espintcp_push_skb(sk, skb);
 	bh_unlock_sock(sk);
 
+	sock_put(sk);
+
 out:
 	rcu_read_unlock();
 	return err;
@@ -424,6 +381,8 @@ static struct ip_esp_hdr *esp6_output_tcp_encap(struct xfrm_state *x,
 	if (IS_ERR(sk))
 		return ERR_CAST(sk);
 
+	sock_put(sk);
+
 	*lenp = htons(len);
 	esph = (struct ip_esp_hdr *)(lenp + 1);
 
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 69af5964c886c..fa8a8776d5397 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -838,9 +838,6 @@ int __xfrm_state_delete(struct xfrm_state *x)
 		xfrm_nat_keepalive_state_updated(x);
 		spin_unlock(&net->xfrm.xfrm_state_lock);
 
-		if (x->encap_sk)
-			sock_put(rcu_dereference_raw(x->encap_sk));
-
 		xfrm_dev_state_delete(x);
 
 		/* All xfrm_state objects are created by xfrm_state_alloc.
-- 
2.39.5



