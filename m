Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168361C687;
	Mon,  4 Mar 2024 21:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588149; cv=none; b=MicSqeNTIdjGd+6fJYCFcKoVF2s2AoMRpAmF7EtRCeoszvlIjCKqBv3bgPq9RbmgJloCxgAsNCVTA4qaAuxmfONOtkP03aZ9UtECoB1nvVEjd5PlnPr2p0cdlQf8DJ8pySE8ZVLjfQpLujD56icwR78UG1EqnWLWLE6OalndMC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588149; c=relaxed/simple;
	bh=2G/4Zth9obOF50j/M/6cn9eYRBo9w/oEVV+Shcp8wkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZPk8fzDprIrD5flKmiXBA/GusYOHSnB1A/kvVQhLaTdqsSmHO1zdPImnCWnA/liHcl3AxgVDKbU/hcrFtaoHpXuQx7yLuNL5h0bPB7+q1BFSKUilqS1a4oqxK2mFwm2abzHYJ+hEgEytzLRIhMPfJo5gtOTUJKxwKb88vc2Pf4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dn51sjhT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dn51sjhT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8E9C43390;
	Mon,  4 Mar 2024 21:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588149;
	bh=2G/4Zth9obOF50j/M/6cn9eYRBo9w/oEVV+Shcp8wkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dn51sjhTC1rFBEEcEvO95jSzwnI8AWZeQD1VxkG6JtvaEQa9WEBaOV2Y8nKNMRokJ
	 7llWc9Q6htlAnIVa2dUn+FEgBbXJ2/PpH4pEN313TvefuQbGOWfs4COlMzzHkRfjlU
	 mQaeA3QAwaAqaILpH3UExbnJ4WQ5FNybcLcKLAo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 39/42] gpiolib: Fix the error path order in gpiochip_add_data_with_key()
Date: Mon,  4 Mar 2024 21:24:06 +0000
Message-ID: <20240304211538.965607345@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211537.631764077@linuxfoundation.org>
References: <20240304211537.631764077@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d10f621085e2e..9c3aa518e6b79 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -763,11 +763,11 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
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
 err_remove_from_list:
 	spin_lock_irqsave(&gpio_lock, flags);
-- 
2.43.0



