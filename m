Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A3B6DCE8;
	Tue, 14 May 2024 10:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683616; cv=none; b=TdqnivNlIW4vN/fZUqlvhUMfnRO0pRFLVKplLnKdKgnTekUulW3k2Hn5uZVkgO3Wa7ATY+OEgHlkUwSYScndw2/OdhyJAiBdSVVOkq1/MR3T8r9dKL4hGAbSueGotx+i1qnQqWhd5ne6o/kBo6B0ye6dsEr4rS9gpDefu5yiFlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683616; c=relaxed/simple;
	bh=OVscp2Indq47Q8ZpIlQMT8c8Ju2P4qP+c/3xC8FRm1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5ami5Jmb61BqiRpK3tsIe8Y+wWrY9r7dFVMpRCgj6y6N7ayKDh52+0ZWnIo60Xzg4r6SamklAyAps0TIDC5nhPBJRzkxfextweFkWUsoE2aB6/2WwcJbY5JeeuoJFwDt+HgAs+d7wztb476YvBqpLf43ghKw0/aH4qdo9khO6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCNN2s0P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCNN2s0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040ACC2BD10;
	Tue, 14 May 2024 10:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683615;
	bh=OVscp2Indq47Q8ZpIlQMT8c8Ju2P4qP+c/3xC8FRm1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bCNN2s0PJjnnjUxSp9m+yAzIhIkHngioiMDWUeKcZIK6+LA/bvvXSx4Cxu1aCb6oq
	 4hP3v3LDKlMqt+47Ia67Wk5I2mTuvhw0qjOcuGnhVZCYJTgwqkmRmh08ylCI9+OIoC
	 bii3fgytuBLguEsQ5sLWafgI5CP+L/daQGkje/ZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 213/336] net: bridge: fix corrupted ethernet header on multicast-to-unicast
Date: Tue, 14 May 2024 12:16:57 +0200
Message-ID: <20240514101046.654286977@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index d7c35f55bd69f..d97064d460dc7 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -258,6 +258,7 @@ static void maybe_deliver_addr(struct net_bridge_port *p, struct sk_buff *skb,
 {
 	struct net_device *dev = BR_INPUT_SKB_CB(skb)->brdev;
 	const unsigned char *src = eth_hdr(skb)->h_source;
+	struct sk_buff *nskb;
 
 	if (!should_deliver(p, skb))
 		return;
@@ -266,12 +267,16 @@ static void maybe_deliver_addr(struct net_bridge_port *p, struct sk_buff *skb,
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



