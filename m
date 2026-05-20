Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7DC370D54;
	Wed, 20 May 2026 17:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297261; cv=none; b=bzwUN2mfpegncHTsQPonQEXkforK04RrkpqLGXQOtXbgIyRUdqoKDxO6P7a52u670MiRuL20Ycrbp4Zm4Uo1udHr6pArxczR8Six7yIGIyJXQKMNvUcdEizH7xTdt0wyp1KCjokrMhRCY9mcAhpjk0Dcgn2L3MjCfpPQDvFxNMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297261; c=relaxed/simple;
	bh=GwqluoPSY6+kax8nu38Us+ixxm5CGa5In/ka7vDgRNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEeEqCFa/kksHbiVKyUf0Saj2731Rk9yucbk2EPuXU3D/AGdvKPJbipJxDJHiPDv9BcLkM52+piDZwIqWhPuaGthHl0D4MyqwZYZrQ81EaG4p+D77iGw60fMeAcJlruJy2u7srVYCTHfjhlgyHkodcdgRRTQ82ehx4hwp5O+nPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sJcW8w7F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sJcW8w7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF6C1F000E9;
	Wed, 20 May 2026 17:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297259;
	bh=cjU9zTE66Sr/QzzdHAvjCsdyIaPxLQOQJP2+ZowXnqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sJcW8w7FKc1EF67ic9448SBMpTWdpzxoNGYBNK3A0bSlLIAF61Z/BfJzW2ecRPmwT
	 ARgI0V1KMTnCVGRFU/FNcYKnhB4HAXB7u7q6uvQa1HLRvji9NdIiD+Lu4uGMv4GceD
	 3hVUmo4bME110xDYRIU9s1rMyaca1TS350NA/Tik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: [PATCH 7.0 1111/1146] irqchip/gic-v5: Move LPI allocation into the LPI domain
Date: Wed, 20 May 2026 18:22:41 +0200
Message-ID: <20260520162213.389108734@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sascha Bischoff <Sascha.Bischoff@arm.com>

commit dec85d2fbd20de3711a71e65397dfdb40c3fa953 upstream.

The IPI and ITS MSI domains currently allocate and release LPIs
directly, then pass the selected LPI ID to the parent LPI domain. This
leaks the LPI domain's allocation policy into its child domains and
forces each child to duplicate part of the parent domain's teardown.

Make the LPI domain allocate LPIs in its .alloc() callback and release
them in a matching .free() callback. Child domains can then request a
parent interrupt without passing an implementation-specific LPI ID,
and the LPI lifetime is tied to the domain that owns the LPI
namespace.

Remove the gicv5_alloc_lpi() and gicv5_free_lpi() wrappers now that no
external caller needs to manage LPIs directly.

This is a preparatory change for an actual leakage problem in the
allocation code and therefore tagged with the same Fixes tag.

Fixes: 0f0101325876 ("irqchip/gic-v5: Add GICv5 LPI/IPI support")
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260506093634.382062-2-sascha.bischoff@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v5-its.c   |   14 +--------
 drivers/irqchip/irq-gic-v5.c       |   53 ++++++++++++++++++-------------------
 include/linux/irqchip/arm-gic-v5.h |    3 --
 3 files changed, 28 insertions(+), 42 deletions(-)

