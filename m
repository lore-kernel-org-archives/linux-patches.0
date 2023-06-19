Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8975381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8692FC433C0;
	Mon, 19 Jun 2023 10:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171611;
	bh=clj61MxufCeo8r3bfqXpiJTcJgIQC86Je0XgB64GOyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XJdrHcwcD3ulGJ9HWnf72Euag+tTLJ97kNooELO7cHlVNo+PCtmoQCVqQllbSZys2
	 TaxoRx1RYYIXmdeIH3i6Y/AFxoW6txe8YD6R62cHz5yVeUhI9SUpNCUc1iRGDQ/raV
	 hl7E2om9UGy0tmDIdNIBs6EBT+ETRvHsdRz4VFn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/166] spi: cadence-quadspi: Add missing check for dma_set_mask
Date: Mon, 19 Jun 2023 12:29:31 +0200
Message-ID: <20230619102159.358854047@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 947c70a213769f60e9d5aca2bc88b50a1cfaf5a6 ]

Add check for dma_set_mask() and return the error if it fails.

Fixes: 1a6f854f7daa ("spi: cadence-quadspi: Add Xilinx Versal external DMA support")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20230606093859.27818-1-jiasheng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index 30fd4bc90580e..b371e4eb41ec3 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1697,8 +1697,11 @@ static int cqspi_probe(struct platform_device *pdev)
 			cqspi->slow_sram = true;
 
 		if (of_device_is_compatible(pdev->dev.of_node,
-					    "xlnx,versal-ospi-1.0"))
-			dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
+					    "xlnx,versal-ospi-1.0")) {
+			ret = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
+			if (ret)
+				goto probe_reset_failed;
+		}
 	}
 
 	ret = devm_request_irq(dev, irq, cqspi_irq_handler, 0,
-- 
2.39.2



