Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80AEE46A610;
	Tue, 21 Jul 2026 15:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649120; cv=none; b=QCk8Lh/D1Y2EUZ0NSEsvb2W/UMCvJMukwET2D+i0VczrKwyjR/eqz5H+gQhCiLibrpla6Wt1LMItbyFh8LPp1mZ9qiShJSkZ9If8/H4XPMl3bdqQud1w/tWts4IiRtA4rtV7+NPG+ZuBeJeyMrPzOnVmD3ENp7iHju3VQbTYsV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649120; c=relaxed/simple;
	bh=FpI4Pioko5SMjA9vgg36HTHiKRMS3hVJwu370tRK1jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9F3QniRvwTA1lH62CnZLpKd5XpjARQwHNGHX0tJvX98wW2mCLuUeTc6P4zmNzH2JkDyvc7tEZJ26H416Do7kz716ZYVhYaGgspiaAQKCMCyJmJKkfUonhQ+46ytQptYHF6whqWerVVw5sTXh0IYpx1ArXOIvmmmygFyg9LD7zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2KwvxZUu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2KwvxZUu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70771F000E9;
	Tue, 21 Jul 2026 15:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649118;
	bh=/1GOXeTFoyqvWVstXvjjSacmfSpUQ/fyln7uQDH7vk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2KwvxZUuNFVz8ntBWJA9/rjsDqUcqfmoJJBZ42fTlNAv3oEWYJzxu0Rdc07vmVGWc
	 killUoJkB/sZqFjAQ94oUj69J2gIqAFQXPc2eL3uZ3a+CKz441bdEIG/iaP6uKsDxh
	 hYgHXNIb2RGSDB6ZVw2oDDbOdF4+gKjXw3yPFlaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0413/2077] spi: imx: replace dmaengine_terminate_all() with dmaengine_terminate_sync()
Date: Tue, 21 Jul 2026 17:01:26 +0200
Message-ID: <20260721152602.475010421@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Carlos Song <carlos.song@nxp.com>

[ Upstream commit 4503b2fe761c2bfd33ed043d9b9deec0d1eb40e0 ]

dmaengine_terminate_all() has been deprecated, so replace it with
dmaengine_terminate_sync().

Fixes: ba9b28652c75 ("spi: imx: enable DMA mode for target operation")
Fixes: a450c8b77f92 ("spi: imx: handle DMA submission errors with dma_submit_error()")
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Link: https://patch.msgid.link/20260525062928.3191821-1-carlos.song@oss.nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-imx.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 480d1e8b281f19..ae9912905c67ad 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1774,8 +1774,8 @@ static int spi_imx_dma_submit(struct spi_imx_data *spi_imx,
 							transfer_timeout);
 		if (!time_left) {
 			dev_err(spi_imx->dev, "I/O Error in DMA TX\n");
-			dmaengine_terminate_all(controller->dma_tx);
-			dmaengine_terminate_all(controller->dma_rx);
+			dmaengine_terminate_sync(controller->dma_tx);
+			dmaengine_terminate_sync(controller->dma_rx);
 			return -ETIMEDOUT;
 		}
 
@@ -1784,7 +1784,7 @@ static int spi_imx_dma_submit(struct spi_imx_data *spi_imx,
 		if (!time_left) {
 			dev_err(&controller->dev, "I/O Error in DMA RX\n");
 			spi_imx->devtype_data->reset(spi_imx);
-			dmaengine_terminate_all(controller->dma_rx);
+			dmaengine_terminate_sync(controller->dma_rx);
 			return -ETIMEDOUT;
 		}
 	} else {
@@ -1793,15 +1793,15 @@ static int spi_imx_dma_submit(struct spi_imx_data *spi_imx,
 		if (wait_for_completion_interruptible(&spi_imx->dma_tx_completion) ||
 		    READ_ONCE(spi_imx->target_aborted)) {
 			dev_dbg(spi_imx->dev, "I/O Error in DMA TX interrupted\n");
-			dmaengine_terminate_all(controller->dma_tx);
-			dmaengine_terminate_all(controller->dma_rx);
+			dmaengine_terminate_sync(controller->dma_tx);
+			dmaengine_terminate_sync(controller->dma_rx);
 			return -EINTR;
 		}
 
 		if (wait_for_completion_interruptible(&spi_imx->dma_rx_completion) ||
 		    READ_ONCE(spi_imx->target_aborted)) {
 			dev_dbg(spi_imx->dev, "I/O Error in DMA RX interrupted\n");
-			dmaengine_terminate_all(controller->dma_rx);
+			dmaengine_terminate_sync(controller->dma_rx);
 			return -EINTR;
 		}
 
@@ -1818,9 +1818,9 @@ static int spi_imx_dma_submit(struct spi_imx_data *spi_imx,
 	return 0;
 
 dmaengine_terminate_tx:
-	dmaengine_terminate_all(controller->dma_tx);
+	dmaengine_terminate_sync(controller->dma_tx);
 dmaengine_terminate_rx:
-	dmaengine_terminate_all(controller->dma_rx);
+	dmaengine_terminate_sync(controller->dma_rx);
 
 	return -EINVAL;
 }
-- 
2.53.0



