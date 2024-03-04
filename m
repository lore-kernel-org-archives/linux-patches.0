Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5911C6AB;
	Mon,  4 Mar 2024 21:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589384; cv=none; b=iHG49xmP7oHEfuvue06FEVVrRtqMiub+VBCA3RS13ybRxvbC1mo+5qwGVQyNPQ+7NALljNL4m43TfCv86oiQrdGFXR9aM5fbT6N3jgcgC5JzHJLqKkA0RO7xtjiqjjLP4hKfsJpfzCISK+6sXGf5TWaexX4gWxj01a9Bknclh1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589384; c=relaxed/simple;
	bh=2zXzBO1YiF2sTczwRZkdAWw6miMrl2kuHMfFqtbskUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mAa90WWUGNz0bigUwTEEv8GXd91pqNCCnmZNYaf0oDEVHSTtq6/0sHTClza2vZIcMT9eMNtMIs8ny6op/Ucm0P5S8fbM9dWYH1rDeKfgevyUFrumlad+uqEZi94o/03afPyWiR89TFBIawh1SyUDp0GLHz2e+rVVSXxstCc2gas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2auy9SB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2auy9SB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DCBC433F1;
	Mon,  4 Mar 2024 21:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589384;
	bh=2zXzBO1YiF2sTczwRZkdAWw6miMrl2kuHMfFqtbskUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w2auy9SBbqZlpjz5/k4G18TAqWyOjICOTjQQvixdkydVngw5EUWHNHYsfT+nuC8XQ
	 cGYUvZstHIiCJjHCW/9UAUVVafg8I11vdaxGULCrRWgGu8LgfCpe2ah3Gdx/uFG4lt
	 Q5Fof+qoCn36ookw5Rox0xIWHy+4hzB8x1I+TsSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 76/84] gpio: fix resource unwinding order in error path
Date: Mon,  4 Mar 2024 21:24:49 +0000
Message-ID: <20240304211544.935306019@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4245ece1acb60..34a061b4becdb 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -774,11 +774,11 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 
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
@@ -803,11 +803,11 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
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



