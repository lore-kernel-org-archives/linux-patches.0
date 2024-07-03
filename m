Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8503817C238;
	Wed,  3 Jul 2024 10:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003953; cv=none; b=dEa3uYc3X0YAp68azQ8S2dZTn2/1tMsa/zIuFbxwoqGC4zGP1ehx74Ledc2mQeZL++Zj7GZk9ZB7pyNnOGd0X/zqgrRHpwGytEe78W2u87KJDtgzorAEj6KliY85k1Lj/cbFoQ7Jbd63HG3lbsoY2rkDJtvrJAEmi18tBsyx8rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003953; c=relaxed/simple;
	bh=bOvs7WkpEC6DI1KWgMyabWOdO8ZAPf2cfLKXLcxoY3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/nc/nrWJQ2Pkv2JwnPD+yqmja60HwvKr9Yy1W2gsRZ3Gq5DisBEK/qrxNH38v8F9Jw1L4eCqO7HH/fN7+XWYJb9wMsTnXHGtBli99qQ5bZjgMVXEQ++h8voaeKmOhvpc8FlXW4O+xYf903bAJRsh8RPn5g06ENT/IOs8Kbib0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k9W4MIaR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9W4MIaR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E980CC2BD10;
	Wed,  3 Jul 2024 10:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003953;
	bh=bOvs7WkpEC6DI1KWgMyabWOdO8ZAPf2cfLKXLcxoY3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k9W4MIaRcj/EAda+SmC+Q5qW7Y2L9cOQQD+Fs2Ys/+bmfpeg2u6SWHc08w9AqfQUl
	 czWkZMM0mxAkMEdG860G64VECnJSxAGGcZ3pB0SVKGHpA04AiKWRzkd1T8XIgr1RRi
	 W/tfl87igD3Mu3g8hsbm5o5HfHy0syUIJCeWDfSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Nuno Sa <nuno.sa@analog.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 075/189] dmaengine: axi-dmac: fix possible race in remove()
Date: Wed,  3 Jul 2024 12:38:56 +0200
Message-ID: <20240703102844.337844200@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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
@@ -947,8 +947,8 @@ static int axi_dmac_remove(struct platfo
 {
 	struct axi_dmac *dmac = platform_get_drvdata(pdev);
 
-	of_dma_controller_free(pdev->dev.of_node);
 	free_irq(dmac->irq, dmac);
+	of_dma_controller_free(pdev->dev.of_node);
 	tasklet_kill(&dmac->chan.vchan.task);
 	dma_async_device_unregister(&dmac->dma_dev);
 	clk_disable_unprepare(dmac->clk);


