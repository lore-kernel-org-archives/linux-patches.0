Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A522A1F1534;
	Sat, 12 Sep 2026 08:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201418; cv=none; b=UtPnYM8Ike8D4lmqKtw6PetMIspeM6mH2X3O2KGw/ZKGAXNzAqYIQfMIXeDkQqheBB+17DkqEAPJejzT6fbRyoGVwe3YWYHtbWX3ehDYtLkXbDeLwKKEwprLNGsBxpyVMAfxgemVAwABfoLXbTv2y8/w74yEpAgU4pz8V3jmvl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201418; c=relaxed/simple;
	bh=c0NlePd3Kqe3BC5gxW4Ps679+iJHyHMknv1KJEmDeBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGMBvECu0VUb5NUKFHglFpQ8W+zPvGJNToFD3N/3mPOzwWoHKe1NMV+WEzYTKArBlTKc8bj7r23h9u40nBVGwc+O/LMhPUUCOjgIGfj6rB2XamJ0uKNQl2mrEATnQwpSpWvGjqMCHW548/UcMEAEXNOr5PioIlKXNYYMYIIMv94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sSNQY0iW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sSNQY0iW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA51C1F000FF;
	Sat, 12 Sep 2026 08:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201417;
	bh=+sVXXdKbZz10SGYg/OLUv8e8l8deqDgH3wmTT6xH2jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sSNQY0iW2mi1ZZkAluaj2NMjj3wDawP/IF6VEdPHPRswNGeRmFX++nPTJ0lz7O3eq
	 HnMENn6HH2u4Zu9QGBlhc6yey5R/1sr3IZzbTBjhpxRBRNRvvk+QsEha3ssCtM16ym
	 0ww2dq/S8H8VYU6KWFLvx19QaZLLZ5drOSimMsnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0991/1815] soc: fsl: qe: implement get_direction()
Date: Sat, 12 Sep 2026 08:45:41 +0200
Message-ID: <20260912065712.259837583@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

[ Upstream commit e460ef309f44b39480209970f1dd462f051d6f30 ]

The lack of get_direction() callback in this driver causes GPIOLIB to
emit a warning. Implement it.

Fixes: e623c4303ed1 ("gpiolib: sanitize the return value of gpio_chip::get_direction()")
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/30b3f278a10b46252783458c81dc438df176f86c.1785405882.git.chleroy@kernel.org
Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/qe/gpio.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/soc/fsl/qe/gpio.c b/drivers/soc/fsl/qe/gpio.c
index 66828f2a35774..6d8f4d549fe29 100644
--- a/drivers/soc/fsl/qe/gpio.c
+++ b/drivers/soc/fsl/qe/gpio.c
@@ -135,6 +135,30 @@ static int qe_gpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
 	return 0;
 }
 
+static int qe_gpio_get_direction(struct gpio_chip *gc, unsigned int gpio)
+{
+	struct qe_gpio_chip *qe_gc = gpiochip_get_data(gc);
+	struct qe_pio_regs __iomem *regs = qe_gc->regs;
+	unsigned long flags;
+	u32 val, mask;
+
+	spin_lock_irqsave(&qe_gc->lock, flags);
+
+	if (gpio < QE_PIO_PINS / 2)
+		val = ioread32be(&regs->cpdir1);
+	else
+		val = ioread32be(&regs->cpdir2);
+
+	spin_unlock_irqrestore(&qe_gc->lock, flags);
+
+	mask = (u32)QE_PIO_DIR_OUT << (QE_PIO_PINS - 2 - (gpio % (QE_PIO_PINS / 2)) * 2);
+
+	if (val & mask)
+		return GPIO_LINE_DIRECTION_OUT;
+	else
+		return GPIO_LINE_DIRECTION_IN;
+}
+
 struct qe_pin {
 	/*
 	 * The qe_gpio_chip name is unfortunate, we should change that to
@@ -308,6 +332,7 @@ static int qe_gpio_probe(struct platform_device *ofdev)
 	gc->ngpio = QE_PIO_PINS;
 	gc->direction_input = qe_gpio_dir_in;
 	gc->direction_output = qe_gpio_dir_out;
+	gc->get_direction = qe_gpio_get_direction;
 	gc->get = qe_gpio_get;
 	gc->set = qe_gpio_set;
 	gc->set_multiple = qe_gpio_set_multiple;
-- 
2.53.0



