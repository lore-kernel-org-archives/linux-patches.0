Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7D11F0995;
	Thu, 12 Feb 2026 01:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770858631; cv=none; b=IrITu1b7wGTU8JNUJLM8+b5RMHw3ikstEUp7Y9o09iw01uP4eFlA5xNW5CV58Qm6mUWHWGvkIw+gww4+pNLYfKKwAw0JEKUY1Sw3s8NwfeEf+aJgESh865btA0q7v1CVYFT24xtmvbkamwOt3unHuJk7+u9hx8LtkCfSqb8zJGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770858631; c=relaxed/simple;
	bh=7fS8DbbI9q6WGNP9aei1xHrTmn5Ib3i+d78ooTbcE3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J9XLc0BKVXjn4WE3Fy+SGoyVi7XRzfw/dgBUtaSIqePB/VjGJpXzIw1Ad6cfvwp03sbvoXHNPP3PeF15pLIimbO7IdRyUqAhi7r519KMu4QLh+2S05HNMxAsRL56i99D+ZwqXNjwOKt/WmJPMqUsk91DrYabCYEPhhWC3xp8AYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ST01HzW7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ST01HzW7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015E0C16AAE;
	Thu, 12 Feb 2026 01:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770858631;
	bh=7fS8DbbI9q6WGNP9aei1xHrTmn5Ib3i+d78ooTbcE3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ST01HzW7L6hpwQnAWJjtiVrQTeAtv3+se0/XztnWY+TiRnM7RGnVXan226hU78eV2
	 rv8H3v67ga9ZKZerHVNjGibJt/ZduA3QaRrrZydZlykt50g84/1f9srfq/yckLZNt5
	 5ft2OopN3Mm0R8KkX3DZ20F7R7aWHxRB/Bd5hg0virqPXpyQKeBOE3Jk7OBkxtL4IN
	 go1Lw9NzSwFSQV11EypoqQalb9PCVz0c8uMCkdnPfkkwaL+eq3Cc+QL5YzOdY5qRSu
	 YHa/qfKm0GucjN1X0c08MLG7pWtUvdXFi12Y8KbiWRF0LH7v/cR2R2shdZuGJeALVH
	 e25v3+xKNGySg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nick Hu <nick.hu@sifive.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Cyan Yang <cyan.yang@sifive.com>,
	Anup Patel <anup@brainfault.org>,
	Nutty Liu <liujingqi@lanxincomputing.com>,
	Sasha Levin <sashal@kernel.org>,
	tglx@kernel.org,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] irqchip/riscv-imsic: Add a CPU pm notifier to restore the IMSIC on exit
Date: Wed, 11 Feb 2026 20:09:44 -0500
Message-ID: <20260212010955.3480391-21-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260212010955.3480391-1-sashal@kernel.org>
References: <20260212010955.3480391-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nick Hu <nick.hu@sifive.com>

[ Upstream commit f48b4bd0915bf61ac12b8c65c7939ebd03bc8abf ]

The IMSIC might be reset when the system enters a low power state, but on
exit nothing restores the registers, which prevents interrupt delivery.

Solve this by registering a CPU power management notifier, which restores
the IMSIC on exit.

Signed-off-by: Nick Hu <nick.hu@sifive.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Reviewed-by: Cyan Yang <cyan.yang@sifive.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Nutty Liu <liujingqi@lanxincomputing.com>
Link: https://patch.msgid.link/20251202-preserve-aplic-imsic-v3-1-1844fbf1fe92@sifive.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a comprehensive understanding. Let me summarize the analysis.

---

## Detailed Analysis

### 1. Commit Message Analysis

The commit message is clear and directly describes a **bug fix**: "The
IMSIC might be reset when the system enters a low power state, but on
exit nothing restores the registers, which prevents interrupt delivery."
This is unambiguous — without the fix, **interrupt delivery is broken**
after returning from a low power state.

The patch is from Nick Hu at SiFive (a major RISC-V silicon vendor),
signed-off by Thomas Gleixner (the overall irqchip maintainer), and
reviewed by:
- Anup Patel (original IMSIC driver author/maintainer at Ventana Micro)
- Yong-Xuan Wang, Cyan Yang (SiFive reviewers)
- Nutty Liu (Lanxin Computing)

