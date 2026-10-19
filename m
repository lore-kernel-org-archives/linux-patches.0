Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82470634F39;
	Mon, 19 Oct 2026 14:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418743; cv=none; b=BKlxX41qwajZJXE3OWIUx4KOrifFtJH/1Krn+RYsVndQWPNvlFWyHREPxAbRe4wz3PT0KlytzZ9WTy3k3j+uAZn2q0vGPa3WUla/MXQHKHV75FlO+UHGg0lLPhwN6a0N4vdPAO3GDmjF5EtKI9EKsarEWkqhZ+hHDfTz2Sy/zS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418743; c=relaxed/simple;
	bh=HVjNpkKLxT7qbdAdX4Zdcfqctuwo66CEVxbqw0grWh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tCYQqT7xMf+eoFLZbkwbVQRPfh+XnauvM5w0mTisepp1+nLXU8oVNWw4wS4988kiV15ILgzonFRHigTGfCphqJORwYTZuV5PgW4cXSeTMeAspu8XLehVQBT+soxMruGGtsreyuZOwoRLNo0aPVe7HmWPVZrxWr0Fj4Y6LvLh7Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iCiU/Fab; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iCiU/Fab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A431F000C6;
	Mon, 19 Oct 2026 14:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418740;
	bh=7cDxpU4h7PLon0nH984O6cOV2WKPkPMLrPLXQMxU55g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iCiU/FabYqYihhFEr91ABX8s79SlkjGeTjLiekhJEQP5NGPGBQa8+l5D5AWorrbDL
	 vOtF4ZidpquaQQ9gd7odJvT7472vQZMrYlr/lLnP8WtjDi+IZz/GuHxd5RpDTwYc9o
	 Np7p5OGJP9U6Iu+eOD8YkYLHE4pZjhbxkvOEwncDCRIKM6haFp21GxX5EazA8+jnH2
	 Na451Yg0wwxZQlC4gwnH16vQWxReJXz6e3kUIxAHRKgsjnV4aRZLaEPgas6iHM9XZb
	 6pIUmu3AzV33mDU4ziFCOZrpOPFO+KsaJZ+A3eJMofkcZDufLD95aYYk4555T/FzlX
	 8YebOD8PQN//Q==
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
Subject: [PATCH AUTOSEL 6.18-6.12] pinctrl: npcm8xx: clear pending GPIO events during init
Date: Mon, 19 Oct 2026 09:52:33 -0400
Message-ID: <20261019135441.1420968-462-sashal@kernel.org>
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

[ Upstream commit cd39cce4cfd499f555eb8b8252636609c3468f57 ]

A bank may retain pending event status across resets of the GPIO block.
If probe leaves the old state in place, the chained IRQ handler can see
spurious events as soon as the irqchip is registered.

Disable event generation and clear EVST before wiring each GPIO bank
into gpiolib so the driver starts from a known state.

Signed-off-by: Tomer Maimon <tmaimon77@gmail.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). The
NPCM8XX pinctrl/GPIO driver is present, the leftover EVEN/EVST init gap
is real on this path, and the change is a 3-line hardware init fix that
belongs here.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[pinctrl/npcm8xx] [clear] [clear leftover GPIO event
enable/status before irqchip registration]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Signed-off-by: Tomer Maimon \<tmaimon77@gmail.com\> (author; original
  NPCM8XX driver author)
