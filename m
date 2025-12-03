Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025CE33344A;
	Wed,  3 Dec 2025 16:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780558; cv=none; b=VNpwWwsBdTarzGFLO0A7GnIBiTSEA67gnSdfs34f6Qx6oeiotHONxhY+L6dOte0VlgXdyq3tbdhNZa5tptqbSTlqvgloTTymdaDHa5Vq8rH5LMfRn8fJSAT8XeT0RHbIpgfeXRj38fxsSCWacqMqr4o+sRU/N3AXs1BHBaxkroA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780558; c=relaxed/simple;
	bh=/yp6IFMAlXWA5CjLncS/I/uUsAwS+thn7ElI0C1bpSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WUTO5aS4GRLpPrenJhDQbTEfLDgEvElUj0OrpNeXf1uPFZSbruT0rzhQrghWFr2bJBrYEgZhQhfuvZHmXq6B1R2vvOMxLAzN7MzrQPCmQds/8y6eYmRG6L6ji9WTFA5EOh65a+GZZEgmvNNhZ8c9+FHMolzmBflGBkKliUNT2xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wS1l43Bc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wS1l43Bc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35020C4CEF5;
	Wed,  3 Dec 2025 16:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780557;
	bh=/yp6IFMAlXWA5CjLncS/I/uUsAwS+thn7ElI0C1bpSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wS1l43Bc5cCIMN7Wd+eJS7CkC1VaThRqspRkbQLGJoOg2Lzfx3D/C8dfJiUVNlb21
	 hguDVkyTztjR2KpbH9VJwUGIfiQJx2n7axhVOUfVJEEBez0HJk8nPAYjHeTmzsGPcp
	 /ledJdVvtPGGmCTETUt2pSXv1olTswAVETbed0nM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Kodanev <aleksei.kodanev@bell-sw.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 021/132] net: sxgbe: fix potential NULL dereference in sxgbe_rx()
Date: Wed,  3 Dec 2025 16:28:20 +0100
Message-ID: <20251203152344.084428141@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

From: Alexey Kodanev <aleksei.kodanev@bell-sw.com>

[ Upstream commit f5bce28f6b9125502abec4a67d68eabcd24b3b17 ]

Currently, when skb is null, the driver prints an error and then
dereferences skb on the next line.

To fix this, let's add a 'break' after the error message to switch
to sxgbe_rx_refill(), which is similar to the approach taken by the
other drivers in this particular case, e.g. calxeda with xgmac_rx().

Found during a code review.

Fixes: 1edb9ca69e8a ("net: sxgbe: add basic framework for Samsung 10Gb ethernet driver")
Signed-off-by: Alexey Kodanev <aleksei.kodanev@bell-sw.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251121123834.97748-1-aleksei.kodanev@bell-sw.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index 12c8396b6942d..d2ba283f6123f 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -1520,8 +1520,10 @@ static int sxgbe_rx(struct sxgbe_priv_data *priv, int limit)
 
 		skb = priv->rxq[qnum]->rx_skbuff[entry];
 
-		if (unlikely(!skb))
+		if (unlikely(!skb)) {
 			netdev_err(priv->dev, "rx descriptor is not consistent\n");
+			break;
+		}
 
 		prefetch(skb->data - NET_IP_ALIGN);
 		priv->rxq[qnum]->rx_skbuff[entry] = NULL;
-- 
2.51.0



