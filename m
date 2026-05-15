Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1332609EE;
	Fri, 15 May 2026 16:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862028; cv=none; b=jLpPxIGCVNrpL1UGVlA3nJIaP0NXUR5+gJKJb8o5wmfxlwM1uEcFPpxlTm7mgTSTfwRphAKCla6+HzJ72t2j05nC/hG3BEQ+ZkAEpqhkcTcJAi8mYPulS46k3cM2pKzYHf3dvc117lAQ/vLMRLucr258cVHe8RWER34sg/6O/9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862028; c=relaxed/simple;
	bh=+YaCQQ2YP6UCTX0GA7iQX4Y+hYPG2SA0UvspnngKhw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djO+PcZWk5LAxol7OrvKBhE+iw1q71pjkWcKttf3NRcMcv9A7ji09yAblZP25fN9iM0W+vN3eVpLw/6gphR2WD/qAx9v+HEoFAFldeoEWmKlwXfSYY1K4RRHpEYZGuWdjqz66VDFpp5cso29rnzOu54BcixJ4pbryVKLoRou2ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I8L727f4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I8L727f4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A34C2BCB0;
	Fri, 15 May 2026 16:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862028;
	bh=+YaCQQ2YP6UCTX0GA7iQX4Y+hYPG2SA0UvspnngKhw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I8L727f4wxc7HUlMq+5Ep9I5hMl2oIGl20zxn0BjyhYwLC49PICpSkpCTcCnTuJh4
	 UwDXFHdgmPW0+/l0eu/UPFuCJk2xH7YubKkpzAvTcyAEcWvdbpZMn3FJPWcWnvV+wO
	 6kUOVsdWgGb568mRLQUqpiNxS/o7d2JG1NWiTaqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingoo Han <jg1.han@samsung.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 081/188] spi: rspi: fix controller deregistration
Date: Fri, 15 May 2026 17:48:18 +0200
Message-ID: <20260515154659.077153839@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

commit 9944fa6726afb1e6eb7e2212764e7da0c97f2dcc upstream.

Make sure to deregister the controller before releasing underlying
resources like DMA during driver unbind.

Fixes: 9e03d05eee4c ("spi: rcar: Use devm_spi_register_master()")
Cc: stable@vger.kernel.org	# 3.14
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-11-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-rspi.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -1171,8 +1171,14 @@ static void rspi_remove(struct platform_
 {
 	struct rspi_data *rspi = platform_get_drvdata(pdev);
 
+	spi_controller_get(rspi->ctlr);
+
+	spi_unregister_controller(rspi->ctlr);
+
 	rspi_release_dma(rspi->ctlr);
 	pm_runtime_disable(&pdev->dev);
+
+	spi_controller_put(rspi->ctlr);
 }
 
 static const struct spi_ops rspi_ops = {
@@ -1377,9 +1383,9 @@ static int rspi_probe(struct platform_de
 	if (ret < 0)
 		dev_warn(&pdev->dev, "DMA not available, using PIO\n");
 
-	ret = devm_spi_register_controller(&pdev->dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	if (ret < 0) {
-		dev_err(&pdev->dev, "devm_spi_register_controller error.\n");
+		dev_err(&pdev->dev, "failed to register controller\n");
 		goto error3;
 	}
 


