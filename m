Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FC216EC1A;
	Tue,  7 May 2024 21:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715116095; cv=none; b=fej9vJ6XPWTtR7YD0RzaoqyGLK8ClbJcLyeRwEVi6B8HD8coMWy5cYJTBkTK/7gPLUTKbD7OiZPpXIWrKPO+WhkmeFFO4x/S61X1iYebJNMMIo6CI/XMm30brfIoZa7iom81mOHMF1My7yhFrbZRQ6uS+xfim8OhoGJAM2JgLYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715116095; c=relaxed/simple;
	bh=OAdc4HV1P1yxs6i2wdZe9uwAxUj/NfVsf96nXvu9DDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQtfAZxL77IXqdt29k8x1tEwkOPGrfneImOU+PGUDO+nMu24qjKTjXZNKwnsHMhCHhUBu+yVaDIoAhro7dGz1vXuuLCRoz6jSKnpaOQihUzjoSHC50FVGS8IC8M5NBja4LqRbvBm1IYR8d0zqltTLDPEwghSr38A1WLlGO4dVmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EMKmCZvB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EMKmCZvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E155C4AF17;
	Tue,  7 May 2024 21:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715116095;
	bh=OAdc4HV1P1yxs6i2wdZe9uwAxUj/NfVsf96nXvu9DDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EMKmCZvBeQUY3mogtAFImxrgOUQqwMDU2vyqfxGe2v47d90rLVYSHvS/8h15s9hrF
	 TDda4+pY3h1FXh0jd7DvEVT8fs3x61AXCUIsmB+g1gjudCmbhrUbjldiIrERNRXL8Y
	 HyK9QGlSW3fgCZa9TI6jfV2QmdZAy03do7EkllgUXsuGIkxRZS68XSjPS2ec6iIQ17
	 rkqFedCgr7+yBaOs5SD7dq9Gy5upHEaHwjuhJHv0kor+kREGj/Ql/tLGXN/1Cj+TWz
	 mWo6bnDSDgmwTQw5yRcXyHzo+e/vGH5/NCVrubnjPGfkP7vgz2nMMgBvwEBacSZmiL
	 GT+6u1RlbPflg==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Abel Vesa <abel.vesa@linaro.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 09/12] spmi: pmic-arb: Make the APID init a version operation
Date: Tue,  7 May 2024 14:07:46 -0700
Message-ID: <20240507210809.3479953-10-sboyd@kernel.org>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
In-Reply-To: <20240507210809.3479953-1-sboyd@kernel.org>
References: <20240507210809.3479953-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Abel Vesa <abel.vesa@linaro.org>

Rather than using conditionals in probe function, add the APID init
as a version specific operation. Due to v7, which supports multiple
buses, pass on the bus index to be used for sorting out the apid base
and count.

Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20240417-spmi-multi-master-support-v10-4-5bc6d322e266@linaro.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/spmi/spmi-pmic-arb.c | 146 +++++++++++++++++------------------
 1 file changed, 70 insertions(+), 76 deletions(-)

