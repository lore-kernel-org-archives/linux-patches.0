Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35292DF6E6;
	Thu, 28 May 2026 20:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999343; cv=none; b=IcvQtact9mzQMrN3OusJZXz4Z7C7Z55iimOhErrMOHnTqOp11Me0TI60URBmxkiBqkvy0G/qP5GPTpXV5iix7ASyCUFkprsdCWupen41uL123mk0o3EzMnyLkKWgF4u7Zuqe8S88gOdwmnJpBpWa7x+YL7ZtTZLZs8E2c8qq8MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999343; c=relaxed/simple;
	bh=31ax1XlPLEYt0JN8IGY0/4S479Cd0EY4RiuOP82tf04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjSxz45GPkluOju/G0xXNzkNgNLT90NOHENHgj/PolRWn2ug9gablVj/7EV5tweLeEXUCutHORLYz59sQIUB7wZWnxVPHlJceqIn3PHv8WxhmwIfwhL+6LuCpqmNrinrEwTiCVoKNWEZLu7mdH584clkCNE1E0P647jpFrqNGCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZiI025+Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZiI025+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34481F000E9;
	Thu, 28 May 2026 20:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999341;
	bh=C8Vg1eQo7uo7M9gUu6Ul5Zi5YJGUwSxHUmVW3ZlAOc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZiI025+ZDio9GcwWag73Xnm4a1AWLVxO/lGy6ELmnnBk6dKEmPYSfWptnC1zu5xWz
	 O4bhLYfFLNWBzvt6sNnf5bu6nYJy9ApijFa1eWPet2it3mpC6g9Epb1tEvwunb/5CP
	 KoD6CbeLuG6b1BFwOZ8kkhBVT+arHxogmpqP+T6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco@dolcini.it>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 031/377] regulator: tps65219: fix irq_data.rdev not being assigned
Date: Thu, 28 May 2026 21:44:29 +0200
Message-ID: <20260528194639.284302946@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

commit f9b2d3b703d13df50c630997dfdc25648e96db0d upstream.

Commit 64a6b577490c ("regulator: tps65219: Remove debugging helper
function") removed the tps65219_get_rdev_by_name() helper along with
the irq_data.rdev assignment that depended on it. This left
irq_data.rdev uninitialized for all IRQs, causing undefined behavior
when regulator_notifier_call_chain() is called from the IRQ handler:

  Internal error: Oops: 0000000096000004
  pc : regulator_notifier_call_chain
  lr : tps65219_regulator_irq_handler
  Call trace:
   regulator_notifier_call_chain
   tps65219_regulator_irq_handler
   handle_nested_irq
   regmap_irq_thread
   irq_thread_fn
   irq_thread
   kthread
   ret_from_fork

Instead of restoring a dedicated lookup array, restructure the probe
function to combine regulator registration with IRQ registration in
the same loop. This way the rdev returned by devm_regulator_register()
is naturally available for assigning to irq_data.rdev without any
auxiliary data structure.

Non-regulator IRQs (SENSOR, TIMEOUT) that don't correspond to any
registered regulator are registered with rdev=NULL, and the IRQ handler
is protected with a NULL check to avoid crashing.

Cc: stable@vger.kernel.org
Closes: https://lore.kernel.org/all/aBDSTxALaOc-PD7X@gaggiata.pivistrello.it/
Reported-by: Francesco Dolcini <francesco@dolcini.it>
Fixes: 64a6b577490c ("regulator: tps65219: Remove debugging helper function")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Link: https://patch.msgid.link/20260518083113.2063368-1-alexander.sverdlin@siemens.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/tps65219-regulator.c |  135 +++++++++++++++++++++++----------
 1 file changed, 95 insertions(+), 40 deletions(-)

--- a/drivers/regulator/tps65219-regulator.c
+++ b/drivers/regulator/tps65219-regulator.c
@@ -346,8 +346,9 @@ static irqreturn_t tps65219_regulator_ir
 		return IRQ_HANDLED;
 	}
 
-	regulator_notifier_call_chain(irq_data->rdev,
-				      irq_data->type->event, NULL);
+	if (irq_data->rdev)
+		regulator_notifier_call_chain(irq_data->rdev,
+					      irq_data->type->event, NULL);
 
 	dev_err(irq_data->dev, "Error IRQ trap %s for %s\n",
 		irq_data->type->event_name, irq_data->type->regulator_name);
@@ -398,14 +399,65 @@ static struct tps65219_chip_data chip_in
 	},
 };
 
