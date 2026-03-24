Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453083ED107;
	Tue, 24 Mar 2026 11:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774351180; cv=none; b=IX803jW7wLTAQJPtfCeb4AQtkoHGZ0oCXdU7oMdei/Eh66WX1+kcJU6ghYjdE3YBFNafHboZXjQdMJfAdXImSvvO/zNoIv2+2HM4sr1JTDEfI7EPBOw7MniokG2ZJYf7oFIEiGY2x78N6oH1vu1l/0oXHi+hb1gnXDQEhnqmiG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774351180; c=relaxed/simple;
	bh=YEeArAs+QD6a5UVTZj63wVrItdJdOlVlIuhf25jZjfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mVta8qbPd4TCtajnGicoEvem9THRGK4ZEDMxXJbQjy7wOcFEQr0nrD9e7NUilWDqEWuPDyaBCcIw9oG9Y5VpCCBo7vBlg/GwdQ8Q0ylBC+tBBw+ztVrhdnAPMimY59QfkfKXYtNdFuFwKOh1WgRXtDDzXC9u6ry8pk8vTqBbtzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nFxHGH/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nFxHGH/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6F4C2BCB5;
	Tue, 24 Mar 2026 11:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774351179;
	bh=YEeArAs+QD6a5UVTZj63wVrItdJdOlVlIuhf25jZjfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nFxHGH/MoU0Nw0VBaJ419zaXIm7x9t+Mog5Rga/Re8Tj8FM8J6Kw2jGKtbkmZtfnx
	 2LSnWT+/muI0TEgFMv3bnHqOvHOJaqZsgAN8fWs1A3RxojJ2r2zi13d+hFDcszvypi
	 HqqWqnuO7l+8YMTFVGPL71hARtxglN+wCEh4fcSaU2m5L/UV5BYB39xONvdYRI2uEb
	 EfZyw9atloBiegEFFgLLfrSC8jU9cxNG7CHGlHECo/raNwFbq6Of13DN4w8IIMYSig
	 M4aitjFdTnaUfPkfiSjxOI8sQ/Qkeu5kk9fOg/U+qEpz1Y5zL188gELUus50Vl68IC
	 Rk4nGjEjUwCUg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>,
	peterz@infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] objtool: Fix Clang jump table detection
Date: Tue, 24 Mar 2026 07:19:14 -0400
Message-ID: <20260324111931.3257972-5-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260324111931.3257972-1-sashal@kernel.org>
References: <20260324111931.3257972-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 4e5019216402ad0b4a84cff457b662d26803f103 ]

With Clang, there can be a conditional forward jump between the load of
the jump table address and the indirect branch.

Fixes the following warning:

  vmlinux.o: warning: objtool: ___bpf_prog_run+0x1c5: sibling call from callable instruction with modified stack frame

Reported-by: Arnd Bergmann <arnd@arndb.de>
Closes: https://lore.kernel.org/a426d669-58bb-4be1-9eaa-6f3d83109e2d@app.fastmail.com
Link: https://patch.msgid.link/7d8600caed08901b6679767488acd639f6df9688.1773071992.git.jpoimboe@kernel.org
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The buggy code (`insn->type == INSN_JUMP_UNCONDITIONAL`) exists in both
6.1 and 6.6 stable. The patch would apply with minor context differences
(the code after the jump table detection differs slightly between
versions).

### Step 6.2: Backport Complications
The code in stable trees has slightly different structure in
`find_jump_table()` (uses `reloc` variable and `insn->jump_table`
instead of `insn->_jump_table`), but the specific code being changed in
`mark_func_jump_tables()` is **identical** across all versions. The
patch should apply cleanly to the `mark_func_jump_tables()` function.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

- **Subsystem**: objtool (tools/objtool/) — a build tool for kernel
  stack validation
- **Criticality**: IMPORTANT — objtool is used during every kernel build
  with Clang or CONFIG_OBJTOOL enabled. Incorrect objtool analysis can
  produce spurious warnings that become errors with CONFIG_WERROR, and
  can also miss real issues.
- **Author**: Josh Poimboeuf — the **maintainer** of objtool. His fixes
  carry maximum weight for this subsystem.

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is Affected
Anyone building the kernel with **Clang** compiler where Clang generates
conditional forward jumps in switch tables. This affects the BPF
subsystem (`___bpf_prog_run`) specifically mentioned, but potentially
other functions too.

### Step 8.2: Trigger Conditions
- Building the kernel with Clang (increasingly common, required by
  Android)
- Having BPF enabled (very common)
- The warning appears during every build — not intermittent

### Step 8.3: Failure Mode Severity
- **Build warnings** that become **build failures** with
  `CONFIG_WERROR=y`
- **Incorrect stack validation** — objtool may miss real stack issues
- Severity: **MEDIUM-HIGH** — build breakage for Clang users,
  correctness issue for stack validation

### Step 8.4: Risk-Benefit
- **BENEFIT**: High — fixes build warnings/errors for Clang users,
  improves objtool correctness
