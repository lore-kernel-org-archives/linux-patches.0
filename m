Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DF612EBD4;
	Tue, 14 May 2024 11:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687412; cv=none; b=JpZDeuyIaXHlR/HH4YVlORRwz4n6W5gL8sIZ3l7yLz21hmh561wZDg3fd1tByQ9BqihEgR8hTKYbU5kp5TPQ8IrLBIQXKpXIqcL8CGIPGyN0MTXr6HsiOPdpkg4UGtNGTFPZlBes+35bYmYQzKeRDeltD3+IXf6ITHm0JcEonqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687412; c=relaxed/simple;
	bh=Sq7wTOiPttDnHCPPvij1z48iSz9aExQ9qc7AlsfUtOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n0dBZw+ID2bRqEITSMU/gQh5UtKGQbJUo7p7sOCEveOcp1D9uvr7q5sk7s5OK6cMOjSIGZInXePsc7N1WHK57YCWQPxq12Ml8dRIxpTWbUKaBEQUokIsUfHhRf1xM+ecgXEpVKdqgH+u0To5i1nL6u6+Vr9I/Oqvrl9msp5LFIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=azFqcF0P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="azFqcF0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA15CC2BD10;
	Tue, 14 May 2024 11:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687412;
	bh=Sq7wTOiPttDnHCPPvij1z48iSz9aExQ9qc7AlsfUtOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=azFqcF0PNLdpSCMw7/2Wq+/ZSPlYolZMIaB/JzNttyBRHs4p4ki59J87+JBEIC8Jo
	 CXFDKlUjPOsGv4EvBUeqCoSGp9GaB6He5l3OzF/3Gen7HEK9sajemPbN2yD+YlMT2X
	 Ai6kV6HWxdb8k+3nZ9BFIMleoGPqv6OC7yOenThM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/111] net: bridge: fix corrupted ethernet header on multicast-to-unicast
Date: Tue, 14 May 2024 12:20:24 +0200
Message-ID: <20240514101000.398875412@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 86b29d830ad69eecff25b22dc96c14c6573718e6 ]

The change from skb_copy to pskb_copy unfortunately changed the data
copying to omit the ethernet header, since it was pulled before reaching
this point. Fix this by calling __skb_push/pull around pskb_copy.

Fixes: 59c878cbcdd8 ("net: bridge: fix multicast-to-unicast with fraglist GSO")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_forward.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 3a70682e63524..ada03d49e7c1a 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -245,6 +245,7 @@ static void maybe_deliver_addr(struct net_bridge_port *p, struct sk_buff *skb,
 {
 	struct net_device *dev = BR_INPUT_SKB_CB(skb)->brdev;
 	const unsigned char *src = eth_hdr(skb)->h_source;
+	struct sk_buff *nskb;
 
 	if (!should_deliver(p, skb))
 		return;
@@ -253,12 +254,16 @@ static void maybe_deliver_addr(struct net_bridge_port *p, struct sk_buff *skb,
 	if (skb->dev == p->dev && ether_addr_equal(src, addr))
 		return;
 
-	skb = pskb_copy(skb, GFP_ATOMIC);
-	if (!skb) {
+	__skb_push(skb, ETH_HLEN);
+	nskb = pskb_copy(skb, GFP_ATOMIC);
+	__skb_pull(skb, ETH_HLEN);
+	if (!nskb) {
 		DEV_STATS_INC(dev, tx_dropped);
 		return;
 	}
 
+	skb = nskb;
+	__skb_pull(skb, ETH_HLEN);
 	if (!is_broadcast_ether_addr(addr))
 		memcpy(eth_hdr(skb)->h_dest, addr, ETH_ALEN);
 
-- 
2.43.0