-static int tps65219_regulator_probe(struct platform_device *pdev)
+static bool tps65219_is_regulator_name(const struct tps65219_chip_data *pmic,
+				       const char *name)
+{
+	int i;
+
+	for (i = 0; i < pmic->common_rdesc_size; i++)
+		if (!strcmp(pmic->common_rdesc[i].name, name))
+			return true;
+	for (i = 0; i < pmic->rdesc_size; i++)
+		if (!strcmp(pmic->rdesc[i].name, name))
+			return true;
+	return false;
+}
+
+static int tps65219_register_irqs(struct platform_device *pdev,
+				  struct tps65219 *tps,
+				  struct regulator_dev *rdev,
+				  struct tps65219_regulator_irq_type *irq_types,
+				  int nirqs,
+				  const char *regulator_name)
 {
 	struct tps65219_regulator_irq_data *irq_data;
+	int i, irq, error;
+
+	for (i = 0; i < nirqs; i++) {
+		if (strcmp(irq_types[i].regulator_name, regulator_name))
+			continue;
+
+		irq = platform_get_irq_byname(pdev, irq_types[i].irq_name);
+		if (irq < 0)
+			return -EINVAL;
+
+		irq_data = devm_kmalloc(tps->dev, sizeof(*irq_data), GFP_KERNEL);
+		if (!irq_data)
+			return -ENOMEM;
+
+		irq_data->dev = tps->dev;
+		irq_data->type = &irq_types[i];
+		irq_data->rdev = rdev;
+
+		error = devm_request_threaded_irq(tps->dev, irq, NULL,
+						  tps65219_regulator_irq_handler,
+						  IRQF_ONESHOT,
+						  irq_types[i].irq_name,
+						  irq_data);
+		if (error)
+			return dev_err_probe(tps->dev, error,
+					     "Failed to request %s IRQ %d\n",
+					     irq_types[i].irq_name, irq);
+	}
+	return 0;
+}
+
+static int tps65219_regulator_probe(struct platform_device *pdev)
+{
 	struct tps65219_regulator_irq_type *irq_type;
 	struct tps65219_chip_data *pmic;
 	struct regulator_dev *rdev;
 	int error;
-	int irq;
 	int i;
 
 	struct tps65219 *tps = dev_get_drvdata(pdev->dev.parent);
@@ -425,6 +477,19 @@ static int tps65219_regulator_probe(stru
 			return dev_err_probe(tps->dev, PTR_ERR(rdev),
 					      "Failed to register %s regulator\n",
 					      pmic->common_rdesc[i].name);
+
+		error = tps65219_register_irqs(pdev, tps, rdev,
+					       pmic->common_irq_types,
+					       pmic->common_irq_size,
+					       pmic->common_rdesc[i].name);
+		if (error)
+			return error;
+		error = tps65219_register_irqs(pdev, tps, rdev,
+					       pmic->irq_types,
+					       pmic->dev_irq_size,
+					       pmic->common_rdesc[i].name);
+		if (error)
+			return error;
 	}
 
 	for (i = 0; i <  pmic->rdesc_size; i++) {
@@ -434,52 +499,42 @@ static int tps65219_regulator_probe(stru
 			return dev_err_probe(tps->dev, PTR_ERR(rdev),
 					     "Failed to register %s regulator\n",
 					     pmic->rdesc[i].name);
+
+		error = tps65219_register_irqs(pdev, tps, rdev,
+					       pmic->common_irq_types,
+					       pmic->common_irq_size,
+					       pmic->rdesc[i].name);
+		if (error)
+			return error;
+		error = tps65219_register_irqs(pdev, tps, rdev,
+					       pmic->irq_types,
+					       pmic->dev_irq_size,
+					       pmic->rdesc[i].name);
+		if (error)
+			return error;
 	}
 
+	/* Register non-regulator IRQs (TIMEOUT, SENSOR) with rdev=NULL */
 	for (i = 0; i < pmic->common_irq_size; ++i) {
 		irq_type = &pmic->common_irq_types[i];
-		irq = platform_get_irq_byname(pdev, irq_type->irq_name);
-		if (irq < 0)
-			return -EINVAL;
-
-		irq_data = devm_kmalloc(tps->dev, sizeof(*irq_data), GFP_KERNEL);
-		if (!irq_data)
-			return -ENOMEM;
-
-		irq_data->dev = tps->dev;
-		irq_data->type = irq_type;
-		error = devm_request_threaded_irq(tps->dev, irq, NULL,
-						  tps65219_regulator_irq_handler,
-						  IRQF_ONESHOT,
-						  irq_type->irq_name,
-						  irq_data);
+		if (tps65219_is_regulator_name(pmic, irq_type->regulator_name))
+			continue;
+		error = tps65219_register_irqs(pdev, tps, NULL,
+					       irq_type, 1,
+					       irq_type->regulator_name);
 		if (error)
-			return dev_err_probe(tps->dev, error,
-					     "Failed to request %s IRQ %d\n",
-					     irq_type->irq_name, irq);
+			return error;
 	}
 
 	for (i = 0; i < pmic->dev_irq_size; ++i) {
 		irq_type = &pmic->irq_types[i];
-		irq = platform_get_irq_byname(pdev, irq_type->irq_name);
-		if (irq < 0)
-			return -EINVAL;
-
-		irq_data = devm_kmalloc(tps->dev, sizeof(*irq_data), GFP_KERNEL);
-		if (!irq_data)
-			return -ENOMEM;
-
-		irq_data->dev = tps->dev;
-		irq_data->type = irq_type;
-		error = devm_request_threaded_irq(tps->dev, irq, NULL,
-						  tps65219_regulator_irq_handler,
-						  IRQF_ONESHOT,
-						  irq_type->irq_name,
-						  irq_data);
+		if (tps65219_is_regulator_name(pmic, irq_type->regulator_name))
+			continue;
+		error = tps65219_register_irqs(pdev, tps, NULL,
+					       irq_type, 1,
+					       irq_type->regulator_name);
 		if (error)
-			return dev_err_probe(tps->dev, error,
-					     "Failed to request %s IRQ %d\n",
-					     irq_type->irq_name, irq);
+			return error;
 	}
 
 	return 0;


