Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E203C1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:13:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DA9C433D6;
	Wed, 23 Nov 2022 09:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194815;
	bh=fL4KDHoEdGH+vAbUrfguMJ/tMLrrnzKmWtFyoAcrO58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gSwYgs5FkPC6pCT85CFszN8LJnaHNWi5jLtLUW8YBk8wO+XJacdRjQALfzz7LEdCP
	 NCd51R/hs/V2DvSQX5GCO2XmZut9Z7opWb9sSqC64VskZzfhAvGGaarHzaOShe4X4T
	 EIRWhhgxb6DDswxNkEKuvtBLD/GP/qbPKLqvOIrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@microchip.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 061/156] dmaengine: at_hdmac: Check return code of dma_async_device_register
Date: Wed, 23 Nov 2022 09:50:18 +0100
Message-Id: <20221123084600.165545700@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tudor Ambarus <tudor.ambarus@microchip.com>

commit c47e6403fa099f200868d6b106701cb42d181d2b upstream.

dma_async_device_register() can fail, check the return code and display an
error.

Fixes: dc78baa2b90b ("dmaengine: at_hdmac: new driver for the Atmel AHB DMA Controller")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20221025090306.297886-1-tudor.ambarus@microchip.com
Link: https://lore.kernel.org/r/20221025090306.297886-16-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_hdmac.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1948,7 +1948,11 @@ static int __init at_dma_probe(struct pl
 	  dma_has_cap(DMA_SLAVE, atdma->dma_common.cap_mask)  ? "slave " : "",
 	  plat_dat->nr_channels);
 
-	dma_async_device_register(&atdma->dma_common);
+	err = dma_async_device_register(&atdma->dma_common);
+	if (err) {
+		dev_err(&pdev->dev, "Unable to register: %d.\n", err);
+		goto err_dma_async_device_register;
+	}
 
 	/*
 	 * Do not return an error if the dmac node is not present in order to
@@ -1968,6 +1972,7 @@ static int __init at_dma_probe(struct pl
 
 err_of_dma_controller_register:
 	dma_async_device_unregister(&atdma->dma_common);
+err_dma_async_device_register:
 	dma_pool_destroy(atdma->memset_pool);
 err_memset_pool_create:
 	dma_pool_destroy(atdma->dma_desc_pool);


