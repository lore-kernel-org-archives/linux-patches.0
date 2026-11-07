Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064566;
	b=5C+oNaXbf4qn4sfpyHNRLAp2uL30/XqTfQiUk14U13MjjiAV1RH8q333D5bN/YA8PyTr
	 AJLWF1M6XMJfcwUJquzfnmnjxnR8zb1woTHoAYczoAm8denn6T/e9cWeo4F2/0RL423mJ
	 mFTz02AQ3ZEh4LHneVD2pyRiKEFr5QV38gCRG/wQNtTnOaHb4H4UlLAuEHnfaNgctEJKV
	 36qSoyGWKhpPbvoTc65wKF5NaCSeg+4AxrlVf3vnWmv7pB6xORnJuNttWjz9qtrZ1bgAM
	 Cyq25tU0dCWCaPtISe5Lufcc+fwKtEFRLPDCcuj/4j8e8GccqOXHA5gfkAeyz6t9KWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064566;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Px7SN9YtQJwnRh2wVz4qNbR0k7awOEviv0DkhtA3YkM=;
	b=CZe+7BP5nuILgbCxx5Louo2m0nAacGWPfsaTWRGjGEDKTPrbzghqdrl5SvWwo21R52vr
	 ZBp5S32j4XY0JGvBmQLtk0TbvpzcLfCPLCkVKutbiiLkNqhZf1oh7zN7g7SieQME1dvlX
	 QkhlpSkg6e1GC4NP6Ey8zlazuVYjOBBa1N/5JLgDWh1BhbK/2SngZYqKBylQCkYVCGXV8
	 wiQY/4rkB+zcgw2NvpNEUhkmxhL1EsgaKZeQG5wRarg4+PoYv+okViK1atIAGA5xI88F4
	 56L23QotyZZwvspRbCunkcMF22PRoeXjJC1Q3EzBsW5pW4bXhKGBzL1w0nY3PhKLEJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L7ajyVgt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A94C606D827;
	Sat,  7 Nov 2026 15:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L7ajyVgt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268461F0089F;
	Sat,  7 Nov 2026 15:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064566;
	bh=Px7SN9YtQJwnRh2wVz4qNbR0k7awOEviv0DkhtA3YkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L7ajyVgt033xwCg5mzUm+ab+bqBiRP8W1gNn8DG1FxqOP7sv6qPqb/lDUlkXb4qid
	 T8G2rginjrY39dVrya4vbjDjKofvXGOkX8Z6ImXMO8/GC4+/w0Okf7C5lFwvvM/Ytt
	 0n9zUy9KBTlUIJTRNj22lsr0Ck0abijWqV6kN/RM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-Hao Chen <billy920225@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0549/1257] spi: stm32: fix double free of SRAM buffer on MDMA fallback
Date: Sat,  7 Nov 2026 08:47:25 -0500
Message-ID: <20261107134954.555223452@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index be88e62075af6..605b847d87738 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -2511,6 +2511,7 @@ static int stm32_spi_probe(struct platform_device *pdev)
 					gen_pool_free(spi->sram_pool,
 						      (unsigned long)spi->sram_rx_buf,
 						      spi->sram_rx_buf_size);
+					spi->sram_rx_buf = NULL;
 					dev_warn(&pdev->dev,
 						 "failed to request rx mdma channel, DMA only\n");
 				}
@@ -2548,7 +2549,7 @@ static int stm32_spi_probe(struct platform_device *pdev)
 	if (spi->mdma_rx)
 		dma_release_channel(spi->mdma_rx);
 err_pool_free:
-	if (spi->sram_pool)
+	if (spi->sram_rx_buf)
 		gen_pool_free(spi->sram_pool, (unsigned long)spi->sram_rx_buf,
 			      spi->sram_rx_buf_size);
 	if (spi->dma_rx)
-- 
2.53.0



