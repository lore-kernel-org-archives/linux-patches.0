Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E6E426D30;
	Mon, 20 Apr 2026 13:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691758; cv=none; b=j18qrJqOm6iUlrIT+Rp4/qJxqkm+SEZY2vUDbXHItVfrspAGbLoXhsbPMiOLzXtUawxZzWYzAL/HQK0SSxHERBzej4JAyxHUUD9c+0DsOIPMqwbyRihCan1T1WF4OKBfX4H7FGDI81BpqhEG2CjB9eC1/M0ogED3l5wi9o9PC9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691758; c=relaxed/simple;
	bh=QhsY025C2nNu4jEGyaVOaI6kxyIQawcmKacAriMzsIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fdp9t8o45Sdh1/tmtKogUjj6wFieoQlNkbt61K8s/GCvFMbfINYI4ev+uB4POBMUQ7/KvBQXmRpvIaCWsbO4QnLfJ9SoF0g8QgacoZ4pjdh5z12rEZFtFqqn8k3d/T09wGVNXyoZKrCYeTtRdQE9ZCCF2ZDqETbpVoArFVx1vEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dvuZ197X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dvuZ197X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B37AC2BCB4;
	Mon, 20 Apr 2026 13:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691758;
	bh=QhsY025C2nNu4jEGyaVOaI6kxyIQawcmKacAriMzsIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dvuZ197X89M5hwPGOAu3qZMhTmY4bewucP12GR9NtRS7h2B6hYRVy+NYJYf/wKnn4
	 GEUl20jLgz/W3dg0SWnkfjG3c6/POa4ecKmf3rYbVs2Je0l8wtP0PXgTcbKm87Js8h
	 MWzBF+KHVFgWnHPG/gj4pNn1s1+aLMQTaTgrRVsGhsTiXe7m8GtAMI+UUs2QuTJL0p
	 O6dyW24ZtL3ZlhpPUMsmUjBnA2xfbh96Kt9OjfRsOciCfsILv9uY7wb2xzCjfcSTzt
	 oLCV0JKLXfZpaqwSL3xDlL+Gy+qcWYu65q05gc7naNo1a0T04yvdNjcwkWBQaZiibe
	 3eFVoAKj/zzBQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Helen Koike <koike@igalia.com>,
	syzbot+e14b1036481911ae4d77@syzkaller.appspotmail.com,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	shaggy@kernel.org,
	jfs-discussion@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] jfs: hold LOG_LOCK on umount to avoid null-ptr-deref
Date: Mon, 20 Apr 2026 09:19:30 -0400
Message-ID: <20260420132314.1023554-176-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
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

From: Helen Koike <koike@igalia.com>

[ Upstream commit ca5848ae87d24886a7886f5a22278bd4045c15f8 ]

write_special_inodes() function iterate through the log->sb_list and
access the sbi fields, which can be set to NULL concurrently by umount.

Fix concurrency issue by holding LOG_LOCK and checking for NULL.

Reported-by: syzbot+e14b1036481911ae4d77@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e14b1036481911ae4d77
Signed-off-by: Helen Koike <koike@igalia.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

---

## Full Analysis

### PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `jfs` (JFS filesystem)
- Action verb: "hold" (LOG_LOCK) + "avoid" (null-ptr-deref)
- Summary: Hold LOG_LOCK during umount to prevent null pointer
  dereference in `write_special_inodes`

Record: [jfs] [hold/avoid] [prevent null-ptr-deref by holding LOG_LOCK
during umount teardown]

**Step 1.2: Tags**
- `Reported-by: syzbot+e14b1036481911ae4d77@syzkaller.appspotmail.com` -
  syzbot fuzzer found this (strong YES signal)
- `Closes: https://syzkaller.appspot.com/bug?extid=e14b1036481911ae4d77`
  - syzbot bug tracker link
- `Signed-off-by: Helen Koike <koike@igalia.com>` - patch author
- `Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>` - JFS
  maintainer signed off (strong quality signal)

