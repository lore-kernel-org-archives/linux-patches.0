Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874B55B6793;
	Mon, 19 Oct 2026 14:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418444; cv=none; b=aMylkdaCYpyyUPczdDW88pPlsM7TzKcMhl7lzX+MaJdKgli/0P4Ip0nL2EuCP7Cjrsk3aB5NQQO/Q520TRodKuEfa5z8fe3Ehcj567glT+D1tqa9HpJZW1ZM2lcJxuWPMdZFd06rG+8kDdArQijaGxz+5NsVaVVFHL1Mo6I8g50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418444; c=relaxed/simple;
	bh=kDZcdXAdhCI7mVYRke3rRDlWlNGQWvzvDMs5QSQVMWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WMskcIPp63M8jXc2/xufrs/c5sPvqiFIpFEUGlt8hJDQ5DhjFi6H56ABTkkeQeSN5hOes+VecgMtwzXUIfSRQ34mNQ5aoMuTB8YtcER7pzu3veVIPzn0h/eg9LLY0qYiC+cQdMr/s5CIAwswim9m8eIRCp8lxvMl7j+Q3MfitfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TBqMS+nO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TBqMS+nO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 652A81F000C6;
	Mon, 19 Oct 2026 14:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418441;
	bh=HnH9Q1B70h7WaZqs+atuLrBcDHt4+dPha0IK0njWoO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TBqMS+nO+vDSQDC148tld5QpvzFElW+E9on42cilefWgs+XJO456poMgF+HHnJSY9
	 0+fAv7FEhc4uYWxdI/xi/2IcNhju5gf7bI5A6WIdfPbWJrgWDVn0xSKnWazTSJqTtR
	 7CVYG9/XN34nE2I6uh9Rqx7k7YMi9VnfoT5quTP84zr4dQyn2eteVMYcw8ir2YTjLf
	 URqCCGxX/VU/a92H+Tmwxo3zXomZRwMXrgAJyZN9G34QIu2RDRIqi5MxubuW/0sfuq
	 kSTV6Uqns0HtwlyDxy7gU7Zhl/L+MX2xHyTiXVv+fOHjIKN2GpjqimoVrZqerZJ1rt
	 lJGj6rOtUZxdg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] regulator: rt6245: Restore state on enable failure
Date: Mon, 19 Oct 2026 09:49:02 -0400
Message-ID: <20261019135441.1420968-251-sashal@kernel.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit e95a0a309ca02bf26dc937cdeb3fe2a235c65f63 ]

Currently, if regcache_sync() fails after the enable GPIO has been
asserted, the driver returns with enable_gpio still set high and
regcache_cache_only() left disabled. This leaves the device state
inconsistent with the disabled state, where the enable GPIO is low and
cache_only is enabled.
On failure, restore the original state by setting cache_only back to
true and driving the enable GPIO low before returning the error.

Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260729100018.66577-1-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Local tree is **6.1.188** (`pending-6.1`). The buggy `rt6245_enable()`
error path is present and matches the patch pre-image; this is a small,
self-contained rollback of GPIO and regcache state after
`regcache_sync()` fails.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[regulator / rt6245] [Restore] restore GPIO + regcache state
when enable fails after `regcache_sync()`**

Subsystem prefix `regulator: rt6245:`. Verb “Restore” is rollback
language: incomplete error recovery, not a feature.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- `Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>` (author)
- `Link:
  https://patch.msgid.link/20260729100018.66577-1-phucduc.bui@gmail.com`
- `Signed-off-by: Mark Brown <broonie@kernel.org>` (regulator
  maintainer)
- No `Fixes:`, no `Cc: stable`, no `Reported-by`, no `Tested-by`, no
  `Reviewed-by`, no syzbot
- Absence of `Fixes:` / `Cc: stable` is expected for this review and is
  not a negative signal

Mainline SHA (from git.kernel.org, not used as a “already selected”
signal): `e95a0a309ca02bf26dc937cdeb3fe2a235c65f63`

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** After asserting `enable_gpio` and turning cache-only off,
  `regcache_sync()` can fail. The function then returns without undoing
  those two steps.
- **Symptom:** Software reports enable failed (`enable_state` stays
  false) while the chip enable pin stays high and
  `regcache_cache_only()` stays disabled. That does not match the
  disabled state (GPIO low, cache-only on).
- **Root cause:** Missing rollback on the `regcache_sync()` error path.
- **Version info:** None in the message. Introduced with the driver
  itself (2021).
- No stack trace, no reproducer, no user report.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: This is an explicit error-path fix, not a disguised cleanup. It
restores hardware and cache mode so they match “disabled” before
returning the error.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `drivers/regulator/rt6245-regulator.c` (+4 / −1)
- Function: `rt6245_enable()`
- Scope: single-file surgical error-path fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Before (this tree, lines 47–56):

