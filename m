Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976F8168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A2AC4339B;
	Mon,  8 May 2023 10:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542516;
	bh=KSxizf7datX2HEfGJf+3bDanl/ZKUkPm3AsmV9jLRa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P0E9Q9jBTeYL+rbuHDWRZIeJThvDU0LFX9ZrJBxotEOC86vcA/GhfIHBDAEobJUTF
	 WNXnPTY9++gutRfd0Go2NgClL+MAth8PhEPMOVYlpPz2znkjoylI6av2SfB6O6gCux
	 whmB6z87FVo2aXpaBQUWX0zhrhFPCM6nKLD7ou0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tharun Kumar P <tharunkumar.pasumarthi@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 461/663] spi: mchp-pci1xxxx: Fix length of SPI transactions not set properly in driver
Date: Mon,  8 May 2023 11:44:47 +0200
Message-Id: <20230508094443.098484008@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
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