Record: syzbot-reported, JFS maintainer signed-off. No Fixes: tag
(expected for review candidates).

**Step 1.3: Commit Body**
- Bug: `write_special_inodes()` iterates `log->sb_list` and accesses
  `sbi` fields (`ipbmap`, `ipimap`, `direct_inode`) that can be
  concurrently set to NULL by `jfs_umount()`.
- Symptom: general protection fault / null-ptr-deref (kernel crash)
- Fix: Hold LOG_LOCK during teardown in umount + add NULL checks in
  `write_special_inodes()`

Record: Race condition between log sync and filesystem unmount, causing
a null pointer dereference in `write_special_inodes`. Root cause is
unsynchronized access to `sbi` fields during concurrent umount.

**Step 1.4: Hidden Bug Fix Detection**
This is explicitly a bug fix, not disguised.

---

### PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- `fs/jfs/jfs_logmgr.c`: -9 lines (removes LOG_LOCK macros, adds NULL
  checks in `write_special_inodes`)
- `fs/jfs/jfs_logmgr.h`: +7 lines (moves LOG_LOCK macros here so
  `jfs_umount.c` can use them)
- `fs/jfs/jfs_umount.c`: +10 lines (adds `#include "jfs_logmgr.h"`,
  wraps teardown section with LOG_LOCK/LOG_UNLOCK)

Total: +24/-9, 3 files. Small, well-contained fix.

**Step 2.2: Code Flow Changes**

Hunk 1 (jfs_logmgr.c): Moves `LOG_LOCK_INIT`/`LOG_LOCK`/`LOG_UNLOCK`
macro definitions from `.c` to `.h` file. No behavior change.

Hunk 2 (jfs_logmgr.c, `write_special_inodes`):
- Before: Unconditionally dereferences `sbi->ipbmap->i_mapping`,
  `sbi->ipimap->i_mapping`, `sbi->direct_inode->i_mapping`
- After: Adds NULL checks before each dereference

Hunk 3 (jfs_logmgr.h): Adds the moved LOG_LOCK macros.

Hunk 4 (jfs_umount.c):
- Before: `jfs_umount()` tears down sbi fields (sets to NULL) without
  holding LOG_LOCK
- After: Acquires LOG_LOCK before teardown, releases after
  `filemap_write_and_wait()`, before `updateSuper()`

**Step 2.3: Bug Mechanism**
Category: Race condition / NULL pointer dereference

The race window:
1. Thread A: `jfs_sync_fs()` -> `jfs_syncpt()` -> `lmLogSync()` ->
   `write_special_inodes()` iterates `log->sb_list`
2. Thread B: `jfs_umount()` sets `sbi->ipimap = NULL`, `sbi->ipbmap =
   NULL` etc.
3. The `list_del(&sbi->log_list)` (which removes sbi from sb_list) only
   happens later in `lmLogClose()` (line 1445)
4. Window: sbi is still on `sb_list` but its fields are NULL

Fix mechanism: Hold LOG_LOCK in umount during teardown. Since
`jfs_syncpt()` also holds LOG_LOCK before calling `lmLogSync()`, the two
paths are now serialized. Additionally, NULL checks in
`write_special_inodes` provide belt-and-suspenders safety.

**Step 2.4: Fix Quality**
- Obviously correct: LOG_LOCK is the existing per-log serialization
  mechanism, and `jfs_syncpt` already uses it
- Minimal and surgical: only adds synchronization around existing
  teardown code
- Regression risk: Very low. The LOG_LOCK is a mutex. `jfs_umount`
  already calls `jfs_flush_journal(log, 2)` before this code which does
  `write_special_inodes` itself, so the lock ordering is safe (no
  deadlock risk since `jfs_flush_journal` doesn't hold LOG_LOCK during
  its `write_special_inodes` calls)

---

### PHASE 3: GIT HISTORY

**Step 3.1: Blame**
- `write_special_inodes` introduced by commit `67e6682f18b3bf` (Dave
  Kleikamp, 2007-10-10) - present since v2.6.24
