Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8026552EB8;
	Mon, 19 Oct 2026 13:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418219; cv=none; b=kg3s+EbOjABx23YjVbFqjWfkT4K6xeA/L5RPsB4MctIzEBrXU6MQcqRZZ14bHHhMtNlZfJok8HuLy4B89pS27RcOeweOjiba6dLJ78hYRLeEEUAv7aRhaWTWE3dsS5fghnPBqRZV0Fam5FxddUfuVcE/DBt0AFp19w18x6m8pKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418219; c=relaxed/simple;
	bh=7tUZfxcD7COv27rz9IVJ9gMTyG9nyFLb3JVf2YOo4BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TWSDmo/KfbiKZ77WQS+m3xGi7fAakT3ur8Vxxk1M9OT7TkDRH1C4c3VbB2Cvpzgxh0cV3KKE3d8F6yIhvqft+1LjBAosfsYG5NNtIsqGPZwZkql9+OdhP2UTdkIUlRIrrOvp+Gwj+e5rh2Bw3BhLaAypGOkU6CYZuBCFpPnpAD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XH8DTxi/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XH8DTxi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8551F000CB;
	Mon, 19 Oct 2026 13:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418215;
	bh=6iyZVxZiHgeA5BgfiuJCJuKzY8aswxG3zPufo15540c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XH8DTxi/tcFMo9ZpQ7QhLxU5Rt4g+wbGTw7HFsbV2GjjETMAMCzYb7iPHSVSXr8q4
	 mAxuKlxz+25sZwLK4Pfo9V1ZbQYCV6b16xW0Env9jxzWOwO/oM4M58PFKb9Pc3Q43D
	 jqfR1Ppv+Fl0EcaY+euq9S4/nqKUUxX1KTGnaPtYZQfHXMObigWJ8oJAr7xhzNexeJ
	 g3bwGqhIMMHfvzgoiSZB4Ga39pEjjRgksCKKQ699oinRT5RqOD4tvVsM/QRqaNBUNb
	 StLBxMjhxhM/fazaC9+tkbZ3qAc69hmYf/HDKbDViVCwqVkaaKzv/4ENabstL91d/N
	 /Y8dd6ummsaxw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yichong Chen <chenyichong@uniontech.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sj1557.seo@samsung.com,
	exfat@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] exfat: write moved entry before removing source
Date: Mon, 19 Oct 2026 09:46:25 -0400
Message-ID: <20261019135441.1420968-94-sashal@kernel.org>
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

[ Upstream commit 896fcc93574fd511ee04a4110e8ea59d6d8d43d7 ]

exfat_move_file() removes the old directory entry before the new entry
has been written.  If writing the new entry fails, rename returns an
error after the source entry has already been marked deleted.

