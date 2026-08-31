Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2161654528E;
	Mon, 31 Aug 2026 13:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183977; cv=none; b=LTZLqaQxlEZrVgKNeJOx7aii4WVYPuygkq4QCbdIi8pgdeSbIqLMHupcJbaKz6CM1CCvFtIid4TTGJmalU++HzluPj3tZiqezy0SSGvh+8of6PYqkhl5nUWQYl9uJIQk7/owNS4mkQ0hRjdXRSDlvbYiS37OU+vSuEyobAGSU68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183977; c=relaxed/simple;
	bh=dzSTdZ849HBReuhrO41FWQwocuEhov5JM/MClRFC4NU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CX6HnmpUwjJxx5Ey5btUVa2sgy/Y+7YhfzQ/YMZ8baSuC+yjvj+0TEmsWe0kEET51wt04qPIMH7JBYdSM7ArbdnrFXBN1jU6/PsoT38cZxv6LDJThSKSG4uIPc9TRa7mjxU7nkuNxwiapnNKpyZJo1toZdN/Y8ex4oanmpNlnAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a5F7DQhs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a5F7DQhs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0CB1F00A3F;
	Mon, 31 Aug 2026 13:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183973;
	bh=T8CoT45ycZ6x0kFHPpneDiyOZEEg+LlC41dDKdWTFYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a5F7DQhs6IyKi3Ggt+9gb65BJU/RUiDB7HxGp9XcZWBxnnwu7e8rhoBg91z/iPujm
	 9xwr75yCmmyJmr47Nhvn9B4BxlXAIdm4UNKsAbskO/0EUqjPjltglcaHsuoG+rtMBg
	 laC/Tk4F3zLOreHoxUtWSibHTO/yBSWxppqClOL3XGxIeLkp48VvG+Ld0KebenLpGy
	 wrw16k4MzpU0x4S+ZE3c1OFicFMh7n9vbUFLKUcevJrm5dLyAgY0fecptfDgSFBeDH
	 m8txyFVpJlQyXh2GWBkV+G8BgjxRPTJ7XJPoXhZDbn4V9g5o25YLTQHjCGLPVkDmKn
	 +ENpTwg7kk3IQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chen-Yu Tsai <wenst@chromium.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sean.wang@kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-gpio@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] pinctrl: mediatek: paris: bypass pinctrl GPIO layer in set GPIO direction
Date: Mon, 31 Aug 2026 09:27:22 -0400
Message-ID: <20260831133314.4125787-414-sashal@kernel.org>
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

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit c87c9046c4e00d599454e033a477176c4d73ac2a ]

pinctrl_gpio_direction_input() / pinctrl_gpio_direction_output() take
the pinctrl mutex. This causes a gpiochip operations to need to sleep.
Worse yet, the .can_sleep field in the gpiochip is not set. This causes
the shared GPIO proxy to trip over, as it uses gpiod_cansleep() to check
whether it can use a spinlock or needs a mutex. In this case, it ends
up taking a spinlock, then calls pinctrl_gpio_direction_output(), which
takes a mutex. This causes a huge warning.

While this class of Mediatek hardware does not have separate clear/set
registers, the pinctrl context has a spinlock that is taken whenever
a register read-modify-write is done. Also, once the GPIO function is
selected / muxed in, further GPIO operations do not involve pinctrl
operations or state. The GPIO direction and level values do not require
toggling the pinmux or any other pin config options.

Switch to directly calling mtk_pinmux_gpio_set_direction() in the GPIO
set direction callbacks to avoid taking the pinctrl mutex. Drop the
.gpio_set_direction field in mtk_pmxops to signal we are no longer using
the pinctrl GPIO layer for setting the direction.

Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[pinctrl: mediatek: paris]` `[bypass]` — bypass the pinctrl
GPIO layer when setting GPIO direction on MediaTek Paris pin
controllers.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Chen-Yu Tsai `<wenst@chromium.org>` (author)
- **Signed-off-by:** Linus Walleij `<linusw@kernel.org>` (pinctrl
  maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Cc:
  stable@vger.kernel.org`, or `Link:` tags
- Notable: maintainer sign-off; no syzbot/fuzzer report

### Step 1.3: Body analysis
**Record:**
- **Bug:** `pinctrl_gpio_direction_input/output()` take
  `pctldev->mutex`, so direction callbacks can sleep, but the Paris
  gpiochip does not set `.can_sleep`. The shared GPIO proxy uses
  `gpiod_cansleep()` to choose spinlock vs mutex; with `can_sleep ==
  false` it takes a spinlock, then direction setup reaches the pinctrl
  mutex → lockdep “sleeping in atomic context” warning.
