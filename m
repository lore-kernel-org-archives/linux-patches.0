Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B172743E064;
	Mon, 31 Aug 2026 13:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183225; cv=none; b=txvFdOLM0jNGKxbExUPgEtkSC7MLy9jCp6ds4UDFjsV9XNntc+1gACq2UgYA0HxPTtp+RYxano34wc5DV3lOpafpmGUFg7RtEG1GJ0G7+3jLLBjF9khZxpKyJxnnIuF5CwBMe3wVr/uQAsU6Ot36etGs1NkJSpgajn5T3wPSaUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183225; c=relaxed/simple;
	bh=l/56Mp+ctAZUbulXcqb+WeY2Ne2hHUShqhMTWzKM+TM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XOTsB88pIJY3DCbrWU80BmxmAPBg8/SW7IDb2Wwgjrpr+8wF3WBd3VvXNakBD5Zu/09Ig5lv354HLXhTEQe5oO5ZflCnPY8cq0Uj2js7L1+L93XqMdpqJi2j6TmqwjD37KPDWSdZjXlAl1fUh6nogHc5UVpLB2tEFhKFxwnd0pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DiuVFCof; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DiuVFCof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3521F000E9;
	Mon, 31 Aug 2026 13:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183222;
	bh=kCyqIH2jlVm1iotaIBZP5VkI5E3rVBdez4Hph9mnU7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DiuVFCofGFKMhz5wyDNVfBXtI6IGs7MIin2qLdUGN+HXWnGtmBWm/CjhyM0knUwnR
	 LlhwFLZVHMgtNc1HNCjPIWY8x+xbvy746UnWrTdQoy5kYYhCWQN6DjgSYXlp+vN3nN
	 VOSt8kfiiYcyJNueFPFwuESIGKGJaNx3uJhJFq61luBujBUUJO+EYX3zwi2Nulvllb
	 6n1+JALvD1Uac2/k9ArAZfj5MJSpmJKv0115osMwp9U3w1AerfqKxh4wHsPWgMI85s
	 i2bpZWMC5U54ETJWWUlLOmqCJbgneBV4kEEVPE905m9ydv+gLIFgolygOr35gyWlS2
	 a5iI5cC4UuFLw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	tglx@kernel.org,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] perf/x86/intel/uncore: Guard against invalid box control address
Date: Mon, 31 Aug 2026 09:20:46 -0400
Message-ID: <20260831133314.4125787-18-sashal@kernel.org>
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

From: Zide Chen <zide.chen@intel.com>

[ Upstream commit 3c19ea24f02658c4b8ad364458fae4d77fdb3fae ]

Theoretically, intel_uncore_find_discovery_unit() could return NULL,
e.g., when a CPU die is offline during uncore enumeration and its PMU
units are not added to the discovery RB-tree.

Guard against a NULL return value and the resulting invalid box control
address (0) before accessing hardware.

