Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950AF1C6AB;
	Mon,  4 Mar 2024 21:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589381; cv=none; b=MNBaXDkRN4goRkOeUtG+rZA3cTf0hloXY/N5cLNEf41QUKJu+1U7lFIRg4xoPrqG5TfopnVgPmCjfhwxdEz6SVkQTYxfWLSAfZkvO4d0SgbjGi3LuSWHo+dzLrBYoHalZGFnGSpkMFPf6/DER3iBi6nEbl8S72ofng08SN0wyxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589381; c=relaxed/simple;
	bh=0Y5Tk1mvx1jfppY8I5hMuZclZMHSXYwxKtggFTXXBEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lWNQRaKV78q2YNCs/RufX5KfCgqRTE/kCiAcAmyN40h40zfrig17DU2z9pnvGbEKB4fq+2cY9abX4sz178b82ciWJFwNzqhsOqa597tMwyL40XYdDhEpy7s3WXdYT5Tf5fZ0VlnXC55Y8gJH1Bx33SLl63/sUMZBZ8eg/vlUjy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P/kGn3r8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/kGn3r8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28ED7C433C7;
	Mon,  4 Mar 2024 21:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589381;
	bh=0Y5Tk1mvx1jfppY8I5hMuZclZMHSXYwxKtggFTXXBEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/kGn3r8lUZZGgIFDwnDPQN0Ie7ZLHlQ5940bURaIqN2i9VJy18lyTsBQ98XSmYFg
	 c3bOT+YUFV4URZT8wYmHykxSQh4HKb+lMMgTpVNOZBhxUWO1W5t+Gz1JvDa+S1gjvf
	 3LQCbxhQPooJvWHXNEK1mqQEA1V0p0FbKBmA58Zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 75/84] gpiolib: Fix the error path order in gpiochip_add_data_with_key()
Date: Mon,  4 Mar 2024 21:24:48 +0000
Message-ID: <20240304211544.903685521@linuxfoundation.org>
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
index f9fdd117c654c..4245ece1acb60 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -805,11 +805,11 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
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



