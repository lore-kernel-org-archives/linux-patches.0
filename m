Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302E41A3178;
	Thu, 17 Apr 2025 18:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913622; cv=none; b=BG/kMLtEaQTnMm1qQNSzfMkmetcPpZJ9mdlRjkToERuWiIIZh4XEmIUzY5vbQ5OJ7obUiuv2cK/D/EpwVMe7xTVbybfEXavIxk45l9zfpyfb4UjuUc/kQSInu9Dv7Q9+UU9GqvsidgObuB1R4d/H05GNi47CelahzooVly3LpeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913622; c=relaxed/simple;
	bh=8oNytVVbWui8mYBuFYYnw5Ye4hn7ciu1ERfi0mrefM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=axnP5IhPlitXQpFX5JD3XDmLX0qVP3r1cjf5StJ8S3m0O3DBqGFze17kpz55A/Xl0unL3vvuzoagfWzu8S5s3QW1A/j4e9IRtCeHGgHXhX/h28ZVmSrFHThw0tJB1KOY+2xyhPbqM8kHatSFGHRM2Oj/yqBex5Laq/k72GZEMBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IaiZhCTX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IaiZhCTX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53847C4CEE4;
	Thu, 17 Apr 2025 18:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913621;
	bh=8oNytVVbWui8mYBuFYYnw5Ye4hn7ciu1ERfi0mrefM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IaiZhCTX3wQEUecrku4NZk1hFZhMS7H54IflYTtuHVCFXQkxk6JXk+xMhEbk3OFqG
	 Wi/xUkAv7Ivn87FhuazDmzTgCYlNjF0cLUIH0P6ErwecPGo5W8W5VhVB+e2bMFbxL/
	 TygcvTiA4LRDsRZhkOGRULPP4CJHMeWLCwIFQknc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.14 399/449] gpio: zynq: Fix wakeup source leaks on device unbind
Date: Thu, 17 Apr 2025 19:51:27 +0200
Message-ID: <20250417175134.329228820@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1011,6 +1011,7 @@ static void zynq_gpio_remove(struct plat
 	ret = pm_runtime_get_sync(&pdev->dev);
 	if (ret < 0)
 		dev_warn(&pdev->dev, "pm_runtime_get_sync() Failed\n");
+	device_init_wakeup(&pdev->dev, 0);
 	gpiochip_remove(&gpio->chip);
 	device_set_wakeup_capable(&pdev->dev, 0);
 	pm_runtime_disable(&pdev->dev);