```47:56:drivers/regulator/rt6245-regulator.c
        gpiod_direction_output(priv->enable_gpio, 1);
        usleep_range(RT6245_ENTIME_IN_US, RT6245_ENTIME_IN_US + 1000);

        regcache_cache_only(regmap, false);
        ret = regcache_sync(regmap);
        if (ret)
                return ret;

        priv->enable_state = true;
        return 0;
```

After: on `regcache_sync()` failure, set `regcache_cache_only(regmap,
true)`, drive GPIO low, then return `ret`. `priv->enable_state` is still
not set (already false on this path).

Affected path: enable error path only, and only when `enable_gpio` is
present (early `return 0` if it is NULL).

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **Error-path / incomplete rollback**, not UAF/race/leak.

Mechanism:
1. GPIO is driven high (chip powered).
2. Cache-only is disabled so I2C writes go to hardware.
3. `regcache_sync()` fails (I2C/NAK/timeout).
4. Function returns. Regulator core does **not** call `disable()` on
   enable failure (see Phase 5).
5. Chip stays powered; cache-only stays off; `is_enabled()` still
   reports off.

Disable already does the matching pair (`cache_only true` + GPIO low).
The patch copies that rollback onto the failed-enable path.

Note: `rt6245_disable()` also calls `regcache_mark_dirty()`. This patch
does not. For this driver that is still correct: it uses
`REGCACHE_FLAT`, and `regcache_sync()` only clears `map->cache_dirty` on
success (`drivers/base/regmap/regcache.c`). A failed sync leaves the
cache dirty, so the next enable still resyncs. `mark_dirty()` is needed
on disable because a *successful* enable had already cleared that flag.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- Obviously correct: undoes exactly the two side effects performed
  before the failing call, in reverse order (cache-only first, then
  GPIO, matching disable).
- Minimal: four lines, no unrelated churn.
- Regression risk: very low. GPIO is already known non-NULL on this
  path. No locking change. No API change.
- `gpiod_direction_output(..., 0)` matches the style already used in
  this file’s enable/disable (this tree does not use `gpiod_set_value()`
  here).

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record: Buggy sequence was introduced in
`a747070e9b629eeb70118651dfbd500bf8bb5ebe` (“regulator: rt6245: Add
support for Richtek RT6245”, 2021-06-03, ChiYuan Huang). `git merge-base
--is-ancestor a747070e9b629 HEAD` succeeds. `git merge-base --is-
ancestor a747070e9b629 v6.1` succeeds. Present since the driver landed,
well before 6.1.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. The introducing commit is the driver add
itself, and it is in this tree.

**Step 3.3: CHECK FILE HISTORY**

Record: Only two commits on this file in this tree:
- `a747070e9b629` — add driver
- `508f8ccd993d1` — make `func_base` static (unrelated size tweak)

No later refactor, no series glue, no conflicting change. Standalone.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Author is not the subsystem maintainer (that is Mark Brown;
driver author is ChiYuan Huang). Same author has similar “restore cache-
only on sync failure” work already in this tree, e.g.:
- `3de4b44d5887d` ASoC rockchip spdif: restore cache-only on sync
  failure
- `0614f2fa0998f` gpio pca953x: restore cache_only/IRQ on
  restore_context failure

Those are the same class of error-path rollback. This rt6245 change is
not in HEAD (`git merge-base --is-ancestor e95a0a309ca0 HEAD` fails).

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: None. Uses only `regcache_cache_only()`, `regcache_sync()`,
`gpiod_direction_output()`, all present. Pre-image of the hunk matches
this tree exactly. Can apply standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- msgid `20260729100018.66577-1-phucduc.bui@gmail.com`
- `b4 dig` / `b4 mbox`: no match / lore 404
- lore.kernel.org fetch: HTTP 403
- Patchew fetch: timeout
- LKML archive:
  https://lkml.iu.edu/hypermail/linux/kernel/2607.3/10141.html — v1
  patch text matches the committed diff; no review replies on that page
- Patchew summary (search): Mark Brown applied it to `for-7.3` the next
  day
- git.kernel.org: committed 2026-07-30 by Mark Brown; tags are only
  author SOB + Link + maintainer SOB
- Included in “regulator updates for v7.3” pull (Mark Brown, 2026-08-17)

No NAK found. No later v2/v3 of this specific patch found. Applied as
submitted.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (from Patchew mbox snippet): To Liam Girdwood and Mark Brown; Cc
linux-kernel. Mark Brown applied it. No extra Reviewed-by.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No bugzilla, no syzbot, no user report. Analysis-driven error-
path fix.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Single `[PATCH]`, not `N/M`. Sibling Richtek drivers in this
tree (`rt6160`, `rtq6752`) have similar enable+sync patterns; this
commit does not depend on changing them.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: Search of lore.kernel.org/stable for this subject did not find a
prior stable request or rejection. UNVERIFIED beyond search snippets
(lore 403).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**

