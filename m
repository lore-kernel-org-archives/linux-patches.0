Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E8B5A082D;
	Mon, 19 Oct 2026 13:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418374; cv=none; b=jTuOWL4R20ZE8acZnqnWWgjX2FmNVgDITk7NQRcELZdrV+DLYe2H16gaoLEOYmp1031Fg94Of+qZkJLi5onWPJ6cFxXNqgXFg6hwHNtZ/ZyW+TmVpcEJBZt9rrp9dYEnWW6t7Owa9FObPe9FiAAY6pEp7tY3AmGzWyM0RJELlW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418374; c=relaxed/simple;
	bh=T3zLdA9bCbKodBGblZE0QTW2oGErBGum4uQN2UgSQH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rd8sU55erQcnTX/UWMsCqkB/qsqIT0Ph0fni8dBNFrMV73yPt+tym4+FOurJ3fBTWCTpPZdIuo4wuOga5Wh5KrdazUCJ5GfXUzBm8OpGLtKxusfivqc92+DQl2ZywyBgyZdQBHfxASahvH3kthjIoe7au0H1vJreN889j1sr4bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QMytVi/b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QMytVi/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25CA1F000CA;
	Mon, 19 Oct 2026 13:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418371;
	bh=BKJyvaJualIFrkcTwoJTDGl29AXmYioDQwVF/x+kK+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QMytVi/bsMdAvKUUbQfpVCPIoTa4PUdoSiI4GXu9vQ/r3k1imvRX3ppQKqqrnIomc
	 2Y3LrEbMoUrZeAw65bGxvrb05gy1itUqZD84aALNG7VpZzaZBIrSBLQyDIiiErU8rz
	 3L6ycPN3VSmJ4CO2SiamznoAfWrsdmMrna/HfGv67+127wyDfgoiCR6nVBVdBlCwxG
	 XZ25wZfcIqTCc7s21NauG5MaSlHtS4FWfi+V2EHNmK7TD0FpKlaLI/wk5PsaHjBuub
	 1LWCe6mkw7jhEw13fvJsVLKvcEJO4XDGdVk+JNcd8ul/E8DGpGbwScBbcwXpQVZZyW
	 VtZY2LxT/H8gQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zizhi Wo <wozizhi@huawei.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	hirofumi@mail.parknet.co.jp,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] fat: reject name longer than NAME_MAX in msdos_format_name()
Date: Mon, 19 Oct 2026 09:48:12 -0400
Message-ID: <20261019135441.1420968-201-sashal@kernel.org>
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

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit 9d7ed813ee5ff0d469bd99630828ed6fdef4e8da ]

msdos_format_name() performs no upper-bound check on the input name length.
It silently truncates an arbitrarily long name into the 8.3 form (11 bytes)
and returns success. The subsequent fat_scan() then matches only against
these 11 truncated bytes, so it returns an inode as long as any entry with
the same 8.3 name exists on disk.

For example, passing a 300-byte name of all 'A's returns 0 with res set to
"AAAAAAAA" (8 'A's + 3 padding spaces), reporting success for a name far
longer than NAME_MAX.

As a result, when a user calls open() on a path component longer than
NAME_MAX (255) bytes, the VFS only enforces PATH_MAX, not the length of an
individual component. The dentry keeps the original long name but gets an
inode attached and becomes positive. Later in vfs_open() -> fsnotify_open()
-> fanotify_info_copy_name() triggers WARN_ON_ONCE(), and the event is
reported to userspace with an empty name.

vfat is not affected, as create goes through xlate_to_uni() which refuses
names longer than FAT_LFN_LEN.

Fix this by checking 'len > NAME_MAX' at the entry of msdos_format_name(),
the single entry point for all msdos name handling, aligning with the
NAME_MAX check that xfs/9p/ceph/simple_lookup() perform at lookup.

Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Link: https://patch.msgid.link/20260629130943.3671939-1-wozizhi@huaweicloud.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.53**. The buggy `msdos_format_name()` path is
present here and the three-line `NAME_MAX` check is a self-contained
correctness fix for that code.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[fat]** **[reject]** Reject names longer than `NAME_MAX` in
`msdos_format_name()`. Subsystem is the MS-DOS FAT namei path. Verb
“reject” is a correctness/validation fix, not a feature add.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Fixes:** none (expected for this review)
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** none on the commit; mailing-list thread shows Brauner
  applied it
- **Acked-by:** none
- **Link:** https://patch.msgid.link/20260629130943.3671939-1-
  wozizhi@huaweicloud.com
