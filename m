Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21583576EC6;
	Mon, 31 Aug 2026 13:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184149; cv=none; b=N5dK1DmFEYDiOpwrJWfSVmzH4Vw0UD8YTngTHhLrDlcPkkNfIyL3U2ax8m0Scw8QmrBan50Bq4NXfamRsxOdd4QsaGns00AFyIW2k/woCmUnJXzxintjnH+yoDgZCLQeqdrYmuNmAmmT6lvrUepkCxF1v8J3VYAbStH2b9KNkz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184149; c=relaxed/simple;
	bh=73b6ujas0L0O7L8zE5h4eFQrJNPoI1vdv5F9kC9ZZDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uyXz5X7fPt1LEKYCeJhcC8kVfyi+5wADi/LT6YcyzpogLh8o5AFt9ibD5WwtgsGAwqLO1HgD2IfTUt15Tsj9hGITl8K7Csib/wYqyngWgQNuwWZKNkEGkn430qbVfi5WNAYH78hbm6mVoOAzqvKqbEMStxaBVaBc9vZQGMv2nWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q68yedK2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q68yedK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28C51F000E9;
	Mon, 31 Aug 2026 13:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184146;
	bh=KlSvKAY/kIXka37cbjpcQ5QVOoWOuQkNVF54QeykQFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q68yedK20Mqs2QJoHCbSyfQAqvLtW/UNzCLvN7LtcdmL4TPOw4ngMTxzDe8PiumNM
	 Wzk1coqmH1XBFzJzN19jKUPDPMeNVntYEAOdJSvuAnzpSkreSO7tHOC4POSHkdSXws
	 ID9jkH7qFUYQM+btudL0y0bPP0LTm9bgjDKYyUIBDEYuuasYkxykcGvcoomTLSt4ea
	 jy3aA8XFT6MTC3qNqHVy8edtdTR5245fX/H51Uci6Ua/wfn3dDkFanAYJ5kxxxFuzz
	 nUoZgQdRxdDVgW8F1tvJBgGvWC/WbUCXroHtAfJ7ScYm08jJjaXIftPE9UvETmu6Yk
	 sp0UnyhkUrpKw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mohamed Khalfella <mkhalfella@purestorage.com>,
	Randy Jennings <randyj@purestorage.com>,
	Hannes Reinecke <hare@kernel.org>,
	Daniel Wagner <dwagner@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	James Smart <jsmart833426@gmail.com>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	justin.tee@broadcom.com,
	nareshgottumukkala83@gmail.com,
	paul.ely@broadcom.com,
	sagi@grimberg.me,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] nvme-fc: Do not cancel requests in io target before it is initialized
Date: Mon, 31 Aug 2026 09:29:07 -0400
Message-ID: <20260831133314.4125787-519-sashal@kernel.org>
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

From: Mohamed Khalfella <mkhalfella@purestorage.com>

[ Upstream commit ee38469f88492df99e1d97f03aa40ecfd218934f ]

A new nvme-fc controller in CONNECTING state sees admin request timeout
schedules ctrl->ioerr_work to abort inflight requests. This ends up
calling __nvme_fc_abort_outstanding_ios() which aborts requests in both
admin and io tagsets. In case fc_ctrl->tag_set was not initialized we
see the warning below. This is because ctrl.queue_count is initialized
early in nvme_fc_alloc_ctrl().

nvme nvme0: NVME-FC{0}: starting error recovery Connectivity Loss
INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
lpfc 0000:ab:00.0: queue 0 connect admin queue failed (-6).
you didn't initialize this object before use?
turning off the locking correctness validator.
Workqueue: nvme-reset-wq nvme_fc_ctrl_ioerr_work [nvme_fc]
Call Trace:
 <TASK>
 dump_stack_lvl+0x57/0x80
 register_lock_class+0x567/0x580
 __lock_acquire+0x330/0xb90
 lock_acquire.part.0+0xad/0x210
 blk_mq_tagset_busy_iter+0xf9/0xc00
 __nvme_fc_abort_outstanding_ios+0x23f/0x320 [nvme_fc]
 nvme_fc_ctrl_ioerr_work+0x172/0x210 [nvme_fc]
 process_one_work+0x82c/0x1450
 worker_thread+0x5ee/0xfd0
 kthread+0x3a0/0x750
 ret_from_fork+0x439/0x670
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Update the check in __nvme_fc_abort_outstanding_ios() confirm that io
tagset was created before iterating over busy requests. Also make sure
to cancel ctrl->ioerr_work before removing io tagset.

