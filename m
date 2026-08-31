Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D20459B679;
	Mon, 31 Aug 2026 13:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184304; cv=none; b=Ui6/pJ2Uuwj7zT7ESBoYYibW4BGPw6hF6HyJ2F4tphM3i846/2ASWhH9/EfnS71eH9MOQaxd6y7xraD+N/5VbIeeP7Vrnfkt/+zow8XI0vv5Au2yaSbFvgXUvt3yNb/U4krAE32il5TBQwzapnuNd+GzFh4mkaNnjt2yhGI9DyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184304; c=relaxed/simple;
	bh=1uAy2OJTOTy0zeju2706sQ4Mlt9NE8ih/SaQurLonrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GoDuMhIT081OFmDb27rFPvfFN0bqqJKlsL29aqS5jSA4Ghii6dzq8fuXjGu9ypXW64yND22P4cn2hMPKHMMhUk9e2+TUEtZn9IgGQNwQRXUrVuK84s0nAmivOLgx00qMhpDAJn/fPoC98Pbnux+s+ItXAr7ZCm+bzJjN7ZqVMSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mU4S5Nrt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mU4S5Nrt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C881F000E9;
	Mon, 31 Aug 2026 13:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184299;
	bh=Xy8SsRCa5kF8aw3Zrtf9+1ak17dI9byixxsBvDMsfPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mU4S5NrtaYa2SU3f32sw61H3eU49cyJxqE4kLwldFStqFlBHasqzYMCCXd3GVDQNQ
	 ksrkmCSKV4idJoqqh6itlWqaIz87331DpcsHBu2tiWFkSRSpK1iOnXHcvp5TffgT/F
	 E9KfHhG52GtO0y9D5I/mK9DnLysx67jLXvM80vo27qbhmciHoAccDpPv3NKIbBcs9/
	 IF/mbTgJnEoP+emax57T6GoLHCJ+yCv0aRohzNJnlVcqdidzk1kbcRlMCmrSYUFTcD
	 RWktmVrdhUgWPYJioTbKo882Ua3WFEV2pP6X8pkiyHV5dDPwVmr23kwNDbAMVVZCnW
	 a1k2y/tTPybLA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ALSA: seq: Remove arbitrary prioq insertion limit
Date: Mon, 31 Aug 2026 09:30:38 -0400
Message-ID: <20260831133314.4125787-610-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 3fcc84f1f8d28cc1966b859cef33c858ff531766 ]

The sequencer priority queue insertion path uses a hardcoded traversal
limit of 10000 entries.  The value is intended to catch a corrupted list,
but it also becomes a real limit for valid queues.

The event pool limit is per client, while a sequencer queue can be shared
by multiple clients.  A queue can therefore legitimately contain more than
10000 events.  In that case, inserting an event that has to be placed past
the arbitrary limit fails with -EINVAL.

Use the queue's own cell count as the traversal bound instead.  This keeps
the protection against inconsistent list accounting or cyclic lists without
rejecting valid large queues.

Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260525-alsa-seq-prioq-limit-v1-1-16c348df5ff7@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ALSA: seq: Remove arbitrary prioq insertion
limit

