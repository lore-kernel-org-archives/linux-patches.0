Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E531474CC;
	Tue, 21 Jul 2026 18:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659228; cv=none; b=Mn2fSfWOZ+8Lc5jzmlKlkCe5R07VO6WdAbunGed9zAKHNWyJkcz6kEiPQ7404R02BZJqTwGXFSGUIGCh6+ZbDUGPVMgKmdZ2/8JaIcyY6OtpBWRPCOJqL0BszzilATm775Qogy1ceaoR18d2ebkBOoQWCAXXGAogQcrNKJeWMpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659228; c=relaxed/simple;
	bh=0ha3CaJZOPu1hyxyi0NoyusFHpLOO3XWbBvchN9YtJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ICNVhHBftUGHVIMP/SxZLR/CsmjD27QhuCdUnumDlqn5Xf9oNU50E6THfi+Yow2ktKEkQV+zzmgLAW0bS9sT8lDfZkhqSqZOICjlmP6dn3cMHSsdmVwV1Lw/5V7WXH771/+qUzTiiFpETBk69wMcEM3S4xE1AgWtGbjFMqvNZok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=USE2i/bQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="USE2i/bQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262F21F000E9;
	Tue, 21 Jul 2026 18:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659226;
	bh=KZZE9PMzLOjGuRRoLuOvfSNhWkvkzeEAcSQwblPCOHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=USE2i/bQO793s+91opQFFWe5hfbTz8yJ+pm4PG36baor6S8neFOhgJ8LfdachU/ti
	 1/po//nXBcCn279NOa64F2Zy8Iww5wW2FGmlIe5uepiUchyC+rP8lyj1Ke+RIOAF6F
	 Yn1XdpGF6PWvMYLARpOXiZvB3RF/cqi5kVktu1bQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Andreas Kemnade <andreas@kemnade.info>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.18 1398/1611] gpios: palmas: add .get_direction() op
Date: Tue, 21 Jul 2026 17:25:14 +0200
Message-ID: <20260721152546.888468956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -116,6 +116,24 @@ static int palmas_gpio_input(struct gpio
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


