Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5A2171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B61C433D2;
	Mon, 22 May 2023 19:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783754;
	bh=au32dqcFzCqNi0URbhZwVyzN7vWdlv2Zb8QDKKcbZDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BLm3iWcPDifPbDPniBHC5/7YvXY1DK6p88MFcSxKFMOVqUhaWVYiuUWmelqUn+TKY
	 lYnAP3qLiS0uaaUg5oMew9Pm3qwWhk9DkDAxFSFM8+fikmtZszTDPduUIz4GMIyh/y
	 feq98ajJieFFHYM+xFX8iN5A2DntQB3z1eMGG/kY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Willi <martin@strongswan.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 152/292] Revert "Fix XFRM-I support for nested ESP tunnels"
Date: Mon, 22 May 2023 20:08:29 +0100
Message-Id: <20230522190409.761374573@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin Willi <martin@strongswan.org>

[ Upstream commit 5fc46f94219d1d103ffb5f0832be9da674d85a73 ]

This reverts commit b0355dbbf13c0052931dd14c38c789efed64d3de.

The reverted commit clears the secpath on packets received via xfrm interfaces
to support nested IPsec tunnels. This breaks Netfilter policy matching using
xt_policy in the FORWARD chain, as the secpath is missing during forwarding.
Additionally, Benedict Wong reports that it breaks Transport-in-Tunnel mode.

Fix this regression by reverting the commit until we have a better approach
for nested IPsec tunnels.

Fixes: b0355dbbf13c ("Fix XFRM-I support for nested ESP tunnels")
Link: https://lore.kernel.org/netdev/20230412085615.124791-1-martin@strongswan.org/
Signed-off-by: Martin Willi <martin@strongswan.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_interface.c | 54 +++------------------------------------
 net/xfrm/xfrm_policy.c    |  3 ---
 2 files changed, 4 insertions(+), 53 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 94a3609548b11..5a67b120c4dbd 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -310,52 +310,6 @@ static void xfrmi_scrub_packet(struct sk_buff *skb, bool xnet)
 	skb->mark = 0;
 }
 
-static int xfrmi_input(struct sk_buff *skb, int nexthdr, __be32 spi,
-		       int encap_type, unsigned short family)
-{
-	struct sec_path *sp;
-
-	sp = skb_sec_path(skb);
-	if (sp && (sp->len || sp->olen) &&
-	    !xfrm_policy_check(NULL, XFRM_POLICY_IN, skb, family))
-		goto discard;
-
-	XFRM_SPI_SKB_CB(skb)->family = family;
-	if (family == AF_INET) {
-		XFRM_SPI_SKB_CB(skb)->daddroff = offsetof(struct iphdr, daddr);
-		XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip4 = NULL;
-	} else {
-		XFRM_SPI_SKB_CB(skb)->daddroff = offsetof(struct ipv6hdr, daddr);
-		XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip6 = NULL;
-	}
-
-	return xfrm_input(skb, nexthdr, spi, encap_type);
-discard:
-	kfree_skb(skb);
-	return 0;
-}
-
-static int xfrmi4_rcv(struct sk_buff *skb)
-{
-	return xfrmi_input(skb, ip_hdr(skb)->protocol, 0, 0, AF_INET);
-}
-
-static int xfrmi6_rcv(struct sk_buff *skb)
-{
-	return xfrmi_input(skb, skb_network_header(skb)[IP6CB(skb)->nhoff],
-			   0, 0, AF_INET6);
-}
-
-static int xfrmi4_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
-{
-	return xfrmi_input(skb, nexthdr, spi, encap_type, AF_INET);
-}
-
-static int xfrmi6_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
-{
-	return xfrmi_input(skb, nexthdr, spi, encap_type, AF_INET6);
-}
-
 static int xfrmi_rcv_cb(struct sk_buff *skb, int err)
 {
 	const struct xfrm_mode *inner_mode;
@@ -983,8 +937,8 @@ static struct pernet_operations xfrmi_net_ops = {
 };
 
 static struct xfrm6_protocol xfrmi_esp6_protocol __read_mostly = {
-	.handler	=	xfrmi6_rcv,
-	.input_handler	=	xfrmi6_input,
+	.handler	=	xfrm6_rcv,
+	.input_handler	=	xfrm_input,
 	.cb_handler	=	xfrmi_rcv_cb,
 	.err_handler	=	xfrmi6_err,
 	.priority	=	10,
@@ -1034,8 +988,8 @@ static struct xfrm6_tunnel xfrmi_ip6ip_handler __read_mostly = {
 #endif
 
 static struct xfrm4_protocol xfrmi_esp4_protocol __read_mostly = {
-	.handler	=	xfrmi4_rcv,
-	.input_handler	=	xfrmi4_input,
+	.handler	=	xfrm4_rcv,
+	.input_handler	=	xfrm_input,
 	.cb_handler	=	xfrmi_rcv_cb,
 	.err_handler	=	xfrmi4_err,
 	.priority	=	10,
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index bea48a73a7313..bc04cb83215f9 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3664,9 +3664,6 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 			goto reject;
 		}
 
-		if (if_id)
-			secpath_reset(skb);
-
 		xfrm_pols_put(pols, npols);
 		return 1;
 	}
-- 
2.39.2



