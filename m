Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1971AA793;
	Mon, 14 Oct 2024 14:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916653; cv=none; b=LaNyptFCL8I2GgCiEhWy2DO2lM5kwizKfhiNR++SoaW6Nk9gMK8Cv4lPKdjAaQ0Q+Nc1MsVOqa+lExBu1Q6LNJqj4QA6grnu1aHDVRNim7q66RnFhM2UlEYETO7OHcVwqioisYbEiob+UXseO0z8+vzu9axxwroXfT6lGQuWJpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916653; c=relaxed/simple;
	bh=pB6cKZEmWPj2/FyBhoI1/UYNDsocjZmh8Jdmt9qsNCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mhUYh10v/n5jzSexCXy+ShiNUvvs2bUlnOiOK1dOQLAvPLhx+pGAynHI3x1lJTZr3s10G3wgIOLMC6GAF6FMy2KWF6VMc3gRivmLfC13ltC/w6spYxaoLaYnqwhWJRtKt0XX8ITgnw+KW/6B4vK8YUxSOZsJgDqMik0fvpcBx4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DxtHoDnU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DxtHoDnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E1EC4CEC3;
	Mon, 14 Oct 2024 14:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916653;
	bh=pB6cKZEmWPj2/FyBhoI1/UYNDsocjZmh8Jdmt9qsNCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DxtHoDnUPjjT3YoQcvjHiKr4L0yYlD1KBvZVtkf4rIhnMJDwkPjjYIDLh/RdDh2yt
	 cl24mTNtIzgGjSU7IFIGUZlkevAaS3IEU6mva1N0hRc14RcD5w/X4vbmlgf7aVeYQy
	 1Uu/8edlFn99w/o1hIsH7lBZmdhZuzbyNxc6WUMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/213] spi: spi-fsl-lpspi: remove redundant spi_controller_put call
Date: Mon, 14 Oct 2024 16:18:53 +0200
Message-ID: <20241014141044.046357060@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Song <carlos.song@nxp.com>

[ Upstream commit bff892acf79cec531da6cb21c50980a584ce1476 ]

devm_spi_alloc_controller will allocate an SPI controller and
automatically release a reference on it when dev is unbound from
its driver. It doesn't need to call spi_controller_put explicitly
to put the reference when lpspi driver failed initialization.

Fixes: 2ae0ab0143fc ("spi: lpspi: Avoid potential use-after-free in probe()")
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Reviewed-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Link: https://msgid.link/r/20240403084029.2000544-1-carlos.song@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index 180cea7d38172..13313f07839b6 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -881,39 +881,39 @@ static int fsl_lpspi_probe(struct platform_device *pdev)
 	fsl_lpspi->base = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (IS_ERR(fsl_lpspi->base)) {
 		ret = PTR_ERR(fsl_lpspi->base);
-		goto out_controller_put;
+		return ret;
 	}
 	fsl_lpspi->base_phys = res->start;
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
 		ret = irq;
-		goto out_controller_put;
+		return ret;
 	}
 
 	ret = devm_request_irq(&pdev->dev, irq, fsl_lpspi_isr, 0,
 			       dev_name(&pdev->dev), fsl_lpspi);
 	if (ret) {
 		dev_err(&pdev->dev, "can't get irq%d: %d\n", irq, ret);
-		goto out_controller_put;
+		return ret;
 	}
 
 	fsl_lpspi->clk_per = devm_clk_get(&pdev->dev, "per");
 	if (IS_ERR(fsl_lpspi->clk_per)) {
 		ret = PTR_ERR(fsl_lpspi->clk_per);
-		goto out_controller_put;
+		return ret;
 	}
 
 	fsl_lpspi->clk_ipg = devm_clk_get(&pdev->dev, "ipg");
 	if (IS_ERR(fsl_lpspi->clk_ipg)) {
 		ret = PTR_ERR(fsl_lpspi->clk_ipg);
-		goto out_controller_put;
+		return ret;
 	}
 
 	/* enable the clock */
 	ret = fsl_lpspi_init_rpm(fsl_lpspi);
 	if (ret)
-		goto out_controller_put;
+		return ret;
 
 	ret = pm_runtime_get_sync(fsl_lpspi->dev);
 	if (ret < 0) {
@@ -974,8 +974,6 @@ static int fsl_lpspi_probe(struct platform_device *pdev)
 	pm_runtime_dont_use_autosuspend(fsl_lpspi->dev);
 	pm_runtime_put_sync(fsl_lpspi->dev);
 	pm_runtime_disable(fsl_lpspi->dev);
-out_controller_put:
-	spi_controller_put(controller);
 
 	return ret;
 }
-- 
2.43.0



