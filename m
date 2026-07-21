Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223C844AB9F;
	Tue, 21 Jul 2026 22:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673366; cv=none; b=QaOQU6kmGKJMoKjaOfzAHzl9w1wptUGJH5QC1mlc2fQCQACAI218OGnZSZUXJ0g7Od5Jmi1WFn3+vYAwfc84gJkfhhXWgx1tMWQlw9MO+S4bLw1DGmej3xg2F7fSt1fRxE2wf7y/Qg2poiJ7oe7o2mZznCsN4IJJXygXh4iRVAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673366; c=relaxed/simple;
	bh=co2TtNviBGxui5Py43O/9biuWMEciElqCvFtrZoqfEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJ1P7JNdKbMUuBijD/cOqHitzlElFLoNPORE48fPk0gf07EKGScEvGTy4H5EmOOKrA+0oK1S9Jer+eUOi+ZnVj3gU5uwb4Bhz5ZQ/FDitc5kGhUcFeOIJnvjUUwlzZYy4DeQakuFC8N0lsR6o1X/0HX0pddSklbpfj9zM3PGZis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bk7KrKdE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bk7KrKdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878D51F000E9;
	Tue, 21 Jul 2026 22:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673365;
	bh=uzitj26zWemB9yxHYB4Rq2NYWmswpnp6Qk936zzGAdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bk7KrKdEI0juuwrDX7WUeYQYUszE+aKcS7n8Wtesbs5/FCuXaoPT8x/g6zSzZl5dn
	 Dxycsl30Egm2YdgQ+8idxCL2u49WGzBrd/bf0u+2j6z55/VmOkUqCiweuCnESDhxek
	 LNrxFfFv5mY1tTtYW/7mpEOo3fMW62A7L46RWLPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 136/699] spi: fsl-lpspi: terminate the RX channel on TX prepare failure path
Date: Tue, 21 Jul 2026 17:18:15 +0200
Message-ID: <20260721152358.777278089@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -577,7 +577,7 @@ static int fsl_lpspi_dma_transfer(struct
 				tx->sgl, tx->nents, DMA_MEM_TO_DEV,
 				DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!desc_tx) {
-		dmaengine_terminate_sync(controller->dma_tx);
+		dmaengine_terminate_sync(controller->dma_rx);
 		return -EINVAL;
 	}
 


