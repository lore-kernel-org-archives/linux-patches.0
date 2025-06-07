Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73481F4CB8;
	Sat,  7 Jun 2025 10:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749290968; cv=none; b=nCPfHN+c1RC661/dNgR8SkraMMs+qKlWYi3kcVXOqq/jkyeeNxBfXKZ1ZUA6iZoRKPvUEZmTnWVgy4SYg6DhS9zjHqpnGvBTJqnCbV9v7A8jS757hLwCcwPVC3qhXDpMLchZV9z8j9DoKiEUOsWTgAPl476OappKp5koPVvbNII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749290968; c=relaxed/simple;
	bh=icZRPus5g3PeifEPdx8kE+ynae1KiuBpAzVrm6YT68A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E9VpzGCXWlo/xWKXg0cyi1nxJ8NFKIyN+G4OnbuZ2r8Gm8XnQEjx//GXOkX5FGOMsHKypLqg9w3bwr/xwHI5UqDUEZ8MIl68WMK7C8bb4dCAJEJC3qa8d2M5uHVBVBlST1rWyQa1+9+8K5CxK1AXRUYZxEL+NxBI85nkdFK3Hlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MfVhgH0q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MfVhgH0q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663FEC4CEE4;
	Sat,  7 Jun 2025 10:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749290968;
	bh=icZRPus5g3PeifEPdx8kE+ynae1KiuBpAzVrm6YT68A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MfVhgH0qdu4W5M8C2HjFGs60RBqc9pyp9QVHQm1zaYKFiurkOoGJLqhKQZSsvkU0g
	 STwJH+zW1D9WfPCQ1MfuYYxsq/LMAchiTxtkFiwuFaaph67Yw9TrRxnhNARFxqjxGQ
	 hZQzjo2xrEZ8dudpZhJIDnSseZIW6dwQj92AV+3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@openwrt.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Gabor Juhos <j4g8y7@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.14 03/24] pinctrl: armada-37xx: set GPIO output value before setting direction
Date: Sat,  7 Jun 2025 12:07:43 +0200
Message-ID: <20250607100717.840762094@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100717.706871523@linuxfoundation.org>
References: <20250607100717.706871523@linuxfoundation.org>
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

From: Gabor Juhos <j4g8y7@gmail.com>

commit e6ebd4942981f8ad37189bbb36a3c8495e21ef4c upstream.

Changing the direction before updating the output value in the
OUTPUT_VAL register may result in a glitch on the output line
if the previous value in the OUTPUT_VAL register is different
from the one we want to set.

In order to avoid that, update the output value before changing
the direction.

Cc: stable@vger.kernel.org
Fixes: 6702abb3bf23 ("pinctrl: armada-37xx: Fix direction_output() callback behavior")
Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Link: https://lore.kernel.org/20250514-pinctrl-a37xx-fixes-v2-2-07e9ac1ab737@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -417,23 +417,22 @@ static int armada_37xx_gpio_direction_ou
 					     unsigned int offset, int value)
 {
 	struct armada_37xx_pinctrl *info = gpiochip_get_data(chip);
-	unsigned int val_offset = offset;
-	unsigned int reg = OUTPUT_EN;
+	unsigned int en_offset = offset;
+	unsigned int reg = OUTPUT_VAL;
 	unsigned int mask, val, ret;
 
 	armada_37xx_update_reg(&reg, &offset);
 	mask = BIT(offset);
+	val = value ? mask : 0;
 
-	ret = regmap_update_bits(info->regmap, reg, mask, mask);
-
+	ret = regmap_update_bits(info->regmap, reg, mask, val);
 	if (ret)
 		return ret;
 
-	reg = OUTPUT_VAL;
-	armada_37xx_update_reg(&reg, &val_offset);
+	reg = OUTPUT_EN;
+	armada_37xx_update_reg(&reg, &en_offset);
 
-	val = value ? mask : 0;
-	regmap_update_bits(info->regmap, reg, mask, val);
+	regmap_update_bits(info->regmap, reg, mask, mask);
 
 	return 0;
 }


