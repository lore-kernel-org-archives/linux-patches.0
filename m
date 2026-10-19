Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6000657DF37;
	Mon, 19 Oct 2026 13:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418316; cv=none; b=I8fVJR76ygQRFzyfo53MOo4TyxCUezXj3q1RgguzALz8L2ra6gYWTeB13YVFrMv3gzKbtg8zq4rP/wUyQ16ATV3PwQ1n5wGbGLUXvcrVXPaRFQ+xkRrLQjNPk9fNdEVsQZKvj5/AvVEPy3po8d/BoFHZC7OlQoXncOrk8mwJz/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418316; c=relaxed/simple;
	bh=3x91CE8kXBoAW2q2NqNwulyU8jH32SmJ80oWoUgPHdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H38UW04owc3s43t6teDJSccScIYm0/cde64qQ1c9gsDM77QN+nmHv0uMa33+LCzbMx3Ym36VhPGjsfjmUSR7Zo4hGIaL/7Xtv1rjIZ1l+eM9+b8Srw7C9Ypld5IUEJ+vLc/1nZ/dxiDgb4sZ5nQZdHcKM/nh+zdBBt3+xvglly0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aWYUOgmR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aWYUOgmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9F81F000C9;
	Mon, 19 Oct 2026 13:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418313;
	bh=IFJLhZd7yDmRR51EKDyr6ZIn8xIWLMqCxDkGS5Xyc/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aWYUOgmRP3ZqP6m+mSdcOdJ2RA9bRCGJ1ZASfhfoUz5PI6/n40cb9QXwIdv58/SPX
	 Sfs8924HMkY4YT+dpFxXjWGwiYrrc4o4Z8KWN+N6KC0nI9e4uWzM6HmnOcF8vq7OUy
	 yMj0ybmZoTuv7JVBPUKbk6SSiWwUGIT1/8ZguDyx7a/UFcqr1K9o3NddrUMIsFypK8
	 o+DAeZLhCiQ4+BjyaCg51698rF26vzmujGIOmNalEN4LLhddiCTQWhZOXeyV3HFjMR
	 y5UJVbgW9glmz4DNMctC/oKdqeI3KgBcwZNPJ0LXESOm25oUEU+1vfjpwJjzF3gDXH
	 JCLEQcUOD7xTw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xiong Weimin <xiongweimin@kylinos.cn>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	jasowangio@gmail.com,
	eperezma@redhat.com,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] vdpa_sim: hold iommu_lock across dma_unmap passthrough transition
Date: Mon, 19 Oct 2026 09:47:30 -0400
Message-ID: <20261019135441.1420968-159-sashal@kernel.org>
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

From: Xiong Weimin <xiongweimin@kylinos.cn>

[ Upstream commit 7b411448c668bfab0d0e572cee5a592cea396ce7 ]

vdpasim_dma_map() updates the IOTLB and the passthrough (iommu_pt)
state under iommu_lock.  vdpasim_dma_unmap() clears iommu_pt and
resets the IOTLB before taking iommu_lock, then deletes the mapping
while holding the lock.

A concurrent dma_map(), dma_unmap(), or reset path that also touches
the same address space can therefore observe or modify the IOTLB and
iommu_pt state without consistent locking.

Perform the passthrough transition and range deletion under the same
iommu_lock scope, matching dma_map().

Tested-on: openEuler VM (6.16.8, /usr/src/linux-6.16.8)
Tested-by: Xiong Weimin <xiongweimin@kylinos.cn>

Signed-off-by: Xiong Weimin <xiongweimin@kylinos.cn>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260626020545.607600-3-15927021679@163.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to judge this for 6.12: the buggy unlocked `dma_unmap`
path is present, the race with the simulator datapath is real, and the
fix is a one-lock-move. Compiling the nine-phase analysis next.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[vdpa_sim] [hold] [take `iommu_lock` for the full `dma_unmap`
passthrough-to-custom IOTLB transition]**

- Subsystem: `vdpa_sim` (vDPA device simulator)
- Verb: “hold” — locking/correctness, not a feature
- Intent: make `vdpasim_dma_unmap()` lock the same way
  `vdpasim_dma_map()` already does

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Tested-on:** openEuler VM (6.16.8, `/usr/src/linux-6.16.8`)
- **Tested-by:** Xiong Weimin `<xiongweimin@kylinos.cn>` (author; not
  independent)
