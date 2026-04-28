Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937903F23D8;
	Tue, 28 Apr 2026 10:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372904; cv=none; b=Voa62mBjNU3thHWX7yrQJW0j8x1e/PE7VAg3/fiJDDDtJjd7AZDgyyqUANn0VfEKTJUNkJitjSS/XMPu+KAnmNJVEwoLYkri0cEf7cOgbnxLoV8kPNm0s2EX/leQAtCjxPMxijxK+NjOz7v8cDLetriIZh5zXV6FwQ1N1TeoycI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372904; c=relaxed/simple;
	bh=aWNoUQTynV5pZbzLHTHX5c7mk9of2OZcSFZ4VPq8R0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OJoJq+1wB2MBQ7lxiAzCeMBfVcV2qFRR29SeM0quaJPj2BDx9h5TNw1KFE/rsQPpAzCACvNLoKwTEEdIEnr0eYvvwlsnTv6cIPSVlf7rNmDN1RYUT7brTIwK+b7s5IsIutabVyYZjy5NcVe5/Cnm7qCpMEVOUW60yi8VEaV8u+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZnVVBXcB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZnVVBXcB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCABC2BCAF;
	Tue, 28 Apr 2026 10:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372904;
	bh=aWNoUQTynV5pZbzLHTHX5c7mk9of2OZcSFZ4VPq8R0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZnVVBXcBj6sU+OfxZ6S1Vy7uAJdAVbCLVSawzOxhEcjMjPFJFdDogKD7kxw9PyAfq
	 hsOQyI75/EJ1Vufs8v1J7qlJoFgrGQAYBX2ylEpTzy7e3lBBziQCMrEr2gX4UcWVOC
	 xuNJogagian4Wgrm8asa/JGX/0EIdWQc6FojBsR+rF+Oz1xAidsTLJ6BdCbm0PickK
	 PByGHsVCzwzJBVYGsneDBfLmW05UTthmdypnS0V1or/kyVPbU+tmkYx9wg2kor7UIw
	 9B40YH09lC2mXAWkN4RisPg2ZCWmG9by9QKwuZgHYAEudaC7chck6NTNX8UuR/clkV
	 CuBLDBriZtS4w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Marcel W. Wysocki" <maci.stgn@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	richard@nod.at,
	anton.ivanov@cambridgegreys.com,
	johannes@sipsolutions.net,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	linux-um@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] um: avoid struct sigcontext redefinition with musl
Date: Tue, 28 Apr 2026 06:40:18 -0400
Message-ID: <20260428104133.2858589-7-sashal@kernel.org>
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

From: "Marcel W. Wysocki" <maci.stgn@gmail.com>

[ Upstream commit d46dfb369a4627d90efc2c2ffbe29e38e3e74286 ]

mcontext.c includes both <sys/ucontext.h> and <asm/sigcontext.h>.
With musl libc, this causes a struct sigcontext redefinition error:

  <sys/ucontext.h> pulls in musl's <bits/signal.h>, which defines
  struct sigcontext directly.  The kernel's <asm/sigcontext.h> then
  provides a second, conflicting definition of the same struct.

With glibc this does not conflict because glibc's signal headers
source their struct sigcontext from the kernel's own UAPI headers,
so the include guard in <asm/sigcontext.h> makes the second
inclusion a no-op.

mcontext.c does not actually use struct sigcontext by name -- it
only needs the FP-state types (_fpstate, _xstate, etc.) that are
defined in <asm/sigcontext.h> independently of the sigcontext
struct.

Temporarily rename sigcontext to __kernel_sigcontext during the
inclusion of <asm/sigcontext.h> so that the kernel's definition
does not collide with musl's.  The #undef restores normal name
resolution immediately afterward.

No functional change with glibc; fixes the build with musl.

Signed-off-by: Marcel W. Wysocki <maci.stgn@gmail.com>
Link: https://patch.msgid.link/20260215142803.1455757-2-maci.stgn@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to write the complete analysis.

## Analysis

### PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: Subsystem=`um:` (User Mode Linux). Verb=`avoid` (implies fix -
avoiding redefinition error). Summary: Fix a build failure when
compiling UML with musl libc due to `struct sigcontext` being redefined.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Link:
  https://patch.msgid.link/20260215142803.1455757-2-maci.stgn@gmail.com`
  (lore discussion)
- `Signed-off-by: Marcel W. Wysocki <maci.stgn@gmail.com>` (author)
- `Signed-off-by: Johannes Berg <johannes.berg@intel.com>` (UML co-
  maintainer who applied it)
- No `Fixes:` tag (expected — bug from commit `b1e1bd2e69430`, not
  tagged)
- No `Cc: stable@vger.kernel.org` (not nominated by author, but absence
  is expected)
