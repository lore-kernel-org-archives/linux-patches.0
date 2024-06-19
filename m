Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3706E12FB31;
	Wed, 19 Jun 2024 13:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802471; cv=none; b=FS5nGQ8V3vM1tnawDrW4bPOxdhQ0bmu9+WEEDk6BhOjJARNkO3Ll76z59AWoC5mPeAlpKNnsLFlRWRXq7GldatNPmk9K9/Autap2vi7GSLviDFZ1Vh91YgYoZzIH1eGh/lmOoF0AJ8Z6vg1mKh8xevU+3PbOwqaWGquBDV4fs9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802471; c=relaxed/simple;
	bh=QPOuNP69UBxOB65WskyeDtl/P6wP14W5Y/vG5kcuyBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzEiZbcbsYCjW32Fq+1qnYjU9Zuayt0vm5vJXb6rB+pPEstYazYQTngFtL1rmXnV1mFv9SSkxia+2cwA0KUqNTHUfrhoNEdM6vgCzcJnCBc4nimGXJj3KW0zmpIQD1TGnURj3KWb07/K2QN3LhNNbJ6HpBMoYO39MuJ1h9c5O38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UWuiiQbz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UWuiiQbz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703EEC2BBFC;
	Wed, 19 Jun 2024 13:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802470;
	bh=QPOuNP69UBxOB65WskyeDtl/P6wP14W5Y/vG5kcuyBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UWuiiQbzC1uNnbTlo3pMJcMk2rlkwG08UoV5Sg3EZsJYJYdzqWU34gKS3uJwICIQm
	 9erbEwDS7LoA2WhXWlNtAxyYaDJT7GpgsG7HhsUUy5NC/S0biACVDNdVmZQl2cDqTk
	 6/gTcoHEmLDreXZHMDQYTIalF/sMk6mQpum4iwVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Nuno Sa <nuno.sa@analog.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 207/267] dmaengine: axi-dmac: fix possible race in remove()
Date: Wed, 19 Jun 2024 14:55:58 +0200
Message-ID: <20240619125614.274053275@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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
@@ -1033,8 +1033,8 @@ static int axi_dmac_remove(struct platfo
 {
 	struct axi_dmac *dmac = platform_get_drvdata(pdev);
 
-	of_dma_controller_free(pdev->dev.of_node);
 	free_irq(dmac->irq, dmac);
+	of_dma_controller_free(pdev->dev.of_node);
 	tasklet_kill(&dmac->chan.vchan.task);
 	dma_async_device_unregister(&dmac->dma_dev);
 	clk_disable_unprepare(dmac->clk);