This level of review by domain experts demonstrates the fix is well-
vetted.

### 2. Code Change Analysis

The change is minimal (31 lines added, 8 removed, single file) and
consists of three logical parts:

**a) Refactoring — extracting `imsic_hw_states_init()`:**

The existing code from `imsic_starting_cpu()` that handles hardware
register initialization is moved into a new helper:

```126:147:drivers/irqchip/irq-riscv-imsic-early.c
static int imsic_starting_cpu(unsigned int cpu)
{
        /* Mark per-CPU IMSIC state as online */
        imsic_state_online();

        /* Enable per-CPU parent interrupt */
        enable_percpu_irq(imsic_parent_irq,
irq_get_trigger_type(imsic_parent_irq));

        /* Setup IPIs */
        imsic_ipi_starting_cpu();

        /*
  - Interrupts identities might have been enabled/disabled while
  - this CPU was not running so sync-up local enable/disable state.
         */
        imsic_local_sync_all(true);

        /* Enable local interrupt delivery */
        imsic_local_delivery(true);

        return 0;
}
```

The three operations (`imsic_ipi_starting_cpu()`,
`imsic_local_sync_all(true)`, `imsic_local_delivery(true)`) are
extracted into `imsic_hw_states_init()`, which is then called from both
`imsic_starting_cpu()` and the new PM notifier.

**b) Adding the CPU PM notifier:**

A new `imsic_pm_notifier` function handles `CPU_PM_EXIT` by calling
`imsic_hw_states_init()`. This is the **exact same pattern** used by
GICv3 (`irq-gic-v3.c:1482`) and GIC (`irq-gic.c`), which have been
stable for years.

**c) Registering the notifier:**

The `imsic_early_probe()` return is changed from `return 0` to `return
cpu_pm_register_notifier(&imsic_pm_notifier_block)`.

### 3. Bug Mechanism and Severity

**The bug**: On RISC-V systems with SBI-based cpuidle (the standard CPU
idle mechanism), when a CPU enters a deep idle state, the SBI firmware
may power down the IMSIC. The `cpuidle-riscv-sbi.c` driver calls
`cpu_pm_enter()` before and `cpu_pm_exit()` after the idle transition.
`cpu_pm_exit()` fires `CPU_PM_EXIT` notifications to all registered
handlers. Without this patch, no handler exists for IMSIC, so:

1. `imsic_local_delivery` — the EIDELIVERY/EITHRESHOLD CSRs may be
   reset, disabling all interrupt delivery
2. `imsic_local_sync_all` — individual interrupt enable bits may be
   reset, leaving all interrupt sources disabled
3. `imsic_ipi_starting_cpu` — the IPI enable bit may be reset, breaking
   inter-processor interrupts

**Impact**: The CPU effectively becomes deaf to all interrupts — IPIs,
device interrupts, timer interrupts routed through IMSIC — after
returning from a deep idle state. This can cause:
- System hangs (no timer interrupts)
- IPI failures (scheduler hangs, RCU stalls)
- Device interrupt loss (I/O failures, network timeouts)

This bug affects any RISC-V system using IMSIC with cpuidle deep states
— which includes SiFive boards and other production RISC-V hardware.

### 4. Dependency Check

The patch is **self-contained**. It depends only on:
- `imsic_ipi_starting_cpu()` — exists in all stable trees with IMSIC
  (6.12.y+)
- `imsic_local_sync_all()` — exists in all stable trees with IMSIC
  (6.12.y+)
- `imsic_local_delivery()` — exists in all stable trees with IMSIC
  (6.12.y+)
- `cpu_pm_register_notifier()` — exists in all kernel versions (core
  kernel PM API)
- `cpuidle-riscv-sbi.c` — exists in all stable trees with IMSIC, and
  calls `cpu_pm_enter()`/`cpu_pm_exit()`

The companion APLIC patch (95a8ddde36601) touches a different driver
entirely and is not a dependency.

### 5. Backport Applicability

- **IMSIC driver exists**: 6.12.y through 6.19.y (added in v6.10)
- **Clean backport**: The `imsic_starting_cpu` function is byte-
  identical between the mainline pre-image and 6.12.y. Only minor
  context conflict in the `#include` section (6.12.y lacks
  `<linux/export.h>` that mainline has), trivially resolved.
