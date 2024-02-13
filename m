Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A745FB94;
	Tue, 13 Feb 2024 17:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845664; cv=none; b=hmp6tdgmb1jQpBWWxMORgpaK/rm6Xry3ol196tBB9vx2hGdXsSlsePr7v21C1bV3iFoVVf3gCKqEIEYrCHZ6Gu12J+o+uX7/80t9OFV8FqXf5+hQb2bEA9r18mJUNKjy0zHLCdEnGkYWkeGfST5roprLUL16UwVb3ldyLLYTkeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845664; c=relaxed/simple;
	bh=aghmLEnVEYI9/B5V3oQG13YBFuk80sYEYjTyAq/ZGyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDrBgvmB3K8J1SQtue9KEjITkfc6QGE5QyivsQeE+Jv2X6FCtqJ6Xi+FcGnUZnhoolnIlVgt42zkhhvaQC3ADJzT9OlgSCFe9nhSzUKqUpn0pwVzXs9WRhJ7vDLq/DS6YvavaIhVaD1cckHmWvDhgIrBbwLRHXbMWgghC6U/Gks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nNoV8q0C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nNoV8q0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05E5C433F1;
	Tue, 13 Feb 2024 17:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845664;
	bh=aghmLEnVEYI9/B5V3oQG13YBFuk80sYEYjTyAq/ZGyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nNoV8q0CqrkBCX+32w2J4jYT9x9x5uAe6RiNDywMAQ9ojLLnCCS4zCVnemnFetmZ2
	 ztmSKstHzAoZsgmMYUw7Y6D3vGM9n3vXI3UwU7VsTxW7lGMj1yJ5vczeZv6+GErSiX
	 rN8bYIXonMP22j1R+OvoDNzBJceXpFq20T6aDlcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 005/124] dmaengine: fsl-qdma: Fix a memory leak related to the queue command DMA
Date: Tue, 13 Feb 2024 18:20:27 +0100
Message-ID: <20240213171853.885608233@linuxfoundation.org>
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
index 38409e06040a..3a5595a1d442 100644
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



