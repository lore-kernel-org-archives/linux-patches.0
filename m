Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFD73FF1DF;
	Fri, 15 May 2026 15:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860271; cv=none; b=gN1exDT7+EF9uwgPCvrVPzYXUZZORclknNPb+9700Lam4Ye6zUHVWhdp1/wp1SEJUBUJ9mPitvUSRaIoVyFMdeil/qqI5ziT6fX6tBbjYYCjRdLlYonrESrdddhIxFTc7oZ42HHMk65u/j2UQLxKGU0kDtQn1AiCJDH2TdU6XR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860271; c=relaxed/simple;
	bh=Xbmy9MykpMQYzxwut0y0QPSdDNi0A38fsMzhZJ7z+UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFM5mKfcUWfyolT2WCup8QavTjvjw+3NzCul0zSPlo60BTvx8/CPT8GHhvhSDdreTvfKhGTzOXG48TmRIl2bSfR/38E1whbbchn451ogcg8j1qJqBJbnPZqsLe5SxRBjeQUsa9h3qBY2ixPs3emW++kD0/maMySQY+Of/blyAfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1B7diAOL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1B7diAOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79DE6C2BCB3;
	Fri, 15 May 2026 15:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860270;
	bh=Xbmy9MykpMQYzxwut0y0QPSdDNi0A38fsMzhZJ7z+UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1B7diAOLagMbHUGAxvcE2oeXMKjAcVN06co3LXkzFw2XPXrG0b5yWuNEXKXqiEy6M
	 aK29STpyt0d652KJ+tNAB3HarC75VGlKqwOuDib6oVyGeCrnBCS0bcbLMVWnpesr0e
	 JYiz/yfrnUrPqs+ns6WnBDJ3vj7LU1quV0CsjaA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 025/144] spi: meson-spicc: fix controller deregistration
Date: Fri, 15 May 2026 17:47:31 +0200
Message-ID: <20260515154654.088791945@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -883,7 +883,7 @@ static int meson_spicc_probe(struct plat
 		}
 	}
 
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret) {
 		dev_err(&pdev->dev, "spi registration failed\n");
 		goto out_host;
@@ -901,8 +901,14 @@ static void meson_spicc_remove(struct pl
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


