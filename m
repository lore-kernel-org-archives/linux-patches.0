Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3901943F4A3;
	Thu, 30 Jul 2026 14:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421464; cv=none; b=ZqDswXLdAZMd31aIMPC8yO716TZDi1PebTk7dv0x+yQsfklQJxf0HOwgRBh8+m8iWx9y623amctX/gpA58NgVftOlyT/69+96N1BzGnEw17RTCYhN0H2Kk8RXHhAsEK/w2KL2dhIDRP59i6YfRVPm2QEb4o4AujIWVQ1L7xPuHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421464; c=relaxed/simple;
	bh=nXVkOaLWVjREa5UyZpopNkKHw3bduM/UUniGov4Pucw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rdpqz06MwfPgzjrCRUm3Y2zarX69pDaLNKiww2GYruPHeuvxd0QrmtDKXDsoHbxXrsGtCYOSsQTq0i2+N8pNX5z4nwn6tevxfUpZ+e0JKVxeid8Xw8zx5HphzAkS5PrSGs5NkWTAtj7jgR7vJEPrTwKbtVJ40Y6/MJexBmN2uZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qZ49Aggc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qZ49Aggc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E991F000E9;
	Thu, 30 Jul 2026 14:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421462;
	bh=09VgA6426aoNSjKv7ue85Pvuf+ius4iGjsnjaGpSNF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qZ49AggcQmSJwHsqr9hTtviRskifxgaYCNHS7ks2Ax3hhxoiUPyVCD4w/JCqWn2Hx
	 umYS8fiCmVFWtvCS0cCvTOXnT5WcnQ3X+IOYSUUiNDKfxbJudx2Q6gifFDDikTcXk6
	 rw/GJPOWdqdGbvKkXbvaCYNNEab2RrlDt0y03xyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srikanth Boyapally <srikanth.boyapally@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 111/744] spi: cadence-quadspi: Fix indirect write timeout when DMA read mode is enabled
Date: Thu, 30 Jul 2026 16:06:24 +0200
Message-ID: <20260730141446.638465417@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srikanth Boyapally <srikanth.boyapally@amd.com>

[ Upstream commit e919ca35a6e84b5adf085da9ffa1544c01d4ce1e ]

When use_dma_read is enabled, the IRQ handler unconditionally overwrites
irq_status with the return value of get_dma_status(). For write operations,
DMA status returns 0 since no DMA read is in progress, causing irq_status
to become 0. The subsequent completion signal is never triggered and the
write operation times out with -ETIMEDOUT:

  cadence-qspi f1010000.spi: Indirect write timeout
  spi-nor spi0.1: operation failed with -110

Fix this by separating the DMA completion path from the write interrupt
path. If get_dma_status() indicates DMA read completion, signal completion
and return immediately. Otherwise, preserve the original irq_status so that
write completion interrupts are correctly recognized and signalled.

Fixes: aac733a96636 ("spi: cadence-qspi: Fix style and improve readability")
Signed-off-by: Srikanth Boyapally <srikanth.boyapally@amd.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://patch.msgid.link/20260708045148.2993313-1-srikanth.boyapally@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index 057381e56a7fd5..38aa83375c1896 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -382,12 +382,16 @@ static irqreturn_t cqspi_irq_handler(int this_irq, void *dev)
 	/* Clear interrupt */
 	writel(irq_status, cqspi->iobase + CQSPI_REG_IRQSTATUS);
 
-	if (cqspi->use_dma_read && ddata && ddata->get_dma_status)
-		irq_status = ddata->get_dma_status(cqspi);
-	else if (cqspi->slow_sram)
+	if (cqspi->use_dma_read && ddata && ddata->get_dma_status) {
+		if (ddata->get_dma_status(cqspi)) {
+			complete(&cqspi->transfer_complete);
+			return IRQ_HANDLED;
+		}
+	} else if (cqspi->slow_sram) {
 		irq_status &= CQSPI_IRQ_MASK_RD_SLOW_SRAM | CQSPI_IRQ_MASK_WR;
-	else
+	} else {
 		irq_status &= CQSPI_IRQ_MASK_RD | CQSPI_IRQ_MASK_WR;
+	}
 
 	if (irq_status)
 		complete(&cqspi->transfer_complete);
-- 
2.53.0



