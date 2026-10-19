Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C9B55A2BA;
	Mon, 19 Oct 2026 13:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418233; cv=none; b=kzng4YAgt9Zkuy+K9zJDWvTVlQh6IMfwiKmcL/tyJUtt0tSQo7iPT7dpy8/Oyy3W2fpcKwfxcjyTtwCdkG2yH3W5p2NAKjORLsWPgPoa3wcQzvMIruk1fmJtuUPT5mGcAJgvwwA08Iwi9aI/LEf2FFGnjCFWWJOna4JDJbI5XZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418233; c=relaxed/simple;
	bh=E2U7CFGx9u1LDC4RvMJwcuqc81fFkZJubNwScbWE03w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AINSRaV1we7jKAG/rWLs25GTrVn8Kj5RvTWDLPwytQI6Kk5IPgvAbQorDimBTaMVnojEoy213nxE+1WE3sscIQFtq6FTiOq2/el0apXAIpc9RRAnE5Dfg8rCI5ofoxrCpPWwfZ1+98BGzFqmYHvIzyAROMVf+1OYz+jeCqpMv+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=npG1eZ2s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="npG1eZ2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23EBF1F000C6;
	Mon, 19 Oct 2026 13:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418231;
	bh=JAcloDKvAqXuJTHrWnLErrI9EthPRSZ/ESEUaCcP6YU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=npG1eZ2swsMCBGsgoiBjDYkiat1qAaVxfdxZDAZ/2Y1J4/StsS9XmAeLX6J4p6YMl
	 cNunVdRjqcXW65LyhRAjC1ot2BhX6N0tbUVb/JyKpiCAiNQhjEfSBmfB5xeRy5Dn+W
	 JqlXKuTZ1Cmy5zJn516ALQ2CKS9pvgfCp/yssOn8t9OcxRDomWwpforF6IoRtT9IS8
	 jqsucYYI9GbBHtbvTpJwdWHGzq3veNsPzEHKK3uZXH5P5dopGsi+9ivPKuDjKvRSad
	 Pw1iV0EN+V9jXXkytGf6yycfDljRMeFrtzocNfbVhaHkI+s01sCBvOsnWXbReTr13z
	 gbPGME+qCRcvQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Maulik Shah <maulik.shah@oss.qualcomm.com>,
	Sneh Mankad <sneh.mankad@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Navya Malempati <navya.malempati@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	andersson@kernel.org,
	brgl@kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] pinctrl: qcom: Add irq_get/set_irqchip_state() for msm gpio irqchip
Date: Mon, 19 Oct 2026 09:46:36 -0400
Message-ID: <20261019135441.1420968-105-sashal@kernel.org>
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

From: Maulik Shah <maulik.shah@oss.qualcomm.com>

[ Upstream commit 1860fb0be224dec0e4d170f46d1cbbc77e25e09e ]

MPM irqchip monitors the interrupts during SoC sleep state and after wakeup
replays the edge interrupt by making it pending at respective irqchip by
invoking irq_set_irqchip_state() API. The msm gpio irqchip however do not
implement this function making it impossible to replay the gpio interrupt
on any MPM irqchip based SoC.

Add the missing irq_get/set_irqchip_state() APIs. Implement only
IRQCHIP_STATE_PENDING case which MPM irqchip uses.

Signed-off-by: Maulik Shah <maulik.shah@oss.qualcomm.com>
Signed-off-by: Sneh Mankad <sneh.mankad@oss.qualcomm.com>
Acked-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Navya Malempati <navya.malempati@oss.qualcomm.com>
Link: https://patch.msgid.link/20260424-pinctrl_irqchip_states-v1-1-85286f078916@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **7.3.0-rc4**. This commit fills in missing MSM GPIO
irqchip ops so MPM can replay edge GPIOs after deep sleep. That is a
real resume bug on Qualcomm MPM SoCs, and the change is small enough to
be a stable candidate.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[pinctrl/qcom] [Add] Implement missing
irq_get/set_irqchip_state() on the MSM GPIO irqchip`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Fixes:` — none (expected)
- `Reported-by:` — none
- `Tested-by:` — none
- `Reviewed-by: Navya Malempati <navya.malempati@oss.qualcomm.com>`
- `Acked-by: Linus Walleij <linusw@kernel.org>` (pinctrl maintainer)
- `Link: https://patch.msgid.link/20260424-pinctrl_irqchip_states-v1-1-
  85286f078916@oss.qualcomm.com`