- **RISK**: Very low — the change removes 2 conditions from an `if`
  statement, making it more inclusive. This is authored by the objtool
  maintainer. The worst case of being too inclusive would be extra back-
  pointers, which is benign.
- **Ratio**: Strongly favorable

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backporting:**
- Fixes a real build warning that becomes a build failure with
  CONFIG_WERROR
- Fixes incorrect objtool analysis (correctness bug)
- Reported by Arnd Bergmann (prominent developer), affecting Clang
  builds
- Very small, surgical fix (removes 2 conditions from one `if`
  statement)
- Authored by the objtool maintainer (Josh Poimboeuf)
- Merged via objtool/urgent track
- Buggy code exists identically in all stable trees (introduced 2018)
- Patch applies cleanly to the specific code being changed
- Self-contained (patches 2/3 and 3/3 in the series are for unrelated
  subsystems)

**AGAINST backporting:**
- It's a build tool fix, not a runtime kernel bug
- No explicit stable nomination
- 240 changes to objtool/check.c since 6.1 means context may have
  diverged elsewhere

### Step 9.2: Stable Rules Checklist
1. **Obviously correct and tested?** YES — authored by maintainer,
   removes overly restrictive condition, tested by reporter
2. **Fixes a real bug?** YES — false warnings/build failures with Clang
3. **Important issue?** YES — build failures affect all Clang users,
   objtool correctness matters
4. **Small and contained?** YES — ~5 lines changed in one function
5. **No new features or APIs?** CORRECT — no new features
6. **Can apply to stable?** YES — the specific code being changed is
   identical in stable

### Step 9.3: Exception Categories
Not an exception category — this is a straightforward bug fix.

### Step 9.4: Decision

This is a small, obviously correct fix by the objtool maintainer that
addresses real build warnings/failures for Clang users. The buggy code
is present in all stable trees, the fix is surgical, and the risk is
minimal. Build tool fixes are important for stable because users need to
be able to compile their kernels.

## Verification

- [Phase 1] Parsed tags: Reported-by: Arnd Bergmann, Closes: lore link,
  Link: patch link, SOB: Josh Poimboeuf (objtool maintainer)
- [Phase 1] Subject: "Fix" verb, objtool subsystem, Clang jump table
  detection
- [Phase 1] Commit body: describes conditional forward jump between jump
  table load and indirect branch in Clang output
- [Phase 2] Diff: removes `insn->type == INSN_JUMP_UNCONDITIONAL` and
  `insn->offset > last->offset` from one if-statement in
  `mark_func_jump_tables()`, updates comment
- [Phase 3] git blame: buggy code introduced in `99ce7962d52d` (Peter
  Zijlstra, 2018-02-08), present in all stable trees
- [Phase 3] git show 99ce7962d52d: confirmed original commit added the
  overly-restrictive INSN_JUMP_UNCONDITIONAL check
- [Phase 3] Author check: Josh Poimboeuf is the objtool maintainer with
  10+ recent objtool commits
- [Phase 3] Series: This is 1/3 but patches 2 and 3 are unrelated
  subsystems (ASoC, IIO) — standalone
- [Phase 4] Lore: Patch merged via objtool/urgent track, no NAKs or
  concerns
- [Phase 4] Bug report: Arnd Bergmann reported multiple objtool warnings
  with Clang builds
- [Phase 5] Callers: `mark_func_jump_tables()` called from
  `add_jump_table_alts()` during objtool analysis; `first_jump_src` used
  in `find_jump_table()` backward search
- [Phase 6] Verified buggy code exists identically in v6.1 and v6.6
  stable trees — patch applies to the changed lines
- [Phase 6] Related commit ef753d66051ca is another Clang jump table
  fix, but for a different issue (consecutive jump table ordering)
- [Phase 7] Subsystem: objtool, IMPORTANT criticality (build tool used
  by all Clang builds)
- [Phase 8] Trigger: building kernel with Clang + BPF enabled (common);
  Severity: MEDIUM-HIGH (build warning/failure)
- [Phase 8] Risk: very low (2 conditions removed, more inclusive
  matching, authored by maintainer)

**YES**

 tools/objtool/check.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index eba35bb8c0bdf..8687991215d63 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2144,12 +2144,11 @@ static void mark_func_jump_tables(struct objtool_file *file,
 			last = insn;
 
 		/*
-		 * Store back-pointers for unconditional forward jumps such
+		 * Store back-pointers for forward jumps such
 		 * that find_jump_table() can back-track using those and
 		 * avoid some potentially confusing code.
 		 */
-		if (insn->type == INSN_JUMP_UNCONDITIONAL && insn->jump_dest &&
-		    insn->offset > last->offset &&
+		if (insn->jump_dest &&
 		    insn->jump_dest->offset > insn->offset &&
 		    !insn->jump_dest->first_jump_src) {
 
-- 
2.51.0

