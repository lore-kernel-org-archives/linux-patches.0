Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0678C52F849;
	Mon, 19 Oct 2026 13:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418388; cv=none; b=MNWdHpz2xCMvnljQuzPWmrpPHA9PgZM/utSxMIoe/nKwxEe2LpxneR4jbmKzQ4szUD5zckB0ssSqL6LG/HCLhfxlNSJhrx2D+diB05rV5yDK3I3nEX1tgHD/bW1WoqparMCYOnIhEcT2i2Oqpk6qhg55v0N+3vPfe5wKfxFSXV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418388; c=relaxed/simple;
	bh=q4Kwr21DP2sbCnW/Ls1zpcfgGb54QCiTQ8IzQOgJZYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QFuuOq+bFx4U3l8FqbOnC4qZxXq3H8yrHlyScTEkgGIdcwmi/0AoQmXXIRWGGcBuKloXjhjAjW+aNs3EpDzCO1jAX7dMdNfZZA+/qgRgFUhPByae7o2nK/m06JAC7cv/Sx/3uRRonr0WJzmuYsQSfwqOULfVzfs2SbifXz51WQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cQtdEHYA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cQtdEHYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28EBE1F000C6;
	Mon, 19 Oct 2026 13:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418385;
	bh=aadi2K92DwERhOn4Fk0o1ulK5sm4tl7p50s/tBdXtHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cQtdEHYAzmjqs0rc1BNACaVeZ7RMQg1DM5Rzm+Uz5CN184czaqbWFB/BlJKD88c9N
	 fQRFxHny3nrGtDOBzIAFltmooKtThy6QJ7Bab2oCvrw5wycC6XJUGFFG2BWy9tbskB
	 Pe8tnrITIqmd6Z7uC1dDWzjtv6ZwgaspRg1L7Piv/AONZQL1eKx7Oy8pQVpxqWuIvR
	 NBFkPduVjjjjIbHV7O+tzqJjkgTXbD5JFvEX122Ajd1W7+pU4v8A2nN5skU56g+x8d
	 VFt98M1BjeK5113vb7E7+EUsQQemfubVdVXUm4cu9ly+fy67OAQ4dLD0uw4DIRC+8j
	 qiuwW7+s+E7pA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namhyung Kim <namhyung@kernel.org>,
	Sashiko Review <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] tools/lib/api: Fix potential double-free from fdarray__grow()
Date: Mon, 19 Oct 2026 09:48:23 -0400
Message-ID: <20261019135441.1420968-212-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit eadce0f46a1d066b812c7e5aa46a33711c78a755 ]

If the realloc for fda->entries succeeds but the realloc for fda->priv
fails, the error path frees the newly allocated entries.

However, fda->entries is neither updated to point to the new entries block
nor cleared to NULL. If realloc moved the allocation to a new block, the
old fda->entries pointer is now freed memory.

When fdarray__exit() is later called to clean up, it executes
free(fda->entries), which would trigger a double-free on that old pointer.

Reported-by: Sashiko Review <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-perf-users/20260710200150.11FE71F00A3A@smtp.kernel.org
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is mainline **v7.3-rc4**. The change is a real `realloc`
double-free in `perf`/`libperf` userspace, present since v3.18, and it
is small enough to meet the stable rules.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[tools/lib/api] [fix] [prevent double-free in fdarray__grow()
on partial realloc failure]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Reported-by: Sashiko Review <sashiko-bot@kernel.org>` — AI static
  review, not a user crash
- `Closes: https://lore.kernel.org/linux-perf-
  users/20260710200150.11FE71F00A3A@smtp.kernel.org`
- `Reviewed-by: Ian Rogers <irogers@google.com>` — perf tools reviewer
- `Signed-off-by: Namhyung Kim <namhyung@kernel.org>` — perf tools
  maintainer (author and committer)
- No `Fixes:` tag (expected)
- No `Cc: stable` (expected)
- Ignore any pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit
  ...]` markers — none on the real commit

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** In `fdarray__grow()`, `realloc(fda->entries)` can succeed and
  `realloc(fda->priv)` can fail. The old error path `free(entries)`
  without updating `fda->entries`.
