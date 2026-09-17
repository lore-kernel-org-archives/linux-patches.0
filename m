Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72AA14D1796;
	Thu, 17 Sep 2026 17:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667050; cv=none; b=YYP+1Dw9D+bn8bUR6wRP3BfBM+Fz1yiOl1ZGckEKEotD2xG7AUTvaQlT+K3Dy9JUk3eyYg4hF42RY25VoRUWEVgybThRfEDK+4NqdJFsHYewtWyed5Ge+HU+06MqTZeQrvW/+UaGcLlnDXerqs1oNMYzooGcldsLTc9NhUmwpVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667050; c=relaxed/simple;
	bh=IZ+TkPxjfLAPIqR+Sds9gqGW6KbwCtZ36SDrdkCLe8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCubVvw39txOLRQ2hLQdLle1co6UA+cbJcmNTrG8JTjGMLs9URTfGqiZgANbhmNb3tkCbrls9yn65kvF2vasDgWZF5z4oNWbRy8ffwshLaF/D2VLaMr8ximahdoMoRIRHDYrt0EbMce5lwUjWQwv2Apy6bDLW9swTlyAZygAKZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RDtNK02A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RDtNK02A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE671F000FF;
	Thu, 17 Sep 2026 17:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667047;
	bh=HY6/OnYClRUcYHQXp4KMF//g9U4AVlKCFYY98vKcz0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RDtNK02AD45O55auLafgDFW7FxQUjl+FXOMR6O6xhTFWPBSejmdG5nf42qx8EmckR
	 e4tantTQwscDbkqhien2lk95X3BIwSo5YFjFAIImHJQ0CcQnPaQm32StHK2MsysvpX
	 xEa5gQAy0gUpzcYo7Tp8dUsGyOsK2nz7NPeOpzEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rounak Das <rounakdas2025@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1211/1250] EDAC/altera: Use ECC manager compatible to select A10/S10 IRQ layout
Date: Thu, 17 Sep 2026 16:16:46 +0100
Message-ID: <20260917151625.108848735@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Rounak Das <rounakdas2025@gmail.com>

[ Upstream commit d4486fc3098e176cb4a29fee037216484761f9ca ]

The SDMMC ECC IRQ layout selection uses CONFIG_64BIT to distinguish between
Arria10 and Stratix10 paths.

Detect the SoC once at probe via the device match table (.data) store it in
struct altr_arria10_edac, and use it instead of CONFIG_64BIT.

This keeps the decision correct for every ECC child device (OCRAM, SD/MMC,
etc.) and avoids any runtime compatible lookup.

