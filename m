Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A6835CBD7;
	Sat, 12 Sep 2026 14:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224094; cv=none; b=L4WJIr/YCRJgFenPbc5APja+nZBrkLBZg2lLmsXSuI4gFR/b/7vhIlX3PVakwLGcJ8GvvehpPdNC9LzUVA1cSLJ8cc8zzKPBl/zKaeD9AdW0SvcBhfzteqc50KMxNbE2YvLLgAgDgblXGMd1QetSZlyDt8PWGAeTPRQ8El6uaFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224094; c=relaxed/simple;
	bh=uqXUk/N3vNdTQN09ndcUSq7jxe9v4bTihC9ZKCyEsqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDrmCtcWPgYecyAIBt1o0G08NFNyqQhNDRokNy5GgSapTYAnym8gyUrwDt8vZMvVNutdFxIIEs4gTXDA3RvWGoyyjOOUViGhKnxCFH5NCm6p5RUldTiqGkhtJPU2MjERfoCuWwpjdSuQM98TGEVN195pRHeMeTcU0IJ4PmFswX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OAwF/nhe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OAwF/nhe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C1E1F00893;
	Sat, 12 Sep 2026 14:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224088;
	bh=qA8Pcw+RMW0Yh0RMwoCtQUATjYw1FWeVvq24BaXgT3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OAwF/nhelWfDjMo9Zyddwudxmx2vp+yx/YAsd4q/bkFwa1ADyMKL7Iya2kd/MsaCB
	 qiDfhRuk6wMZYHVnoCAkQq0OyLiTOTbhHPoIeaM6Cc83InVLgdqrn2kz2ozUmgQGye
	 NHsh0vlCifSrzzi+S1PFm3QWsnFQhC3KmHpjWNWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0923/1424] spi: davinci: switch to managed controller allocation
Date: Sat, 12 Sep 2026 08:55:55 +0200
Message-ID: <20260912065627.994080665@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit ea408a05dc8f18b4a184b88d6e19d2fd1acc1527 ]

The controller is allocated with the non-managed spi_alloc_host() while
the interrupt is registered with devm_request_threaded_irq().  During
removal, spi_bitbang_stop() only unregisters the controller; the
subsequent spi_controller_put() then frees the controller together with
its embedded davinci_spi devdata, which is the IRQ handler's dev_id.
The devm_request_threaded_irq() release action (free_irq()), which
drains the handler, does not run until after .remove() returns.  A late
or latched interrupt can therefore reach davinci_spi_irq() and
dereference already-freed memory.

Switch to devm_spi_alloc_host() so that the devres LIFO order releases
the controller only after free_irq() has drained the handler, and drop
the now-redundant spi_controller_put() from .remove().  The probe error
path is simplified to direct returns.

The clock is acquired with devm_clk_get_enabled(), which is registered
after the IRQ and thus released before it by the devres LIFO order.
Drain the interrupt explicitly with devm_free_irq() before disabling the
controller so that a late interrupt cannot access the registers of a
clock-gated controller.

This issue was found by an in-house static analysis tool.

Fixes: 5b3bb5963ff2 ("spi: davinci: Use devm_*() functions")
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260719010014.3163356-2-fanwu01@zju.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-davinci.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-davinci.c b/drivers/spi/spi-davinci.c
index 80c5c26f8d961..72f36ee4568b1 100644
--- a/drivers/spi/spi-davinci.c
+++ b/drivers/spi/spi-davinci.c
@@ -862,7 +862,7 @@ static int davinci_spi_probe(struct platform_device *pdev)
 	int ret = 0;
 	u32 spipc0;
 
-	host = spi_alloc_host(&pdev->dev, sizeof(struct davinci_spi));
+	host = devm_spi_alloc_host(&pdev->dev, sizeof(struct davinci_spi));
 	if (host == NULL) {
 		ret = -ENOMEM;
 		goto err;
@@ -992,7 +992,6 @@ static int davinci_spi_probe(struct platform_device *pdev)
 		dma_release_channel(dspi->dma_tx);
 	}
 free_host:
-	spi_controller_put(host);
 err:
 	return ret;
 }
@@ -1016,6 +1015,8 @@ static void davinci_spi_remove(struct platform_device *pdev)
 
 	spi_bitbang_stop(&dspi->bitbang);
 
+	devm_free_irq(&pdev->dev, dspi->irq, dspi);
+
 	/* This bit needs to be cleared to disable dpsi->clk */
 	clear_io_bits(dspi->base + SPIGCR1, SPIGCR1_POWERDOWN_MASK);
 
@@ -1023,8 +1024,6 @@ static void davinci_spi_remove(struct platform_device *pdev)
 		dma_release_channel(dspi->dma_rx);
 		dma_release_channel(dspi->dma_tx);
 	}
-
-	spi_controller_put(host);
 }
 
 static struct platform_driver davinci_spi_driver = {
-- 
2.53.0



