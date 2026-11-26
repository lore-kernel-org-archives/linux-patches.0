Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705304;
	b=jGGuFCWqy9qo9P2l5YOpEhhybcMMAqxiQZAmwhZQnb3tBp5m8IXO0iYQGs3pTkRfs6hi
	 EInPgxFbObSxtQk2hu3oEMdD5WPghiy7v20/Yolfjqlt6IbIzmZYFO6rg4i5PhuMZmUnT
	 2X144xZS3VqHUgXioEWPdgg/ZnUzugGOqel5k4tzBDOSO8iZb3qNKRipbobodguASL+40
	 iYX2VFauzXLGijuuXnT/Fy5q8wNb1KFubSLABSkNYuVQC5SqlRwwyYzmhcdoIbw4hjQ2d
	 43HaYrTJCB3b1UDuMURBNRMY9FNkJGGiJeFMQFJa+RNUsUv0DsqzahsD4chfTSXttbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705304;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=88Kdk47I2Qv/SaK0ICGx75JboppKfteW4hPpvjWxdBQ=;
	b=gu0jPGk+TxGjy3/dmdLt5KqQk3GGJm8lFKhNXI+rJTns935cgWLVN4jUUpIu+5seDBSv
	 om4zPo6Jzgt3XiD1wfnlQTpZUzTU+fSikiZXag7GY+jeViZny8xlS65xnaIO622dFE7Iz
	 ZlBpCu6z6l4VgOjPpEW/vvv5EXmZ5gg+Y8M237dgoVs8J3I5IHrPerDjyuBMEl3k8fUl6
	 lHKg86O4zw9FzAZiF7GLJKPJIf/9FCrkjvGhWV/5kZg7xnKFfgsXetHtBll1g4zb95yvZ
	 uBoFalv9bdD1ZF31mTKGFIYNfVCbuVTBNxJR4lJNjK0aouensoeecshMh9uZQz/SqSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fkh2tutQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98771606A32E;
	Thu, 26 Nov 2026 15:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fkh2tutQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C4B1F000D0;
	Thu, 26 Nov 2026 15:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705304;
	bh=88Kdk47I2Qv/SaK0ICGx75JboppKfteW4hPpvjWxdBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fkh2tutQF/i/qDdQwCx7XzMrKZeYuw+CWT0HIW7Tt6EucNzF/M4U0Xpi3wrqAjjYA
	 n/uXCeJ46TxVYmOASTfWfSWjJ2G6ILGdUNrD+tBefJ8PH1vPeUtkUtvBdYHWu66kMY
	 F8RPtuM6G+CxKkanm4doCvXBn7WOyi/+0xrNZJLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 152/319] udp: do not use a cross-family sk_rx_dst in early demux
Date: Thu, 26 Nov 2026 15:38:40 +0100
Message-ID: <20261126144010.175579499@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 5636e67320563be743d47706ef4914078c27edb2 ]

A dual-stack UDP socket connected to a v4-mapped address can receive
both IPv4 packets and IPv6 packets using v4-mapped addresses:
ip6_rcv_core() no longer rejects a v4-mapped source since commit
dcc32f4f183a ("ipv6: weaken the v4mapped source check"), which kept
that check only in tcp_v6_conn_request(). ipv6_portaddr_hash() hashes
v4-mapped addresses like IPv4 ones, so both early demux handlers find
the socket, and both __udp4_lib_rcv() and __udp6_lib_rcv() store their
input dst in the same sk->sk_rx_dst.

udp_v6_early_demux() validates the cached dst with dst_check(), but
ipv4_dst_check() ignores the cookie, so an IPv4 dst gets attached to
an IPv6 skb. ip6_rcv_finish_core() then skips the route lookup and
ip_local_deliver() parses the IPv6 header as an IPv4 one: the IPv6
next header and hop limit are read as a fragment offset, and the IPv4
protocol is taken from a source address byte.

The reverse direction looks possible too: per-cpu dsts of IPv6 routes
using nexthop objects have rt->sernum set, and ip6_dst_check() then
ignores the cookie, so udp_v4_early_demux() can attach an IPv6 dst to
an IPv4 skb.

Kyle Zeng reported that such a packet can reach XFRM input still
holding the prefetched, non refcounted, socket set by early demux,
which can then outlive its RCU grace period.

Only use the cached dst if its family matches the packet. Otherwise
fall back to a regular route lookup.

TCP does not have the same problem: sk_ehashfn() hashes a v4-mapped
socket with inet_ehashfn(), while IPv6 lookups use inet6_ehashfn(),
so IPv6 packets do not normally find a v4-mapped TCP socket.

Fixes: 5425077d73e0 ("net: ipv6: Add early demux handler for UDP unicast")
Fixes: c9f2c1ae123a ("udp6: fix socket leak on early demux")
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261106110135.2161204-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp.c | 5 ++++-
 net/ipv6/udp.c | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 65780cf993eac..b3878e610c2a6 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2642,8 +2642,11 @@ int udp_v4_early_demux(struct sk_buff *skb)
 	skb->destructor = sock_efree;
 	dst = rcu_dereference(sk->sk_rx_dst);
 
-	if (dst)
+	/* A dual-stack socket can cache an IPv6 dst. */
+	if (dst && dst->ops->family == AF_INET)
 		dst = dst_check(dst, 0);
+	else
+		dst = NULL;
 	if (dst) {
 		u32 itag = 0;
 
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 21f34a3a4e8ec..46b98f46dca3d 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1108,8 +1108,11 @@ void udp_v6_early_demux(struct sk_buff *skb)
 	skb->destructor = sock_efree;
 	dst = rcu_dereference(sk->sk_rx_dst);
 
-	if (dst)
+	/* A dual-stack socket can cache an IPv4 dst. */
+	if (dst && dst->ops->family == AF_INET6)
 		dst = dst_check(dst, sk->sk_rx_dst_cookie);
+	else
+		dst = NULL;
 	if (dst) {
 		/* set noref for now.
 		 * any place which wants to hold dst has to call
-- 
2.53.0



