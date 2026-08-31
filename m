Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666E457096E;
	Mon, 31 Aug 2026 13:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184128; cv=none; b=mZuKK+Gh9PtsFcaqSMMMuNIkTW/udRuyxTHabPlYxQt9viwttaUynoKEonR2sGH9waLA2IDB3vF3F2Y/BV8FE+fs8CGM0fuQBVcSRqLQxQCSmYZUZPVzUnQ9TS2SLMDbLd8F8+fXw0x17Rtd8DWmecniex7tKpyGZmSctfOHLm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184128; c=relaxed/simple;
	bh=TzKFdgxgSGat+xULECVcqIi3vrxUzKURchqHCmyH3b8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KiA/p/Kn4CBhKpF0pUuQM6w6WB6aUHLSKcrNjD5ZqwJqjcQjs7/aQGoorQHQzR+KD3+RqqL/c79t/ICqpWJZXbxxGLwNCBnkDTJILJNGY9Z4ftkKPULXqVAMaxYOVNta7tImmydF6/S2rKhg+EHsxjMipEyoLHLmeXKSCG45QOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Budn8tOH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Budn8tOH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B84B1F00A3D;
	Mon, 31 Aug 2026 13:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184125;
	bh=yQi3y6sYGLHYeF5P9eo2t/apthYtXBwbFUwYVpa1SKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Budn8tOH+qiZqgeQF0aLnnAjXs5jXdvnXyZssaa/uKHSad13wVDN24hxpQ/JS81eA
	 p4JR2WX2DM8xL+8M13LRvjAWw60GX6U6LEuNXiQS2qH/gIVYm9XNJOGBVZk1qkD37C
	 MFlqxK/DOIGzG0J9XnzZ+0DPR3UKxEQ9eF90xi/DSBHJ7EdI4M8b+5SnKf+iKb5PJv
	 QNN4lfY1bwyeNRZmviWTpyZieRs6zvMbCMJmwxU/vhzoSsZIzOkz1xslrOvb1ehj1F
	 z5fsZIQYd9MSzw4YNanyPrTJf1gKn5c3AGcYIv7nbimu1mwEkmQNwCNZ6ONhPAmMhL
	 NAYvwm+AaKJlw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kamal Wadhwa <kamal.wadhwa@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] regulator: core: clamp voltage constraints before applying apply_uV
Date: Mon, 31 Aug 2026 09:28:55 -0400
Message-ID: <20260831133314.4125787-507-sashal@kernel.org>
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

From: Kamal Wadhwa <kamal.wadhwa@oss.qualcomm.com>

[ Upstream commit a45cc646a3aa83eb4ab4c7ed2685785ea51dc5e6 ]

machine_constraints_voltage() currently applies apply_uV against the
machine-supplied [min_uV, max_uV] range, and only afterwards clamps
that range down to what the regulator can actually supply (via
ops->list_voltage()).

If the machine-supplied range is wider than the regulator's actual
range, apply_uV's rounding can pick a selector outside the (correct)
clamped range, so the regulator ends up programmed outside its clamped
min/max. At bring-up this shows up as a voltage read-back outside the
clamped range.

Fix this by moving the clamping block ahead of the apply_uV block, so
apply_uV always targets an already-clamped range. Whether apply_uV
should run is decided from the unclamped constraints beforehand and
stored in a local bool, since clamping must not itself change whether
apply_uV fires.

No functional change to the clamping logic itself, only its position
relative to apply_uV. Its early return 0 exits become fallthroughs
since the apply_uV logic now follows it.

Assisted-by: Claude:claude-sonnet-5
Signed-off-by: Kamal Wadhwa <kamal.wadhwa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260720-b4-regulator-core-clamp-voltage-v1-1-8e5eec076a8e@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `regulator: core: clamp voltage constraints
before applying apply_uV`

