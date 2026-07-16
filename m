Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662744279FD;
	Thu, 16 Jul 2026 14:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212362; cv=none; b=Ir79CUIngNpcVwQb3AZNtSqRcZQ0Fduykkd+1fs0WPYquV1HkPa69wTIQBwrJzFq7koqpJ4lrYIbiKYaeomlIj8yjAiStKOW0Kpf89FmnbMPXorNE6wjNXNYLJZJ+Q4faHstEXndoIDmp6llXCAzNJLmusgoNWWyJLV9UFCx37Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212362; c=relaxed/simple;
	bh=0Yrda7wfddieeJ+cDk1h8EiNRPdUdxY4p0QCocJvFdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTI7X/lOV6epQzP7NWxLZYnF44v42NlSp5jpt9QPw9FfukT6giPonR4ArzBUbHq6k9tVBSAw0Q9X18UAaeDZk+o/vRFjAUe+0eM0Nvey4cu/KOI+95DUyJrJsop1Jpqzgta2Uo305hnPKKdrvjAL1AJ5RQLkygKHyvFURcHHE8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTv+kAHP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTv+kAHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9135E1F000E9;
	Thu, 16 Jul 2026 14:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212361;
	bh=4jkSu9RbHNvrqDqXcGpGgATyntIdbILueghdMrOdHnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QTv+kAHPhJOgp5UnvTJilrD7rNSI3ExiDdH57kDIkHzIK3jNySB884MfKoLHmr8XL
	 scnLS35tsI3E8d4DDNzAjsBf944mGDhKnih0H5fTH8nvDw/4KpJcyc2WvOxEbbW6vx
	 vpM/CrEwCKgh+PMijjLmV5FHBADPBxRUM9PJ0bPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 299/349] spi: fsl-lpspi: terminate the RX channel on TX prepare failure path
Date: Thu, 16 Jul 2026 15:33:53 +0200
Message-ID: <20260716133040.013062960@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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
 


