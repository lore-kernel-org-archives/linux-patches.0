Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587FC78B4B;
	Wed, 21 Feb 2024 14:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524511; cv=none; b=P7nsR71RUgDYOcxvwjTsTigFRK5YD+DuAZawEea3qHOE8vczN1ixHyBxiOLv03TY92xvRqm2hSuT1xDKMyZDinmD35DYI7gzhRV7+s/IObsX0LjYiMbleh0+As9D2d3Oy48d6p0aCO0j29O+UM2GvTb4xFOzfgf5nPjBvTUeRV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524511; c=relaxed/simple;
	bh=z1pl1m/RHZxMaFKCcA2kEyoiTgXI30agEZraT6xG6kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QPCdvNFAAW0+F8oopGBT1W7UM7vhtEEIOUgsnJKEU7UdGD/Qd/viJ2TcPgn4d8to5wmFEsNaXFvHjLertEg/tBA/PP2a5XLCQEfenBXjco3Qb5LlQmOPNSCRY98ABNQQ8JRx9FPR15+EioV28ezrHHoJU7c+9Yz3YNF60zb1tkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RrerSy8o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RrerSy8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55E9C433F1;
	Wed, 21 Feb 2024 14:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524510;
	bh=z1pl1m/RHZxMaFKCcA2kEyoiTgXI30agEZraT6xG6kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RrerSy8oRxbzOPbLzv/HLwKDtzhvNjuacttgwCA7S+jNfTUWTlUUlvxmDbPgky4f6
	 ytrjdMe3Y8fKY0xT7XbQa19O8SMSULVG7eDhVNR0zPq9qdJc1QmZijZ7R2MJADA8NK
	 m3A1Q/9mJgQKEHPG73SFYy9aBb4P4N1XbJMm7M9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 249/379] dmaengine: fsl-qdma: Fix a memory leak related to the queue command DMA
Date: Wed, 21 Feb 2024 14:07:08 +0100
Message-ID: <20240221130002.274947676@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5cc887acb05b..69385f32e275 100644
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



