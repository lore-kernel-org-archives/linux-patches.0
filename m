Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096A553BBAF;
	Mon, 19 Oct 2026 14:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418715; cv=none; b=FEgaZSWquNP86hWr8gwWmQyfYYELWwetpULTd349ZfiBhkZGnYN7nWBuq/aIoH6GaKJ3RA50GHfFcgP7GWXQ53G70LjyyurtHQj4H2I5L+Pd6uzAHVNF0smpqdvWnhPEskzAk2S3RJKvCuEK8iu18qB1dRpsZZSI7v5xNvhQW80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418715; c=relaxed/simple;
	bh=g+veDCmlhCAqMBdGLPALcJ3IuOIMVViwoioxncymKNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nbxa9TDhzxERz6qdCSJfpV48WhfoRw8AVSqOZGMRUQNwe3KaGnmAiZYGT4oACT6p2NyQisYK/GeFEoApQ+wEi4G29Zn9qa1ABGd5O6NjZz5zJZCxiQUBrEAE5UMt4dFBWaOEb8iBj8x+DY6J+wmltONso9g7P/0Hm2hwObmfKE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mn+M2xg5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mn+M2xg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D8C1F000C7;
	Mon, 19 Oct 2026 14:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418711;
	bh=CM2WAE2HkP0FdbYvaMOjqRvZj/7tVd7+xmKcg/KyjcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mn+M2xg5dJ6MTHExbbG+b450kblSLnAZM9hVmnrEgdoHSa9O6Y5h8aZq8hRFVe1dK
	 NjGjNgRKKoYSw6wKijfuWoQoz5+PoEUY7EXG/ki+6UzbcvGOrfUrZKGrYF4fReV2k2
	 hkGKV3wJzMKtComXJdKTblvIHc0FEe+Lz45wZK+NjZWjCFpfADG5Ot4IAedT9+/kDc
	 nQWZUmjuyPTgUORnLhH9qQ2VXRlqRtpMT+zcQLcPdrzRcH4dLQ0bk300wqt6kncokx
	 XLGQ5JyMUsCvOxepTKRWagVW5vv8TSeDoZKwZ2CECCbF3VtL3Gtj/0k6blgx4CSlND
	 q9jw1ngtv9ZDw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Weimin Xiong <xiongwm2026@163.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	dtatulea@nvidia.com,
	jasowangio@gmail.com,
	eperezma@redhat.com,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] vdpa/mlx5: roll back MR update after VQ setup failure
Date: Mon, 19 Oct 2026 09:52:13 -0400
Message-ID: <20261019135441.1420968-442-sashal@kernel.org>
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

From: Weimin Xiong <xiongwm2026@163.com>

[ Upstream commit 11f79e2780043ad94424a8db02a7a9022ba93252 ]

mlx5_vdpa_change_map() must install the new MR before rebuilding or
resuming virtqueues, because both paths read the MR keys from
mvdev->mres.mr[].

If rebuilding the virtqueue resources fails, the new MR must not remain
installed after its reference is released. Keep an extra reference to
the old MR before replacing it. On setup failure, restore the old MR;
the saved reference then becomes the map reference, while replacing the
new MR drops its map reference.

Make mlx5_vdpa_change_map() consume new_mr on all error paths so that
set_map_data() does not release an MR already released during rollback.

v2:
- Keep the new MR installed while virtqueues are rebuilt.
- Restore the old MR only after setup_vq_resources() fails.

Signed-off-by: Weimin Xiong <xiongwm2026@163.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Message-ID: <20260716054353.155805-1-xiongwm2026@163.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Local tree is **6.12.111** (`pending-6.12`). The buggy
`mlx5_vdpa_change_map()` path is present, the patch applies cleanly, and
this is a real use-after-free on the map-update error path.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[vdpa/mlx5] [roll back] [restore the previous memory region if
virtqueue rebuild fails after installing a new MR]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Fixes:** none (expected for this review)
- **Reported-by / Tested-by / Reviewed-by / Acked-by:** none
- **Link:** none in the commit; Message-ID
  `20260716054353.155805-1-xiongwm2026@163.com`
