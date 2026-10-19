Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC9E54408D;
	Mon, 19 Oct 2026 13:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418186; cv=none; b=YWH1kcn/i8JVAT7+qAgsd9cX5PKx0PdRRyZSWA2HnmHscslk7Sa165tbvwzWH/Y2PKNFP7UlrqWYLGPtBLN0FdVDOprs9wWXhz9apQ/sBAudNT4Gii35Dy1tPzg1Fs0tGGhObDCvpcGhzphrLz1Hyrj+ofq3Xn6LQfcPb6U7lbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418186; c=relaxed/simple;
	bh=WPytO5mj3Kz6s0pbUcHQ9xPaUjyuzpcKV6wnMQPYkMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fGAehLpwFRFBgtR4O91py6VHww2RPzcBAQ/PT46pCxEXXmsAg797rD4tcdYOfDZvARq8f8J7QrP+yNxuvF7undbmfYybSwEQEzHZjNLdhSUoNroQCaaWP4xvRGmnawEdxPD6L5Kdsrl0SD49dor2yoKYH5Bjv1qkcS4tM88fyi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hPpfUFPm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hPpfUFPm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EDF81F000C5;
	Mon, 19 Oct 2026 13:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418184;
	bh=dc6SFE22Qvk6YfiBY+bv4S7Ucp5hbJOxKN83Amem+GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hPpfUFPmgyhblvtLfSkQp1tBmtTfoVRGXKT9hZb30Ib1XmHmYLBcS/kIdVlkKtd2R
	 UIi6oJ6SlTv+gnDfc2S+AF4X/fZwh2PP5NQNMzKBUTTPqEbXQ5XoKg8LJm3lrIiM8M
	 FwHW39mxXneBpkctnLPdvsLXrsa/GDT9Bbor6CYYmeO7EkLrBgCDboQKOFa1Bg1L6d
	 NVPHUCsrui7Eoz/1iiS9yIJEKOerBoJ3/jYUaO3Mj3DV0aNNQJA55xBDlU+2Suupxw
	 Wk0hoWqEutW3mIQMvp+WqYBfsZ3vFz2+XdYhXulJhhJ2Z8kzMjEv384hK5hQCsDFF7
	 vC1Tc/LIwXz5g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tomer Maimon <tmaimon77@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew@codeconstruct.com.au,
	avifishman70@gmail.com,
	tali.perry1@gmail.com,
	openbmc@lists.ozlabs.org,
	linux-gpio@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] pinctrl: npcm8xx: move GPIO IRQ setup into request_resources
Date: Mon, 19 Oct 2026 09:46:03 -0400
Message-ID: <20261019135441.1420968-72-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tomer Maimon <tmaimon77@gmail.com>

[ Upstream commit b8edfde12e355030e708394c0fa11632559c7ac5 ]

npcmgpio_irq_startup() calls pinctrl_gpio_direction_input(), which may
sleep while taking the pinctrl core mutex. That makes IRQ startup trip
lockdep when CONFIG_PROVE_LOCKING is enabled.

Move the direction change into irq_request_resources() and keep startup
limited to the ack and unmask operations that are safe in atomic
context.

Signed-off-by: Tomer Maimon <tmaimon77@gmail.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **v7.3-rc4** (`7.3.0-rc4`). The NPCM8XX pinctrl driver
is present, and this change is a real sleep-in-atomic IRQ fix, not a
feature add.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[pinctrl/npcm8xx] [move] move GPIO IRQ setup into
request_resources**
Subsystem `pinctrl: npcm8xx`. Verb is “move”, but the body is a
correctness fix: take a may-sleep call out of `irq_startup`.

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Tomer Maimon `<tmaimon77@gmail.com>` (author; NPCM
  maintainer)
- Signed-off-by: Linus Walleij `<linusw@kernel.org>` (pinctrl
  maintainer)
- No Fixes, Reported-by, Tested-by, Reviewed-by, Acked-by, Link, or Cc:
  stable
Absence of Fixes/Cc: stable is expected for this review and is not a
negative signal.

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: `npcmgpio_irq_startup()` calls `pinctrl_gpio_direction_input()`,
  which takes the pinctrl mutex and may sleep.
- Symptom: lockdep splat with `CONFIG_PROVE_LOCKING` on IRQ startup.
- Root cause: IRQ startup runs in atomic context; mutex_lock there is
  illegal.
- Fix: do the direction change in `irq_request_resources()`; leave
  startup as ack+unmask only.
