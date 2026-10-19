Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A96573F03;
	Mon, 19 Oct 2026 13:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418303; cv=none; b=b2xsFxpVFRy2s6o+3zRLuCgU3oazzJnNI8aOO8H4NjxB9+hL9T1YZEmEzvNZF1r7nqQKVYoOvNyV/5ox/ssBZKwae3FqBWK8weIt39sQsZ7Px80BZE6+Ogfnj/IwsSVPAOBLZ/kN2fzrMaepyhHoPMOcYq6IIXsMZorcM76Iv3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418303; c=relaxed/simple;
	bh=reNTbulWtZkpKW51F+Zgm+JhgwNiirUaORyC4DQ2p7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tYX78iDxYnb+D0wQiX8j0Hul3hGexuGvzyAMV8BIu5H2L7VAnQlyX+JgrL14qtE6o7BYkZZuaSyt1ctj3fawcac502jV2djwF4tZYYO+yJGXBudLXKzxGdOQg+VBIXxES/k0fyhcDfczBlHDbtlfaqaCvp4BSuwb7Xu3ZWEMPbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MxPJ/UzN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MxPJ/UzN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389BE1F000C6;
	Mon, 19 Oct 2026 13:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418301;
	bh=IQU3dA6xvKPcYP6SCDYrIRIPyx97Hcsp1xf1UGbJEZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MxPJ/UzNp32fM6o9ncxZMOqTe/z971tqARlT+Sh4AZ91zqNcHZnJy19MhgwM0PSku
	 XxUC6/XLSaxOQQkRhmZ6SAmLczb+AaVuSlK3E/s3LXJ5eA/vGCdJK/H/JXEftSa6CU
	 eMI5/1tCAScInouaG5e/SRwCXCVfibeSyPkD1Vc8g/cZqY00T/EhmgVHVp1Mh+EbEs
	 kT2WtoBn08dA65js0ryULQBFuoDQ3q64m7CAV/eUEiEOkvWG+fDBLVx10DlDgrA2x9
	 LdoGUPiBrd5QF1G8MJw4JYpCtM7KMaMrdFSFW7lz2AxH1f+y8Vm8vg/hLOHKdvY44n
	 msXa4o9ojPO+Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rosen Penev <rosenp@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	linusw@kernel.org,
	brgl@kernel.org,
	linux-gpio@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] gpio: mvebu: keep resume masks within the irqchip cache
Date: Mon, 19 Oct 2026 09:47:21 -0400
Message-ID: <20261019135441.1420968-150-sashal@kernel.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 02af7eac17bc62a72335c1fc8c4af4471654f6cc ]

mvebu_gpio_resume() writes the edge/level mask registers saved at
suspend time straight back to hardware, bypassing the irqchip's
mask_cache_priv.  genirq skips mask_irq() for a line it already
considers masked, so restoring a bit in hardware that genirq thinks
is still masked leaves that line unmasked behind genirq's back.  An
asserted level line then has nobody to ack it, and the moment
interrupts are re-enabled the chained handler storms, hanging resume.

AND the restored mask values with the matching irqchip mask cache so
only lines genirq currently considers unmasked are unmasked again.
Read the caches under gc->lock to keep them consistent with the
mask/unmask handlers.

Tested on Helios4 (armhf): 5 suspend cycles woken by magic packet,
no hang; mvebu_gpio_resume() returns in 6 usecs.

Assisted-by: LLM
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://patch.msgid.link/20260915004406.115230-1-rosenp@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a real resume hang in `gpio-mvebu`: restoring stale mask bits
can unmask a level line behind genirq and storm the chained handler. The
buggy restore is in this 6.18.57 tree and the patch is small enough to
backport.

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
- Record: `[gpio/mvebu] [keep/prevent] keep resume masks within the
  irqchip cache` — stop `mvebu_gpio_resume()` from writing suspend-time
  mask bits that genirq still considers masked.

