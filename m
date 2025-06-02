Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BF31C5D72;
	Mon,  2 Jun 2025 14:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874136; cv=none; b=SkLNYOu08Wcu08YSAN2ne4TUvpON5SP+reoMHljJ+YPRuH4weLss8tO4WlQWdhGWHSGGxWS9LoRA+TqwJfJF0p/3Pm6SObUBQieN2lSDQmqcCsKXd09y3tI6gk15ZYjvYCsuTH7xEG6YC/I8VP3DeKym+zpwZ1H9QEmfavzxDqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874136; c=relaxed/simple;
	bh=EPzxl7YrD01h2PVU0wRu2i1rTEwsGa/0o8Ens1cwSKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4qvho32wWyhFQpiwu+UrIAZ5xktixqlepqTtTUQEpwCeEcDGTptt0XCleS6Kzx63CsrgIOHuXWmCD4k8RE8Iwvqm51mO9Mxxv+B31XQr8qR5TpnoGi840BmJOkOGtIafBlwyZ5UhmZfuD2c9NHh8Wxhpz7g4MOW9lDw3aOBfms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=httUQ4dx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="httUQ4dx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2344C4CEEB;
	Mon,  2 Jun 2025 14:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874136;
	bh=EPzxl7YrD01h2PVU0wRu2i1rTEwsGa/0o8Ens1cwSKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=httUQ4dxr/nutxMEyIbca+HiwumFLoWowAYPLWap0His246frRhW3c4Q3YvWAtl/A
	 4edG4ejWHT7h7/JihOfXZ8kl5wNPpdExfYcSmA0Gcc4Sb6LybpAGeJ3PZQgXE3YtUa
	 GOpTLNYFcg6sCTnQvucBP9NmpTJ46FB7yiejxlsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Joy Zou <joy.zou@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 339/444] dmaengine: fsl-edma: Fix return code for unhandled interrupts
Date: Mon,  2 Jun 2025 15:46:43 +0200
Message-ID: <20250602134354.685967670@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cc9923ab686dc..eccbcf67951fb 100644
--- a/drivers/dma/fsl-edma-main.c
+++ b/drivers/dma/fsl-edma-main.c
@@ -58,7 +58,7 @@ static irqreturn_t fsl_edma3_tx_handler(int irq, void *dev_id)
 
 	intr = edma_readl_chreg(fsl_chan, ch_int);
 	if (!intr)
-		return IRQ_HANDLED;
+		return IRQ_NONE;
 
 	edma_writel_chreg(fsl_chan, 1, ch_int);
 
-- 
2.39.5



