Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8077396565;
	Fri,  7 Aug 2026 15:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115048; cv=none; b=GEe5MH1Tde+0sV+nZeceMALvxrUZ90CTsRP9g64Nz9CY9/INPdp68mmMNhCPzjQ6/EMgVZCH+j7vzj3CRBOjfZR50GwbVeMg8EO26gkh8eOccP0UmutdMIyxDHlQZQ5cXBZuw+KBD6PAwb2hhhM0Kymr/r5Zp/D7DGxP+/1ogjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115048; c=relaxed/simple;
	bh=irBQm2MkTdkFjAeXJewyaGRN45FycgABpPxLRswm+Fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JuoaB8xlidP5HhYS0nkWKtkeSPT1kV7LdvoiOgWwNGwMPY+AJ9Evuvp+Xjl4YfN5VhjS6nh3XoqzbG6zTNs9KCzHidhE53eEpnSw6ZTR8twrPVffvJaYrqXyvQxnDF8Z1RwPkB8S8VTy/CoJ21nMoa6lYc0zZcOQm7ighN/hNB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BgT2Ua8z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BgT2Ua8z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51111F00A3D;
	Fri,  7 Aug 2026 15:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115042;
	bh=JHtKCLNieTsVG7pGMofeF56qQZiwESG5fCjJYy39upM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BgT2Ua8zHXw+h3Z2VtCjooInzguami+W0p4jzevTjGWBjPTMoSo2Uy+qioxPUP5EG
	 vCckZ9h9SCz6vERK0Txkn+ahSHkujebXF6binAw5ol5YfB2ph4qK94GLGgEKXppfAJ
	 gvYXD3FwfPhh5ulfLlLBjHFOtg5FvWrEdBL7AZkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 135/396] net: sxgbe: check descriptor ring allocation failures
Date: Fri,  7 Aug 2026 16:34:55 +0200
Message-ID: <20260807143427.217640544@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5eb8e7c232f8b..848a0578cea1f 100644
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



