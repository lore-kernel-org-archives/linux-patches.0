Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0FA3BE163;
	Mon, 20 Apr 2026 13:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691034; cv=none; b=T16jrXx77rn1jfsMePp4pmcgJsA4DJmJTBwX6+FTHFughDi9K8xqbbGcUxHpCZ4sRaB7BAxWNENZylTmUmHZ3aG7h4dOKERtrSFIbs/pPEZqRzpdjwMp2xdxzcUEB5aMOXNiIc6eDscnAFhPsL19X/W9Y1YTlmZePdc5jD7o3jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691034; c=relaxed/simple;
	bh=81Ng9CutKyy/7MQcL5BdbyBnhxSmd8NnfjmHPiUjoww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AzPksNp6Em/rcf8A1fsonTUq0B8qS6yTQKhDOOyyCkimsHE6I6zHk8FB+DWVW1lCOnbuCCUC47oas7JKrbvBbI4gzk7Qot4ObkZAbwDfKS+HEY+Hgb6r0IxPOQXkfjJ4QUQTCGY6RzSSpdVvUAh/fEOzfCmZe/hEOfduGmCXclw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tJ/o9J/b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tJ/o9J/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13FF5C19425;
	Mon, 20 Apr 2026 13:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691034;
	bh=81Ng9CutKyy/7MQcL5BdbyBnhxSmd8NnfjmHPiUjoww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tJ/o9J/bpQZkCfaH7vEDlqjQ+RRyxFtJOrygjdNpPdMUD/r7+n/iaycw6SatXYAcS
	 Ef2asPmDLuv/X/DWI8DTNkCnOMnEFhEZwslrD0Jl9hdn8vbwj1Q2yFlvs4pGlHi0YP
	 w4SQuv4INozniKWmN2Xc2tDeuClPhpPdObygaJmku5P1MfYLW1Z4343Syl9nI5RtzB
	 CbDtJ2DdgskfcRbG7RCWXG1x5rvME0vXxPUHJDoFIZHGqIiMfrFpzdTCFMra84EB/O
	 V+LpQEiCitUz0E6Eokqi3L1T4uqlsDJ+1lJC2C+A1EDtZvWuZS+++gJlf9rjsZyEgB
	 4rrpF1VW3RISw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ravi Bangoria <ravi.bangoria@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mingo@redhat.com,
	acme@kernel.org,
	tglx@kernel.org,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] perf/amd/ibs: Avoid race between event add and NMI
Date: Mon, 20 Apr 2026 09:08:41 -0400
Message-ID: <20260420131539.986432-55-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
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

From: Ravi Bangoria <ravi.bangoria@amd.com>

[ Upstream commit 1b044ff3c17e9d7fd93ffc0ba541ccdeb992d7f5 ]

Consider the following race:

  --------
  o OP_CTL contains stale value: OP_CTL[Val]=1, OP_CTL[En]=0
  o A new IBS OP event is being added
  o [P]: Process context, [N]: NMI context

  [P] perf_ibs_add(event) {
  [P]     if (test_and_set_bit(IBS_ENABLED, pcpu->state))
  [P]         return;
  [P]     /* pcpu->state = IBS_ENABLED */
  [P]
  [P]     pcpu->event = event;
  [P]
  [P]     perf_ibs_start(event) {
  [P]         set_bit(IBS_STARTED, pcpu->state);
  [P]         /* pcpu->state = IBS_ENABLED | IBS_STARTED */
  [P]         clear_bit(IBS_STOPPING, pcpu->state);
  [P]         /* pcpu->state = IBS_ENABLED | IBS_STARTED */

  [N] --> NMI due to genuine FETCH event. perf_ibs_handle_irq()
  [N]     called for OP PMU as well.
  [N]
  [N] perf_ibs_handle_irq(perf_ibs) {
  [N]     event = pcpu->event; /* See line 6 */
  [N]
  [N]     if (!test_bit(IBS_STARTED, pcpu->state)) /* false */
  [N]         return 0;
  [N]
  [N]     if (WARN_ON_ONCE(!event)) /* false */
  [N]         goto fail;
  [N]
  [N]     if (!(*buf++ & perf_ibs->valid_mask)) /* false due to stale
  [N]                                            * IBS_OP_CTL value */
  [N]         goto fail;
  [N]
  [N]         ...
  [N]
  [N]     perf_ibs_enable_event() // *Accidentally* enable the event.
  [N] }
  [N]
  [N] /*
  [N]  * Repeated NMIs may follow due to accidentally enabled IBS OP
  [N]  * event if the sample period is very low. It could also lead
  [N]  * to pcpu->state corruption if the event gets throttled due
  [N]  * to too frequent NMIs.
  [N]  */

  [P]         perf_ibs_enable_event();
  [P]     }
  [P] }
  --------

