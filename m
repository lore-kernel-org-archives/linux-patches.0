Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446C860708C;
	Mon, 19 Oct 2026 14:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418603; cv=none; b=X4PJLhZiUE6NRz/kshVSk/yxQF6n3t/WcHK/SllveR9h0aDM6B79IdrIDbOKhcIF7b2eOUZItdRKJPS/8GMfMPJgELA/UuQSCNJH8oWXekjguoSkMLJ7+sklKrLazz1q1pEarmH5wtgFCsrM88YByeu9ZIALNXNQ3CyeoRDmOOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418603; c=relaxed/simple;
	bh=mBR0t3Ccnpt0fmE/sNKAu/ReGBjCM6IUh3bpOBw98UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lw0Df3lpBzeU5uCxeFN7pgwkDc2T8KPc934wTCuDSp7Kwi5EPZOTntm09ZuB1w66G1O+KNP6lAMuHyhUBOf3BzkVa6dhXrH0fsTHkg7xH9MLibby7iLkkru3EWSkfdYGQeg2UxlklQ3r3xVWFbgUGETQ8wXw2bdOeiF3I7CzZJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D88nEK+U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D88nEK+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3C61F000C6;
	Mon, 19 Oct 2026 14:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418600;
	bh=obvmpAGnxQTItHw8kIywl9jV5Uy0bs2+R1HEZSL6mAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D88nEK+UAoUxZRQlWP3Gs0zmE42fx0tO/XFPon/gpDXXC2usHKnonE4T3VosVz3na
	 SiLbUrfm8YfR38b1PakA7QnANa3kuXSwqvOFelUN2YJIgna1BOBQjFTb/9EMkOJJCJ
	 EnZmE85An4DuHmJXcVw+bkyr/vwCKis889qvFIoU/zALGkMoNqqowVx4mZ3RXXbhAZ
	 lYO7XtYzXvmp9JjsoVskjrX20zLu4EIb21Age4Hz6zSFOhVGtn2JIBaD2RzdKUQSE+
	 b1MVAitqhEgIzxnZnaeMyO+AQNAcML1uMqJ1uftryj3GFIoYKJJdYwyAuPEm3F3AJg
	 /j1oKoerGnrHw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xiubo Li <xiubo.li@clyso.com>,
	Andras Pataki <apataki@flatironinstitute.org>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	amarkuze@redhat.com,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ceph: do not cache negative dentries for snapped directories
Date: Mon, 19 Oct 2026 09:50:54 -0400
Message-ID: <20261019135441.1420968-363-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Transfer-Encoding: 8bit

From: Xiubo Li <xiubo.li@clyso.com>

[ Upstream commit af59562a5b3d34fb3aa7753f2543393578d06dbf ]

When a LOOKUP/LOOKUPSNAP in a snapped directory returns ENOENT
without a trace, ceph_finish_lookup() creates a negative dentry
via d_add(dentry, NULL).  For live directories this is fine — the
dentry naturally expires.  But for snapped directories,
ceph_d_revalidate() unconditionally trusts all cached dentries
(valid = 1), so a negative dentry created by a transient error
persists forever, hiding entries that genuinely exist in the
snapshot.

Only cache negative dentries for live (non-snapshotted) parent
directories.  For snapped parents, skip the negative dentry so
that VFS retries the lookup on the next access.  Since the
conditions that trigger a negative dentry (MDS transient error,
local ENOENT shortcut, or MDS null dentry lease) are all rare in
snapped directories, the performance impact of this change is
negligible.

Link: https://tracker.ceph.com/issues/78529
Reported-by: Andras Pataki <apataki@flatironinstitute.org>
Signed-off-by: Xiubo Li <xiubo.li@clyso.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
- Record: `[ceph] [do not cache] negative dentries for snapped
  directories`
- Subsystem: CephFS kernel client (`fs/ceph/`)
- Action: “do not cache” is a prevent/avoid-style fix, not a feature

**Step 1.2: Tags**
- `Link: https://tracker.ceph.com/issues/78529` (production bug tracker)
- `Reported-by: Andras Pataki <apataki@flatironinstitute.org>` (real
  CephFS user)
