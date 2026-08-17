Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85288442B12;
	Mon, 17 Aug 2026 15:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979857; cv=none; b=UvUNFz+oaQd3WPTUjoPE4ofLoT4pqmhCr0ayeyKHLkwUN0Ncg2+AZnNVeKG36VMKcaUHVMerHFnzR/xqpWNk5n/XylUWM8nZILXuva99q8XV50aTs3XHbs7wdLDBfd8PtCTwaGl9CZJ2cCKU9LecLlPD3ai6K6dIK8uOMT/oQTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979857; c=relaxed/simple;
	bh=fmf+dbE26Khy105TVLeQ7O3mbFq+UZaLYbKNiQ5uC38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKFWfcEr2tQEi9WKHrcwm/QlMKgRpYPUo+x81HnA0vd1NRiuiG1hZSUluoMvrk02C85AP4D/t3xN2dQ/g8RIUWO5OSLq7v9LdaX4Ks/JqDp5/8GXGiR7SmbHiLeG2QBapWyP5tMyqrVPVZXZ5YmlkQNnqNxbH+iR5Z61QVlECQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X1N4GgCm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X1N4GgCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D577B1F00A3D;
	Mon, 17 Aug 2026 15:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979856;
	bh=Dk+ia0Lo7+4O/7+upkdQeXQnBHuc/LXvp3qOqBz7gNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X1N4GgCmxBiCPNdHkBlhL3Q543NM9B0Vf97duawyRwa33Y8exxmVbsIZC41r+8LR0
	 JmJukbBC+LnJ9QvWS7J5FqCvX5mmsznyWoOo7oszW1zQorakSWC8j0rxeXbYlqrhRr
	 Mjn/7Z86kqv5eSsIi1FaObcB93m+SApyTsyDXnRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 372/609] net: sxgbe: check descriptor ring allocation failures
Date: Mon, 17 Aug 2026 15:31:08 +0200
Message-ID: <20260817132556.733982670@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Chenguang Zhao <zhaochenguang@kylinos.cn>

[ Upstream commit 51b093a7ba27476e1f639455f005e8d2e75390e4 ]

sxgbe_open() ignores the return value of init_dma_desc_rings() and
continues to program DMA with invalid ring addresses when allocation
fails. Check the return value and disconnect the PHY on failure.

Fixes: 1edb9ca69e8a ("net: sxgbe: add basic framework for Samsung 10Gb ethernet driver")
Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index 2801526f75962..342faeb6c8afa 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -1080,7 +1080,9 @@ static int sxgbe_open(struct net_device *dev)
 	priv->dma_buf_sz = SXGBE_ALIGN(DMA_BUFFER_SIZE);
 	priv->tx_tc = TC_DEFAULT;
 	priv->rx_tc = TC_DEFAULT;
-	init_dma_desc_rings(dev);
+	ret = init_dma_desc_rings(dev);
+	if (ret)
+		goto init_phy_error;
 
 	/* DMA initialization and SW reset */
 	ret = sxgbe_init_dma_engine(priv);
@@ -1189,6 +1191,7 @@ static int sxgbe_open(struct net_device *dev)
 
 init_error:
 	free_dma_desc_resources(priv);
+init_phy_error:
 	if (dev->phydev)
 		phy_disconnect(dev->phydev);
 phy_error:
-- 
2.53.0