Write the new entry first, then remove the old entry and update the
cached inode location.  This keeps the source entry intact if creating
the destination entry fails.

Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This commit is a small filesystem data-loss fix: cross-directory rename
deleted the source before the destination write succeeded. Local tree is
**7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`); the change is already in
this history as `896fcc93574fd` (v7.3-rc1). The question is whether it
is technically worth sending to stable.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[exfat]** **[write … before]** write the destination directory
entry before removing the source during a move.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- `Signed-off-by: Yichong Chen <chenyichong@uniontech.com>` (author)
- `Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>` (exFAT
  maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, `Link:`, or `Cc: stable`
- Absence of `Fixes:` / `Cc: stable` is expected for this review and is
  not a negative signal

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `exfat_move_file()` marks the old directory entry deleted
  before the new entry is written.
- **Symptom:** A failed destination write still returns an error from
  rename, but the source is already gone.
- **Root cause:** Wrong operation order (remove source, then
  `exfat_put_dentry_set()` of the new set).
- **Fix:** Write the new entry first; only then remove the old entry and
  update the cached inode location.
- **Version info:** None in the message. Git: landed in v7.3-rc1; author
  date 2026-07-27.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not a disguised cleanup. The message describes a real rename
error-path data-loss bug.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `fs/exfat/namei.c` only (`5` insertions, `5` deletions)
- Function: `exfat_move_file()`
- Scope: single-file surgical reorder of existing statements; no new
  helpers or APIs

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record: **Before** (parent of `896fcc93574fd`):

1. Copy file/stream entries into the new set and call
   `exfat_init_ext_entry()`
2. `exfat_remove_entries()` on the source (`mov_es`)
3. Update `ei->dir` / `ei->entry` to the destination
4. `exfat_put_dentry_set(&new_es, …)` to write the destination
5. On failure: best-effort delete of the *new* entries, then `goto
   put_mov_es` (source already deleted in memory)

**After:** steps 4 then 2–3. Destination write is attempted first. On
failure the source is still intact; only the incomplete destination is
cleaned up.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** logic/correctness; filesystem metadata loss on I/O error
- **Mechanism:** `exfat_remove_entries()` only marks dentries
  `TYPE_DELETED` in the cached set (`dir.c`). Durability happens in
  `exfat_put_dentry_set()` → `exfat_update_bhs()`. That returns `-EIO`
  when `sync` is set (`IS_DIRSYNC`) and a buffer is not uptodate after
  wait. On error, `exfat_put_dentry_set()` `bforget()`s the destination
  buffers.
- Combined with `942296784b2a9` (v7.2-rc1), which added “best-effort
  delete” of the *new* entries on that failure: source already deleted
  **and** destination discarded/deleted → the file can disappear.
- Same-directory `exfat_rename_file()` already wrote the new set before
  removing the old one after `942296784b2a9`. Only the cross-directory
  path was wrong.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- Obviously correct: matches `exfat_rename_file()` and the pre-v6.9
  write-then-remove order.
- Minimal: three statements moved, no unrelated edits.
- Residual risk: if the destination write succeeds and the source-delete
  write later fails, both names can exist (duplicate entries). That is
  better than losing the file. No new locks, APIs, or data structures.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Original 2020 `exfat_move_file()` (`5f2aa075070cf`, v5.7 era) wrote
  destination buffers with `exfat_update_bh()` **before**
  `exfat_remove_entries()`.
- The inverted order was introduced by `d97e060673906d` (“exfat: convert
  exfat_init_ext_entry() to use dentry cache”, contained in
  **v6.9-rc1**). That commit batched destination writes into
  `exfat_put_dentry_set(&new_es)` but left `exfat_remove_entries()`
  *before* that put.
- `942296784b2a9` (v7.2-rc1) added the dest-cleanup error path while
  keeping the bad order, making loss complete on that path.
- `896fcc93574fd` (Yichong Chen, 2026-07-27) restores write-then-remove.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. The buggy conversion is `d97e060673906d`
(v6.9-rc1), present in this tree (`git merge-base --is-ancestor`
succeeded). `942296784b2a9` is also in this tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record:
- Immediate predecessor in `fs/exfat/`: `942296784b2a9` (preserve benign
  secondary entries; `Cc: stable`)
- Follow-ups by the same author, independent: `ce12a39bed483` (free dir
  cluster on zeroing failure), `0901a71e8cff5` (cleanup on
  `exfat_add_entry()` write failure)
- Standalone ordering fix, not “patch X/Y”

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Yichong Chen is a recent exFAT contributor (three error-path
fixes in this cycle), not the listed maintainer. Maintainer Namjae Jeon
applied the patch.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record:
- Clean apply of *this* diff assumes `942296784b2a9` (4-arg
  `exfat_init_ext_entry()`, `free_benign` on `exfat_remove_entries()`,
  best-effort dest delete). Both are in this 7.3 tree.
- The reorder itself does not need new functions. It can stand alone
  here.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c 896fcc93574fd`: https://patch.msgid.link/20260727091214.355
  917-1-chenyichong@uniontech.com
- `b4 dig -a`: **v1 only**, no later revisions
- Thread (mbox): submission + maintainer reply. Namjae Jeon: “Applied it
  to #dev.” No NAK, no requested changes.
- lore.kernel.org / patch.msgid.link HTTP fetch returned 403; discussion
  recovered via `b4 dig -m` and public mirrors (spinics, LKML, Patchew).

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): To/Cc Namjae Jeon, Sungjong Seo (maintainers),
Yuezhang Mo (reviewer), `exfat@lists.linux.dev`, `linux-
kernel@vger.kernel.org`. Maintainer applied it; no extra `Reviewed-by`
on the commit.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No `Reported-by` or bugzilla/syzbot link. Bug found by code
inspection of the error path, not a public crash report.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Standalone v1. Related later patches target `exfat_add_entry()`
/ `exfat_alloc_new_dir()`, not this reorder.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: No dedicated stable-list discussion of this subject was found.
`942296784b2a9` (prerequisite context) *did* carry `Cc: stable`.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: `exfat_move_file()` only.

