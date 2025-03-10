Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96EED2206BD;
	Mon, 10 Mar 2025 18:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630444; cv=none; b=WHuomz16lDwaZJywGcpUzmjWbyeErDPrW1YGiR5PJJ0iEe3zBBmGnI7PkDHz1l3vdTexkTbX4mdG9NSWzDTjUYP81WSuudeJUL13fVK/DZKYr5SlFpRveOCCdPFJA9ikczDTyXuChdFiymZ6MyKymvqH7RWceP++9pOFFsZtEq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630444; c=relaxed/simple;
	bh=ng80GeQXA6gUTS/bY5AvEx5mE4jY4ljB16rN7RxjiKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJJq+mkdUx8XgqLDAlh5RK1qI3IV2p/Ll506QVkLu5UCW/ZwJBTwOWn4n3kVXoNPAnjY7OrJifymJuhBUH3758anIZjZgUzWZrkrs2sI9Ck2QnXhG6TitTtTOGonVLnmS1EhkWH2p9Y6THAI96+9w89HL9K7Soa52lVtCaTTEsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rWl0NTBz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rWl0NTBz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF09C4CEE5;
	Mon, 10 Mar 2025 18:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630444;
	bh=ng80GeQXA6gUTS/bY5AvEx5mE4jY4ljB16rN7RxjiKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rWl0NTBz+noQkZrTTC/2256KTF3z+nXGEaiszrpEsvfiP+i8DhnpHTPz8XmjgSz69
	 C1MYUFTrgN6E93nR8g3x6cvj4Ul3xW4V7BebXL1OZxtty5iBhvUwKwOZugfbTIQty/
	 h3/zfFCakxDGGPQUkFqwZz0BnGW+LNkSQ87+jr+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 408/620] ndisc: extend RCU protection in ndisc_send_skb()
Date: Mon, 10 Mar 2025 18:04:14 +0100
Message-ID: <20250310170601.694298095@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ed6ae1f325d3c43966ec1b62ac1459e2b8e45640 ]

ndisc_send_skb() can be called without RTNL or RCU held.

Acquire rcu_read_lock() earlier, so that we can use dev_net_rcu()
and avoid a potential UAF.

Fixes: 1762f7e88eb3 ("[NETNS][IPV6] ndisc - make socket control per namespace")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250207135841.1948589-8-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ndisc.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 3972189c09b14..af584e879467e 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -471,16 +471,20 @@ static void ndisc_send_skb(struct sk_buff *skb,
 			   const struct in6_addr *daddr,
 			   const struct in6_addr *saddr)
 {
+	struct icmp6hdr *icmp6h = icmp6_hdr(skb);
 	struct dst_entry *dst = skb_dst(skb);
-	struct net *net = dev_net(skb->dev);
-	struct sock *sk = net->ipv6.ndisc_sk;
 	struct inet6_dev *idev;
+	struct net *net;
+	struct sock *sk;
 	int err;
-	struct icmp6hdr *icmp6h = icmp6_hdr(skb);
 	u8 type;
 
 	type = icmp6h->icmp6_type;
 
+	rcu_read_lock();
+
+	net = dev_net_rcu(skb->dev);
+	sk = net->ipv6.ndisc_sk;
 	if (!dst) {
 		struct flowi6 fl6;
 		int oif = skb->dev->ifindex;
@@ -488,6 +492,7 @@ static void ndisc_send_skb(struct sk_buff *skb,
 		icmpv6_flow_init(sk, &fl6, type, saddr, daddr, oif);
 		dst = icmp6_dst_alloc(skb->dev, &fl6);
 		if (IS_ERR(dst)) {
+			rcu_read_unlock();
 			kfree_skb(skb);
 			return;
 		}
@@ -502,7 +507,6 @@ static void ndisc_send_skb(struct sk_buff *skb,
 
 	ip6_nd_hdr(skb, saddr, daddr, inet6_sk(sk)->hop_limit, skb->len);
 
-	rcu_read_lock();
 	idev = __in6_dev_get(dst->dev);
 	IP6_UPD_PO_STATS(net, idev, IPSTATS_MIB_OUT, skb->len);
 
-- 
2.39.5



