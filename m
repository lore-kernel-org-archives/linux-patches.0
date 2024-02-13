Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2A35FB94;
	Tue, 13 Feb 2024 17:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845660; cv=none; b=oVxkHN2cWyYKMTdxlSlAPi1bhA8CScQU8dqe/tD3TM+a/drJy9zchZQnRByNkAnriCZt6McW0F5Oz+5xXDj2DKrnSX4Vu5h13iOMW0EczCzpBXLLzBiPTNEV9tGcOdemK5FR+OWxYymAASCm6cci80H8zAn/iXt7uwK0LArwja8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845660; c=relaxed/simple;
	bh=cKPS5WXbtisoaurWvntlclN30EbkHrp3/y06cw+7wfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XaUmhnQN92eKUtca1U4xI7B+ZCvXHzNXKah/zYNViVCiY8dJI00wujeq03F7twrpyS9bRt7ofuvmXRfBbcHsrgUTtVqJ/Z3aC4u6IbhbEdXoh/XJVJKNF7L9L2JB//h1TiSNaj1Yyaqjc+1uxMx7QVvQhNVMLC93QTabkEL0xYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PXM+vdVd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PXM+vdVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30003C433F1;
	Tue, 13 Feb 2024 17:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845660;
	bh=cKPS5WXbtisoaurWvntlclN30EbkHrp3/y06cw+7wfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PXM+vdVdUANqFjX4zlhGOBGtpTWO0UKvIlF+XTc59yXK1SNbqYl38adLcDNXsH2XB
	 +sbC6PdGfeccpVH710WnfEEh4r71/FqtTXWWDqbaphzgMmwCW/2tYB+ZGuD0WJzgG6
	 xVzHMLoIzGvPe8qXt2rlfAtiKIbNyRcgkjy5XZeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 004/124] dmaengine: fsl-qdma: Fix a memory leak related to the status queue DMA
Date: Tue, 13 Feb 2024 18:20:26 +0100
Message-ID: <20240213171853.856786154@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 968bc1d7203d384e72afe34124a1801b7af76514 ]

This dma_alloc_coherent() is undone in the remove function, but not in the
error handling path of fsl_qdma_probe().

Switch to the managed version to fix the issue in the probe and simplify
the remove function.

Fixes: b092529e0aa0 ("dmaengine: fsl-qdma: Add qDMA controller driver for Layerscape SoCs")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/a0ef5d0f5a47381617ef339df776ddc68ce48173.1704621515.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl-qdma.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/dma/fsl-qdma.c b/drivers/dma/fsl-qdma.c
index 47cb28468049..38409e06040a 100644
--- a/drivers/dma/fsl-qdma.c
+++ b/drivers/dma/fsl-qdma.c
@@ -563,11 +563,11 @@ static struct fsl_qdma_queue
 	/*
 	 * Buffer for queue command
 	 */
-	status_head->cq = dma_alloc_coherent(&pdev->dev,
-					     sizeof(struct fsl_qdma_format) *
-					     status_size,
-					     &status_head->bus_addr,
-					     GFP_KERNEL);
+	status_head->cq = dmam_alloc_coherent(&pdev->dev,
+					      sizeof(struct fsl_qdma_format) *
+					      status_size,
+					      &status_head->bus_addr,
+					      GFP_KERNEL);
 	if (!status_head->cq) {
 		devm_kfree(&pdev->dev, status_head);
 		return NULL;
@@ -1268,8 +1268,6 @@ static void fsl_qdma_cleanup_vchan(struct dma_device *dmadev)
 
 static void fsl_qdma_remove(struct platform_device *pdev)
 {
-	int i;
-	struct fsl_qdma_queue *status;
 	struct device_node *np = pdev->dev.of_node;
 	struct fsl_qdma_engine *fsl_qdma = platform_get_drvdata(pdev);
 
@@ -1277,12 +1275,6 @@ static void fsl_qdma_remove(struct platform_device *pdev)
 	fsl_qdma_cleanup_vchan(&fsl_qdma->dma_dev);
 	of_dma_controller_free(np);
 	dma_async_device_unregister(&fsl_qdma->dma_dev);
-
-	for (i = 0; i < fsl_qdma->block_number; i++) {
-		status = fsl_qdma->status[i];
-		dma_free_coherent(&pdev->dev, sizeof(struct fsl_qdma_format) *
-				status->n_cq, status->cq, status->bus_addr);
-	}
 }
 
 static const struct of_device_id fsl_qdma_dt_ids[] = {
-- 
2.43.0