Record: `rt6245_enable()` only. Wired as `.enable` in
`rt6245_regulator_ops`.

**Step 5.2: TRACE CALLERS**

Record: Not called by name elsewhere. Invoked through regulator core
`_regulator_do_enable()`:

```2814:2817:drivers/regulator/core.c
        } else if (rdev->desc->ops->enable) {
                ret = rdev->desc->ops->enable(rdev);
                if (ret < 0)
                        return ret;
```

On failure the core returns immediately. It does not call
`ops->disable`. The leftover GPIO-high / cache-only-off state persists
until a later disable (which the core will not issue, because it never
counted the regulator as enabled).

**Step 5.3: TRACE CALLEES**

Record: `gpiod_direction_output`, `usleep_range`, `regcache_cache_only`,
`regcache_sync`. I2C writes happen inside `rt6245_reg_write()` during
sync.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Reachable from `regulator_enable()` consumers and from sysfs
enable of this regulator. Trigger: board has `enable-gpios`, someone
enables the regulator, I2C `regcache_sync()` fails. Not every boot; it
is an I2C error path. Unprivileged trigger depends on whether that
regulator sysfs is exposed; kernel consumers can hit it during
probe/resume.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Same class in this tree: `rt6160_enable()` also does GPIO +
`regcache_sync()` with no rollback
(`drivers/regulator/rt6160-regulator.c`). `rtq6752_set_vdd_enable()`
likewise returns on sync failure after GPIO high. Those are separate
bugs, not prerequisites.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: Yes. `drivers/regulator/rt6245-regulator.c` `rt6245_enable()`
lines 50–53. Introduced 2021-06-03, in v6.1. Fix is not an ancestor of
HEAD.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply.** Hunk context is identical. No refactor of this
function after the driver was added. (`probe_new` vs later `probe` is
unrelated.)

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No other rt6245 enable-failure rollback. File history is only
the two commits above.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**

Record: **regulator / Richtek RT6245 I2C buck**. Criticality:
**PERIPHERAL** (specific PMIC/regulator, `CONFIG_REGULATOR_RT6245`). It
is a 14A, 0.4375–1.3875 V converter, typically a CPU/core or similar
rail on boards that use it.

**Step 7.2: SUBSYSTEM ACTIVITY**

Record: Regulator core in this tree is actively backported. This file
itself is mature and almost untouched since 2021.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**

Record: Driver-specific / config-specific: `CONFIG_REGULATOR_RT6245`
plus DT `enable-gpios`. No in-tree `.dts`/`.dtsi` uses `richtek,rt6245`
(only the binding example). Real users are out-of-tree / vendor DTs.
Still a shipped mainline driver.

**Step 8.2: TRIGGER CONDITIONS**

Record: Enable with GPIO, then I2C `regcache_sync()` fails. Uncommon
compared with the happy path, but a lasting state once it happens (core
will not disable). Not a race.

**Step 8.3: FAILURE MODE SEVERITY**

Record:
- Hardware enable pin left asserted on a 14 A regulator while the
  framework thinks it is off.
- Cache-only left disabled, so later cache/I2C behavior does not match
  “disabled”.
- Not a panic, UAF, or filesystem corruption.

Severity: **MEDIUM–HIGH** for this hardware (wrong power state /
unexpected rail power), **LOW** for the rest of the kernel.

**Step 8.4: RISK-BENEFIT RATIO**

Record:
- **Benefit:** Stops a failed enable from leaving a high-current rail
  powered and the regmap in the wrong mode. Matches disable semantics.
- **Risk:** Four lines on an error path, same operations disable already
  uses. Very low.
- **Ratio:** Favorable. Cheap, contained, real rollback.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real incomplete error recovery; hardware and cache mode left
  inconsistent with “disabled”.
- Regulator core does not call disable on enable failure, so the leak is
  permanent until some other disable.
- Buggy code has been in this 6.1 tree since the driver was added
  (2021).
- Four-line, obviously correct, applies cleanly, no new API, no
  dependencies.
- Maintainer (Mark Brown) applied it; same author pattern already
  accepted in this tree for other cache-only rollbacks.

**AGAINST:**
- Peripheral driver; no in-tree board DT.
- I2C error path; no user/syzbot report.
- Not a crash/security/deadlock/corruption bug.

**UNRESOLVED:**
- Full lore thread unreable (403/404); no extra reviewer comments
  retrieved.
- No stable-list discussion found.