- `Cc: stable@vger.kernel.org` — none (expected)
- `Signed-off-by: Maulik Shah` (author)
- `Signed-off-by: Sneh Mankad` (submitter)
- `Signed-off-by: Bartosz Golaszewski` (Qualcomm pinctrl maintainer)
- Ignore pipeline `Signed-off-by: Sasha Levin`

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** After SoC sleep, MPM replays edge IRQs with
  `irq_set_irqchip_state(..., IRQCHIP_STATE_PENDING, true)`. The MSM
  GPIO irqchip did not implement that op, so GPIO edges cannot be
  replayed on MPM SoCs.
- **Symptom:** Lost GPIO edge interrupts after deep sleep / resume
  (wakeup events never delivered to the GPIO irqchip).
- **Root cause:** Missing `irq_chip.irq_{get,set}_irqchip_state` on
  `msmgpio`.
- **Versions:** None stated. MPM has called this API since it was added
  (2022).

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. Subject says “Add”, but the body
describes a real missing-op bug. Implementing existing irqchip callbacks
is a completeness/correctness fix, not a new userspace API.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/pinctrl/qcom/pinctrl-msm.c` — **+39 / -0**
- New: `msm_gpio_irq_set_irqchip_state()`,
  `msm_gpio_irq_get_irqchip_state()`
- Wired into `msm_gpio_irq_chip`
- Scope: single-file, surgical

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** `irq_set_irqchip_state()` walks the hierarchy from
  `msmgpio`. That chip had no callback, so it walked to MPM (also no
  callback). GPIO-only MPM pins disconnect GIC, so the call returns
  `-EINVAL` and the edge is never made pending.
- **After:** `msmgpio` writes/reads TLMM `intr_status` for
  `IRQCHIP_STATE_PENDING`. Other states and `skip_wake_irqs` pins (PDC-
  owned) return `-EINVAL`.
- Path: resume / MPM handler, not probe.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Logic / correctness (missing irqchip op)**, with a hardware-
wakeup workaround flavor.
Mechanism: MPM’s `qcom_mpm_handler()` does
`irq_set_irqchip_state(d->irq, IRQCHIP_STATE_PENDING, true)` for non-
level IRQs. Without the GPIO callback, replay is impossible. The fix
writes the GPIO status register (bit 0; `intr_status_bit` is 0 on all
GPIO pingroups).

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Quality: sufficient for the MPM case. Only `IRQCHIP_STATE_PENDING`;
  PDC pins are rejected via `skip_wake_irqs`.
- Nits (not blockers): bool written as the full status register (OK
  because status bit is 0); no `pctrl->lock` (single `writel`/`readl`);
  redundant `g` assignment in get; get is unused by MPM but harmless.
- `intr_ack_high` platforms (msm8660/8960, ipq8064, …) would invert set
  vs ack; those SoCs do not use MPM.
- For `skip_wake_irqs` (PDC), the walk now stops at `msmgpio` and
  returns `-EINVAL` instead of forwarding to PDC/GIC. PDC SoCs do not
  use MPM replay; this is conservative, not the MPM bug.
- Regression risk: **low–medium**. Writing pending can inject an IRQ;
  that is the intended replay. Pinctrl maintainer initially called it
  “super dangerous”, then acked after Qualcomm review.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record: These callbacks are new. The irqchip struct dates to
`69b78b8de65b` (2014) / immutable chip `14dbe186b9d4` (2022).
`skip_wake_irqs` dates to `e35a6ae0eb3a` (2019). MPM (`a6199bb514d8`,
2022-03-11, ~v5.18) is what started calling `irq_set_irqchip_state()` on
wakeup.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Bug is omission vs MPM, not a regression from a
later commit.

**Step 3.3: CHECK FILE HISTORY**
Record: No prerequisite series. `v1-1` is standalone. No later commit in
this tree patches these new functions.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Maulik Shah is a regular Qualcomm pinctrl/irqchip contributor
(PDC, wakeup, irqchip flags). Related work is Qualcomm wakeup IRQ
handling, not a hard dependency of this patch.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Uses existing `msm_readl/writel_intr_status`, `skip_wake_irqs`,
and `irq_chip` ops. Can apply standalone to this file.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- Lore: https://patch.msgid.link/20260424-pinctrl_irqchip_states-v1-1-
  85286f078916@oss.qualcomm.com
- Single revision **v1** (no v2/v3).
- Linus Walleij (28 Apr 2026): “smart and also **super dangerous**” —
  wanted Qualcomm ACK/test before merge.
- Navya Malempati (16 Jul 2026): `Reviewed-by`.
- Linus (25 Jul 2026): `Acked-by`; asked Bartosz to queue it.
- Bartosz (27 Jul 2026): Applied as `[1/1]`.
- No `Cc: stable`, no NAK after Qualcomm review.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: To/Cc: Bjorn Andersson, Linus Walleij, linux-arm-msm, linux-
gpio, linux-kernel, Maulik Shah. Right lists and maintainers.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot, bugzilla, or public user report. Qualcomm-internal
hardware knowledge. Severity from the message: **GPIO edges cannot be
replayed after sleep on any MPM SoC**.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone 1/1. Same 7.3 pinctrl-qcom pull also had PDC work;
this patch does not depend on those.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: No stable@ discussion found. Merged via “Qualcomm pinctrl
updates for v7.3-rc1”.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**
Record: `msm_gpio_irq_set_irqchip_state`,
`msm_gpio_irq_get_irqchip_state`; `msm_gpio_irq_chip` updated.

**Step 5.2: TRACE CALLERS**
Record:
- IRQ core: `irq_set_irqchip_state()` / `irq_get_irqchip_state()`
  (`kernel/irq/manage.c`) start at the leaf chip (`msmgpio`).
- Primary caller: `qcom_mpm_handler()` in `drivers/irqchip/irq-qcom-
  mpm.c` (RPM wakeup IRQ, resume).
- Also: `irq_inject_interrupt()` (debug), KVM vgic (unrelated host
  IRQs).

**Step 5.3: TRACE CALLEES**
Record: `msm_writel_intr_status` / `msm_readl_intr_status` — MMIO to
TLMM per-pin status.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Sleep → MPM latches wakeup GPIO → resume → `qcom_mpm_handler` →
`irq_set_irqchip_state(PENDING)` → **now** TLMM status. Triggered by
hardware wakeup, not a raw syscall. User-visible: GPIO clients (keys,
modem, sensors) miss the edge after suspend.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: PDC already has `irq_chip_{get,set}_parent_state`. GIC
implements these ops. `skip_wake_irqs` is set only when parent is PDC
(`IRQ_DOMAIN_FLAG_QCOM_PDC_WAKEUP`). MPM parent does **not** set that
flag, so TLMM keeps handling those GPIOs — which is why MSM GPIO must
implement the ops.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- Local tree: **v7.3-rc4-27-gf0100363d8c37**, `VERSION=7 PATCHLEVEL=3
  SUBLEVEL=0 EXTRAVERSION=-rc4`.
- Driver, MPM (`CONFIG_QCOM_MPM`), `skip_wake_irqs`, and accessors all
  exist.
- Commit `1860fb0be224` **is already an ancestor of HEAD** (7.3 merge
  window). Unfixed code is not on HEAD; the same files still need this
  on any branch that predates 7.3.
- Bug present since MPM (v5.18), not introduced after 7.3 branched.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply** onto this `pinctrl-msm.c`. One file, two new
functions, two irq_chip pointers. `skip_wake_irqs` and status accessors
are old.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No other fix for “MPM cannot replay GPIO pending”. No follow-up
on these functions after `1860fb0be224`.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**
Record: `drivers/pinctrl/qcom` + Qualcomm MPM irqchip. **IMPORTANT**
(platform GPIO/wakeup), not core mm/vfs. Affects Qualcomm MPM boards
(sdm660, sm6115/6125/6375, msm8996/8998, qcm2290, …), not PDC phones.

**Step 7.2: SUBSYSTEM ACTIVITY**
Record: Actively maintained (Bartosz / Qualcomm). This is a targeted
irqchip-ops fill-in, not a refactor.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**
Record: **Platform-specific** — `CONFIG_PINCTRL_MSM*` +
`CONFIG_QCOM_MPM`. Not universal. Still real products (older/mid
Qualcomm, IoT, embedded).

**Step 8.2: TRIGGER CONDITIONS**
Record: SoC deep sleep, then an edge GPIO that MPM monitored. Common on
suspend/resume. Not an unprivileged syscall exploit path.

**Step 8.3: FAILURE MODE SEVERITY**
Record: Lost GPIO edge after resume (keys, wake sources, peripherals).
Not oops/UAF/corruption. **MEDIUM–HIGH** functional/suspend-resume, not
CRITICAL crash.

**Step 8.4: RISK-BENEFIT RATIO**
Record:
- **Benefit:** High for MPM Qualcomm users (resume GPIO actually fires).
- **Risk:** Low–medium (39 lines, pending-bit write). Mitigated by
  PENDING-only and `skip_wake_irqs`. No lock/API/data-structure change.
- **Ratio:** Benefit outweighs risk for trees that still lack the ops.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Concrete bug: MPM cannot replay GPIO edges after sleep.
- User-visible resume failure on MPM SoCs.
- Small, one-file, existing irqchip API only.
- Prerequisites present here for years.
- Qualcomm `Reviewed-by`, Walleij `Acked-by`, Bartosz merged.
- No follow-up fix in this tree.
- Same class as hardware/suspend quirks that stable takes.

AGAINST:
- Worded as “Add”; implements new irqchip methods.
- Not crash/UAF/security.
- No public reporter / `Tested-by`.
- Walleij first called it “super dangerous”.
- Minor implementation nits.

UNRESOLVED:
- No public repro log (Qualcomm-described).
- lore HTTP 403; thread recovered via `b4 dig -m`.

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — PENDING-only, skip PDC pins;
   reviewed/acked. Initial “dangerous” concern addressed in review. No
   `Tested-by`, but mechanism matches MPM code.
2. Fixes a real bug that affects users? **PASS** — lost GPIO IRQs after
   sleep on MPM SoCs.
3. Important issue? **PASS** — suspend/resume IRQ loss (serious
   functional), not oops/CVE.
4. Small and contained? **PASS** — +39 lines, one file.
5. No new features or APIs? **PASS** — no new uAPI; fills existing
   `irq_chip` ops the core already calls.
6. Can apply to the local tree? **PASS** — same file/helpers; applies
   cleanly.

**Step 9.3: EXCEPTION CATEGORIES**
Record: Not a device-ID/DT/build/doc exception. Closest: **hardware
wakeup workaround** (missing irqchip op so existing MPM hardware works
after sleep).

**Step 9.4: DECISION**
This tree has the MSM GPIO irqchip, MPM, and `skip_wake_irqs`. The bug
is missing ops, present since MPM (~v5.18), not a 7.3-only feature. The
patch is a small, review-vetted fix for lost edge GPIOs after deep
sleep. That meets stable rules for this checkout.

---

### What it solves for stable users
On Qualcomm MPM SoCs, an edge GPIO during sleep is latched in always-on
MPM. On resume, MPM marks the leaf irqchip pending. Without these ops,
`msmgpio` cannot accept that, so the edge is dropped. Users can miss
keys, modem/Wi-Fi wake, sensors, etc. after suspend.

### Stable rules
Small, obviously aimed at one hardware path, no new uAPI, real resume
bug. Risk is writing the GPIO pending bit; the patch limits that to
`IRQCHIP_STATE_PENDING` and non-PDC pins.

### Risk vs benefit
Benefit is real on MPM platforms. Risk is contained. Quality nits do not
break the MPM case (`intr_status_bit == 0`).

---

### Verification
- **[Phase 1]** Tags: Reviewed-by Navya, Acked-by Walleij, Link to
  msgid; no Fixes/Reported-by/Cc:stable.
- **[Phase 2]** Diff: +39 in `pinctrl-msm.c`; two callbacks + irq_chip
  pointers; `msm_writel_intr_status(val)` with bool; `intr_status_bit`
  is 0 on GPIO groups (verified across pinctrl-qcom).
- **[Phase 2]** `qcom_mpm_handler` confirmed to call
  `irq_set_irqchip_state(..., IRQCHIP_STATE_PENDING, true)` for non-
  level IRQs.
- **[Phase 2]** `irq_set_irqchip_state()` in `kernel/irq/manage.c` walks
  until a chip implements the op; `qcom_mpm_chip` does not.
- **[Phase 3]** MPM added `a6199bb514d8` (2022); `skip_wake_irqs` from
  `e35a6ae0eb3a` (2019); no later fix to these functions.
- **[Phase 3]** `git merge-base --is-ancestor 1860fb0be224 HEAD` → yes
  (commit is in this 7.3-rc4 history). Decision is on technical merit,
  not “already selected”.
- **[Phase 4]** `b4 dig -c 1860fb0be224` → v1 only; Walleij “super
  dangerous” then Acked-by; Bartosz applied 1/1.
- **[Phase 4]** `b4 dig -w`: linux-gpio, linux-arm-msm, Walleij,
  Andersson.
- **[Phase 4]** lore.kernel.org WebFetch 403; thread read from
  `/tmp/pinctrl-irqchip.mbox`.
- **[Phase 5]** PDC sets `IRQ_DOMAIN_FLAG_QCOM_PDC_WAKEUP` →
  `skip_wake_irqs`; MPM sets `IRQ_DOMAIN_FLAG_QCOM_MPM_WAKEUP` and does
  not skip TLMM.
- **[Phase 6]** `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`;
  `make kernelversion` = `7.3.0-rc4`.
- **[Phase 8]** Failure: dropped GPIO edge after MPM wakeup; severity
  MEDIUM–HIGH functional, not crash.
- **UNVERIFIED:** Public reproducer / which exact board Qualcomm used
  (not in the thread).

The patch is a contained fix for a real resume IRQ-loss bug on hardware
this tree already supports.

**YES**

 drivers/pinctrl/qcom/pinctrl-msm.c | 39 ++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index 424b14bc29e96..015c9b2f086da 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -1289,6 +1289,43 @@ static int msm_gpio_irq_set_affinity(struct irq_data *d,
 	return -EINVAL;
 }
 
+static int msm_gpio_irq_set_irqchip_state(struct irq_data *d,
+					  enum irqchip_irq_state which, bool val)
+{
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct msm_pinctrl *pctrl = gpiochip_get_data(gc);
+	const struct msm_pingroup *g = &pctrl->soc->groups[d->hwirq];
+
+	if (which != IRQCHIP_STATE_PENDING)
+		return -EINVAL;
+
+	if (test_bit(d->hwirq, pctrl->skip_wake_irqs))
+		return -EINVAL;
+
+	msm_writel_intr_status(val, pctrl, g);
+
+	return 0;
+}
+
+static int msm_gpio_irq_get_irqchip_state(struct irq_data *d,
+					  enum irqchip_irq_state which, bool *val)
+{
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct msm_pinctrl *pctrl = gpiochip_get_data(gc);
+	const struct msm_pingroup *g = &pctrl->soc->groups[d->hwirq];
+
+	if (which != IRQCHIP_STATE_PENDING)
+		return -EINVAL;
+
+	if (test_bit(d->hwirq, pctrl->skip_wake_irqs))
+		return -EINVAL;
+
+	g = &pctrl->soc->groups[d->hwirq];
+	*val = msm_readl_intr_status(pctrl, g);
+
+	return 0;
+}
+
 static int msm_gpio_irq_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
@@ -1377,6 +1414,8 @@ static const struct irq_chip msm_gpio_irq_chip = {
 	.irq_request_resources	= msm_gpio_irq_reqres,
 	.irq_release_resources	= msm_gpio_irq_relres,
 	.irq_set_affinity	= msm_gpio_irq_set_affinity,
+	.irq_set_irqchip_state = msm_gpio_irq_set_irqchip_state,
+	.irq_get_irqchip_state = msm_gpio_irq_get_irqchip_state,
 	.irq_set_vcpu_affinity	= msm_gpio_irq_set_vcpu_affinity,
 	.flags			= (IRQCHIP_MASK_ON_SUSPEND |
 				   IRQCHIP_SET_TYPE_MASKED |
-- 
2.53.0

