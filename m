Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82CE953BBA4;
	Mon, 19 Oct 2026 14:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418709; cv=none; b=KCERdk3LlKz8tJKRqaGSltNvuk9Kr/olY7JAu3aaRI4Zy7XHQwM4Qx5SpLW85wECgs9qfQX0ZiIUnYgyz9ev6e+n1Ah4GkaWxIFMyxIpIPhG+TV8CMbmK07H5fLvhBB0310F4zCRbUlcqFGrSxmuW16Ws2W/bW++oVFamLDnvbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418709; c=relaxed/simple;
	bh=gdpYHTHPa8GETDT41pyvYWhEKc76FlZ6XMBxJToRUhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U8Qo4+8OF3ylr1T0dUYbyftBUqw8higVPmZNPQreYmhyHhkRX6ZDO1dD2cVhJx2TIs5CmO2VXKsxZ+z07xBcmm1Sb2/ti7RSWE48ubLOK7KkGWJwABPqVEg+tZ9PoQD8gcMFh3JQBoJphmMY42IjrH7nhbyhsfGsqsHJl1yegHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G/JbqSml; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G/JbqSml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F75F1F000C5;
	Mon, 19 Oct 2026 14:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418706;
	bh=puJHvOR18uGgydD0UqVU9Q615PKFNOUYE1WyOkm/96U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G/JbqSmlVtllRjsmfilhgUCB2LFGVVwJe9jtVObJc3R0CFtdthYSOlvuq438OWDMQ
	 JdZfGRIFCkFRZTIm+CjyRDNPsM8jYB058IZ/BWaFNWshLxF7yqOIFrKTixbpLdlcjN
	 4B35RKgl/cylLlQG27QIgKuKLGLa+gntJb/6Pj5WX2UyST6aL6gvVJygKA1/W0q61/
	 ksR4fs3ziaesKm+8k2jdXQL62y4Vmx3HYXK5epJ93+cKS5hXmJClC8DFo1qC148FQS
	 QEziLXtlG/wfQW2CFouRtHwTNE+vop+k/AfTGokoU7R1Lgf07zHjClFpWi8cJh7fsr
	 qtJ+wZIjQg5pw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yichong Chen <chenyichong@uniontech.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sj1557.seo@samsung.com,
	exfat@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] exfat: clean up new entry on add entry failure
Date: Mon, 19 Oct 2026 09:52:09 -0400
Message-ID: <20261019135441.1420968-438-sashal@kernel.org>
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

From: Yichong Chen <chenyichong@uniontech.com>

[ Upstream commit 0901a71e8cff5c60dd464529cba2ed30a2ab0a3f ]

exfat_add_entry() initializes a new directory entry set before writing it
with exfat_put_dentry_set().  If the write fails, mkdir/create returns an
error but a partially written entry may be left behind.

For non-zero-size directories, the failure also happens after a cluster
has been allocated for the new directory.  Clean up the new entry
best-effort, and free the newly allocated directory cluster only when the
cleanup writeback succeeds.  This avoids freeing a cluster that may still
be referenced by an on-disk entry if the cleanup fails.

Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: **[exfat] [clean up] new entry on add-entry failure**

