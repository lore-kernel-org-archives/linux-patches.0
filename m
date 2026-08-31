Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603724F55BE;
	Mon, 31 Aug 2026 13:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183670; cv=none; b=FlTy4+IDS6IMul9uFZJyAWGGuV5pbH6C1+Cqp5kgOknjeyKkm6BAnFsi3ubIVOk7hvMjqhLvdceq31GQfses0RokqIvIw9IdR+xRiN4ki7CMAauqjdljTwVmYBLi2y1rKZ01/xUQ/9xdSrSb0R59FLe8hdkIIvmu/3bV6xfbpoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183670; c=relaxed/simple;
	bh=lTg7mI8OB6U9ATpWBGgBlRVGHJV1ZEWD0zBQjH6zj0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VUIQsQCwzidc8Y4OJYolxJ6Q+Np4AWBOYJSSl2y2EJ8lMG7Fg7voAvxB2zNn8iwMoXAz6n15td12H6QCD06+YBYsW9fvB3JRT+g+kDigQq6E0SWS8EZVkok1SD+RzAEUFIR384yE8Si+GlM0yVe7HdPwjv7epD40COpQPK49knU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZxcXcS2B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZxcXcS2B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1801F00A3F;
	Mon, 31 Aug 2026 13:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183667;
	bh=X82KvuxOuoihP1bgpcO0E5p7eFFJ6u83+mvJZEfATUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZxcXcS2Bzw1ObY2/Mz8Jz7CRngUEPxvmicDhNmAJhHpYo6DSffz9KQfTO+SmGPXw6
	 uU1MGolttWdTLkIDDEXpj2FR+JVXgkBppHKYHqyYICeWBQWumlUF4jnY+l0wGlqRfY
	 X7dhLH/a1AU3Saz4rcfUS4UaDBicDUbMgl+FUkB++rwjUe3o+kYGyiOshu794T8Oed
	 yZQswY4YefyKkVYhrqwjKczyxrfThPEGgnyCm9kfmGumzbX7BgzoRlWhRhx0msV+er
	 /TnfWDNSpaj2VBYLDDgtWkRl1pGoIiDWwFQIBxUMnEguHgfZUrylBBlBe7k7SkdM5N
	 4KJS69l6kvyng==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ring-buffer: Skip invalid sub-buffers when validating persistent ring buffer
Date: Mon, 31 Aug 2026 09:24:20 -0400
Message-ID: <20260831133314.4125787-232-sashal@kernel.org>
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

[ Upstream commit eb3bd277b37cd435d26a44a40d8f7c87ff16feb6 ]

Skip invalid sub-buffers when validating the persistent ring buffer
instead of discarding the entire ring buffer. Only skipped buffers
are invalidated (cleared).

If the cache data in memory fails to be synchronized during a reboot,
the persistent ring buffer may become partially corrupted, but other
sub-buffers may still contain readable event data. Only discard the
subbuffers that are found to be corrupted.

Link: https://lore.kernel.org/all/20260520185018.051228084@kernel.org/

Link: https://patch.msgid.link/20260522171050.914418536@kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
[SDR: Fixed max_loops in rb_iter_peek() as well ]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ring-buffer persistent validation fix