- The umount code setting sbi fields to NULL goes back to
  `1da177e4c3f41` (Linus Torvalds, 2005-04-16) - the initial Linux tree
  import
- The `sbi->ipbmap = NULL` was fixed in `d0e482c45c501` (2022) - before
  that it was a typo (`sbi->ipimap = NULL` was set twice)

Record: Bug has existed since `write_special_inodes` was introduced in
2007, affecting ALL stable trees.

**Step 3.2: No Fixes: tag** - expected for review candidates.

**Step 3.3: File History** - None of the recent changes to these files
affect the buggy code paths. The race condition code is untouched
ancient code.

**Step 3.4: Author** - Helen Koike is a kernel contributor (drm/ci
primarily), not the JFS maintainer. But the commit was signed off by
Dave Kleikamp, the JFS maintainer (`shaggy@kernel.org`).

**Step 3.5: Dependencies** - The only "dependency" is moving LOG_LOCK
macros to the header, which is done in the same commit. Fully self-
contained.

---

### PHASE 4: MAILING LIST RESEARCH

**b4 dig**: Found the original submission at
`https://patch.msgid.link/20260227181150.736848-1-koike@igalia.com`.
Single version (v1), no revisions needed.

**Syzbot report**: The bug page confirms:
- Crash type: "general protection fault in lmLogSync" - KASAN: null-ptr-
  deref
- First reported: ~1295 days ago (September 2022)
- Still actively crashing as recently as 9h45m before page load
- Fix commit identified as `ca5848ae87d2`
- **Similar bugs exist on linux-5.15, linux-6.1, and linux-6.6** stable
  trees (all marked 0/N patched)
- The bug has been in syzbot monthly reports for 36+ months

**Recipients**: Sent to JFS maintainer (shaggy@kernel.org), jfs-
discussion list, linux-kernel, linux-fsdevel.

---

### PHASE 5: CODE SEMANTIC ANALYSIS

**Callers of `write_special_inodes`:**
1. `lmLogSync()` (line 935/937) - called with LOG_LOCK held from
   `lmLog()` (line 321) and `jfs_syncpt()` (line 1038)
2. `jfs_flush_journal()` (lines 1572/1581) - called WITHOUT LOG_LOCK

**Call chain for crash:**
`jfs_sync_fs()` -> `jfs_syncpt()` -> LOG_LOCK -> `lmLogSync()` ->
`write_special_inodes()` -> dereference `sbi->ipbmap` (NULL) -> CRASH

`sync_filesystem()` in VFS -> `jfs_sync_fs()` -> same path

**Race counterpart:**
`generic_shutdown_super()` -> `kill_block_super()` -> ... ->
`jfs_umount()` -> sets sbi fields to NULL -> `lmLogClose()` does
`list_del`

The crash trace from syzbot confirms exactly this path:
```
write_special_inodes fs/jfs/jfs_logmgr.c:208
lmLogSync+0x244/0x9f0 fs/jfs/jfs_logmgr.c:937
jfs_syncpt+0x7b/0x90 fs/jfs/jfs_logmgr.c:1041
jfs_sync_fs+0x87/0xa0 fs/jfs/super.c:650
sync_filesystem+0x1ce/0x250 fs/sync.c:66
generic_shutdown_super+0x77/0x2d0 fs/super.c:625
```

---

### PHASE 6: STABLE TREE ANALYSIS

- The buggy code (`write_special_inodes` from 2007, umount NULL
  assignments from 2005) exists in ALL active stable trees
- Syzbot confirms active crashing on linux-5.15, linux-6.1, linux-6.6
- None of these stable trees have been patched (0/N patched status on
  syzbot)
- No intermediate changes to the affected code in stable trees
- Backport should be clean: the affected code is ancient and unchanged

---

### PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

- Subsystem: JFS filesystem (fs/jfs/)
- Criticality: IMPORTANT - JFS is a real filesystem used in production
- Maintainer: Dave Kleikamp signed off, confirming this fix
- JFS is mature/stable - minimal recent development, making this
  longstanding bug more important

