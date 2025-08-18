Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2929E30DEC8;
	Mon, 18 Aug 2025 13:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524637; cv=none; b=tBVi7U8aeiot8tJorL5zqoXa5OmM3s+dBxkl8IrOzX1Z1WZoZeokyq24edWUsOym+j2TdRWsfP6Z5trC/rLonOYG8HtHVEN9sm+PgilFThCQRXv33Wegxf1BOtYgYCIKEDHq12M5B9g8dAMQaQHOMORcovD2yOYCPMR1mBlDS7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524637; c=relaxed/simple;
	bh=Wt6oXE7rNSLsPdVqn2QBFrZ5csCQq/SzkcIYaeF7bCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgOIFYiIA9swniR/2CglE4psaTGqW+XE8Txa+rZXLPxH0LES7DvjaGpme6BObt1IacIuih2L8CCiCT+8IuaVNxCyp15+ZLdIJhr78h+xVtRu5Z0YOP9AGZQ8TL58GR466/2K1Krzr8VstL0Nr7R/vNwNBkwTmTNAZOrTxiElh60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=USo96jxq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="USo96jxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DEA3C4CEEB;
	Mon, 18 Aug 2025 13:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524637;
	bh=Wt6oXE7rNSLsPdVqn2QBFrZ5csCQq/SzkcIYaeF7bCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=USo96jxqYOudIBJ3DZLorGT17UKbzI03xibRUPBvilVX4P0u3q7tU8mEaoy7tWKTz
	 6zRS6r7Z0UswCEdEfzpwUszgMdiTmIaVAQoCt7nKGc1aBnxYx8yLMQtjVre1g8rCht
	 TKE9FekB9RMqLwJJO3q/4vxGbEydFmKumlvVVM9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Thompson <davthompson@nvidia.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.16 017/570] Revert "gpio: mlxbf3: only get IRQ for device instance 0"
Date: Mon, 18 Aug 2025 14:40:04 +0200
Message-ID: <20250818124506.460902042@linuxfoundation.org>
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

commit 56bdf7270ff4f870e2d4bfacdc00161e766dba2d upstream.

This reverts commit 10af0273a35ab4513ca1546644b8c853044da134.

While this change was merged, it is not the preferred solution.
During review of a similar change to the gpio-mlxbf2 driver, the
use of "platform_get_irq_optional" was identified as the preferred
solution, so let's use it for gpio-mlxbf3 driver as well.

Cc: stable@vger.kernel.org
Fixes: 10af0273a35a ("gpio: mlxbf3: only get IRQ for device instance 0")
Signed-off-by: David Thompson <davthompson@nvidia.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/8d2b630c71b3742f2c74242cf7d602706a6108e6.1754928650.git.davthompson@nvidia.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-mlxbf3.c |   54 +++++++++++++++------------------------------
 1 file changed, 19 insertions(+), 35 deletions(-)

--- a/drivers/gpio/gpio-mlxbf3.c
+++ b/drivers/gpio/gpio-mlxbf3.c
@@ -190,9 +190,7 @@ static int mlxbf3_gpio_probe(struct plat
 	struct mlxbf3_gpio_context *gs;
 	struct gpio_irq_chip *girq;
 	struct gpio_chip *gc;
-	char *colon_ptr;
 	int ret, irq;
-	long num;
 
 	gs = devm_kzalloc(dev, sizeof(*gs), GFP_KERNEL);
 	if (!gs)
@@ -229,39 +227,25 @@ static int mlxbf3_gpio_probe(struct plat
 	gc->owner = THIS_MODULE;
 	gc->add_pin_ranges = mlxbf3_gpio_add_pin_ranges;
 
-	colon_ptr = strchr(dev_name(dev), ':');
-	if (!colon_ptr) {
-		dev_err(dev, "invalid device name format\n");
-		return -EINVAL;
-	}
-
-	ret = kstrtol(++colon_ptr, 16, &num);
-	if (ret) {
-		dev_err(dev, "invalid device instance\n");
-		return ret;
-	}
-
-	if (!num) {
-		irq = platform_get_irq(pdev, 0);
-		if (irq >= 0) {
-			girq = &gs->gc.irq;
-			gpio_irq_chip_set_chip(girq, &gpio_mlxbf3_irqchip);
-			girq->default_type = IRQ_TYPE_NONE;
-			/* This will let us handle the parent IRQ in the driver */
-			girq->num_parents = 0;
-			girq->parents = NULL;
-			girq->parent_handler = NULL;
-			girq->handler = handle_bad_irq;
-
-			/*
-			 * Directly request the irq here instead of passing
-			 * a flow-handler because the irq is shared.
-			 */
-			ret = devm_request_irq(dev, irq, mlxbf3_gpio_irq_handler,
-					       IRQF_SHARED, dev_name(dev), gs);
-			if (ret)
-				return dev_err_probe(dev, ret, "failed to request IRQ");
-		}
+	irq = platform_get_irq(pdev, 0);
+	if (irq >= 0) {
+		girq = &gs->gc.irq;
+		gpio_irq_chip_set_chip(girq, &gpio_mlxbf3_irqchip);
+		girq->default_type = IRQ_TYPE_NONE;
+		/* This will let us handle the parent IRQ in the driver */
+		girq->num_parents = 0;
+		girq->parents = NULL;
+		girq->parent_handler = NULL;
+		girq->handler = handle_bad_irq;
+
+		/*
+		 * Directly request the irq here instead of passing
+		 * a flow-handler because the irq is shared.
+		 */
+		ret = devm_request_irq(dev, irq, mlxbf3_gpio_irq_handler,
+				       IRQF_SHARED, dev_name(dev), gs);
+		if (ret)
+			return dev_err_probe(dev, ret, "failed to request IRQ");
 	}
 
 	platform_set_drvdata(pdev, gs);


