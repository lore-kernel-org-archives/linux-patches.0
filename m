Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625398;
	b=lc7uIlMaAS8GYdmQpWABHKicmk0S5oGrkKG/2jH7ci55iv1sbLQ8EXo8vzOhH0vM+IvC
	 AYF2qfcJ0WFtXC+Ra1GZlRjTrbUD6ePY2hmVMpmslGgpg+6/kDZMoXrpGnkkgygehMaEt
	 dfP2RclEWgC2qfJpra25JSukLDqHmV5yLPstqwj61I8Gys9SaFi4ArTDj6eYf89OLun90
	 FhfY7sZ4xNUgFyI+frrDkaw6eXxaHW2xJmGYmdEaePzSulP6llwe3zLuaVG/9m4KM4P6J
	 ZDBrlcofm5IUwJQY5DLrCyZnVRJ3c16NdeUpBs2kB6QMb11vMdGnZqLg9z9+AB8IcAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625398;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dqDz2wOHjItIgcc2nh29E4x9cEzkLmEucW66Wd6MBdc=;
	b=1oi3YghvYBE869RPL1sfxVZhrQt7QFEIGTJ0tdESYkiMCcL36HAJaaxIgj8YWNYj8kcn
	 C7UtACL4CKezfoLZAwYP0yMIcrZS3QWYioaT/blVh6YSgSffClCoiyP72z8+u0bOomnQ8
	 +q1DdgPTyX8EDsD/WbOHQKL/OTuBQuIdGdx5KoqLLzK4eczxoMfblGBtNVMAsId4qo84s
	 aqTPZALtRTgn03rk139kCK2fVkHfoOKAuAJua2NR+7osHYn3J0ZjvFwps4GMOrjhvG2T1
	 8Tmp52N2sMDYQxWScGJMkw52TmLjsvsOKfYVUtulvD/I4673pE7vjiiKqn9GFN666OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KnRYe99v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F619606A326;
	Wed, 25 Nov 2026 16:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KnRYe99v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8911F000EE;
	Wed, 25 Nov 2026 16:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625398;
	bh=dqDz2wOHjItIgcc2nh29E4x9cEzkLmEucW66Wd6MBdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KnRYe99vxU7k3cDsX2Smv+HTC/bLbGD2q46Uk9Zu8xHVj3lZTI5ZZ5u0g212y88Os
	 S/M/xYAZWZygWkD+BXzscA3Y2HcB8TMY9Bwm2uWE/Ixu2Wbp86WJHFyCCiFdC8F8Sp
	 qYLKiVhp/0DtpdGK2masGua+RBs3V3sLOCmN13ZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 502/816] tcp: use the echoed source route in cookie_v4_check()
Date: Wed, 25 Nov 2026 15:34:10 +0100
Message-ID: <20261125143900.808525278@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted the conflict context in cookie_v4_check(): dropped the missing treq local from the declarations and kept sk->sk_uid instead of the sk_uid(sk) helper. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/syncookies.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 43cf33f282c15..8177725e9dd22 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -404,11 +404,11 @@ static struct request_sock *cookie_tcp_check(struct net *net, struct sock *sk,
  */
 struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 {
-	struct ip_options *opt = &TCP_SKB_CB(skb)->header.h4.opt;
 	const struct tcphdr *th = tcp_hdr(skb);
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct inet_request_sock *ireq;
 	struct net *net = sock_net(sk);
+	struct ip_options_rcu *opt;
 	struct request_sock *req;
 	struct sock *ret = sk;
 	struct flowi4 fl4;
@@ -447,6 +447,8 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 		SKB_DR_SET(reason, SECURITY_HOOK);
 		goto out_free;
 	}
+	/* Load ireq->ireq_opt after the LSM hook, which can replace it. */
+	opt = rcu_dereference_protected(ireq->ireq_opt, true);
 
 	tcp_ao_syncookie(sk, skb, req, AF_INET);
 
@@ -459,7 +461,7 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 	flowi4_init_output(&fl4, ireq->ir_iif, ireq->ir_mark,
 			   ip_sock_rt_tos(sk), ip_sock_rt_scope(sk),
 			   IPPROTO_TCP, inet_sk_flowi_flags(sk),
-			   opt->srr ? opt->faddr : ireq->ir_rmt_addr,
+			   (opt && opt->opt.srr) ? opt->opt.faddr : ireq->ir_rmt_addr,
 			   ireq->ir_loc_addr, th->source, th->dest, sk->sk_uid);
 	security_req_classify_flow(req, flowi4_to_flowi_common(&fl4));
 	rt = ip_route_output_key(net, &fl4);
@@ -467,6 +469,12 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
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