- **Signed-off-by:** Xiong Weimin `<xiongweimin@kylinos.cn>` (author)
- **Signed-off-by:** Michael S. Tsirkin `<mst@redhat.com>` (vhost/vdpa
  maintainer; applied the patch)
- **Message-ID:** `<20260626020545.607600-3-15927021679@163.com>`

Absent (expected for this review pipeline, not a negative):
- No `Fixes:`
- No `Cc: stable@vger.kernel.org`
- No `Reported-by:` / syzbot
- No `Reviewed-by:` / `Acked-by:`
- No `Link:`

Ignored per instructions: any `[Upstream commit …]` / `Signed-off-by:
Sasha Levin` pipeline markers.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `vdpasim_dma_map()` updates IOTLB + `iommu_pt` under
  `iommu_lock`. `vdpasim_dma_unmap()` clears `iommu_pt` and calls
  `vhost_iotlb_reset()` *before* taking the lock, then deletes the range
  under the lock.
- **Symptom / failure mode:** concurrent `dma_map` / `dma_unmap` / reset
  can observe or mutate IOTLB and `iommu_pt` without consistent locking.
  That is interval-tree mutation vs walk → corruption / UAF / crash, not
  a log-only issue.
- **Version info:** tested on 6.16.8; no “introduced in vX” text. The
  buggy passthrough logic is from v6.3 (see Phase 3).
- **Root cause (author):** passthrough-exit in `dma_unmap` is outside
  the lock that `dma_map` already uses.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Not disguised.** This is an explicit locking/race fix. Subject
uses “hold … across”, body describes a concurrent IOTLB/`iommu_pt`
inconsistency. Hidden-fix heuristics are N/A.

---

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

**Step 2.1: INVENTORY THE CHANGES**

Record:
- **File:** `drivers/vdpa/vdpa_sim/vdpa_sim.c` only
- **Scope:** ~1 insertion, ~2 deletions (move `spin_lock` up, drop a
  blank line)
- **Function:** `vdpasim_dma_unmap()`
- **Classification:** single-file surgical locking fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record — this tree today (`vdpasim_dma_unmap`):

```725:743:drivers/vdpa/vdpa_sim/vdpa_sim.c
static int vdpasim_dma_unmap(struct vdpa_device *vdpa, unsigned int
asid,
                             u64 iova, u64 size)
{
        struct vdpasim *vdpasim = vdpa_to_sim(vdpa);

        if (asid >= vdpasim->dev_attr.nas)
                return -EINVAL;

        if (vdpasim->iommu_pt[asid]) {
                vhost_iotlb_reset(&vdpasim->iommu[asid]);
                vdpasim->iommu_pt[asid] = false;
        }

        spin_lock(&vdpasim->iommu_lock);
        vhost_iotlb_del_range(&vdpasim->iommu[asid], iova, iova + size -
1);
        spin_unlock(&vdpasim->iommu_lock);

        return 0;
}
```

- **Before:** if still in passthrough (`iommu_pt[asid]`), reset the
  whole IOTLB interval tree and clear `iommu_pt` with **no lock**; then
  take `iommu_lock` only for `vhost_iotlb_del_range()`.
- **After:** one `spin_lock` covers passthrough-exit
  (`vhost_iotlb_reset` + `iommu_pt = false`) **and**
  `vhost_iotlb_del_range()`, then unlock. Same shape as
  `vdpasim_dma_map()`.
- **Path:** vhost-vdpa IOTLB invalidate / AS teardown
  (`ops->dma_unmap`), not probe init.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **[Synchronization / race] [IOTLB interval tree and `iommu_pt`
mutated without `iommu_lock`]**

`vhost_iotlb_reset()` is `vhost_iotlb_del_range(iotlb, 0, ~0ULL)` — it
walks and frees the rbtree (`drivers/vhost/iotlb.c`). The datapath walks
that tree under `iommu_lock` via `iotlb_translate()` in
`drivers/vhost/vringh.c` (`spin_lock(vrh->iotlb_lock)` then
`vhost_iotlb_itree_first()`).

