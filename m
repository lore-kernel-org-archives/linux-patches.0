Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F4F481FBF;
	Mon, 20 Apr 2026 13:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691909; cv=none; b=sOGvYbwL9hgvH+d//yVuit+adb0SQyimVbWp2JcX2KhR/Y5ef0u7XS1Znkr2zitTwbXDhhk3XztEjkcSFdMQlTcInsa2T0tMKWVD+o+/00aVlG1rF2GqyUdptt/qEccNfURwiKmjRWcdZzjK+wET1QcPDSrZRcrQxCaIhrxm4/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691909; c=relaxed/simple;
	bh=yLRLtStpZ4MQvqtf6ks5FF0zfFDEqxFDhbyfwOaLfIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ep0/26PSD7hr+EGtv5owCo2UVPDE/LS75mgo5n5tA4T2HuLgdw9JnWgzUCa/Srqvic7pq+h0KUGYBCO/zkPQsBzjAxlsxbZaJmtNDCMpFtRABbgE/UCVtwRmeuqyeiOCp1kSSTFFoTbi4hsCFNdGkPJJkzdC5A/UstBVWRIFTu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mW+87j7q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mW+87j7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCB1C19425;
	Mon, 20 Apr 2026 13:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691908;
	bh=yLRLtStpZ4MQvqtf6ks5FF0zfFDEqxFDhbyfwOaLfIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mW+87j7qpNMn56R7TE046n1CLk18e0juNi5AMk0L2V8C9FcpkTHQSXZqKCRcV3/K4
	 rjAJzLLtY+lynunTaYe8/DzFBuuF9z+i6WLf1VZxN0Q8g/oG+MWXm37OBqUIVta0Ex
	 RFN0UAtD9zws305lEbAOSJRVB8R8v1MWRHPmGPZ7IVJtW+Uxsu03fAVuvzVcFRSPCP
	 KXg3T8brCFVhpMEQFhIQKy0Vgjwxhy4PO5IIIL/zc+wj7FU4smSi8HMoDqxu2FaIxb
	 adxHPSrWbeuESlkXEFmSa29GCwkGLBMSJF9QXnADlit+reEyL+fOpmQsbEeht9YQwB
	 ctsMYPEDCaEww==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] objtool: Support Clang RAX DRAP sequence
Date: Mon, 20 Apr 2026 09:20:57 -0400
Message-ID: <20260420132314.1023554-263-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 96f3b16a9de552538b810f773645d43f3b661b50 ]

Recent Clang can use RAX as a temporary register for the DRAP stack
alignment sequence.  Add support for that.

Fixes the following warning:

  vmlinux.o: error: objtool: vmw_host_printf+0xd: unknown CFA base reg 0

Closes: https://lore.kernel.org/cefefdd1-7b82-406d-8ff4-e4b167e45ee6@app.fastmail.com
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/3f33dc720b83dc6d3a2b7094f75a5c90a0b1cbc5.1773708458.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the necessary data. Let me compile the full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
Record: [objtool (x86)] [Support] [Adding support for Clang using RAX as
a DRAP register in stack alignment sequence]

The verb "Support" indicates adding new handling rather than directly
fixing an existing bug. However, the commit body makes clear this fixes
a build error.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
- **Closes:** `https://lore.kernel.org/cefefdd1-7b82-406d-8ff4-
  e4b167e45ee6@app.fastmail.com` - bug report link
- **Reported-by:** Arnd Bergmann `<arnd@arndb.de>` - prominent kernel
  developer, subsystem maintainer
- **Signed-off-by:** Josh Poimboeuf `<jpoimboe@kernel.org>` - objtool
  maintainer/author
- **Signed-off-by:** Peter Zijlstra (Intel) `<peterz@infradead.org>` -
  x86 co-maintainer (committer)
- **Link:** patch.msgid.link URL for the submission

Record: Reported by a prominent developer (Arnd Bergmann), authored by
the objtool maintainer (Josh Poimboeuf), committed by x86 co-maintainer
(Peter Zijlstra). Strong review lineage.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
The commit explains:
- Recent Clang can use RAX as a temporary register for the DRAP stack
  alignment sequence
- This causes objtool to fail with: `vmlinux.o: error: objtool:
  vmw_host_printf+0xd: unknown CFA base reg 0`
- The `vmw_host_printf` function in VMware graphics driver triggers this

