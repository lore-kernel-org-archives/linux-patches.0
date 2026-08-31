Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97644B127F;
	Mon, 31 Aug 2026 13:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184239; cv=none; b=T0Ux/cvm4e3fDGtQDPVsEmDHM1GdcxVM36Ed7ZXC1bf32SR8VCjifEuwnnBzqRa+Hq4XrplGfDTV0zuwFfbkZ0UezW4WxPPJ2uUJYedFcuOI/frRNbKJOItyhGjXrKDwFb8VzmLvIRfH6NPzCWNZnG+py6JLYaalkAIWHtwiYvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184239; c=relaxed/simple;
	bh=DdorWQK8zY5n0ULJKXec3yDgAepE/76fqNCOtSqkwgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OnP+RIbYDDEg1oU2Z3SJmvmBPcCWlC7jlfuNABvcZ8oa9zEdhw8QhYBhOG/9r6M6KayWUNrJNhU9irvm17z1DPcZOjLrYib2an6m9HgKOKmrwQNbPpd9xRb5ITcYlRhVaODpIVCAW5hL86bx+1hnV8lorkNqWZOmDek9l2z8IYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kyZDSMoZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kyZDSMoZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18BE1F00ACA;
	Mon, 31 Aug 2026 13:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184236;
	bh=KWm48LSQm398uOJ1rgE0wfUXzw1hcmIL3hKuUF1xDPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kyZDSMoZ5cpHkFYAC2DLUZ6i7HfFJ2bN2oAF2SnPbK1hA+/G51JSddUXr65Ktm2AU
	 Cp3jS4KybSy5dsWmcb3LhWvaf94oOVFl3GWEjYFf6aaROrcHeBI+ZSs0qFPYMpEqoZ
	 kGcVuHoG8GFs3n+6kpDoeEAtYUwsHnZFSSD08+ZflmmBiv2BTBtZfhbogYy+xKkx41
	 4O4jwngaI4lLXV16mTT/30mf/WQmPlX2WHZjcnjFGCTw6WfwNuWkycZcyd1sAdgsuW
	 gjdv7chXP876bZAYGPR6OFlA7JySIrqMZ1SdvItGgx3Za7lDLwMniGwSAwLT2Rg/uR
	 ZbeeBe1HGwo7w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ring-buffer: Skip invalid sub-buffers when rewinding persistent ring buffer
Date: Mon, 31 Aug 2026 09:30:01 -0400
Message-ID: <20260831133314.4125787-573-sashal@kernel.org>
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

From: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>

[ Upstream commit c8a7d4b4723a21e7464efe86dcf80627e0b4df33 ]

Skip invalid sub-buffers when rewinding the persistent ring buffer
instead of stopping the rewinding the ring buffer. The skipped
buffers are cleared.

To ensure the rewinding stops at the unused page, this also clears
buffer_data_page::time_stamp when tracing resets the buffer. This
allows us to identify unused pages and empty pages.

Link: https://patch.msgid.link/20260522171051.091265852@kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
[ SDR: Have reader_page still get evaluated if header_page fails ]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `ring-buffer: Skip invalid sub-buffers when
rewinding persistent ring buffer`

