Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6661315C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:37:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE919C433C1;
	Mon,  5 Dec 2022 19:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670269058;
	bh=/tpOELxwIj6VTNgSuaULuBLZG9FCXL+NackIq/q/DO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kVX3xKOYVJByS8hK9JKONKNAC5ZgDqmOLDL4g3rvud3iCcwbmQJ6my5Vgk5oknzxZ
	 WKnl/hto7OAu7uEpfVrLoBGRHI6J05wfSy3scpMtSdRc62d/kPfTQ/W43cvI0q6hXk
	 sj6PeGZAQCRDqTJbpVd1qvpl8kOMljRAs8PqddFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Dale Smith <dalepsmith@gmail.com>,
	John Harris <jmharris@gmail.com>
Subject: [PATCH 5.15 073/120] pinctrl: intel: Save and restore pins in "direct IRQ" mode
Date: Mon,  5 Dec 2022 20:10:13 +0100
Message-Id: <20221205190808.808828091@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 6989ea4881c8944fbf04378418bb1af63d875ef8 upstream.

The firmware on some systems may configure GPIO pins to be
an interrupt source in so called "direct IRQ" mode. In such
cases the GPIO controller driver has no idea if those pins
are being used or not. At the same time, there is a known bug
in the firmwares that don't restore the pin settings correctly
after suspend, i.e. by an unknown reason the Rx value becomes
inverted.

Hence, let's save and restore the pins that are configured
as GPIOs in the input mode with GPIROUTIOXAPIC bit set.

Cc: stable@vger.kernel.org
Reported-and-tested-by: Dale Smith <dalepsmith@gmail.com>
Reported-and-tested-by: John Harris <jmharris@gmail.com>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=214749
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://lore.kernel.org/r/20221124222926.72326-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/intel/pinctrl-intel.c |   27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -436,9 +436,14 @@ static void __intel_gpio_set_direction(v
 	writel(value, padcfg0);
 }
 
+static int __intel_gpio_get_gpio_mode(u32 value)
+{
+	return (value & PADCFG0_PMODE_MASK) >> PADCFG0_PMODE_SHIFT;
+}
+
 static int intel_gpio_get_gpio_mode(void __iomem *padcfg0)
 {
-	return (readl(padcfg0) & PADCFG0_PMODE_MASK) >> PADCFG0_PMODE_SHIFT;
+	return __intel_gpio_get_gpio_mode(readl(padcfg0));
 }
 
 static void intel_gpio_set_gpio_mode(void __iomem *padcfg0)
@@ -1659,6 +1664,7 @@ EXPORT_SYMBOL_GPL(intel_pinctrl_get_soc_
 static bool intel_pinctrl_should_save(struct intel_pinctrl *pctrl, unsigned int pin)
 {
 	const struct pin_desc *pd = pin_desc_get(pctrl->pctldev, pin);
+	u32 value;
 
 	if (!pd || !intel_pad_usable(pctrl, pin))
 		return false;
@@ -1673,6 +1679,25 @@ static bool intel_pinctrl_should_save(st
 	    gpiochip_line_is_irq(&pctrl->chip, intel_pin_to_gpio(pctrl, pin)))
 		return true;
 
+	/*
+	 * The firmware on some systems may configure GPIO pins to be
+	 * an interrupt source in so called "direct IRQ" mode. In such
+	 * cases the GPIO controller driver has no idea if those pins
+	 * are being used or not. At the same time, there is a known bug
+	 * in the firmwares that don't restore the pin settings correctly
+	 * after suspend, i.e. by an unknown reason the Rx value becomes
+	 * inverted.
+	 *
+	 * Hence, let's save and restore the pins that are configured
+	 * as GPIOs in the input mode with GPIROUTIOXAPIC bit set.
+	 *
+	 * See https://bugzilla.kernel.org/show_bug.cgi?id=214749.
+	 */
+	value = readl(intel_get_padcfg(pctrl, pin, PADCFG0));
+	if ((value & PADCFG0_GPIROUTIOXAPIC) && (value & PADCFG0_GPIOTXDIS) &&
+	    (__intel_gpio_get_gpio_mode(value) == PADCFG0_PMODE_GPIO))
+		return true;
+
 	return false;
 }
 


