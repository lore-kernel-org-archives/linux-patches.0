Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7368D21CC55;
	Mon, 18 Aug 2025 13:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523344; cv=none; b=LuRc4zRW7ttnvzWKY+wi6K3wlTYuc9oQMNeonbFwDly4FGpuW3xXxSGJaBBOMhDfz3XFAE6XiZcpQoncVMEkwciGilKhB2q3/bPsRe9QYidC3yBLnYMSFelxz8oH4G33smRqJRYAxwQ2TI38ktLRTCFDsnaFPFxwsJa4ElfHWsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523344; c=relaxed/simple;
	bh=POCnk6vdOKbSlt8/qvWStjkpEvq8LvlkaphR23pqy3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZsK89FRsTz/ywURjBNAQi7mVG/hCOmIlnH17z2bAlJIigqu57RAHJirz3GvwSjNCQEJhdn/P9Hfz+ZiGPnPZ7SrM8+b4sp3yjCsJdIEMvge5/hw8KhLkNx6N2Ehu3vwh/YajBmkXMc9Aty4Eu3+0bngPaHGJ/sh3rE5zJdGI24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OiEaRP1C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OiEaRP1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69527C4CEEB;
	Mon, 18 Aug 2025 13:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523343;
	bh=POCnk6vdOKbSlt8/qvWStjkpEvq8LvlkaphR23pqy3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OiEaRP1CatLrEF2ElCAhp27MkBH5EiB5zXMYh4jWc91deaz3GVQCYQZ9K/Q8i5gzf
	 hBCf1s1VHybyRhhB/mJexG3gNCOimX+nTg54Qmyvf6MOJJWZMw2lwFP6vK11pw3CuU
	 Cs/7bn1d4c+EClU4dYmwgPOV32kC2XE9pGYvgddk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 142/515] gpio: tps65912: check the return value of regmap_update_bits()
Date: Mon, 18 Aug 2025 14:42:08 +0200
Message-ID: <20250818124503.852760895@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit a0b2a6bbff8c26aafdecd320f38f52c341d5cafa ]

regmap_update_bits() can fail, check its return value like we do
elsewhere in the driver.

Link: https://lore.kernel.org/r/20250707-gpiochip-set-rv-gpio-round4-v1-2-35668aaaf6d2@linaro.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-tps65912.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-tps65912.c b/drivers/gpio/gpio-tps65912.c
index fab771cb6a87..bac757c191c2 100644
--- a/drivers/gpio/gpio-tps65912.c
+++ b/drivers/gpio/gpio-tps65912.c
@@ -49,10 +49,13 @@ static int tps65912_gpio_direction_output(struct gpio_chip *gc,
 					  unsigned offset, int value)
 {
 	struct tps65912_gpio *gpio = gpiochip_get_data(gc);
+	int ret;
 
 	/* Set the initial value */
-	regmap_update_bits(gpio->tps->regmap, TPS65912_GPIO1 + offset,
-			   GPIO_SET_MASK, value ? GPIO_SET_MASK : 0);
+	ret = regmap_update_bits(gpio->tps->regmap, TPS65912_GPIO1 + offset,
+				 GPIO_SET_MASK, value ? GPIO_SET_MASK : 0);
+	if (ret)
+		return ret;
 
 	return regmap_update_bits(gpio->tps->regmap, TPS65912_GPIO1 + offset,
 				  GPIO_CFG_MASK, GPIO_CFG_MASK);
-- 
2.39.5



