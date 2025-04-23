Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B001C2BE7A8;
	Wed, 23 Apr 2025 15:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421721; cv=none; b=fgDkhFQNE4xn8Twwy9QZiJKcroxy9AyALlhLHcRufk9Sin05jfNMAERo2AHa1D4Auu4PW3BLVp/hTTjtCl3IQ16r6QB2GKqrN9D8D3uroHHMsnW+/yf4kwcCBNa8aMN3BccL36baXibKWbiaeTABomEjrkZ10ZRZg34ZdKNJ+Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421721; c=relaxed/simple;
	bh=lEg3w+OwJ7iE/E49YbjrdACZjDFDCJPYNIf7bTvR7nI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G4aVl/+YOP0cN0OcBo6tmLJWylk/gAgTyNEK702ZF1HX7Ag3jZeKwYTicaM7ayNxm7Ml90mReoENsC5exYqDEdbYJey+YP1m+ecoHFVdOwNkj+ZrE6P/h+tNVw/GixrtsEjktOIcEWH+Y9bMd4UhFo587+yb3qNvj0ZXWtEWZq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l133+ulF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l133+ulF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA16C4CEE2;
	Wed, 23 Apr 2025 15:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421721;
	bh=lEg3w+OwJ7iE/E49YbjrdACZjDFDCJPYNIf7bTvR7nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l133+ulFnR51pEimhcFdm4Gq1ZXILie7LOpkqlCuA2iO9QLZWsssZDMcZ3uAQOA6C
	 ncf5a9dx9DtqJIUpbbwZKlzT7bl8W5Vri4BLR0+mlaut1nNfkHGXKc0CLHgPnLqyzg
	 hy15da/5yv4txmRT8QOfTKRCv2HG905uLbdyJNA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.6 216/393] gpio: zynq: Fix wakeup source leaks on device unbind
Date: Wed, 23 Apr 2025 16:41:52 +0200
Message-ID: <20250423142652.302159070@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit c5672e310ad971d408752fce7596ed27adc6008f upstream.

Device can be unbound, so driver must also release memory for the wakeup
source.

Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250406202245.53854-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-zynq.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpio/gpio-zynq.c
+++ b/drivers/gpio/gpio-zynq.c
@@ -1018,6 +1018,7 @@ static int zynq_gpio_remove(struct platf
 	ret = pm_runtime_get_sync(&pdev->dev);
 	if (ret < 0)
 		dev_warn(&pdev->dev, "pm_runtime_get_sync() Failed\n");
+	device_init_wakeup(&pdev->dev, 0);
 	gpiochip_remove(&gpio->chip);
 	clk_disable_unprepare(gpio->clk);
 	device_set_wakeup_capable(&pdev->dev, 0);


