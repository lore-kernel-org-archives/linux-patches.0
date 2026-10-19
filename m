Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6B05D18A0;
	Mon, 19 Oct 2026 14:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418491; cv=none; b=rRqicGS7KMxRc59EUBSzzMZCPYvI51xQ0SWYTIPYpQWM7XaM/w6tz3LqUxwFfadsLF8P6HCkuIGgu24f5GShV3xIyQjH9ofXajZsjSMiuoG0EGNiCYteOd3rD9Lq9jf+C8C1J5fQSNfhASaJmxdysiLQqTVUCUsizW1VsBgzyk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418491; c=relaxed/simple;
	bh=U0XngmClq5ynipwJFetEN/KadKGs+p5reEPGOvYYPSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JnITepBDTBzqK1D36lSF9WFE87Iuq6BB/396RIYI8vZz3bW+GE4+WVDNzie4g+zXQ5buxMX0KGfv3ROHarTx+b8xpyeO6jW4WjWXDB/6Y4XfPK75bOeADVjtAdj9kaxVzPZF11OOuQLiRk6qzgcRLjMMt8LOdEkchQhcetE9RIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eWpfvWx2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eWpfvWx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E1E01F000C4;
	Mon, 19 Oct 2026 14:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418488;
	bh=BYPnPnJA1lC5apAC3z/r397eqYHitsMnh0hxAWm5NYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eWpfvWx2iuDiZ6SwWUKtGLLsJU9uCEuy4/hjTa6VvAhxIVwHycnTJEvLjdwgqhBZM
	 I9gY1DATQb66F0oR4CSv/43dAs5KGmBF0RazWD3bc5CDs7FqRj/shE6IqXUJMV7ErW
	 X88g44KUQIJ42e1OoeTi9ZThu5ZOvr5IsRNRpd25txbsPetsFKbn43rBetUuLWigPM
	 jLCatueMBoihQOvFGumcKEQpskPiLSm7CapORX/cr9/wIOXB2RD330NTF8v+8NEXnI
	 VmHSxwF/dCwamf8S74KiByxiyjwnBc3uMtIcKPxWC3Si6BYutRox2vqrzt4ihhSlPU
	 ornXaAHX6SRxQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Stefan Haberland <sth@linux.ibm.com>,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] s390/dasd: Snapshot intrc before freeing the request block
Date: Mon, 19 Oct 2026 09:49:35 -0400
Message-ID: <20261019135441.1420968-284-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Transfer-Encoding: 8bit

From: Stefan Haberland <sth@linux.ibm.com>

[ Upstream commit dc3e3f7306cb74066f231251602b1be5aaec7bd8 ]

__dasd_cleanup_cqr() maps the completion result to a block status by
reading cqr->intrc, but only after discipline->free_cp() has returned the
request block to its memory pool (dasd_eckd_free_cp() ends in
dasd_sfree_request()). On SMP another CPU can reallocate that block and
overwrite cqr->intrc before it is read, completing the request with the
wrong error. proc_bytes is already snapshotted before free_cp() for the
same reason; do the same for intrc.

Reviewed-by: Jan Höppner <hoeppner@linux.ibm.com>
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Link: https://patch.msgid.link/20260805111612.1285190-5-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **5.10.270** (`pending-5.10`). The DASD cleanup path
here still reads `cqr->intrc` after the CQR is returned to the per-
device pool, so this is a real, self-contained race fix for this
checkout.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
- Record: **[s390/dasd] [Snapshot] Snapshot `intrc` before freeing the
  request block**
