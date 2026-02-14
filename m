Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B85020E334;
	Sat, 14 Feb 2026 00:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771030714; cv=none; b=ETUqDJ/+OBT0ibwGxugqJizamwFt8ol1neKw0Uyee2fLbn5sQuoqiQYGHtxzJciSQ98+dvf7zSNQ9/qDhJeu+q/Y5VolvEQW6/b4TrXBYcP1NbLkfD7kzPSikI2uAl2TdMjrUG/dY0peU/YiAjHexdQvVBHhToVw2y2L7rMr7xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771030714; c=relaxed/simple;
	bh=Fbguudayvr5/a8atI4mdtxwAWSlFxYIraPPOXe1sJ88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmuNyDykg3WYlcim5ZPEAJUDOXIiNumCmaazWWtTxVT+B4P8udACMdNt677WU3fUKa8Nd9hHFttcFu7891L+m/zAxoyY5ND4h0r4UdyOQlhWHITnUVmlbYW0zFx/jFuaW/hMSe7fHpw+glX/VqnnKDmdm3P2ondMI36/VK0W2cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FfAYDfaD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FfAYDfaD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F52C19424;
	Sat, 14 Feb 2026 00:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771030713;
	bh=Fbguudayvr5/a8atI4mdtxwAWSlFxYIraPPOXe1sJ88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FfAYDfaDrtDjmPTkhoEwGQc4K4nBSYKHRRf2EFllZ6YB7EJusBzPu9Cciz9h2oow9
	 c0k5OXIJWc3wo83R4csKqdQP1v2YEeY5Tk/oG42nRTWK/a3vBFQTXvxHAfqEZwdDjF
	 Z1rHenOIBJYoQhNXRblwA0xr8vEhvNrXN7OHlIL2tz2zhNYIw8a9u7vMZGnKT554Tv
	 LObS6laFcKSsDehiRDGIHAzQPYLqlYOBtXc/vxdgaCxk8t6IebjMafzUyAbMaYf3Oc
	 mLbGnF36oYStG2hHeBoRwIth0mf0IDP00bbbmILFZph4ucOlOpvnYkxvG5Nd8GBo0l
	 WYPVjBEa3sJ+A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Prathamesh Shete <pshete@nvidia.com>,
	Petlozu Pravareshwar <petlozup@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	thierry.reding@gmail.com,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	rostedt@goodmis.org,
	ulf.hansson@linaro.org,
	chleroy@kernel.org,
	jirislaby@kernel.org,
	yelangyan@huaqin.corp-partner.google.com,
	linux-tegra@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.19] soc/tegra: pmc: Fix unsafe generic_handle_irq() call
Date: Fri, 13 Feb 2026 19:58:09 -0500
Message-ID: <20260214005825.3665084-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214005825.3665084-1-sashal@kernel.org>
References: <20260214005825.3665084-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Prathamesh Shete <pshete@nvidia.com>

[ Upstream commit e6d96073af681780820c94079b978474a8a44413 ]

Currently, when resuming from system suspend on Tegra platforms,
the following warning is observed:

WARNING: CPU: 0 PID: 14459 at kernel/irq/irqdesc.c:666
Call trace:
 handle_irq_desc+0x20/0x58 (P)
 tegra186_pmc_wake_syscore_resume+0xe4/0x15c
 syscore_resume+0x3c/0xb8
 suspend_devices_and_enter+0x510/0x540
 pm_suspend+0x16c/0x1d8

The warning occurs because generic_handle_irq() is being called from
a non-interrupt context which is considered as unsafe.

Fix this warning by deferring generic_handle_irq() call to an IRQ work
which gets executed in hard IRQ context where generic_handle_irq()
can be called safely.

When PREEMPT_RT kernels are used, regular IRQ work (initialized with
init_irq_work) is deferred to run in per-CPU kthreads in preemptible
context rather than hard IRQ context. Hence, use the IRQ_WORK_INIT_HARD
variant so that with PREEMPT_RT kernels, the IRQ work is processed in
hardirq context instead of being deferred to a thread which is required
for calling generic_handle_irq().

On non-PREEMPT_RT kernels, both init_irq_work() and IRQ_WORK_INIT_HARD()
execute in IRQ context, so this change has no functional impact for
standard kernel configurations.

Signed-off-by: Petlozu Pravareshwar <petlozup@nvidia.com>
Signed-off-by: Prathamesh Shete <pshete@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
[treding@nvidia.com: miscellaneous cleanups]
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Complete Analysis

