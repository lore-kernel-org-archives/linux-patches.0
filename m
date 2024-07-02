Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711191BE226;
	Tue,  2 Jul 2024 17:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940689; cv=none; b=ODGzSAHKFXt6tKVbk7yk4aP9bsk8w+gFbV9TbeBc1wer0i7hK9m8VUZdd6/0KrXHv+IkZF+bidF3HQzzpRwNvJtMuFeaAZbYP5+SmuG5QvRCWVtlbdO3b63J5nlem2TwaumOtxAIlRUEEqlK027KzJA0Ekzn/Ji71mby1Y2DRAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940689; c=relaxed/simple;
	bh=deOwfQEeSyoY4n8dzRwazHOz1bNLHSUABDSINAOTQVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8+VRLEKsIRmF904ePqIRD73bclJ3cphleFqPyxUIUsOUWzVfJlSSt3Ku1MXUoTyCp5b59zKRWsd79QntFJGRtulJXk2BfGUkxBJm69ivEUC8d3uK8yj1JdlJmfy50ulF09T9lpWKYjpOmk9A5IBz9ylrr3Vna+Exy8xUx5GWQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zTIWNzP5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zTIWNzP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2BCAC116B1;
	Tue,  2 Jul 2024 17:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940689;
	bh=deOwfQEeSyoY4n8dzRwazHOz1bNLHSUABDSINAOTQVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zTIWNzP5aoup7sWq2JS9BPYx8E3CJLWS+tV6x+juOd/YWZmnFNRpX7tFrOYRoXEyc
	 hgXwsOjT53Xkac1eEwraJzzuMQeOUxEn23/d2qnNy/8bfSlNZuVC1zvkZotdu003fu
	 bU7t4htLWmoFLMZykORDhAxgzEpa+gaQl7F9dHkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 215/222] reset: gpio: Fix missing gpiolib dependency for GPIO reset controller
Date: Tue,  2 Jul 2024 19:04:13 +0200
Message-ID: <20240702170252.205481301@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 01f6a84c7a3eaabafd787608d630db31c6904f5c ]

The GPIO reset controller uses gpiolib but there is no Kconfig
dependency reflecting this fact, add one.

With the addition of the controller to the arm64 defconfig this is
causing build breaks for arm64 virtconfig in -next:

aarch64-linux-gnu-ld: drivers/reset/core.o: in function `__reset_add_reset_gpio_lookup':
/build/stage/linux/drivers/reset/core.c:861:(.text+0xccc): undefined reference to `gpio_device_find_by_fwnode'

Fixes: cee544a40e44 ("reset: gpio: Add GPIO-based reset controller")
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20240325-reset-gpiolib-deps-v2-1-3ed2517f5f53@kernel.org
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/reset/Kconfig b/drivers/reset/Kconfig
index 85b27c42cf65b..f426b4c391796 100644
--- a/drivers/reset/Kconfig
+++ b/drivers/reset/Kconfig
@@ -68,6 +68,7 @@ config RESET_BRCMSTB_RESCAL
 
 config RESET_GPIO
 	tristate "GPIO reset controller"
+	depends on GPIOLIB
 	help
 	  This enables a generic reset controller for resets attached via
 	  GPIOs.  Typically for OF platforms this driver expects "reset-gpios"
-- 
2.43.0