**Step 1.2 — Tags**
- Record:
  - `Assisted-by: LLM`
  - `Signed-off-by: Rosen Penev <rosenp@gmail.com>` (author)
  - `Link:
    https://patch.msgid.link/20260915004406.115230-1-rosenp@gmail.com`
  - `Signed-off-by: Bartosz Golaszewski
    <bartosz.golaszewski@oss.qualcomm.com>` (GPIO maintainer)
  - No `Fixes:`, `Reported-by:`, `Tested-by:`, `Cc: stable` (absence
    expected)
  - Ignore `[Upstream commit 02af7eac17bc...]` and `Signed-off-by: Sasha
    Levin`

**Step 1.3 — Body**
- Record:
  - **Bug:** `mvebu_gpio_resume()` writes saved edge/level mask
    registers straight to hardware, bypassing `mask_cache_priv`.
  - **Symptom:** resume hang — an asserted level line is unmasked while
    genirq still thinks it is masked, so nobody acks it and the chained
    handler storms once IRQs are live.
  - **Root cause (author):** `mask_irq()` is skipped when genirq already
    considers the line masked (`irqd_irq_masked`).
  - **Fix:** AND restored values with the irqchip mask cache; read
    caches under `gc->lock`.
  - **Testing:** Helios4 (armhf), 5 suspend cycles woken by magic
    packet, no hang; `mvebu_gpio_resume()` ~6 µs.
  - **Versions:** none named.

**Step 1.4 — Hidden bug fix?**
- Record: Not hidden. The subject uses “keep … within” but the body
  describes a resume hang from an IRQ storm. This is an explicit
  correctness fix.

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
- Record:
  - File: `drivers/gpio/gpio-mvebu.c` (+27 / −6)
  - Function: `mvebu_gpio_resume()` only
  - Classification: single-file surgical fix

**Step 2.2 — Control flow**
- Record:
  - **Before:** restore `edge_mask_regs[]` / `level_mask_regs[]`
    verbatim to hardware.
  - **After:** if `mvchip->domain` is set, snapshot
    `gc->chip_types[0].mask_cache_priv` (level) and `[1]` (edge) under
    `gc->lock`, drop the lock, then write `saved & cache`. If there is
    no domain, caches stay `~0U` so behavior is unchanged.
  - Path: system resume of the GPIO platform device, after
    `resume_device_irqs()`.

**Step 2.3 — Bug mechanism**
- Record: **Logic / interrupt-state desync** that produces a **level IRQ
  storm / resume hang**.
  - `mask_irq()` returns immediately if `irqd_irq_masked()` is already
    set (`kernel/irq/chip.c`).
  - `handle_level_irq()` does `mask_ack_irq()` then `irq_can_handle()`.
    If the line is disabled, it returns without running the handler.
    Level GPIO has no separate ack; masking is the ack.
  - Blind restore can put 1s in the HW mask while genirq still has
    `IRQD_IRQ_MASKED`. The chained handler (`mvebu_gpio_irq_handler`)
    keeps seeing `data_in & level_mask` and storms.

**Step 2.4 — Fix quality**
- Record: Minimal and locally correct. `chip_types[0]` is level and
  `[1]` is edge in `mvebu_gpio_probe()` in this tree, matching the
  snapshot. Unlock-before-`regmap_write` is required because
  `regmap_write()` can take a sleepable lock on PREEMPT_RT (`gc->lock`
  is a `raw_spinlock_t`).
- Regression risk: low. AND can only clear extra bits, never unmask more
  than both the snapshot and genirq allow. The `saved==0 && cache==1`
  “lost IRQ” case already wrote 0 before this patch. Remaining TOCTOU
  after dropping the lock is the same class of window v1 tried to close
  by holding the lock across `regmap_write`, which is illegal on RT; v2
  is the applied compromise.

## Phase 3: Git history

**Step 3.1 — Blame**
- Record: Resume save/restore added by `b5b7b487431b0` (“gpio: mvebu:
  add suspend/resume support”, Thomas Petazzoni, 2014-10-24), first in
  **v3.19-rc1**. Present for a long time; this is not new 6.18-only
  code.

