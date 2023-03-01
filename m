Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34665847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:09:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADB1C433D2;
	Wed,  1 Mar 2023 18:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694178;
	bh=AufyQJ5bQHeNvPWgyeK+ieVSshJJ13qq6zrSYpWWCzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UCfg8MdG20QbKsdiJ0T39QSmM6xwjVioNM3iy9Wm4HjEGs2n5Dt+inRa6owHrzNUu
	 we4Yah57cZOT6q2sBGLLqg95c7TC9tFIaTvMPy/8eToS8Mng8NPQ8jztCEs4s/2PFB
	 Q/LbyGuW0xnC0IIxIWt3WwviamSv26DXJ5IVeWaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benedict Wong <benedictwong@google.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 01/19] Fix XFRM-I support for nested ESP tunnels
Date: Wed,  1 Mar 2023 19:08:30 +0100
Message-Id: <20230301180652.383841321@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180652.316428563@linuxfoundation.org>
References: <20230301180652.316428563@linuxfoundation.org>
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
index da518b4ca84c6..e4f21a6924153 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -207,6 +207,52 @@ static void xfrmi_scrub_packet(struct sk_buff *skb, bool xnet)
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
@@ -780,8 +826,8 @@ static struct pernet_operations xfrmi_net_ops = {
 };
 
 static struct xfrm6_protocol xfrmi_esp6_protocol __read_mostly = {
-	.handler	=	xfrm6_rcv,
-	.input_handler	=	xfrm_input,
+	.handler	=	xfrmi6_rcv,
+	.input_handler	=	xfrmi6_input,
 	.cb_handler	=	xfrmi_rcv_cb,
 	.err_handler	=	xfrmi6_err,
 	.priority	=	10,
@@ -831,8 +877,8 @@ static struct xfrm6_tunnel xfrmi_ip6ip_handler __read_mostly = {
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
index 0d12bdf59d4cc..d15aa62887de0 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3710,6 +3710,9 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
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



