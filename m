Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBDB69D21;
	Wed, 21 Feb 2024 13:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523017; cv=none; b=B0WbT0OKAOiyxotwV0SSbM/MRy48CMGTUxlJVRsZyrZ9P/dbe5P95X4TkCL03JWPQ9vP5Pyx7zm9CFpxkVWpYbWbzxDToIi0tvWNc6ibn4awMSOPww4d0izJ8NEVoFMYLd1H5logA/4qEp9dHpbd+48XfA5UnZoBVnvfgU62zZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523017; c=relaxed/simple;
	bh=Z071QmREvq0miPOF6lYHzf0d8uHvCyKdQan3pRB+064=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgBlJmgjj3382TTjQ/MU/WPJxH/yjDJ4G56McplyaNT/u5cs4AbloR71LrnRpGoaAPehEgjlxuyx20NQNJmdQw7+0REJfOIIkUUbLsBTHaS4l/67aVB5YGRsJb2ZwyoUhRK4lBzdAmIYPV23v/Rxh3tO855wfOyzNykeYLiDjlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VR7iASuS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VR7iASuS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91325C433C7;
	Wed, 21 Feb 2024 13:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523017;
	bh=Z071QmREvq0miPOF6lYHzf0d8uHvCyKdQan3pRB+064=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VR7iASuSRKE9y9FlXQQwmO/LIZcQjTnMcGgJZXa1nGThvUYW93dHnezjx9wtX6SI5
	 pJCdCxIl1gVi/mf4pZD+4sn5XLC0XybNNVXMzZcxlBbSS+wOUPm7ypJrJ2X4eDtDvc
	 A/oNZQwZ1m7Q1qKdW4Uxdq3xSwqIH1dSy2OkYxTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 298/476] dmaengine: fsl-qdma: Fix a memory leak related to the status queue DMA
Date: Wed, 21 Feb 2024 14:05:49 +0100
Message-ID: <20240221130019.021495543@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 045ead46ec8f..5cc887acb05b 100644
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
@@ -1272,8 +1272,6 @@ static void fsl_qdma_cleanup_vchan(struct dma_device *dmadev)
 
 static int fsl_qdma_remove(struct platform_device *pdev)
 {
-	int i;
-	struct fsl_qdma_queue *status;
 	struct device_node *np = pdev->dev.of_node;
 	struct fsl_qdma_engine *fsl_qdma = platform_get_drvdata(pdev);
 
@@ -1282,11 +1280,6 @@ static int fsl_qdma_remove(struct platform_device *pdev)
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



