Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0101304AD;
	Wed, 19 Jun 2024 13:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802069; cv=none; b=MBZEQM9Qrz+fv2czF9I9ChBzEI5cov6DwCq85FpJuV5Fln+g2wM39SsjH7774wJGhfYF0hfNwO5dGhX98b87FMF9T4iaozWaxfVGRHDuVRH2dVQVVX1jYY1tdRS9BgwonwTJK8A1dT3EuifYU8zWMkht8b5vrqyThfbYVFEwR8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802069; c=relaxed/simple;
	bh=+EjE2tPMHHhuoiB5txqcnd0A6YG7CbaBjf8DL+4g6BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QdFVByc5+xnFoozS9l6sZJIzdc00CeJR3idKrxgjVTDqOz31mz09K618nY+8718e9CtpG/96EojH2z9Y3w7ASfqUWzBI0SveQsq8Jpz4yqAr57r+vqK42ZhZc9vsYMfpQjAJ0W/ryqzVx6RRzcWs6TiFQFpB2W272Cgjoo3pk7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mJCZLLwk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mJCZLLwk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61DCC2BBFC;
	Wed, 19 Jun 2024 13:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802069;
	bh=+EjE2tPMHHhuoiB5txqcnd0A6YG7CbaBjf8DL+4g6BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mJCZLLwk0JFdYa6trI+aYAsWIOlhkumRJLkOVNSepcBOwqlCBUysWmsev5FK6m3Hh
	 OeGZSxnoixR+d+0QE68tJCYZkRy6iCuHzFyqfY0PL8QQ3pdoRnw2w2AGV2gx2t2+oM
	 V2kRIDvmwO85bkARgISNGpCGXBCTPSAG9RT5zk6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Chien Peter Lin <peterlin@andestech.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Randolph <randolph@andestech.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/267] irqchip/riscv-intc: Allow large non-standard interrupt number
Date: Wed, 19 Jun 2024 14:53:42 +0200
Message-ID: <20240619125609.081985755@linuxfoundation.org>
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

[ Upstream commit 96303bcb401c21dc1426d8d9bb1fc74aae5c02a9 ]

Currently, the implementation of the RISC-V INTC driver uses the
interrupt cause as the hardware interrupt number, with a maximum of
64 interrupts. However, the platform can expand the interrupt number
further for custom local interrupts.

To fully utilize the available local interrupt sources, switch
to using irq_domain_create_tree() that creates the radix tree
map, add global variables (riscv_intc_nr_irqs, riscv_intc_custom_base
and riscv_intc_custom_nr_irqs) to determine the valid range of local
interrupt number (hwirq).

Signed-off-by: Yu Chien Peter Lin <peterlin@andestech.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Randolph <randolph@andestech.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Link: https://lore.kernel.org/r/20240222083946.3977135-3-peterlin@andestech.com
Stable-dep-of: 0110c4b11047 ("irqchip/riscv-intc: Prevent memory leak when riscv_intc_init_common() fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-riscv-intc.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/irqchip/irq-riscv-intc.c b/drivers/irqchip/irq-riscv-intc.c
index e8d01b14ccdde..684875c397280 100644
--- a/drivers/irqchip/irq-riscv-intc.c
+++ b/drivers/irqchip/irq-riscv-intc.c
@@ -19,15 +19,16 @@
 #include <linux/smp.h>
 
 static struct irq_domain *intc_domain;
+static unsigned int riscv_intc_nr_irqs __ro_after_init = BITS_PER_LONG;
+static unsigned int riscv_intc_custom_base __ro_after_init = BITS_PER_LONG;
+static unsigned int riscv_intc_custom_nr_irqs __ro_after_init;
 
 static asmlinkage void riscv_intc_irq(struct pt_regs *regs)
 {
 	unsigned long cause = regs->cause & ~CAUSE_IRQ_FLAG;
 
-	if (unlikely(cause >= BITS_PER_LONG))
-		panic("unexpected interrupt cause");
-
-	generic_handle_domain_irq(intc_domain, cause);
+	if (generic_handle_domain_irq(intc_domain, cause))
+		pr_warn_ratelimited("Failed to handle interrupt (cause: %ld)\n", cause);
 }
 
 /*
@@ -93,6 +94,14 @@ static int riscv_intc_domain_alloc(struct irq_domain *domain,
 	if (ret)
 		return ret;
 
+	/*
+	 * Only allow hwirq for which we have corresponding standard or
+	 * custom interrupt enable register.
+	 */
+	if ((hwirq >= riscv_intc_nr_irqs && hwirq < riscv_intc_custom_base) ||
+	    (hwirq >= riscv_intc_custom_base + riscv_intc_custom_nr_irqs))
+		return -EINVAL;
+
 	for (i = 0; i < nr_irqs; i++) {
 		ret = riscv_intc_domain_map(domain, virq + i, hwirq + i);
 		if (ret)
@@ -117,8 +126,7 @@ static int __init riscv_intc_init_common(struct fwnode_handle *fn)
 {
 	int rc;
 
-	intc_domain = irq_domain_create_linear(fn, BITS_PER_LONG,
-					       &riscv_intc_domain_ops, NULL);
+	intc_domain = irq_domain_create_tree(fn, &riscv_intc_domain_ops, NULL);
 	if (!intc_domain) {
 		pr_err("unable to add IRQ domain\n");
 		return -ENXIO;
@@ -132,7 +140,11 @@ static int __init riscv_intc_init_common(struct fwnode_handle *fn)
 
 	riscv_set_intc_hwnode_fn(riscv_intc_hwnode);
 
-	pr_info("%d local interrupts mapped\n", BITS_PER_LONG);
+	pr_info("%d local interrupts mapped\n", riscv_intc_nr_irqs);
+	if (riscv_intc_custom_nr_irqs) {
+		pr_info("%d custom local interrupts mapped\n",
+			riscv_intc_custom_nr_irqs);
+	}
 
 	return 0;
 }
-- 
2.43.0



