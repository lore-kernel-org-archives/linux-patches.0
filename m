Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40AF3A1A5D;
	Mon, 20 Apr 2026 13:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776690994; cv=none; b=dJnTOVJmYt7dlg7ZjTiagAawB5DSgYxdxOwbg5mnHDDLR+BeNKtv9i+tVieXldDTfEmSBlQcvBJM5BzG0Q5IX9mh0sHK+GGamGjtFsKODFrqPGUbse4dZmCAuhCj1VMEf0TSrwAN5rvXnkODaYWCxYDVWuesqBHLUYy6TxyRtGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776690994; c=relaxed/simple;
	bh=1R6UORkzKlJcnPa2JPSrAaDPtQ3tNRSN74WycQiL+IM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cM+VsLtgp9zRsIuobtmu04WwkIwpiuMMJ/B7lGOoQA0G2NSM1HnLUieJ9hmoIvdQT5ReJI1/DbF3ZeYKJzYvMdulYcQ89zbzr2HN6oWxBW67DacY1eeS1zq7rQ7fBe2kSgdkApellI+mDEXdlN9jJ7VBmchCINOisNpyDc01+hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UtjMZ6ir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UtjMZ6ir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4FBC2BCB4;
	Mon, 20 Apr 2026 13:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776690994;
	bh=1R6UORkzKlJcnPa2JPSrAaDPtQ3tNRSN74WycQiL+IM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UtjMZ6irJBo2Hk7CAvtWcE9xQie8nEu9/Wp+HQMagzldir/du+3Tp6avwXKUt/Kna
	 Yp229N/Bza0beYvBsA411/+SKJ5UQ63LUDKisJUF3dOz9Z0hsbjCKvMQz7NYYp38Wq
	 FxThyXYgJ5nk8OY6G4UZKHoOWiiWq8jarIQDg3Y0WZQATYU28S9nSxA44PDSo41xXo
	 V1T1ewU6TyfU4lNJlQN6atsgbIcl4wvzKT8UM786/aP9YfFpnFb2NXbZ0n7m0LUkcm
	 xtgAsgNOlqYfpHXENet/cQeQMAqqYEEhrzQ+i1/RifxHgWovvX9kChYwYINYDS5B4v
	 Kd/rNozjp8SNQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nilay Shroff <nilay@linux.ibm.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sagi@grimberg.me,
	kch@nvidia.com,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.6] nvme-loop: do not cancel I/O and admin tagset during ctrl reset/shutdown
Date: Mon, 20 Apr 2026 09:08:18 -0400
Message-ID: <20260420131539.986432-32-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
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

From: Nilay Shroff <nilay@linux.ibm.com>

[ Upstream commit 886f35201591ded7958e16fe3750871d3ca0bcdf ]

Cancelling the I/O and admin tagsets during nvme-loop controller reset
or shutdown is unnecessary. The subsequent destruction of the I/O and
admin queues already waits for all in-flight target operations to
complete.

Cancelling the tagsets first also opens a race window. After a request
tag has been cancelled, a late completion from the target may still
arrive before the queues are destroyed. In that case the completion path
may access a request whose tag has already been cancelled or freed,
which can lead to a kernel crash. Please see below the kernel crash
encountered while running blktests nvme/040:

run blktests nvme/040 at 2026-03-08 06:34:27
loop0: detected capacity change from 0 to 2097152
nvmet: adding nsid 1 to subsystem blktests-subsystem-1
nvmet: Created nvm controller 1 for subsystem blktests-subsystem-1 for NQN nqn.2014-08.org.nvmexpress:uuid:0f01fb42-9f7f-4856-b0b3-51e60b8de349.
nvme nvme6: creating 96 I/O queues.
nvme nvme6: new ctrl: "blktests-subsystem-1"
nvme_log_error: 1 callbacks suppressed
block nvme6n1: no usable path - requeuing I/O
nvme6c6n1: Read(0x2) @ LBA 2096384, 128 blocks, Host Aborted Command (sct 0x3 / sc 0x71)
blk_print_req_error: 1 callbacks suppressed
I/O error, dev nvme6c6n1, sector 2096384 op 0x0:(READ) flags 0x2880700 phys_seg 1 prio class 2
block nvme6n1: no usable path - requeuing I/O
Kernel attempted to read user page (236) - exploit attempt? (uid: 0)
BUG: Kernel NULL pointer dereference on read at 0x00000236
Faulting instruction address: 0xc000000000961274
Oops: Kernel access of bad area, sig: 11 [#1]
LE PAGE_SIZE=64K MMU=Radix  SMP NR_CPUS=2048 NUMA pSeries
Modules linked in: nvme_loop nvme_fabrics loop nvmet null_blk rpadlpar_io rpaphp xsk_diag bonding rfkill nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables nfnetlink pseries_rng dax_pmem vmx_crypto drm drm_panel_orientation_quirks xfs mlx5_core nvme bnx2x sd_mod nd_pmem nd_btt nvme_core sg papr_scm tls libnvdimm ibmvscsi ibmveth scsi_transport_srp nvme_keyring nvme_auth mdio hkdf pseries_wdt dm_mirror dm_region_hash dm_log dm_mod fuse [last unloaded: loop]
CPU: 25 UID: 0 PID: 0 Comm: swapper/25 Kdump: loaded Not tainted 7.0.0-rc3+ #14 PREEMPT
Hardware name: IBM,9043-MRX Power11 (architected) 0x820200 0xf000007 of:IBM,FW1120.00 (RF1120_128) hv:phyp pSeries
NIP:  c000000000961274 LR: c008000009af1808 CTR: c00000000096124c
REGS: c0000007ffc0f910 TRAP: 0300   Not tainted  (7.0.0-rc3+)
MSR:  8000000000009033 <SF,EE,ME,IR,DR,RI,LE>  CR: 22222222  XER: 00000000
CFAR: c008000009af232c DAR: 0000000000000236 DSISR: 40000000 IRQMASK: 0
GPR00: c008000009af17fc c0000007ffc0fbb0 c000000001c78100 c0000000be05cc00
GPR04: 0000000000000001 0000000000000000 0000000000000007 0000000000000000
GPR08: 0000000000000000 0000000000000000 0000000000000002 c008000009af2318
GPR12: c00000000096124c c0000007ffdab880 0000000000000000 0000000000000000
GPR16: 0000000000000010 0000000000000000 0000000000000004 0000000000000000
GPR20: 0000000000000001 c000000002ca2b00 0000000100043bb2 000000000000000a
GPR24: 000000000000000a 0000000000000000 0000000000000000 0000000000000000
GPR28: c000000084021d40 c000000084021d50 c0000000be05cd60 c0000000be05cc00
NIP [c000000000961274] blk_mq_complete_request_remote+0x28/0x2d4
LR [c008000009af1808] nvme_loop_queue_response+0x110/0x290 [nvme_loop]
Call Trace:
 0xc00000000502c640 (unreliable)
 nvme_loop_queue_response+0x104/0x290 [nvme_loop]
 __nvmet_req_complete+0x80/0x498 [nvmet]
 nvmet_req_complete+0x24/0xf8 [nvmet]
 nvmet_bio_done+0x58/0xcc [nvmet]
 bio_endio+0x250/0x390
 blk_update_request+0x2e8/0x68c
 blk_mq_end_request+0x30/0x5c
 lo_complete_rq+0x94/0x110 [loop]
 blk_complete_reqs+0x78/0x98
 handle_softirqs+0x148/0x454
 do_softirq_own_stack+0x3c/0x50
 __irq_exit_rcu+0x18c/0x1b4
 irq_exit+0x1c/0x34
 do_IRQ+0x114/0x278
 hardware_interrupt_common_virt+0x28c/0x290

Since the queue teardown path already guarantees that all target-side
operations have completed, cancelling the tagsets is redundant and
unsafe. So avoid cancelling the I/O and admin tagsets during controller
reset and shutdown.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed. Let me compile the complete
analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: `nvme-loop` (NVMe over Fabrics loopback target driver)
- **Action verb**: "do not cancel" - explicitly removing code that
  causes a bug
- **Summary**: Removes unnecessary and dangerous tagset cancellation
  from controller reset/shutdown path

### Step 1.2: Tags
- **Reviewed-by**: Christoph Hellwig `<hch@lst.de>` - NVMe subsystem co-
  maintainer, a very strong review signal
- **Signed-off-by**: Nilay Shroff `<nilay@linux.ibm.com>` - author, IBM
  NVMe developer with history of nvme-loop fixes
- **Signed-off-by**: Keith Busch `<kbusch@kernel.org>` - NVMe maintainer
  who applied the patch
- No Fixes: tag, no Cc: stable (expected for AUTOSEL candidates)
- No Reported-by other than the author (crash found during blktests)

### Step 1.3: Commit Body Analysis
The bug: During nvme-loop controller shutdown, the code cancels tagsets
then destroys queues. But after a tag is cancelled, a late target-side
completion can arrive (via `nvme_loop_queue_response()`) before queue
destruction. This completion accesses a request that's already been
cancelled/freed, causing a NULL pointer dereference in
`blk_mq_complete_request_remote()`.

The full crash stack trace is included showing `rq->mq_hctx` is NULL,
reproducing on blktests nvme/040 on IBM Power11 hardware with kernel
7.0.0-rc3+.

### Step 1.4: Hidden Bug Fix Detection
This is an explicit, clear crash fix, not disguised.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed**: 1 (`drivers/nvme/target/loop.c`)
- **Lines removed**: 2, **Lines added**: 0
- **Functions modified**: `nvme_loop_shutdown_ctrl()`
- **Scope**: Extremely surgical - single function, 2 line removal

### Step 2.2: Code Flow Change
**Before**: `quiesce_io -> cancel_tagset -> destroy_io_queues ->
quiesce_admin -> disable_ctrl -> cancel_admin_tagset ->
destroy_admin_queue`

**After**: `quiesce_io -> destroy_io_queues -> quiesce_admin ->
disable_ctrl -> destroy_admin_queue`

The cancel step is removed because `nvmet_sq_destroy()` inside the
destroy functions already calls `percpu_ref_kill_and_confirm()` +
`wait_for_completion()` twice, guaranteeing all in-flight target
operations complete before continuing.

### Step 2.3: Bug Mechanism
This is a **race condition / use-after-free** fix:
1. `nvme_cancel_tagset()` iterates in-flight requests and calls
   `blk_mq_complete_request()` on each, marking them done
2. The target side (running in the nvmet workqueue) has an outstanding
   bio that hasn't completed yet
3. When `nvmet_bio_done()` fires, it goes through `nvmet_req_complete()`
   -> `nvme_loop_queue_response()` -> `blk_mq_complete_request_remote()`
4. At this point, the request has already been freed/cancelled, so
   `rq->mq_hctx` is NULL -> crash

### Step 2.4: Fix Quality
- **Obviously correct**: The cancel calls are demonstrably redundant
  because `nvmet_sq_destroy()` does a full wait-for-completion. Verified
  in code at line 969-970 of `drivers/nvme/target/core.c`.
- **Minimal**: Only 2 lines removed
- **Regression risk**: Very low. The cancel is redundant for nvme-loop.
  Other transports (tcp, rdma, pci) still use cancel because they don't
  have a local target queue to wait on.
- **Important**: The error path cancel calls (lines 496 and 636) are
  preserved - those are during controller init, not shutdown, where
  queues aren't fully set up.

---

## PHASE 3: GIT HISTORY

### Step 3.1: Blame
The `nvme_cancel_tagset()` and `nvme_cancel_admin_tagset()` calls were
introduced by commit `e41f8c0222e30` (Sagi Grimberg, 2022-06-26) "nvme-
loop: use nvme core helpers to cancel all requests in a tagset". That
was a pure refactoring - replacing open-coded `blk_mq_tagset_busy_iter`
with the helper. The underlying cancel logic existed since the original
nvme-loop driver.

### Step 3.2: Fixes Tag
No Fixes: tag. The bug is inherent to having cancel + destroy in nvme-
loop's shutdown, which has been this way since at least v6.0. A strict
Fixes: tag would point to `e41f8c0222e30` (v6.0+).

### Step 3.3: Related Changes
The same author (Nilay Shroff) previously submitted `c199fac88fe7c`
"nvme-loop: flush off pending I/O while shutting down loop controller"
which added `nvme_unquiesce_*` calls to the destroy functions. That's a
related but distinct fix for a different race (hung tasks from I/O
sneaking in between quiesce and destroy).

### Step 3.4: Author
Nilay Shroff is an active NVMe developer at IBM, with multiple
contributions to the nvme subsystem. Previous nvme-loop
shutdown/crashfix patches from him were accepted and merged.

### Step 3.5: Dependencies
**This patch is self-contained**. It only removes 2 lines. No
prerequisites needed.

---

## PHASE 4: MAILING LIST

### Step 4.1: Original Thread
Found via infradead pipermail:
- **Cover letter**: [http://lists.infradead.org/pipermail/linux-nvme/202
  6-March/061768.html](http://lists.infradead.org/pipermail/linux-
  nvme/2026-March/061768.html)
- **Patch**: [http://lists.infradead.org/pipermail/linux-nvme/2026-
  March/061767.html](http://lists.infradead.org/pipermail/linux-
  nvme/2026-March/061767.html)

The cover letter provides an even more detailed explanation of the race,
showing that `rq->mq_hctx` is NULL when the kernel tries to dereference
it.

### Step 4.2: Review
- **Christoph Hellwig** (NVMe co-maintainer) on Mar 20: "Looks good:
  Reviewed-by: Christoph Hellwig"
- **Keith Busch** (NVMe maintainer) on Mar 24: "Thanks, applied to
  nvme-7.1."
- No NAKs, no concerns raised by any reviewer.
- Single version patch (no v2/v3 iterations needed).

### Step 4.3-4.5: No stable-specific discussion found. No additional
reports.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.2: Functions
The modified function `nvme_loop_shutdown_ctrl()` is called from:
1. `nvme_loop_delete_ctrl_host()` - controller deletion path
2. `nvme_loop_reset_ctrl_work()` - controller reset path

Both are critical controller lifecycle paths.

### Step 5.3-5.4: Callees
`nvme_cancel_tagset()` calls `blk_mq_tagset_busy_iter()` +
`nvme_cancel_request()` which calls `blk_mq_complete_request()`. The
late completion from `nvmet_bio_done()` -> `nvme_loop_queue_response()`
also calls `blk_mq_complete_request()` on the same request. Double-
completion of a freed request = crash.

`nvmet_sq_destroy()` calls `percpu_ref_kill_and_confirm()` followed by
`wait_for_completion(&sq->confirm_done)` and
`wait_for_completion(&sq->free_done)` - this guarantees all in-flight
target operations complete before proceeding.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy code in stable trees
- `e41f8c0222e30` (introduced the cancel helper calls) is in **v6.0,
  v6.1, v6.6** and later
- The bug exists in all active stable trees: **v6.1.y, v6.6.y, v6.12.y**
- NOT present in v5.15 (the older open-coded cancel was different)

### Step 6.2: Backport complications
The patch removes the exact same 2 lines (`nvme_cancel_tagset()` and
`nvme_cancel_admin_tagset()`) from `nvme_loop_shutdown_ctrl()`. Verified
the v6.6 and v6.1 code has these lines at the same locations. The
surrounding context differs slightly (`nvme_ctrl_state()` vs
`ctrl->ctrl.state`, presence/absence of CQ sharing code), but the lines
being removed are identical. **Should apply cleanly with trivial context
adjustment.**

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
- **Subsystem**: NVMe over Fabrics loopback
  (`drivers/nvme/target/loop.c`)
- **Criticality**: IMPORTANT - NVMe loopback is used in testing
  (blktests), CI pipelines, and some production setups for local NVMe-oF
  workloads.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
Users of nvme-loop (NVMe over Fabrics loopback) who perform controller
reset/shutdown while I/O is in-flight.

### Step 8.2: Trigger conditions
Triggered during blktests nvme/040 - a standard NVMe test. Race requires
in-flight I/O during controller shutdown, which is a normal occurrence.

### Step 8.3: Failure mode
**CRITICAL**: Kernel NULL pointer dereference (oops), crash in softirq
context (`swapper/25` at CPU 25). This is a system crash.

### Step 8.4: Risk-Benefit
- **Benefit**: Very HIGH - prevents kernel crash during normal NVMe
  loopback controller shutdown
- **Risk**: Very LOW - 2 lines removed, confirmed redundant by code
  analysis (`nvmet_sq_destroy` does wait_for_completion), reviewed by
  subsystem co-maintainer
- **Ratio**: Extremely favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence
**FOR backporting:**
- Fixes a real kernel crash (NULL pointer dereference -> oops)
- Crash reproduced with standard blktests nvme/040
- Extremely small: 2 lines removed
- Fix is obviously correct: removed code is provably redundant
- Reviewed by Christoph Hellwig (NVMe co-maintainer)
- Applied by Keith Busch (NVMe maintainer)
- Buggy code exists in stable trees v6.1.y, v6.6.y, v6.12.y
- Patch should apply cleanly with at most trivial context adjustment
- No regression risk - other transports unaffected
- Author has established track record with nvme-loop fixes

**AGAINST backporting:**
- No Fixes: tag (expected for AUTOSEL candidates)
- No Cc: stable (expected)
- Patch was applied to nvme-7.1, not tagged as a fix for 7.0

### Step 9.2: Stable Rules Checklist
1. **Obviously correct and tested?** YES - crash stack trace + blktests
   reproduction, reviewed by co-maintainer
2. **Fixes a real bug?** YES - kernel crash/oops
3. **Important issue?** YES - system crash (CRITICAL)
4. **Small and contained?** YES - 2 lines in 1 file
5. **No new features/APIs?** Correct - pure removal
6. **Can apply to stable?** YES - lines exist identically in v6.1.y,
   v6.6.y, v6.12.y

### Step 9.3: Exception categories
Not applicable - this is a standard crash fix, not an exception
category.

---

## Verification

- [Phase 1] Parsed tags: Reviewed-by Christoph Hellwig, Signed-off-by
  Keith Busch (NVMe maintainer)
- [Phase 2] Diff analysis: 2 lines removed from
  `nvme_loop_shutdown_ctrl()`, removing `nvme_cancel_tagset()` and
  `nvme_cancel_admin_tagset()` calls
- [Phase 2] Verified `nvmet_sq_destroy()` does
  `wait_for_completion(&sq->confirm_done)` +
  `wait_for_completion(&sq->free_done)` at lines 969-970 of
  `drivers/nvme/target/core.c` - confirms redundancy claim
- [Phase 3] git blame: cancel calls introduced by `e41f8c0222e30` (v6.0,
  Sagi Grimberg, 2022-06-26)
- [Phase 3] `git merge-base --is-ancestor`: e41f8c0222e30 is in v6.1
  (YES), v6.6 (YES), NOT in v5.15
- [Phase 3] Author's prior commit `c199fac88fe7c` (related nvme-loop
  shutdown fix) confirms expertise