- **Symptom:** If `realloc` moved the block, `fda->entries` still points
  at the old (already freed) pointer. Later `fdarray__exit()` does
  `free(fda->entries)` → **double-free**.
- **Version info:** none in the message. Git shows the two-`realloc`
  pattern since **v3.18-rc1**.
- **Root cause:** classic partial-`realloc` handling: new pointer
  discarded, struct left holding a dangling pointer.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised. Explicit double-free fix. The `fdarray__new()`
`free(fda)` → `fdarray__delete(fda)` change is the matching leak fix
once `fda->entries` is kept on failure.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `tools/lib/api/fd/array.c` — **+3 / −2** (net +1), 5 lines
  touched
- Functions: `fdarray__grow()`, `fdarray__new()`
- Scope: **single-file surgical fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Hunk 1 (`fdarray__grow` error path): **before** `free(entries)` and
  return `-ENOMEM`, leaving `fda->entries` stale. **after** assign
  `fda->entries = entries` and return `-ENOMEM`, so `fdarray__exit()`
  frees the live block once.
- Hunk 2 (`fdarray__new`): **before** `free(fda)` on grow failure,
  leaking the entries block after hunk 1. **after**
  `fdarray__delete(fda)` which runs `fdarray__exit()` then `free(fda)`.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** double-free (and a companion leak on `fdarray__new`)
- **Mechanism:** two-step `realloc`. `sizeof(struct priv)` is larger
  than `sizeof(struct pollfd)` (pointer + flags vs 8-byte `pollfd`), so
  `psize` is larger than `size`. Entries can grow while priv allocation
  fails under memory pressure. Callers then `fdarray__exit()`.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct `realloc` handling: if the first `realloc` moved the
  block, the old pointer is already invalid and **must** be replaced.
- Clearing `fda->entries` to NULL (what the bot suggested) would leak
  the new block and leave `fda->nr > 0` with a NULL array.
- Minimal, no API/`struct fdarray` change. `fdarray__delete()` has
  existed since 2014.
- Regression risk: **very low**. Error path only. On failure, extra
  unused entries capacity may remain (`nr_alloc` unchanged); that is
  harmless.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- `free(entries)` on priv failure introduced in **`2171a9256862ec`**
  (“tools lib fd array: Allow associating an integer cookie with each
  entry”), Arnaldo, 2014-09-25.
