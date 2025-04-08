Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3131D267F4F;
	Tue,  8 Apr 2025 11:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111596; cv=none; b=JJxYpQwKPugU1oyBoJfWYe2BqD2XTLFhSm0nfznNeSD62oMCbllbhKoFkLZyvKBDOm3WtnZ9F0Bm+xlDlR2HhFH+g6Y9gPyIuJa0oSyFxibLWBmWlNqpvJUQY7zgfefIx0u3mMWep82WuGvqUJPyRsFiKHXBTtnXYvi1+iqbamg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111596; c=relaxed/simple;
	bh=fzAktsOQmi8kPpna5iqg+wIQOh56RUevtjZxyNbzj5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+rBWJFZsA0qD3Z9NWtvWuClHEP7h/JdCaBegba5RzMAxztK2Z3dq4K13SZGJWsijyfOezL3yJDfnUrTphr3m0n7sBxszlxBzlH0U6kKQm5aEmvRFj1lXKPV10C+EqlONq0GYC9IelHVak7wPQPWzc1OxWsVBFNfaN/hSA8pjqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a04o82kf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a04o82kf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B782AC4CEE5;
	Tue,  8 Apr 2025 11:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111596;
	bh=fzAktsOQmi8kPpna5iqg+wIQOh56RUevtjZxyNbzj5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a04o82kfcY70Nn9zbyoMtPStGj2AUWXcQTWabAapkhwdkCACArjA2SCQKkv3AaA0G
	 Ep1bSfWjpqFYVBmIkk0CxKOFxSLB2052ar91nED/sB4dMmqv+GWxMLTPM12Me1sWr8
	 bDAaQaivQfWBE3Zp9zH1fBFAhG0AxZo2F0jBMNAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 488/731] dmaengine: fsl-edma: free irq correctly in remove path
Date: Tue,  8 Apr 2025 12:46:25 +0200
Message-ID: <20250408104925.628218863@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit fa70c4c3c580c239a0f9e83a14770ab026e8d820 ]

Add fsl_edma->txirq/errirq check to avoid below warning because no
errirq at i.MX9 platform. Otherwise there will be kernel dump:
WARNING: CPU: 0 PID: 11 at kernel/irq/devres.c:144 devm_free_irq+0x74/0x80
Modules linked in:
CPU: 0 UID: 0 PID: 11 Comm: kworker/u8:0 Not tainted 6.12.0-rc7#18
Hardware name: NXP i.MX93 11X11 EVK board (DT)
Workqueue: events_unbound deferred_probe_work_func
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : devm_free_irq+0x74/0x80
lr : devm_free_irq+0x48/0x80
Call trace:
 devm_free_irq+0x74/0x80 (P)
 devm_free_irq+0x48/0x80 (L)
 fsl_edma_remove+0xc4/0xc8
 platform_remove+0x28/0x44
 device_remove+0x4c/0x80

Fixes: 44eb827264de ("dmaengine: fsl-edma: request per-channel IRQ only when channel is allocated")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/20250228071720.3780479-2-peng.fan@oss.nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl-edma-main.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/fsl-edma-main.c b/drivers/dma/fsl-edma-main.c
index 133bdb48d1a5c..e3e0e88a76d3c 100644
--- a/drivers/dma/fsl-edma-main.c
+++ b/drivers/dma/fsl-edma-main.c
@@ -401,6 +401,7 @@ fsl_edma2_irq_init(struct platform_device *pdev,
 
 		/* The last IRQ is for eDMA err */
 		if (i == count - 1) {
+			fsl_edma->errirq = irq;
 			ret = devm_request_irq(&pdev->dev, irq,
 						fsl_edma_err_handler,
 						0, "eDMA2-ERR", fsl_edma);
@@ -420,10 +421,13 @@ static void fsl_edma_irq_exit(
 		struct platform_device *pdev, struct fsl_edma_engine *fsl_edma)
 {
 	if (fsl_edma->txirq == fsl_edma->errirq) {
-		devm_free_irq(&pdev->dev, fsl_edma->txirq, fsl_edma);
+		if (fsl_edma->txirq >= 0)
+			devm_free_irq(&pdev->dev, fsl_edma->txirq, fsl_edma);
 	} else {
-		devm_free_irq(&pdev->dev, fsl_edma->txirq, fsl_edma);
-		devm_free_irq(&pdev->dev, fsl_edma->errirq, fsl_edma);
+		if (fsl_edma->txirq >= 0)
+			devm_free_irq(&pdev->dev, fsl_edma->txirq, fsl_edma);
+		if (fsl_edma->errirq >= 0)
+			devm_free_irq(&pdev->dev, fsl_edma->errirq, fsl_edma);
 	}
 }
 
@@ -620,6 +624,8 @@ static int fsl_edma_probe(struct platform_device *pdev)
 	if (!fsl_edma)
 		return -ENOMEM;
 
+	fsl_edma->errirq = -EINVAL;
+	fsl_edma->txirq = -EINVAL;
 	fsl_edma->drvdata = drvdata;
 	fsl_edma->n_chans = chans;
 	mutex_init(&fsl_edma->fsl_edma_mutex);
-- 
2.39.5



