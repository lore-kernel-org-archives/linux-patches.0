Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4599112C491;
	Tue, 30 Apr 2024 10:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474488; cv=none; b=NQEqrGhewqoABRyZj4oaF33M/6tOux8XaQWd1iu+QxmaF1K3F8kRDb1JoB/lE+9pX+Zd8SBrvmQeRnCIAyvNFabSmQYnq6IN62qqCW+A9R5Zt62J0B0fPDJbitYxGu80azs8npGyROMKxKdNYAHTJaeFzg4DWDfFL8r5Cinnf0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474488; c=relaxed/simple;
	bh=8Zg0FUGoC+MP2IC5wjjVdrgou2WcnWL/fHrPieND2oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHd5f9SMxlEZU3Rxuxnn/fbSmRemyKZ2AhgWmcWpNvuiHksljzWY1IFVYEIK4jIdeAh3s1qzLoMdDNRdkQQtiNsXbyGmModbiaj2NnKK6VVvDqMCVa5WB9XIWisLewyi/RE8bkMDI9YVCUNbIQas5XK1cLlNlIuGYjmOIjgqZEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZH8O+3sb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZH8O+3sb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7414EC2BBFC;
	Tue, 30 Apr 2024 10:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474487;
	bh=8Zg0FUGoC+MP2IC5wjjVdrgou2WcnWL/fHrPieND2oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZH8O+3sbTn7wThkaKPeWti2p8ddE8E9RjXBUmDPKRIhG+yVe6TyEgkLE4RgItLucB
	 LC5Bd+PSPqjYGhrCLcVHwh847rGUExv72Su1TYD53qkQTqYtFNRZPqMcv3ONGAsiTm
	 Kxu0guRyslXkp55kBbsgrpzzcy/IZJbjKM6ZIObk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Louis Chauvet <louis.chauvet@bootlin.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.8 171/228] dmaengine: xilinx: xdma: Fix wrong offsets in the buffers addresses in dma descriptor
Date: Tue, 30 Apr 2024 12:39:09 +0200
Message-ID: <20240430103108.738352911@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 5b9706bfc094314c600ab810a61208a7cbaa4cb3 upstream.

The addition of interleaved transfers slightly changed the way
addresses inside DMA descriptors are derived, breaking cyclic
transfers.

Fixes: 3e184e64c2e5 ("dmaengine: xilinx: xdma: Prepare the introduction of interleaved DMA transfers")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Louis Chauvet <louis.chauvet@bootlin.com>
Link: https://lore.kernel.org/r/20240327-digigram-xdma-fixes-v1-1-45f4a52c0283@bootlin.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/xilinx/xdma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/xilinx/xdma.c
+++ b/drivers/dma/xilinx/xdma.c
@@ -704,7 +704,7 @@ xdma_prep_dma_cyclic(struct dma_chan *ch
 	desc_num = 0;
 	for (i = 0; i < periods; i++) {
 		desc_num += xdma_fill_descs(sw_desc, *src, *dst, period_size, desc_num);
-		addr += i * period_size;
+		addr += period_size;
 	}
 
 	tx_desc = vchan_tx_prep(&xdma_chan->vchan, &sw_desc->vdesc, flags);


