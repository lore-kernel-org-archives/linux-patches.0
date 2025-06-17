Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE01A2F2345;
	Tue, 17 Jun 2025 16:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176121; cv=none; b=rIIcCbHtxo5MM9EMixg+cGALkIuLYrhjRvuy9P8qvcLqhvvUMi1LNwqhCEPsrqOkCrb7ohhxBNqbVpVK983kUFfeZUTvk8jyGIrcv47JSCmog4v4Gk5zTggiAfAK7UJEN30ujIw2qoHeF/u3rkPKDrJ4bDq1R97Ho4LbGEjw+Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176121; c=relaxed/simple;
	bh=VSR8hmKOB2FbtrA2zKt9pXG9dvoB1IIoBXdl/1ODi4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8bQ1B9BwsbOZZsTy92hRyMJMRLEXKAp/udWcUqvfn+YCbXMEJzejKJ9NFOGlmum/rGP97tXrhLTQSEM+h+8ddmChgPh0sqgiJiPLaeot7rlwBdiIj9nGlQ2FoX2A6W5KnGwYsAzN5zDsN/txOMq6jZvYun0s7Ij0jbcONgv844=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k8bQbQDI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k8bQbQDI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC99C4CEE3;
	Tue, 17 Jun 2025 16:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176121;
	bh=VSR8hmKOB2FbtrA2zKt9pXG9dvoB1IIoBXdl/1ODi4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k8bQbQDIbJvDlI007MZCMvBspyHGegTq0Nf7GaTlyArxPey2/soLKxvIfZ44RjwM7
	 O4nz265eWp+XHSEkV6pLQME7JefF2FjhUEcGUTkLOk0PC/qiiacTE+9TlLJ2nQcCtT
	 JOqmDaQPsHCTaGkoFIa8XH9y1J0pP25Jj6SMOg7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Nathan Lynch <nathan.lynch@amd.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 227/356] dmaengine: ti: Add NULL check in udma_probe()
Date: Tue, 17 Jun 2025 17:25:42 +0200
Message-ID: <20250617152347.337675771@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit fd447415e74bccd7362f760d4ea727f8e1ebfe91 ]

devm_kasprintf() returns NULL when memory allocation fails. Currently,
udma_probe() does not check for this case, which results in a NULL
pointer dereference.

Add NULL check after devm_kasprintf() to prevent this issue.

Fixes: 25dcb5dd7b7c ("dmaengine: ti: New driver for K3 UDMA")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Reviewed-by: Nathan Lynch <nathan.lynch@amd.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Link: https://lore.kernel.org/r/20250402023900.43440-1-bsdhenrymartin@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/k3-udma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/ti/k3-udma.c b/drivers/dma/ti/k3-udma.c
index 418e1774af1e5..d99cf81358c54 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -5537,7 +5537,8 @@ static int udma_probe(struct platform_device *pdev)
 		uc->config.dir = DMA_MEM_TO_MEM;
 		uc->name = devm_kasprintf(dev, GFP_KERNEL, "%s chan%d",
 					  dev_name(dev), i);
-
+		if (!uc->name)
+			return -ENOMEM;
 		vchan_init(&uc->vc, &ud->ddev);
 		/* Use custom vchan completion handling */
 		tasklet_setup(&uc->vc.task, udma_vchan_complete);
-- 
2.39.5