**Local tree:** Linux **6.18.44** (`git describe HEAD` → `v6.18.44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[ALSA: seq]` `[remove]` — Remove an arbitrary hardcoded
traversal limit in the sequencer priority-queue insertion path.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Cássio Gabriel `<cassiogabrielcontato@gmail.com>`
  (author)
- **Signed-off-by:** Takashi Iwai `<tiwai@suse.de>` (ALSA maintainer)
- **Link:** https://patch.msgid.link/20260525-alsa-seq-prioq-
  limit-v1-1-16c348df5ff7@gmail.com
- **No** Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or
  Cc: stable tags
- Notable: Maintainer (Iwai) sign-off; no fuzzer/user bug reports cited

### Step 1.3: Body Analysis
**Record:**
- **Bug:** `snd_seq_prioq_cell_in()` uses a hardcoded traversal counter
  of 10000 intended as corruption/loop protection, but it also caps
  legitimate queues.
- **Symptom:** Inserting an event that must be placed past the 10000th
  element returns `-EINVAL` with `pr_err("cannot find a pointer..
  infinite loop?")`.
- **Root cause:** Event pools are per-client (`SNDRV_SEQ_MAX_EVENTS` =
  2000), but sequencer queues are shared across clients. Multiple
  clients can enqueue to the same queue, so total queue depth can exceed
  10000 even when each client stays within its pool limit.
- **Fix approach:** Use `f->cells` (the queue's own cell count) as the
  traversal bound instead of 10000.

### Step 1.4: Hidden Bug Fix?
**Record:** No — this is an explicit functional bug fix, not disguised
cleanup. The commit clearly describes incorrect rejection of valid
events.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `sound/core/seq/seq_prioq.c` (+4 net lines, ~6 lines
  moved/restructured)
- **Function:** `snd_seq_prioq_cell_in()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `count = 10000`; decrement after each list advance; error
  when count hits 0 while `cur` is still non-NULL.
- **After:** `remaining = f->cells`; at start of each loop iteration,
  post-decrement check `if (remaining-- <= 0)` → error with new message
  `"inconsistent prioq cell count"`; old end-of-loop count check
  removed.
- **Affected path:** Slow-path sorted insertion (when the tail fast-path
  does not apply — priority events or out-of-order timestamps).

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Logic / correctness bug (artificial operational limit)
- **Mechanism:** The 10000 bound is smaller than the legitimate maximum
  queue occupancy. With `SNDRV_SEQ_DEFAULT_CLIENT_EVENTS` = 200 and up
  to 192 clients sharing one queue, 51 clients each holding 200 queued
  events yields 10,200 events — exceeding the limit. With max pool size
  2000, only 6 fully-loaded clients are needed (6 × 2000 = 12,000).

### Step 2.4: Fix Quality
**Record:**
- **Obviously correct:** Yes. `f->cells` is the authoritative count
  maintained by the prioq; a valid list traversal visits at most
  `f->cells` nodes. Post-decrement semantics (`remaining-- <= 0` uses
  pre-decrement value) allow exactly N iterations for N existing cells,
  including full-list traversal for tail insertion.
- **Minimal:** Yes, no unrelated changes.
- **Regression risk:** Very low. Corrupted/cyclic lists still hit the
  bound and fail safely; valid large queues are no longer rejected.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** In this tree, `count = 10000` at line 165 is attributed to
commit `e664048784506` (Nov 2025 merge), but the file header dates to
1998–1999. The 10000 limit with `/* FIXME: enough big, isn't it? */` is
longstanding ALSA sequencer code, not a recent regression.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag present.

### Step 3.3: Related File History
**Record:** Recent ALSA seq stable commits in this tree include UAF
fixes, leaks, and functional fixes. Same author (Cássio Gabriel) already
has `33074b1e6c18f` ("ALSA: seq_oss: return full count for successful
SEQ_FULLSIZE writes") backported here — a similar functional correctness
fix with Iwai sign-off. The prioq fix itself is **not** yet in this tree
(`git log -S "inconsistent prioq cell count"` returns nothing).

### Step 3.4: Author Context
**Record:** Cássio Gabriel is an active ALSA seq contributor in this
tree. Takashi Iwai (subsystem maintainer) signed off.

### Step 3.5: Dependencies
**Record:** Standalone. Uses existing `f->cells` field and
`guard(spinlock_irqsave)` — both present in this tree's `seq_prioq.c`.
No series dependencies.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:** `b4 dig` could not match the commit (not yet in this tree's
HEAD). `b4 shazam` and WebFetch/curl to lore.kernel.org and
patch.msgid.link were blocked (Anubis bot protection / 403).
**UNVERIFIED:** Full review thread content, stable nominations in
replies.

### Step 4.2: Reviewers
**Record:** **UNVERIFIED** via b4 -w. Commit message confirms Takashi
Iwai (maintainer) sign-off.

### Step 4.3: Bug Report
**Record:** No external bug report referenced. Bug identified through
code analysis by the author.

### Step 4.4: Series Context
**Record:** Standalone 1-patch fix; no "patch X/Y" markers.

### Step 4.5: Stable List History
**Record:** **UNVERIFIED** — lore access blocked.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `snd_seq_prioq_cell_in()` — modified.

### Step 5.2: Callers
**Record:** Called from `snd_seq_enqueue_event()` in
`sound/core/seq/seq_queue.c` (lines 314, 319) for tick and real-time
queues. That is reached from `snd_seq_client_enqueue_event()` →
`snd_seq_write()` ioctl/write path — userspace-accessible ALSA sequencer
API.

### Step 5.3: Callees
**Record:** `compare_timestamp_rel()`, spinlock via
`guard(spinlock_irqsave)`, `pr_err()`.

### Step 5.4: Reachability
**Record:** Userspace applications writing sequencer events to a shared
queue can trigger the slow insertion path. Reachable from
`/dev/snd/seq*` write/ioctl by unprivileged users with sequencer access.

### Step 5.5: Similar Patterns
**Record:** `seq_queue.c` has a separate `MAX_CELL_PROCESSES_IN_QUEUE`
(1000) for dispatch processing — a different code path. The prioq 10000
limit is unique to insertion traversal.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** `count = 10000; /* FIXME: enough big, isn't it? */`
confirmed at line 165 of `sound/core/seq/seq_prioq.c` in v6.18.44.

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** The tree already uses
`guard(spinlock_irqsave)(&f->lock)` at line 144, matching the patch
context. No structural divergence in this function.

### Step 6.3: Related Fixes Already Present?
**Record:** **No.** Fix not present; `git log --grep="inconsistent
prioq"` returns nothing.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
**Record:** `sound/core/seq` — ALSA sequencer. **Criticality:
IMPORTANT** (not core kernel, but widely used by audio/MIDI
applications).

### Step 7.2: Activity
**Record:** Actively maintained in 6.18.y — 13 ALSA seq commits since
the base merge, including several stable-worthy bug fixes.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users of ALSA sequencer with shared queues and multiple
clients — DAWs, MIDI routers, JACK/ALSA bridge setups, OSS sequencer
compatibility layers.

### Step 8.2: Trigger Conditions
**Record:**
- Shared sequencer queue used by multiple clients
- Combined queued events > 10,000 (achievable with 51 default-pool
  clients at 200 events each, or 6 max-pool clients at 2000 each)
- Event insertion requires sorted traversal (not the sequential tail
  fast-path)
- **Likelihood:** Uncommon but legitimate in professional multi-client
  MIDI setups

### Step 8.3: Failure Mode Severity
**Record:** Event enqueue fails with `-EINVAL`; kernel logs error;
application loses the event. **Severity: MEDIUM** — functional failure,
not crash/corruption/security, but breaks valid workloads.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** MEDIUM — restores correct behavior for large shared
  queues
- **Risk:** VERY LOW — ~6 lines, uses existing `f->cells` accounting,
  maintainer-reviewed
- **Ratio:** Favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, verifiable bug (10000 < legitimate max queue depth)
- Buggy code present in Linux 6.18.44
- Small, surgical, maintainer-signed fix
- Same author/subsystem already has a functional fix in this stable tree
  (`33074b1e6c18f`)
- Userspace-reachable path
- Fix preserves corruption detection using accurate bound

**AGAINST backport:**
- Not a crash, security, or data-corruption issue
- Requires multi-client shared-queue workloads
- No user/syzbot reports cited
- Mailing list review details unverified

**Unresolved:**
- Full lore review thread (blocked)
- Whether any reviewer explicitly nominated for stable

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic verified; maintainer
   sign-off; no Tested-by
2. Fixes a real bug affecting users? **PASS** — incorrect `-EINVAL` on
   valid large queues
3. Important issue? **PASS (borderline)** — MEDIUM severity functional
   failure in userspace API, not crash/corruption
4. Small and contained? **PASS** — single file, ~6 lines changed
5. No new features or APIs? **PASS**
6. Can apply to local tree? **PASS** — clean apply expected

### Step 9.3: Exception Categories
**Record:** None apply (not device ID, quirk, DT, build, or docs).

### Step 9.4: Problem and Decision Rationale

The commit fixes a longstanding artificial limit in ALSA sequencer
priority-queue insertion. The 10000-entry traversal cap was meant to
detect list corruption but incorrectly rejects valid queues when
multiple clients share a sequencer queue and their combined event count
exceeds 10000. Given per-client pool limits of up to 2000 events and 192
possible clients, this is not theoretical — 6 clients at max pool size,
or 51 at default pool size, suffice.

For stable 6.18.y users running multi-client MIDI/sequencer setups,
affected insertions silently fail with `-EINVAL`, causing dropped
events. The fix replaces the arbitrary constant with `f->cells`, which
is the correct upper bound for a consistent list. The patch is minimal,
reviewed by the ALSA maintainer, and follows the precedent of the same
author's functional seq fix already backported to this tree.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user-provided
  content
- **[Phase 1]** Confirmed no Reported-by/syzbot/Cc: stable tags
- **[Phase 2]** Read `sound/core/seq/seq_prioq.c` lines 130–196: buggy
  `count = 10000` present
- **[Phase 2]** Verified post-decrement semantics of `remaining-- <= 0`
  allow N traversals for N cells
- **[Phase 3]** `git describe HEAD` → `v6.18.44`; Makefile confirms
  6.18.44
- **[Phase 3]** `git blame -L 165,182` → `count = 10000` at line 165
- **[Phase 3]** `git log -S "inconsistent prioq cell count"` → no
  results (fix not in tree)
- **[Phase 3]** `git show 33074b1e6c18f` → same author's functional fix
  already in 6.18.y stable
- **[Phase 4]** `b4 dig -c HEAD` → no match (expected; fix not
  committed)
- **[Phase 4]** `b4 shazam "Remove arbitrary prioq insertion limit"` →
  message-id not known
- **[Phase 4]** WebFetch lore.kernel.org and patch.msgid.link → blocked
  (Anubis/403)
- **[Phase 5]** `grep snd_seq_prioq_cell_in` → callers in
  `seq_queue.c:314,319`
- **[Phase 5]** Traced call chain: `snd_seq_write` →
  `snd_seq_client_enqueue_event` → `snd_seq_enqueue_event` →
  `snd_seq_prioq_cell_in`
- **[Phase 6]** Confirmed buggy code at `seq_prioq.c:165` in local tree
- **[Phase 6]** Confirmed `guard(spinlock_irqsave)` and `f->cells` field
  exist for clean apply
- **[Phase 6]** Read `include/sound/seq_kernel.h`:
  `SNDRV_SEQ_MAX_EVENTS=2000`, `SNDRV_SEQ_MAX_CLIENTS=192`,
  `SNDRV_SEQ_DEFAULT_CLIENT_EVENTS=200`
- **[Phase 6]** Verified math: 6×2000=12000>10000; 51×200=10200>10000
- **[Phase 8]** Confirmed failure mode: `-EINVAL` from
  `snd_seq_prioq_cell_in`, propagated through `snd_seq_enqueue_event`
  with cell freed
- **UNVERIFIED:** Mailing list review discussion and any explicit stable
  nominations
- **UNVERIFIED:** Whether fix has landed in mainline (not needed for
  local-tree decision; bug exists here)

**YES****Result:** Backport to **Linux 6.18.44** — **YES**.

The hardcoded 10,000-entry traversal limit in `snd_seq_prioq_cell_in()`
can reject valid events on shared sequencer queues (e.g. 6 clients at
max pool size, or 51 at default). The fix uses `f->cells` instead, is
small and maintainer-reviewed, and the buggy code is still present in
this tree — the fix is not applied yet.

 sound/core/seq/seq_prioq.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/sound/core/seq/seq_prioq.c b/sound/core/seq/seq_prioq.c
index e649485a87722..8c9a293cb5b51 100644
--- a/sound/core/seq/seq_prioq.c
+++ b/sound/core/seq/seq_prioq.c
@@ -132,7 +132,7 @@ int snd_seq_prioq_cell_in(struct snd_seq_prioq * f,
 			  struct snd_seq_event_cell * cell)
 {
 	struct snd_seq_event_cell *cur, *prev;
-	int count;
+	int remaining;
 	int prior;
 
 	if (snd_BUG_ON(!f || !cell))
@@ -162,10 +162,16 @@ int snd_seq_prioq_cell_in(struct snd_seq_prioq * f,
 	prev = NULL;		/* previous cell */
 	cur = f->head;		/* cursor */
 
-	count = 10000; /* FIXME: enough big, isn't it? */
+	remaining = f->cells;
 	while (cur != NULL) {
 		/* compare timestamps */
 		int rel = compare_timestamp_rel(&cell->event, &cur->event);
+
+		if (remaining-- <= 0) {
+			pr_err("ALSA: seq: inconsistent prioq cell count\n");
+			return -EINVAL;
+		}
+
 		if (rel < 0)
 			/* new cell has earlier schedule time, */
 			break;
@@ -176,10 +182,6 @@ int snd_seq_prioq_cell_in(struct snd_seq_prioq * f,
 		/* move cursor to next cell */
 		prev = cur;
 		cur = cur->next;
-		if (! --count) {
-			pr_err("ALSA: seq: cannot find a pointer.. infinite loop?\n");
-			return -EINVAL;
-		}
 	}
 
 	/* insert it before cursor */
-- 
2.53.0