Unlocked reset vs locked walk is concurrent rbtree mutation → UAF /
corruption / oops.

Same lock is used by `vdpasim_dma_map()`, `vdpasim_set_map()`,
`vdpasim_reset_map()`, and `vdpasim_do_reset()`.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- **Quality:** obviously correct. It only moves an existing `spin_lock`
  so the passthrough block matches `dma_map`. No new APIs, no new state.
- **Regression risk:** very low. Same lock already used on the sibling
  path; no lock-order change vs `vdpasim->mutex` (unmap still does not
  take that mutex). No new sleep under spinlock
  (`vhost_iotlb_reset`/`del_range` are tree ops).
- **Red flags:** none. Independent of series patch 1/2 (`pending_kick`);
  cover letter calls them independent.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Unlocked `iommu_pt` / `vhost_iotlb_reset` in `dma_unmap`:
  **`6c3d329e6486dd`** — `vdpa_sim: get rid of DMA ops` (Jason Wang,
  committed 2023-02-20).
- First in **v6.3-rc1** (`git describe --contains` →
  `v6.3-rc1~84^2~23`).
- `spin_lock` around `del_range`: **`0ea9ee430e74b1`** (Max Gurtovoy,
  2020).
- Present in this 6.12 tree for the whole lifetime of 6.12.y.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: **No `Fixes:` tag.** The introducing change is still
**`6c3d329e6486dd`**, and `git merge-base --is-ancestor 6c3d329e6486dd
HEAD` succeeded. No later fix of this lock split was found on this file.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record (recent `drivers/vdpa/vdpa_sim/vdpa_sim.c`):
- `05ddc94afb69e` vdpa_sim: fix cleanup after worker creation failure
- `9588e7fc511f9` vdpa_sim: reset must not run
- `86f6c224c9791` vdpa_sim: implement `.reset_map` support
- `6c3d329e6486d` vdpa_sim: get rid of DMA ops (introducer)