**Step 5.2: TRACE CALLERS**

Record:
- `exfat_move_file()` ← `__exfat_rename()` when `new_parent_inode !=
  old_parent_inode`
- `__exfat_rename()` ← `exfat_rename()` (`inode_operations.rename`)
- Userspace trigger: `rename()` / `mv` across directories on an exFAT
  mount
- Same-directory rename uses `exfat_rename_file()`, already ordered
  correctly

**Step 5.3: TRACE CALLEES**

Record: `exfat_init_ext_entry()`, `exfat_put_dentry_set()` /
`exfat_update_bhs()`, `exfat_remove_entries()`, `exfat_get_dentry_set()`
on the error path. No allocations or new locks.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Reachable from the rename syscall. Failure of
`exfat_put_dentry_set(&new_es)` is a DIRSYNC/sync write `-EIO`
(`exfat_update_bhs()` only waits when `sync` is set). That is the
`dirsync` mount option or `S_DIRSYNC` on the directory. Unprivileged
users with write access to the volume can hit the path; the I/O-error
half needs a failed dest directory write.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: `exfat_rename_file()` already put the new set, then removed the
old set, after `942296784b2a9`. This commit makes `exfat_move_file()`
match that.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: Yes, in this tree’s history. `d97e060673906d` (v6.9) and
`942296784b2a9` (v7.2) are ancestors of HEAD. Current `fs/exfat/namei.c`
already has the fixed order at `exfat_move_file()` (write new, then
`exfat_remove_entries()`).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: On **this** 7.3-rc4 tree the patch applies (it is already
merged). Context matches `942296784b2a9`.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: This exact fix is already HEAD-reachable (`git merge-base --is-
ancestor 896fcc93574fd HEAD`). No later revert or competing fix on
`exfat_move_file()`.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **exFAT** (`fs/exfat/`). **IMPORTANT** — not VFS core, but a
widely used filesystem (SD cards, USB sticks, Android/Windows
interchange). Metadata loss on rename is user-visible data loss.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Actively maintained (Namjae Jeon / Sungjong Seo; frequent
7.2–7.3 exFAT pulls). This is a targeted error-path fix, not a drive-by
refactor.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: Users of `CONFIG_EXFAT_FS` who cross-directory rename/move.
Default mounts without `dirsync` rarely take the `-EIO` return from
`exfat_put_dentry_set()` (non-sync `exfat_update_bhs()` only dirties
buffers). `dirsync` / `S_DIRSYNC` plus dest write failure is the
concrete fail path.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record:
- Cross-directory `rename()` on exFAT
- Destination directory-entry write fails (`IS_DIRSYNC` + I/O error)
- Not a race; sequential error handling
- Unprivileged if they can write the volume

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: Source directory entry marked deleted, destination write
discarded (`bforget`), then best-effort delete of dest → **file
disappears / orphaned clusters**. **Severity: CRITICAL** (data loss),
even though the trigger is an I/O error path.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** Prevents losing a file when cross-dir rename hits a dest
  write error; also stops `942296784b2a9`’s dest-cleanup from deleting
  the only remaining name.
- **Risk:** Very low (10-line reorder, same pattern as
  `exfat_rename_file()`).
- **Ratio:** High benefit / very low risk.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real filesystem data-loss bug, not style
- Small, obviously correct reorder
- Matches the already-correct `exfat_rename_file()` path
- Bug introduced in v6.9 (`d97e060673906d`); made worse in v7.2
  (`942296784b2a9`, which was `Cc: stable`)
- Maintainer applied v1 with no objections
- No new features/APIs; applies in this tree’s code
- Reachable from `rename(2)`

AGAINST:
- No public user report / syzbot / `Fixes:` tag
- Trigger needs DIRSYNC (or equivalent) plus dest I/O error — uncommon
- No `Tested-by`
- This 7.3-rc4 checkout already contains the commit (does not reduce
  technical merit for stable)

UNRESOLVED:
- Could not HTTP-fetch lore.kernel.org (403); thread recovered via `b4
  dig -m` and mirrors
- No evidence this was discussed on stable@ (search did not turn up this
  subject)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — ordering is clearly right;
   maintainer applied it. No extra tester tag, but the change is
   reviewable from the code.