- **Cc: stable:** none (expected)
- **Signed-off-by:** Weimin Xiong (author); Michael S. Tsirkin (vhost
  maintainer, applied the patch)
- Ignore any pipeline SOBs.

Notable: standalone v2 patch, not `N/M`. Maintainer SOB is present; no
syzbot tag.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `mlx5_vdpa_change_map()` installs `new_mr` into
  `mvdev->mres.mr[]` before rebuilding virtqueues. If
  `setup_vq_resources()` fails, the caller still drops `new_mr` while
  that pointer remains installed.
- **Symptom:** dangling MR pointer / use-after-free after a failed live
  map update. GC can free the MR ~2s later (`MLX5_VDPA_MR_GC_TRIGGER_MS`
  is 2000).
- **Version info:** none in the message. Introduced by the v6.7 MR-
  update flow, present in this 6.12 tree.
- **Root cause:** missing rollback of the map slot and split ownership
  of `new_mr` between `change_map()` and `set_map_data()`.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Not a disguised cleanup.** This is an explicit error-path
refcount/UAF fix. v1 wrongly deferred the MR install until after VQ
setup; v2 keeps the new MR installed during rebuild and rolls back only
on failure.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/vdpa/mlx5/net/mlx5_vnet.c` — **+15 / -8** (23 lines)
- Functions: `mlx5_vdpa_change_map()`, `set_map_data()`
- Scope: **single-file surgical error-path fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
1. `save_channels_info()` failure: now `mlx5_vdpa_put_mr(new_mr)` inside
   `change_map()` (caller no longer puts it).
2. Before `mlx5_vdpa_update_mr()`: extra `get` on `old_mr` so it is not
   GC'd after the map slot is replaced.
3. `setup_vq_resources()` failure: `mlx5_vdpa_update_mr(old_mr)`
   restores the old map; extra get becomes the map ref; installing
   `old_mr` drops `new_mr`'s map ref.
4. Success / early `!DRIVER_OK` / suspended: `goto out` and drop the
   extra old-MR ref.
5. `set_map_data()`: remove `out_err` put of `new_mr` so rollback cannot
   double-free.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **[UAF / dangling pointer + refcount] [map slot updated, then
`new_mr` released on error while `mres.mr[asid]` still points at it]**

Verified in this tree:

```731:743:drivers/vdpa/mlx5/core/mr.c
void mlx5_vdpa_update_mr(struct mlx5_vdpa_dev *mvdev,
                         struct mlx5_vdpa_mr *new_mr,
                         unsigned int asid)
{
        struct mlx5_vdpa_mr *old_mr = mvdev->mres.mr[asid];
        mutex_lock(&mvdev->mres.lock);
        _mlx5_vdpa_put_mr(mvdev, old_mr);
        mvdev->mres.mr[asid] = new_mr;
        mutex_unlock(&mvdev->mres.lock);
}
```

`create_virtqueue()` / `modify_virtqueue` read `mvdev->mres.mr[]` for
mkeys, so the new MR **must** be installed before rebuild/resume. v1 was
incorrect; v2 matches that constraint.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- **Quality:** refcount flow is consistent: extra get on `old_mr`;
  failure converts it into the map ref; success drops it; `new_mr` is
  consumed on every `change_map()` error path.
- **Regression risk:** low. No new locks, APIs, or data structures.
  `put_mr(NULL)` is a no-op. Residual issue: after a failed rebuild, VQs
  stay torn down (pre-existing); this patch only keeps the MR pointer
  valid.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- `mlx5_vdpa_update_mr()` before setup: **625e4b59a923d2** (“vdpa/mlx5:
  Improve mr update flow”), **v6.7-rc1**.
- Teardown/rebuild via `setup_vq_resources()`: **f756dd3e2a4c70**,
  **v6.8-rc1**.
- Caller `out_err` put: **625e4b59a923d2** / **a06bd11b18fdf2**.
- Function itself dates to **1a86b377aa2147** (2020).

The dangling-pointer pattern exists since the v6.7 MR-update refactor:
setup failure returns without restoring the map, and the caller puts
`new_mr`.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: **No Fixes: tag.** Buggy pattern is in this tree via 625e4b59 /
f756dd3e. `git merge-base --is-ancestor 11f79e2780043 HEAD` is false —
fix is **not** already here.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Related: **62111654481d5** “Postpone MR deletion” (**v6.12-rc1**) —
  delayed GC, so a dangling MR is freed ~2s later rather than
  immediately.
- No prior rollback of `change_map()` in this tree.
- Standalone; not `N/M`.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Weimin Xiong has **no other mlx5 vdpa commits in this tree**.
Subsystem maintainer is Dragos Tatulea; the patch was applied by Michael
Tsirkin. Recipients included Tatulea, Tsirkin, Jason Wang, Eugenio
Perez.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Uses existing `mlx5_vdpa_get_mr` / `put_mr` / `update_mr`. `git
apply --check` of 11f79e27 against this tree: **clean**. **Standalone.**

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 11f79e2780043`:
  https://patch.msgid.link/20260716054353.155805-1-xiongwm2026@163.com
