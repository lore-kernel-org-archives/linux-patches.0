Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E050E1754B;
	Mon, 27 May 2024 19:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836911; cv=none; b=REIVTveYhWazSZ7j//6+E2ZV7gd1tfaVch70N9krXuLplpb3aevW+tad5ey8JIvaJUp9/zUCBLpEB2+IeCVSbqQwZzq6WgTHAARstC6Tw6bKreMlk8x8U6SWrcFuloPd84pjVSfI4JnrXjEQUyRN6Td4pBCwlVdn3mEX9JuNnJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836911; c=relaxed/simple;
	bh=eNpY8I4U5D8Sgs8wuW2QtlS/S7YxcHNMa4w0/HQZRm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AaIBn5020J1teCfIK8jYq3eRm94o8cJPMkyTu8sDZRuUKuatyBC406OWRTk3GO/YkvWpIXtpAsc2NQrsGDwB9iT2dTdXeMckOd0qx8hrIdh+Nw9d+PxA5CdBgnyPaExXUti2lktfi7FD1iJufCSSha4QfHJufzsQneCU8Pr/3vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Os0a77p7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Os0a77p7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A01C2BBFC;
	Mon, 27 May 2024 19:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836910;
	bh=eNpY8I4U5D8Sgs8wuW2QtlS/S7YxcHNMa4w0/HQZRm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Os0a77p7iNBcTNQYmsB+EGFuuNB4yfJeQKn6uBRwLtYPDJRdrcVh/KEsTTIOnCQV+
	 hy7S2Z7yXlCXSPsN5ooXfpwVHTmXLsk7kabXEgDoFuUqQEF8g+PFozliBOJxhizmAf
	 ujiwsrlxrEfnqWTy2HSjZTRriGTbLhUgFo4GKMis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xingwang <gaoxingwang1@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 237/427] net: ipv6: fix wrong start position when receive hop-by-hop fragment
Date: Mon, 27 May 2024 20:54:44 +0200
Message-ID: <20240527185624.611654670@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: gaoxingwang <gaoxingwang1@huawei.com>

[ Upstream commit 1cd354fe1e4864eeaff62f66ee513080ec946f20 ]

In IPv6, ipv6_rcv_core will parse the hop-by-hop type extension header and increase skb->transport_header by one extension header length.
But if there are more other extension headers like fragment header at this time, the skb->transport_header points to the second extension header,
not the transport layer header or the first extension header.

This will result in the start and nexthdrp variable not pointing to the same position in ipv6frag_thdr_trunced,
and ipv6_skip_exthdr returning incorrect offset and frag_off.Sometimes,the length of the last sharded packet is smaller than the calculated incorrect offset, resulting in packet loss.
We can use network header to offset and calculate the correct position to solve this problem.

Fixes: 9d9e937b1c8b (ipv6/netfilter: Discard first fragment not including all headers)
Signed-off-by: Gao Xingwang <gaoxingwang1@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/reassembly.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index acb4f119e11f0..148bf9e3131a1 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -369,7 +369,7 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
 	 * the source of the fragment, with the Pointer field set to zero.
 	 */
 	nexthdr = hdr->nexthdr;
-	if (ipv6frag_thdr_truncated(skb, skb_transport_offset(skb), &nexthdr)) {
+	if (ipv6frag_thdr_truncated(skb, skb_network_offset(skb) + sizeof(struct ipv6hdr), &nexthdr)) {
 		__IP6_INC_STATS(net, __in6_dev_get_safely(skb->dev),
 				IPSTATS_MIB_INHDRERRORS);
 		icmpv6_param_prob(skb, ICMPV6_HDR_INCOMP, 0);
-- 
2.43.0



