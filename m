Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D637326ED41;
	Fri,  9 Jan 2026 12:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961010; cv=none; b=nuKO3/QII8Rocj7Vtjv8O0UwOSSkIp6ize/EL0MDsPL+PDcZewtdSKi/b8O/sR1X1zTJqLItHjVE+zKGnWogtwLjSIpUcPnnYeyGPbGmyWg3YwmPzAKHz0/JaHRbISDt78VXfjFaj4p4vXUB3dpxZfPlKogmH5EOqfWcrhdrhls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961010; c=relaxed/simple;
	bh=dhU+kX8Ef5Z3BDZXqEX/z2pw68rbBJEH7Sm/ij3oTHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmNO8kTIa1R94bm2aqMQIYGuGo66Na4E10Vl604dsbdP3nnkkjJkaQDFWpDEUB1CXkr+HOi+qii+zR7DBKn6B7obvGlE9awHWWz+kYIeXVMYBz4aBmrmfJifxh5bsr9nWR6gJwZ1k8WEvsD+RNQUdJ/zyudbFQksiamz0HJG9iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ergj6tfd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ergj6tfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB58C4CEF1;
	Fri,  9 Jan 2026 12:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961010;
	bh=dhU+kX8Ef5Z3BDZXqEX/z2pw68rbBJEH7Sm/ij3oTHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ergj6tfd0zryZ7wQkaHorVO+NkPFK2RtMfhFzgvGbayfzcAucrXwDW3UklAVtFlWq
	 Vv/fm7CdpadzkQur93IRtecngETK9U1+cVzSqcK/+bk5zDwxP2rVlkL80Y7fhtKkC/
	 FFc6hMEz4rWlOwkypAnBYrKQhvKQhRF8XwovrLPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 571/737] mfd: max77620: Fix potential IRQ chip conflict when probing two devices
Date: Fri,  9 Jan 2026 12:41:50 +0100
Message-ID: <20260109112155.480873374@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 2bac49bad1f3553cc3b3bfb22cc194e9bd9e8427 upstream.

MAX77620 is most likely always a single device on the board, however
nothing stops board designers to have two of them, thus same device
driver could probe twice. Or user could manually try to probing second
time.

Device driver is not ready for that case, because it allocates
statically 'struct regmap_irq_chip' as non-const and stores during
probe in 'irq_drv_data' member a pointer to per-probe state
container ('struct max77620_chip').  devm_regmap_add_irq_chip() does not
make a copy of 'struct regmap_irq_chip' but store the pointer.

Second probe - either successful or failure - would overwrite the
'irq_drv_data' from previous device probe, so interrupts would be
executed in a wrong context.

Cc: stable@vger.kernel.org
Fixes: 3df140d11c6d ("mfd: max77620: Mask/unmask interrupt before/after servicing it")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20251023101939.67991-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/max77620.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/mfd/max77620.c
+++ b/drivers/mfd/max77620.c
@@ -253,7 +253,7 @@ static int max77620_irq_global_unmask(vo
 	return ret;
 }
 
-static struct regmap_irq_chip max77620_top_irq_chip = {
+static const struct regmap_irq_chip max77620_top_irq_chip = {
 	.name = "max77620-top",
 	.irqs = max77620_top_irqs,
 	.num_irqs = ARRAY_SIZE(max77620_top_irqs),
@@ -498,6 +498,7 @@ static int max77620_probe(struct i2c_cli
 	const struct i2c_device_id *id = i2c_client_get_device_id(client);
 	const struct regmap_config *rmap_config;
 	struct max77620_chip *chip;
+	struct regmap_irq_chip *chip_desc;
 	const struct mfd_cell *mfd_cells;
 	int n_mfd_cells;
 	bool pm_off;
@@ -508,6 +509,14 @@ static int max77620_probe(struct i2c_cli
 		return -ENOMEM;
 
 	i2c_set_clientdata(client, chip);
+
+	chip_desc = devm_kmemdup(&client->dev, &max77620_top_irq_chip,
+				 sizeof(max77620_top_irq_chip),
+				 GFP_KERNEL);
+	if (!chip_desc)
+		return -ENOMEM;
+	chip_desc->irq_drv_data = chip;
+
 	chip->dev = &client->dev;
 	chip->chip_irq = client->irq;
 	chip->chip_id = (enum max77620_chip_id)id->driver_data;
@@ -544,11 +553,9 @@ static int max77620_probe(struct i2c_cli
 	if (ret < 0)
 		return ret;
 
-	max77620_top_irq_chip.irq_drv_data = chip;
 	ret = devm_regmap_add_irq_chip(chip->dev, chip->rmap, client->irq,
 				       IRQF_ONESHOT | IRQF_SHARED, 0,
-				       &max77620_top_irq_chip,
-				       &chip->top_irq_data);
+				       chip_desc, &chip->top_irq_data);
 	if (ret < 0) {
 		dev_err(chip->dev, "Failed to add regmap irq: %d\n", ret);
 		return ret;