- `b4 dig -a`: **only v2** matched by patch-id
- v1 existed with a different subject/diff: “fix MR state corruption on
  setup_vq_resources failure” — it moved `update_mr` **after** setup,
  which would program VQs with the **old** mkey. v2 changelog documents
  that correction.
- Saved mbox: **patch only, no public replies**. lore.kernel.org fetches
  returned 403; no NAK found in the saved thread.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc Dragos Tatulea, Michael Tsirkin, Jason Wang,
Xuan Zhuo, Eugenio Perez, virtualization@lists.linux.dev. Applied with
Tsirkin SOB. No public Reviewed-by.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: **No syzbot, bugzilla, or user crash report.** Bug is from code
inspection of the error path. Failure mode is still verified from the
current sources.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: **Standalone v2.** No later `mlx5_vnet.c` commits on `all-next`
after 11f79e27. No follow-up reverting or replacing this fix.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search returned 403. **UNVERIFIED**
whether stable@ already discussed this. That does not change the
technical verdict.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `mlx5_vdpa_change_map()`, `set_map_data()`

**Step 5.2: TRACE CALLERS**
Record:
- `set_map_data()` → `mlx5_vdpa_change_map()` when an ASID already has
  an MR
- `mlx5_vdpa_set_map()` (vdpa `.set_map`) → `set_map_data()` under
  `reslock`
- vhost-vdpa calls `.set_map` from `vhost_vdpa_map()` / unmap / batch
  IOTLB updates (`drivers/vhost/vdpa.c`)

**Step 5.3: TRACE CALLEES**
Record: `suspend_vqs`, `save_channels_info`, `teardown_vq_resources`,
`mlx5_vdpa_get_mr`/`update_mr`/`put_mr`, `setup_vq_resources`,
`resume_vqs`. `setup_vq_resources()` can fail on umem, virtqueue create,
RQT/TIR, steering (firmware/alloc errors). `_mlx5_vdpa_put_mr()` queues
GC when refcount hits 0.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace/QEMU vhost-vdpa IOTLB updates → `VHOST_IOTLB_*` →
`ops->set_map` → this path. **Reachable from VM memory map changes**
(boot, live migration, hotplug, vIOMMU). The UAF arm additionally needs
DRIVER_OK, non-resumable firmware (`freeze_to_rdy_supported` missing →
`.resume = NULL` → teardown/rebuild), and `setup_vq_resources()`
failure.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Other `mlx5_vdpa_update_mr()` sites (`mlx5_vdpa_clean_mrs`,
first-map in `set_map_data`, reset) do not rebuild VQs then drop the new
MR while leaving it installed. This error path is unique to
`change_map()`.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** `mlx5_vdpa_change_map()` at
`drivers/vdpa/mlx5/net/mlx5_vnet.c:3044` still updates the MR then
returns on `setup_vq_resources()` failure; `set_map_data()` still `put`s
`new_mr` on that error. Bug since **v6.7**; delayed GC since
**v6.12-rc1**. Local: **6.12.111**.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply** (`git apply --check` exit 0). Surrounding code
matches the diff hunks.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: **No** rollback/`roll back MR` commit in this tree. 11f79e27 is
not an ancestor of HEAD.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **[drivers/vdpa/mlx5] [IMPORTANT]** — ConnectX6+ virtio-net
datapath offload (`CONFIG_MLX5_VDPA_NET`). Not core MM/VFS, but
production virtualization (OpenStack/K8s HW-offloaded virtio).
Maintainer: Dragos Tatulea.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature, still receiving error-path and MR-lifetime fixes
(postpone MR deletion, probe error paths). Not staging.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **driver-specific / config-specific** — `CONFIG_MLX5_VDPA_NET`
users, mainly when firmware lacks `freeze_to_rdy_supported`
(teardown/rebuild on every map change).

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Live `.set_map` while DRIVER_OK, teardown path, then VQ resource
setup fails. Not every boot; map updates are normal for vDPA VMs.
Unprivileged guest does not call `.set_map` directly; the VMM/host
process does. Still a host kernel UAF.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **[dangling `mres.mr[]` + GC free → UAF] [HIGH]** — later VQ
modify/create or another map op can dereference a freed MR. Crash or
memory corruption in the host kernel.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** high for mlx5 vDPA — prevents UAF after a failed map
  change.