- No version range, stack trace, or reproducer in the message.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a hidden fix. It is an explicit locking/context bug. Cover
letter of the v1 series called the set a “cleanup” from a Nuvoton tree
comparison, but this patch itself describes a real sleep-in-atomic
problem.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c` (+23 / -6, 29 lines)
- Functions: `npcmgpio_irq_startup` (changed),
  `npcmgpio_irq_request_resources` (added),
  `npcmgpio_irq_release_resources` (added), `npcmgpio_irqchip` (changed)
- Scope: single-file surgical irqchip callback change

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: `irq_startup` called `npcmgpio_direction_input()` then
  ack/unmask. Resource helpers came from `GPIOCHIP_IRQ_RESOURCE_HELPERS`
  (`gpiochip_irq_reqres` / `gpiochip_irq_relres`).
- After: `irq_startup` only ack+unmask. New `irq_request_resources` does
  `npcmgpio_direction_input()` then `gpiochip_reqres_irq()`. New
  `irq_release_resources` calls `gpiochip_relres_irq()`. Macro helpers
  removed because custom callbacks replace them.
- Path: GPIO `request_irq()` setup, not a probe-only path.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: **Synchronization / illegal sleep in atomic context**
`irq_startup()` is invoked from `__setup_irq()` while `desc->lock` is
held via `raw_spin_lock_irqsave()` (`kernel/irq/manage.c`: lock at 1589,
`irq_startup()` at 1766, unlock at 1807).
`pinctrl_gpio_direction_input()` takes `pinctrldev_list_mutex` and
`pctldev->mutex` (`drivers/pinctrl/core.c`). Mutex in that context is
sleep-in-atomic. `irq_request_resources()` runs before that spinlock and
is allowed to sleep.

Step 2.4: ASSESS THE FIX QUALITY
Record: Quality is high. Same pattern as `pinctrl-ingenic.c` and
`pinctrl-st.c`. Resource get/put is preserved. Direction-input errors
are now returned instead of ignored. Regression risk is low: startup no
longer re-applies input on later startups, which matches other drivers;
first `request_irq()` still sets input before unmask. No API or data-
structure change.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: Buggy `npcmgpio_irq_startup()` / `GPIOCHIP_IRQ_RESOURCE_HELPERS`
came from `acf4884a571709` (“pinctrl: nuvoton: add NPCM8XX pinctrl and
GPIO driver”, 2023-08-28), first in **v6.7-rc1**. The bug is as old as
the driver.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Introducer is the original driver commit above.
`git merge-base --is-ancestor acf4884a571709 HEAD` is true in this tree.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Submitted as **[PATCH v1 6/8]** “pinctrl: npcm8xx: fix pinmuxing
and configuration handling”. Siblings (bmcuart1 pins, RMII, RG2 drive
strength, event clear, rename, JM1/SMB7 flags, debounce) do not change
the irqchip callbacks this patch needs. Standalone. No follow-up on
these IRQ helpers after this commit.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Tomer Maimon is listed under ARM/NUVOTON NPCM ARCHITECTURE in
MAINTAINERS. Recent npcm8xx work is this same 8-patch set plus earlier
pin-table updates. Maintainer-authored.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Needs existing `gpiochip_reqres_irq` / `gpiochip_relres_irq` and
`GPIOCHIP_IRQ_RESOURCE_HELPERS`, both present here. No series
prerequisite for this hunk. Can apply standalone to this driver.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record: `b4 dig -c b8edfde12e355` →
https://patch.msgid.link/20260715122923.1938327-7-tmaimon77@gmail.com
Only **v1**. Lore HTTP fetch returned 403; full thread was saved with
`b4 dig -m`. Linus Walleij (24 Jul 2026): “No comments so patches
applied.” No NAK, no stable nomination, no requested respin.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: `b4 dig -w` To/Cc: Tomer Maimon, Andrew Jeffery, Linus Walleij,
Bartosz Golaszewski, openbmc, linux-gpio, linux-kernel, Avi Fishman,
Tali Perry, Patrick Venture, Nancy Yuen, Benjamin Fair. Right lists and
maintainers. Only explicit reply is Walleij applying the series.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No Reported-by, syzbot, or bugzilla. Issue was found by
comparing upstream with Nuvoton’s tree. Symptom claimed is lockdep with
`CONFIG_PROVE_LOCKING`. No public user crash report found.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: 8-patch pinmux/config series. This IRQ move does not depend on
the others. npcm7xx still calls `npcmgpio_direction_input()` from
`irq_startup()` — same class of bug, different driver, not a dependency.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable search via curl returned 403. UNVERIFIED
whether stable@ already discussed this. No evidence in the gpio thread
of a stable NAK.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `npcmgpio_irq_startup`, `npcmgpio_irq_request_resources`,
`npcmgpio_irq_release_resources`, plus `npcmgpio_irqchip` initializer.

Step 5.2: TRACE CALLERS
Record:
- irqchip ops invoked from IRQ core: `irq_request_resources()` /
  `irq_release_resources()` / `irq_startup()` in `kernel/irq/manage.c`
  and `kernel/irq/chip.c`
- Chip registered in `npcm8xx_gpio_register()` via `girq->chip`
- Reachable from `request_irq()` / `gpiod_to_irq()` users on NPCM8XX
  GPIO banks

Step 5.3: TRACE CALLEES
Record: `npcmgpio_direction_input` → `pinctrl_gpio_direction_input`
(mutex) + generic `bank->direction_input`; `npcmgpio_irq_ack` / `unmask`
(MMIO); `gpiochip_reqres_irq` / `gpiochip_relres_irq`.

Step 5.4: FOLLOW THE CALL CHAIN
Record: userspace or driver `request_irq` on a GPIO line → `__setup_irq`
→ `irq_request_resources` (sleep OK) →
`raw_spin_lock_irqsave(&desc->lock)` → `irq_startup` (atomic). Path is
reachable whenever GPIO IRQs are used (BMC buttons, hotplug, etc.). Not
an obscure config-only path if `PINCTRL_NPCM8XX` is enabled (`depends on
ARCH_NPCM || COMPILE_TEST`).

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same “direction_input in irq_request_resources” pattern in
ingenic and ST pinctrl. Sibling `pinctrl-npcm7xx.c` still has the old
startup-time `direction_input` call.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. Driver is `drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c`.
Introduced v6.7 (`acf4884a571709`). `git merge-base --is-ancestor
acf4884a571709 HEAD` succeeded. Pre-fix startup still present at parent
`b8edfde12e355^`. Local kernel: **v7.3-rc4** (`7.3.0-rc4`).

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Expected apply: **clean**. Hunks are local to the irqchip struct
and two small callbacks. `GPIOCHIP_IRQ_RESOURCE_HELPERS` and
`gpiochip_reqres_irq()` exist here. Reverse-apply of the committed diff
checked cleanly against current file.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No earlier alternate fix for this irq_startup sleep. Current
HEAD already contains `b8edfde12e355` because this checkout is mainline
after the pinctrl-v7.3 pull; that is the upstream commit under review,
not a prior independent fix. No later corrective commit.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **pinctrl / GPIO irqchip for Nuvoton NPCM8XX (Arbel BMC)**.
Criticality: **PERIPHERAL** for general kernels, **IMPORTANT** for
OpenBMC/NPCM845 systems. Not mm/fs/net core.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: File is actively updated (pin tables, debounce, RMII, this IRQ
fix). Driver is mature since v6.7, not brand-new staging code.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: **driver-specific / platform-specific**: NPCM8XX
(`CONFIG_PINCTRL_NPCM8XX`), typically OpenBMC on NPCM845. Not universal.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Trigger is GPIO IRQ request (`request_irq` / irqchip startup).
Common for BMC GPIO IRQs. Unprivileged userspace can hit it if a GPIO
irq is exported; typical path is kernel drivers during bring-up. Not a
rare race: with lockdep it fires on every such startup. Mutex contention
can turn it into a real sleep-under-spinlock.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: Failure mode: mutex_lock while `desc->lock` is held and IRQs are
off.
- With `CONFIG_PROVE_LOCKING` / `DEBUG_ATOMIC_SLEEP`: lockdep/WARN
  (always)
- If `pctldev->mutex` is contended: **scheduling while atomic** → BUG
Severity: **HIGH** (illegal atomic sleep; crash if contended), not a
silent data-corruption bug.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: medium-high for NPCM8XX/OpenBMC (correct IRQ request, no
  lockdep/sleep-in-atomic); zero for other platforms
- Risk: **low** (~20 net lines, irqchip callbacks only, established
  pattern)
- Ratio: favorable

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real sleep-in-atomic: `pinctrl_gpio_direction_input()` takes mutexes;
  `irq_startup()` runs under `raw_spin_lock_irqsave(&desc->lock)`
- Deterministic on GPIO IRQ request with lockdep
- Can BUG if the pinctrl mutex is contended
- Small, obviously correct, matches ingenic/ST
- Keeps `gpiochip_reqres_irq` / `gpiochip_relres_irq`
- Driver exists in this tree since v6.7
- Author is NPCM maintainer; applied by Linus Walleij
- Standalone vs the rest of the 8-patch series

AGAINST:
- No user crash report / syzbot / Fixes tag
- Author framed the user-visible issue as lockdep, not production oops
- NPCM8XX-only
- Cover letter called the series a vendor-tree cleanup
- npcm7xx still has the same pattern (does not make this patch wrong)

UNRESOLVED:
- lore.kernel.org HTTP 403; stable@ discussion not independently fetched
  (thread itself was retrieved via b4)

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — context split is the
   documented irqchip model; applied by pinctrl maintainer. No extra
   Tested-by.
2. Fixes a real bug that affects users? **PASS** — illegal mutex in IRQ
   startup on GPIO `request_irq`.
3. Important issue? **PASS** — sleep-in-atomic / lockdep; possible BUG
   if mutex contended. Not a new feature.
4. Small and contained? **PASS** — one file, ~29 lines.
5. No new features or APIs? **PASS** — only irqchip callback placement.
6. Can apply to the local tree? **PASS** — driver and helpers exist;
   hunks match.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: None (not a device ID, quirk, DT, build, or docs-only change).
Qualifies as a normal bugfix.

Step 9.4: MAKE YOUR DECISION
This tree has the NPCM8XX driver and the buggy startup path. The patch
is a small, correct move of a may-sleep call to
`irq_request_resources()`, which is the sleepable side of
`request_irq()`. That meets stable rules for this checkout.

Verification:
- [Phase 1] Tags: only Tomer Maimon and Linus Walleij SOBs; no
  Fixes/Reported-by/stable Cc
- [Phase 2] Diff: 23 insertions, 6 deletions in `pinctrl-npcm8xx.c`;
  direction_input moved; GPIOCHIP_IRQ_RESOURCE_HELPERS replaced by
  custom reqres/relres
- [Phase 2] `pinctrl_gpio_direction()` locks `pctldev->mutex`;
  `pinctrl_get_device_gpio_range()` locks `pinctrldev_list_mutex`
- [Phase 2] `__setup_irq()`: `irq_request_resources()` before
  `desc->lock`; `irq_startup()` while lock held (`manage.c` 1574–1766,
  unlock 1807)
- [Phase 3] Blame: bug from `acf4884a571709` (v6.7-rc1); `git merge-base
  --is-ancestor` true for intro and for `b8edfde12e355`
- [Phase 3] `git describe HEAD`: v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion`: 7.3.0-rc4
- [Phase 3] Series 1/8–8/8 identified; this patch does not depend on the
  others