**Step 3.2 — Fixes: tag**
- Record: None. Buggy pattern is the 2014 suspend/resume support, not a
  recent regression commit.

**Step 3.3 — Related file history**
- Record:
  - `6136c1474db88` gpio: mvebu: fix NULL pointer dereference in
    suspend/resume (PWM NULL) — related path, different bug.
  - `3bfcce441c552` gpio: mvebu: free generic chips on unbind — same
    author, teardown leak, not a prerequisite.
  - No later follow-up on this file after the candidate (`git log
    cb5b039e115ea..HEAD -- drivers/gpio/gpio-mvebu.c` is empty).

**Step 3.4 — Author**
- Record: Rosen Penev is a regular contributor, not the GPIO maintainer.
  Two mvebu commits in this tree. Maintainer (Bartosz) applied it; Linus
  Walleij reviewed v1.

**Step 3.5 — Dependencies**
- Record: Standalone. Uses `irq_get_domain_generic_chip()`,
  `mask_cache_priv`, `gc->lock`, and `mvchip->domain`, all already in
  this tree. Not patch X/Y.

## Phase 4: Mailing list / external

**Step 4.1 — Original discussion**
- Record:
  - Lore / msgid:
    https://patch.msgid.link/20260915004406.115230-1-rosenp@gmail.com
  - **v1:**
    https://patch.msgid.link/20260912221937.71403-1-rosenp@gmail.com —
    held `gc->lock` across `regmap_write`.
  - **v2 (applied):** unlock before `regmap_write` (changelog: “Unlock
    spinlock before regmap_write”).
  - `b4 dig -a` found only v1 and v2. `b4 mbox -c` did not find a newer
    revision.
  - Linus Walleij: `Reviewed-by` on v1.
  - Bartosz: “Applied, thanks!”
  - Sebastian Andrzej Siewior (RT): asked why the mask changes after
    suspend; later “This looks like a hack with no explanation about the
    root cause.” Not a NAK of the hang; complaint about the write-up.
  - Rosen, after apply: “I had a v3 ready … to fix sashiko’s issue. I
    guess I’ll send it separately.” No v3 found in this tree or via
    `b4`.
  - Sashiko bot flagged a TOCTOU after dropping the lock, and a pre-
    existing `saved & cache` lost-IRQ case. The lost-IRQ case is not
    made worse (see 2.4). No reviewer nominated `Cc: stable`.

**Step 4.2 — Recipients (`b4 dig -w`)**
- Record: `linux-gpio@vger.kernel.org`, Linus Walleij, Bartosz
  Golaszewski, linux-kernel; v2 also CC’d Sebastian Siewior, Clark
  Williams, Steven Rostedt, `linux-rt-devel` because of the PREEMPT_RT
  lock/sleep issue.

**Step 4.3 — Bug report**
- Record: No syzbot/bugzilla link. Author reports Helios4 magic-packet
  wakeup hangs without the patch.
  `arch/arm/boot/dts/marvell/armada-388-helios4.dts` is in this tree.

**Step 4.4 — Series**
- Record: Standalone one-patch series. Not 2/3.

**Step 4.5 — Stable list**
- Record: lore.kernel.org/stable search returned HTTP 403. No stable
  discussion found via `b4`. **UNVERIFIED:** whether anyone already
  requested or rejected this on stable@.

## Phase 5: Semantic / call graph

**Step 5.1 — Functions**
- Record: only `mvebu_gpio_resume()`.

**Step 5.2 — Callers**
- Record: `platform_driver.mvebu_gpio_driver.resume`. Reachable from
  system suspend/resume (`dpm_resume` → driver `.resume`), not from a
  syscall on a hot path.

**Step 5.3 — Callees**
- Record: `irq_get_domain_generic_chip()`,
  `raw_spin_lock_irqsave`/`unlock`, `regmap_write()`, optional
  `mvebu_pwm_resume()`.

