Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9206E1F7580;
	Mon, 23 Jun 2025 22:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716781; cv=none; b=q5ixSgR7K+daSQE2LlqNpm/1RJfYVym5JWVLbO13urDForau433mByYkFZruqUBVEg4Cbbw0ydIqPmqWbTSwxuhf/7qPGfgBFcnIwzWjqfLyVBJPLS9nDtd9IUCXV5q+CTZB3SnPJEyCU92wqvyKwZOnfpQ1kEGI5LoEpdHl7rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716781; c=relaxed/simple;
	bh=437EngjXTQV0GtCzG6jQ7AXhRvgiGhXWOdSkoISTEgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4xWTp0u+PBkrVFvkqBmeBv+ofJa7T8Uy94jxFdKTAl79kMRvIxgbGn9Zf1oNGJ3S8Lsn1DXgoL+BPm+CBywCfwWbuiPcejwbHJGk2/RnVWy7IB55DojVE4RACQpJ1/gaGXbV5ni6glNT/MUWQb0JcOOZhwkwV3vG5Hfdk010TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iAVZqSfn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iAVZqSfn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF52C4CEEA;
	Mon, 23 Jun 2025 22:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716781;
	bh=437EngjXTQV0GtCzG6jQ7AXhRvgiGhXWOdSkoISTEgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iAVZqSfndF8MEdoqx0koneK8Lk+PsKjyy3V4/VDw/fsZbbt0Pm1RFpV9WSTyVFuVQ
	 tTb8gnYuVntuZzC4J4xc4Iw0th0k49PUVuJfCInF7f4I0nqoPuPheay7+lTze7OlUi
	 QVHBmnKfASA59I555nV8H3c2ydE2BLx2ILKFT7y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Thompson <davthompson@nvidia.com>,
	Shravan Kumar Ramani <shravankr@nvidia.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 289/290] gpio: mlxbf3: only get IRQ for device instance 0
Date: Mon, 23 Jun 2025 15:09:10 +0200
Message-ID: <20250623130635.615091191@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

[ Upstream commit 10af0273a35ab4513ca1546644b8c853044da134 ]

The gpio-mlxbf3 driver interfaces with two GPIO controllers,
device instance 0 and 1. There is a single IRQ resource shared
between the two controllers, and it is found in the ACPI table for
device instance 0.  The driver should not attempt to get an IRQ
resource when probing device instance 1, otherwise the following
error is logged:
  mlxbf3_gpio MLNXBF33:01: error -ENXIO: IRQ index 0 not found

Signed-off-by: David Thompson <davthompson@nvidia.com>
Reviewed-by: Shravan Kumar Ramani <shravankr@nvidia.com>
Fixes: cd33f216d241 ("gpio: mlxbf3: Add gpio driver support")
Link: https://lore.kernel.org/r/20250613163443.1065217-1-davthompson@nvidia.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mlxbf3.c | 54 ++++++++++++++++++++++++--------------
 1 file changed, 35 insertions(+), 19 deletions(-)

diff --git a/drivers/gpio/gpio-mlxbf3.c b/drivers/gpio/gpio-mlxbf3.c
index 10ea71273c891..9875e34bde72a 100644
--- a/drivers/gpio/gpio-mlxbf3.c
+++ b/drivers/gpio/gpio-mlxbf3.c
@@ -190,7 +190,9 @@ static int mlxbf3_gpio_probe(struct platform_device *pdev)
 	struct mlxbf3_gpio_context *gs;
 	struct gpio_irq_chip *girq;
 	struct gpio_chip *gc;
+	char *colon_ptr;
 	int ret, irq;
+	long num;
 
 	gs = devm_kzalloc(dev, sizeof(*gs), GFP_KERNEL);
 	if (!gs)
@@ -227,25 +229,39 @@ static int mlxbf3_gpio_probe(struct platform_device *pdev)
 	gc->owner = THIS_MODULE;
 	gc->add_pin_ranges = mlxbf3_gpio_add_pin_ranges;
 
-	irq = platform_get_irq(pdev, 0);
-	if (irq >= 0) {
-		girq = &gs->gc.irq;
-		gpio_irq_chip_set_chip(girq, &gpio_mlxbf3_irqchip);
-		girq->default_type = IRQ_TYPE_NONE;
-		/* This will let us handle the parent IRQ in the driver */
-		girq->num_parents = 0;
-		girq->parents = NULL;
-		girq->parent_handler = NULL;
-		girq->handler = handle_bad_irq;
-
-		/*
-		 * Directly request the irq here instead of passing
-		 * a flow-handler because the irq is shared.
-		 */
-		ret = devm_request_irq(dev, irq, mlxbf3_gpio_irq_handler,
-				       IRQF_SHARED, dev_name(dev), gs);
-		if (ret)
-			return dev_err_probe(dev, ret, "failed to request IRQ");
+	colon_ptr = strchr(dev_name(dev), ':');
+	if (!colon_ptr) {
+		dev_err(dev, "invalid device name format\n");
+		return -EINVAL;
+	}
+
+	ret = kstrtol(++colon_ptr, 16, &num);
+	if (ret) {
+		dev_err(dev, "invalid device instance\n");
+		return ret;
+	}
+
+	if (!num) {
+		irq = platform_get_irq(pdev, 0);
+		if (irq >= 0) {
+			girq = &gs->gc.irq;
+			gpio_irq_chip_set_chip(girq, &gpio_mlxbf3_irqchip);
+			girq->default_type = IRQ_TYPE_NONE;
+			/* This will let us handle the parent IRQ in the driver */
+			girq->num_parents = 0;
+			girq->parents = NULL;
+			girq->parent_handler = NULL;
+			girq->handler = handle_bad_irq;
+
+			/*
+			 * Directly request the irq here instead of passing
+			 * a flow-handler because the irq is shared.
+			 */
+			ret = devm_request_irq(dev, irq, mlxbf3_gpio_irq_handler,
+					       IRQF_SHARED, dev_name(dev), gs);
+			if (ret)
+				return dev_err_probe(dev, ret, "failed to request IRQ");
+		}
 	}
 
 	platform_set_drvdata(pdev, gs);
-- 
2.39.5



