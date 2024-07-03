Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3AF181B9E;
	Wed,  3 Jul 2024 10:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003447; cv=none; b=q4hJelv471YSa2rTUyU/c5Abjgx/3zgnSQCZjOZWyElHotIrDLjOGtTIWR8nHbwYXVfxeGfOJm0E2Cwv0rjJ3qNBCd9IPM5c9PmMiPWYMg9fyjih2pYhhAy1js5mfclnmpuICtJ2WRXqj5s2JRcQo8V2srsRBNmlBzPGUAXmw5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003447; c=relaxed/simple;
	bh=062y4SZy3Nprywq0A4VkYOG15mUbno+sUjWpK9U1Wxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DkweiC+10okjjloDAzkHmda4JKdSTAHAVPJqQNVYoAJIsLjtHP+sGmd7PSK/EDTHjWwckBjMi3iByAPfjSVN6aWgX4ABHqRF2DfiRxQlySFBly8z52oBXEJXYNbOkdILeDQx8ZcCPPcShznN1O/50SOFp24rEnQ0j+AT2yJ0zkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cwdY6ELw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cwdY6ELw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F41C2BD10;
	Wed,  3 Jul 2024 10:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003447;
	bh=062y4SZy3Nprywq0A4VkYOG15mUbno+sUjWpK9U1Wxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cwdY6ELwp7UHT21LOceb/lYTn4hUDtXv8RubAm9zprkVSMYy6SkpWTjQKDVAiGV+e
	 K3OYfPwiLg1lS6bphKyf4HkD2HyZWOxc4oZTqwfKpsL4R7PfO3rJIcz4lqTaGLU0RR
	 36lj1YvOl17YEL0BRC86qAml+I7W//cJEIzABfDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Nuno Sa <nuno.sa@analog.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.19 051/139] dmaengine: axi-dmac: fix possible race in remove()
Date: Wed,  3 Jul 2024 12:39:08 +0200
Message-ID: <20240703102832.364466972@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -710,8 +710,8 @@ static int axi_dmac_remove(struct platfo
 {
 	struct axi_dmac *dmac = platform_get_drvdata(pdev);
 
-	of_dma_controller_free(pdev->dev.of_node);
 	free_irq(dmac->irq, dmac);
+	of_dma_controller_free(pdev->dev.of_node);
 	tasklet_kill(&dmac->chan.vchan.task);
 	dma_async_device_unregister(&dmac->dma_dev);
 	clk_disable_unprepare(dmac->clk);