Record: Bug is a build failure (objtool error) when compiling with
recent Clang versions. The symptom is a fatal objtool error that
prevents kernel builds from completing. The root cause is that Clang
uses RAX as the DRAP register, which objtool didn't know about.

### Step 1.4: DETECT HIDDEN BUG FIXES
Record: This IS a build fix, though phrased as "Support" rather than
"Fix". Without this change, kernels cannot be built with recent Clang
versions when objtool is enabled (standard for x86). This is a BUILD
FIX.

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
- `arch/x86/include/asm/orc_types.h`: +1 line (`#define ORC_REG_AX 10`)
- `tools/arch/x86/include/asm/orc_types.h`: +1 line (same)
- `arch/x86/kernel/unwind_orc.c`: +8 lines (new case in switch for
  runtime unwinding)
- `tools/objtool/arch/x86/decode.c`: +3 lines (new case in
  `arch_decode_hint_reg()`)
- `tools/objtool/arch/x86/orc.c`: +5 lines (two new cases in
  `init_orc_entry()` and `reg_name()`)

Total: +18 lines across 5 files. All changes are adding new `case`
statements to existing switch blocks.

Record: 5 files changed, +18 lines. All additions are parallel `case`
blocks in switch statements, following the exact pattern of existing
registers (DI, DX, R10, R13, etc.). Scope: small, surgical, contained.

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Each change adds handling for `ORC_REG_AX`/`CFI_AX` alongside existing
register handling:
1. **orc_types.h**: Defines the constant `ORC_REG_AX = 10` (fits within
   `ORC_REG_MAX = 15`)
2. **decode.c**: Maps `ORC_REG_AX` -> `CFI_AX` in hint decoding
3. **orc.c (init_orc_entry)**: Maps `CFI_AX` -> `ORC_REG_AX` when
   generating ORC data
4. **orc.c (reg_name)**: Returns "ax" for display purposes
5. **unwind_orc.c**: Uses `pt_regs->ax` when unwinding with AX as base
   register

Record: Before: RAX as DRAP register causes "unknown CFA base reg" fatal
error. After: RAX is handled identically to how DI, DX, R10, R13 are
already handled.

### Step 2.3: IDENTIFY THE BUG MECHANISM
Category (h): Hardware/toolchain workaround. Specifically, compiler
compatibility fix.

Record: The bug is that objtool's register set for ORC data was
incomplete - it lacked RAX as a possible DRAP register. When Clang
generates code using RAX as DRAP, objtool hits the `default:` case in
the switch and reports "unknown CFA base reg 0" (0 being `CFI_AX`). The
fix adds RAX handling following the established pattern.

### Step 2.4: ASSESS THE FIX QUALITY
- Obviously correct: Each new case follows the exact pattern of adjacent
  cases
- Minimal/surgical: Only adds the necessary case statements
- Regression risk: Very low. `CFI_AX` (= 0) already exists in
  `cfi_regs.h` and has since the CFI renumbering in 2021. The new
  `ORC_REG_AX = 10` fits within the existing ORC_REG_MAX of 15. No
  existing paths are modified.
- Red flags: None. This is a textbook extension of an existing pattern.

Record: Fix quality is high. Obviously correct, minimal, no regression
risk.

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
The ORC register definitions in `orc_types.h` date back to commit
`39358a033b2e44` from Josh Poimboeuf (2017-07-11, v4.14). The register
list has been incrementally extended over the years (DI, DX were added
later). The code being modified has been stable for years.

Record: The ORC framework has been in the kernel since v4.14. The
pattern of adding new DRAP registers (DI, DX, R10, R13) to the ORC
register set is well-established. `CFI_AX` has existed since the CFI
renumbering in v5.12 (commit d473b18b2ef62).

### Step 3.2: FOLLOW THE FIXES: TAG
No explicit `Fixes:` tag present. This is expected for autosel
candidates.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Commit `7fdaa640c810c` ("objtool: Handle Clang RSP musical chairs") by
the same author addresses a related but independent Clang issue (RSP
register shuffling). That commit modifies `arch_decode_instruction()` in
decode.c, NOT `arch_decode_hint_reg()`. The RAX DRAP commit modifies
`arch_decode_hint_reg()`, so they touch different functions and are
independent.

