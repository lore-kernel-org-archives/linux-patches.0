Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C90D3F0A84;
	Tue, 28 Apr 2026 10:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372897; cv=none; b=onZPBEdhS6sWvWIJ8uiptbGQ84qNhEq0c3v+EGjr0gBKaGRkxglYQtyS+aa128syMHxvAsk9XcR1XmQ0RnY4SKQ5KPGkEx4drEA3YQJqvfvJMe2ipNxa/vM+2UfrUG5Cl+Qw/ZGFX7kC9fa5DMI5xT/yplw/f8XKKNo2HO/VYIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372897; c=relaxed/simple;
	bh=maBGhwV59MpCNfpFOozJJQbqErBR3v4jZTQJgF9+4kA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sHscG3kzcIDhReDjqG7rfzbQ1H8qPKZy701qhIxa+xn236WX27v+yt5agLYUjkANzV63UHjoS9PpbXkQ+mdURIcUrMVFmu91P4oviWMKbR1Rqbep2gPInQb6N1wdqeZJ18Wg2IS++xTs9/d/CJSPebOx2ldAHQGVvFoDGSvantg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eqtcdhtG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eqtcdhtG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93391C2BCB7;
	Tue, 28 Apr 2026 10:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372897;
	bh=maBGhwV59MpCNfpFOozJJQbqErBR3v4jZTQJgF9+4kA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqtcdhtGHwlS8UKV6ilgBfpLJNaTTGaKL6tG6Eh9CpgFQ4PPGPC+f9JlKFwYlcixd
	 OVAYoJoybMcA9xTZtB9AfqM43m3XcriRYoPWTltKmR8emjB71x4E7rlv60qq61zQra
	 fECX2JofVqU9ur+CYBwHIHVlkG8hudWA9/cnYfkCP5ZOYM1pmhxcqYz2UKIWAh1aaU
	 std5ChyL3UXbha4xjpYvHuvLfYoNk6bvffvJFrKU03Ld/OgMwalwVFjRpMLLV9yiuu
	 AfWqAcj4jw4Rdk7oUmCtv8WfFsYLXrKiG3CQ7xAmfLsBoExceVSqhhSklVcR7Vufrp
	 +T6olB6SvLPwA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] tools/power/x86/intel-speed-select: Avoid current base freq as maximum
Date: Tue, 28 Apr 2026 06:40:13 -0400
Message-ID: <20260428104133.2858589-2-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit ae67f582398611b9f67c06961e292e3a2612346d ]

SST-PP level change results in online/offline of CPUs with -o option.
The Linux intel-pstate driver internally stores the current HWP_REQ MSR
value during offline and restores them during online.

It is possible that during SST-PP level change, the new HWP_CAP limits
can be updated. So, when a CPU is online, the HWP_REQ MSR should be
updated to new values based on HWP_CAP values.

This is particularly problematic when either turbo is disabled or the
current HWP_REQ value (stored before online) is less than the base
frequency from the updated HWP_CAP MSR guaranteed value. If the HWP_REQ
MSR is not updated, then the performance will be limited to the value
before perf level change.

Hence the tool updates cpufreq scaling_max_freq to the newer
base_frequency value in this case. This step is not required when HWP
interrupts are enabled, as the perf level change should result in a new
interrupt with HWP_GUARANTEED_PERF_CHANGE_STATUS and the intel_pstate
driver will update to new limits.

But the tool needs to handle the case when HWP interrupts are not
enabled but there is no way for the tool to know that HWP interrupts are
enabled or not. So, it has to still update the scaling_max_freq.

With the QOS changes in the kernel, user space writes to scaling_max_freq
are treated as hard limits. So, when base frequency is increased with
SST-BF enabled, the cpufreq subsystem will still not allow setting to the
SST-BF high priority core frequency. So, the HWP_REQ MSR will still be
capped to the user-set scaling_max_freq after SST-PP level change.

To address this, instead of setting scaling_max_freq to the current HWP_CAP
highest frequency, set it to the maximum integer value to set the QOS limit
as unconstrained. In this case, the actual HWP_REQ maximum frequency will
still be capped to HWP_CAP highest performance by the intel-pstate driver.
So, it will not result in invalid HWP_REQ values.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to provide a comprehensive analysis.

## Analysis: tools/power/x86/intel-speed-select: Avoid current base freq
as maximum

### PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Parse the subject line**
Record: Subsystem: `tools/power/x86/intel-speed-select` (userspace
tool). Action verb: "Avoid" (indicates behavior fix). Summary: Don't use
current base frequency as maximum when writing to cpufreq
scaling_max_freq.

