Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EAAB4A5C2E;
	Mon, 31 Aug 2026 13:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183858; cv=none; b=DNlZLSA+bfQE4pM2CdbOiCXSCjUgP2ceEu/flxB2+8UhwyfK19WPBanPwNqMm50ENKVJshHA07yto0WM7p0VuYNzjH8fmaARlG6RTIEZfTvK6W1VP4fGwrJ7T3WL9lBJhZD0hiDb1PtbyMgcvz5e3VUFzNheKy436FoMWCqCHG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183858; c=relaxed/simple;
	bh=3dljvT2RW0SpC2Nt24HFEUr6CFzmomVHhhwhIcKOVqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f1+EMaWYwMSU7U8bG4IJg3P4VWzHnq80avit2MyFFRzC5zUYrgxU48V4R+HhwpMtdn2T5wKYl1xI7rRJ+Jgx3DFBdMGxgZWF5t03XqMRHYwDhaJkNSKEmP9gqDSpQKtndEdtOGdVkCl6rzQQ0joBzvYbonGLBMwRMcmwjAlqrzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fGGY1Hcp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fGGY1Hcp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12A31F00ACA;
	Mon, 31 Aug 2026 13:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183855;
	bh=W9hs4yCVMuwtOEDhBP/5X3aIuUOtMvfpYZF8O8jo20U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fGGY1HcpvGAqmeQ2tk1YSRMuCPVaG8bcU6sUyZPusq85WaDnS+ACt721JvlLvEZYG
	 xHemmKpOyEyZFPvgHF9Lv1YGGxJBsn3OqKUKMYC+8H7I8/7dPbyahmDbyVEI6U7ROI
	 Nju/tcGhDISeUA3F4j9s6e8ocXrQt+PRObpT2u4/eKIglam81el34VKhH5W9AfUqfs
	 7lerky29WLxjDaNFS+uWyuRKFG3qxqvjHucbnWXzidrKK50+8rp3oYKtKUQ+Xv/IzS
	 +CawwgF46o+r/vl5Et9zqxbWSqa+U38adD0tcLqdEDQ/sphJOmB33Hs62yno1oDGgN
	 av78uAQ3s8Dmw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Viacheslav Dubeyko <slava@dubeyko.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Yangtao Li <frank.li@vivo.com>,
	linux-fsdevel@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] hfsplus: rework hfsplus_readdir() logic
Date: Mon, 31 Aug 2026 09:26:12 -0400
Message-ID: <20260831133314.4125787-344-sashal@kernel.org>
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

From: Viacheslav Dubeyko <slava@dubeyko.com>

[ Upstream commit 4b0496432844628ad05a5b1efce329a3340174d2 ]

The xfstests' test-case generic/637 fails with error:

FSTYP -- hfsplus
PLATFORM -- Linux/x86_64 hfsplus-testing-0001 6.15.0-rc4+ #8 SMP PREEMPT_DYNAMIC Thu May 1 16:43:22 PDT 2025
MKFS_OPTIONS -- /dev/loop51
MOUNT_OPTIONS -- /dev/loop51 /mnt/scratch

