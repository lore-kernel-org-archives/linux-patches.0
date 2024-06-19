Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E1113F428;
	Wed, 19 Jun 2024 13:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804021; cv=none; b=BKFiuj2zh1fjk1LY70wb3iKFcLDL+r3T6QeDDSvK7K+GtiF/fj6Xfg3bVVFYVoOrPS80CsK/bzwOXabYP3tlYWCH8lNqftNuGvAl0IYJIM0Fmiw7WrqJ67faPvCI6q5VnQCAtMMH3SJEbBA7DnaQgXJMUPIC/4QEl/9HOZmOtWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804021; c=relaxed/simple;
	bh=3GQ0yY1Qwx6JsM04lAJ3xYUPYbjGYMpk2/QW4Y5fHlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qYhnJ5geLNAf4UFw2Y22cw0Vk2lF6M6hy3G0H0q7a0xZcZ0Ql3CVakN7JGGD8N4RMx+d44wWN7QUCz093CAC64S/a72w16lyR98rEOjD2VKmx60FR+L8bJ97NezRbyWwJQBatYwXYB2poYNaag3TD1ME3UPo3/CB4Psbv0DwlAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NhPSfVvF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NhPSfVvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23A4C2BBFC;
	Wed, 19 Jun 2024 13:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718804021;
	bh=3GQ0yY1Qwx6JsM04lAJ3xYUPYbjGYMpk2/QW4Y5fHlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NhPSfVvFCpfrKx84Y3zull3LmpeF633T+9rxfBX+gu9yMjWAIBIM/lQxMXCUx4Ihm
	 SzKFS+OV5yRKsz5k5JKLE9pDZFm9szswC3BK5Xrs/+6ebLR9otr1bacJvBFpyzpD58
	 p+ij4MsDtFXUky3y7n3s0wi0Jk+kUZPJet+ZZvi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Nuno Sa <nuno.sa@analog.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 183/217] dmaengine: axi-dmac: fix possible race in remove()
Date: Wed, 19 Jun 2024 14:57:06 +0200
Message-ID: <20240619125603.747840652@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1036,8 +1036,8 @@ static int axi_dmac_remove(struct platfo
 {
 	struct axi_dmac *dmac = platform_get_drvdata(pdev);
 
-	of_dma_controller_free(pdev->dev.of_node);
 	free_irq(dmac->irq, dmac);
+	of_dma_controller_free(pdev->dev.of_node);
 	tasklet_kill(&dmac->chan.vchan.task);
 	dma_async_device_unregister(&dmac->dma_dev);
 	clk_disable_unprepare(dmac->clk);


