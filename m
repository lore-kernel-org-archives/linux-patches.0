Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD04B1EB9F2;
	Mon, 23 Mar 2026 14:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275220; cv=none; b=TdJbzVgpB+ysK555VK3KXkc18O6wmsTRngFp59tENJBIuHj/Em8pDcqfknrmaZBem99MQ+slNAnPYTFHYYGGqHSidNqNRwa8HcLq592QzeXtLrEJp0nj8mYLivfQq38PpK5wf93KXdRegI4CKYXZ/VZBk0UY2QRQtr5i+XnoI7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275220; c=relaxed/simple;
	bh=zB1/bYfpLK0+5oADa9puVQWysDGPzAdasDMwEOivdqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZP5tC1oWfpdcWOlAhkVGk/0LX+jG/o0CDgZD+5s7qC4bi3sWfD7Wooi759f8bF7oba5hLswTiR92ddNHDLsYHg2hrWAAl45zUAFX1iB7JNJj268cF1P3tjDOg8NK3Od+3nOVL23285VuJjdnXLM0QOxKgtl+3Dr55tIVh/8fxME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P6sf0H9n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P6sf0H9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22BD9C4CEF7;
	Mon, 23 Mar 2026 14:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275220;
	bh=zB1/bYfpLK0+5oADa9puVQWysDGPzAdasDMwEOivdqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P6sf0H9nP5woTkva888MpQGgy53hdWMy/Tc75rSpXmgYge9BZoKnuAHvVHFNeDU1T
	 AyCqCTT1SXoO4fPROat7qqDd2uEIoBfLy7wx5E6z/smiDf4ektMHU+14A919KyzCfk
	 FWObe1kiDy1OTwB64bOOnT4D2l8Wn51cGrZMirYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eliav Farber <farbere@amazon.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/460] kexec: Consolidate machine_kexec_mask_interrupts() implementation
Date: Mon, 23 Mar 2026 14:40:13 +0100
Message-ID: <20260323134527.084575420@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliav Farber <farbere@amazon.com>

[ Upstream commit bad6722e478f5b17a5ceb039dfb4c680cf2c0b48 ]

Consolidate the machine_kexec_mask_interrupts implementation into a common
function located in a new file: kernel/irq/kexec.c. This removes duplicate
implementations from architecture-specific files in arch/arm, arch/arm64,
arch/powerpc, and arch/riscv, reducing code duplication and improving
maintainability.

The new implementation retains architecture-specific behavior for
CONFIG_GENERIC_IRQ_KEXEC_CLEAR_VM_FORWARD, which was previously implemented
for ARM64. When enabled (currently for ARM64), it clears the active state
of interrupts forwarded to virtual machines (VMs) before handling other
interrupt masking operations.

Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20241204142003.32859-2-farbere@amazon.com
Stable-dep-of: 20197b967a6a ("powerpc/kexec/core: use big-endian types for crash variables")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/machine_kexec.c   | 23 ------------------
 arch/arm64/Kconfig                |  1 +
 arch/arm64/kernel/machine_kexec.c | 31 ------------------------
 arch/powerpc/include/asm/kexec.h  |  1 -
 arch/powerpc/kexec/core.c         | 22 -----------------
 arch/powerpc/kexec/core_32.c      |  1 +
 arch/riscv/kernel/machine_kexec.c | 23 ------------------
 include/linux/irq.h               |  3 +++
 kernel/irq/Kconfig                |  6 +++++
 kernel/irq/Makefile               |  2 +-
 kernel/irq/kexec.c                | 40 +++++++++++++++++++++++++++++++
 11 files changed, 52 insertions(+), 101 deletions(-)
 create mode 100644 kernel/irq/kexec.c

diff --git a/arch/arm/kernel/machine_kexec.c b/arch/arm/kernel/machine_kexec.c
index 80ceb5bd2680b..dd430477e7c13 100644
--- a/arch/arm/kernel/machine_kexec.c
+++ b/arch/arm/kernel/machine_kexec.c
@@ -127,29 +127,6 @@ void crash_smp_send_stop(void)
 	cpus_stopped = 1;
 }
 
