Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C863511867;
	Mon, 19 Oct 2026 13:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418279; cv=none; b=rhPIjDg6Tj0Umr6fq0pOZaOpbayCfWUww0bf9tRYvuWhlxDITrZLhWwHaenl2zlYBolb0A8w0f+bpLxdmAYcjsv3Y+CBtBLvwV25wBv1ZVoI7Q9S/oHYKzY5n8/JDMvspGL4Ey2Rucj4zAxWDmtsiiVssoGTjKX03a5QXjm9w+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418279; c=relaxed/simple;
	bh=XDU6+6pwtadhr6doWqCQ3gECBs9cYuwXo/tfRjSkB9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RkFk0JHMsu5lpYlwrLGRXX9s++bfk7Oyy5C3xM/4wlE05ITXyOq5g1Mx9F/D00iqAyExGESXXhtXDfrHTbWsP/0DZY48Fm3sDVs+r3ZkiI+riyBZmY6KDrY+sHER8O9IZ22q2L8UiWrDd7428hajJMDldf7MLzNkQGhWiQmK27Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e2uiYRH+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e2uiYRH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CACF1F000C4;
	Mon, 19 Oct 2026 13:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418277;
	bh=2Gc4i/MTQwtF5eXqj1ku3FnA/N5RAlrlxKhUjAUIBGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e2uiYRH+wFMY93LJpmKJ1Op3ABibC+DCjAO8pyj2eeXVv36XCP2/v/JKoZr8fQVuM
	 w82J1CkWsqMI4epFONNeiupARJeTem9fBXEcGbn1lJ86GzB5OMGUEiCGKbj3R3t324
	 1PvGqFKU9aDWcZRmQ6/HLPjOpLPzCPtP7F03JWcXN4tEeKd4+lk4D+Q3YmqmB5g54s
	 t8ikzpX9m3P9/Zwa1n2a1DfiwrfHP2H5wgtGQVM7c+a7Rtau9feoNxRFeN47nQKfRu
	 DzEAif74DqfwDCPorYHdZ0T/ZtZND/hfPSIDcazb+QameJIAz6Vwa0Y9PbbB2nL3VV
	 wycOm0ItOCrZw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jinqian Yang <yangjinqian1@huawei.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	jasowangio@gmail.com,
	eperezma@redhat.com,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] virtio_ring: fix infinite loop in virtnet_poll_cleantx when device is broken
Date: Mon, 19 Oct 2026 09:47:04 -0400
Message-ID: <20261019135441.1420968-133-sashal@kernel.org>
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

From: Jinqian Yang <yangjinqian1@huawei.com>

[ Upstream commit 0d0eff39ceb3dcbf7847a6f4517086c207c60081 ]

virtnet_poll_cleantx() contains a do-while loop that cleans up
transmitted TX buffers and calls virtqueue_enable_cb_delayed() to check
whether more buffers need processing. When the virtio backend stops
responding during guest reboot, used->idx is never updated, so
virtqueue_enable_cb_delayed() always returns false and the loop never
terminates. Then it will block reboot process, and the guest will hang.

The problem occurs during guest reboot under network traffic:

  1. kernel_restart() -> device_shutdown() traverses the device list
  2. virtio_dev_shutdown() calls virtio_break_device() which sets
     vq->broken = true
  3. virtio_dev_shutdown() then calls virtio_synchronize_cbs() to wait
     for in-flight callbacks to complete
  4. A virtio interrupt fires, softirq is deferred to ksoftirqd which
     calls net_rx_action() -> virtnet_poll() -> virtnet_poll_cleantx()
  5. virtnet_poll_cleantx() enters the do-while loop and never exits
     because the QEMU backend has stopped updating used->idx, despite
     vq->broken having been set to true in step 2.

Since the loop runs inside ksoftirqd (a SCHED_OTHER kthread), it is
visible to the scheduler and does not trigger a hard lockup. However,
the kthread never leaves the loop, so RCU detects it as a CPU stall
and reports it periodically. Meanwhile, the reboot process remains
blocked in device_shutdown() because virtio_dev_shutdown() cannot
complete its synchronization step, and the guest hangs permanently.

This can be reproduced on a guest with a virtio-net device: run iperf3
traffic in the guest, then trigger reboot. The reboot occasionally hangs
permanently with RCU stall on ksoftirqd.

Observed on ARM64 KVM guest:

  CPU#1 RCU stall (ksoftirqd/1), repeated periodically:
    virtqueue_enable_cb_delayed_split <- virtnet_poll <- __napi_poll <-
    net_rx_action <- handle_softirqs <- run_ksoftirqd <-
    smpboot_thread_fn <- kthread

