Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C256A1C687;
	Mon,  4 Mar 2024 21:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587992; cv=none; b=C/MyU1kJnEWp6nuTWUZNEovp4ms21mAyiCyDfLT1c/NDJiFIsvSS/2rOVIttNvfmQnWsBAj9ddxYb8++cuoolc18VTl8IYojnjVQ/5ZPPZZ5a+h5hp6VExKSNossHDyPR9iouHjm1vlzPpg9qix0EFtGmFmsBry9qauXp06VYX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587992; c=relaxed/simple;
	bh=UYtwNh9wzJFUuC7IRLvv1p/WOz5DRSyTg4a3MnAyf1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rqc5mjrlMnNpUGqaBVIJ2nKb/H6IaGU/0DcRJUjiWsEJTjwdFuYmXb8X07xBSXkvq9cGsUPsGp/+F722+tiTV1xrooRQDcVaPiYhN7gx4DIVx3c/kkiKdEOEiDstqbtilcgMhLnl894mcrxhlNuylyvWoiSXkjxc2UKoLz4NOBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MM0jxeBG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MM0jxeBG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FDCC433F1;
	Mon,  4 Mar 2024 21:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587992;
	bh=UYtwNh9wzJFUuC7IRLvv1p/WOz5DRSyTg4a3MnAyf1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MM0jxeBGdLC9Pcr4RE2y1gN867fpTeOcEX8kSeaMj9mJt6mgK1IgUAtH/ViZ3Nv/C
	 q/eZL+FWXg1HbuJy4RxMCsEywHWAyHr9vW9FBVFV98eQu5dQ38/ffMdh78SaGTsyix
	 R5ArAjlBDQsmuh3SlWmrHIiT5zDnvM2zJxksaNJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 150/162] gpio: fix resource unwinding order in error path
Date: Mon,  4 Mar 2024 21:23:35 +0000
Message-ID: <20240304211556.487739317@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit ec5c54a9d3c4f9c15e647b049fea401ee5258696 ]

Hogs are added *after* ACPI so should be removed *before* in error path.

Fixes: a411e81e61df ("gpiolib: add hogs support for machine code")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index e8dc706fd7979..1d033106cf396 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -972,11 +972,11 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 
 	ret = gpiochip_irqchip_init_valid_mask(gc);
 	if (ret)
-		goto err_remove_acpi_chip;
+		goto err_free_hogs;
 
 	ret = gpiochip_irqchip_init_hw(gc);
 	if (ret)
-		goto err_remove_acpi_chip;
+		goto err_remove_irqchip_mask;
 
 	ret = gpiochip_add_irqchip(gc, lock_key, request_key);
 	if (ret)
@@ -1001,11 +1001,11 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 	gpiochip_irqchip_remove(gc);
 err_remove_irqchip_mask:
 	gpiochip_irqchip_free_valid_mask(gc);
-err_remove_acpi_chip:
+err_free_hogs:
+	gpiochip_free_hogs(gc);
 	acpi_gpiochip_remove(gc);
 	gpiochip_remove_pin_ranges(gc);
 err_remove_of_chip:
-	gpiochip_free_hogs(gc);
 	of_gpiochip_remove(gc);
 err_free_gpiochip_mask:
 	gpiochip_free_valid_mask(gc);
-- 
2.43.0