2. Fixes a real bug that affects users? **PASS** — rename can drop the
   source name on dest write failure.
3. Important issue? **PASS** — data loss / missing directory entry.
   **CRITICAL**
4. Small and contained? **PASS** — ±5 lines, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — already present; context with
   `942296784b2a9` is here

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: Not a device-ID/quirk/DT/build/docs exception. It is a normal
important bugfix.

**Step 9.4: MAKE YOUR DECISION**

This is a surgical fix for metadata loss on cross-directory exFAT
rename. The wrong order has been in the dentry-cache path since v6.9 and
became fully destructive with v7.2’s dest-cleanup. Benefit is preventing
file disappearance; regression risk is negligible. It meets stable rules
for this tree’s exFAT code.

Verification:
- [Phase 1] Parsed tags: only author + maintainer SOBs; no
  Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: 5+/5- in `exfat_move_file()`; moved
  `exfat_remove_entries` + `ei->dir`/`ei->entry` to after successful
  `exfat_put_dentry_set(&new_es)`
- [Phase 2] `exfat_put_dentry_set`/`exfat_update_bhs`: `-EIO` only when
  `sync` and buffer not uptodate; error path `bforget()`s dest buffers
- [Phase 3] `git describe HEAD` / `make kernelversion`: v7.3-rc4 /
  7.3.0-rc4
- [Phase 3] `git show 896fcc93574fd`: commit
  `896fcc93574fd511ee04a4110e8ea59d6d8d43d7`
- [Phase 3] `git merge-base --is-ancestor 896fcc93574fd HEAD`: yes
  (already in this tree)
- [Phase 3] `git describe --contains 896fcc93574fd`: v7.3-rc1~87^2~6
- [Phase 3] `git merge-base --is-ancestor d97e060673906d HEAD`: yes;
  contained in v6.9-rc1 (introduced remove-before-put)
- [Phase 3] `git merge-base --is-ancestor 942296784b2a9 HEAD`: yes;
  v7.2-rc1 (dest-cleanup error path)
- [Phase 3] `git blame fs/exfat/namei.c` around the hunk: reorder
  attributed to `896fcc93574fd`; dest-cleanup to `942296784b2a9`
- [Phase 3] Original 2020 `exfat_move_file` wrote dest with
  `exfat_update_bh` before `exfat_remove_entries`
- [Phase 4] `b4 dig -c/-a/-w/-m`: v1 only; maintainers CC’d; Namjae Jeon
  applied to #dev; no NAK
- [Phase 4] lore HTTP 403; mbox + Patchew/LKML/spinics confirm the same
  thread
- [Phase 4] No stable@ hit for this subject
- [Phase 5] Callers: only `__exfat_rename()` → `exfat_rename()` (VFS
  rename), cross-directory only
- [Phase 6] Current `namei.c` already has the fixed order; no later
  revert
- [Phase 7] MAINTAINERS: Namjae Jeon, Sungjong Seo; reviewer Yuezhang Mo
- [Phase 8] Failure mode verified in code: source deleted in cache, dest
  write failed/forgotten, then dest also removed
- UNVERIFIED: whether any particular older stable series already carried
  a handwritten equivalent (not needed for this 7.3 tree)

**YES**

 fs/exfat/namei.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index 6b544df0a03a6..06bed867b46ad 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -1156,11 +1156,6 @@ static int exfat_move_file(struct inode *parent_inode,
 	exfat_init_ext_entry(&new_es, num_new_entries, p_uniname,
 			     &mov_es, num_extra_entries);
 
-	exfat_remove_entries(parent_inode, &mov_es, ES_IDX_FILE, false);
-
-	ei->dir = newdir;
-	ei->entry = newentry;
-
 	ret = exfat_put_dentry_set(&new_es, IS_DIRSYNC(parent_inode));
 	if (ret) {
 		/* Best-effort delete to avoid duplicate entries */
@@ -1174,6 +1169,11 @@ static int exfat_move_file(struct inode *parent_inode,
 		goto put_mov_es;
 	}
 
+	exfat_remove_entries(parent_inode, &mov_es, ES_IDX_FILE, false);
+
+	ei->dir = newdir;
+	ei->entry = newentry;
+
 	return exfat_put_dentry_set(&mov_es, IS_DIRSYNC(parent_inode));
 
 put_mov_es:
-- 
2.53.0

