Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED613BFAF7;
	Sat, 12 Sep 2026 09:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204680; cv=none; b=lk5mpsYEowSf37HsgTcRjuZAlaIYgVQvZ4aftkONp3NLqZtkeTkp9Kl7ajQ08VlFpDFiRU60qvWqaZECXIjVWio89Lo+45dWutxbTZRfJYElzWof/21WKbMAn7BmJ37hLwr5lyioo7ZGVouRHDxwzbo43GAeLBQMWlapyQOtfVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204680; c=relaxed/simple;
	bh=gOxHCUi9kGCnXW9tVk6wDTxouJSBTAZ4uZW6n/MQjhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PV6XV7JH4zI3a5F61sIfJD9MWWZKPZmwaHDKWXX1ds9WYp+tqAVkdMWdG9SVqIwbMq2HikeIL/gvIR76rCrr/5cZqF8qWlcycTyw0zvOi8PM4PxN2u2tmQ1HQTgihFMIq1sEhai5jArM6W+O6ALTyks+Rka/Ly0+tAB71fYMinQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Clks3bMh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Clks3bMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8314A1F000FF;
	Sat, 12 Sep 2026 09:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204678;
	bh=S+/98AqeZAgN5m5whu4z0bo1cqb09ezIgl4S+lILoTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Clks3bMhVqDFsVWEWDmod/Z+Un2ICHqRLQZkPbSy++YMwDiG3oRmIkSV984SvARFZ
	 4PeKQV8Q4y+BNvNbqtT4UeoWZkuzrKdR7uZe9ysMMrGORkYPbTI7o/wtbIrPumrVIn
	 eqa3Yao9DLV+bJlTQvRsDKFgI6NmBAf00ZSWa6nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Stockhausen <markus.stockhausen@gmx.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1663/1815] irqchip/irq-realtek-rtl: Split out parent setup code
Date: Sat, 12 Sep 2026 08:56:53 +0200
Message-ID: <20260912065728.030205039@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Stockhausen <markus.stockhausen@gmx.de>

[ Upstream commit d36c1d1657113fcf442c50e074593d7b712bada1 ]

The parent interrupt setup will be extended to support multiple parents.

To prepare for that, relocate the code into a separate helper. Although it
still works only for a single interrupt prepare the coding so it can be
easily extended with a loop for multi parent support. For this reduce the
line lengths so that the upcoming indentation still leaves the width below
100 characters.

Signed-off-by: Markus Stockhausen <markus.stockhausen@gmx.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260605211646.2101652-3-markus.stockhausen@gmx.de
Stable-dep-of: 58b34b72b64b ("irqchip/irq-realtek-rtl: Use readl_be()/writel_be() instead of readl()/writel()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-realtek-rtl.c | 60 +++++++++++++++++--------------
 1 file changed, 33 insertions(+), 27 deletions(-)

diff --git a/drivers/irqchip/irq-realtek-rtl.c b/drivers/irqchip/irq-realtek-rtl.c
index 2ae3be7fa6338..3b4508ec71982 100644
--- a/drivers/irqchip/irq-realtek-rtl.c
+++ b/drivers/irqchip/irq-realtek-rtl.c
@@ -147,48 +147,35 @@ static void realtek_irq_dispatch(struct irq_desc *desc)
 	chained_irq_exit(chip, desc);
 }
 
-static int __init realtek_rtl_of_init(struct device_node *node, struct device_node *parent)
+static int __init realtek_setup_parents(struct device_node *node)
 {
+	int parent_irq, num_parents = of_irq_count(node);
 	struct of_phandle_args oirq;
 	struct irq_domain *domain;
-	int cpu, parent_irq;
 
-	for_each_present_cpu(cpu) {
-		realtek_ictl_base[cpu] = of_iomap(node, cpu);
-		if (!realtek_ictl_base[cpu])
-			return -ENXIO;
-
-		/* Disable all cascaded interrupts and clear routing */
-		for (unsigned int hw_irq = 0; hw_irq < RTL_ICTL_NUM_INPUTS; hw_irq++) {
-			disable_gimr(cpu, hw_irq);
-			write_irr(cpu, hw_irq, 0);
-		}
-	}
-
-	if (WARN_ON(!of_irq_count(node))) {
+	if (WARN_ON(!num_parents)) {
 		/*
-		 * If DT contains no parent interrupts, assume MIPS CPU IRQ 2
-		 * (HW0) is connected to the first output. This is the case for
-		 * all known hardware anyway. "interrupt-map" is deprecated, so
-		 * don't bother trying to parse that.
+		 * If DT contains no parent interrupts, assume MIPS IRQ 2 (HW0) is
+		 * connected to the first output. This is the case for all known hardware.
 		 */
-		oirq.np = of_find_compatible_node(NULL, NULL, "mti,cpu-interrupt-controller");
+		oirq.np = of_find_compatible_node(NULL, NULL,
+						  "mti,cpu-interrupt-controller");
+		if (!oirq.np)
+			return -EINVAL;
+
 		oirq.args_count = 1;
 		oirq.args[0] = 2;
-
 		parent_irq = irq_create_of_mapping(&oirq);
-
 		of_node_put(oirq.np);
 	} else {
 		parent_irq = of_irq_get(node, 0);
 	}
 
-	if (parent_irq < 0)
-		return parent_irq;
-	else if (!parent_irq)
-		return -ENODEV;
+	if (parent_irq <= 0)
+		return parent_irq ? parent_irq : -ENODEV;
 
-	domain = irq_domain_create_linear(of_fwnode_handle(node), RTL_ICTL_NUM_INPUTS, &irq_domain_ops, NULL);
+	domain = irq_domain_create_linear(of_fwnode_handle(node), RTL_ICTL_NUM_INPUTS,
+					  &irq_domain_ops, NULL);
 	if (!domain)
 		return -ENOMEM;
 
@@ -197,4 +184,23 @@ static int __init realtek_rtl_of_init(struct device_node *node, struct device_no
 	return 0;
 }
 
+static int __init realtek_rtl_of_init(struct device_node *node, struct device_node *parent)
+{
+	unsigned int cpu;
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
+	}
+
+	return realtek_setup_parents(node);
+}
+
 IRQCHIP_DECLARE(realtek_rtl_intc, "realtek,rtl-intc", realtek_rtl_of_init);
-- 
2.53.0



