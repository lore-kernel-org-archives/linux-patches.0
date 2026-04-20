Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E11D3F0AA4;
	Mon, 20 Apr 2026 13:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691533; cv=none; b=EToVZnEZQ6VevX6OehHXJynB59nBgufC8+f6Jxuhm6D67EFlety+pSwT9AOSHthr7bxsKlcvuEZembosq673k4TabCy/bpt0oMO/OnNfVblYlN63080/F3XdKtR99nvIQ96CbS84XImPrg+QCMisCxBDVyuEt4v1Sr7rWiRsx70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691533; c=relaxed/simple;
	bh=WYswN/ROswEAsJMjhIx+uqRHKp+65BaQFPOFnwBgM3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lcJCphbANDLR4ewy2ncbQE9Vr03StizuN5J5xlYTWz2dtm6u1YKW6rEu7cHH4upUrtf1cSuoiwqGAQe3ZhOd4H1DjLDxobF3T7y0TCborev4vynk7C5PkzXWaRkM5fq0wBhoam4JZCZ087xWYq1cbhB1AOijRC4/pNFkrixH5nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TWwN9/Ki; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TWwN9/Ki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEDBEC2BCB4;
	Mon, 20 Apr 2026 13:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691533;
	bh=WYswN/ROswEAsJMjhIx+uqRHKp+65BaQFPOFnwBgM3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TWwN9/KiFOi8KofX2NLDsLSH3+AhHWaskkGVjuYmT9nx7zfNlMpYy9+s7++AmjkwO
	 Hl5onZE159VSwHd1TTC4/DrHFOPvnUHP2BhAJLHEDQ6eDzPgvXSUs+/iwrwBx0wTqN
	 H2uEs9Jnqcmv00pWp58VlSkyClVQKJZwSJmzRam94aZmGJUwc2HXDcr5/eB41ZxQTQ
	 O+f4/Pb8VBChDKRaVCmShv+fudqI76ULIum0sU8oeetEdIwu3M9qT3T/xqDnmQVVoK
	 6aR+76QyWYW6PkP3EZr9+qA/FDaGVbycmh14KDKdBASUiE2kMO4SuqQDygDHHCeMeh
	 YEB8aF8od/FAA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jorge Marques <jorge.marques@analog.com>,
	Frank Li <Frank.Li@nxp.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-i3c@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.1] i3c: master: Move bus_init error suppression
Date: Mon, 20 Apr 2026 09:17:59 -0400
Message-ID: <20260420132314.1023554-85-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jorge Marques <jorge.marques@analog.com>

[ Upstream commit 49775afa983e3e5ce8e7d00ee241791073be214d ]

Prepare to fix improper Mx positive error propagation in later commits
by handling Mx error codes where the i3c_ccc_cmd command is allocated.
The CCC DISEC to broadcast address is invoked with
i3c_master_enec_disec_locked() and yields error I3C_ERROR_M2 if there
are no devices active on the bus. This is expected at the bus
initialization stage, where it is not known yet that there are no active
devices on the bus. Add bool suppress_m2 argument to
i3c_master_enec_disec_locked() and update the call site at
i3c_master_bus_init() with the exact corner case to not require
propagating positive Mx error codes. Other call site should not suppress
the error code, for example, if a driver requests to peripheral to
disable events and the transfer is not acknowledged, this is an error
and should not proceed.

Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Jorge Marques <jorge.marques@analog.com>
Link: https://patch.msgid.link/20260323-ad4062-positive-error-fix-v3-3-30bdc68004be@analog.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I now have sufficient information. Let me write the complete analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Parse subject line**
Record: Subsystem `i3c: master:`, action verb `Move` (refactoring),
summary: Move bus_init error suppression for DISEC M2 errors.

**Step 1.2: Parse tags**
Record:
- Reviewed-by: Frank Li <Frank.Li@nxp.com>
- Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
- Signed-off-by: Jorge Marques <jorge.marques@analog.com>
- Link: patch.msgid.link/20260323-ad4062-positive-error-fix-v3-3
- Signed-off-by: Alexandre Belloni (maintainer)
- **No Reported-by, no Fixes:, no Cc: stable**

**Step 1.3: Commit body analysis**
Record: Body explicitly states "Prepare to fix improper Mx positive
error propagation in later commits". Describes adding `suppress_m2`
argument to `i3c_master_enec_disec_locked()` so callers don't need to
handle positive Mx codes. No stack traces, no crash description, no
user-visible symptom described. This is author-declared preparation for
a future fix.

