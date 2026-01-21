Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F032C375E;
	Wed, 21 Jan 2026 18:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019499; cv=none; b=MvCScGKuKgjsZuFWoCdgdILnlx2cvHYSGbOePjoVr9FqV+KUculxgLm10mdm+5oeqLDeAR6fWlSNJSZIMRXEvoODcZWvPggIH8pxPW+GKudHvJGqTcsNc9rK+lhNVwW9GbNse8+AIMS7Ts9jw9HXC1LWsEjE54DX26nkUkZWw2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019499; c=relaxed/simple;
	bh=Xdo2KwI7UUnTZztgdbicRu2awcJ7LqpX/KRwXRLkWe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3vpE4Lf1JirWX15PSc0o6V6Qc3lw/khu84EJ1z6DqXJ7vffqH1UgjbB3KtSWWec03R03od68YkSn5Vw1u4MmHoFJKHLWWuqkJCKBt3sTtyxFhdWv3B/uwxmacKLbV8wBOj4p9z/BE9oNt6jx0ZqPaCcREz8GETGGQpJwXk6zUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zpQUEbGn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zpQUEbGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F2B9C19425;
	Wed, 21 Jan 2026 18:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019498;
	bh=Xdo2KwI7UUnTZztgdbicRu2awcJ7LqpX/KRwXRLkWe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zpQUEbGnfxVUFVEexPBzPG2sgnRu76fTs5NRp2VgEQD8jRJnfqGlyOlfovHERX3lP
	 1+WGPasDz1RjnP/5YuF/3Rd9YsyIow9KYRTkcg3H15oKeecSgqL3KeZJh/V+o29yp1
	 pBFd2QSQQviek5YdGWaTpHiMGrbEcKQfru6IxYec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 006/139] xfrm: Fix inner mode lookup in tunnel mode GSO segmentation
Date: Wed, 21 Jan 2026 19:14:14 +0100
Message-ID: <20260121181411.687177468@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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
index 05828d4cb6cdb..abd77162f5e75 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -122,8 +122,8 @@ static struct sk_buff *xfrm4_tunnel_gso_segment(struct xfrm_state *x,
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
index 22410243ebe88..22895521a57d0 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -158,8 +158,8 @@ static struct sk_buff *xfrm6_tunnel_gso_segment(struct xfrm_state *x,
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



