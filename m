Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A88C3FA5EA;
	Tue, 28 Apr 2026 10:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372919; cv=none; b=fi4/7STT+iRRubIPrjLRbZqT3EnLZUaSKdqdJ5a44XlRXbcsIsoYBYpe8nOrfycggxO36DcBUYlPRIp8MNJ8aa4uOogmTj5OLMzEuaYSokqdxkIQKKCLz7XJm+f4oy6Jt7+RwGZ3r4tdvWe8siQ74nH+MkrrxhcmSOYHTzBJ7Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372919; c=relaxed/simple;
	bh=vZc4P0BDoe7eirlzk7685cVeWW4/osHZn5mpP9ILqCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RmYJ81u1SPZsprY9+Z2OtrEO9E6PaezXS46O9SvG9Nfhy/O8jUNqMeiAGIFnAw0xtWb09AJu0F+rm+22MmoSsI0dZ5muOh9L0L59smIvYtBjqtpyvYHWF92G4SVpLTMI+Fj0tZPxBpjqbFLNN1KhPA43Nz0Y0X211UUb+R7R6G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NFg+rsEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NFg+rsEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3211C2BCAF;
	Tue, 28 Apr 2026 10:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372919;
	bh=vZc4P0BDoe7eirlzk7685cVeWW4/osHZn5mpP9ILqCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NFg+rsEjNmf2yWL/hq+mXrb8QEGUJDyxMZITDco//gM49SkXy0ug7u2pSsU6WY3qL
	 U9HHEBqjjBYqeGSG7mRMwoMTEc6x6xkDvG9U7z4LpCQYd/9XYErXCeTFkyQSpUq/pF
	 Ll07E7wVVbuZgBsboST3kdPDuq1cObuNIuk02tXItMXJxjNtZQEIJB16ogmt6izxx2
	 hxKvS04eMg5ppqHaa1OVPX2cADIuQa/4oX+5H7Oc1y9KKLe62QFM0yu6c8WPWLUVsq
	 +nTz73v71ENngp8LIsutJV9t6031bS26tpoahKAxYKqBZKBz5mSQ/eX+UvdpBOMb0o
	 AqJTKYO/Q7ONg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kees Cook <kees@kernel.org>,
	kernel test robot <lkp@intel.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	richard@nod.at,
	anton.ivanov@cambridgegreys.com,
	johannes@sipsolutions.net,
	linux-um@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.1] um: Disable GCOV_PROFILE_ALL on 32-bit UML with Clang 20/21
Date: Tue, 28 Apr 2026 06:40:29 -0400
Message-ID: <20260428104133.2858589-18-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Kees Cook <kees@kernel.org>

[ Upstream commit 6522fe5c1b007c376fc5f2de1016c99a18b0af8e ]

Clang 20 and 21 miscompute __builtin_object_size() when -fprofile-arcs
is active on 32-bit UML targets, which passes incorrect object size
calculations for local variables through always_inline copy_to_user()
and check_copy_size(), causing spurious compile-time errors:

  include/linux/ucopysize.h:52:4: error: call to '__bad_copy_from' declared with 'error' attribute: copy source size is too small

