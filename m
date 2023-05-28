Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C94B611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082A0C433D2;
	Sun, 28 May 2023 19:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302565;
	bh=ZQKUqK2QCJ3QauNXIQl/Cp3CBG2qy3fAVPd5b1f9VsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gaMRjAaY88VSWp4/1wnHapG3WEX5PP/EGCuD6LeODm5xpTsfbuliBaRvNe51RO5q0
	 yjbv6XbQ0C/DG5LaYxKjx7w1wpD7YVWMEPDrwMW0Nf1mxxzWQ7Dgb5h4TVTgiWCx+r
	 8/9VdqvZo/FWWdpLtTqz778t1DXJ4yKZaKgDsbUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Serge Semin <fancer.lancer@gmail.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.1 055/119] irqchip/mips-gic: Use raw spinlock for gic_lock
Date: Sun, 28 May 2023 20:10:55 +0100
Message-Id: <20230528190837.263565816@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
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

commit 3d6a0e4197c04599d75d85a608c8bb16a630a38c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-mips-gic.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -50,7 +50,7 @@ void __iomem *mips_gic_base;
 
 static DEFINE_PER_CPU_READ_MOSTLY(unsigned long[GIC_MAX_LONGS], pcpu_masks);
 
-static DEFINE_SPINLOCK(gic_lock);
+static DEFINE_RAW_SPINLOCK(gic_lock);
 static struct irq_domain *gic_irq_domain;
 static int gic_shared_intrs;
 static unsigned int gic_cpu_pin;
@@ -211,7 +211,7 @@ static int gic_set_type(struct irq_data
 
 	irq = GIC_HWIRQ_TO_SHARED(d->hwirq);
 
-	spin_lock_irqsave(&gic_lock, flags);
+	raw_spin_lock_irqsave(&gic_lock, flags);
 	switch (type & IRQ_TYPE_SENSE_MASK) {
 	case IRQ_TYPE_EDGE_FALLING:
 		pol = GIC_POL_FALLING_EDGE;
@@ -251,7 +251,7 @@ static int gic_set_type(struct irq_data
 	else
 		irq_set_chip_handler_name_locked(d, &gic_level_irq_controller,
 						 handle_level_irq, NULL);
-	spin_unlock_irqrestore(&gic_lock, flags);
+	raw_spin_unlock_irqrestore(&gic_lock, flags);
 
 	return 0;
 }
@@ -269,7 +269,7 @@ static int gic_set_affinity(struct irq_d
 		return -EINVAL;
 
 	/* Assumption : cpumask refers to a single CPU */
-	spin_lock_irqsave(&gic_lock, flags);
+	raw_spin_lock_irqsave(&gic_lock, flags);
 
 	/* Re-route this IRQ */
 	write_gic_map_vp(irq, BIT(mips_cm_vp_id(cpu)));
@@ -280,7 +280,7 @@ static int gic_set_affinity(struct irq_d
 		set_bit(irq, per_cpu_ptr(pcpu_masks, cpu));
 
 	irq_data_update_effective_affinity(d, cpumask_of(cpu));
-	spin_unlock_irqrestore(&gic_lock, flags);
+	raw_spin_unlock_irqrestore(&gic_lock, flags);
 
 	return IRQ_SET_MASK_OK;
 }
@@ -358,12 +358,12 @@ static void gic_mask_local_irq_all_vpes(
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
@@ -376,12 +376,12 @@ static void gic_unmask_local_irq_all_vpe
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
@@ -394,7 +394,7 @@ static void gic_all_vpes_irq_cpu_online(
 	unsigned long flags;
 	int i;
 
-	spin_lock_irqsave(&gic_lock, flags);
+	raw_spin_lock_irqsave(&gic_lock, flags);
 
 	for (i = 0; i < ARRAY_SIZE(local_intrs); i++) {
 		unsigned int intr = local_intrs[i];
@@ -408,7 +408,7 @@ static void gic_all_vpes_irq_cpu_online(
 			write_gic_vl_smask(BIT(intr));
 	}
 
-	spin_unlock_irqrestore(&gic_lock, flags);
+	raw_spin_unlock_irqrestore(&gic_lock, flags);
 }
 
 static struct irq_chip gic_all_vpes_local_irq_controller = {
@@ -438,11 +438,11 @@ static int gic_shared_irq_domain_map(str
 
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
@@ -537,12 +537,12 @@ static int gic_irq_domain_map(struct irq
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


