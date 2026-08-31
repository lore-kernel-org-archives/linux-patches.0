Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5F243BDD6;
	Mon, 31 Aug 2026 13:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183221; cv=none; b=XvEgJIorpOr9PX2DI8DKeTbfFLBa3FTsYeZVZoTor+aUM3OwKnNS4Bdm7EY5BL2OOXRdKukTRvppBOSVTH1krlnYWXUHU1mPAxBC1mb3JxkLwWNxvoRYE829k1T0RXlsRvL9X8MFbP+LRG9Dz873qMwPDvcME4ygYY61yMiADQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183221; c=relaxed/simple;
	bh=TE17VwI9rll3f2GWMfg7sEj/C6x4l/DjzALtKz0vQbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LrmC+a3b2XT+O+BhjmRAhHb8pM42zufXZDpRGTDCivf3ZxuL4gfFCnN08ouJoloPSo+rb2FRZwje0iYi7Yz4FzAvY3U1IPY5n+z2RtqHikhF8YDLJoRd4HEktVpBwGN5uiU3kp7ZEU2w3wkpiqLGLi244gGZZ9Rlnblu1gLFxCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b4/xcCCf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b4/xcCCf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F14D1F00ACA;
	Mon, 31 Aug 2026 13:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183219;
	bh=btqJjj1YUoC5weF03sT25svIkf/+PmS962BjMyfzVHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b4/xcCCf1FKPa0PC98eAuUvUANhQpp1IqDYMDIPpKqiiarXYsQ+yv60JljUHnxKpu
	 e+lJJQOiOHvhkFg7BeDOVjuTJ1asElCx2Z0vsjZQ12RpDmVVtMlEhgXNp3JvYOHxeu
	 c/XY7GQyCFP55jHNoMlKY5BoRkjtGUaHI/QP87wjBlY40x7pr7rOBuWf9UESuaOSTF
	 6gtZRmOyliMuoN2U+1xg1Lu5KYJEyCHpraHK2XFnJ3j3hWvP3PQIEY+ZqObDV6aCz0
	 ZTP39ws4ZfAtvJjBixEvBxH3bhm9KYL06m2KG2unyMuoS+r1twFahIBs2s5A8ZTB71
	 IFfIwA37C/FnQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yung-Tse Cheng <mes900903@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	gmaglione@redhat.com,
	vgoyal@redhat.com,
	stefanha@redhat.com,
	miklos@szeredi.hu,
	virtualization@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] virtio-fs: avoid double-free on failed queue setup
Date: Mon, 31 Aug 2026 09:20:44 -0400
Message-ID: <20260831133314.4125787-16-sashal@kernel.org>
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

From: Yung-Tse Cheng <mes900903@gmail.com>

[ Upstream commit 6af3330ec5d5fb8c06c04eb520a71cf73ea5a765 ]

virtio_fs_setup_vqs() allocates fs->vqs and fs->mq_map before calling
virtio_find_vqs(). If virtio_find_vqs() fails, the error path frees both
pointers and returns an error to virtio_fs_probe().

virtio_fs_probe() then drops the last kobject reference, and
virtio_fs_ktype_release() frees fs->vqs and fs->mq_map again. This leaves
dangling pointers in struct virtio_fs and can trigger a double-free during
probe failure cleanup.

Set fs->vqs and fs->mq_map to NULL immediately after kfree() in the
virtio_fs_setup_vqs() error path so that the later kobject release sees an
uninitialized state and kfree(NULL) becomes harmless.

This can be reproduced when a broken virtio-fs device advertises more
request queues than the transport actually provides. In that case
virtio_find_vqs() fails while setting up the extra queue, and the probe
path reaches the double-free cleanup sequence.