- **Cc: stable:** none (expected)
- **Signed-off-by:** Zizhi Wo \<wozizhi@huawei.com\>; Christian Brauner
  (Amutable) \<brauner@kernel.org\>
- Pipeline `Signed-off-by: Sasha Levin` and `[Upstream commit
  9d7ed813ee5ff0d469bd99630828ed6fdef4e8da]` ignored as candidate-prep
  markers
- Notable: VFS maintainer SOB; FAT maintainer Hirofumi was on the
  original To: list

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `msdos_format_name()` has no upper bound on `len`. It
  truncates an arbitrary name to 8.3 (11 bytes) and returns 0.
  `fat_scan()` then matches those 11 bytes, so a 300-byte `"AAA..."`
  lookup can attach the inode for `"AAAAAAAA"`.
- **Symptom:** `open()` of a component longer than `NAME_MAX` (255)
  succeeds because VFS only enforces `PATH_MAX` per path, not per
  component. The dentry keeps the long name, becomes positive, then
  `vfs_open()` → `fsnotify_open()` → `fanotify_info_copy_name()` hits
  `WARN_ON_ONCE()` and reports an empty name to userspace.
- **Version info:** none stated; code is ancient.
- **Root cause (author):** missing length check at the single MS-DOS
  name-formatting entry point. VFAT create is already guarded by
  `xlate_to_uni()` vs `FAT_LFN_LEN`.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. It is an explicit validation fix for
silent truncation, a kernel `WARN_ON_ONCE`, and a broken fanotify event.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- **File:** `fs/fat/namei_msdos.c` (+3 / −0)
- **Function:** `msdos_format_name()`
- **Scope:** single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record: Before, any length was accepted and folded into 8.3. After, `len
> NAME_MAX` returns `-ENAMETOOLONG` before truncation. Callers:
- `msdos_create` / `msdos_mkdir` / rename: surface `-ENAMETOOLONG`
- `msdos_find` (lookup/unlink/rmdir): still maps any format error to
  `-ENOENT` (pre-existing), so lookup of a too-long name fails instead
  of matching a truncated 8.3 entry
- `msdos_hash` / `msdos_cmp`: fall back to the existing invalid-name
  path

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Logic / correctness** plus **memory-safety defensive path**.
Missing bounds check let names longer than `NAME_MAX` become positive
dentries. `fanotify_info.name_len` is a `u8` (`BUILD_BUG_ON(NAME_MAX >
U8_MAX)`), so fanotify refuses `name->len > NAME_MAX` with
`WARN_ON_ONCE` and copies nothing.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct and minimal. Regression risk is very low: only
names longer than 255 bytes change behavior, and those are not valid
Unix names. No locking, no API, no data-structure change. Slight
incompleteness: lookup still reports `-ENOENT` rather than
`-ENAMETOOLONG` because `msdos_find()` swallows format errors; that
still stops the WARN and the wrong-inode match.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: On `v6.18.53`, `msdos_format_name()` starts at **1da177e4c3f41**
(Linux-2.6.12-rc2, 2005). No `NAME_MAX` check. The bug is old, not new-
in-6.19+.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Not applicable.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Recent `fs/fat/namei_msdos.c` history on this series is
unrelated (`fat: avoid parent link count underflow in rmdir`, mount-
API/idmap ports). No “patch X/Y” series. Standalone.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: No other `fs/fat/` commits by Zizhi Wo on `master`. Huawei
contributor; the VFS maintainer applied the patch.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Diff uses existing `NAME_MAX` and `-ENAMETOOLONG`. No new
helpers. Applies standalone. `git diff v6.18.53 04dcdda681446 --
fs/fat/namei_msdos.c` is exactly this 3-line hunk.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- Lore/msgid: https://patch.msgid.link/20260629130943.3671939-1-
  wozizhi@huaweicloud.com
- `b4 dig -a`: **v1 only**
- Thread: submission + Brauner “Applied to vfs-7.3.fat”. No NAKs, no
  requested revisions, no reviewer `Cc: stable` in the saved mbox.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc included Hirofumi (FAT maintainer), Brauner,
linux-fsdevel, linux-kernel, yangerkun@huawei.com,
chengzhihao1@huawei.com. Brauner applied it the next day.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla link. Author describes a concrete `open()` +
fanotify path. Openwall mirror matches the commit text; no extra
reports.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Single-patch series `[1/1]`. No follow-up on `fs/fat/` changing
this check.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: No relevant stable-list discussion found (search did not surface
this subject). No known reason to exclude it.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `msdos_format_name()` only.