We cannot safely clear IBS_{FETCH|OP}_CTL while disabling the event,
because the register might be read again later. So, clear the register
in the enable path - before we update pcpu->state and enable the event.
This guarantees that any NMI that lands in the gap finds Val=0 and
bails out cleanly.

Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: https://patch.msgid.link/20260216042216.1440-6-ravi.bangoria@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a thorough understanding. Let me compile the full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: `perf/amd/ibs` (AMD Instruction-Based Sampling perf PMU
  driver)
- **Action verb**: "Avoid" (almost always indicates fixing a bug)
- **Summary**: Prevent race between adding a perf event and NMI handling
  in IBS

### Step 1.2: Tags
- **Signed-off-by: Ravi Bangoria** - the author, AMD IBS subsystem
  expert
- **Signed-off-by: Peter Zijlstra (Intel)** - perf core maintainer,
  committed the patch
- **Acked-by: Namhyung Kim** - another perf subsystem maintainer
- **Link**:
  `https://patch.msgid.link/20260216042216.1440-6-ravi.bangoria@amd.com`
  - patch 5/5 (originally numbered 6 including cover letter) in a series
- **No Fixes: tag** - expected for manual review candidates
- **No Cc: stable tag** - expected

Record: Strong reviewer/maintainer endorsement. No syzbot or bug
reports.

### Step 1.3: Commit Body
The commit body provides an extremely detailed, step-by-step walkthrough
of the race:
1. `OP_CTL` has stale `Val=1, En=0` from a previous IBS sample
2. In process context, `perf_ibs_add()` → `perf_ibs_start()` sets
   `IBS_STARTED`
3. Before `perf_ibs_enable_event()` is called, an NMI arrives (from a
   FETCH event)
4. NMI handler sees `IBS_STARTED=true`, reads stale `OP_CTL[Val]=1`,
   treats it as valid
5. NMI handler calls `perf_ibs_enable_event()`, **accidentally**
   enabling the OP event
6. Results in: repeated NMIs, `pcpu->state` corruption, potential
   throttle issues

**Failure mode**: NMI storm and state corruption.

### Step 1.4: Hidden Bug Fix Detection
This is explicitly described as a race condition fix - not disguised at
all.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed**: 1 (`arch/x86/events/amd/ibs.c`)
- **Lines added**: +8 (6 comment lines + 1 blank + 1 code line)
- **Lines removed**: 0
- **Functions modified**: `perf_ibs_start()`
- **Scope**: Single-function surgical fix

### Step 2.2: Code Flow Change
**Before**: After computing `config`, `perf_ibs_start()` sets
`IBS_STARTED`, clears `IBS_STOPPING`, and enables the event. The IBS
control MSR may contain stale `Val=1` data from a previous sample.

**After**: Before setting `IBS_STARTED`, the code calls
`perf_ibs_disable_event(perf_ibs, hwc, 0)` which writes 0 to the IBS
control MSR, clearing `Val` and `En` bits. Any NMI arriving in the
window between this write and the actual event enable will read `Val=0`
and bail out.

### Step 2.3: Bug Mechanism
**Category**: Race condition between process context and NMI context
- The NMI handler (`perf_ibs_handle_irq`) is called for both FETCH and
  OP PMUs on every IBS NMI (see `perf_ibs_nmi_handler` at line
  1396-1411)
- A stale `Val=1` in the OP_CTL MSR fools the handler into thinking a
  valid sample exists
- The handler then re-enables the event prematurely

### Step 2.4: Fix Quality
- **Obviously correct**: A single MSR zero-write before enabling, using
  an existing function
- **Minimal/surgical**: 1 functional line + comments
- **Regression risk**: Extremely low - clearing a register before
  writing new values into it is safe. The MSR was going to be written
  anyway a few instructions later by `perf_ibs_enable_event()`
- **No red flags**: Single function, single file, existing API

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The IBS state machine code (set_bit/clear_bit for STARTED/STOPPING) was
introduced by:
- `5a50f529170113` (Peter Zijlstra, 2016-03-16): "Fix race with
  IBS_STARTING state"
- `85dc600263c229` (Peter Zijlstra, 2016-03-21): "Fix pmu::stop()
  nesting"

Both were merged in kernel 4.7. The race condition has existed since
then — present in **all active stable trees**.

### Step 3.2: No Fixes: tag (expected)

