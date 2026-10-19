Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB2E646982;
	Mon, 19 Oct 2026 14:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418792; cv=none; b=s+/Nzo9pyMlxpp8PJZ8rM+9YrR+nwDPn1mnkV/y1g9yfP9bkS/QhVFPAYIt9E+fsLhDE8/t2Cyg6rInCAuzZVVhxJYLP9ZoIV6VE3LicQ/yydk3sVxf25I6yZzq/4KQIndS4k8p3nvQBhXNWQsJxDVkhYxcJLUIYFfyrUXQITtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418792; c=relaxed/simple;
	bh=b970QSfivtWhXrCHnwzJxaqW6ZddRWQZLiIE8vwH3Ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gUt1NaXtULie3h5q2IGpsJNMCwhueG2+c5bPxsBmnqyjlVdAPJMZ6/pD96p+o9XLHKfHXpPzLuYRwhji5vfzDywuzqx/ERg8M3r9ZbkAgZB6G+GdPPC+OvZENnAe+w7uMWfg0AUDIrKcMjy+SK2k4WZ/e2YQceEZVKopxcITKZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kjOEgefw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kjOEgefw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031161F000C5;
	Mon, 19 Oct 2026 14:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418789;
	bh=hOQDEz33xStZKw/+9YXAnJNUn5iUFyNgLBgNBn1kxMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kjOEgefwtRTl8ILkOEMAOI8kWJzovXDpvC965hB1Kcn1+3RyfdSF8kc/b3hp3XthF
	 yfbQCb2Vm9KGc/cJpHvrUvHNquQo4VMDRP0sjYiI8Jx7cWDa8cEAsO/aWaTcgaVc+y
	 fhicJYKn5ozuGWPJv9TOCoA9P7PeVcetxqNfzFK2RdaQWSuBnkOj8FYDLI/90w8unM
	 dcRcq8h2UBdID4Db+vcqDdwGxUjgZvxx66yoYgG5WMzIEkfBiYiXz9ewpCtaijTRyT
	 A2Jfn/a9eOfOQwVGiZhOzPpn8R1j07nsaS2PQydsGK18GiOmS09e5j/WuMSDQRqF4l
	 LonZXj1x47HCA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yun Zhou <yun.zhou@windriver.com>,
	syzbot+72fe3ea5814121fbc76e@syzkaller.appspotmail.com,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	axboe@kernel.dk,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] block: reject block device inodes with i_rdev == 0 in lookup_bdev()
Date: Mon, 19 Oct 2026 09:53:09 -0400
Message-ID: <20261019135441.1420968-498-sashal@kernel.org>
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

From: Yun Zhou <yun.zhou@windriver.com>

[ Upstream commit 83887ad02f30c1814bed5da3ca999f7b0f3f337c ]