**Step 1.4: Hidden bug fixes**
Record: NOT a hidden bug fix - the author explicitly says "Prepare to
fix ... in later commits". Functionally this is a no-op: M2 was
suppressed via `ret != I3C_ERROR_M2` at callsite before, now via
`suppress_m2=true` inside the helper.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
Record: Single file `drivers/i3c/master.c`, 15 insertions / 8 deletions.
Modifies static helper `i3c_master_enec_disec_locked()` signature,
updates 2 static wrappers (`i3c_master_disec_locked`,
`i3c_master_enec_locked`), updates one callsite in
`i3c_master_bus_init()`.

**Step 2.2: Code flow**
Record:
- Before: `i3c_master_bus_init` called `i3c_master_disec_locked` then
  checked `if (ret && ret != I3C_ERROR_M2) goto err`.
- After: `i3c_master_bus_init` calls `i3c_master_enec_disec_locked`
  directly with `suppress_m2=true`; the helper returns 0 when cmd.err ==
  I3C_ERROR_M2; callsite just checks `if (ret) goto err`.
- Net behavior: Functionally identical under the current state of
  `i3c_master_send_ccc_cmd_locked()`.

**Step 2.3: Bug mechanism**
Record: None — this is (h) refactoring moving logic from callsite to
callee. No bug class fixed by this commit alone.

**Step 2.4: Quality**
Record: Small, surgical, reviewed by two maintainers. Risk: low. But by
itself offers no functional benefit — it only matters in conjunction
with patch 4/5 that stops propagating cmd->err.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
Record: `i3c_master_enec_disec_locked()` has been the implementation of
the DISEC helper since the i3c subsystem was introduced in commit
3a379bbcea0a ("i3c: Add core I3C infrastructure"), which is v4.17.

**Step 3.2: Fixes tag**
Record: No Fixes: tag on this commit. The related fix commit in the
series (ef8b5229348f0 "i3c: master: Fix error codes at send_ccc_cmd")
has `Fixes: 3a379bbcea0a` — pointing to the initial i3c commit.

**Step 3.3: File history**
Record: This commit is part of a 5-patch series (v3):
- 1/5 `19a1b61fa6237` "Move rstdaa error suppression" (prep)
- 2/5 `42247fffb3044` "Move entdaa error suppression" (prep)
- **3/5 `49775afa983e3` "Move bus_init error suppression" (THIS COMMIT,
  prep)**
- 4/5 `ef8b5229348f0` "Fix error codes at send_ccc_cmd" (the actual fix)
- 5/5 `0b73da96b6eb6` "adi: Fix error propagation for CCCs" (adi-
  specific follow-up)

The fix commit 4/5 explicitly names this commit as a prerequisite in its
message: "The prerequisite patches for the fix are: ... i3c: master:
Move bus_init error suppression".

**Step 3.4: Author's work**
Record: Jorge Marques (Analog Devices) is contributor of the
adi-i3c-master driver; not the i3c core maintainer. Alexandre Belloni is
the i3c maintainer (provided final SOB). The series was reviewed by
Frank Li (NXP, active i3c reviewer) and Adrian Hunter (Intel).

**Step 3.5: Dependencies**
Record: This commit is a prerequisite for commit 4/5 of the same series.
Without all three prep commits (1/5, 2/5, 3/5), commit 4/5 causes a
regression.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1: Original submission**
Record: `b4 dig -c 49775afa983e3` found original submission at
https://patch.msgid.link/20260323-ad4062-positive-error-
fix-v3-3-30bdc68004be@analog.com. Patch is the final v3 of 3 revisions
(v1 → v2 → v3). Cover letter explains the series was triggered by a
**Smatch warning on iio/adc/ad4062.c**, not a user-reported runtime
crash.

**Step 4.2: Reviewers**
Record: Recipients = Alexandre Belloni (maintainer), Frank Li (NXP
reviewer), Przemysław Gaj (Cadence). CC: linux-i3c, Dan Carpenter
(Smatch reporter), Jonathan Cameron, Adrian Hunter. Both Reviewed-by
tags (Frank Li, Adrian Hunter) are from credible reviewers.

**Step 4.3: Bug report**
Record: Closes link in the fix commit (patch 4/5) points to
https://lore.kernel.org/linux-iio/aYXvT5FW0hXQwhm_@stanley.mountain/ —
Dan Carpenter's Smatch report. No user-reported crashes, no syzbot, no
KASAN/KMSAN/KCSAN report. The bug is static-analysis-detected API
correctness.