-static void machine_kexec_mask_interrupts(void)
-{
-	unsigned int i;
-	struct irq_desc *desc;
-
-	for_each_irq_desc(i, desc) {
-		struct irq_chip *chip;
-
-		chip = irq_desc_get_chip(desc);
-		if (!chip)
-			continue;
-
-		if (chip->irq_eoi && irqd_irq_inprogress(&desc->irq_data))
-			chip->irq_eoi(&desc->irq_data);
-
-		if (chip->irq_mask)
-			chip->irq_mask(&desc->irq_data);
-
-		if (chip->irq_disable && !irqd_irq_disabled(&desc->irq_data))
-			chip->irq_disable(&desc->irq_data);
-	}
-}
-
 void machine_crash_shutdown(struct pt_regs *regs)
 {
 	local_irq_disable();
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 0e2902f38e70e..f487c5e21e2f1 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -146,6 +146,7 @@ config ARM64
 	select GENERIC_IDLE_POLL_SETUP
 	select GENERIC_IOREMAP
 	select GENERIC_IRQ_IPI
+	select GENERIC_IRQ_KEXEC_CLEAR_VM_FORWARD
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IRQ_SHOW_LEVEL
diff --git a/arch/arm64/kernel/machine_kexec.c b/arch/arm64/kernel/machine_kexec.c
index 82e2203d86a31..6f121a0164a48 100644
--- a/arch/arm64/kernel/machine_kexec.c
+++ b/arch/arm64/kernel/machine_kexec.c
@@ -207,37 +207,6 @@ void machine_kexec(struct kimage *kimage)
 	BUG(); /* Should never get here. */
 }
 
-static void machine_kexec_mask_interrupts(void)
-{
-	unsigned int i;
-	struct irq_desc *desc;
-
-	for_each_irq_desc(i, desc) {
-		struct irq_chip *chip;
-		int ret;
-
-		chip = irq_desc_get_chip(desc);
-		if (!chip)
-			continue;
-
-		/*
-		 * First try to remove the active state. If this
-		 * fails, try to EOI the interrupt.
-		 */
-		ret = irq_set_irqchip_state(i, IRQCHIP_STATE_ACTIVE, false);
-
-		if (ret && irqd_irq_inprogress(&desc->irq_data) &&
-		    chip->irq_eoi)
-			chip->irq_eoi(&desc->irq_data);
-
-		if (chip->irq_mask)
-			chip->irq_mask(&desc->irq_data);
-
-		if (chip->irq_disable && !irqd_irq_disabled(&desc->irq_data))
-			chip->irq_disable(&desc->irq_data);
-	}
-}
-
 /**
  * machine_crash_shutdown - shutdown non-crashing cpus and save registers
  */
diff --git a/arch/powerpc/include/asm/kexec.h b/arch/powerpc/include/asm/kexec.h
index 270ee93a0f7d8..601e569303e1b 100644
--- a/arch/powerpc/include/asm/kexec.h
+++ b/arch/powerpc/include/asm/kexec.h
@@ -61,7 +61,6 @@ struct pt_regs;
 extern void kexec_smp_wait(void);	/* get and clear naca physid, wait for
 					  master to copy new code to 0 */
 extern void default_machine_kexec(struct kimage *image);
-extern void machine_kexec_mask_interrupts(void);
 
 void relocate_new_kernel(unsigned long indirection_page, unsigned long reboot_code_buffer,
 			 unsigned long start_address) __noreturn;
diff --git a/arch/powerpc/kexec/core.c b/arch/powerpc/kexec/core.c
index b8333a49ea5da..58a930a47422b 100644
--- a/arch/powerpc/kexec/core.c
+++ b/arch/powerpc/kexec/core.c
@@ -22,28 +22,6 @@
 #include <asm/setup.h>
 #include <asm/firmware.h>
 
-void machine_kexec_mask_interrupts(void) {
-	unsigned int i;
-	struct irq_desc *desc;
-
-	for_each_irq_desc(i, desc) {
-		struct irq_chip *chip;
-
-		chip = irq_desc_get_chip(desc);
-		if (!chip)
-			continue;
-
-		if (chip->irq_eoi && irqd_irq_inprogress(&desc->irq_data))
-			chip->irq_eoi(&desc->irq_data);
-
-		if (chip->irq_mask)
-			chip->irq_mask(&desc->irq_data);
-
-		if (chip->irq_disable && !irqd_irq_disabled(&desc->irq_data))
-			chip->irq_disable(&desc->irq_data);
-	}
-}
-
 #ifdef CONFIG_CRASH_DUMP
 void machine_crash_shutdown(struct pt_regs *regs)
 {
diff --git a/arch/powerpc/kexec/core_32.c b/arch/powerpc/kexec/core_32.c
index c95f96850c9e1..deb28eb44f30f 100644
--- a/arch/powerpc/kexec/core_32.c
+++ b/arch/powerpc/kexec/core_32.c
@@ -7,6 +7,7 @@
  * Copyright (C) 2005 IBM Corporation.
  */
 
+#include <linux/irq.h>
 #include <linux/kexec.h>
 #include <linux/mm.h>
 #include <linux/string.h>
diff --git a/arch/riscv/kernel/machine_kexec.c b/arch/riscv/kernel/machine_kexec.c
index 3c830a6f7ef46..2306ce3e5f229 100644
--- a/arch/riscv/kernel/machine_kexec.c
+++ b/arch/riscv/kernel/machine_kexec.c
@@ -114,29 +114,6 @@ void machine_shutdown(void)
 #endif
 }
 