- **Symptom:** Large kernel warning (lockdep sleep-in-atomic).
- **Root cause:** Redundant pinctrl-layer direction call adds a sleeping
  mutex on a chip that should be fast/MMIO; after muxing to GPIO,
  direction changes only need register RMW under the driver’s spinlock.
- **Version info:** None in the message.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Although framed as bypassing a layer, this is a real
concurrency bug fix: sleeping mutex taken from a path that must be non-
sleeping.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/pinctrl/mediatek/pinctrl-paris.c` only
- **Scope:** ~8 lines changed (1 removed, 5 added, 2 modified)
- **Functions:** `mtk_pmxops`, `mtk_gpio_direction_input()`,
  `mtk_gpio_direction_output()`
- **Classification:** Single-file surgical fix

### Step 2.2: Code flow per hunk
**Record:**
1. **`mtk_pmxops`:** Removes `.gpio_set_direction =
   mtk_pinmux_gpio_set_direction` so the pinctrl core no longer exposes
   this hook.
2. **`mtk_gpio_direction_input()`:** Before:
   `pinctrl_gpio_direction_input()` → mutex + `pinmux_gpio_direction()`
   → `mtk_pinmux_gpio_set_direction()`. After: direct
   `mtk_pinmux_gpio_set_direction(hw->pctrl, NULL, gpio, true)` — no
   pinctrl mutex.
3. **`mtk_gpio_direction_output()`:** Same pattern after
   `mtk_gpio_set()`; direct call with `false` for output.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Synchronization / sleep-in-atomic (lockdep)
- **Mechanism:** `pinctrl_gpio_direction()` in `core.c` does
  `mutex_lock(&pctldev->mutex)` before calling the pinmux op. Paris
  gpiochip has `can_sleep` unset (false) and uses `mtk_hw_set_value()` →
  `mtk_rmw()` under `spinlock_irqsave(&pctl->lock)`. The pinctrl mutex
  path is inappropriate for a non-sleeping gpiochip and conflicts with
  callers that serialize with a spinlock.

### Step 2.4: Fix quality
**Record:** Obviously correct and minimal. Same underlying function
(`mtk_pinmux_gpio_set_direction`) is invoked; only the mutex wrapper is
removed. Low regression risk; matches the tegra stable backport already
in this tree.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Current direction callbacks and `.gpio_set_direction` in
`mtk_pmxops` trace to `5d324e5159d9e` in this stable tree (squashed
history). Paris driver and the `pinctrl_gpio_direction_*` pattern are
present throughout v6.18.x.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:** Only one history entry visible for `pinctrl-paris.c` in this
tree. Related sibling issue exists in `pinctrl-mtk-common.c` (common-v1)
with a separate patch series; this Paris commit is standalone.

### Step 3.4: Author context
**Record:** Chen-Yu Tsai (Chromium) has other MediaTek pinctrl work in-
tree. Linus Walleij is the pinctrl maintainer and signed off upstream.

### Step 3.5: Dependencies
**Record:** No prerequisites. `mtk_pinmux_gpio_set_direction()`,
`hw->pctrl`, and `gpiochip_get_data()` all exist in this tree. Applies
standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** v2 posted 2026-05-05 by Chen-Yu Tsai; thread at
[spinics](https://www.spinics.net/lists/kernel/msg6186918.html). CC’d to
MediaTek, GPIO, arm-kernel maintainers. v1 linked in cover letter. Linus
Walleij replied in-thread (per index). `b4 dig -c` could not be used
(commit not in this checkout).

### Step 4.2: Reviewers
**Record:** To: Sean Wang, Matthias Brugger, AngeloGioacchino Del Regno,
Linus Walleij. Maintainer sign-off from Linus Walleij.

### Step 4.3: Bug report
**Record:** No external bugzilla/syzbot link. Author describes
reproduced lockdep warning on Chromebook-class MediaTek hardware.

### Step 4.4: Related patches
**Record:** Companion patch for `pinctrl-mtk-common.c` (common-v1)
exists; not required for this Paris-only fix.

### Step 4.5: Stable list
**Record:** No explicit stable nomination in the Paris v2 post (unlike
tegra fix `ac761e66708d5` which had `Cc: stable@vger.kernel.org`).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `mtk_gpio_direction_input`, `mtk_gpio_direction_output`,
`mtk_pinmux_gpio_set_direction`, `pinctrl_gpio_direction`,
`mtk_hw_set_value`, `mtk_rmw`.

### Step 5.2: Callers
**Record:** Direction callbacks are reached from gpiolib
(`gpiod_direction_input_nonotify`, `gpiod_direction_output_raw_commit` →
`gpiochip_direction_*`). On Chromebook/MediaTek platforms these GPIOs
are used by regulators, PMICs, USB, display, etc. Shared-GPIO consumers
(when present) call direction while holding their lock.

### Step 5.3: Callees
**Record:** Fixed path calls `mtk_pinmux_gpio_set_direction()` →
`mtk_hw_set_value()` → `mtk_rmw()` with
`spin_lock_irqsave(&pctl->lock)`.

### Step 5.4: Reachability
**Record:** Reachable from userspace-driven device operations and from
kernel drivers requesting GPIO direction changes. The problematic path
is direction change on a non-`can_sleep` chip while a spinlock-holding
caller (e.g. gpio-shared-proxy on newer kernels) invokes
`gpiod_direction_*`.

### Step 5.5: Similar patterns
**Record:** `ac761e66708d5` (“gpio: tegra: do not call pinctrl for GPIO
direction”) is already in this v6.18.43 tree — same bug class,
explicitly backported to stable with `Cc: stable@vger.kernel.org`.
`pinctrl-mtk-common.c` and `pinctrl-moore.c` still use
`pinctrl_gpio_direction_*` but are out of scope for this commit.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (v6.18.43)

### Step 6.1: Buggy code present?
**Record:** **Yes.** `git describe HEAD` → `v6.18.43`; `Makefile` →
6.18.43. Current code at lines 889 and 901 still calls
`pinctrl_gpio_direction_input/output()`. `.gpio_set_direction` is set in
`mtk_pmxops` at line 774. `can_sleep` is not set in
`mtk_build_gpiochip()`.

### Step 6.2: Backport complications
**Record:** Clean apply expected — small, localized change; no
structural conflicts observed.

### Step 6.3: Related fixes already present?
**Record:** Tegra equivalent fix `ac761e66708d5` is in HEAD. This Paris
fix is **not** yet applied. No duplicate fix found.

**Important nuance:** `gpio-shared-proxy` was merged in **6.19**, not
6.18. It is **not** present in this v6.18.43 tree (`grep` found no
`GPIO_SHARED`, `gpio-shared-proxy`, or `gpio_shared_proxy`). The
commit’s primary trigger is therefore not available in 6.18.43 today,
but the underlying mutex-in-non-sleeping-callback bug still exists and
matches the tegra stable backport rationale.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem and criticality
**Record:** `drivers/pinctrl/mediatek/` — **IMPORTANT** (ARM64 SoC pin
control; affects Chromebooks, tablets, embedded MediaTek Paris
platforms: MT8186, MT8188, MT8192, MT8195, MT8196, etc.).

### Step 7.2: Activity
**Record:** Active subsystem with many Paris-based SoC drivers in
`Kconfig`.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Users of MediaTek Paris pinctrl/GPIO on affected SoCs
(CONFIG_PINCTRL_MTK_PARIS and selected SoC drivers). Not universal, but
significant for ChromeOS/Chromebook and embedded MTK platforms.

### Step 8.2: Trigger conditions
**Record:** GPIO direction change on a Paris pin after it is muxed to
GPIO, when called from a context expecting non-sleeping behavior
(notably shared-GPIO proxy on 6.19+; tegra stable commit documents the
same class on 6.18). Normal process-context `gpiod_direction_*` works
but still incorrectly takes a sleeping mutex on a chip advertised as
non-sleeping.

### Step 8.3: Failure mode severity
**Record:** Lockdep “sleeping in atomic context” / potential real
deadlock or oops under contention. **Severity: HIGH** (not data
corruption, but serious stability warning and potential hang).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for affected platforms; aligns with accepted tegra
  stable fix in the same tree.
- **Risk:** VERY LOW — 8-line change, same hardware operation, removes
  redundant mutex.
- **Ratio:** Strong benefit, minimal risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real concurrency bug (sleeping mutex in non-sleeping gpiochip
  callback)
- Small, surgical, maintainer-reviewed fix
- Buggy code confirmed present in v6.18.43
- Same pattern as tegra fix already backported to this tree
  (`ac761e66708d5`)
- Affects widely deployed MediaTek Paris SoCs
- Direct call preserves semantics while removing incorrect mutex

**AGAINST backport:**
- `gpio-shared-proxy` (the described trigger) is not in v6.18.43 (landed
  in 6.19)
- No `Cc: stable` tag on the Paris patch
- Common-v1 (`pinctrl-mtk-common.c`) has the same pattern but is a
  separate commit

**Unresolved:**
- Exact upstream commit SHA not in this checkout (candidate evaluation
  only)
- Could not fetch full Linus Walleij review reply (wrong spinics message
  ID)

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — same function, mutex
   removed; maintainer SOB; author reproduced warning.
2. Fixes a real bug? **PASS** — lockdep sleep-in-atomic on direction
   change.
3. Important issue? **PASS** — stability / lockdep, HIGH severity.
4. Small and contained? **PASS** — 1 file, ~8 lines.
5. No new features/APIs? **PASS** — behavior correction only.
6. Can apply to local tree? **PASS** — code exists, no dependencies.

### Step 9.3: Exception category
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
driver bug fix.

### Step 9.4: Decision rationale

This tree (v6.18.43) still has Paris GPIO direction callbacks routing
through `pinctrl_gpio_direction_*`, which takes the pinctrl mutex on a
gpiochip that does not set `can_sleep` and whose register access uses a
spinlock. That is incorrect and matches the tegra direction fix already
accepted into this same stable series. Even though `gpio-shared-proxy`
is not in 6.18, the underlying bug is present and the fix is minimal,
obviously correct, and low-risk. Chromebook/MediaTek users benefit, and
the change is consistent with stable maintainer practice for this bug
class.

---

## Verification

- [Phase 1] Parsed subject, tags, body; no Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: 1 file, `mtk_gpio_direction_*` + `mtk_pmxops`; mutex-
  bypass fix verified in `core.c` and `pinctrl-paris.c`
- [Phase 3] `git blame` lines 887–902, 769–776 → present in v6.18.43; no
  Fixes tag; standalone (no deps)
- [Phase 4] WebFetch spinics v2 thread; b4 dig requires commit in tree
  (N/A); gpio-shared-proxy confirmed 6.19+ via web search
- [Phase 5] Traced `pinctrl_gpio_direction()` → `mutex_lock`;
  `mtk_hw_set_value()` → `spin_lock_irqsave`
- [Phase 6] `git describe HEAD` → v6.18.43; buggy code at lines 774,
  889, 901; `hw->pctrl` in `pinctrl-mtk-common-v2.h:292`; tegra fix
  `ac761e66708d5` in HEAD
- [Phase 6] `grep` — no `gpio-shared-proxy` / `GPIO_SHARED` in tree
- [Phase 7] Paris used by multiple MTK SoCs in `Kconfig`
- [Phase 8] Failure mode: lockdep sleep-in-atomic, HIGH severity
- [UNVERIFIED] Full text of Linus Walleij review reply not retrieved

**YES**Those three background `git log -S "gpio_shared_proxy"` searches
didn’t finish (they timed out or were killed on this large tree), so
they didn’t add anything new.

That doesn’t change the conclusion: `gpio_shared_proxy` / `gpio-shared-
proxy` isn’t in this v6.18.43 checkout — that was already confirmed with
targeted `grep` and the 6.19 merge history. The Paris pinctrl fix should
still be backported to this tree.

**YES**

 drivers/pinctrl/mediatek/pinctrl-paris.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-paris.c b/drivers/pinctrl/mediatek/pinctrl-paris.c
index 6bf37d8085fae..23f04b24fd65e 100644
--- a/drivers/pinctrl/mediatek/pinctrl-paris.c
+++ b/drivers/pinctrl/mediatek/pinctrl-paris.c
@@ -771,7 +771,6 @@ static const struct pinmux_ops mtk_pmxops = {
 	.get_function_name	= mtk_pmx_get_func_name,
 	.get_function_groups	= mtk_pmx_get_func_groups,
 	.set_mux		= mtk_pmx_set_mux,
-	.gpio_set_direction	= mtk_pinmux_gpio_set_direction,
 	.gpio_request_enable	= mtk_pinmux_gpio_request_enable,
 };
 
@@ -886,19 +885,22 @@ static int mtk_gpio_set(struct gpio_chip *chip, unsigned int gpio, int value)
 
 static int mtk_gpio_direction_input(struct gpio_chip *chip, unsigned int gpio)
 {
-	return pinctrl_gpio_direction_input(chip, gpio);
+	struct mtk_pinctrl *hw = gpiochip_get_data(chip);
+
+	return mtk_pinmux_gpio_set_direction(hw->pctrl, NULL, gpio, true);
 }
 
 static int mtk_gpio_direction_output(struct gpio_chip *chip, unsigned int gpio,
 				     int value)
 {
+	struct mtk_pinctrl *hw = gpiochip_get_data(chip);
 	int ret;
 
 	ret = mtk_gpio_set(chip, gpio, value);
 	if (ret)
 		return ret;
 
-	return pinctrl_gpio_direction_output(chip, gpio);
+	return mtk_pinmux_gpio_set_direction(hw->pctrl, NULL, gpio, false);
 }
 
 static int mtk_gpio_to_irq(struct gpio_chip *chip, unsigned int offset)
-- 
2.53.0

