Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E281A7076;
	Thu, 15 Aug 2024 14:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731472; cv=none; b=CwuEZlkPHKD2q5pc+6sRmgOnEYWgOOK+s/PsZOJX1qJRJYO7O1Yxf74HRQwHFEhksnSvmtPWUxFE0fF7fxIOi0p5r3jIeWXMwcQGG0r0Ga+A8dPLDvf+czs7BgvisT/rssxktCAjnM+L9DmKs6Vbks+qQ3S45BmDsSgw3HoWYMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731472; c=relaxed/simple;
	bh=R5hCHX68kN7mQYUWpt8QcEzMVZdbElEmbGuFzPaA8SM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rmDJEdFahSFpZUb+fRkCvirl4mHenqw2yqJSKDDfhMdmLY2/h6iyU+q+gvHYcBoKoAhQW8feIMsoj/sSRx5FIuCmW6ibEvIYJ1pXvVrL1bVG95deZhZ4prbWLppt3fa04hSljhZAuFg/6Lsxf8y4pDbItxENi5Bfq2nLhHxsRAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HK8Z/zd4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HK8Z/zd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB22C32786;
	Thu, 15 Aug 2024 14:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731471;
	bh=R5hCHX68kN7mQYUWpt8QcEzMVZdbElEmbGuFzPaA8SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HK8Z/zd4khU/GNoWs+knaUATnbmtGqtnw87i8EnrYMW8ffDSwiWwHD9+wzhWMtb99
	 r7kOlgrhJJwtm4/aaZxmQ+KEACP/5teu0arEVHfscTY1N44UMG74GqyeIisM+z05eI
	 GzXiSg3TagXFcD68BWMU6qafgszLmJIrRAyTxTX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Guillaume Nault <gnault@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 141/259] ipv4: Fix incorrect source address in Record Route option
Date: Thu, 15 Aug 2024 15:24:34 +0200
Message-ID: <20240815131908.236930723@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit cc73bbab4b1fb8a4f53a24645871dafa5f81266a ]

The Record Route IP option records the addresses of the routers that
routed the packet. In the case of forwarded packets, the kernel performs
a route lookup via fib_lookup() and fills in the preferred source
address of the matched route.

The lookup is performed with the DS field of the forwarded packet, but
using the RT_TOS() macro which only masks one of the two ECN bits. If
the packet is ECT(0) or CE, the matched route might be different than
the route via which the packet was forwarded as the input path masks
both of the ECN bits, resulting in the wrong address being filled in the
Record Route option.

Fix by masking both of the ECN bits.

Fixes: 8e36360ae876 ("ipv4: Remove route key identity dependencies in ip_rt_get_source().")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Link: https://patch.msgid.link/20240718123407.434778-1-idosch@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 2672b71e662d3..f3e77b1e1d4b9 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1283,7 +1283,7 @@ void ip_rt_get_source(u8 *addr, struct sk_buff *skb, struct rtable *rt)
 		struct flowi4 fl4 = {
 			.daddr = iph->daddr,
 			.saddr = iph->saddr,
-			.flowi4_tos = RT_TOS(iph->tos),
+			.flowi4_tos = iph->tos & IPTOS_RT_MASK,
 			.flowi4_oif = rt->dst.dev->ifindex,
 			.flowi4_iif = skb->dev->ifindex,
 			.flowi4_mark = skb->mark,
-- 
2.43.0



