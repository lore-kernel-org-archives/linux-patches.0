Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F1111C86
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 15:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 471FEC433C7;
	Thu, 24 Aug 2023 15:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692889211;
	bh=rS+npzK/68F0dBPJM0XrPTrlDTrEtCOE6RdKcxmk9mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QFeY3q9YEAX83gTD0czduAhYxfaLm3qruEuGAnKMlhlnIEie71RTXczXNhRFGM3K6
	 Xm84ctXsvrmQANZcRHr8W1EhgEvxEZW0YkruUqw/UBnvnn8Y5E+OOCceuQ2lblhd9x
	 61152WMlr8xvICardac42klBJz3r631jvXAZbRm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Serge Semin <fancer.lancer@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/135] irqchip/mips-gic: Use raw spinlock for gic_lock
Date: Thu, 24 Aug 2023 16:49:56 +0200
Message-ID: <20230824145029.190092059@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145027.008282920@linuxfoundation.org>
References: <20230824145027.008282920@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

[ Upstream commit 3d6a0e4197c04599d75d85a608c8bb16a630a38c ]

Since we may hold gic_lock in hardirq context, use raw spinlock
makes more sense given that it is for low-level interrupt handling
routine and the critical section is small.

Fixes BUG:

[    0.426106] =============================
[    0.426257] [ BUG: Invalid wait context ]
[    0.426422] 6.3.0-rc7-next-20230421-dirty #54 Not tainted
[    0.426638] -----------------------------
[    0.426766] swapper/0/1 is trying to lock:
[    0.426954] ffffffff8104e7b8 (gic_lock){....}-{3:3}, at: gic_set_type+0x30/08

Fixes: 95150ae8b330 ("irqchip: mips-gic: Implement irq_set_type callback")
Cc: stable@vger.kernel.org
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Tested-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230424103156.66753-3-jiaxun.yang@flygoat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-mips-gic.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index 7e4a9e75b49be..fc25b900cef71 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -48,7 +48,7 @@ void __iomem *mips_gic_base;
 
 static DEFINE_PER_CPU_READ_MOSTLY(unsigned long[GIC_MAX_LONGS], pcpu_masks);
 
-static DEFINE_SPINLOCK(gic_lock);
+static DEFINE_RAW_SPINLOCK(gic_lock);
 static struct irq_domain *gic_irq_domain;
 static int gic_shared_intrs;
 static unsigned int gic_cpu_pin;
@@ -209,7 +209,7 @@ static int gic_set_type(struct irq_data *d, unsigned int type)
 
 	irq = GIC_HWIRQ_TO_SHARED(d->hwirq);
 
-	spin_lock_irqsave(&gic_lock, flags);
+	raw_spin_lock_irqsave(&gic_lock, flags);
 	switch (type & IRQ_TYPE_SENSE_MASK) {
 	case IRQ_TYPE_EDGE_FALLING:
 		pol = GIC_POL_FALLING_EDGE;
@@ -249,7 +249,7 @@ static int gic_set_type(struct irq_data *d, unsigned int type)
 	else
 		irq_set_chip_handler_name_locked(d, &gic_level_irq_controller,
 						 handle_level_irq, NULL);
-	spin_unlock_irqrestore(&gic_lock, flags);
+	raw_spin_unlock_irqrestore(&gic_lock, flags);
 
 	return 0;
 }