- `Signed-off-by: Xiubo Li <xiubo.li@clyso.com>` (author; listed as Ceph
  FS client maintainer)
- `Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>`
- `Signed-off-by: Ilya Dryomov <idryomov@gmail.com>` (Ceph maintainer
  who merged it)
- No `Fixes:` tag (expected; the `d_add(..., NULL)` path dates to 2009)
- No `Cc: stable` (expected for this review pipeline)
- Original submission also had `Closes:
  https://tracker.ceph.com/issues/78529`; that was dropped at merge
- Ignore pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit ...]`
  if present

**Step 1.3: Body**
- Record: [Bug] LOOKUP/LOOKUPSNAP on a snapped directory can return
  `-ENOENT` with no trace. `ceph_finish_lookup()` then does
  `d_add(dentry, NULL)`, caching a negative dentry.
  `ceph_d_revalidate()` unconditionally trusts snapped dentries (`valid
  = 1`), so that negative entry never expires.
- [Symptom] Snapshot paths return `ENOENT` for files/dirs that exist.
  `readdir` on the parent restores them.
- [Version] Reporter hit it on kernel 6.18.32 with Ceph squid 19.2.3.
  Same client caching logic is in this 6.12 tree.
- [Root cause] Negative dentries in snapped dirs are sticky, so a
  transient MDS `ENOENT` hides real snapshot entries forever.

**Step 1.4: Hidden bug fix?**
- Record: Not hidden. Explicit correctness fix for stale negative
  dentries. Not cleanup/refactor.

---

## Phase 2: Diff analysis

**Step 2.1: Inventory**
- Record: `fs/ceph/dir.c` (+8/-2), `fs/ceph/inode.c` (+2/-1). Net
  +10/-3.
- Functions: `ceph_finish_lookup()`, `ceph_lookup()`,
  `ceph_fill_trace()`.
- Scope: single-subsystem surgical fix, three call sites that
  instantiate negative dentries.

**Step 2.2: Code flow**
1. `ceph_finish_lookup()`: on traceless `-ENOENT`, previously always
   `d_add(dentry, NULL)` for unhashed negatives. After: only if parent
   is missing or `ceph_snap(parent) == CEPH_NOSNAP`. Snapped parents
   skip `d_add`; VFS retries next access.
2. `ceph_lookup()` local ENOENT shortcut (`DCACHE` + complete dir +
   `FILE_SHARED`): add `ceph_snap(dir) == CEPH_NOSNAP` so snapped dirs
   never conclude ENOENT locally and cache it.
3. `ceph_fill_trace()` null-dentry + lease path: `d_add(dn, NULL)` only
   when parent is live (`CEPH_NOSNAP`).

**Step 2.3: Bug mechanism**
- Record: [Logic / dcache correctness]
- Mechanism: sticky negative dentry + “always trust snapped dentries” in
  `ceph_d_revalidate()` (this tree, `fs/ceph/dir.c` around the
  `ceph_snap(dir) != CEPH_NOSNAP` / `valid = 1` path). Fix: do not
  instantiate those negatives.

**Step 2.4: Fix quality**
- Record: Minimal and obviously correct. Live-dir behavior unchanged.
  Regression risk is extra MDS lookups for true ENOENT in snapshots
  (author: rare). No locking/API/data-structure changes. Skipping
  `d_add` leaves the lookup dentry unhashed; VFS `d_lookup_done()` +
  `dput()` frees it, so the next access looks up again.

---

## Phase 3: Git history

**Step 3.1: Blame**
- Record: Negative `d_add` in `ceph_finish_lookup()` from Sage Weil
  `2817b000b02c5f` (2009). Unconditional trust of snapped dentries also
  from that era (`valid = 1` in `bf1c6aca96c9d2`, 2011). Present for the
  life of this filesystem client, not new 6.13+ code.
- Local wrappers `if (d_unhashed(dentry))` come from `4179cc390dace`
  (`ceph: only d_add() negative dentries when they are unhashed`),
  already in this tree.

**Step 3.2: Fixes: tag**
- Record: None. Introducer is the original 2009 lookup path, which is in
  this tree.

**Step 3.3: File history**
- Record: Recent related commit in this tree: `4179cc390dace` (hash-
  corruption/RCU stall if `d_add` on already-hashed negatives). This fix
  builds on that `d_unhashed` guard and applies cleanly.
- Standalone; not `patch X/Y`. Mainline follow-ups on these files after
  `af59562a5b3d3` are unrelated (`ceph_trim_dentries`, VFS mkdir/lookup
  churn).

**Step 3.4: Author**
- Record: Xiubo Li is a listed maintainer of CEPH DISTRIBUTED FILE
  SYSTEM CLIENT. Ilya Dryomov is co-maintainer and merged it. Strong
  subsystem ownership.

**Step 3.5: Dependencies**
- Record: Uses existing `ceph_snap()` / `CEPH_NOSNAP`. Needs the
  `d_unhashed` guards for a clean apply; those are already here.
  Standalone.

Original mainline SHA: `af59562a5b3d34fb3aa7753f2543393578d06dbf` (not
an ancestor of this HEAD).

---

## Phase 4: Mailing list / external research

**Step 4.1: Original discussion**
- Record: `b4 dig -c af59562a5b3d3` →
  https://patch.msgid.link/20260723-b4-snap-negative-
  dentry-v1-1-c78178117929@clyso.com
- Only v1. Viacheslav Dubeyko: “Makes sense.” + `Reviewed-by`. No NAK,
  no stable objection, no later revision that superseded the committed
  diff.

**Step 4.2: Recipients (`b4 dig -w`)**
- Record: Ilya Dryomov, Alex Markuze, Viacheslav Dubeyko, Dhairya
  Parmar, `ceph-devel@`, `linux-kernel@`, reporter Andras Pataki. Right
  maintainers/list.

**Step 4.3: Bug report**
- Tracker 78529: snapshot paths return ENOENT; `ls` of parent restores
  visibility. Live tree had deleted the names after the snapshot.
- ceph-users thread documents a real backup/copy workload across
  parallel kernel mounts. Reproduced with `ls -ld` on snapshot paths.
- Tracker notes MDS `path_traverse()` `is_complete()` shortcut as the
  server-side trigger, and this kclient change as an independent defense
  so a transient ENOENT is not cached forever.

**Step 4.4: Series**
- Record: Single standalone patch. MDS/libcephfs fixes are userspace,
  not kernel prerequisites.

**Step 4.5: stable@**
- Record: UNVERIFIED. lore.kernel.org fetches returned 403. No evidence
  in the ceph-devel mbox of a stable NAK.

---

## Phase 5: Semantic analysis

**Step 5.1: Functions**
- Record: `ceph_finish_lookup`, `ceph_lookup`, `ceph_fill_trace`.

**Step 5.2: Callers**
- `ceph_lookup` is `.lookup` for `ceph_dir_iops` and `ceph_snapdir_iops`
  — every path walk, including `.snap/...`.
- `ceph_finish_lookup` also from `ceph_atomic_open()` in
  `fs/ceph/file.c`.
- `ceph_fill_trace` processes MDS replies (lookup/link/unlink traces).

**Step 5.3: Callees**
- Record: `d_add`/`d_unhashed`/`d_really_is_positive`, `ceph_snap()`,
  `__ceph_dir_is_complete()`, lease updates. No alloc/lock changes.

**Step 5.4: Reachability**
- Record: Userspace-reachable via ordinary `stat`/`open`/`cp`/`ls` on
  snapshot paths. Not an obscure config hook. `CONFIG_CEPH_FS` is the
  only gate.

**Step 5.5: Similar patterns**
- Record: All three `d_add(..., NULL)` sites in `fs/ceph/` are patched.
  No leftover sibling.

---

## Phase 6: This tree (pending-6.12 / 6.12.111)

**Step 6.1: Buggy code present?**
- Record: Yes.
  - `fs/ceph/dir.c` `ceph_finish_lookup()`: unhashed negatives still
    `d_add(dentry, NULL)` with no snap check.
  - `ceph_lookup()` local ENOENT shortcut has no `ceph_snap(dir) ==
    CEPH_NOSNAP`.
  - `fs/ceph/inode.c` `ceph_fill_trace()`: `d_add(dn, NULL)` on null
    dentry + lease, no snap check.
  - `ceph_d_revalidate()` still: `if (ceph_snap(dir) != CEPH_NOSNAP)
    valid = 1;`
- `git merge-base --is-ancestor af59562a5b3d3 HEAD` → not an ancestor
  (fix not already here).

**Step 6.2: Backport difficulty**
- Record: `git show af59562a5b3d3 | git apply --check` succeeded
  (inode.hunk offset −32). Clean apply.

**Step 6.3: Related fixes already here?**
- Record: `4179cc390dace` only prevents `d_add` on already-hashed
  dentries (RCU stall). It does not skip snapped negatives. No duplicate
  of this fix.

---

## Phase 7: Subsystem context

**Step 7.1**
- Record: [Subsystem] CephFS client (`fs/ceph/`). [Criticality]
  IMPORTANT — not core VFS, but a production networked filesystem
  (MAINTAINERS: Supported). Snapshot lookups are a real backup/restore
  path.

**Step 7.2**
- Record: Mature client; this lookup/revalidate behavior has been stable
  for years. Not a fix to brand-new 7.x-only code.

---

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
- Record: CephFS (`CONFIG_CEPH_FS`) users accessing snapshot trees
  (`.snap/...`), especially after live-tree deletes and MDS cache trim.
  Reporter: parallel snapshot copies on kernel mounts.

**Step 8.2: Trigger**
- Record: LOOKUP of a snapshot name after MDS returns traceless ENOENT
  (complete-dir shortcut / trim). Then every later lookup hits the
  cached negative. Unprivileged users who can read the mount can trigger
  it. Not a tiny race window; once cached, it sticks until
  readdir/`d_invalidate`.

**Step 8.3: Failure mode**
- Record: Existing snapshot files/directories are invisible (`ENOENT`).
  Backup/copy can skip or fail. Not a panic, but filesystem data-access
  correctness. Severity: **HIGH**.

**Step 8.4: Risk/benefit**
- Benefit: high for CephFS snapshot users (broken snapshot access /
  incomplete backups).
- Risk: very low (10 lines, snap-only, no locks/APIs). Cost is extra
  lookups for true snapshot ENOENT.
- Ratio: strongly favors backport.

---

## Phase 9: Synthesis

**Step 9.1: Evidence**

FOR:
- Real production report (Flatiron Institute); tracker + ceph-users
  thread with repro.
- Sticky negative dentries make snapshot names disappear until readdir.
- Same client logic is in this 6.12 tree.
- Small, obviously correct, maintainer-authored and maintainer-merged.
- Applies cleanly; no series dependency.
- Independent of the MDS-side fix; still needed against older/unfixed
  MDS.

AGAINST:
- Not a crash/UAF/deadlock; tracker severity “3 - minor”.
- Primary trigger is MDS; workaround is `ls` on the parent.
- Only CephFS snapshot lookups.

UNRESOLVED:
- Whether stable@ already discussed this (lore HTTP 403).

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** — reviewed, merged, matches
   the described mechanism in this tree.
2. Real bug affecting users? **PASS** — confirmed ENOENT for existing
   snapshot paths.
3. Important? **PASS** — filesystem returning ENOENT for data that
   exists, breaking snapshot copy/backup.
4. Small and contained? **PASS** — +10/-3, two files, three sites.
5. No new features/APIs? **PASS**
6. Applies to this tree? **PASS** — `git apply --check` clean; helpers
   already present.

**Step 9.3: Exceptions**
- Record: Not ID/quirk/DT/build/docs. Ordinary correctness fix.

**Step 9.4: Decision**
This tree should take it. The bug is here, the fix is surgical, and
snapshot ENOENT-for-existing-files is a serious CephFS correctness issue
for stable users still talking to MDS daemons that can emit that reply.

---

### What it solves for this tree
On 6.12 CephFS, a traceless snapshot LOOKUP ENOENT is cached as a
negative dentry that `ceph_d_revalidate()` never invalidates. Users then
cannot open snapshot files that still exist until someone does readdir.
The patch stops caching those negatives for snapped parents.

### Risk vs benefit
Benefit is restoring snapshot access for a documented production failure
mode. Risk is confined to extra lookups on snapshot ENOENT, with live-
directory caching unchanged.

### Concerns
None that block backport. MDS userspace should still be fixed
separately; this kernel change is the client-side defense and does not
require those patches.

---

Verification:
- [Phase 1] Parsed tags: Reported-by Andras Pataki, Link tracker 78529,
  Reviewed-by Dubeyko, SOB Dryomov; no Fixes/Cc-stable
- [Phase 1] Tracker 78529 and ceph-users thread confirm ENOENT on
  snapshot paths, readdir workaround, kernel 6.18.32 / squid 19.2.3
- [Phase 2] Diff: three `d_add(..., NULL)` sites; snap check + skip
  cache; `ceph_lookup` local ENOENT gated on `CEPH_NOSNAP`
- [Phase 2] Confirmed `ceph_d_revalidate()` in this tree sets `valid =
  1` for `ceph_snap(dir) != CEPH_NOSNAP`
- [Phase 3] `git describe HEAD` / Makefile: pending-6.12, 6.12.111
- [Phase 3] `git merge-base --is-ancestor af59562a5b3d3 HEAD` → not
  present
- [Phase 3] Blame: `d_add` path from `2817b000b02c5f` (2009); snap trust
  from 2009–2011
- [Phase 3] Prerequisite `4179cc390dace` (`d_unhashed` before `d_add`)
  is already in this tree
- [Phase 4] `b4 dig -c af59562a5b3d3`: v1 only; lore msgid
  `20260723-b4-snap-negative-dentry-v1-1-c78178117929@clyso.com`
- [Phase 4] `b4 dig -a/-w/-m`: maintainer CC list; Dubeyko “Makes sense”
  + Reviewed-by; no NAK
- [Phase 4] WebFetch lore.kernel.org/patch.msgid.link: HTTP 403
  (discussion recovered via `b4 dig -m`)
- [Phase 5] Callers: `ceph_lookup` is dir and snapdir `.lookup`;
  `ceph_finish_lookup` also from `ceph_atomic_open`
- [Phase 6] `git apply --check` of `af59562a5b3d3` succeeded on this
  tree
- [Phase 6] All three local `d_add(..., NULL)` sites still lack the snap
  guard
- [Phase 7] MAINTAINERS: Ceph FS client Supported; author Xiubo Li is a
  listed maintainer
- [Phase 8] Failure mode: persistent ENOENT for existing snapshot names
  → HIGH filesystem correctness
- UNVERIFIED: stable@ mailing-list history (lore 403)

**YES**

 fs/ceph/dir.c   | 10 ++++++++--
 fs/ceph/inode.c |  3 ++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 24abe4dbf774d..a253286214fee 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -774,8 +774,13 @@ struct dentry *ceph_finish_lookup(struct ceph_mds_request *req,
 				d_drop(dentry);
 				err = -ENOENT;
 			} else {
-				if (d_unhashed(dentry))
-					d_add(dentry, NULL);
+				if (d_unhashed(dentry)) {
+					struct inode *parent =
+						d_inode(dentry->d_parent);
+					if (!parent ||
+					    ceph_snap(parent) == CEPH_NOSNAP)
+						d_add(dentry, NULL);
+				}
 			}
 		}
 	}
@@ -840,6 +845,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
 			    dentry->d_name.len) &&
 		    !is_root_ceph_dentry(dir, dentry) &&
 		    ceph_test_mount_opt(fsc, DCACHE) &&
+		    ceph_snap(dir) == CEPH_NOSNAP &&
 		    __ceph_dir_is_complete(ci) &&
 		    __ceph_caps_issued_mask_metric(ci, CEPH_CAP_FILE_SHARED, 1)) {
 			__ceph_touch_fmode(ci, mdsc, CEPH_FILE_MODE_RD);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index b6c60d787692e..fddeeb9527fb3 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1783,7 +1783,8 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 				ceph_dir_clear_ordered(dir);
 				d_delete(dn);
 			} else if (have_lease) {
-				if (d_unhashed(dn))
+				if (d_unhashed(dn) &&
+				    ceph_snap(dir) == CEPH_NOSNAP)
 					d_add(dn, NULL);
 			}
 
-- 
2.53.0

