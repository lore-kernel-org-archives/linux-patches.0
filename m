Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA697340279;
	Wed,  3 Dec 2025 16:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780087; cv=none; b=ldHUdqdI+oYU3ckUzHTMQG1qwqcG12pdfmNx047tNU/nRnkq/Olrt7rv85f56uN4ZmxANPLfx1ANGJBTliU2j775LjgtjZs019fNHuVZuoTg93QvpqrkRVzg8HjEcYDQn9KfVJdhwRdEOcL/sdLgUkg9EafiaCL1NvgIaAW3/ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780087; c=relaxed/simple;
	bh=SFq9jhx/KernNknCZME5Gj+giMds1Gd86A4vPiozTZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aLxiKHzwuglJ/oqgfhPd4L47ThouxOFGCYU1A+5zW6IDI/NVY4bM27wvCtX4aIKg+fH45X78kuR9UfORLWynYzoeGjbzpTflDXpPzBpbioZldF2h5tcla77dS1Z61DLX6ql1l2mG1TlKtIfswIKPy2QpVk70NVlZINj6sq5mFYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Au8iz8Fs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Au8iz8Fs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304F5C4CEF5;
	Wed,  3 Dec 2025 16:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780087;
	bh=SFq9jhx/KernNknCZME5Gj+giMds1Gd86A4vPiozTZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Au8iz8FsCNzYj+b6HTDQodV8bd2IEIitM0mgyU45+enUH+LaIX1m5VC39EVCfm+eF
	 ns05FqkrAXPLx//fsV9HL0v+UHcI6foAawqwz278aJdmpNxxzMN3ucRseOo41+fkyC
	 M7ecIZLXJzHqNI1d2DvyIQnkNfWUbCEghBS9/GIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 451/568] xfrm: Determine inner GSO type from packet inner protocol
Date: Wed,  3 Dec 2025 16:27:33 +0100
Message-ID: <20251203152457.224842330@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit 61fafbee6cfed283c02a320896089f658fa67e56 ]

The GSO segmentation functions for ESP tunnel mode
(xfrm4_tunnel_gso_segment and xfrm6_tunnel_gso_segment) were
determining the inner packet's L2 protocol type by checking the static
x->inner_mode.family field from the xfrm state.

This is unreliable. In tunnel mode, the state's actual inner family
could be defined by x->inner_mode.family or by
x->inner_mode_iaf.family. Checking only the former can lead to a
mismatch with the actual packet being processed, causing GSO to create
segments with the wrong L2 header type.

This patch fixes the bug by deriving the inner mode directly from the
packet's inner protocol stored in XFRM_MODE_SKB_CB(skb)->protocol.

Instead of replicating the code, this patch modifies the
xfrm_ip2inner_mode helper function. It now correctly returns
&x->inner_mode if the selector family (x->sel.family) is already
specified, thereby handling both specific and AF_UNSPEC cases
appropriately.

With this change, ESP GSO can use xfrm_ip2inner_mode to get the
correct inner mode. It doesn't affect existing callers, as the updated
logic now mirrors the checks they were already performing externally.

Fixes: 26dbd66eab80 ("esp: choose the correct inner protocol for GSO on inter address family tunnels")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xfrm.h      | 3 ++-
 net/ipv4/esp4_offload.c | 6 ++++--
 net/ipv6/esp6_offload.c | 6 ++++--
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 64911162ab5f4..ac5db167370c9 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -446,7 +446,8 @@ static inline int xfrm_af2proto(unsigned int family)
 
 static inline const struct xfrm_mode *xfrm_ip2inner_mode(struct xfrm_state *x, int ipproto)
 {
-	if ((ipproto == IPPROTO_IPIP && x->props.family == AF_INET) ||
+	if ((x->sel.family != AF_UNSPEC) ||
+	    (ipproto == IPPROTO_IPIP && x->props.family == AF_INET) ||
 	    (ipproto == IPPROTO_IPV6 && x->props.family == AF_INET6))
 		return &x->inner_mode;
 	else
diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index ee848be59e65a..cbfc8b5b15bd2 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -110,8 +110,10 @@ static struct sk_buff *xfrm4_tunnel_gso_segment(struct xfrm_state *x,
 						struct sk_buff *skb,
 						netdev_features_t features)
 {
-	__be16 type = x->inner_mode.family == AF_INET6 ? htons(ETH_P_IPV6)
-						       : htons(ETH_P_IP);
+	const struct xfrm_mode *inner_mode = xfrm_ip2inner_mode(x,
+					XFRM_MODE_SKB_CB(skb)->protocol);
+	__be16 type = inner_mode->family == AF_INET6 ? htons(ETH_P_IPV6)
+						     : htons(ETH_P_IP);
 
 	return skb_eth_gso_segment(skb, features, type);
 }
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index fc6a5be732634..65d628e500059 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -145,8 +145,10 @@ static struct sk_buff *xfrm6_tunnel_gso_segment(struct xfrm_state *x,
 						struct sk_buff *skb,
 						netdev_features_t features)
 {
-	__be16 type = x->inner_mode.family == AF_INET ? htons(ETH_P_IP)
-						      : htons(ETH_P_IPV6);
+	const struct xfrm_mode *inner_mode = xfrm_ip2inner_mode(x,
+					XFRM_MODE_SKB_CB(skb)->protocol);
+	__be16 type = inner_mode->family == AF_INET ? htons(ETH_P_IP)
+						    : htons(ETH_P_IPV6);
 
 	return skb_eth_gso_segment(skb, features, type);
 }
-- 
2.51.0



