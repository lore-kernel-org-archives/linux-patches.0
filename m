Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485D2352029;
	Tue, 21 Jul 2026 21:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670289; cv=none; b=gFiSxbFGK3Q7IENFYGRa/yb4bfmpENH2d01rgYjToJAgRfGfCrElpsDpUL7teer0Efia6CsfEs2tgt6yLnc9jP2lHl+LtWC20OAF+HCtYRmBwHdw7KTSir1P6Ct+7nAW7JBsQJNOdgLR7yKH+WGrZMlsAASiuqou/3L8KbGYoRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670289; c=relaxed/simple;
	bh=3afsnUW3HYBOBUS69hNbxLCQwLeglLT3tMybw0RNmjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKcYrvBS9tAPhhFgc3acWgk3zh422dOs9ccxjMuvnEGU87IwKMDGLlPQHe5wnOe9Ez0XMYFjdyHsrbVq9+n3/X8FHurC1OmH/2GtnkU2WfwcwLPLGM9DgZK7Ks33URCumbOiCJNEfP4MNoDtmtgDQaAmjE2Wj6VGvnqKKw1fWsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r26TAN95; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r26TAN95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA1A1F000E9;
	Tue, 21 Jul 2026 21:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670288;
	bh=xoHb8iZqu0TjikRjOMdE4tfwaXzqNJU2OQORYE9Vxzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r26TAN95XnrsgzwgVn/bqAG5HilNyqGHGnsqLS9YmFiDtUDssxbKhRcViZhkv8pOn
	 nPJDi2h7dU+57CIfomO3IrPsnEkzmd5MU9qfctDaSK9BLfG6/tI1XSgz2Zs7E77ni1
	 ImarMT8H5IZbb4UUd1mxBn+mgf2u2pfCnqYi/pTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Andreas Kemnade <andreas@kemnade.info>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.1 0875/1067] gpios: palmas: add .get_direction() op
Date: Tue, 21 Jul 2026 17:24:36 +0200
Message-ID: <20260721152444.107047286@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


