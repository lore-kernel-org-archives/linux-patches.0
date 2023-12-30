Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D88881F;
	Sat, 30 Dec 2023 12:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ce+a7QG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145E7C433C8;
	Sat, 30 Dec 2023 12:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937658;
	bh=+al/LrqqX+MkYZ6s7c7xbL9uGFOes6PG+v2y86wnIeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ce+a7QG7jQBZP6dl0PTsL+S7Qs8sS3rmaWGnsEUj7nsawB3eYJ7L+cHOg2xtgNev1
	 LDe4zT5T1Y3QIbdH2KgZQ99IkHpkKpTwKlFql5UB5bxuM8U9GmlQGPaT08KkDld8/j
	 UELnW3nnXkVcvdPP6U5xxSGI4ghj09mnGp0wCtb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Bigler <benjamin@bigler.one>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/156] spi: spi-imx: correctly configure burst length when using dma
Date: Sat, 30 Dec 2023 11:57:47 +0000
Message-ID: <20231230115812.814069672@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Bigler <benjamin@bigler.one>

[ Upstream commit e9b220aeacf109684cce36a94fc24ed37be92b05 ]

If DMA is used, burst length should be set to the bus width of the DMA.
Otherwise, the SPI hardware will transmit/receive one word per DMA
request.
Since this issue affects both transmission and reception, it cannot be
detected with a loopback test.
Replace magic numbers 512 and 0xfff with MX51_ECSPI_CTRL_MAX_BURST.

Reported-by Stefan Bigler <linux@bigler.io>

Signed-off-by: Benjamin Bigler <benjamin@bigler.one>
Fixes: 15a6af94a277 ("spi: Increase imx51 ecspi burst length based on transfer length")
Link: https://lore.kernel.org/r/8a415902c751cdbb4b20ce76569216ed@mail.infomaniak.com
Link: https://lore.kernel.org/r/20231209222338.5564-1-benjamin@bigler.one
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-imx.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 498e35c8db2c1..272bc871a848b 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -659,11 +659,18 @@ static int mx51_ecspi_prepare_transfer(struct spi_imx_data *spi_imx,
 		ctrl |= (spi_imx->target_burst * 8 - 1)
 			<< MX51_ECSPI_CTRL_BL_OFFSET;
 	else {
-		if (spi_imx->count >= 512)
-			ctrl |= 0xFFF << MX51_ECSPI_CTRL_BL_OFFSET;
-		else
-			ctrl |= (spi_imx->count * spi_imx->bits_per_word - 1)
+		if (spi_imx->usedma) {
+			ctrl |= (spi_imx->bits_per_word *
+				spi_imx_bytes_per_word(spi_imx->bits_per_word) - 1)
 				<< MX51_ECSPI_CTRL_BL_OFFSET;
+		} else {
+			if (spi_imx->count >= MX51_ECSPI_CTRL_MAX_BURST)
+				ctrl |= (MX51_ECSPI_CTRL_MAX_BURST - 1)
+						<< MX51_ECSPI_CTRL_BL_OFFSET;
+			else
+				ctrl |= (spi_imx->count * spi_imx->bits_per_word - 1)
+						<< MX51_ECSPI_CTRL_BL_OFFSET;
+		}
 	}
 
 	/* set clock speed */
-- 
2.43.0



