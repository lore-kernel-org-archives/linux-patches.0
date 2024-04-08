Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697527CF29;
	Mon,  8 Apr 2024 13:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583320; cv=none; b=bo++5FkGsMKFfAiMz/RfGyrgUdFeaaqxvXvQeOIO2zkosIZPPMcdWpfV7fUMU8tL4muPB1SyGF/lUv8pMbVmQjnCqfmY198kQwTeUAAGomiQoxx60Zv4TxB73mjf2U3xKtMiDulCpOLruOAjsxPa3oPht5LITdDiq2OJfduZcZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583320; c=relaxed/simple;
	bh=FN27wrmFzJ84Pe99AvInlX0ushFh+bk5XIyS17z6UFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJRRLQhAHKisxwVuKoObyaVKE8QZbdrgpVSveswdeygVOG12q4UM/pVT2UmXdZqeE+paDJQvE0PGSwdraV2eX5+Qan9N4dInm5wro7UjdNevTtB4hS+N/xsAdeXYvTQlLtrrvPn0C0gNU91ZHAVF/PKxLEAVO3r0zIIiH9JHUqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0GZ5CexY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0GZ5CexY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72E9C433C7;
	Mon,  8 Apr 2024 13:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583320;
	bh=FN27wrmFzJ84Pe99AvInlX0ushFh+bk5XIyS17z6UFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0GZ5CexY9IAE98B4zJR393dsL2uzOvB7YTTGJ1LY/Se4rXzTrg09D9EvbPhPtFdmR
	 2ptQturrOpeN7g9OQrQCcYnMCm/0s7f4EVcFTvrbJq24cd7DmrUzjn2nAJaLWQ1DQg
	 CCLEPlkjsb34bbRoMiYhmUkmQCRAX18bQTJB8G3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaewon Kim <jaewon02.kim@samsung.com>,
	Sam Protsenko <semen.protsenko@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 181/252] spi: s3c64xx: Use DMA mode from fifo size
Date: Mon,  8 Apr 2024 14:58:00 +0200
Message-ID: <20240408125312.284236250@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

From: Jaewon Kim <jaewon02.kim@samsung.com>

[ Upstream commit a3d3eab627bbbb0cb175910cf8d0f7022628a642 ]

If the SPI data size is smaller than FIFO, it operates in PIO mode,
and if it is larger than FIFO size, it oerates in DMA mode.

If the SPI data size is equal to fifo, it operates in PIO mode and it is
separated to 2 transfers. To prevent it, it must operate in DMA mode
from the case where the data size and the fifo size are the same.

Fixes: 1ee806718d5e ("spi: s3c64xx: support interrupt based pio mode")
Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
Reviewed-by: Sam Protsenko <semen.protsenko@linaro.org>
Link: https://lore.kernel.org/r/20240329085840.65856-1-jaewon02.kim@samsung.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-s3c64xx.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index e059fb9db1da1..652eadbefe24c 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -424,7 +424,7 @@ static bool s3c64xx_spi_can_dma(struct spi_controller *host,
 	struct s3c64xx_spi_driver_data *sdd = spi_controller_get_devdata(host);
 
 	if (sdd->rx_dma.ch && sdd->tx_dma.ch)
-		return xfer->len > sdd->fifo_depth;
+		return xfer->len >= sdd->fifo_depth;
 
 	return false;
 }
@@ -783,10 +783,9 @@ static int s3c64xx_spi_transfer_one(struct spi_controller *host,
 			return status;
 	}
 
-	if (!is_polling(sdd) && (xfer->len > fifo_len) &&
+	if (!is_polling(sdd) && xfer->len >= fifo_len &&
 	    sdd->rx_dma.ch && sdd->tx_dma.ch) {
 		use_dma = 1;
-
 	} else if (xfer->len >= fifo_len) {
 		tx_buf = xfer->tx_buf;
 		rx_buf = xfer->rx_buf;
-- 
2.43.0



