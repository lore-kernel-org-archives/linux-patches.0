Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E29235201C;
	Tue, 21 Jul 2026 21:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668563; cv=none; b=NO4YMZcp8DIdOix6+4LOLi0do9IvlPTjZNo8F14wWuXTF2ujWiDlIMBPLfOpcgE6weAsCYSIwpqLQpfWFAY8cKEfNzVJWvwFb/zAvAa5yyINFtjd+2tJq2OvW+J4WU1Hl//QXgD7O+lVHk0xvCcF8kqX2H7x0TbbWT3/Xty2Y80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668563; c=relaxed/simple;
	bh=5SUjxJzezsg1pQiKkrKflFseAud35LPeQIAfIfpRFOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r2L7YQix9TIqvIeehGhGSIok0qomIEjbRqux+ywdFOcqDoYMLuyP3SDYvbCvTTwV9KjlhOf1xs9n0iDKivH3W7b7pasCZQKmKm1bMcxruFYA4B1is62kcMguj/XLLi5MTEeLIgsE4cagVVDAX6w+oIzIiGDcCwYwKpgpZSJb7GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tu5i8rhv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tu5i8rhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82FFF1F000E9;
	Tue, 21 Jul 2026 21:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668560;
	bh=gTDPv4eRc4P/xbxpxigXj3tvZxfWJHnuq9WaBuWnKkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tu5i8rhvsJd57bD/r4OFASB8xw/6AcJkmDsKV4uD3TspK8ulNMuJ15wq1w8DwbAYL
	 1ZYi3M1FJNE0LAAEar900sRe+IOKN0ZzsdhhMceczUZy3DRBxfCVNSXcMotHDtZOHF
	 WHS8ZpOARovBbOjgYk3aihQ6gG+jSAbPDwGpZAy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 0221/1067] spi: fsl-lpspi: terminate the RX channel on TX prepare failure path
Date: Tue, 21 Jul 2026 17:13:42 +0200
Message-ID: <20260721152429.540495600@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