Reviewed-by: Randy Jennings <randyj@purestorage.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Mohamed Khalfella <mkhalfella@purestorage.com>
Signed-off-by: James Smart <jsmart833426@gmail.com>
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `nvme-fc: Do not cancel requests in io
target before it is initialized`

**Local tree:** `v6.18.44` (Linux 6.18.y stable)
**Upstream commit:** `ee38469f88492` (2026-06-10)
**Candidate stable commit:** `7e1a5ff60479b` (exists in repo, **not**
merged into HEAD)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 – Subject line**
Record: `[nvme-fc] [prevent/ensure] Do not cancel requests in io tagset
before it is initialized`

**Step 1.2 – Tags**
Record:
- **Reviewed-by:** Randy Jennings, Hannes Reinecke, Daniel Wagner,
  Christoph Hellwig (four NVMe/FC reviewers)
- **Signed-off-by:** Mohamed Khalfella, James Smart, Maurizio Lombardi,
  Keith Busch
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, `Link:`, or
  `Tested-by:` tags
- Absence of stable tags is expected for manual review candidates

**Step 1.3 – Body analysis**
Record:
- **Bug:** During `NVME_CTRL_CONNECTING`, an admin request timeout
  schedules `ctrl->ioerr_work`, which calls
  `__nvme_fc_abort_outstanding_ios()`. That function aborts both admin
  and IO tagsets when `queue_count > 1`, but `fc_ctrl->tag_set` may not
  yet be initialized.
- **Symptom:** lockdep warning `"you didn't initialize this object
  before use?"` in `blk_mq_tagset_busy_iter()`; lockdep validator
  disabled; observed with lpfc during admin queue connect failure
  (`-6`).
- **Root cause:** `ctrl->queue_count` is set early in
  `nvme_fc_alloc_ctrl()`, while IO tagset creation is deferred to the
  connect path.
- **Version info:** Not specified; bug is structural in existing init
  ordering.

**Step 1.4 – Hidden bug fix?**
Record: **Yes.** Subject uses "Do not cancel" rather than "fix", but the
body and stack trace describe a real uninitialized-lock / premature
tagset iteration bug, plus a teardown race fixed by
`cancel_work_sync()`.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 – Inventory**
Record:
- **File:** `drivers/nvme/host/fc.c` (+6, −1)
- **Functions:** `__nvme_fc_abort_outstanding_ios()`,
  `nvme_fc_create_io_queues()` error path (`out_cleanup_tagset`)
- **Scope:** Single-file, surgical fix

**Step 2.2 – Code flow changes**
Record:
- **Hunk 1 (line 2462):** Before: abort IO tagset whenever `queue_count
  > 1`. After: also require `ctrl->ctrl.tagset` (set by
  `nvme_alloc_io_tag_set()`).
- **Hunk 2 (`out_cleanup_tagset`):** Before: directly remove IO tagset
  on create failure. After: `cancel_work_sync(&ctrl->ioerr_work)` first,
  preventing `ioerr_work` from iterating a tagset being torn down.

**Step 2.3 – Bug mechanism**
Record:
- **Category:** Uninitialized data / memory safety (uninitialized
  spinlock in `blk_mq_tag_set`)
- **Mechanism:** `queue_count > 1` is true from allocation, but
  `tag_set` is zero-initialized until `nvme_fc_create_io_queues()`
  succeeds in `nvme_alloc_io_tag_set()`. Error recovery during
  CONNECTING calls `blk_mq_tagset_busy_iter()` on an uninitialized
  tagset.