**Step 1.2: Parse all commit message tags**
Record:
- No `Fixes:` tag
- No `Reported-by:` tag
- No `Tested-by:` tag
- No `Reviewed-by:` tag
- No `Acked-by:` tag
- No `Link:` tag
- No `Cc: stable@vger.kernel.org`
- Only author `Signed-off-by: Srinivas Pandruvada
  <srinivas.pandruvada@linux.intel.com>` (the tool maintainer)

Notable: no user-facing bug report, no reviewer feedback, no explicit
stable nomination. This is a solo fix by the maintainer.

**Step 1.3: Analyze the commit body text**
Record: Bug: When SST-PP level change triggers CPU online/offline
cycling (via `-o` option), intel_pstate saves HWP_REQ MSR on offline and
restores on online. But the new HWP_CAP limits may be different than
before; if turbo is disabled or stored HWP_REQ value is less than new
base_frequency, performance is limited. The tool's fix was to update
`scaling_max_freq` to the new `base_frequency`. However, kernel QoS
changes treat userspace writes to `scaling_max_freq` as HARD LIMITS.
When SST-BF is enabled and base_freq increases, SST-BF high priority
cores can no longer reach their high frequency because the
scaling_max_freq QoS limit is too low. The fix writes S32_MAX
(effectively unconstrained) so intel_pstate's actual HWP_CAP highest
performance acts as the cap.

**Step 1.4: Detect hidden bug fixes**
Record: Title uses "Avoid" which is the pattern indicator for a bug fix.
This IS fixing a real functional bug where SST-BF performance is limited
after SST-PP level transitions.

### PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory the changes**
Record: 1 file modified: `tools/power/x86/intel-speed-select/isst-
config.c`. ~4 lines added (2 `#define`s + blank line), 1 line changed.
Total scope: ~5 lines. Single-file, surgical fix.

**Step 2.2: Understand the code flow change**
Record: In `adjust_scaling_max_from_base_freq()`: when `scaling_max_freq
< base_freq || no_turbo()`, BEFORE the fix it wrote `base_freq` to
cpufreq sysfs; AFTER the fix it writes `S32_MAX`. Kernel QoS interprets
this as "no userspace limit", allowing intel_pstate to cap at HWP_CAP
instead.

**Step 2.3: Identify the bug mechanism**
Record: Category: Logic/correctness fix (g). Mechanism: The tool was
capping CPU frequency at base_freq, but this was interacting with kernel
QoS semantics to prevent SST-BF high priority cores from reaching their
higher frequency. Fix: Use INT_MAX to indicate "unconstrained" QoS
request.

**Step 2.4: Assess the fix quality**
Record: Fix is obviously correct on reading — writing INT_MAX sets QoS
to default (unconstrained). Cannot cause regression because the kernel's
intel_pstate driver will still cap to HWP_CAP.highest_performance. One
minor note: the file defines U32_MAX/S32_MAX locally rather than using
`<limits.h>` (INT_MAX), but this is a stylistic choice not a correctness
concern.

### PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame the changed lines**
Record: `adjust_scaling_max_from_base_freq` was introduced by
`f981dc171c04c` ("tools/power/x86/intel-speed-select: Set
scaling_max_freq to base_frequency", 2020-12-20) and later touched by
`bbaa2e95e23e7` ("Set higher of cpuinfo_max_freq or base_frequency",
2020-12-20). The function has existed since v5.11.

**Step 3.2: Follow the Fixes: tag**
Record: No Fixes: tag. However, the "original commit that made this
broken" can be inferred: the conflict arose when kernel QoS changes
(da5c504c7aae9 "cpufreq: intel_pstate: Implement QoS supported freq
constraints" v5.4, and 3000ce3c52f8b "cpufreq: Use per-policy frequency
QoS" v5.5) made scaling_max_freq writes become hard QoS limits. This
means the tool's original behavior has been subtly broken since the QoS
infrastructure landed. Alternatively, the tool's own commit
f981dc171c04c added the problematic logic assuming old behavior.

**Step 3.3: Check file history for related changes**
Record: Related history shows `adjust_scaling_max_from_base_freq` was
last substantively modified in 2020. No intermediate fixes. This is not
part of a patch series — verified via lore mailing list pull request
showing it as one of two Srinivas patches (the other being v1.26 version
bump).

**Step 3.4: Check the author's other commits**
Record: Srinivas Pandruvada is the primary maintainer of intel-speed-
select and intel_pstate. He has authored dozens of commits to this file.
Highly authoritative source for the fix.

**Step 3.5: Check for dependent/prerequisite commits**
Record: The fix is standalone. It doesn't reference new APIs or
structures. The kernel-side QoS behavior it depends on (treating
scaling_max_freq as hard limit) has been in place since v5.5, well
before any active stable tree's branch point.

### PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: Find the original patch discussion**
Record: `b4 dig -c ae67f58239861` returned "Nothing matching that query"
— patch was apparently committed to the maintainer's tree without
posting as a separate patch submission on lore. Manual lore.kernel.org
search for "Avoid current base freq as maximum" found only the Pull
Request messages (not a submission thread). This confirms this commit
was NOT posted to a public mailing list for review — it went directly
through the maintainer's github branch into the pdx86 pull request.

**Step 4.2: Check who reviewed the patch**
Record: No public review. Found the pull request from Srinivas to Ilpo
Järvinen (pdx86 maintainer) on lore.kernel.org: `https://lore.kernel.org
/all/0b288f7a7024f896a1699ac3609c7da39c588d03.camel@intel.com/`, which
went into `review-ilpo-next` then to 7.1-rc1. Pull request lists it as
one of two Srinivas patches for v1.26 release. No review comments, no
stable nomination in the pull request.

**Step 4.3: Search for the bug report**
Record: No Reported-by tag. No syzbot, bugzilla, or user bug report
linked. No evidence this was discovered through a user report or
automated tooling.

**Step 4.4: Check for related patches and series**
Record: This is a standalone patch, not part of a series. Pull request
shows only 2 patches from Srinivas (this + version bump).

**Step 4.5: Check stable mailing list history**
Record: No discussion found on lore.kernel.org/stable for this fix.
However, historical precedent: `f981dc171c04c` (the commit that
introduced this same function) WAS backported to stable 5.10.14. This
establishes that fixes to this tool function have been considered
stable-worthy before.

### PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Identify key functions in the diff**
Record: `adjust_scaling_max_from_base_freq(int cpu)` — the modified
function.

**Step 5.2: Trace callers**
Record: Called from 3 sites:
- Line 1581: In SST-PP `set_tdp_level` path when bringing CPUs online
  after level change (`use_offline:` label)
- Line 1864: In `set_scaling_max_to_cpuinfo_max`
- Line 1884: In `set_scaling_min_to_cpuinfo_min`
All are in the main SST-PP/SST-BF configuration code paths invoked when
user runs `intel-speed-select` commands.

**Step 5.3: Trace callees**
Record: Calls `parse_int_file()`, `get_cpufreq_base_freq()`,
`no_turbo()`, `set_cpufreq_scaling_min_max()` — standard sysfs
operations.

**Step 5.4: Follow the call chain**
Record: Reachable from: user running `intel-speed-select perf-profile
set-config-level -o` (SST-PP level change with CPU online/offline).
Triggered specifically when SST-BF is enabled and new level has
different HWP_CAP.

**Step 5.5: Search for similar patterns**
Record: The function `adjust_scaling_min_from_base_freq` follows a
similar pattern but for minimum freq and was NOT modified (the min-freq
case doesn't have the same hard-limit issue because minimum is supposed
to be set).

### PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1: Does the buggy code exist in stable trees?**
Record: VERIFIED — the identical function exists in stable trees: 5.10,
5.15, 6.1, 6.6, 6.12, 6.18. The code has been unchanged since 2020.

**Step 6.2: Check for backport complications**
Record: Applies cleanly. The function signature and surrounding code are
identical in all stable trees. Verified by showing the function in for-
greg/5.10-200, 5.15-200, 6.6-200, 6.12-200 — all have exactly the same
body as mainline before this fix.

**Step 6.3: Check if related fixes are already in stable**
Record: The original function-introducing commit `f981dc171c04c` is in
stable (backported to 5.10.14). No different fix for this same bug has
been applied. The kernel-side QoS behavior is present in all stable
trees.

### PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: Identify the subsystem and its criticality**
Record: `tools/power/x86/intel-speed-select/` — Intel Speed Select
Technology userspace utility. Criticality: PERIPHERAL. This is a
userspace tool, not kernel code. Affects only users of specific Intel
server CPUs (Xeon Scalable) using SST-PP/SST-BF features. Not a core
subsystem.

**Step 7.2: Assess subsystem activity**
Record: Active subsystem. The tool is regularly updated (v1.26 release
just announced). Srinivas is an active maintainer.

### PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Determine who is affected**
Record: Narrow user population: users of Intel Xeon Scalable CPUs with
SST-BF enabled who run `intel-speed-select` to change SST-PP levels with
`-o` (online/offline) option. Enterprise server administrators. Not
universal, not common consumer kernels.

**Step 8.2: Determine the trigger conditions**
Record: Specific conditions must all be met: (1) supported Intel CPU,
(2) user invokes SST-PP level change with `-o` option, (3) SST-BF
enabled, (4) HWP interrupts are NOT enabled, (5) new level has different
HWP_CAP values. User-initiated configuration tool, not triggered
spontaneously.

**Step 8.3: Determine the failure mode severity**
Record: Failure mode = CPU performance limited to base frequency (SST-BF
high priority cores cannot reach their intended higher frequency after
SST-PP level change). Severity: LOW-MEDIUM. No crash, no data
corruption, no security issue. It's a "feature doesn't work correctly"
bug.

**Step 8.4: Risk-benefit ratio**
Record:
- BENEFIT: LOW-MEDIUM. Fixes functional issue for SST-BF users. Affects
  only specific user scenarios.
- RISK: VERY LOW. 5-line change to a userspace tool. No kernel changes.
  Writing INT_MAX to scaling_max_freq is the documented way to indicate
  "no limit" in the QoS system. Cannot cause crashes.
- Ratio: Favorable. Low risk + some benefit = reasonable candidate.

### PHASE 9: FINAL SYNTHESIS

**Step 9.1: Compile the evidence**

Evidence FOR backporting:
- Fixes a real user-visible functional bug (SST-BF performance
  limitation)
- Very small, contained fix (5 lines, 1 file, userspace tool)
- From the authoritative tool maintainer (Srinivas)
- Applies cleanly to all active stable trees
- Function exists unmodified in all stable trees (5.10, 5.15, 6.1, 6.6,
  6.12, 6.18)
- Low regression risk (cannot cause crash since it's a userspace tool
  change)
- Precedent: the commit that introduced this function was backported to
  5.10.14
- intel-speed-select historically has many fixes backported to stable

Evidence AGAINST backporting:
- No `Fixes:` tag
- No `Cc: stable@vger.kernel.org`
- No `Reported-by:` (no user bug report evidence)
- No public review — went directly through maintainer tree
- Userspace tool, not kernel code
- Narrow use case (specific hardware + specific tool invocation)
- Failure mode is performance limitation, not crash/security/corruption
- The kernel QoS behavior it adapts to has been present for years, so
  this isn't a recent regression

Unresolved questions:
- UNVERIFIED: Whether any actual users have hit this (no user reports
  cited)
- UNVERIFIED: Whether the commit author considered stable backporting
  (no evidence either way)

**Step 9.2: Apply the stable rules checklist**
1. Obviously correct and tested? Correct by inspection. Testing unknown
   but from the maintainer.
2. Fixes a real bug? Yes — SST-BF performance not reaching target
   frequency after SST-PP level change.
3. Important issue? Borderline — not crash/security/corruption.
   Performance limitation in specific scenarios.
4. Small and contained? Yes — ~5 lines, single file.
5. No new features or APIs? Correct — fixes existing functionality.
6. Can apply to stable trees? Yes — verified clean apply across
   5.10-6.18.

**Step 9.3: Exception categories**
Not a device ID addition, quirk, DT update, build fix, or documentation
fix. It's a plain bug fix.

**Step 9.4: Decision**

This is a borderline case. The fix is small, safe, from the maintainer,
applies cleanly, and addresses a real functional issue. On the other
hand, it's a userspace tool with no explicit stable nomination, no
Fixes: tag, no Reported-by, and the failure mode is performance (not
crash/corruption/security). The narrow use case and lack of stable
markers argue against.

Weighing the factors: the fix is very low risk and fixes a real
functional issue for SST-BF users. Historically, intel-speed-select
fixes get backported. The code path exists in all stable trees and the
fix applies cleanly. The author is the maintainer.

### Verification:
- [Phase 1] Parsed tags: NO Fixes, NO Cc stable, NO Reported-by, NO
  Link, NO Reviewed-by — only author SoB (verified via `git show`)
- [Phase 2] Diff analysis: 4 lines added (U32_MAX/S32_MAX defines), 1
  line changed (base_freq → S32_MAX) in
  `adjust_scaling_max_from_base_freq()` (verified via `git show
  ae67f58239861`)
- [Phase 3] git log on file history: `adjust_scaling_max_from_base_freq`
  introduced by `f981dc171c04c` in Dec 2020 (verified via `git log
  --oneline --follow`)
- [Phase 3] kernel QoS commits traced: `da5c504c7aae9` (Aug 2019),
  `3000ce3c52f8b` (Oct 2019), `521223d8b3ec0` (Dec 2021) — QoS
  infrastructure in kernel for years (verified via `git log --format`)
- [Phase 3] Author is Srinivas Pandruvada, primary maintainer of intel-
  speed-select and intel_pstate (verified via `git log --author`
  history)
- [Phase 4] `b4 dig -c ae67f58239861`: returned "Nothing matching" — no
  public patch submission on lore
- [Phase 4] lore search found pull request from Srinivas to pdx86
  maintainer
  (`0b288f7a7024f896a1699ac3609c7da39c588d03.camel@intel.com`) dated
  2026-04-05 — grouped with v1.26 version bump, no explicit stable
  nomination
- [Phase 4] lore search confirmed `f981dc171c04c` was backported to
  stable 5.10.14 (found in Linux 5.10.14 announcement)
- [Phase 5] find_callers: 3 call sites in isst-config.c (lines 1581,
  1864, 1884), all in SST configuration paths invoked by user commands
  (verified via grep)
- [Phase 6] Function body verified unchanged in stable trees 5.10, 5.15,
  6.1, 6.6, 6.12, 6.18 (verified via `git show for-greg/X:tools/...`)
- [Phase 6] No Fixes: tag, so no "introduced by" commit to verify is in
  stable
- [Phase 7] Subsystem: intel-speed-select userspace tool, PERIPHERAL
  criticality
- [Phase 8] Failure mode: performance limitation (CPU capped at
  base_freq), not crash/corruption
- UNVERIFIED: Whether real users have reported hitting this bug (no
  Reported-by in commit)
- UNVERIFIED: Whether Srinivas consciously chose not to Cc stable

### Summary

This is a legitimate small bug fix for a userspace tool that addresses a
real functional issue: when using SST-PP level changes with SST-BF
enabled, the `intel-speed-select` tool was writing `base_freq` to
`scaling_max_freq`, which (due to kernel QoS semantics treating this as
a hard limit) prevented SST-BF high-priority cores from reaching their
target frequency. The fix changes to `INT_MAX` so the kernel's
intel_pstate driver (which caps at HWP_CAP.highest_performance) is the
effective limiter.

The fix is minimal (~5 lines), from the tool maintainer, and applies
cleanly to all active stable trees where the function exists unchanged
since 2020. The kernel QoS behavior it adapts to is present in all
stable trees. Precedent exists: the commit that introduced this function
(`f981dc171c04c`) was backported to 5.10.14.

Arguments against include: no Fixes: tag, no stable Cc, no Reported-by,
userspace tool (not kernel), narrow use case (SST-BF + SST-PP change +
no HWP interrupts), and the failure mode is performance rather than
crash/corruption/security. The patch also went directly through the
maintainer's tree without a public mailing list review.

On balance, the fix is surgical, correct, safe, addresses a real
functional bug, and stable trees have historically accepted intel-speed-
select fixes with similar characteristics. The very low risk combined
with concrete (if narrow) benefit favors backporting.

**YES**

 tools/power/x86/intel-speed-select/isst-config.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/power/x86/intel-speed-select/isst-config.c b/tools/power/x86/intel-speed-select/isst-config.c
index dd9056ddb016e..652ef1f567ad8 100644
--- a/tools/power/x86/intel-speed-select/isst-config.c
+++ b/tools/power/x86/intel-speed-select/isst-config.c
@@ -1744,6 +1744,9 @@ static int no_turbo(void)
 	return parse_int_file(0, "/sys/devices/system/cpu/intel_pstate/no_turbo");
 }
 
+#define U32_MAX		((unsigned int)~0U)
+#define S32_MAX		((int)(U32_MAX >> 1))
+
 static void adjust_scaling_max_from_base_freq(int cpu)
 {
 	int base_freq, scaling_max_freq;
@@ -1751,7 +1754,7 @@ static void adjust_scaling_max_from_base_freq(int cpu)
 	scaling_max_freq = parse_int_file(0, "/sys/devices/system/cpu/cpu%d/cpufreq/scaling_max_freq", cpu);
 	base_freq = get_cpufreq_base_freq(cpu);
 	if (scaling_max_freq < base_freq || no_turbo())
-		set_cpufreq_scaling_min_max(cpu, 1, base_freq);
+		set_cpufreq_scaling_min_max(cpu, 1, S32_MAX);
 }
 
 static void adjust_scaling_min_from_base_freq(int cpu)
-- 
2.53.0