Fix by adding a vq->broken check in virtqueue_enable_cb_delayed(), so
that the loop exits immediately when the device is broken, allowing
the device shutdown to proceed.

Signed-off-by: Jinqian Yang <yangjinqian1@huawei.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260716115940.394832-1-yangjinqian1@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have the local-tree picture: the cleanup loop is here,
`virtio_dev_shutdown()` is not, and the missing `vq->broken` check is
still a hang. Next I’ll write the full nine-phase verdict from that
evidence.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: [virtio_ring] [fix] [stop infinite loop in virtnet_poll_cleantx
when the virtqueue is marked broken]

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Signed-off-by: Jinqian Yang <yangjinqian1@huawei.com> (author)
- Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com> (virtio co-
  maintainer)
- Signed-off-by: Michael S. Tsirkin <mst@redhat.com> (virtio maintainer)
- Message-ID: <20260716115940.394832-1-yangjinqian1@huawei.com>
- No Fixes: tag (expected)
- No Cc: stable (expected)
- No Reported-by / Tested-by / syzbot / Link: tags in the provided
  message
- Ignore pipeline markers (none present in the provided text besides
  normal maintainer SOBs)

Notable: maintainer + co-maintainer sign-off; author describes a real
reproduced hang, not a theoretical cleanup.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: `virtnet_poll_cleantx()` do-while loops on
  `virtqueue_enable_cb_delayed()` returning false. If the backend never
  advances `used->idx`, the loop never ends.
- Symptom: guest reboot hang under virtio-net traffic; RCU stalls on
  ksoftirqd (`virtqueue_enable_cb_delayed_split <- virtnet_poll <-
  net_rx_action <- run_ksoftirqd`); `device_shutdown()` blocked in
  `virtio_synchronize_cbs()`.
- Trigger described: `kernel_restart()` → `device_shutdown()` →
  `virtio_dev_shutdown()` sets `vq->broken` then waits for callbacks; a
  deferred NAPI poll then spins forever.
- Root cause: `virtqueue_enable_cb_delayed()` keeps polling `used->idx`
  even after `vq->broken` is true.
- Reproduction: iperf3 + reboot on ARM64 KVM guest; occasional permanent
  hang.
- Version info in the message: none named; the reboot path names
  `virtio_dev_shutdown()`.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a hidden fix. Subject and body are an explicit
hang/infinite-loop fix. Not cleanup, refactor, or a feature.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/virtio/virtio_ring.c` only
- Scope: +8 lines (comment + `if (unlikely(vq->broken)) return true;`)
- Function: `virtqueue_enable_cb_delayed()`
- Classification: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Before: convert `_vq` to `vring_virtqueue`, optionally clear
  `event_triggered`, then call split/packed `enable_cb_delayed`, which
  looks at `used->idx` / packed used descriptors and returns false if
  “many pending buffers” remain.
- After: if `vq->broken`, return true immediately so callers of the form
  `while (!virtqueue_enable_cb_delayed())` exit.
- Path affected: any enable-cb-delayed poll/cleanup loop after the
  device is marked broken. Not a new feature path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- Category: logic/correctness that produces an infinite loop / hang
  (also a missing “device broken” abort, same family as other virtqueue
  ops).
- Mechanism: `virtqueue_enable_cb_delayed()` did not honor `vq->broken`,
  unlike `virtqueue_poll()`, `virtqueue_add_*()`,
  `virtqueue_get_buf_*()`, and `virtqueue_notify()` in this tree.
  Callers treat a false return as “more work remains”; on a dead backend
  that is never true, so they spin.
- Fix: return true when broken, matching `virtqueue_enable_cb()` which
  already becomes true because `virtqueue_poll()` returns false when
  broken.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: one `unlikely(vq->broken)` check at the API
  boundary, same pattern as sibling helpers.
- Minimal: no unrelated edits.
- Regression risk: low. Returning true skips further used-ring polling
  and skips re-enabling callbacks. `vring_interrupt()` already refuses
  to invoke callbacks when broken (returns IRQ_HANDLED / IRQ_NONE
  without calling `vq->callback`). Leftover TX buffers are still
  collected later by `free_unused_bufs()` /
  `virtqueue_detach_unused_buf()` on teardown.
- Red flags: none (no API change, no new lock, no data-structure
  change).

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- `virtqueue_enable_cb_delayed()` wrapper: e6f633e5beab65 /
  1ce9e6055fa0a9 (Tiwei Bie, 2018) — packed/split split-up; the function
  itself is older.
- The spinning loop in `virtnet_poll_cleantx` / `start_xmit`:
  a7766ef18b3367 (“virtio_net: disable cb aggressively”, 2021-07-08).
  Present in this tree (`git merge-base --is-ancestor` exit 0).
- `virtqueue_poll()` already has `if (unlikely(vq->broken)) return
  false;` in this tree.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag. The hang the author describes is the interaction
of that 2021 loop with later reboot teardown, not a one-line typo in a
single commit.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Recent `virtio_ring.c` work here is KCSAN tagging, resize/reset args,
  premapped DMA — unrelated.
- This is standalone, not patch X/Y of a series in-tree.
- Mailing-list series is v1→v3 of the same fix (see Phase 4).

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record:
- Jinqian Yang has no other virtio_ring/virtio_net commits in this tree.
  Not the subsystem maintainer.
- Weight comes from Reviewed-by Xuan Zhuo and SOB Michael S. Tsirkin.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record:
- The insertion does not use `VIRTQUEUE_CALL` (mainline) vs the 6.12
  ternary packed/split call. The new code sits before that dispatch.
- No new helpers. Can apply standalone.
- The *reboot* scenario names `virtio_dev_shutdown()`, which is **not**
  in this tree (see Phase 6). The *code defect* does not depend on that
  function.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c <message-id>`: no matching commit object in this checkout
  (candidate is not on HEAD).
