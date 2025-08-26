Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A8C12C499;
	Tue, 26 Aug 2025 12:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212591; cv=none; b=Vn6z8mqsrfiHWAa6LOgmOtPeuQfIK2ijw9jL+UBIPa3PBG5XnxM4IgtEFvehscgM3N8HZVYlDIAZqv16xUgbD1wPdwSy/PUBT3+oBFmX3CMNSNqVEYfG2jrs1ckAUq+pn8BxhsLmz+gYSqP4Q+f4jhIqVvl2k/HRfywRgdzLnWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212591; c=relaxed/simple;
	bh=bJ5n0bNoIZRnVeYav3p0IGBfU6OpidyO2ErOqmSPWTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LmNNUqtDx0krndkt4YL/jA4uRBS1pXDfpHnXZN+27S6twK/map7OU0HP5PNJkhkJjSAOaYaPcueeXFRNyfv12sM2CTHJnfT/EVfop+AGEqUhXVAsw3uRqLqAsYFGIn8IE49gQ26tTZyPDR1tQIpmUnXkpHDCGCNZL6oypHKIR8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U9JrgcjX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U9JrgcjX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82AEC4CEF1;
	Tue, 26 Aug 2025 12:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212591;
	bh=bJ5n0bNoIZRnVeYav3p0IGBfU6OpidyO2ErOqmSPWTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U9JrgcjX6pWE1bAk8F/bVLItiTyySYTu5kgj2gKqQB5+tB2UswDuoeGyFyJm/RAJE
	 XdKdQndXVay31liOaK5TjeCdh97zfVWPN7LFo56qt1m2QxfFg5jD4hJEW4C9xKo604
	 IAP7n4eR+c5QT1KnXoZ+EVy8I660x0z5xTuBtY0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Thompson <davthompson@nvidia.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.6 011/587] gpio: mlxbf3: use platform_get_irq_optional()
Date: Tue, 26 Aug 2025 13:02:40 +0200
Message-ID: <20250826110953.237963149@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


