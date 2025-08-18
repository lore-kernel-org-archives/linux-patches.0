Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EBF27B355;
	Mon, 18 Aug 2025 12:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521748; cv=none; b=iHkZmvSQbXx7+oOSGMZvYsrb/Qg5yjhf3dM15HT5cmrAmfB7crRYGZg3+Enu3FlWj95Hz51365upKjFHHpnantAsUp3VP6vZwH2vxHRAbh7WRxKKiEa91GnLSjsvmUcqf4Xh4n8GpRU+t4lDjPn5yfK+dy4AG8DSocy1iTAJINs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521748; c=relaxed/simple;
	bh=1XSmO+/e3Z7Iw+aBDKI30Q3uagmr9SytoQBPcWJjz10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r96LkzIzauE++Slp5O++IISR0BDI13KM5ZlJZfa3MkdxFbnbpns6X/4r2dgoeLJoNrJf66IoFHf6T9yrgYK7j/XRv4TN7XjN4XKWrcBVQdrc84oH/4ugf2+i5U88GE72EnErXvmfQ6NOBcmDTEKvVXdwYLFion5wZou1tIn6Rqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uk2jmUQO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uk2jmUQO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E77CC4CEEB;
	Mon, 18 Aug 2025 12:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521747;
	bh=1XSmO+/e3Z7Iw+aBDKI30Q3uagmr9SytoQBPcWJjz10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uk2jmUQOZSdiAWNtvPrVL0cC4Yj7mGkUu8ebzOeHUfjzMJqd19lcBQKKLf5KgVGuF
	 roORo6HGWjmTNM89eYq3NBjSNUj2WNYyiyI85wKlcXlFsk5zV7SF9D4LaV+qBVirh7
	 VxBIX4R8B3y9/NaqLbood2gYzZy04NDXc27qUwcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 109/444] gpio: wcd934x: check the return value of regmap_update_bits()
Date: Mon, 18 Aug 2025 14:42:15 +0200
Message-ID: <20250818124453.024796176@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit ff0f0d7c6587e38c308be9905e36f86e98fb9c1f ]

regmap_update_bits() can fail so check its return value in
wcd_gpio_direction_output() for consistency with the rest of the code
and propagate any errors.

Link: https://lore.kernel.org/r/20250709-gpiochip-set-rv-gpio-remaining-v1-2-b8950f69618d@linaro.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-wcd934x.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-wcd934x.c b/drivers/gpio/gpio-wcd934x.c
index 2bba27b13947..cfa7b0a50c8e 100644
--- a/drivers/gpio/gpio-wcd934x.c
+++ b/drivers/gpio/gpio-wcd934x.c
@@ -46,9 +46,12 @@ static int wcd_gpio_direction_output(struct gpio_chip *chip, unsigned int pin,
 				     int val)
 {
 	struct wcd_gpio_data *data = gpiochip_get_data(chip);
+	int ret;
 
-	regmap_update_bits(data->map, WCD_REG_DIR_CTL_OFFSET,
-			   WCD_PIN_MASK(pin), WCD_PIN_MASK(pin));
+	ret = regmap_update_bits(data->map, WCD_REG_DIR_CTL_OFFSET,
+				 WCD_PIN_MASK(pin), WCD_PIN_MASK(pin));
+	if (ret)
+		return ret;
 
 	return regmap_update_bits(data->map, WCD_REG_VAL_CTL_OFFSET,
 				  WCD_PIN_MASK(pin),
-- 
2.39.5