- `b4 mbox` for Message-ID
  20260716115940.394832-1-yangjinqian1@huawei.com: lore returned 404.
- Fallback mirrors (verified):
  - v3: https://lists.openwall.net/linux-kernel/2026/07/16/1135
  - v1: https://lkml.iu.edu/2607.1/10830.html (changed `virtio_net.c`
    loop to also test `virtqueue_is_broken()`)
  - v2 changelog: moved the check into `virtqueue_enable_cb_delayed()`
  - v3: subject prefix only (`virtio_net:` → `virtio_ring:`)
  - Xuan Zhuo Reviewed-by on v3: https://lkml.rescloud.iu.edu/hypermail/
    linux/kernel/2607.2/09380.html
- No NAK found. Applied version is v3 (latest).
- No reviewer “Cc: stable” found in the retrieved mail.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: v3 To/Cc (from the v3 post): mst@redhat.com,
jasowang@redhat.com, xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
netdev maintainers; lists netdev, virtualization, linux-kernel.
Appropriate virtio + netdev audience. Reviewed-by Xuan Zhuo; merged via
MST.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla. Author reports a reproduced ARM64 KVM guest
hang (iperf3 + reboot). That is a real user-visible failure, but the
reboot recipe uses `virtio_dev_shutdown()` (Phase 6).

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Single-patch series, v1–v3. v1 only fixed the virtio_net loop;
v2/v3 fixed the core helper so every looping caller is covered
(`start_xmit` in this tree has the same pattern). No extra patches
required.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable fetch returned 403; web search of stable
archives did not show this subject. UNVERIFIED: no evidence this was
already requested or rejected for stable.

Related context (verified via git objects + public commit page):
8bd2fa086a04 (“virtio: break and reset virtio devices on
device_shutdown()”) added `virtio_dev_shutdown()`. `git merge-base --is-
ancestor 8bd2fa086a04 HEAD` → not an ancestor. Same SHA **is** an
ancestor of v6.15, not of v6.12.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `virtqueue_enable_cb_delayed()` (exported). Indirectly
`virtqueue_enable_cb_delayed_split()` / `_packed()` are skipped when
broken.

**Step 5.2: TRACE CALLERS**
Record (this tree, `git grep`):
- `drivers/net/virtio_net.c`:
  - `virtnet_poll_cleantx()` — do-while until enable_cb_delayed is true
    (the hang)
  - `start_xmit()` — same loop when napi-tx and !xmit_more
  - TX-stop path (~1066/1068) — not a spin loop; false just schedules
    NAPI / frees old bufs
- `tools/virtio/*` test code only
No other in-tree driver loops on this helper.

Call context: NAPI/`ksoftirqd` (`virtnet_poll` → `virtnet_poll_cleantx`)
and `ndo_start_xmit`. Userspace-reachable via normal virtio-net RX/TX.

**Step 5.3: TRACE CALLEES**
Record: `to_vvq()`, optional `event_triggered` clear, then split/packed
enable which does `START_USE`, writes used-event idx, compares
`used->idx` vs `last_used_idx`. No alloc; ring MMIO/memory only.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record:
- `virtnet_poll()` (line 2892) always calls `virtnet_poll_cleantx()`
  then `virtnet_receive()`.
