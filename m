Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E962A299927;
	Fri, 23 Jan 2026 18:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769192443; cv=none; b=cb7JAxAobZcxSo104UXhJFdCNI6chuZ6LhQzK/bJV5p59Vf6cbOAx2wmk5FC6E1+JssyWwO+GMj0wBOQhRsfZsK+t3V9V8hxwnLVCGXftgn7sCgijsN/KOHLwg0uwsBPljK8oBr42iBdcVKoXS46fufvSZcFRs68sL+0dj2ie8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769192443; c=relaxed/simple;
	bh=83eIvNUiWT8ns/OAK/Rxj5oGr8sNrYvQbRvCDOgB8Oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qvggRnCKz0xAxl34fTeYeUeAjZj4a3vA6lI4vIKBnFIgp9KZ5xoz9SA+VV/Za2jabyUVXeiQFP95w5reOZbdPn8oT5dvgij5ncabDOLTpqXfQh1JuZiUZkkD7tVe+n2DsGRt6IyLOz9d1pF9fTsmlWhqxJdh1aBjH6hIvAP6G1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HQr3TLu6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HQr3TLu6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A43C19424;
	Fri, 23 Jan 2026 18:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769192442;
	bh=83eIvNUiWT8ns/OAK/Rxj5oGr8sNrYvQbRvCDOgB8Oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HQr3TLu6liNt3odt/pwuaj7eYU+GfJhLh9hes84w1GqiUJvUtxkBifuaoWeWVUsrf
	 2nkAzn72zSyFbUXTmNccyntplfw/bVFBTYkfJfseh6yNsGLlsnTDBXsojHjM0cJX3k
	 7oZY9iWyHuIn27/+c4+6Jn/nyMA8fi9lURsQIXJpkUk96Km+qCBpxyjT6uodLhsl6E
	 zWMKP5k7CifoDxrWJTjjguLU6M/Aw6R48RXuCOU7zU5AyPkrIZ58I2y24uZFsoX94G
	 w5OSefZquaUvWUgXIpvIR/WfhD5yJyQvUCEED2KB7288hZoZyT2FVvlEEd8hsUGGFE
	 6DjH94McC8qPQ==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	=?UTF-8?q?N=C3=ADcolas=20F=2E=20R=2E=20A=2E=20Prado?= <nfraprado@collabora.com>
Subject: [PATCH 04/10] spmi: mtk-pmif: Implement Request Capable Slave (RCS) interrupt
Date: Fri, 23 Jan 2026 10:20:32 -0800
Message-ID: <20260123182039.224314-5-sboyd@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260123182039.224314-1-sboyd@kernel.org>
References: <20260123182039.224314-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

Add support for the per-bus RCS interrupt by adding a new linear
irqdomain and its irqchip.

The SPMI controller will raise an interrupt when any of the SPMI
connected devices' irq needs attention (whenever any interrupt
fires on any SID) in one of four registers, where each register
holds four sets of four bits of information about a SID interrupt.

This controller's RCS interrupt status knowledge is limited to the
address of the SID that raised an interrupt, but does not have any
details about the devices irq numbers: as this may change with a
future SPMI controller IP version, the devicetree is meant to hold
three cells, where the first one is the SPMI SID interrupt number,
the second one is a device interrupt number, and the third one is
the irq sense type.

Reviewed-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/spmi/spmi-mtk-pmif.c | 232 ++++++++++++++++++++++++++++++++++-
 1 file changed, 226 insertions(+), 6 deletions(-)

diff --git a/drivers/spmi/spmi-mtk-pmif.c b/drivers/spmi/spmi-mtk-pmif.c
index 9f416b231ab8..624611dd4849 100644
--- a/drivers/spmi/spmi-mtk-pmif.c
+++ b/drivers/spmi/spmi-mtk-pmif.c
@@ -5,12 +5,17 @@
 //                    AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
 
 #include <linux/clk.h>
+#include <linux/interrupt.h>
 #include <linux/iopoll.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_irq.h>
 #include <linux/platform_device.h>
 #include <linux/property.h>
 #include <linux/spmi.h>
+#include <linux/irqchip/chained_irq.h>
 
 #define SWINF_IDLE	0x00
 #define SWINF_WFVLDCLR	0x06
