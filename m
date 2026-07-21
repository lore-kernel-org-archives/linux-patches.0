Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39D143F4C0;
	Tue, 21 Jul 2026 22:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671262; cv=none; b=ogvFtBrtk5yO1yz8gydThWCKjN1cfbajE4DuA3ZrviNVaD3w48asWvt+ThnIXD70PU69Re1KblBdvgFzOIOBg1AjxNaPXQ+8PkfBPBvMT4UHiJAwP0NmySsyQXBTEI1k0tSwK/z9qnKHDRE8XCxSLTnnS3zuj4LVLlD2w1C3SgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671262; c=relaxed/simple;
	bh=eyV+/GA2YkMYJLKDKzs7PcdhF2Fpn1KU4TKu2PeDXCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDVf3Uvdf38JE9XRIUbRQRXFqxd265p4XXlik75OfMMmScft3bf7IA8kcJqNMiK3bWeDulbCf4mXuokVpK+6c5A2cb/dv9c3/u+XlHeco5RjqbSI7//J73XmNtE7xfF7TI4onPfN7FhgIe3LuktjciD4TV854llkeqymSmhtPTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TvRmwu1O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TvRmwu1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 195031F000E9;
	Tue, 21 Jul 2026 22:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671260;
	bh=c1Qf2xQy3BozR75dMuNLcPDQfHqRPevqKwiZIh5//5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TvRmwu1OutU00AmqZOjgs1CQg7wh1K8S8yqoJ0XjpdDjzFLrAxYUtDEkJ0kihC/Dd
	 tgYKelCG/KOKFGChINU7tifBWC2Xt61y8H0by5Y/c+LIJf1sbfY+QZyIZkPA1d6Ruj
	 h1uSaNJehjteuPP77acTW5QDD+CHOCe8+j+NPCek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 172/843] spi: fsl-lpspi: terminate the RX channel on TX prepare failure path
Date: Tue, 21 Jul 2026 17:16:47 +0200
Message-ID: <20260721152409.887540309@linuxfoundation.org>
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
 


