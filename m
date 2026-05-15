Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC563F927B;
	Fri, 15 May 2026 16:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862443; cv=none; b=LPgMsfuPqYq4DDUSkIwwtmhkDm2lS6s0IdNnuj1tKR43pZ7oRV86AsBdk1bZmcZwmX27wZzleVoT8K+TsS0Je3z1eGHDGcssZKhMGbftJsII021UG7INchSDw00oCNOxWR5TKYNcDEPv4weRepscqZKnXfsrhbo6uTVOj2yM4Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862443; c=relaxed/simple;
	bh=qAEcn+T07j6w5GBKqPPiV/VSBrOYR8J2B/VQn4J4Yrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMpEshY3budP5tm3LUOqViStOryptkxlwASCMjtVFH75quV8cuOJ+s1xzvPQgGyxfE0xEACBePh8VnOmIm//KoY32SHN5Z4xF5/mex23FOf1gcGP265oDiphRV6GIZEFKz6fXn0u0kw3F+7EOwi4S8jlyMx8LUqy7h5mbWiYEns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EliuyFg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EliuyFg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8C3C2BCB0;
	Fri, 15 May 2026 16:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862443;
	bh=qAEcn+T07j6w5GBKqPPiV/VSBrOYR8J2B/VQn4J4Yrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EliuyFg1tqJuqA+LynxzPDU4tofGuBFuJzSWxPS/Rg5We7zZ1bGi7uO3931XTCDP3
	 47rp+difInWLUqlwQRd15eLfkKMjfoCPUaGTOY66g786jS+ZSjoyQfDAKBQl+hQ42C
	 MtAcYETxxvZSqRTGTM37UXT/jLQ4Lnpofm4SQi0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 051/201] spi: meson-spicc: fix controller deregistration
Date: Fri, 15 May 2026 17:47:49 +0200
Message-ID: <20260515154659.640560131@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 77953c76bec9af4191f8692a10225dd816208718 upstream.

Make sure to deregister the controller before disabling it to allow SPI
device drivers to do I/O during deregistration.

Fixes: 454fa271bc4e ("spi: Add Meson SPICC driver")
Cc: stable@vger.kernel.org	# 4.13
Cc: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260409120419.388546-18-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-meson-spicc.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-meson-spicc.c
+++ b/drivers/spi/spi-meson-spicc.c
@@ -1081,7 +1081,7 @@ static int meson_spicc_probe(struct plat
 		}
 	}
 
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret) {
 		dev_err(&pdev->dev, "spi registration failed\n");
 		goto out_host;
@@ -1099,8 +1099,14 @@ static void meson_spicc_remove(struct pl
 {
 	struct meson_spicc_device *spicc = platform_get_drvdata(pdev);
 
+	spi_controller_get(spicc->host);
+
+	spi_unregister_controller(spicc->host);
+
 	/* Disable SPI */
 	writel(0, spicc->base + SPICC_CONREG);
+
+	spi_controller_put(spicc->host);
 }
 
 static const struct meson_spicc_data meson_spicc_gx_data = {


