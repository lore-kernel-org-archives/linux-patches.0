Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE3B2E84A;
	Fri, 24 Nov 2023 18:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GwZjHOsh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A34C433C8;
	Fri, 24 Nov 2023 18:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850918;
	bh=TRXrTC05qAVyBg9JAwFPqdkPTFvxAFncF9CWorOD0K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GwZjHOshtXfw9l4jHYrBWhhTG+4khipujLkLPR2wOppVbJzbpM4nMQL0D43kIbt2N
	 QnCjR2IPDYLVdrz4z2Y1ZXwDM5xjsJpVs756PaTXXwqbPWOxJH3RdqFmxkxibyP8Qf
	 jhUElq1fnhexT3aFgnNa/3YyWxmRiOSIQB5R1960=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Koichiro Den <den@valinux.co.jp>
Subject: [PATCH 6.5 240/491] x86/apic/msi: Fix misconfigured non-maskable MSI quirk
Date: Fri, 24 Nov 2023 17:47:56 +0000
Message-ID: <20231124172031.772172833@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

commit b56ebe7c896dc78b5865ec2c4b1dae3c93537517 upstream.

commit ef8dd01538ea ("genirq/msi: Make interrupt allocation less
convoluted"), reworked the code so that the x86 specific quirk for affinity
setting of non-maskable PCI/MSI interrupts is not longer activated if
necessary.

This could be solved by restoring the original logic in the core MSI code,
but after a deeper analysis it turned out that the quirk flag is not
required at all.

The quirk is only required when the PCI/MSI device cannot mask the MSI
interrupts, which in turn also prevents reservation mode from being enabled
for the affected interrupt.

This allows ot remove the NOMASK quirk bit completely as msi_set_affinity()
can instead check whether reservation mode is enabled for the interrupt,
which gives exactly the same answer.

Even in the momentary non-existing case that the reservation mode would be
not set for a maskable MSI interrupt this would not cause any harm as it
just would cause msi_set_affinity() to go needlessly through the
functionaly equivalent slow path, which works perfectly fine with maskable
interrupts as well.

Rework msi_set_affinity() to query the reservation mode and remove all
NOMASK quirk logic from the core code.

[ tglx: Massaged changelog ]

Fixes: ef8dd01538ea ("genirq/msi: Make interrupt allocation less convoluted")
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231026032036.2462428-1-den@valinux.co.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/apic/msi.c |    8 +++-----
 include/linux/irq.h        |   26 ++++----------------------
 include/linux/msi.h        |    6 ------
 kernel/irq/debugfs.c       |    1 -
 kernel/irq/msi.c           |   12 +-----------
 5 files changed, 8 insertions(+), 45 deletions(-)

--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -55,14 +55,14 @@ msi_set_affinity(struct irq_data *irqd,
 	 * caused by the non-atomic update of the address/data pair.
 	 *
 	 * Direct update is possible when:
-	 * - The MSI is maskable (remapped MSI does not use this code path)).
-	 *   The quirk bit is not set in this case.
+	 * - The MSI is maskable (remapped MSI does not use this code path).
+	 *   The reservation mode bit is set in this case.
 	 * - The new vector is the same as the old vector
 	 * - The old vector is MANAGED_IRQ_SHUTDOWN_VECTOR (interrupt starts up)
 	 * - The interrupt is not yet started up
 	 * - The new destination CPU is the same as the old destination CPU
 	 */
-	if (!irqd_msi_nomask_quirk(irqd) ||
+	if (!irqd_can_reserve(irqd) ||
 	    cfg->vector == old_cfg.vector ||
 	    old_cfg.vector == MANAGED_IRQ_SHUTDOWN_VECTOR ||
 	    !irqd_is_started(irqd) ||
@@ -215,8 +215,6 @@ static bool x86_init_dev_msi_info(struct
 		if (WARN_ON_ONCE(domain != real_parent))
 			return false;
 		info->chip->irq_set_affinity = msi_set_affinity;
-		/* See msi_set_affinity() for the gory details */
-		info->flags |= MSI_FLAG_NOMASK_QUIRK;
 		break;
 	case DOMAIN_BUS_DMAR:
 	case DOMAIN_BUS_AMDVI:
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -215,8 +215,6 @@ struct irq_data {
  * IRQD_SINGLE_TARGET		- IRQ allows only a single affinity target
  * IRQD_DEFAULT_TRIGGER_SET	- Expected trigger already been set
  * IRQD_CAN_RESERVE		- Can use reservation mode
- * IRQD_MSI_NOMASK_QUIRK	- Non-maskable MSI quirk for affinity change
- *				  required
  * IRQD_HANDLE_ENFORCE_IRQCTX	- Enforce that handle_irq_*() is only invoked
  *				  from actual interrupt context.
  * IRQD_AFFINITY_ON_ACTIVATE	- Affinity is set on activation. Don't call
@@ -247,11 +245,10 @@ enum {
 	IRQD_SINGLE_TARGET		= BIT(24),
 	IRQD_DEFAULT_TRIGGER_SET	= BIT(25),
 	IRQD_CAN_RESERVE		= BIT(26),
-	IRQD_MSI_NOMASK_QUIRK		= BIT(27),
-	IRQD_HANDLE_ENFORCE_IRQCTX	= BIT(28),
-	IRQD_AFFINITY_ON_ACTIVATE	= BIT(29),
-	IRQD_IRQ_ENABLED_ON_SUSPEND	= BIT(30),
-	IRQD_RESEND_WHEN_IN_PROGRESS    = BIT(31),
+	IRQD_HANDLE_ENFORCE_IRQCTX	= BIT(27),
+	IRQD_AFFINITY_ON_ACTIVATE	= BIT(28),
+	IRQD_IRQ_ENABLED_ON_SUSPEND	= BIT(29),
+	IRQD_RESEND_WHEN_IN_PROGRESS    = BIT(30),
 };
 
 #define __irqd_to_state(d) ACCESS_PRIVATE((d)->common, state_use_accessors)
@@ -426,21 +423,6 @@ static inline bool irqd_can_reserve(stru
 	return __irqd_to_state(d) & IRQD_CAN_RESERVE;
 }
 
-static inline void irqd_set_msi_nomask_quirk(struct irq_data *d)
-{
-	__irqd_to_state(d) |= IRQD_MSI_NOMASK_QUIRK;
-}
-
-static inline void irqd_clr_msi_nomask_quirk(struct irq_data *d)
-{
-	__irqd_to_state(d) &= ~IRQD_MSI_NOMASK_QUIRK;
-}
-
-static inline bool irqd_msi_nomask_quirk(struct irq_data *d)
-{
-	return __irqd_to_state(d) & IRQD_MSI_NOMASK_QUIRK;
-}
-
 static inline void irqd_set_affinity_on_activate(struct irq_data *d)
 {
 	__irqd_to_state(d) |= IRQD_AFFINITY_ON_ACTIVATE;
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -547,12 +547,6 @@ enum {
 	MSI_FLAG_ALLOC_SIMPLE_MSI_DESCS	= (1 << 5),
 	/* Free MSI descriptors */
 	MSI_FLAG_FREE_MSI_DESCS		= (1 << 6),
-	/*
-	 * Quirk to handle MSI implementations which do not provide
-	 * masking. Currently known to affect x86, but has to be partially
-	 * handled in the core MSI code.
-	 */
-	MSI_FLAG_NOMASK_QUIRK		= (1 << 7),
 
 	/* Mask for the generic functionality */
 	MSI_GENERIC_FLAGS_MASK		= GENMASK(15, 0),
--- a/kernel/irq/debugfs.c
+++ b/kernel/irq/debugfs.c
@@ -121,7 +121,6 @@ static const struct irq_bit_descr irqdat
 	BIT_MASK_DESCR(IRQD_AFFINITY_ON_ACTIVATE),
 	BIT_MASK_DESCR(IRQD_MANAGED_SHUTDOWN),
 	BIT_MASK_DESCR(IRQD_CAN_RESERVE),
-	BIT_MASK_DESCR(IRQD_MSI_NOMASK_QUIRK),
 
 	BIT_MASK_DESCR(IRQD_FORWARDED_TO_VCPU),
 
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -1204,7 +1204,6 @@ static int msi_handle_pci_fail(struct ir
 
 #define VIRQ_CAN_RESERVE	0x01
 #define VIRQ_ACTIVATE		0x02
-#define VIRQ_NOMASK_QUIRK	0x04
 
 static int msi_init_virq(struct irq_domain *domain, int virq, unsigned int vflags)
 {
@@ -1213,8 +1212,6 @@ static int msi_init_virq(struct irq_doma
 
 	if (!(vflags & VIRQ_CAN_RESERVE)) {
 		irqd_clr_can_reserve(irqd);
-		if (vflags & VIRQ_NOMASK_QUIRK)
-			irqd_set_msi_nomask_quirk(irqd);
 
 		/*
 		 * If the interrupt is managed but no CPU is available to
@@ -1275,15 +1272,8 @@ static int __msi_domain_alloc_irqs(struc
 	 * Interrupt can use a reserved vector and will not occupy
 	 * a real device vector until the interrupt is requested.
 	 */
-	if (msi_check_reservation_mode(domain, info, dev)) {
+	if (msi_check_reservation_mode(domain, info, dev))
 		vflags |= VIRQ_CAN_RESERVE;
-		/*
-		 * MSI affinity setting requires a special quirk (X86) when
-		 * reservation mode is active.
-		 */
-		if (info->flags & MSI_FLAG_NOMASK_QUIRK)
-			vflags |= VIRQ_NOMASK_QUIRK;
-	}
 
 	xa_for_each_range(xa, idx, desc, ctrl->first, ctrl->last) {
 		if (!msi_desc_match(desc, MSI_DESC_NOTASSOCIATED))