**Step 5.4 — Reachability**
- Record: Userspace triggers via `/sys/power/state` (or equivalent).
  Helios4 WOL GPIO is a typical level wakeup. `CONFIG_GPIO_MVEBU` is
  `default y` on `ARCH_MVEBU`/`PLAT_ORION`.

**Step 5.5 — Similar patterns**
- Record: No other gpio driver in this tree ANDs resume masks with
  `mask_cache_priv`. This is mvebu-specific because it saves/restores
  mask registers itself instead of using generic irqchip suspend/resume.

## Phase 6: This tree (6.18.y)

**Step 6.1 — Does the bug exist here?**
- Record: **Yes.** `make kernelversion` / Makefile: **6.18.57**. `git
  describe HEAD`: `v6.18.57-155-gcdf239ca885b2`.
- `v6.18.57:drivers/gpio/gpio-mvebu.c` `mvebu_gpio_resume()` writes
  `mvchip->edge_mask_regs[]` / `level_mask_regs[]` with **no** cache
  AND. Diff of that function vs the candidate’s parent is empty.
- Probe in v6.18.57 already has `chip_types[0]` level, `chip_types[1]`
  edge, and `mvchip->domain`.

**Step 6.2 — Backport difficulty**
- Record: **Clean apply.** Same resume function, same irqchip layout,
  same APIs.

**Step 6.3 — Related fixes already here?**
- Record: PWM NULL check in suspend/resume is present and different.
  Nothing else intersects mask-cache vs HW restore.

## Phase 7: Subsystem context

**Step 7.1**
- Record: `drivers/gpio/gpio-mvebu.c` — Marvell Orion/EBU GPIO irqchip.
  **IMPORTANT** for ARCH_MVEBU (Armada 370/XP/38x/8K, Helios4, Clearfog,
  etc.), not core mm/VFS.

**Step 7.2**
- Record: Mature driver (suspend/resume since 2014). Recent commits are
  small fixes, not a rewrite.

## Phase 8: Impact and risk

**Step 8.1 — Who is affected**
- Record: Platform-specific: `CONFIG_GPIO_MVEBU` (default on Marvell
  EBU). Users who suspend/resume, especially with GPIO/level wakeup
  (WOL).

**Step 8.2 — Trigger**
- Record: System suspend then resume with an asserted level GPIO
  (author: magic packet on Helios4). Not unprivileged-exploit in the
  syzbot sense; any user who can suspend can hit it. Timing-sensitive
  around genirq vs HW mask.

**Step 8.3 — Failure mode**
- Record: Chained IRQ storm → resume hang. **CRITICAL** for affected
  boards.

**Step 8.4 — Risk/benefit**
- Record: **Benefit high** (unhang resume on real hardware). **Risk
  low** (one function, conservative AND, tested, GPIO maintainer
  applied). Remaining TOCTOU is a small window required for RT, not a
  reason to keep the hang.

## Phase 9: Synthesis

**Step 9.1 — Evidence**

FOR:
- Resume hang / IRQ storm is a real user-visible failure.
- Author reproduced and tested on Helios4 (DT in this tree).
- Mechanism matches genirq: `mask_irq()` skip + `handle_level_irq()` +
  chained GPIO handler.
- Buggy restore is in **this** 6.18.57 tree; bug dates to v3.19.
- +27/−6, one function, no new API.
- Applies cleanly.
- Reviewed by Linus Walleij; applied by Bartosz Golaszewski.

AGAINST:
- Sebastian Siewior called the explanation a hack (write-up, not a
  demonstrated regression).
- Author mentioned an unsent v3 for a TOCTOU sashiko flagged; not in
  this tree.
- No `Fixes:` / syzbot / stable Cc (not a negative per the rules).
- Driver-specific, not universal.

UNRESOLVED:
- Stable@ discussion (lore 403).
- Whether v3 was ever posted after 2026-09-17.

