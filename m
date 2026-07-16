Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC65426424;
	Thu, 16 Jul 2026 14:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211319; cv=none; b=X33uKoEnoV7cHHEtpyJIM9LsP07SEK9YeUeMqcZCdmJcKkVHP1e81GZOR9xAWvjQ8xdpe/yxQXsRvGOzvINcITxY/sNsBPi6aBeuRyVsHsGAQjOIJe/jTgDM8zKSiGv/0dVoVColVVf3n5f3RaYs0OQWj7mb6TK73BMs+WIqhns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211319; c=relaxed/simple;
	bh=UChsHLzGOXeBldc47unrdnPe+Gl3Keh2hhv9D5UISBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WT4u/i7tG2rZY+4x8SNm6Kux0Zau+GiU0x1D47YZc88l7l55xJN4IdG31OhU2THevulxrZNdE45zVDGe/TU93kPiSQgYkK4SdmnnJSt3X1g6wsQAZ7scXEi++9XmNFOyIhjpQJXle4aEZ1yvJfJUKZX0KqHZxYWqcsNqP4JrgTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=We3rwjvj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="We3rwjvj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114BE1F000E9;
	Thu, 16 Jul 2026 14:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211317;
	bh=LOIz9fGifVu7+JWqAZowRfY6zq+t7ONTN5BdhxLTeZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=We3rwjvjJTSx0AZs1llDod79JU6lCg+om6cj6lz0fHkGNUULgDqh+lnFsvDHg4LHW
	 xpXt8a1ycCcrXBljfuhllIJImeitVNdO5RhZQhtWv/KYSj+14FE8UEOvXpKTHRCldr
	 S3y/JmvGSzuWTQw8QAIXyCBgHbFGeVnir/AwfTLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 383/480] spi: fsl-lpspi: replace dmaengine_terminate_all() with dmaengine_terminate_sync()
Date: Thu, 16 Jul 2026 15:32:10 +0200
Message-ID: <20260716133053.087317859@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -619,7 +619,7 @@ static int fsl_lpspi_dma_transfer(struct
 				tx->sgl, tx->nents, DMA_MEM_TO_DEV,
 				DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!desc_tx) {
-		dmaengine_terminate_all(controller->dma_tx);
+		dmaengine_terminate_sync(controller->dma_tx);
 		return -EINVAL;
 	}
 
@@ -640,8 +640,8 @@ static int fsl_lpspi_dma_transfer(struct
 							transfer_timeout);
 		if (!time_left) {
 			dev_err(fsl_lpspi->dev, "I/O Error in DMA TX\n");
-			dmaengine_terminate_all(controller->dma_tx);
-			dmaengine_terminate_all(controller->dma_rx);
+			dmaengine_terminate_sync(controller->dma_tx);
+			dmaengine_terminate_sync(controller->dma_rx);
 			fsl_lpspi_reset(fsl_lpspi);
 			return -ETIMEDOUT;
 		}
@@ -650,8 +650,8 @@ static int fsl_lpspi_dma_transfer(struct
 							transfer_timeout);
 		if (!time_left) {
 			dev_err(fsl_lpspi->dev, "I/O Error in DMA RX\n");
-			dmaengine_terminate_all(controller->dma_tx);
-			dmaengine_terminate_all(controller->dma_rx);
+			dmaengine_terminate_sync(controller->dma_tx);
+			dmaengine_terminate_sync(controller->dma_rx);
 			fsl_lpspi_reset(fsl_lpspi);
 			return -ETIMEDOUT;
 		}
@@ -660,8 +660,8 @@ static int fsl_lpspi_dma_transfer(struct
 			fsl_lpspi->target_aborted) {
 			dev_dbg(fsl_lpspi->dev,
 				"I/O Error in DMA TX interrupted\n");
-			dmaengine_terminate_all(controller->dma_tx);
-			dmaengine_terminate_all(controller->dma_rx);
+			dmaengine_terminate_sync(controller->dma_tx);
+			dmaengine_terminate_sync(controller->dma_rx);
 			fsl_lpspi_reset(fsl_lpspi);
 			return -EINTR;
 		}
@@ -670,8 +670,8 @@ static int fsl_lpspi_dma_transfer(struct
 			fsl_lpspi->target_aborted) {
 			dev_dbg(fsl_lpspi->dev,
 				"I/O Error in DMA RX interrupted\n");
-			dmaengine_terminate_all(controller->dma_tx);
-			dmaengine_terminate_all(controller->dma_rx);
+			dmaengine_terminate_sync(controller->dma_tx);
+			dmaengine_terminate_sync(controller->dma_rx);
 			fsl_lpspi_reset(fsl_lpspi);
 			return -EINTR;
 		}


