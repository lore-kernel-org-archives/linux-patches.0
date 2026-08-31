Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324A5576ECB;
	Mon, 31 Aug 2026 13:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184151; cv=none; b=dt9aGbxwMTlYxO2oXlbOsJqxV68HPWzSB3dpvpD0vsJyN2TKrhkTgwajPdrVdL23x4g/n7OiZwV/Y+P7QPGpkKKq0ZtKusM/A76mDOCjJdJuhcBG8RdxDL6c58VXlnZxmDJR9NZay696EVgZ1ZNBnDrBkLw5ObW9++NMF0aeK0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184151; c=relaxed/simple;
	bh=nxm8TCLe1NAIexoZGCss09KSBgvZckLa5mkKFBP8Ld8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gm3nZqOK/mO3GXR4smUVmatFu2iLn/Cbgbr0E8QGXP6mF80HIRnGwLKAYHnvwTUtOVvYglbBcQLbw/HYFFpKJGSIRqwtAufw6FA4XDxiUoKLKke1WRf6eN95c6asJ5wv5tkfprW/z9XcwfnyMQQQYW7eZ0r68bdA8S6O4vtHC/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ChqJJsUL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ChqJJsUL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E76D1F00ADF;
	Mon, 31 Aug 2026 13:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184148;
	bh=+2piEAl8TQwbISF+YrXVO7sQM3VsKs+x6fEO3ZYdErE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ChqJJsUL2nSBGLK0dITiqSnrQLoGn2pqNXrF6Q4RkZj/hG4NAg+tnK3YrvEOm1E/O
	 PTw/ji6NXP3NDi/julvstqk35fcRMckzGgZLcQmn9vgjqQpxSRWSv1SkZJKQsHUfIz
	 ddKFQ7TqZU65YS6pGxMlJhL5cIZKAIPJOLNdHxD//GRxXPbgWD8gkRAvUTj1mxm9op
	 czP+1cleHbMkmT3V9ZiviIBHkhH2GwfvmpEoP0C+toKXhssaApxHK+yutZu/w7LB/r
	 sA+Fn4CRnjioHcBdnLyJ+kGAE4UpiwBKj1aQxI99/GVVgrFB0d+ZF+QBT7dZq/+wDw
	 M5sqBr86qsA8g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Liang Hao <haohlliang@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	hoan@os.amperecomputing.com,
	linusw@kernel.org,
	brgl@kernel.org,
	linux-gpio@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] gpio: dwapb: Mask interrupts at hardware initialization
Date: Mon, 31 Aug 2026 09:29:08 -0400
Message-ID: <20260831133314.4125787-520-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liang Hao <haohlliang@gmail.com>

[ Upstream commit aaf7766ba3b99a3834319e7cf939838afc705574 ]

GPIO interrupts may retain stale state across warm reboots when
peripherals remain powered. If a GPIO line is not explicitly
configured for interrupts, this can result in interrupt storms
due to missing handlers.

Fix this by ensuring all interrupts are masked and disabled at
hardware initialization time via the init_hw() callback. Pending
interrupts are also cleared to start from a known-safe state.

Interrupts will be unmasked only when explicitly configured by
userspace or kernel drivers.

Signed-off-by: Liang Hao <haohlliang@gmail.com>
Link: https://patch.msgid.link/20260705074759.47863-1-haohlliang@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `gpio: dwapb: Mask interrupts at hardware
initialization`

**Local tree:** Linux **6.18.44** (`v6.18.44-1-g2736c32da98b9`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[gpio: dwapb]` `[Mask]` — Ensure GPIO interrupt hardware is
in a known-safe masked state during driver initialization.

### Step 1.2: Parse all commit message tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Link:**
  `https://patch.msgid.link/20260705074759.47863-1-haohlliang@gmail.com`
