Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143082749D2;
	Mon, 29 Dec 2025 16:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025424; cv=none; b=c2w5TADrJbHbs+8QnYELuszOBbN+SfrQzAX50hfwdFdK4TImjUdJwm/2++4UCnuBfv28qsGNrHe+og+na5Y/KDqTA3M1HVhf77p8gwPs2xkRh7GZI/pK8SOel0QLnihf7d0NaewNuzNyKf5cG3g9cNrJ1SOVa9REiyJxNy6KUt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025424; c=relaxed/simple;
	bh=3Sn/CXGObT3JFmtMH7B8tQ21yJ/Tvouvac64aiXl84U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LdefLHLtVwefBjdJ/OSoPc9RsZK2TFjzBqNdBhSSxSUBmx8/hLYhYQbkHozsHpWJmZAVoJ953ZCykCLbCYDZJi8DHiJHARBUSHCp5rquDAuT9fLrqRb1lZ3/DpxjS6iu4IjQqONvdz2GsTKK2mCHa7VkpVqI1OaEumopEoNeE3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=We4imbqD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="We4imbqD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738C8C19421;
	Mon, 29 Dec 2025 16:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025423;
	bh=3Sn/CXGObT3JFmtMH7B8tQ21yJ/Tvouvac64aiXl84U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=We4imbqDziP53M5InMK1O6evsytHeGqHoe99k+gj0okSlnlttTC2CRVbbrALQLN1u
	 GnHZIXa3HG9Cm3nIyrj3u/9Qj6EfrWSWA0TKX8yC6Qc4kLK7RDzK4x5Iqw/Y/Pwh/f
	 IbmU71MbUcd5w3m/oGMXUvbx/1ZZjH6td56+490w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luigi Rizzo <lrizzo@google.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.18 165/430] x86/msi: Make irq_retrigger() functional for posted MSI
Date: Mon, 29 Dec 2025 17:09:27 +0100
Message-ID: <20251229160730.435135109@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

commit 0edc78b82bea85e1b2165d8e870a5c3535919695 upstream.

Luigi reported that retriggering a posted MSI interrupt does not work
correctly.

The reason is that the retrigger happens at the vector domain by sending an
IPI to the actual vector on the target CPU. That works correctly exactly
once because the posted MSI interrupt chip does not issue an EOI as that's
only required for the posted MSI notification vector itself.

As a consequence the vector becomes stale in the ISR, which not only
affects this vector but also any lower priority vector in the affected
APIC because the ISR bit is not cleared.

Luigi proposed to set the vector in the remap PIR bitmap and raise the
posted MSI notification vector. That works, but that still does not cure a
related problem:

  If there is ever a stray interrupt on such a vector, then the related
  APIC ISR bit becomes stale due to the lack of EOI as described above.
  Unlikely to happen, but if it happens it's not debuggable at all.

So instead of playing games with the PIR, this can be actually solved
for both cases by:

 1) Keeping track of the posted interrupt vector handler state

 2) Implementing a posted MSI specific irq_ack() callback which checks that
    state. If the posted vector handler is inactive it issues an EOI,
    otherwise it delegates that to the posted handler.

This is correct versus affinity changes and concurrent events on the posted
vector as the actual handler invocation is serialized through the interrupt
descriptor lock.

Fixes: ed1e48ea4370 ("iommu/vt-d: Enable posted mode for device MSIs")
Reported-by: Luigi Rizzo <lrizzo@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Luigi Rizzo <lrizzo@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251125214631.044440658@linutronix.de
Closes: https://lore.kernel.org/lkml/20251124104836.3685533-1-lrizzo@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/irq_remapping.h |    7 +++++++
 arch/x86/kernel/irq.c                |   23 +++++++++++++++++++++++
 drivers/iommu/intel/irq_remapping.c  |    8 ++++----
 3 files changed, 34 insertions(+), 4 deletions(-)

