Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DB844AB6A;
	Tue, 21 Jul 2026 22:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672599; cv=none; b=fAf/V6y3OAPikDrNpnBMYDVV6AXWQ1QM6VaSYy+liqvAFYRtNPSB1snpVTnbM6J2SpcENZZvVS7Nr3cBcwOqh7heCp5dCiUd7jnWuK58LPAYOYn95FY6GtaZmjr1WarPaB9/QLqvB+tpenVsURdpdehz3CAPZl6MFqx16SidHUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672599; c=relaxed/simple;
	bh=w2lAfbsTz1MCzyCKuriZjtmEY3Twvk/FEWI3eUsWPcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJSo0oFr3xmzz1hO5iCjfkJwLoBOOOPrsy+iQu5nIS/0QNUN0GO2lvim6dMFD0P6zhCAr7HRrzT2PFRPVrIZZxZi1vmW9w4YH2XEecJXqO/FX9Z/TIgqNBnEXB4JMnvt7ZTFU3tB8gHFyABY0Uobb4UywY+vz8keP09MQDEi16k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9pUcobT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9pUcobT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C321F00A3A;
	Tue, 21 Jul 2026 22:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672597;
	bh=+pqX63160/8WJShMGL7p8vEnW8V11uvnCbKSVYWVg78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H9pUcobTBzcaoyo0kPRNgiivSR98V4vZnqNX8p4KA5mZ13lfuHr2ZyJakRZAONT57
	 kVRhStqMGY7Wie8SNFO+LWJc7GBI9ZmPtDBIpQC8MnbxNv5McLv72dOg8IreJhK6zh
	 QyYOewLf0MxLqTRqxhq1iSjsIs3YNUV8JoMTQjGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Andreas Kemnade <andreas@kemnade.info>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 5.15 678/843] gpios: palmas: add .get_direction() op
Date: Tue, 21 Jul 2026 17:25:13 +0200
Message-ID: <20260721152421.310214729@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Andreas Kemnade <andreas@kemnade.info>

commit db4a79713ed8e252d5e4edf6eaaa80948b6855a2 upstream.

Accessing debug/gpio is quite noisy without a get_direction()
implementation. To calm that down add an implementation.

Fixes: 3d50a2785271 ("gpio: palmas: Add support for Palmas GPIO")
Cc: stable@vger.kernel.org
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://patch.msgid.link/20260704-palmas-getdirection-v2-1-2fd85fee3832@kemnade.info
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-palmas.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/drivers/gpio/gpio-palmas.c
+++ b/drivers/gpio/gpio-palmas.c
@@ -118,6 +118,24 @@ static int palmas_gpio_input(struct gpio
 	return ret;
 }
 
+static int palmas_gpio_get_direction(struct gpio_chip *gc, unsigned int offset)
+{
+	struct palmas_gpio *pg = gpiochip_get_data(gc);
+	struct palmas *palmas = pg->palmas;
+	unsigned int val;
+	unsigned int reg;
+	int ret;
+	int gpio16 = (offset/8);
+
+	offset %= 8;
+	reg = (gpio16) ? PALMAS_GPIO_DATA_DIR2 : PALMAS_GPIO_DATA_DIR;
+	ret = palmas_read(palmas, PALMAS_GPIO_BASE, reg, &val);
+	if (ret)
+		return ret;
+
+	return (val & BIT(offset)) ? GPIO_LINE_DIRECTION_OUT : GPIO_LINE_DIRECTION_IN;
+}
+
 static int palmas_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
 {
 	struct palmas_gpio *pg = gpiochip_get_data(gc);
@@ -166,6 +184,7 @@ static int palmas_gpio_probe(struct plat
 	palmas_gpio->gpio_chip.can_sleep = true;
 	palmas_gpio->gpio_chip.direction_input = palmas_gpio_input;
 	palmas_gpio->gpio_chip.direction_output = palmas_gpio_output;
+	palmas_gpio->gpio_chip.get_direction = palmas_gpio_get_direction;
 	palmas_gpio->gpio_chip.to_irq = palmas_gpio_to_irq;
 	palmas_gpio->gpio_chip.set	= palmas_gpio_set;
 	palmas_gpio->gpio_chip.get	= palmas_gpio_get;


