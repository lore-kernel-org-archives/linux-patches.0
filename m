Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FED3F54D9;
	Mon, 20 Apr 2026 13:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691550; cv=none; b=XcCmbxQfuMqGavSrOeXI8Oxx0FMERMPJzlFnkr2nZTV0TOzGR/F3mt+q5pwZUp7sM0TCxFNMqgybR0JWwOzM9jeacnYKuLpWfCrHJ+fJzYEminAQW+1vAWn/FUsPjL9mJbzBFw5UYlrPxBUxpRrK865breOXYeojuGTfe3fdwM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691550; c=relaxed/simple;
	bh=VqXNKc8ZsrtVruS4eW2Cg+R6OwzVuc+h4MWq0pXObVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KuMUQ2swGuzMtuBy8DROUsN89tTaAhoy2zpnj1zZXS9KetWLk4SrGS8JRh46M+xjlpaRJ1Pmi6zSXwGM8v6BJK9HI6ofBiiozLzXOAlnzXgdns8yivy+G25lAGhiSP4wNbcjeC1/CgrDOfLus2XNq1PAdLFB3b8hQ+qb1BCRdXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CPeH0vqp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CPeH0vqp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B4BC2BCB9;
	Mon, 20 Apr 2026 13:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691549;
	bh=VqXNKc8ZsrtVruS4eW2Cg+R6OwzVuc+h4MWq0pXObVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CPeH0vqpkYJJ40uz9+dzzyX/771qCLAvXe7cpu4iLV1CegtXk/3G5yvehLwsEymxq
	 ch1kofW2YSbehxM9tmfpEWy8W9Uu2iBCiipmVFqcf7C3Q8HlcjZWv58g5D814cKzzT
	 HAU6F9g9s0ynjH8Jd9zTz/PJ5ZnLquOxy1WndWIwDhFkxv+mK4nvhCU+YZlBbmXKNQ
	 klMC96mwSOE8qBkvHXqzbvsiMw0suvNt4h0yvxD9OBVb7Sm3Yf123ZmUCbt16+n8Qg
	 qbeAiYkx6HvnVJbMW8acbW3kIQVOb6Zo4K5t9n4a8LmoaJZLau02BSVoKCop6/5vnd
	 x/3bxACAGQ3CA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lucas De Marchi <demarchi@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Phil Sutter <phil@nwl.cc>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Sami Tolvanen <samitolvanen@google.com>,
	Sasha Levin <sashal@kernel.org>,
	mcgrof@kernel.org,
	da.gomez@kernel.org,
	linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.15] module: Override -EEXIST module return
Date: Mon, 20 Apr 2026 09:18:08 -0400
Message-ID: <20260420132314.1023554-94-sashal@kernel.org>
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

From: Lucas De Marchi <demarchi@kernel.org>

[ Upstream commit 743f8cae549affe8eafb021b8c0e78a9f3bc23fa ]

The -EEXIST errno is reserved by the module loading functionality. When
userspace calls [f]init_module(), it expects a -EEXIST to mean that the
module is already loaded in the kernel. If module_init() returns it,
that is not true anymore.

Override the error when returning to userspace: it doesn't make sense to
change potentially long error propagation call chains just because it's
will end up as the return of module_init().

Closes: https://lore.kernel.org/all/aKLzsAX14ybEjHfJ@orbyte.nwl.cc/
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Phil Sutter <phil@nwl.cc>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Lucas De Marchi <demarchi@kernel.org>
[Sami: Fixed a typo.]
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have comprehensive context. Let me compile the final analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
- **Subsystem:** module (kernel/module)
- **Action verb:** "Override" — correcting incorrect behavior
- **Summary:** Override module_init's -EEXIST return to prevent
  userspace confusion
