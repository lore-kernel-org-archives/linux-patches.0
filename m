Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063192;
	b=KTDpOXFpWLosasJ8ei5ofmPL2OxPwPhtrHNhJisu88iaGYagLshlJ8kwAhPPIgDktpUh
	 VAdJmm607vQmPowcsnnK+YjUBWngwnXXGh+PLuDDhvM1OQi1LirECsoP0gcemR2QbUhB9
	 ONtA1YDRde/MeB9zyT2n8GEkH26dc3ZpEhOzb/kqr0kfXCIkNhtAnPQVrha/LdeXpcZm6
	 onQuao5LrII1Atgik8/eUgidKXiW9siSVfamJui2ILaggK3d0LzvaDJzyvKiUGSRQdDH1
	 kfLF6tz245B5Nhwp7/EEaJz+VyDWTevfpxl83tgMCQLSxrUN8I8weKC0/u2yytgUIBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063192;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yeCgLEG+K3Vj1SG4ZU75bptThEYtItbSLB9dMJeCrRc=;
	b=bBz3xDdeEuDcpjCh1g6GcyVAjGcONub0dxBFJ4MVIxOsfeCQozUt5UBkY/ywunWEzOJV
	 onIXfuhDYaPLWMoGnKQ6u6vZxXnGqTJrguAhmmG1MNiMBAHL1/vi+vgrpQCh5kuqndj9C
	 o/4YkIww0OAXZABxhD+CE60Y9fg9S9zX7WvllrJ3O5yuuPs2GthgLoo6ZSdwYwISs4puv
	 GR7rJ3oakHypMxbvqYhcXPMZ/vjV0lp6PaMugQfbuhAsi2pCOHtvBlIsiELGfLMsjz8QD
	 wMolMcZyGBPCHEncUTSX1p1Ys5T0uU+nhHK2vt1DXunFjHdBhMj4db2KixsTpFu3osw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O2awRZYh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D30606D81F;
	Sat,  7 Nov 2026 14:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O2awRZYh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 333751F0089F;
	Sat,  7 Nov 2026 14:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063192;
	bh=yeCgLEG+K3Vj1SG4ZU75bptThEYtItbSLB9dMJeCrRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O2awRZYhXg0aDvL2guf9MjMV70ycZ4GLY44MiC6zwW2EaTVqDLi9yUU1NNO2YQtFO
	 eeeQbXyge5v6kjkoEE/KfYfb088/EUZlO1y4sQ/tkRE14kr8yZroVuLZ4w76FlI1pU
	 hkzonqsRp5Q22+nQS2cvr9k0oqEuUKETLRAIb4eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-Hao Chen <billy920225@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 408/869] spi: stm32: fix double free of SRAM buffer on MDMA fallback
Date: Sat,  7 Nov 2026 08:51:30 -0500
Message-ID: <20261107134907.185860632@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pin-Hao Chen <billy920225@gmail.com>

[ Upstream commit 0c5b0c3eb1d6daa1117dacd32589196f52109cab ]

When the "rxm2m" MDMA channel cannot be obtained, the driver frees the
SRAM buffer and falls back to DMA-only mode. However, sram_rx_buf is
left pointing to the freed buffer.

As a result, stm32_spi_unprepare_msg() may clear the released SRAM
area, while stm32_spi_remove() or a later probe error path may free the
buffer again, triggering BUG_ON() in gen_pool_free_owner().

The probe error path also checks sram_pool instead of sram_rx_buf. If
the SRAM allocation failed and a later probe step fails,
gen_pool_free() may therefore be called with an unallocated buffer.

Clear sram_rx_buf after freeing it on the MDMA fallback path and use
the buffer pointer to determine whether cleanup is needed.

Fixes: d17dd2f1d8a1 ("spi: stm32: use STM32 DMA with STM32 MDMA to enhance DDR use")
Cc: stable@vger.kernel.org
Signed-off-by: Pin-Hao Chen <billy920225@gmail.com>
Link: https://patch.msgid.link/20261005220528.7199-1-billy920225@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-stm32.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-stm32.c b/drivers/spi/spi-stm32.c
index 7a6ee93be9bd4..e5d483a9d38b1 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -2454,6 +2454,7 @@ static int stm32_spi_probe(struct platform_device *pdev)
 					gen_pool_free(spi->sram_pool,
 						      (unsigned long)spi->sram_rx_buf,
 						      spi->sram_rx_buf_size);
+					spi->sram_rx_buf = NULL;
 					dev_warn(&pdev->dev,
 						 "failed to request rx mdma channel, DMA only\n");
 				}
@@ -2491,7 +2492,7 @@ static int stm32_spi_probe(struct platform_device *pdev)
 	if (spi->mdma_rx)
 		dma_release_channel(spi->mdma_rx);
 err_pool_free:
-	if (spi->sram_pool)
+	if (spi->sram_rx_buf)
 		gen_pool_free(spi->sram_pool, (unsigned long)spi->sram_rx_buf,
 			      spi->sram_rx_buf_size);
 err_dma_release:
-- 
2.53.0



