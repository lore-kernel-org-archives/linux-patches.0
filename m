Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F701C6AB;
	Mon,  4 Mar 2024 21:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589155; cv=none; b=INiVyOO9HMIBlacoZuNtHCGqr9AAmRRfY4SsoL2FW88v8Z7qUvAXjiBRsd69tDk505xl1QAuUSnRfqOwAQgJtN9ZjL4zLxECDoKwhBQVNnL7TGC1MHJCbTtet65POIL7oxtrgbGi+rA+sDIJ++u7y00xprvCQc7/Y2952gnZQ6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589155; c=relaxed/simple;
	bh=9rDK3VRFr3EYfAGWF4eT1W5tN/uYbKJX+1jeG0rLEGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPWHUvmbejrSYGbMjwR4ziI97tj3LhkuXMK3HqhXWYHXBG4vCMo6KYT8DwAIMGX2Rx1SvchpaxDpRBboWQvxulE3nRhR1Fq5SpLzC9KAP6f8uRreCNy+k3yZQLVYTV+UFQlKOIDFhhYb0FbuNwKZBxYu6HsrJ4EitrxbptwJi9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VaSOQqyF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VaSOQqyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64615C433C7;
	Mon,  4 Mar 2024 21:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589155;
	bh=9rDK3VRFr3EYfAGWF4eT1W5tN/uYbKJX+1jeG0rLEGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VaSOQqyFbiTNiWABEwpe9vrh87ZJmAfsi4HoXh5uzc/K414FYPel8Rc5Hek1g+d8t
	 a6/BJrHVh+J/u/iUQGHXilvORKttnIGLlBWpzhV+m7sqsxEApzhzCzQeTkNUpwSZeP
	 lDAxyGm85UCBzzBvbS4N6qGUdeYzUiVpLN/91ISQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 202/215] gpio: fix resource unwinding order in error path
Date: Mon,  4 Mar 2024 21:24:25 +0000
Message-ID: <20240304211603.398651331@linuxfoundation.org>
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
index f646df7f1b41a..9d8c783124033 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -784,11 +784,11 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 
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
@@ -813,11 +813,11 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
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



