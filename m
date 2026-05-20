Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACB01B7910;
	Wed, 20 May 2026 17:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299948; cv=none; b=F0mLzhxdMMQxJrXrbXzPFpRyublTtQmImo3Oi72ykZfsITNco7HNXZUuHnY45poK4djXdi+twvxTyrX/B17Va1j8meYDGVbZPNc+rDkb5hsv2vJb0dHrLttI0QTuXCci8zx0Dw2EizmjC81u0/f+p8t9tJ1rqDVh0jaivHdcQrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299948; c=relaxed/simple;
	bh=9IKoo5QfMFT6DeBXM3X/5xlFq4nX+0PgPmOsGaHyX4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kOQpjVvGsvuCnUzG+c2DC4SgaWLg+GzFoBPNUL/hoP+XjRWUpI9+pWyMk8Zsd5wdvnpfP5qizGZN9d86P1VlDFMeEVz/QNfFbSJXHiWecjmwYXJo1TcZH26K9ts3xwooz0dXZKyCYi874Wy4tFzCe5DpauzzFN9T9emrrGRKGxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HOY8tcL9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HOY8tcL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0AD51F000E9;
	Wed, 20 May 2026 17:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299947;
	bh=pV/33ctO9qSWfncb4+5D5Ne/1ycAd1z0vhY6k5VQqYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HOY8tcL9tlCWp3l4rsbIoX4+KMqPQRpReMB4HOE3Zsi8Cw3zVVKQFCL6Iay5o3uYx
	 cis4mxtkrimE3VGoijMVk5fxvJI0YdNLXNo/O10xJ/rStlJ/gFnkFFnIapLopnR6PC
	 /bLZbfWIcisdNDTL4kDjWAMc2P8+euc/QmyeSwS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: [PATCH 6.18 930/957] irqchip/gic-v5: Move LPI allocation into the LPI domain
Date: Wed, 20 May 2026 18:23:33 +0200
Message-ID: <20260520162154.756707425@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
@@ -927,8 +927,8 @@ static void gicv5_its_free_eventid(struc
 static int gicv5_its_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
 				      unsigned int nr_irqs, void *arg)
 {
-	u32 device_id, event_id_base, lpi;
 	struct gicv5_its_dev *its_dev;
+	u32 device_id, event_id_base;
 	msi_alloc_info_t *info = arg;
 	irq_hw_number_t hwirq;
 	struct irq_data *irqd;
@@ -947,16 +947,8 @@ static int gicv5_its_irq_domain_alloc(st
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
 
@@ -981,7 +973,6 @@ static int gicv5_its_irq_domain_alloc(st
 out_free_irqs:
 	while (--i >= 0) {
 		irqd = irq_domain_get_irq_data(domain, virq + i);
-		gicv5_free_lpi(irqd->parent_data->hwirq);
 		irq_domain_reset_irq_data(irqd);
 		irq_domain_free_irqs_parent(domain, virq + i, 1);
 	}
@@ -1011,7 +1002,6 @@ static void gicv5_its_irq_domain_free(st
 	for (i = 0; i < nr_irqs; i++) {
 		d = irq_domain_get_irq_data(domain, virq + i);
 
-		gicv5_free_lpi(d->parent_data->hwirq);
 		irq_domain_reset_irq_data(d);
 		irq_domain_free_irqs_parent(domain, virq + i, 1);
 	}
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -58,16 +58,6 @@ static void release_lpi(u32 lpi)
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
@@ -751,18 +741,36 @@ static void gicv5_lpi_config_reset(struc
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
 
@@ -771,8 +779,10 @@ static int gicv5_irq_lpi_domain_alloc(st
 	irqd_set_single_target(irqd);
 
 	ret = gicv5_irs_iste_alloc(hwirq);
-	if (ret < 0)
+	if (ret < 0) {
+		release_lpi(hwirq);
 		return ret;
+	}
 
 	gicv5_hwirq_init(hwirq, GICV5_IRQ_PRI_MI, GICV5_HWIRQ_TYPE_LPI);
 	gicv5_lpi_config_reset(irqd);
@@ -782,7 +792,7 @@ static int gicv5_irq_lpi_domain_alloc(st
 
 static const struct irq_domain_ops gicv5_irq_lpi_domain_ops = {
 	.alloc	= gicv5_irq_lpi_domain_alloc,
-	.free	= gicv5_irq_domain_free,
+	.free	= gicv5_irq_lpi_domain_free,
 };
 
 void __init gicv5_init_lpi_domain(void)
@@ -804,21 +814,12 @@ static int gicv5_irq_ipi_domain_alloc(st
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
@@ -844,8 +845,6 @@ static void gicv5_irq_ipi_domain_free(st
 		if (!d)
 			return;
 
-		gicv5_free_lpi(d->parent_data->hwirq);
-
 		irq_set_handler(virq + i, NULL);
 		irq_domain_reset_irq_data(d);
 		irq_domain_free_irqs_parent(domain, virq + i, 1);
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -387,8 +387,5 @@ struct gicv5_its_itt_cfg {
 void gicv5_init_lpis(u32 max);
 void gicv5_deinit_lpis(void);
 
-int gicv5_alloc_lpi(void);
-void gicv5_free_lpi(u32 lpi);
-
 void __init gicv5_its_of_probe(struct device_node *parent);
 #endif