**Step 1.2: Tags**
Record:
- Signed-off-by: Yichong Chen <chenyichong@uniontech.com> (author)
- Signed-off-by: Namjae Jeon <linkinjeon@kernel.org> (exFAT maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, Link:,
  or Cc: stable (absence is expected)

**Step 1.3: Body**
Record: `exfat_add_entry()` fills a new directory entry set, then writes
it with `exfat_put_dentry_set()`. If that write fails, `mkdir`/`create`
return an error but a partial on-disk entry can remain. For non-zero-
size directories a cluster is already allocated. The patch best-effort-
deletes the new entry and frees the cluster **only if cleanup writeback
succeeds**, so a still-referenced cluster is not reused.

Symptom: leftover/ghost directory entries after failed create/mkdir;
leaked directory cluster. Root cause: error path after
`exfat_put_dentry_set()` did `goto out` with no rollback. No version
range stated.

**Step 1.4: Hidden bug fix?**
Record: Yes. “Clean up” is error-path rollback: leftover metadata and a
cluster leak, with an explicit guard against double-
allocation/corruption.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record: `fs/exfat/namei.c` only, **+16 / −1**. Function:
`exfat_add_entry()`. Surgical, single-file.

**Step 2.2: Flow**
Record:
- Before: on `exfat_put_dentry_set()` failure, return immediately; entry
  may be on disk; directory cluster stays allocated.
- After: re-load the entry set, `exfat_remove_entries(..., ES_IDX_FILE,
  false)`, write back; free `clu` only if that cleanup succeeds.

**Step 2.3: Bug mechanism**
Record: **Logic / error-path filesystem integrity** (orphan dentry +
resource leak; avoids use-after-free of a still-referenced cluster).
Confirmed in `exfat_update_bhs()`: with `sync` (`IS_DIRSYNC`), some
buffers can complete while others return `-EIO`;
`exfat_put_dentry_set()` then `bforget()`s, so a partial on-disk set is
real.

**Step 2.4: Fix quality**
Record: Minimal and aligned with the existing rename rollback in the
same file. v1 freed the cluster even when delete writeback failed; the
maintainer required v2. Remaining risk is conservative: if re-get fails,
the cluster stays allocated (leak, not double-allocation). No
API/locking/hot-path change.

## Phase 3: Git history

**Step 3.1: Blame**
Record: `exfat_add_entry()` is from `5f2aa075070cf` (“exfat: add inode
operations”, 2020-03-02, in **v5.7**). The unfixed `if (ret) goto out;`
after `exfat_put_dentry_set()` is that old. The new cleanup lines are
`0901a71e8cff5` (this commit).

**Step 3.2: Fixes: tag**
Record: None. Buggy pattern is original add-entry error handling, not a
later regression.

**Step 3.3: File history**
Record: Nearby work by the same author: `896fcc93574fd` (write dest
before removing source; same get/remove/put rollback), `ce12a39bed483`
(free dir cluster if zeroing fails — different function, not a compile
dep). No later follow-up on `dir_allocated`. Standalone vs that sibling.

**Step 3.4: Author**
Record: Yichong Chen, several exFAT error-path patches in Jul 2026.
Applied by maintainer Namjae Jeon.

**Step 3.5: Prerequisites**
Record: Uses `exfat_get_dentry_set`, `exfat_remove_entries(..., bool
free_benign)`, `exfat_free_cluster`. Four-arg `exfat_remove_entries` is
from `942296784b2a9` (v7.2-rc1). This 7.3-rc4 tree has all of them.
Older stables with 3-arg `exfat_remove_entries` would only need dropping
`false`. Parent `ce12a39bed483` is **not** required for this hunk.

## Phase 4: Mailing list

**Step 4.1: Original discussion**
Record: `b4 dig -c 0901a71e8cff5` → https://patch.msgid.link/20260729022
543.469171-1-chenyichong@uniontech.com
- v1: 2026-07-28 https://lore.kernel.org/all/20260728055504.412284-1-
  chenyichong@uniontech.com/
- v2 (applied): 2026-07-29

v1 freed the cluster even if delete failed. Namjae: that can reuse a
cluster still named on disk → **duplicated cluster corruption**. v2
matches his suggested code. He applied v2 to `#dev`. No NAK.

**Step 4.2: Recipients (`b4 dig -w`)**
Record: Namjae Jeon, Sungjong Seo, Yuezhang Mo, exfat@lists.linux.dev,
linux-kernel. Maintainer reviewed and applied.

**Step 4.3: Bug report**
Record: No syzbot/bugzilla/user report; found by inspection.

**Step 4.4: Series**
Record: Standalone patch (v1→v2), not a numbered series. Same-week
siblings are independent.

**Step 4.5: stable@**
Record: lore.kernel.org/stable search did not show this subject; no
recorded reason to skip it.

## Phase 5: Semantic analysis

**Step 5.1: Functions**
Record: `exfat_add_entry()` only.

**Step 5.2: Callers**
Record: `exfat_create()` (`fs/exfat/namei.c:570`) and `exfat_mkdir()`
(`:843`), both under `s_lock`. Userspace `creat`/`mkdir`.

**Step 5.3: Callees**
Record: `exfat_get_dentry_set`, `exfat_remove_entries`,
`exfat_put_dentry_set`, `exfat_free_cluster`. `__exfat_get_dentry_set()`
`memset`s `es` (safe after a failed put). `ES_ALL_ENTRIES` requires on-
disk type `EXFAT_FILE`; if the write never landed, re-get returns `-EIO`
and the cluster is not freed (intentional).

**Step 5.4: Reachability**
Record: Yes, from create/mkdir. `exfat_update_bhs()` only returns `-EIO`
when `sync` is set, so this path is **DIRSYNC or `dirsync` mount** plus
I/O error — common for removable exFAT (USB/SD).

**Step 5.5: Similar patterns**
Record: Same get/remove/put rollback in `exfat_find_renamed_entry` /
`exfat_move_file` after `896fcc93574fd`.

## Phase 6: This tree

**Step 6.1: Buggy code here?**
Record: Local tree is **v7.3-rc4** (`7.3.0-rc4`, HEAD `f0100363d8c37`).
`git merge-base --is-ancestor 0901a71e8cff5 HEAD` succeeds; the fix is
already in this checkout. Pre-fix `goto out` lived here from v5.7 until
`0901a71e8cff5` (7.3-rc1). Helpers used by the patch are present.

**Step 6.2: Backport difficulty**
Record: Clean on this tree (already applied). On older trees, likely a
trivial 3-arg `exfat_remove_entries` tweak only.

**Step 6.3: Related fixes already here?**
Record: Rename rollback is here; nothing else replaces this add-entry
cleanup. No later revert/amend of `0901a71e8cff5`.

## Phase 7: Subsystem

**Step 7.1:** Record: **fs/exfat** — **IMPORTANT** (not core VFS; widely
used on removable media).

**Step 7.2:** Record: Actively maintained (exfat-for-7.3-rc1). This is
error-path correctness, not a new feature.

## Phase 8: Impact and risk

**Step 8.1: Who**
Record: CONFIG_EXFAT_FS users, especially `dirsync` / `S_DIRSYNC` on
USB/SD.

**Step 8.2: Trigger**
Record: create/mkdir with DIRSYNC when dentry writeback hits `-EIO`.
Unprivileged users can call create/mkdir; they cannot force the I/O
error.

**Step 8.3: Failure mode**
Record: On-disk leftover/partial directory entries (name collisions,
inconsistent listings, fsck pain) and leaked directory clusters. Unfixed
v1-style free would be **cluster double-allocation**. Severity: **HIGH**
(metadata inconsistency / potential corruption), not a panic.

**Step 8.4: Risk/benefit**
Record: Benefit high for a small FS integrity fix. Risk low: ~16 lines,
error path only, maintainer-corrected, same pattern as rename.

## Phase 9: Synthesis

**Step 9.1: Evidence**

FOR:
- Real leftover entries and cluster leak after failed create/mkdir
- Maintainer: naive free causes duplicated-cluster corruption; v2 avoids
  that
- Small, one function, no new API
- Userspace-reachable; DIRSYNC on removable exFAT is realistic
- Bug present since v5.7; this tree has the call graph

AGAINST:
- I/O-error + DIRSYNC only; no Reported-by
- Best-effort: failed re-get still leaks a cluster
- Subject reads like cleanup

UNRESOLVED: none that change the call; stable@ had no specific skip
discussion.

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** — v2 is the maintainer’s code;
   applied to #dev then 7.3-rc1
2. Real user-visible bug? **PASS** — stale dentries / leaked clusters
   after failed mkdir/create
3. Important? **PASS** — filesystem metadata inconsistency; avoids a
   corruption footgun
4. Small? **PASS** — 16 insertions, one file
5. No new features/APIs? **PASS**
6. Applies here? **PASS** — code and helpers exist on this 7.3-rc4 tree

**Step 9.3: Exception category**
Record: None (not IDs/quirks/DT/build/docs). Ordinary FS error-path fix.

**Step 9.4: Decision**
This is a small, reviewed rollback for a long-standing exFAT
create/mkdir error path. It prevents leftover directory entries and, by
only freeing the new dir cluster after successful delete writeback,
avoids cluster reuse while an on-disk entry still points at it. That is
stable-appropriate on this tree.

---

### What it solves for stable users
Failed `exfat_put_dentry_set()` during DIRSYNC create/mkdir could leave
a partial directory entry and an allocated directory cluster while
userspace only saw `-EIO`. That is inconsistent metadata and a leak;
freeing the cluster blindly could let it be reused (**duplicated
cluster**). The patch deletes the new entry best-effort and frees the
cluster only after that delete hits disk.

### Stable rules / risk
Meets the rules: real FS integrity bug, small, no features, helpers
present here. Risk is low (error path, maintainer v2). Benefit is
avoiding ghost names and cluster double-allocation on failing removable
media.

### Concerns
Older stables with 3-arg `exfat_remove_entries` need a one-argument
drop. `ce12a39bed483` is not required. Cleanup is best-effort by design.

---

Verification:
- [Phase 1] Parsed `0901a71e8cff5`: author + maintainer SOB only; no
  Fixes/Reported-by/stable Cc
- [Phase 2] Diff: +16/−1 in `exfat_add_entry()`; error path after
  `exfat_put_dentry_set()`
- [Phase 2] `exfat_update_bhs()` (`fs/exfat/misc.c`): `-EIO` only when
  `sync`; partial DIRSYNC write is possible
- [Phase 2] `exfat_put_dentry_set()`: on error, `bforget()` — leftover
  on-disk data is real
- [Phase 3] `git blame`: add_entry from `5f2aa075070cf` (v5.7); cleanup
  from `0901a71e8cff5`
- [Phase 3] `git merge-base --is-ancestor 0901a71e8cff5 HEAD`: commit is
  in this tree
- [Phase 3] Parent `ce12a39bed483` is dir.c only; not needed to apply
  this hunk
- [Phase 3] 4-arg `exfat_remove_entries`: `942296784b2a9` (v7.2-rc1);
  present here
- [Phase 4] `b4 dig -c 0901a71e8cff5`: v2 lore URL; `b4 dig -a`: v1 then
  v2; `b4 dig -w`: maintainer CC’d
- [Phase 4] v1 mbox: Namjae required free-only-after-successful-delete;
  v2 applied to #dev
- [Phase 4] stable@ search: no thread about this commit
- [Phase 5] Callers: `exfat_create` / `exfat_mkdir` under `s_lock`
- [Phase 5] `__exfat_get_dentry_set` memsets `es`; `ES_ALL_ENTRIES`
  needs `EXFAT_FILE` type
- [Phase 6] `git describe HEAD`: v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion`: 7.3.0-rc4
- [Phase 6] Pre-fix source at `0901a71e8cff5^`: bare `if (ret) goto
  out;`
- [Phase 8] Failure: leftover dentries + cluster leak; v1 free =
  possible double-allocation
- UNVERIFIED: WebFetch to lore returned 403; used `b4 dig` + raw lore
  instead
- UNVERIFIED: no runtime test of DIRSYNC I/O failure on this checkout

**YES**

 fs/exfat/namei.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index 06bed867b46ad..9fe6635c60a42 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -476,6 +476,7 @@ static int exfat_add_entry(struct inode *inode, const char *path,
 	struct exfat_entry_set_cache es;
 	int clu_size = 0;
 	unsigned int start_clu = EXFAT_FREE_CLUSTER;
+	bool dir_allocated = false;
 
 	ret = exfat_resolve_path(inode, path, &uniname);
 	if (ret)
@@ -502,6 +503,7 @@ static int exfat_add_entry(struct inode *inode, const char *path,
 		}
 		start_clu = clu.dir;
 		clu_size = sbi->cluster_size;
+		dir_allocated = true;
 	}
 
 	/* update the directory entry */
@@ -512,8 +514,21 @@ static int exfat_add_entry(struct inode *inode, const char *path,
 	exfat_init_ext_entry(&es, num_entries, &uniname, NULL, 0);
 
 	ret = exfat_put_dentry_set(&es, IS_DIRSYNC(inode));
-	if (ret)
+	if (ret) {
+		int cleanup_ret;
+
+		cleanup_ret = exfat_get_dentry_set(&es, sb, &info->dir,
+						   dentry, ES_ALL_ENTRIES);
+		if (!cleanup_ret) {
+			exfat_remove_entries(inode, &es, ES_IDX_FILE, false);
+			cleanup_ret = exfat_put_dentry_set(&es,
+							   IS_DIRSYNC(inode));
+		}
+
+		if (!cleanup_ret && dir_allocated)
+			exfat_free_cluster(inode, &clu);
 		goto out;
+	}
 
 	info->entry = dentry;
 	info->flags = ALLOC_NO_FAT_CHAIN;
-- 
2.53.0