### Step 3.3: File History
Recent changes to `ibs.c` are mostly feature additions (ldlat filtering,
min_period, etc.) and cleanups (MSR rename, syscore changes). This fix
doesn't conflict with any of them.

### Step 3.4: Author
Ravi Bangoria is the AMD IBS subsystem maintainer/expert with 15+
commits to `arch/x86/events/amd/ibs.c`. This fix carries strong
authority.

### Step 3.5: Dependencies
This is patch 5/5 in a series titled "perf/amd/ibs: Assorted fixes":
1. "Account interrupt for discarded samples"
2. "Limit ldlat->l3missonly dependency to Zen5"
3. "Preserve PhyAddrVal bit when clearing PhyAddr MSR"
4. "Avoid calling perf_allow_kernel() from the IBS NMI handler"
5. "Avoid race between event add and NMI" (this patch)

**Critical finding**: This patch is **completely standalone**. It only
adds a call to the existing `perf_ibs_disable_event()` function. It does
not depend on any changes from patches 1-4 (which address unrelated
bugs).

---

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1: Patch Discussion
- Found via patchew.org and spinics.net
- Upstream commit: `1b044ff3c17e9d7fd93ffc0ba541ccdeb992d7f5`
- Merged into tip/perf/core on Feb 27, 2026 by Peter Zijlstra
- v2 series (v1 was at different URL, split from enhancements)

### Step 4.2: Reviewers
- **Namhyung Kim** Acked the entire series
- **Peter Zijlstra** (perf core maintainer) committed it
- All appropriate subsystem maintainers were involved

### Step 4.3-4.5: No specific bug report (author-found via code
analysis), no stable-specific discussion found.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
- `perf_ibs_start()` (modified) - called from `perf_ibs_add()` during
  event scheduling
- `perf_ibs_disable_event()` (called, not modified) - writes 0 to IBS
  control MSR

### Step 5.2: Callers of perf_ibs_start
- `perf_ibs_add()` → `perf_ibs_start()` — called during perf event
  scheduling to CPU
- This is a standard perf PMU operation, triggered whenever a perf event
  using IBS is scheduled

### Step 5.3-5.4: Call Chain
`perf_event_open()` → context scheduling → `perf_ibs_add()` →
`perf_ibs_start()`. The race is triggerable from userspace by using
`perf record` with IBS events on AMD processors. This is a common usage
path.

### Step 5.5: Similar Patterns
The existing IBS state machine already had two prior race fixes (5a50f52
and 85dc600) for similar NMI vs. process context races. This is a third
variant of the same class of bug.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable
The vulnerable code (`set_bit(IBS_STARTED, ...)` followed by
`perf_ibs_enable_event()` without clearing stale MSR data) has existed
since kernel 4.7 (2016). It exists in **all active stable trees**:
5.4.y, 5.10.y, 5.15.y, 6.1.y, 6.6.y, 6.12.y.

### Step 6.2: Backport Complications
The `perf_ibs_start()` function has seen minor changes over the years
(8b0bed7d in v5.9 added config variable, fa5d0a82 added min_period
check), but the core structure — compute config, set STARTED, enable
event — has remained stable. The MSR accessor names changed (`wrmsrl` →
`wrmsrq`) in newer trees, but the older trees still have
`perf_ibs_disable_event()` with the same signature. The patch should
apply cleanly to recent stable trees, and with trivial adjustments to
older ones.

### Step 6.3: No related fixes already in stable for this specific race.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
- **Path**: `arch/x86/events/amd/ibs.c`
- **Subsystem**: x86 perf/PMU (AMD IBS)
- **Criticality**: IMPORTANT — AMD IBS is used by all AMD processor
  users running perf profiling, which is standard practice for
  performance analysis

### Step 7.2: Activity
Actively maintained by Ravi Bangoria at AMD with regular fixes and
enhancements.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is Affected
All users of AMD processors (Zen and later) using `perf` with IBS
events. This includes server workloads, desktop profiling, and CI
systems running performance testing.

### Step 8.2: Trigger Conditions
- Both IBS FETCH and IBS OP events are in use (or hardware has residual
  FETCH state)
- NMI from FETCH arrives during OP event initialization
- OP_CTL MSR has stale Val=1 from a previous sample
- More likely with low sample periods (high sampling frequency)
- Triggered from unprivileged perf usage (with appropriate
  perf_event_paranoid)

### Step 8.3: Failure Mode
- **NMI storm**: Repeated NMIs can occur if the sample period is very
  low
- **State corruption**: `pcpu->state` can become corrupted if the event
  gets throttled
- **Severity**: HIGH — NMI storms can make a system unresponsive; state
  corruption can lead to further crashes or undefined behavior

