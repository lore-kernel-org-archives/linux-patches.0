Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D321216E23;
	Mon, 18 Aug 2025 13:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524640; cv=none; b=G0eFaZjDLLf4ZUz0b2Gf7KflKNZyNDEDAzJYbVfIvIj5Iwyv0LohRuEp5a5H3s6wCxkI3ZhpmmacfQ4fOKo6b6oaK6lnVWe9WaJMPRhm1hpfBpfWcK0LI6Ng1VsyJgnul57GYGQPUxJtj2egPPhO8sJmD2BrH6rPkSbwZpPprGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524640; c=relaxed/simple;
	bh=yoDXVwgj38vWH57vFVfH3jmM+dOiMmDv1us7N31CaQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGVofA0SmeCpDuYAM8iy1c8T/UinVS3KYhK3m2zzlXCzfp5qRnE9HbNX8JYoJbR0umLjBI1pEu+Ht9dC1osSS1QhRjKTNjn+AQM2J/DBznrZYqya6v4Nf6CtmMvxfSSo8F62OdzUao4lUo5Vf0X4OH11kfqLOdqF3JETacjQC5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/7856Nj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/7856Nj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1078FC4CEEB;
	Mon, 18 Aug 2025 13:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524640;
	bh=yoDXVwgj38vWH57vFVfH3jmM+dOiMmDv1us7N31CaQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o/7856NjmbZ8LuA5FF2PI22rloHoNw/cy7XnkF7bSQddeEL6p9zbKnoaB5Io8RyGf
	 Wpoa5ufo0ITGnR1/APDuN+busngnpp26TrEkiAGrGd2PROtZQsy4LwydaykUx1glyt
	 Np+KLrTIWdUeQoylJDEv1dxvmt79tjrI3R94CkiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Thompson <davthompson@nvidia.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.16 018/570] gpio: mlxbf3: use platform_get_irq_optional()
Date: Mon, 18 Aug 2025 14:40:05 +0200
Message-ID: <20250818124506.502532443@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Thompson <davthompson@nvidia.com>

commit 810bd9066fb1871b8a9528f31f2fdbf2a8b73bf2 upstream.

The gpio-mlxbf3 driver interfaces with two GPIO controllers,
device instance 0 and 1. There is a single IRQ resource shared
between the two controllers, and it is found in the ACPI table for
device instance 0. The driver should not use platform_get_irq(),
otherwise this error is logged when probing instance 1:
    mlxbf3_gpio MLNXBF33:01: error -ENXIO: IRQ index 0 not found

Cc: stable@vger.kernel.org
Fixes: cd33f216d241 ("gpio: mlxbf3: Add gpio driver support")
Signed-off-by: David Thompson <davthompson@nvidia.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/ce70b98a201ce82b9df9aa80ac7a5eeaa2268e52.1754928650.git.davthompson@nvidia.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-mlxbf3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-mlxbf3.c
+++ b/drivers/gpio/gpio-mlxbf3.c
@@ -227,7 +227,7 @@ static int mlxbf3_gpio_probe(struct plat
 	gc->owner = THIS_MODULE;
 	gc->add_pin_ranges = mlxbf3_gpio_add_pin_ranges;
 
-	irq = platform_get_irq(pdev, 0);
+	irq = platform_get_irq_optional(pdev, 0);
 	if (irq >= 0) {
 		girq = &gs->gc.irq;
 		gpio_irq_chip_set_chip(girq, &gpio_mlxbf3_irqchip);


