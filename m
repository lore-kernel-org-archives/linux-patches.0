Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7898F31E85C;
	Thu, 16 Jul 2026 13:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210120; cv=none; b=WeFltf2/EM76IfYgfFs9+mBK4cg3Rp02wkk68ZK6eMuaA/Pt9stZJeqHROQ0bFiMEwkXYyD2MxTgPjls9S1TuWUnLokeiINbZwJa0ktsfILnBQbU/BZx5ZeWRMo2ujdM1CRG91qVimR7Ac6du1gu+Cv7N932hdj0nIVptH+4oL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210120; c=relaxed/simple;
	bh=N1wcpWRl3Xle5Xgfc/nnwWwNjS+TwQqCom5stSB1qxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7fOWKBaTnNvfMzx1kZmLlLozHkX/2JgjobAfumTHKbULTKrJvLwHMF81zq26pLQw6O6stWts9uyN/Du151UYO3azyddyCYPqK9OBKo8tn0LHZbD5ORgGWq4DXAvnwt4LIJCrHa6LnedUuR9k+ZHsjPdDzTpU0zlh/kz1Aw1mME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VA8724tV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VA8724tV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFC41F000E9;
	Thu, 16 Jul 2026 13:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210119;
	bh=NKrOMsDQkKUjebgNdD3SM+X18rwADrcSa08Je2bgHng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VA8724tVhYL5rqghzvvm7zt9NkDHASy5q7BmjzHchmINLsPpsQQY3ImZ13pK29IVt
	 qwcKYdlhgd1wO25sqnV5yTilSLGvyYhm2QNnfJjORveADPhFx9drNGlecOfTZ2HSRj
	 VGGksfvI8KHgRQMesed1G0ClD0tIe6n/CQH/5Arg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.1 402/518] spi: fsl-lpspi: terminate the RX channel on TX prepare failure path
Date: Thu, 16 Jul 2026 15:31:10 +0200
Message-ID: <20260716133056.631911288@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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
@@ -647,7 +647,7 @@ static int fsl_lpspi_dma_transfer(struct
 				tx->sgl, tx->nents, DMA_MEM_TO_DEV,
 				DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!desc_tx) {
-		dmaengine_terminate_sync(controller->dma_tx);
+		dmaengine_terminate_sync(controller->dma_rx);
 		return -EINVAL;
 	}
 