@@ -26,6 +31,7 @@
 #define PMIF_TIMEOUT_US (10 * 1000)
 
 #define PMIF_CHAN_OFFSET 0x5
+#define PMIF_RCS_IRQ_MASK	GENMASK(7, 0)
 
 #define PMIF_MAX_BUSES	2
 #define PMIF_MAX_CLKS	3
@@ -44,6 +50,7 @@ struct pmif_data {
 	const u32	*regs;
 	const u32	*spmimst_regs;
 	u32	soc_chan;
+	u8	spmi_ver;
 	u32	num_spmi_buses;
 };
 
@@ -51,8 +58,13 @@ struct pmif_bus {
 	void __iomem	*base;
 	void __iomem	*spmimst_base;
 	struct spmi_controller *ctrl;
+	struct irq_domain *dom;
+	int irq;
 	struct clk_bulk_data clks[PMIF_MAX_CLKS];
 	size_t nclks;
+	u8 irq_min_sid;
+	u8 irq_max_sid;
+	u16 irq_en;
 	raw_spinlock_t	lock;
 };
 
@@ -287,6 +299,11 @@ static void pmif_writel(struct pmif *arb, struct pmif_bus *pbus,
 	writel(val, pbus->base + arb->data->regs[reg]);
 }
 
+static u32 mtk_spmi_readl(struct pmif *arb, struct pmif_bus *pbus, enum spmi_regs reg)
+{
+	return readl(pbus->spmimst_base + arb->data->spmimst_regs[reg]);
+}
+
 static void mtk_spmi_writel(struct pmif *arb, struct pmif_bus *pbus,
 			    u32 val, enum spmi_regs reg)
 {
@@ -343,7 +360,6 @@ static int pmif_spmi_read_cmd(struct spmi_controller *ctrl, u8 opc, u8 sid,
 
 	if (len > 4) {
 		dev_err(&ctrl->dev, "pmif supports 1..4 bytes per trans, but:%zu requested", len);
-
 		return -EINVAL;
 	}
 
@@ -455,6 +471,159 @@ static int pmif_spmi_write_cmd(struct spmi_controller *ctrl, u8 opc, u8 sid,
 	return 0;
 }
 
+static void mtk_spmi_handle_chained_irq(struct irq_desc *desc)
+{
+	struct pmif_bus *pbus = irq_desc_get_handler_data(desc);
+	struct irq_chip *chip = irq_desc_get_chip(desc);
+	struct pmif *arb = to_mtk_pmif(pbus->ctrl);
+	u8 regidx_min, regidx_max;
+	bool irq_handled = false;
+	unsigned int i;
+
+	regidx_min = pbus->irq_min_sid / 4;
+	regidx_min += SPMI_SLV_3_0_EINT;
+
+	regidx_max = pbus->irq_max_sid / 4;
+	regidx_max += SPMI_SLV_3_0_EINT;
+
+	chained_irq_enter(chip, desc);
+
+	for (i = regidx_min; i <= regidx_max; i++) {
+		u32 val = mtk_spmi_readl(arb, pbus, i);
+
+		while (val) {
+			u8 bit = __ffs(val);
+			u8 bank = bit / 7;
+			u8 sid = ((i - SPMI_SLV_3_0_EINT) * 4) + bank;
+
+			val &= ~(PMIF_RCS_IRQ_MASK << (8 * bank));
+
+			/* Check if IRQs for this SID are enabled */
+			if (!(pbus->irq_en & BIT(sid)))
+				continue;
+
+			generic_handle_domain_irq_safe(pbus->dom, sid);
+			irq_handled = true;
+		}
+	}
+
+	if (!irq_handled)
+		handle_bad_irq(desc);
+
+	chained_irq_exit(chip, desc);
+}
+
+static void mtk_spmi_rcs_irq_eoi(struct irq_data *d)
+{
+	struct pmif_bus *pbus = irq_data_get_irq_chip_data(d);
+	struct pmif *arb = to_mtk_pmif(pbus->ctrl);
+	irq_hw_number_t irq = irqd_to_hwirq(d);
+	unsigned int reg, shift;
+
+	/* There are four interrupts (8 bits each) per register */
+	reg = SPMI_SLV_3_0_EINT + d->hwirq / 4;
+	shift = (irq % 4) * 8;
+
+	mtk_spmi_writel(arb, pbus, PMIF_RCS_IRQ_MASK << shift, reg);
+}
+
+static void mtk_spmi_rcs_irq_enable(struct irq_data *d)
+{
+	struct pmif_bus *pbus = irq_data_get_irq_chip_data(d);
+	irq_hw_number_t irq = irqd_to_hwirq(d);
+
+	pbus->irq_en |= BIT(irq);
+}
+
+static void mtk_spmi_rcs_irq_disable(struct irq_data *d)
+{
+	struct pmif_bus *pbus = irq_data_get_irq_chip_data(d);
+	irq_hw_number_t irq = irqd_to_hwirq(d);
+
+	pbus->irq_en &= ~BIT(irq);
+}
+
+static int mtk_spmi_rcs_irq_set_wake(struct irq_data *d, unsigned int on)
+{
+	struct pmif_bus *pbus = irq_data_get_irq_chip_data(d);
+
+	return irq_set_irq_wake(pbus->irq, on);
+}
+
+static const struct irq_chip mtk_spmi_rcs_irq_chip = {
+	.name			= "spmi_rcs",
+	.irq_eoi		= mtk_spmi_rcs_irq_eoi,
+	.irq_enable		= mtk_spmi_rcs_irq_enable,
+	.irq_disable		= mtk_spmi_rcs_irq_disable,
+	.irq_set_wake		= mtk_spmi_rcs_irq_set_wake,
+};
+
+static int mtk_spmi_rcs_irq_translate(struct irq_domain *d, struct irq_fwspec *fwspec,
+				      unsigned long *out_hwirq, unsigned int *out_type)
+{
+	struct pmif_bus *pbus = d->host_data;
+	struct device *dev = &pbus->ctrl->dev;
+	u32 *intspec = fwspec->param;
+
+	if (intspec[0] > SPMI_MAX_SLAVE_ID)
+		return -EINVAL;
+
+	/*
+	 * The IRQ number in intspec[1] is ignored on purpose here!
+	 *
+	 * The controller only has knowledge of which SID raised an interrupt
+	 * and the type of irq, but doesn't know about any device irq number,
+	 * hence that must be read from the SPMI device's registers.
+	 */
+	*out_hwirq = intspec[0];
+	*out_type = intspec[2] & IRQ_TYPE_SENSE_MASK;
+
+	if (pbus->irq_min_sid > intspec[0])
+		pbus->irq_min_sid = intspec[0];
+
+	if (pbus->irq_max_sid < intspec[0])
+		pbus->irq_max_sid = intspec[0];
+
+	dev_dbg(dev, "Found SPMI IRQ %u (map: 0x%lx)\n", intspec[0], *out_hwirq);
+
+	return 0;
+}
+
+static struct lock_class_key mtk_spmi_rcs_irqlock_class, mtk_spmi_rcs_irqreq_class;
+
+static int mtk_spmi_rcs_irq_alloc(struct irq_domain *d, unsigned int virq,
+				  unsigned int nr_irqs, void *data)
+{
+	struct pmif_bus *pbus = d->host_data;
+	struct device *dev = &pbus->ctrl->dev;
+	struct irq_fwspec *fwspec = data;
+	irq_hw_number_t hwirq;
+	unsigned int irqtype;
+	int i, ret;
+
+	ret = mtk_spmi_rcs_irq_translate(d, fwspec, &hwirq, &irqtype);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < nr_irqs; i++) {
+		dev_dbg(dev, "Mapping IRQ%u (hwirq %lu) with type %u\n",
+			virq, hwirq, irqtype);
+
+		irq_set_lockdep_class(virq, &mtk_spmi_rcs_irqlock_class,
+				      &mtk_spmi_rcs_irqreq_class);
+		irq_domain_set_info(d, virq, hwirq, &mtk_spmi_rcs_irq_chip,
+				    pbus, handle_level_irq, NULL, NULL);
+	}
+
+	return 0;
+}
+
+static const struct irq_domain_ops mtk_spmi_rcs_irq_domain_ops = {
+	.alloc = mtk_spmi_rcs_irq_alloc,
+	.free = irq_domain_free_irqs_common,
+	.translate = mtk_spmi_rcs_irq_translate,
+};
+
 static const struct pmif_data mt6873_pmif_arb = {
 	.regs = mt6873_regs,
 	.spmimst_regs = mt6873_spmi_regs,
@@ -467,6 +636,44 @@ static const struct pmif_data mt8195_pmif_arb = {
 	.soc_chan = 2,
 };
 
+static int mtk_spmi_irq_init(struct device_node *node,
+			     const struct pmif_data *pdata,
+			     struct pmif_bus *pbus)
+{
+	struct pmif *arb = to_mtk_pmif(pbus->ctrl);
+	unsigned int i;
+
+	/* No interrupts required for SPMI 1.x controller */
+	if (pdata->spmi_ver < 2) {
+		pbus->dom = NULL;
+		return 0;
+	}
+
+	pbus->irq = of_irq_get_byname(node, "rcs");
+	if (pbus->irq <= 0)
+		return pbus->irq ? : -ENXIO;
+
+	pbus->dom = irq_domain_create_tree(of_fwnode_handle(node),
+					   &mtk_spmi_rcs_irq_domain_ops, pbus);
+	if (!pbus->dom)
+		return -ENOMEM;
+
+	/* Clear possible unhandled interrupts coming from bootloader SPMI init */
+	for (i = SPMI_SLV_3_0_EINT; i <= SPMI_SLV_F_C_EINT; i++)
+		mtk_spmi_writel(arb, pbus, GENMASK(31, 0), i);
+
+	return 0;
+}
+
+static void mtk_spmi_irq_remove(struct pmif_bus *pbus)
+{
+	if (!pbus->dom)
+		return;
+
+	irq_set_chained_handler_and_data(pbus->irq, NULL, NULL);
+	irq_domain_remove(pbus->dom);
+}
+
 static int mtk_spmi_bus_probe(struct platform_device *pdev,
 			      struct device_node *node,
 			      const struct pmif_data *pdata,
@@ -512,12 +719,21 @@ static int mtk_spmi_bus_probe(struct platform_device *pdev,
 		pbus->clks[i].id = pmif_clock_names[i];
 		pbus->clks[i].clk = of_clk_get_by_name(node, pbus->clks[i].id);
 		if (IS_ERR(pbus->clks[i].clk))
-			return PTR_ERR(pbus->clks[i].clk);
+			return dev_err_probe(&pdev->dev, PTR_ERR(pbus->clks[i].clk),
+					     "Failed to get clocks\n");
 	}
 
 	err = clk_bulk_prepare_enable(pbus->nclks, pbus->clks);
-	if (err)
+	if (err) {
+		dev_err_probe(&pdev->dev, err, "Failed to enable clocks\n");
 		goto err_put_clks;
+	}
+
+	err = mtk_spmi_irq_init(node, pdata, pbus);
+	if (err) {
+		dev_err_probe(&pdev->dev, err, "Cannot initialize SPMI IRQs\n");
+		goto err_disable_clks;
+	}
 
 	ctrl->cmd = pmif_arb_cmd;
 	ctrl->read_cmd = pmif_spmi_read_cmd;
@@ -529,13 +745,16 @@ static int mtk_spmi_bus_probe(struct platform_device *pdev,
 
 	err = spmi_controller_add(ctrl);
 	if (err)
-		goto err_domain_remove;
+		goto err_remove_irq;
 
-	pbus->ctrl = ctrl;
+	if (pbus->dom)
+		irq_set_chained_handler_and_data(pbus->irq, mtk_spmi_handle_chained_irq, pbus);
 
 	return 0;
 
-err_domain_remove:
+err_remove_irq:
+	mtk_spmi_irq_remove(pbus);
+err_disable_clks:
 	clk_bulk_disable_unprepare(pbus->nclks, pbus->clks);
 err_put_clks:
 	clk_bulk_put(pbus->nclks, pbus->clks);
@@ -600,6 +819,7 @@ static void mtk_spmi_remove(struct platform_device *pdev)
 		if (!pbus->ctrl)
 			continue;
 
+		mtk_spmi_irq_remove(pbus);
 		spmi_controller_remove(pbus->ctrl);
 		clk_bulk_disable_unprepare(pbus->nclks, pbus->clks);
 		clk_bulk_put(pbus->nclks, pbus->clks);
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