**Step 5.2: TRACE CALLERS**
Record (all in `fs/fat/namei_msdos.c`):
- `msdos_find()` ← `msdos_lookup`, `msdos_rmdir`, unlink
- `msdos_hash()`, `msdos_cmp()` (dcache)
- `msdos_create()`, `msdos_mkdir()`, rename

Call context: VFS lookup/create from syscalls (`open`, `stat`, `mkdir`,
…), not IRQ.

**Step 5.3: TRACE CALLEES**
Record: After the check, same 8.3 formatting and `strchr()` validation.
Success path still feeds `fat_scan()`, which `strncmp()`s 11-byte names.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace `open()` → VFS lookup → `msdos_lookup()` →
`msdos_find()` → `msdos_format_name()`. If format “succeeds” on a
truncated name, `fat_build_inode()` + `d_splice_alias()` make a positive
dentry; `vfs_open()` → `fsnotify_open()` can call
`fanotify_info_copy_name()`. **Reachable from userspace** on
`CONFIG_MSDOS_FS`. VFAT lookup uses `vfat_find()` → `fat_search_long()`
/ `xlate_to_uni()`, not this function.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same `len > NAME_MAX` → `-ENAMETOOLONG` exists in
`simple_lookup()`, 9p (`v9fs_vfs_lookup`), ceph, autofs, configfs.
Commit’s “xfs does this at lookup” is **not** visible as `d_name.len >
NAME_MAX` under `fs/xfs/` in this tree (minor message inaccuracy). VFAT
`xlate_to_uni()` already returns `-ENAMETOOLONG` when Unicode length >
`FAT_LFN_LEN` (255).

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** `git describe HEAD` = `v6.18.53-5049-g0f0bdc2b0dffb`,
`VERSION=6 PATCHLEVEL=18 SUBLEVEL=53`. At **v6.18.53**,
`msdos_format_name()` has no `NAME_MAX` check. `git merge-base --is-
ancestor 04dcdda681446 v6.18.53` is **NO**. Bug introduced at 2.6.12-era
git genesis, still present on this 6.18.y base.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply.** Surrounding code at v6.18.53 matches the hunk
context. No intervening refactor of this function.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No other `NAME_MAX` / `msdos_format_name` fix on this file in
6.18.53. `fat: Fix statfs->f_namelen` is unrelated.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **fs/fat (MS-DOS namei)**. Criticality **IMPORTANT** for
`CONFIG_MSDOS_FS` users (USB/floppy/legacy FAT without long names), not
core VFS. Not staging.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature; this function has been stable for decades. Low churn
around the format loop. Typical “old bug, small late fix.”

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Filesystem/config-specific:** `CONFIG_MSDOS_FS` mounts (`mount
-t msdos`). Not the common VFAT long-name driver. Still a real
production config (Kconfig even says “If unsure, answer Y”).

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Unprivileged user with access to an msdos mount calls
`open()`/`stat()`/etc. with a component length 256..PATH_MAX, and a
directory entry whose 8.3 name matches the truncated form. Fanotify
`WARN` additionally needs a fanotify mark that reports names (typically
privileged watcher). Trigger is uncommon but fully reachable; not a
theoretical race.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record:
- Kernel `WARN_ON_ONCE` (stack dump; panic if `panic_on_warn`) —
  **HIGH**
- fanotify userspace event with empty name (breaks monitors/security
  policy) — **MEDIUM-HIGH**
- Lookup/open of the wrong 8.3 file via an illegal Unix name —
  **MEDIUM**
Overall: **HIGH** (userspace-triggerable WARN + wrong-file match), not a
default panic.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record: **Benefit high** relative to scope (stops WARN, empty fanotify
names, illegal-name aliasing). **Risk very low** (3 lines, error return
only). Ratio strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real bug: names > `NAME_MAX` truncated to 8.3 and treated as success
- Userspace-triggerable `WARN_ON_ONCE` in fanotify; empty name delivered
  to watchers
- `fanotify_info.name_len` is `u8`; the WARN is a hard length invariant
- Three-line check at the single MS-DOS format entry point
- Present in this 6.18.53 tree since 2.6.12-era code
- Applies cleanly; no prerequisites; no new API
- Applied by VFS maintainer; FAT maintainer was CC’d; v1 accepted as-is

AGAINST:
- Only `CONFIG_MSDOS_FS`, not VFAT
- No syzbot/`Reported-by`/explicit `Cc: stable`
- Lookup still maps the error to `-ENOENT` via `msdos_find()`
- Default severity is WARN + wrong lookup, not oops

