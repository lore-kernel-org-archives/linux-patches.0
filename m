Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BEB3CE48F;
	Mon, 20 Apr 2026 13:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691071; cv=none; b=ouszW+IXexEYePNVi2i62uU6nNzhJMhSjQMzPpz8P+FfEYBX2BiPTdNkNhsEG1rsvPQ/fMHT6L5p+fwSfOHI1ST8Mda2ni9i74DbFGIIdw0IETU8dv3+uxQoUdP5g9a4T0xGmfJbc+l+xt/xKa95OsztsXQwkLJeXONC4JD+n/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691071; c=relaxed/simple;
	bh=D4gzbApaCmFCoqZH8AOrVXrd+GNGxB6eS1Wa4nuDa5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X2BrTp+vQI5LEn0GwxXncUeAieoYfarw8S9fMhqGPgj9mhxR/+YDukc7SCROb1rs1V2Pz3Na/akPgQzfXk/MvRme2Ba9P6upI2Iwm9NA09x7PnH/Um1VQgbQ19iQBUV22LggapE1Frp62GI8DNM1VbyaK7jwYLaUHf1to4jTpYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DpH8x8/q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DpH8x8/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76EFCC2BCB4;
	Mon, 20 Apr 2026 13:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691070;
	bh=D4gzbApaCmFCoqZH8AOrVXrd+GNGxB6eS1Wa4nuDa5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DpH8x8/qgyZjDOfv3yPtBigz4IsvUJuLL4s1If0D2jG2FTMmLGP6CIdPdd6aRvLWB
	 rnFo3jwOYmuWhhD/WjFUD1w/Hbs9wGOXk2XtFjyDfZoQvQWrYMg/WIoPGZX6YpR9wk
	 WG/9QZcxxXh4MlBZOiz3UIHWh5kd5b7hFBeCp4tAuCCbf/zeOFKTWPuxAclxneCVOM
	 iFt7hvcRDNX/lSDQ2+ZXFLE4hwr5AGZt1AJHAwb3VB0Q83PX8AEQqqdgSZHD1t/Ge1
	 sf0IukJY+AjKD8SLlphOVOna8MuxUeInRdmbAfOjK/lnaEJp4v26Tb+C0bjoMsSP46
	 A+JUnEKEZeLag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ravi Bangoria <ravi.bangoria@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mingo@redhat.com,
	acme@kernel.org,
	tglx@linutronix.de,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] perf/amd/ibs: Limit ldlat->l3missonly dependency to Zen5
Date: Mon, 20 Apr 2026 09:09:02 -0400
Message-ID: <20260420131539.986432-76-sashal@kernel.org>
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

[ Upstream commit 898138efc99096c3ee836fea439ba6da3cfafa4d ]

The ldlat dependency on l3missonly is specific to Zen 5; newer generations
are not affected. This quirk is documented as an erratum in the following
Revision Guide.

  Erratum: 1606 IBS (Instruction Based Sampling) OP Load Latency Filtering
           May Capture Unwanted Samples When L3Miss Filtering is Disabled

  Revision Guide for AMD Family 1Ah Models 00h-0Fh Processors,
  Pub. 58251 Rev. 1.30 July 2025
  https://bugzilla.kernel.org/attachment.cgi?id=309193

Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: https://patch.msgid.link/20260216042216.1440-3-ravi.bangoria@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed. Let me compile the full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: [perf/amd/ibs] [Limit] Constrains the ldlat->l3missonly hardware
workaround to only apply on Zen5 CPUs, per AMD Erratum 1606.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- Signed-off-by: Ravi Bangoria (author, AMD IBS expert at AMD)
- Signed-off-by: Peter Zijlstra (Intel) (perf subsystem maintainer)
- Acked-by: Namhyung Kim (perf co-maintainer)
- Link: patch.msgid.link URL to lore thread
- No Fixes: tag (expected for candidates)
- No Cc: stable (expected for candidates)

