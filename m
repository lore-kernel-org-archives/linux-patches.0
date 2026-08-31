Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBBF4A8415;
	Mon, 31 Aug 2026 13:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183925; cv=none; b=cW/tl0zblfDhFRloqBjYMfFFEWy4rPnNejwaVP2ojPAxhMDat68r2mdnvz1uZD/6k0WHdtONy8OhIeYR6RLVvz+Z1GtoZ+B+b6UwGW/oDlV3cxRT0aH9wkA1C5EoI3zIV0emOg4kSLELtvo4+IIWplI8s2Lxql31Y23+w5BoIT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183925; c=relaxed/simple;
	bh=OIg7l13nxuhdLn1XpDZ8UMkOMxzCvSHj/QYjizJdQ90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lp7XftSeALIbyWkm27cfpmbxJR+tz0I3GTwrMaPsWmUcTuZMhENwZDzMpwQPEN7DWwVhnCc3/B5I8VJA7XK2OVvM2aNCPHoyWn1+6LzyY0lBrz3lY2iUXUXQ8PoRqDWELskjkovHB7qGQzz3+1TTN79wK8Ot9+q51+Euh7wATqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J8yogWWh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J8yogWWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F011F00ACA;
	Mon, 31 Aug 2026 13:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183922;
	bh=vfRLqjE0w724fjjraUPwJXa+ty8mIFanlDPtt44qbrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J8yogWWhJJIDD6ntjM7BAK0893jhdI1Q4N6GNCkcG/zJ7qLu8Bg82DmzcbkCqDTw3
	 ybbAm7v9q8oJetTycPjS5IUAz80VR6sfM4b4wfXe8PzoeV6DsyTRKjvaiMs1Z3w/3L
	 A0ubvm/7wE1WPZbH5F++qQD+s7gKRxjYuaGrtLNZY4BdDaBmGIVdOQeAXfzg5Vruy3
	 B5XGoEWqBG3AwTUaGpd9mPlkNhy35yuDxqNApZ6oU3Nty/sPZ4F4DR/HeX40wZcBhK
	 Kh/Jsp0nzXNU4q3Pbee8Yt4K44/Bw2gWCG42M6N6zdZe74ZMvb0rvkAnJwwJQyencg
	 vMVvvH3nJ8Q0A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	rafael@kernel.org,
	maciej.wieczor-retman@intel.com,
	pawel.chmielewski@intel.com,
	linux-acpi@vger.kernel.org,
	acpica-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ACPICA: Fix use-after-free in acpi_ds_terminate_control_method()
Date: Mon, 31 Aug 2026 09:26:51 -0400
Message-ID: <20260831133314.4125787-383-sashal@kernel.org>
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

From: ikaros <void0red@gmail.com>

[ Upstream commit 945e87267cfd90937b3c637f87324cbb56998b72 ]

Fix use-after-free issue in acpi_ds_terminate_control_method() by
clearing references to method locals and arguments.

Link: https://github.com/acpica/acpica/commit/36f22a94cb1b
Signed-off-by: ikaros <void0red@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/8730924.NyiUUSuA9g@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ACPICA UAF in
`acpi_ds_terminate_control_method()`

