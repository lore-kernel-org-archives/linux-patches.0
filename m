Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4F8126BFF;
	Thu,  3 Jul 2025 14:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554280; cv=none; b=siT3QIVkGEjtP0kCUN8gqyZP0u4vy7kK8ZWVT6F3kdUyIlqQ0t6au+ehXKEjo18h4mXcTIl7EXCEj90fnFx94oK0ChvWnwgCx838fkneSulK5lYk/9fkuEwprSHrOQQE+P3mtyU+q0vlQKYpYToUni62E2Cod/aaLa/7XmnFqao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554280; c=relaxed/simple;
	bh=irkSf+AfZXXGz3R7HDJM4HuPQnjwak3/BNrbzVAqj90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EH1qpIPc3eAl2FooRucl0IuuIM6nNE/rBmunJg98juFLTR9RsI77u3GFoKA/5hzo32pOTf2DZmpy44EwLkeY1kCI6D0+HwCZR+V80IH56H8NDDGaOUUtqXvTgB5Pade5mfhol70IiJGE/EkgJiEUhvFf2Gf2fBIPgumPQG1TMvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eKci1qNx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eKci1qNx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969D3C4CEE3;
	Thu,  3 Jul 2025 14:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554280;
	bh=irkSf+AfZXXGz3R7HDJM4HuPQnjwak3/BNrbzVAqj90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eKci1qNxsLjGGTEhEq2O7xUxIVmkn4Mp3vbJwEtT7EE+UK+OLd4TArwH71q14YO2U
	 lLda9olS3DncaXLxRkhRH9MT/JhUbsRszlQEwRitZJv5+yx7tXtP5lcF2ZwmTzNnJs
	 kpCak/lMHb7BWTYdTl6mtjFnKNIcTl7dAyrGKZAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Khairul Anuar Romli <khairul.anuar.romli@altera.com>,
	Matthew Gerlach <matthew.gerlach@altera.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 137/218] spi: spi-cadence-quadspi: Fix pm runtime unbalance
Date: Thu,  3 Jul 2025 16:41:25 +0200
Message-ID: <20250703144001.598233942@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Khairul Anuar Romli <khairul.anuar.romli@altera.com>

commit b07f349d1864abe29436f45e3047da2bdd476462 upstream.

Having PM put sync in remove function is causing PM underflow during
remove operation. This is caused by the function, runtime_pm_get_sync,
not being called anywhere during the op. Ensure that calls to
pm_runtime_enable()/pm_runtime_disable() and
pm_runtime_get_sync()/pm_runtime_put_sync() match.

echo 108d2000.spi > /sys/bus/platform/drivers/cadence-qspi/unbind
[   49.644256] Deleting MTD partitions on "108d2000.spi.0":
[   49.649575] Deleting u-boot MTD partition
[   49.684087] Deleting root MTD partition
[   49.724188] cadence-qspi 108d2000.spi: Runtime PM usage count underflow!

Continuous bind/unbind will result in an "Unbalanced pm_runtime_enable" error.
Subsequent unbind attempts will return a "No such device" error, while bind
attempts will return a "Resource temporarily unavailable" error.

[   47.592434] cadence-qspi 108d2000.spi: Runtime PM usage count underflow!
[   49.592233] cadence-qspi 108d2000.spi: detected FIFO depth (1024) different from config (128)
[   53.232309] cadence-qspi 108d2000.spi: Runtime PM usage count underflow!
[   55.828550] cadence-qspi 108d2000.spi: detected FIFO depth (1024) different from config (128)
[   57.940627] cadence-qspi 108d2000.spi: Runtime PM usage count underflow!
[   59.912490] cadence-qspi 108d2000.spi: detected FIFO depth (1024) different from config (128)
[   61.876243] cadence-qspi 108d2000.spi: Runtime PM usage count underflow!
[   61.883000] platform 108d2000.spi: Unbalanced pm_runtime_enable!
[  532.012270] cadence-qspi 108d2000.spi: probe with driver cadence-qspi failed1

Also, change clk_disable_unprepare() to clk_disable() since continuous
bind and unbind operations will trigger a warning indicating that the clock is
already unprepared.

Fixes: 4892b374c9b7 ("mtd: spi-nor: cadence-quadspi: Add runtime PM support")
cc: stable@vger.kernel.org # 6.6+
Signed-off-by: Khairul Anuar Romli <khairul.anuar.romli@altera.com>
Reviewed-by: Matthew Gerlach <matthew.gerlach@altera.com>
Link: https://patch.msgid.link/4e7a4b8aba300e629b45a04f90bddf665fbdb335.1749601877.git.khairul.anuar.romli@altera.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cadence-quadspi.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1929,10 +1929,10 @@ static int cqspi_probe(struct platform_d
 			goto probe_setup_failed;
 	}
 
-	ret = devm_pm_runtime_enable(dev);
-	if (ret) {
-		if (cqspi->rx_chan)
-			dma_release_channel(cqspi->rx_chan);
+	pm_runtime_enable(dev);
+
+	if (cqspi->rx_chan) {
+		dma_release_channel(cqspi->rx_chan);
 		goto probe_setup_failed;
 	}
 
@@ -1952,6 +1952,7 @@ static int cqspi_probe(struct platform_d
 	return 0;
 probe_setup_failed:
 	cqspi_controller_enable(cqspi, 0);
+	pm_runtime_disable(dev);
 probe_reset_failed:
 	if (cqspi->is_jh7110)
 		cqspi_jh7110_disable_clk(pdev, cqspi);
@@ -1970,7 +1971,8 @@ static void cqspi_remove(struct platform
 	if (cqspi->rx_chan)
 		dma_release_channel(cqspi->rx_chan);
 
-	clk_disable_unprepare(cqspi->clk);
+	if (pm_runtime_get_sync(&pdev->dev) >= 0)
+		clk_disable(cqspi->clk);
 
 	if (cqspi->is_jh7110)
 		cqspi_jh7110_disable_clk(pdev, cqspi);


