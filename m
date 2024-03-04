Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFB01C6AB;
	Mon,  4 Mar 2024 21:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589153; cv=none; b=Aabo1v0cv/9eRETu3yh7MYF19QO7TmHiRPNllF6fZNzIm4FZNMa/7V2oOHcV0azmLxnCUjOXgHGeuB44CrN9FNUyCrfOTU2B1wZQOtNZQqViMtJ7n87bON9rQoKSwV1mheeOf+OJuvkr6RFhGk/QdtaCxo915JptpPwGRkdPJgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589153; c=relaxed/simple;
	bh=1qf9R1f4p3N4OigGpuIM1kJod+muvuZLe3mnOYRkxwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDeosD7SBC9zybTyoLHwkatPTr6/zVLc+GqyaUL04i0bgY3ZFxBV6Br14/3EAmDArmm2G83o+Llj/LqebrydNEa1SRpDyyIO7JMbr62EO1rB15787vK2gj5S6lxDL6VdHBcItv21bKb7mrZ+HTkpa5AuIJcghIZOOXcWKGBp9cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e6u8Y8Wj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e6u8Y8Wj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3538C433C7;
	Mon,  4 Mar 2024 21:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589153;
	bh=1qf9R1f4p3N4OigGpuIM1kJod+muvuZLe3mnOYRkxwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e6u8Y8Wj78Ggn60bsAYNHMYgSxkEjyhCLbfwfv7W5dfnuUG1ChC/cEMzE0eLJ16Ub
	 CEUNGMGpwAUDm8R6d84qk7paHVnMOVV4/jp2YcyspUPmH4DpURbyTym+yIgFERVqjo
	 IU8bxBzU5I8oAAVsTFPeWeaDjaDlduFdylJvKNkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 201/215] gpiolib: Fix the error path order in gpiochip_add_data_with_key()
Date: Mon,  4 Mar 2024 21:24:24 +0000
Message-ID: <20240304211603.362214436@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit e4aec4daa8c009057b5e063db1b7322252c92dc8 ]

After shuffling the code, error path wasn't updated correctly.
Fix it here.

Fixes: 2f4133bb5f14 ("gpiolib: No need to call gpiochip_remove_pin_ranges() twice")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 6d3e3454a6ed6..f646df7f1b41a 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -815,11 +815,11 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 	gpiochip_irqchip_free_valid_mask(gc);
 err_remove_acpi_chip:
 	acpi_gpiochip_remove(gc);
+	gpiochip_remove_pin_ranges(gc);
 err_remove_of_chip:
 	gpiochip_free_hogs(gc);
 	of_gpiochip_remove(gc);
 err_free_gpiochip_mask:
-	gpiochip_remove_pin_ranges(gc);
 	gpiochip_free_valid_mask(gc);
 	if (gdev->dev.release) {
 		/* release() has been registered by gpiochip_setup_dev() */
-- 
2.43.0