QA output created by 637
entries 7 and 8 have duplicate d_off 8
Found unlinked files in open dir (see xfstests-dev/results//generic/637.full for details)

Debugging of the hfsplus_readdir() logic showed this:

hfsplus: hfsplus_readdir(): 163 ctx->pos 0
hfsplus: hfsplus_readdir(): 189 ctx->pos 1
hfsplus: hfsplus_readdir(): 264 ctx->pos 2, ino 18
hfsplus: hfsplus_readdir(): 264 ctx->pos 3, ino 19
hfsplus: hfsplus_readdir(): 264 ctx->pos 4, ino 28
hfsplus: hfsplus_readdir(): 264 ctx->pos 5, ino 118
hfsplus: hfsplus_readdir(): 264 ctx->pos 6, ino 29
hfsplus: hfsplus_readdir(): 264 ctx->pos 7, ino 30
hfsplus: hfsplus_readdir(): 264 ctx->pos 8, ino 31
hfsplus: hfsplus_readdir(): 304 ctx->pos 8
hfsplus: hfsplus_unlink():420 dir->i_ino 17, inode->i_ino 28
hfsplus: hfsplus_readdir(): 141 ctx->pos 7
hfsplus: hfsplus_readdir(): 264 ctx->pos 7, ino 31
hfsplus: hfsplus_readdir(): 264 ctx->pos 8, ino 32
hfsplus: hfsplus_readdir(): 264 ctx->pos 9, ino 33

It means that hfsplus_readdir() stopped the processing of
folder's items on ctx->pos 8, then, item with ino 28 has
been deleted and hfsplus_readdir() re-started the logic
from ctx->pos 7. As a result, previous and new sets of
folder's items have overlapping values for the case of
d_off 8.

Currently, HFS+ has very complicated and fragile logic
of rd->file->f_pos correction in hfsplus_delete_cat().
This patch removes this logic and it stores the current
pos into hfsplus_readdir_data. Finally, if rd->pos == ctx->pos
then hfsplus_readdir() tries to find the position in
b-tree's node by means of hfsplus_cat_key. This position is
used to re-start the folder's content traversal.

sudo ./check generic/637
FSTYP         -- hfsplus
PLATFORM      -- Linux/x86_64 hfsplus-testing-0001 7.1.0-rc1+ #44 SMP PREEMPT_DYNAMIC Mon May  4 15:58:45 PDT 2026
MKFS_OPTIONS  -- /dev/loop51
MOUNT_OPTIONS -- /dev/loop51 /mnt/scratch

generic/637  22s ...  22s
Ran: generic/637
Passed all 1 tests

Closes: https://github.com/hfs-linux-kernel/hfs-linux-kernel/issues/198
cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
cc: Yangtao Li <frank.li@vivo.com>
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20260505220051.2854696-2-slava@dubeyko.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
Record: `[hfsplus] [rework] Fix fragile `hfsplus_readdir()` position
tracking that breaks xfstests generic/637`

**Step 1.2 — Tags**
Record:
- `Closes: https://github.com/hfs-linux-kernel/hfs-linux-
  kernel/issues/198`
- `cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>`
- `cc: Yangtao Li <frank.li@vivo.com>`
- `cc: linux-fsdevel@vger.kernel.org`
- `Link:
  https://lore.kernel.org/r/20260505220051.2854696-2-slava@dubeyko.com`
- `Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>` (author)
- No `Fixes:`, `Reported-by:`, `Reviewed-by:`, `Acked-by:`, `Tested-
  by:`, or `Cc: stable@vger.kernel.org`
- Notable: xfstests failure documented; GitHub issue closed by author
  after fix

**Step 1.3 — Body analysis**
Record:
- **Bug:** During partial `readdir()` on an open directory, if a catalog
  entry is deleted, `hfsplus_delete_cat()` decrements `f_pos` for open
  readers, but `hfsplus_readdir()` resumes using `ctx->pos` via
  `hfs_brec_goto()`. After a mid-read stop, these diverge, producing
  duplicate `d_off` values and stale (unlinked) entries.
- **Symptom:** xfstests generic/637 fails with `entries 7 and 8 have
  duplicate d_off 8` and `Found unlinked files in open dir`.
- **Root cause:** Fragile `rd->file->f_pos--` logic in
  `hfsplus_delete_cat()` does not correctly track btree position across
  concurrent deletes.
- **Fix approach:** Remove per-inode open-dir list and `f_pos`
  adjustment; store `ctx->pos` and catalog key in
  `hfsplus_readdir_data`; on resume, if `rd->pos == ctx->pos`, locate
  btree position by key.
- **Testing:** Author reports generic/637 passes after fix.

**Step 1.4 — Hidden bug fix?**
Record: **Yes.** Subject says "rework," but this is a directory-
iteration correctness bug fix, not a refactor.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
Record:
- `fs/hfsplus/catalog.c` — 11 lines removed
- `fs/hfsplus/dir.c` — net ~14 lines changed
- `fs/hfsplus/hfsplus_fs.h` — 5 lines changed
- `fs/hfsplus/inode.c` — 2 lines removed
- `fs/hfsplus/super.c` — 2 lines removed
- **Total:** 5 files, +12 / −36 lines
- **Functions:** `hfsplus_delete_cat()`, `hfsplus_readdir()`,
  `hfsplus_dir_release()`, `hfsplus_new_inode()`, `hfsplus_iget()`
- **Scope:** Single-subsystem surgical fix

**Step 2.2 — Code flow per hunk**
Record:
1. **`hfsplus_delete_cat()`:** Before: on delete, walk `open_dir_list`
   and decrement `f_pos` for readers past deleted key. After: no `f_pos`
   manipulation.
2. **`hfsplus_readdir()` resume:** Before: always `hfs_brec_goto(&fd,
   ctx->pos - 1)`. After: if saved `rd->pos == ctx->pos`, find btree
   record by stored `rd->key` (with `-ENOENT` fallback); else use
   numeric offset.
3. **`hfsplus_readdir()` bookmark:** Before: register `rd` on per-inode
   list, save only key. After: save `rd->pos = ctx->pos` and key in per-
   file `private_data`.
4. **`hfsplus_dir_release()`:** Before: list removal under spinlock.
   After: simple `kfree()`.
5. **Struct cleanup:** Remove `open_dir_list`, `open_dir_lock` from
   `hfsplus_inode_info`; simplify `hfsplus_readdir_data` to `{ loff_t
   pos; struct hfsplus_cat_key key; }`.

**Step 2.3 — Bug mechanism**
Record: **Logic/correctness fix** in directory iteration during
concurrent unlink. The old `f_pos--` scheme breaks when `readdir()`
stops mid-buffer (`dir_emit()` returns false): `ctx->pos` and adjusted
`f_pos` disagree, so resumed reads revisit wrong catalog entries →
duplicate `d_off` and visible deleted files.

**Step 2.4 — Fix quality**
Record: Fix is logically sound and minimal. Replacing numeric-offset
resume with catalog-key lookup is the standard approach for btree-backed
directories. Regression risk is **low** — removes spinlock/list
complexity rather than adding it. No public API changes.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
Record: `open_dir_list` / `f_pos--` code is present in current tree
(blame shows import-era ancestry via `5d324e5159d9e`). The buggy
mechanism predates 6.18.y by many kernel releases.

**Step 3.2 — Fixes: tag**
Record: N/A — no `Fixes:` tag in commit message.

**Step 3.3 — Related file history**
Record: This stable tree already contains multiple hfsplus xfstests
fixes from the same author:
- `282214ddf8472` generic/073
- `54694417d4384` generic/480
- `956b1d8051cfa` generic/498
Standalone v1 patch; not part of a multi-commit series.

**Step 3.4 — Author context**
Record: Viacheslav Dubeyko is the active hfs/hfsplus maintainer with a
track record of stable-worthy filesystem correctness fixes in this
subsystem.

**Step 3.5 — Dependencies**
Record: No prerequisites. Cherry-pick onto this tree succeeds cleanly
(`git cherry-pick --no-commit 4b04964328446` auto-merged all 5 files).
Standalone.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
Record: `b4 dig -c 4b04964328446` →
https://patch.msgid.link/20260505220051.2854696-2-slava@dubeyko.com.
Single v1 submission (no v2/v3). Mbox contains only the patch itself —
no review replies.

**Step 4.2 — Reviewers**
Record: `b4 dig -w` CC'd `linux-fsdevel@vger.kernel.org`, glaubitz,
frank.li. No `Reviewed-by`/`Acked-by` in thread (author self-committed
to mainline).

**Step 4.3 — Bug report**
Record: GitHub issue #198 confirms reproducible generic/637 failure on
hfsplus since at least 6.15.0-rc4; closed May 2026 referencing this
patch.

**Step 4.4 — Related patches**
Record: Sibling commit `7fde7e806657f` applies the same fix to `fs/hfs/`
(plain HFS). That is a separate backport candidate; this analysis covers
only the hfsplus commit.

**Step 4.5 — Stable list discussion**
Record: No stable-specific lore discussion found. Not a negative signal
per instructions.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
Record: `hfsplus_readdir()`, `hfsplus_delete_cat()`,
`hfsplus_dir_release()`

**Step 5.2 — Callers**
Record: `hfsplus_readdir` is registered as `.iterate_shared` in
`hfsplus_dir_operations` (`fs/hfsplus/dir.c:622`), reachable from
`getdents64`/`readdir` syscalls on open directory fds.
`hfsplus_delete_cat()` is called from unlink/rmdir/remove paths in
`dir.c`, `inode.c`, `super.c`.

**Step 5.3 — Callees**
Record: `hfs_brec_goto()`, `hfs_brec_find()`, `dir_emit()`,
`hfs_brec_remove()` — standard hfsplus btree/catalog operations.

**Step 5.4 — Reachability**
Record: **Userspace-reachable.** Any process doing `getdents64()` on an
hfsplus directory while another thread/process unlinks entries in that
directory can trigger this. generic/637 exercises exactly this.

**Step 5.5 — Similar patterns**
Record: Identical `open_dir_list`/`f_pos--` pattern exists in `fs/hfs/`
(`fs/hfs/catalog.c:370-375`, `fs/hfs/dir.c`). Same class of bug; fixed
separately on mainline.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.y)

