Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51C4433BCA;
	Tue, 21 Jul 2026 22:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671380; cv=none; b=fXrelKTf3LZRQVXw08gxQoO9GoA0AwsnOSKrSipHvnCGNWHpgwpcpSwI1g+T0UCCqVZ19DFbjVEjcswYiuMdVfDylrEFy+iqk775v5hhKsfUEgCXypvKKJeFfsWq2YwLdVgCLo+g+wkmU6Wfvd1EmZg55lcZDBOz63hZMAlgPiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671380; c=relaxed/simple;
	bh=N65rQSy0M8AaBwJLoUWA73MLTjziV78QMeW/QkUYV3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EN2OJwRPHXmnuHkf+dBLHvnmafnmuzG5uZiXO2F6bZpNWqW1XWEcQrXyiuiiTt0jXIhf2+St2oktD8F51TSHJM+d6lLcP5OhqAMrE828Vo3IHUtaAHibb8MN1RmX8Z4k/FHeU68grL0g8dgwCMJaep16p+ajdF9jNhMyhUGmPBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RhzboRZU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RhzboRZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A1C1F000E9;
	Tue, 21 Jul 2026 22:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671379;
	bh=9hyw6fP0taoyw4e/A0Y9Y1XTYv6u6XsgoD1Zo/LAPJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RhzboRZUl9DfC/6RTcS71o1RgTG4W8op3DGvtIQzIGnEqrdO55DTgIJNCj2PIItwZ
	 iyjU9JADoiSWkCi03/YBiOJxuQYxw7+70fwAInoghKDT0q1pY9AZXqigygI+Qo6ewL
	 0pwrBcGksWG91E5sMJ7+2jYw9+Tj2RZa61Sh5h2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 171/843] spi: fsl-lpspi: replace dmaengine_terminate_all() with dmaengine_terminate_sync()
Date: Tue, 21 Jul 2026 17:16:46 +0200
Message-ID: <20260721152409.865451556@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Song <carlos.song@nxp.com>

commit e703ce47691b967fe9b4057fb1d062273211afa9 upstream.

dmaengine_terminate_all() has been deprecated, so replace it with
dmaengine_terminate_sync().

Fixes: 09c04466ce7e ("spi: lpspi: add dma mode support")
Cc: stable@vger.kernel.org
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Link: https://patch.msgid.link/20260525062357.3191349-2-carlos.song@oss.nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-fsl-lpspi.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -577,7 +577,7 @@ static int fsl_lpspi_dma_transfer(struct
 				tx->sgl, tx->nents, DMA_MEM_TO_DEV,
 				DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!desc_tx) {
-		dmaengine_terminate_all(controller->dma_tx);
+		dmaengine_terminate_sync(controller->dma_tx);
 		return -EINVAL;
 	}
 
@@ -598,8 +598,8 @@ static int fsl_lpspi_dma_transfer(struct
 						      transfer_timeout);
 		if (!timeout) {
 			dev_err(fsl_lpspi->dev, "I/O Error in DMA TX\n");
-			dmaengine_terminate_all(controller->dma_tx);
-			dmaengine_terminate_all(controller->dma_rx);
+			dmaengine_terminate_sync(controller->dma_tx);
+			dmaengine_terminate_sync(controller->dma_rx);
 			fsl_lpspi_reset(fsl_lpspi);
 			return -ETIMEDOUT;
 		}
@@ -608,8 +608,8 @@ static int fsl_lpspi_dma_transfer(struct
 						      transfer_timeout);
 		if (!timeout) {
 			dev_err(fsl_lpspi->dev, "I/O Error in DMA RX\n");
-			dmaengine_terminate_all(controller->dma_tx);
-			dmaengine_terminate_all(controller->dma_rx);
+			dmaengine_terminate_sync(controller->dma_tx);
+			dmaengine_terminate_sync(controller->dma_rx);
 			fsl_lpspi_reset(fsl_lpspi);
 			return -ETIMEDOUT;
 		}
@@ -618,8 +618,8 @@ static int fsl_lpspi_dma_transfer(struct
 			fsl_lpspi->slave_aborted) {
 			dev_dbg(fsl_lpspi->dev,
 				"I/O Error in DMA TX interrupted\n");
-			dmaengine_terminate_all(controller->dma_tx);
-			dmaengine_terminate_all(controller->dma_rx);
+			dmaengine_terminate_sync(controller->dma_tx);
+			dmaengine_terminate_sync(controller->dma_rx);
 			fsl_lpspi_reset(fsl_lpspi);
 			return -EINTR;
 		}
@@ -628,8 +628,8 @@ static int fsl_lpspi_dma_transfer(struct
 			fsl_lpspi->slave_aborted) {
 			dev_dbg(fsl_lpspi->dev,
 				"I/O Error in DMA RX interrupted\n");
-			dmaengine_terminate_all(controller->dma_tx);
-			dmaengine_terminate_all(controller->dma_rx);
+			dmaengine_terminate_sync(controller->dma_tx);
+			dmaengine_terminate_sync(controller->dma_rx);
 			fsl_lpspi_reset(fsl_lpspi);
 			return -EINTR;
 		}