- Subsystem: `s390/dasd` (IBM mainframe block driver). Action is
  “snapshot”, which here means copy a field before free so it cannot be
  overwritten — a use-after-reuse fix.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- Record:
  - `Reviewed-by: Jan Höppner <hoeppner@linux.ibm.com>` (DASD co-
    maintainer)
  - `Signed-off-by: Stefan Haberland <sth@linux.ibm.com>` (DASD
    maintainer / author)
  - `Link:
    https://patch.msgid.link/20260805111612.1285190-5-sth@linux.ibm.com`
  - `Signed-off-by: Jens Axboe <axboe@kernel.dk>` (block maintainer;
    applied to the block tree)
  - No `Fixes:`, `Reported-by:`, `Tested-by:`, `Cc: stable` (absence
    expected for this review)
  - Ignore pipeline `Signed-off-by: Sasha Levin` if present

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
- Record:
  - **Bug:** `__dasd_cleanup_cqr()` maps completion to `blk_status_t` by
    reading `cqr->intrc` *after* `discipline->free_cp()`.
    `dasd_eckd_free_cp()` ends in `dasd_sfree_request()`, which returns
    the CQR to the device CCW memory pool.
  - **Failure mode:** On SMP another CPU can reallocate that block and
    overwrite `intrc`; the original request is completed with the
    **wrong error**.
  - **Root cause:** Same class of bug already handled for `proc_bytes`
    (snapshotted before `free_cp()`); `intrc` was left unsaved.
  - **Version info:** None in the message. The pattern exists since
    detailed I/O-error mapping (2013).

**Step 1.4: DETECT HIDDEN BUG FIXES**
- Record: **Not hidden.** Explicit race / use-after-reuse. Cover letter
  for the 19-patch series (`[PATCH 00/19] s390/dasd: ESE Performance
  improvements`) states: “The first 4 patches are fixes for existing
  bugs in this area.” This is patch 04/19. Later patches are ESE
  performance features; this one is standalone.

---

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

**Step 2.1: INVENTORY THE CHANGES**
- Record:
  - File: `drivers/s390/block/dasd.c` only (`+8 / -2`)
  - Function: `__dasd_cleanup_cqr()`
  - Scope: **single-file surgical fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
- Record:
  - **Before:** `proc_bytes = cqr->proc_bytes;` then `status =
    ...->free_cp(cqr, req);` then `switch (cqr->intrc)` on the failed
    path (`status == 0`).
  - **After:** Also `intrc = cqr->intrc;` before `free_cp()`, then
    `switch (intrc)`.
  - Path: block-layer completion / error mapping after I/O or ERP; not
    an init-only path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
- Record:
  - **Category:** Use-after-free / use-after-reuse (custom memory pool),
    with a race.
  - **Mechanism:** `dasd_sfree_request()` drops `device->mem_lock` after
    `dasd_free_chunk(&device->ccw_chunks, ...)`.
    `dasd_smalloc_request()` on another CPU takes that lock, allocates
    the same chunk, and `memset(cqr, 0, sizeof(*cqr))`, then may set a
    new `intrc`. Cleanup then maps garbage/zero/`intrc` from a
    *different* request.
  - Verified in this tree: `dasd_eckd_free_cp()`, `dasd_fba_free_cp()`,
    and `dasd_diag_free_cp()` all call `dasd_sfree_request()` after
    capturing `status = cqr->status == DASD_CQR_DONE`. `status` is
    already a return value; only `intrc` was still loaded from freed
    memory.

**Step 2.4: ASSESS THE FIX QUALITY**
- Record:
  - **Obviously correct:** copies the already-accepted `proc_bytes`
    pattern.
  - **Minimal:** one local, one assignment, switch operand change,
    comment.
  - **Regression risk:** very low. Does not change locking, APIs, or
    success/fail (`status` was already snapshotted via the return
    value).
  - Context in this tree uses `BLK_STS_NEXUS` (not
    `BLK_STS_RESV_CONFLICT`, renamed later in `7ba150834b840`). Backport
    needs that context tweak only; the logic is identical.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
- Record:
  - `__dasd_cleanup_cqr` since `8e09f21574ea30` (2008).
  - `switch (cqr->intrc)` after `free_cp()`: `d1ffc1f8660e74`
    (“block/dasd: detailed I/O errors”, 2013) then `2a842acab109f4`
    (blk_status_t, 2017).
  - `proc_bytes` snapshot: `5e6bdd37c5526` (2020, ESE data-corruption
    fix, `Cc: stable`).
  - Bug present for ~13 years; `proc_bytes` was fixed in 2020 and **is**
    in this tree; `intrc` was not.

**Step 3.2: FOLLOW THE FIXES: TAG**
- Record: No `Fixes:` tag. Introducing commits `d1ffc1f8660e74` and
  `2a842acab109f4` **are** ancestors of HEAD (`git merge-base --is-
  ancestor` exit 0).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
