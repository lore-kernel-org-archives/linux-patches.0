Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF6121883E;
	Tue, 29 Apr 2025 17:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946854; cv=none; b=c5R5ykw//Hx0EhQCNrMF7w0iH5kdXUSERunYMyabk9UyDTHYofv5kO/I7cBiU0x7uGjpZC7WfJOoHvpjp6QTdKdkGeS0V+nMJ/l1MuluacMYPSghUNdHrT530wI2USgxN7xP1NkhOO5SkMDWFAQOwBBXGunIWX879EMmU+2RBrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946854; c=relaxed/simple;
	bh=v7y6mo/fKM0RHzMB6Vqd0XE6BmfilyVZqhNdym6Apto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRYlNzIhdUcoiSXnAY2ey0yE7ssD25gpvc7uirE7KE0RbdbI4uB/eeVu3VuBIfnGUDAkc1p4Tb0o0qspE6e6c5GTMugDNyOr1Fsr8Xf9FMjuMbzupia+8xlt0NqeYN3CKvggyyhS3sgf4jhTGYC2gX4IkNjxvlbGLMhQY2gpb2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jHgTG4UR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jHgTG4UR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F15C4CEE3;
	Tue, 29 Apr 2025 17:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946854;
	bh=v7y6mo/fKM0RHzMB6Vqd0XE6BmfilyVZqhNdym6Apto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jHgTG4URETzVfeVn7eQiktiQgeTbe25dDGV4lz9XPKOk0aLPISjm+Lpf6MIZyQR7W
	 lkzwDjOcFPaavRFcuDT5I4oBqhlWXvXc5uw/rBmoohCiaVcw+q/RLx7Y5qdSHaFmew
	 SgvhKw9emqmk+m5QxBOm3umG8dBceLOX4jqmBQrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 5.10 090/286] gpio: zynq: Fix wakeup source leaks on device unbind
Date: Tue, 29 Apr 2025 18:39:54 +0200
Message-ID: <20250429161111.560693376@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1016,6 +1016,7 @@ static int zynq_gpio_remove(struct platf
 	ret = pm_runtime_get_sync(&pdev->dev);
 	if (ret < 0)
 		dev_warn(&pdev->dev, "pm_runtime_get_sync() Failed\n");
+	device_init_wakeup(&pdev->dev, 0);
 	gpiochip_remove(&gpio->chip);
 	clk_disable_unprepare(gpio->clk);
 	device_set_wakeup_capable(&pdev->dev, 0);