**Local tree:** `v6.18.44` (Linux 6.18.44, `stable/linux-6.18.y`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[ring-buffer]` `[skip]` — When rewinding a persistent ring
buffer across reboot, skip (and clear) invalid sub-buffers instead of
stopping the rewind early.

### Step 1.2: Tags
**Record:**
- **Link:** https://patch.msgid.link/20260522171051.091265852@kernel.org
- **Signed-off-by:** Masami Hiramatsu (Google), Steven Rostedt
- **No** Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or
  Cc: stable in the commit message
- **Notable:** Patch 2/9 in the v21 series “Making persistent ring
  buffers robust”; Steven Rostedt note: “Have reader_page still get
  evaluated if header_page fails”

### Step 1.3: Body analysis
**Record:**
- **Bug:** During persistent ring-buffer rewind after reboot, hitting an
  invalid sub-buffer stops the rewind loop.
- **Symptom:** Valid older trace data in earlier sub-buffers is not
  recovered; only data up to the first invalid page is kept.
- **Root cause (author):** Rewind treated invalid pages as a hard stop;
  unused pages were not reliably identifiable because `time_stamp` was
  not cleared on buffer reset.
- **Fix approach:** Continue rewinding past invalid pages (clearing
  them), use timestamp boundaries for validation, and clear
  `buffer_data_page::time_stamp` in `rb_init_page()`.

### Step 1.4: Hidden bug fix?
**Record:** Yes — described as robustness, but it fixes incorrect
recovery behavior: premature rewind termination and loss of readable
trace events after partial buffer corruption (e.g. unsynchronized cache
across reboot).

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `kernel/trace/ring_buffer.c` only (~69 insertions, ~38
  deletions)
- **Functions modified:** `rb_init_page()`, `rb_validate_buffer()`,
  `rb_meta_validate_events()`
- **Scope:** Single-file, focused change in persistent-buffer
  validation/rewind path

### Step 2.2: Code flow changes
**Record:**
| Hunk | Before | After |
|------|--------|-------|
| `rb_init_page()` | Clears only `commit` | Also clears `time_stamp` |
| `rb_validate_buffer()` | Validates commit size + event walk | Adds
`prev_ts`/`next_ts` bounds; clears invalid pages; sets `entries` |
| Rewind loop | `break` on invalid page | Skip invalid pages, increment
`discarded`, continue |
| Head page handling | Reader validated first | Head validated first;
rewind skipped only if head invalid |
| Unused-page detection | Timestamp/commit heuristics | Stop when
`!time_stamp && commit == 0` |
| Invalid path cleanup | Manual commit clears | Uses `rb_init_page()` |

### Step 2.3: Bug mechanism
**Record:** **Logic/correctness fix** in persistent ring-buffer
recovery. Invalid sub-buffer during rewind caused early loop exit
(`break`), leaving older valid pages unrecovered. Timestamp clearing and
boundary checks improve detection of unused/corrupt pages.

### Step 2.4: Fix quality
**Record:** Fix is logically sound and minimal for its scope. Low
regression risk: only affects persistent ring-buffer recovery at boot.
Timestamp clearing on reset is consistent with identifying unused pages.
**Caveat:** Builds on refactored `rb_validate_buffer()` from
prerequisite commit `eb3bd277b37cd`.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Rewind loop with `break` on invalid page introduced by
`ca296d32ece38` (“tracing: ring_buffer: Rewind persistent ring buffer on
reboot”, 2025-06-04). That commit **is in this tree** (6.18.y). Base
validation infrastructure from `5f3b6e839f3ce` (“Validate boot range
memory events”, 2024-06-12), also in tree.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related file history
**Record:** Stable 6.18.y already has persistent ring-buffer fixes:
- `ca296d32ece38` — rewind on reboot (introduces bug)
- `b6925774dd15d` — per-subbuf entries fix (backported)
- `2bc60c175568e` — flush on panic (backported)
- `6b4bf6519e507` — reader_page double-count fix (backported)

**Missing from stable (on master):**
- `eb3bd277b37cd` — skip invalid sub-buffers when **validating** (patch
  1/9, prerequisite)
- `c8a7d4b4723a2` — this commit (patch 2/9)

Part of v21 series “Making persistent ring buffers robust”; not
standalone.

### Step 3.4: Author context
**Record:** Masami Hiramatsu and Steven Rostedt are tracing/ring-buffer
maintainers. Multiple related persistent ring-buffer commits in the same
timeframe.

### Step 3.5: Dependencies
**Record:**
- **Requires** `eb3bd277b37cd` (changes `rb_validate_buffer()` signature
  and per-sub-buffer discard logic).
- `c8a7d4b4723a2` alone: **merge conflict** on stable.
- `eb3bd277b37cd` then `c8a7d4b4723a2`: **both apply cleanly** (verified
  via cherry-pick).
- Does not require later series patches (tests, display, cleanup) for
  core fix.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **b4 dig URL:**
  https://patch.msgid.link/20260522171051.091265852@kernel.org
- **Series:** v19 → v20 → v21; committed version matches v21 patch 2/9
- **Cover letter (v21 0/9):** “make the persistent ring buffer more
  robust when sub-buffers are detected to be corrupted. Instead of
  invalidating the entire buffer, just invalidate the individual sub-
  buffers.”

### Step 4.2: Reviewers
**Record:** CC’d: linux-kernel, linux-trace-kernel, Masami Hiramatsu,
Mark Rutland, Mathieu Desnoyers, Andrew Morton, Ian Rogers. Reviewed-by
Masami Hiramatsu on a related thread message in mbox.

### Step 4.3: Bug report
**Record:** No syzbot/user bug report. Issue inferred from persistent-
buffer corruption scenario in companion patch `eb3bd277b37cd`: “cache
data in memory fails to be synchronized during a reboot.”

### Step 4.4: Related patches
**Record:** Same series includes validation skip (`eb3bd`), inject test,
dropped-events display, validation cleanup. Validation + rewind skip are
the core functional pair.

### Step 4.5: Stable list history
**Record:** No Cc: stable or stable-list discussion found in retrieved
mbox thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `rb_init_page()`, `rb_validate_buffer()`,
`rb_meta_validate_events()`

### Step 5.2: Callers
**Record:** `rb_meta_validate_events()` called from
`rb_allocate_cpu_buffer()` at line 2399 during CPU ring-buffer
allocation when persistent/range-mapped meta is present.

### Step 5.3: Callees
**Record:** `rb_read_data_buffer()`, `rb_page_commit()`,
`rb_page_size()`, `rb_dec_page()`/`rb_inc_page()`, `local_set()`.

### Step 5.4: Reachability
**Record:** Triggered at **boot** during ring-buffer init for
**reserve_mem / range-mapped persistent** trace buffers with valid meta
from a previous boot. Not a syscall hot path; requires tracing admin
setup. Not unprivileged.

### Step 5.5: Similar patterns
**Record:** Stable tree still has related bugs:
- Rewind: `break` on invalid page (lines 1932–1935)
- Validation: `goto invalid` resets entire buffer on any invalid page
  (lines 1899–1901, 2013–2016)

`eb3bd277b37cd` addresses validation; this commit addresses rewind.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current stable code at lines 1932–1935:

```1932:1935:kernel/trace/ring_buffer.c
                /* Stop rewind if the page is invalid. */
                ret = rb_validate_buffer(head_page->page,
cpu_buffer->cpu);
                if (ret < 0)
                        break;
```

Bug introduced with rewind feature in `ca296d32ece38`, which is in
6.18.y.

### Step 6.2: Backport complications
**Record:** This commit alone does **not** apply cleanly (content
conflict). With prerequisite `eb3bd277b37cd` first, both apply cleanly.
Expect minor context differences vs mainline but no structural blocker.

### Step 6.3: Related fixes already present?
**Record:** No equivalent skip-on-invalid rewind or per-sub-buffer
validation discard logic in 6.18.44.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **kernel/trace** (ring buffer) — **IMPORTANT** for
tracing/debugging; not core MM/net, but persistent buffers target
crash/post-mortem analysis.

### Step 7.2: Activity
**Record:** Actively maintained; several persistent ring-buffer fixes
already backported to 6.18.y.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Users of **persistent/reserve_mem ring buffers** who reboot
after unclean shutdown or partial memory corruption. Config-specific,
admin-configured.

### Step 8.2: Trigger conditions
**Record:** Boot with persistent trace buffer meta from previous boot +
at least one invalid sub-buffer during rewind. Most likely after
crash/unclean reboot with unsynced buffer memory. Uncommon but realistic
for the feature’s purpose.

### Step 8.3: Failure severity
**Record:** **Loss of recoverable trace events** (diagnostic data), not
kernel crash/panic/deadlock. Severity: **MEDIUM** for persistent-tracing
users; **LOW** for others.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** MEDIUM — restores trace data that would otherwise be
  discarded during rewind
- **Risk:** LOW — boot-time recovery path only; small, maintainer-
  authored change
- **Ratio:** Favorable when paired with `eb3bd277b37cd`

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real bug in shipped 6.18.y feature (persistent ring-buffer rewind)
- Loses valid trace data on partial corruption — the scenario persistent
  buffers are meant to survive
- Small, surgical, maintainer-reviewed
- Applies cleanly with prerequisite `eb3bd277b37cd` (also clean)
- Related persistent ring-buffer fixes already in 6.18.y
- Part of intentional robustness series

**AGAINST backport:**
- Not a kernel crash/security/deadlock
- Niche feature (reserve_mem persistent tracing)
- Requires prerequisite commit not yet in stable
- No explicit Cc: stable or user/syzbot report
- Patch 2/9 of a series

**Unresolved:** No runtime test results in commit message; no explicit
stable nomination.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** (logic clear; maintainer
   authorship; no test tag)
2. Fixes real bug affecting users? **PASS** (persistent tracing users
   lose recoverable data)
3. Important issue? **PASS (borderline)** — diagnostic data loss in
   crash-recovery path, not kernel instability
4. Small and contained? **PASS** (~107 lines, one file)
5. No new features/APIs? **PASS** (fixes recovery behavior)
6. Can apply to local tree? **PASS with dependency** — needs
   `eb3bd277b37cd` first; then applies cleanly

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs).

### Step 9.4: Decision rationale

This commit fixes a real correctness bug in persistent ring-buffer
rewind that exists in 6.18.44. When an invalid sub-buffer is encountered
during rewind after reboot, the current code stops early and fails to
recover older valid trace pages. That undermines the purpose of
persistent tracing across reboots, especially after crashes with partial
memory corruption.

The fix is small, maintainer-authored, and backports cleanly together
with its immediate prerequisite `eb3bd277b37cd` (which fixes the
analogous “discard everything” problem in the validation path). Stable
6.18.y already carries the rewind feature and other persistent ring-
buffer fixes; this pair completes that robustness work.

**Backport recommendation:** Apply `eb3bd277b37cd` first, then
`c8a7d4b4723a2`.

---

## Verification

- [Phase 1] `git show c8a7d4b4723a2 -s`: parsed subject, body, Link,
  Signed-off-by tags
- [Phase 1] No Fixes:/Reported-by:/Cc: stable in commit message
- [Phase 2] `git show c8a7d4b4723a2 --stat`: 1 file, +69/-38 lines
- [Phase 3] `git describe HEAD`: v6.18.44
- [Phase 3] `git blame -L 1930,1936 kernel/trace/ring_buffer.c`: rewind
  logic from `ca296d32ece38`
- [Phase 3] `git merge-base --is-ancestor ca296d32ece38 HEAD`: rewind
  commit in tree
- [Phase 3] `git log stable/linux-6.18.y --grep='Skip invalid sub-
  buffers'`: no matches — fix not in stable
- [Phase 3] `git log stable/linux-6.18.y..master --
  kernel/trace/ring_buffer.c | grep -iE 'invalid|rewind'`: both commits
  missing from stable
- [Phase 4] `b4 dig -c c8a7d4b4723a2`: lore URL found
- [Phase 4] `b4 dig -c c8a7d4b4723a2 -a`: v19/v20/v21 series revisions
- [Phase 4] `b4 dig -c c8a7d4b4723a2 -w`: maintainers CC’d
- [Phase 4] `grep` on `/tmp/ringbuf_thread.mbox`: cover letter describes
  corruption robustness; no Cc: stable
- [Phase 5] `grep rb_meta_validate_events`: caller at line 2399 in
  `rb_allocate_cpu_buffer()`
- [Phase 6] Read `kernel/trace/ring_buffer.c` lines 1870–2057: buggy
  rewind `break` confirmed
- [Phase 6] `git cherry-pick --no-commit c8a7d4b4723a2`: **CONFLICT**
- [Phase 6] `git cherry-pick --no-commit eb3bd277b37cd && git cherry-
  pick --no-commit c8a7d4b4723a2`: **both succeeded** (exit 0)
- [Phase 6] `git reset --hard HEAD`: tree restored to v6.18.44
- [Phase 7] `git log --oneline -10 -- kernel/trace/ring_buffer.c`:
  active persistent ring-buffer maintenance
- [Phase 8] Failure mode verified from code: premature rewind stop →
  trace data not recovered; severity MEDIUM

**YES**

 kernel/trace/ring_buffer.c | 107 ++++++++++++++++++++++++-------------
 1 file changed, 69 insertions(+), 38 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 631d42281f5b3..cb35aef4c47bd 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -389,6 +389,7 @@ struct buffer_page {
 static void rb_init_page(struct buffer_data_page *bpage)
 {
 	local_set(&bpage->commit, 0);
+	bpage->time_stamp = 0;
 }
 
 static __always_inline unsigned int rb_page_commit(struct buffer_page *bpage)
@@ -1872,12 +1873,14 @@ static int rb_read_data_buffer(struct buffer_data_page *dpage, int tail, int cpu
 	return events;
 }
 
-static int rb_validate_buffer(struct buffer_data_page *dpage, int cpu,
-			      struct ring_buffer_cpu_meta *meta)
+static int rb_validate_buffer(struct buffer_page *bpage, int cpu,
+			      struct ring_buffer_cpu_meta *meta, u64 prev_ts, u64 next_ts)
 {
+	struct buffer_data_page *dpage = bpage->page;
 	unsigned long long ts;
 	unsigned long tail;
 	u64 delta;
+	int ret;
 
 	/*
 	 * When a sub-buffer is recovered from a read, the commit value may
@@ -1886,9 +1889,27 @@ static int rb_validate_buffer(struct buffer_data_page *dpage, int cpu,
 	 * subbuf_size is considered invalid.
 	 */
 	tail = local_read(&dpage->commit) & ~RB_MISSED_MASK;
-	if (tail > meta->subbuf_size - BUF_PAGE_HDR_SIZE)
-		return -1;
-	return rb_read_data_buffer(dpage, tail, cpu, &ts, &delta);
+	if (tail <= meta->subbuf_size - BUF_PAGE_HDR_SIZE)
+		ret = rb_read_data_buffer(dpage, tail, cpu, &ts, &delta);
+	else
+		ret = -1;
+
+	/*
+	 * The timestamp must be greater than @prev_ts and smaller than @next_ts.
+	 * Since this function works in both forward (verify) and reverse (unwind)
+	 * loop, we don't know both @prev_ts and @next_ts at the same time.
+	 * So use the known boundary as the boundary.
+	 */
+	if (ret < 0 || (prev_ts && prev_ts > ts) || (next_ts && ts > next_ts)) {
+		local_set(&bpage->entries, 0);
+		local_set(&dpage->commit, 0);
+		dpage->time_stamp = prev_ts ? prev_ts : next_ts;
+		ret = -1;
+	} else {
+		local_set(&bpage->entries, ret);
+	}
+
+	return ret;
 }
 
 /* If the meta data has been validated, now validate the events */
@@ -1899,6 +1920,7 @@ static void rb_meta_validate_events(struct ring_buffer_per_cpu *cpu_buffer)
 	unsigned long entry_bytes = 0;
 	unsigned long entries = 0;
 	int discarded = 0;
+	bool skip = false;
 	int ret;
 	u64 ts;
 	int i;
@@ -1909,25 +1931,35 @@ static void rb_meta_validate_events(struct ring_buffer_per_cpu *cpu_buffer)
 	orig_head = head_page = cpu_buffer->head_page;
 	orig_reader = cpu_buffer->reader_page;
 
-	/* Do the reader page first */
-	ret = rb_validate_buffer(orig_reader->page, cpu_buffer->cpu, meta);
+	/* Do the head page first */
+	ret = rb_validate_buffer(head_page, cpu_buffer->cpu, meta, 0, 0);
+	if (ret < 0) {
+		pr_info("Ring buffer meta [%d] invalid head page detected\n",
+			cpu_buffer->cpu);
+		/* Don't bother rewinding */
+		skip = true;
+		ts = 0;
+	} else {
+		ts = head_page->page->time_stamp;
+	}
+
+	/* Do the reader page - reader must be previous to head. */
+	ret = rb_validate_buffer(orig_reader, cpu_buffer->cpu, meta, 0, ts);
 	if (ret < 0) {
 		pr_info("Ring buffer meta [%d] invalid reader page detected\n",
 			cpu_buffer->cpu);
 		discarded++;
-		/* Instead of discard whole ring buffer, discard only this sub-buffer. */
-		local_set(&orig_reader->entries, 0);
-		local_set(&orig_reader->page->commit, 0);
 	} else {
 		entries += ret;
 		entry_bytes += rb_page_size(orig_reader);
-		local_set(&orig_reader->entries, ret);
+		ts = orig_reader->page->time_stamp;
 	}
 
-	ts = head_page->page->time_stamp;
+	if (skip)
+		goto skip_rewind;
 
 	/*
-	 * Try to rewind the head so that we can read the pages which already
+	 * Try to rewind the head so that we can read the pages which are already
 	 * read in the previous boot.
 	 */
 	if (head_page == cpu_buffer->tail_page)
@@ -1940,26 +1972,27 @@ static void rb_meta_validate_events(struct ring_buffer_per_cpu *cpu_buffer)
 		if (head_page == cpu_buffer->tail_page)
 			break;
 
-		/* Ensure the page has older data than head. */
-		if (ts < head_page->page->time_stamp)
+		/* Rewind until unused page (no timestamp, no commit). */
+		if (!head_page->page->time_stamp && rb_page_commit(head_page) == 0)
 			break;
 
-		ts = head_page->page->time_stamp;
-		/* Ensure the page has correct timestamp and some data. */
-		if (!ts || rb_page_commit(head_page) == 0)
-			break;
-
-		/* Stop rewind if the page is invalid. */
-		ret = rb_validate_buffer(head_page->page, cpu_buffer->cpu, meta);
-		if (ret < 0)
-			break;
-
-		/* Recover the number of entries and update stats. */
-		local_set(&head_page->entries, ret);
-		if (ret)
-			local_inc(&cpu_buffer->pages_touched);
-		entries += ret;
-		entry_bytes += rb_page_size(head_page);
+		/*
+		 * Skip if the page is invalid, or its timestamp is newer than the
+		 * previous valid page.
+		 */
+		ret = rb_validate_buffer(head_page, cpu_buffer->cpu, meta, 0, ts);
+		if (ret < 0) {
+			if (!discarded)
+				pr_info("Ring buffer meta [%d] invalid buffer page detected\n",
+					cpu_buffer->cpu);
+			discarded++;
+		} else {
+			entries += ret;
+			entry_bytes += rb_page_size(head_page);
+			if (ret > 0)
+				local_inc(&cpu_buffer->pages_touched);
+			ts = head_page->page->time_stamp;
+		}
 	}
 	if (i)
 		pr_info("Ring buffer [%d] rewound %d pages\n", cpu_buffer->cpu, i);
@@ -2021,6 +2054,7 @@ static void rb_meta_validate_events(struct ring_buffer_per_cpu *cpu_buffer)
 		/* Nothing more to do, the only page is the reader page */
 		goto done;
 	}