**Step 2.4 – Fix quality**
Record:
- Fix is minimal and follows existing patterns (`ctrl->ctrl.tagset` is
  already checked at lines 3236 and 3267 in the same file).
- Low regression risk: only skips IO abort when no tagset exists; admin
  queue abort still proceeds.
- `cancel_work_sync()` in the error path mirrors the pattern from
  `0a2c5495b6d1e` (already in this tree for `nvme_fc_delete_ctrl()`).

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 – Blame**
Record:
- Buggy `if (ctrl->ctrl.queue_count > 1)` at line 2462 introduced by
  `95ced8a2c72d` (James Smart, 2020-10-27): "nvme-fc: eliminate
  terminate_io use by nvme_fc_error_recovery"
- Early `queue_count` init dates to 2016–2017 (`e399441de9115`,
  `d858e5f04e58a4`)
- Tagset deferral comment at lines 3504–3508 confirms intentional late
  IO tagset init

**Step 3.2 – Fixes: tag**
Record: Not applicable (no `Fixes:` tag in commit message).

**Step 3.3 – Related file history**
Record:
- `ee59e3820ca92` (2025-01): "do not ignore connectivity loss during
  connecting" — increases CONNECTING-state error handling
- `f13409bb3f914` (2025-02): connectivity loss state machine changes —
  present in this tree
- `0a2c5495b6d1e`: related `ioerr_work` cancellation fix in delete path
  — already in HEAD
- `e810b290922c5`: admin tagset release on init failure — recent related
  work
- Standalone 1/1 patch, not part of a multi-patch dependency series

**Step 3.4 – Author context**
Record: Mohamed Khalfella (Pure Storage); patch submitted by Maurizio
Lombardi; reviewed by NVMe maintainers (Hellwig, Busch chain). Author is
an active NVMe-FC contributor.

**Step 3.5 – Prerequisites**
Record: No prerequisite commits required. Patch applies cleanly (`git
apply --check` passed). Uses only existing symbols (`ctrl->ctrl.tagset`,
`cancel_work_sync`).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 – Original discussion**
Record:
- `b4 dig -c 7e1a5ff60479b`:
  https://patch.msgid.link/20260528092734.258899-2-mlombard@redhat.com
- Standalone v1 patch (2026-05-28), not part of the larger Rapid Path
  Failure Recovery series
- Lore page blocked by bot protection; could not read inline review text

**Step 4.2 – Reviewers**
Record: `b4 dig -w` shows CC to `kbusch@kernel.org`, `hch@lst.de`,
`linux-nvme@lists.infradead.org`, `dwagner@suse.de`,
`randyj@purestorage.com`, `mkhalfella@purestorage.com`

**Step 4.3 – Bug report**
Record: Stack trace embedded in commit message; lpfc admin queue connect
failure (`-6`); no external bugzilla/syzbot link.

**Step 4.4 – Series context**
Record: `b4 dig -a` shows unrelated RFR series revisions; this fix was
submitted separately as `[PATCH 1/1]`.

**Step 4.5 – Stable list**
Record: UNVERIFIED — could not search lore stable archive due to fetch
restrictions; no stable nomination found in commit metadata.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 – Key functions**
Record: `__nvme_fc_abort_outstanding_ios()`, `nvme_fc_error_recovery()`,
`nvme_fc_ctrl_ioerr_work()`, `nvme_fc_create_io_queues()`

**Step 5.2 – Callers**
Record:
- `nvme_fc_ctrl_ioerr_work()` → `nvme_fc_error_recovery()` →
  `__nvme_fc_abort_outstanding_ios()` (CONNECTING path)
- `nvme_fc_delete_association()` →
  `__nvme_fc_abort_outstanding_ios(ctrl, false)`
- `ioerr_work` queued from `nvme_fc_fcpio_done()` (`check_error` at line
  2052) on transport errors
- Triggered during controller connect/reconnect — common enterprise FC
  storage path