**Step 4.4: Related patches**
Record: Confirmed as part of 5-patch series. Patches 1/5, 2/5, 3/5 are
preparation; patches 4/5, 5/5 are the actual fixes. No Cc: stable in any
version.

**Step 4.5: Stable mailing list**
Record: No stable-specific discussion found in the thread. No reviewer
suggested Cc: stable.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions**
Record: `i3c_master_enec_disec_locked()` (static, signature change),
`i3c_master_disec_locked()` (exported wrapper),
`i3c_master_enec_locked()` (exported wrapper), `i3c_master_bus_init()`
(caller updated).

**Step 5.2: Callers**
Record: `i3c_master_bus_init()` is called from `i3c_master_register()`
during driver probe (common hardware init path).
`i3c_master_disec_locked()`/`i3c_master_enec_locked()` are exported and
called from controller drivers (dw, svc, cdns, mipi-hci, renesas, adi)
for enable/disable ibi operations.

**Step 5.3: Callees**
Record: `i3c_master_send_ccc_cmd_locked()` delegates to
`master->ops->send_ccc_cmd()`. In the current stable pre-fix state, it
still returns positive Mx codes; after the series' patch 4/5, it returns
0/negative only.

**Step 5.4: Reachability**
Record: Bus init path is reachable at every I3C master device probe —
runs on every boot/init with I3C hardware.

**Step 5.5: Similar patterns**
Record: Two sibling preparation commits (1/5 rstdaa, 2/5 entdaa) follow
identical pattern of moving M2 suppression into helper functions.

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1: Code exists in stable?**
Record: The `i3c_master_enec_disec_locked()` helper and its M2-handling
call site in `i3c_master_bus_init()` exist essentially unchanged since
v4.17. The buggy M2-propagation pattern exists in every active stable
tree.

**Step 6.2: Backport difficulty**
Record: Would apply with minor conflicts to older stables due to
unrelated churn in bus_init.

**Step 6.3: Related fixes in stable**
Record: **Critical observation** — in the stable candidate branch under
evaluation, the series' fix commit (patch 4/5) is present but this
preparation commit (3/5) and the other two preparation commits (1/5,
2/5) are NOT. I verified `i3c_master_bus_init()` in the stable branch
state still has `if (ret && ret != I3C_ERROR_M2)` at the DISEC callsite.
Because the fix 4/5 stops `i3c_master_send_ccc_cmd_locked()` from
returning positive M2, the driver's underlying `-EIO`/`-ETIMEDOUT` now
propagates. That value `!= I3C_ERROR_M2`, so the check fails and
bus_init aborts when no I3C device acks DISEC — this is exactly the "no
active devices on the bus" case that M2 is meant to indicate. This is a
**real regression** that the prep commits prevent.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: Subsystem**
Record: `drivers/i3c/` — I3C bus subsystem. Criticality: PERIPHERAL
(affects systems with I3C hardware only, a relatively niche but growing
bus), but on those systems bus_init is mandatory so impact is 100% of
affected users.

**Step 7.2: Activity**
Record: Active subsystem, moderate churn, new controller drivers being
added.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected users**
Record: Any stable system running an I3C controller driver. Bus init
runs on every probe.

**Step 8.2: Trigger conditions**
Record: This commit alone has no trigger (no behavior change). The
scenario it addresses: bus_init when no active I3C device acknowledges
DISEC broadcast. Very common during early boot of I3C controllers where
devices may be powered off or absent.

**Step 8.3: Failure mode**
Record: In isolation, this commit changes nothing. When taken together
with patch 4/5 (the actual fix), its absence causes bus_init to fail and
the I3C controller to fail to probe. Severity in that combined scenario:
HIGH (boot-time probe failure).

**Step 8.4: Risk-benefit**
Record:
- Standalone benefit: zero (no bug fixed by itself).
- Series-level benefit: Prevents a regression in the fix-for-stable.
  Without it, the fix breaks bus_init.
