Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D2B4963B0;
	Fri, 15 May 2026 16:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861426; cv=none; b=CjfK7o/qSBVhWPx6oarIQ9w+ceMO4VxYAXT8jOLJV8sKJAVZC5fv0sHi6ebX0YI3lzqODdUXX3+uS3adWwItbeB49jfV+iAyU6vNBH2Pcpj4E0DGb4TFPpEnRnQmXbukT6PzEX1CN2RMPFC1unA2zrVUVzrSOgU/SCOboK3cJNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861426; c=relaxed/simple;
	bh=ussBQraCDdTwN1BxcTR4qz+6yx6co/HuhCWfS6cNW5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mT9/2Dp7bhYeCoq3tBRgltbY6S0jgsZpbRaKKQ01lOcodGVnDqMYrv0Y8j8kzWuhXrX+2cknAZ78/mgs9zSZkFoILT+IlZh7OeY7CT1KzAbIlJLg3DZhLHScb89Sa9U6sp7sBo7ScYNvdZq8fYyTZxNiPApCGq+1Ognj9mj7ILQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=czqIbbix; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="czqIbbix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB91C2BCB0;
	Fri, 15 May 2026 16:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861426;
	bh=ussBQraCDdTwN1BxcTR4qz+6yx6co/HuhCWfS6cNW5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=czqIbbixEo0YyBvEqWwFCmxo6gTGKujI99aSfEccXvLpdPnASJBl/aUiU3LMLnO5I
	 yWZvwCF2ibJwZG6Q/Vc5AP2Oe6uI+ymUOj7365+zhNkJw3UJLzPdNYqmZUYHVQQ0Jf
	 /jUxm+JyYaJY2pogU4HtJvthHiXL0wSr0az8kC9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 323/474] spi: s3c64xx: fix controller deregistration
Date: Fri, 15 May 2026 17:47:12 +0200
Message-ID: <20260515154721.998757460@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1305,7 +1305,7 @@ static int s3c64xx_spi_probe(struct plat
 	       S3C64XX_SPI_INT_TX_OVERRUN_EN | S3C64XX_SPI_INT_TX_UNDERRUN_EN,
 	       sdd->regs + S3C64XX_SPI_INT_EN);
 
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "cannot register SPI host: %d\n", ret);
 		goto err_pm_put;
@@ -1336,6 +1336,8 @@ static void s3c64xx_spi_remove(struct pl
 
 	pm_runtime_get_sync(&pdev->dev);
 
+	spi_unregister_controller(host);
+
 	writel(0, sdd->regs + S3C64XX_SPI_INT_EN);
 
 	pm_runtime_put_noidle(&pdev->dev);