- **Bug triggerable**: The cpuidle-riscv-sbi driver in 6.12.y already
  calls `cpu_pm_enter()`/`cpu_pm_exit()`, meaning the IMSIC registers
  get reset with no restoration.

### 6. Risk Assessment

**Very low risk**:
- The refactored code (`imsic_hw_states_init`) performs exactly the same
  operations as before — just from an additional call site
- The GICv3 driver has used this exact pattern (CPU PM notifier
  restoring interrupt controller state) for over a decade
- No behavior changes to the existing CPU hotplug path
- Well-reviewed by all key stakeholders

### 7. Conclusion

This is a clear-cut bug fix for a critical issue: **complete loss of
interrupt delivery** after RISC-V CPUs return from deep idle states. The
fix is:
- Small and surgical (31 lines added to a single file)
- Based on a well-established pattern (identical to GICv3/GIC CPU PM
  handling)
- Thoroughly reviewed by domain experts
- Self-contained with no dependencies on other patches
- Cleanly backportable to all stable trees containing IMSIC (6.12.y+)

**YES**

 drivers/irqchip/irq-riscv-imsic-early.c | 39 ++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/irqchip/irq-riscv-imsic-early.c b/drivers/irqchip/irq-riscv-imsic-early.c
index 6bac67cc0b6d9..ba903fa689bd5 100644
--- a/drivers/irqchip/irq-riscv-imsic-early.c
+++ b/drivers/irqchip/irq-riscv-imsic-early.c
@@ -7,6 +7,7 @@
 #define pr_fmt(fmt) "riscv-imsic: " fmt
 #include <linux/acpi.h>
 #include <linux/cpu.h>
+#include <linux/cpu_pm.h>
 #include <linux/export.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
@@ -123,14 +124,8 @@ static void imsic_handle_irq(struct irq_desc *desc)
 	chained_irq_exit(chip, desc);
 }
 
-static int imsic_starting_cpu(unsigned int cpu)
+static void imsic_hw_states_init(void)
 {
-	/* Mark per-CPU IMSIC state as online */
-	imsic_state_online();
-
-	/* Enable per-CPU parent interrupt */
-	enable_percpu_irq(imsic_parent_irq, irq_get_trigger_type(imsic_parent_irq));
-
 	/* Setup IPIs */
 	imsic_ipi_starting_cpu();
 
@@ -142,6 +137,18 @@ static int imsic_starting_cpu(unsigned int cpu)
 
 	/* Enable local interrupt delivery */
 	imsic_local_delivery(true);
+}
+
+static int imsic_starting_cpu(unsigned int cpu)
+{
+	/* Mark per-CPU IMSIC state as online */
+	imsic_state_online();
+
+	/* Enable per-CPU parent interrupt */
+	enable_percpu_irq(imsic_parent_irq, irq_get_trigger_type(imsic_parent_irq));
+
+	/* Initialize the IMSIC registers to enable the interrupt delivery */
+	imsic_hw_states_init();
 
 	return 0;
 }
@@ -157,6 +164,22 @@ static int imsic_dying_cpu(unsigned int cpu)
 	return 0;
 }
 
+static int imsic_pm_notifier(struct notifier_block *self, unsigned long cmd, void *v)
+{
+	switch (cmd) {
+	case CPU_PM_EXIT:
+		/* Initialize the IMSIC registers to enable the interrupt delivery */
+		imsic_hw_states_init();
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block imsic_pm_notifier_block = {
+	.notifier_call = imsic_pm_notifier,
+};
+
 static int __init imsic_early_probe(struct fwnode_handle *fwnode)
 {
 	struct irq_domain *domain;
@@ -194,7 +217,7 @@ static int __init imsic_early_probe(struct fwnode_handle *fwnode)
 	cpuhp_setup_state(CPUHP_AP_IRQ_RISCV_IMSIC_STARTING, "irqchip/riscv/imsic:starting",
 			  imsic_starting_cpu, imsic_dying_cpu);
 
-	return 0;
+	return cpu_pm_register_notifier(&imsic_pm_notifier_block);
 }
 
 static int __init imsic_early_dt_init(struct device_node *node, struct device_node *parent)
-- 
2.51.0