- [Phase 4] `b4 dig -c b8edfde12e355`: lore msgid
  20260715122923.1938327-7; v1 only
- [Phase 4] `b4 dig -w`: Walleij, Golaszewski, Andrew Jeffery, openbmc,
  linux-gpio
- [Phase 4] mbox: Walleij “No comments so patches applied”; no
  NAK/stable Cc
- [Phase 4] UNVERIFIED: stable@ archive (HTTP 403)
- [Phase 5] Same pattern in `ingenic_gpio_irq_request` and
  `st_gpio_irq_request_resources`; npcm7xx still uses startup-time
  direction_input
- [Phase 6] File present; reverse `git apply --check` of the commit diff
  succeeded
- [Phase 8] Failure mode: lockdep always; scheduling-while-atomic if
  mutex contended — HIGH for this SoC, not universal
- UNVERIFIED: whether an unprivileged gpiochip ioctl is the common
  trigger vs kernel drivers (both reach `request_irq`)

**YES**

 drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c | 29 ++++++++++++++++++-----
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c b/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
index 28464463ff833..0347a471f9226 100644
--- a/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
+++ b/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
@@ -295,17 +295,33 @@ static void npcmgpio_irq_unmask(struct irq_data *d)
 
 static unsigned int npcmgpio_irq_startup(struct irq_data *d)
 {
-	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
-	unsigned int gpio = irqd_to_hwirq(d);
-
-	/* active-high, input, clear interrupt, enable interrupt */
-	npcmgpio_direction_input(gc, gpio);
 	npcmgpio_irq_ack(d);
 	npcmgpio_irq_unmask(d);
 
 	return 0;
 }
 