**Step 9.2 — Stable rules**
1. Obviously correct and tested? **PASS** — AND with irqchip cache;
   Helios4 test; maintainer applied.
2. Real bug affecting users? **PASS** — resume hang on Marvell EBU
   boards.
3. Important (crash/hang/corruption/deadlock)? **PASS** — resume hang /
   IRQ storm.
4. Small and contained? **PASS** — one function, ~30 lines.
5. No new features/APIs? **PASS**.
6. Can apply to this tree? **PASS** — v6.18.57 resume path matches the
   parent.

**Step 9.3 — Exceptions**
- Record: None (not a device ID / quirk / DT / build / docs exception).
  Ordinary driver bugfix.

**Step 9.4 — Decision**
Backport to this 6.18.57 tree. The hang is in-tree, the fix is surgical,
and the remaining RT lock-drop window is weaker than leaving resume
broken.

### What the commit solves for this tree
On 6.18.57, `mvebu_gpio_resume()` still restores suspend-time EDGE/LEVEL
mask registers blindly. If genirq has since masked a line (lazy disable,
wakeup handling, in-progress level IRQ), that write unmasks hardware
while `mask_irq()` is a no-op. An asserted level GPIO then has no ack
path; `mvebu_gpio_irq_handler` storms and resume hangs. AND-ing with
`mask_cache_priv` keeps hardware from going beyond what genirq currently
has unmasked.

### Risk vs benefit
Benefit is an unhang of suspend/resume on in-tree Marvell EBU platforms
(Helios4 and similar). Risk is a short snapshot-vs-write window
(required so `regmap_write` is not called under a raw spinlock on
PREEMPT_RT) and a theoretically more conservative mask; both are
preferable to the current hang.

## Verification
- [Phase 1] Parsed tags: author Rosen Penev; Link msgid
  20260915004406.115230-1; Bartosz SOB; no Fixes/Reported-by/stable Cc.
- [Phase 2] Diff: +27/−6 in `mvebu_gpio_resume()` only; AND saved masks
  with `mask_cache_priv`.
- [Phase 2] Probe in this tree: `chip_types[0]` level, `chip_types[1]`
  edge (`drivers/gpio/gpio-mvebu.c` ~1291–1305).
- [Phase 2] `mask_irq()` skips if `irqd_irq_masked()`
  (`kernel/irq/chip.c:428–431`).
- [Phase 2] `handle_level_irq()` → `mask_ack_irq()` then
  `irq_can_handle()`; disabled lines are not handled (`chip.c:686–697`,
  `544–552`).
- [Phase 2] `gc->lock` is `raw_spinlock_t`
  (`include/linux/irq.h:1052–1053`).
- [Phase 3] Blame: resume path from `b5b7b487431b0`, contained in
  v3.19-rc1; ancestor of HEAD.
- [Phase 3] No follow-up on `gpio-mvebu.c` after this candidate.
- [Phase 4] `b4 dig -c 02af7eac17bc...`: v1 + v2; applied version is v2.
- [Phase 4] `b4 dig -w`: gpio lists + RT CCs on v2.
- [Phase 4] mbox: Linus Walleij Reviewed-by (v1); Bartosz applied;
  Siewior “hack” comment; Rosen mentioned unsent v3.
- [Phase 4] `b4 mbox -c`: no newer revision found.
- [Phase 4] lore.kernel.org WebFetch: 403. UNVERIFIED: stable@ thread.
- [Phase 5] Resume hooked from `mvebu_gpio_driver.resume`;
  `CONFIG_GPIO_MVEBU` default on ARCH_MVEBU
  (`drivers/gpio/Kconfig:509–514`).
- [Phase 6] `make kernelversion`: 6.18.57; `git describe HEAD`:
  v6.18.57-155-gcdf239ca885b2.
- [Phase 6] `git show v6.18.57:drivers/gpio/gpio-mvebu.c` resume ==
  candidate parent (clean apply).
