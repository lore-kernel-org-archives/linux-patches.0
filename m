Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5AA847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6288C433EF;
	Wed,  1 Mar 2023 18:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694290;
	bh=FNUMdvdi3mJP+rFRsXs5GNThXOAU929tIeki5L3SV3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K07f/xTAJP6jyN0lhZ7iNNTM7joPDqeqKZ0XHe11LWDQvEeq5qECFnMNRHcxQ0Q6v
	 qo5COqre4ycXtTHA473mK5FpcpQeNvI4APMCL/2ZpSd71cgkY3vNP3vO1+DaHLYeOb
	 +XD2XhD0TemICkE2EzEO/5Ch+oiTMLka2X5MI9zA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benedict Wong <benedictwong@google.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 01/42] Fix XFRM-I support for nested ESP tunnels
Date: Wed,  1 Mar 2023 19:08:22 +0100
Message-Id: <20230301180657.081986762@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
References: <20230301180657.003689969@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Benedict Wong <benedictwong@google.com>

[ Upstream commit b0355dbbf13c0052931dd14c38c789efed64d3de ]

This change adds support for nested IPsec tunnels by ensuring that
XFRM-I verifies existing policies before decapsulating a subsequent
policies. Addtionally, this clears the secpath entries after policies
are verified, ensuring that previous tunnels with no-longer-valid
do not pollute subsequent policy checks.

This is necessary especially for nested tunnels, as the IP addresses,
protocol and ports may all change, thus not matching the previous
policies. In order to ensure that packets match the relevant inbound
templates, the xfrm_policy_check should be done before handing off to
the inner XFRM protocol to decrypt and decapsulate.

Notably, raw ESP/AH packets did not perform policy checks inherently,
whereas all other encapsulated packets (UDP, TCP encapsulated) do policy
checks after calling xfrm_input handling in the respective encapsulation
layer.

Test: Verified with additional Android Kernel Unit tests
Signed-off-by: Benedict Wong <benedictwong@google.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_interface.c | 54 ++++++++++++++++++++++++++++++++++++---
 net/xfrm/xfrm_policy.c    |  3 +++
 2 files changed, 53 insertions(+), 4 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 5a67b120c4dbd..94a3609548b11 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -310,6 +310,52 @@ static void xfrmi_scrub_packet(struct sk_buff *skb, bool xnet)
 	skb->mark = 0;
 }
 
+static int xfrmi_input(struct sk_buff *skb, int nexthdr, __be32 spi,
+		       int encap_type, unsigned short family)
+{
+	struct sec_path *sp;
+
+	sp = skb_sec_path(skb);
+	if (sp && (sp->len || sp->olen) &&
+	    !xfrm_policy_check(NULL, XFRM_POLICY_IN, skb, family))
+		goto discard;
+
+	XFRM_SPI_SKB_CB(skb)->family = family;
+	if (family == AF_INET) {
+		XFRM_SPI_SKB_CB(skb)->daddroff = offsetof(struct iphdr, daddr);
+		XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip4 = NULL;
+	} else {
+		XFRM_SPI_SKB_CB(skb)->daddroff = offsetof(struct ipv6hdr, daddr);
+		XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip6 = NULL;
+	}
+
+	return xfrm_input(skb, nexthdr, spi, encap_type);
+discard:
+	kfree_skb(skb);
+	return 0;
+}
+
+static int xfrmi4_rcv(struct sk_buff *skb)
+{
+	return xfrmi_input(skb, ip_hdr(skb)->protocol, 0, 0, AF_INET);
+}
+
+static int xfrmi6_rcv(struct sk_buff *skb)
+{
+	return xfrmi_input(skb, skb_network_header(skb)[IP6CB(skb)->nhoff],
+			   0, 0, AF_INET6);
+}
+
+static int xfrmi4_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
+{
+	return xfrmi_input(skb, nexthdr, spi, encap_type, AF_INET);
+}
+
+static int xfrmi6_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
+{
+	return xfrmi_input(skb, nexthdr, spi, encap_type, AF_INET6);
+}
+
 static int xfrmi_rcv_cb(struct sk_buff *skb, int err)
 {
 	const struct xfrm_mode *inner_mode;
@@ -937,8 +983,8 @@ static struct pernet_operations xfrmi_net_ops = {
 };
 
 static struct xfrm6_protocol xfrmi_esp6_protocol __read_mostly = {
-	.handler	=	xfrm6_rcv,
-	.input_handler	=	xfrm_input,
+	.handler	=	xfrmi6_rcv,
+	.input_handler	=	xfrmi6_input,
 	.cb_handler	=	xfrmi_rcv_cb,
 	.err_handler	=	xfrmi6_err,
 	.priority	=	10,
@@ -988,8 +1034,8 @@ static struct xfrm6_tunnel xfrmi_ip6ip_handler __read_mostly = {
 #endif
 
 static struct xfrm4_protocol xfrmi_esp4_protocol __read_mostly = {
-	.handler	=	xfrm4_rcv,
-	.input_handler	=	xfrm_input,
+	.handler	=	xfrmi4_rcv,
+	.input_handler	=	xfrmi4_input,
 	.cb_handler	=	xfrmi_rcv_cb,
 	.err_handler	=	xfrmi4_err,
 	.priority	=	10,
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 52538d5360673..7f49dab3b6b59 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3670,6 +3670,9 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 			goto reject;
 		}
 
+		if (if_id)
+			secpath_reset(skb);
+
 		xfrm_pols_put(pols, npols);
 		return 1;
 	}
-- 
2.39.0



