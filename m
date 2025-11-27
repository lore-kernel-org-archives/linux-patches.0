Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33572299943;
	Thu, 27 Nov 2025 14:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255244; cv=none; b=svXeihoWZLqWuSQrq0dQLFyF06WG7WGmhrN0XkH8W6S9jT7WlDccoULSZuO9/SxqjeatNKW5B02BJc0wLbVOQLvPoCRaeHSbSjapLYrLzpCrvyy8NIUIW9kuDmsbc6p+TXNI5JPJQkq7pyJLS9ID1rMXoPk5uFV2eyS2l8Vm5TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255244; c=relaxed/simple;
	bh=viDplz5WBWczqhYLNsmYsxA0ZlTl1nP+T6IEozBSxCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GTJdytNCvXykzlKZ8G/d95e3JBwHgK2JJse7qxbGP/XKTPynlpfDiO3kyHySL4bbIX+TU4Cn0l97DQG+XcmKVAtxcJtXrUsRsBcOcTMhXn0x2O9bQmO8FP7qtjeBX2bLXLrxYVN088vHYMX4H7+o7E2Kxslly2WLuBMEWGNIObY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K55bxF0P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K55bxF0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B11C4CEF8;
	Thu, 27 Nov 2025 14:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255244;
	bh=viDplz5WBWczqhYLNsmYsxA0ZlTl1nP+T6IEozBSxCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K55bxF0PncpQWVbEZDbLN0urulXnUfZlHdMzU61brBXRgZU6kJERN39+aX+azUo1R
	 f2OiPPmDJLa2RrK3QAhHoSJibSRYhF4vA0q+nNS6zUi/aQimLkJsQiPNeWvZPGoAwQ
	 PSp2EYKpg+pvWQTNj38RMeJhBBw+pwMSluCZlla8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 056/112] xfrm: Determine inner GSO type from packet inner protocol
Date: Thu, 27 Nov 2025 15:45:58 +0100
Message-ID: <20251127144034.891942355@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1484dd15a3694..caaff61601a07 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -472,7 +472,8 @@ static inline int xfrm_af2proto(unsigned int family)
 
 static inline const struct xfrm_mode *xfrm_ip2inner_mode(struct xfrm_state *x, int ipproto)
 {
-	if ((ipproto == IPPROTO_IPIP && x->props.family == AF_INET) ||
+	if ((x->sel.family != AF_UNSPEC) ||
+	    (ipproto == IPPROTO_IPIP && x->props.family == AF_INET) ||
 	    (ipproto == IPPROTO_IPV6 && x->props.family == AF_INET6))
 		return &x->inner_mode;
 	else
diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index e0d94270da28a..05828d4cb6cdb 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -122,8 +122,10 @@ static struct sk_buff *xfrm4_tunnel_gso_segment(struct xfrm_state *x,
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
index 7b41fb4f00b58..22410243ebe88 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -158,8 +158,10 @@ static struct sk_buff *xfrm6_tunnel_gso_segment(struct xfrm_state *x,
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



