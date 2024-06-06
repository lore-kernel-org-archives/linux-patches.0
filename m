Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E841719A2B5;
	Thu,  6 Jun 2024 14:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683292; cv=none; b=darESBQyxt1L7A1hFTCs8gkWWrhMvI2X7MPxTEYkkv+Im00lIGQ8EKjWmpteJRVSOa11WwJEFgJiKlqX185npE6FriT3ThKjflgcL4jo005tzMyhLM8TqWaMjZq+HWKGiBVtvmvWikmpIzJQYQFgA9msKC+yLFN5M9/EvaVvO9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683292; c=relaxed/simple;
	bh=38XNr6FH1qXAaR5g+T7rWapzYnYhnOrt473FR7Hg4ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mO9KaCqOh83VqkfnQgVXVqDMgAeOiSZe+drDI/VcYLTf766ddjwNAKqdfi3EmDNKTlWiKG4c2dCGoZpSnOiPRS2OphfbpSySaxysjdGajli4Qg347XDqWNlRalXUPySHDu7qb9VYOgfekcER+jdvNOZdXma/QklWL5exDNUNQnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FwVUucD/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FwVUucD/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8911C32781;
	Thu,  6 Jun 2024 14:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683291;
	bh=38XNr6FH1qXAaR5g+T7rWapzYnYhnOrt473FR7Hg4ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FwVUucD/x+6ttvv3lyg5IWmt2w0k60qFinCzfEPanJkH+ObEzHN4gHMavqlAnRt+x
	 jxqKmDQ36znuOvUCpeIxi7pbhHBOP48Juho8cPpZb3DTTDroIhZtM051VGkYRuCRiY
	 lcbJ4ha/JBsucrydPQ6kCCSt0nn7LiEy11L+hAfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xingwang <gaoxingwang1@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 168/473] net: ipv6: fix wrong start position when receive hop-by-hop fragment
Date: Thu,  6 Jun 2024 16:01:37 +0200
Message-ID: <20240606131705.496338900@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ff866f2a879e0..32ba4417eb1de 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -364,7 +364,7 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
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