**Step 6.1 — Buggy code present?**
Record: **Yes.** Local tree is `v6.18.43` on `stable/linux-6.18.y`.
Buggy `f_pos--` logic confirmed at `fs/hfsplus/catalog.c:394-402`;
`open_dir_list`/`open_dir_lock` in `hfsplus_fs.h` and init paths. Fix
commit `4b04964328446` is **not** an ancestor of HEAD.

**Step 6.2 — Backport complications**
Record: **Clean apply.** Cherry-pick auto-merges all files. Initial `git
apply --check` failed only on `kmalloc_obj` vs `kmalloc` hunk; cherry-
pick resolved this automatically.

**Step 6.3 — Related fixes already present?**
Record: No equivalent fix (`rd->pos` not present). Prior hfsplus
generic/* corruption fixes are in tree but address different bugs.

---

## Phase 7: Subsystem Context

**Step 7.1 — Subsystem/criticality**
Record: `fs/hfsplus` — filesystem driver. **IMPORTANT** for hfsplus
users; not universal core code, but VFS directory semantics are
fundamental to any user of the filesystem.

**Step 7.2 — Activity**
Record: Active maintenance in 6.18.y — multiple recent hfsplus fixes
(uninit-value, lock-free-on-error, xfstests corruption fixes).

---

## Phase 8: Impact and Risk

**Step 8.1 — Who is affected**
Record: Users with `CONFIG_HFSPLUS_FS` who read directories while
entries are being deleted (backup tools, `find`, file managers,
concurrent workloads). Niche filesystem but real macOS-interop use case.

**Step 8.2 — Trigger conditions**
Record: Open directory fd → partial `readdir()` (buffer fills before
EOF) → unlink of catalog entry whose key sorts before the reader's saved
position → continue `readdir()`. Realistic for multi-threaded or multi-
process directory traversal. Unprivileged users can trigger on mounts
they can write to.

**Step 8.3 — Failure mode severity**
Record: Incorrect directory enumeration — duplicate `d_off`, deleted
files still visible to `getdents64`. Not on-disk corruption, but
violates POSIX directory semantics and can cause userspace to skip files
or process stale names. **Severity: MEDIUM-HIGH** (correctness /
semantic violation with real userspace impact).

**Step 8.4 — Risk/benefit**
Record: **Benefit: HIGH** for hfsplus users (fixes reproducible xfstests
failure, aligns with prior stable backports from same subsystem).
**Risk: LOW** (net code reduction, cherry-picks cleanly, author-tested).
Ratio strongly favors backport.

---

## Phase 9: Final Synthesis

**Evidence FOR:**
- Reproducible, documented bug (generic/637, GitHub #198)
- Violates directory iteration semantics (duplicate offsets, stale
  entries)
- Small, self-contained, cherry-picks cleanly to 6.18.y
- Author tested with xfstests
- Same maintainer's generic/* hfsplus fixes already in this stable tree
- Bug present since ancient hfsplus code; affects 6.18.y today
- Removes fragile synchronization (spinlock + per-inode list) in favor
  of simpler per-fd state

**Evidence AGAINST:**
- No independent reviewer Ack on mailing list (author self-committed)
- hfsplus is not a widely deployed filesystem
- Not a crash/Oops/security issue — correctness only

**Unresolved:** None material to the decision.

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** — clear mechanism, xfstests
   generic/637 passes
2. Fixes real bug affecting users? **PASS** — reproducible directory
   enumeration corruption
3. Important issue? **PASS** — MEDIUM-HIGH correctness; stale/deleted
   entries in `readdir`
4. Small and contained? **PASS** — 5 files, net −24 lines
5. No new features/APIs? **PASS** — internal implementation change only
6. Can apply to local tree? **PASS** — verified clean cherry-pick

**Exception category:** N/A (not device ID/quirk/build/doc fix; standard
bug fix)

---

## Verification

- [Phase 1] Parsed commit `4b04964328446` message and tags from `git
  show`
- [Phase 2] Diff analysis: 5 files, +12/−36; classified as directory
  iteration correctness fix
- [Phase 3] `git describe HEAD` → `v6.18.43`; `git merge-base --is-
  ancestor 4b04964328446 HEAD` → fix NOT in tree
- [Phase 3] `git log --grep='generic/' -- fs/hfsplus/` → prior stable-
  worthy fixes present (073, 480, 498)
- [Phase 3] `git cherry-pick --no-commit 4b04964328446` → clean auto-
  merge of all 5 files
- [Phase 4] `b4 dig -c 4b04964328446` → lore URL found; v1 only, no
  review replies in mbox
- [Phase 4] `b4 dig -a` → single revision
- [Phase 4] `b4 dig -w` → CC list retrieved
- [Phase 4] GitHub issue #198 → confirms generic/637 failure, closed
  with patch reference
- [Phase 4] Web search → generic/637 tests `getdents64` while unlinking
  files in open directory
- [Phase 5] `grep hfsplus_dir_operations` → `.iterate_shared =
  hfsplus_readdir` at dir.c:622
- [Phase 5] `grep hfsplus_delete_cat` → called from unlink/rmdir paths
- [Phase 6] `grep open_dir_list/open_dir_lock` in fs/hfsplus → buggy
  code confirmed present
- [Phase 6] `grep rd->pos` in fs/hfsplus → absent (fix not applied)
- [Phase 6] Cherry-pick test → applies cleanly

This commit fixes a real, reproducible hfsplus directory iteration bug
that is present in the 6.18.y tree, applies cleanly, matches the pattern
of prior hfsplus xfstests fixes already backported here, and carries low
regression risk.

**YES**The background check confirmed commit `4b04964328446` (`hfsplus:
rework hfsplus_readdir() logic`) is **not** in this tree — the buggy
`open_dir_list` / `f_pos--` code is still present on
`stable/linux-6.18.y` at `v6.18.43`.

That supports the earlier **YES** verdict: this is a real directory-
iteration bug (generic/637), the fix cherry-picks cleanly, and it fits
the pattern of other hfsplus xfstests fixes already in 6.18.y.

 fs/hfsplus/catalog.c    | 11 -----------
 fs/hfsplus/dir.c        | 28 +++++++++++-----------------
 fs/hfsplus/hfsplus_fs.h |  5 +----
 fs/hfsplus/inode.c      |  2 --
 fs/hfsplus/super.c      |  2 --
 5 files changed, 12 insertions(+), 36 deletions(-)

diff --git a/fs/hfsplus/catalog.c b/fs/hfsplus/catalog.c
index 6c8380f7208df..fd2a9460e6aa8 100644
--- a/fs/hfsplus/catalog.c
+++ b/fs/hfsplus/catalog.c
@@ -332,7 +332,6 @@ int hfsplus_delete_cat(u32 cnid, struct inode *dir, const struct qstr *str)
 	struct super_block *sb = dir->i_sb;
 	struct hfs_find_data fd;
 	struct hfsplus_fork_raw fork;
-	struct list_head *pos;
 	int err, off;
 	u16 type;
 
@@ -391,16 +390,6 @@ int hfsplus_delete_cat(u32 cnid, struct inode *dir, const struct qstr *str)
 		hfsplus_free_fork(sb, cnid, &fork, HFSPLUS_TYPE_RSRC);
 	}
 
-	/* we only need to take spinlock for exclusion with ->release() */
-	spin_lock(&HFSPLUS_I(dir)->open_dir_lock);
-	list_for_each(pos, &HFSPLUS_I(dir)->open_dir_list) {
-		struct hfsplus_readdir_data *rd =
-			list_entry(pos, struct hfsplus_readdir_data, list);
-		if (fd.tree->keycmp(fd.search_key, (void *)&rd->key) < 0)
-			rd->file->f_pos--;
-	}
-	spin_unlock(&HFSPLUS_I(dir)->open_dir_lock);
-
 	err = hfs_brec_remove(&fd);
 	if (err)
 		goto out;
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index 8aeb861969d37..8254d6c92eb94 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -185,7 +185,15 @@ static int hfsplus_readdir(struct file *file, struct dir_context *ctx)
 	}
 	if (ctx->pos >= inode->i_size)
 		goto out;