- Record: Recent `dasd.c` work is other DASD correctness fixes (ESE,
  hanging unbind, etc.). This patch does not depend on them. Series
  patches 02–03 touch `dasd_erp.c` / `dasd_eckd.c`, not this hunk.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
- Record: Stefan Haberland is listed in MAINTAINERS for S390 DASD (`M:
  Stefan Haberland`, `M: Jan Hoeppner`). Jan Höppner reviewed. High-
  confidence maintainer fix.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
- Record: **Standalone.** Needs only `__dasd_cleanup_cqr` + `cqr->intrc`
  after `free_cp()`, both present. Not blocked on ESE full-track patches
  05–19. Applied by Axboe as `dc3e3f7306cb74066f231251602b1be5aaec7bd8`
  (block tree); that SHA is not in this checkout, which is expected.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
- Record:
  - Lore/msgid: `20260805111612.1285190-5-sth@linux.ibm.com` (patch
    04/19; msgid `-5` is 1-based including cover).
  - `b4 mbox` retrieved a 40-message thread (WebFetch to lore returned
    403).
  - Cover letter: first four patches are **existing bug fixes**; rest is
    ESE performance.
  - Jens Axboe: “Applied, thanks!” and listed this as commit
    `dc3e3f7306cb74066f231251602b1be5aaec7bd8`.
  - No NAK. Sashiko flagged **pre-existing** UAFs (flush path `cqr->dq`
    after free, `req->q` after `blk_mq_end_request`, etc.) — not
    introduced here; author said leftover findings would be handled
    separately.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
- Record: DASD maintainers (author + Reviewed-by Höppner); linux-block
  via Axboe. Correct audience.

**Step 4.3: SEARCH FOR THE BUG REPORT**
- Record: No user/syzbot report. Bug is pool reuse, not `kfree`, so
  KASAN often will not fire. Analysis is from code review by the
  maintainer.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
- Record: 19-patch ESE series. This hunk does not need patches 05–19.
  Independent of 01–03 for apply/correctness.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
- Record: **UNVERIFIED** — lore.kernel.org/stable WebFetch returned 403.
  No evidence in the retrieved thread of a stable NAK.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
- Record: `__dasd_cleanup_cqr()` only.

**Step 5.2: TRACE CALLERS**
- Record (this tree):
  1. Block tasklet (`dasd_block_tasklet` path ~2979): `dq = cqr->dq;`
     lock; `__dasd_cleanup_cqr(cqr);` unlock. Normal I/O completion.
  2. `dasd_flush_block_queue()` ~3085: same cleanup during flush/unbind.
- Called from tasklet / flush, not a rare ioctl-only path.

**Step 5.3: TRACE CALLEES**
- Record: `dasd_profile_end` (before free), `discipline->free_cp` →
  `dasd_sfree_request` → pool free, then `blk_mq_end_request` /
  `blk_mq_complete_request` / `blk_update_request`.

**Step 5.4: FOLLOW THE CALL CHAIN**
- Record: userspace I/O → `do_dasd_request` (`blk_mq_ops.queue_rq`) →
  `build_cp` / `dasd_smalloc_request` → interrupt/tasklet →
  `__dasd_cleanup_cqr`. **Reachable from ordinary block I/O** on DASD.
  Default `nr_hw_queues = 4`, so cleanup on one queue does **not**
  serialize `smalloc` on another (`do_dasd_request` only holds that
  queue’s `dq->lock`; pool uses `device->mem_lock`). Internal CCWs also
  `smalloc` without `dq->lock`. Race is real on SMP.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
- Record: `proc_bytes` already snapshotted in the same function.
  `dasd_erp.c` also snapshots `proc_bytes` around ERP. No other
  `cqr->intrc` use after `free_cp()` in this function.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
- Record: **Yes.** `drivers/s390/block/dasd.c` `__dasd_cleanup_cqr`
  (around 2782–2835):

```2792:2797:drivers/s390/block/dasd.c
        proc_bytes = cqr->proc_bytes;
        status = cqr->block->base->discipline->free_cp(cqr, req);
        if (status < 0)
                error = errno_to_blk_status(status);
        else if (status == 0) {
                switch (cqr->intrc) {
```