**Local tree:** `v6.18.44` (Linux 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[ring-buffer]` `[skip]` — Skip invalid sub-buffers when
validating persistent ring buffer during boot recovery.

### Step 1.2: Tags
**Record:**
- `Link:`
  https://lore.kernel.org/all/20260520185018.051228084@kernel.org/
- `Link:` https://patch.msgid.link/20260522171050.914418536@kernel.org
- `Signed-off-by:` Masami Hiramatsu (Google) <mhiramat@kernel.org>
- `Signed-off-by:` Steven Rostedt <rostedt@goodmis.org> (with note:
  "Fixed max_loops in rb_iter_peek() as well")
- No `Fixes:`, `Reported-by:`, `Cc: stable`, `Tested-by:`, or `Reviewed-
  by:` tags
- Notable: subsystem maintainer (Rostedt) amended and signed off

### Step 1.3: Body analysis
**Record:**
- **Bug:** After reboot, persistent ring buffer validation treats any
  single corrupted sub-buffer as fatal and discards the entire buffer.
- **Symptom:** Valid trace events from previous boot (especially post-
  crash traces) are lost when only some sub-buffers are bad.
- **Root cause:** Cache may not fully sync across reboot; partial
  corruption is realistic. Current code in `rb_cpu_meta_valid()` and
  `rb_meta_validate_events()` rejects the whole buffer on first bad sub-
  buffer.
- **Version info:** None in message.

### Step 1.4: Hidden bug fix detection
**Record:** Yes — described as validation improvement, but it fixes real
data-loss and reader-loop failures (`RB_WARN_ON` when >3 empty pages
after recovery).

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `kernel/trace/ring_buffer.c` only (~73 insertions, ~47
  deletions)
- **Functions modified:** `rb_cpu_meta_valid()`, `rb_validate_buffer()`,
  `rb_meta_validate_events()`, `rb_get_reader_page()`, `rb_iter_peek()`;
  relocates `rb_page_size()` earlier
- **Scope:** Single-file surgical fix in persistent ring-buffer recovery
  path

### Step 2.2: Code flow changes
**Record:**
| Hunk | Before → After |
|------|----------------|
| `rb_cpu_meta_valid()` | Rejects entire meta if any subbuf `commit >
PAGE_SIZE` → only validates meta array structure; adds `subbuf_size !=
PAGE_SIZE` check |
| `rb_validate_buffer()` | Uses raw `commit` → masks `RB_MISSED_MASK`,
bounds-checks against `meta->subbuf_size` |
| `rb_meta_validate_events()` | `goto invalid` on first bad page → clear
only that sub-buffer, continue; track `discarded` count |
| `rb_get_reader_page()` / `rb_iter_peek()` | `max_loops = 3` hardcoded
→ `max_loops = nr_pages` for persistent buffers |
| `rb_page_size()` | Moved earlier so validation code can use masked
commit size |

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic/correctness fix + secondary loop-limit bug
- **Mechanism:** Overly aggressive all-or-nothing validation discards
  recoverable trace data; after per-page discard, multiple consecutive
  empty pages exceed the hardcoded loop limit of 3, triggering
  `RB_WARN_ON` and breaking trace reads

### Step 2.4: Fix quality
**Record:** Fix is minimal, obviously correct, and low regression risk.
Invalidates only proven-bad pages; still falls back to full discard on
structural failures (e.g., commit page not found). Rostedt's `max_loops`
addition addresses a real follow-on failure.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- Aggressive per-subbuf commit check introduced in `c76883f18e59b7`
  ("ring-buffer: Add test if range of boot buffer is valid", 2024-06-14)
- `goto invalid` on bad buffer page in `rb_meta_validate_events()` dates
  to `5f3b6e839f3ceb` (2024-06-12)
- Persistent ring buffer metadata added in `4009cc31e7813` (2025-03-05)
  — present in this tree

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: Related file history
**Record:** Multiple persistent ring-buffer fixes already in this 6.18.y
tree:
- `ca296d32ece38` — rewind persistent ring buffer on reboot
- `b6925774dd15d` — fix per-subbuf entries
- `2bc60c175568e` — flush/stop on panic
- This fix (`009124508d96f` / upstream `eb3bd277b37cd`) is **not** yet
  in HEAD

### Step 3.4: Author context
**Record:** Masami Hiramatsu is the primary persistent ring-buffer
author; Steven Rostedt is trace/ring-buffer maintainer. Both have
multiple related commits in this file.

### Step 3.5: Dependencies
**Record:** Standalone for the validation path. Companion commit
`8a4563881fa3d` ("Skip invalid sub-buffers when rewinding persistent
ring buffer", patch 2/9 in v21 series) addresses a related rewind path
but is separate. This commit includes its own `max_loops` fixes and
applies independently.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- `b4 dig -c 009124508d96f` matched: **[PATCH v21 1/9]** at
  https://patch.msgid.link/20260522171050.914418536@kernel.org
- Lore URLs blocked by bot protection (Anubis) — could not read thread
  content directly

### Step 4.2: Reviewers
**Record:** `b4 dig -w` CC list includes Steven Rostedt, linux-trace-
kernel, Mathieu Desnoyers, Mark Rutland, Andrew Morton — appropriate
maintainer/reviewer coverage.

### Step 4.3: Bug report
**Record:** No external bug report or syzbot link. Bug rationale is in
commit message (cache sync failure across reboot).

### Step 4.4: Series context
**Record:** Part of v21 9-patch series; this is patch 1/9. Companion
rewinding fix exists separately. Validation fix is self-contained.

### Step 4.5: Stable list history
**Record:** UNVERIFIED — could not search lore stable list due to bot
protection. However, multiple prior persistent ring-buffer fixes are
already present in this 6.18.y tree.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `rb_cpu_meta_valid()`, `rb_validate_buffer()`,
`rb_meta_validate_events()`, `rb_get_reader_page()`, `rb_iter_peek()`

### Step 5.2: Callers
**Record:**
- `rb_meta_validate_events()` called from ring buffer CPU init at line
  2399 during `range_addr_start` (persistent/reserved-memory) buffer
  setup
- `rb_get_reader_page()` → `rb_buffer_peek()` → `ring_buffer_consume()`
  / trace reading paths
- `rb_iter_peek()` → `ring_buffer_iter_peek()` — non-consuming trace
  reads

### Step 5.3: Callees
**Record:** `rb_read_data_buffer()`, `local_read/set`,
`rb_page_commit()`, `RB_WARN_ON()`, page list operations

### Step 5.4: Reachability
**Record:** Triggered at boot when persistent tracing instance is
configured via reserved memory / boot parameters (`trace.c` maps boot
instances via `reserve_mem_find_by_name()`). Affects crash/post-mortem
tracing users, not all kernels — but reachable on every boot for
configured systems.

### Step 5.5: Similar patterns
**Record:** Same "skip invalid sub-buffer instead of aborting" pattern
exists in companion rewinding patch (not yet in tree). Consistent with
incremental recovery approach used elsewhere in persistent ring-buffer
series.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (v6.18.44)

### Step 6.1: Buggy code present?
**Record:** **YES.** Current tree still has:
- `rb_cpu_meta_valid()` commit check at lines 1795–1797 that rejects
  entire meta
- `rb_meta_validate_events()` `goto invalid` on first bad page at lines
  2012–2016
- `rb_get_reader_page()` / `rb_iter_peek()` hardcoded `nr_loops > 3`

### Step 6.2: Backport complications
**Record:** Expected **clean apply**. `rb_page_size()` already exists at
line 3247; patch relocates it earlier (trivial). Function names match
(`rb_get_reader_page`, not `__rb_get_reader_page`).

### Step 6.3: Related fixes already present?
**Record:** Prior persistent ring-buffer fixes are in tree, but **not**
this validation-granularity fix or the companion rewinding fix.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `kernel/trace/` — IMPORTANT subsystem. Persistent ring
buffer is a debugging/crash-analysis feature, not core VFS/net, but
critical for post-crash trace retention.

### Step 7.2: Activity
**Record:** Actively developed — 10+ persistent ring-buffer commits in
recent `ring_buffer.c` history on this branch.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Users with persistent/reserved-memory tracing configured
(boot params, DT `reserve_mem`, crash analysis setups). Config-specific,
not universal.

### Step 8.2: Trigger conditions
**Record:** Reboot with partially unsynchronized persistent ring-buffer
memory (unclean shutdown, crash, power loss). Realistic for the
feature's intended use case.

### Step 8.3: Failure severity
**Record:**
- **Without fix:** Total loss of previous-boot trace data when any
  single sub-buffer is corrupt; `RB_WARN_ON` / failed reads when
  multiple cleared pages exist after recovery
- **Severity:** MEDIUM-HIGH for affected users (defeats purpose of
  persistent tracing); LOW for systems without persistent tracing

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Recovers partial crash traces; prevents false
  `RB_WARN_ON` on read path — high value for persistent tracing users
- **Risk:** Very low — only clears proven-invalid pages; structural
  failures still trigger full discard
- **Ratio:** Favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real bug with verified presence in v6.18.44
- Causes loss of recoverable crash-trace data
- Secondary `RB_WARN_ON`/read failure after recovery
- Small, single-file, maintainer-reviewed fix
- Consistent with other persistent ring-buffer fixes already in this
  stable line
- Applies cleanly to this tree

**AGAINST backport:**
- Niche feature (persistent tracing only)
- Not a general security/crash issue for all users
- Companion rewinding patch may also be desirable for complete coverage

**Unresolved:** Lore thread content and stable-list discussion (bot-
blocked).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is clear; maintainer
   signed off; no Tested-by but tracing selftest series exists
2. Fixes real bug affecting users? **PASS** — data loss on boot recovery
   for persistent tracing
3. Important issue? **PASS** — trace data loss + `RB_WARN_ON` on read
   path for crash-analysis users
4. Small and contained? **PASS** — ~120 lines, one file
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — code exists, patch should apply
   cleanly

### Step 9.3: Exception categories
**Record:** None (not a quirk/DT/build/docs fix — a correctness bug fix
in existing feature).

### Step 9.4: Decision rationale

This commit fixes a real correctness bug in the persistent ring buffer
recovery path present in Linux 6.18.44. When memory is partially
corrupted across reboot (the exact scenario persistent tracing is
designed for), the current code throws away **all** trace data because
of **one** bad sub-buffer. The fix surgically invalidates only corrupted
pages and adjusts reader/iterator loop limits so recovered buffers
remain readable. The change is small, reviewed by the trace maintainer,
and follows the same pattern as other persistent ring-buffer fixes
already accepted into this stable series.

**Note:** Consider also backporting the companion patch `ring-buffer:
Skip invalid sub-buffers when rewinding persistent ring buffer` for the
rewind path, but this validation commit is independently valuable.

---

## Verification

- [Phase 1] `git show 009124508d96f`: parsed subject, body, tags; no
  Fixes/Reported-by/Cc:stable
- [Phase 2] `git show 009124508d96f -- kernel/trace/ring_buffer.c`: full
  diff analyzed; 1 file, 5 functions
- [Phase 3] `git describe HEAD`: v6.18.44
- [Phase 3] `git merge-base --is-ancestor 009124508d96f HEAD`: exit 1 —
  fix NOT in tree
- [Phase 3] `git merge-base --is-ancestor 4009cc31e7813 HEAD`: exit 0 —
  persistent ring buffer feature IS in tree
- [Phase 3] `git blame -L 1795,1816,2012,2017
  kernel/trace/ring_buffer.c`: buggy code from c76883f18e59b7 /
  5f3b6e839f3ceb
- [Phase 3] `git log --oneline -20 -- kernel/trace/ring_buffer.c`:
  multiple prior persistent ring-buffer fixes in tree
- [Phase 3] `git merge-base --is-ancestor 8a4563881fa3d HEAD`: exit 1 —
  companion rewinding fix not in tree
- [Phase 4] `b4 dig -c 009124508d96f`: found [PATCH v21 1/9] at
  patch.msgid.link/20260522171050.914418536@kernel.org
- [Phase 4] `b4 dig -c 009124508d96f -w`: CC list includes Rostedt,
  Desnoyers, linux-trace-kernel
- [Phase 4] WebFetch lore/patch.msgid.link URLs: BLOCKED by Anubis bot
  protection
- [Phase 5] Read `ring_buffer.c` lines 1754–2057, 2399, 3247, 5421–5765:
  confirmed buggy code paths and call sites
- [Phase 5] Grep `rb_meta_validate_events`, `rb_get_reader_page`,
  `rb_iter_peek`: traced callers
- [Phase 5] Read `trace.c` lines 11137–11165: persistent boot instance
  via `reserve_mem_find_by_name()`
- [Phase 6] Grep `rb_validate_buffer(head_page->page, cpu_buffer->cpu)`
  without meta param: confirms pre-fix code in tree
- [Phase 6] Grep `nr_loops > 3` in reader/iter paths: confirms hardcoded
  limit in tree
- [Phase 8] Failure mode: total trace data discard + RB_WARN_ON on read;
  severity MEDIUM-HIGH for persistent tracing users

**YES****Result:** Backport analysis for `ring-buffer: Skip invalid sub-
buffers when validating persistent ring buffer` on **v6.18.44** —
**YES**.

The fix belongs in this tree: the buggy all-or-nothing validation is
still present, persistent ring-buffer support is in-tree, and the patch
is a small, maintainer-reviewed correctness fix for crash-trace recovery
after reboot.

**Worth noting:** It’s patch **1/9** in the v21 series. The companion
**rewinding** fix (`Skip invalid sub-buffers when rewinding persistent
ring buffer`) isn’t in this tree yet and may be worth evaluating
separately for full coverage.

 kernel/trace/ring_buffer.c | 120 ++++++++++++++++++++++---------------
 1 file changed, 73 insertions(+), 47 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index fefa16e51e0ef..631d42281f5b3 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -396,6 +396,12 @@ static __always_inline unsigned int rb_page_commit(struct buffer_page *bpage)
 	return local_read(&bpage->page->commit);
 }
 
+/* Size is determined by what has been committed */
+static __always_inline unsigned int rb_page_size(struct buffer_page *bpage)
+{
+	return rb_page_commit(bpage) & ~RB_MISSED_MASK;
+}
+
 static void free_buffer_page(struct buffer_page *bpage)
 {
 	/* Range pages are not to be freed */
@@ -1756,7 +1762,6 @@ static bool rb_cpu_meta_valid(struct ring_buffer_cpu_meta *meta, int cpu,
 			      unsigned long *subbuf_mask)
 {
 	int subbuf_size = PAGE_SIZE;
-	struct buffer_data_page *subbuf;
 	unsigned long buffers_start;
 	unsigned long buffers_end;
 	int i;
@@ -1764,6 +1769,11 @@ static bool rb_cpu_meta_valid(struct ring_buffer_cpu_meta *meta, int cpu,
 	if (!subbuf_mask)
 		return false;
 
+	if (meta->subbuf_size != PAGE_SIZE) {
+		pr_info("Ring buffer boot meta [%d] invalid subbuf_size\n", cpu);
+		return false;
+	}
+
 	buffers_start = meta->first_buffer;
 	buffers_end = meta->first_buffer + (subbuf_size * meta->nr_subbufs);
 
@@ -1780,11 +1790,12 @@ static bool rb_cpu_meta_valid(struct ring_buffer_cpu_meta *meta, int cpu,
 		return false;
 	}
 
-	subbuf = rb_subbufs_from_meta(meta);
-
 	bitmap_clear(subbuf_mask, 0, meta->nr_subbufs);
 
-	/* Is the meta buffers and the subbufs themselves have correct data? */
+	/*
+	 * Ensure the meta::buffers array has correct data. The data in each subbufs
+	 * are checked later in rb_meta_validate_events().
+	 */
 	for (i = 0; i < meta->nr_subbufs; i++) {
 		if (meta->buffers[i] < 0 ||
 		    meta->buffers[i] >= meta->nr_subbufs) {
@@ -1792,18 +1803,12 @@ static bool rb_cpu_meta_valid(struct ring_buffer_cpu_meta *meta, int cpu,
 			return false;
 		}
 
-		if ((unsigned)local_read(&subbuf->commit) > subbuf_size) {
-			pr_info("Ring buffer boot meta [%d] buffer invalid commit\n", cpu);
-			return false;
-		}
-
 		if (test_bit(meta->buffers[i], subbuf_mask)) {
 			pr_info("Ring buffer boot meta [%d] array has duplicates\n", cpu);
 			return false;
 		}
 
 		set_bit(meta->buffers[i], subbuf_mask);
-		subbuf = (void *)subbuf + subbuf_size;
 	}
 
 	return true;
@@ -1867,13 +1872,22 @@ static int rb_read_data_buffer(struct buffer_data_page *dpage, int tail, int cpu
 	return events;
 }
 
-static int rb_validate_buffer(struct buffer_data_page *dpage, int cpu)
+static int rb_validate_buffer(struct buffer_data_page *dpage, int cpu,
+			      struct ring_buffer_cpu_meta *meta)
 {
 	unsigned long long ts;
+	unsigned long tail;
 	u64 delta;
-	int tail;
 
-	tail = local_read(&dpage->commit);
+	/*
+	 * When a sub-buffer is recovered from a read, the commit value may
+	 * have RB_MISSED_* bits set, as these bits are reset on reuse.
+	 * Even after clearing these bits, a commit value greater than the
+	 * subbuf_size is considered invalid.
+	 */
+	tail = local_read(&dpage->commit) & ~RB_MISSED_MASK;
+	if (tail > meta->subbuf_size - BUF_PAGE_HDR_SIZE)
+		return -1;
 	return rb_read_data_buffer(dpage, tail, cpu, &ts, &delta);
 }
 
@@ -1884,6 +1898,7 @@ static void rb_meta_validate_events(struct ring_buffer_per_cpu *cpu_buffer)
 	struct buffer_page *head_page, *orig_head, *orig_reader;
 	unsigned long entry_bytes = 0;
 	unsigned long entries = 0;
+	int discarded = 0;
 	int ret;
 	u64 ts;
 	int i;
@@ -1895,14 +1910,19 @@ static void rb_meta_validate_events(struct ring_buffer_per_cpu *cpu_buffer)
 	orig_reader = cpu_buffer->reader_page;
 
 	/* Do the reader page first */
-	ret = rb_validate_buffer(orig_reader->page, cpu_buffer->cpu);
+	ret = rb_validate_buffer(orig_reader->page, cpu_buffer->cpu, meta);
 	if (ret < 0) {
-		pr_info("Ring buffer reader page is invalid\n");
-		goto invalid;
+		pr_info("Ring buffer meta [%d] invalid reader page detected\n",
+			cpu_buffer->cpu);
+		discarded++;
+		/* Instead of discard whole ring buffer, discard only this sub-buffer. */
+		local_set(&orig_reader->entries, 0);
+		local_set(&orig_reader->page->commit, 0);
+	} else {
+		entries += ret;
+		entry_bytes += rb_page_size(orig_reader);
+		local_set(&orig_reader->entries, ret);
 	}
-	entries += ret;
-	entry_bytes += local_read(&orig_reader->page->commit);
-	local_set(&orig_reader->entries, ret);
 
 	ts = head_page->page->time_stamp;
 
@@ -1930,7 +1950,7 @@ static void rb_meta_validate_events(struct ring_buffer_per_cpu *cpu_buffer)
 			break;
 
 		/* Stop rewind if the page is invalid. */
-		ret = rb_validate_buffer(head_page->page, cpu_buffer->cpu);
+		ret = rb_validate_buffer(head_page->page, cpu_buffer->cpu, meta);
 		if (ret < 0)
 			break;
 
@@ -1939,7 +1959,7 @@ static void rb_meta_validate_events(struct ring_buffer_per_cpu *cpu_buffer)
 		if (ret)
 			local_inc(&cpu_buffer->pages_touched);
 		entries += ret;
-		entry_bytes += rb_page_commit(head_page);
+		entry_bytes += rb_page_size(head_page);
 	}
 	if (i)
 		pr_info("Ring buffer [%d] rewound %d pages\n", cpu_buffer->cpu, i);
@@ -2009,21 +2029,24 @@ static void rb_meta_validate_events(struct ring_buffer_per_cpu *cpu_buffer)
 		if (head_page == orig_reader)
 			continue;
 
-		ret = rb_validate_buffer(head_page->page, cpu_buffer->cpu);
+		ret = rb_validate_buffer(head_page->page, cpu_buffer->cpu, meta);
 		if (ret < 0) {
-			pr_info("Ring buffer meta [%d] invalid buffer page\n",
-				cpu_buffer->cpu);
-			goto invalid;
-		}
-
-		/* If the buffer has content, update pages_touched */
-		if (ret)
-			local_inc(&cpu_buffer->pages_touched);
-
-		entries += ret;
-		entry_bytes += local_read(&head_page->page->commit);
-		local_set(&head_page->entries, ret);
+			if (!discarded)
+				pr_info("Ring buffer meta [%d] invalid buffer page detected\n",
+					cpu_buffer->cpu);
+			discarded++;
+			/* Instead of discard whole ring buffer, discard only this sub-buffer. */
+			local_set(&head_page->entries, 0);
+			local_set(&head_page->page->commit, 0);
+		} else {
+			/* If the buffer has content, update pages_touched */
+			if (ret)
+				local_inc(&cpu_buffer->pages_touched);
 
+			entries += ret;
+			entry_bytes += rb_page_size(head_page);
+			local_set(&head_page->entries, ret);
+		}
 		if (head_page == cpu_buffer->commit_page)
 			break;
 	}
@@ -2037,7 +2060,10 @@ static void rb_meta_validate_events(struct ring_buffer_per_cpu *cpu_buffer)
 	local_set(&cpu_buffer->entries, entries);
 	local_set(&cpu_buffer->entries_bytes, entry_bytes);
 
-	pr_info("Ring buffer meta [%d] is from previous boot!\n", cpu_buffer->cpu);
+	pr_info("Ring buffer meta [%d] is from previous boot!", cpu_buffer->cpu);
+	if (discarded)
+		pr_cont(" (%d pages discarded)", discarded);
+	pr_cont("\n");
 	return;
 
  invalid:
@@ -3243,12 +3269,6 @@ rb_iter_head_event(struct ring_buffer_iter *iter)
 	return NULL;
 }
 
-/* Size is determined by what has been committed */
-static __always_inline unsigned rb_page_size(struct buffer_page *bpage)
-{
-	return rb_page_commit(bpage) & ~RB_MISSED_MASK;
-}
-
 static __always_inline unsigned
 rb_commit_index(struct ring_buffer_per_cpu *cpu_buffer)
 {
@@ -5421,8 +5441,9 @@ rb_update_iter_read_stamp(struct ring_buffer_iter *iter,
 static struct buffer_page *
 rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 {
-	struct buffer_page *reader = NULL;
+	int max_loops = cpu_buffer->ring_meta ? cpu_buffer->nr_pages : 3;
 	unsigned long bsize = READ_ONCE(cpu_buffer->buffer->subbuf_size);
+	struct buffer_page *reader = NULL;
 	unsigned long overwrite;
 	unsigned long flags;
 	int nr_loops = 0;
@@ -5434,11 +5455,14 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
  again:
 	/*
 	 * This should normally only loop twice. But because the
-	 * start of the reader inserts an empty page, it causes
-	 * a case where we will loop three times. There should be no
-	 * reason to loop four times (that I know of).
+	 * start of the reader inserts an empty page, it causes a
+	 * case where we will loop three times. There should be no
+	 * reason to loop four times unless the ring buffer is a
+	 * recovered persistent ring buffer. For persistent ring buffers,
+	 * invalid pages are reset during recovery, so there may be more
+	 * than 3 contiguous pages can be empty, but less than nr_pages.
 	 */
-	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 3)) {
+	if (RB_WARN_ON(cpu_buffer, ++nr_loops > max_loops)) {
 		reader = NULL;
 		goto out;
 	}
@@ -5728,12 +5752,14 @@ rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event;
 	int nr_loops = 0;
+	int max_loops;
 
 	if (ts)
 		*ts = 0;
 
 	cpu_buffer = iter->cpu_buffer;
 	buffer = cpu_buffer->buffer;
+	max_loops = cpu_buffer->ring_meta ? cpu_buffer->nr_pages : 3;
 
 	/*
 	 * Check if someone performed a consuming read to the buffer
@@ -5756,7 +5782,7 @@ rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 	 * the ring buffer with an active write as the consumer is.
 	 * Do not warn if the three failures is reached.
 	 */
-	if (++nr_loops > 3)
+	if (++nr_loops > max_loops)
 		return NULL;
 
 	if (rb_per_cpu_empty(cpu_buffer))
-- 
2.53.0