---

### PHASE 8: IMPACT AND RISK ASSESSMENT

**Who is affected:** All JFS users
**Trigger conditions:** Concurrent `sync` and `umount` operations on JFS
filesystems. The syzbot reproducer triggers this from userspace (umount
syscall racing with sync). Triggerable by unprivileged users if they can
unmount.
**Failure mode:** Kernel oops / general protection fault (NULL pointer
dereference). Severity: **CRITICAL** (system crash)
**Frequency:** Syzbot has been hitting this continuously for 3.5+ years

**Benefit:** Prevents a real kernel crash on all JFS systems. HIGH
benefit.
**Risk:** Very LOW. The fix is 24 lines net, adds synchronization using
existing infrastructure (LOG_LOCK mutex), and adds defensive NULL
checks. No new APIs, no behavior change, no regression risk.

---

### PHASE 9: FINAL SYNTHESIS

**Evidence FOR backporting:**
1. Fixes a confirmed, reproducible kernel crash (null-ptr-deref / GPF)
2. Syzbot-reported with C reproducer, crashing continuously for 3.5+
   years
3. Bug exists in ALL active stable trees (5.15, 6.1, 6.6) - syzbot
   confirms
4. Small, surgical fix: +24/-9 lines across 3 files
5. Obviously correct: uses existing LOG_LOCK mechanism + NULL checks
6. JFS maintainer (Dave Kleikamp) signed off
7. Standalone, self-contained fix with no dependencies
8. Triggerable from userspace (sync + umount race)

**Evidence AGAINST backporting:**
- None identified

**Stable Rules Checklist:**
1. Obviously correct and tested? YES - uses existing locking, syzbot
   confirms fix
2. Fixes a real bug? YES - null-ptr-deref / kernel crash
3. Important issue? YES - CRITICAL severity (system crash)
4. Small and contained? YES - 3 files, +24/-9 lines
5. No new features/APIs? YES - only adds synchronization and safety
   checks
6. Can apply to stable? YES - code is unchanged in stable trees

---

### Verification

- [Phase 1] Parsed tags: Reported-by syzbot, Closes syzkaller link, SOB
  from JFS maintainer Dave Kleikamp
- [Phase 2] Diff analysis: NULL checks added to
  `write_special_inodes()`, LOG_LOCK held in `jfs_umount()` during
  teardown
- [Phase 3] git blame: `write_special_inodes` introduced in commit
  `67e6682f18b3bf` (2007), umount NULL assignments from `1da177e4c3f41`
  (2005) - present in all stable trees
- [Phase 3] git log: no intermediate fixes for this race condition
- [Phase 3] Verified `list_del(&sbi->log_list)` happens in
  `lmLogClose()` (line 1445), AFTER umount sets fields to NULL,
  confirming the race window
- [Phase 4] b4 dig: found original submission at
  `https://patch.msgid.link/20260227181150.736848-1-koike@igalia.com`,
  single version (v1)
- [Phase 4] b4 dig -w: sent to JFS maintainer and relevant lists
- [Phase 4] Syzbot page: confirms crash "general protection fault in
  lmLogSync (2)", first crash ~1295 days ago, still actively
  reproducing, similar bugs on linux-5.15/6.1/6.6 (all unpatched)
- [Phase 5] Traced call chain: `jfs_sync_fs -> jfs_syncpt -> LOG_LOCK ->
  lmLogSync -> write_special_inodes` races with `jfs_umount` setting sbi
  fields to NULL
- [Phase 5] Verified `lmLogSync` is normally called under LOG_LOCK (from
  `lmLog()` line 321, `jfs_syncpt` line 1039)
- [Phase 5] Verified `jfs_flush_journal` calls `write_special_inodes`
  WITHOUT LOG_LOCK (lines 1572/1581), but fix in umount still protects
  the window
- [Phase 6] No changes to affected code in stable trees since 6.1; patch
  should apply cleanly
