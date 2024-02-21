Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5152476037;
	Wed, 21 Feb 2024 14:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525507; cv=none; b=ZYd0SHbGbDc6IT3hD/ofVdenVWwPNqX3qFClJYgdXoSG8uGCO5AuUDu9XfOS7xgNBUvfNbWDbjd589cA9vYcErUD9yrOdK0dtSF3vUF5Kb2XLM4+JSAkXoetIyJhfowfNRBTaKUlAflvaMWaDHHYcOzXfkCk+OSFWhQgokuPvzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525507; c=relaxed/simple;
	bh=cN1BcZWV0j+XRdybkcDTamlaGLgd3nWZust13dAYLMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MktFTBnfJ+yS5UTUGqNInpNloRvbT6zGV7m2PmGkjsdlIfL08hunWEgWIvZGya+R/1TJ7QJLN+o4KDdR434A+a22zQIEQQIVZdA0LBuOIKBFyo2TxKmsoE0NY+DumDPy/04fAbWe0w7LUH7pxknb4B+F2AnA8BD6LpJP05azYpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KoVKOY3+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KoVKOY3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B168DC433F1;
	Wed, 21 Feb 2024 14:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525507;
	bh=cN1BcZWV0j+XRdybkcDTamlaGLgd3nWZust13dAYLMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KoVKOY3+U0Aa8Zc0FSZlIqoDV8LoLXHcHHKaVOllhA9qWnkP82bPkw+tJF6AXdbpi
	 85MLbkfQBEly55HPdNN1vlqWBoaPjDPLgAZXpsYR7ILikSIEtjf885OgIYArfXDw6t
	 EWpnEvUXv0Bvt4yUNXwE4OAcjHtpGZAnadB6Gb3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 177/267] dmaengine: fsl-qdma: Fix a memory leak related to the queue command DMA
Date: Wed, 21 Feb 2024 14:08:38 +0100
Message-ID: <20240221125945.693945632@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index e3d07013ae8d..ad5818c0ce22 100644
--- a/drivers/dma/fsl-qdma.c
+++ b/drivers/dma/fsl-qdma.c
@@ -502,11 +502,11 @@ static struct fsl_qdma_queue
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



