Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7845E1304AD;
	Wed, 19 Jun 2024 13:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802072; cv=none; b=KfFDCzDtghAKR52XQ4DI5/Yr975nEv7ORx6p7zUpcwfyM8YCzJYpJX2tPp8IsGEHK6IPkZHKcLNCVWv/4Ma7x7AmfRVeHzW7ZrPMfAVFNcDYkUPmWqxX/jixOGvyaVk46l+YaoWGW0p19dkx2GVsGGaOnEgd22BCGiomzcqYuE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802072; c=relaxed/simple;
	bh=BGduIpxCMTAk1FkdTuqzQgiH7fUD1LeM20uQ4RtyDAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0y2rbJCkxRt4PBHU4BArTgLH/nE8BweJtEBPB7G+1oX15atrCkk5cKLwAxBWXFsCgqidWLk/KJvecvPv6HQmtIRMHCOyB7GDLtLmZKYzgup5VdqRfDluN2aSSTPAfxO0xphRByLI0lOVXTJSFqDViOr1C9bQFhQYSpSs2NknJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qVCcjzx8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qVCcjzx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC60C4AF1A;
	Wed, 19 Jun 2024 13:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802072;
	bh=BGduIpxCMTAk1FkdTuqzQgiH7fUD1LeM20uQ4RtyDAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qVCcjzx89QL/CSBgicNuOU+136WSVJLK5GgX1UH34FW3A7fjiw4te+at0RA8MRnsI
	 i6ATkpxRbTMvTaqG3CJU/XScb2jOY+pK89s9v414XvQ47ExTuRKqnB0j5lfwX+tAE3
	 ES4qMGj8tL1py4QmbzIBx9bIetQ2XKfCxo88r5DQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Chien Peter Lin <peterlin@andestech.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Randolph <randolph@andestech.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/267] irqchip/riscv-intc: Introduce Andes hart-level interrupt controller
Date: Wed, 19 Jun 2024 14:53:43 +0200
Message-ID: <20240619125609.120016853@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Yu Chien Peter Lin <peterlin@andestech.com>

[ Upstream commit f4cc33e78ba8624a79ba8dea98ce5c85aa9ca33c ]

Add support for the Andes hart-level interrupt controller. This
controller provides interrupt mask/unmask functions to access the
custom register (SLIE) where the non-standard S-mode local interrupt
enable bits are located. The base of custom interrupt number is set
to 256.

To share the riscv_intc_domain_map() with the generic RISC-V INTC and
ACPI, add a chip parameter to riscv_intc_init_common(), so it can be
passed to the irq_domain_set_info() as a private data.

Andes hart-level interrupt controller requires the "andestech,cpu-intc"
compatible string to be present in interrupt-controller of cpu node to
enable the use of custom local interrupt source.
e.g.,

  cpu0: cpu@0 {
      compatible = "andestech,ax45mp", "riscv";
      ...
      cpu0-intc: interrupt-controller {
          #interrupt-cells = <0x01>;
          compatible = "andestech,cpu-intc", "riscv,cpu-intc";
          interrupt-controller;
      };
  };

Signed-off-by: Yu Chien Peter Lin <peterlin@andestech.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Randolph <randolph@andestech.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20240222083946.3977135-4-peterlin@andestech.com
Stable-dep-of: 0110c4b11047 ("irqchip/riscv-intc: Prevent memory leak when riscv_intc_init_common() fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-riscv-intc.c | 58 ++++++++++++++++++++++++++++----
 include/linux/soc/andes/irq.h    | 18 ++++++++++
 2 files changed, 69 insertions(+), 7 deletions(-)
 create mode 100644 include/linux/soc/andes/irq.h

diff --git a/drivers/irqchip/irq-riscv-intc.c b/drivers/irqchip/irq-riscv-intc.c
index 684875c397280..0cd6b48a5dbf9 100644
--- a/drivers/irqchip/irq-riscv-intc.c
+++ b/drivers/irqchip/irq-riscv-intc.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/smp.h>
+#include <linux/soc/andes/irq.h>
 
 static struct irq_domain *intc_domain;
 static unsigned int riscv_intc_nr_irqs __ro_after_init = BITS_PER_LONG;
@@ -48,6 +49,31 @@ static void riscv_intc_irq_unmask(struct irq_data *d)
 	csr_set(CSR_IE, BIT(d->hwirq));
 }
 