Signed-off-by: Zide Chen <zide.chen@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://patch.msgid.link/20260602144908.263680-3-zide.chen@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `perf/x86/intel/uncore: Guard against
invalid box control address`

**Local tree:** Linux **6.18.44** (`git describe HEAD` → `v6.18.44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[perf/x86/intel/uncore]` `[Guard]` — Add NULL/invalid-
address guards before accessing uncore box control hardware.

### Step 1.2: Parse all commit message tags
**Record:**
| Tag | Value |
|-----|-------|
| Signed-off-by | Zide Chen \<zide.chen@intel.com\> |
| Signed-off-by | Peter Zijlstra (Intel) \<peterz@infradead.org\> |
| Reviewed-by | Dapeng Mi \<dapeng1.mi@linux.intel.com\> |
| Link |
https://patch.msgid.link/20260602144908.263680-3-zide.chen@intel.com |

**Notable patterns:** No `Fixes:`, `Reported-by:`, `Cc: stable`, or
`Tested-by:`. Link is patch **3/3** of the same series as commit
`58cbb1c2aadf` (patch 2/3, already in this tree).

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** `intel_uncore_find_discovery_unit()` can return NULL when a
  die was offline during uncore enumeration and its PMU units were never
  added to the discovery RB-tree.
- **Symptom:** `intel_generic_uncore_box_ctl()` returns 0; callers then
  invoke `wrmsrq(0, …)` or `pci_write_config_dword(pdev, 0, …)` —
  invalid hardware access.
- **Root cause:** Commit `58cbb1c2aadf` (already in 6.18.44) made per-
  die lookup and removed `WARN_ON_ONCE`, explicitly documenting that
  NULL is expected, but did not guard all hardware-access callers.

### Step 1.4: Detect hidden bug fixes
**Record:** Not disguised — this is an explicit defensive bug fix
preventing invalid MSR/PCI config writes. Hidden-bug patterns: N/A
(message is direct).

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **File:** `arch/x86/events/intel/uncore_discovery.c` only
- **Scope:** ~+25 / -10 lines; single-file surgical fix
- **Functions modified:**
  - `intel_generic_uncore_msr_init_box`
  - `intel_generic_uncore_msr_disable_box`
  - `intel_generic_uncore_msr_enable_box`
  - `intel_generic_uncore_pci_init_box`
  - `intel_generic_uncore_pci_disable_box`
  - `intel_generic_uncore_pci_enable_box`

### Step 2.2: Code flow change (per hunk)
**Record:**
| Function | Before | After |
|----------|--------|-------|
| `*_msr_init_box` | `wrmsrq(intel_generic_uncore_box_ctl(box), …)`
unconditionally | Cache `box_ctl`; return early if `!box_ctl` |
| `*_msr_disable/enable_box` | Same unconditional `wrmsrq` | Skip
`wrmsrq` when `!box_ctl` |
| `*_pci_init_box` | `pci_write_config_dword(pdev, box_ctl, …)` even
when `box_ctl==0` | Return early if `!box_ctl` |
| `*_pci_disable/enable_box` | Same unconditional PCI write | Skip write
when `!box_ctl` |

`intel_generic_uncore_assign_hw_event()` already had `if (!box_ctl)
return false` since `b1d9ea2e1ca4` — this patch extends the same pattern
to init/enable/disable paths.

### Step 2.3: Bug mechanism
**Record:** **Category:** NULL/invalid-address hardware access
(logic/correctness fix).

- `intel_generic_uncore_box_ctl()` returns 0 when
  `intel_uncore_find_discovery_unit()` finds no unit (verified at lines
  484–485).
- `unit->addr` is never 0 for valid units — `uncore_insert_box_info()`
  rejects `!unit->ctl` before insertion (lines 229–234).
- `wrmsrq(0, val)` → write to MSR 0 (`native_write_msr` in `asm/msr.h`).
- `pci_write_config_dword(pdev, 0, val)` → write PCI config dword at
  offset 0 (vendor/device ID region); `UNCORE_DISCOVERY_PCI_BOX_CTRL(0)`
  = 0 per `uncore_discovery.h:36`.

### Step 2.4: Fix quality assessment
**Record:** Fix is minimal, mirrors existing `assign_hw_event` guard,
low regression risk. Early-return on missing discovery unit is
consistent with 58cbb1c2’s stated intent (“PMU box is not functional for
that die”). No lock-order or API changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame the changed lines
**Record:**
- `intel_generic_uncore_box_ctl()` introduced in `b1d9ea2e1ca4`
  (2024-06-14, Kan Liang).
- Per-die lookup change in `58cbb1c2aadf` (2026-06-02, Zide Chen) —
  **present in 6.18.44**.
- Unguarded `wrmsrq`/`pci_write_config_dword` callers date to 2021
  (`d6c754130435ab`, `42839ef4a20a4b`).
- Guard commit itself: **not found** in this tree’s history.

### Step 3.2: Follow Fixes: tag
**Record:** No `Fixes:` tag. Functionally follows `58cbb1c2aadf`, which
is already in this tree.

### Step 3.3: Related file history
**Record:** Recent related commits in this tree:
- `58cbb1c2aadf` — Fix discovery unit lookup for multi-die systems
  (prerequisite, in tree)
- `f34feda8e0c95` — Skip discovery table for offline dies (in tree;
  `Reported-by: Steve Wahl`, real multi-die boot issue)

### Step 3.4: Author context
**Record:** Zide Chen authored both `f34feda8e0c95` and `58cbb1c2aadf`
on this file. Peter Zijlstra (perf maintainer) signed off. Dapeng Mi
(Intel) reviewed.

### Step 3.5: Dependencies
**Record:** Depends on `58cbb1c2aadf` (already in 6.18.44). No other
prerequisites. Patch 3/3 of series; patches 1–2 appear already applied.
Standalone and self-contained.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:** `b4 dig -c` failed (commit not in local tree).
Lore/patch.msgid.link fetch blocked by Anubis bot protection. Series
context inferred from `58cbb1c2aadf` Link (`263680-2`) and this patch’s
Link (`263680-3`).

### Step 4.2: Reviewers
**Record:** Reviewed-by Dapeng Mi; Signed-off-by Peter Zijlstra —
appropriate perf/x86 maintainers.

### Step 4.3: Bug report
**Record:** No user/syzbot report in this commit. Related
`f34feda8e0c95` documents real multi-die/offline-die scenarios
(`Reported-by: Steve Wahl`, WARNING at `uncore_pci_pmu_register`).

### Step 4.4: Series context
**Record:** Part of 3-patch series from Zide Chen (June 2026). Patch 2
(`58cbb1c2aadf`) explicitly states NULL discovery units are expected
after per-die lookup; this patch completes that work.

### Step 4.5: Stable mailing list
**Record:** Could not search lore (bot protection). No stable discussion
found locally.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** Six box init/enable/disable functions listed in Phase 2.1.

### Step 5.2: Callers
**Record:**
- `init_box` via `uncore_box_init()` (`uncore.h:538–543`):
  - `uncore_pci_pmu_register()` at `uncore.c:1158` (PCI probe)
  - `uncore_box_ref()` at `uncore.c:1602` (CPU online on a die)
- `enable_box` / `disable_box` via `uncore_pmu_enable()` /
  `uncore_pmu_disable()` at `uncore.c:820–836` (perf PMU enable/disable)

### Step 5.3: Callees
**Record:** `wrmsrq()` → `native_write_msr()`;
`pci_write_config_dword()` → PCI config space write.

### Step 5.4: Call chain / reachability
**Record:**
1. Multi-die Intel server with generic discovery tables
   (`CONFIG_PERF_EVENTS`, Intel uncore PMU).
2. Die offline during enumeration → discovery units not in RB-tree
   (`f34feda8` + MSR path only parses online dies at
   `uncore_discovery.c:415–426`).
3. Die later online or PCI box registered → `uncore_box_init` / PMU
   enable runs.
4. `intel_generic_uncore_box_ctl()` returns 0 → unguarded path writes
   MSR 0 or PCI offset 0.

Reachable from CPU hotplug and perf uncore use; requires root for perf
but init runs at probe/hotplug without user perf events.

### Step 5.5: Similar patterns
**Record:** `intel_generic_uncore_assign_hw_event()` already guards `if
(!box_ctl) return false` at lines 545–547. This patch applies the same
pattern to sibling functions — consistent, not novel logic.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Does buggy code exist?
**Record:** **YES.** Current tree at `uncore_discovery.c:490–503` and
`567–589` calls `wrmsrq`/`pci_write_config_dword` without checking
`box_ctl`. Per-die NULL return path exists since `58cbb1c2aadf` (lines
482–485).

### Step 6.2: Backport complications
**Record:** Clean apply expected — single file, no conflicting changes
since `58cbb1c2aadf`. Minor style change (remove local `pdev` variable)
is cosmetic.

### Step 6.3: Related fixes already present?
**Record:** `58cbb1c2aadf` and `f34feda8e0c95` are in tree.
`assign_hw_event` guard present. **This specific guard commit is
absent.**

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `arch/x86/events/intel/` — perf uncore PMU on Intel x86.
**IMPORTANT** (not universal core, but affects Intel server/workstation
perf and hotplug paths).

### Step 7.2: Subsystem activity
**Record:** Active development in 2026 (multi-die discovery fixes).
Mature uncore framework with recent multi-die-related churn.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Intel x86 systems using generic uncore discovery (modern
server platforms — Sapphire Rapids and later class). Config-specific
(`CONFIG_PERF_EVENTS`, Intel uncore with discovery tables).

### Step 8.2: Trigger conditions
**Record:** Multi-die system where a die is offline during uncore
enumeration; die later comes online or box is initialized. Uncommon but
documented in the same author’s series. Not userspace-exploitable in a
straightforward way; triggered by boot topology / hotplug.

### Step 8.3: Failure mode severity
**Record:**
- `wrmsrq(0, …)` → likely #GP / kernel oops on invalid MSR write
- `pci_write_config_dword(pdev, 0, …)` → write to PCI config offset 0
  (vendor/device ID) — hardware corruption risk

**Severity: HIGH** (potential oops / invalid hardware access), though
trigger is relatively rare.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Prevents invalid MSR/PCI writes on a path made explicitly
  reachable by `58cbb1c2aadf` already in this tree
- **Risk:** Very low — early-return mirrors existing `assign_hw_event`
  logic
- **Ratio:** Strong benefit, minimal risk

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real bug: hardware access at address 0 when discovery unit missing
- Prerequisite `58cbb1c2aadf` already in 6.18.44 and documents NULL as
  expected
- Small, single-file, obviously correct fix
- Reviewed by Intel engineer; signed off by perf maintainer
- Completes incomplete fix from patch 2/3 of same series
- Invalid MSR/PCI writes can cause kernel oops

**AGAINST backport:**
- Commit says “theoretically” — no direct user crash report for this
  specific patch
- Affects niche multi-die + offline-die boot scenarios
- Perf subsystem, not core kernel path

**Unresolved:** Lore thread content; upstream commit SHA for this
specific patch (not in local tree).

### Step 9.2: Stable rules checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — mirrors existing guard;
reviewed by subsystem engineer |
| 2. Fixes real bug affecting users? | **PASS** — invalid hardware
access on documented code path |
| 3. Important issue? | **PASS** — potential kernel oops / invalid PCI
config write (HIGH) |
| 4. Small and contained? | **PASS** — one file, ~25 lines |
| 5. No new features/APIs? | **PASS** — defensive guards only |
| 6. Can apply to local tree? | **PASS** — prerequisite in tree; clean
apply expected |

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
bug fix.

### Step 9.4: Decision rationale
This tree (6.18.44) already contains `58cbb1c2aadf`, which intentionally
allows `intel_uncore_find_discovery_unit()` to return NULL for offline-
die enumeration gaps. Without this follow-up,
`init_box`/`enable_box`/`disable_box` still perform `wrmsrq(0, …)` and
`pci_write_config_dword(pdev, 0, …)`. The fix is the natural completion
of an already-backported series, minimal, and prevents a plausible
kernel oops on multi-die Intel systems.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit
  message
- **[Phase 2]** Diff analysis: 6 functions guarded in
  `uncore_discovery.c`
- **[Phase 3]** `git describe HEAD` → v6.18.44 / 6.18.44
- **[Phase 3]** `git blame -L 478,580` → `b1d9ea2e1ca4`, `58cbb1c2aadf`
  on lookup path
- **[Phase 3]** `git show 58cbb1c2aadf` → prerequisite in tree;
  documents expected NULL
- **[Phase 3]** `git show f34feda8e0c95` → offline-die skip in tree;
  Steve Wahl report
- **[Phase 3]** `git log --grep="Guard against invalid box control"` →
  no match (commit not in tree)
- **[Phase 4]** `b4 dig -c HEAD` → commit not in tree; cannot dig
- **[Phase 4]** WebFetch lore/patch.msgid.link → blocked by Anubis
- **[Phase 5]** Read `uncore.h:538–543`, `uncore.c:820–836,1158,1602` →
  call paths verified
- **[Phase 5]** Read `uncore_discovery.c:229–234,478–589` → buggy code
  and missing guards verified
- **[Phase 5]** Read `uncore_discovery.h:36` →
  `UNCORE_DISCOVERY_PCI_BOX_CTRL(0)` = 0
- **[Phase 5]** Read `asm/msr.h:197–200` → `wrmsrq` → `native_write_msr`
- **[Phase 6]** Buggy unguarded code confirmed present in 6.18.44
  checkout
- **[Phase 6]** `58cbb1c2aadf` and `f34feda8e0c95` confirmed in tree via
  `git log`
- **[UNVERIFIED]** Lore thread review comments and explicit stable
  nominations

**YES**The background search for this commit in the local tree finished
with no matches — `git log --grep="Guard against invalid box control"`
and `--grep="invalid box control"` both came up empty. So the guard
patch isn’t in **6.18.44** yet, while its prerequisite `58cbb1c2aadf`
(“Fix discovery unit lookup for multi-die systems”) is already there.

That lines up with the earlier analysis: the tree has the per-die lookup
change that can return NULL/0, but not the follow-up that stops
`wrmsrq(0, …)` and `pci_write_config_dword(pdev, 0, …)` in the
init/enable/disable paths. Backport recommendation remains **YES**.

 arch/x86/events/intel/uncore_discovery.c | 33 +++++++++++++++++-------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/arch/x86/events/intel/uncore_discovery.c b/arch/x86/events/intel/uncore_discovery.c
index 7dd3910d8de3a..8595e14199ed4 100644
--- a/arch/x86/events/intel/uncore_discovery.c
+++ b/arch/x86/events/intel/uncore_discovery.c
@@ -489,17 +489,28 @@ static u64 intel_generic_uncore_box_ctl(struct intel_uncore_box *box)
 
 void intel_generic_uncore_msr_init_box(struct intel_uncore_box *box)
 {
-	wrmsrq(intel_generic_uncore_box_ctl(box), GENERIC_PMON_BOX_CTL_INT);
+	u64 box_ctl = intel_generic_uncore_box_ctl(box);
+
+	if (!box_ctl)
+		return;
+
+	wrmsrq(box_ctl, GENERIC_PMON_BOX_CTL_INT);
 }
 
 void intel_generic_uncore_msr_disable_box(struct intel_uncore_box *box)
 {
-	wrmsrq(intel_generic_uncore_box_ctl(box), GENERIC_PMON_BOX_CTL_FRZ);
+	u64 box_ctl = intel_generic_uncore_box_ctl(box);
+
+	if (box_ctl)
+		wrmsrq(box_ctl, GENERIC_PMON_BOX_CTL_FRZ);
 }
 
 void intel_generic_uncore_msr_enable_box(struct intel_uncore_box *box)
 {
-	wrmsrq(intel_generic_uncore_box_ctl(box), 0);
+	u64 box_ctl = intel_generic_uncore_box_ctl(box);
+
+	if (box_ctl)
+		wrmsrq(box_ctl, 0);
 }
 
 static void intel_generic_uncore_msr_enable_event(struct intel_uncore_box *box,
@@ -548,6 +559,7 @@ bool intel_generic_uncore_assign_hw_event(struct perf_event *event,
 
 	if (box->pci_dev) {
 		box_ctl = UNCORE_DISCOVERY_PCI_BOX_CTRL(box_ctl);
+
 		hwc->config_base = box_ctl + uncore_pci_event_ctl(box, hwc->idx);
 		hwc->event_base  = box_ctl + uncore_pci_perf_ctr(box, hwc->idx);
 		return true;
@@ -566,27 +578,30 @@ static inline int intel_pci_uncore_box_ctl(struct intel_uncore_box *box)
 
 void intel_generic_uncore_pci_init_box(struct intel_uncore_box *box)
 {
-	struct pci_dev *pdev = box->pci_dev;
 	int box_ctl = intel_pci_uncore_box_ctl(box);
 
+	if (!box_ctl)
+		return;
+
 	__set_bit(UNCORE_BOX_FLAG_CTL_OFFS8, &box->flags);
-	pci_write_config_dword(pdev, box_ctl, GENERIC_PMON_BOX_CTL_INT);
+	pci_write_config_dword(box->pci_dev, box_ctl, GENERIC_PMON_BOX_CTL_INT);
 }
 
 void intel_generic_uncore_pci_disable_box(struct intel_uncore_box *box)
 {
-	struct pci_dev *pdev = box->pci_dev;
 	int box_ctl = intel_pci_uncore_box_ctl(box);
 
-	pci_write_config_dword(pdev, box_ctl, GENERIC_PMON_BOX_CTL_FRZ);
+	if (box_ctl)
+		pci_write_config_dword(box->pci_dev, box_ctl,
+				       GENERIC_PMON_BOX_CTL_FRZ);
 }
 
 void intel_generic_uncore_pci_enable_box(struct intel_uncore_box *box)
 {
-	struct pci_dev *pdev = box->pci_dev;
 	int box_ctl = intel_pci_uncore_box_ctl(box);
 
-	pci_write_config_dword(pdev, box_ctl, 0);
+	if (box_ctl)
+		pci_write_config_dword(box->pci_dev, box_ctl, 0);
 }
 
 static void intel_generic_uncore_pci_enable_event(struct intel_uncore_box *box,
-- 
2.53.0