- **Risk:** low — ~15 lines, local refcount, applies cleanly.
- **Ratio:** **favor backport.**

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real UAF: map slot holds `new_mr` after the caller drops its last map
  ref.
- Delayed GC in this 6.12 tree makes the free asynchronous and easier to
  hit.
- Small, contained, obviously correct refcount rollback.
- Applies cleanly; no missing helpers.
- v2 respects that VQ setup/resume must see the new MR keys.
- Applied by the vhost maintainer.

AGAINST:
- Error-path only (setup failure after teardown).
- mlx5 vDPA only, not all 6.12 users.
- No syzbot/user report, no Fixes/Cc:stable (not a negative per the
  review rules).
- No public review comments in the saved mbox.

UNRESOLVED:
- Full lore/stable@ threads (HTTP 403).
- No Tested-by from hardware.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — refcount accounting is
   consistent; maintainer-applied. Hardware Tested-by absent but the
   logic is verifiable from the code.
2. Fixes a real bug that affects users? **PASS** — dangling MR after
   failed `.set_map`.
3. Important issue? **PASS** — UAF / host crash, HIGH.
4. Small and contained? **PASS** — one file, +15/-8.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — buggy code present; clean
   apply.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Not an exception category** (not an ID/quirk/DT/build/doc
add). It qualifies as a normal UAF/refcount bug fix.

**Step 9.4: MAKE YOUR DECISION**
This tree has the bug. The patch is a small, correct rollback that
prevents a host UAF on a reachable vDPA map-update error path. Backport
it.

===============================================================
What the commit solves, and why it matters here
===============================================================

On 6.12, a live mlx5 vDPA map change with non-resumable firmware tears
down virtqueues, installs a new MR, then rebuilds queues. If rebuild
fails, `set_map_data()` still `put`s that new MR while `mres.mr[asid]`
points at it. The MR GC workqueue can free it two seconds later. Later
mkey reads are a use-after-free in the host kernel.

The fix keeps an extra ref on the old MR, installs the new one for the
rebuild (required, because create/modify read `mres.mr[]`), and on setup
failure restores the old MR so the extra ref becomes the map ref.
`change_map()` owns `new_mr` on all error paths, so the caller does not
double-put.

Risk vs benefit: low risk, high severity. No prerequisites missing in
6.12.111.

===============================================================
Verification
===============================================================
- [Phase 1] Parsed tags: SOB Weimin Xiong + Michael Tsirkin; Message-ID
  present; no Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: +15/-8 in `mlx5_vnet.c`; extra get on old MR; rollback
  via `update_mr`; move `new_mr` put into `change_map()`
- [Phase 2] `mlx5_vdpa_update_mr()` puts old and assigns new without get
  on new (mr.c:731)
- [Phase 2] `mlx5_vdpa_create_mr()` starts refcount at 1 (mr.c:832)
- [Phase 2] create_virtqueue reads `mvdev->mres.mr[]` for mkeys
  (mlx5_vnet.c:944)
- [Phase 3] blame: update-before-setup from 625e4b59 (v6.7-rc1);
  teardown/rebuild from f756dd3e (v6.8-rc1)
