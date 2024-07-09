Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740ED13A25F;
	Tue,  9 Jul 2024 11:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524330; cv=none; b=rx5uCyOq6xwt9xyJHWiQF/rw3YLpa8MpKMGeaavlZJexV/aE8+QG65sLZBQDDTJqhdc0Kj2MZXBp2wg/kZADv5Ui7XyRq4nZK0sZxnTx9dCoYiAOewNfAB9u9FP4T4JsM7VPO4jQX6aZavh9IQ77LMzgMeOPjAWfsokAvxCNp0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524330; c=relaxed/simple;
	bh=S4seHr6J3agTnUZKRn9TSkIXVl1kBmpIK0gbjFD9218=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LIw0RX52YMg9HbjGKK7NCaoQFmHLsA8s8mk5wu1jLwBp9EwOiS39YTeVtcMefjLFpPw9OmNaiKRAQxtXzKU3qFGr6pPblqGPw83umKQbDchMAzYF5j8gK1SMUIAt1F22vIeuzP4Oo0EBnirbQry+ww0Ap6je+Ha3jKlw2xXVWyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XtrxFj62; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XtrxFj62"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE544C3277B;
	Tue,  9 Jul 2024 11:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524330;
	bh=S4seHr6J3agTnUZKRn9TSkIXVl1kBmpIK0gbjFD9218=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XtrxFj620+5qAF6ShAeUkxM1hXI99Opubbj4+JcBZTOdyyK4Lx8VPZqcgnWnsPAie
	 hNIXvU+uHkmIqSEZ2blXRAarZwEp5N/wzSOecEzyST9GFLlFPqUBqVzu0aO3fbSIyQ
	 R55dKw2QMfgFSOgtWSxnMLCUtt1q/O5/MyP1qfrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 130/197] gpiolib: of: add polarity quirk for TSC2005
Date: Tue,  9 Jul 2024 13:09:44 +0200
Message-ID: <20240709110713.983121360@linuxfoundation.org>
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

[ Upstream commit f8d76c2c313c56d5cb894a243dff4550f048278d ]

DTS for Nokia N900 incorrectly specifies "active high" polarity for
the reset line, while the chip documentation actually specifies it as
"active low".  In the past the driver fudged gpiod API and inverted
the logic internally, but it was changed in d0d89493bff8.

Fixes: d0d89493bff8 ("Input: tsc2004/5 - switch to using generic device properties")
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/ZoWXwYtwgJIxi-hD@google.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-of.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 7db35cbde8e92..5c4442200118a 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -212,6 +212,14 @@ static void of_gpio_try_fixup_polarity(const struct device_node *np,
 		 * for the property.
 		 */
 		{ "lantiq,pci-xway",	"gpio-reset",	false },
+#endif
+#if IS_ENABLED(CONFIG_TOUCHSCREEN_TSC2005)
+		/*
+		 * DTS for Nokia N900 incorrectly specified "active high"
+		 * polarity for the reset line, while the chip actually
+		 * treats it as "active low".
+		 */
+		{ "ti,tsc2005",		"reset-gpios",	false },
 #endif
 	};
 	unsigned int i;
-- 
2.43.0