- Record: [module] [override/correct] [Prevent -EEXIST from module_init
  reaching userspace, where it's misinterpreted as "module already
  loaded"]

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
- **Closes:**
  https://lore.kernel.org/all/aKLzsAX14ybEjHfJ@orbyte.nwl.cc/ — Phil
  Sutter's bug report
- **Cc:** Greg Kroah-Hartman, Aaron Tomlin, Petr Pavlu, Daniel Gomez,
  Phil Sutter, Christophe Leroy — multiple well-known kernel developers
- **Signed-off-by:** Lucas De Marchi (author), Sami Tolvanen (picked up,
  fixed typo)
- **No Fixes: tag** — expected for manual review candidates
- Record: Notable that Phil Sutter (netfilter maintainer) is CC'd and
  the bug report is his. Greg KH is CC'd (he suggested this approach).

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
The commit explains: `-EEXIST` is **reserved** by the module loading
infrastructure. When userspace calls `[f]init_module()`, it expects
`-EEXIST` to mean "module is already loaded." The man page explicitly
documents `EEXIST - A module with this name is already loaded.` If a
module's init() returns -EEXIST (e.g., because a registration function
found a duplicate), this error reaches userspace where kmod/modprobe
interprets it as "already loaded" and reports **success** (0) to the
user. The module actually failed to initialize but the user is told it
succeeded.

