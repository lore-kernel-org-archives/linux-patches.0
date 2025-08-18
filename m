Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7360335BA7;
	Mon, 18 Aug 2025 13:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525090; cv=none; b=U9aCXn5KNGW+ERmgAPQChC0tsfWKSvbM3l3iPSXLFQ41pNYwA0MeQNmzFM2UtsLnNeX5IRTIVjSJbVwKtvGkkfjaiJnfEWO6Os3ZUed334x2OZ9w4aCkqVfTBLw7c8yeckJejbYNfaGM68pwATqL+4mo0HJ+tyf0ap/OJt7najQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525090; c=relaxed/simple;
	bh=GXlIX/rbyezxORdhc4CaxRTEYbgdlkoIRbIh/YaxhaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/0D/23W1ctZwvhi0JDk820BGC0mK7X+dPd5kVmIGbwec18ryh7phvkS0PWwnG7UgR1eQmDv6rZ8+ScXzbgPMtSXjqrYqANyC6vuIssP7mZm2td/lMXTO3Y73VBBeZeElEfhXLLESnkDkdwAXBRen1rZ8kTr2yueDJeGXWWa51Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s590NBcU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s590NBcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438DDC4CEEB;
	Mon, 18 Aug 2025 13:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525090;
	bh=GXlIX/rbyezxORdhc4CaxRTEYbgdlkoIRbIh/YaxhaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s590NBcUa2zmBQmauSUK09PLz1/RtbQy7CUjT02Ffsrj5mUjUgUWphqpzWAyRscvj
	 aXrjO/NZSzWroNC157BhLTLnjw+FoEnPawaxZnzywljDOEOsoZ3ja1KGYn1sp5bSoW
	 ACTxVvEY2ebvpI1p8W4xWiMAAgAU9uWC77OohdJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 155/570] gpio: tps65912: check the return value of regmap_update_bits()
Date: Mon, 18 Aug 2025 14:42:22 +0200
Message-ID: <20250818124511.785162019@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



