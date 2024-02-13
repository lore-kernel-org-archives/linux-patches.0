Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9F95F54E;
	Tue, 13 Feb 2024 17:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845208; cv=none; b=lB/K2KmTLy/S2wY29MU7F4Y3R5Dr3hlfkZ0MVNBkJAQ8F7EnVcy05kove+29VS1ShBSZ8c1fOWK50vdFBoxiWf7Te8Szx3zH2YD9TBb1xBmwtrHtQ2hSUjA5NkKt6jGEt/VAf6geEHbxXNw2nBJ0q73nnS7n+P61Hm/bqms+Q5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845208; c=relaxed/simple;
	bh=GJIiGiIZcFODCKMHFGcVvfKwf5TQnGw36csl/jIScBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SzKbiQC8LXvSbRspdw6znDKv8ilNPG8boZhx5feFXzTp/T32lYNo5yxXd8upnNp3T6Hh480wKLjOBya7pMMG2cnUqYXQ23e56+piop12BnNvtyIXFG7fOT9KbvzyCiTEA9hgl5rMv0jxETXpXgsobotA/Jeky+5NDOdps+32z9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SPAanaqD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SPAanaqD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC28C433F1;
	Tue, 13 Feb 2024 17:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845208;
	bh=GJIiGiIZcFODCKMHFGcVvfKwf5TQnGw36csl/jIScBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SPAanaqDg7kq50AwOFBs8MobjTet3ndGgPreaSXf+8Fd6qsdFcO8BAfQQPYHVNdUi
	 dqR4+w4+8uQ2nJS9XVPpZGQJg+xQn9/ySgKu7RFLqVqVjq4RukMzwMOMmgbJpEASjQ
	 6D7QUAhbKMWYvpMLdtsRLFKN0li4vDc5PxAT4hDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/121] dmaengine: fsl-qdma: Fix a memory leak related to the queue command DMA
Date: Tue, 13 Feb 2024 18:20:14 +0100
Message-ID: <20240213171853.112928857@linuxfoundation.org>
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

[ Upstream commit 3aa58cb51318e329d203857f7a191678e60bb714 ]

This dma_alloc_coherent() is undone neither in the remove function, nor in
the error handling path of fsl_qdma_probe().

Switch to the managed version to fix both issues.

Fixes: b092529e0aa0 ("dmaengine: fsl-qdma: Add qDMA controller driver for Layerscape SoCs")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/7f66aa14f59d32b13672dde28602b47deb294e1f.1704621515.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl-qdma.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/fsl-qdma.c b/drivers/dma/fsl-qdma.c
index e4606ab27745..e4c293b76e05 100644
--- a/drivers/dma/fsl-qdma.c
+++ b/drivers/dma/fsl-qdma.c
@@ -514,11 +514,11 @@ static struct fsl_qdma_queue
 			queue_temp = queue_head + i + (j * queue_num);
 
 			queue_temp->cq =
-			dma_alloc_coherent(&pdev->dev,
-					   sizeof(struct fsl_qdma_format) *
-					   queue_size[i],
-					   &queue_temp->bus_addr,
-					   GFP_KERNEL);
+			dmam_alloc_coherent(&pdev->dev,
+					    sizeof(struct fsl_qdma_format) *
+					    queue_size[i],
+					    &queue_temp->bus_addr,
+					    GFP_KERNEL);
 			if (!queue_temp->cq)
 				return NULL;
 			queue_temp->block_base = fsl_qdma->block_base +
-- 
2.43.0