- [Phase 6] Helios4 DT present:
  `arch/arm/boot/dts/marvell/armada-388-helios4.dts`.
- [Phase 8] Failure mode: chained level IRQ storm → resume hang,
  severity CRITICAL for mvebu boards.

**YES**

 drivers/gpio/gpio-mvebu.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index 39a7ad6585f25..c613d74ed48d0 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -1006,6 +1006,8 @@ static int mvebu_gpio_suspend(struct platform_device *pdev, pm_message_t state)
 static int mvebu_gpio_resume(struct platform_device *pdev)
 {
 	struct mvebu_gpio_chip *mvchip = platform_get_drvdata(pdev);
+	u32 edge_cache = ~0U, level_cache = ~0U;
+	unsigned long flags;
 	int i;
 
 	regmap_write(mvchip->regs, GPIO_OUT_OFF + mvchip->offset,
@@ -1017,32 +1019,51 @@ static int mvebu_gpio_resume(struct platform_device *pdev)
 	regmap_write(mvchip->regs, GPIO_IN_POL_OFF + mvchip->offset,
 		     mvchip->in_pol_reg);
 
+	/*
+	 * genirq skips mask_irq() for a line it already considers masked, so
+	 * unmasking one behind its back leaves an asserted level line that
+	 * nobody masks. Restore only bits the irqchip cache still has set.
+	 *
+	 * Snapshot the caches under the raw spinlock, but release it before
+	 * the regmap writes below: regmap_write() takes a sleepable lock on
+	 * PREEMPT_RT.
+	 */
+	if (mvchip->domain) {
+		struct irq_chip_generic *gc;
+
+		gc = irq_get_domain_generic_chip(mvchip->domain, 0);
+		raw_spin_lock_irqsave(&gc->lock, flags);
+		level_cache = gc->chip_types[0].mask_cache_priv;
+		edge_cache = gc->chip_types[1].mask_cache_priv;
+		raw_spin_unlock_irqrestore(&gc->lock, flags);
+	}
+
 	switch (mvchip->soc_variant) {
 	case MVEBU_GPIO_SOC_VARIANT_ORION:
 	case MVEBU_GPIO_SOC_VARIANT_A8K:
 		regmap_write(mvchip->regs, GPIO_EDGE_MASK_OFF + mvchip->offset,
-			     mvchip->edge_mask_regs[0]);
+			     mvchip->edge_mask_regs[0] & edge_cache);
 		regmap_write(mvchip->regs, GPIO_LEVEL_MASK_OFF + mvchip->offset,
-			     mvchip->level_mask_regs[0]);
+			     mvchip->level_mask_regs[0] & level_cache);
 		break;
 	case MVEBU_GPIO_SOC_VARIANT_MV78200:
 		for (i = 0; i < 2; i++) {
 			regmap_write(mvchip->regs,
 				     GPIO_EDGE_MASK_MV78200_OFF(i),
-				     mvchip->edge_mask_regs[i]);
+				     mvchip->edge_mask_regs[i] & edge_cache);
 			regmap_write(mvchip->regs,
 				     GPIO_LEVEL_MASK_MV78200_OFF(i),
-				     mvchip->level_mask_regs[i]);
+				     mvchip->level_mask_regs[i] & level_cache);
 		}
 		break;
 	case MVEBU_GPIO_SOC_VARIANT_ARMADAXP:
 		for (i = 0; i < 4; i++) {
 			regmap_write(mvchip->regs,
 				     GPIO_EDGE_MASK_ARMADAXP_OFF(i),
-				     mvchip->edge_mask_regs[i]);
+				     mvchip->edge_mask_regs[i] & edge_cache);
 			regmap_write(mvchip->regs,
 				     GPIO_LEVEL_MASK_ARMADAXP_OFF(i),
-				     mvchip->level_mask_regs[i]);
+				     mvchip->level_mask_regs[i] & level_cache);
 		}
 		break;
 	default:
-- 
2.53.0

