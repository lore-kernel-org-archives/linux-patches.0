Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E862949E0;
	Fri, 15 May 2026 16:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862580; cv=none; b=lAmy2DUDiakn7Wf1JXd4epGJ84kNjD6seJGo1PdKWfz1+P8HpwnxvOHrQJbqfZvoTdPifptcOlk7/b0MVzZF2QpexxAL8cXphRqx6C8oSswkYOWhkq3SGfM7be/kiLEbsx0B2M8Mjv/OhpH0L8+vcH9wxyMfQUnFYdHtKiYHtZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862580; c=relaxed/simple;
	bh=vC9T8qp7gmaM1PV2PJq78nfTgp/v20XxF2h7VIC6obc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kuuhi2yFJAbKI+zAnxU+1IbfxN76i7ZE2J8XCf7bPm1asdKvevMcw4chKJt5uEFhSuCOv5wUUUcoOV49H23CupmN8OZbRyIqNfToAboxXux78HaWUNFM5xae7usCAex/Lfgd55/OZk9mBGX1St3SdY/FQRzFlCGjXaUuzxhI/FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0w2YIAsk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0w2YIAsk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CADC2BCB0;
	Fri, 15 May 2026 16:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862580;
	bh=vC9T8qp7gmaM1PV2PJq78nfTgp/v20XxF2h7VIC6obc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0w2YIAskXhrnKvE8pWeuoKVHp49ycZ/hFpIVTB7OkEIsl/zkwPxMfHaoUTX1ToJ+l
	 /g/sKS6uKYSXKKn8U4lmJDjP42/yDCo8Qjza7sIbVSxYJC+Mgl+kZVy9ANvco9oAiD
	 RF6Fy+cfsUbQI7b42vwftDP9suZWZoZwXS+NPBqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 086/201] spi: s3c64xx: fix controller deregistration
Date: Fri, 15 May 2026 17:48:24 +0200
Message-ID: <20260515154700.394404266@linuxfoundation.org>
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
@@ -1369,7 +1369,7 @@ static int s3c64xx_spi_probe(struct plat
 	       S3C64XX_SPI_INT_TX_OVERRUN_EN | S3C64XX_SPI_INT_TX_UNDERRUN_EN,
 	       sdd->regs + S3C64XX_SPI_INT_EN);
 
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "cannot register SPI host: %d\n", ret);
 		goto err_pm_put;
@@ -1399,6 +1399,8 @@ static void s3c64xx_spi_remove(struct pl
 
 	pm_runtime_get_sync(&pdev->dev);
 
+	spi_unregister_controller(host);
+
 	writel(0, sdd->regs + S3C64XX_SPI_INT_EN);
 
 	pm_runtime_put_noidle(&pdev->dev);