- `make kernelversion` / Makefile: **5.10.270**. `git describe HEAD`:
  `p-5.10-1-gce56b7a73b64b`.
- Introduced: 2013 (`d1ffc1f8660e74`); present for the entire 5.10
  lifetime.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
- Record: **Minor context only.** This tree maps `-EPERM` to
  `BLK_STS_NEXUS` without the later reservation comment. Same function
  shape. Expected apply: fuzz on the `case -EPERM` block, or a 3-line
  manual edit. No structural rework.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
- Record: `proc_bytes` snapshot is here (`5e6bdd37c5526`). `intrc` is
  still read after free. No substitute fix.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
- Record: `drivers/s390/block/dasd*` — **IMPORTANT** on s390 (primary
  disk driver for IBM Z). Not core mm/VFS, but production storage for
  every DASD user.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
- Record: Mature driver, still receiving correctness fixes. Not staging.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
- Record: **Driver-specific / platform-specific:** s390 DASD
  (`CONFIG_DASD`). Default 4 HW queues. Typical enterprise mainframe
  disks.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
- Record:
  - Failed block I/O (`free_cp` returns 0) **and** another CPU
    reallocates the CQR from the 2-page `ccw_chunks` pool before `intrc`
    is read.
  - Window is a few instructions, but the pool is tiny and multi-queue
    I/O makes reuse likely under load.
  - Unprivileged users can issue disk I/O; they cannot freely choose the
    race. Not a typical local-root primitive; it is a
    correctness/memory-safety bug.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
- Record:
  - `status` is already captured, so success vs fail of the request
    stays correct.
  - Wrong `intrc` maps `-EPERM` (stolen DASD lock → `BLK_STS_NEXUS`),
    `-ENOLINK` (failfast/transport), `-ETIMEDOUT` to whatever the reused
    block contains (usually 0 after `memset` → `BLK_STS_IOERR`).
  - Stolen-lock reported as generic I/O error can break HA/cluster
    handling (retry on a volume another system owns).
  - **Severity: HIGH** (wrong block completion status; use-after-reuse).
    Not a panic by itself.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
- Record:
  - **Benefit:** High for s390 DASD — correct
    timeout/transport/reservation errors; closes a real SMP reuse race.
  - **Risk:** Very low — ~6 lines, local stack copy, same pattern as
    `proc_bytes`.
  - **Ratio:** Strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real SMP use-after-reuse after `dasd_sfree_request()`.
- Wrong `blk_status_t` on failed I/O, including stolen-lock (`-EPERM`)
  vs generic `IOERR`.
- Tiny, obviously correct, matches existing `proc_bytes` snapshot in
  this file.
- DASD maintainer + co-maintainer review; Axboe applied it.
- Author classified it as a bug fix (series patches 1–4), not an ESE
  feature.
- Buggy code is in 5.10.270; default 4 HW queues make the race
  plausible.
- No new API/feature.

**AGAINST:**
- No `Reported-by` / syzbot / panic.
- Typical visible effect is misclassified errors, not a crash.
- Original patch context uses `BLK_STS_RESV_CONFLICT` (rename not in
  5.10).
- Related pre-existing UAFs (flush `cqr->dq`, `req->q`) are **not**
  fixed here — separate issues, not a reason to drop this snapshot.

**UNRESOLVED:**
- Stable-list discussion (lore 403).
- How often the race hits in production (unverified; maintainer asserts
  it).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — same snapshot as
   `proc_bytes`; reviewed; in mainline block tree.
2. Fixes a real bug that affects users? **PASS** — wrong completion
   status on DASD I/O.
3. Important (crash, security, corruption, deadlock)? **PASS** — use-
   after-reuse plus misreported reservation/timeout/transport errors on
   the s390 disk path.
4. Small and contained? **PASS** — one function, ~6 lines of logic.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — hunk is here; map
   `BLK_STS_RESV_CONFLICT` context to `BLK_STS_NEXUS`.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
- Record: Not a device-ID/quirk/DT/build/doc exception. Ordinary small
  correctness fix.

**Step 9.4: DECISION**
Backport. The bug exists in this 5.10 tree, the fix is surgical and
independent of the ESE performance series, and the risk is negligible
compared with completing I/O with a stale `intrc`.