@@ -267,7 +267,7 @@ static int gic_set_affinity(struct irq_data *d, const struct cpumask *cpumask,
 		return -EINVAL;
 
 	/* Assumption : cpumask refers to a single CPU */
-	spin_lock_irqsave(&gic_lock, flags);
+	raw_spin_lock_irqsave(&gic_lock, flags);
 
 	/* Re-route this IRQ */
 	write_gic_map_vp(irq, BIT(mips_cm_vp_id(cpu)));
@@ -278,7 +278,7 @@ static int gic_set_affinity(struct irq_data *d, const struct cpumask *cpumask,
 		set_bit(irq, per_cpu_ptr(pcpu_masks, cpu));
 
 	irq_data_update_effective_affinity(d, cpumask_of(cpu));
-	spin_unlock_irqrestore(&gic_lock, flags);
+	raw_spin_unlock_irqrestore(&gic_lock, flags);
 
 	return IRQ_SET_MASK_OK;
 }
@@ -356,12 +356,12 @@ static void gic_mask_local_irq_all_vpes(struct irq_data *d)
 	cd = irq_data_get_irq_chip_data(d);
 	cd->mask = false;
 
-	spin_lock_irqsave(&gic_lock, flags);
+	raw_spin_lock_irqsave(&gic_lock, flags);
 	for_each_online_cpu(cpu) {
 		write_gic_vl_other(mips_cm_vp_id(cpu));
 		write_gic_vo_rmask(BIT(intr));
 	}
-	spin_unlock_irqrestore(&gic_lock, flags);
+	raw_spin_unlock_irqrestore(&gic_lock, flags);
 }
 
 static void gic_unmask_local_irq_all_vpes(struct irq_data *d)
@@ -374,12 +374,12 @@ static void gic_unmask_local_irq_all_vpes(struct irq_data *d)
 	cd = irq_data_get_irq_chip_data(d);
 	cd->mask = true;
 
-	spin_lock_irqsave(&gic_lock, flags);
+	raw_spin_lock_irqsave(&gic_lock, flags);
 	for_each_online_cpu(cpu) {
 		write_gic_vl_other(mips_cm_vp_id(cpu));
 		write_gic_vo_smask(BIT(intr));
 	}
-	spin_unlock_irqrestore(&gic_lock, flags);
+	raw_spin_unlock_irqrestore(&gic_lock, flags);
 }
 
 static void gic_all_vpes_irq_cpu_online(void)
@@ -392,7 +392,7 @@ static void gic_all_vpes_irq_cpu_online(void)
 	unsigned long flags;
 	int i;
 
-	spin_lock_irqsave(&gic_lock, flags);
+	raw_spin_lock_irqsave(&gic_lock, flags);
 
 	for (i = 0; i < ARRAY_SIZE(local_intrs); i++) {
 		unsigned int intr = local_intrs[i];
@@ -404,7 +404,7 @@ static void gic_all_vpes_irq_cpu_online(void)
 			write_gic_vl_smask(BIT(intr));
 	}
 
-	spin_unlock_irqrestore(&gic_lock, flags);
+	raw_spin_unlock_irqrestore(&gic_lock, flags);
 }
 
 static struct irq_chip gic_all_vpes_local_irq_controller = {
@@ -434,11 +434,11 @@ static int gic_shared_irq_domain_map(struct irq_domain *d, unsigned int virq,
 
 	data = irq_get_irq_data(virq);
 
-	spin_lock_irqsave(&gic_lock, flags);
+	raw_spin_lock_irqsave(&gic_lock, flags);
 	write_gic_map_pin(intr, GIC_MAP_PIN_MAP_TO_PIN | gic_cpu_pin);
 	write_gic_map_vp(intr, BIT(mips_cm_vp_id(cpu)));
 	irq_data_update_effective_affinity(data, cpumask_of(cpu));
-	spin_unlock_irqrestore(&gic_lock, flags);
+	raw_spin_unlock_irqrestore(&gic_lock, flags);
 
 	return 0;
 }
@@ -533,12 +533,12 @@ static int gic_irq_domain_map(struct irq_domain *d, unsigned int virq,
 	if (!gic_local_irq_is_routable(intr))
 		return -EPERM;
 
-	spin_lock_irqsave(&gic_lock, flags);
+	raw_spin_lock_irqsave(&gic_lock, flags);
 	for_each_online_cpu(cpu) {
 		write_gic_vl_other(mips_cm_vp_id(cpu));
 		write_gic_vo_map(mips_gic_vx_map_reg(intr), map);
 	}
-	spin_unlock_irqrestore(&gic_lock, flags);
+	raw_spin_unlock_irqrestore(&gic_lock, flags);
 
 	return 0;
 }
-- 
2.40.1



