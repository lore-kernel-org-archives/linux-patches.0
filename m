Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6027927B324;
	Tue, 21 Oct 2025 20:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077307; cv=none; b=U4xAfyskyqPc7ZMNPEmIlD+5NRB9uCAM3N/EwK033PcZo1VwyQYfgM8t/Ag+TbIuxRxKusQamDBRik+DT9leIc414fx+X/ZsH03uVhSN+PVOaInHTjAmr0S3wwqAY7C5Q75tiG1A/fAXW1CtTxdGnTteAbD4l737ODTxe5IWdUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077307; c=relaxed/simple;
	bh=I8B1aLatiN0gpkj+wp38L8l/8GzOyp9/TFoibp2bJcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ks3jBNdgTWz5x9t4ZwJdOIC71HrfXl6zwcWPY3KdjvofCOXl3cKZs5WF4mCwzh2jcwtlrBfDiwA3P9QGR5cDwRKTgKY3ZU8ouLzPesFFeldj7zLOIzlt7dwgX1Aby6n8+W8t5VwtCj5GqVChPE6sF5cE07mDMUj8cT4jeB6dpNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Px6GoB7y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Px6GoB7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E098FC4CEF7;
	Tue, 21 Oct 2025 20:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077307;
	bh=I8B1aLatiN0gpkj+wp38L8l/8GzOyp9/TFoibp2bJcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Px6GoB7yy7c4Mpc9mXyChyV3Uo2fBzfrOG27lpKFX5bcxzyAsRNjmwDpRiHtpP0W9
	 qvDB4vQy8y0glQv918AC55H2sx+7OYQ67D0r6w/gLyR5SusqkkTWvas7XGjTsQM6Eu
	 3GTmkdKrPfvqFEOcKqQtvFuw0lDfhspsxsOyyEuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Pawlik <pawlik.dan@gmail.com>,
	Matteo Croce <teknoraver@meta.com>,
	Rex Lu <rex.lu@mediatek.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 064/159] net: mtk: wed: add dma mask limitation and GFP_DMA32 for device with more than 4GB DRAM
Date: Tue, 21 Oct 2025 21:50:41 +0200
Message-ID: <20251021195044.750269021@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rex Lu <rex.lu@mediatek.com>

[ Upstream commit 3abc0e55ea1fa2250e52bc860e8f24b2b9a2093a ]

Limit tx/rx buffer address to 32-bit address space for board with more
than 4GB DRAM.

Fixes: 804775dfc2885 ("net: ethernet: mtk_eth_soc: add support for Wireless Ethernet Dispatch (WED)")
Fixes: 6757d345dd7db ("net: ethernet: mtk_wed: introduce hw_rro support for MT7988")
Tested-by: Daniel Pawlik <pawlik.dan@gmail.com>
Tested-by: Matteo Croce <teknoraver@meta.com>
Signed-off-by: Rex Lu <rex.lu@mediatek.com>
Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 0a80d8f8cff7f..16aa7e4138d36 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -670,7 +670,7 @@ mtk_wed_tx_buffer_alloc(struct mtk_wed_device *dev)
 		void *buf;
 		int s;
 
-		page = __dev_alloc_page(GFP_KERNEL);
+		page = __dev_alloc_page(GFP_KERNEL | GFP_DMA32);
 		if (!page)
 			return -ENOMEM;
 
@@ -793,7 +793,7 @@ mtk_wed_hwrro_buffer_alloc(struct mtk_wed_device *dev)
 		struct page *page;
 		int s;
 
-		page = __dev_alloc_page(GFP_KERNEL);
+		page = __dev_alloc_page(GFP_KERNEL | GFP_DMA32);
 		if (!page)
 			return -ENOMEM;
 
@@ -2405,6 +2405,10 @@ mtk_wed_attach(struct mtk_wed_device *dev)
 	dev->version = hw->version;
 	dev->hw->pcie_base = mtk_wed_get_pcie_base(dev);
 
+	ret = dma_set_mask_and_coherent(hw->dev, DMA_BIT_MASK(32));
+	if (ret)
+		goto out;
+
 	if (hw->eth->dma_dev == hw->eth->dev &&
 	    of_dma_is_coherent(hw->eth->dev->of_node))
 		mtk_eth_set_dma_device(hw->eth, hw->dev);
-- 
2.51.0



