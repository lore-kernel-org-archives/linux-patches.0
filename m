Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44C0320A
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C650C433D2;
	Mon,  8 May 2023 11:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544804;
	bh=KSxizf7datX2HEfGJf+3bDanl/ZKUkPm3AsmV9jLRa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ARDnCD8hm76vIWa1+fULX/M1/cUE7OgqJuwu41sWP//KkZ4Csf2qaZ6RP99zDHx9a
	 q7PHcGYyvlvsQYLCuq7eNfw70YC6ZgDUMXiO/BXmH0ABCS4XD7mfcCTTpSCOLkPQ12
	 iO7awEShQQouWEDYnCbYTjTDp5B/ymKcwM+mT2yM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tharun Kumar P <tharunkumar.pasumarthi@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 511/694] spi: mchp-pci1xxxx: Fix length of SPI transactions not set properly in driver
Date: Mon,  8 May 2023 11:45:46 +0200
Message-Id: <20230508094450.758746740@linuxfoundation.org>
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

[ Upstream commit 35c8c5e503a82e0a4bf251d32096211eba8c2be6 ]

In pci1xxxx_spi_transfer_one API, length of SPI transaction gets cleared
by setting of length mask. Set length of transaction only after masking
length field.

Fixes: 1cc0cbea7167 ("spi: microchip: pci1xxxx: Add driver for SPI controller of PCI1XXXX PCIe switch")
Signed-off-by: Tharun Kumar P <tharunkumar.pasumarthi@microchip.com>
Link: https://lore.kernel.org/r/20230404171613.1336093-2-tharunkumar.pasumarthi@microchip.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-pci1xxxx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-pci1xxxx.c b/drivers/spi/spi-pci1xxxx.c
index a31c3b612a430..0805c441b4065 100644
--- a/drivers/spi/spi-pci1xxxx.c
+++ b/drivers/spi/spi-pci1xxxx.c
@@ -199,8 +199,9 @@ static int pci1xxxx_spi_transfer_one(struct spi_controller *spi_ctlr,
 			else
 				regval &= ~SPI_MST_CTL_MODE_SEL;
 
-			regval |= ((clkdiv << 5) | SPI_FORCE_CE | (len << 8));
+			regval |= ((clkdiv << 5) | SPI_FORCE_CE);
 			regval &= ~SPI_MST_CTL_CMD_LEN_MASK;
+			regval |= (len << 8);
 			writel(regval, par->reg_base +
 			       SPI_MST_CTL_REG_OFFSET(p->hw_inst));
 			regval = readl(par->reg_base +
-- 
2.39.2



