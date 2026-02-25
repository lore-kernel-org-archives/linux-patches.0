Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FD94369A;
	Wed, 25 Feb 2026 01:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982953; cv=none; b=lfkrxleq3m4ODyLv8O5RlgetLuq8syeZO27dFiO/0OBlvbJ4Jri8zQW/4X/0y0HGBzxlDCDiZER2nUJ6AC9fFwRAS/ffJR/+uNj15DOF3OJAR0gTpgmOaL8W0kg00lIH/Rp3cTqXRD/7u690kus60+0tHpJTkLuGuWqyY15cCUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982953; c=relaxed/simple;
	bh=4UCDv8P6V4yIP2O3lOWQwYLeBxto56dC2wD+JCnWR3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6UZiuLxxYUMaz77zwbHEm+uOeUMDgx7I7tUGq+NZzdeap9ge0CjZooEPcGaldf49vjsOd064Cu9gSYP3Trz2MeKTxLQFEh/nQzgRmQI11Ss3aNONaeZhNHeWwWa917w9/nkngDs+fLW1Mm/bCPGT9GgJ451syyh1z64T4/mMxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KWuUc0cy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KWuUc0cy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4AE0C116D0;
	Wed, 25 Feb 2026 01:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982953;
	bh=4UCDv8P6V4yIP2O3lOWQwYLeBxto56dC2wD+JCnWR3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWuUc0cyS5AS/oR7hHtIrPzQYbO5agVqj4QUvjt6wJR5LyUYFKdIpgOeu8seQ5UYX
	 P2tmIbpFg+KE6VDzAz9ixjssyHQFInj5rSaT40mbHp8DV/svyG0H7y1N9okuUhtMQe
	 FEk8UyiGfyY/LCoNEoCqDrtIzuvNf3eC+SekBtus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangyu Chen <cyy@cyyself.name>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 131/781] irqchip/sifive-plic: Handle number of hardware interrupts correctly
Date: Tue, 24 Feb 2026 17:14:00 -0800
Message-ID: <20260225012402.883064071@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@kernel.org>

[ Upstream commit 42e025b719c128bdf8ff88584589a1e4a2448c81 ]

The driver is handling the number of hardware interrupts inconsistently.

The reason is that the firmware enumerates the maximum number of device
interrupts, but the actual number of hardware interrupts is one more
because hardware interrupt 0 is reserved.

There are two loop variants where this matters:

  1) Iterating over the device interrupts

     for (irq = 1; irq < total_irqs; irq++)

  2) Iterating over the number of interrupt register groups

     for (grp = 0; grp < irq_groups; grp++)

The current code stores the number of device interrupts and that requires
to write the loops as:

  1) for (irq = 1; irq <= device_irqs; irq++)

  2) for (grp = 0; grp < DIV_ROUND_UP(device_irqs + 1); grp++)

But the code gets it wrong all over the place. Just fixing up the
conditions and off by ones is not a sustainable solution as the next changes
will reintroduce the same bugs over and over.

Sanitize it by storing the total number of hardware interrupts during probe
and precalculating the number of groups. To future proof it mark
priv::total_irqs __private, provide a correct iterator macro and adjust the
code to this.

Marking it private allows sparse (C=1 build) to catch direct access to this
member:

  drivers/irqchip/irq-sifive-plic.c:270:9: warning: dereference of noderef expression

That should prevent at least the most obvious future damage in that area.

Fixes: e80f0b6a2cf3 ("irqchip/irq-sifive-plic: Add syscore callbacks for hibernation")
Reported-by: Yangyu Chen <cyy@cyyself.name>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Tested-by: Yangyu Chen <cyy@cyyself.name>
Link: https://patch.msgid.link/87ikcd36i9.ffs@tglx
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-sifive-plic.c | 82 +++++++++++++++++--------------
 1 file changed, 45 insertions(+), 37 deletions(-)