--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -87,4 +87,11 @@ static inline void panic_if_irq_remap(co
 }
 
 #endif /* CONFIG_IRQ_REMAP */
+
+#ifdef CONFIG_X86_POSTED_MSI
+void intel_ack_posted_msi_irq(struct irq_data *irqd);
+#else
+#define intel_ack_posted_msi_irq	NULL
+#endif
+
 #endif /* __X86_IRQ_REMAPPING_H */
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -396,6 +396,7 @@ DEFINE_IDTENTRY_SYSVEC_SIMPLE(sysvec_kvm
 
 /* Posted Interrupt Descriptors for coalesced MSIs to be posted */
 DEFINE_PER_CPU_ALIGNED(struct pi_desc, posted_msi_pi_desc);
+static DEFINE_PER_CPU_CACHE_HOT(bool, posted_msi_handler_active);
 
 void intel_posted_msi_init(void)
 {
@@ -413,6 +414,25 @@ void intel_posted_msi_init(void)
 	this_cpu_write(posted_msi_pi_desc.ndst, destination);
 }
 
+void intel_ack_posted_msi_irq(struct irq_data *irqd)
+{
+	irq_move_irq(irqd);
+
+	/*
+	 * Handle the rare case that irq_retrigger() raised the actual
+	 * assigned vector on the target CPU, which means that it was not
+	 * invoked via the posted MSI handler below. In that case APIC EOI
+	 * is required as otherwise the ISR entry becomes stale and lower
+	 * priority interrupts are never going to be delivered after that.
+	 *
+	 * If the posted handler invoked the device interrupt handler then
+	 * the EOI would be premature because it would acknowledge the
+	 * posted vector.
+	 */
+	if (unlikely(!__this_cpu_read(posted_msi_handler_active)))
+		apic_eoi();
+}
+
 static __always_inline bool handle_pending_pir(unsigned long *pir, struct pt_regs *regs)
 {
 	unsigned long pir_copy[NR_PIR_WORDS];
@@ -445,6 +465,8 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_posted_msi
 
 	pid = this_cpu_ptr(&posted_msi_pi_desc);
 
+	/* Mark the handler active for intel_ack_posted_msi_irq() */
+	__this_cpu_write(posted_msi_handler_active, true);
 	inc_irq_stat(posted_msi_notification_count);
 	irq_enter();
 
@@ -473,6 +495,7 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_posted_msi
 
 	apic_eoi();
 	irq_exit();
+	__this_cpu_write(posted_msi_handler_active, false);
 	set_irq_regs(old_regs);
 }
 #endif /* X86_POSTED_MSI */
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -1303,17 +1303,17 @@ static struct irq_chip intel_ir_chip = {
  *	irq_enter();
  *		handle_edge_irq()
  *			irq_chip_ack_parent()
- *				irq_move_irq(); // No EOI
+ *				intel_ack_posted_msi_irq(); // No EOI
  *			handle_irq_event()
  *				driver_handler()
  *		handle_edge_irq()
  *			irq_chip_ack_parent()
- *				irq_move_irq(); // No EOI
+ *				intel_ack_posted_msi_irq(); // No EOI
  *			handle_irq_event()
  *				driver_handler()
  *		handle_edge_irq()
  *			irq_chip_ack_parent()
- *				irq_move_irq(); // No EOI
+ *				intel_ack_posted_msi_irq(); // No EOI
  *			handle_irq_event()
  *				driver_handler()
  *	apic_eoi()
@@ -1322,7 +1322,7 @@ static struct irq_chip intel_ir_chip = {
  */
 static struct irq_chip intel_ir_chip_post_msi = {
 	.name			= "INTEL-IR-POST",
-	.irq_ack		= irq_move_irq,
+	.irq_ack		= intel_ack_posted_msi_irq,
 	.irq_set_affinity	= intel_ir_set_affinity,
 	.irq_compose_msi_msg	= intel_ir_compose_msi_msg,
 	.irq_set_vcpu_affinity	= intel_ir_set_vcpu_affinity,