- [Phase 6] Syzbot confirms active crashing on 5.15, 6.1, 6.6 stable
  trees (0/N patched)
- [Phase 8] Failure mode: kernel oops (null-ptr-deref), severity
  CRITICAL
- [Phase 8] Risk: very low (24 lines, uses existing LOG_LOCK, adds NULL
  checks)

**YES**

 fs/jfs/jfs_logmgr.c | 16 +++++++---------
 fs/jfs/jfs_logmgr.h |  7 +++++++
 fs/jfs/jfs_umount.c | 10 ++++++++++
 3 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index ada00d5bc2146..d8266220776e8 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -74,12 +74,6 @@ static struct lbuf *log_redrive_list;
 static DEFINE_SPINLOCK(log_redrive_lock);
 
 
-/*
- *	log read/write serialization (per log)
- */
-#define LOG_LOCK_INIT(log)	mutex_init(&(log)->loglock)
-#define LOG_LOCK(log)		mutex_lock(&((log)->loglock))
-#define LOG_UNLOCK(log)		mutex_unlock(&((log)->loglock))
 
 
 /*
@@ -204,9 +198,13 @@ static void write_special_inodes(struct jfs_log *log,
 	struct jfs_sb_info *sbi;
 
 	list_for_each_entry(sbi, &log->sb_list, log_list) {
-		writer(sbi->ipbmap->i_mapping);
-		writer(sbi->ipimap->i_mapping);
-		writer(sbi->direct_inode->i_mapping);
+		/* These pointers can be NULL before list_del during umount */
+		if (sbi->ipbmap)
+			writer(sbi->ipbmap->i_mapping);
+		if (sbi->ipimap)
+			writer(sbi->ipimap->i_mapping);
+		if (sbi->direct_inode)
+			writer(sbi->direct_inode->i_mapping);
 	}
 }
 
diff --git a/fs/jfs/jfs_logmgr.h b/fs/jfs/jfs_logmgr.h
index 8b8994e48cd08..09e0ef6aeccef 100644
--- a/fs/jfs/jfs_logmgr.h
+++ b/fs/jfs/jfs_logmgr.h
@@ -402,6 +402,13 @@ struct jfs_log {
 	int no_integrity;	/* 3: flag to disable journaling to disk */
 };
 
+/*
+ * log read/write serialization (per log)
+ */
+#define LOG_LOCK_INIT(log)	mutex_init(&(log)->loglock)
+#define LOG_LOCK(log)		mutex_lock(&((log)->loglock))
+#define LOG_UNLOCK(log)		mutex_unlock(&((log)->loglock))
+
 /*
  * Log flag
  */
diff --git a/fs/jfs/jfs_umount.c b/fs/jfs/jfs_umount.c
index 8ec43f53f6865..18569f1eaabdb 100644
--- a/fs/jfs/jfs_umount.c
+++ b/fs/jfs/jfs_umount.c
@@ -20,6 +20,7 @@
 #include "jfs_superblock.h"
 #include "jfs_dmap.h"
 #include "jfs_imap.h"
+#include "jfs_logmgr.h"
 #include "jfs_metapage.h"
 #include "jfs_debug.h"
 
@@ -57,6 +58,12 @@ int jfs_umount(struct super_block *sb)
 		 */
 		jfs_flush_journal(log, 2);
 
+	/*
+	 * Hold log lock so write_special_inodes (lmLogSync) cannot see
+	 * this sbi with a NULL inode pointer while iterating log->sb_list.
+	 */
+	if (log)
+		LOG_LOCK(log);
 	/*
 	 * close fileset inode allocation map (aka fileset inode)
 	 */
@@ -95,6 +102,9 @@ int jfs_umount(struct super_block *sb)
 	 */
 	filemap_write_and_wait(sbi->direct_inode->i_mapping);
 
+	if (log)
+		LOG_UNLOCK(log);
+
 	/*
 	 * ensure all file system file pages are propagated to their
 	 * home blocks on disk (and their in-memory buffer pages are
-- 
2.53.0

