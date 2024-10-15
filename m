Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1291D4154;
	Tue, 15 Oct 2024 11:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992970; cv=none; b=O5panMHxgrv9JG8CbBA9rqqvaE0hqtfMUraNd0MkRm7nf9mIy75yIRmjtteP45YNfP5UzdIAqSU9O9DxphOlQlhMUiIK+tcAypOZJeSAcdLnSM0r1t86+pOpohvzym6fLc5V8KZv2P4PxRKLeAZOJqj/AU/Pu7mHJdN0fu1n14s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992970; c=relaxed/simple;
	bh=m2n91DoEkejaGnLYVPzy66nIWd2f/8jb3gQR96QKxDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFezKFlgYnz4X50aE02hLLKJ2k3NmmhsqMs7B1VQdHyTUwbayCa4CVbJexifNKcPFbdy0Dp7kPygrtDMH+C3raf7GQYKQ9Lh2dV0deFW9o3xU1oflrgRfWNBXInrYFMtzRcMDcZc/Ohqph5pk+pQxVOuMIximOg+ykJHtnTWKns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aSQiNlPf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aSQiNlPf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4989EC4CEC6;
	Tue, 15 Oct 2024 11:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992970;
	bh=m2n91DoEkejaGnLYVPzy66nIWd2f/8jb3gQR96QKxDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aSQiNlPflA9ba2mDJkuyY7tXRPFFPWANA9Key7eiF3zj0AlBytXs3taNly5EYZDku
	 Fw9NHW9DtRY2QELHKYlzv295Bj+vDDc42kdtKUMFBPyaIVngRt7pvETsuVKzn+Un/n
	 Okw/sxoq1pYOdSuu6OilcDnJaoTrabMHErj5sw9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 272/691] spi: lpspi: release requested DMA channels
Date: Tue, 15 Oct 2024 13:23:40 +0200
Message-ID: <20241015112451.142404569@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit f02bff30114f385d53ae3e45141db602923bca5d ]

The requested DMA channels are never released. Do this in .remove as well
as in .probe. spi_register_controller() can return -EPROBE_DEFER if
cs-gpios are not probed yet.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20211109103134.184216-1-alexander.stein@ew.tq-group.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 3b577de206d5 ("spi: spi-fsl-lpspi: Undo runtime PM changes at driver exit time")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index bc3e434ba2986..314629b172281 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -920,7 +920,7 @@ static int fsl_lpspi_probe(struct platform_device *pdev)
 	ret = devm_spi_register_controller(&pdev->dev, controller);
 	if (ret < 0) {
 		dev_err_probe(&pdev->dev, ret, "spi_register_controller error: %i\n", ret);
-		goto out_pm_get;
+		goto free_dma;
 	}
 
 	pm_runtime_mark_last_busy(fsl_lpspi->dev);
@@ -928,6 +928,8 @@ static int fsl_lpspi_probe(struct platform_device *pdev)
 
 	return 0;
 
+free_dma:
+	fsl_lpspi_dma_exit(controller);
 out_pm_get:
 	pm_runtime_dont_use_autosuspend(fsl_lpspi->dev);
 	pm_runtime_put_sync(fsl_lpspi->dev);
@@ -944,6 +946,8 @@ static int fsl_lpspi_remove(struct platform_device *pdev)
 	struct fsl_lpspi_data *fsl_lpspi =
 				spi_controller_get_devdata(controller);
 
+	fsl_lpspi_dma_exit(controller);
+
 	pm_runtime_disable(fsl_lpspi->dev);
 	return 0;
 }
-- 
2.43.0



