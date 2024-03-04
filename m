Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2278979DCE;
	Mon,  4 Mar 2024 21:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588542; cv=none; b=dKp8/5VmiGZHuCctTlllan7yMYgvzaDZcdT5yxGb53jiKis0gSnWsjmLP3wShEZRImKXl3JuiH+8EMdXbtSBGrsTSKxhOPgX7WVeoT9LTtAXTSua04RHLdZr8w4YASVo9cXI4/BOb7NU/nTmzD5jUSnNNs9FXrgZuuU0LDBljjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588542; c=relaxed/simple;
	bh=FQu/QLA9nd6jgPAn7Xr2NBwqnNJIytqQEfVoiwxAyx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KEJ8y0+6ekmYk74G94+zKcf3XD86srrSEtVSxODyeXsm9H2A9JLtIOW4fzDYCq4pHQ7ceZsfSh0qzver+Pp6Yfr5WL2irLsgFTCf4KJZN2C/Wdyp7AkuxZMVD0Q5qHqplOgpbxqNX21UHG0KWOh8BWfPm+tugm+TVPVvQ37JV3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZXC71D29; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZXC71D29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878B9C433F1;
	Mon,  4 Mar 2024 21:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588541;
	bh=FQu/QLA9nd6jgPAn7Xr2NBwqnNJIytqQEfVoiwxAyx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZXC71D29khfGScy7T7Xo4pv+PZh6XFm6GrqjD1CkBZshrtzDHn2QBHmiblhwJmT3v
	 2sGP7N51itypvbzFjFa4lt706uUAC4NHpjI5drhPuWxaL3ZmkPFjbcl9gxeFe6cdJl
	 X9TjxM6LbeRGWFTfXpZjncN3822EDICVFmeXwqzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 131/143] gpio: fix resource unwinding order in error path
Date: Mon,  4 Mar 2024 21:24:11 +0000
Message-ID: <20240304211554.098017465@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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
index 53ab4e62503fd..deca1d43de9ca 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -894,11 +894,11 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 
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
@@ -923,11 +923,11 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
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



