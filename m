Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95357158219;
	Tue,  9 Jul 2024 11:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523698; cv=none; b=PRGaReF6tNDPOzF4vAc5BYIwN3nlqt37jZegcy7YkFmyljTmQGHCzrHe3UR2yqXUM3nXIZgxG5CHkIMYvPJ6W+QbnUCnpNHS40qyJ4xMaGj8rDunVmtGa4AjFdqIGFQz6fXrh01bZkUoSZZvM2RJhoLRNrmR8THWGGptwkj5keQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523698; c=relaxed/simple;
	bh=LEES/SnSAz0qgRQEHu+iDc4xPjHe9jja09yr0n8aqOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FjHwu84GmSfZfZD1/7f21B3NXewziwG69n0UfEY58JhPpo2Wwus8H5BCFQNHW9MrswvJo32T4YB0NiqWgSKUAsR+5bsnDy6HmtcSE+s/S7vcpiZRymFmKs7exiog6tCCrMHqXLFQAyt13j9FhwIctFvpA6nGoME6finyonCRtI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GYAlZJrj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GYAlZJrj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46F8C3277B;
	Tue,  9 Jul 2024 11:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523698;
	bh=LEES/SnSAz0qgRQEHu+iDc4xPjHe9jja09yr0n8aqOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GYAlZJrjFlcoRGhIW7O/LVYuTPFokh5JO5G3Ruxv/4entOb1nvbGCDQX+PUZPtK0W
	 ucTHM9hM10xIK/eQm2E3ustvGLSJVfpIcqT2M8gh+ZC6ozw48helxUj2m52T4qqAdF
	 f64hEH5U9HGpiWpzsBh047egrOc7EQ6ZZsZRJwec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Mentovai <mark@mentovai.com>,
	Shiji Yang <yangshiji66@outlook.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	=?UTF-8?q?L=C3=B3r=C3=A1nd=20Horv=C3=A1th?= <lorand.horvath82@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/139] gpio: mmio: do not calculate bgpio_bits via "ngpios"
Date: Tue,  9 Jul 2024 13:09:37 +0200
Message-ID: <20240709110701.152640203@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shiji Yang <yangshiji66@outlook.com>

[ Upstream commit f07798d7bb9c46d17d80103fb772fd2c75d47919 ]

bgpio_bits must be aligned with the data bus width. For example, on a
32 bit big endian system and we only have 16 GPIOs. If we only assume
bgpio_bits=16 we can never control the GPIO because the base address
is the lowest address.

low address                          high address
-------------------------------------------------
|   byte3   |   byte2   |   byte1   |   byte0   |
-------------------------------------------------
|    NaN    |    NaN    |  gpio8-15 |  gpio0-7  |
-------------------------------------------------

Fixes: 55b2395e4e92 ("gpio: mmio: handle "ngpios" properly in bgpio_init()")
Fixes: https://github.com/openwrt/openwrt/issues/15739
Reported-by: Mark Mentovai <mark@mentovai.com>
Signed-off-by: Shiji Yang <yangshiji66@outlook.com>
Suggested-By: Mark Mentovai <mark@mentovai.com>
Reviewed-by: Jonas Gorski <jonas.gorski@gmail.com>
Tested-by: Lóránd Horváth <lorand.horvath82@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/TYCP286MB089577B47D70F0AB25ABA6F5BCD52@TYCP286MB0895.JPNP286.PROD.OUTLOOK.COM
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mmio.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpio/gpio-mmio.c b/drivers/gpio/gpio-mmio.c
index 74fdf0d87b2c8..c9f9f4e36c89b 100644
--- a/drivers/gpio/gpio-mmio.c
+++ b/drivers/gpio/gpio-mmio.c
@@ -622,8 +622,6 @@ int bgpio_init(struct gpio_chip *gc, struct device *dev,
 	ret = gpiochip_get_ngpios(gc, dev);
 	if (ret)
 		gc->ngpio = gc->bgpio_bits;
-	else
-		gc->bgpio_bits = roundup_pow_of_two(round_up(gc->ngpio, 8));
 
 	ret = bgpio_setup_io(gc, dat, set, clr, flags);
 	if (ret)
-- 
2.43.0



