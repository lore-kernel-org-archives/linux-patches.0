Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB4836B923;
	Sat, 12 Sep 2026 18:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238755; cv=none; b=Fv5JLzaku+K4K4J2YPrcHzeDLV64pW7NUo5d/JnYIkQya9xSVi1sIuHP0LKd3s/9UEqf9ZCzxUAOguuuXYFPGC3nsgu3gamOCIktihF9Zepy/siHPONCEOC/ezkGv1TPY5qs8eZRm5BRPIsOvEAZxYT74AL0B3j3M0Gcwdfst/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238755; c=relaxed/simple;
	bh=wk8cjBjTEDL94DCDaU9OdrcMArdmR1x2evBizseKiwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7KC4R35riFn9Ev0MTl99c1+02B9YyfRxe+7yrBpUHt1P63m+eOCnQRf9jaTcbMQWmCFWAYWMGBcy57JecRTt3AOYVIArhdOmC7cWFdaqNNz6BgvevbcH+FKypMYOCngaU6XYDK/GpBnkthVPMK0nE23YFtCSvPBN1OhVMr/eqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZH6WcKUz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZH6WcKUz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD2B91F000FF;
	Sat, 12 Sep 2026 18:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238754;
	bh=56Ak+SryFOPoy7bwkZ+FOKelMJggKGRgysEJRNrsnBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZH6WcKUzyTSt6e+uyDb7Sy4V/Rc8PCqg5t9uYICbicr5bGAhaAWTLW5XiFase+ceX
	 LTyea589fSpG6514bbKktyzvu3WmMVmrTn+BmFGZodOSb7htg7uZbcZaybHYMnMt9f
	 AsGjHiu6QqnXRYNgqgw6NjuMawmKa1p47M44dJhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Herve Codina <herve.codina@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 525/935] genirq/generic_chip: Introduce irq_domain_{alloc,remove}_generic_chips()
Date: Sat, 12 Sep 2026 08:59:15 +0200
Message-ID: <20260912065538.865274061@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit e25f553a92973eaf59ff3a00fe7f61ab01b2877f ]

The existing __irq_alloc_domain_generic_chips() uses a bunch of parameters
to describe the generic chips that need to be allocated.

Adding more parameters and wrappers to hide new parameters in the existing
code leads to more and more code without any relevant values and without
any flexibility.

Introduce irq_domain_alloc_generic_chips() where the generic chips
description is done using the irq_domain_chip_generic_info structure
instead of the bunch of parameters to allow flexibility and easy evolution.