### 1. COMMIT MESSAGE ANALYSIS

**Subject**: "soc/tegra: pmc: Fix unsafe generic_handle_irq() call"

The commit message is unambiguous - it's fixing a **real, observable
WARNING** during system resume on Tegra platforms. The warning backtrace
is included:

```
WARNING: CPU: 0 PID: 14459 at kernel/irq/irqdesc.c:666
Call trace:
 handle_irq_desc+0x20/0x58 (P)
 tegra186_pmc_wake_syscore_resume+0xe4/0x15c
 syscore_resume+0x3c/0xb8
 suspend_devices_and_enter+0x510/0x540
 pm_suspend+0x16c/0x1d8
```

The fix has been **Reviewed-by** and **Tested-by** Jon Hunter (NVIDIA
kernel engineer), and authored by NVIDIA engineers who are experts on
Tegra PMC.

### 2. CODE CHANGE ANALYSIS - The Bug

**Root cause**: `tegra186_pmc_wake_syscore_resume()` is called by
`syscore_resume()` during system resume. Looking at `syscore_resume()`
in `drivers/base/syscore.c:93-110`:

```c
void syscore_resume(void)
{
    WARN_ONCE(!irqs_disabled(), ...);
    list_for_each_entry(syscore, &syscore_list, node)
        if (syscore->ops->resume)
            syscore->ops->resume(syscore->data);
}
```

This runs with **interrupts disabled** but **NOT in hard IRQ context**
(i.e., `in_hardirq()` returns false). However, when
`generic_handle_irq()` is called, it goes through `handle_irq_desc()`
(in `kernel/irq/irqdesc.c:658-671`):

```c
int handle_irq_desc(struct irq_desc *desc)
{
    data = irq_desc_get_irq_data(desc);
    if (WARN_ON_ONCE(!in_hardirq() &&
irqd_is_handle_enforce_irqctx(data)))
        return -EPERM;
    generic_handle_irq_desc(desc);
    return 0;
}
```

The ARM GIC v2 and GIC v3 interrupt controllers **set
`IRQD_HANDLE_ENFORCE_IRQCTX` on ALL interrupts** they map (confirmed in
`drivers/irqchip/irq-gic.c:1077` and `drivers/irqchip/irq-
gic-v3.c:1585`). Since Tegra SoCs use ARM GIC, any IRQ going through the
Tegra wake domain will have this flag set. Thus, calling
`generic_handle_irq()` from the syscore resume context (not hard IRQ)
triggers the `WARN_ON_ONCE`.

**Why it matters**: Beyond the WARN, the function returns `-EPERM`
without actually handling the interrupt. This means **edge-triggered
wake IRQs are silently dropped**, potentially causing missed wakeup
events and device misbehavior after resume.

### 3. THE FIX

The fix:
1. Adds `struct irq_work wake_work` and `u32 *wake_status` fields to
   `struct tegra_pmc`
2. Creates a new `tegra186_pmc_wake_handler()` function (the IRQ work
   handler) that contains the logic previously in
   `tegra186_pmc_process_wake_events()`
3. `tegra186_pmc_wake_syscore_resume()` now saves wake status to
   `pmc->wake_status[]` and queues the IRQ work via `irq_work_queue()`
4. The IRQ work handler runs in **hard IRQ context** where
   `generic_handle_irq()` is safe
5. Uses `IRQ_WORK_INIT_HARD()` to ensure hard IRQ context even on
   `PREEMPT_RT` kernels
6. Adds a check in `tegra186_pmc_wake_syscore_suspend()` for unhandled
   wake IRQs

This is the **correct** fix pattern - using `irq_work` to defer IRQ
handling to hard IRQ context is a well-established kernel pattern.
Multiple other drivers have been fixed similarly (see commits
`94ec234a16cf3`, `118c3ba24d04f`, `c6a91405ac5cd`, `f285de79569f9`,
`f460c70125bcb` which all converted to `generic_handle_irq_safe()`).

### 4. DEPENDENCY ANALYSIS

**Critical dependency**: This commit was written against the v6.19 tree
which has the new `struct syscore` API from commit `a97fbc3ee3e2a`
(v6.19-rc1 only). In stable trees (v6.6, v6.12), the functions use the
old `struct syscore_ops` interface:
- `tegra186_pmc_wake_syscore_resume(void)` (no `void *data` parameter)
- `tegra186_pmc_wake_syscore_suspend(void)` (no `void *data` parameter)
- `struct syscore_ops syscore` (not `struct syscore`)

