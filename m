Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8470D14EC4D;
	Tue,  9 Jul 2024 11:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523810; cv=none; b=DhW3tU/dVFDNuLkVMNdsZyoddm53TN7eQWAa1aaNYcfK1+xpisnkq0eSxRyhS/xkNuLf34msUPXD3KHa+QQiPwbOZGJGEMMC9jcLl1XTanyDPWx8YWq04nV/KCzOw+dpL3dtmk0zGMTS1LWjS5zIfvt7cXeZBOV/63OUGOpEX6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523810; c=relaxed/simple;
	bh=mCPOnKdeh5ks4qPP5wm/N8HRj2TOZafTo5eMXhxgJTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BIDWBbj3/MU7mBEPK4KSFpXEXvYnyf4snOMHPV8b0cpEUH+iq0V91/nb0/v5jDGsJNXvwq0uQurwDcpJBBfnHQOTrhDU9HJKMaWQmhQCgVIVKn7X96H3+EBBIeLI7nx6rIQwK0oEcHd6Q46GSjgnA5S5kSMd/2YwVYnkPlxvx7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TRph+Zmg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TRph+Zmg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07758C3277B;
	Tue,  9 Jul 2024 11:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523810;
	bh=mCPOnKdeh5ks4qPP5wm/N8HRj2TOZafTo5eMXhxgJTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TRph+ZmgSGSMUEVan30oSsPasWojqQ+nUJ8fgCvx6awIOrDke2TgEfUXeSrVBcBQr
	 iGB3IC5vmYvVL8/gXWkOSXtIw7AMJGYsb9sCEGPBJ1SfIsi61YVIebmmjZjFui/bau
	 dFlas478o5gk/HpaaUkISdTCcMMwdSVfJhQrbkLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 086/139] gpiolib: of: add polarity quirk for TSC2005
Date: Tue,  9 Jul 2024 13:09:46 +0200
Message-ID: <20240709110701.500109950@linuxfoundation.org>
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
index 133d2a4c31a6d..cec9e8f29bbdf 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -202,6 +202,14 @@ static void of_gpio_try_fixup_polarity(const struct device_node *np,
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