**Step 5.3 – Callees**
Record: `blk_mq_tagset_busy_iter()`, `nvme_quiesce_io_queues()`,
`nvme_sync_io_queues()`, `nvme_remove_io_tag_set()`,
`cancel_work_sync()`

**Step 5.4 – Reachability**
Record:
- Userspace triggers NVMe-FC device discovery/connect via sysfs/fc
  transport
- Connectivity loss or admin timeout during CONNECTING is a realistic
  failure mode (documented in commit message with lpfc)
- **Reachable from normal device operation**, not obscure debug-only
  path

**Step 5.5 – Similar patterns**
Record: File already guards `ctrl->ctrl.tagset` before IO queue teardown
at lines 3236 and 3267; this fix aligns abort path with existing
teardown guards.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

**Step 6.1 – Buggy code present?**
Record: **Yes.** HEAD at `drivers/nvme/host/fc.c:2462` still has `if
(ctrl->ctrl.queue_count > 1)` without tagset check. `out_cleanup_tagset`
at line 2900 lacks `cancel_work_sync()`. Upstream fix `ee38469f88492` is
**not** an ancestor of HEAD.

**Step 6.2 – Backport complications**
Record: **Clean apply** — `git show 7e1a5ff60479b | git apply --check`
succeeded with no conflicts.

**Step 6.3 – Related fixes already present?**
Record: `0a2c5495b6d1e` fixes `ioerr_work` cancellation ordering in
`nvme_fc_delete_ctrl()` but does not cover the
`nvme_fc_create_io_queues()` failure path or the uninitialized tagset
abort. No duplicate fix found.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1 – Subsystem**
Record: `drivers/nvme/host/fc.c` — NVMe over Fibre Channel host driver.
**Criticality: IMPORTANT** (enterprise storage; not core kernel, but
stability-critical for FC deployments).

**Step 7.2 – Activity**
Record: 14 commits to `fc.c` since `ee59e3820ca92`; actively maintained
with recent connectivity/error-recovery work.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 – Who is affected**
Record: Users with `CONFIG_NVME_FC` and FC HBAs (lpfc, etc.) during
controller connect, reconnect, or connectivity-loss scenarios.

**Step 8.2 – Trigger conditions**
Record:
- Controller in `NVME_CTRL_CONNECTING`
- `queue_count > 1` (normal when IO queues configured)
- IO tagset not yet created (admin connect in progress or IO queue setup
  failed)
- Admin timeout or connectivity loss schedules `ioerr_work`
- **Likelihood:** Moderate during link/target issues — exactly when
  error recovery runs

**Step 8.3 – Failure severity**
Record:
- lockdep: `"you didn't initialize this object before use?"` — disables
  lock validator
- Without lockdep: use of uninitialized spinlock in
  `blk_mq_tagset_busy_iter()` — unpredictable behavior, potential
  oops/panic
- **Severity: HIGH** (kernel instability during error recovery)

**Step 8.4 – Risk vs benefit**
Record:
- **Benefit: HIGH** — prevents crash/warning during connect-failure
  error recovery on production FC storage
- **Risk: LOW** — 7-line change, matches existing tagset guards, four
  maintainer reviews
- **Ratio:** Strong benefit, minimal risk

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1 – Evidence summary**

| FOR backport | AGAINST backport |
|---|---|
| Real bug with reproduced stack trace | Only affects NVMe-FC users (not
all kernels) |
| Uninitialized lock use — HIGH severity | No syzbot/CVE, but real lpfc
scenario |
| Small, surgical, 4 Reviewed-by | Lore review text UNVERIFIED |
| Applies cleanly to 6.18.44 | — |
| Buggy code confirmed in HEAD | — |
| Complements existing `ioerr_work` fix | — |

**Step 9.2 – Stable rules checklist**

1. Obviously correct and tested? **PASS** — logic matches existing
   `ctrl->ctrl.tagset` guards; four subsystem reviewers
2. Fixes a real bug affecting users? **PASS** — lpfc connect failure
   scenario with stack trace
