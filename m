Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6761D13A25F;
	Tue,  9 Jul 2024 11:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524281; cv=none; b=kWl0Af7Mcf6lFLrOX1y225tyX49yP7dqoJqJiO6QQLQiQbaylZJDanRIVK2GIwcLxQy0uj8KIXDtMq37PHS4DmKcqY7J44nSeDVk2iObZgVv+cNUB99J6JiNQem1DqTXiqrrZzjnMonqOukCl6/YgZXCu4kYEs4LGjKcS2mbJ08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524281; c=relaxed/simple;
	bh=PUnMPZIvY5aVc8yrwG0SrJ7buAek+aHM0wGSI+pf5C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVDUR75qlEi0cXTh+BV8nyYZjdtYvM/myu8Yl02v1NHA3fcAc7kpzHq7cymOPYpExySL4msQvRWIKZzJNOzcGHq2eEvt54X01Q1XV+y4Y1FDqtpdTbHWCUt5ucJcG5x69q7qoXCwDUNYQ5+DjwO/6f3N1PrIskl8kqIEh9U9Qkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pMpqE+hY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pMpqE+hY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E191CC3277B;
	Tue,  9 Jul 2024 11:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524281;
	bh=PUnMPZIvY5aVc8yrwG0SrJ7buAek+aHM0wGSI+pf5C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pMpqE+hYeu6hQucclSMEMk/P1Lzwfm2OqHr253msWnXZOJOTx2eXwACiofoW//Npo
	 f2RBKr1gZSINuSw5w8qcDD0Eb3xNXfHihpFcdXKp0Di5RnDd2wrltt4FzXnPAKu6sr
	 0BQNFRb17xvjW1d4pDjOprlEVcS0XuOGWcq0LgG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Schiller <ms@dev.tdt.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 101/197] gpiolib: of: fix lookup quirk for MIPS Lantiq
Date: Tue,  9 Jul 2024 13:09:15 +0200
Message-ID: <20240709110712.868401481@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index cb0cefaec37e8..7db35cbde8e92 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -202,6 +202,16 @@ static void of_gpio_try_fixup_polarity(const struct device_node *np,
 		 * helper, and be consistent with what other drivers do.
 		 */
 		{ "qi,lb60",		"rb-gpios",	true },
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
@@ -504,9 +514,9 @@ static struct gpio_desc *of_find_gpio_rename(struct device_node *np,
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