Signed-off-by: Rounak Das <rounakdas2025@gmail.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
Link: https://patch.msgid.link/20260708091135.94114-2-rounakdas2025@gmail.com
Stable-dep-of: 9868f5c077df ("EDAC/altera: Use parent device for devres in altr_portb_setup()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/altera_edac.c |  107 ++++++++++++++++++++++-----------------------
 drivers/edac/altera_edac.h |    1 
 2 files changed, 55 insertions(+), 53 deletions(-)

--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -1507,6 +1507,7 @@ static int altr_portb_setup(struct altr_
 	int edac_idx, rc;
 	struct device_node *np;
 	const struct edac_device_prv_data *prv = &a10_sdmmceccb_data;
+	bool is_s10 = device->edac->is_s10;
 
 	rc = altr_check_ecc_deps(device);
 	if (rc)
@@ -1548,15 +1549,14 @@ static int altr_portb_setup(struct altr_
 
 	/*
 	 * Update the PortB IRQs - A10 has 4, S10 has 2, Index accordingly
-	 *
-	 * FIXME: Instead of ifdefs with different architectures the driver
-	 *        should properly use compatibles.
 	 */
-#ifdef CONFIG_64BIT
-	altdev->sb_irq = irq_of_parse_and_map(np, 1);
-#else
-	altdev->sb_irq = irq_of_parse_and_map(np, 2);
-#endif
+
+	/* Using compatibles to determine the IRQ Index */
+	if (is_s10)
+		altdev->sb_irq = irq_of_parse_and_map(np, 1);
+	else
+		altdev->sb_irq = irq_of_parse_and_map(np, 2);
+
 	if (!altdev->sb_irq) {
 		edac_printk(KERN_ERR, EDAC_DEVICE, "Error PortB SBIRQ alloc\n");
 		rc = -ENODEV;
@@ -1570,29 +1570,28 @@ static int altr_portb_setup(struct altr_
 		goto err_release_group_1;
 	}
 
-#ifdef CONFIG_64BIT
-	/* Use IRQ to determine SError origin instead of assigning IRQ */
-	rc = of_property_read_u32_index(np, "interrupts", 1, &altdev->db_irq);
-	if (rc) {
-		edac_printk(KERN_ERR, EDAC_DEVICE,
-			    "Error PortB DBIRQ alloc\n");
-		goto err_release_group_1;
-	}
-#else
-	altdev->db_irq = irq_of_parse_and_map(np, 3);
-	if (!altdev->db_irq) {
-		edac_printk(KERN_ERR, EDAC_DEVICE, "Error PortB DBIRQ alloc\n");
-		rc = -ENODEV;
-		goto err_release_group_1;
-	}
-	rc = devm_request_irq(&altdev->ddev, altdev->db_irq,
-			      prv->ecc_irq_handler, IRQF_TRIGGER_HIGH,
-			      ecc_name, altdev);
-	if (rc) {
-		edac_printk(KERN_ERR, EDAC_DEVICE, "PortB DBERR IRQ error\n");
-		goto err_release_group_1;
+	if (is_s10) {
+		/* Use IRQ to determine SError origin instead of assigning IRQ */
+		rc = of_property_read_u32_index(np, "interrupts", 1, &altdev->db_irq);
+		if (rc) {
+			edac_printk(KERN_ERR, EDAC_DEVICE, "Error PortB DBIRQ alloc\n");
+			goto err_release_group_1;
+		}
+	} else {
+		altdev->db_irq = irq_of_parse_and_map(np, 3);
+		if (!altdev->db_irq) {
+			edac_printk(KERN_ERR, EDAC_DEVICE, "Error PortB DBIRQ alloc\n");
+			rc = -ENODEV;
+			goto err_release_group_1;
+		}
+		rc = devm_request_irq(&altdev->ddev, altdev->db_irq,
+				      prv->ecc_irq_handler, IRQF_TRIGGER_HIGH,
+				      ecc_name, altdev);
+		if (rc) {
+			edac_printk(KERN_ERR, EDAC_DEVICE, "PortB DBERR IRQ error\n");
+			goto err_release_group_1;
+		}
 	}
-#endif
 
 	rc = edac_device_add_device(dci);
 	if (rc) {
@@ -1974,29 +1973,29 @@ static int altr_edac_a10_device_add(stru
 		goto err_release_group1;
 	}
 
-#ifdef CONFIG_64BIT
-	/* Use IRQ to determine SError origin instead of assigning IRQ */
-	rc = of_property_read_u32_index(np, "interrupts", 0, &altdev->db_irq);
-	if (rc) {
-		edac_printk(KERN_ERR, EDAC_DEVICE,
-			    "Unable to parse DB IRQ index\n");
-		goto err_release_group1;
-	}
-#else
-	altdev->db_irq = irq_of_parse_and_map(np, 1);
-	if (!altdev->db_irq) {
-		edac_printk(KERN_ERR, EDAC_DEVICE, "Error allocating DBIRQ\n");
-		rc = -ENODEV;
-		goto err_release_group1;
-	}
-	rc = devm_request_irq(edac->dev, altdev->db_irq, prv->ecc_irq_handler,
-			      IRQF_TRIGGER_HIGH,
-			      ecc_name, altdev);
-	if (rc) {
-		edac_printk(KERN_ERR, EDAC_DEVICE, "No DBERR IRQ resource\n");
-		goto err_release_group1;
+	if (edac->is_s10) {
+		/* Use IRQ to determine SError origin instead of assigning IRQ */
+		rc = of_property_read_u32_index(np, "interrupts", 0, &altdev->db_irq);
+		if (rc) {
+			edac_printk(KERN_ERR, EDAC_DEVICE,
+				    "Unable to parse DB IRQ index\n");
+			goto err_release_group1;
+		}
+	} else {
+		altdev->db_irq = irq_of_parse_and_map(np, 1);
+		if (!altdev->db_irq) {
+			edac_printk(KERN_ERR, EDAC_DEVICE, "Error allocating DBIRQ\n");
+			rc = -ENODEV;
+			goto err_release_group1;
+		}
+		rc = devm_request_irq(edac->dev, altdev->db_irq, prv->ecc_irq_handler,
+				      IRQF_TRIGGER_HIGH,
+				      ecc_name, altdev);
+		if (rc) {
+			edac_printk(KERN_ERR, EDAC_DEVICE, "No DBERR IRQ resource\n");
+			goto err_release_group1;
+		}
 	}
-#endif
 
 	rc = edac_device_add_device(dci);
 	if (rc) {
@@ -2122,6 +2121,8 @@ static int altr_edac_a10_probe(struct pl
 	platform_set_drvdata(pdev, edac);
 	INIT_LIST_HEAD(&edac->a10_ecc_devices);
 
+	edac->is_s10 = !!device_get_match_data(&pdev->dev);
+
 	edac->ecc_mgr_map =
 		altr_sysmgr_regmap_lookup_by_phandle(pdev->dev.of_node,
 						     "altr,sysmgr-syscon");
@@ -2207,7 +2208,7 @@ static int altr_edac_a10_probe(struct pl
 
 static const struct of_device_id altr_edac_a10_of_match[] = {
 	{ .compatible = "altr,socfpga-a10-ecc-manager" },
-	{ .compatible = "altr,socfpga-s10-ecc-manager" },
+	{ .compatible = "altr,socfpga-s10-ecc-manager", .data = (void *)1 },
 	{},
 };
 MODULE_DEVICE_TABLE(of, altr_edac_a10_of_match);
--- a/drivers/edac/altera_edac.h
+++ b/drivers/edac/altera_edac.h
@@ -395,6 +395,7 @@ struct altr_arria10_edac {
 	struct irq_chip		irq_chip;
 	struct list_head	a10_ecc_devices;
 	struct notifier_block	panic_notifier;
+	bool is_s10;
 };
 
 #endif	/* #ifndef _ALTERA_EDAC_H */


