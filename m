Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEB04315A;
	Mon, 23 Jun 2025 21:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714956; cv=none; b=kTm12WWoE+6uYvKVHbbY6ZX7ts3SFm6xnAwGBFXQI3ZdQzMGpcQEx4YDqo6GgIh097zPjEJ+OCxGNFhv2cloualB+PKu8AUKEruqEd9gGzEzP4xbg1+4DlHNQryEOs65Mfvy712B8coXd9hL7dGs7Nuo2Rqb0attxfiJrhtm/yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714956; c=relaxed/simple;
	bh=HSYl8KdX06hzaijzNHQPYJTm8tOvYmXREmZzJs+Zzus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hmbul9snY+0diPohtfBrr4g/8MzqipTgafgXRtKeOscWKEFpeXxw98pR2OOLgxakYFU0NX6Yo8Ryw99B0Ze/jzwUaeio0xVKzLMJHPsHN1xv9eHaiH07RSa4LuTwk5k3yR72C43pe08LGqMSmeQHmJBPGhB6EZhahdglm+4Lc3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EV1a10eT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EV1a10eT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D47C4CEEA;
	Mon, 23 Jun 2025 21:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714955;
	bh=HSYl8KdX06hzaijzNHQPYJTm8tOvYmXREmZzJs+Zzus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EV1a10eTf59EyfBDbomiGHeCrScOlx5gVHYOVD6CF7rgxCvPFP63EhauYWFzBtS1M
	 hf/tohnlGVOKUjANbEocoXtGweKnX+EcwSvOX0Q8u2O72gznDm1EcoAx32vRjxqDCj
	 spdj008gCGwM8Ki6MDvwRQ15/VDNixLSKsLkX2Kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 428/592] watchdog: stm32: Fix wakeup source leaks on device unbind
Date: Mon, 23 Jun 2025 15:06:26 +0200
Message-ID: <20250623130710.616817392@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit b6f8a417e17f1929bb8e7e6ba9f4677f1f3ce364 ]

Device can be unbound or probe can fail, so driver must also release
memory for the wakeup source.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20250406203531.61322-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/stm32_iwdg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/stm32_iwdg.c b/drivers/watchdog/stm32_iwdg.c
index 8ad06b54c5adc..b356a272ff9a0 100644
--- a/drivers/watchdog/stm32_iwdg.c
+++ b/drivers/watchdog/stm32_iwdg.c
@@ -291,7 +291,7 @@ static int stm32_iwdg_irq_init(struct platform_device *pdev,
 		return 0;
 
 	if (of_property_read_bool(np, "wakeup-source")) {
-		ret = device_init_wakeup(dev, true);
+		ret = devm_device_init_wakeup(dev);
 		if (ret)
 			return ret;
 
-- 
2.39.5



