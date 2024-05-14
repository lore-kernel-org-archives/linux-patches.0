Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9ADF84D26;
	Tue, 14 May 2024 11:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686266; cv=none; b=dFMlpsWvIEvlqZ/WK75NE1j18N5dCofJYNe7XVczi+wQn3c2+e9c0OMbHUXviJcVdDnHGM4H0Jc3C4xEMw9xFPHa2CA2NXrGA3NIBui546O5D0c0tNjPWtEzPvdZVK/iAtAgEeaPbG/0ViZqIsGHGoIt6PQJrfFDfzXO1uR6anc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686266; c=relaxed/simple;
	bh=DDyEZx+zuv4ywpVgyeg6bRX1o/zytidZozq54R/FBsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGnPKmmhmWVb09U9ny3EDrubgcDURSD75vcHJlVs6cmE4iFWTwqoTGmEEShFrg1cu95hTYU16ZVXyyOtxswXFJzEBfjmSjcyQQWv6ndoA8paKoo8JxTv4oChmfljDCAICIhhPpQSJaXefGhgO+XRqCnHOfq1YD4w3u8hTP9UJks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+3Rs7ay; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+3Rs7ay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EFFAC2BD10;
	Tue, 14 May 2024 11:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686266;
	bh=DDyEZx+zuv4ywpVgyeg6bRX1o/zytidZozq54R/FBsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+3Rs7ayOVH+2OZwOgB110AotJ+GdyO+xv1a/ZqhFKwvdWdyzvqyYeu442u3UwgYz
	 iEmlSsPI4IrjWbd3u5X79bFzznbryjhK2asxiJ7Iw4v3KAjKIqvnBJgV7FbedJBxWx
	 YnEgOhXjjVcBfItvkwiwGaaGbnBdt0GRgCu8x/H4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Paolo Abeni <pabeni@redhat.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 077/236] net: bridge: fix multicast-to-unicast with fraglist GSO
Date: Tue, 14 May 2024 12:17:19 +0200
Message-ID: <20240514101023.293465100@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 59c878cbcdd80ed39315573b3511d0acfd3501b5 ]

Calling skb_copy on a SKB_GSO_FRAGLIST skb is not valid, since it returns
an invalid linearized skb. This code only needs to change the ethernet
header, so pskb_copy is the right function to call here.

Fixes: 6db6f0eae605 ("bridge: multicast to unicast")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_forward.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 4e3394a7d7d45..982e7a9ccc41c 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -261,7 +261,7 @@ static void maybe_deliver_addr(struct net_bridge_port *p, struct sk_buff *skb,
 	if (skb->dev == p->dev && ether_addr_equal(src, addr))
 		return;
 
-	skb = skb_copy(skb, GFP_ATOMIC);
+	skb = pskb_copy(skb, GFP_ATOMIC);
 	if (!skb) {
 		DEV_STATS_INC(dev, tx_dropped);
 		return;
-- 
2.43.0



