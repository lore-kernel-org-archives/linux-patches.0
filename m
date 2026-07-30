Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A24383983;
	Thu, 30 Jul 2026 15:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426762; cv=none; b=mlOAi3EAufA3QTaMFmO3OPBX4An5578h93hIa3vpaA2Q69+RcmcJitdlDtiYlfUuI5CAxLqah8ZRG3ZEQG/l1GWeKibPABhm+TxjnDBQlUBEuSKHVNSphNYgORs8f0SEPeAjZIY+C+MlMTaIf3Ii0yTtfjKwoayVM4kMThVFPvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426762; c=relaxed/simple;
	bh=uptNYTJevq1iMYA09PbPp/KFM9A0VDxb0ajGOBeRKaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SY0/NNOxHF992va5OeYCMBNGNdyHRhGEoDyFq243HTU4I+mbq1PzvGr4QPaF30H1TOCkpCppUlN/ubBeK5gE+d7nBgW2WJRW7P9YTqwJzizv8ovzaFVLN59VoBQvOquTdvVAz/GTwVoaze28aSGbdqd7tXWXsDBm+G71dT7vq0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dIqFF8xv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dIqFF8xv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4461F000E9;
	Thu, 30 Jul 2026 15:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426761;
	bh=MjuQFfE+M0s2Dmkr3vpaN+qJfZyWV7AJhpZy/EdU1VI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dIqFF8xvu3z9pDxenoH3LWt0RV9pHM0LiAiadQWo4tPtaEuiS1/a6WRNHM+1lXa6P
	 +1h9H7wkxfo9jx9rFMnxND9hf7oX+2GWqTe5uxEvm/lCq7Bqgzxqao4alK13xfmAyS
	 lB2cW2jJjyKGLcFdhQAPHKt/zy7HW3QqClbPKJQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 534/602] xfrm: Use nested-BH locking for nat_keepalive_sk_ipv[46]
Date: Thu, 30 Jul 2026 16:15:26 +0200
Message-ID: <20260730141447.241433804@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 9c607d4b6589d4d380a85784514bcf4cceee1e11 ]

nat_keepalive_sk_ipv[46] is a per-CPU variable and relies on disabled BH
for its locking. Without per-CPU locking in local_bh_disable() on
PREEMPT_RT this data structure requires explicit locking.

Use sock_bh_locked which has a sock pointer and a local_lock_t. Use
local_lock_nested_bh() for locking. This change adds only lockdep
coverage and does not alter the functional behaviour for !PREEMPT_RT.

Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://patch.msgid.link/20250512092736.229935-7-bigeasy@linutronix.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 226f4a490d1a ("xfrm: nat_keepalive: avoid double free on send error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_nat_keepalive.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

--- a/net/xfrm/xfrm_nat_keepalive.c
+++ b/net/xfrm/xfrm_nat_keepalive.c
@@ -9,9 +9,13 @@
 #include <net/ip6_checksum.h>
 #include <net/xfrm.h>
 
-static DEFINE_PER_CPU(struct sock *, nat_keepalive_sk_ipv4);
+static DEFINE_PER_CPU(struct sock_bh_locked, nat_keepalive_sk_ipv4) = {
+	.bh_lock = INIT_LOCAL_LOCK(bh_lock),
+};
 #if IS_ENABLED(CONFIG_IPV6)
-static DEFINE_PER_CPU(struct sock *, nat_keepalive_sk_ipv6);
+static DEFINE_PER_CPU(struct sock_bh_locked, nat_keepalive_sk_ipv6) = {
+	.bh_lock = INIT_LOCAL_LOCK(bh_lock),
+};
 #endif
 
 struct nat_keepalive {
@@ -56,10 +60,12 @@ static int nat_keepalive_send_ipv4(struc
 
 	skb_dst_set(skb, &rt->dst);
 
-	sk = *this_cpu_ptr(&nat_keepalive_sk_ipv4);
+	local_lock_nested_bh(&nat_keepalive_sk_ipv4.bh_lock);
+	sk = this_cpu_read(nat_keepalive_sk_ipv4.sock);
 	sock_net_set(sk, net);
 	err = ip_build_and_send_pkt(skb, sk, fl4.saddr, fl4.daddr, NULL, tos);
 	sock_net_set(sk, &init_net);
+	local_unlock_nested_bh(&nat_keepalive_sk_ipv4.bh_lock);
 	return err;
 }
 
@@ -89,15 +95,19 @@ static int nat_keepalive_send_ipv6(struc
 	fl6.fl6_sport = ka->encap_sport;
 	fl6.fl6_dport = ka->encap_dport;
 
-	sk = *this_cpu_ptr(&nat_keepalive_sk_ipv6);
+	local_lock_nested_bh(&nat_keepalive_sk_ipv6.bh_lock);
+	sk = this_cpu_read(nat_keepalive_sk_ipv6.sock);
 	sock_net_set(sk, net);
 	dst = ipv6_stub->ipv6_dst_lookup_flow(net, sk, &fl6, NULL);
-	if (IS_ERR(dst))
+	if (IS_ERR(dst)) {
+		local_unlock_nested_bh(&nat_keepalive_sk_ipv6.bh_lock);
 		return PTR_ERR(dst);
+	}
 
 	skb_dst_set(skb, dst);
 	err = ipv6_stub->ip6_xmit(sk, skb, &fl6, skb->mark, NULL, 0, 0);
 	sock_net_set(sk, &init_net);
+	local_unlock_nested_bh(&nat_keepalive_sk_ipv6.bh_lock);
 	return err;
 }
 #endif
@@ -202,7 +212,7 @@ static void nat_keepalive_work(struct wo
 				      (ctx.next_run - ctx.now) * HZ);
 }
 
-static int nat_keepalive_sk_init(struct sock * __percpu *socks,
+static int nat_keepalive_sk_init(struct sock_bh_locked __percpu *socks,
 				 unsigned short family)
 {
 	struct sock *sk;
@@ -214,22 +224,22 @@ static int nat_keepalive_sk_init(struct
 		if (err < 0)
 			goto err;
 
-		*per_cpu_ptr(socks, i) = sk;
+		per_cpu_ptr(socks, i)->sock = sk;
 	}
 
 	return 0;
 err:
 	for_each_possible_cpu(i)
-		inet_ctl_sock_destroy(*per_cpu_ptr(socks, i));
+		inet_ctl_sock_destroy(per_cpu_ptr(socks, i)->sock);
 	return err;
 }
 
-static void nat_keepalive_sk_fini(struct sock * __percpu *socks)
+static void nat_keepalive_sk_fini(struct sock_bh_locked __percpu *socks)
 {
 	int i;
 
 	for_each_possible_cpu(i)
-		inet_ctl_sock_destroy(*per_cpu_ptr(socks, i));
+		inet_ctl_sock_destroy(per_cpu_ptr(socks, i)->sock);
 }
 
 void xfrm_nat_keepalive_state_updated(struct xfrm_state *x)