- Risk: very low (15/8 lines, static helper, functionally equivalent to
  prior code).

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence**
FOR backporting:
- It is an explicit, author-named prerequisite for patch 4/5 ("i3c:
  master: Fix error codes at send_ccc_cmd"), which is itself a real bug
  fix (Smatch-reported, Fixes: the initial i3c core commit, affects an
  exported API contract).
- Without this commit, applying patch 4/5 to stable causes a regression
  at bus_init (verified by inspecting `i3c_master_bus_init()` in the
  stable branch state — the `ret != I3C_ERROR_M2` check still present,
  but `ret` will no longer ever be positive I3C_ERROR_M2, so the check
  always fails into error path).
- Small, contained (23 lines in one file), reviewed by two i3c reviewers
  including Adrian Hunter.
- Touches only a static helper and a single callsite; risk is minimal.

AGAINST backporting:
- By its own commit message, it is explicitly a preparation/refactor
  that "prepares to fix in later commits", with no standalone bug fix —
  a canonical STRONG NO signal per the guidelines.
- No Cc: stable, no Reported-by, no Fixes: tag on this commit itself.
- If autosel selects this but not patch 4/5, it provides zero benefit
  (pure refactoring in stable).
- The original bug's severity is medium (API-contract correctness,
  Smatch-found, no user runtime report).

**Step 9.2: Stable rules checklist**
1. Obviously correct and tested: YES (reviewed, minor refactor,
   mainline-tested)
2. Fixes a real bug: NO on its own. YES only transitively as prereq to
   4/5.
3. Important issue: NO standalone. Medium in series.
4. Small and contained: YES (single file, ~23 lines)
5. No new features/APIs: YES (static helper signature only)
6. Applies cleanly: YES with minor context adjustments

**Step 9.3: Exception categories**
Record: None apply — not a device ID, quirk, DT, build fix, or doc fix.

**Step 9.4: Decision**
This is a genuinely borderline "patch 3/5 is a preparation commit" case.
The strict reading of stable rules marks preparation commits as STRONG
NO. However, the guidelines also explicitly call out incomplete fix
series as borderline cases requiring dependency analysis. My
verification shows:

1. Patch 4/5 of the series is the actual bug fix targeting a real (if
   medium-severity) API-contract bug that has existed since i3c was
   introduced.
2. Patch 4/5 **cannot be backported safely without this prerequisite** —
   I verified the resulting bus_init code would regress (driver-returned
   `-EIO` falls into the error path when the old code relied on positive
   M2 propagation to take the "no devices" happy path).
3. The cost of including this prep commit is negligible (pure refactor,
   reviewed, small scope).
4. The cost of excluding it, if patch 4/5 is selected, is a boot/probe
   regression for I3C-enabled systems.

Given the clear transitive value (preventing a regression in an
accompanying fix) and the minimal risk profile, this should travel with
its fix series rather than be evaluated in isolation.

---

## Verification

- [Phase 1] Parsed tags from commit message: two Reviewed-by (Frank Li
  NXP, Adrian Hunter Intel), two SOB (author + maintainer Belloni), Link
  to lore/patch.msgid. No Fixes:, no Cc: stable, no Reported-by.
- [Phase 1] Commit body explicitly states "Prepare to fix improper Mx
  positive error propagation in later commits" — author-declared
  preparation.
- [Phase 2] Diff inventory: single file, 15+/8-, modifies one static
  helper + 2 static wrappers + 1 callsite. Confirmed functional
  equivalence under current `i3c_master_send_ccc_cmd_locked()` behavior.
- [Phase 3] `git log --oneline -- drivers/i3c/master.c` confirmed
  recent-file history; this commit is not yet visible via HEAD's
  reachable history (only in bus-next).
- [Phase 3] `git branch --contains 49775afa983e3` → `bus-next`; same for
  patches 1/5 and 2/5. `git branch --contains 18db53793d787` → `for-
  greg/7.0-100` (stable candidate branch) — the fix is being prepared
  for stable but the prereqs are NOT in that branch.
- [Phase 3] `git show ef8b5229348f0` confirmed the fix commit explicitly
  names this commit in the prerequisite list inside its body.
- [Phase 4] `b4 dig -c 49775afa983e3` returned the lore URL
  https://patch.msgid.link/20260323-ad4062-positive-error-
  fix-v3-3-30bdc68004be@analog.com.
- [Phase 4] `b4 dig -c 49775afa983e3 -a` showed three series revisions
  (v1 → v2 → v3); the applied version is the latest.
- [Phase 4] `b4 dig -c 49775afa983e3 -m` saved thread; read cover letter
  — series was triggered by Dan Carpenter's Smatch warning on
  iio/adc/ad4062; no Cc: stable requested by author or reviewers.
- [Phase 4] Grepped mbox for `stable@|Cc:.*stable` — no hits related to
  stable nomination.
