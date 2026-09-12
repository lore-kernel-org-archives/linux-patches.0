Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2F04BEE32;
	Sat, 12 Sep 2026 11:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211899; cv=none; b=bRZQPdqIL0mVzd+f5idORS6FnYPV64thJ8rZNMpEgQPOdXOVFs8jpmoQWbS+LOTmCgYeecEIeS4Cw+3Cg7+InFXVGdXCd8dwOlvRcKrws0SwDofyRPskUwSI4U9kjOmH3s8jTjrSgokbv/KRZtvCMzDFnvs5a3rL4wP2SeSBEg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211899; c=relaxed/simple;
	bh=goN9JVxS94TxQSRhv6oym0QQwf2qxU1nTmLALNix7tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dC50ToPLbTWWA/7+EIjeExGCwQqnCX27qRYv21DDz7Zf5gynwe/qBxYl9euT01JciWspa6jzBe0PGUDhBM8+CyRLnB9Rp7ZN8S+d3Kbv9FbHC6cl3Vj0iMU5IQnkqZOlG2ydVmft8T2BtU8WEvrXgl6JKsgr/h+oQ030aXvVMyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A2h0fjE/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A2h0fjE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2CF1F000FF;
	Sat, 12 Sep 2026 11:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211898;
	bh=7EivjyFnXcdUu+W59A4tKs5DyqOMmPNowICNpc5PCyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A2h0fjE/llj2qES+xSXa2GzzHsjlGlwwuircyKlxOy94NFC+EfTMhkIJts6NvVTno
	 gv32iJkNQP71sGHcjgUu0JDw+3N56vDfUpYoKMsT+5ZHaNuOcEWSA/YHkoovizJLPW
	 uoVcwq/hT60Wm3AkMlmQhGiFjbRMP1aqeu4lYUe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Stockhausen <markus.stockhausen@gmx.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1324/1518] irqchip/irq-realtek-rtl: Add multicore support
Date: Sat, 12 Sep 2026 08:58:13 +0200
Message-ID: <20260912065653.480677840@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Markus Stockhausen <markus.stockhausen@gmx.de>

[ Upstream commit a1a35c09241f0577cc40f65d7372fed01138619d ]

The Realtek interrupt driver currently supports only single core
systems. So the higher end devices like RTL839x and RTL930x with
dual VPEs must be driven with NR_CPU=1. Enhance the driver to
support multicore (dual VPE) systems. For this:

  - Extend the register map for multiple cores
  - Search for multiple CPU cores in the devicetree
  - Improve the register helpers to support multiple cores
  - Add an affinity setter
  - Enhance the IRQ handler for multiple cores

