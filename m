Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BC93F9271;
	Fri, 15 May 2026 16:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862062; cv=none; b=jLFFpG6IsdA7pn0D7UEaQNUbtL26js8FA1lP0jHfMakqmcRKfMpjmQGnBa2krfra+4M3FIzT3VtR74wtXDoN8OlhOGSssF90NwnJJ4cmZYRBCptoGAUbzaFF2iDToLcg7J3bcHuvjyqUuWRIYp5cdN7+uPHjwE/Bta7wEF+8rVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862062; c=relaxed/simple;
	bh=MT02EWYv4a99G9Nw3Cxw17yrJwK3MVjlsx0PlZVHCG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lXMDNuui8g0r72oKoMPXsgwdR/D/kZ7B0sO9q5B493qiLUEjB1u2dx5JUF6gvgHsryWVPv7a+8a587b2AOEOD9VIV8GbLZxWlGvgzFv9Gi5NJvlr/sHyDS9WjFaU2N2tFql1rh6myx1ks10fjWLASCfh/aSbExyEY7/ZhPm5O3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CY83a/P2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CY83a/P2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D286C2BCC9;
	Fri, 15 May 2026 16:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862061;
	bh=MT02EWYv4a99G9Nw3Cxw17yrJwK3MVjlsx0PlZVHCG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CY83a/P2HbSyVu4rv6Ct4rrcEYP7UzpuU2+lJP5+yykEvT6TDqwVV47UicacHnrfR
	 5ZpO1oHvtvPyza/CpeC2L6lY3g8Z72MjaW5pLwsuS0+Iu/HwanB0fskFn5EH3gt18B
	 sQImu1H+2fU7vEULwdT8UucC8ZIcull60IBLHY/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 066/188] spi: s3c64xx: fix controller deregistration
Date: Fri, 15 May 2026 17:48:03 +0200
Message-ID: <20260515154658.747635649@linuxfoundation.org>
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

commit c1446b61e472da24d1547525193467b4bea4a7cb upstream.

Make sure to deregister the controller before releasing underlying
resources like DMA during driver unbind.

Fixes: 91800f0e9005 ("spi/s3c64xx: Use managed registration")
Cc: stable@vger.kernel.org	# 3.13: 76fbad410c0f
Cc: stable@vger.kernel.org	# 3.13
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-12-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-s3c64xx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -1370,7 +1370,7 @@ static int s3c64xx_spi_probe(struct plat
 	       S3C64XX_SPI_INT_TX_OVERRUN_EN | S3C64XX_SPI_INT_TX_UNDERRUN_EN,
 	       sdd->regs + S3C64XX_SPI_INT_EN);
 
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "cannot register SPI host: %d\n", ret);
 		goto err_pm_put;
@@ -1400,6 +1400,8 @@ static void s3c64xx_spi_remove(struct pl
 
 	pm_runtime_get_sync(&pdev->dev);
 
+	spi_unregister_controller(host);
+
 	writel(0, sdd->regs + S3C64XX_SPI_INT_EN);
 
 	pm_runtime_put_noidle(&pdev->dev);