lookup_bdev() blindly returns inode->i_rdev without validating it.
When a FUSE filesystem exposes a root inode with S_IFBLK mode but
i_rdev == 0 (via rootmode=060000), any subsequent mount attempt using
that path as a block device source propagates dev_t 0 into the
superblock machinery.  After commit 9ee5f161a4db ("fs: maintain a
global device-to-superblock table") this triggers a WARNING in
super_dev_register().

Reject i_rdev == 0 early with -ENODEV since no real block device
driver registers major 0.

Reported-by: syzbot+72fe3ea5814121fbc76e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=72fe3ea5814121fbc76e
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Link: https://patch.msgid.link/20260703065548.1135125-1-yun.zhou@windriver.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable backport analysis: `83887ad02f30c`

Local tree: **v7.3-rc4** (`7.3.0-rc4`, HEAD `f0100363d8c37`). Both the
device-to-superblock table (`9ee5f161a4db`) and this lookup check landed
in the `vfs-7.3-rc1.super` pull. Verdict is for this checkout only.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[block] [reject] reject block device inodes with `i_rdev == 0`
in `lookup_bdev()`**

Subsystem `block:`. Verb `reject` is a defensive check, not a feature.
Intent: stop `lookup_bdev()` from returning `dev_t` 0.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Reported-by:**
  `syzbot+72fe3ea5814121fbc76e@syzkaller.appspotmail.com` (fuzzer, C
  repro)
- **Closes:**
  https://syzkaller.appspot.com/bug?extid=72fe3ea5814121fbc76e
- **Link:** https://patch.msgid.link/20260703065548.1135125-1-
  yun.zhou@windriver.com
- **Signed-off-by:** Yun Zhou (author); Christian Brauner (VFS
  maintainer; applied)
- **Fixes:** none (expected for this review)
- **Cc: stable:** none (expected)
- **Tested-by / Reviewed-by / Acked-by:** none on the commit

Sasha Levin SOB is ignored per pipeline rules.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `lookup_bdev()` copies `inode->i_rdev` with no check. FUSE
  `rootmode=060000` (`S_IFBLK`) can present a block inode with `i_rdev
  == 0`. A later mount that uses that path as a block-device source
  feeds `dev_t` 0 into superblock setup.
- **Symptom:** `WARNING in super_dev_register()` after `9ee5f161a4db`
  (`VFS_WARN_ON_ONCE(!sb->s_dev)`).
- **Root cause:** major 0 is not a real block major (`get_anon_bdev()`
  allocates `MKDEV(0, n)` with `n >= 1`). Fake inodes can still expose
  0.
- **Version info:** warning is tied to `9ee5f161a4db` (2026-06-29). That
  commit **is** an ancestor of this HEAD.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Not disguised.** It is an explicit validation fix. Not cleanup
or API work.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- **File:** `block/bdev.c` only (`+12` comment + check, `−0`)
- **Function:** `lookup_bdev()`
- **Scope:** single-file surgical check on an existing error path (`goto
  out_path_put`)

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record: **Before:** after `S_ISBLK` and `may_open_dev()`, always `*dev =
inode->i_rdev`. **After:** if `i_rdev == 0`, return `-ENODEV` and drop
the path. Success path unchanged for real devices.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **Logic / correctness** (invalid `dev_t`), plus **debug
assertion** (`WARN_ON_ONCE` under `CONFIG_DEBUG_VFS`). Mechanism: stop
`dev_t` 0 from reaching `sget_dev()` → `set_bdev_super()` →
`super_dev_register()`.

**Step 2.4: ASSESS THE FIX QUALITY**

Record: **Obviously correct and minimal.** Real block drivers do not
register major 0; `get_anon_bdev()` starts minors at 1 for that reason.
Regression risk is **low**: only rejects `i_rdev == 0`. No new API, no
lock changes. Possible behavior change: callers that used to get `dev_t`
0 now get `-ENODEV` instead of failing later in `blkdev_get_no_open()`
(`-ENXIO`). That is a better error for “no such device.”

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record: Unchecked `*dev = inode->i_rdev` comes from `4e7b5671c6a883`
(“block: remove i_bdev”, 2020-12-01), on top of `lookup_bdev()` back to
`1da177e4c3f41`. The **warning** is new with `9ee5f161a4db`
(2026-06-29). The new check is `83887ad02f30c` itself.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: **No Fixes: tag.** The message names `9ee5f161a4db`. `git merge-
base --is-ancestor 9ee5f161a4db HEAD` succeeded. That commit is in this
tree. `git describe --contains`: both `9ee5f161a4db` and `83887ad02f30c`
are in **v7.3-rc1**.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record: Recent `block/bdev.c` work is unrelated (`bdev_yield_claim`,
unfreezable bdev, etc.). Standalone one-patch series, not `N/M`.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Yun Zhou also has filesystem fixes (ext4/xfs/jfs) in this
history; not the block maintainer. Applied by **Christian Brauner**, VFS
maintainer.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: The check is self-contained in `lookup_bdev()`. The **warning**
needs `super_dev_register()`, which this tree has. No extra helper or
struct change required. **Can apply standalone** on this tree’s
`lookup_bdev()`.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c 83887ad02f30c` → https://patch.msgid.link/20260703065548.11
  35125-1-yun.zhou@windriver.com
- `b4 dig -a`: **v1 only**, 2026-07-03
- Mbox is the patch only; **no review replies** in the saved thread
- Openwall mirror matches; no NAK
- Applied the same day (commit date 2026-07-03 15:12 +0200)
- **No Cc: stable** in the submission

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): To Jens Axboe and Christian Brauner; Cc linux-
block, linux-kernel. Brauner applied it. No extra Reviewed-by.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record (syzkaller):
- Title: `WARNING in super_dev_register`
- Label: **prio:normal**; subsystem fuse
- C repro; first crash 2026-07-02 on linux-next
- Stack: `mount` → `fuse_get_tree` → `get_tree_bdev_flags` → `sget_dev`
  → `super_dev_register`
- Warning text: `!sb->s_dev` at `super_dev_register`
- Syzbot CI: **Unprivileged: ❌**; DenialOfService/Exploitable marked,
  but not an unprivileged trigger
- Status: fix listed as `83887ad02f30`

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Single patch. Syzbot CI series passed KASAN build/boot/fuzz. No
follow-up fix on `lookup_bdev()` `i_rdev` in this tree.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org WebFetch returned **403**. Web search of
`site:lore.kernel.org/stable` did not find a discussion of this patch.
**UNVERIFIED:** no confirmed stable-list thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**

Record: **`lookup_bdev()`** only.

**Step 5.2: TRACE CALLERS**

Record (this tree): `get_tree_bdev_flags()` in `fs/super.c` (mount path
that warned); `bdev_file_open_by_path()`; hibernate; quota; nilfs2;
btrfs; MTD; dm-table; bcache. **~26** call sites. Important path:
**`get_tree_bdev_flags()`** from filesystem `get_tree` (including
fuseblk).

**Step 5.3: TRACE CALLEES**

Record: `kern_path()`, `d_backing_inode()`, `S_ISBLK()`,
`may_open_dev()`, `path_put()`. No alloc/lock added.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Userspace `mount()` with a FUSE `rootmode=S_IFBLK` path as
fuseblk/block source. **Reachable from the mount syscall**, typically
with mount privilege. Confirmed by syzbot C repro. Not a hot I/O path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: No other `i_rdev == 0` reject in block core.
`early_lookup_bdev()` is name/PARTUUID parsing at boot, not inode-based;
different bug. `bdev_statx()` uses `i_rdev` via `blkdev_get_no_open()`,
which already fails closed on missing devices.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.**
- `lookup_bdev()` is in `block/bdev.c`
- `super_dev_register()` in `fs/super.c` has
  `VFS_WARN_ON_ONCE(!sb->s_dev)`
- `get_tree_bdev_flags()` still does `lookup_bdev(fc->source, &dev)`
  then `sget_dev(fc, dev)`
- Bug introduced for this warning: **`9ee5f161a4db`**, first in
  **v7.3-rc1**, present here

Current `lookup_bdev()` already contains this check because
`83887ad02f30c` is an ancestor of HEAD (same 7.3-rc1 vfs pull). That is
git history of this series, not a pipeline “already selected” marker.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply** on this tree’s `lookup_bdev()`. Surrounding code
matches the hunk. No backport rewrite needed.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: This is the fix in this lineage. No alternate `i_rdev` check
elsewhere.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **block / VFS mount** (`block/bdev.c`, used by `fs/super.c`).
**CORE** for block-backed mounts.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Active in 7.3 (device-to-superblock table is new this cycle).
The check is a same-cycle guard for that table.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: Anyone mounting a block-backed fs using a path that is a fake
`S_IFBLK` inode with `i_rdev == 0` (FUSE `rootmode=S_IFBLK` is the known
trigger). Not universal hardware. **Config-specific extra:**
`CONFIG_DEBUG_VFS` (default **n**, `DEBUG_KERNEL`) is required for the
**runtime WARNING**. Without it, `VFS_WARN_ON_ONCE` is
`BUILD_BUG_ON_INVALID` (no runtime warn).

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: FUSE mount with `rootmode=060000`, then mount that path as a
block device (fuseblk / `get_tree_bdev`). **Unprivileged: no** (syzbot).
Not every boot; needs a crafted mount. Reproducible (C repro).

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record:
- **With `CONFIG_DEBUG_VFS`:** `WARN_ON_ONCE(!sb->s_dev)` — **MEDIUM**
  (WARN; panic if `panic_on_warn`)
- **Without it:** `s_dev = 0` is still registered in the global table,
  then `setup_bdev_super()` → `bdev_file_open_by_dev(0)` →
  `blkdev_get_no_open(0)` fails (`NULL` → `-ENXIO`). Mount fails.
  **LOW–MEDIUM** correctness (invalid table key; mount still fails)

Not UAF, not filesystem corruption, not an unprivileged crash.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** Stops `dev_t` 0 from entering `sget_dev` /
  `super_dev_register` on this 7.3 line, which has the new table.
  Matches a syzbot C repro.
- **Risk:** Very low (~12 lines, error-path only).
- **Ratio:** Favorable **on this tree**, because `9ee5f161a4db` is
  present.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**For backporting to this tree:**
- Introducing commit `9ee5f161a4db` **is in this tree** (v7.3-rc1)
- Syzbot C repro of `WARNING in super_dev_register`
- Small, obviously correct `-ENODEV` check
- Applied by VFS maintainer; syzbot CI passed
- Call path is real: `get_tree_bdev_flags()`
- Also avoids publishing `s_dev == 0` in the device-to-superblock table

**Against:**
- Runtime WARN is **`CONFIG_DEBUG_VFS` only** (default n)
- Trigger is a privileged, crafted FUSE/fuseblk mount, not normal disks
- syzbot **prio:normal**; not unprivileged
- Production mount already fails later with `-ENXIO`
- No Fixes/Cc-stable (not a negative by itself)

**Unresolved:**
- lore.kernel.org 403; no stable-list thread found (UNVERIFIED)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — syzbot repro + CI; logic is
   sound
2. Fixes a real bug that affects users? **PASS** — warning and invalid
   `dev_t` 0 on this 7.3 VFS
3. Important issue? **PASS** (borderline) — WARN_ON / table invariant;
   not UAF/corruption; still a real VFS assertion this tree has
4. Small and contained? **PASS** — one function, +12 lines
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — `lookup_bdev()` and
   `super_dev_register()` match

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: **None** (not a device ID, quirk, DT, build, or docs patch).
Qualifies as a small correctness fix, not an exception class.

**Step 9.4: MAKE YOUR DECISION**

On **this** v7.3-rc4 tree the warning path exists: `9ee5f161a4db` is
here, `lookup_bdev()` can still feed 0 into `sget_dev()`, and syzbot has
a C repro. The patch is a 12-line `-ENODEV` check with negligible
regression risk. That meets stable rules for this checkout. It would not
be appropriate on a tree that lacks `super_dev_register()`; that is not
this tree.

---

### What the commit solves, and why it matters here

Without the check, a FUSE inode with `S_IFBLK` and `i_rdev == 0` makes
`lookup_bdev()` return 0. `get_tree_bdev_flags()` then calls
`sget_dev(fc, 0)`, and `super_dev_register()` hits
`VFS_WARN_ON_ONCE(!sb->s_dev)` when `CONFIG_DEBUG_VFS=y`. This tree has
that table and that warning. Rejecting `i_rdev == 0` with `-ENODEV`
stops the bad `dev_t` at the lookup.

### Risk vs benefit

Benefit is silencing a reachable WARN and keeping `dev_t` 0 out of the
superblock device table on 7.3. Risk is a slightly earlier `-ENODEV`
instead of a later `-ENXIO` for a path that was never a real block
device.

### Concerns

Depends on `9ee5f161a4db` for the warning; that dependency **is
satisfied here**. No extra backport patches. lore.kernel.org could not
be fetched (403); discussion was recovered via `b4 dig` and an openwall
mirror.

---

### Verification

- **[Phase 1]** Parsed tags: syzbot Reported-by, Closes syzkaller URL,
  msgid Link, Brauner SOB; no Fixes
- **[Phase 2]** Diff: +12 in `lookup_bdev()` in `block/bdev.c`;
  `-ENODEV` if `!inode->i_rdev`
- **[Phase 3]** `git describe HEAD` → `v7.3-rc4-27-gf0100363d8c37`;
  `make kernelversion` → `7.3.0-rc4`
- **[Phase 3]** `git merge-base --is-ancestor 9ee5f161a4db HEAD` → yes
- **[Phase 3]** `git merge-base --is-ancestor 83887ad02f30c HEAD` → yes
  (in v7.3-rc1 vfs-super pull)
- **[Phase 3]** `git blame -L 1259,1297 block/bdev.c`: unchecked assign
  from `4e7b5671c6a883`; check from `83887ad02f30c`
- **[Phase 3]** `git describe --contains 9ee5f161a4db` / `83887ad02f30c`
  → both v7.3-rc1
- **[Phase 4]** `b4 dig -c 83887ad02f30c` →
  patch.msgid.link/20260703065548.1135125-1-yun.zhou@windriver.com
- **[Phase 4]** `b4 dig -a`: v1 only; `-w`: axboe + brauner + linux-
  block
- **[Phase 4]** `b4 dig -m`: mbox is the patch only; no NAK
- **[Phase 4]** WebFetch syzkaller bug: WARNING, prio:normal, C repro,
  Unprivileged ❌
- **[Phase 4]** lore.kernel.org WebFetch: **403**; stable-list hit:
  **UNVERIFIED**
- **[Phase 5]** Callers: `get_tree_bdev_flags`,
  `bdev_file_open_by_path`, btrfs/nilfs2/dm/quota/hibernate/mtd/bcache
- **[Phase 5]** `include/linux/vfsdebug.h`: `VFS_WARN_ON_ONCE` is
  runtime only if `CONFIG_DEBUG_VFS`
- **[Phase 5]** `lib/Kconfig.debug`: `DEBUG_VFS` default n, “If unsure,
  say N”
- **[Phase 6]** Read `lookup_bdev()` and `super_dev_register()` in this
  tree; warning and mount path present
- **[Phase 8]** Failure: WARN under DEBUG_VFS; otherwise failed open of
  bdev 0 (`blkdev_get_no_open`)
- **UNVERIFIED:** full lore review thread beyond the v1 patch mbox;
  stable@ discussion

The fix is small, matches a syzbot warning this 7.3 tree can hit, and
applies cleanly.

**YES**

 block/bdev.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/block/bdev.c b/block/bdev.c
index 02d7503e7c2c4..00345746e34f8 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -1209,6 +1209,18 @@ int lookup_bdev(const char *pathname, dev_t *dev)
 	if (!may_open_dev(&path))
 		goto out_path_put;
 
+	/*
+	 * Reject a block device inode with i_rdev == 0.  A dev_t of 0 is
+	 * never valid for a block device: no real block device driver
+	 * registers major 0.  Fake block device inodes (e.g. fuse with
+	 * rootmode=S_IFBLK) can expose i_rdev == 0, and letting that
+	 * propagate would confuse superblock lookup and trigger warnings
+	 * in the device-to-superblock table (super_dev_register).
+	 */
+	error = -ENODEV;
+	if (!inode->i_rdev)
+		goto out_path_put;
+
 	*dev = inode->i_rdev;
 	error = 0;
 out_path_put:
-- 
2.53.0

