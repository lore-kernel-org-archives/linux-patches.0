Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DBE4D9EA;
	Wed, 19 Jun 2024 13:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803392; cv=none; b=q7qsl3aCa5hC+yvzibJ0IeY+FtnnCSCEdWpQ2Np9h+ivtSESz5SfrQWhrzEzS3ReCTZK+du2nOgT2BeV7z0r7wP+/EGpqkOrlbAJvq1ZR3oB4TexEPZ7NyxedfDa6//qudL4tHy7anBXx6Y7AxiilJ8I5J3n79enr7gIeCTDruM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803392; c=relaxed/simple;
	bh=iGXHVH3BIh156MHy1iEDbeuC5zqiZTxebm7z6zG0bcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBw0HwBBk0Zuq14c0kW+er+Y0GUhKB1Fmym757J4CMxo9RikWF1IAuijNlEaZ+KlM9wtm7cMzRwyY2eAXM8bdHD87dX21Un+SkHtoPMh0Kupz/7GRKjxug1iViPy6NNk9aQelZO2/UNJkKh8mqBV3YwfKDmoQKAlXxKUz+4VyTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lPg8gvFB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lPg8gvFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B882C2BBFC;
	Wed, 19 Jun 2024 13:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803391;
	bh=iGXHVH3BIh156MHy1iEDbeuC5zqiZTxebm7z6zG0bcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lPg8gvFBfqnhMvs5S0SO4Jg1tqDCnwLcdp9jCQGbz6fjxiqEJuvkVNTvvXrNrL1jj
	 eLrS/9G8HnZUEoo7ntdNuvjE1MlBAL3GJZGv/Z0/3j4qb2+zrKXU6ugqqubXbWtuZn
	 973sDbL4BoBtpxnU97n1nXjuPQBUPr3edDmu1fGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Nuno Sa <nuno.sa@analog.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.9 244/281] dmaengine: axi-dmac: fix possible race in remove()
Date: Wed, 19 Jun 2024 14:56:43 +0200
Message-ID: <20240619125619.352198404@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sa <nuno.sa@analog.com>

commit 1bc31444209c8efae98cb78818131950d9a6f4d6 upstream.

We need to first free the IRQ before calling of_dma_controller_free().
Otherwise we could get an interrupt and schedule a tasklet while
removing the DMA controller.

Fixes: 0e3b67b348b8 ("dmaengine: Add support for the Analog Devices AXI-DMAC DMA controller")
Cc: stable@kernel.org
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20240328-axi-dmac-devm-probe-v3-1-523c0176df70@analog.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/dma-axi-dmac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/dma-axi-dmac.c
+++ b/drivers/dma/dma-axi-dmac.c
@@ -1134,8 +1134,8 @@ static void axi_dmac_remove(struct platf
 {
 	struct axi_dmac *dmac = platform_get_drvdata(pdev);
 
-	of_dma_controller_free(pdev->dev.of_node);
 	free_irq(dmac->irq, dmac);
+	of_dma_controller_free(pdev->dev.of_node);
 	tasklet_kill(&dmac->chan.vchan.task);
 	dma_async_device_unregister(&dmac->dma_dev);
 	clk_disable_unprepare(dmac->clk);