3. Important issue? **PASS** — kernel instability during error recovery
   (HIGH)
4. Small and contained? **PASS** — 1 file, 7 lines
5. No new features/APIs? **PASS** — error-path guard only
6. Can apply to local tree? **PASS** — clean apply verified

**Step 9.3 – Exception categories**
Record: Not a device-ID/quirk/DT/docs/build fix; qualifies as a straight
bug fix.

**Step 9.4 – Decision rationale**
This is a longstanding init-order bug: `queue_count` is set at
allocation time but the IO tagset is created later. Error recovery
during CONNECTING can call `blk_mq_tagset_busy_iter()` on an
uninitialized tagset. The fix is minimal, reviewed by NVMe maintainers,
applies cleanly to 6.18.44, and prevents kernel instability during
exactly the failure scenarios stable users encounter (connectivity loss,
admin queue connect failure). The complementary `cancel_work_sync()`
prevents a race when IO queue creation fails partway through.

---

## Verification

- [Phase 1] Parsed subject, tags, body; identified hidden bug fix
- [Phase 2] Read diff: tagset guard + `cancel_work_sync()` in error path
- [Phase 3] `git blame -L 2462`: buggy check from `95ced8a2c72d` (2020);
  early `queue_count` from 2016–2017
- [Phase 3] `git log --oneline -20 -- drivers/nvme/host/fc.c`: related
  commits identified; no duplicate fix
- [Phase 3] `git merge-base --is-ancestor ee38469f88492 HEAD`: upstream
  fix **NOT** in HEAD
- [Phase 3] `git show 7e1a5ff60479b | git apply --check`: applies
  cleanly
- [Phase 4] `b4 dig -c 7e1a5ff60479b`: lore URL found
- [Phase 4] `b4 dig -a`: standalone 1/1 patch confirmed
- [Phase 4] `b4 dig -w`: maintainers CC'd
- [Phase 4] UNVERIFIED: lore thread content (bot protection)
- [Phase 5] Traced call chain: `ioerr_work` → `nvme_fc_error_recovery` →
  `__nvme_fc_abort_outstanding_ios`
- [Phase 5] Verified `nvme_alloc_io_tag_set()` sets `ctrl->tagset` at
  `core.c:4961`
- [Phase 6] `git describe HEAD`: v6.18.44
- [Phase 6] Read HEAD `fc.c:2462,2900`: buggy code present
- [Phase 6] `0a2c5495b6d1e` in tree: related but incomplete coverage
- [Phase 8] Failure mode: uninitialized lock in
  `blk_mq_tagset_busy_iter`, severity HIGH

**YES**

 drivers/nvme/host/fc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index bf78faf1a4ffa..2e8cba91a853e 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2459,7 +2459,7 @@ __nvme_fc_abort_outstanding_ios(struct nvme_fc_ctrl *ctrl, bool start_queues)
 	 * io requests back to the block layer as part of normal completions
 	 * (but with error status).
 	 */
-	if (ctrl->ctrl.queue_count > 1) {
+	if (ctrl->ctrl.queue_count > 1 && ctrl->ctrl.tagset) {
 		nvme_quiesce_io_queues(&ctrl->ctrl);
 		nvme_sync_io_queues(&ctrl->ctrl);
 		blk_mq_tagset_busy_iter(&ctrl->tag_set,
@@ -2898,6 +2898,11 @@ nvme_fc_create_io_queues(struct nvme_fc_ctrl *ctrl)
 out_delete_hw_queues:
 	nvme_fc_delete_hw_io_queues(ctrl);
 out_cleanup_tagset:
+	/*
+	 * In CONNECTING state ctrl->ioerr_work will abort both admin
+	 * and io tagsets. Cancel it first before removing io tagset.
+	 */
+	cancel_work_sync(&ctrl->ioerr_work);
 	nvme_remove_io_tag_set(&ctrl->ctrl);
 	nvme_fc_free_io_queues(ctrl);
 
-- 
2.53.0