diff --git a/drivers/irqchip/irq-sifive-plic.c b/drivers/irqchip/irq-sifive-plic.c
index 210a579596377..60fd8f91762b1 100644
--- a/drivers/irqchip/irq-sifive-plic.c
+++ b/drivers/irqchip/irq-sifive-plic.c
@@ -68,15 +68,17 @@
 #define PLIC_QUIRK_CP100_CLAIM_REGISTER_ERRATUM	1
 
 struct plic_priv {
-	struct fwnode_handle *fwnode;
-	struct cpumask lmask;
-	struct irq_domain *irqdomain;
-	void __iomem *regs;
-	unsigned long plic_quirks;
-	unsigned int nr_irqs;
-	unsigned long *prio_save;
-	u32 gsi_base;
-	int acpi_plic_id;
+	struct fwnode_handle	*fwnode;
+	struct cpumask		lmask;
+	struct irq_domain	*irqdomain;
+	void __iomem		*regs;
+	unsigned long		plic_quirks;
+	/* device interrupts + 1 to compensate for the reserved hwirq 0 */
+	unsigned int __private	total_irqs;
+	unsigned int		irq_groups;
+	unsigned long		*prio_save;
+	u32			gsi_base;
+	int			acpi_plic_id;
 };
 
 struct plic_handler {
@@ -91,6 +93,12 @@ struct plic_handler {
 	u32			*enable_save;
 	struct plic_priv	*priv;
 };
+
+/*
+ * Macro to deal with the insanity of hardware interrupt 0 being reserved */
+#define for_each_device_irq(iter, priv)	\
+	for (unsigned int iter = 1; iter < ACCESS_PRIVATE(priv, total_irqs); iter++)
+
 static int plic_parent_irq __ro_after_init;
 static bool plic_global_setup_done __ro_after_init;
 static DEFINE_PER_CPU(struct plic_handler, plic_handlers);
@@ -257,14 +265,11 @@ static int plic_irq_set_type(struct irq_data *d, unsigned int type)
 
 static int plic_irq_suspend(void *data)
 {
-	struct plic_priv *priv;
-
-	priv = per_cpu_ptr(&plic_handlers, smp_processor_id())->priv;
+	struct plic_priv *priv = this_cpu_ptr(&plic_handlers)->priv;
 
-	/* irq ID 0 is reserved */
-	for (unsigned int i = 1; i < priv->nr_irqs; i++) {
-		__assign_bit(i, priv->prio_save,
-			     readl(priv->regs + PRIORITY_BASE + i * PRIORITY_PER_ID));
+	for_each_device_irq(irq, priv) {
+		__assign_bit(irq, priv->prio_save,
+			     readl(priv->regs + PRIORITY_BASE + irq * PRIORITY_PER_ID));
 	}
 
 	return 0;
@@ -272,18 +277,15 @@ static int plic_irq_suspend(void *data)
 
 static void plic_irq_resume(void *data)
 {
-	unsigned int i, index, cpu;
+	struct plic_priv *priv = this_cpu_ptr(&plic_handlers)->priv;
+	unsigned int index, cpu;
 	unsigned long flags;
 	u32 __iomem *reg;
-	struct plic_priv *priv;
-
-	priv = per_cpu_ptr(&plic_handlers, smp_processor_id())->priv;
 
-	/* irq ID 0 is reserved */
-	for (i = 1; i < priv->nr_irqs; i++) {
-		index = BIT_WORD(i);
-		writel((priv->prio_save[index] & BIT_MASK(i)) ? 1 : 0,
-		       priv->regs + PRIORITY_BASE + i * PRIORITY_PER_ID);
+	for_each_device_irq(irq, priv) {
+		index = BIT_WORD(irq);
+		writel((priv->prio_save[index] & BIT_MASK(irq)) ? 1 : 0,
+		       priv->regs + PRIORITY_BASE + irq * PRIORITY_PER_ID);
 	}
 
 	for_each_present_cpu(cpu) {
@@ -293,7 +295,7 @@ static void plic_irq_resume(void *data)
 			continue;
 
 		raw_spin_lock_irqsave(&handler->enable_lock, flags);
-		for (i = 0; i < DIV_ROUND_UP(priv->nr_irqs, 32); i++) {
+		for (unsigned int i = 0; i < priv->irq_groups; i++) {
 			reg = handler->enable_base + i * sizeof(u32);
 			writel(handler->enable_save[i], reg);
 		}
@@ -431,7 +433,7 @@ static u32 cp100_isolate_pending_irq(int nr_irq_groups, struct plic_handler *han
 
 static irq_hw_number_t cp100_get_hwirq(struct plic_handler *handler, void __iomem *claim)
 {
-	int nr_irq_groups = DIV_ROUND_UP(handler->priv->nr_irqs, 32);
+	int nr_irq_groups = handler->priv->irq_groups;
 	u32 __iomem *enable = handler->enable_base;
 	irq_hw_number_t hwirq = 0;
 	u32 iso_mask;
@@ -614,7 +616,6 @@ static int plic_probe(struct fwnode_handle *fwnode)
 	struct plic_handler *handler;
 	u32 nr_irqs, parent_hwirq;
 	struct plic_priv *priv;
-	irq_hw_number_t hwirq;
 	void __iomem *regs;
 	int id, context_id;
 	u32 gsi_base;
@@ -647,7 +648,16 @@ static int plic_probe(struct fwnode_handle *fwnode)
 
 	priv->fwnode = fwnode;
 	priv->plic_quirks = plic_quirks;
-	priv->nr_irqs = nr_irqs;
+	/*
+	 * The firmware provides the number of device interrupts. As
+	 * hardware interrupt 0 is reserved, the number of total interrupts
+	 * is nr_irqs + 1.
+	 */
+	nr_irqs++;
+	ACCESS_PRIVATE(priv, total_irqs) = nr_irqs;
+	/* Precalculate the number of register groups */
+	priv->irq_groups = DIV_ROUND_UP(nr_irqs, 32);
+
 	priv->regs = regs;
 	priv->gsi_base = gsi_base;
 	priv->acpi_plic_id = id;
@@ -686,7 +696,7 @@ static int plic_probe(struct fwnode_handle *fwnode)
 				u32 __iomem *enable_base = priv->regs +	CONTEXT_ENABLE_BASE +
 							   i * CONTEXT_ENABLE_SIZE;
 
-				for (int j = 0; j <= nr_irqs / 32; j++)
+				for (int j = 0; j < priv->irq_groups; j++)
 					writel(0, enable_base + j);
 			}
 			continue;
@@ -718,23 +728,21 @@ static int plic_probe(struct fwnode_handle *fwnode)
 			context_id * CONTEXT_ENABLE_SIZE;
 		handler->priv = priv;
 
-		handler->enable_save = kcalloc(DIV_ROUND_UP(nr_irqs, 32),
-					       sizeof(*handler->enable_save), GFP_KERNEL);
+		handler->enable_save = kcalloc(priv->irq_groups, sizeof(*handler->enable_save),
+					       GFP_KERNEL);
 		if (!handler->enable_save) {
 			error = -ENOMEM;
 			goto fail_cleanup_contexts;
 		}
 done:
-		for (hwirq = 1; hwirq <= nr_irqs; hwirq++) {
+		for_each_device_irq(hwirq, priv) {
 			plic_toggle(handler, hwirq, 0);
-			writel(1, priv->regs + PRIORITY_BASE +
-				  hwirq * PRIORITY_PER_ID);
+			writel(1, priv->regs + PRIORITY_BASE + hwirq * PRIORITY_PER_ID);
 		}
 		nr_handlers++;
 	}
 
-	priv->irqdomain = irq_domain_create_linear(fwnode, nr_irqs + 1,
-						   &plic_irqdomain_ops, priv);
+	priv->irqdomain = irq_domain_create_linear(fwnode, nr_irqs, &plic_irqdomain_ops, priv);
 	if (WARN_ON(!priv->irqdomain)) {
 		error = -ENOMEM;
 		goto fail_cleanup_contexts;
-- 
2.51.0



