Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7C747CA74;
	Fri,  7 Aug 2026 15:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116995; cv=none; b=UKOW7IjPl/9xuu3m12Eb2u2ZQ+r+A/EL5j1uJJWb46FU6FGHxqvwndu0++9uipoZAfJs7ClJgXgQ1n8wmRcNNRj71ssnTj0JFYKUZf5fJTt7+4FgJYx1osuZftKC8luhZ/De6GmP8LICDsKTk4Sp6lx8N5c+yX8CqNbaVQO0KYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116995; c=relaxed/simple;
	bh=9cbvagAZN5CvMuY5LWW9qoFwMgJi3ON8gIM1Wbkbrm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DW7eoXZGYwqmGtRwVA84QxHY/LVaXZMrmYVRz8af3xGDpjqnE+iLOSNszeeiX+38A6X/vB+RJuYT90d33lhY09B5b9Fm8nAi+eakDCtTdhLptHBW3VitvokMQY5ylHcs9Q8pmmXmDL9TNK1xvpfdJZtXpxily2wUWg14tG3QKUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bR0aQhmx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bR0aQhmx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F8F1F00A3A;
	Fri,  7 Aug 2026 15:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116994;
	bh=JO1bUWIHPXPgAcC6jFgGVlDiKONMPSU5tEBmuowUGJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bR0aQhmxGoiGzYF8WqXUjrRi1Ep4D8PnTxRjGvLrbjg0qBsVuUebXgOGdg2Pc/UwO
	 iCiTkGFF4M3oWzNvYwcMZiqQzrLXacXrBi0db+sTqcsOw1fsdpSN7Ub/Ww/Zs0dCVA
	 Ali3+82NtnWshb8+IASWfiL55l66Oh7uDiMj1L7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 161/438] net: sxgbe: check descriptor ring allocation failures
Date: Fri,  7 Aug 2026 16:35:57 +0200
Message-ID: <20260807143431.467148537@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9b48a587d5c2e..70cf3619555f9 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -1078,7 +1078,9 @@ static int sxgbe_open(struct net_device *dev)
 	priv->dma_buf_sz = SXGBE_ALIGN(DMA_BUFFER_SIZE);
 	priv->tx_tc = TC_DEFAULT;
 	priv->rx_tc = TC_DEFAULT;
-	init_dma_desc_rings(dev);
+	ret = init_dma_desc_rings(dev);
+	if (ret)
+		goto init_phy_error;
 
 	/* DMA initialization and SW reset */
 	ret = sxgbe_init_dma_engine(priv);
@@ -1187,6 +1189,7 @@ static int sxgbe_open(struct net_device *dev)
 
 init_error:
 	free_dma_desc_resources(priv);
+init_phy_error:
 	if (dev->phydev)
 		phy_disconnect(dev->phydev);
 phy_error:
-- 
2.53.0