Record: Strong reviewer credentials. The patch was authored by the AMD
IBS subsystem expert, merged by the perf maintainer, and acked by the
perf co-maintainer.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
The commit describes AMD Erratum 1606: "IBS OP Load Latency Filtering
May Capture Unwanted Samples When L3Miss Filtering is Disabled." This
erratum is specific to AMD Family 1Ah Models 00h-0Fh (Zen5). The
original ldlat code unconditionally forced `IBS_OP_L3MISSONLY` alongside
`IBS_OP_LDLAT_EN`, but this workaround should only apply to Zen5.

Record: Bug = erratum workaround applied too broadly. Symptom = on non-
Zen5 hardware, ldlat filtering incorrectly forces L3-miss-only sampling.
Root cause = original ldlat feature lacked CPU generation check.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: This IS a bug fix. It corrects incorrect hardware configuration
on non-Zen5 processors. The word "Limit" indicates constraining overly
broad behavior to only the affected hardware.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY**
- 1 file: `arch/x86/events/amd/ibs.c` (+4/-1, net +3 lines)
- Function modified: `perf_ibs_init()`
- Scope: single-file surgical fix

**Step 2.2: CODE FLOW CHANGE**
Before: When ldlat event is configured, ALWAYS sets both
`IBS_OP_L3MISSONLY | IBS_OP_LDLAT_EN`.
After: Always sets `IBS_OP_LDLAT_EN`, but only sets `IBS_OP_L3MISSONLY`
when `cpu_feature_enabled(X86_FEATURE_ZEN5)` is true.

**Step 2.3: BUG MECHANISM**
Category: Hardware workaround refinement. The Zen5 erratum 1606 required
forcing l3missonly alongside ldlat, but this constraint was applied to
all CPUs unconditionally. On post-Zen5 hardware, this forces unwanted
filtering that limits the utility of ldlat profiling.

**Step 2.4: FIX QUALITY**
- Obviously correct: constrains documented erratum workaround to the
  affected CPU generation
- Minimal (3 actual lines of change)
- Zero regression risk on Zen5 (behavior unchanged); corrects behavior
  on all other generations
