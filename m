Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618988;
	b=uz348DxXeYVpwFfTVX87FFA+GezaD73JxdWGzm6+ldueOa4w5aM2V1aKUrGwgAj9LiXp
	 3XsSbMae92sNIFpXq1ol4W1Zh+1nWjJ7q5l6JO4LCNBXA5ctHrI2CIVNAN8DPUV7QwJX1
	 Z9pYuKaGyLEaBhDraAGQnQAt7sySRu1xe5/NUnZFWjX98Gp9saAmF3Kowu93S06RxcIDw
	 xHAbice+8i/k1kKegwaHFDsLwDANUGYp1pMCHe/Xlr+S23plFAtska5VOjv2NVHMaI75g
	 RZGj4pvQUl1ojHySyCgYzUTdlvCYnWv+YZhq3zztH0XklFr+mZgbkzkiAYENJ6JyNbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618988;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PdwPCy5OoWYoxIJl/Mg6a8mFv0U9BziFbOwajEql+lo=;
	b=NFFyK4L0AdiiLjUUd0j3WEIBrcs1M6Bc7yAxTgX9hrSpbQn0APBpJ72ZEUrNGEs5hNfB
	 tt8sSIKHQjDKD/kWGHJjw+YlF4wwdS/dbCI9mXRFj64ZxVpCw9Ghux7r4HqfexFz+6kv7
	 L4R+CXwVuRNTGwmQxMF3S7FbzkbhUg8WiiauLTSiu2beDQETTBhDxxv3GE5h+z9ZtStL2
	 HTySNul8unS4hfyJ5dVvYmjvhAHl6guBQA7El+vv66gfY2hWewLMWCPE+ea9Fwifr5PUX
	 jTRfCs7DETK3cpbJJULbuPYRLJ18RfTblWyJRrHRwOwPVcxEsXC8UQIdatEb8n42dIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mwC9Rn+/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B67606A321;
	Wed, 25 Nov 2026 15:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mwC9Rn+/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41511F000C6;
	Wed, 25 Nov 2026 15:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618988;
	bh=PdwPCy5OoWYoxIJl/Mg6a8mFv0U9BziFbOwajEql+lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mwC9Rn+/q87iS0kJk/Da86xZQFIWBOFfG+BYqMG9x6bU2HRUtsLgCkju9RKdrJcm9
	 pAu4c+VeGr2RZtLU6rZZKntYUBfPOugmuw5I5pc7N2tjH/dyIhYPmBJhJ1dGn/eBmA
	 HkK/wgHMEvraGiU6LWUTGPeBPlV1nm7cp09OiV0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0451/1005] net: raw: fix ICMP unreachable sent when receive queue is full
Date: Wed, 25 Nov 2026 15:29:49 +0100
Message-ID: <20261125143832.312541529@linuxfoundation.org>
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
index d756e5e31b90d..f0035f8da3cf2 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -182,18 +182,19 @@ static int raw_v4_input(struct net *net, struct sk_buff *skb,
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
index bdea825434ea7..00d832c7cdae9 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -160,12 +160,6 @@ static bool ipv6_raw_deliver(struct sk_buff *skb, int nexthdr)
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



