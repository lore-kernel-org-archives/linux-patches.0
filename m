Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999122417C3;
	Mon, 23 Jun 2025 13:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684213; cv=none; b=AQxIDcJ+s8jy1TmXUeRLSNszvx6B0ejwOfoiRBvgfDgXdo+o/J/e6gnbgz6QyVPifmYdDsRWiClkZTPaKUjdTDkZqQzvg9J2Dw/h6mK7bIbL4FuxZzULT7QM0fkko1bufPxdjCJ856uL5aJGlE0VQuguW3sTwy4ku2vqzpi4hxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684213; c=relaxed/simple;
	bh=eIFn6succvwWLd7NFH9XRbzvh3m9EOsGj1hM7hNOonk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMu4O6jBWzTZuiX+WbMqJ3lxFAQf7xlqdXcMdZCQgAfefP1HXB3NK9UTUppDWTF0clh0bmXxpRsUDJsWGZl7ZJhgnQHcG0zBZvKSWCTJXGoh10Qtkckj5reXh/nqTF5tUj01UKc5wpZStZdLwNWK43qaw9RxFQCShhOgMh4ZQYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pF9hsTnX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pF9hsTnX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21EB8C4CEF0;
	Mon, 23 Jun 2025 13:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684213;
	bh=eIFn6succvwWLd7NFH9XRbzvh3m9EOsGj1hM7hNOonk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pF9hsTnX0/T16N7XbJUo5Ij22yATiWOmPwyHR2iLbtOE4xtVi2PQIhZfxm5FabpDI
	 LJ9m7I+4duyUiy9rTJSC4N3ozmLkAbVZGUAjuKUtGqRy7ODNnbLmEjqRtBiuko5xi1
	 Tih1puHWahZDSNfzhjkdGx1yZacBhZgkeV+fAnw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@openwrt.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Gabor Juhos <j4g8y7@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.15 002/411] pinctrl: armada-37xx: use correct OUTPUT_VAL register for GPIOs > 31
Date: Mon, 23 Jun 2025 15:02:26 +0200
Message-ID: <20250623130633.067789169@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

commit 947c93eb29c2a581c0b0b6d5f21af3c2b7ff6d25 upstream.

The controller has two consecutive OUTPUT_VAL registers and both
holds output value for 32 GPIOs. Due to a missing adjustment, the
current code always uses the first register while setting the
output value whereas it should use the second one for GPIOs > 31.

Add the missing armada_37xx_update_reg() call to adjust the register
according to the 'offset' parameter of the function to fix the issue.

Cc: stable@vger.kernel.org
Fixes: 6702abb3bf23 ("pinctrl: armada-37xx: Fix direction_output() callback behavior")
Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Link: https://lore.kernel.org/20250514-pinctrl-a37xx-fixes-v2-1-07e9ac1ab737@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -413,6 +413,7 @@ static int armada_37xx_gpio_direction_ou
 					     unsigned int offset, int value)
 {
 	struct armada_37xx_pinctrl *info = gpiochip_get_data(chip);
+	unsigned int val_offset = offset;
 	unsigned int reg = OUTPUT_EN;
 	unsigned int mask, val, ret;
 
@@ -425,6 +426,8 @@ static int armada_37xx_gpio_direction_ou
 		return ret;
 
 	reg = OUTPUT_VAL;
+	armada_37xx_update_reg(&reg, &val_offset);
+
 	val = value ? mask : 0;
 	regmap_update_bits(info->regmap, reg, mask, val);
 


