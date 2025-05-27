Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9703C01;
	Tue, 27 May 2025 17:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367389; cv=none; b=QC/0RAmGhQRSHO1yoKizF5eesn5Kb0a2o/AEE+LkpQ19GZrS4f0IocCTY7MX/Mb0M7cj4tevxvd6S96vg6zRzT1U9s32Yq98VzqQicB9TjeIpUqNzctXBT6nedN1ZsetsunoMfY5paDiF8Ye6QdkMnbYlHfOYCj7wWVeYmIDDoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367389; c=relaxed/simple;
	bh=2kRaakITvzP9paiWUC8o1lh7PbOb+peuOQXexvIesCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gC2yKUPCDF48Cfm9/X88xsH5wIV5A/og/+4GI+w2Cw/lDVnPILTm19A7qOzxNAY2fLHk+TxlJ3p2KtR4uMoqldi8B+Sa+wwtyMM1j4LRhRdQzSMb0zmBnIQxZVsZNBq+snkQGTZHS1WQp5o8L0RlmYAWofQYepQfMfil9D85mv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UVB7rutg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UVB7rutg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED32C4CEEB;
	Tue, 27 May 2025 17:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367388;
	bh=2kRaakITvzP9paiWUC8o1lh7PbOb+peuOQXexvIesCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UVB7rutgM2QspnqBLNOs1t/cLJj8M0A8r6oph2R7TV4Hnba12aufa+zvfpHzv/E4o
	 6HtaX3JfYajSDfUV7mBmVIVYVrEibndu0EqzjB+uRNrz/eJGmu+KwFGgx6YHWvfJyt
	 7T4E0kqyBjBF3wGrN0MbZjLUvoVDwRKjCbzRYMuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 371/783] gpiolib: sanitize the return value of gpio_chip::set_config()
Date: Tue, 27 May 2025 18:22:48 +0200
Message-ID: <20250527162528.195079150@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit dcf8f3bffa2de2c7f3b5771b63605194ccd2286f ]

The return value of the set_config() callback may be propagated to
user-space. If a bad driver returns a positive number, it may confuse
user programs. Tighten the API contract and check for positive numbers
returned by GPIO controllers.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20250210-gpio-sanitize-retvals-v1-3-12ea88506cb2@linaro.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c      | 3 +++
 include/linux/gpio/driver.h | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 0c00ed2ab4315..960ca0ad45fc8 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2577,6 +2577,9 @@ int gpio_do_set_config(struct gpio_desc *desc, unsigned long config)
 		return -ENOTSUPP;
 
 	ret = guard.gc->set_config(guard.gc, gpio_chip_hwgpio(desc), config);
+	if (ret > 0)
+		ret = -EBADE;
+
 #ifdef CONFIG_GPIO_CDEV
 	/*
 	 * Special case - if we're setting debounce period, we need to store
diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index 2dd7cb9cc270a..5ce6b2167f808 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -347,7 +347,8 @@ struct gpio_irq_chip {
  * @set: assigns output value for signal "offset"
  * @set_multiple: assigns output values for multiple signals defined by "mask"
  * @set_config: optional hook for all kinds of settings. Uses the same
- *	packed config format as generic pinconf.
+ *	packed config format as generic pinconf. Must return 0 on success and
+ *	a negative error number on failure.
  * @to_irq: optional hook supporting non-static gpiod_to_irq() mappings;
  *	implementation may not sleep
  * @dbg_show: optional routine to show contents in debugfs; default code
-- 
2.39.5