- No red flags

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME**
The buggy line (`config |= IBS_OP_L3MISSONLY | IBS_OP_LDLAT_EN`) was
introduced by commit d20610c19b4a22 ("perf/amd/ibs: Add support for OP
Load Latency Filtering") by Ravi Bangoria on 2025-02-05. This was the
initial ldlat feature addition, first appearing in v6.15-rc1.

**Step 3.2: FIXES TAG**
No explicit Fixes: tag. The implicit fix target is d20610c19b4a22. That
commit appeared in v6.15-rc1, confirmed by `git tag --contains`.

**Step 3.3: FILE HISTORY**
The file has active development from Ravi Bangoria. This is patch 2/5 in
a series "[PATCH v2 0/5] perf/amd/ibs: Assorted fixes" but it is
completely self-contained — it modifies a single line with no dependency
on the other patches.

**Step 3.4: AUTHOR**
Ravi Bangoria is the primary AMD IBS developer with 10+ commits to this
file. He works at AMD and is the domain expert for this code.

**Step 3.5: DEPENDENCIES**
None. The patch only changes the conditional expression around setting
`IBS_OP_L3MISSONLY`. The check `cpu_feature_enabled(X86_FEATURE_ZEN5)`
already exists in the tree (used in `drivers/cpufreq/amd-pstate.c` and
`drivers/platform/x86/amd/pmc/mp1_stb.c`). `X86_FEATURE_ZEN5` is defined
in `arch/x86/include/asm/cpufeatures.h`.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: PATCH DISCUSSION**
Found the original submission at spinics.net. The patch was v2 of a
series. Namhyung Kim acked the entire series. No NAKs or concerns. Peter
Zijlstra merged it on Feb 27, 2026 as commit
898138efc99096c3ee836fea439ba6da3cfafa4d in tip/perf/core.

**Step 4.2: REVIEWERS**
Peter Zijlstra (perf maintainer) committed it. Namhyung Kim (perf co-
maintainer) acked it. Both appropriate reviewers for this subsystem.

**Step 4.3: BUG REPORT**
The bug is based on AMD's published erratum 1606 in the Revision Guide
for Family 1Ah processors. This is vendor-documented hardware behavior,
not a user-reported crash.

**Step 4.4: RELATED PATCHES**
This is patch 2/5. The other patches fix unrelated issues (interrupt
accounting, PhyAddrVal bit, NMI safety, race condition). None of the
other patches are in the 7.0 tree. This patch is fully standalone.

**Step 4.5: STABLE DISCUSSION**
No specific stable discussion found. The series was labeled "Assorted
fixes" and contains patches with "fix" characteristics.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**
Modified function: `perf_ibs_init()` — the event initialization function
for IBS PMU events.

**Step 5.2: CALLERS**
`perf_ibs_init()` is registered as the `.event_init` callback for both
`perf_ibs_fetch` and `perf_ibs_op` PMU structures. It's called during
perf event creation via the perf_event_open() syscall path.

**Step 5.3-5.4: CALL CHAIN**
The ldlat path is gated by `perf_ibs_ldlat_event()`, which checks
`perf_ibs == &perf_ibs_op && (ibs_caps & IBS_CAPS_OPLDLAT)`. This means
the code only runs on CPUs that advertise the ldlat capability. The path
is reachable from userspace via perf_event_open().

**Step 5.5: SIMILAR PATTERNS**
`cpu_feature_enabled(X86_FEATURE_ZEN5)` is used in 2 other places in the
kernel for Zen5-specific behavior, confirming this is an established
pattern.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: CODE EXISTS IN STABLE?**
The ldlat feature (d20610c19b4a22) was introduced in v6.15-rc1. Only
stable trees >= 6.15 contain this code. The 7.0 tree does contain the
buggy code at line 359. Older stable trees (6.12.y, 6.6.y, 6.1.y, etc.)
do NOT have this code.

**Step 6.2: BACKPORT COMPLICATIONS**
The diff context matches the 7.0 tree exactly (verified by reading line
359). Clean application expected.

**Step 6.3: RELATED FIXES IN STABLE**
No related fixes found for this issue in any stable tree.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM**
Subsystem: perf/x86/amd (performance monitoring for AMD CPUs).
Criticality: PERIPHERAL — affects AMD users who use IBS profiling.
However, IBS is the primary hardware profiling mechanism on AMD, so it's
important for AMD users who do performance analysis.

**Step 7.2: ACTIVITY**
Actively developed, with many recent commits from the author.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: AFFECTED USERS**
AMD CPU users on post-Zen5 hardware who use IBS ldlat profiling (`perf
record -e ibs_op/ldlat=N/`). This is a specialized but real use case.

**Step 8.2: TRIGGER CONDITIONS**
Any use of ldlat filtering on non-Zen5 AMD hardware that supports the
ldlat capability (IBS_CAPS_OPLDLAT). Easily triggered when the feature
is used.

**Step 8.3: FAILURE MODE SEVERITY**
Wrong profiling results — forces L3-miss-only sampling when user didn't
request it, causing ldlat to only capture L3 cache misses instead of all
loads meeting the latency threshold. Not a crash, security issue, or
data corruption. Severity: LOW-MEDIUM.

**Step 8.4: RISK-BENEFIT RATIO**
- Benefit: MEDIUM — corrects hardware configuration for ldlat profiling
  on post-Zen5 hardware
- Risk: VERY LOW — 3-line change, zero behavior change on Zen5,
  obviously correct
- Ratio: Favorable

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR backporting:**
- Fixes a real bug: incorrect hardware configuration on non-Zen5
  processors
- Small and surgical: 3 lines, single file
- Obviously correct: constrains documented erratum workaround to
  affected hardware
- Strong review: authored by subsystem expert, merged by perf
  maintainer, acked by co-maintainer
- Standalone: no dependencies on other patches
- Hardware erratum workaround (exception category)
- Clean application to 7.0 tree

**Evidence AGAINST backporting:**
- Failure mode is not severe (wrong perf results, not
  crash/corruption/security)
- Post-Zen5 hardware with ldlat capability may not be widely available
  yet
- Specialized debugging tool (perf IBS profiling)
- Only relevant for stable trees >= 6.15

**Stable Rules Checklist:**
1. Obviously correct? YES — constrains erratum to documented affected
   hardware
2. Fixes a real bug? YES — wrong hardware configuration on non-Zen5
3. Important issue? MEDIUM — wrong profiling results for hardware users
4. Small and contained? YES — 3 lines, 1 file
5. No new features or APIs? YES — only constrains existing behavior
6. Can apply to stable? YES — clean application to 7.0

**Exception category:** Hardware quirk/workaround refinement

## Verification

- [Phase 1] Parsed tags: Signed-off-by from AMD author, perf maintainer;
  Acked-by from perf co-maintainer
- [Phase 2] Diff analysis: 3 lines changed in perf_ibs_init(), adds
  cpu_feature_enabled(X86_FEATURE_ZEN5) guard around IBS_OP_L3MISSONLY
- [Phase 3] git blame: buggy code introduced in d20610c19b4a22
  (v6.15-rc1), Ravi Bangoria
- [Phase 3] git tag --contains d20610c19b4a22: confirmed first in
  v6.15-rc1, present in 7.0
- [Phase 3] Author has 10+ commits to this file, is the AMD IBS domain
  expert
- [Phase 4] spinics.net: found original submission [PATCH v2 2/5],
  Namhyung Kim acked entire series
- [Phase 4] tip-bot2: merged as 898138efc99096c3ee836fea439ba6da3cfafa4d
  on Feb 27 2026
- [Phase 5] perf_ibs_init() is .event_init callback, reachable from
  perf_event_open() syscall
- [Phase 5] X86_FEATURE_ZEN5 defined in cpufeatures.h,
  cpu_feature_enabled() used elsewhere for Zen5
- [Phase 6] Verified line 359 in 7.0 tree matches pre-fix code; patch
  applies cleanly
- [Phase 6] ldlat code does NOT exist in stable trees < 6.15
- [Phase 8] Failure mode: wrong perf sampling results (not
  crash/security), severity LOW-MEDIUM
- UNVERIFIED: Could not access lore.kernel.org or bugzilla.kernel.org
  due to anti-bot measures; relied on spinics.net mirrors

## Decision

This is a small, obviously correct hardware erratum workaround fix from
the subsystem expert. It constrains the Zen5-specific Erratum 1606
workaround to only apply on Zen5 hardware, preventing incorrect IBS
configuration on newer AMD generations. While the failure mode (wrong
profiling results) is not severe, the fix carries essentially zero
regression risk and falls into the "hardware quirk/workaround" exception
category. It is standalone, applies cleanly, and was reviewed by the
appropriate maintainers.

**YES**

 arch/x86/events/amd/ibs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index aca89f23d2e00..e35132c5448dd 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -356,7 +356,10 @@ static int perf_ibs_init(struct perf_event *event)
 		ldlat >>= 7;
 
 		config |= (ldlat - 1) << 59;
-		config |= IBS_OP_L3MISSONLY | IBS_OP_LDLAT_EN;
+
+		config |= IBS_OP_LDLAT_EN;
+		if (cpu_feature_enabled(X86_FEATURE_ZEN5))
+			config |= IBS_OP_L3MISSONLY;
 	}
 
 	/*
-- 
2.53.0