**Local tree:** Linux **6.18.44** (`git describe HEAD` → `v6.18.44`,
`make kernelversion` → `6.18.44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[ACPICA] [fix] use-after-free in
acpi_ds_terminate_control_method() when clearing references to method
locals/arguments`

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Link:** https://github.com/acpica/acpica/commit/36f22a94cb1b
  (upstream ACPICA commit)
- **Link:** https://patch.msgid.link/8730924.NyiUUSuA9g@rafael.j.wysocki
  (kernel submission; could not fetch)
- **Signed-off-by:** ikaros \<void0red@gmail.com\> (author)
- **Signed-off-by:** Rafael J. Wysocki \<rafael.j.wysocki@intel.com\>
  (ACPI maintainer)
- **Fixes:** #1119 (ACPICA GitHub issue, in upstream commit message)
- No Reported-by, Tested-by, Reviewed-by, Acked-by, or Cc: stable in the
  provided message
- Notable: Maintainer sign-off; upstream issue with ASAN reproduction

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** If `walk_state->return_desc` is a `RefOf` reference pointing
  at a method local or argument namespace node (embedded in
  `walk_state`), terminating the method deletes locals/args and later
  frees `walk_state`, leaving a dangling pointer in `return_desc`.
- **Symptom:** Heap use-after-free when `acpi_ns_resolve_references()`
  dereferences `node->object` during `acpi_evaluate_object()`.
- **Root cause:** `acpi_ds_method_data_delete_all()` and
  `acpi_ds_delete_walk_state()` invalidate nodes still referenced by
  `return_desc`.
- **Fix approach:** Before deleting locals/args, detect
  `ACPI_REFCLASS_REFOF` references to `walk_state->local_variables[]` or
  `walk_state->arguments[]`, drop the reference, and NULL `return_desc`.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not disguised — explicitly labeled as a use-after-free fix.
The mechanism is a classic dangling-pointer bug in interpreter teardown,
not cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **Files:** `drivers/acpi/acpica/dsmethod.c` (+43 lines, 0 removed)
- **Function modified:** `acpi_ds_terminate_control_method()`
- **Scope:** Single-file, surgical fix in ACPI interpreter dispatch path

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Record:**
- **Hunk (before):** On method termination, immediately calls
  `acpi_ds_method_data_delete_all(walk_state)` while
  `walk_state->return_desc` may still hold a `RefOf` pointer into
  `walk_state->local_variables[]` or `walk_state->arguments[]`.
- **Hunk (after):** Before `acpi_ds_method_data_delete_all()`, if
  `return_desc` is `ACPI_TYPE_LOCAL_REFERENCE` / `ACPI_REFCLASS_REFOF`
  and `reference.object` matches a local or argument node in this
  `walk_state`, call `acpi_ut_remove_reference()` and set `return_desc =
  NULL`.
- **Execution path:** Method termination during AML parse/execute
  (normal and error paths), always under interpreter lock.

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:**
- **Category:** Memory safety — use-after-free (dangling pointer)
- **Mechanism:** `local_variables[]` and `arguments[]` are embedded in
  `struct acpi_walk_state` (`acstruct.h:66-67`). A `RefOf(LocalX)`
  return value stores a pointer to those nodes. After method termination
  frees `walk_state`, `acpi_ns_resolve_references()` at
  `nsxfeval.c:496-501` reads `node->object` from freed memory.

### Step 2.4: ASSESS THE FIX QUALITY
**Record:**
- Fix is minimal, localized, and logically correct for the identified
  failure mode.
- Regression risk is low: only affects the teardown path when
  `return_desc` references ephemeral local/arg nodes.
- Trade-off: dropping the reference yields no return value instead of a
  crash — acceptable vs. UAF, and explicit `Return(RefOf(Local))` paths
  are supposed to resolve references earlier in `dscontrol.c`.
- No API changes, no new features.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:** Buggy teardown sequence dates to **2005-2006**
(`b229cf92eee616` / `^1da177e4c3f41` on
`acpi_ds_method_data_delete_all()` call). Long-present bug, not a recent
regression.

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** No `Fixes:` tag in the kernel commit message. Upstream
ACPICA commit references `Fixes: #1119`.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:** Related prior UAF fix in this tree: `6fcab27915439`
("ACPICA: Refuse to evaluate a method if arguments are missing") —
different bug, same subsystem, also UAF from AML evaluation. Another:
`470188b09e92d` (package copy UAF). This specific
`terminate_control_method` fix is **not** present in 6.18.44.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** Author ikaros reported ACPICA issue #1119. Rafael J. Wysocki
is ACPI maintainer and regularly syncs ACPICA fixes (e.g.,
`6fcab27915439`, `e2c80b3c23782`).

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:** Standalone fix. No series dependencies. Applies to existing
`acpi_ds_terminate_control_method()` with only path adjustment
(`source/components/dispatcher/dsmethod.c` →
`drivers/acpi/acpica/dsmethod.c`).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:** `b4 dig -c 36f22a94cb1b` failed — commit is upstream ACPICA
only, not in this kernel tree. `lore.kernel.org` returned 403.
`patch.msgid.link` blocked by bot protection. Upstream GitHub issue
#1119 provides full reproduction and ASAN stack trace.

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** Could not verify via b4/lore. Upstream issue closed by Saket
Dumbre (ACPICA maintainer). Kernel commit signed by Rafael J. Wysocki.

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** [ACPICA issue
#1119](https://github.com/acpica/acpica/issues/1119) — "Use-After-Free
in AcpiNsResolveReferences"
- **Reproducer:** `./acpiexec -m issue7.aml`
- **ASAN:** heap-use-after-free READ at `AcpiNsResolveReferences`
  (nsxfeval.c:692 upstream)
- **Free site:** `AcpiDsDeleteWalkState` during `AcpiPsParseAml`
- **Alloc site:** `AcpiDsCreateWalkState`
- Severity: reproducible memory corruption in ACPI method evaluation

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** Single-commit fix in upstream ACPICA. No multi-patch series.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** Could not access lore (403). No stable-list discussion found
via available tools.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** `acpi_ds_terminate_control_method()` — only function
modified.

### Step 5.2: TRACE CALLERS
**Record:** Called from:
- `psxface.c:168` — internal method execution cleanup
- `psparse.c:434` — error path during thread creation
- `psparse.c:568` — normal method completion / error during parse
- `dsmethod.c:594` — nested method handling

All paths run during ACPI control method evaluation — core interpreter
hot path.

### Step 5.3: TRACE CALLEES
**Record:** Fix adds `acpi_ut_remove_reference()`; existing path calls
`acpi_ds_method_data_delete_all()`, namespace cleanup, mutex release,
thread count management.

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:**
`acpi_evaluate_object()` → `acpi_ns_evaluate()` →
`acpi_ps_execute_method()` → `acpi_ps_parse_aml()` →
`acpi_ds_terminate_control_method()` → (later)
`acpi_ns_resolve_references()` on the return object.

Reachable whenever kernel code evaluates ACPI methods returning `RefOf`
references to locals/args without prior resolution — including firmware
AML during boot, suspend/resume, thermal, battery, and device
enumeration.

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** `dscontrol.c:236-254` and `dscontrol.c:264-286` already
resolve references on explicit `Return()`, but
`acpi_ds_restart_control_method()` (`dsmethod.c:658`) can propagate
unresolved `return_desc` from nested calls. The terminate-time guard
closes the gap.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:** **YES.** `drivers/acpi/acpica/dsmethod.c:717-721` goes
directly to `acpi_ds_method_data_delete_all()` with no `return_desc`
guard. `local_variables[]` / `arguments[]` embedded in `walk_state` per
`acstruct.h:66-67`. `acpi_ns_resolve_references()` at
`nsxfeval.c:496-501` performs the dangling dereference. Fix is **not**
present (grep found no matching comment/pattern).

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** Expected **clean apply** with path adjustment only.
Insertion point at line 717 matches upstream hunk context exactly.
Upstream raw patch failed only due to path mismatch
(`source/components/dispatcher/` vs `drivers/acpi/acpica/`).

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** No equivalent fix for this specific UAF. Prior ACPICA UAF
fixes (`6fcab27915439`, `470188b09e92d`) address different bugs.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** **ACPI / ACPICA interpreter** — **CORE**. Affects all ACPI-
enabled systems (x86, ARM servers/laptops, etc.).

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** Actively maintained; regular ACPICA syncs in 6.18.y (e.g.,
`e2c80b3c23782`, `6fcab27915439`).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** All systems running ACPI firmware methods — universal on
ACPI platforms. `acpi_evaluate_object` is used across battery, thermal,
power, PCI, processor, and bus code (30+ files under `drivers/acpi/`).

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:** ACPI method returns a `RefOf` reference to its own local or
argument without the reference being fully resolved before method
termination. Triggered by specific AML (reproduced with `issue7.aml`;
potentially present in platform firmware). Not a direct unprivileged
syscall path, but firmware-controlled AML runs with kernel privileges.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:** **HIGH** — heap use-after-free during
`acpi_evaluate_object()`. Can cause kernel oops/crash or memory
corruption. Potential security relevance (UAF in privileged interpreter
context).

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** HIGH — prevents real UAF on common ACPI evaluation path
- **Risk:** LOW — 43 lines, single function, teardown-only, maintainer-
  reviewed pattern
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backport:**
- Confirmed heap UAF with ASAN reproduction (ACPICA #1119)
- Affects `acpi_evaluate_object()` — widely used kernel API
- Buggy code present in 6.18.44 since ~2005
- Small, surgical, obviously correct fix
- ACPI maintainer sign-off
- Precedent: similar ACPICA UAF fixes already in stable series
  (`6fcab27915439`)
- Failure mode is crash/memory corruption, not cosmetic

**AGAINST backport:**
- Requires minor path adjustment for kernel tree (trivial)
- Trigger depends on specific AML patterns (may be rare in the wild, but
  firmware is uncontrolled input)
- No in-kernel Tested-by / Reviewed-by tags in provided message

**UNRESOLVED:**
- Full lore.kernel.org review thread (403)
- Whether this exact commit has landed in mainline kernel yet (not in
  6.18.44)

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — logic is clear; ASAN-tested
   upstream with reproducer; maintainer SOB
2. Fixes a real bug affecting users? **PASS** — confirmed UAF in ACPI
   evaluation
3. Important issue? **PASS** — UAF / potential crash and memory
   corruption (HIGH severity)
4. Small and contained? **PASS** — 43 lines, one function, one file
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — code exists; trivial path
   adjustment

### Step 9.3: EXCEPTION CATEGORIES
**Record:** Not applicable (not device ID, quirk, DT, build, or docs).
Standard bug fix.

### Step 9.4: DECISION RATIONALE

This commit fixes a real, reproducible use-after-free in the ACPICA
interpreter teardown path. The vulnerable code is present in Linux
6.18.44, the failure occurs on the `acpi_evaluate_object()` return path
used throughout the kernel, and the fix is minimal with low regression
risk. This is appropriate stable material comparable to the already-
accepted `6fcab27915439` ACPICA UAF fix.

---

## Verification

- [Phase 1] Parsed subject, tags, body; identified UAF fix intent
- [Phase 1] GitHub API: upstream commit `36f22a94cb1b`, author ikaros,
  `Fixes: #1119`
- [Phase 2] Diff: +43 lines in `acpi_ds_terminate_control_method()`,
  REFOF local/arg guard before `acpi_ds_method_data_delete_all()`
- [Phase 3] `git blame -L 717,722`: buggy teardown from 2005-2006
- [Phase 3] `git log --grep`: fix not in tree; related UAF fix
  `6fcab27915439` present
- [Phase 4] GitHub issue #1119: full ASAN report, reproducer `acpiexec
  -m issue7.aml`
- [Phase 4] `b4 dig -c 36f22a94cb1b`: no match (ACPICA-only commit)
- [Phase 4] lore.kernel.org / patch.msgid.link: 403/bot-blocked —
  UNVERIFIED for ML review
- [Phase 5] `grep acpi_ds_terminate_control_method`: callers in
  `psxface.c`, `psparse.c`, `dsmethod.c`
- [Phase 5] Read `nsxfeval.c:472-517`: UAF dereference at `node->object`
  for `ACPI_REFCLASS_REFOF`
- [Phase 5] Read `acstruct.h:66-67`: locals/args embedded in
  `walk_state`
- [Phase 6] `git describe HEAD`: v6.18.44; buggy code confirmed at
  `dsmethod.c:717-721`
- [Phase 6] `grep` for fix comment: not present in tree
- [Phase 6] Upstream patch dry-run: fails on path only; hunk context
  matches kernel file
- [Phase 8] Failure mode: heap UAF → crash/corruption, severity HIGH

**YES**The background searches finished and line up with the earlier
analysis:

- **UAF fix commit search:** No match for “Fix use-after-free in
  acpi_ds_terminate” in this tree — the fix is **not** in 6.18.44 yet.
- **Related fixes search:** Other ACPICA UAF fixes are already here
  (`6fcab27915439` for missing method arguments, `470188b09e92d` for
  package copy), but nothing equivalent for this
  `acpi_ds_terminate_control_method()` issue.

**Verdict for 6.18.44 remains YES** — real, reproducible UAF on the
`acpi_evaluate_object()` path; small, surgical fix; should backport with
the usual ACPICA path adjustment.

 drivers/acpi/acpica/dsmethod.c | 43 ++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/acpi/acpica/dsmethod.c b/drivers/acpi/acpica/dsmethod.c
index 45ec32e81903a..08bfe83030838 100644
--- a/drivers/acpi/acpica/dsmethod.c
+++ b/drivers/acpi/acpica/dsmethod.c
@@ -705,6 +705,8 @@ void
 acpi_ds_terminate_control_method(union acpi_operand_object *method_desc,
 				 struct acpi_walk_state *walk_state)
 {
+	u32 i;
+	struct acpi_namespace_node *ref_node;
 
 	ACPI_FUNCTION_TRACE_PTR(ds_terminate_control_method, walk_state);
 
@@ -715,6 +717,47 @@ acpi_ds_terminate_control_method(union acpi_operand_object *method_desc,
 	}
 
 	if (walk_state) {
+		/*
+		 * Check if the return value is a ref_of reference to a method local
+		 * or argument. If so, clear the reference to avoid use-after-free
+		 * when the walk state is deleted.
+		 */
+		if (walk_state->return_desc &&
+		    (walk_state->return_desc->common.type ==
+		     ACPI_TYPE_LOCAL_REFERENCE)
+		    && (walk_state->return_desc->reference.class ==
+			ACPI_REFCLASS_REFOF)) {
+			ref_node = walk_state->return_desc->reference.object;
+			if (ref_node) {
+
+				/* Check against method locals */
+				for (i = 0; i < ACPI_METHOD_NUM_LOCALS; i++) {
+					if (ref_node ==
+					    &walk_state->local_variables[i]) {
+						acpi_ut_remove_reference
+						    (walk_state->return_desc);
+						walk_state->return_desc = NULL;
+						break;
+					}
+				}
+
+				/* Check against method arguments if not already cleared */
+				if (walk_state->return_desc) {
+					for (i = 0; i < ACPI_METHOD_NUM_ARGS;
+					     i++) {
+						if (ref_node ==
+						    &walk_state->arguments[i]) {
+							acpi_ut_remove_reference
+							    (walk_state->
+							     return_desc);
+							walk_state->
+							    return_desc = NULL;
+							break;
+						}
+					}
+				}
+			}
+		}
 
 		/* Delete all arguments and locals */
 
-- 
2.53.0