This commit is **standalone**. Cover letter: “[PATCH 0/2] vdpa_sim: fix
suspend/reset and dma_unmap locking” — two independent bugs. Sibling
`clear pending_kick on device reset` is **not** a prerequisite and is
**not** in this tree.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: **Xiong Weimin** has no other `vdpa_sim` commits in this tree.
Maintainer of record is **Michael S. Tsirkin** (SOB on apply) /
historical authors Jason Wang, Eugenio Pérez, Si-Wei Liu. Author is a
contributor, not the subsystem maintainer; MST still took the patch.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: **None.** Needs only `iommu_lock`, `iommu_pt`,
`vhost_iotlb_reset`, `vhost_iotlb_del_range` — all present. Applies as a
lock-line move. **Can apply standalone.**

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 mbox` for `20260626020545.607600-3-15927021679@163.com` saved the
  thread (3 messages).
- Cover: `[PATCH 0/2] vdpa_sim: fix suspend/reset and dma_unmap locking`
- This patch is **2/2** (`-3` is cover+two patches).
- **No replies in the thread** (no NAK, no `Cc: stable` from reviewers,
  no v2).
- Committed Message-ID matches this v1 2/2; applied version is the
  submitted version.
- Lore HTML via WebFetch/curl: **403** — could not read lore web UI;
  thread content came from `b4 mbox`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: Thread is author-only. **Michael S. Tsirkin** SOBed on merge
(vhost/vdpa maintainer). No `Reviewed-by` on the list copy. Recipients
of the original mail were not dumped (`b4 dig -w` needs a local commit
SHA; this SHA is not in this tree).

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: **No external bug report.** No syzbot, bugzilla, or `Reported-
by`. Evidence is code inspection plus author test that the module still
loads on 6.16.8 — that does **not** prove the race was reproduced.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Two-patch series, independent. Patch 1/2 (`pending_kick`) is a
different bug and is not required. No other series members needed.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: `curl` to `lore.kernel.org/stable/?q=vdpa_sim+iommu_lock`
returned **403**. **UNVERIFIED:** whether stable@ already discussed
this. No local `git log --grep` hit for this subject on this file.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: **`vdpasim_dma_unmap()`** only. Registered as `.dma_unmap` in
`vdpasim_config_ops` / `vdpasim_batch_config_ops`.

**Step 5.2: TRACE CALLERS**

Record:
- `vhost_vdpa_general_unmap()` → `ops->dma_unmap()`
  (`drivers/vhost/vdpa.c`)
- Called from `vhost_vdpa_pa_unmap()` / `vhost_vdpa_va_unmap()` →
  `vhost_vdpa_iotlb_unmap()` → `vhost_vdpa_unmap()`
- Userspace: `vhost_vdpa_process_iotlb_msg()` `VHOST_IOTLB_INVALIDATE`
  under `dev->mutex`
- Teardown: `vhost_vdpa_remove_as()` → `vhost_vdpa_iotlb_unmap()`
  (release/cleanup, also under `dev->mutex`)

No other `ops->dma_unmap` users for this simulator in-tree.

**Step 5.3: TRACE CALLEES**

Record: `vhost_iotlb_reset()` → `vhost_iotlb_del_range()` → interval-
tree delete/free; `spin_lock`/`unlock` on `iommu_lock`.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record:
- Reachable from **vhost-vdpa character-device IOTLB messages**
  (privileged userspace: QEMU/DPDK with vhost-vdpa).
- Simulator datapath: `vdpasim_kick_vq()` → kthread `vdpasim_work_fn()`
  → `vdpa_sim_net`/`blk` `vringh_getdesc_iotlb()` /
  `vringh_iov_{pull,push}_iotlb()` → `iotlb_translate()` under
  `iommu_lock`.
- **Yes, userspace can trigger both sides:** IOTLB invalidate vs running
  virtqueue processing.

**Nuance (verified):** vhost serializes `dma_map`, `dma_unmap`, and
`vdpa_reset` with `vdev.mutex`. So **map vs unmap vs reset from vhost
ioctls do not run together**. The commit text overstates that pair. The
**verified** concurrent party is the **simulator worker**, which does
**not** take `vdev.mutex` and walks the IOTLB under `iommu_lock` only.

This tree also advertises `VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK`
(`vdpasim` getter at line 436), so DRIVER_OK / kicks can happen while
still in passthrough (`iommu_pt == true`). First `dma_unmap` then takes
the unlocked reset path while the worker may be in `iotlb_translate()`.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: `dma_map`, `set_map`, `reset_map`, and `do_reset` already take
`iommu_lock` around `iommu_pt` and IOTLB updates. **`dma_unmap` is the
only passthrough-exit that does not.** No sibling driver has this exact
split; mlx5 has a different `iommu_lock`.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:
- Tree: **Linux 6.12.111** (`Makefile` VERSION=6 PATCHLEVEL=12
  SUBLEVEL=111; `git describe HEAD` → `p-6.12-3-gc504cf0baa3d8`; branch
  `pending-6.12`).
- Buggy code is in `vdpasim_dma_unmap()` as cited above.
- Introduced **v6.3**, so **before** 6.12 branched. Bug **does** exist
  here.
- This exact fix is **not** already applied (`git log --grep` empty for
  this subject).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply.** Surrounding function matches the hunk exactly.
No refactor of this path after 6.12. Expected difficulty: **clean
apply**.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: Other `vdpa_sim` bugfixes are in this pending tree (worker-
creation cleanup, sim_blk sector check, sim_net TX-pull check).
**Nothing already fixes this lock split.** Sibling `pending_kick` fix is
not here and is not required.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record:
- **Subsystem:** `drivers/vdpa/vdpa_sim` — vDPA **simulator** (net/blk
  loopback for testing).
- **Kconfig:** `CONFIG_VDPA_SIM` “vDPA device simulator core”,
  **`depends on RUNTIME_TESTING_MENU`**, help text: “testing,
  prototyping and development of vDPA”.
- **Criticality:** **PERIPHERAL** (not mm/VFS/net core). Not a
  production NIC/block driver. Still in-tree and used with vhost-vdpa in
  labs/CI (author: openEuler).

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Mature-but-active. Core simulator from ~2020; 6.12 still
receives sim bugfixes (including 2026 worker-cleanup). Not a dead file.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **config-specific / driver-specific.** Only `CONFIG_VDPA_SIM`
(and `_NET`/`_BLOCK`) plus vhost-vdpa IOTLB programming. Not universal.
Production kernels often leave the module off; anyone who loads it (QEMU
vDPA sim, distro debug kernels) can hit it.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record:
- **Trigger:** IOTLB invalidate / unmap while `iommu_pt[asid]` is true,
  overlapping simulator worker IOTLB walk.
- **Likelihood:** not every boot; realistic with
  `ENABLE_AFTER_DRIVER_OK` and live IOTLB updates while VQs run. Hard to
  hit, timing-dependent.
- **Privilege:** vhost-vdpa + creating a sim device is typically
  **root**, not an unprivileged syscall primitive. Not a generic
  syzbot/LPE story.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record:
- **Failure mode:** concurrent interval-tree reset vs walk → use-after-
  free / memory corruption / oops.
- **Severity:** **HIGH** (crash/UAF) on that config path; not a
  production-wide panic.
- Unlocked `iommu_pt` store vs locked readers is also a data race; the
  tree walk is the severe part.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** medium for sim users (prevents crash/UAF); low for
  generic 6.12 fleet that never loads `vdpa_sim`.
- **Risk:** **very low** (1–2 line lock move, matches existing `dma_map`
  protocol).
- **Ratio:** benefit exceeds risk. A no-op on systems without the
  module; cannot change unrelated drivers.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR backporting:**
- Real locking bug: IOTLB rbtree reset without the lock the walker uses
- Crash/UAF-class, not style
- Tiny, obviously correct, matches `dma_map`
- Buggy code present since v6.3; in this 6.12 tree
- Applies cleanly; no prerequisites
- Maintainer (MST) applied it in mainline
- This pending-6.12 tree already takes other `vdpa_sim` correctness
  fixes
- Race window is real against the kthread datapath (verified call chain)

**AGAINST:**
- Simulator behind `RUNTIME_TESTING_MENU`, not production hardware
- No syzbot / third-party crash report; `Tested-by` is the author
- No list review beyond maintainer SOB
- Commit’s “concurrent dma_map/dma_unmap/reset” is **overstated** given
  vhost `dev->mutex`
- Peripheral impact population

**UNRESOLVED:**
- Lore/stable HTML 403; no public stable@ discussion found
- Whether the author actually reproduced the race vs only smoke-tested
  module load
- `b4 dig -w` recipients (no local mainline SHA)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — lock move mirrors `dma_map`;
   author + maintainer SOB. Testing is light but the change is
   reviewable by inspection.
2. Fixes a real bug that affects users? **PASS** — unlocked IOTLB reset
   vs datapath walk. Affects `vdpa_sim` + vhost-vdpa users, which this
   tree already treats as in-scope.
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   UAF/oops on IOTLB tree; severity HIGH on that path.
4. Small and contained? **PASS** — ~2 lines, one function.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — context identical in 6.12.111

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: **None** (not a device ID, quirk, DT, build, or doc-only
change). It qualifies as a normal small race/crash fix.

**Step 9.4: MAKE YOUR DECISION**

This should be backported to **this** 6.12 tree. The bug is in this
checkout, the fix is surgical, and the failure mode is memory-safety on
a path this tree already ships. Simulator-only scope lowers fleet-wide
benefit but does not make a 2-line IOTLB UAF fix inappropriate for
stable, especially with near-zero regression risk.

---

### What the commit solves (for this tree)

`vdpasim_dma_unmap()` drops the whole passthrough IOTLB
(`vhost_iotlb_reset`) and clears `iommu_pt` without `iommu_lock`, while
`dma_map` and the vringh translator use that lock. A vhost-vdpa IOTLB
unmap can therefore tear down the interval tree while the simulator
worker is in `iotlb_translate()`. That is a kernel oops/UAF, not a
benign inconsistency. Holding `iommu_lock` across that transition closes
the hole.

### Stable rules / risk vs benefit

Meets the rules: real bug, small, no new API, applies here. Benefit is
crash prevention for `CONFIG_VDPA_SIM`; risk is negligible. The missing
`Fixes:`/`Cc: stable` tags are irrelevant to this pipeline.

### Concerns

- No independent repro; vhost mutex means map/unmap/reset do not race
  with each other — the datapath race is the one that matters and is
  verified.
- Patch 1/2 of the series is unrelated and must not be treated as a
  dependency.
- Peripheral testing driver; still in this tree and already receiving
  similar backports.

---

### Verification

- **[Phase 1]** Parsed subject/body/tags from the provided message and
  from `b4 mbox` (cover + 2/2). Tags: Tested-on/Tested-by/SOB author,
  SOB MST, Message-ID. No Fixes/Cc stable/Reported-by/Reviewed-by.
- **[Phase 2]** Read `vdpasim_dma_unmap`/`vdpasim_dma_map` in this tree;
  compared to the diff. Confirmed unlocked reset vs locked `dma_map`.
- **[Phase 2]** Read `vhost_iotlb_reset`/`vhost_iotlb_del_range` in
  `drivers/vhost/iotlb.c` (interval tree free).
- **[Phase 3]** `git blame -L 725,743` → introducer `6c3d329e6486dd`
  (Jason Wang, v6.3-rc1).
- **[Phase 3]** `git merge-base --is-ancestor 6c3d329e6486dd HEAD` →
  yes. `git describe --contains` → `v6.3-rc1~84^2~23`.
- **[Phase 3]** `git show 6c3d329e6486dd` — “get rid of DMA ops” added
  `iommu_pt` passthrough; unmap’s reset was left outside the lock.
- **[Phase 3]** `git log --oneline -20 --
  drivers/vdpa/vdpa_sim/vdpa_sim.c`; `--grep` for this subject /
  `pending_kick` → fix not present; sibling not present.
- **[Phase 3]** `git log --author="Xiong Weimin" -- drivers/vdpa/` — no
  vdpa_sim commits in this tree.
- **[Phase 4]** `b4 mbox` Message-ID → 3-message v1 series; no review
  replies; cover says issues are independent.
- **[Phase 4]** WebFetch/curl lore.kernel.org → 403. UNVERIFIED: stable@
  archives and HTML lore UI.
- **[Phase 5]** Callers: `ops->dma_unmap` only from
  `drivers/vhost/vdpa.c`. Datapath: `vdpa_sim_net.c`/`vdpa_sim_blk.c`
  `vringh_*_iotlb` → `iotlb_translate` + `iommu_lock`.
- **[Phase 5]** `vhost_vdpa_process_iotlb_msg` holds `dev->mutex` —
  map/unmap/reset from vhost do not interleave (commit text overstated;
  datapath race still real).
- **[Phase 5]** `VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK` offered in this
  file (line 436).
- **[Phase 6]** `head Makefile` / `git describe HEAD` / `make
  kernelversion` → **6.12.111**, branch `pending-6.12`.
- **[Phase 6]** File context matches the hunk; fix not in tree.
- **[Phase 7]** `drivers/vdpa/Kconfig`: `VDPA_SIM` depends on
  `RUNTIME_TESTING_MENU`; testing/prototyping help text.
- **[Phase 8]** Failure mode: IOTLB rbtree UAF/oops, HIGH on that
  config; trigger: IOTLB unmap in passthrough vs worker.
- **UNVERIFIED:** lore web discussion beyond b4 mbox; whether author
  reproduced the race vs module-load smoke test; `b4 dig -w` recipient
  list.

The fix is small, correct, already matched by `dma_map` in this 6.12
tree, and prevents a real IOTLB UAF race on a driver this tree ships.

**YES**

 drivers/vdpa/vdpa_sim/vdpa_sim.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 9df300c467452..44055778b6940 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -736,12 +736,11 @@ static int vdpasim_dma_unmap(struct vdpa_device *vdpa, unsigned int asid,
 	if (asid >= vdpasim->dev_attr.nas)
 		return -EINVAL;
 
+	spin_lock(&vdpasim->iommu_lock);
 	if (vdpasim->iommu_pt[asid]) {
 		vhost_iotlb_reset(&vdpasim->iommu[asid]);
 		vdpasim->iommu_pt[asid] = false;
 	}
-
-	spin_lock(&vdpasim->iommu_lock);
 	vhost_iotlb_del_range(&vdpasim->iommu[asid], iova, iova + size - 1);
 	spin_unlock(&vdpasim->iommu_lock);
 
-- 
2.53.0