+	ts = head_page->page->time_stamp;
 
 	/* Iterate until finding the commit page */
 	for (i = 0; i < meta->nr_subbufs + 1; i++, rb_inc_page(&head_page)) {
@@ -2029,15 +2063,12 @@ static void rb_meta_validate_events(struct ring_buffer_per_cpu *cpu_buffer)
 		if (head_page == orig_reader)
 			continue;
 
-		ret = rb_validate_buffer(head_page->page, cpu_buffer->cpu, meta);
+		ret = rb_validate_buffer(head_page, cpu_buffer->cpu, meta, ts, 0);
 		if (ret < 0) {
 			if (!discarded)
 				pr_info("Ring buffer meta [%d] invalid buffer page detected\n",
 					cpu_buffer->cpu);
 			discarded++;
-			/* Instead of discard whole ring buffer, discard only this sub-buffer. */
-			local_set(&head_page->entries, 0);
-			local_set(&head_page->page->commit, 0);
 		} else {
 			/* If the buffer has content, update pages_touched */
 			if (ret)
@@ -2045,7 +2076,7 @@ static void rb_meta_validate_events(struct ring_buffer_per_cpu *cpu_buffer)
 
 			entries += ret;
 			entry_bytes += rb_page_size(head_page);
-			local_set(&head_page->entries, ret);
+			ts = head_page->page->time_stamp;
 		}
 		if (head_page == cpu_buffer->commit_page)
 			break;
@@ -2073,12 +2104,12 @@ static void rb_meta_validate_events(struct ring_buffer_per_cpu *cpu_buffer)
 
 	/* Reset the reader page */
 	local_set(&cpu_buffer->reader_page->entries, 0);
-	local_set(&cpu_buffer->reader_page->page->commit, 0);
+	rb_init_page(cpu_buffer->reader_page->page);
 
 	/* Reset all the subbuffers */
 	for (i = 0; i < meta->nr_subbufs - 1; i++, rb_inc_page(&head_page)) {
 		local_set(&head_page->entries, 0);
-		local_set(&head_page->page->commit, 0);
+		rb_init_page(head_page->page);
 	}
 }
 
-- 
2.53.0

