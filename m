Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9069F41C2E6;
	Wed,  4 Feb 2026 15:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217428; cv=none; b=G2BWRuBobQFlLuJ+oRF5CdpLF79u8pwKiSob+WG8sGAtF/dKwvCwiqDT+i4R//oBVk+NVb4seIrcgkB9MPYoUzHPQeoQB0KPD9c2duKe258rP8rOQHK1PnD1WBpnfGVrZS/D4a4p3J3wYU1qO2vubyMEjVdT6j6dAYW1I+6+cXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217428; c=relaxed/simple;
	bh=NvHUGvWJe/1tMKP1XDKzct39JQg9kSQ7TQSlCKVj2qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhSe01uPVMPy1GsDpskZ1Xu1E7aohwBJjpW79fhkcQKDPdfAT819MPLVAuu7VgfwRtPJh2lBCl6o0NEhLjnJ5VGD6MjOdYVCurKFyzfxdqkRx77/rHL9RiiECO8oOJYY2XqMarUVRQ5Y+uZAsw+d7FqOnNyKp0WgxwuCOVyorRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nB+KV+i+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nB+KV+i+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12568C4CEF7;
	Wed,  4 Feb 2026 15:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217428;
	bh=NvHUGvWJe/1tMKP1XDKzct39JQg9kSQ7TQSlCKVj2qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nB+KV+i+oDZnTUuDoHz/G7st2ITtLPyOvxGyA6aDFIxs0ahq0a/gI38xYz6pAaXpf
	 yMU39Gm4Uril9nNNJ2UYTc6mRTFAtTGFJaB8LXJTp62NQOELXKJ2+2mAWgvTuZgfSO
	 HXTH0Ya/dl8Pi0kxXJTffqP+ew6WUqFcNSKqj3q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/280] xfrm: Fix inner mode lookup in tunnel mode GSO segmentation
Date: Wed,  4 Feb 2026 15:36:18 +0100
Message-ID: <20260204143909.782317191@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

[ Upstream commit 3d5221af9c7711b7aec8da1298c8fc393ef6183d ]

Commit 61fafbee6cfe ("xfrm: Determine inner GSO type from packet inner
protocol") attempted to fix GSO segmentation by reading the inner
protocol from XFRM_MODE_SKB_CB(skb)->protocol. This was incorrect
because the field holds the inner L4 protocol (TCP/UDP) instead of the
required tunnel protocol. Also, the memory location (shared by
XFRM_SKB_CB(skb) which could be overwritten by xfrm_replay_overflow())
is prone to corruption. This combination caused the kernel to select
the wrong inner mode and get the wrong address family.

The correct value is in xfrm_offload(skb)->proto, which is set from
the outer tunnel header's protocol field by esp[4|6]_gso_encap(). It
is initialized by xfrm[4|6]_tunnel_encap_add() to either IPPROTO_IPIP
or IPPROTO_IPV6, using xfrm_af2proto() and correctly reflects the
inner packet's address family.

Fixes: 61fafbee6cfe ("xfrm: Determine inner GSO type from packet inner protocol")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/esp4_offload.c | 4 ++--
 net/ipv6/esp6_offload.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index cbfc8b5b15bd2..8d6a40054eaab 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -110,8 +110,8 @@ static struct sk_buff *xfrm4_tunnel_gso_segment(struct xfrm_state *x,
 						struct sk_buff *skb,
 						netdev_features_t features)
 {
-	const struct xfrm_mode *inner_mode = xfrm_ip2inner_mode(x,
-					XFRM_MODE_SKB_CB(skb)->protocol);
+	struct xfrm_offload *xo = xfrm_offload(skb);
+	const struct xfrm_mode *inner_mode = xfrm_ip2inner_mode(x, xo->proto);
 	__be16 type = inner_mode->family == AF_INET6 ? htons(ETH_P_IPV6)
 						     : htons(ETH_P_IP);
 
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 65d628e500059..460cf1dab9da2 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -145,8 +145,8 @@ static struct sk_buff *xfrm6_tunnel_gso_segment(struct xfrm_state *x,
 						struct sk_buff *skb,
 						netdev_features_t features)
 {
-	const struct xfrm_mode *inner_mode = xfrm_ip2inner_mode(x,
-					XFRM_MODE_SKB_CB(skb)->protocol);
+	struct xfrm_offload *xo = xfrm_offload(skb);
+	const struct xfrm_mode *inner_mode = xfrm_ip2inner_mode(x, xo->proto);
 	__be16 type = inner_mode->family == AF_INET ? htons(ETH_P_IP)
 						    : htons(ETH_P_IPV6);
 
-- 
2.51.0



