Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FDBEEAB;
	Tue, 26 Aug 2025 12:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212588; cv=none; b=Gg/fpkHz8jEq4zrkpMqOds9uzDw/zgrm2Me6mKULOACe/vUzIUelSXISTCsuvIZKftf68/euDVLdypLIyQt/pVtubTogiLC6D8r+VPVRyqbdCZzGYwZVWBlkSIaAI+BtCj91CbCrD7Ye96rbjdVFACqf1dkR0Qus8TR1FLiW1Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212588; c=relaxed/simple;
	bh=zNjn6wdzb4mdai7oiNmILSW857lOFs+rd6P+S3JW37Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IH9l6dzm0uz19fX1D+dDI6eDL3mqb9wWbGlmU0tYtrGechOSxxzTDGhsu+7l2vOpCo+mlT5g2dPoUF+aTEGmbKHntMil8qCeEIbU1GHDX2mzQmHNQLFsODwUhO2gNX9eQx0x0sU8w9o6b/Dml9hlJh+h8tfIlKPqdU0qrKm3Oik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F99wije3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F99wije3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271EDC4CEF1;
	Tue, 26 Aug 2025 12:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212588;
	bh=zNjn6wdzb4mdai7oiNmILSW857lOFs+rd6P+S3JW37Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F99wije33D1b3DbpXDca2nbxpPp1KWbffB7iKZJQ9T9M4GS5izedxvGA2JvExcZg3
	 HDhocbDYobN4/KBBpaFgWCsRJExsZAShF0pBHhNWISnLZ0ICgO/EU3FVnN192/IgBV
	 vc2wPSyDBnrW7alSy0TNlhFnbBavU4QT+pEoMCyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Thompson <davthompson@nvidia.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.6 010/587] Revert "gpio: mlxbf3: only get IRQ for device instance 0"
Date: Tue, 26 Aug 2025 13:02:39 +0200
Message-ID: <20250826110953.214238911@linuxfoundation.org>
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


