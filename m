Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D54569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76EC4C433EF;
	Sun, 28 May 2023 19:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301909;
	bh=SBSauO/Isw7x+hrwevVKs1A8CSZfB8/4fA7n3jW1zg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LHHoyD9PBzPjL54Rg0iVB70hpXrXj4rHZduk64OuPjisX0a3TR9+DQQc5I6Lw2LUb
	 GxftkhjwaH44wDyKwY59I1AbjOpKLfNMLjAouWK6lJBd75b7Iv62htAETaEGQ5DIEd
	 a3jIkRbeCEZng2nIKgpZmE5TaAWzsogR03BN+GPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peilin Ye <peilin.ye@bytedance.com>,
	William Tu <u9012063@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 067/161] ip6_gre: Make o_seqno start from 0 in native mode
Date: Sun, 28 May 2023 20:09:51 +0100
Message-Id: <20230528190839.301133921@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190837.051205996@linuxfoundation.org>
References: <20230528190837.051205996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peilin Ye <peilin.ye@bytedance.com>

[ Upstream commit fde98ae91f79cab4e020f40c35ed23cbdc59661c ]

For IP6GRE and IP6GRETAP devices, currently o_seqno starts from 1 in
native mode.  According to RFC 2890 2.2., "The first datagram is sent
with a sequence number of 0."  Fix it.

It is worth mentioning that o_seqno already starts from 0 in collect_md
mode, see the "if (tunnel->parms.collect_md)" clause in __gre6_xmit(),
where tunnel->o_seqno is passed to gre_build_header() before getting
incremented.

Fixes: c12b395a4664 ("gre: Support GRE over IPv6")
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
Acked-by: William Tu <u9012063@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: d80fc101d2eb ("erspan: get the proto with the md version for collect_md")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_gre.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index a1fd3c9c1da3e..e3c65e7681ad4 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -711,6 +711,7 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 {
 	struct ip6_tnl *tunnel = netdev_priv(dev);
 	__be16 protocol;
+	__be16 flags;
 
 	if (dev->type == ARPHRD_ETHER)
 		IPCB(skb)->flags = 0;
@@ -726,7 +727,6 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 	if (tunnel->parms.collect_md) {
 		struct ip_tunnel_info *tun_info;
 		const struct ip_tunnel_key *key;
-		__be16 flags;
 		int tun_hlen;
 
 		tun_info = skb_tunnel_info(skb);
@@ -758,15 +758,14 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 						      : 0);
 
 	} else {
-		if (tunnel->parms.o_flags & TUNNEL_SEQ)
-			tunnel->o_seqno++;
-
 		if (skb_cow_head(skb, dev->needed_headroom ?: tunnel->hlen))
 			return -ENOMEM;
 
-		gre_build_header(skb, tunnel->tun_hlen, tunnel->parms.o_flags,
+		flags = tunnel->parms.o_flags;
+
+		gre_build_header(skb, tunnel->tun_hlen, flags,
 				 protocol, tunnel->parms.o_key,
-				 htonl(tunnel->o_seqno));
+				 (flags & TUNNEL_SEQ) ? htonl(tunnel->o_seqno++) : 0);
 	}
 
 	return ip6_tnl_xmit(skb, dev, dsfield, fl6, encap_limit, pmtu,
-- 
2.39.2



