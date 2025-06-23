Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E759A253356;
	Mon, 23 Jun 2025 13:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684656; cv=none; b=oMirjBHOBztrmo856H2En5T0p6hRFAtXzhrcOepyW735QOE7m6DRV+M3Fdab7DxNAX1aTm2h5UoSmiW/+80eutv5Tbwr6svqIhgsMfkpQpIbO9SBpw5yr/RLvXcSDuvMw9Qsdlj87DBzEUl9j9ZU7PS0rs8PtKx7GNnkNjtt61s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684656; c=relaxed/simple;
	bh=RLOYN8U4G3qHeuIQfspj29AcFdhFeyPgSaIE6FwycaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p0vzgsVng2hgL1qrkb2lxN7YTWrfKUmALJlUsZhu9ul74uZZsf7tvOXDW5XRm8hvURkCEbgZZwG7ReGuhxVWl/r5/XNGEF6oqcOKndoBEcbN1vIAfAWqcx7u8A8+qYOThhBImbGn+gXKvxdm7QnprdU7GMI8ieqmxSdhRihwdNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HGkShVzB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HGkShVzB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B543C4CEF0;
	Mon, 23 Jun 2025 13:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684655;
	bh=RLOYN8U4G3qHeuIQfspj29AcFdhFeyPgSaIE6FwycaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HGkShVzBVP4wx88lImalLeDAPYpD5ihu5IBmSyc5PBxn6K7J/VXCp5VF/h/bFuxSd
	 70WPtrP0NbPIvMC5UBgZJuTd1JK2/gczRhaQwCtMq6mj8GwQrCf2iW2AjQr07jRwPT
	 4KMvGXgOvujQdl3nnUZ9VdNVmHyWuc/8MnQhI3DM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@openwrt.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Gabor Juhos <j4g8y7@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 003/222] pinctrl: armada-37xx: set GPIO output value before setting direction
Date: Mon, 23 Jun 2025 15:05:38 +0200
Message-ID: <20250623130612.000741061@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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
@@ -409,23 +409,22 @@ static int armada_37xx_gpio_direction_ou
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


