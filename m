Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624881;
	b=wCFFWattx5dCgFMjKovaLWp0fIlwd2qmXpyVs1jBTHde2WdD+3ruoRG7E5pUWRpWKVKz
	 rl8Lq9PQ5qafnzG/EoE672CdTTAs3aQ/uKMWT4Ful+ZtCK/qPoJ5YcXDekfz5Wc+YwIoH
	 QKF/Pdj1Eoxen4Thuk5Zgs7Pk8Wy1nnI7OCcAdPVhrYcWxujLVLWaZryOdOtlca6vWLa4
	 P9wefpE9t1F8RqB4fY/T27Rf2gksvxe/Yi9f0Wi8HkzCYZcwhop4YBKtlHZkAKcnky/O7
	 TyIRgBYoNWZuETRXvYk/Wo0dhhpLgrB9xYEG3taHUtDQOPOpkSYRuC+AmVhtmJhrEwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624881;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F2LEAPeLDbrwxMpdlJ7WAitgl4S+eI+DN2GF1krO7Cw=;
	b=2JOZS7rIT/m11UC1r/UyYBcrFdWafBvPkUiQzA9+olT45FTYRwFZPE9kL75CJgS4p+zc
	 RdzcCOmnTi+6etqaGlCvkqm4++0R+PgoFp1VghPm3I22kBXKuOJP0pSUQzxRjNIusgee3
	 U8VwZB4VPba6rJKwU2EiJuAbn+5wbv+k3cBsXqpDZTFPyQz8UAVsMd9i+qZT0J3m7AFaq
	 lZ4GngW2Su/whRTi+M4PbEEZIJ8Mdrtk83C+KkEB8Kw7HMgEbhufKtGS7THqVDJiNe9LZ
	 ch7+AaFeMhNXPI8XaKKjCvFVgQAUqyX1YPnI4gHAdXt1mqsNvfJjxE+ZFt8eb4RUj3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e+FIL+t9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE39606A321;
	Wed, 25 Nov 2026 16:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e+FIL+t9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F101F000C0;
	Wed, 25 Nov 2026 16:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624880;
	bh=F2LEAPeLDbrwxMpdlJ7WAitgl4S+eI+DN2GF1krO7Cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e+FIL+t9Pfaa0R+ZQ+sIdCTxtIOTjT3hUuIsuAb1Hc3sOu8YvuI81yu4q6JxQ8Bz9
	 pHT0FfFkFWEJFD71zH0ILu8ql0vXjYwJy18NYY2zupLy60y5iZDBE9MM3WTuo4R2t3
	 bCjRD5XOGhYNZ+zlbm8i6UwEyv1PmOHKNHHYNNOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 337/816] udp: do not use a cross-family sk_rx_dst in early demux
Date: Wed, 25 Nov 2026 15:31:25 +0100
Message-ID: <20261125143856.998936712@linuxfoundation.org>
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
index 4fc8263286f2e..af7afbf7a0c64 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2678,8 +2678,11 @@ int udp_v4_early_demux(struct sk_buff *skb)
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
index db67fc05ca51a..296ea0bb36369 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1180,8 +1180,11 @@ void udp_v6_early_demux(struct sk_buff *skb)
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



