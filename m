Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452B049CF27;
	Mon, 31 Aug 2026 13:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183603; cv=none; b=G9jVQdxCwFjS02iP6zvE663xztQpqUZwSLAb2jTPZe2gtM23rKnpGgiYf09pYavEARPp+ZHwtAFhmiVU4YWC9liLiCOoMRnDzogwclK7tJAAqARu7y+hc9mYIGjJTmm8tGIiBkGlgzL6u7ll8U9Aq4PGYbzxfC4NK1xOC4rLKR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183603; c=relaxed/simple;
	bh=HdTqYmRFCqXz2BrcvU61DWP7azzaV565riu46iVoBlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QuT/96BndceJCdEH+HP0e14Q0e2HdMbk2FwztEOU1njUlAcVrabTbd6UX7eF0pSd98b4Km1uISUVm+WPdwAQ0yFwvRVKKlH/oiG/oqEr6El59MEqCwR7kw+ElhFE+OQclZvp1PXWdbBUpcz5dw+h8Q4arkAo0axbBAFmukRjR7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gIWtnluB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gIWtnluB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146F41F00A3E;
	Mon, 31 Aug 2026 13:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183601;
	bh=NtVfbbes/ko7nNCbIZFxZeNaoWBzUa4mLaruX3hFLmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gIWtnluBVQiykWMQo2b6i16IImj3gG6crovtHbdCf6lySc2CI252J3Kj+9Wk6QS7B
	 oVC+7dTL99mi9pmbSTTTP7d3KhXMukhIOnjOhkTi9ALfbjQZvidGcSBhmmQzDi6P9s
	 03eCGIn4WjXNt5t/ERxnKup/KydVZEWAg++N3L7ZBnpvOD6xXEgtGZXNeQ2gVvf0A1
	 m+XGVATsMXi8uEcZA8yJKTrhOWWJUUuDjt6/g4mfsfYnB4yY4uVXjiikg0hzptI1wa
	 dfcF2jndqaC3TqYRmQelr/WV83DPwQlWOTE8FcHKqJjdBCn+VboaWWWLnq3gl/htwh
	 5/l1oTVZxQByQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tobias Deiminger <tobias.deiminger@linutronix.de>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	riku.voipio@iki.fi,
	pavel@kernel.org,
	linux-leds@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] leds: pca9532: Don't stop blinking for non-zero brightness
Date: Mon, 31 Aug 2026 09:23:40 -0400
Message-ID: <20260831133314.4125787-192-sashal@kernel.org>
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

From: Tobias Deiminger <tobias.deiminger@linutronix.de>

[ Upstream commit 0261683a4d31783d680e74b3ae5f22f6a62128cc ]

pca9532 unexpectedly stopped blinking when changing brightness to a
non-zero value. To reproduce:

 echo timer > /sys/class/leds/led-1/trigger   # blinks
 echo 255 > /sys/class/leds/led-1/brightness  # blinking stops, light on
 cat /sys/class/leds/led-1/trigger            # still claims [timer]

According to Documentation/leds/leds-class.rst, only brightness = 0
shall be a stop condition:

> You can change the brightness value of a LED independently of the
> timer trigger. However, if you set the brightness value to LED_OFF it
> will also disable the timer trigger.