### Step 8.4: Risk-Benefit Ratio
- **Benefit**: Prevents NMI storms and state corruption on AMD systems
  during IBS profiling — HIGH benefit
- **Risk**: Single function call to an existing function, writing 0 to
  an MSR before writing new values — VERY LOW risk
- **Ratio**: Extremely favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backporting:**
- Fixes a concrete race condition between process context and NMI
  context
- Can cause NMI storms and state corruption (HIGH severity)
- Single line of functional code + comments (VERY LOW risk)
- Uses existing `perf_ibs_disable_event()` function (no new code paths)
- Self-contained — no dependencies on other patches
- Written by the AMD IBS maintainer, committed by perf core maintainer
- Acked by Namhyung Kim (another perf maintainer)
- Bug exists in all stable trees (since v4.7, 2016)
- Obviously correct — clearing a register before enabling it

**AGAINST backporting:**
- No user-reported bug or syzbot report (found via code analysis)
- Part of a 5-patch series (but confirmed standalone)
- No explicit stable nomination

### Step 9.2: Stable Rules Checklist
1. **Obviously correct and tested?** YES — single MSR write, committed
   by PeterZ, Acked by Namhyung
2. **Fixes a real bug?** YES — documented race causing NMI storms and
   state corruption
3. **Important issue?** YES — NMI storm = system hang; state corruption
   = undefined behavior
4. **Small and contained?** YES — 1 functional line in 1 function in 1
   file
5. **No new features or APIs?** Correct — no new features
6. **Can apply to stable trees?** YES — clean apply expected

### Step 9.3: Exception Categories
Not an exception category — this is a standard race condition bug fix.

### Step 9.4: Decision
Strong YES. This is a textbook stable backport candidate: a minimal,
obviously correct fix for a real race condition with severe consequences
(NMI storms, state corruption), written and reviewed by the appropriate
maintainers.

---

## Verification

- [Phase 1] Parsed tags: Signed-off-by (Bangoria, PeterZ), Acked-by
  (Namhyung Kim), Link to patchew/lore
- [Phase 2] Diff analysis: 1 functional line added
  (`perf_ibs_disable_event(perf_ibs, hwc, 0)`) + 7 comment/blank lines
  in `perf_ibs_start()`
- [Phase 2] Verified `perf_ibs_disable_event()` with config=0 writes 0
  to the MSR (lines 451-459 of ibs.c)
- [Phase 2] Verified NMI handler checks `valid_mask` at line 1261 —
  stale Val=1 bypasses this check
- [Phase 2] Verified NMI handler is called for both FETCH and OP PMUs at
  lines 1402-1403
- [Phase 3] git blame: IBS_STARTED state machine introduced by
  5a50f529170113 (v4.7, 2016) and refined by 85dc600263c229 (v4.7, 2016)
  — present in all stable trees
- [Phase 3] git log --author="Ravi Bangoria": 15+ commits to ibs.c —
  confirmed subsystem expert
- [Phase 3] Verified no dependencies on other patches in series — only
  uses existing `perf_ibs_disable_event()`
- [Phase 4] patchew.org: confirmed patch 5/5 in "Assorted fixes" series,
  all Acked by Namhyung
- [Phase 4] spinics.net: confirmed upstream commit
  1b044ff3c17e9d7fd93ffc0ba541ccdeb992d7f5, merged Feb 27, 2026
- [Phase 4] Verified series patches 1-4 are independent bug fixes
  (different issues)
- [Phase 5] Verified `perf_ibs_start()` called from `perf_ibs_add()`
  (line 568), a standard PMU scheduling path
- [Phase 6] git log v6.6.. and v6.1..: ibs.c has had changes but core
  start() structure is preserved
- [Phase 8] Failure mode: NMI storm + state corruption → severity HIGH
- UNVERIFIED: Could not access lore.kernel.org directly due to Anubis
  bot protection — used patchew.org and spinics.net mirrors instead

**YES**

 arch/x86/events/amd/ibs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index e35132c5448dd..705e9a65c9ac9 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -490,6 +490,14 @@ static void perf_ibs_start(struct perf_event *event, int flags)
 	}
 	config |= period >> 4;
 
+	/*
+	 * Reset the IBS_{FETCH|OP}_CTL MSR before updating pcpu->state.
+	 * Doing so prevents a race condition in which an NMI due to other
+	 * source might accidentally activate the event before we enable
+	 * it ourselves.
+	 */
+	perf_ibs_disable_event(perf_ibs, hwc, 0);
+
 	/*
 	 * Set STARTED before enabling the hardware, such that a subsequent NMI
 	 * must observe it.
-- 
2.53.0

