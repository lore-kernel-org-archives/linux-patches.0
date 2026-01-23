Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412342D6E5C;
	Fri, 23 Jan 2026 18:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769192445; cv=none; b=lGO0RJsYvvJ5W0CBxD6r6mE+NNY3Hu8/sok2Rs/dzQJNkAmZNQTjx6E618F+cxR2evk1tvPif8EAil7K2H6tiYxKMYbb8nrY2wKAEBlfyf9n0dhrvb0KbTAqhxUi15fHECBvGxHqbfvIIAh1Xaqswf9SquWWZeqfAq2I4XLmAaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769192445; c=relaxed/simple;
	bh=I66E/zZiHA6FOcCAlffXQhFB9fSE9Y79UmI2dtkyj4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQ/i0nfKCsGUMgAfSfm2JaLvD54MND/dYeb+F2u2DuKdPijQ8ueMM2+yXIXatOLQ/HDk5JwZaaEgiyHpdj68xFdu6OZqOCaaqDuo2DSzxLn5rfYDlnJ9MdABExkzvowFjk4V5EvQd3pB+jMYllOpeMX94QyIra1FxYNqMjShVZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CiNzQxHl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CiNzQxHl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8142C19423;
	Fri, 23 Jan 2026 18:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769192445;
	bh=I66E/zZiHA6FOcCAlffXQhFB9fSE9Y79UmI2dtkyj4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CiNzQxHlf3kw1mSEMVK315XTHVbSrcp8ViwsGNSO+RBKAAh54jo/9xZOSdzGTmFYr
	 Rrzpw/JhAslJff5tenp5WvCbitDh9zGHuuUoaX1z3ujrUgLaIUvM10TnoVZ71O73TD
	 k/ngori8QGDFWlRQrhj96tIHgFVyzM0bMj9HI8gzI0Bbza8nysyKCW/GcCkw057JMb
	 ZpSBHKbibxagBATUni59MN+N5vr/92totG01pymIDwV3kfQ/iAnM1guemq3e6o9uAA
	 Rs2dVeyhF0XX9dhHvCKAnwOZYJhTffU00k2NOCDXHyACqwZlVbFrQAnwVY/267Uf0B
	 UM6PYhmL89wAA==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: David Collins <david.collins@oss.qualcomm.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Kamal Wadhwa <kamal.wadhwa@oss.qualcomm.com>,
	Jishnu Prakash <jishnu.prakash@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: [PATCH 09/10] spmi: spmi-pmic-arb: add support for PMIC arbiter v8
Date: Fri, 23 Jan 2026 10:20:37 -0800
Message-ID: <20260123182039.224314-10-sboyd@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260123182039.224314-1-sboyd@kernel.org>
References: <20260123182039.224314-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Collins <david.collins@oss.qualcomm.com>

PMIC arbiter v8 supports up to 4 SPMI buses and up to 8192 PMIC
peripherals.  Its register map differs from v7 as several fields
increased in size. Add support for PMIC arbiter version 8.

Signed-off-by: David Collins <david.collins@oss.qualcomm.com>
Signed-off-by: Kamal Wadhwa <kamal.wadhwa@oss.qualcomm.com>
Signed-off-by: Jishnu Prakash <jishnu.prakash@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/spmi/spmi-pmic-arb.c | 304 +++++++++++++++++++++++++++++------
 1 file changed, 255 insertions(+), 49 deletions(-)

diff --git a/drivers/spmi/spmi-pmic-arb.c b/drivers/spmi/spmi-pmic-arb.c
index 91581974ef84..69f8d456324a 100644
--- a/drivers/spmi/spmi-pmic-arb.c
+++ b/drivers/spmi/spmi-pmic-arb.c
@@ -2,6 +2,8 @@
 /*
  * Copyright (c) 2012-2015, 2017, 2021, The Linux Foundation. All rights reserved.
  */
