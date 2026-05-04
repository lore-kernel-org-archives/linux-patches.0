Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B931ADC83;
	Mon,  4 May 2026 14:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903722; cv=none; b=oDJ4F7/souJWW4F81SEVogb0hytGdQf6y5N+j0ubG2Y51qZmq/UyfpnJwFDMjdFw9qWg17+QIUD6sVqBHsAPTrYPl2klgo0NZtr/bELaQAFrD2XO/XwWXWEJrT0VZrTsjf3zEpueYpK8O5lhwv7xotd0Vlnn5pY2XXc3YFnIY5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903722; c=relaxed/simple;
	bh=LYr9vpALDQtLyMx8ZUC39r+IGlCsYLmDXvpDSTCE8io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9mhAfiBuXimJMjUvLKFH8uHLjH33yF+BdI5yHtdCMgBWVM1dT0DYMXT+TexGAYHD+tsTp3n17jJ46yBGYXh93utDWOdhRNoqhj3J7cTVtnISY7weMvhIOetLuA1f1UfWFX9vRIPNdUDsLYlcGPemkGNWdQc3qTobnfSbs4jbJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wnvfbHUx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnvfbHUx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88956C2BCB8;
	Mon,  4 May 2026 14:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903721;
	bh=LYr9vpALDQtLyMx8ZUC39r+IGlCsYLmDXvpDSTCE8io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wnvfbHUxz4W5FMrWq+T5/h6a8v7BUQJRIM8/B2dnbsauqw6MKjyZ6NwvwzUUjbiU8
	 i8OM9v+DEPosb8oZbGKRresMkNsJ8nCORSR5JhuWmqC2JUdq2SzNO8HsUtUP8JXl+R
	 +JVkoufV9DJWumzHj9zJl3OutefHt2YRoE/fQ7m8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 036/275] spi: imx: fix use-after-free on unbind
Date: Mon,  4 May 2026 15:49:36 +0200
Message-ID: <20260504135144.279500037@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 1c78c2002380a1fe31bfb01a3d5f29809e55a096 upstream.

The SPI subsystem frees the controller and any subsystem allocated
driver data as part of deregistration (unless the allocation is device
managed).

Take another reference before deregistering the controller so that the
driver data is not freed until the driver is done with it.

Fixes: 307c897db762 ("spi: spi-imx: replace struct spi_imx_data::bitbang by pointer to struct spi_controller")
Cc: stable@vger.kernel.org	# 5.19
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260324082326.901043-2-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-imx.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1965,6 +1965,8 @@ static void spi_imx_remove(struct platfo
 	struct spi_imx_data *spi_imx = spi_controller_get_devdata(controller);
 	int ret;
 
+	spi_controller_get(controller);
+
 	spi_unregister_controller(controller);
 
 	ret = pm_runtime_get_sync(spi_imx->dev);
@@ -1978,6 +1980,8 @@ static void spi_imx_remove(struct platfo
 	pm_runtime_disable(spi_imx->dev);
 
 	spi_imx_sdma_exit(spi_imx);
+
+	spi_controller_put(controller);
 }
 
 static int spi_imx_runtime_resume(struct device *dev)


