Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320FA7BAFE;
	Mon,  4 Mar 2024 21:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587990; cv=none; b=RT10ajGWPuO7HJkNhW626sFW+T9PoZViaUButufKFhnD3p4YsJzpbgiMh7f7DLPH5bS0Ab+ey2k/F3O2iiJWOnKd3F9WUeDiblKzU4jnTxec8PWm/zInOMSBWej4yfiS3AaEz3ESNqZK7ePlRv3p/t6XHQpD7Xix6PX0QHUmJl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587990; c=relaxed/simple;
	bh=x8Lqfw/H0ZAQXk3S9LItYM+ik9aYhSjeAeIGJjJpG7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bO1+Ayv8jO+DJAvcVFAzGyAWF6dUqu+kZ9acjRhtKwxt0CRkZto05rRh9BkVTrfpS3aBK5rDnAVgo/9klL7whZqlBavGDoMxYqdtKn3HpDEDjDdNThk+kiJBFR13filMJjhRcRvwxeKfofXzy4hpWcVfqdFFP67ARBKSLAiHM3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yM4bV+AE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yM4bV+AE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B404BC433F1;
	Mon,  4 Mar 2024 21:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587990;
	bh=x8Lqfw/H0ZAQXk3S9LItYM+ik9aYhSjeAeIGJjJpG7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yM4bV+AE4nbpGuXDbascQWGFDMRSw3waocFLE1Ak0EPbiI0qsOHx0TJsl6Q6KdydE
	 B7By+TAjQ5ZrtiRgEcOo+stinEl3aRb0t28s5Totu1pH2sUewhmJumTZ2NfoT0rwFp
	 ppfQLktmuDB+jEZnBLw1BhJjFcbDkPUWG+ExLfuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 149/162] gpiolib: Fix the error path order in gpiochip_add_data_with_key()
Date: Mon,  4 Mar 2024 21:23:34 +0000
Message-ID: <20240304211556.461037577@linuxfoundation.org>
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
index 15de124d5b402..e8dc706fd7979 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1003,11 +1003,11 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
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