---

## What the commit solves and why it matters here

`__dasd_cleanup_cqr()` already saves `proc_bytes` before `free_cp()`
because that call returns the CQR to a 2-page per-device pool. It still
reads `cqr->intrc` afterward. With default four blk-mq queues, another
CPU can `dasd_smalloc_request()` the same chunk (`memset` to zero, then
a new `intrc`). Failed requests then get the wrong `blk_status_t`
(timeout, transport, or stolen lock reported as generic I/O error). That
is a real SMP race on the main s390 disk driver, not an ESE feature.

## Stable rules / risk vs benefit

Meets the stable bar: real bug, small, no new API, applies with a
trivial `BLK_STS_NEXUS` context tweak. Benefit is correct I/O error
reporting and closing use-after-reuse; regression risk is a local
integer copy.

## Concerns

- Original diff context uses `BLK_STS_RESV_CONFLICT`; this tree still
  has `BLK_STS_NEXUS`. Adjust context; do not pull the rename.
- Do not pull series patches 05–19 (ESE performance).
- Pre-existing `cqr->dq` use after free in `dasd_flush_block_queue()` is
  out of scope.

## Verification

- **[Phase 1]** Tags: Reviewed-by Höppner; SOB Haberland + Axboe; Link
  msgid `...1285190-5`; no Fixes/Reported-by.
- **[Phase 1]** Cover letter via `b4 mbox`: “first 4 patches are fixes
  for existing bugs.”
- **[Phase 2]** Diff: `intrc` snapshot in `__dasd_cleanup_cqr` only;
  `+8/-2`.
- **[Phase 2]** This tree: `free_cp` → `dasd_sfree_request` →
  `dasd_free_chunk(&device->ccw_chunks)`; `smalloc` `memset`s the CQR.
- **[Phase 3]** `git blame`: `switch (cqr->intrc)` from `2a842acab109f4`
  / `d1ffc1f8660e74`; `proc_bytes` from `5e6bdd37c5526`.
- **[Phase 3]** `git merge-base --is-ancestor` those SHAs vs HEAD: all
  present.
- **[Phase 3]** Author is MAINTAINERS DASD `M:`.
- **[Phase 4]** `b4 mbox` 40 messages; Axboe applied as `dc3e3f7306cb`;
  Sashiko notes are pre-existing, not this hunk.
- **[Phase 4]** WebFetch lore/stable: 403 — UNVERIFIED.
- **[Phase 5]** Callers: block tasklet ~2979, flush ~3085; `queue_rq =
  do_dasd_request`; `nr_hw_queues = 4`.
- **[Phase 6]** `make kernelversion` 5.10.270; buggy `switch
  (cqr->intrc)` at dasd.c:2797.
- **[Phase 6]** `BLK_STS_RESV_CONFLICT` absent here
  (`include/linux/blk_types.h` has `BLK_STS_NEXUS` only).
- **[Phase 8]** Failure mode verified: `status` from `free_cp` return;
  only error *class* races.

**YES**

 drivers/s390/block/dasd.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index e7845c8ccc9ff..f6e86692a21d7 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -2736,17 +2736,23 @@ static void __dasd_cleanup_cqr(struct dasd_ccw_req *cqr)
 	struct request *req;
 	blk_status_t error = BLK_STS_OK;
 	unsigned int proc_bytes;
-	int status;
+	int status, intrc;
 
 	req = (struct request *) cqr->callback_data;
 	dasd_profile_end(cqr->block, cqr, req);
 
+	/*
+	 * free_cp() returns the request block to its memory pool, so snapshot
+	 * everything still needed from cqr before calling it - another CPU can
+	 * reallocate and overwrite the block right after.
+	 */
 	proc_bytes = cqr->proc_bytes;
+	intrc = cqr->intrc;
 	status = cqr->block->base->discipline->free_cp(cqr, req);
 	if (status < 0)
 		error = errno_to_blk_status(status);
 	else if (status == 0) {
-		switch (cqr->intrc) {
+		switch (intrc) {
 		case -EPERM:
 			/*
 			 * DASD doesn't implement SCSI/NVMe reservations, but it
-- 
2.53.0

