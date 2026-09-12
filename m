Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9F94BEE32;
	Sat, 12 Sep 2026 11:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211909; cv=none; b=MT/lhBZouIhClUc/alwNhA+ShlNdcRIF7HCPpQTOTtG7ITh8UDZJShwyLfbuapxgOaEVnKKzOK8ekIOsHhuyVZsWcBHbCB88tRqrSAYX19xXuB8gHfiivG/M0Hb99HO0z5wIQVenkClkRhgiGQrDKmoNWRSrj2VR2rG003aP+qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211909; c=relaxed/simple;
	bh=kR6U1/P151xld0ZFXZutCxUoSZbvfFVz4dgX5ciGpjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yrz4s4xZhU45tDMFPoZJxt0/IXdU3qHCYExI0PHnidN0L22dENho3iB/DxCKYlZsP7vQgkQA7gtWs9QUI05Dw7DSHiKV48Yttza8dyxqS7m9GJmq2R9vjP+U3rIkJkrga9PpDRnnu13HEJ+ONs2uLgJGWIis+YOdO66hXKRGUjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hx/BiR95; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hx/BiR95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 379CC1F000FF;
	Sat, 12 Sep 2026 11:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211908;
	bh=eajcuDmbZzkpPVGxpj3fQ/aznkWdneHJ854n0+AQqks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hx/BiR95gkPDnFTdiQL1H8wA5rjqM1Z3u7gXCXhfiNdDD8B/bxTJUKk+ZZJbsM1rx
	 shdREqF5vwd83xAsmWPuS7LaEzjZa0zjtsvgEsEGLWQ05nKxJjlgZ164YQgG6v9LBC
	 4/RFE1y5Xifrm8br+xytv/1ndZGhWZ3COGNSU70k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Stockhausen <markus.stockhausen@gmx.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1326/1518] irqchip/irq-realtek-rtl: Add interrupt data structure
Date: Sat, 12 Sep 2026 08:58:15 +0200
Message-ID: <20260912065653.525609792@linuxfoundation.org>
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

[ Upstream commit 2568f6926c667e0b4ecf523cb4015acefc40409a ]

To prepare for multiple parent interrupt domains add an intermediate
data structure. For now this will only host the link to the domain.
Additionally adapt a deviating variable name to driver standard "hw_irq".

Signed-off-by: Markus Stockhausen <markus.stockhausen@gmx.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260605211646.2101652-4-markus.stockhausen@gmx.de
Stable-dep-of: 58b34b72b64b ("irqchip/irq-realtek-rtl: Use readl_be()/writel_be() instead of readl()/writel()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-realtek-rtl.c | 48 ++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 14 deletions(-)

diff --git a/drivers/irqchip/irq-realtek-rtl.c b/drivers/irqchip/irq-realtek-rtl.c
index 3b4508ec71982..547f21da3edc2 100644
--- a/drivers/irqchip/irq-realtek-rtl.c
+++ b/drivers/irqchip/irq-realtek-rtl.c
@@ -25,6 +25,10 @@
 
 #define REG(cpu, x)		(realtek_ictl_base[cpu] + x)
 
+struct realtek_ictl_output {
+	struct irq_domain	*domain;
+};
+
 static DEFINE_RAW_SPINLOCK(irq_lock);
 static void __iomem *realtek_ictl_base[NR_CPUS];
 
@@ -125,11 +129,11 @@ static const struct irq_domain_ops irq_domain_ops = {
 
 static void realtek_irq_dispatch(struct irq_desc *desc)
 {
+	struct realtek_ictl_output *output = irq_desc_get_handler_data(desc);
 	struct irq_chip *chip = irq_desc_get_chip(desc);
 	unsigned int cpu = smp_processor_id();
-	struct irq_domain *domain;
 	unsigned long pending;
-	unsigned int soc_int;
+	unsigned int hw_irq;
 
 	chained_irq_enter(chip, desc);
 	pending = readl(REG(cpu, RTL_ICTL_GIMR)) & readl(REG(cpu, RTL_ICTL_GISR));
@@ -139,9 +143,8 @@ static void realtek_irq_dispatch(struct irq_desc *desc)
 		goto out;
 	}
 
-	domain = irq_desc_get_handler_data(desc);
-	for_each_set_bit(soc_int, &pending, RTL_ICTL_NUM_INPUTS)
-		generic_handle_domain_irq(domain, soc_int);
+	for_each_set_bit(hw_irq, &pending, RTL_ICTL_NUM_INPUTS)
+		generic_handle_domain_irq(output->domain, hw_irq);
 
 out:
 	chained_irq_exit(chip, desc);
@@ -149,10 +152,15 @@ static void realtek_irq_dispatch(struct irq_desc *desc)
 
 static int __init realtek_setup_parents(struct device_node *node)
 {
-	int parent_irq, num_parents = of_irq_count(node);
+	int err, parent_irq, num_parents = of_irq_count(node);
+	struct realtek_ictl_output *output;
 	struct of_phandle_args oirq;
 	struct irq_domain *domain;
 
+	output = kcalloc(1, sizeof(*output), GFP_KERNEL);
+	if (!output)
+		return -ENOMEM;
+
 	if (WARN_ON(!num_parents)) {
 		/*
 		 * If DT contains no parent interrupts, assume MIPS IRQ 2 (HW0) is
@@ -160,8 +168,10 @@ static int __init realtek_setup_parents(struct device_node *node)
 		 */
 		oirq.np = of_find_compatible_node(NULL, NULL,
 						  "mti,cpu-interrupt-controller");
-		if (!oirq.np)
-			return -EINVAL;
+		if (!oirq.np) {
+			err = -EINVAL;
+			goto err_out;
+		}
 
 		oirq.args_count = 1;
 		oirq.args[0] = 2;
@@ -171,17 +181,27 @@ static int __init realtek_setup_parents(struct device_node *node)
 		parent_irq = of_irq_get(node, 0);
 	}
 
-	if (parent_irq <= 0)
-		return parent_irq ? parent_irq : -ENODEV;
+	if (parent_irq <= 0) {
+		err = parent_irq ? parent_irq : -ENODEV;
+		goto err_out;
+	}
 
 	domain = irq_domain_create_linear(of_fwnode_handle(node), RTL_ICTL_NUM_INPUTS,
-					  &irq_domain_ops, NULL);
-	if (!domain)
-		return -ENOMEM;
+					  &irq_domain_ops, output);
+	if (!domain) {
+		err = -ENOMEM;
+		goto err_out;
+	}
 
-	irq_set_chained_handler_and_data(parent_irq, realtek_irq_dispatch, domain);
+	output->domain = domain;
+	irq_set_chained_handler_and_data(parent_irq, realtek_irq_dispatch, output);
 
 	return 0;
+
+err_out:
+	kfree(output);
+
+	return err;
 }
 
 static int __init realtek_rtl_of_init(struct device_node *node, struct device_node *parent)
-- 
2.53.0