**However**, the core fix logic (adding `irq_work`, deferring
`generic_handle_irq()`) does NOT depend on the syscore API change. The
fix can be backported with minor adaptation:
- The function signatures need to match the old `syscore_ops` callbacks
  (no `void *data`)
- `IRQ_WORK_INIT_HARD` and `irq_work_queue` are available in v6.6+
- The `irq_work` and `wake_status` additions to `struct tegra_pmc` are
  self-contained

**Affected stable trees**: v6.6.y, v6.12.y (and any other active stable
tree based on v6.2+, since commit `0474cc8489bda` introduced the buggy
code in v6.2).

### 5. SCOPE AND RISK

- **Files changed**: 1 file (`drivers/soc/tegra/pmc.c`)
- **Lines**: ~+60, ~-30 (net ~30 lines added)
- **Subsystem**: Tegra SoC PMC - a self-contained platform driver
- **Risk**: LOW - The change only affects Tegra platforms with wake
  events. The `irq_work` mechanism is well-tested kernel infrastructure.
  The fix has been reviewed and tested by NVIDIA engineers.
- **Regression risk**: Very low - non-Tegra systems are unaffected. The
  new code path is functionally equivalent but executes in the correct
  context.

### 6. USER IMPACT

- **Who**: All users of NVIDIA Tegra186+ SoCs (Tegra186, Tegra194,
  Tegra234) using suspend/resume
- **Severity**: Every system resume triggers a kernel WARNING. Beyond
  the warning itself, edge-triggered wake IRQs may be silently dropped
  because `handle_irq_desc()` returns `-EPERM` without processing the
  interrupt
- **Real-world**: Tegra platforms are used in NVIDIA Jetson embedded
  systems, automotive platforms, and gaming devices (Nintendo Switch)

### 7. CONCLUSION

This is a clear bug fix for a real, reproducible issue that fires on
every resume on affected hardware. The fix uses a well-established
kernel pattern (irq_work) and is self-contained within a single platform
driver file. It has been reviewed and tested by the subsystem
maintainers. The fix will need minor adaptation for stable trees
(different `syscore_ops` API), but the core logic is fully applicable.
The bug exists in all stable trees from v6.2 onward.

**YES**

 drivers/soc/tegra/pmc.c | 104 ++++++++++++++++++++++++++++------------
 1 file changed, 74 insertions(+), 30 deletions(-)

diff --git a/drivers/soc/tegra/pmc.c b/drivers/soc/tegra/pmc.c
index f3760a3b3026d..407fa840814c3 100644
--- a/drivers/soc/tegra/pmc.c
+++ b/drivers/soc/tegra/pmc.c
@@ -28,6 +28,7 @@
 #include <linux/iopoll.h>
 #include <linux/irqdomain.h>
 #include <linux/irq.h>
+#include <linux/irq_work.h>
 #include <linux/kernel.h>
 #include <linux/of_address.h>
 #include <linux/of_clk.h>
@@ -468,6 +469,10 @@ struct tegra_pmc {
 	unsigned long *wake_sw_status_map;
 	unsigned long *wake_cntrl_level_map;
 	struct syscore syscore;
+
+	/* Pending wake IRQ processing */
+	struct irq_work wake_work;
+	u32 *wake_status;
 };
 
 static struct tegra_pmc *pmc = &(struct tegra_pmc) {
@@ -1905,6 +1910,50 @@ static int tegra_pmc_parse_dt(struct tegra_pmc *pmc, struct device_node *np)
 	return 0;
 }
 