Signed-off-by: Yung-Tse Cheng <mes900903@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[virtio-fs] [avoid] double-free on failed queue setup` —
explicit bug fix in the virtio-fs driver error path during virtqueue
setup.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Yung-Tse Cheng `<mes900903@gmail.com>` (author)
- **Signed-off-by:** Miklos Szeredi `<mszeredi@redhat.com>`
  (FUSE/virtio-fs maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, Link:,
  or Cc: stable tags

Notable: maintainer Signed-off-by is a strong quality signal.

### Step 1.3: Body Analysis
**Record:**
- **Bug:** On `virtio_find_vqs()` failure in `virtio_fs_setup_vqs()`,
  the error path frees `fs->vqs` and `fs->mq_map`, but
  `virtio_fs_probe()` then calls `kobject_put()`, which runs
  `virtio_fs_ktype_release()` and frees the same pointers again.
- **Symptom:** Double-free and dangling pointers during probe-failure
  cleanup; potential kernel crash / memory corruption.
- **Trigger:** Broken virtio-fs device advertising more request queues
  than the transport actually provides.
- **Root cause:** Missing NULL assignment after `kfree()` in the setup
  error path, so the kobject release path cannot tell memory was already
  freed.

### Step 1.4: Hidden Bug Fix?
**Record:** No — this is an explicit, clearly described double-free fix,
not disguised cleanup.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **File:** `fs/fuse/virtio_fs.c` (+2 lines, 0 removed)
- **Function:** `virtio_fs_setup_vqs()`
- **Scope:** Single-file, surgical fix (2 lines)

### Step 2.2: Code Flow Change
**Record:**
- **Hunk (error path in `virtio_fs_setup_vqs()`):**
  - **Before:** On failure (`ret != 0`), `kfree(fs->vqs)` and
    `kfree(fs->mq_map)` leave dangling pointers in `struct virtio_fs`.
  - **After:** Same frees, then `fs->vqs = NULL` and `fs->mq_map =
    NULL`, so later `virtio_fs_ktype_release()` does harmless
    `kfree(NULL)`.

### Step 2.3: Bug Mechanism
**Record:** **Category:** Double-free / dangling pointer on error path.
**Mechanism:** `virtio_fs_setup_vqs()` and `virtio_fs_ktype_release()`
both free the same allocations without coordinating ownership transfer.

### Step 2.4: Fix Quality
**Record:** Obviously correct, minimal, standard kernel pattern.
Regression risk is very low — only affects the failure path and makes
cleanup idempotent.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:**
- `kfree(fs->vqs)` in error path: Stefan Hajnoczi, 2018-06-12
  (`a62a8ef9d97da2`)
- `if (ret) { ... kfree(fs->mq_map); }` wrapper: Peter-Jan Gootzen,
  2024-05-01 (`529395d2ae6456`, "virtio-fs: add multi-queue support")
- The **double-free mechanism** was introduced when kobject lifecycle
  landed in `virtio_fs_ktype_release()` — commit `a8f62f50b4e4e`
  (2024-02-12, "virtiofs: export filesystem tags through sysfs"). That
  commit is an ancestor of this tree and of `v6.18`.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag present.

### Step 3.3: Related File History
**Record:** Recent `virtio_fs.c` activity includes other probe/cleanup
fixes (e.g. `c014021253d77` incorrect fsvq kobj check). No related fix
for this double-free is present. The candidate fix is not yet in this
tree.

### Step 3.4: Author Context
**Record:** Yung-Tse Cheng has no prior commits in this checkout. Miklos
Szeredi is the FUSE maintainer and signed off on the patch.

### Step 3.5: Dependencies
**Record:** Standalone, 2-line fix. No series dependencies. `git apply
--check` succeeds cleanly against the local tree.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:** `b4 dig -c` failed (commit not in local tree). Web search
found the patch at [mail-archive.com](https://www.mail-
archive.com/linux-kernel@vger.kernel.org/msg2622149.html) and [Patchew](
https://patchew.org/linux/20260405193039.178506-1-mes900903@gmail.com/).
Posted 2026-04-06 by Yung-Tse Cheng. Standalone 1-patch series. Lore
fetch timed out; no review-thread details retrieved.

### Step 4.2: Reviewers
**Record:** From Spinics archive: To: virtio-fs maintainers (gmaglione,
vgoyal, stefanha, miklos). Cc: virtualization@, linux-fsdevel@, linux-
kernel@. Appropriate maintainers were included.

### Step 4.3: Bug Report
**Record:** No external bug report or syzbot link. Author describes
reproducible scenario with a misconfigured/broken virtio-fs device.

### Step 4.4: Related Patches
**Record:** Standalone fix, not part of a multi-patch series.

### Step 4.5: Stable List History
**Record:** No stable-list discussion found. UNVERIFIED due to lore
access failure.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `virtio_fs_setup_vqs()`, `virtio_fs_ktype_release()`,
`virtio_fs_probe()`

### Step 5.2: Callers
**Record:**
- `virtio_fs_setup_vqs()` — called only from `virtio_fs_probe()` (line
  1133)
- `virtio_fs_ktype_release()` — kobject `.release` callback, invoked via
  `kobject_put()` from `virtio_fs_probe()` error path (line 1160) and
  normal teardown paths

### Step 5.3: Callees
**Record:** `kcalloc()`, `virtio_find_vqs()`, `kfree()`, `kobject_put()`
— standard probe allocation/cleanup.

### Step 5.4: Reachability
**Record:**
```
virtio device probe → virtio_fs_probe()
  → virtio_fs_setup_vqs() [fails]
    → error path kfree(vqs, mq_map)
  → out: kobject_put()
    → virtio_fs_ktype_release() [double-free without fix]