Record: [Bug: init failures returning -EEXIST are silently swallowed by
userspace tools] [Symptom: modprobe reports success when module init
actually failed] [Root cause: collision between kernel-internal -EEXIST
meaning and module loader's reserved -EEXIST meaning]

### Step 1.4: DETECT HIDDEN BUG FIXES
This is an explicit bug fix — the commit clearly describes incorrect
behavior visible to users.
Record: [Not hidden — clearly a bug fix for incorrect error propagation
to userspace]

---

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

### Step 2.1: INVENTORY THE CHANGES
- **Files:** `kernel/module/main.c` — single file
- **Lines added:** +8 (5 comment lines + 3 code lines)
- **Lines removed:** 0
- **Function modified:** `do_init_module()`
- Record: [kernel/module/main.c +8 lines] [do_init_module()] [single-
  file surgical fix]

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
In the `if (ret < 0)` block after `do_one_initcall(mod->init)`:
- **Before:** ret passes through unchanged to `fail_free_freeinit` error
  path, eventually returned to userspace via `load_module()` → syscall
- **After:** If `ret == -EEXIST`, it's changed to `-EBUSY` before
  proceeding to the error path
- This ensures userspace never sees `-EEXIST` from a module init failure
Record: [Error path change: -EEXIST is remapped to -EBUSY before
reaching userspace]

### Step 2.3: IDENTIFY THE BUG MECHANISM
Category: **Logic/correctness fix**
- The kernel module loader uses `-EEXIST` as a special sentinel to mean
  "module already loaded" (in `module_patient_check_exists()`)
- Userspace tools (kmod/modprobe) rely on this convention to silently
  succeed when a module is loaded twice
- When `module_init()` returns `-EEXIST` for an unrelated reason (e.g.,
  registration collision), userspace misinterprets it
- Fix: translate `-EEXIST` to `-EBUSY` at the boundary between module
  init and error reporting
Record: [Logic/correctness: -EEXIST overloading causes userspace to
misinterpret module init failures as success]

### Step 2.4: ASSESS THE FIX QUALITY
- **Obviously correct:** Yes — simple conditional check and error code
  substitution
- **Minimal:** Yes — 3 lines of code + 5 lines of comment
- **Regression risk:** Extremely low — changes behavior only when module
  init returns -EEXIST (which is already a failure), and the change is
  from "silently succeed" to "properly report failure"
- **Approach endorsed by Greg KH:** He explicitly suggested this
  approach instead of the "whack-a-mole" approach of fixing every
  individual module
Record: [Fix quality: excellent — minimal, obviously correct, low
regression risk, approach endorsed by GKH]

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
The modified code (`do_one_initcall` + `if (ret < 0) { goto
fail_free_freeinit; }`) was introduced by commit `34e1169d996ab1` by
Kees Cook in October 2012. This code has been stable since v3.7+.
Record: [Buggy code pattern present since 2012 (v3.7), exists in ALL
active stable trees]

### Step 3.2: FOLLOW THE FIXES TAG
No Fixes: tag present (expected for autosel candidates). The underlying
issue is as old as the module loader's use of -EEXIST, which has been in
the kernel for many years.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Recent module/main.c changes are unrelated: panic fix, lockdep cleanup,
kmalloc_obj conversion. No conflicting changes near the modified code
area.
Record: [No related changes, standalone fix]

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Lucas De Marchi is a well-known kernel developer (xe/i915 DRM
maintainer, kmod maintainer). He has deep understanding of module
loading. Sami Tolvanen co-signed (known for module/CFI work).
Record: [Author is kmod maintainer — very authoritative on this topic]

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
No dependencies. The fix adds a simple conditional inside an existing
`if` block. The code pattern exists identically in v5.15, v6.1, v6.6,
and all active stable trees.
Record: [Fully standalone, applies cleanly to all stable trees]

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1-4.2: PATCH DISCUSSION
From the mailing list discussion found:
- Phil Sutter (netfilter maintainer) reported this bug when
  `nf_conntrack_helper_register()` returned -EEXIST to init_module,
  causing kmod to treat the failure as success
- Daniel Gomez attempted to fix individual modules, but Greg KH
  explicitly said "let the module loader do the translation" rather than
  playing whack-a-mole
- Lucas De Marchi agreed and implemented the module loader approach
- This patch is the consensus solution agreed upon by GKH, Lucas De
  Marchi, and Daniel Gomez
Record: [Greg KH explicitly suggested this approach; multiple
maintainers agreed]

### Step 4.3: BUG REPORT
Phil Sutter's report (aKLzsAX14ybEjHfJ@orbyte.nwl.cc) demonstrates this
is a real user-visible bug. The precedent fix (commit 54416fd76770 for
netfilter) was already merged in August 2025. At least 40+ modules
across the kernel tree can potentially hit this issue.
Record: [Real bug reported by netfilter maintainer; 40+ modules
affected]

### Step 4.5: STABLE MAILING LIST
The "dm: replace -EEXIST with -EBUSY" commit was already selected for
stable 6.19.y backporting, showing this class of bugs is considered
stable-worthy.
Record: [Related fixes (individual module -EEXIST → -EBUSY) already in
stable queues]

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.2: KEY FUNCTIONS AND CALLERS
- `do_init_module()` is called from `load_module()`
- `load_module()` is called from `init_module` syscall and
  `finit_module` syscall
- Every module load in the system passes through this code path
Record: [Universal code path — affects every module load operation]

### Step 5.4: CALL CHAIN
`finit_module()` syscall → `idempotent_init_module()` →
`init_module_from_file()` → `load_module()` → `do_init_module()` →
`do_one_initcall(mod->init)` → ret flows back to userspace
Record: [ret from module init reaches userspace directly — any -EEXIST
is seen by kmod]

---

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

### Step 6.1: DOES THE BUGGY CODE EXIST IN STABLE TREES?
Verified: The exact same code pattern exists in v6.6 and v5.15:

```c
if (mod->init != NULL)
    ret = do_one_initcall(mod->init);
if (ret < 0) {
    goto fail_free_freeinit;
}
```

This code has been unchanged since 2012. It exists in ALL active stable
trees.
Record: [Buggy code present in all stable trees: 5.15.y, 6.1.y, 6.6.y,
6.12.y, 6.19.y]

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
The patch adds code inside the `if (ret < 0)` block which is identical
across all stable trees. Should apply cleanly with no conflicts.
Record: [Clean apply expected across all stable trees]

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: SUBSYSTEM CRITICALITY
- **Subsystem:** kernel/module (CORE)
- Module loading affects every kernel user who loads any module
- Criticality: **CORE** — every system loads modules
Record: [CORE subsystem; affects all users who load kernel modules]

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: WHO IS AFFECTED
ALL users who load kernel modules — universal. Specifically affects
users whose modules' init functions return -EEXIST from internal
registration functions (documented: 40+ modules identified).
Record: [Universal impact — all module loading users]

### Step 8.2: TRIGGER CONDITIONS
Any module whose init() path returns -EEXIST (e.g., due to registration
collision). Phil Sutter triggered it with netfilter conntrack helpers.
At least 40+ modules can potentially hit this.
Record: [Triggered by any module init returning -EEXIST; multiple known
triggering modules]

### Step 8.3: FAILURE MODE SEVERITY
When triggered: userspace reports **success** for a module that **failed
to initialize**. The user has no indication the module isn't working.
For netfilter, this means conntrack helpers silently don't register and
connection tracking breaks.
Record: [Severity: HIGH — silent failure, user unaware their module
isn't functional]

### Step 8.4: RISK-BENEFIT RATIO
- **Benefit:** HIGH — fixes silent module init failures across 40+
  modules
- **Risk:** VERY LOW — 3 lines of code, simple error code translation,
  only affects error paths where init already failed
- **Ratio:** Strongly favorable for backporting
Record: [High benefit, very low risk]

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: EVIDENCE
**FOR backporting:**
- Fixes a real, user-reported bug (Phil Sutter, netfilter maintainer)
- Silent failures are dangerous — users believe module is loaded when it
  isn't
- Affects ALL stable trees (code unchanged since 2012)
- Tiny patch: 3 lines of code + comment
- Obviously correct: simple error code translation
- Approach explicitly endorsed by Greg Kroah-Hartman
- Author is kmod maintainer (Lucas De Marchi)
- Related individual module fixes already selected for stable
- Clean apply expected across all stable trees

**AGAINST backporting:**
- None identified

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **YES** — trivial code, endorsed by GKH
2. Fixes a real bug that affects users? **YES** — module init failures
   silently ignored
3. Important issue? **YES** — silent failure can cause unexpected broken
   functionality
4. Small and contained? **YES** — 8 lines, single file, single function
5. No new features or APIs? **YES** — pure bug fix
6. Can apply to stable trees? **YES** — identical code pattern in all
   trees

### Step 9.3: EXCEPTION CATEGORIES
Not an exception case — this is a straightforward bug fix that meets all
standard criteria.

---

## Verification

- [Phase 1] Parsed commit message: Closes: tag to Phil Sutter's bug
  report, CCs to GKH and module developers
- [Phase 2] Diff analysis: +8 lines in do_init_module(), adds -EEXIST →
  -EBUSY translation in error path
- [Phase 3] git blame: buggy code introduced by 34e1169d996ab1 (Kees
  Cook, 2012, v3.7), present in all stable trees
- [Phase 3] Verified same code in v6.6: `git show
  v6.6:kernel/module/main.c` — identical pattern at line 2531
- [Phase 3] Verified same code in v5.15: `git show
  v5.15:kernel/module.c` — identical pattern at line 3696
- [Phase 3] No dependencies: fix is standalone
- [Phase 4] Mailing list: GKH explicitly suggested the module-loader-
  level approach (lkml.iu.edu/2601.1/00694.html)
- [Phase 4] Related dm -EEXIST fix already in stable 6.19 queue
  (spinics.net)
- [Phase 4] man page confirms: EEXIST = "module with this name is
  already loaded" (kernel.org man page)
- [Phase 5] Call chain: syscall → load_module → do_init_module → ret
  reaches userspace directly
- [Phase 6] Clean apply: code pattern identical in
  v5.15/v6.1/v6.6/v6.12/v6.19
- [Phase 8] Severity: HIGH — silent failure, user unaware module isn't
  functional
- [Phase 8] Risk: VERY LOW — 3 lines, only affects already-failing error
  path

This is a small, obviously correct bug fix for a real user-reported
issue. It prevents userspace tools from silently treating module
initialization failures as successes. The fix was developed at Greg
Kroah-Hartman's explicit suggestion, implemented by the kmod maintainer,
and applies cleanly to all stable trees. The benefit (preventing silent
module failures) far outweighs the negligible risk.

**YES**

 kernel/module/main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/module/main.c b/kernel/module/main.c
index c3ce106c70af1..f6704856249df 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -3045,6 +3045,14 @@ static noinline int do_init_module(struct module *mod)
 	if (mod->init != NULL)
 		ret = do_one_initcall(mod->init);
 	if (ret < 0) {
+		/*
+		 * -EEXIST is reserved by [f]init_module() to signal to userspace that
+		 * a module with this name is already loaded. Use something else if the
+		 * module itself is returning that.
+		 */
+		if (ret == -EEXIST)
+			ret = -EBUSY;
+
 		goto fail_free_freeinit;
 	}
 	if (ret > 0) {
-- 
2.53.0