Also introduce irq_domain_remove_generic_chips() to revert the operations
done by irq_domain_alloc_generic_chips().

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20240614173232.1184015-14-herve.codina@bootlin.com
Stable-dep-of: 616dd89d81ad ("irqchip/renesas-irqc: Fix generic interrupt chip leak on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/irq.h       | 25 +++++++++++
 kernel/irq/generic-chip.c | 91 +++++++++++++++++++++++++++++----------
 2 files changed, 93 insertions(+), 23 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 4fd8d900a1b86..0cee0f19ea34d 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -1109,6 +1109,27 @@ struct irq_domain_chip_generic {
 	struct irq_chip_generic	*gc[];
 };
 
+/**
+ * struct irq_domain_chip_generic_info - Generic chip information structure
+ * @name:		Name of the generic interrupt chip
+ * @handler:		Interrupt handler used by the generic interrupt chip
+ * @irqs_per_chip:	Number of interrupts each chip handles (max 32)
+ * @num_ct:		Number of irq_chip_type instances associated with each
+ *			chip
+ * @irq_flags_to_clear:	IRQ_* bits to clear in the mapping function
+ * @irq_flags_to_set:	IRQ_* bits to set in the mapping function
+ * @gc_flags:		Generic chip specific setup flags
+ */
+struct irq_domain_chip_generic_info {
+	const char		*name;
+	irq_flow_handler_t	handler;
+	unsigned int		irqs_per_chip;
+	unsigned int		num_ct;
+	unsigned int		irq_flags_to_clear;
+	unsigned int		irq_flags_to_set;
+	enum irq_gc_flags	gc_flags;
+};
+
 /* Generic chip callback functions */
 void irq_gc_noop(struct irq_data *d);
 void irq_gc_mask_disable_reg(struct irq_data *d);
@@ -1144,6 +1165,10 @@ int devm_irq_setup_generic_chip(struct device *dev, struct irq_chip_generic *gc,
 
 struct irq_chip_generic *irq_get_domain_generic_chip(struct irq_domain *d, unsigned int hw_irq);
 
+int irq_domain_alloc_generic_chips(struct irq_domain *d,
+				   const struct irq_domain_chip_generic_info *info);
+void irq_domain_remove_generic_chips(struct irq_domain *d);
+
 int __irq_alloc_domain_generic_chips(struct irq_domain *d, int irqs_per_chip,
 				     int num_ct, const char *name,
 				     irq_flow_handler_t handler,
diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index e7b8168e8513e..78952157d401d 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -269,21 +269,14 @@ irq_gc_init_mask_cache(struct irq_chip_generic *gc, enum irq_gc_flags flags)
 }
 
 /**
- * __irq_alloc_domain_generic_chips - Allocate generic chips for an irq domain
- * @d:			irq domain for which to allocate chips
- * @irqs_per_chip:	Number of interrupts each chip handles (max 32)
- * @num_ct:		Number of irq_chip_type instances associated with this
- * @name:		Name of the irq chip
- * @handler:		Default flow handler associated with these chips
- * @clr:		IRQ_* bits to clear in the mapping function
- * @set:		IRQ_* bits to set in the mapping function
- * @gcflags:		Generic chip specific setup flags
+ * irq_domain_alloc_generic_chips - Allocate generic chips for an irq domain
+ * @d:		irq domain for which to allocate chips
+ * @info:	Generic chip information
+ *
+ * Return: 0 on success, negative error code on failure
  */
-int __irq_alloc_domain_generic_chips(struct irq_domain *d, int irqs_per_chip,
-				     int num_ct, const char *name,
-				     irq_flow_handler_t handler,
-				     unsigned int clr, unsigned int set,
-				     enum irq_gc_flags gcflags)
+int irq_domain_alloc_generic_chips(struct irq_domain *d,
+				   const struct irq_domain_chip_generic_info *info)
 {
 	struct irq_domain_chip_generic *dgc;
 	struct irq_chip_generic *gc;
@@ -297,23 +290,23 @@ int __irq_alloc_domain_generic_chips(struct irq_domain *d, int irqs_per_chip,
 	if (d->gc)
 		return -EBUSY;
 
-	numchips = DIV_ROUND_UP(d->revmap_size, irqs_per_chip);
+	numchips = DIV_ROUND_UP(d->revmap_size, info->irqs_per_chip);
 	if (!numchips)
 		return -EINVAL;
 
 	/* Allocate a pointer, generic chip and chiptypes for each chip */
-	gc_sz = struct_size(gc, chip_types, num_ct);
+	gc_sz = struct_size(gc, chip_types, info->num_ct);
 	dgc_sz = struct_size(dgc, gc, numchips);
 	sz = dgc_sz + numchips * gc_sz;
 
 	tmp = dgc = kzalloc(sz, GFP_KERNEL);
 	if (!dgc)
 		return -ENOMEM;
-	dgc->irqs_per_chip = irqs_per_chip;
+	dgc->irqs_per_chip = info->irqs_per_chip;
 	dgc->num_chips = numchips;
-	dgc->irq_flags_to_set = set;
-	dgc->irq_flags_to_clear = clr;
-	dgc->gc_flags = gcflags;
+	dgc->irq_flags_to_set = info->irq_flags_to_set;
+	dgc->irq_flags_to_clear = info->irq_flags_to_clear;
+	dgc->gc_flags = info->gc_flags;
 	d->gc = dgc;
 
 	/* Calc pointer to the first generic chip */
@@ -321,11 +314,12 @@ int __irq_alloc_domain_generic_chips(struct irq_domain *d, int irqs_per_chip,
 	for (i = 0; i < numchips; i++) {
 		/* Store the pointer to the generic chip */
 		dgc->gc[i] = gc = tmp;
-		irq_init_generic_chip(gc, name, num_ct, i * irqs_per_chip,
-				      NULL, handler);
+		irq_init_generic_chip(gc, info->name, info->num_ct,
+				      i * dgc->irqs_per_chip, NULL,
+				      info->handler);
 
 		gc->domain = d;
-		if (gcflags & IRQ_GC_BE_IO) {
+		if (dgc->gc_flags & IRQ_GC_BE_IO) {
 			gc->reg_readl = &irq_readl_be;
 			gc->reg_writel = &irq_writel_be;
 		}
@@ -338,6 +332,57 @@ int __irq_alloc_domain_generic_chips(struct irq_domain *d, int irqs_per_chip,
 	}
 	return 0;
 }
+EXPORT_SYMBOL_GPL(irq_domain_alloc_generic_chips);
+
+/**
+ * irq_domain_remove_generic_chips - Remove generic chips from an irq domain
+ * @d: irq domain for which generic chips are to be removed
+ */
+void irq_domain_remove_generic_chips(struct irq_domain *d)
+{
+	struct irq_domain_chip_generic *dgc = d->gc;
+	unsigned int i;
+
+	if (!dgc)
+		return;
+
+	for (i = 0; i < dgc->num_chips; i++)
+		irq_remove_generic_chip(dgc->gc[i], ~0U, 0, 0);
+
+	d->gc = NULL;
+	kfree(dgc);
+}
+EXPORT_SYMBOL_GPL(irq_domain_remove_generic_chips);
+
+/**
+ * __irq_alloc_domain_generic_chips - Allocate generic chips for an irq domain
+ * @d:			irq domain for which to allocate chips
+ * @irqs_per_chip:	Number of interrupts each chip handles (max 32)
+ * @num_ct:		Number of irq_chip_type instances associated with this
+ * @name:		Name of the irq chip
+ * @handler:		Default flow handler associated with these chips
+ * @clr:		IRQ_* bits to clear in the mapping function
+ * @set:		IRQ_* bits to set in the mapping function
+ * @gcflags:		Generic chip specific setup flags
+ */
+int __irq_alloc_domain_generic_chips(struct irq_domain *d, int irqs_per_chip,
+				     int num_ct, const char *name,
+				     irq_flow_handler_t handler,
+				     unsigned int clr, unsigned int set,
+				     enum irq_gc_flags gcflags)
+{
+	struct irq_domain_chip_generic_info info = {
+		.irqs_per_chip		= irqs_per_chip,
+		.num_ct			= num_ct,
+		.name			= name,
+		.handler		= handler,
+		.irq_flags_to_clear	= clr,
+		.irq_flags_to_set	= set,
+		.gc_flags		= gcflags,
+	};
+
+	return irq_domain_alloc_generic_chips(d, &info);
+}
 EXPORT_SYMBOL_GPL(__irq_alloc_domain_generic_chips);
 
 static struct irq_chip_generic *
-- 
2.53.0



