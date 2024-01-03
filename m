Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA531BDF1;
	Wed,  3 Jan 2024 17:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lbGyoDKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D0DC433C7;
	Wed,  3 Jan 2024 17:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301964;
	bh=lVtIHogaV19bicU5tfDSNxDMAKRgmBiVWbM3WICmV5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lbGyoDKeg6uvfZeOGvtv0q5kNoJI75PyUuSBrhQi74ARLIdnOmuyppBxRsx3IxOHx
	 ik9puc9+Ii25T9CtYwAMEMgLU8if/9bRuycs+TzN/lLiMzs5LXdSWwW0AW2migGJgI
	 nENZXQSqqtRmQZ3k8k9m86JoOokwuRfDGwm7DqBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Sneddon <dan.sneddon@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 61/75] spi: atmel: Fix CS and initialization bug
Date: Wed,  3 Jan 2024 17:55:42 +0100
Message-ID: <20240103164852.329991240@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164842.953224409@linuxfoundation.org>
References: <20240103164842.953224409@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Sneddon <dan.sneddon@microchip.com>

[ Upstream commit 69e1818ad27bae167eeaaf6829d4a08900ef5153 ]

Commit 5fa5e6dec762 ("spi: atmel: Switch to transfer_one transfer
method") switched to using transfer_one and set_cs.  The
core doesn't call set_cs when the chip select lines are gpios.  Add the
SPI_MASTER_GPIO_SS flag to the driver to ensure the calls to set_cs
happen since the driver programs configuration registers there.

Fixes: 5fa5e6dec762 ("spi: atmel: Switch to transfer_one transfer method")

Signed-off-by: Dan Sneddon <dan.sneddon@microchip.com>
Link: https://lore.kernel.org/r/20210629192218.32125-1-dan.sneddon@microchip.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: fc70d643a2f6 ("spi: atmel: Fix clock issue when using devices with different polarities")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-atmel.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 2dba2089f2b7e..19499131e5676 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -352,8 +352,6 @@ static void cs_activate(struct atmel_spi *as, struct spi_device *spi)
 		}
 
 		mr = spi_readl(as, MR);
-		if (spi->cs_gpiod)
-			gpiod_set_value(spi->cs_gpiod, 1);
 	} else {
 		u32 cpol = (spi->mode & SPI_CPOL) ? SPI_BIT(CPOL) : 0;
 		int i;
@@ -369,8 +367,6 @@ static void cs_activate(struct atmel_spi *as, struct spi_device *spi)
 
 		mr = spi_readl(as, MR);
 		mr = SPI_BFINS(PCS, ~(1 << chip_select), mr);
-		if (spi->cs_gpiod)
-			gpiod_set_value(spi->cs_gpiod, 1);
 		spi_writel(as, MR, mr);
 	}
 
@@ -400,8 +396,6 @@ static void cs_deactivate(struct atmel_spi *as, struct spi_device *spi)
 
 	if (!spi->cs_gpiod)
 		spi_writel(as, CR, SPI_BIT(LASTXFER));
-	else
-		gpiod_set_value(spi->cs_gpiod, 0);
 }
 
 static void atmel_spi_lock(struct atmel_spi *as) __acquires(&as->lock)
@@ -1498,7 +1492,8 @@ static int atmel_spi_probe(struct platform_device *pdev)
 	master->bus_num = pdev->id;
 	master->num_chipselect = 4;
 	master->setup = atmel_spi_setup;
-	master->flags = (SPI_MASTER_MUST_RX | SPI_MASTER_MUST_TX);
+	master->flags = (SPI_MASTER_MUST_RX | SPI_MASTER_MUST_TX |
+			SPI_MASTER_GPIO_SS);
 	master->transfer_one = atmel_spi_one_transfer;
 	master->set_cs = atmel_spi_set_cs;
 	master->cleanup = atmel_spi_cleanup;
-- 
2.43.0



