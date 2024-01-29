Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C73157E67;
	Mon, 29 Jan 2024 17:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548052; cv=none; b=g1owGFs+oL3kR/akpCWySiQE0Jhi85X1u/Zg4OJ+fXpdVCWY1KSdlyyPW4aXAgERQWWIhUQG8YcUehhB8pwu9DnKX371e9wO9bVpZK7LMb9PMN3Lrf6PSb4aoIli6JOT7a6O6a3zO/azWb3DMYmMESnDxeug2yEazsPDFl2+Qa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548052; c=relaxed/simple;
	bh=e5HpxFkNxTy/9AQzJ31MyM1DRFbc4lLmJjirSTrPBBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UD2hrYaVq02yuSCVobuukv7cmUIPPOZpwvxtPaCAbAMMhUHGFMs7c2QhkRuPMl5U88fHSsDC7582DS1MhKiymlKmWHChCBW3nIDLAa2FfopW9nfpd38oZEScv41tR6ny1Jui/MRYanBZcoHQcradw/Ry8gKt5Kmd1opHPuYFppM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aVovv1oT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVovv1oT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC73C433F1;
	Mon, 29 Jan 2024 17:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548052;
	bh=e5HpxFkNxTy/9AQzJ31MyM1DRFbc4lLmJjirSTrPBBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVovv1oTYDVYRst7MM5q9cEZW1gIfdTXUKTGNntWc3mNaRNircO9w7VPVZQS8YIXB
	 MpOa/Bi/6/W0JUtrFlM6gjLw14jLsKkEX2E+Aa0uqpO6JDd+Vyh0/hIwy97MWq10Bu
	 zLjLG9C/6N/976t9uUQRNSXkj/78ukdkJSbHzQMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 054/346] dmaengine: xilinx: xdma: Fix the count of elapsed periods in cyclic mode
Date: Mon, 29 Jan 2024 09:01:25 -0800
Message-ID: <20240129170017.980121472@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 26ee018ff6d1c326ac9b9be36513e35870ed09db ]

Xilinx DMA engine is capable of keeping track of the number of elapsed
periods and this is an increasing 32-bit counter which is only reset
when turning off the engine. No need to add this value to our local
counter.

Fixes: cd8c732ce1a5 ("dmaengine: xilinx: xdma: Support cyclic transfers")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20231130111315.729430-2-miquel.raynal@bootlin.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xdma.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/xilinx/xdma.c b/drivers/dma/xilinx/xdma.c
index 84a88029226f..2c9c72d4b5a2 100644
--- a/drivers/dma/xilinx/xdma.c
+++ b/drivers/dma/xilinx/xdma.c
@@ -754,9 +754,9 @@ static irqreturn_t xdma_channel_isr(int irq, void *dev_id)
 	if (ret)
 		goto out;
 
-	desc->completed_desc_num += complete_desc_num;
-
 	if (desc->cyclic) {
+		desc->completed_desc_num = complete_desc_num;
+
 		ret = regmap_read(xdev->rmap, xchan->base + XDMA_CHAN_STATUS,
 				  &st);
 		if (ret)
@@ -768,6 +768,8 @@ static irqreturn_t xdma_channel_isr(int irq, void *dev_id)
 		goto out;
 	}
 
+	desc->completed_desc_num += complete_desc_num;
+
 	/*
 	 * if all data blocks are transferred, remove and complete the request
 	 */
-- 
2.43.0