+static void andes_intc_irq_mask(struct irq_data *d)
+{
+	/*
+	 * Andes specific S-mode local interrupt causes (hwirq)
+	 * are defined as (256 + n) and controlled by n-th bit
+	 * of SLIE.
+	 */
+	unsigned int mask = BIT(d->hwirq % BITS_PER_LONG);
+
+	if (d->hwirq < ANDES_SLI_CAUSE_BASE)
+		csr_clear(CSR_IE, mask);
+	else
+		csr_clear(ANDES_CSR_SLIE, mask);
+}
+
+static void andes_intc_irq_unmask(struct irq_data *d)
+{
+	unsigned int mask = BIT(d->hwirq % BITS_PER_LONG);
+
+	if (d->hwirq < ANDES_SLI_CAUSE_BASE)
+		csr_set(CSR_IE, mask);
+	else
+		csr_set(ANDES_CSR_SLIE, mask);
+}
+
 static void riscv_intc_irq_eoi(struct irq_data *d)
 {
 	/*
@@ -71,12 +97,21 @@ static struct irq_chip riscv_intc_chip = {
 	.irq_eoi = riscv_intc_irq_eoi,
 };
 
+static struct irq_chip andes_intc_chip = {
+	.name		= "RISC-V INTC",
+	.irq_mask	= andes_intc_irq_mask,
+	.irq_unmask	= andes_intc_irq_unmask,
+	.irq_eoi	= riscv_intc_irq_eoi,
+};
+
 static int riscv_intc_domain_map(struct irq_domain *d, unsigned int irq,
 				 irq_hw_number_t hwirq)
 {
+	struct irq_chip *chip = d->host_data;
+
 	irq_set_percpu_devid(irq);
-	irq_domain_set_info(d, irq, hwirq, &riscv_intc_chip, d->host_data,
-			    handle_percpu_devid_irq, NULL, NULL);
+	irq_domain_set_info(d, irq, hwirq, chip, NULL, handle_percpu_devid_irq,
+			    NULL, NULL);
 
 	return 0;
 }
@@ -122,11 +157,12 @@ static struct fwnode_handle *riscv_intc_hwnode(void)
 	return intc_domain->fwnode;
 }
 
-static int __init riscv_intc_init_common(struct fwnode_handle *fn)
+static int __init riscv_intc_init_common(struct fwnode_handle *fn,
+					 struct irq_chip *chip)
 {
 	int rc;
 
-	intc_domain = irq_domain_create_tree(fn, &riscv_intc_domain_ops, NULL);
+	intc_domain = irq_domain_create_tree(fn, &riscv_intc_domain_ops, chip);
 	if (!intc_domain) {
 		pr_err("unable to add IRQ domain\n");
 		return -ENXIO;
@@ -152,8 +188,9 @@ static int __init riscv_intc_init_common(struct fwnode_handle *fn)
 static int __init riscv_intc_init(struct device_node *node,
 				  struct device_node *parent)
 {
-	int rc;
+	struct irq_chip *chip = &riscv_intc_chip;
 	unsigned long hartid;
+	int rc;
 
 	rc = riscv_of_parent_hartid(node, &hartid);
 	if (rc < 0) {
@@ -178,10 +215,17 @@ static int __init riscv_intc_init(struct device_node *node,
 		return 0;
 	}
 
-	return riscv_intc_init_common(of_node_to_fwnode(node));
+	if (of_device_is_compatible(node, "andestech,cpu-intc")) {
+		riscv_intc_custom_base = ANDES_SLI_CAUSE_BASE;
+		riscv_intc_custom_nr_irqs = ANDES_RV_IRQ_LAST;
+		chip = &andes_intc_chip;
+	}
+
+	return riscv_intc_init_common(of_node_to_fwnode(node), chip);
 }
 
 IRQCHIP_DECLARE(riscv, "riscv,cpu-intc", riscv_intc_init);
+IRQCHIP_DECLARE(andes, "andestech,cpu-intc", riscv_intc_init);
 
 #ifdef CONFIG_ACPI
 
@@ -208,7 +252,7 @@ static int __init riscv_intc_acpi_init(union acpi_subtable_headers *header,
 		return -ENOMEM;
 	}
 
-	return riscv_intc_init_common(fn);
+	return riscv_intc_init_common(fn, &riscv_intc_chip);
 }
 
 IRQCHIP_ACPI_DECLARE(riscv_intc, ACPI_MADT_TYPE_RINTC, NULL,
diff --git a/include/linux/soc/andes/irq.h b/include/linux/soc/andes/irq.h
new file mode 100644
index 0000000000000..edc3182d6e661
--- /dev/null
+++ b/include/linux/soc/andes/irq.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2023 Andes Technology Corporation
+ */
+#ifndef __ANDES_IRQ_H
+#define __ANDES_IRQ_H
+
+/* Andes PMU irq number */
+#define ANDES_RV_IRQ_PMOVI		18
+#define ANDES_RV_IRQ_LAST		ANDES_RV_IRQ_PMOVI
+#define ANDES_SLI_CAUSE_BASE		256
+
+/* Andes PMU related registers */
+#define ANDES_CSR_SLIE			0x9c4
+#define ANDES_CSR_SLIP			0x9c5
+#define ANDES_CSR_SCOUNTEROF		0x9d4
+
+#endif /* __ANDES_IRQ_H */
-- 
2.43.0



