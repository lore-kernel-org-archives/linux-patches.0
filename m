Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CDE434E5D;
	Tue, 21 Jul 2026 20:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665402; cv=none; b=rwzExMUVEkI7h0iVTbVFna8u5IaflXerulX+/Z1+Yme4Zp9zuFqihuZS5s9lljbIO+aRCEP57eoCNTgR5z4i067zT4rDcJZ+GpV1AAbxOqjaG7i9Mt+eq/A/fZLHlcZQ6IDXt8zI4I3QTeKI4dPP/t+ZOyfAAulWfxxehWvQY5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665402; c=relaxed/simple;
	bh=Eq6AYNODNAZe2WpagUiTxzEDmF5BXrQBDvzhZjjG26g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWcHQt70sAtW/u3FVCFYDFOGq4T7dAtwJziNXi+djKRzOatG0BIVi0S8JFLGVpu3yQSlWHIN0JjJLqATRLcihcwnAsibZ4lKAib6V+dyubyVx7aYu59lNzEKQVaMmhBL1rHrBhmfMlT5l8V4VCBLXXdPBNFpa0OFhMuIaCVutvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RvVToBj/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RvVToBj/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614B01F00A3A;
	Tue, 21 Jul 2026 20:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665400;
	bh=M4z1TnxZ68CpkNdlwBnhb9TtZrWTHsRB0LZNoHE0lDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RvVToBj/Gi0mBSTh/ty3+IV6Qx4fn1iGPjyCOK63d0CF6ABTUWmhChF79RQh1de+B
	 X7mQ9DQQa8pLUN+G+AHLISJMfEsoS2iZfS10CQphda05gA2bc93+yg7YrvKzqBcs58
	 wQ2kZ1+hbVWbJF3cqj83kjPWwxvuwpFQrA1D9QdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 0291/1266] spi: fsl-lpspi: terminate the RX channel on TX prepare failure path
Date: Tue, 21 Jul 2026 17:12:08 +0200
Message-ID: <20260721152448.335429812@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -603,7 +603,7 @@ static int fsl_lpspi_dma_transfer(struct
 				tx->sgl, tx->nents, DMA_MEM_TO_DEV,
 				DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!desc_tx) {
-		dmaengine_terminate_sync(controller->dma_tx);
+		dmaengine_terminate_sync(controller->dma_rx);
 		return -EINVAL;
 	}
 