**Step 9.2: STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — rollback is local and
   matches disable; applied by maintainer. No extra Tested-by.
2. Fixes a real bug that affects users? **PASS** — failed enable leaves
   the rail on and cache-only off.
3. Important issue? **PASS** (medium) — wrong power state on a high-
   current regulator, not a kernel oops. Within the “etc.” of hardware
   left in a bad state.
4. Small and contained? **PASS** — 4 insertions / 1 deletion, one
   function.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — pre-image matches; driver
   present.

**Step 9.3: EXCEPTION CATEGORIES**

Record: Not a device ID / quirk / DT / build / docs exception. Ordinary
driver bugfix.

**Step 9.4: DECISION**

This belongs on 6.1. The bug exists here, the fix is surgical, and
leaving a 14 A enable pin high after a failed enable is a real hardware-
state bug, not style cleanup. Risk of regression is negligible.

---

## What the commit solves for this tree

On `CONFIG_REGULATOR_RT6245` boards that use `enable-gpios`, a failed
`regcache_sync()` during enable currently returns an error while the
chip stays powered and the regmap is no longer cache-only. The regulator
core will not run disable for that failed enable, so the rail stays on.
The patch restores cache-only and deasserts the GPIO, which is the
disabled state this driver already uses.

It meets the stable rules: obviously correct, real bug, small, no new
API, clean apply on 6.1.188. Benefit is restoring consistent power/cache
state; risk is a four-line error path.

---

## Verification

- **[Phase 1]** Parsed subject/tags/body from the candidate message and
  from git.kernel.org commit `e95a0a309ca0` (author SOB, Link, Mark
  Brown SOB; no Fixes/stable/Reported-by).
- **[Phase 2]** Diff is +4/−1 in `rt6245_enable()`; local file matches
  the pre-image (`if (ret) return ret;` after `regcache_sync`).
- **[Phase 2]** Compared with `rt6245_disable()`: disable already does
  cache-only + GPIO low; enable failure did not.
- **[Phase 2]** `regcache_sync()` only clears `cache_dirty` on success —
  missing `mark_dirty` is not required on this failure path for
  `REGCACHE_FLAT`.
- **[Phase 3]** `git blame`: lines from `a747070e9b629` (2021-06-03).
  Ancestor of HEAD and of `v6.1`.
- **[Phase 3]** `git log --oneline --
  drivers/regulator/rt6245-regulator.c`: only add-driver + static-array
  commit.
- **[Phase 3]** `git merge-base --is-ancestor e95a0a309ca0 HEAD` → not
  in this tree.
- **[Phase 4]** `b4 dig`/`b4 mbox`: no lore thread; lore HTTP 403;
  Patchew timeout.
- **[Phase 4]** LKML archive shows v1 matching the committed diff; v7.3
  regulator pull lists this commit.
- **[Phase 4]** Recipients: Liam Girdwood, Mark Brown (Patchew mbox
  snippet).
- **[Phase 5]** `rt6245_enable` is only `.enable` in ops;
  `_regulator_do_enable()` returns on `ops->enable` failure without
  disable.
- **[Phase 5]** `git grep richtek,rt6245` in dts/dtsi: no in-tree users;
  binding YAML only.
- **[Phase 6]** `git describe HEAD` → `p-6.1-9-g27ef8181b8a64`;
  `Makefile` 6.1.188; `make kernelversion` 6.1.188.
- **[Phase 6]** Python pre-image check: enable() does not yet restore
  cache-only/GPIO on sync failure.
- **[Phase 7]** Kconfig `REGULATOR_RT6245` present; Makefile builds
  `rt6245-regulator.o`.
- **[Phase 8]** Failure mode verified from code: GPIO left high + cache-
  only left false + `enable_state` still false.
- **UNVERIFIED:** Full lore review comments (fetch blocked); whether any
  out-of-tree board actually hits the I2C-fail path in production.

The patch is small, applies cleanly to this 6.1 tree, and fixes a real
enable-failure rollback for hardware that this tree already ships.

**YES**

 drivers/regulator/rt6245-regulator.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/rt6245-regulator.c b/drivers/regulator/rt6245-regulator.c
index 1843ecec19229..5c0ee04e97ac7 100644
--- a/drivers/regulator/rt6245-regulator.c
+++ b/drivers/regulator/rt6245-regulator.c
@@ -49,8 +49,11 @@ static int rt6245_enable(struct regulator_dev *rdev)
 
 	regcache_cache_only(regmap, false);
 	ret = regcache_sync(regmap);
-	if (ret)
+	if (ret) {
+		regcache_cache_only(regmap, true);
+		gpiod_direction_output(priv->enable_gpio, 0);
 		return ret;
+	}
 
 	priv->enable_state = true;
 	return 0;
-- 
2.53.0