+
+#include <linux/bitfield.h>
 #include <linux/bitmap.h>
 #include <linux/delay.h>
 #include <linux/err.h>
@@ -25,12 +27,12 @@
 #define PMIC_ARB_VERSION_V3_MIN		0x30000000
 #define PMIC_ARB_VERSION_V5_MIN		0x50000000
 #define PMIC_ARB_VERSION_V7_MIN		0x70000000
+#define PMIC_ARB_VERSION_V8_MIN		0x80000000
 #define PMIC_ARB_INT_EN			0x0004
 
 #define PMIC_ARB_FEATURES		0x0004
 #define PMIC_ARB_FEATURES_PERIPH_MASK	GENMASK(10, 0)
-
-#define PMIC_ARB_FEATURES1		0x0008
+#define PMIC_ARB_FEATURES_V8_PERIPH_MASK	GENMASK(12, 0)
 
 /* PMIC Arbiter channel registers offsets */
 #define PMIC_ARB_CMD			0x00
@@ -50,9 +52,11 @@
 #define SPMI_MAPPING_BIT_IS_1_RESULT(X)	(((X) >> 0) & 0xFF)
 
 #define SPMI_MAPPING_TABLE_TREE_DEPTH	16	/* Maximum of 16-bits */
-#define PMIC_ARB_MAX_PPID		BIT(12) /* PPID is 12bit */
+#define PMIC_ARB_MAX_PPID		BIT(13)
 #define PMIC_ARB_APID_VALID		BIT(15)
-#define PMIC_ARB_CHAN_IS_IRQ_OWNER(reg)	((reg) & BIT(24))
+#define PMIC_ARB_CHAN_IS_IRQ_OWNER_MASK	BIT(24)
+#define PMIC_ARB_V8_CHAN_IS_IRQ_OWNER_MASK	BIT(31)
+
 #define INVALID_EE				0xFF
 
 /* Ownership Table */
@@ -96,30 +100,37 @@ enum pmic_arb_channel {
 	PMIC_ARB_CHANNEL_OBS,
 };
 
-#define PMIC_ARB_MAX_BUSES		2
+#define PMIC_ARB_MAX_BUSES		4
 
 /* Maximum number of support PMIC peripherals */
 #define PMIC_ARB_MAX_PERIPHS		512
 #define PMIC_ARB_MAX_PERIPHS_V7		1024
+#define PMIC_ARB_MAX_PERIPHS_V8		8192
 #define PMIC_ARB_TIMEOUT_US		1000
 #define PMIC_ARB_MAX_TRANS_BYTES	(8)
 
 #define PMIC_ARB_APID_MASK		0xFF
-#define PMIC_ARB_PPID_MASK		0xFFF
+#define PMIC_ARB_PPID_MASK		GENMASK(11, 0)
+#define PMIC_ARB_V8_PPID_MASK		GENMASK(12, 0)
 
 /* interrupt enable bit */
 #define SPMI_PIC_ACC_ENABLE_BIT		BIT(0)
 
+#define HWIRQ_SID_MASK	GENMASK(28, 24)
+#define HWIRQ_PID_MASK	GENMASK(23, 16)
+#define HWIRQ_IRQID_MASK	GENMASK(15, 13)
+#define HWIRQ_APID_MASK	GENMASK(12, 0)
+
 #define spec_to_hwirq(slave_id, periph_id, irq_id, apid) \
-	((((slave_id) & 0xF)   << 28) | \
-	(((periph_id) & 0xFF)  << 20) | \
-	(((irq_id)    & 0x7)   << 16) | \
-	(((apid)      & 0x3FF) << 0))
+	(FIELD_PREP(HWIRQ_SID_MASK, (slave_id))  | \
+	 FIELD_PREP(HWIRQ_PID_MASK, (periph_id)) | \
+	 FIELD_PREP(HWIRQ_IRQID_MASK, (irq_id))  | \
+	 FIELD_PREP(HWIRQ_APID_MASK, (apid)))
 