Record: Related commit `7fdaa640c810c` exists in the tree (also by Josh
Poimboeuf, also fixing Clang objtool issues), but touches different code
paths. This commit is standalone.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Josh Poimboeuf is the **original author and maintainer of objtool**. He
has extensive recent commits to the objtool subsystem. This is the
highest-authority author possible for this code.

Record: Author is THE objtool maintainer. Maximum authority.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
The `tools/objtool/arch/x86/orc.c` file was created by commit
`b8e85e6f3a09f` (v6.9 era). This file exists in v7.0.

The `CFI_AX = 0` constant exists in `cfi_regs.h` and has since v5.12. No
new CFI constants are needed.

The commit does NOT depend on the "Clang RSP musical chairs" commit -
they touch independent functions.

Record: For v7.0, no prerequisites are needed. For older stable trees
(pre-6.9), `orc.c` doesn't exist and those changes would need to target
`orc_gen.c` and `orc_dump.c` instead.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1-4.2: FIND THE ORIGINAL PATCH DISCUSSION
b4 dig could not find the commit hash (it's not yet in the tree). The
`Link:` tag points to `patch.msgid.link/3f33dc720b83dc6d3a2b7094f75a5c90
a0b1cbc5.1773708458.git.jpoimboe@kernel.org`. The lore site was blocked
by anti-bot protection.

The related "Clang RSP musical chairs" commit was also reported by Arnd
Bergmann and fixed by Josh Poimboeuf, suggesting this is part of a
series of Clang compatibility fixes that are being actively addressed.

Record: Could not fetch lore discussion due to anti-bot protection. The
patch was submitted by the objtool maintainer and committed by the x86
co-maintainer.

### Step 4.3-4.5: BUG REPORT
The `Closes:` link references a Fastmail email from Arnd Bergmann. Arnd
is a prolific kernel developer and build tester who regularly tests
kernels with different compilers and configurations. His reports are
highly reliable.

Record: Bug reporter is Arnd Bergmann, one of the most active kernel
developers, known for compiler/build testing.

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS
Functions modified:
- `unwind_next_frame()` in `unwind_orc.c` - the core ORC unwinding
  function
- `arch_decode_hint_reg()` in `decode.c` - hint register decoding in
  objtool
- `init_orc_entry()` in `orc.c` - ORC entry generation in objtool
- `reg_name()` in `orc.c` - register name display in objtool

### Step 5.2-5.4: TRACE CALLERS
`unwind_next_frame()` is called by the kernel's stack unwinder for every
frame traversal - this is on the critical path for stack traces, OOPS
reporting, perf profiling, and livepatch. Without AX support, any
function where Clang used RAX as DRAP would produce broken stack traces
at runtime.

`arch_decode_hint_reg()` is called by objtool during kernel build to
decode ORC hint annotations.

`init_orc_entry()` is called by objtool during ORC data generation for
every function.

Record: The runtime change (unwind_orc.c) is on the critical stack
unwinding path. The build-time changes (objtool) are on the kernel build
critical path.

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
The existing ORC_REG_DI, ORC_REG_DX, ORC_REG_R10, ORC_REG_R13 are all
examples of the same pattern being extended. Each was added when a
specific DRAP register usage was encountered.

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

### Step 6.1: DOES THE BUGGY CODE EXIST IN STABLE TREES?
The ORC unwinder and objtool infrastructure exist in all stable trees
from v4.14 onward. The specific code being modified (the switch
statements in `unwind_orc.c` and objtool) exists in all active stable
trees.

However, `tools/objtool/arch/x86/orc.c` was only created in v6.9 (from
`b8e85e6f3a09f`). Older stable trees have the equivalent code in
`tools/objtool/orc_gen.c` and `tools/objtool/orc_dump.c`.

Record: The bug (missing RAX DRAP support) affects all stable trees when
compiled with recent Clang. For v6.9+ trees, the patch should apply
cleanly. For older trees, minor rework is needed.

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
For v7.0: Should apply cleanly.
For v6.6-v6.8: `orc.c` doesn't exist; changes need to target
`orc_gen.c`/`orc_dump.c`.
For v6.1 and earlier: Same, plus potential other conflicts.

Record: Clean apply for v7.0; minor rework for v6.6 and older.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY IN STABLE
No evidence of this fix being in any stable tree.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Subsystem: x86/objtool + x86/unwind (CORE infrastructure)

objtool is the mandatory build-time validation tool for x86 kernels. If
objtool fails, the kernel build fails. The ORC unwinder is the x86 stack
unwinding mechanism used by perf, crash dumps, and livepatch.

Record: [x86/objtool + x86/unwind] [Criticality: CORE - build tool +
stack unwinder]

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
The objtool subsystem is actively maintained with ~20+ commits in recent
development cycles. Josh Poimboeuf is the active maintainer.

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
ALL x86 users who build the kernel with recent Clang versions. This
includes Android (which uses Clang), ChromeOS, and many distributions
that support Clang builds.

Record: Affected population: all Clang-based x86 kernel builders.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
The trigger is: compiling any kernel function where Clang chooses RAX as
the DRAP register for stack alignment. The commit message shows
`vmw_host_printf` as one such function, but any function with stack
alignment could trigger it.

Record: Triggered by normal kernel compilation with recent Clang. Common
trigger in normal usage.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
- **Build-time**: objtool error prevents kernel compilation -
  **CRITICAL** for affected users
- **Runtime (without fix)**: If ORC_REG_AX data somehow made it in,
  stack traces would be broken - **HIGH**

Record: Severity: CRITICAL (build failure). Without this fix, affected
users simply cannot build the kernel with Clang.

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
- **BENEFIT**: High - enables kernel builds with recent Clang, fixes
  stack unwinding
- **RISK**: Very low - adds parallel case statements following an
  established pattern; no modification to existing code paths;
  `ORC_REG_AX = 10` fits within `ORC_REG_MAX = 15`

Record: Benefit HIGH, Risk VERY LOW.

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**Evidence FOR backporting:**
- Fixes build failure with recent Clang (build fixes are explicitly
  stable material)
- Author is the objtool maintainer; committer is x86 co-maintainer
- Reported by Arnd Bergmann (reliable reporter, prominent developer)
- +18 lines total, all following established patterns
- Very low regression risk - only adds new case statements
- Clang is widely used (Android, ChromeOS, distributions)
- The ORC format has room for this (ORC_REG_AX=10, MAX=15)
- CFI_AX already existed, just wasn't mapped to ORC

**Evidence AGAINST backporting:**
- Technically adds a new ORC register type (format extension)
- Touches 5 files
- For pre-6.9 stable trees, `orc.c` doesn't exist (needs rework)
- Only affects users with "recent" Clang versions

### Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **YES** - pattern follows existing
   register handling exactly
2. Fixes a real bug? **YES** - build failure with recent Clang
3. Important issue? **YES** - cannot build the kernel
4. Small and contained? **YES** - 18 lines of case statement additions
5. No new features or APIs? **Borderline** - adds ORC_REG_AX, but this
   is a build fix, not a feature
6. Can apply to stable? **YES for v7.0; needs rework for older trees**

### Step 9.3: CHECK FOR EXCEPTION CATEGORIES
This falls under **BUILD FIX** - fixes compilation/build errors with a
supported compiler. Build fixes are explicitly allowed in stable.

### Step 9.4: DECISION
This is a build fix for Clang users, authored by the objtool maintainer,
with very low regression risk. The change is small, obviously correct
(following an established pattern), and fixes a real build failure.
Build fixes are one of the explicitly allowed categories for stable
backporting.

## Verification

- [Phase 1] Parsed tags: Reported-by: Arnd Bergmann, Closes: lore link,
  Link: patch.msgid.link, SOBs from Josh Poimboeuf and Peter Zijlstra
- [Phase 2] Diff analysis: +18 lines across 5 files, all new `case`
  statements in existing switch blocks
- [Phase 2] Verified `ORC_REG_AX = 10` fits within `ORC_REG_MAX = 15`
- [Phase 3] git blame: ORC types header dates to v4.14 (commit
  39358a033b2e44)
- [Phase 3] Confirmed `CFI_AX = 0` already exists in `cfi_regs.h` since
  v5.12 (commit d473b18b2ef62)
- [Phase 3] Verified "Clang RSP musical chairs" (7fdaa640c810c) touches
  different function (`arch_decode_instruction`, not
  `arch_decode_hint_reg`), so no dependency
- [Phase 3] Confirmed `tools/objtool/arch/x86/orc.c` was created in
  commit b8e85e6f3a09f (v6.9 era)
- [Phase 3] Verified Josh Poimboeuf is the objtool maintainer with 10+
  recent objtool commits
- [Phase 4] b4 dig failed (commit not in tree); lore blocked by anti-bot
- [Phase 5] Verified `vmw_host_printf` exists in
  `drivers/gpu/drm/vmwgfx/vmwgfx_msg.c` - real function that triggers
  this
- [Phase 5] Confirmed `unwind_next_frame()` is the core unwinding
  function, critical path
- [Phase 6] `orc.c` exists in v7.0 tree; doesn't exist pre-6.9
- [Phase 6] `orc_types.h` only had one change since v6.6 (header guard
  rename)
- [Phase 8] Build failure is CRITICAL severity for affected users
- UNVERIFIED: Could not verify lore discussion or stable mailing list
  history due to anti-bot protection

The fix is small, surgical, obviously correct (follows established
pattern), fixes a real build failure, and meets all stable kernel
criteria.

**YES**

 arch/x86/include/asm/orc_types.h       | 1 +
 arch/x86/kernel/unwind_orc.c           | 8 ++++++++
 tools/arch/x86/include/asm/orc_types.h | 1 +
 tools/objtool/arch/x86/decode.c        | 3 +++
 tools/objtool/arch/x86/orc.c           | 5 +++++
 5 files changed, 18 insertions(+)

diff --git a/arch/x86/include/asm/orc_types.h b/arch/x86/include/asm/orc_types.h
index e0125afa53fb9..b3cc7970fa548 100644
--- a/arch/x86/include/asm/orc_types.h
+++ b/arch/x86/include/asm/orc_types.h
@@ -37,6 +37,7 @@
 #define ORC_REG_R13			7
 #define ORC_REG_BP_INDIRECT		8
 #define ORC_REG_SP_INDIRECT		9
+#define ORC_REG_AX			10
 #define ORC_REG_MAX			15
 
 #define ORC_TYPE_UNDEFINED		0
diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index f610fde2d5c4b..32f7e918d3d9f 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -578,6 +578,14 @@ bool unwind_next_frame(struct unwind_state *state)
 		}
 		break;
 
