Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EFE27D784;
	Tue, 27 May 2025 17:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368394; cv=none; b=O9NEm3QFxPj98wg2LfNMJGJZBMnkPt3pWrD43/VFYw4SnCkoZFi0TD+vMDGWARU6K5UIgvUZ5QTE/IwZeIwVawYOsqKz6TEVdpsD6vxSKW6yqd5gppWt2tl8qXoZyd7U7V4EeoD50+8pQC708BjFIg2FIT9DQCFj9nzN9MoW2HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368394; c=relaxed/simple;
	bh=N2H17D490MlzIHhuJ1/ica2PXvKiMGRfw/zpDCq7xeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlMQWXIwzcoS/eEXjn7nHZU8dy9W3GF7sYR7AT0/rX1ZscWCqKd85jFDcsy5vIZRJo8nMOs0ZPDArlF1Az4YSBELrP3IuYYMuqxjfSpibcxGGGKgKv8nVFkXESsTvZgm4TePpTGSx9Nbl72M5barreC+6Qivgjhq3Mar/c07fCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OBEmLV5x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OBEmLV5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85D3C4CEE9;
	Tue, 27 May 2025 17:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368394;
	bh=N2H17D490MlzIHhuJ1/ica2PXvKiMGRfw/zpDCq7xeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OBEmLV5xGBRW7DLmQ2pzcrM/iPSs41mbX83MnN1vIopMUFKmb/U12Xisb8uTmLBBk
	 txPvKwvwnQCaxgDR0ClR3WR+eRK5XeOCsNHp4YCQbHBu0HYoDWWq0otlwRu0p4lx17
	 HTjJ/h+MhzT+xxzX97y/sNXaXTvF8RnGshAzjseE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Joy Zou <joy.zou@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 692/783] dmaengine: fsl-edma: Fix return code for unhandled interrupts
Date: Tue, 27 May 2025 18:28:09 +0200
Message-ID: <20250527162541.312209401@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index e3e0e88a76d3c..619403c6e5173 100644
--- a/drivers/dma/fsl-edma-main.c
+++ b/drivers/dma/fsl-edma-main.c
@@ -57,7 +57,7 @@ static irqreturn_t fsl_edma3_tx_handler(int irq, void *dev_id)
 
 	intr = edma_readl_chreg(fsl_chan, ch_int);
 	if (!intr)
-		return IRQ_HANDLED;
+		return IRQ_NONE;
 
 	edma_writel_chreg(fsl_chan, 1, ch_int);
 
-- 
2.39.5