UNRESOLVED:
- Direct lore.kernel.org HTTP fetch returned 403; thread recovered via
  `b4 dig -m`
- xfs lookup `NAME_MAX` check cited in the message is not in `fs/xfs/`
  here
- No stable-list thread found

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — two-line check, Brauner
   applied v1
2. Fixes a real bug that affects users? **PASS** — wrong inode +
   fanotify WARN/empty name
3. Important issue? **PASS** — userspace-triggerable `WARN_ON_ONCE`;
   wrong-file match
4. Small and contained? **PASS** — +3 lines, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — clean on 6.18.53
   `namei_msdos.c`

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None (not a device ID/quirk/DT/build/docs exception). Qualifies
as a normal small bugfix.

**Step 9.4: MAKE YOUR DECISION**
This belongs on this 6.18.y tree. The buggy formatter is here, the
fanotify WARN path is here, and the fix is a three-line `-ENAMETOOLONG`
guard with negligible regression risk.

------------------------------------------------
What the commit solves for stable users
------------------------------------------------
On msdos mounts, VFS allows a path **component** up to nearly `PATH_MAX`
(4096). The MS-DOS formatter then silently compresses that to 8.3 and
can bind a long name to an existing short-name inode. Opening that
dentry trips `fanotify_info_copy_name()`’s `WARN_ON_ONCE(name->len >
NAME_MAX)` and reports an empty name. The patch rejects `len > NAME_MAX`
at the only MS-DOS format entry point, matching
9p/ceph/`simple_lookup()`.

------------------------------------------------
Verification
------------------------------------------------
- [Phase 1] Parsed subject/tags/body from `git log -1 04dcdda681446`;
  ignored pipeline SOB/Upstream markers
- [Phase 2] Diff is +3 lines in `msdos_format_name()`; callers grepped
  in `fs/fat/namei_msdos.c`
- [Phase 2] Confirmed `fat_scan()` matches 11-byte `MSDOS_NAME`;
  `fanotify_info.name_len` is `u8`
- [Phase 3] `git blame v6.18.53 -L 19,45 -- fs/fat/namei_msdos.c` →
  1da177e4c3f41 (2.6.12-rc2)
- [Phase 3] No `Fixes:` tag; no series; `git log master --author='Zizhi
  Wo' -- fs/fat/` empty
- [Phase 3] `git diff v6.18.53 04dcdda681446 -- fs/fat/namei_msdos.c` is
  only this hunk
- [Phase 4] `b4 dig -c 9d7ed813ee5ff0d469bd99630828ed6fdef4e8da` → msgid
  20260629130943.3671939-1
- [Phase 4] `b4 dig -a`: v1 only; `-w`: Hirofumi + Brauner + linux-
  fsdevel; `-m`: Brauner applied to vfs-7.3.fat, no NAK
- [Phase 4] Openwall archive matches; lore HTTP 403; no stable-list hit
  for this subject
- [Phase 5] Call chain: `msdos_lookup` → `msdos_find` →
  `msdos_format_name`; VFAT uses `xlate_to_uni`/`vfat_find`
- [Phase 5] `simple_lookup`/9p/ceph have `NAME_MAX` checks; xfs claim
  unverified in this tree
- [Phase 6] `git describe HEAD` = v6.18.53-5049; `make kernelversion` =
  6.18.53
- [Phase 6] `v6.18.53:fs/fat/namei_msdos.c` lacks the check; ancestor
  test vs v6.18.53 = NO
- [Phase 6] fanotify WARN present in
  `v6.18.53:fs/notify/fanotify/fanotify.h`
- [Phase 8] Failure mode: `WARN_ON_ONCE` + empty fanotify name +
  truncated 8.3 match; severity HIGH
- UNVERIFIED: xfs lookup NAME_MAX check as stated in the commit message
- UNVERIFIED: live reproduction of the fanotify WARN (code path
  verified, not executed)

The fix is small, surgical, present-bug in this tree, and meets stable
criteria.

**YES**

 fs/fat/namei_msdos.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index 262ec1b790b56..c03610d0e7247 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -29,6 +29,9 @@ static int msdos_format_name(const unsigned char *name, int len,
 	unsigned char c;
 	int space;
 
+	if (len > NAME_MAX)
+		return -ENAMETOOLONG;
+
 	if (name[0] == '.') {	/* dotfile because . and .. already done */
 		if (opts->dotsOK) {
 			/* Get rid of dot - test for it elsewhere */
-- 
2.53.0

