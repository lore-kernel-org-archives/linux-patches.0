Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2262798E6;
	Tue, 27 May 2025 17:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366044; cv=none; b=GO3yyrS3CiK0eC9HTFdFMWgJhVJAqS/LYjWnefPJ2Ec0lafzRl867wo157e6xTdYHrV3xvtfRyQLSW6KY13qVpGGI2Kp+xnnWSsYiB0ayR2oyvgZMp9ecn+456uxpbCgx05/CdNuBgK+YQpcgZ0Wl+2lZTCYcvkYV9h3xEL0+po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366044; c=relaxed/simple;
	bh=9M1J1iRwqfz/jWEN6O4bC5Tz/jzERxTqgaVLoG00ACM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MDEqvI0Z51yXkC8O3sEZYjbGPCGjrkIyJOJPWFoM/V3pKJ2jlTcMUEbcGfU/CfC9ZFCoK7tdGBPSWVCU9hCofip6CrRp2EBCngQWUJtnUEJfNiUVLtLt7BPD7EFVdPEoVe5Lt5yI7nSTYHaxwDr9s98cO50gI8oggjd9ZBWAOaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZHKNYuu5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZHKNYuu5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A235C4CEE9;
	Tue, 27 May 2025 17:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366043;
	bh=9M1J1iRwqfz/jWEN6O4bC5Tz/jzERxTqgaVLoG00ACM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZHKNYuu5ikCl1Z8A9WwwuoYMsH0VHKTYYr+X3J+oR8k+nlwxCE1wOY9VLouSV97bb
	 BRZKVBzu5a3KZorihuXwFMyHXDsLr7RmOyYAwmcNyAYCJolIse+eWcGMOQv13qN1ZO
	 QZFsqz2gqRuhCoAmKkb9ZG6ipe8Yo3JDOnDROzvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Joy Zou <joy.zou@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 545/626] dmaengine: fsl-edma: Fix return code for unhandled interrupts
Date: Tue, 27 May 2025 18:27:18 +0200
Message-ID: <20250527162507.130334213@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit 5e27af0514e2249a9ccc9a762abd3b74e03a1f90 ]

For fsl,imx93-edma4 two DMA channels share the same interrupt.
So in case fsl_edma3_tx_handler is called for the "wrong"
channel, the return code must be IRQ_NONE. This signalize that
the interrupt wasn't handled.

Fixes: 72f5801a4e2b ("dmaengine: fsl-edma: integrate v3 support")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Joy Zou <joy.zou@nxp.com>
Link: https://lore.kernel.org/r/20250424114829.9055-1-wahrenst@gmx.net
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl-edma-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/fsl-edma-main.c b/drivers/dma/fsl-edma-main.c
index 27645606f900b..4794d58dab556 100644
--- a/drivers/dma/fsl-edma-main.c
+++ b/drivers/dma/fsl-edma-main.c
@@ -56,7 +56,7 @@ static irqreturn_t fsl_edma3_tx_handler(int irq, void *dev_id)
 
 	intr = edma_readl_chreg(fsl_chan, ch_int);
 	if (!intr)
-		return IRQ_HANDLED;
+		return IRQ_NONE;
 
 	edma_writel_chreg(fsl_chan, 1, ch_int);
 
-- 
2.39.5