Therefore add a guard to continue blinking when brightness != LED_OFF,
similar to how pca955x does it since 575f10dc64a2 ("leds: pca955x: Add
HW blink support").

Signed-off-by: Tobias Deiminger <tobias.deiminger@linutronix.de>
Link: https://patch.msgid.link/20260331202848.658676-1-tobias.deiminger@linutronix.de
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `leds: pca9532: Don't stop blinking for non-
zero brightness`

**Local tree:** `v6.18.44` (`6.18.44`, Makefile `VERSION=6`,
`PATCHLEVEL=18`, `SUBLEVEL=44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[leds: pca9532]` `[fix/guard]` — When brightness is set to
a non-zero value while hardware blinking is active, do not stop
blinking.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Tobias Deiminger `<tobias.deiminger@linutronix.de>`
  (author)
- **Link:** https://patch.msgid.link/20260331202848.658676-1-
  tobias.deiminger@linutronix.de
- **Signed-off-by:** Lee Jones `<lee@kernel.org>` (subsystem maintainer,
  applied)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable@vger.kernel.org`
- Lore thread identifies mainline commit as
  `770edd8e8e5bed961af2ca6ab397052046d1d774` (not present in this
  checkout)

### Step 1.3: Body analysis
**Record:**
- **Bug:** After enabling the `timer` trigger (hardware blink via PWM1),
  writing a non-zero value to `brightness` stops blinking while sysfs
  still reports `[timer]`.
- **Symptom:** LED stays solid on; trigger sysfs entry is inconsistent
  with actual behavior.
- **Reproduction:** Documented sysfs sequence (`timer` trigger → `echo
  255 > brightness` → `cat trigger`).
- **Root cause (author):** `pca9532_set_brightness()` overwrites
  `PCA9532_PWM1` state for any non-zero brightness.
- **Reference:** LED class docs say only `LED_OFF` should stop a timer
  trigger; `pca955x` already guards this way since `575f10dc64a2`.

### Step 1.4: Hidden bug fix?
**Record:** No — this is an explicit functional bug fix, not disguised
cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/leds/leds-pca9532.c` only (+4/-2 lines net)
- **Function:** `pca9532_set_brightness()`
- **Scope:** Single-file, surgical driver fix

### Step 2.2: Code flow change
**Record:**
- **Before:** Any non-zero brightness overwrites `led->state`
  (`PCA9532_ON` or `PCA9532_PWM0`), including when already in
  `PCA9532_PWM1` (HW blink).
- **After:** If `value == LED_OFF` → turn off as before. Else if
  `led->state == PCA9532_PWM1` → return 0 immediately (preserve HW
  blink). Otherwise unchanged logic for `LED_FULL` / PWM dimming.
- **Path affected:** Sysfs `brightness` writes while hardware blinking
  is active.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic / correctness fix (API contract violation)
- **Mechanism:** HW blink sets `led->state = PCA9532_PWM1` in
  `pca9532_update_hw_blink()`. Subsequent `brightness_set_blocking`
  calls clobber that state via `pca9532_setled()`, stopping hardware
  blink while the LED core still believes the timer trigger is active.

### Step 2.4: Fix quality
**Record:**
- Fix is minimal and mirrors the established `pca955x` pattern
  (`test_bit(active_blink)` → early `goto out` for non-zero brightness).
- **Regression risk:** Low. `PCA9532_PWM1` for HW blink is only set via
  `pca9532_update_hw_blink()`, which requires `hw_blink == true`. The
  N2100 beeper path uses PWM1 but does not register a `led_classdev`
  brightness callback, so the guard does not affect beeper input
  handling.
- `LED_OFF` still correctly stops the LED.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `pca9532_set_brightness()` core logic dates to 2008
(`e14fa82439d33c`). The bug was latent until HW blink landed in
`48ca7f302cfcf` (2024-06-17, "leds: pca9532: Use PWM1 for hardware
blinking"), which added `pca9532_update_hw_blink()` setting
`PCA9532_PWM1` without updating `pca9532_set_brightness()`.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag. Logical introducer is
`48ca7f302cfcf`, which is an ancestor of this tree.

### Step 3.3: Related file history
**Record:** Recent `leds-pca9532.c` commits in this tree include HW
blink work (`48ca7f302cfcf`, `f51bc3cedfc45`), default frequency change,
and error-message cleanup (`2aad93b6de0d8`, which carried `Cc: stable`).
This fix is standalone (v2 of a single-patch series).

### Step 3.4: Author context
**Record:** Tobias Deiminger has no other commits in `drivers/leds/` in
this tree. Lee Jones (LED maintainer) applied the patch.

### Step 3.5: Dependencies
**Record:**
- Requires HW blink support (`48ca7f302cfcf`) — **present** in this
  tree.
- References `pca955x` pattern from `575f10dc64a2` — **present** in this
  tree.
- No series dependencies; applies standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **URL:** https://lore.kernel.org/linux-
  leds/20260331202848.658676-1-tobias.deiminger@linutronix.de/
- **Series:** v2 (v1 at https://lore.kernel.org/r/20260321102121.1563365
  -1-tobias.deiminger@linutronix.de); v2 only changes comment style and
  brace placement.
- **Review:** Lee Jones replied "Applied, thanks!" — no NAKs or
  objections found.
- **Stable nomination:** None in thread.

### Step 4.2: Reviewers
**Record:** CC'd: `lee@kernel.org`, `pavel@kernel.org`,
`eajames@linux.ibm.com`, `riku.voipio@iki.fi`, `linux-
leds@vger.kernel.org`. Lee Jones (maintainer) applied.

### Step 4.3: Bug report
**Record:** Author-provided sysfs reproduction in patch and commit
message. No external bugzilla/syzbot report.

### Step 4.4: Related patches
**Record:** Standalone 1/1 patch. Related context: `575f10dc64a2`
(pca955x HW blink guard) and `48ca7f302cfcf` (pca9532 HW blink
introduction).

### Step 4.5: Stable list
**Record:** No stable-list discussion found for this specific fix.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `pca9532_set_brightness()` (modified); context:
`pca9532_update_hw_blink()`, `pca9532_set_blink()`, `pca9532_setled()`.

### Step 5.2: Callers
**Record:** `pca9532_set_brightness` is registered as
`brightness_set_blocking` for `PCA9532_TYPE_LED` devices (probe path
~line 426). Called from LED core via `__led_set_brightness_blocking()`
on sysfs `brightness` writes — userspace-accessible.

### Step 5.3: Callees
**Record:** On guarded path: none (early return). Normal path:
`pca9532_calcpwm()`, `pca9532_setpwm()`, `pca9532_setled()` (I2C
register writes under mutex).

### Step 5.4: Reachability
**Record:**
1. User writes `timer` to `trigger` → `led_blink_set()` →
   `pca9532_set_blink()` → HW blink configures PWM1
2. User writes non-zero `brightness` → `pca9532_set_brightness()` —
   **buggy without fix**
- Reachable from unprivileged userspace (sysfs, subject to permissions).
  Common on embedded status-LED setups.

### Step 5.5: Similar patterns
**Record:** `pca955x_led_set()` in `leds-pca955x.c` lines 316–323
explicitly preserves blinking for non-zero brightness when
`active_blink` is set — same design intent.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current `pca9532_set_brightness()` at lines 185–198
lacks the `PCA9532_PWM1` guard. HW blink support from `48ca7f302cfcf` is
in this tree. Bug introduced ~2024-06 with that commit.

### Step 6.2: Backport complications
**Record:** Expected **clean apply** — the surrounding function matches
the diff context exactly. No conflicting recent changes to this
function.

### Step 6.3: Related fixes already present?
**Record:** **No** — grep finds no "Non-zero brightness shall not stop"
comment or equivalent guard. The fix commit (`770edd8e8e5b`) is not in
this tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/leds/` — **PERIPHERAL** driver (PCA9532 I2C LED
controller). Important for embedded/industrial boards (e.g. historical
Thecus NAS platforms), not core kernel.

### Step 7.2: Subsystem activity
**Record:** LED subsystem actively maintained in 6.18.y; recent stable-
relevant fixes include buffer overread, error-path leaks, and probe-
order fixes.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of `pca9532` with `hw_blink == true` (default for
normal LED configs; disabled only for N2100 beeper variant). Driver-
specific, config/board-specific.

### Step 8.2: Trigger conditions
**Record:** Enable `timer` trigger (HW blink succeeds), then write any
non-zero brightness. **Common** for scripts/users adjusting LED
intensity while blinking. Unprivileged users can trigger via sysfs (with
normal permissions).

### Step 8.3: Failure mode severity
**Record:** Incorrect LED behavior + inconsistent sysfs state (trigger
shows active, hardware not blinking). **Severity: MEDIUM** — no crash,
corruption, or deadlock; real functional regression against documented
LED class behavior.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Restores documented sysfs semantics; fixes regression
  introduced by HW blink backport already in this tree.
- **Risk:** Very low (4-line guard, proven sibling-driver pattern).
- **Ratio:** Favorable — low-risk regression fix for functionality
  already shipped in 6.18.y.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real, reproducible bug with clear sysfs steps
- Regression from `48ca7f302cfcf`, already in this tree
- Violates `Documentation/leds/leds-class.rst` contract
- Tiny, obviously correct fix matching `pca955x`
- Maintainer (Lee Jones) applied without objection
- Clean apply expected

**AGAINST backport:**
- Not a crash, security, corruption, or deadlock issue
- Affects only `pca9532` + HW blink configurations
- No explicit `Cc: stable` or user bug reports beyond author

**Unresolved:** None material to the decision.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic matches pca955x; sysfs
   repro documented; maintainer applied.
2. Fixes a real bug affecting users? **PASS** — sysfs/API behavior bug
   on real hardware.
3. Important issue? **PASS (moderate)** — regression in shipped HW-blink
   feature; inconsistent sysfs state; not crash-level but user-visible
   and documented-API violation.
4. Small and contained? **PASS** — ~4 lines, one function, one file.
5. No new features or APIs? **PASS** — behavior correction only.
6. Can apply to local tree? **PASS** — prerequisite commits present;
   clean apply expected.

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs-only).
Standard driver correctness fix.

### Step 9.4: Problem and decision rationale

This commit fixes a regression introduced when hardware blinking was
added to `pca9532` in this tree (`48ca7f302cfcf`). Without the guard,
any non-zero `brightness` write silently tears down `PCA9532_PWM1`
hardware blink while the LED core still reports the `timer` trigger as
active — breaking the documented rule that non-zero brightness changes
should not disable the timer trigger.

For 6.18.y users who received HW blink support, this completes that
feature correctly. The fix is minimal, follows an in-tree precedent
(`pca955x`), and carries negligible regression risk. While not a crash
fix, it is a clear regression fix for behavior already present in this
stable tree.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit
  message; fetched lore v2 mbox via curl
- **[Phase 2]** Read current `pca9532_set_brightness()` at lines
  179–199; analyzed provided diff
- **[Phase 3]** `git describe HEAD` → v6.18.44; `git blame -L 179,199` →
  core logic from 2008, bug latent until 2024; `git log --oneline -20 --
  drivers/leds/leds-pca9532.c` → `48ca7f302cfcf` present; `git merge-
  base --is-ancestor` → both `48ca7f302cfcf` and `575f10dc64a2` in tree;
  `git show 48ca7f302cfcf` confirmed HW blink addition
- **[Phase 4]** curl lore mbox: v2 patch, Lee Jones "Applied, thanks!",
  commit id `770edd8e8e5b`; `b4 dig -c` failed (commit not in tree); no
  stable-list hits
- **[Phase 5]** Traced `brightness_set_blocking` registration (~line
  426); read `pca955x_led_set()` guard at lines 316–323; read
  `led_blink_setup()` in `led-core.c` (HW blink bypasses SW timer when
  `blink_set` succeeds)
- **[Phase 6]** Confirmed buggy code present (no PCA9532_PWM1 guard);
  grep found no existing fix; `git show 770edd8e8e5b` → bad object (not
  in tree)
- **[Phase 7]** `git log --oneline -20 -- drivers/leds/` for subsystem
  activity
- **[Phase 8]** Read `Documentation/leds/leds-class.rst` lines 23–25;
  confirmed `hw_blink` default true except N2100 beeper (~line 440)
- **[Phase 9]** Synthesized against stable rules for 6.18.44 only

**YES**The background search finished: the fix (`leds: pca9532: Don't
stop blinking for non-zero brightness`) is **not** in this `6.18.44`
tree yet. The buggy code is still there — `pca9532_set_brightness()` can
overwrite `PCA9532_PWM1` when sysfs brightness is set to a non-zero
value while hardware blinking is active.

**Verdict for this tree: YES** — small regression fix for HW blink
support already in 6.18.y; low risk and matches the `pca955x` pattern.

 drivers/leds/leds-pca9532.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
index 0344189bb991c..dae7c67605084 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -182,11 +182,13 @@ static int pca9532_set_brightness(struct led_classdev *led_cdev,
 	int err = 0;
 	struct pca9532_led *led = ldev_to_led(led_cdev);
 
-	if (value == LED_OFF)
+	if (value == LED_OFF) {
 		led->state = PCA9532_OFF;
-	else if (value == LED_FULL)
+	} else if (led->state == PCA9532_PWM1) {
+		return 0; /* Non-zero brightness shall not stop HW blinking */
+	} else if (value == LED_FULL) {
 		led->state = PCA9532_ON;
-	else {
+	} else {
 		led->state = PCA9532_PWM0; /* Thecus: hardcode one pwm */
 		err = pca9532_calcpwm(led->client, PCA9532_PWM_ID_0, 0, value);
 		if (err)
-- 
2.53.0

