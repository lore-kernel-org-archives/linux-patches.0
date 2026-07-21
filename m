Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49465400DFC;
	Tue, 21 Jul 2026 20:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664028; cv=none; b=iBT2ViZ9ztMMFGcyAiVrsKiXpSXwD9WV4DRwSA2PspZmfX6C3iC9fCaRFuQRJN3VKX6PcJ1JuuP56edRCggzmRTrgXxndceNIdGAr6e+BUmtSvn1ZjXWOOeGwvSF0x0T2le9yuOmWnyoa1Kd45Lzej+TXuiv1PxHfLNdPIA+Rbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664028; c=relaxed/simple;
	bh=v4EEKM6H69W3KCs3BMwkDtZpRoODSP+wpHviyAvyEOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKcNzmWEPg5UDoXWbfYUZKUyyJk9pCBD1PYDfpOpd5pMhCviDKhdBaQ6sJz2lqjvh5HHS49XPT0rYoQq/GQ/oDsWPk+QpUrP45hDuWCY20BIFjSC/OEUobkraNir/+z6rAFW1dNJrjhDeefigBbnE/iV71ZrlkeOPfw0TFnIk3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MooFJh5J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MooFJh5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0221F000E9;
	Tue, 21 Jul 2026 20:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664027;
	bh=uXmPObe+hzhAMoOW1PnF322o3B4BWbV6bmBpi1dGEXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MooFJh5J9kGMSCiJQPzdSGokBMJfUQuL+wdBEcBoHT3HPwcRpnQTnB3bM4WV9ovm7
	 mD+4XO5lrT7YYvNnTs0xwlBdVh487LFftEYT9PMir84gPdPyYj3AA9BnT9zN/7aiNw
	 wlgbHLVsBgyk0o/ee1pJnkjeb3n9qvfixPyJ8LzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Andreas Kemnade <andreas@kemnade.info>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.12 1044/1276] gpios: palmas: add .get_direction() op
Date: Tue, 21 Jul 2026 17:24:47 +0200
Message-ID: <20260721152509.349103957@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -117,6 +117,24 @@ static int palmas_gpio_input(struct gpio
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
@@ -165,6 +183,7 @@ static int palmas_gpio_probe(struct plat
 	palmas_gpio->gpio_chip.can_sleep = true;
 	palmas_gpio->gpio_chip.direction_input = palmas_gpio_input;
 	palmas_gpio->gpio_chip.direction_output = palmas_gpio_output;
+	palmas_gpio->gpio_chip.get_direction = palmas_gpio_get_direction;
 	palmas_gpio->gpio_chip.to_irq = palmas_gpio_to_irq;
 	palmas_gpio->gpio_chip.set	= palmas_gpio_set;
 	palmas_gpio->gpio_chip.get	= palmas_gpio_get;