diff --git a/drivers/spmi/spmi-pmic-arb.c b/drivers/spmi/spmi-pmic-arb.c
index 12c0efd744c2..fe45d62a42e2 100644
--- a/drivers/spmi/spmi-pmic-arb.c
+++ b/drivers/spmi/spmi-pmic-arb.c
@@ -186,6 +186,7 @@ struct spmi_pmic_arb {
  * struct pmic_arb_ver_ops - version dependent functionality.
  *
  * @ver_str:		version string.
+ * @init_apid:		finds the apid base and count
  * @ppid_to_apid:	finds the apid for a given ppid.
  * @non_data_cmd:	on v1 issues an spmi non-data command.
  *			on v2 no HW support, returns -EOPNOTSUPP.
@@ -205,6 +206,7 @@ struct spmi_pmic_arb {
  */
 struct pmic_arb_ver_ops {
 	const char *ver_str;
+	int (*init_apid)(struct spmi_pmic_arb *pmic_arb);
 	int (*ppid_to_apid)(struct spmi_pmic_arb *pmic_arb, u16 ppid);
 	/* spmi commands (read_cmd, write_cmd, cmd) functionality */
 	int (*offset)(struct spmi_pmic_arb *pmic_arb, u8 sid, u16 addr,
@@ -947,6 +949,32 @@ static int qpnpint_irq_domain_alloc(struct irq_domain *domain,
 	return 0;
 }
 
+static int pmic_arb_init_apid_min_max(struct spmi_pmic_arb *pmic_arb)
+{
+	/*
+	 * Initialize max_apid/min_apid to the opposite bounds, during
+	 * the irq domain translation, we are sure to update these
+	 */
+	pmic_arb->max_apid = 0;
+	pmic_arb->min_apid = pmic_arb->max_periphs - 1;
+
+	return 0;
+}
+
+static int pmic_arb_init_apid_v1(struct spmi_pmic_arb *pmic_arb)
+{
+	u32 *mapping_table;
+
+	mapping_table = devm_kcalloc(&pmic_arb->spmic->dev, pmic_arb->max_periphs,
+				     sizeof(*mapping_table), GFP_KERNEL);
+	if (!mapping_table)
+		return -ENOMEM;
+
+	pmic_arb->mapping_table = mapping_table;
+
+	return pmic_arb_init_apid_min_max(pmic_arb);
+}
+
 static int pmic_arb_ppid_to_apid_v1(struct spmi_pmic_arb *pmic_arb, u16 ppid)
 {
 	u32 *mapping_table = pmic_arb->mapping_table;
@@ -1149,6 +1177,34 @@ static int pmic_arb_offset_v2(struct spmi_pmic_arb *pmic_arb, u8 sid, u16 addr,
 	return 0x1000 * pmic_arb->ee + 0x8000 * apid;
 }
 
+static int pmic_arb_init_apid_v5(struct spmi_pmic_arb *pmic_arb)
+{
+	int ret;
+
+	pmic_arb->base_apid = 0;
+	pmic_arb->apid_count = readl_relaxed(pmic_arb->core + PMIC_ARB_FEATURES) &
+					   PMIC_ARB_FEATURES_PERIPH_MASK;
+
+	if (pmic_arb->base_apid + pmic_arb->apid_count > pmic_arb->max_periphs) {
+		dev_err(&pmic_arb->spmic->dev, "Unsupported APID count %d detected\n",
+			pmic_arb->base_apid + pmic_arb->apid_count);
+		return -EINVAL;
+	}
+
+	ret = pmic_arb_init_apid_min_max(pmic_arb);
+	if (ret)
+		return ret;
+
+	ret = pmic_arb_read_apid_map_v5(pmic_arb);
+	if (ret) {
+		dev_err(&pmic_arb->spmic->dev, "could not read APID->PPID mapping table, rc= %d\n",
+			ret);
+		return ret;
+	}
+
+	return 0;
+}
+
 /*
  * v5 offset per ee and per apid for observer channels and per apid for
  * read/write channels.
@@ -1363,6 +1419,7 @@ pmic_arb_apid_owner_v7(struct spmi_pmic_arb *pmic_arb, u16 n)
 
 static const struct pmic_arb_ver_ops pmic_arb_v1 = {
 	.ver_str		= "v1",
+	.init_apid		= pmic_arb_init_apid_v1,
 	.ppid_to_apid		= pmic_arb_ppid_to_apid_v1,
 	.non_data_cmd		= pmic_arb_non_data_cmd_v1,
 	.offset			= pmic_arb_offset_v1,
@@ -1377,6 +1434,7 @@ static const struct pmic_arb_ver_ops pmic_arb_v1 = {
 
 static const struct pmic_arb_ver_ops pmic_arb_v2 = {
 	.ver_str		= "v2",
+	.init_apid		= pmic_arb_init_apid_v1,
 	.ppid_to_apid		= pmic_arb_ppid_to_apid_v2,
 	.non_data_cmd		= pmic_arb_non_data_cmd_v2,
 	.offset			= pmic_arb_offset_v2,
@@ -1391,6 +1449,7 @@ static const struct pmic_arb_ver_ops pmic_arb_v2 = {
 
 static const struct pmic_arb_ver_ops pmic_arb_v3 = {
 	.ver_str		= "v3",
+	.init_apid		= pmic_arb_init_apid_v1,
 	.ppid_to_apid		= pmic_arb_ppid_to_apid_v2,
 	.non_data_cmd		= pmic_arb_non_data_cmd_v2,
 	.offset			= pmic_arb_offset_v2,
@@ -1405,6 +1464,7 @@ static const struct pmic_arb_ver_ops pmic_arb_v3 = {
 
 static const struct pmic_arb_ver_ops pmic_arb_v5 = {
 	.ver_str		= "v5",
+	.init_apid		= pmic_arb_init_apid_v5,
 	.ppid_to_apid		= pmic_arb_ppid_to_apid_v5,
 	.non_data_cmd		= pmic_arb_non_data_cmd_v2,
 	.offset			= pmic_arb_offset_v5,
@@ -1419,6 +1479,7 @@ static const struct pmic_arb_ver_ops pmic_arb_v5 = {
 
 static const struct pmic_arb_ver_ops pmic_arb_v7 = {
 	.ver_str		= "v7",
+	.init_apid		= pmic_arb_init_apid_v5,
 	.ppid_to_apid		= pmic_arb_ppid_to_apid_v5,
 	.non_data_cmd		= pmic_arb_non_data_cmd_v2,
 	.offset			= pmic_arb_offset_v7,
@@ -1444,7 +1505,6 @@ static int spmi_pmic_arb_probe(struct platform_device *pdev)
 	struct spmi_controller *ctrl;
 	struct resource *res;
 	void __iomem *core;
-	u32 *mapping_table;
 	u32 channel, ee, hw_ver;
 	int err;
 
@@ -1472,12 +1532,6 @@ static int spmi_pmic_arb_probe(struct platform_device *pdev)
 
 	pmic_arb->core_size = resource_size(res);
 
-	pmic_arb->ppid_to_apid = devm_kcalloc(&ctrl->dev, PMIC_ARB_MAX_PPID,
-					      sizeof(*pmic_arb->ppid_to_apid),
-					      GFP_KERNEL);
-	if (!pmic_arb->ppid_to_apid)
-		return -ENOMEM;
-
 	hw_ver = readl_relaxed(core + PMIC_ARB_VERSION);
 
 	if (hw_ver < PMIC_ARB_VERSION_V2_MIN) {
@@ -1511,59 +1565,18 @@ static int spmi_pmic_arb_probe(struct platform_device *pdev)
 			return -ENOMEM;
 	}
 
-	pmic_arb->max_periphs = PMIC_ARB_MAX_PERIPHS;
-
-	if (hw_ver >= PMIC_ARB_VERSION_V7_MIN) {
-		pmic_arb->max_periphs = PMIC_ARB_MAX_PERIPHS_V7;
-		/* Optional property for v7: */
-		of_property_read_u32(pdev->dev.of_node, "qcom,bus-id",
-					&pmic_arb->bus_instance);
-		if (pmic_arb->bus_instance > 1) {
-			dev_err(&pdev->dev, "invalid bus instance (%u) specified\n",
-				pmic_arb->bus_instance);
-			return -EINVAL;
-		}
-
-		if (pmic_arb->bus_instance == 0) {
-			pmic_arb->base_apid = 0;
-			pmic_arb->apid_count =
-				readl_relaxed(core + PMIC_ARB_FEATURES) &
-				PMIC_ARB_FEATURES_PERIPH_MASK;
-		} else {
-			pmic_arb->base_apid =
-				readl_relaxed(core + PMIC_ARB_FEATURES) &
-				PMIC_ARB_FEATURES_PERIPH_MASK;
-			pmic_arb->apid_count =
-				readl_relaxed(core + PMIC_ARB_FEATURES1) &
-				PMIC_ARB_FEATURES_PERIPH_MASK;
-		}
-
-		if (pmic_arb->base_apid + pmic_arb->apid_count > pmic_arb->max_periphs) {
-			dev_err(&pdev->dev, "Unsupported APID count %d detected\n",
-				pmic_arb->base_apid + pmic_arb->apid_count);
-			return -EINVAL;
-		}
-	} else if (hw_ver >= PMIC_ARB_VERSION_V5_MIN) {
-		pmic_arb->base_apid = 0;
-		pmic_arb->apid_count = readl_relaxed(core + PMIC_ARB_FEATURES) &
-					PMIC_ARB_FEATURES_PERIPH_MASK;
-
-		if (pmic_arb->apid_count > pmic_arb->max_periphs) {
-			dev_err(&pdev->dev, "Unsupported APID count %d detected\n",
-				pmic_arb->apid_count);
-			return -EINVAL;
-		}
-	}
-
-	pmic_arb->apid_data = devm_kcalloc(&ctrl->dev, pmic_arb->max_periphs,
-					   sizeof(*pmic_arb->apid_data),
-					   GFP_KERNEL);
-	if (!pmic_arb->apid_data)
-		return -ENOMEM;
-
 	dev_info(&ctrl->dev, "PMIC arbiter version %s (0x%x)\n",
 		 pmic_arb->ver_ops->ver_str, hw_ver);
 
+	if (hw_ver < PMIC_ARB_VERSION_V7_MIN)
+		pmic_arb->max_periphs = PMIC_ARB_MAX_PERIPHS;
+	else
+		pmic_arb->max_periphs = PMIC_ARB_MAX_PERIPHS_V7;
+
+	err = pmic_arb->ver_ops->init_apid(pmic_arb);
+	if (err)
+		return err;
+
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "intr");
 	pmic_arb->intr = devm_ioremap_resource(&ctrl->dev, res);
 	if (IS_ERR(pmic_arb->intr))
@@ -1604,16 +1617,6 @@ static int spmi_pmic_arb_probe(struct platform_device *pdev)
 	}
 
 	pmic_arb->ee = ee;
-	mapping_table = devm_kcalloc(&ctrl->dev, pmic_arb->max_periphs,
-					sizeof(*mapping_table), GFP_KERNEL);
-	if (!mapping_table)
-		return -ENOMEM;
-
-	pmic_arb->mapping_table = mapping_table;
-	/* Initialize max_apid/min_apid to the opposite bounds, during
-	 * the irq domain translation, we are sure to update these */
-	pmic_arb->max_apid = 0;
-	pmic_arb->min_apid = pmic_arb->max_periphs - 1;
 
 	platform_set_drvdata(pdev, ctrl);
 	raw_spin_lock_init(&pmic_arb->lock);
@@ -1622,15 +1625,6 @@ static int spmi_pmic_arb_probe(struct platform_device *pdev)
 	ctrl->read_cmd = pmic_arb_read_cmd;
 	ctrl->write_cmd = pmic_arb_write_cmd;
 
-	if (hw_ver >= PMIC_ARB_VERSION_V5_MIN) {
-		err = pmic_arb_read_apid_map_v5(pmic_arb);
-		if (err) {
-			dev_err(&pdev->dev, "could not read APID->PPID mapping table, rc= %d\n",
-				err);
-			return err;
-		}
-	}
-
 	dev_dbg(&pdev->dev, "adding irq domain\n");
 	pmic_arb->domain = irq_domain_add_tree(pdev->dev.of_node,
 					 &pmic_arb_irq_domain_ops, pmic_arb);
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

