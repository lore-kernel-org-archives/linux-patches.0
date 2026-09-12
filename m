Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9BF4BEE32;
	Sat, 12 Sep 2026 11:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211889; cv=none; b=lObSLRO1xJFtVet0X2rPTZuX96MUfPOnVMf1JqjE8sfShztUTdo5aCIeTuInakERn9+CTnJbAKZ5OOoH40Gn41RIAlqwNIAw6LkYvvnVCpdJ/ZmvnfEL5HEJ12AFXvguqLatZ3w6LGvN1TLGH99/F3jP72NKL4KcfIDcr1kmzGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211889; c=relaxed/simple;
	bh=oHvur0hZbbpc2Upx+toqEpQZQUgsVp9eg1gtpvwXewo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2FxebfL/swg2shFQdMl6k5GwXlB7kanbhfn59tZe2d3fy8vdbRz89YazXiTcBkiWlf7L4m+rhqh/ORQHizcXo58qYFB6POFflTLK44Ff6VSaK3hukEbYg1CNUsujaDGpFzl5MJUYEtgYtrebYuzfC5wTlLISHT3nrg3eI3nlT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TE3cRD/f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TE3cRD/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44BA1F000FF;
	Sat, 12 Sep 2026 11:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211888;
	bh=p/VnrsK7K1b2DD/OAtSsseNmmmDqZR6PFKZo9MMpGI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TE3cRD/fCTd1GLgiSSl996mVldCk41215FYgK3sdHEbefbdn3zpBAh3De+5H2aFyi
	 ZtoK5s6gsXcCcEQE/eINEnRkufelrkYXbz/w9E+Zc3a/+fnjfF6j7EZSxhGieBSDYu
	 OyptcqNlVZ99RZME9wfJ3633KlTqDp/XrhWjEzQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Stockhausen <markus.stockhausen@gmx.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1323/1518] irqchip/irq-realtek-rtl: Add/simplify register helpers
Date: Sat, 12 Sep 2026 08:58:12 +0200
Message-ID: <20260912065653.458200461@linuxfoundation.org>
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

[ Upstream commit 167883f75f83088a2b32c85ce5e3d0cd1cef157b ]

The Realtek interrupt controller has two important registers that are used
by the driver in several places

 - GIMR: global interrupt mask register
 - IRR: Interrupt routing registers

The usage of these registers is very inconsistent. GIMR is addressed
directly while IRR has a helper that needs a macro as an input. Harmonize
this by providing consistent helpers that improve code readability.

The callers of these helpers use classic lock/unlock functions and
sometimes use the wrong locking helper. E.g. irqsave variants are used in
mask/unmask although not needed. Adapt and fix the surrounding call
locations.

