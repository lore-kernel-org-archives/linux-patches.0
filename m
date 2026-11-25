Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619305;
	b=V0fb2rqXBxyMOAetIEyTnP/liO0kEDIGQNQdNeVR9+hspHzDoi+jWnmalCP6n0x7YhT6
	 ZmNVRy/Z+jvGzwC32uD/tpOFcG9bXf1EEn0wlQ/8TMOJovQTtUVe28LtUPJouD2I29d4b
	 7SpuZVml1dj9bUWG/6CDGLK7A2/slk+JRs2/ZbtaTcp6DOMq6TnCq9aF0ct7QPuTMekMj
	 XcuezTufSCu4q2ApGEIkKDCGE9WY1yJRaUsuEzWzsSHgruunCLYqzvOZsbP0fW6hyseJo
	 oT33wnSUVjEx45piKHqISqHq82FkEaP1BxZXb3DmVZW3E36iuf0oC8YUQ9Z9G0VgIAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619305;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VllzmHgt26o1xzOxUizcj6VM7YQIw/aZfyxwo25X1Bw=;
	b=UzRVCbVa+vCu8gwVZU7pJK5+o93U4x0Z3teFUzU8wzZJPdqPJRlJDOHY6feei4rIeYjD
	 dQN1zi5BjpuV74R2Uvun+LRbnqkMQpeR+fQDBmqwE43DbgOGJEwavj1wFlpirj5wtHkwF
	 EXuzGCxvSLQegA/jhCLMBXbP5Lrf3YQP8CSv5p2Im7Zi30iU+7CWTty4BE7CwEimE08xL
	 2F20NVxnrUVBXLhtwM1E9UhAXEpyynU9j9XOUunxPO1I1SuO5RIwtcxpnBYmV/GtYo6Pr
	 rgZ4IppYpASz0GuMZrCCk6JUtXwWy5+oq2rczW6O5s4/4+Y9eagA+ZxkEQzLzQ888vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HCHYvBht;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DEB606A321;
	Wed, 25 Nov 2026 15:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HCHYvBht
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B151F000C0;
	Wed, 25 Nov 2026 15:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619304;
	bh=VllzmHgt26o1xzOxUizcj6VM7YQIw/aZfyxwo25X1Bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HCHYvBhtfak4v4HAjN9SAGXo0/FKa8sWG8/3RaF8Mm//D8bXSKhquoKu9W+uFysF+
	 hY3J7uOye6GGM1UyUGh5QrFEcISucUj3YTssOSFzTs5B0/6QvotAWdq3foMv/I61UC
	 oPZtvxXVItKYgUkNte8zvAlmoOXJWJYaiZDwrabQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0509/1005] udp: do not use a cross-family sk_rx_dst in early demux
Date: Wed, 25 Nov 2026 15:30:47 +0100
Message-ID: <20261125143833.668805961@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index b090bd1f59e86..9a91e3533c15c 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2849,8 +2849,11 @@ enum skb_drop_reason udp_v4_early_demux(struct sk_buff *skb)
 	skb->destructor = sock_pfree;
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
index 93478d1ad5769..471cf3fba80eb 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1255,8 +1255,11 @@ void udp_v6_early_demux(struct sk_buff *skb)
 	skb->destructor = sock_pfree;
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