+	case ORC_REG_AX:
+		if (!get_reg(state, offsetof(struct pt_regs, ax), &sp)) {
+			orc_warn_current("missing AX value at %pB\n",
+					 (void *)state->ip);
+			goto err;
+		}
+		break;
+
 	default:
 		orc_warn("unknown SP base reg %d at %pB\n",
 			 orc->sp_reg, (void *)state->ip);
diff --git a/tools/arch/x86/include/asm/orc_types.h b/tools/arch/x86/include/asm/orc_types.h
index e0125afa53fb9..b3cc7970fa548 100644
--- a/tools/arch/x86/include/asm/orc_types.h
+++ b/tools/arch/x86/include/asm/orc_types.h
@@ -37,6 +37,7 @@
 #define ORC_REG_R13			7
 #define ORC_REG_BP_INDIRECT		8
 #define ORC_REG_SP_INDIRECT		9
+#define ORC_REG_AX			10
 #define ORC_REG_MAX			15
 
 #define ORC_TYPE_UNDEFINED		0
diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
index c5817829cdfac..5931b2393bd87 100644
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -896,6 +896,9 @@ int arch_decode_hint_reg(u8 sp_reg, int *base)
 	case ORC_REG_DX:
 		*base = CFI_DX;
 		break;
+	case ORC_REG_AX:
+		*base = CFI_AX;
+		break;
 	default:
 		return -1;
 	}
diff --git a/tools/objtool/arch/x86/orc.c b/tools/objtool/arch/x86/orc.c
index 735e150ca6b73..5494bb450ab55 100644
--- a/tools/objtool/arch/x86/orc.c
+++ b/tools/objtool/arch/x86/orc.c
@@ -70,6 +70,9 @@ int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi, struct instruct
 	case CFI_DX:
 		orc->sp_reg = ORC_REG_DX;
 		break;
+	case CFI_AX:
+		orc->sp_reg = ORC_REG_AX;
+		break;
 	default:
 		ERROR_INSN(insn, "unknown CFA base reg %d", cfi->cfa.base);
 		return -1;
@@ -138,6 +141,8 @@ static const char *reg_name(unsigned int reg)
 		return "bp(ind)";
 	case ORC_REG_SP_INDIRECT:
 		return "sp(ind)";
+	case ORC_REG_AX:
+		return "ax";
 	default:
 		return "?";
 	}
-- 
2.53.0