- No `Reported-by:`, `Tested-by:`, or `Reviewed-by:`

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record: Bug description is explicit and detailed — `mcontext.c` includes
both `<sys/ucontext.h>` (pulls in musl's `<bits/signal.h>` which defines
`struct sigcontext`) and `<asm/sigcontext.h>` (defines `struct
sigcontext` again). With musl, these collide causing a compile-time
"redefinition" error. With glibc, the include guard coordination
prevents this. Symptom: build failure, not runtime. Author explains
mechanism precisely.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: This is NOT a hidden bug fix; it's an explicit, stated build
fix. Category = build fix (one of the documented exceptions allowed in
stable).

### PHASE 2: DIFF ANALYSIS - LINE BY LINE

**Step 2.1: INVENTORY THE CHANGES**
Record: Single file: `arch/x86/um/os-Linux/mcontext.c`, +6 lines, 0
removed. No functions modified (only top-of-file includes). Scope
classification: trivial, single-file, preprocessor-only change.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Before: `#include <asm/sigcontext.h>` pulls in kernel's `struct
  sigcontext` definition after musl already defined its own →
  redefinition error.
- After: `#define sigcontext __kernel_sigcontext` before include +
  `#undef sigcontext` after include. The kernel's struct gets renamed to
  `__kernel_sigcontext` inside `<asm/sigcontext.h>`, avoiding the
  collision. After the `#undef`, normal name resolution resumes (musl's
  `struct sigcontext` is what any subsequent code would see — but this
  file doesn't use it).
- No executable code path is affected; this is purely a preprocessor
  name-space change localized to 3 lines of includes.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: Bug category = Hardware/toolchain workaround (build fix).
Mechanism: musl's `<bits/signal.h>` defines `struct sigcontext` directly
(no guard macro shared with kernel UAPI), while x86 kernel UAPI
`<asm/sigcontext.h>` only suppresses its user-space `struct sigcontext`
definition with `#ifndef __KERNEL__` — there is no handshake with musl.
The fix side-steps this by renaming the kernel's copy in this one
translation unit.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct. Narrowly scoped (`#define` paired with
matching `#undef`). Zero regression risk with glibc: the `#undef`
restores the macro namespace before the next include, and the file never
references `struct sigcontext` by name (verified via grep — only
`_fpstate`/`_xstate` types are used, which are defined independently).
No red flags.

### PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record: The `#include <asm/sigcontext.h>` line (which is the root cause
of the musl collision) was introduced by commit `b1e1bd2e69430` ("um:
Add helper functions to get/set state for SECCOMP") — merged into v6.16
(verified via `git tag --contains`). Before v6.16, `mcontext.c` only
included `<sys/ucontext.h>` and had no conflict with musl.

**Step 3.2: FOLLOW THE FIXES: TAG (if present)**
Record: No `Fixes:` tag present. Based on blame, the offending code came
from `b1e1bd2e69430` in v6.16. Verified: that commit is present in
v6.16+ tags. The only stable branches where `<asm/sigcontext.h>` is
included in this file are 6.17.y, 6.18.y, 6.19.y (verified by checking
each `stable-push/linux-*.y` branch).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Recent history of `arch/x86/um/os-Linux/mcontext.c`:
`942349413a496` (SECCOMP 32bit xstate fix), `b1e1bd2e69430` (introduced
the problematic include), and older minor changes. No prerequisite patch
is needed for this fix; it is standalone. This patch is 2/2 in its
series; patch 1/2 is `4076f73298320` ("um: fix address-of CMSG_DATA()
rvalue in stub") — a different file, independent fix, not a
prerequisite.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Author Marcel W. Wysocki has only two commits in the tree (both
from this 2/2 series on musl UML build fixes). New contributor. The
applying committer is Johannes Berg (co-maintainer of UML subsystem),
which is a trust signal for correctness.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Fix is entirely self-contained — a 6-line preprocessor patch. No
dependencies.

### PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record: `b4 dig -c d46dfb369a4627d90efc2c2ffbe29e38e3e74286` found the
submission at `https://lore.kernel.org/all/20260215142803.1455757-2-
maci.stgn@gmail.com/`. Only v1 exists (no revisions). The mbox thread
contains exactly 2 messages (the two patches 1/2 and 2/2) — no reply
from reviewers, no NAKs, no stable nominations, no discussion of stable
suitability. The patch was applied quickly by the UML maintainer.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: `b4 dig -c ... -w` shows recipients: Richard Weinberger (UML
maintainer), Anton Ivanov (UML maintainer), Johannes Berg (UML co-
maintainer), linux-um@lists.infradead.org, linux-kernel@vger.kernel.org.
All appropriate people were CC'd. Johannes Berg applied the patch
himself.

**Step 4.3: SEARCH FOR THE BUG REPORT (if applicable)**
Record: No `Reported-by:` tag or linked bug report. Not applicable — the
commit message describes the bug mechanism without a specific reporter.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: `b4 dig -a` confirms this is part of a 2-patch series (v1).
Patch 1/2 is a separate musl build fix (CMSG_DATA rvalue issue in
`arch/um/kernel/skas/stub.c`). They are independent fixes in different
files — each can be applied without the other.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: Not specifically discussed on stable list, but precedent exists:
other "Fix build with musl" commits have been backported to stable
(e.g., `c723289f4e7f1` for turbostat, `d5408730bca99` for
netfilter_bridge.h) — verified via `git log stable-push/linux-rolling-
stable --grep=musl`.

### PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: No functions are modified. The diff only changes `#include`
directives at file header level.

**Step 5.2–5.4: TRACE CALLERS / CALLEES / CALL CHAIN**
Record: Not applicable — no function-level code is touched. The change
is compilation-unit scope only.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Verified via grep: `mcontext.c` does not reference `struct
sigcontext` by name anywhere — it only uses `_fpstate`, `_xstate`, etc.
(19 matches) which are defined independently of `struct sigcontext` in
`<asm/sigcontext.h>`. The fix's core premise is correct.

### PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1: DOES THE BUGGY CODE EXIST IN STABLE TREES?**
Record: Verified by inspecting `arch/x86/um/os-Linux/mcontext.c` in each
stable branch:
- 5.10.y, 5.15.y, 6.1.y, 6.6.y, 6.12.y → DO NOT include
  `<asm/sigcontext.h>` (bug doesn't exist there — fix not needed)
- 6.17.y, 6.18.y, 6.19.y → DO include `<asm/sigcontext.h>` (bug exists,
  fix is needed)
- Rolling stable / 7.0 → same (bug exists)

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: The file content in 6.17.y, 6.18.y, 6.19.y is identical around
the includes. Patch will apply cleanly. No backport adjustments needed.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY IN STABLE**
Record: No duplicate or earlier fix for this specific issue in stable
trees (verified by inspecting the actual files — they all still have the
naked `#include <asm/sigcontext.h>`).

### PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: Subsystem = arch/um (User Mode Linux for x86). Criticality =
PERIPHERAL — UML is a developer/testing-focused feature, not used in
typical production systems. However, it is widely used for kernel
testing in CI (e.g., Alpine Linux-based Docker containers use musl by
default).

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: UML is actively developed (many recent commits). The particular
code path here (SECCOMP mcontext helpers) is relatively new (added in
v6.16), so the bug window is recent.

### PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Only users who build UML with musl libc. This includes:
developers using Alpine Linux-based CI/containers for kernel testing,
musl-based embedded systems, void-linux users. Affects only x86 UML
builds (arch/x86/um). Not a runtime issue — purely compile-time.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Triggers always (100%) when compiling `arch/x86/um/os-
Linux/mcontext.c` with musl headers in the include path, on v6.16+
kernels. Not triggered with glibc. Not a runtime issue, so no
unprivileged-user security angle.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Failure mode = compile error (build cannot complete). Severity =
MEDIUM for affected users (they cannot build the kernel at all), LOW
overall (only affects a niche combination). But it is a total block on
an entire valid use case.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- BENEFIT: MEDIUM — enables an entire class of users (musl + UML) to
  build affected kernels. Build fixes are explicitly listed as a stable
  exception.
- RISK: VERY LOW — 6 lines, preprocessor-only, zero effect with glibc,
  the file doesn't use the renamed struct anywhere.
- Ratio: Strongly favorable.

### PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**
FOR: (a) explicit build fix — documented exception for stable; (b)
trivial 6-line preprocessor change, no behavior change; (c) applied by
UML maintainer Johannes Berg; (d) fixes a real, reproducible build
failure on v6.16+; (e) applies cleanly to 6.17.y, 6.18.y, 6.19.y; (f)
precedent exists (other musl build fixes backported to stable); (g) the
file doesn't use `struct sigcontext` by name — fix is logically sound
and verified.
AGAINST: (a) no `Cc: stable` tag and no explicit stable nomination in
review; (b) affects a niche user group (musl + UML builders); (c) no
reporter or tester confirmation in the thread.

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct? YES — verified fix logic against the source.
2. Fixes real bug? YES — build failure documented.
3. Important? MEDIUM — build fixes are important for affected users;
   it's a total block.
4. Small and contained? YES — 6 lines, single file, preprocessor only.
5. No new features/APIs? YES — pure build fix.
6. Applies to stable? YES — verified clean apply to
   6.17.y/6.18.y/6.19.y.

**Step 9.3: EXCEPTION CATEGORY**
Record: Falls squarely into "BUILD FIXES" exception category explicitly
listed as allowed in stable.

**Step 9.4: DECISION**
This is a textbook small build fix. Zero functional change with glibc,
unblocks musl builds for affected stable trees (6.17.y+). The code
touched doesn't exist in older stable trees (5.10-6.12), so the fix is
only relevant for newer stable branches — and maintainers/AUTOSEL
pipelines can no-op where the file doesn't have the problematic include.

### Verification

- [Phase 1] Parsed tags from commit message: only Link: +
  author/maintainer SOB. No Reported-by/Tested-by/Fixes/Cc:stable.
  Confirmed.
- [Phase 2] Read `arch/x86/um/os-Linux/mcontext.c` and diff: verified 6
  lines added (comment + `#define` + `#undef`), no other changes.
- [Phase 2] Ran grep on the file for `struct sigcontext` — no matches,
  confirming the commit's claim that the file doesn't reference the
  renamed struct.
- [Phase 2] Ran grep for `_fpstate|_xstate` in the file — 19 matches,
  confirming these are the types actually used.
- [Phase 3] `git log -- arch/x86/um/os-Linux/mcontext.c`: confirmed
  `<asm/sigcontext.h>` include was introduced by `b1e1bd2e69430` ("um:
  Add helper functions to get/set state for SECCOMP").
- [Phase 3] `git show b1e1bd2e69430~1:...mcontext.c`: verified pre-patch
  file did NOT have `<asm/sigcontext.h>`.
- [Phase 3] `git tag --contains b1e1bd2e69430`: confirmed it first
  appears in v6.16.
- [Phase 4] `b4 dig -c d46dfb369a4627d90efc2c2ffbe29e38e3e74286`: found
  submission at lore URL; only v1 exists.
- [Phase 4] `b4 dig -c ... -a`: confirmed v1-only, part of 2-patch
  series; patch 1/2 is in a different file (stub.c).
- [Phase 4] `b4 dig -c ... -w`: confirmed all UML maintainers and
  correct lists were CC'd.
- [Phase 4] Read saved mbox thread: only 2 messages (the two patches
  themselves), no replies, no NAKs, no stable nomination.
- [Phase 4] lore.kernel.org direct fetch: blocked by Anubis anti-
  scraping, but mbox download via b4 succeeded.
- [Phase 4] `git log --grep=musl stable-push/linux-rolling-stable`:
  confirmed other musl build fixes have been backported (e.g.,
  `c723289f4e7f1` turbostat, `d5408730bca99` netfilter_bridge.h).
- [Phase 5] grep verification: `mcontext.c` only uses
  `_fpstate`/`_xstate` types from `<asm/sigcontext.h>`; no `struct
  sigcontext` references.
- [Phase 6] Checked each stable branch's `arch/x86/um/os-
  Linux/mcontext.c`: 5.10/5.15/6.1/6.6/6.12 do NOT have `#include
  <asm/sigcontext.h>`; 6.17/6.18/6.19 DO. Fix only applies to 6.17+.
- [Phase 6] Line counts (`wc -l`) show 6.17.y, 6.19.y, and current tree
  all have 260-line mcontext.c with the same include structure — patch
  will apply cleanly.
- [Phase 7] Author Marcel W. Wysocki has only two commits ever (the 2/2
  series), new contributor, but patch applied by maintainer Johannes
  Berg.
- [Phase 8] Failure mode: compile error only; no runtime impact.
  Triggered deterministically on musl+UML.
- UNVERIFIED: Could not independently confirm how many real users build
  UML with musl (assumed non-zero based on Alpine Linux containers being
  common in CI).

This is a small, obviously correct build fix with zero risk to glibc
users and clear benefit to musl users. It fits the documented "BUILD
FIXES" stable exception, the file is in the same state in stable
6.17.y/6.18.y/6.19.y so it will apply cleanly, and the change is
preprocessor-only with an immediate matching `#undef`.

**YES**

 arch/x86/um/os-Linux/mcontext.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/um/os-Linux/mcontext.c b/arch/x86/um/os-Linux/mcontext.c
index a21403df66637..b1580df80b3fc 100644
--- a/arch/x86/um/os-Linux/mcontext.c
+++ b/arch/x86/um/os-Linux/mcontext.c
@@ -4,7 +4,13 @@
 #include <linux/string.h>
 #include <sys/ucontext.h>
 #include <asm/ptrace.h>
+/*
+ * musl defines struct sigcontext in <bits/signal.h>.  Rename the kernel's
+ * copy to avoid redefinition while keeping the FP-state types available.
+ */
+#define sigcontext __kernel_sigcontext
 #include <asm/sigcontext.h>
+#undef sigcontext
 #include <sysdep/ptrace.h>
 #include <sysdep/mcontext.h>
 #include <arch.h>
-- 
2.53.0