- Signed-off-by: Linus Walleij \<linusw@kernel.org\> (pinctrl
  maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, Link:,
  or Cc: stable (absence is expected)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** GPIO bank EVEN/EVST can survive GPIO-block reset
  (bootloader/firmware leftover).
- **Symptom:** chained IRQ handler sees spurious events as soon as the
  irqchip is registered at probe.
- **Root cause:** probe never disables event generation or W1C-clears
  EVST before `gpiochip_add_data()`.
- **Fix:** write EVEN=0, then EVST=0xffffffff, per bank, before gpiolib
  wiring.
- **Versions:** none stated. Bug is an omission since the driver was
  added.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised. Subject/body describe a real init-time IRQ bug.
Cover letter of the v1 8-patch series called the series a vendor-tree
cleanup, but this patch is a concrete spurious-IRQ fix, not style-only.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c` (+3 / −0)
- Function: `npcm8xx_gpio_fw()`
- Scope: single-file surgical init fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** after `fwnode_irq_get()`, the bank’s EVEN/EVST were left
  as hardware left them; later `npcm8xx_gpio_register()` set
  `girq->parent_handler = npcmgpio_irq_handler` and called
  `devm_gpiochip_add_data()`.
- **After:** EVEN is forced to 0 (no event generation), then EVST is
  W1C-cleared with `0xffffffff`, still before irqchip registration.
- Path: probe/init only (`npcm8xx_pinctrl_probe` → `npcm8xx_gpio_fw`).

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** hardware leftover interrupt state / spurious IRQ (init
  hygiene, same class as a quirk).
- **Mechanism:** `npcmgpio_irq_handler()` does `sts = EVST; en = EVEN;
  sts &= en;` then `generic_handle_domain_irq()` for set bits. If
  firmware left EVEN and EVST non-zero, the first chained invocation
  dispatches IRQs for lines that were never requested. Parent bank IRQs
  in DT are **GIC_SPI, IRQ_TYPE_LEVEL_HIGH**; leftover asserted status
  can keep the parent line high (storm / “nobody cared”).
  `npcmgpio_irq_ack()` writes `BIT(gpio)` to EVST, confirming EVST is
  write-1-to-clear; writing `0xffffffff` is the correct all-clear.
  Disabling EVEN first avoids a new event sneaking in between the two
  writes.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: disable, then W1C-clear, before the handler is
  installed.
- Minimal: two MMIO writes, no API/struct/locking changes.
- Regression risk: very low. Linux GPIO IRQs must be requested through
  gpiolib; inheriting bootloader unmasks is not a supported ABI.
  Starting masked+cleared is the normal irqchip model.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: The surrounding `npcm8xx_gpio_fw()` bank setup comes from
**acf4884a57170** (“pinctrl: nuvoton: add NPCM8XX pinctrl and GPIO
driver”, 2023-08-28), first in **v6.7-rc1**. The bug is missing init,
present for the lifetime of the driver.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag. N/A. Introduced-by is the original driver commit
above. `git merge-base --is-ancestor acf4884a57170 HEAD` is implicit:
the file exists on this 7.3 tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Same-day series (2026-07-15) in this file:
1. drop RTS/CTS from bmcuart1
2. enable RMII outputs
3. RG2 drive strength
4. **this commit**
5. rename GPIO7 IOX2
6. move IRQ setup into `request_resources`
7. JM1/SMB7 pin flags
8. debounce register selection

This patch does not use symbols or structure from 1–3 or 5–8.
Standalone.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Tomer Maimon is the Nuvoton driver author
(`MODULE_AUTHOR("tomer.maimon@nuvoton.com")`) and added both NPCM7XX and
NPCM8XX pinctrl drivers. Weight: high.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None. Uses existing `NPCM8XX_GP_N_EVEN` / `NPCM8XX_GP_N_EVST`
and `iowrite32()`. Applies standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c cd39cce4cfd499f555eb8b8252636609c3468f57` →
  https://patch.msgid.link/20260715122923.1938327-5-tmaimon77@gmail.com
- v1 only (`b4 dig -a`): **[PATCH v1 4/8]** in “pinctrl: npcm8xx: fix
  pinmuxing and configuration handling”
- Cover letter: issues found by comparing upstream with the Nuvoton
  tree; this patch is called out as clearing stale GPIO events at probe.
- Linus Walleij (2026-07-24): “No comments so patches applied.” No NAK,
  no requested respin.
- Applied version is v1 (only revision).

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc included linusw@kernel.org (pinctrl
maintainer), brgl@kernel.org (GPIO), andrew@codeconstruct.com.au,
openbmc@lists.ozlabs.org, linux-gpio, Nuvoton/Google OpenBMC people.
Maintainer applied the series. No Reviewed-by tags on the commit.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No Reported-by, bugzilla, or syzbot. Trigger is SoC/firmware
leftover state, not a fuzzer path. Author is the vendor driver owner;
that is how this class of BMC GPIO bugs usually surfaces.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: 8-patch v1 series. Other patches are pinmux/drive-
strength/rename/lockdep-IRQ-startup/debounce — not prerequisites. This
3-line hunk is self-contained.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search returned HTTP 403. **UNVERIFIED:**
no confirmation of prior stable-list discussion. gpio list mbox had no
“Cc: stable” and no objection.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `npcm8xx_gpio_fw()` (modified). Related, not edited:
`npcmgpio_irq_handler()`, `npcm8xx_gpio_register()`,
`npcm8xx_pinctrl_probe()`.

**Step 5.2: TRACE CALLERS**
Record:
- `npcm8xx_gpio_fw()` ← `npcm8xx_pinctrl_probe()` only (platform probe,
  `arch_initcall`).
- `npcmgpio_irq_handler()` ← chained parent handler for each of 8 GPIO
  banks.
- Context: boot/probe, then hardirq for bank SPI 116–123.

**Step 5.3: TRACE CALLEES**
Record: `iowrite32()` to EVEN and EVST. No alloc, no locks. Later
`npcm8xx_gpio_register()` → `devm_gpiochip_add_data()`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: DT `compatible = "nuvoton,npcm845-pinctrl"` with 8
`gpio@f001x000` nodes, each `interrupts = <GIC_SPI 11x
IRQ_TYPE_LEVEL_HIGH>`. Reachable on every NPCM845/NPCM8XX boot
(OpenBMC). Not a syscall fuzzer path; userspace GPIO IRQ consumers can
be hit by the spurious events if leftover enables match those lines.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: NPCM7XX has the same EVEN/EVST handler and **does not** clear
them at init (same latent class, out of scope). `pinctrl-owl.c` also
clears pending GPIO IRQs in its handler path. Pattern is established.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. `drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c` is in this
7.3-rc4 tree. Driver since v6.7. Without the two writes,
`npcm8xx_gpio_fw()` still maps banks and `npcm8xx_gpio_register()` still
installs `npcmgpio_irq_handler`. Bug introduced with the driver, long
before 7.3.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply. Hunk sits immediately after `fwnode_irq_get()` in
`npcm8xx_gpio_fw()`, which exists here. No structural mismatch.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No earlier equivalent EVEN/EVST init. This is the first such
clear on this file (`git log --grep='pending GPIO'` / `'spurious'` on
that path only hits this commit).

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **pinctrl/GPIO, Nuvoton NPCM8XX (BMC SoC).** Criticality:
**PERIPHERAL** for the kernel as a whole, **IMPORTANT** for NPCM845
OpenBMC/server BMC users. `CONFIG_PINCTRL_NPCM8XX` depends on `ARCH_NPCM
|| COMPILE_TEST`.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature driver (v6.7), with a burst of vendor fixes in the 7.3
window. Not staging.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver-specific / platform-specific: Nuvoton NPCM8XX (e.g.
NPCM845) systems using this pinctrl driver. Typical population: OpenBMC
on that SoC.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Boot/probe, when firmware or a partial GPIO-block reset left
EVEN/EVST non-zero. Common on BMCs (bootloader uses GPIOs). Not
unprivileged-syscall; it is default hardware bring-up.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record:
- Spurious chained IRQs at probe.
- Parent IRQs are **level-high**; leftover enable+status can hold the
  line → IRQ storm, “nobody cared”, hung boot.
- `generic_handle_domain_irq()` on never-requested lines (this driver
  defaults `girq->handler = handle_level_irq`, not `handle_bad_irq`).
- **Severity: HIGH** (boot IRQ storm / spurious IRQs on BMC GPIO). Not a
  universal panic, but a real stability failure on affected boards.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** high for NPCM8XX (known-state IRQ init; prevents probe-
  time storms).
- **Risk:** very low (2 MMIO writes, probe only).
- **Ratio:** strongly in favor of applying.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real leftover-hardware IRQ bug, not a refactor.
- Level-triggered parent IRQs make leftover EVST/EVEN a boot storm risk.
- 3 lines, obviously correct (mask then W1C-clear before handler
  install).
- Author is the vendor driver owner; pinctrl maintainer applied it.
- Driver and insertion point exist in this 7.3 tree; no prerequisites.
- Same class as accepted GPIO “clear pending at init” fixes.

AGAINST:
- No user/syzbot report; found via vendor-tree comparison.
- Affects one BMC SoC family, not core kernel.
- No Cc: stable (not a negative by itself).
- Series mixed in feature/rename patches (this hunk does not depend on
  them).

UNRESOLVED:
- Could not search lore.kernel.org/stable (HTTP 403).
- No independent Tested-by.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — two register writes,
   maintainer applied; no test robot/NAK. Formal Tested-by absent, but
   the change is reviewable from the handler and DT IRQ type.
2. Fixes a real bug that affects users? **PASS** — leftover EVEN/EVST →
   spurious chained IRQs on NPCM8XX probe.
3. Important issue? **PASS** — boot-time spurious/level IRQ storm on BMC
   GPIO, not cosmetic.
4. Small and contained? **PASS** — +3 lines, one function.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — file, registers, and
   `npcm8xx_gpio_fw()` insertion point are here.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Hardware init/workaround (clear stale IRQ state). Not a new ID,
but the same “make existing hardware boot cleanly” exception.

**Step 9.4: MAKE YOUR DECISION**
This is a small, correct, self-contained fix for leftover GPIO event
state that can fire the chained handler as soon as the irqchip is
registered. The buggy path exists in this 7.3 tree. It should be applied
here.

What the commit solves: NPCM8XX GPIO banks can keep EVEN/EVST across
GPIO-block reset. Probe used to register the chained handler on that
dirty state, so leftover enables × pending status become spurious (and,
with level-high parents, potentially stuck) interrupts at boot.

Stable rules: obviously correct, real bug, important for that platform,
tiny, no new API, applies cleanly.

Risk vs benefit: two MMIO writes at probe vs boot IRQ storms on OpenBMC
NPCM845. Benefit dominates.

Concerns: no public reproducer; NPCM7XX still has the same gap (does not
block this fix). No extra backports required.

Verification:
- [Phase 1] Parsed tags: only Tomer Maimon + Linus Walleij SOBs; no
  Fixes/Reported-by/stable
- [Phase 2] Diff: +3 lines in `npcm8xx_gpio_fw()`; EVEN=0 then
  EVST=0xffffffff
- [Phase 2] Handler at lines 210–227 ANDs EVST with EVEN then
  `generic_handle_domain_irq()`
- [Phase 2] `npcmgpio_irq_ack()` writes `BIT(gpio)` to EVST → W1C
  confirmed
- [Phase 3] Driver added in acf4884a57170 (v6.7-rc1); blame of
  surrounding init is that commit
- [Phase 3] `git merge-base --is-ancestor` of the fix vs HEAD: commit is
  in this 7.3 history; code path exists either way
- [Phase 3] Standalone vs 8-patch series: no shared symbols with
  neighboring patches
- [Phase 4] `b4 dig -c cd39cce4cfd49`: lore msgid
  20260715122923.1938327-5; v1 4/8
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: linusw, brgl, openbmc, linux-gpio
- [Phase 4] mbox: Linus Walleij “No comments so patches applied.”; no
  NAK; no Cc: stable
- [Phase 4] Cover letter (LKML archive): vendor-tree comparison; this
  patch listed as stale-event clear
- [Phase 4] lore.kernel.org/stable: 403, UNVERIFIED
- [Phase 5] Callers: `npcm8xx_pinctrl_probe` only; 8 DT GPIO banks,
  GIC_SPI 116–123 level-high
- [Phase 6] `git describe HEAD`: v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion`: 7.3.0-rc4
- [Phase 6] File and `fwnode_irq_get` insertion point present; apply
  would be clean
- [Phase 8] Failure mode: spurious chained GPIO IRQs / possible level-
  triggered storm at probe; HIGH on NPCM8XX, not core-wide
- UNVERIFIED: stable@ list discussion; independent user reports

**YES**

 drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c b/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
index c94441b2acdae..22cc87d43ea69 100644
--- a/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
+++ b/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
@@ -2412,6 +2412,9 @@ static int npcm8xx_gpio_fw(struct npcm8xx_pinctrl *pctrl)
 		if (ret < 0)
 			return dev_err_probe(dev, ret, "Failed to retrieve IRQ for bank %u\n", id);
 
+		iowrite32(0, pctrl->gpio_bank[id].base + NPCM8XX_GP_N_EVEN);
+		iowrite32(0xffffffff, pctrl->gpio_bank[id].base + NPCM8XX_GP_N_EVST);
+
 		pctrl->gpio_bank[id].irq = ret;
 		pctrl->gpio_bank[id].irq_chip = npcmgpio_irqchip;
 		pctrl->gpio_bank[id].irqbase = id * NPCM8XX_GPIO_PER_BANK;
-- 
2.53.0