- [Phase 5] Confirmed by reading the file:
  `i3c_master_enec_disec_locked` is static and only invoked via
  `i3c_master_disec_locked`/`i3c_master_enec_locked`.
- [Phase 6] `git show 18db53793d787:drivers/i3c/master.c` confirmed
  bus_init in the stable-candidate branch still contains `if (ret && ret
  != I3C_ERROR_M2)` at the DISEC call — verifies the regression scenario
  if prereq is omitted.
- [Phase 6] Cross-referenced series cover letter: controllers return
  `-EIO`/`-EINVAL` on M2 NACK — confirms regression path.
- [Phase 8] Severity assessment based on verified dependency: HIGH (boot
  probe failure) if fix 4/5 goes without this; zero impact in isolation.
- UNVERIFIED: Could not fetch the lore thread directly over HTTP (Anubis
  bot-challenge blocked WebFetch), but b4 dig retrieved the full mbox
  for analysis instead.
- UNVERIFIED: Did not test backport apply to specific stable kernels
  (6.1, 6.6, 6.12) — stated "minor conflicts" based on file churn
  observation only.

---

This commit is explicitly a preparation/refactor with no standalone bug
fix — the canonical "STRONG NO" pattern in stable rules. However, it is
a **named, documented prerequisite** for a bug-fix commit in the same
5-patch series, and I have verified that applying that fix without this
preparation would cause a real regression at I3C bus init (a common
boot-path code path). Stable sanity demands the series travels as a unit
or not at all.

**YES**

 drivers/i3c/master.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 9e6be49bebb2c..b91dc1e734ed8 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -1051,7 +1051,8 @@ int i3c_master_entdaa_locked(struct i3c_master_controller *master)
 EXPORT_SYMBOL_GPL(i3c_master_entdaa_locked);
 
 static int i3c_master_enec_disec_locked(struct i3c_master_controller *master,
-					u8 addr, bool enable, u8 evts)
+					u8 addr, bool enable, u8 evts,
+					bool suppress_m2)
 {
 	struct i3c_ccc_events *events;
 	struct i3c_ccc_cmd_dest dest;
@@ -1071,6 +1072,9 @@ static int i3c_master_enec_disec_locked(struct i3c_master_controller *master,
 	ret = i3c_master_send_ccc_cmd_locked(master, &cmd);
 	i3c_ccc_cmd_dest_cleanup(&dest);
 
+	if (suppress_m2 && ret && cmd.err == I3C_ERROR_M2)
+		ret = 0;
+
 	return ret;
 }
 
@@ -1091,7 +1095,7 @@ static int i3c_master_enec_disec_locked(struct i3c_master_controller *master,
 int i3c_master_disec_locked(struct i3c_master_controller *master, u8 addr,
 			    u8 evts)
 {
-	return i3c_master_enec_disec_locked(master, addr, false, evts);
+	return i3c_master_enec_disec_locked(master, addr, false, evts, false);
 }
 EXPORT_SYMBOL_GPL(i3c_master_disec_locked);
 
@@ -1112,7 +1116,7 @@ EXPORT_SYMBOL_GPL(i3c_master_disec_locked);
 int i3c_master_enec_locked(struct i3c_master_controller *master, u8 addr,
 			   u8 evts)
 {
-	return i3c_master_enec_disec_locked(master, addr, true, evts);
+	return i3c_master_enec_disec_locked(master, addr, true, evts, false);
 }
 EXPORT_SYMBOL_GPL(i3c_master_enec_locked);
 
@@ -2102,11 +2106,14 @@ static int i3c_master_bus_init(struct i3c_master_controller *master)
 			goto err_bus_cleanup;
 	}
 
-	/* Disable all slave events before starting DAA. */
-	ret = i3c_master_disec_locked(master, I3C_BROADCAST_ADDR,
-				      I3C_CCC_EVENT_SIR | I3C_CCC_EVENT_MR |
-				      I3C_CCC_EVENT_HJ);
-	if (ret && ret != I3C_ERROR_M2)
+	/*
+	 * Disable all slave events before starting DAA. When no active device
+	 * is on the bus, returns Mx error code M2, this error is ignored.
+	 */
+	ret = i3c_master_enec_disec_locked(master, I3C_BROADCAST_ADDR, false,
+					   I3C_CCC_EVENT_SIR | I3C_CCC_EVENT_MR |
+					   I3C_CCC_EVENT_HJ, true);
+	if (ret)
 		goto err_bus_cleanup;
 
 	/*
-- 
2.53.0

