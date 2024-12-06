Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11C513A863;
	Fri,  6 Dec 2024 15:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498170; cv=none; b=nNAzjRvxKKhkucZj69+dyVBLd5ieFcgn4GjMJyEOipnzIMeiDRQpq6oEWN6oE3+/K1JAmO0pkTu2FNnFB7CAME4kCrsOSgt3fCY7C7dPseKlc6fJpzQnhNeOOu1zYgItoVUEdMUBqum5UCO7Pa9SeYXIEeBV5f7x+Ml3mTQRPwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498170; c=relaxed/simple;
	bh=SI/zs/yfEhXmPMrCzz5eNPdOVlCcNWJqtbadxdRdRno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9UfxFuVcO2h9wgF0Dz7LdRa1Wh7eCRZOzFvIzzbrxE4sx9XJnEoJo8RFG+oI6+KNNusAVwXfYDvG2c443prfq1qyVQgmT5Zo8d1e4C5Im9silFGKPO52Lf1Ou/BYIqH4XsQl1lCyfKXtK1L7G6lGGtD8r/WJNnW2wDs7Bp6VJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qkxYGxJv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qkxYGxJv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46CCC4CED1;
	Fri,  6 Dec 2024 15:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498170;
	bh=SI/zs/yfEhXmPMrCzz5eNPdOVlCcNWJqtbadxdRdRno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qkxYGxJv0FSYOoZtyooGze3NYdfbqt5GovrArZlSWsvayglG9KZmgIZWNwiBi5Trh
	 R8YAF6cACDmNuawvxB2+FvdkSlLRy4Yt3uCZkSnnVmET8VKagi6rJljX3fBf1SB/8E
	 zBIOKdz+KGJoEB9aflINYuz4qgXw9Zne8DzDntm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew McClain <mmcclain@noprivs.com>,
	Sai Kumar Cholleti <skmr537@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.6 505/676] gpio: exar: set value when external pull-up or pull-down is present
Date: Fri,  6 Dec 2024 15:35:24 +0100
Message-ID: <20241206143713.081548260@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sai Kumar Cholleti <skmr537@gmail.com>

commit 72cef64180de04a7b055b4773c138d78f4ebdb77 upstream.

Setting GPIO direction = high, sometimes results in GPIO value = 0.

If a GPIO is pulled high, the following construction results in the
value being 0 when the desired value is 1:

$ echo "high" > /sys/class/gpio/gpio336/direction
$ cat /sys/class/gpio/gpio336/value
0

Before the GPIO direction is changed from an input to an output,
exar_set_value() is called with value = 1, but since the GPIO is an
input when exar_set_value() is called, _regmap_update_bits() reads a 1
due to an external pull-up.  regmap_set_bits() sets force_write =
false, so the value (1) is not written.  When the direction is then
changed, the GPIO becomes an output with the value of 0 (the hardware
default).

regmap_write_bits() sets force_write = true, so the value is always
written by exar_set_value() and an external pull-up doesn't affect the
outcome of setting direction = high.

The same can happen when a GPIO is pulled low, but the scenario is a
little more complicated.

$ echo high > /sys/class/gpio/gpio351/direction
$ cat /sys/class/gpio/gpio351/value
1

$ echo in > /sys/class/gpio/gpio351/direction
$ cat /sys/class/gpio/gpio351/value
0

$ echo low > /sys/class/gpio/gpio351/direction
$ cat /sys/class/gpio/gpio351/value
1

Fixes: 36fb7218e878 ("gpio: exar: switch to using regmap")
Co-developed-by: Matthew McClain <mmcclain@noprivs.com>
Signed-off-by: Matthew McClain <mmcclain@noprivs.com>
Signed-off-by: Sai Kumar Cholleti <skmr537@gmail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20241105071523.2372032-1-skmr537@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-exar.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/gpio/gpio-exar.c
+++ b/drivers/gpio/gpio-exar.c
@@ -99,11 +99,13 @@ static void exar_set_value(struct gpio_c
 	struct exar_gpio_chip *exar_gpio = gpiochip_get_data(chip);
 	unsigned int addr = exar_offset_to_lvl_addr(exar_gpio, offset);
 	unsigned int bit = exar_offset_to_bit(exar_gpio, offset);
+	unsigned int bit_value = value ? BIT(bit) : 0;
 
-	if (value)
-		regmap_set_bits(exar_gpio->regmap, addr, BIT(bit));
-	else
-		regmap_clear_bits(exar_gpio->regmap, addr, BIT(bit));
+	/*
+	 * regmap_write_bits() forces value to be written when an external
+	 * pull up/down might otherwise indicate value was already set.
+	 */
+	regmap_write_bits(exar_gpio->regmap, addr, BIT(bit), bit_value);
 }
 
 static int exar_direction_output(struct gpio_chip *chip, unsigned int offset,