- **Cc: stable:** — not present (not a negative signal)
- **Signed-off-by:** Liang Hao `<haohlliang@gmail.com>` (author)
- **Signed-off-by:** Bartosz Golaszewski
  `<bartosz.golaszewski@oss.qualcomm.com>` (GPIO maintainer)

Notable: maintainer sign-off; no syzbot/fuzzer report; no explicit user
bug report in the message.

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** GPIO interrupt registers can retain stale enabled/unmasked
  state across warm reboots when the GPIO block stays powered.
- **Symptom:** Interrupt storms on lines not explicitly configured for
  interrupts, because hardware is firing but software has no proper
  handler setup for those lines.
- **Root cause:** Driver did not reset interrupt enable/mask/EOI
  registers at probe time.
- **Fix approach:** Add `init_hw` callback that disables all interrupts
  (`GPIO_INTEN=0`), masks all lines (`GPIO_INTMASK=0xffffffff`), and
  clears pending interrupts (`GPIO_PORTA_EOI=0xffffffff`) before the
  irqchip/domain is fully operational.
- **Version info:** none stated in the message.

### Step 1.4: Detect hidden bug fixes
**Record:** Not disguised as cleanup — this is an explicit hardware-init
bug fix. The failure mode (interrupt storm → potential soft lockup /
system unresponsiveness) is a real stability bug, not cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **Files:** `drivers/gpio/gpio-dwapb.c` only (+16 lines net)
- **Functions added/modified:**
  - New: `dwapb_irq_init_hw()`
  - Modified: `dwapb_configure_irqs()` (assigns `girq->init_hw`)
- **Scope:** Single-file, surgical driver fix.

### Step 2.2: Code flow change per hunk

**Hunk 1 — new `dwapb_irq_init_hw()`:**
- **Before:** No hardware interrupt reset at GPIO irqchip registration.
- **After:** On `gpiochip_add_data()`, gpiolib calls `init_hw` which
  writes:
  - `GPIO_INTEN = 0` (disable all interrupt enables)
  - `GPIO_INTMASK = 0xffffffff` (mask all lines)
  - `GPIO_PORTA_EOI = 0xffffffff` (clear all pending interrupts)

**Hunk 2 — `dwapb_configure_irqs()`:**
- **Before:** `girq->handler = handle_bad_irq`, `girq->default_type =
  IRQ_TYPE_NONE` only.
- **After:** Also sets `girq->init_hw = dwapb_irq_init_hw`.

**Execution path:** Driver probe → `dwapb_gpio_add_port()` →
`dwapb_configure_irqs()` → `devm_gpiochip_add_data()` →
`gpiochip_irqchip_init_hw()` → `dwapb_irq_init_hw()`.

### Step 2.3: Bug mechanism
**Record:** **Category (h): Hardware initialization / stale-state
workaround**

The DesignWare APB GPIO block does not reset interrupt state on warm
reboot if power is maintained. Without explicit masking at probe, lines
left enabled from a prior boot can assert interrupts continuously. The
driver sets `handle_bad_irq` as default handler, but unmasked hardware
interrupts on unconfigured lines can still flood the CPU with IRQ
activity.

The fix mirrors established patterns in other GPIO drivers (e.g. `gpio-
max77620.c` explicitly documents bootloader-left interrupts).

### Step 2.4: Fix quality assessment
**Record:**
- **Quality:** High — minimal, register writes match existing driver
  register definitions and irq enable/disable logic.
- **Regression risk:** Very low — interrupts are only unmasked later via
  `dwapb_irq_unmask()` / `dwapb_irq_enable()` when explicitly
  configured.
- **Minor nuance:** On ACPI platforms, `devm_request_irq()` in
  `dwapb_configure_irqs()` runs *before* `devm_gpiochip_add_data()`
  triggers `init_hw`. This is a pre-existing ordering characteristic;
  the fix still addresses the steady-state stale-hardware problem and is
  strictly better than no masking. Verified in current tree code at
  lines 484–566 of `gpio-dwapb.c`.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame changed lines