-	err = hfs_brec_goto(&fd, ctx->pos - 1);
+	rd = file->private_data;
+	if (rd && rd->pos == ctx->pos) {
+		memcpy(fd.search_key, &rd->key, sizeof(struct hfsplus_cat_key));
+		err = hfs_brec_find(&fd, hfs_find_rec_by_key);
+		if (err == -ENOENT)
+			err = hfs_brec_goto(&fd, 1);
+	} else {
+		err = hfs_brec_goto(&fd, ctx->pos - 1);
+	}
 	if (err)
 		goto out;
 	for (;;) {
@@ -261,7 +269,6 @@ static int hfsplus_readdir(struct file *file, struct dir_context *ctx)
 		if (err)
 			goto out;
 	}
-	rd = file->private_data;
 	if (!rd) {
 		rd = kmalloc(sizeof(struct hfsplus_readdir_data), GFP_KERNEL);
 		if (!rd) {
@@ -269,15 +276,8 @@ static int hfsplus_readdir(struct file *file, struct dir_context *ctx)
 			goto out;
 		}
 		file->private_data = rd;
-		rd->file = file;
-		spin_lock(&HFSPLUS_I(inode)->open_dir_lock);
-		list_add(&rd->list, &HFSPLUS_I(inode)->open_dir_list);
-		spin_unlock(&HFSPLUS_I(inode)->open_dir_lock);
 	}