- [Phase 4] Original submission found on lists.infradead.org: cover
  letter (#061768), patch (#061767)
- [Phase 4] Christoph Hellwig review (#061882): "Looks good: Reviewed-
  by"
- [Phase 4] Keith Busch applied (#061934): "Thanks, applied to nvme-7.1"
- [Phase 4] Single version, no v2/v3, no NAKs or concerns
- [Phase 5] `nvme_loop_shutdown_ctrl()` called from controller delete
  and reset paths
- [Phase 5] Verified `nvme_cancel_request()` calls
  `blk_mq_complete_request()`, creating the double-completion race with
  target-side `nvme_loop_queue_response()`
- [Phase 6] Verified v6.6 and v6.1 stable trees have the same cancel
  lines at identical locations in `nvme_loop_shutdown_ctrl()`
- [Phase 6] Patch will need trivial context adjustment for v6.6
  (`ctrl->ctrl.state` vs `nvme_ctrl_state()`)
- [Phase 8] Failure mode: NULL pointer dereference in softirq -> kernel
  oops, CRITICAL severity

This is a textbook stable backport candidate: a tiny, obviously correct
crash fix for a real race condition, reviewed by the subsystem co-
maintainer, with zero regression risk.

**YES**

 drivers/nvme/target/loop.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index 4b3f4f11928d4..d98d0cdc5d6fa 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -419,7 +419,6 @@ static void nvme_loop_shutdown_ctrl(struct nvme_loop_ctrl *ctrl)
 {
 	if (ctrl->ctrl.queue_count > 1) {
 		nvme_quiesce_io_queues(&ctrl->ctrl);
-		nvme_cancel_tagset(&ctrl->ctrl);
 		nvme_loop_destroy_io_queues(ctrl);
 	}
 
@@ -427,7 +426,6 @@ static void nvme_loop_shutdown_ctrl(struct nvme_loop_ctrl *ctrl)
 	if (nvme_ctrl_state(&ctrl->ctrl) == NVME_CTRL_LIVE)
 		nvme_disable_ctrl(&ctrl->ctrl, true);
 
-	nvme_cancel_admin_tagset(&ctrl->ctrl);
 	nvme_loop_destroy_admin_queue(ctrl);
 }
 
-- 
2.53.0

