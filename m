Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027089;
	b=kv8yZysbxxQvRk/dNEujeAU84OoCF05GfRehHw1M2EtZ4QMCJG1rXCiOfOTDcRV0i+0l
	 QiWJ+/fuaDAgbm95oDYPZxaWq44QRNBPuF2Afwqzusk2Rt4Zor7GZT7sH7P/PvoVj0T3F
	 7eA6pJVHAwwmhbn4T8ztLi9n5Rjlxn9vrFKEkuJhtlvB+6ZEfnPFJpF9lvRvr3lXAZk6k
	 1xFh91L2XT6P65DA5/FUt4u4tVdWvApsabIPk428/CEbRYnneB7riQkBzrMtWglueY9Ar
	 MzbkBfKt0bkWq/kRd2LG7wclPAOQn31VLZsv0jl+LaHkWhnpgXf70Fq5ewPAqQZybSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027089;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OC6SHXTUa9UwLJQzuvHwI8BdqTUFteLt1NfqO2kyi64=;
	b=Qd4AYcgOm894TEpXNVWkpql/zRWLKDd+NGQq5SwsGGSNqP77TPhagd3Kw/YW5B3+bkIF
	 k2qWa+l2YGJZmfpsyYYwtEZd2v0FB2Yc1Igbv+owyY9DscpUr/awjjhixteq6jtzkzn5J
	 cG/6JlJ+LudrsXYoEXkA0VdIKw8Z93y84n7gvbfHcKLQ/x5RTGULETyGp9txsCLQLWh6z
	 sgyFKjMW0xxezAV9m8H/4TeWFyGoui9QpMBKSvEgZKchOBezhm7c/Q5xGxe9w2/vTWFIY
	 FPnwcAvY3Fp2NMMbqODEdv3EvkriuQSeobCUsMXDFjn9ntgjBWKBxDwZLMwegLYpUug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Er/L9QY5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FFE606A31C;
	Wed, 18 Nov 2026 18:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Er/L9QY5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8E31F000C4;
	Wed, 18 Nov 2026 18:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027089;
	bh=OC6SHXTUa9UwLJQzuvHwI8BdqTUFteLt1NfqO2kyi64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Er/L9QY5Jqtlyg7Oak2tBhHM9uWsPi64ARvZ/otntOJyAGV3jeE++e+JxiusWTw+A
	 SU9l7ckgobnacNcY6IB7XUpRcluUO9QNqhy1tDC5e2BSAkLdyg3qrHQIWFB/Qb3key
	 BtlyhQ1WAiZPM4/xfqlofQg/y6uKJgb4LkcRGRJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1666/2151] tcp: use the echoed source route in cookie_v4_check()
Date: Wed, 18 Nov 2026 15:56:41 +0100
Message-ID: <20261118150222.527964071@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 54d574d4afd9de820c8a017665c8095f0f5fdbaa ]

When the ACK carries a source route option, cookie_v4_check() routes
the new socket to opt->faddr, where opt points to the options of the
received packet.

ip_options_compile() only fills faddr for options given by
setsockopt() (when called without an skb), so on receive faddr is 0
and the lookup is done for daddr 0, which gives a local route.

Use the options echoed by tcp_v4_save_options() instead, as
inet_csk_route_req() and inet_csk_route_child_sock() do with
ireq->ireq_opt. Read them after security_inet_conn_request(),
since CIPSO can replace ireq->ireq_opt there.

The route now goes to the first hop of the source route, so also
refuse a strict source route through a gateway, as
inet_csk_route_req() does.

Found by sashiko while reviewing the sk_mc_loop() fix.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261012101029.927296-3-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/syncookies.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index d2db09bc7e29e..39dd078cd7034 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -406,12 +406,12 @@ static struct request_sock *cookie_tcp_check(struct net *net, struct sock *sk,
  */
 struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 {
-	struct ip_options *opt = &TCP_SKB_CB(skb)->header.h4.opt;
 	const struct tcphdr *th = tcp_hdr(skb);
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct inet_request_sock *ireq;
 	struct net *net = sock_net(sk);
 	struct tcp_request_sock *treq;
+	struct ip_options_rcu *opt;
 	struct request_sock *req;
 	struct sock *ret = sk;
 	struct flowi4 fl4;
@@ -451,6 +451,8 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 		SKB_DR_SET(reason, SECURITY_HOOK);
 		goto out_free;
 	}
+	/* Load ireq->ireq_opt after the LSM hook, which can replace it. */
+	opt = rcu_dereference_protected(ireq->ireq_opt, true);
 
 	tcp_ao_syncookie(sk, skb, req, AF_INET);
 
@@ -463,7 +465,7 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 	flowi4_init_output(&fl4, ireq->ir_iif, ireq->ir_mark,
 			   ip_sock_rt_tos(sk), ip_sock_rt_scope(sk),
 			   IPPROTO_TCP, inet_sk_flowi_flags(sk),
-			   opt->srr ? opt->faddr : ireq->ir_rmt_addr,
+			   (opt && opt->opt.srr) ? opt->opt.faddr : ireq->ir_rmt_addr,
 			   ireq->ir_loc_addr, th->source, th->dest,
 			   sk_uid(sk));
 	security_req_classify_flow(req, flowi4_to_flowi_common(&fl4));
@@ -472,6 +474,12 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 		SKB_DR_SET(reason, IP_OUTNOROUTES);
 		goto out_free;
 	}
+	/* Same check as in inet_csk_route_req(). */
+	if (opt && opt->opt.is_strictroute && rt->rt_uses_gateway) {
+		ip_rt_put(rt);
+		SKB_DR_SET(reason, IP_OUTNOROUTES);
+		goto out_free;
+	}
 
 	/* Try to redo what tcp_v4_send_synack did. */
 	req->rsk_window_clamp = READ_ONCE(tp->window_clamp) ? :
-- 
2.53.0