- [Phase 3] `git merge-base --is-ancestor 11f79e2780043 HEAD` → not in
  this tree
- [Phase 3] Postpone-MR-deletion 62111654481d5 is in this tree
  (v6.12-rc1); GC delay 2000ms (mr.c:664)
- [Phase 4] `b4 dig -c 11f79e27` →
  patch.msgid.link/20260716054353.155805-1-xiongwm2026@163.com
- [Phase 4] `b4 dig -a`: only v2; v1 was a different (incorrect) patch-
  id
- [Phase 4] `b4 dig -w`: Tatulea, Tsirkin, Wang, Perez CC'd
- [Phase 4] mbox: submission only, no replies; lore HTTP 403
- [Phase 5] callers: `mlx5_vdpa_set_map` ← vhost-vdpa `.set_map`
- [Phase 5] teardown path when `.resume` is NULL
  (`freeze_to_rdy_supported` missing, mlx5_vnet.c:4107)
- [Phase 6] `git describe HEAD` → p-6.12-3-gc504cf0baa3d8; `make
  kernelversion` → 6.12.111
- [Phase 6] current `mlx5_vdpa_change_map()` matches the pre-patch code;
  `git apply --check` clean
- [Phase 8] Failure mode: dangling MR → GC → UAF, severity HIGH
- UNVERIFIED: stable@ mailing-list discussion (lore 403); no hardware
  Tested-by

**YES**

 drivers/vdpa/mlx5/net/mlx5_vnet.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 44062e9d68f00..c49167d760a62 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -3044,18 +3044,24 @@ static int mlx5_vdpa_change_map(struct mlx5_vdpa_dev *mvdev,
 				unsigned int asid)
 {
 	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
+	struct mlx5_vdpa_mr *old_mr;
 	bool teardown = !is_resumable(ndev);
 	int err;
 
 	suspend_vqs(ndev, 0, ndev->cur_num_vqs);
 	if (teardown) {
 		err = save_channels_info(ndev);
-		if (err)
+		if (err) {
+			mlx5_vdpa_put_mr(mvdev, new_mr);
 			return err;
+		}
 
 		teardown_vq_resources(ndev);
 	}
 
+	/* Keep the old MR alive in case rebuilding the VQs fails. */
+	old_mr = mvdev->mres.mr[asid];
+	mlx5_vdpa_get_mr(mvdev, old_mr);
 	mlx5_vdpa_update_mr(mvdev, new_mr, asid);
 
 	for (int i = 0; i < mvdev->max_vqs; i++)
@@ -3063,17 +3069,22 @@ static int mlx5_vdpa_change_map(struct mlx5_vdpa_dev *mvdev,
 						MLX5_VIRTQ_MODIFY_MASK_DESC_GROUP_MKEY;
 
 	if (!(mvdev->status & VIRTIO_CONFIG_S_DRIVER_OK) || mvdev->suspended)
-		return 0;
+		goto out;
 
 	if (teardown) {
 		restore_channels_info(ndev);
 		err = setup_vq_resources(ndev, true);
-		if (err)
+		if (err) {
+			/* The saved reference becomes the restored map reference. */
+			mlx5_vdpa_update_mr(mvdev, old_mr, asid);
 			return err;
+		}
 	}
 
 	resume_vqs(ndev, 0, ndev->cur_num_vqs);
 
+out:
+	mlx5_vdpa_put_mr(mvdev, old_mr);
 	return 0;
 }
 
@@ -3357,15 +3368,11 @@ static int set_map_data(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
 		err = mlx5_vdpa_change_map(mvdev, new_mr, asid);
 		if (err) {
 			mlx5_vdpa_err(mvdev, "change map failed(%d)\n", err);
-			goto out_err;
+			return err;
 		}
 	}
 
 	return mlx5_vdpa_update_cvq_iotlb(mvdev, iotlb, asid);
-
-out_err:
-	mlx5_vdpa_put_mr(mvdev, new_mr);
-	return err;
 }
 
 static int mlx5_vdpa_set_map(struct vdpa_device *vdev, unsigned int asid,
-- 
2.53.0