- `virtnet_poll` is the RX NAPI poll; with napi-tx it also reaps TX.
- Reachable from virtio-net interrupts / NAPI. Yes, userspace traffic
  can keep this hot.

Broken-device entry points in **this** tree (not reboot shutdown):
- `virtio_pci_remove()`: `if (!pci_device_is_present(pci_dev))
  virtio_break_device(...)` then `unregister_virtio_device()` (verified
  in `drivers/virtio/virtio_pci_common.c`).
- `virtqueue_notify()`: sets `vq->broken` if `notify()` fails.
- `virtio_reset_device()`: `virtio_break_device` +
  `virtio_synchronize_cbs` only under
  `CONFIG_VIRTIO_HARDEN_NOTIFICATION`, which `depends on BROKEN` here —
  not a production 6.12 config.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same do-while in `start_xmit()`. Core virtqueue ops already
abort on `vq->broken`. This helper was the inconsistent one. No second
copy of the bug in other drivers in this tree.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- Tree: **6.12.111** (`make kernelversion`), branch `pending-6.12`, `git
  describe` p-6.12-3-gc504cf0baa3d8.
- `virtqueue_enable_cb_delayed()` at `drivers/virtio/virtio_ring.c:2528`
  has **no** `vq->broken` check.
- `virtnet_poll_cleantx()` at `drivers/net/virtio_net.c:2842-2845` still
  has:
  `do { virtqueue_disable_cb(); free_old_xmit(); } while
  (unlikely(!virtqueue_enable_cb_delayed(sq->vq)));`
- `virtio_bus` has probe/remove only — **no** `.shutdown`, **no**
  `virtio_dev_shutdown()`.
- Therefore: the **infinite loop** exists; the **reboot-via-
  virtio_dev_shutdown** trigger does **not**.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean/minor. Mainline uses `VIRTQUEUE_CALL(vq,
enable_cb_delayed)` after the event_triggered block; 6.12 uses a
packed/split ternary. The new lines go immediately after `to_vvq()` and
before `event_triggered`, which exists here (8d622d21d24803 /
b730cb109633c). Expected apply: clean or trivial context.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: Comment “When the device is broken there is no point in polling
used->idx” is absent. `git log --grep='infinite loop in
virtnet_poll_cleantx'` on these files: empty. No earlier equivalent fix.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: virtio core (`drivers/virtio/virtio_ring.c`) used by virtio-net.
Criticality: **IMPORTANT** (default NIC in KVM/QEMU/cloud guests; not
mm/core, but extremely common).

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Active but mature. The looping TX cleanup dates to 2021; broken-
bit handling is long-standing. This is a hole in an old contract, not a
bug in brand-new 6.12-only code.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: virtio-net guests (and any other future/looping caller of
`virtqueue_enable_cb_delayed`). Driver-specific, but a very large VM
population.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record:
- Documented reboot hang: requires `virtio_dev_shutdown()` — **not in
  6.12**.
- In this tree, hang requires (1) napi-tx cleanup loop running, (2)
  `used->idx` stuck, (3) `vq->broken` true so this patch can abort.
  Realistic 6.12 cases: virtio-pci surprise removal under traffic;
  notify failure / backend disconnect with NAPI still polling.
- Unprivileged guest userspace can generate the traffic;
  unplug/reboot/backend death is admin/hypervisor-side.
- Timing-dependent (NAPI already running when the queue is broken).

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Infinite loop in `ksoftirqd` → RCU stalls; teardown paths that
wait for NAPI (`unregister_netdev` / `napi_disable`) block forever.
Severity: **CRITICAL** (guest hang), when the trigger hits. Frequency:
uncommon (needs broken device + in-flight TX cleanup), but consequences
are a stuck VM, not a warning.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: stops a hard hang in virtio-net TX cleanup once `vq->broken`
  is set. On 6.12 this is not the 6.15+ reboot path, but it is the same
  loop vs the same broken flag this kernel already sets on surprise
  removal and notify failure.
- Risk: very low (8 lines, existing pattern, `unlikely` fast path).
- Ratio: favorable.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR backporting:
- Real hang: unbounded loop in NAPI/`ksoftirqd` when `enable_cb_delayed`
  never returns true.
- Loop and helper both exist in 6.12.111; fix is not already applied.
- `vq->broken` is the documented abort switch; this helper uniquely
  ignored it.
- Same semantics as `virtqueue_enable_cb()` via `virtqueue_poll()`.
- 8-line, obviously correct, reviewed by Xuan Zhuo, merged by MST.
- virtio-net is the common VM NIC; hangs on unplug/backend death matter
  to stable users.
- Applies with no prerequisites.