**Record:** `dwapb_configure_irqs()` and surrounding interrupt code
trace to `5d324e5159d9e` (v6.18 merge base in this tree). The driver and
interrupt path have been present since this tree's import; no `init_hw`
hook was ever set for dwapb in this tree.

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: File history for related changes
**Record:** Recent `gpio-dwapb.c` history in this tree:
- `5e15cf51982f8` gpio: dwapb: Defer clock gating until noirq
- `6c736c5ccf4a3` gpio: dwapb: reduce allocation to single kzalloc
- `d7b5497e0e45b` gpio: dwapb: Use modern PM macros

No related interrupt-init fix already present. Standalone patch, not
part of a series.

### Step 3.4: Author's other commits
**Record:** No commits by Liang Hao found in this tree's history (`git
log --author` returned empty). Author appears to be an external
contributor; patch carries GPIO maintainer SOB.

### Step 3.5: Prerequisites / dependencies
**Record:**
- **`init_hw` infrastructure:** Present in this tree —
  `include/linux/gpio/driver.h` defines `gpio_irq_chip::init_hw`;
  `gpiochip_irqchip_init_hw()` in `gpiolib.c` calls it during
  `gpiochip_add_data()` at line 1196.
- **No other commits required.** Patch is self-contained.
- **Can apply standalone:** Yes.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:** Attempted `b4 dig -c <commit>` — commit not in local tree
(not yet applied). Attempted lore fetch via WebFetch and curl — blocked
by Anubis bot protection. **Could not retrieve mailing list thread
content.**

### Step 4.2: Reviewers from b4 dig -w
**Record:** Not performed — commit hash unavailable locally; b4 requires
`-c COMMITISH`.

### Step 4.3: Bug report search
**Record:** No Reported-by or syzbot link in commit message. No external
bug report retrieved.

### Step 4.4: Related patches / series
**Record:** Appears to be a standalone 1-patch fix. No series indicators
in subject.

### Step 4.5: Stable mailing list history
**Record:** Not searchable due to lore access failure. No stable-list
discussion verified.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `dwapb_irq_init_hw()` (new), `dwapb_configure_irqs()`
(modified), called via `gpiochip_irqchip_init_hw()` in gpiolib.

### Step 5.2: Callers
**Record:**
- `dwapb_configure_irqs()` ← `dwapb_gpio_add_port()` ←
  `dwapb_gpio_probe()` (platform driver probe)
- `gpiochip_irqchip_init_hw()` ← `gpiochip_add_data()` ←
  `devm_gpiochip_add_data()`
- Probe runs at boot for all DesignWare APB GPIO instances (DT:
  `snps,dw-apb-gpio`; ACPI on Intel platforms per driver comment).

### Step 5.3: Callees
**Record:** `dwapb_write()` / `dwapb_read()` — MMIO register accessors
with v2 register offset remapping.

### Step 5.4: Call chain / reachability
**Record:** Triggered on every dwapb controller probe at boot (or module
load). Warm reboot with powered GPIO block is the specific failure
scenario. Affects embedded SoCs (RISC-V T-Head, Sophgo, many others in
DT) and Intel ACPI platforms using shared GPIO IRQ lanes.

### Step 5.5: Similar patterns
**Record:** Identical pattern already used in this tree by:
- `gpio-max77620.c` — "GPIO interrupts may be left ON after bootloader"
- `gpio-idt3243x.c` — masks all interrupts in `init_hw`
- `gpio-tangier.c` — clears edge-detect registers in `init_hw`

This is an established, maintainer-accepted GPIO subsystem pattern.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Does buggy code exist?
**Record:** **YES.** Current `gpio-dwapb.c` has no `dwapb_irq_init_hw`
and no `girq->init_hw` assignment. `dwapb_configure_irqs()` at lines
472–474 sets only `handler` and `default_type`. The driver has been
present in this tree without hardware interrupt masking at init.

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** File structure matches the patch
context exactly. `init_hw` callback and gpiolib support are present. No
conflicting changes identified.

### Step 6.3: Related fixes already present?
**Record:** **None.** `grep` for `dwapb_irq_init_hw` and `init_hw` in
`gpio-dwapb.c` returns no matches.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **drivers/gpio** — IMPORTANT. GPIO/IRQ infrastructure
affects many embedded and ACPI platforms. Interrupt storms are a system-
wide stability issue.

### Step 7.2: Subsystem activity
**Record:** Active — recent dwapb commits in 6.18.y (PM, allocation,
clock gating). Driver is maintained and in active use.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of DesignWare APB GPIO (`CONFIG_GPIO_DWAPB`) on
platforms where the GPIO block retains power across warm reboot —
embedded SoCs, Intel ACPI systems with shared GPIO IRQ lanes. Config-
specific but affects a broad class of hardware.

### Step 8.2: Trigger conditions
**Record:**
- Warm reboot (not full power cycle)
- GPIO block stays powered
- Prior boot left interrupt enables/masks in non-default state
- Lines not re-configured for interrupts in new boot
- **Likelihood:** Platform-dependent but realistic on embedded/ACPI
  systems that use warm reboot
- **Unprivileged trigger:** No direct userspace trigger; boot-time /
  reboot-time hardware state issue

### Step 8.3: Failure mode severity
**Record:** **Interrupt storm** → sustained IRQ handling → CPU
saturation → soft lockup / hung system / severely degraded
responsiveness. **Severity: HIGH to CRITICAL** (system stability).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH — prevents boot-time or post-warm-reboot interrupt
  storms on widely deployed IP block
- **Risk:** VERY LOW — ~16 lines, standard register init, no API
  changes, interrupts restored only when explicitly enabled
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compile

**FOR backport:**
- Fixes real hardware stale-state bug causing interrupt storms
- Can cause system hang / severe instability (HIGH severity)
- Small, surgical, obviously correct fix
- Uses existing `init_hw` infrastructure already in 6.18.44
- Precedent in multiple GPIO drivers in this same tree
- GPIO maintainer (Bartosz Golaszewski) signed off
- Buggy code confirmed present; fix not yet applied
- No dependencies on other commits

**AGAINST backport:**
- No syzbot report or explicit user bug report in commit message (weaker
  evidence of real-world hit rate)
- ACPI probe ordering means parent IRQ is requested before `init_hw`
  runs (minor window; pre-existing, not introduced by patch)
- Lore discussion could not be retrieved to confirm review feedback

**Unresolved:**
- Mailing list review thread content (lore blocked)
- Exact platforms where author observed the bug

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — register init matches driver
   conventions; maintainer SOB; pattern used elsewhere
2. Fixes a real bug? **PASS** — stale interrupt state on warm reboot
3. Important issue? **PASS** — interrupt storm / system stability
4. Small and contained? **PASS** — one file, ~16 lines
5. No new features/APIs? **PASS** — uses existing `init_hw` callback
6. Can apply to local tree? **PASS** — infrastructure present, clean
   apply expected

### Step 9.3: Exception categories
**Record:** Hardware workaround / driver initialization quirk —
qualifies under stable exception for hardware-specific workarounds that
fix real hardware behavior.

### Step 9.4: Decision rationale
This commit fixes a genuine stability bug in a widely used GPIO
controller driver. The failure mode (interrupt storm after warm reboot)
is serious, the fix is minimal and follows an established pattern
already present in this tree's GPIO subsystem, and all prerequisites
exist in Linux 6.18.44. The fix is not yet in this tree and should be
backported.

---

## Verification

- [Phase 1] `git describe HEAD` → `v6.18.44-1-g2736c32da98b9`; Makefile
  → 6.18.44
- [Phase 1] Parsed commit message tags from user-provided content
- [Phase 2] Read `drivers/gpio/gpio-dwapb.c` lines 182–509, 750–875;
  confirmed diff targets match current code structure
- [Phase 2] Verified register constants `GPIO_INTEN`, `GPIO_INTMASK`,
  `GPIO_PORTA_EOI` at lines 35–41
- [Phase 2] Verified irq enable/disable logic at lines 283–313 uses same
  registers the fix initializes
- [Phase 3] `git blame -L 454,490 drivers/gpio/gpio-dwapb.c` → code from
  v6.18 merge base
- [Phase 3] `git log --oneline -20 -- drivers/gpio/gpio-dwapb.c` →
  recent PM/allocation commits, no interrupt-init fix
- [Phase 3] `grep init_hw drivers/gpio/gpio-dwapb.c` → no matches (fix
  not present)
- [Phase 3] `git log -S 'init_hw' -- drivers/gpio/gpiolib.c` →
  infrastructure present since tree base
- [Phase 4] `b4 dig -c` — failed (commit not in tree)
- [Phase 4] WebFetch + curl lore URL — blocked by Anubis; thread content
  UNVERIFIED
- [Phase 5] Read `gpiolib.c` lines 1185–1202 —
  `gpiochip_irqchip_init_hw()` called before `gpiochip_add_irqchip()`
- [Phase 5] `grep init_hw drivers/gpio/` → found precedent in max77620,
  idt3243x, tangier, realtek-otto
- [Phase 5] Read `gpio-max77620.c` lines 263–274 — identical rationale
  ("left ON after bootloader")
- [Phase 6] Confirmed `dwapb_configure_irqs()` lacks `girq->init_hw` at
  line 472–474
- [Phase 6] Confirmed `include/linux/gpio/driver.h` has `init_hw` at
  line 264
- [Phase 6] `grep snps,dw-apb-gpio` → multiple DT platforms (T-Head
  th1520, Sophgo sg2042, etc.)
- [Phase 7] `drivers/gpio/Kconfig` line 273 — `CONFIG_GPIO_DWAPB`
  tristate driver exists
- [Phase 8] Analyzed ACPI vs non-ACPI probe order in
  `dwapb_configure_irqs()` + `dwapb_gpio_add_port()`

**YES**

 drivers/gpio/gpio-dwapb.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
index 0259c65973323..6ece05f3afe2d 100644
--- a/drivers/gpio/gpio-dwapb.c
+++ b/drivers/gpio/gpio-dwapb.c
@@ -201,6 +201,22 @@ static void dwapb_toggle_trigger(struct dwapb_gpio *gpio, unsigned int offs)
 	dwapb_write(gpio, GPIO_INT_POLARITY, pol);
 }
 
+static int dwapb_irq_init_hw(struct gpio_chip *gc)
+{
+	struct dwapb_gpio *gpio = to_dwapb_gpio(gc);
+
+	/*
+	 * GPIO interrupts may retain stale state across warm reboots when
+	 * peripherals stay powered. Force a known-safe state before the GPIO
+	 * irqchip and irq domain are set up.
+	 */
+	dwapb_write(gpio, GPIO_INTEN, 0);
+	dwapb_write(gpio, GPIO_INTMASK, 0xffffffff);
+	dwapb_write(gpio, GPIO_PORTA_EOI, 0xffffffff);
+
+	return 0;
+}
+
 static u32 dwapb_do_irq(struct dwapb_gpio *gpio)
 {
 	struct gpio_generic_chip *gen_gc = &gpio->ports[0].chip;
@@ -472,6 +488,7 @@ static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
 	girq = &gc->irq;
 	girq->handler = handle_bad_irq;
 	girq->default_type = IRQ_TYPE_NONE;
+	girq->init_hw = dwapb_irq_init_hw;
 
 	port->pirq = pirq;
 
-- 
2.53.0