-static void machine_kexec_mask_interrupts(void)
-{
-	unsigned int i;
-	struct irq_desc *desc;
-
-	for_each_irq_desc(i, desc) {
-		struct irq_chip *chip;
-
-		chip = irq_desc_get_chip(desc);
-		if (!chip)
-			continue;
-
-		if (chip->irq_eoi && irqd_irq_inprogress(&desc->irq_data))
-			chip->irq_eoi(&desc->irq_data);
-
-		if (chip->irq_mask)
-			chip->irq_mask(&desc->irq_data);
-
-		if (chip->irq_disable && !irqd_irq_disabled(&desc->irq_data))
-			chip->irq_disable(&desc->irq_data);
-	}
-}
-
 /*
  * machine_crash_shutdown - Prepare to kexec after a kernel crash
  *
diff --git a/include/linux/irq.h b/include/linux/irq.h
index fa711f80957b6..25f51bf3c351f 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -694,6 +694,9 @@ extern int irq_chip_request_resources_parent(struct irq_data *data);
 extern void irq_chip_release_resources_parent(struct irq_data *data);
 #endif
 
+/* Disable or mask interrupts during a kernel kexec */
+extern void machine_kexec_mask_interrupts(void);
+
 /* Handling of unhandled and spurious interrupts: */
 extern void note_interrupt(struct irq_desc *desc, irqreturn_t action_ret);
 
diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index 529adb1f58593..875f25ed6f710 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -141,6 +141,12 @@ config GENERIC_IRQ_DEBUGFS
 
 	  If you don't know what to do here, say N.
 
+# Clear forwarded VM interrupts during kexec.
+# This option ensures the kernel clears active states for interrupts
+# forwarded to virtual machines (VMs) during a machine kexec.
+config GENERIC_IRQ_KEXEC_CLEAR_VM_FORWARD
+	bool
+
 endmenu
 
 config GENERIC_IRQ_MULTI_HANDLER
diff --git a/kernel/irq/Makefile b/kernel/irq/Makefile
index f19d3080bf11a..c0f44c06d69df 100644
--- a/kernel/irq/Makefile
+++ b/kernel/irq/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-obj-y := irqdesc.o handle.o manage.o spurious.o resend.o chip.o dummychip.o devres.o
+obj-y := irqdesc.o handle.o manage.o spurious.o resend.o chip.o dummychip.o devres.o kexec.o
 obj-$(CONFIG_IRQ_TIMINGS) += timings.o
 ifeq ($(CONFIG_TEST_IRQ_TIMINGS),y)
 	CFLAGS_timings.o += -DDEBUG
diff --git a/kernel/irq/kexec.c b/kernel/irq/kexec.c
new file mode 100644
index 0000000000000..0f9548c1708dd
--- /dev/null
+++ b/kernel/irq/kexec.c
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/irqdesc.h>
+#include <linux/irqnr.h>
+
+#include "internals.h"
+
+void machine_kexec_mask_interrupts(void)
+{
+	struct irq_desc *desc;
+	unsigned int i;
+
+	for_each_irq_desc(i, desc) {
+		struct irq_chip *chip;
+		int check_eoi = 1;
+
+		chip = irq_desc_get_chip(desc);
+		if (!chip)
+			continue;
+
+		if (IS_ENABLED(CONFIG_GENERIC_IRQ_KEXEC_CLEAR_VM_FORWARD)) {
+			/*
+			 * First try to remove the active state from an interrupt which is forwarded
+			 * to a VM. If the interrupt is not forwarded, try to EOI the interrupt.
+			 */
+			check_eoi = irq_set_irqchip_state(i, IRQCHIP_STATE_ACTIVE, false);
+		}
+
+		if (check_eoi && chip->irq_eoi && irqd_irq_inprogress(&desc->irq_data))
+			chip->irq_eoi(&desc->irq_data);
+
+		if (chip->irq_mask)
+			chip->irq_mask(&desc->irq_data);
+
+		if (chip->irq_disable && !irqd_irq_disabled(&desc->irq_data))
+			chip->irq_disable(&desc->irq_data);
+	}
+}
-- 
2.51.0