The regression was introduced in LLVM commit 02b8ee281947 ("[llvm]
Improve llvm.objectsize computation by computing GEP, alloca and malloc
parameters bound"), which shipped in Clang 20. It was fixed in LLVM
by commit 45b697e610fd ("[MemoryBuiltins] Consider index type size
when aggregating gep offsets"), which was backported to the LLVM 22.x
release branch.

The bug requires 32-bit UML + GCOV_PROFILE_ALL (which uses -fprofile-arcs),
though the exact trigger depends on optimizer decisions influenced by other
enabled configs.

Prevent the bad combination by disabling UML's ARCH_HAS_GCOV_PROFILE_ALL
on 32-bit when using Clang 20.x or 21.x.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202604030531.O6FveVgn-lkp@intel.com/
Suggested-by: Nathan Chancellor <nathan@kernel.org>
Assisted-by: Claude:claude-opus-4-6[1m]
Signed-off-by: Kees Cook <kees@kernel.org>
Link: https://patch.msgid.link/20260409052038.make.995-kees@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture. Let me write the analysis.

## Analysis

### Phase 1: Commit Message Forensics

**Step 1.1 - Subject Line:**
Record: Subsystem = `um:` (User Mode Linux). Action verb = "Disable".
Summary = Disable GCOV_PROFILE_ALL on 32-bit UML when building with
Clang 20/21 to avoid a compiler miscompile.

**Step 1.2 - Tags:**
Record:
- `Reported-by: kernel test robot <lkp@intel.com>` (lkp build failure
  report)
- `Closes: https://lore.kernel.org/oe-kbuild-all/202604030531.O6FveVgn-
  lkp@intel.com/` (lkp report)
- `Suggested-by: Nathan Chancellor <nathan@kernel.org>` (LLVM-kernel
  maintainer endorsed the approach)
- `Signed-off-by: Kees Cook <kees@kernel.org>` (hardening maintainer,
  patch author)
- `Link:
  https://patch.msgid.link/20260409052038.make.995-kees@kernel.org`
- `Signed-off-by: Johannes Berg <johannes.berg@intel.com>` (UML co-
  maintainer applied it)
- No `Fixes:` tag, no `Cc: stable` tag (expected for this review
  pipeline)

**Step 1.3 - Body Analysis:**
Record: Bug = Clang 20/21 miscompute `__builtin_object_size()` when
`-fprofile-arcs` is active on 32-bit UML. Symptom = spurious compile-
time error: `error: call to '__bad_copy_from' declared with 'error'
attribute: copy source size is too small`. Root cause identified in LLVM
commit `02b8ee281947` (shipped in Clang 20), fixed in LLVM by
`45b697e610fd`, backported to LLVM 22.x. Trigger = 32-bit UML +
`GCOV_PROFILE_ALL` + Clang 20 or 21.

**Step 1.4 - Hidden Bug Fix Detection:**
Record: Not hidden - explicitly a build fix / toolchain workaround. Verb
"Disable" accurately describes adding a Kconfig guard to prevent a
broken combination.

### Phase 2: Diff Analysis

**Step 2.1 - Inventory:**
Record: 1 file changed (`arch/um/Kconfig`), +3/-1 lines. Functions
modified = none (Kconfig only). Scope = single-file, single-line logic
change.

**Step 2.2 - Code Flow Change:**
Record: BEFORE: `config UML` unconditionally `select
ARCH_HAS_GCOV_PROFILE_ALL`. AFTER: selects it only when NOT (32-bit AND
Clang in `[20.0.0, 22.1.0)` range). Adds comment explaining why.

**Step 2.3 - Bug Mechanism:**
Record: Category = (h) Hardware/toolchain workarounds - specifically
Kconfig dependency guard for a broken compiler. Mechanism = removing an
invalid configuration option combination that would otherwise result in
a compile-time error.

**Step 2.4 - Fix Quality:**
Record: Obviously correct Kconfig guard. Minimal. Zero regression risk
at runtime (build configuration only). The only "risk" is disabling a
feature in an invalid config, which is exactly the intent.

### Phase 3: Git History Investigation

**Step 3.1 - Blame:**
Record: `select ARCH_HAS_GCOV_PROFILE_ALL` for UML was added in commit
`2419ac3272669` ("um: Enable ARCH_HAS_GCOV_PROFILE_ALL" by Vincent
Whitchurch, April 2022), first released in v5.19.

**Step 3.2 - Fixes Tag:**
Record: No Fixes: tag. The root cause is an LLVM compiler bug, not a
kernel bug. LLVM commit `02b8ee281947` shipped in Clang 20 (external
toolchain, not trackable via kernel Fixes:).

**Step 3.3 - File History:**
Record: Recent UM Kconfig churn includes MMU_GATHER_RCU_TABLE_FREE,
KASAN_INLINE, SMP support, FORTIFY_SOURCE. No conflicting work on GCOV.
Standalone patch, not part of a series.

**Step 3.4 - Author Context:**
Record: Kees Cook (kernel hardening/fortify maintainer) authored.
Johannes Berg (UML co-maintainer) applied it. Nathan Chancellor (LLVM-
kernel integration) suggested the approach. Strong expert endorsement
from multiple relevant maintainers.

**Step 3.5 - Dependencies:**
Record: Depends only on `CLANG_VERSION` Kconfig symbol (present since at
least v5.19). No kernel commit prerequisites.

### Phase 4: Mailing List Investigation

**Step 4.1 - Original Discussion:**
Record: Fetched the thread via `b4 mbox` for message-id
`20260409052038.make.995-kees@kernel.org`. This is v3; v1 at
`20260408005958.work.271-kees@kernel.org` and v2 at
`20260408162607.it.347-kees@kernel.org`. v3 changed approach based on
Nathan Chancellor's suggestion (use `ARCH_HAS_GCOV_PROFILE_ALL` guard in
arch/um instead of earlier approaches).

**Step 4.2 - Reviewers:**
Record: Thread includes UML maintainers (Richard Weinberger, Johannes
Berg, Anton Ivanov), LLVM/Clang kernel contacts (Nathan Chancellor, Nick
Desaulniers, Bill Wendling, Justin Stitt), and mailing lists (llvm@,
linux-um@, linux-kernel@, linux-hardening@). Proper review coverage.

**Step 4.3 - Bug Report:**
Record: Reported-by lkp (kernel test robot) with lore link. This is an
automated build tester - the bug was reproduced by lkp's test matrix.

**Step 4.4 - Discussion Details:**
Record: Johannes Berg raised a stylistic question about the version
comparison bounds. Nathan Chancellor explained the bounds (including
`22.0.x` which is the 22 development cycle, not 22.1.0 which is the
first release). No NAKs; stylistic feedback only. No explicit stable
nomination in the discussion.

**Step 4.5 - Stable-List Discussion:**
Record: No prior discussion on stable list found for this specific
issue.

### Phase 5: Semantic Analysis

**Step 5.1 - Key functions:**
Record: No functions modified. Kconfig-only change. `check_copy_size()`
and `copy_to_user()` are mentioned as affected by the underlying
miscompile, but they are not being modified.

**Step 5.2-5.5:**
Record: N/A for a Kconfig-only guard. Impact surface = anyone who builds
32-bit UML with Clang 20/21 and enables `CONFIG_GCOV_PROFILE_ALL`.

### Phase 6: Cross-Referencing Stable Trees

**Step 6.1 - Buggy code in stable:**
Record: Verified `select ARCH_HAS_GCOV_PROFILE_ALL` is present in UML
Kconfig for v5.19, v6.1, v6.6, v6.12, v6.16, v7.0. So the "buggy
combination" is selectable in all stable trees from v5.19 onward.

**Step 6.2 - Backport Complications:**
Record: Diff context is present cleanly in v6.1+ (line before is `select
ARCH_HAS_FORTIFY_SOURCE`). In v5.19 the preceding line is
`ARCH_EPHEMERAL_INODES` instead, so a very minor context adjustment
would be needed for 5.19 only; v6.1+ should apply verbatim.
`CLANG_VERSION` Kconfig symbol confirmed present in all trees checked.

**Step 6.3 - Related fixes in stable:**
Record: No prior fix exists. This is the first solution to this specific
Clang 20/21 miscompile for UML.

### Phase 7: Subsystem Context

**Step 7.1 - Criticality:**
Record: Subsystem = `arch/um/` (User Mode Linux). Criticality =
PERIPHERAL. UML is a special architecture primarily used for kernel
testing/debugging, not production deployments.

**Step 7.2 - Activity:**
Record: UML is moderately active - recent commits include SMP support,
KASAN, preemption, page tables. Active but niche.

### Phase 8: Impact and Risk

**Step 8.1 - Affected Users:**
Record: Only users who build with 32-bit UML +
`CONFIG_GCOV_PROFILE_ALL=y` + Clang 20 or 21. Very narrow intersection;
primarily kernel developers doing coverage testing on UML.

**Step 8.2 - Trigger:**
Record: Only triggers at BUILD time (not runtime). Trigger = compiling
the kernel with the specific config combination above. Reproducible
(kernel test robot hit it).

**Step 8.3 - Failure Mode:**
Record: Compile-time error - kernel fails to build. Severity = MEDIUM
(blocks compilation but no runtime/security impact; users can work
around by disabling GCOV or using different Clang version). Falls under
allowed "BUILD FIXES" exception category in stable rules.

**Step 8.4 - Risk/Benefit:**
Record: BENEFIT = Fixes build failure for users in affected config
(narrow but real). RISK = Effectively zero - Kconfig guard cannot cause
runtime regressions; only cost is that affected users lose the ability
to enable GCOV_PROFILE_ALL on 32-bit UML with Clang 20/21 (which was
already broken anyway). Ratio = strongly favorable when it applies; non-
impactful otherwise.

### Phase 9: Final Synthesis

**Evidence FOR backporting:**
- Explicit Kconfig dependency fix - stable rules list "Build fixes:
  Kconfig dependency fixes" as an explicit exception
- Zero runtime regression risk (Kconfig-only)
- Small (3 lines), obviously correct, well-reviewed
- Subsystem maintainer applied, LLVM expert suggested the approach
- Reported by automated build bot (real, reproducible issue)
- Applies cleanly to all stable trees from v6.1 onward; trivial context
  fix for v5.19
- Similar Clang 20 build-error fixes are routinely accepted (e.g.,
  `ef753d66051ca` objtool Clang 20 fix)

**Evidence AGAINST backporting:**
- Very narrow audience (32-bit UML + GCOV + Clang 20/21)
- UML is a testing/debug arch, not production-critical
- No `Cc: stable` in submission; discussion did not raise stable
  nomination
- Users can trivially work around by not enabling GCOV or upgrading
  Clang to 22.1+

**Stable Rules Checklist:**
1. Obviously correct/tested: YES (Kconfig guard, build-tested by lkp)
2. Fixes a real bug: YES (reproducible build failure)
3. Important issue: MEDIUM (build failure, narrow scope)
4. Small and contained: YES (3 lines, 1 file)
5. No new features: YES (removes an option in invalid config)
6. Applies to stable: YES (clean apply to v6.1+; minor context to v5.19)

**Exception category:**
Record: Falls under "BUILD FIXES - Kconfig dependency fixes" - an
explicit allowed exception in stable rules.

**Decision:**
This is a Kconfig-only build fix that prevents a known Clang 20/21
compiler miscompile from producing spurious compile errors on 32-bit UML
with GCOV. It has zero runtime risk, applies cleanly to stable trees,
and is explicitly within an allowed exception category. Although the
affected user population is narrow, the cost to include it is
essentially nil, and similar Clang version-specific build fixes are
routinely backported. Stable users building with affected toolchains
will otherwise see unexplained build breakage.

### Verification

- [Phase 1] Parsed tags from commit message: Reported-by kernel test
  robot, Suggested-by Nathan Chancellor, Signed-off-by Kees Cook and
  Johannes Berg, Link + Closes lore URLs. No Cc: stable, no Fixes: tag.
- [Phase 1] Identified as an explicit build fix (compile error described
  with exact error text).
- [Phase 2] Verified diff: 3 lines added, 1 removed in `arch/um/Kconfig`
  only; guards `ARCH_HAS_GCOV_PROFILE_ALL` with `!(!64BIT &&
  CLANG_VERSION >= 200000 && CLANG_VERSION < 220100)`.
- [Phase 3] `git log 2419ac3272669 -1` confirmed UML's
  `ARCH_HAS_GCOV_PROFILE_ALL` select originated in v5.19-rc1 (Vincent
  Whitchurch, Apr 2022).
- [Phase 3] Confirmed no Fixes: target in kernel history; root cause is
  LLVM commit (external).
- [Phase 4] `b4 mbox 20260409052038.make.995-kees@kernel.org` retrieved
  3-message thread; patch is v3 (links to v1/v2 in commit body). Nathan
  explained version bounds rationale, no NAKs, no stable nominations
  raised in thread.
- [Phase 4] Confirmed proper reviewers/maintainers CC'd: UML maintainers
  + LLVM kernel contacts.
- [Phase 5] N/A (Kconfig-only change).
- [Phase 6] `git show v5.19:arch/um/Kconfig`, `v6.1:`, `v6.6:`,
  `v6.12:`, `v6.16:`, `v7.0:` all confirmed `select
  ARCH_HAS_GCOV_PROFILE_ALL` present.
- [Phase 6] `git show vX.Y:init/Kconfig` confirmed `CLANG_VERSION`
  Kconfig symbol present in all checked stable trees.
- [Phase 6] Verified diff context `ARCH_HAS_FORTIFY_SOURCE` /
  `ARCH_HAS_GCOV_PROFILE_ALL` / `ARCH_HAS_KCOV` is present in v6.1+ for
  clean apply; v5.19 context differs slightly.
- [Phase 7] Subsystem = arch/um; peripheral/testing-focused.
- [Phase 8] Failure mode = compile-time error (no runtime impact).
  Severity MEDIUM - build failure, narrow config.
- [Phase 8] Precedent `ef753d66051ca` (objtool Clang 20 fix) confirms
  similar compiler-compat build fixes get applied in mainline/stable
  ecosystem.
- UNVERIFIED: Whether all `LLVM 22.x` patch references are accurate -
  the commit cites them but I did not independently verify the LLVM
  commits. This does not affect the kernel backport decision since the
  kernel-side change stands on its own merits as a Kconfig guard.
- UNVERIFIED: Exact user-impact numbers (how many stable users build
  32-bit UML + GCOV + Clang 20/21) - inherently unknowable but likely
  small; does not change the risk-benefit calculus since risk is
  effectively zero.

This is a narrowly-scoped Kconfig-only build fix with expert review,
clean applicability, and zero runtime regression risk. It matches the
documented "Build fixes / Kconfig dependency fixes" exception in stable
kernel rules.

**YES**

 arch/um/Kconfig | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/um/Kconfig b/arch/um/Kconfig
index 098cda44db225..d9541d13d9eb0 100644
--- a/arch/um/Kconfig
+++ b/arch/um/Kconfig
@@ -11,7 +11,9 @@ config UML
 	select ARCH_HAS_CACHE_LINE_SIZE
 	select ARCH_HAS_CPU_FINALIZE_INIT
 	select ARCH_HAS_FORTIFY_SOURCE
-	select ARCH_HAS_GCOV_PROFILE_ALL
+	# Clang 20 & 21 miscompute __builtin_object_size() under -fprofile-arcs
+	# on 32-bit, causing spurious compile-time errors in check_copy_size().
+	select ARCH_HAS_GCOV_PROFILE_ALL if !(!64BIT && CLANG_VERSION >= 200000 && CLANG_VERSION < 220100)
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_STRNCPY_FROM_USER
 	select ARCH_HAS_STRNLEN_USER
-- 
2.53.0