-#define hwirq_to_sid(hwirq)  (((hwirq) >> 28) & 0xF)
-#define hwirq_to_per(hwirq)  (((hwirq) >> 20) & 0xFF)
-#define hwirq_to_irq(hwirq)  (((hwirq) >> 16) & 0x7)
-#define hwirq_to_apid(hwirq) (((hwirq) >> 0)  & 0x3FF)
+#define hwirq_to_sid(hwirq)  FIELD_GET(HWIRQ_SID_MASK, (hwirq))
+#define hwirq_to_per(hwirq)  FIELD_GET(HWIRQ_PID_MASK, (hwirq))
+#define hwirq_to_irq(hwirq)  FIELD_GET(HWIRQ_IRQID_MASK, (hwirq))
+#define hwirq_to_apid(hwirq) FIELD_GET(HWIRQ_APID_MASK, (hwirq))
 
 struct pmic_arb_ver_ops;
 
@@ -138,11 +149,12 @@ struct spmi_pmic_arb;
  * @domain:		irq domain object for PMIC IRQ domain
  * @intr:		address of the SPMI interrupt control registers.
  * @cnfg:		address of the PMIC Arbiter configuration registers.
+ * @apid_owner:		on v8: address of APID owner mapping table registers
  * @spmic:		spmi controller registered for this bus
  * @lock:		lock to synchronize accesses.
- * @base_apid:		on v7: minimum APID associated with the particular SPMI
- *			bus instance
- * @apid_count:		on v5 and v7: number of APIDs associated with the
+ * @base_apid:		on v7 and v8: minimum APID associated with the
+ *			particular SPMI bus instance
+ * @apid_count:		on v5, v7 and v8: number of APIDs associated with the
  *			particular SPMI bus instance
  * @mapping_table:	in-memory copy of PPID -> APID mapping table.
  * @mapping_table_valid:bitmap containing valid-only periphs
