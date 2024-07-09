Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDD6158851;
	Tue,  9 Jul 2024 11:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523679; cv=none; b=Kp3Y+CQoeVgY9h7YK9+gKyfPMDkkaH7jZu1ql69deelAqxLVvPlrAL/lOpKGDZ83jPEPN5jl3w3ZAd3sQ0VSWYanPT9Y3FlDZaUpI7QJGFVLF/MO+8XTpxin5odMggrDWt/WRKYD5B5qSVZuVyUdgEf1d2MMdV/hyTWX2UmtXLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523679; c=relaxed/simple;
	bh=kJC/q//Ju8aqnQoXEPOYng5x48PJyM69bhxOu2Xz27c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uN+Hnaou4OlJ9JSR028bWFI8xVg1fZl2r7YSHN1RI2XapZoCKhJmZv3deCkVyiaYcoq7DANImNrI9sG4SC5XyMz6+0YxkF7yhr19XoLxygs7+u/JRcSaHXuRnLLlCaVvA+DiFvXEvgumGaZ9+KP85U4OKSOX/DjjlaKcH1wA/xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jkWA5D9T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jkWA5D9T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6ABC3277B;
	Tue,  9 Jul 2024 11:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523678;
	bh=kJC/q//Ju8aqnQoXEPOYng5x48PJyM69bhxOu2Xz27c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jkWA5D9TLKIITTi3U0q+ZqPZMO6faiaMAN60oHa9DrUk1GZ+Ds/Yn2MUbgaLatF46
	 ny1uGYbf0sAGqFgcj+Eoak90Mvq4MVhPAYyLAF+9RJq02Dnh61RhoMiMblJQKSsQS0
	 dcV5jC9JjgTZqZAlej/ikCX8rFPMQzMz9Q3S+2lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Schiller <ms@dev.tdt.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/139] gpiolib: of: fix lookup quirk for MIPS Lantiq
Date: Tue,  9 Jul 2024 13:09:33 +0200
Message-ID: <20240709110700.997762079@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 3645ffaf2b334abaf5f53e5ca0f47465d91e69d2 ]

As it turns out, there is a large number of out-of-tree DTSes (in
OpenWrt project) that used to specify incorrect (active high) polarity
for the Lantiq reset GPIO, so to keep compatibility while they are
being updated a quirk for force the polarity low is needed. Luckily
these old DTSes used nonstandard name for the property ("gpio-reset" vs
"reset-gpios") so the quirk will not hurt if there are any new devices
that need inverted polarity as they can specify the right polarity in
their DTS when using the standard "reset-gpios" property.

Additionally the condition to enable the transition from standard to
non-standard reset GPIO property name was inverted and the replacement
name for the property was not correct. Fix this as well.

Fixes: fbbbcd177a27 ("gpiolib: of: add quirk for locating reset lines with legacy bindings")
Fixes: 90c2d2eb7ab5 ("MIPS: pci: lantiq: switch to using gpiod API")
Reported-by: Martin Schiller <ms@dev.tdt.de>
Acked-by: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Link: https://lore.kernel.org/r/ZoLpqv1PN08xHioh@google.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-of.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index d9525d95e818d..133d2a4c31a6d 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -192,6 +192,16 @@ static void of_gpio_try_fixup_polarity(const struct device_node *np,
 		 */
 		{ "himax,hx8357",	"gpios-reset",	false },
 		{ "himax,hx8369",	"gpios-reset",	false },
+#endif
+#if IS_ENABLED(CONFIG_PCI_LANTIQ)
+		/*
+		 * According to the PCI specification, the RST# pin is an
+		 * active-low signal. However, most of the device trees that
+		 * have been widely used for a long time incorrectly describe
+		 * reset GPIO as active-high, and were also using wrong name
+		 * for the property.
+		 */
+		{ "lantiq,pci-xway",	"gpio-reset",	false },
 #endif
 	};
 	unsigned int i;
@@ -491,9 +501,9 @@ static struct gpio_desc *of_find_gpio_rename(struct device_node *np,
 		{ "reset",	"reset-n-io",	"marvell,nfc-uart" },
 		{ "reset",	"reset-n-io",	"mrvl,nfc-uart" },
 #endif
-#if !IS_ENABLED(CONFIG_PCI_LANTIQ)
+#if IS_ENABLED(CONFIG_PCI_LANTIQ)
 		/* MIPS Lantiq PCI */
-		{ "reset",	"gpios-reset",	"lantiq,pci-xway" },
+		{ "reset",	"gpio-reset",	"lantiq,pci-xway" },
 #endif
 
 		/*
-- 
2.43.0



