Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E3D24113C;
	Tue, 29 Apr 2025 16:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945322; cv=none; b=MA95Cdqls6iTQz4aZ6LACYCy46v1C3hSXjo8JWovIaE2Xa9uvXSWRftuQxxFvnQexpnecgJYa7jtyfDpQlmd3Y0Hv7MQudgIRPa0Ca8JuuoBPCAY1epOxUC7cWkR/osj5+pDPeFDwNPZFPBz57fv/kGhegyPRxrsqpsjZGEQFt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945322; c=relaxed/simple;
	bh=7ZrOzoZ4LDhb5kDrTAdOUEJ7NimO1uwk4zbgsU/hw4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDxttxD761DbBw7gnLCfCCG50b322b1cxyPhYRb0s+Ku1k0iT4rRnl8BQXl+fC7zOUC0djqVtwGnA/LwCkvyvRCiJr7Fq2MkzfC6gDG9i1rPK/nJo/iL6Q5rMfOikfo73CCRfQKpcAXYptLqgyfC9+MKQ/a87hv37z2UTwT6wIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hvf7B9Ax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hvf7B9Ax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA00C4CEE3;
	Tue, 29 Apr 2025 16:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945321;
	bh=7ZrOzoZ4LDhb5kDrTAdOUEJ7NimO1uwk4zbgsU/hw4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hvf7B9Ax7KFXDw4BU5S4W2fPrOpPd1SVZzlHadUp6bZxbaYDCPZxe0j+aUPLm5Q4C
	 R9Uf2i5UMgOX3wYl7aQNM9EvZvv7a1RARh7lfqz+uruKpVEo5ZPWKlHfa4+7gL9WJ1
	 a+aXk0u8pMqDIj42pQRdcyoYVkeghjFdKcpBakAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 5.4 073/179] gpio: zynq: Fix wakeup source leaks on device unbind
Date: Tue, 29 Apr 2025 18:40:14 +0200
Message-ID: <20250429161052.368991534@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -943,6 +943,7 @@ static int zynq_gpio_remove(struct platf
 	ret = pm_runtime_get_sync(&pdev->dev);
 	if (ret < 0)
 		dev_warn(&pdev->dev, "pm_runtime_get_sync() Failed\n");
+	device_init_wakeup(&pdev->dev, 0);
 	gpiochip_remove(&gpio->chip);
 	clk_disable_unprepare(gpio->clk);
 	device_set_wakeup_capable(&pdev->dev, 0);