**Local tree:** `linux-6.18.y` at **6.18.44** (`git describe HEAD` →
`v6.18.44-2-g1b9e1abadee04`; `Makefile` → VERSION 6, PATCHLEVEL 18,
SUBLEVEL 44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: `[regulator: core]` `[clamp]` — Reorder voltage constraint
clamping to run before `apply_uV` processing in
`machine_constraints_voltage()`.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Assisted-by:** Claude:claude-sonnet-5
- **Signed-off-by:** Kamal Wadhwa \<kamal.wadhwa@oss.qualcomm.com\>
- **Link:** https://patch.msgid.link/20260720-b4-regulator-core-clamp-
  voltage-v1-1-8e5eec076a8e@oss.qualcomm.com
- **Signed-off-by:** Mark Brown \<broonie@kernel.org\> (regulator
  subsystem maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable tags
- Notable: Maintainer sign-off; no fuzzer or user bug reports cited

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `machine_constraints_voltage()` runs `apply_uV` against
  unclamped `[min_uV, max_uV]`, then clamps to hardware-supported
  discrete voltages via `ops->list_voltage()`.
- **Symptom:** When machine constraints are wider than the regulator's
  real range, `apply_uV` rounding can select a voltage outside the
  clamped range — seen at bring-up as voltage read-back outside expected
  bounds; can also fail regulator registration.
- **Root cause:** Ordering bug — clamping must precede `apply_uV`.
- **Fix approach:** Move clamping before `apply_uV`; capture whether
  `apply_uV` should run in a `bool` before clamping mutates constraints
  (important for fixed-voltage autoconfigure).
- No explicit kernel version range in the message.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Not hidden** — this is an explicit correctness/ordering bug
fix, though described as "no functional change to the clamping logic
itself, only its position."

---

## PHASE 2: DIFF ANALYSIS — LINE BY LINE

**Step 2.1: INVENTORY THE CHANGES**

Record:
- **Files:** `drivers/regulator/core.c` only
- **Scope:** ~88 lines moved, ~8 lines added (`bool apply_uV` +
  comments); clamping block moved from after `apply_uV` to before it
- **Function modified:** `machine_constraints_voltage()`
- **Classification:** Single-file surgical reorder within one function

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Hunk 1 (before → after):** `apply_uV` block ran first on raw machine
  constraints → clamping ran second. **After:** `apply_uV` decision
  captured upfront → clamping runs → `apply_uV` runs on already-clamped
  range.
- **Hunk 2:** Early `return 0` in clamping for optional constraints /
  continuous range → empty fallthrough blocks so `apply_uV` can still
  run when appropriate.
- **Execution path:** Regulator registration / probe
  (`set_machine_constraints()` → `machine_constraints_voltage()`), boot-
  time initialization.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** Logic / correctness fix (ordering)
- **Mechanism:** `_regulator_do_set_voltage()` uses
  `regulator_map_voltage()` which maps `[min_uV, max_uV]` to a hardware
  selector. When `apply_uV` uses an overly-wide machine range on a
  discrete (`list_voltage` + `n_voltages`,
  non-`continuous_voltage_range`) regulator, the mapped selector/voltage
  may lie outside the subset the clamping pass would later compute.
  Result: wrong voltage programmed or `-EINVAL` on registration.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- **Quality:** Obviously correct — same clamping logic, correct order;
  `apply_uV` bool preserves pre-clamp decision semantics (explicitly
  handles fixed-voltage autoconfigure where clamping rewrites
  `min_uV`/`max_uV`).
- **Regression risk:** Low. Clamping validation errors (`-EINVAL`) now
  occur before hardware programming — strictly safer than before.
- **No API changes, no new sysfs/module parameters.**

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record: `git blame` shows `machine_constraints_voltage()` body
attributed to `5d324e5159d9e` (Nov 2025 merge importing
`drivers/regulator/core.c`). Both `apply_uV` block (line 1209) and
clamping block (line 1265) are present in current tree with buggy
ordering. **Exact commit that introduced the ordering bug:** not
determinable — tree history is shallow (file appears as wholesale
import). Bug is present in 6.18.44.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag present. N/A.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record: Recent `drivers/regulator/core.c` commits on this tree include
locking fixes and supply-check reordering (`bde74af8d4466`,
`b6a83ad13d253`, etc.). No commit reordering clamp vs. `apply_uV`.
**Standalone fix, not part of a series** (subject has no "patch X/Y").

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: No other commits from Kamal Wadhwa in `drivers/regulator/` in
this tree. Mark Brown is the subsystem maintainer (signed off).

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: **No dependencies.** Fix only reorders existing code within
`machine_constraints_voltage()`. All structures (`apply_uV`,
`list_voltage`, `continuous_voltage_range`) exist in this tree. **Can
apply standalone.**

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record: `b4 dig -c HEAD` failed (commit not in tree). `b4 dig` with
message-ID argument not supported by this b4 version. WebFetch and curl
to lore.kernel.org blocked by Anubis bot protection. **Could not
retrieve mailing list thread.** Link tag points to v1 submission
(2026-07-20).

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: **UNVERIFIED** — `b4 dig -w` could not be run without commit in
tree; lore inaccessible. Mark Brown (maintainer) Signed-off-by confirms
maintainer acceptance.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No Reported-by: or syzbot Link: tags. Bug described as bring-up
observation (voltage read-back outside clamped range). **No external bug
report verified.**

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: v1 in message-ID; no evidence of multi-patch series. Standalone.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: **UNVERIFIED** — lore.kernel.org inaccessible.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: `machine_constraints_voltage()` (modified). Supporting context:
`_regulator_do_set_voltage()`, `regulator_map_voltage()`,
`set_machine_constraints()`, `regulator_register()` path.

**Step 5.2: TRACE CALLERS**

Record:
- `set_machine_constraints()` → `machine_constraints_voltage()` (line
  1461)
- `set_machine_constraints()` called from regulator registration at
  lines 5954 and 5967 (`__regulator_register()` path)
- **Context:** Every regulator probe/registration with machine
  constraints; common on ARM/embedded with device tree.

**Step 5.3: TRACE CALLEES**

Record: Clamping calls `ops->list_voltage()` per selector. `apply_uV`
calls `regulator_get_voltage_rdev()` and `_regulator_do_set_voltage()` →
`regulator_map_voltage()` → driver `set_voltage_sel`/`set_voltage`.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Device probe → `regulator_register()` / devm variant →
`set_machine_constraints()` → `machine_constraints_voltage()`. Triggered
at boot for every constrained regulator. **Not directly userspace-
triggerable**, but affects all platforms using DT `regulator-min-
microvolt` / `regulator-max-microvolt` (which auto-set `apply_uV = true`
in `of_regulator.c` lines 109–111).

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: No similar ordering bug found elsewhere in
`drivers/regulator/core.c`. Current and suspend voltage paths use
already-clamped ranges.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **YES.** Current `drivers/regulator/core.c` lines 1208–1263 run
`apply_uV` before clamping (lines 1265–1334). The candidate fix is
**not** present (`git log --grep='clamp voltage'` returns nothing).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply expected.** Function structure in 6.18.44 matches
the patch context exactly. No conflicting changes to this function in
recent stable commits. Minor reorder only.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: **No.** No alternative fix for this ordering issue in the tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **Subsystem:** `drivers/regulator/core.c` — regulator framework
core. **Criticality: CORE/IMPORTANT** — affects power management for all
constrained regulators platform-wide.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Active — multiple regulator core fixes in 6.18.y (locking,
supply resolution, refcount leaks in individual drivers).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Platform-specific but common** — boards using device tree
regulators with `regulator-min-microvolt` + `regulator-max-microvolt`
(auto-enables `apply_uV`) on discrete-voltage PMIC/LDO drivers
(`list_voltage` + `n_voltages`, not `continuous_voltage_range`).
Embedded, mobile, ARM SoCs.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record:
- `apply_uV` true (automatic from DT when min and max microvolt set)
- Discrete voltage table (`ops->list_voltage` && `n_voltages` &&
  !`continuous_voltage_range`)
- Machine `[min_uV, max_uV]` wider than regulator's actual supported
  discrete range
- **Likelihood:** Moderate on embedded bring-up; DT authors often
  specify wide permissible ranges
- **Userspace:** Not directly triggerable; boot/probe path only

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record:
- **Probe failure:** `machine_constraints_voltage()` returns error →
  regulator registration fails → dependent devices fail probe → **boot
  failure** on affected boards. **Severity: HIGH/CRITICAL**
- **Wrong voltage programmed:** Hardware outside intended clamped range
  → instability or hardware damage risk. **Severity: HIGH**
- Not a crash/oops in the classical sense, but can prevent boot or
  misconfigure power rails.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** HIGH for affected embedded platforms — prevents boot
  failures and incorrect voltage programming during regulator init
- **Risk:** LOW — reorder of existing logic, maintainer-reviewed, no new
  APIs
- **Ratio:** Strong benefit, minimal risk

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR backporting:**
- Real ordering bug verified in 6.18.44 source code
- Can cause regulator registration failure (boot broken) or wrong
  voltage at bring-up
- Core regulator framework — broad impact surface for affected configs
- Small, surgical, maintainer-signed fix
- No prerequisites; applies cleanly to this tree
- Fix makes error paths safer (validation before hardware programming)

**AGAINST backporting:**
- Trigger requires specific config combination (apply_uV + discrete
  voltages + wide machine range)
- No syzbot report or multiple user reports in commit message
- Bring-up issue primarily (though affects production DT configs)
- Mailing list review details unverified

**UNRESOLVED:**
- Full lore review thread inaccessible
- Exact age of the ordering bug (shallow git history)

**Step 9.2: STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — logic reorder is clear;
   maintainer SOB; no Tested-by but mechanism is verifiable
2. Fixes a real bug affecting users? **PASS** — probe failure / wrong
   voltage on affected boards
3. Important issue? **PASS** — boot failure and incorrect power-rail
   programming (HIGH severity)
4. Small and contained? **PASS** — single function in one file, no logic
   rewrite
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — buggy code present, fix not
   applied, clean apply expected

**Step 9.3: EXCEPTION CATEGORIES**

Record: None (not device ID, quirk, DT, build, or docs). Standard bug
fix.

**Step 9.4: DECISION RATIONALE**

For **linux-6.18.y (6.18.44)**, the buggy ordering is present in
`machine_constraints_voltage()`. The fix reorders existing clamping
logic ahead of `apply_uV` so voltage selection always targets hardware-
valid ranges — preventing registration failures and incorrect voltage
programming on discrete regulators with wide DT constraints. This is a
real, important correctness bug in the regulator core, with a low-risk
surgical fix and maintainer approval. The lack of syzbot reports does
not diminish the verified code-level bug.

---

## Verification

- [Phase 1] Parsed subject, tags, body; identified explicit ordering bug
  fix; Mark Brown SOB confirmed
- [Phase 2] Read full `machine_constraints_voltage()` (lines 1202–1337);
  confirmed apply_uV-before-clamp ordering; analyzed
  `_regulator_do_set_voltage()` / `regulator_map_voltage()` (lines
  3685–3744)
- [Phase 3] `git describe HEAD` → v6.18.44; `git blame` on changed
  region; shallow history noted; no Fixes: tag; no duplicate fix in tree
- [Phase 4] `b4 dig -c HEAD` → wrong match (commit not in tree); lore
  WebFetch/curl blocked by Anubis — **UNVERIFIED** for list discussion
  and stable nominations
- [Phase 5] Traced callers: `set_machine_constraints()` (1461) ←
  registration (5954, 5967); `of_regulator.c` lines 109–111 auto-set
  `apply_uV`
- [Phase 6] Confirmed buggy code at lines 1208–1334; fix absent (`git
  log --grep='clamp voltage'` empty); HEAD on `stable/linux-6.18.y`
  branch family
- [Phase 7] Regulator core subsystem; active maintenance in 6.18.y
- [Phase 8] Failure modes: probe failure + wrong voltage; trigger:
  apply_uV + discrete list_voltage + wide machine range
- [Phase 9] All stable criteria PASS for this tree

**YES**

 drivers/regulator/core.c | 163 +++++++++++++++++++++------------------
 1 file changed, 90 insertions(+), 73 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 019606bc36b9c..3439488d0bc74 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1204,10 +1204,98 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 {
 	const struct regulator_ops *ops = rdev->desc->ops;
 	int ret;
+	bool apply_uV;
+
+	/*
+	 * Decide up front, from the constraints as handed to us, whether
+	 * apply_uV needs to run below. The clamping pass right after this
+	 * may rewrite constraints->min_uV/max_uV (e.g. the fixed-voltage
+	 * autoconfigure case), and we don't want that to change whether
+	 * apply_uV fires.
+	 */
+	apply_uV = rdev->constraints->apply_uV &&
+		   rdev->constraints->min_uV && rdev->constraints->max_uV;
+
+	/*
+	 * Constrain machine-level voltage specs to fit the actual range
+	 * supported by this regulator before apply_uV (below) tries to
+	 * force hardware to a value from that range: otherwise apply_uV
+	 * can target a constraint value that doesn't correspond to any
+	 * real voltage selector and fail registration outright, even
+	 * though the clamping pass would have narrowed it to a value
+	 * the regulator can actually hit.
+	 */
+	if (ops->list_voltage && rdev->desc->n_voltages) {
+		int	count = rdev->desc->n_voltages;
+		int	i;
+		int	min_uV = INT_MAX;
+		int	max_uV = INT_MIN;
+		int	cmin = constraints->min_uV;
+		int	cmax = constraints->max_uV;
+
+		/* it's safe to autoconfigure fixed-voltage supplies
+		 * and the constraints are used by list_voltage.
+		 */
+		if (count == 1 && !cmin) {
+			cmin = 1;
+			cmax = INT_MAX;
+			constraints->min_uV = cmin;
+			constraints->max_uV = cmax;
+		}
+
+		/* voltage constraints are optional */
+		if ((cmin == 0) && (cmax == 0)) {
+			/* nothing more to do */
+
+		/* else require explicit machine-level constraints */
+		} else if (cmin <= 0 || cmax <= 0 || cmax < cmin) {
+			rdev_err(rdev, "invalid voltage constraints\n");
+			return -EINVAL;
+
+		/* no need to loop voltages if range is continuous */
+		} else if (rdev->desc->continuous_voltage_range) {
+			/* nothing more to do */
+
+		} else {
+			/* initial: [cmin..cmax] valid, [min_uV..max_uV] not */
+			for (i = 0; i < count; i++) {
+				int	value;
+
+				value = ops->list_voltage(rdev, i);
+				if (value <= 0)
+					continue;
+
+				/* maybe adjust [min_uV..max_uV] */
+				if (value >= cmin && value < min_uV)
+					min_uV = value;
+				if (value <= cmax && value > max_uV)
+					max_uV = value;
+			}
+
+			/* final: [min_uV..max_uV] valid iff constraints valid */
+			if (max_uV < min_uV) {
+				rdev_err(rdev,
+					 "unsupportable voltage constraints %u-%uuV\n",
+					 min_uV, max_uV);
+				return -EINVAL;
+			}
+
+			/* use regulator's subset of machine constraints */
+			if (constraints->min_uV < min_uV) {
+				rdev_dbg(rdev, "override min_uV, %d -> %d\n",
+					 constraints->min_uV, min_uV);
+				constraints->min_uV = min_uV;
+			}
+			if (constraints->max_uV > max_uV) {
+				rdev_dbg(rdev, "override max_uV, %d -> %d\n",
+					 constraints->max_uV, max_uV);
+				constraints->max_uV = max_uV;
+			}
+		}
+	}
 
 	/* do we need to apply the constraint voltage */
-	if (rdev->constraints->apply_uV &&
-	    rdev->constraints->min_uV && rdev->constraints->max_uV) {
+	if (apply_uV) {
 		int target_min, target_max;
 		int current_uV = regulator_get_voltage_rdev(rdev);
 
@@ -1262,77 +1350,6 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 		}
 	}
 
-	/* constrain machine-level voltage specs to fit
-	 * the actual range supported by this regulator.
-	 */
-	if (ops->list_voltage && rdev->desc->n_voltages) {
-		int	count = rdev->desc->n_voltages;
-		int	i;
-		int	min_uV = INT_MAX;
-		int	max_uV = INT_MIN;
-		int	cmin = constraints->min_uV;
-		int	cmax = constraints->max_uV;
-
-		/* it's safe to autoconfigure fixed-voltage supplies
-		 * and the constraints are used by list_voltage.
-		 */
-		if (count == 1 && !cmin) {
-			cmin = 1;
-			cmax = INT_MAX;
-			constraints->min_uV = cmin;
-			constraints->max_uV = cmax;
-		}
-
-		/* voltage constraints are optional */
-		if ((cmin == 0) && (cmax == 0))
-			return 0;
-
-		/* else require explicit machine-level constraints */
-		if (cmin <= 0 || cmax <= 0 || cmax < cmin) {
-			rdev_err(rdev, "invalid voltage constraints\n");
-			return -EINVAL;
-		}
-
-		/* no need to loop voltages if range is continuous */
-		if (rdev->desc->continuous_voltage_range)
-			return 0;
-
-		/* initial: [cmin..cmax] valid, [min_uV..max_uV] not */
-		for (i = 0; i < count; i++) {
-			int	value;
-
-			value = ops->list_voltage(rdev, i);
-			if (value <= 0)
-				continue;
-
-			/* maybe adjust [min_uV..max_uV] */
-			if (value >= cmin && value < min_uV)
-				min_uV = value;
-			if (value <= cmax && value > max_uV)
-				max_uV = value;
-		}
-
-		/* final: [min_uV..max_uV] valid iff constraints valid */
-		if (max_uV < min_uV) {
-			rdev_err(rdev,
-				 "unsupportable voltage constraints %u-%uuV\n",
-				 min_uV, max_uV);
-			return -EINVAL;
-		}
-
-		/* use regulator's subset of machine constraints */
-		if (constraints->min_uV < min_uV) {
-			rdev_dbg(rdev, "override min_uV, %d -> %d\n",
-				 constraints->min_uV, min_uV);
-			constraints->min_uV = min_uV;
-		}
-		if (constraints->max_uV > max_uV) {
-			rdev_dbg(rdev, "override max_uV, %d -> %d\n",
-				 constraints->max_uV, max_uV);
-			constraints->max_uV = max_uV;
-		}
-	}
-
 	return 0;
 }
 
-- 
2.53.0