+/* translate sc7 wake sources back into IRQs to catch edge triggered wakeups */
+static void tegra186_pmc_wake_handler(struct irq_work *work)
+{
+	struct tegra_pmc *pmc = container_of(work, struct tegra_pmc, wake_work);
+	unsigned int i, wake;
+
+	for (i = 0; i < pmc->soc->max_wake_vectors; i++) {
+		unsigned long status = pmc->wake_status[i];
+
+		for_each_set_bit(wake, &status, 32) {
+			irq_hw_number_t hwirq = wake + (i * 32);
+			struct irq_desc *desc;
+			unsigned int irq;
+
+			irq = irq_find_mapping(pmc->domain, hwirq);
+			if (!irq) {
+				dev_warn(pmc->dev,
+					 "No IRQ found for WAKE#%lu!\n",
+					 hwirq);
+				continue;
+			}
+
+			dev_dbg(pmc->dev,
+				"Resume caused by WAKE#%lu mapped to IRQ#%u\n",
+				hwirq, irq);
+
+			desc = irq_to_desc(irq);
+			if (!desc) {
+				dev_warn(pmc->dev,
+					 "No descriptor found for IRQ#%u\n",
+					 irq);
+				continue;
+			}
+
+			if (!desc->action || !desc->action->name)
+				continue;
+
+			generic_handle_irq(irq);
+		}
+
+		pmc->wake_status[i] = 0;
+	}
+}
+
 static int tegra_pmc_init(struct tegra_pmc *pmc)
 {
 	if (pmc->soc->max_wake_events > 0) {
@@ -1923,6 +1972,18 @@ static int tegra_pmc_init(struct tegra_pmc *pmc)
 		pmc->wake_cntrl_level_map = bitmap_zalloc(pmc->soc->max_wake_events, GFP_KERNEL);
 		if (!pmc->wake_cntrl_level_map)
 			return -ENOMEM;
+
+		pmc->wake_status = kcalloc(pmc->soc->max_wake_vectors, sizeof(u32), GFP_KERNEL);
+		if (!pmc->wake_status)
+			return -ENOMEM;
+
+		/*
+		 * Initialize IRQ work for processing wake IRQs. Must use
+		 * HARD_IRQ variant to run in hard IRQ context on PREEMPT_RT
+		 * because we call generic_handle_irq() which requires hard
+		 * IRQ context.
+		 */
+		pmc->wake_work = IRQ_WORK_INIT_HARD(tegra186_pmc_wake_handler);
 	}
 
 	if (pmc->soc->init)
@@ -3129,47 +3190,30 @@ static void wke_clear_wake_status(struct tegra_pmc *pmc)
 	}
 }
 
-/* translate sc7 wake sources back into IRQs to catch edge triggered wakeups */
-static void tegra186_pmc_process_wake_events(struct tegra_pmc *pmc, unsigned int index,
-					     unsigned long status)
-{
-	unsigned int wake;
-
-	dev_dbg(pmc->dev, "Wake[%d:%d]  status=%#lx\n", (index * 32) + 31, index * 32, status);
-
-	for_each_set_bit(wake, &status, 32) {
-		irq_hw_number_t hwirq = wake + 32 * index;
-		struct irq_desc *desc;
-		unsigned int irq;
-
-		irq = irq_find_mapping(pmc->domain, hwirq);
-
-		desc = irq_to_desc(irq);
-		if (!desc || !desc->action || !desc->action->name) {
-			dev_dbg(pmc->dev, "Resume caused by WAKE%ld, IRQ %d\n", hwirq, irq);
-			continue;
-		}
-
-		dev_dbg(pmc->dev, "Resume caused by WAKE%ld, %s\n", hwirq, desc->action->name);
-		generic_handle_irq(irq);
-	}
-}
-
 static void tegra186_pmc_wake_syscore_resume(void *data)
 {
-	u32 status, mask;
 	unsigned int i;
+	u32 mask;
 
 	for (i = 0; i < pmc->soc->max_wake_vectors; i++) {
 		mask = readl(pmc->wake + WAKE_AOWAKE_TIER2_ROUTING(i));
-		status = readl(pmc->wake + WAKE_AOWAKE_STATUS_R(i)) & mask;
-
-		tegra186_pmc_process_wake_events(pmc, i, status);
+		pmc->wake_status[i] = readl(pmc->wake + WAKE_AOWAKE_STATUS_R(i)) & mask;
 	}
+
+	/* Schedule IRQ work to process wake IRQs (if any) */
+	irq_work_queue(&pmc->wake_work);
 }
 
 static int tegra186_pmc_wake_syscore_suspend(void *data)
 {
+	unsigned int i;
+
+	/* Check if there are unhandled wake IRQs */
+	for (i = 0; i < pmc->soc->max_wake_vectors; i++)
+		if (pmc->wake_status[i])
+			dev_warn(pmc->dev,
+				 "Unhandled wake IRQs pending vector[%u]: 0x%x\n",
+				 i, pmc->wake_status[i]);
 	wke_read_sw_wake_status(pmc);
 
 	/* flip the wakeup trigger for dual-edge triggered pads
-- 
2.51.0

