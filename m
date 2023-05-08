Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772971549A
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08B0C433EF;
	Mon,  8 May 2023 11:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544853;
	bh=j6p1I+y8zxIyywACXC7Z8VwwKvLZFLpXoiD9Al9hGKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=arI2B/R0GKfXW8Il4KnkG1iv2Fe1Rpl7KAAgFaiAmurhAvyU81h0lCHjhItXBjZnJ
	 YnelEHijnotsJBlxPUkcoY5SVUg8V9Jq6yX92oNZ5Yl3EKl4DjJcTLzMx5ZtOUZXUk
	 gsUyTfcipSI4VTPku8SPOt1EyuX0Iurm0EwkzfQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tharun Kumar P <tharunkumar.pasumarthi@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 514/694] spi: mchp-pci1xxxx: Fix improper implementation of disabling chip select lines
Date: Mon,  8 May 2023 11:45:49 +0200
Message-Id: <20230508094450.863779538@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tharun Kumar P <tharunkumar.pasumarthi@microchip.com>

[ Upstream commit 45d2af82e0e6f662d0d0db20993b35cb1d8da646 ]

Hardware does not have support to disable individual chip select lines.
Disable all chip select lines by using SPI_FORCE_CE bit.

Fixes: 1cc0cbea7167 ("spi: microchip: pci1xxxx: Add driver for SPI controller of PCI1XXXX PCIe switch")
Signed-off-by: Tharun Kumar P <tharunkumar.pasumarthi@microchip.com>
Link: https://lore.kernel.org/r/20230404171613.1336093-4-tharunkumar.pasumarthi@microchip.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-pci1xxxx.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

--- a/drivers/spi/spi-pci1xxxx.c
+++ b/drivers/spi/spi-pci1xxxx.c
@@ -114,17 +114,14 @@ static void pci1xxxx_spi_set_cs(struct s
 
 	/* Set the DEV_SEL bits of the SPI_MST_CTL_REG */
 	regval = readl(par->reg_base + SPI_MST_CTL_REG_OFFSET(p->hw_inst));
-	if (enable) {
+	if (!enable) {
+		regval |= SPI_FORCE_CE;
 		regval &= ~SPI_MST_CTL_DEVSEL_MASK;
 		regval |= (spi->chip_select << 25);
-		writel(regval,
-		       par->reg_base + SPI_MST_CTL_REG_OFFSET(p->hw_inst));
 	} else {
-		regval &= ~(spi->chip_select << 25);
-		writel(regval,
-		       par->reg_base + SPI_MST_CTL_REG_OFFSET(p->hw_inst));
-
+		regval &= ~SPI_FORCE_CE;
 	}
+	writel(regval, par->reg_base + SPI_MST_CTL_REG_OFFSET(p->hw_inst));
 }
 
 static u8 pci1xxxx_get_clock_div(u32 hz)
@@ -199,7 +196,7 @@ static int pci1xxxx_spi_transfer_one(str
 			else
 				regval &= ~SPI_MST_CTL_MODE_SEL;
 
-			regval |= ((clkdiv << 5) | SPI_FORCE_CE);
+			regval |= (clkdiv << 5);
 			regval &= ~SPI_MST_CTL_CMD_LEN_MASK;
 			regval |= (len << 8);
 			writel(regval, par->reg_base +
@@ -223,10 +220,6 @@ static int pci1xxxx_spi_transfer_one(str
 			}
 		}
 	}
-
-	regval = readl(par->reg_base + SPI_MST_CTL_REG_OFFSET(p->hw_inst));
-	regval &= ~SPI_FORCE_CE;
-	writel(regval, par->reg_base + SPI_MST_CTL_REG_OFFSET(p->hw_inst));
 	p->spi_xfer_in_progress = false;
 
 	return 0;


