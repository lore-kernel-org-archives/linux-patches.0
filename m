Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9713235CBAF;
	Fri,  9 Jan 2026 12:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962724; cv=none; b=sjiE/0MN1XFZ84Y6DKvsC+K3rjy2I98JCuohpIl7HJHZC+ZmlZ0abNTKmUW25G/r8GDflmwVgrcfRcldP++/yozsWoaPBE+oFzyrkYP+nlv/q5i+KvXH4jUbvAXhd+AvUbKxEybP/Lh9ipHi6aHOvwZ2sd4yUjifQM0xSseuhek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962724; c=relaxed/simple;
	bh=PAN1uXFO2D+9V32ilc+9K0Krclr+NjIdH+0MmQTSEng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DOV7aNcKJDvCYwRvGQQ5bdqaQgGHY/A4khehOeSVRRdN3PrMkC9e7E/HVsJ4cutqB3Q1ErKGPGGygn0rOTyvoDt9ltM6XILe3d1sSrVObQP2jTyitIGdifsz6Cp2n3KGHrZTSTH8p1bAWFyng5iclANoRA79uBzeA+7SwPO1hSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xWqvrRVP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xWqvrRVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B9B4C19421;
	Fri,  9 Jan 2026 12:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962724;
	bh=PAN1uXFO2D+9V32ilc+9K0Krclr+NjIdH+0MmQTSEng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xWqvrRVP4waBsS9BDC23Qe8enCSOozsFvTpz0PaKJAwA6MObvIW3PX73fKWonyt8S
	 qqTq0J3l0wMa5+8hHkOs3Ch8vlrKfeGOsQZB5aD8jAort5nNoMohMw51996D0kcx8d
	 HR4YEfQZVEu9kzFWhzycjQzYf+/z4XNpp5ShXOcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.1 466/634] mfd: max77620: Fix potential IRQ chip conflict when probing two devices
Date: Fri,  9 Jan 2026 12:42:24 +0100
Message-ID: <20260109112135.085175136@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -254,7 +254,7 @@ static int max77620_irq_global_unmask(vo
 	return ret;
 }
 
-static struct regmap_irq_chip max77620_top_irq_chip = {
+static const struct regmap_irq_chip max77620_top_irq_chip = {
 	.name = "max77620-top",
 	.irqs = max77620_top_irqs,
 	.num_irqs = ARRAY_SIZE(max77620_top_irqs),
@@ -499,6 +499,7 @@ static int max77620_probe(struct i2c_cli
 {
 	const struct regmap_config *rmap_config;
 	struct max77620_chip *chip;
+	struct regmap_irq_chip *chip_desc;
 	const struct mfd_cell *mfd_cells;
 	int n_mfd_cells;
 	bool pm_off;
@@ -509,6 +510,14 @@ static int max77620_probe(struct i2c_cli
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
@@ -545,11 +554,9 @@ static int max77620_probe(struct i2c_cli
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


