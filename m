Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A8511C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:24:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21643C433C9;
	Mon, 28 Aug 2023 10:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218283;
	bh=lJkmgO6xZDV7mrlS1zsQI6sEkkTARTicKO+uUzhVTV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KSzWTj1hB2ewk6FbiGh01H0lXucCZTEl4E5Py5G8rsbpqqafmMQVjaG8jKttr/t+a
	 K2AOJlDqawC0q9yQt/m/YD5wKRPkm/3eDCG0N/HpGZmMZW+50Zb7m/nd654WTybWah
	 XuPVlKFkMfhwwmpM1/n3VzroUfqDA/eGm+OV1pFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Serge Semin <fancer.lancer@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 032/129] irqchip/mips-gic: Get rid of the reliance on irq_cpu_online()
Date: Mon, 28 Aug 2023 12:12:06 +0200
Message-ID: <20230828101154.283894087@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101153.030066927@linuxfoundation.org>
References: <20230828101153.030066927@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit dd098a0e031928cf88c89f7577d31821e1f0e6de ]

The MIPS GIC driver uses irq_cpu_online() to go and program the
per-CPU interrupts. However, this method iterates over all IRQs
in the system, despite only 3 per-CPU interrupts being of interest.

Let's be terribly bold and do the iteration ourselves. To ensure
mutual exclusion, hold the gic_lock spinlock that is otherwise
taken while dealing with these interrupts.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Serge Semin <fancer.lancer@gmail.com>
Link: https://lore.kernel.org/r/20211021170414.3341522-3-maz@kernel.org
Stable-dep-of: 3d6a0e4197c0 ("irqchip/mips-gic: Use raw spinlock for gic_lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-mips-gic.c | 37 ++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index f3985469c2211..6b8c3dd0f76f4 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -380,24 +380,35 @@ static void gic_unmask_local_irq_all_vpes(struct irq_data *d)
 	spin_unlock_irqrestore(&gic_lock, flags);
 }
 
-static void gic_all_vpes_irq_cpu_online(struct irq_data *d)
+static void gic_all_vpes_irq_cpu_online(void)
 {
-	struct gic_all_vpes_chip_data *cd;
-	unsigned int intr;
+	static const unsigned int local_intrs[] = {
+		GIC_LOCAL_INT_TIMER,
+		GIC_LOCAL_INT_PERFCTR,
+		GIC_LOCAL_INT_FDC,
+	};
+	unsigned long flags;
+	int i;
 
-	intr = GIC_HWIRQ_TO_LOCAL(d->hwirq);
-	cd = irq_data_get_irq_chip_data(d);
+	spin_lock_irqsave(&gic_lock, flags);
 
-	write_gic_vl_map(mips_gic_vx_map_reg(intr), cd->map);
-	if (cd->mask)
-		write_gic_vl_smask(BIT(intr));
+	for (i = 0; i < ARRAY_SIZE(local_intrs); i++) {
+		unsigned int intr = local_intrs[i];
+		struct gic_all_vpes_chip_data *cd;
+
+		cd = &gic_all_vpes_chip_data[intr];
+		write_gic_vl_map(mips_gic_vx_map_reg(intr), cd->map);
+		if (cd->mask)
+			write_gic_vl_smask(BIT(intr));
+	}
+
+	spin_unlock_irqrestore(&gic_lock, flags);
 }
 
 static struct irq_chip gic_all_vpes_local_irq_controller = {
 	.name			= "MIPS GIC Local",
 	.irq_mask		= gic_mask_local_irq_all_vpes,
 	.irq_unmask		= gic_unmask_local_irq_all_vpes,
-	.irq_cpu_online		= gic_all_vpes_irq_cpu_online,
 };
 
 static void __gic_irq_dispatch(void)
@@ -476,6 +487,10 @@ static int gic_irq_domain_map(struct irq_domain *d, unsigned int virq,
 	intr = GIC_HWIRQ_TO_LOCAL(hwirq);
 	map = GIC_MAP_PIN_MAP_TO_PIN | gic_cpu_pin;
 
+	/*
+	 * If adding support for more per-cpu interrupts, keep the the
+	 * array in gic_all_vpes_irq_cpu_online() in sync.
+	 */
 	switch (intr) {
 	case GIC_LOCAL_INT_TIMER:
 		/* CONFIG_MIPS_CMP workaround (see __gic_init) */
@@ -662,8 +677,8 @@ static int gic_cpu_startup(unsigned int cpu)
 	/* Clear all local IRQ masks (ie. disable all local interrupts) */
 	write_gic_vl_rmask(~0);
 
-	/* Invoke irq_cpu_online callbacks to enable desired interrupts */
-	irq_cpu_online();
+	/* Enable desired interrupts */
+	gic_all_vpes_irq_cpu_online();
 
 	return 0;
 }
-- 
2.40.1