AGAINST backporting:
- The author’s reboot/kexec story depends on `virtio_dev_shutdown()`
  from 8bd2fa086a04 (v6.15), which is **not** in this tree. That
  specific “reboot hangs in device_shutdown” bug was introduced after
  6.12 branched.
- No Fixes:/Cc: stable (expected, not a negative).
- No second independent reporter, no syzbot.
- Surprise-removal/notify-fail hang is reasoned from call chains, not a
  6.12-specific user report.

UNRESOLVED:
- Could not run `b4 dig` against a mainline SHA (commit not in this
  repo); lore.kernel.org 403/404 for some URLs.
- Stable list discussion: UNVERIFIED (403).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — matches sibling broken
   checks; author reproduced; virtio maintainers reviewed/applied.
2. Fixes a real bug that affects users? **PASS** — infinite NAPI loop
   when the queue is broken; the loop exists here. The 6.15 reboot
   recipe does not, but 6.12 still marks queues broken and still runs
   this loop.
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   hang / RCU stall / teardown stuck. Severity CRITICAL when triggered.
4. Small and contained? **PASS** — 8 lines, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — same function, same insertion
   point.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary hang
fix.

**Step 9.4: MAKE YOUR DECISION**

This tree is 6.12.111. The reboot hang named in the commit message needs
`virtio_dev_shutdown()`, which landed in 6.15 and is not here — that
trigger alone would not justify a backport.

The patch still belongs on 6.12 because it does not fix that later
function; it closes a hole in `virtqueue_enable_cb_delayed()` that 6.12
already has. `virtnet_poll_cleantx()` / `start_xmit()` will spin forever
if `used->idx` stops moving, and they never look at `vq->broken`. This
kernel already sets that flag (PCI surprise removal, failed notify).
Returning true there is the same contract as `virtqueue_poll()` /
`virtqueue_enable_cb()`, is eight lines, and cannot wait on new APIs.

Benefit is avoiding a virtio-net hang in a widely used guest NIC;
regression risk is negligible.

Verification:
- [Phase 1] Parsed subject/tags/body: hang fix; Reviewed-by Xuan Zhuo;
  SOB MST; Message-ID 20260716115940.394832-1; no Fixes/syzbot
- [Phase 2] Diff: +8 lines in `virtqueue_enable_cb_delayed()`; return
  true if `vq->broken`
- [Phase 3] Blame: wrapper 2018 (e6f633e5beab65); poll_cleantx loop
  a7766ef18b3367 (2021), ancestor of HEAD
- [Phase 3] No Fixes: tag; no Jinqian Yang virtio history in this tree
- [Phase 4] b4 dig on Message-ID: no commit in this repo; b4 mbox: lore
  404
- [Phase 4] v1 patched virtio_net loop; v2/v3 moved check to
  virtio_ring; Xuan Zhuo Reviewed-by on v3 (lkml.rescloud 09380)
- [Phase 4] 8bd2fa086a04 exists as object, NOT ancestor of HEAD; IS
  ancestor of v6.15; NOT of v6.12
- [Phase 4] UNVERIFIED: stable@ discussion (lore 403)
- [Phase 5] Callers: virtnet_poll_cleantx, start_xmit, TX-stop;
  poll_cleantx invoked from virtnet_poll line 2892
- [Phase 5] virtio_pci_remove surprise-removal calls virtio_break_device
  (line 758-759)
- [Phase 5] virtqueue_poll/add/get_buf/notify already check broken;
  enable_cb_delayed does not
- [Phase 5] CONFIG_VIRTIO_HARDEN_NOTIFICATION depends on BROKEN in this
  Kconfig
- [Phase 6] kernelversion 6.12.111; virtio_bus has no .shutdown; fix
  comment absent
- [Phase 6] Insertion point (after to_vvq, before event_triggered)
  present
- [Phase 8] Failure mode: infinite ksoftirqd loop / RCU stall / teardown
  hang
- UNVERIFIED: whether a 6.12 user has actually hit surprise-unplug hang
  (code path verified, field report not found)

**YES**

 drivers/virtio/virtio_ring.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index b8199e578ea98..5c0139f3b9811 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2667,6 +2667,14 @@ bool virtqueue_enable_cb_delayed(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
+	/*
+	 * When the device is broken there is no point in polling used->idx,
+	 * the backend will never update it. Return true to let callers
+	 * exit their cleanup loops instead of spinning forever.
+	 */
+	if (unlikely(vq->broken))
+		return true;
+
 	if (vq->event_triggered)
 		data_race(vq->event_triggered = false);
 
-- 
2.53.0