@@ -159,6 +171,7 @@ struct spmi_pmic_arb_bus {
 	struct irq_domain	*domain;
 	void __iomem		*intr;
 	void __iomem		*cnfg;
+	void __iomem		*apid_owner;
 	struct spmi_controller	*spmic;
 	raw_spinlock_t		lock;
 	u16			base_apid;
@@ -181,6 +194,7 @@ struct spmi_pmic_arb_bus {
  * @wr_base:		on v1 "core", on v2 "chnls"    register base off DT.
  * @core:		core register base for v2 and above only (see above)
  * @core_size:		core register base size
+ * @apid_map:		on v8, APID mapping table register base
  * @channel:		execution environment channel to use for accesses.
  * @ee:			the current Execution Environment
  * @ver_ops:		version dependent operations.
@@ -193,6 +207,7 @@ struct spmi_pmic_arb {
 	void __iomem		*wr_base;
 	void __iomem		*core;
 	resource_size_t		core_size;
+	void __iomem		*apid_map;
 	u8			channel;
 	u8			ee;
 	const struct pmic_arb_ver_ops *ver_ops;
@@ -206,6 +221,7 @@ struct spmi_pmic_arb {
  *
  * @ver_str:		version string.
  * @get_core_resources:	initializes the core, observer and channels
+ * @get_bus_resources:	requests per-SPMI bus register resources
  * @init_apid:		finds the apid base and count
  * @ppid_to_apid:	finds the apid for a given ppid.
  * @non_data_cmd:	on v1 issues an spmi non-data command.
@@ -227,6 +243,9 @@ struct spmi_pmic_arb {
 struct pmic_arb_ver_ops {
 	const char *ver_str;
 	int (*get_core_resources)(struct platform_device *pdev, void __iomem *core);
+	int (*get_bus_resources)(struct platform_device *pdev,
+				 struct device_node *node,
+				 struct spmi_pmic_arb_bus *bus);
 	int (*init_apid)(struct spmi_pmic_arb_bus *bus, int index);
 	int (*ppid_to_apid)(struct spmi_pmic_arb_bus *bus, u16 ppid);
 	/* spmi commands (read_cmd, write_cmd, cmd) functionality */
@@ -656,7 +675,7 @@ static int periph_interrupt(struct spmi_pmic_arb_bus *bus, u16 apid)
 	unsigned int irq;
 	u32 status, id;
 	int handled = 0;
-	u8 sid = (bus->apid_data[apid].ppid >> 8) & 0xF;
+	u8 sid = (bus->apid_data[apid].ppid >> 8) & 0x1F;
 	u8 per = bus->apid_data[apid].ppid & 0xFF;
 
 	status = readl_relaxed(pmic_arb->ver_ops->irq_status(bus, apid));
@@ -686,7 +705,7 @@ static void pmic_arb_chained_irq(struct irq_desc *desc)
 	int last = bus->max_apid;
 	/*
 	 * acc_offset will be non-zero for the secondary SPMI bus instance on
-	 * v7 controllers.
+	 * v7 and v8 controllers.
 	 */
 	int acc_offset = bus->base_apid >> 5;
 	u8 ee = pmic_arb->ee;
@@ -913,7 +932,8 @@ static int qpnpint_irq_domain_translate(struct irq_domain *d,
 		return -EINVAL;
 	if (fwspec->param_count != 4)
 		return -EINVAL;
-	if (intspec[0] > 0xF || intspec[1] > 0xFF || intspec[2] > 0x7)
+	if (intspec[0] > FIELD_MAX(HWIRQ_SID_MASK) || intspec[1] > FIELD_MAX(HWIRQ_PID_MASK) ||
+	    intspec[2] > FIELD_MAX(HWIRQ_IRQID_MASK))
 		return -EINVAL;
 
 	ppid = intspec[0] << 8 | intspec[1];
@@ -1160,7 +1180,9 @@ static int pmic_arb_ppid_to_apid_v2(struct spmi_pmic_arb_bus *bus, u16 ppid)
 	return apid_valid & ~PMIC_ARB_APID_VALID;
 }
 
-static int pmic_arb_read_apid_map_v5(struct spmi_pmic_arb_bus *bus)
+static int _pmic_arb_read_apid_map(struct spmi_pmic_arb_bus *bus,
+				   void __iomem *ppid_base, unsigned long ppid_mask,
+				   u8 ppid_shift, unsigned long irq_owner_mask)
 {
 	struct spmi_pmic_arb *pmic_arb = bus->pmic_arb;
 	struct apid_data *apidd;
@@ -1171,7 +1193,7 @@ static int pmic_arb_read_apid_map_v5(struct spmi_pmic_arb_bus *bus)
 
 	/*
 	 * In order to allow multiple EEs to write to a single PPID in arbiter
-	 * version 5 and 7, there is more than one APID mapped to each PPID.
+	 * version 5,7 and 8, there can be more than one APID mapped to each PPID.
 	 * The owner field for each of these mappings specifies the EE which is
 	 * allowed to write to the APID.  The owner of the last (highest) APID
 	 * which has the IRQ owner bit set for a given PPID will receive
@@ -1183,19 +1205,30 @@ static int pmic_arb_read_apid_map_v5(struct spmi_pmic_arb_bus *bus)
 	 * APID = N to N+M-1 are assigned to the secondary bus
 	 * where N = number of APIDs supported by the primary bus and
 	 *       M = number of APIDs supported by the secondary bus
+	 *
+	 * In arbiter version 8, the APID numbering space is divided between
+	 * the SPMI buses according to this mapping:
+	 * APID = 0     to N-1       --> bus 0
+	 * APID = N     to N+M-1     --> bus 1
+	 * APID = N+M   to N+M+P-1   --> bus 2
+	 * APID = N+M+P to N+M+P+Q-1 --> bus 3
+	 * where N = number of APIDs supported by bus 0
+	 *       M = number of APIDs supported by bus 1
+	 *       P = number of APIDs supported by bus 2
+	 *       Q = number of APIDs supported by bus 3
 	 */
+
 	apidd = &bus->apid_data[bus->base_apid];
 	apid_max = bus->base_apid + bus->apid_count;
 	for (i = bus->base_apid; i < apid_max; i++, apidd++) {
 		offset = pmic_arb->ver_ops->apid_map_offset(i);
 		if (offset >= pmic_arb->core_size)
 			break;
-
-		regval = readl_relaxed(pmic_arb->core + offset);
+		regval = readl_relaxed(ppid_base + offset);
 		if (!regval)
 			continue;
-		ppid = (regval >> 8) & PMIC_ARB_PPID_MASK;
-		is_irq_ee = PMIC_ARB_CHAN_IS_IRQ_OWNER(regval);
+		ppid = (regval >> ppid_shift) & ppid_mask;
+		is_irq_ee = regval & irq_owner_mask;
 
 		regval = readl_relaxed(pmic_arb->ver_ops->apid_owner(bus, i));
 		apidd->write_ee = SPMI_OWNERSHIP_PERIPH2OWNER(regval);
@@ -1237,6 +1270,12 @@ static int pmic_arb_read_apid_map_v5(struct spmi_pmic_arb_bus *bus)
 	return 0;
 }
 
+static int pmic_arb_read_apid_map_v5(struct spmi_pmic_arb_bus *bus)
+{
+	return _pmic_arb_read_apid_map(bus, bus->pmic_arb->core, PMIC_ARB_PPID_MASK,
+				       8, PMIC_ARB_CHAN_IS_IRQ_OWNER_MASK);
+}
+
 static int pmic_arb_ppid_to_apid_v5(struct spmi_pmic_arb_bus *bus, u16 ppid)
 {
 	if (!(bus->ppid_to_apid[ppid] & PMIC_ARB_APID_VALID))
@@ -1345,37 +1384,46 @@ static int pmic_arb_get_core_resources_v7(struct platform_device *pdev,
 	return pmic_arb_get_obsrvr_chnls_v2(pdev);
 }
 
-/*
- * Only v7 supports 2 buses. Each bus will get a different apid count, read
- * from different registers.
- */
-static int pmic_arb_init_apid_v7(struct spmi_pmic_arb_bus *bus, int index)
+static int _pmic_arb_init_apid_v7(struct spmi_pmic_arb_bus *bus, int index,
+				  int max_buses, unsigned long periph_mask)
 {
 	struct spmi_pmic_arb *pmic_arb = bus->pmic_arb;
-	int ret;
+	int i;
 
-	if (index == 0) {
-		bus->base_apid = 0;
-		bus->apid_count = readl_relaxed(pmic_arb->core + PMIC_ARB_FEATURES) &
-						   PMIC_ARB_FEATURES_PERIPH_MASK;
-	} else if (index == 1) {
-		bus->base_apid = readl_relaxed(pmic_arb->core + PMIC_ARB_FEATURES) &
-						  PMIC_ARB_FEATURES_PERIPH_MASK;
-		bus->apid_count = readl_relaxed(pmic_arb->core + PMIC_ARB_FEATURES1) &
-						   PMIC_ARB_FEATURES_PERIPH_MASK;
-	} else {
-		dev_err(&bus->spmic->dev, "Unsupported buses count %d detected\n",
-			bus->id);
+	if (index < 0 || index >= max_buses) {
+		dev_err(&bus->spmic->dev, "Unsupported bus index %d detected\n",
+			index);
 		return -EINVAL;
 	}
 
-	if (bus->base_apid + bus->apid_count > pmic_arb->max_periphs) {
-		dev_err(&bus->spmic->dev, "Unsupported APID count %d detected\n",
+	bus->base_apid = 0;
+	bus->apid_count = 0;
+	for (i = 0; i <= index; i++) {
+		bus->base_apid += bus->apid_count;
+		bus->apid_count = readl_relaxed(pmic_arb->core +
+						PMIC_ARB_FEATURES + i * 4) &
+						periph_mask;
+	}
+
+	if (bus->apid_count == 0) {
+		dev_err(&bus->spmic->dev, "Bus %d not implemented\n", index);
+		return -EINVAL;
+	} else if (bus->base_apid + bus->apid_count > pmic_arb->max_periphs) {
+		dev_err(&bus->spmic->dev, "Unsupported max APID %d detected\n",
 			bus->base_apid + bus->apid_count);
 		return -EINVAL;
 	}
 
-	ret = pmic_arb_init_apid_min_max(bus);
+	return pmic_arb_init_apid_min_max(bus);
+}
+
+/*
+ * Arbiter v7 supports 2 buses. Each bus will get a different apid count, read
+ * from different registers.
+ */
+static int pmic_arb_init_apid_v7(struct spmi_pmic_arb_bus *bus, int index)
+{
+	int ret = _pmic_arb_init_apid_v7(bus, index, 2, PMIC_ARB_FEATURES_PERIPH_MASK);
 	if (ret)
 		return ret;
 
@@ -1424,6 +1472,102 @@ static int pmic_arb_offset_v7(struct spmi_pmic_arb_bus *bus, u8 sid, u16 addr,
 	return offset;
 }
 
+static int pmic_arb_get_core_resources_v8(struct platform_device *pdev,
+					  void __iomem *core)
+{
+	struct spmi_pmic_arb *pmic_arb = platform_get_drvdata(pdev);
+
+	pmic_arb->apid_map = devm_platform_ioremap_resource_byname(pdev, "chnl_map");
+	if (IS_ERR(pmic_arb->apid_map))
+		return PTR_ERR(pmic_arb->apid_map);
+
+	pmic_arb->core = core;
+
+	pmic_arb->max_periphs = PMIC_ARB_MAX_PERIPHS_V8;
+
+	return pmic_arb_get_obsrvr_chnls_v2(pdev);
+}
+
+static int pmic_arb_get_bus_resources_v8(struct platform_device *pdev,
+					 struct device_node *node,
+					 struct spmi_pmic_arb_bus *bus)
+{
+	int index;
+
+	index = of_property_match_string(node, "reg-names", "chnl_owner");
+	if (index < 0) {
+		dev_err(&pdev->dev, "chnl_owner reg region missing\n");
+		return -EINVAL;
+	}
+
+	bus->apid_owner = devm_of_iomap(&pdev->dev, node, index, NULL);
+
+	return PTR_ERR_OR_ZERO(bus->apid_owner);
+}
+
+static int pmic_arb_read_apid_map_v8(struct spmi_pmic_arb_bus *bus)
+{
+	return _pmic_arb_read_apid_map(bus, bus->pmic_arb->apid_map,
+				       PMIC_ARB_V8_PPID_MASK, 0,
+				       PMIC_ARB_V8_CHAN_IS_IRQ_OWNER_MASK);
+}
+
+/*
+ * Arbiter v8 supports up to 4 buses. Each bus will get a different apid count, read
+ * from different registers.
+ */
+static int pmic_arb_init_apid_v8(struct spmi_pmic_arb_bus *bus, int index)
+{
+	int ret = _pmic_arb_init_apid_v7(bus, index, 4,
+					 PMIC_ARB_FEATURES_V8_PERIPH_MASK);
+	if (ret)
+		return ret;
+
+	ret = pmic_arb_read_apid_map_v8(bus);
+	if (ret) {
+		dev_err(&bus->spmic->dev, "could not read APID->PPID mapping table, rc= %d\n",
+			ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * v8 offset per ee and per apid for observer channels and per apid for
+ * read/write channels.
+ */
+static int pmic_arb_offset_v8(struct spmi_pmic_arb_bus *bus, u8 sid, u16 addr,
+			      enum pmic_arb_channel ch_type)
+{
+	struct spmi_pmic_arb *pmic_arb = bus->pmic_arb;
+	u16 apid;
+	int rc;
+	u32 offset = 0;
+	u16 ppid = (sid << 8) | (addr >> 8);
+
+	rc = pmic_arb->ver_ops->ppid_to_apid(bus, ppid);
+	if (rc < 0)
+		return rc;
+
+	apid = rc;
+	switch (ch_type) {
+	case PMIC_ARB_CHANNEL_OBS:
+		offset = 0x40000 * pmic_arb->ee + 0x20 * apid;
+		break;
+	case PMIC_ARB_CHANNEL_RW:
+		if (bus->apid_data[apid].write_ee != pmic_arb->ee) {
+			dev_err(&bus->spmic->dev, "disallowed SPMI write to sid=%u, addr=0x%04X\n",
+				sid, addr);
+			return -EPERM;
+		}
+		offset = 0x200 * apid;
+		break;
+	}
+
+	return offset;
+}
+
 static u32 pmic_arb_fmt_cmd_v1(u8 opc, u8 sid, u16 addr, u8 bc)
 {
 	return (opc << 27) | ((sid & 0xf) << 20) | (addr << 4) | (bc & 0x7);
@@ -1490,6 +1634,14 @@ pmic_arb_acc_enable_v7(struct spmi_pmic_arb_bus *bus, u16 n)
 	return pmic_arb->wr_base + 0x100 + 0x1000 * n;
 }
 
+static void __iomem *
+pmic_arb_acc_enable_v8(struct spmi_pmic_arb_bus *bus, u16 n)
+{
+	struct spmi_pmic_arb *pmic_arb = bus->pmic_arb;
+
+	return pmic_arb->wr_base + 0x100 + 0x200 * n;
+}
+
 static void __iomem *
 pmic_arb_irq_status_v1(struct spmi_pmic_arb_bus *bus, u16 n)
 {
@@ -1516,6 +1668,14 @@ pmic_arb_irq_status_v7(struct spmi_pmic_arb_bus *bus, u16 n)
 	return pmic_arb->wr_base + 0x104 + 0x1000 * n;
 }
 
+static void __iomem *
+pmic_arb_irq_status_v8(struct spmi_pmic_arb_bus *bus, u16 n)
+{
+	struct spmi_pmic_arb *pmic_arb = bus->pmic_arb;
+
+	return pmic_arb->wr_base + 0x104 + 0x200 * n;
+}
+
 static void __iomem *
 pmic_arb_irq_clear_v1(struct spmi_pmic_arb_bus *bus, u16 n)
 {
@@ -1542,6 +1702,14 @@ pmic_arb_irq_clear_v7(struct spmi_pmic_arb_bus *bus, u16 n)
 	return pmic_arb->wr_base + 0x108 + 0x1000 * n;
 }
 
+static void __iomem *
+pmic_arb_irq_clear_v8(struct spmi_pmic_arb_bus *bus, u16 n)
+{
+	struct spmi_pmic_arb *pmic_arb = bus->pmic_arb;
+
+	return pmic_arb->wr_base + 0x108 + 0x200 * n;
+}
+
 static u32 pmic_arb_apid_map_offset_v2(u16 n)
 {
 	return 0x800 + 0x4 * n;
@@ -1557,6 +1725,12 @@ static u32 pmic_arb_apid_map_offset_v7(u16 n)
 	return 0x2000 + 0x4 * n;
 }
 
+static u32 pmic_arb_apid_map_offset_v8(u16 n)
+{
+	/* For v8, offset is from "chnl_map" base register, not "core". */
+	return 0x4 * n;
+}
+
 static void __iomem *
 pmic_arb_apid_owner_v2(struct spmi_pmic_arb_bus *bus, u16 n)
 {
@@ -1564,7 +1738,7 @@ pmic_arb_apid_owner_v2(struct spmi_pmic_arb_bus *bus, u16 n)
 }
 
 /*
- * For arbiter version 7, APID ownership table registers have independent
+ * For arbiter version 7 and 8, APID ownership table registers have independent
  * numbering space for each SPMI bus instance, so each is indexed starting from
  * 0.
  */
@@ -1574,6 +1748,12 @@ pmic_arb_apid_owner_v7(struct spmi_pmic_arb_bus *bus, u16 n)
 	return bus->cnfg + 0x4 * (n - bus->base_apid);
 }
 
+static void __iomem *
+pmic_arb_apid_owner_v8(struct spmi_pmic_arb_bus *bus, u16 n)
+{
+	return bus->apid_owner + 0x4 * (n - bus->base_apid);
+}
+
 static const struct pmic_arb_ver_ops pmic_arb_v1 = {
 	.ver_str		= "v1",
 	.get_core_resources	= pmic_arb_get_core_resources_v1,
@@ -1654,6 +1834,23 @@ static const struct pmic_arb_ver_ops pmic_arb_v7 = {
 	.apid_owner		= pmic_arb_apid_owner_v7,
 };
 
+static const struct pmic_arb_ver_ops pmic_arb_v8 = {
+	.ver_str		= "v8",
+	.get_core_resources	= pmic_arb_get_core_resources_v8,
+	.get_bus_resources	= pmic_arb_get_bus_resources_v8,
+	.init_apid		= pmic_arb_init_apid_v8,
+	.ppid_to_apid		= pmic_arb_ppid_to_apid_v5,
+	.non_data_cmd		= pmic_arb_non_data_cmd_v2,
+	.offset			= pmic_arb_offset_v8,
+	.fmt_cmd		= pmic_arb_fmt_cmd_v2,
+	.owner_acc_status	= pmic_arb_owner_acc_status_v7,
+	.acc_enable		= pmic_arb_acc_enable_v8,
+	.irq_status		= pmic_arb_irq_status_v8,
+	.irq_clear		= pmic_arb_irq_clear_v8,
+	.apid_map_offset	= pmic_arb_apid_map_offset_v8,
+	.apid_owner		= pmic_arb_apid_owner_v8,
+};
+
 static const struct irq_domain_ops pmic_arb_irq_domain_ops = {
 	.activate = qpnpint_irq_domain_activate,
 	.alloc = qpnpint_irq_domain_alloc,
@@ -1731,6 +1928,12 @@ static int spmi_pmic_arb_bus_init(struct platform_device *pdev,
 	bus->spmic = ctrl;
 	bus->id = bus_index;
 
+	if (pmic_arb->ver_ops->get_bus_resources) {
+		ret = pmic_arb->ver_ops->get_bus_resources(pdev, node, bus);
+		if (ret)
+			return ret;
+	}
+
 	ret = pmic_arb->ver_ops->init_apid(bus, bus_index);
 	if (ret)
 		return ret;
@@ -1825,8 +2028,10 @@ static int spmi_pmic_arb_probe(struct platform_device *pdev)
 		pmic_arb->ver_ops = &pmic_arb_v3;
 	else if (hw_ver < PMIC_ARB_VERSION_V7_MIN)
 		pmic_arb->ver_ops = &pmic_arb_v5;
-	else
+	else if (hw_ver < PMIC_ARB_VERSION_V8_MIN)
 		pmic_arb->ver_ops = &pmic_arb_v7;
+	else
+		pmic_arb->ver_ops = &pmic_arb_v8;
 
 	err = pmic_arb->ver_ops->get_core_resources(pdev, core);
 	if (err)
@@ -1875,6 +2080,7 @@ static void spmi_pmic_arb_remove(struct platform_device *pdev)
 static const struct of_device_id spmi_pmic_arb_match_table[] = {
 	{ .compatible = "qcom,spmi-pmic-arb", },
 	{ .compatible = "qcom,x1e80100-spmi-pmic-arb", },
+	{ .compatible = "qcom,glymur-spmi-pmic-arb", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, spmi_pmic_arb_match_table);
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

