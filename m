Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8880E3EB0F3;
	Mon, 17 Aug 2026 14:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978011; cv=none; b=axfSiJ6+MlUyUSQBn6YF+DtKvcbjNPi04lSb4wMpZRn/uSoOnkzgYrS4ln6QhgjgS3iAmYeJM8loXrau1cuB3u3DWcLUpCvE9j0AQGembPjAmcf8Z2qDrqkbzBjEzuOLnI7Yt3mhLoNb94rbBsNUU9kbWvJUUaEi+/0E3b6UE6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978011; c=relaxed/simple;
	bh=cbjLGX9epNOmMPH7P9p78QPDlzRz71nbIJPAlgPTWuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUthXpk9JYAPMb+100YRowOV2XqQLAIQ4CbeatNqhnbL3lMUGB3DJnypOjrs4fSgdlnhlg7qJW0yvo29W+bQ0iGvG41HwWPVbVzB5Fqd6IivQAMWkSPNmZymsqDuYN4IvwRLbKNowS87dT3AdyKcXMVrteUnXJ4f9JuIEQKj+Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SUjFqojw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SUjFqojw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BE71F000E9;
	Mon, 17 Aug 2026 14:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978010;
	bh=dLuQLeaKLktHq92GK15Pc9lpoZ1e1aweo/L8TXG6bnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SUjFqojwCqI2N6uv7zdIAQt/bW8cza542HATYBhPxR33rCuGgh1MKaYQZFOFKQXkx
	 amEh+DIjgiRoANK/3J7ulJzbAnihNL42WV1jLcijuNsEnitCh7B8oMEGArxhMbM+fd
	 zkO/tI9rddkZa+emu5MiyXRq955n9pl3Uoo7an7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Larisa Grigore <larisa.grigore@nxp.com>,
	James Clark <james.clark@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/181] spi: spi-fsl-dspi: Avoid setup_accel logic for DMA transfers
Date: Mon, 17 Aug 2026 15:32:43 +0200
Message-ID: <20260817132538.152816328@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larisa Grigore <larisa.grigore@nxp.com>

[ Upstream commit cac7e5054115fcc41b1cb050af8e8971f7c9b22b ]

Repacking multiple smaller words into larger ones to make use of the
full FIFO doesn't save anything in DMA mode, so don't bother doing it.

Signed-off-by: Larisa Grigore <larisa.grigore@nxp.com>
Signed-off-by: James Clark <james.clark@linaro.org>
Link: https://patch.msgid.link/20250522-james-nxp-spi-v2-8-bea884630cfb@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-dspi.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index e26363ae74890..bc7479c834ff6 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -746,8 +746,12 @@ static void dspi_setup_accel(struct fsl_dspi *dspi)
 	struct spi_transfer *xfer = dspi->cur_transfer;
 	bool odd = !!(dspi->len & 1);
 
-	/* No accel for frames not multiple of 8 bits at the moment */
-	if (xfer->bits_per_word % 8)
+	/*
+	 * No accel for DMA transfers or frames not multiples of 8 bits at the
+	 * moment.
+	 */
+	if (dspi->devtype_data->trans_mode == DSPI_DMA_MODE ||
+	    xfer->bits_per_word % 8)
 		goto no_accel;
 
 	if (!odd && dspi->len <= dspi->devtype_data->fifo_size * 2) {
@@ -756,10 +760,7 @@ static void dspi_setup_accel(struct fsl_dspi *dspi)
 		dspi->oper_bits_per_word = 8;
 	} else {
 		/* Start off with maximum supported by hardware */
-		if (dspi->devtype_data->trans_mode == DSPI_XSPI_MODE)
-			dspi->oper_bits_per_word = 32;
-		else
-			dspi->oper_bits_per_word = 16;
+		dspi->oper_bits_per_word = 32;
 
 		/*
 		 * And go down only if the buffer can't be sent with
-- 
2.53.0



