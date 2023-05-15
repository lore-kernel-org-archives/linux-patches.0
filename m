Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBD0C8C0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E416EC4339B;
	Mon, 15 May 2023 17:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173586;
	bh=OP2Kuk1wRpqMGQTcrMLGjcoC5npcJ1SdjSuezJZ3qrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u/svDCg9yTsa46p9CCXkGoAPMPtSiVFdgRkEYgnu60zAPzOioLL6EHIjiEZommDDY
	 ge4UrX2p402P9anlDSlETz8W6clKGFmUFeRpB2Fctk3UhuHqxzFmj6/wSPNjqeDMC1
	 N2iCo4NPpJMNGX/jdna+qq1os6b+qhEVEkBKFUeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Tudor Ambarus <tudor.ambarus@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 143/282] mtd: spi-nor: cadence-quadspi: Handle probe deferral while requesting DMA channel
Date: Mon, 15 May 2023 18:28:41 +0200
Message-Id: <20230515161726.508789844@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vignesh Raghavendra <vigneshr@ti.com>

[ Upstream commit 935da5e5100f57d843cac4781b21f1c235059aa0 ]

dma_request_chan_by_mask() can throw EPROBE_DEFER if DMA provider
is not yet probed. Currently driver just falls back to using PIO mode
(which is less efficient) in this case. Instead return probe deferral
error as is so that driver will be re probed once DMA provider is
available.

Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Acked-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20200601070444.16923-6-vigneshr@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 2087e85bb66e ("spi: cadence-quadspi: fix suspend-resume implementations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/cadence-quadspi.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/spi-nor/cadence-quadspi.c b/drivers/mtd/spi-nor/cadence-quadspi.c
index ad27d3e4c5dbc..2c5a6587f505e 100644
--- a/drivers/mtd/spi-nor/cadence-quadspi.c
+++ b/drivers/mtd/spi-nor/cadence-quadspi.c
@@ -1168,7 +1168,7 @@ static void cqspi_controller_init(struct cqspi_st *cqspi)
 	cqspi_controller_enable(cqspi, 1);
 }
 
-static void cqspi_request_mmap_dma(struct cqspi_st *cqspi)
+static int cqspi_request_mmap_dma(struct cqspi_st *cqspi)
 {
 	dma_cap_mask_t mask;
 
@@ -1177,11 +1177,16 @@ static void cqspi_request_mmap_dma(struct cqspi_st *cqspi)
 
 	cqspi->rx_chan = dma_request_chan_by_mask(&mask);
 	if (IS_ERR(cqspi->rx_chan)) {
-		dev_err(&cqspi->pdev->dev, "No Rx DMA available\n");
+		int ret = PTR_ERR(cqspi->rx_chan);
+
+		if (ret != -EPROBE_DEFER)
+			dev_err(&cqspi->pdev->dev, "No Rx DMA available\n");
 		cqspi->rx_chan = NULL;
-		return;
+		return ret;
 	}
 	init_completion(&cqspi->rx_dma_complete);
+
+	return 0;
 }
 
 static int cqspi_setup_flash(struct cqspi_st *cqspi, struct device_node *np)
@@ -1265,8 +1270,11 @@ static int cqspi_setup_flash(struct cqspi_st *cqspi, struct device_node *np)
 			dev_dbg(nor->dev, "using direct mode for %s\n",
 				mtd->name);
 
-			if (!cqspi->rx_chan)
-				cqspi_request_mmap_dma(cqspi);
+			if (!cqspi->rx_chan) {
+				ret = cqspi_request_mmap_dma(cqspi);
+				if (ret == -EPROBE_DEFER)
+					goto err;
+			}
 		}
 	}
 
-- 
2.39.2



