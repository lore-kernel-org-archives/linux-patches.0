Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515A9325701;
	Thu, 16 Jul 2026 14:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211321; cv=none; b=s1TBhHxj7X8CKu17u24y5qF0Kuz+wXyGf1G3B8e9y6Pe/4geWn+x/mvqm0Hn3UYy5PLBUMWRGSuTA4z+yrQ6V/4navRnwCVus5/vXXiQZcoCEZ2jJweQaBxAHOMaUgVBcF/Voyj6ZlYBwVfsKX+RcEsWFt4vFk/RLwu8at0SvgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211321; c=relaxed/simple;
	bh=aD2LO0zqZlszvCIl4h6VeBXkNTM8Ur93iXcTACBdsjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GFEwoMOOXbgO+Q4iFvsSH5hl+J/7OlpR28wJ274TdysP1WjWg3zwFPxtu/t7NhgBFHbUjfGEd8Y7YY1CNTB7s2Y0XXFXZF5o6oHZ7zXhH4qoHJzukjN8fifkOjpRA1EBhXo1I+1ytQuo7IoSdhw413tQ3tYknxtDn2Fn7JAckhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C4O8hLEv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C4O8hLEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9E01F000E9;
	Thu, 16 Jul 2026 14:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211320;
	bh=YngmRFrwA1n10r5PzAYmrGLwdtU2y28ZDDhdp1KJcfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C4O8hLEvhqudhmJ3GiuAJyMxgiVRZS1FyPYMst4tiyGN1qJt0piws7zG5FtwwRr1H
	 kvXUIFgtCeAig3wAvoLQsj9Tr3t5OEPjHjloxzFbF06bIkbOrY6GtZnIGmfovyo2FY
	 fOsvC58EsaOjwnjp9qbqCe9pryYwc82Fr9wLqOC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 384/480] spi: fsl-lpspi: terminate the RX channel on TX prepare failure path
Date: Thu, 16 Jul 2026 15:32:11 +0200
Message-ID: <20260716133053.107910457@linuxfoundation.org>
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

commit 01980b5da56e573d62798d0ff6c86bcaa2b22cbe upstream.

When dmaengine_prep_slave_sg() fails for the TX channel, the error path
terminates the TX DMA channel but leaves the RX channel running. Since
the RX channel was already submitted and issued prior to preparing
the TX descriptor, returning -EINVAL causes the SPI core to unmap the
DMA buffers while the RX DMA engine continues writing to them, leading
to potential memory corruption or use-after-free.

Terminate the RX channel before returning on the TX prepare failure path.

Fixes: 09c04466ce7e ("spi: lpspi: add dma mode support")
Cc: stable@vger.kernel.org
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Link: https://patch.msgid.link/20260525062357.3191349-3-carlos.song@oss.nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-fsl-lpspi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -619,7 +619,7 @@ static int fsl_lpspi_dma_transfer(struct
 				tx->sgl, tx->nents, DMA_MEM_TO_DEV,
 				DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!desc_tx) {
-		dmaengine_terminate_sync(controller->dma_tx);
+		dmaengine_terminate_sync(controller->dma_rx);
 		return -EINVAL;
 	}
 