-	/*
-	 * Can be done after the list insertion; exclusion with
-	 * hfsplus_delete_cat() is provided by directory lock.
-	 */
+	rd->pos = ctx->pos;
 	memcpy(&rd->key, fd.key, sizeof(struct hfsplus_cat_key));
 out:
 	kfree(strbuf);
@@ -287,13 +287,7 @@ static int hfsplus_readdir(struct file *file, struct dir_context *ctx)
 
 static int hfsplus_dir_release(struct inode *inode, struct file *file)
 {
-	struct hfsplus_readdir_data *rd = file->private_data;
-	if (rd) {
-		spin_lock(&HFSPLUS_I(inode)->open_dir_lock);
-		list_del(&rd->list);
-		spin_unlock(&HFSPLUS_I(inode)->open_dir_lock);
-		kfree(rd);
-	}
+	kfree(file->private_data);
 	return 0;
 }
 
diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index 2da2bd52d200e..9e92493e55c62 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -215,8 +215,6 @@ struct hfsplus_inode_info {
 	sector_t fs_blocks;
 	u8 userflags;		/* BSD user file flags */
 	u32 subfolders;		/* Subfolder count (HFSX only) */
-	struct list_head open_dir_list;
-	spinlock_t open_dir_lock;
 	loff_t phys_size;
 
 	struct inode vfs_inode;
@@ -266,8 +264,7 @@ struct hfs_find_data {
 };
 
 struct hfsplus_readdir_data {
-	struct list_head list;
-	struct file *file;
+	loff_t pos;
 	struct hfsplus_cat_key key;
 };
 
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 7e6cc4dde9f26..ab1c343955b10 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -459,8 +459,6 @@ struct inode *hfsplus_new_inode(struct super_block *sb, struct inode *dir,
 	simple_inode_init_ts(inode);
 
 	hip = HFSPLUS_I(inode);
-	INIT_LIST_HEAD(&hip->open_dir_list);
-	spin_lock_init(&hip->open_dir_lock);
 	mutex_init(&hip->extents_lock);
 	atomic_set(&hip->opencnt, 0);
 	hip->extent_state = 0;
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index e1e2833f528d1..d031c77fb4eb3 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -91,8 +91,6 @@ struct inode *hfsplus_iget(struct super_block *sb, unsigned long ino)
 	HFSPLUS_I(inode)->fs_blocks = 0;
 	HFSPLUS_I(inode)->userflags = 0;
 	HFSPLUS_I(inode)->subfolders = 0;
-	INIT_LIST_HEAD(&HFSPLUS_I(inode)->open_dir_list);
-	spin_lock_init(&HFSPLUS_I(inode)->open_dir_lock);
 	HFSPLUS_I(inode)->phys_size = 0;
 
 	if (inode->i_ino >= HFSPLUS_FIRSTUSER_CNID ||
-- 
2.53.0

