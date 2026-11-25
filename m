Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622094;
	b=yBBjDOXFBuYFSYU08YzoIQPepdqPAhrO20NSii6y87Ykrpn60HzoHp/jL2SSDkVq9HWG
	 HN2tGy68p/bAOOae2RwrquNWkA1XuKHrcpkj1mGN7DZHHJ4ETsVblB4/aLqUU9DLu2BXo
	 GVhVS0l12o+Fy/CX7/YI75iBwbLieNIp1CbV0yWvNflUxtIhpiPMIrLJSTXgxd3DCt2ln
	 fdkkFcCAoiEF0i8vdKKi//ZjIK2xpWAciksk8GmTv6bJV3fqy3dwyC6DIRPl5Xht+IkBu
	 wr+ugnHLrV437OkF+MYwwznEqgviUF8d/NNxIIIKpRCAVQ8HMGyj1ZW8vQBiWq+yOVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622094;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/JRb/0vozzJ0wYFDZythCtpRkoPAX4AcBHsrSv1ys9g=;
	b=40r0ukuZe3YJp1vbPR77jjxb80LAFez814xGgZ5kC2SsNcRCxHGzpfPZi+NPCJQtg+9o
	 70wrNUYq7l6i94Ro/G2mUT+hcp3b6gbXpTUUFC4yoJ3Pwc5iA/SeLkg7hPYz6W5tqinMU
	 mCEUg2MpRBIHqgB+o9cpblbeR0bgABCZLnqNiT3ds+Kp7Hr6hD0TQ3qA52zr8jN2Bs8Y8
	 shNtiuPtLLa8um2TkiWshosc40TTQJYyckXKJdKsvCxAURSt8DVqfmoi41Ir3Jf/kWX53
	 vFNpNqwQDARtUgfXpNcDmVd4uKwjb0WTPTftxcVQuHnrnQp8WX+75dyDG9owOgIA9fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OPHWZ2ib;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1B3606A321;
	Wed, 25 Nov 2026 15:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OPHWZ2ib
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059EE1F000C4;
	Wed, 25 Nov 2026 15:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622094;
	bh=/JRb/0vozzJ0wYFDZythCtpRkoPAX4AcBHsrSv1ys9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OPHWZ2ibFBTasBYf6npZio/rkxz4L08nFux3LrHg/wFV6tnuX5zcWPc2xSFjIwQ+x
	 WHmKHCA1OAcD6vvYb9TC8pdRtqU1npP5tSGxz+M/s0sa8fWVLnLYUPD6oByU3H2kvq
	 0vek9o2QH/idOLCzHhtwCiqlKu99O2FWehdrniB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 402/990] net: raw: fix ICMP unreachable sent when receive queue is full
Date: Wed, 25 Nov 2026 15:29:29 +0100
Message-ID: <20261125143831.516139246@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 45441a94d50200f1478c52857725e6df624bf2ad ]

It's found in a raw socket application. When the application doesn't
read packets in time, the client receives ICMP Protocol Unreachable,
which makes the client abort the session.

The reason is that the server hits the sk_rcvbuf limit, and
raw_v4_input() skips the socket before setting 'delivered', so it
returns 0. Then ip_protocol_deliver_rcu() sees 'raw' is 0, thinks no one
handles this protocol and calls icmp_send() to send ICMP Protocol
Unreachable.

IPv6 has the same issue, ip6_protocol_deliver_rcu() sends ICMPv6
Parameter Problem instead.

Also, we'd better run icmp_filter() and ip_mc_sf_allow() (icmpv6_filter()
for IPv6) before we check sk_rcvbuf, otherwise packets rejected by
ICMP_FILTER/ICMPV6_FILTER or the multicast filter are counted in
sk_drops. So move the check right before skb_clone().

Fixes: d721812aa875 ("ipv4: raw: check sk->sk_rcvbuf earlier")
Fixes: 026763ece881 ("ipv6: raw: check sk->sk_rcvbuf earlier")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/20261104115732.322151-1-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/raw.c | 15 ++++++++-------
 net/ipv6/raw.c | 15 ++++++++-------
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 5735ae7cba01a..076fb2226a0f8 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -184,18 +184,19 @@ static int raw_v4_input(struct net *net, struct sk_buff *skb,
 				  iph->saddr, iph->daddr, dif, sdif))
 			continue;
 
-		if (atomic_read(&sk->sk_rmem_alloc) >=
-		    READ_ONCE(sk->sk_rcvbuf)) {
-			sk_drops_inc(sk);
-			continue;
-		}
-
 		delivered = 1;
 		if ((iph->protocol != IPPROTO_ICMP || !icmp_filter(sk, skb)) &&
 		    ip_mc_sf_allow(sk, iph->daddr, iph->saddr,
 				   skb->dev->ifindex, sdif)) {
-			struct sk_buff *clone = skb_clone(skb, GFP_ATOMIC);
+			struct sk_buff *clone;
+
+			if (atomic_read(&sk->sk_rmem_alloc) >=
+			    READ_ONCE(sk->sk_rcvbuf)) {
+				sk_drops_inc(sk);
+				continue;
+			}
 
+			clone = skb_clone(skb, GFP_ATOMIC);
 			/* Not releasing hash table! */
 			if (clone)
 				raw_rcv(sk, clone);
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 5ecbb9c775be0..b69016d9a2638 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -161,12 +161,6 @@ static bool ipv6_raw_deliver(struct sk_buff *skb, int nexthdr)
 				  inet6_iif(skb), inet6_sdif(skb)))
 			continue;
 
-		if (atomic_read(&sk->sk_rmem_alloc) >=
-		    READ_ONCE(sk->sk_rcvbuf)) {
-			sk_drops_inc(sk);
-			continue;
-		}
-
 		delivered = true;
 		switch (nexthdr) {
 		case IPPROTO_ICMPV6:
@@ -197,8 +191,15 @@ static bool ipv6_raw_deliver(struct sk_buff *skb, int nexthdr)
 		if (filtered < 0)
 			break;
 		if (filtered == 0) {
-			struct sk_buff *clone = skb_clone(skb, GFP_ATOMIC);
+			struct sk_buff *clone;
+
+			if (atomic_read(&sk->sk_rmem_alloc) >=
+			    READ_ONCE(sk->sk_rcvbuf)) {
+				sk_drops_inc(sk);
+				continue;
+			}
 
+			clone = skb_clone(skb, GFP_ATOMIC);
 			/* Not releasing hash table! */
 			if (clone)
 				rawv6_rcv(sk, clone);
-- 
2.53.0



