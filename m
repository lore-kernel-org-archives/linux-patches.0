Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED041B3934;
	Thu, 17 Apr 2025 18:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916093; cv=none; b=S7/+e2UGQJNHyhX0WIPcnhOTiKmyVl5f2i5ENFaCeJaZLfyBS8CcRT3KDwnN8ge20uMEmgUfOWyi4e0bprWBM8/M9ejk69ticva2bG6nvxNIi57otsu/rWUpXem0OjbxMnLjTYz58V4Zo0CG3Dl9F9TNGWExCfN21sIEaEHENbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916093; c=relaxed/simple;
	bh=508ElVOVL/lonoUm5hQ93h74khxjgqZJh9o0N9+BYGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uzI8JaCAOhrrJcnm3gTeuc9j81xxS5DRUrbSidRiuuJPoli4POLPgOvWNg+B/gfZbEjPYNrDwoywvNnX3OlDHS2bRugKfcI+Gfi9QiG5K1A2J2HVRKsKnyZBVUBxxRFo2k5mHP4tcwfOs/ZaObNtEo1MChRcTTeMyTziTC7Rq6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t0wXtFsl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t0wXtFsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF85AC4CEF0;
	Thu, 17 Apr 2025 18:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916093;
	bh=508ElVOVL/lonoUm5hQ93h74khxjgqZJh9o0N9+BYGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t0wXtFslvEdiTFR0tZEZqlEV6dM08pfiVEinTBLbmC1i9RvBbMT71j1f9e0/lWjJe
	 hn+WBcwrV3OZ3p5UJoQjt7txxP9RB8x6YWQFXDccS5JT6MaGdL362Cql5p2NjBU9LC
	 DGPl0fSvokM8l2qOhUzGknMFT1cCltQyUZ0QCZWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.12 340/393] gpio: zynq: Fix wakeup source leaks on device unbind
Date: Thu, 17 Apr 2025 19:52:29 +0200
Message-ID: <20250417175121.270387742@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