- First appeared in **v3.18-rc1**.
- `fdarray` itself: **`1b85337d0685d`** (same merge window).

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. The introducing commit is `2171a9256862ec`,
ancestor of this tree (`git merge-base --is-ancestor` exit 0).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Later fdarray work (flags, duplicate, poll-storm, hang) does not
replace this error path. No follow-up after `eadce0f46a1d0`. Standalone,
not `N/M`.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Namhyung Kim is a **PERFORMANCE EVENTS SUBSYSTEM** maintainer.
Ian Rogers is a listed reviewer. Author applied it to perf-tools-next.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None. Uses existing `fdarray__delete()` / `fdarray__exit()`. Can
apply standalone to any tree that still has the two-`realloc` grow path.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c eadce0f46a1d0` →
  https://patch.msgid.link/20260711003235.1963043-1-namhyung@kernel.org
- v1: `[PATCH v1] lib/api/fd: Fix potential double-free from
  fdarray__grow()` (2026-07-10)
- v2: subject-only (`tools/lib/api:`); **no code change**
- Ian Rogers: `Reviewed-by` (2026-07-15)
- Namhyung: “Applied to perf-tools-next, thanks!” (2026-07-16)
- No NAKs, no `Cc: stable` in review, no reviewer risk flags

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): Namhyung, Arnaldo, Ian Rogers, Jiri Olsa, Adrian
Hunter, James Clark, Peter Zijlstra, Ingo Molnar, LKML, linux-perf-
users, Sashiko. Right maintainer set.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: Sashiko flagged a **High** pre-existing issue on another fdarray
patch. Namhyung replied “I'll handle this in a separate patch.” No user
repro, syzbot, or bugzilla. Bug is from code inspection, not a field
crash.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone. Separate from the `fdarray__filter()` nonfilterable
fix that triggered the review.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: **UNVERIFIED** (lore.kernel.org HTTP 403). The v2 mbox has no
stable discussion.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `fdarray__grow()`, `fdarray__new()`. Cleanup via
`fdarray__exit()` / `fdarray__delete()`.

**Step 5.2: TRACE CALLERS**
Record (grep on this tree):
- `fdarray__grow`: `fdarray__new`, `fdarray__add`,
  `perf_evlist__alloc_pollfd`
- `fdarray__add`: `perf_evlist__add_pollfd`, `builtin-record.c` (per-
  thread pollfd), `builtin-daemon.c`, `fdarray__dup_entry_from`, tests
- `fdarray__exit` on those objects: `perf_evlist__exit`, `record` thread
  teardown (`fdarray__exit(&thread_data[t].pollfd)`), daemon `goto out`
  → `fdarray__exit(&fda)`

**Step 5.3: TRACE CALLEES**
Record: `realloc`, `memset`, `calloc`, `free`. No locks, no kernel
allocators.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace `perf` / libperf. Typical path: `perf record` mmap →
`perf_evlist__alloc_pollfd` → `fdarray__grow`. On `-ENOMEM`,
evlist/thread/daemon cleanup calls `fdarray__exit`. **Reachable from a
normal perf invocation under memory pressure**, not a kernel syscall
path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Only this grow function does the paired `entries`/`priv`
realloc. No sibling copy of the bug.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- `git describe HEAD`: **v7.3-rc4-27-gf0100363d8c37**
- `make kernelversion`: **7.3.0-rc4** (Linus mainline, `origin` =
  torvalds/linux.git)
- Fix commit **`eadce0f46a1d0` is already an ancestor of HEAD**
- Buggy two-`realloc` body exists in history from v3.18; current file
  already has the fix
- Introduced long before this tree

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply** to any tree with this `fdarray__grow` shape.
Function has been stable aside from later `memset` of new slots. No
conflicting refactor in this file.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This is the fix. No earlier equivalent.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **tools/lib/api** used by **tools/perf** and **tools/lib/perf**.
Criticality: **IMPORTANT** for perf users, **not CORE kernel**.
Userspace heap corruption, not a kernel oops.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Active (recent poll-storm/hang fixes in the same file’s
callers). The grow error path itself dates to 2014 and was untouched
until this commit.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **config/tool-specific** — anyone running kernel-tree `perf` /
libperf (record, daemon, evlist polling). Distros ship this `perf`. Not
a kernel-wide crash.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record:
- Grow of an fdarray that already has (or just got) an entries
  allocation
- `realloc(entries)` succeeds, `realloc(priv)` fails
- Then `fdarray__exit()` (all production callers do this)
- Unprivileged `perf` can hit grow; failure needs allocation failure, so
  uncommon but not fictional (`priv` is the larger realloc)
- Not a timing race

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **Userspace double-free / heap corruption** of `perf` → abort or
allocator abort. Severity: **HIGH** for the tool, **not** a kernel
panic. Possible security angle only if `perf` is privileged; unverified
here.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** stops a real double-free on a cleanup path every grow-
  failure caller uses
- **Risk:** very low (5 lines, error path, maintainer-authored and
  reviewed)
- **Ratio:** favorable. Official “bothers people” bar is weaker (bot-
  found, no field report), but the defect is concrete, not a speculative
  race.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real double-free, not style
- Tiny, obviously correct
- Bug since v3.18; this tree has the code
- All major callers `fdarray__exit()` after `-ENOMEM`
- Partial failure is plausible because priv is larger than entries
- Reviewed by Ian Rogers; applied by Namhyung Kim
- No dependencies; clean apply
- Matches stable double-free / error-path pattern

AGAINST:
- Userspace tools, not kernel runtime
- Found by Sashiko, not a user
- Subject says “potential”; no `Fixes:`/`Cc: stable`
- Official rule: “real bug that bothers people” / not “this could be a
  problem”
- Trigger needs allocation failure

UNRESOLVED:
- Whether stable@ ever discussed it (lore HTTP 403)
- Whether any distro `perf` user hit it

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — realloc semantics;
   maintainer + reviewer
2. Fixes a real bug that affects users? **PASS** — double-free on grow-
   fail + exit; users are `perf` users
3. Important issue? **PASS** (HIGH userspace heap corruption; not a
   kernel oops)
4. Small and contained? **PASS** — 5 lines, one file
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — already present here; same
   hunk applies to older trees that still have this grow function

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None (not an ID/quirk/DT/build/doc exception). It is a normal
bug fix.

**Step 9.4: MAKE YOUR DECISION**
This tree is **7.3-rc4 mainline**, and the fix is already in it. The
evaluation is whether that fix is stable material for this codebase: it
is. Distros ship `tools/perf` from the kernel tree; a double-free on a
path every evlist/daemon/record teardown takes is a real crash of that
tool. The patch is too small and too localized to justify holding it
back because the finder was a bot or the trigger is OOM.

===============================================================
What the commit solves, and why it matters
===============================================================
`fdarray__grow()` grows two parallel allocations. On the second
`realloc` failing it used to `free()` the first result without storing
it, so `fda->entries` could dangle. `perf record`, libperf evlist, and
`perf daemon` all `fdarray__exit()` afterward, which is a double-free of
the process heap. Stable users who cannot bump the whole kernel still
use this `perf`.

Risk vs benefit: benefit is preventing heap corruption in a widely
shipped tool; risk is a 5-line error-path change already reviewed by the
subsystem.

No missing prerequisites. No backport rework needed for this `array.c`.

===============================================================
Verification
===============================================================
- [Phase 1] Tags: Sashiko Reported-by, Closes lore, Reviewed-by Ian
  Rogers, SOB Namhyung; no Fixes/Cc-stable
- [Phase 2] Diff: 5 lines in `tools/lib/api/fd/array.c`; `free(entries)`
  → keep pointer; `free(fda)` → `fdarray__delete(fda)`
- [Phase 3] `git blame` on parent: `free(entries)` from `2171a9256862ec`
  (v3.18-rc1)
- [Phase 3] `git merge-base --is-ancestor 2171a9256862ec HEAD` → yes;
  `eadce0f46a1d0` also ancestor
- [Phase 3] `git log --oneline eadce0f46a1d0..HEAD --
  tools/lib/api/fd/array.c` → empty (no follow-up)
- [Phase 4] `b4 dig -c eadce0f46a1d0`: v2 at
  patch.msgid.link/20260711003235.1963043-1-namhyung@kernel.org
- [Phase 4] `b4 dig -a`: v1→v2 subject-only; applied to perf-tools-next
- [Phase 4] `b4 dig -w`: perf maintainers on To/Cc
- [Phase 4] `b4 mbox` of Closes: Sashiko High pre-existing double-free;
  Namhyung “I'll handle this in a separate patch”
- [Phase 4] lore WebFetch/curl: 403 — stable@ search UNVERIFIED
- [Phase 5] grep callers: evlist, builtin-record, builtin-daemon, tests;
  all production paths `fdarray__exit`
- [Phase 6] `git describe HEAD`: v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion`: 7.3.0-rc4
- [Phase 6] Current `array.c` already contains the fixed grow/new bodies
- [Phase 7] MAINTAINERS: Namhyung maintainer, Ian Rogers reviewer of
  PERFORMANCE EVENTS SUBSYSTEM
- [Phase 8] Failure mode: userspace double-free in perf, HIGH for the
  tool
- UNVERIFIED: field reports; privileged-perf exploitability; stable@
  thread

**YES**

 tools/lib/api/fd/array.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/lib/api/fd/array.c b/tools/lib/api/fd/array.c
index f0f195207fca9..dcb396ab51eb1 100644
--- a/tools/lib/api/fd/array.c
+++ b/tools/lib/api/fd/array.c
@@ -31,7 +31,8 @@ int fdarray__grow(struct fdarray *fda, int nr)
 
 	priv = realloc(fda->priv, psize);
 	if (priv == NULL) {
-		free(entries);
+		/* this will be freed by fdarray__exit() */
+		fda->entries = entries;
 		return -ENOMEM;
 	}
 
@@ -50,7 +51,7 @@ struct fdarray *fdarray__new(int nr_alloc, int nr_autogrow)
 
 	if (fda != NULL) {
 		if (fdarray__grow(fda, nr_alloc)) {
-			free(fda);
+			fdarray__delete(fda);
 			fda = NULL;
 		} else {
 			fda->nr_autogrow = nr_autogrow;
-- 
2.53.0

