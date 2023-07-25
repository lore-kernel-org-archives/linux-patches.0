Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41D114270
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:53:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56054C433C7;
	Tue, 25 Jul 2023 10:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282415;
	bh=y6bziz/MvdQ+aDDDtJgCjPL8YGD7r7BVYP/dHYkzrrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t2J7a2Atkv2aaT8AKIiRNZzcwY85lAJro6cGRi2Yf4WD71hLyldz6IEEeiZqq/5di
	 JpjXvhOneoLgvn2EgAJT2CYzfMbO+sQZLQPNxc+wlhQCRzcii8q58pDBRamNPkl9BZ
	 okWDHZG+gA0IwwqbrCIDE4l1xJcuOZroCLgcyFlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abe Kohandel <abe.kohandel@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 121/227] spi: dw: Add compatible for Intel Mount Evans SoC
Date: Tue, 25 Jul 2023 12:44:48 +0200
Message-ID: <20230725104519.824656366@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Abe Kohandel <abe.kohandel@intel.com>

[ Upstream commit 0760d5d0e9f0c0e2200a0323a61d1995bb745dee ]

The Intel Mount Evans SoC's Integrated Management Complex uses the SPI
controller for access to a NOR SPI FLASH. However, the SoC doesn't
provide a mechanism to override the native chip select signal.

This driver doesn't use DMA for memory operations when a chip select
override is not provided due to the native chip select timing behavior.
As a result no DMA configuration is done for the controller and this
configuration is not tested.

The controller also has an errata where a full TX FIFO can result in
data corruption. The suggested workaround is to never completely fill
the FIFO. The TX FIFO has a size of 32 so the fifo_len is set to 31.

Signed-off-by: Abe Kohandel <abe.kohandel@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230606145402.474866-2-abe.kohandel@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-dw-mmio.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/spi/spi-dw-mmio.c b/drivers/spi/spi-dw-mmio.c
index 15f5e9cb54ad4..5a38cb09a650d 100644
--- a/drivers/spi/spi-dw-mmio.c
+++ b/drivers/spi/spi-dw-mmio.c
@@ -236,6 +236,31 @@ static int dw_spi_intel_init(struct platform_device *pdev,
 	return 0;
 }
 
+/*
+ * The Intel Mount Evans SoC's Integrated Management Complex uses the
+ * SPI controller for access to a NOR SPI FLASH. However, the SoC doesn't
+ * provide a mechanism to override the native chip select signal.
+ *
+ * This driver doesn't use DMA for memory operations when a chip select
+ * override is not provided due to the native chip select timing behavior.
+ * As a result no DMA configuration is done for the controller and this
+ * configuration is not tested.
+ */
+static int dw_spi_mountevans_imc_init(struct platform_device *pdev,
+				      struct dw_spi_mmio *dwsmmio)
+{
+	/*
+	 * The Intel Mount Evans SoC's Integrated Management Complex DW
+	 * apb_ssi_v4.02a controller has an errata where a full TX FIFO can
+	 * result in data corruption. The suggested workaround is to never
+	 * completely fill the FIFO. The TX FIFO has a size of 32 so the
+	 * fifo_len is set to 31.
+	 */
+	dwsmmio->dws.fifo_len = 31;
+
+	return 0;
+}
+
 static int dw_spi_canaan_k210_init(struct platform_device *pdev,
 				   struct dw_spi_mmio *dwsmmio)
 {
@@ -405,6 +430,10 @@ static const struct of_device_id dw_spi_mmio_of_match[] = {
 	{ .compatible = "snps,dwc-ssi-1.01a", .data = dw_spi_hssi_init},
 	{ .compatible = "intel,keembay-ssi", .data = dw_spi_intel_init},
 	{ .compatible = "intel,thunderbay-ssi", .data = dw_spi_intel_init},
+	{
+		.compatible = "intel,mountevans-imc-ssi",
+		.data = dw_spi_mountevans_imc_init,
+	},
 	{ .compatible = "microchip,sparx5-spi", dw_spi_mscc_sparx5_init},
 	{ .compatible = "canaan,k210-spi", dw_spi_canaan_k210_init},
 	{ .compatible = "amd,pensando-elba-spi", .data = dw_spi_elba_init},
-- 
2.39.2