Signed-off-by: Markus Stockhausen <markus.stockhausen@gmx.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260604182506.1113440-2-markus.stockhausen@gmx.de
Stable-dep-of: 58b34b72b64b ("irqchip/irq-realtek-rtl: Use readl_be()/writel_be() instead of readl()/writel()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-realtek-rtl.c | 64 +++++++++++++++----------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/irqchip/irq-realtek-rtl.c b/drivers/irqchip/irq-realtek-rtl.c
index 942c1f8c363d7..f490fb867deda 100644
--- a/drivers/irqchip/irq-realtek-rtl.c
+++ b/drivers/irqchip/irq-realtek-rtl.c
@@ -37,10 +37,29 @@ static void __iomem *realtek_ictl_base;
 #define IRR_OFFSET(idx)		(4 * (3 - (idx * 4) / 32))
 #define IRR_SHIFT(idx)		((idx * 4) % 32)
 
-static void write_irr(void __iomem *irr0, int idx, u32 value)
+static inline void enable_gimr(unsigned int hw_irq)
 {
-	unsigned int offset = IRR_OFFSET(idx);
-	unsigned int shift = IRR_SHIFT(idx);
+	u32 gimr;
+
+	gimr = readl(REG(RTL_ICTL_GIMR));
+	gimr |= BIT(hw_irq);
+	writel(gimr, REG(RTL_ICTL_GIMR));
+}
+
+static inline void disable_gimr(unsigned int hw_irq)
+{
+	u32 gimr;
+
+	gimr = readl(REG(RTL_ICTL_GIMR));
+	gimr &= ~BIT(hw_irq);
+	writel(gimr, REG(RTL_ICTL_GIMR));
+}
+
+static void write_irr(int hw_irq, u32 value)
+{
+	void __iomem *irr0 = REG(RTL_ICTL_IRR0);
+	unsigned int offset = IRR_OFFSET(hw_irq);
+	unsigned int shift = IRR_SHIFT(hw_irq);
 	u32 irr;
 
 	irr = readl(irr0 + offset) & ~(0xf << shift);
@@ -50,30 +69,14 @@ static void write_irr(void __iomem *irr0, int idx, u32 value)
 
 static void realtek_ictl_unmask_irq(struct irq_data *i)
 {
-	unsigned long flags;
-	u32 value;
-
-	raw_spin_lock_irqsave(&irq_lock, flags);
-
-	value = readl(REG(RTL_ICTL_GIMR));
-	value |= BIT(i->hwirq);
-	writel(value, REG(RTL_ICTL_GIMR));
-
-	raw_spin_unlock_irqrestore(&irq_lock, flags);
+	guard(raw_spinlock)(&irq_lock);
+	enable_gimr(i->hwirq);
 }
 
 static void realtek_ictl_mask_irq(struct irq_data *i)
 {
-	unsigned long flags;
-	u32 value;
-
-	raw_spin_lock_irqsave(&irq_lock, flags);
-
-	value = readl(REG(RTL_ICTL_GIMR));
-	value &= ~BIT(i->hwirq);
-	writel(value, REG(RTL_ICTL_GIMR));
-
-	raw_spin_unlock_irqrestore(&irq_lock, flags);
+	guard(raw_spinlock)(&irq_lock);
+	disable_gimr(i->hwirq);
 }
 
 static struct irq_chip realtek_ictl_irq = {
@@ -84,13 +87,10 @@ static struct irq_chip realtek_ictl_irq = {
 
 static int intc_map(struct irq_domain *d, unsigned int irq, irq_hw_number_t hw)
 {
-	unsigned long flags;
-
 	irq_set_chip_and_handler(irq, &realtek_ictl_irq, handle_level_irq);
 
-	raw_spin_lock_irqsave(&irq_lock, flags);
-	write_irr(REG(RTL_ICTL_IRR0), hw, 1);
-	raw_spin_unlock_irqrestore(&irq_lock, flags);
+	guard(raw_spinlock_irqsave)(&irq_lock);
+	write_irr(hw, 1);
 
 	return 0;
 }
@@ -127,7 +127,6 @@ static int __init realtek_rtl_of_init(struct device_node *node, struct device_no
 {
 	struct of_phandle_args oirq;
 	struct irq_domain *domain;
-	unsigned int soc_irq;
 	int parent_irq;
 
 	realtek_ictl_base = of_iomap(node, 0);
@@ -135,9 +134,10 @@ static int __init realtek_rtl_of_init(struct device_node *node, struct device_no
 		return -ENXIO;
 
 	/* Disable all cascaded interrupts and clear routing */
-	writel(0, REG(RTL_ICTL_GIMR));
-	for (soc_irq = 0; soc_irq < RTL_ICTL_NUM_INPUTS; soc_irq++)
-		write_irr(REG(RTL_ICTL_IRR0), soc_irq, 0);
+	for (unsigned int hw_irq = 0; hw_irq < RTL_ICTL_NUM_INPUTS; hw_irq++) {
+		disable_gimr(hw_irq);
+		write_irr(hw_irq, 0);
+	}
 
 	if (WARN_ON(!of_irq_count(node))) {
 		/*
-- 
2.53.0