Signed-off-by: Markus Stockhausen <markus.stockhausen@gmx.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260604182506.1113440-3-markus.stockhausen@gmx.de
Stable-dep-of: 58b34b72b64b ("irqchip/irq-realtek-rtl: Use readl_be()/writel_be() instead of readl()/writel()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-realtek-rtl.c | 82 ++++++++++++++++++++-----------
 1 file changed, 54 insertions(+), 28 deletions(-)

diff --git a/drivers/irqchip/irq-realtek-rtl.c b/drivers/irqchip/irq-realtek-rtl.c
index f490fb867deda..2ae3be7fa6338 100644
--- a/drivers/irqchip/irq-realtek-rtl.c
+++ b/drivers/irqchip/irq-realtek-rtl.c
@@ -23,10 +23,10 @@
 
 #define RTL_ICTL_NUM_INPUTS	32
 
-#define REG(x)		(realtek_ictl_base + x)
+#define REG(cpu, x)		(realtek_ictl_base[cpu] + x)
 
 static DEFINE_RAW_SPINLOCK(irq_lock);
-static void __iomem *realtek_ictl_base;
+static void __iomem *realtek_ictl_base[NR_CPUS];
 
 /*
  * IRR0-IRR3 store 4 bits per interrupt, but Realtek uses inverted numbering,
@@ -37,27 +37,27 @@ static void __iomem *realtek_ictl_base;
 #define IRR_OFFSET(idx)		(4 * (3 - (idx * 4) / 32))
 #define IRR_SHIFT(idx)		((idx * 4) % 32)
 
-static inline void enable_gimr(unsigned int hw_irq)
+static inline void enable_gimr(unsigned int cpu, unsigned int hw_irq)
 {
 	u32 gimr;
 
-	gimr = readl(REG(RTL_ICTL_GIMR));
+	gimr = readl(REG(cpu, RTL_ICTL_GIMR));
 	gimr |= BIT(hw_irq);
-	writel(gimr, REG(RTL_ICTL_GIMR));
+	writel(gimr, REG(cpu, RTL_ICTL_GIMR));
 }
 
-static inline void disable_gimr(unsigned int hw_irq)
+static inline void disable_gimr(unsigned int cpu, unsigned int hw_irq)
 {
 	u32 gimr;
 
-	gimr = readl(REG(RTL_ICTL_GIMR));
+	gimr = readl(REG(cpu, RTL_ICTL_GIMR));
 	gimr &= ~BIT(hw_irq);
-	writel(gimr, REG(RTL_ICTL_GIMR));
+	writel(gimr, REG(cpu, RTL_ICTL_GIMR));
 }
 
-static void write_irr(int hw_irq, u32 value)
+static void write_irr(unsigned int cpu, int hw_irq, u32 value)
 {
-	void __iomem *irr0 = REG(RTL_ICTL_IRR0);
+	void __iomem *irr0 = REG(cpu, RTL_ICTL_IRR0);
 	unsigned int offset = IRR_OFFSET(hw_irq);
 	unsigned int shift = IRR_SHIFT(hw_irq);
 	u32 irr;
@@ -69,28 +69,51 @@ static void write_irr(int hw_irq, u32 value)
 
 static void realtek_ictl_unmask_irq(struct irq_data *i)
 {
+	unsigned int cpu;
+
 	guard(raw_spinlock)(&irq_lock);
-	enable_gimr(i->hwirq);
+	for_each_cpu(cpu, irq_data_get_effective_affinity_mask(i))
+		enable_gimr(cpu, i->hwirq);
 }
 
 static void realtek_ictl_mask_irq(struct irq_data *i)
 {
+	unsigned int cpu;
+
 	guard(raw_spinlock)(&irq_lock);
-	disable_gimr(i->hwirq);
+	for_each_cpu(cpu, irq_data_get_effective_affinity_mask(i))
+		disable_gimr(cpu, i->hwirq);
+}
+
+static int realtek_ictl_irq_affinity(struct irq_data *i, const struct cpumask *dest, bool force)
+{
+	if (!irqd_irq_masked(i))
+		realtek_ictl_mask_irq(i);
+
+	irq_data_update_effective_affinity(i, dest);
+
+	if (!irqd_irq_masked(i))
+		realtek_ictl_unmask_irq(i);
+
+	return IRQ_SET_MASK_OK;
 }
 
 static struct irq_chip realtek_ictl_irq = {
-	.name = "realtek-rtl-intc",
-	.irq_mask = realtek_ictl_mask_irq,
-	.irq_unmask = realtek_ictl_unmask_irq,
+	.name			= "realtek-rtl-intc",
+	.irq_mask		= realtek_ictl_mask_irq,
+	.irq_unmask		= realtek_ictl_unmask_irq,
+	.irq_set_affinity	= realtek_ictl_irq_affinity,
 };
 
 static int intc_map(struct irq_domain *d, unsigned int irq, irq_hw_number_t hw)
 {
+	unsigned int cpu;
+
 	irq_set_chip_and_handler(irq, &realtek_ictl_irq, handle_level_irq);
 
 	guard(raw_spinlock_irqsave)(&irq_lock);
-	write_irr(hw, 1);
+	for_each_present_cpu(cpu)
+		write_irr(cpu, hw, 1);
 
 	return 0;
 }
@@ -103,12 +126,13 @@ static const struct irq_domain_ops irq_domain_ops = {
 static void realtek_irq_dispatch(struct irq_desc *desc)
 {
 	struct irq_chip *chip = irq_desc_get_chip(desc);
+	unsigned int cpu = smp_processor_id();
 	struct irq_domain *domain;
 	unsigned long pending;
 	unsigned int soc_int;
 
 	chained_irq_enter(chip, desc);
-	pending = readl(REG(RTL_ICTL_GIMR)) & readl(REG(RTL_ICTL_GISR));
+	pending = readl(REG(cpu, RTL_ICTL_GIMR)) & readl(REG(cpu, RTL_ICTL_GISR));
 
 	if (unlikely(!pending)) {
 		spurious_interrupt();
@@ -116,7 +140,7 @@ static void realtek_irq_dispatch(struct irq_desc *desc)
 	}
 
 	domain = irq_desc_get_handler_data(desc);
-	for_each_set_bit(soc_int, &pending, 32)
+	for_each_set_bit(soc_int, &pending, RTL_ICTL_NUM_INPUTS)
 		generic_handle_domain_irq(domain, soc_int);
 
 out:
@@ -127,16 +151,18 @@ static int __init realtek_rtl_of_init(struct device_node *node, struct device_no
 {
 	struct of_phandle_args oirq;
 	struct irq_domain *domain;
-	int parent_irq;
-
-	realtek_ictl_base = of_iomap(node, 0);
-	if (!realtek_ictl_base)
-		return -ENXIO;
-
-	/* Disable all cascaded interrupts and clear routing */
-	for (unsigned int hw_irq = 0; hw_irq < RTL_ICTL_NUM_INPUTS; hw_irq++) {
-		disable_gimr(hw_irq);
-		write_irr(hw_irq, 0);
+	int cpu, parent_irq;
+
+	for_each_present_cpu(cpu) {
+		realtek_ictl_base[cpu] = of_iomap(node, cpu);
+		if (!realtek_ictl_base[cpu])
+			return -ENXIO;
+
+		/* Disable all cascaded interrupts and clear routing */
+		for (unsigned int hw_irq = 0; hw_irq < RTL_ICTL_NUM_INPUTS; hw_irq++) {
+			disable_gimr(cpu, hw_irq);
+			write_irr(cpu, hw_irq, 0);
+		}
 	}
 
 	if (WARN_ON(!of_irq_count(node))) {
-- 
2.53.0