+static int npcmgpio_irq_request_resources(struct irq_data *d)
+{
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	unsigned int gpio = irqd_to_hwirq(d);
+	int ret;
+
+	ret = npcmgpio_direction_input(gc, gpio);
+	if (ret)
+		return ret;
+
+	return gpiochip_reqres_irq(gc, gpio);
+}
+
+static void npcmgpio_irq_release_resources(struct irq_data *d)
+{
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	unsigned int gpio = irqd_to_hwirq(d);
+
+	gpiochip_relres_irq(gc, gpio);
+}
+
 static struct irq_chip npcmgpio_irqchip = {
 	.name = "NPCM8XX-GPIO-IRQ",
 	.irq_ack = npcmgpio_irq_ack,
@@ -313,8 +329,9 @@ static struct irq_chip npcmgpio_irqchip = {
 	.irq_mask = npcmgpio_irq_mask,
 	.irq_set_type = npcmgpio_set_irq_type,
 	.irq_startup = npcmgpio_irq_startup,
+	.irq_request_resources = npcmgpio_irq_request_resources,
+	.irq_release_resources = npcmgpio_irq_release_resources,
 	.flags =  IRQCHIP_MASK_ON_SUSPEND | IRQCHIP_IMMUTABLE,
-	GPIOCHIP_IRQ_RESOURCE_HELPERS,
 };
 
 static const int gpi36_pins[] = { 36 };
-- 
2.53.0