```
Reachable during virtio-fs device enumeration when queue setup fails
(broken device, ENOMEM, or `virtio_find_vqs()` failure). Not a syscall
path directly, but triggered during driver probe on systems with virtio-
fs enabled.

### Step 5.5: Similar Patterns
**Record:** No `fs->vqs = NULL` or `fs->mq_map = NULL` anywhere in
current `virtio_fs.c`. The dangling-pointer pattern is unique to this
error path.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Local tree is **v6.18.44** (`git describe HEAD` →
`v6.18.44-1-g2736c32da98b9`). Current code at lines 989–992 frees
without NULLing:

```989:992:fs/fuse/virtio_fs.c
        if (ret) {
                kfree(fs->vqs);
                kfree(fs->mq_map);
        }
```

And `virtio_fs_ktype_release()` at lines 195–196 frees the same pointers
again. Fix is not yet applied.

### Step 6.2: Backport Complications
**Record:** Clean apply — `git apply --check` passed with exit code 0.
No conflicts expected.

### Step 6.3: Related Fixes Already Present?
**Record:** None. `git log -S 'fs->mq_map = NULL'` returned no results.
No grep matches for NULL assignments.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem
**Record:** `fs/fuse/virtio_fs.c` — virtio-fs driver (FUSE over virtio).
**Criticality: IMPORTANT** — affects virtualization/virtio-fs users, not
universal core kernel, but probe failures can crash the host/VM.

### Step 7.2: Activity
**Record:** Actively maintained; recent virtio-fs and fuse fixes in this
tree.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Systems with `CONFIG_VIRTIO_FS` enabled (module or built-in)
where virtio-fs device probe fails during queue setup — VMs with virtio-
fs, hosts exporting virtio-fs, or broken/malicious virtio device
configurations.

### Step 8.2: Trigger Conditions
**Record:**
- `virtio_find_vqs()` failure (e.g. device advertises more queues than
  transport supports)
- Also any error path through `out:` label with `ret != 0` after
  `fs->vqs`/`fs->mq_map` were allocated (including ENOMEM)
- Not everyday, but reproducible on probe failure; privileged entity
  controlling virtio device configuration can trigger it

### Step 8.3: Failure Mode Severity
**Record:** **Double-free** → kernel oops, possible memory corruption.
**Severity: HIGH** (crash / potential security impact from heap
corruption on probe failure).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH — prevents crash on legitimate probe failure paths
- **Risk:** VERY LOW — 2 lines, error-path only, idempotent cleanup
- **Ratio:** Strongly favors backport

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real double-free bug with clear mechanism
- Reproducible trigger described (broken virtio-fs queue advertisement)
- HIGH severity (kernel crash / memory corruption)
- Minimal 2-line fix, applies cleanly
- FUSE maintainer (Miklos Szeredi) Signed-off-by
- Bug present in this 6.18.44 tree since kobject lifecycle (Feb 2024);
  mq_map added second vector (May 2024)
- Standard NULL-after-kfree pattern

**AGAINST backport:**
- Only triggered on probe failure, not hot path
- No syzbot report or CVE
- Lore review thread not fully retrieved

**UNRESOLVED:**
- Whether reviewers explicitly nominated for stable (lore fetch failed)
- Whether patch has landed in mainline yet (not in this checkout)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — standard pattern; maintainer
   SOB; author describes reproduction
2. Fixes a real bug? **PASS** — verified double-free in local code
3. Important issue? **PASS** — double-free on probe failure (HIGH)
4. Small and contained? **PASS** — 2 lines, 1 file
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — clean apply verified

### Step 9.3: Exception Categories
**Record:** None — this is a straight bug fix, not a
quirk/ID/DT/build/doc exception.

### Step 9.4: Decision Rationale
This tree (6.18.44) contains the buggy code: `virtio_fs_setup_vqs()`
frees `fs->vqs` and `fs->mq_map` on error without NULLing them, and
`virtio_fs_probe()` unconditionally calls `kobject_put()` which re-frees
them in `virtio_fs_ktype_release()`. The fix is minimal, obviously
correct, and prevents a kernel crash on a realistic probe-failure path.
It fully meets stable kernel criteria.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message
- [Phase 1] Confirmed maintainer Signed-off-by: Miklos Szeredi
- [Phase 2] Read current `virtio_fs_setup_vqs()` error path (lines
  986–993): missing NULL assignments
- [Phase 2] Read `virtio_fs_ktype_release()` (lines 191–197): frees same
  pointers
- [Phase 2] Read `virtio_fs_probe()` error path (lines 1158–1161):
  `kobject_put()` on all failures
- [Phase 3] `git describe HEAD`: v6.18.44-1-g2736c32da98b9
- [Phase 3] `git blame -L 989,992`: error-path code from 2018 (vqs) and
  2024 (mq_map wrapper)
- [Phase 3] `git show 529395d2ae6456`: mq_map kfree added to error path
  without NULL
- [Phase 3] `git show a8f62f50b4e4e`: kobject lifecycle introduced
  double-free mechanism
- [Phase 3] `git merge-base --is-ancestor a8f62f50b4e4e HEAD`: confirmed
  in tree
- [Phase 3] `git merge-base --is-ancestor 529395d2ae6456 HEAD`:
  confirmed in tree
- [Phase 3] `git log -S 'fs->mq_map = NULL'`: no existing fix
- [Phase 4] `b4 dig -c df25d4faca41c`: failed (commit not in tree)
- [Phase 4] Web search: found patch submission at mail-archive.com and
  Patchew (2026-04-06)
- [Phase 4] Lore direct fetch: timed out — review comments UNVERIFIED
- [Phase 5] `grep virtio_fs_setup_vqs`: single caller in
  `virtio_fs_probe()`
- [Phase 5] Traced probe → setup_vqs error → kobject_put → ktype_release
  call chain
- [Phase 6] Confirmed buggy code present at lines 989–992; fix absent
  (no NULL assignments)
- [Phase 6] `git apply --check`: patch applies cleanly (exit 0)
- [Phase 7] Read `fs/fuse/Kconfig`: VIRTIO_FS depends on FUSE_FS +
  VIRTIO
- [Phase 8] Assessed severity: double-free on probe failure = HIGH

**YES**Those background searches finished and line up with the earlier
analysis:

- **Author lookup** — No commits from Yung-Tse Cheng / `mes900903` in
  this 6.18.44 tree; the patch is still a candidate, not merged here.
- **Commit message search** — Nothing matching “avoid double-free on
  failed queue setup” in local history.
- **Alternate-fix search** — No other commit in `fs/fuse/` that already
  fixes this.

Together that confirms the bug is present locally and the fix isn’t
applied yet. The backport recommendation remains **YES**.

 fs/fuse/virtio_fs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index b2f6486fe1d56..2b3daa93e299a 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -988,7 +988,9 @@ static int virtio_fs_setup_vqs(struct virtio_device *vdev,
 	kfree(vqs);
 	if (ret) {
 		kfree(fs->vqs);
+		fs->vqs = NULL;
 		kfree(fs->mq_map);
+		fs->mq_map = NULL;
 	}
 	return ret;
 }
-- 
2.53.0

