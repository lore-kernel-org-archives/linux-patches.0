Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089ED36124;
	Wed, 30 Jul 2025 09:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868476; cv=none; b=bkWMRy5zrfy0El76bzioWliwxArlUsToVZDIXNENSGrw68U70nDD4vuDH1/T0josWz2FvJXMEEbOaGEMVK928lgRMfz5F36Fxov7huI3dJN5SGV1cG9jLvNA9cPuv72yZCx+IvOmpYehjfh626qGf2cZfV6oK+YB1uzv5FFUMzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868476; c=relaxed/simple;
	bh=7aEnrgzJaBZ8Yb976yP9ut0Shck1wGy19paUE2iJa2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jVlKwBGLZjzBkd8A12DM7UmpNe8+MwsboLWqTfNintZNfA+2MMztP6BJB+8q3kvcBPmoT980sl67bDdur1lVll10iesh77XADtj1wx3OLNt1niizKRxhOyQAWd78eAqLJJ8F+5iIwEIhgWeCM8gGy2sdGJvkCwv1MvPsyRPwk4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjT1GW5w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjT1GW5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC14C4CEF5;
	Wed, 30 Jul 2025 09:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868475;
	bh=7aEnrgzJaBZ8Yb976yP9ut0Shck1wGy19paUE2iJa2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjT1GW5w/0PRowhgiCknJn85OfC1bwhw+ARqvlNLmIXF6GQaYPRTBho+W+BzPEjMQ
	 L01cRwmBb852w/fDI6X0nwQAQJkvFRc0RW9g4RGtFMK8JwYrxaHZgT/j57+Ouz01/u
	 IieEMCDRUhLXdr/9Co3glNIeo/USUlTKh9qguiJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Khairul Anuar Romli <khairul.anuar.romli@altera.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Ronald Wahl <ronald.wahl@legrand.com>
Subject: [PATCH 6.6 75/76] spi: cadence-quadspi: fix cleanup of rx_chan on failure paths
Date: Wed, 30 Jul 2025 11:36:08 +0200
Message-ID: <20250730093229.770650564@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Khairul Anuar Romli <khairul.anuar.romli@altera.com>

commit 04a8ff1bc3514808481ddebd454342ad902a3f60 upstream.

Remove incorrect checks on cqspi->rx_chan that cause driver breakage
during failure cleanup. Ensure proper resource freeing on the success
path when operating in cqspi->use_direct_mode, preventing leaks and
improving stability.

Signed-off-by: Khairul Anuar Romli <khairul.anuar.romli@altera.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/89765a2b94f047ded4f14babaefb7ef92ba07cb2.1751274389.git.khairul.anuar.romli@altera.com
Signed-off-by: Mark Brown <broonie@kernel.org>
[Minor conflict resolved due to code context change.]
Signed-off-by: Ronald Wahl <ronald.wahl@legrand.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cadence-quadspi.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1870,11 +1870,6 @@ static int cqspi_probe(struct platform_d
 
 	pm_runtime_enable(dev);
 
-	if (cqspi->rx_chan) {
-		dma_release_channel(cqspi->rx_chan);
-		goto probe_setup_failed;
-	}
-
 	ret = spi_register_controller(host);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register SPI ctlr %d\n", ret);


