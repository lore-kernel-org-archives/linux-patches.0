Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDC43FF1A2;
	Fri, 15 May 2026 15:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860307; cv=none; b=poEIbdhHNrtrcwfclBaQ0sau8bq856RcyosI4ADsTILdMU/HFO8hlEX6x61AJ53ZymUTKRmcICvEC3QzQHTAUledf6Hr5cuuS2L2pd3pJotqYAVSUg7uknEbjOCCOpzSRO86gK4lcnQKyDw7pCnLmyKKJAeeDimddq+EbboNoGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860307; c=relaxed/simple;
	bh=xscvDLDx1UbrIlCFEyO/yzFSEa/Qgksyebc6ShcP7iE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NPzuGXhwnoBxua+HIWV6WkYc0uNCBRNVxo8tJA9OrcbBGX4fO/adytquPlVdPOMPwkGVAZUXH5LyTYaCi73hch9IVv0Za8AhELtZmt/6G5PFUW7ZXFSXhjlCC3PmpbLJ8W18vLqLGcayB+M6f1CYjhwT4g048TSyQSDaXRY4LSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oBZ1OJwx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oBZ1OJwx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D00C2BCB0;
	Fri, 15 May 2026 15:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860306;
	bh=xscvDLDx1UbrIlCFEyO/yzFSEa/Qgksyebc6ShcP7iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oBZ1OJwx8XfrZRrqTIKsDNybfZrEqsacEPVLQAKqp7ggqv/wCcI0JEpxptuw0BRqJ
	 5uWWUYHAZPa6GWzgb1hqG8SFac91anJDnINIwOtn/Fl59hQrwaFhXLQCrTLHpIxG0f
	 cdww973RlkkIkJo8g57FMo8sBnZoMQJxRR9HME6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingoo Han <jg1.han@samsung.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 038/144] spi: mxs: fix controller deregistration
Date: Fri, 15 May 2026 17:47:44 +0200
Message-ID: <20260515154654.403376154@linuxfoundation.org>
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

commit 8b0d0011af20fb547aa67a1cefbf320992fd5e92 upstream.

Make sure to deregister the controller before releasing underlying
resources like DMA during driver unbind.

Fixes: 33e195acf268 ("spi: mxs: use devm_spi_register_master()")
Cc: stable@vger.kernel.org	# 3.13
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-4-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-mxs.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-mxs.c
+++ b/drivers/spi/spi-mxs.c
@@ -617,7 +617,7 @@ static int mxs_spi_probe(struct platform
 	if (ret)
 		goto out_pm_runtime_put;
 
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret) {
 		dev_err(&pdev->dev, "Cannot register SPI host, %d\n", ret);
 		goto out_pm_runtime_put;
@@ -648,11 +648,17 @@ static void mxs_spi_remove(struct platfo
 	spi = spi_controller_get_devdata(host);
 	ssp = &spi->ssp;
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	pm_runtime_disable(&pdev->dev);
 	if (!pm_runtime_status_suspended(&pdev->dev))
 		mxs_spi_runtime_suspend(&pdev->dev);
 
 	dma_release_channel(ssp->dmach);
+
+	spi_controller_put(host);
 }
 
 static struct platform_driver mxs_spi_driver = {


