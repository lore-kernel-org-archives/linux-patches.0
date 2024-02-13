Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E546025E;
	Tue, 13 Feb 2024 17:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845205; cv=none; b=avEFG9opC3pTZhbonGJ1wapQQBrJLbAASHWrjOomKe0RsYVY8kO7mBHAcba8geQwdx9Y+a75LoJh3ma4nR1MXv2vXiOwIm8PtAB/PmWT6ENzGi9IO5hlbM8SY7pfd49spLg7Jpf8ZrPCMGj7JfC6/Eey6yZv/dE0bZesAAr/NzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845205; c=relaxed/simple;
	bh=FlkhS8+dVeOVRFz+YODIsTYFeIf9ZwVldd/Y+azhhow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BmQC3NIpTToyneWMuiNhwXtfyImZwuyYc+lDilWHxuM1ti1Z0lsdZxRXuspX521pacQRLlr2qqjJJyE9s6WK1FMFrIhXR6/3dDrj+372yC6V+CP6DWWr/iDf0/1HlG56VvtCLyQP7HjOiwxNO2ChZJRSAo4BKnmoR9FT1r3zk3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yLB9q8tD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yLB9q8tD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15C4C433C7;
	Tue, 13 Feb 2024 17:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845205;
	bh=FlkhS8+dVeOVRFz+YODIsTYFeIf9ZwVldd/Y+azhhow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yLB9q8tDAkFO6micOR5v40CEZcdx88XiUILlDm7gN0Ra+B+9TiVY1ZNB6iiquOu5X
	 fDN9FoR5cOmXPO2M0/T7BblO0shEZ6jJuztRM4tZkUmf8CzmaYc+z4ME9KTOK52AJz
	 xEzWSvQypzNSPdx5NWVZCtybpFT8KzBhUc7W4T7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/121] dmaengine: fsl-qdma: Fix a memory leak related to the status queue DMA
Date: Tue, 13 Feb 2024 18:20:13 +0100
Message-ID: <20240213171853.082724604@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/dma/fsl-qdma.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/dma/fsl-qdma.c b/drivers/dma/fsl-qdma.c
index a8cc8a4bc610..e4606ab27745 100644
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
 
 static int fsl_qdma_remove(struct platform_device *pdev)
 {
-	int i;
-	struct fsl_qdma_queue *status;
 	struct device_node *np = pdev->dev.of_node;
 	struct fsl_qdma_engine *fsl_qdma = platform_get_drvdata(pdev);
 
@@ -1278,11 +1276,6 @@ static int fsl_qdma_remove(struct platform_device *pdev)
 	of_dma_controller_free(np);
 	dma_async_device_unregister(&fsl_qdma->dma_dev);
 
-	for (i = 0; i < fsl_qdma->block_number; i++) {
-		status = fsl_qdma->status[i];
-		dma_free_coherent(&pdev->dev, sizeof(struct fsl_qdma_format) *
-				status->n_cq, status->cq, status->bus_addr);
-	}
 	return 0;
 }
 
-- 
2.43.0



