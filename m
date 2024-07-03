Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBB4178CFA;
	Wed,  3 Jul 2024 11:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004572; cv=none; b=UJDsR7tyWJvyjcBDrUcwG+HM+knYsMuZvObHwl441UwQII9cvglFL7F9SVI3V0UMlWaFVZXasUrK6z3gjlL+vfirzOjCFo47EQ9MSCC6Uqkyk88yfUHtidYIBGoANLOBMV3Ga+k6J7T041CPbQR8hKM8mlKOGaRLKJ9HTksWHgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004572; c=relaxed/simple;
	bh=cwX9FXjtTpNlOgvtE0rIV7HmR2PIRMSgwlxAr3ih3Cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z52LW+86INP19dt1nuKUyKx/WRlgr92G0lQdDSaLJ/DsLzJFAZgdtIDsFg2jeNSLCXSUvxwVt5KX9EOcRC4RCE9AJ3sBSHGdYIQuZVnRefkle88660zQS1ki/wybZDPGUd6FdLIrxC/1efeIR8BP4VKkTI+eCqRlkYLhHgbJEec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=COKBGojV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="COKBGojV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C5BC4AF0B;
	Wed,  3 Jul 2024 11:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004572;
	bh=cwX9FXjtTpNlOgvtE0rIV7HmR2PIRMSgwlxAr3ih3Cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=COKBGojVkZJ+sbqlL90OWWC1Cy8Zx73p9aTUBb7JA11ysXAp/eRQlcBuvUBFa90Df
	 xhYPMWRBdlldA14rMQ9Gwtz5ldgSkWYQ11eICKLkFVGi9JuDKjk0UJH20YhGkwN1bL
	 Lk9oSOG3a7YJClaf9E4faXGtHglRnKRmDiW4TFhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Nuno Sa <nuno.sa@analog.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 085/290] dmaengine: axi-dmac: fix possible race in remove()
Date: Wed,  3 Jul 2024 12:37:46 +0200
Message-ID: <20240703102907.405338379@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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
@@ -1020,8 +1020,8 @@ static int axi_dmac_remove(struct platfo
 {
 	struct axi_dmac *dmac = platform_get_drvdata(pdev);
 
-	of_dma_controller_free(pdev->dev.of_node);
 	free_irq(dmac->irq, dmac);
+	of_dma_controller_free(pdev->dev.of_node);
 	tasklet_kill(&dmac->chan.vchan.task);
 	dma_async_device_unregister(&dmac->dma_dev);
 	clk_disable_unprepare(dmac->clk);