--- a/drivers/irqchip/irq-gic-v5-its.c
+++ b/drivers/irqchip/irq-gic-v5-its.c
@@ -929,8 +929,8 @@ static void gicv5_its_free_eventid(struc
 static int gicv5_its_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
 				      unsigned int nr_irqs, void *arg)
 {
-	u32 device_id, event_id_base, lpi;
 	struct gicv5_its_dev *its_dev;
+	u32 device_id, event_id_base;
 	msi_alloc_info_t *info = arg;
 	irq_hw_number_t hwirq;
 	struct irq_data *irqd;
@@ -949,16 +949,8 @@ static int gicv5_its_irq_domain_alloc(st
 	device_id = its_dev->device_id;
 
 	for (i = 0; i < nr_irqs; i++) {
-		ret = gicv5_alloc_lpi();
-		if (ret < 0) {
-			pr_debug("Failed to find free LPI!\n");
-			goto out_free_irqs;
-		}
-		lpi = ret;
-
-		ret = irq_domain_alloc_irqs_parent(domain, virq + i, 1, &lpi);
+		ret = irq_domain_alloc_irqs_parent(domain, virq + i, 1, NULL);
 		if (ret) {
-			gicv5_free_lpi(lpi);
 			goto out_free_irqs;
 		}
 
@@ -983,7 +975,6 @@ static int gicv5_its_irq_domain_alloc(st
 out_free_irqs:
 	while (--i >= 0) {
 		irqd = irq_domain_get_irq_data(domain, virq + i);
-		gicv5_free_lpi(irqd->parent_data->hwirq);
 		irq_domain_reset_irq_data(irqd);
 		irq_domain_free_irqs_parent(domain, virq + i, 1);
 	}
@@ -1013,7 +1004,6 @@ static void gicv5_its_irq_domain_free(st
 	for (i = 0; i < nr_irqs; i++) {
 		d = irq_domain_get_irq_data(domain, virq + i);
 
-		gicv5_free_lpi(d->parent_data->hwirq);
 		irq_domain_reset_irq_data(d);
 		irq_domain_free_irqs_parent(domain, virq + i, 1);
 	}
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -59,16 +59,6 @@ static void release_lpi(u32 lpi)
 	ida_free(&lpi_ida, lpi);
 }
 
-int gicv5_alloc_lpi(void)
-{
-	return alloc_lpi();
-}
-
-void gicv5_free_lpi(u32 lpi)
-{
-	release_lpi(lpi);
-}
-
 static void gicv5_ppi_priority_init(void)
 {
 	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_PRI_MI), SYS_ICC_PPI_PRIORITYR0_EL1);
@@ -788,18 +778,36 @@ static void gicv5_lpi_config_reset(struc
 	gicv5_lpi_irq_write_pending_state(d, false);
 }
 
+static void gicv5_irq_lpi_domain_free(struct irq_domain *domain, unsigned int virq,
+				      unsigned int nr_irqs)
+{
+	struct irq_data *d;
+
+	if (WARN_ON_ONCE(nr_irqs != 1))
+		return;
+
+	d = irq_domain_get_irq_data(domain, virq);
+
+	release_lpi(d->hwirq);
+
+	irq_set_handler(virq, NULL);
+	irq_domain_reset_irq_data(d);
+}
+
 static int gicv5_irq_lpi_domain_alloc(struct irq_domain *domain, unsigned int virq,
 				      unsigned int nr_irqs, void *arg)
 {
 	irq_hw_number_t hwirq;
 	struct irq_data *irqd;
-	u32 *lpi = arg;
 	int ret;
 
 	if (WARN_ON_ONCE(nr_irqs != 1))
 		return -EINVAL;
 
-	hwirq = *lpi;
+	ret = alloc_lpi();
+	if (ret < 0)
+		return ret;
+	hwirq = ret;
 
 	irqd = irq_domain_get_irq_data(domain, virq);
 
@@ -808,8 +816,10 @@ static int gicv5_irq_lpi_domain_alloc(st
 	irqd_set_single_target(irqd);
 
 	ret = gicv5_irs_iste_alloc(hwirq);
-	if (ret < 0)
+	if (ret < 0) {
+		release_lpi(hwirq);
 		return ret;
+	}
 
 	gicv5_hwirq_init(hwirq, GICV5_IRQ_PRI_MI, GICV5_HWIRQ_TYPE_LPI);
 	gicv5_lpi_config_reset(irqd);
@@ -819,7 +829,7 @@ static int gicv5_irq_lpi_domain_alloc(st
 
 static const struct irq_domain_ops gicv5_irq_lpi_domain_ops = {
 	.alloc	= gicv5_irq_lpi_domain_alloc,
-	.free	= gicv5_irq_domain_free,
+	.free	= gicv5_irq_lpi_domain_free,
 };
 
 void __init gicv5_init_lpi_domain(void)
@@ -841,21 +851,12 @@ static int gicv5_irq_ipi_domain_alloc(st
 {
 	struct irq_data *irqd;
 	int ret, i;
-	u32 lpi;
 
 	for (i = 0; i < nr_irqs; i++) {
-		ret = gicv5_alloc_lpi();
-		if (ret < 0)
+		ret = irq_domain_alloc_irqs_parent(domain, virq + i, 1, NULL);
+		if (ret)
 			return ret;
 
-		lpi = ret;
-
-		ret = irq_domain_alloc_irqs_parent(domain, virq + i, 1, &lpi);
-		if (ret) {
-			gicv5_free_lpi(lpi);
-			return ret;
-		}
-
 		irqd = irq_domain_get_irq_data(domain, virq + i);
 
 		irq_domain_set_hwirq_and_chip(domain, virq + i, i,
@@ -881,8 +882,6 @@ static void gicv5_irq_ipi_domain_free(st
 		if (!d)
 			return;
 
-		gicv5_free_lpi(d->parent_data->hwirq);
-
 		irq_set_handler(virq + i, NULL);
 		irq_domain_reset_irq_data(d);
 		irq_domain_free_irqs_parent(domain, virq + i, 1);
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -398,9 +398,6 @@ struct gicv5_its_itt_cfg {
 void gicv5_init_lpis(u32 max);
 void gicv5_deinit_lpis(void);
 
-int gicv5_alloc_lpi(void);
-void gicv5_free_lpi(u32 lpi);
-
 void __init gicv5_its_of_probe(struct device_node *parent);
 void __init gicv5_its_acpi_probe(void);
 #endif


