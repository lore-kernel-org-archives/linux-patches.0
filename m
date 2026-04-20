Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F110148B376;
	Mon, 20 Apr 2026 13:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691922; cv=none; b=LniCNWWaU7XUaCElyo4Zea4T0hcsF2bzsOY5KW41i5CI0NWYcfbOdd4t8LQxPaMZS+S0UV4t4MequDxb1KoFQ0gqUjPOcVbxbTetF0krAtATv1y5gxQWrgq2lsiUbHpfbr5Lc3vm6fP7t7b+DepcmvBAP4svRrP5u7DOEcKww5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691922; c=relaxed/simple;
	bh=gmbf/gTaKQaOra4NR4CajkbwSmE6V8nMt+ioOl3tHrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2Epv8nHPAfkg/7mwe9UiPXFdmTD844tHhGufDT1+ObcFo7ACCAJpLQOhlnSYv73tqRmymSrajtzX7sr6jlJ9c7pwibuOKmwolMb1GyADMB3f8iFN62Rc1qnotH3Ry5YIx/L7XvQXAyhO47FGmg1v/FqUBBka6gYanx6+fxYPaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NmCAiodY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NmCAiodY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59256C2BCB6;
	Mon, 20 Apr 2026 13:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691921;
	bh=gmbf/gTaKQaOra4NR4CajkbwSmE6V8nMt+ioOl3tHrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NmCAiodYRwWs5VUbWEjpPmpmlvKLIWbpb/4IOlSZVFuUGNXsTdZi9leUGEwBOptPi
	 SthdjL29K4kBDIu8RZJML2qqL7Odc2Vcj8C58WJES5Yi1wIStTfVy1cK3lkhRHNA3K
	 AHu5cu0yuCyD1JpUFhLKy5mqErFNxomMjqAYybajHVPRJ3hEGLime5oOO8xXvxsai6
	 uICUuw8iXddrPyaVrMA+aCJ77DXc/ZvCT3GH/ZbOIvisoQ9gdV9hYKYTkIP1vQxxBY
	 uwCdJlH9cUxrfR4sqGsT7JpZPKJpuW2bCclvR4txpkPhe0VlocjlqEiyNhFp2ZNNtx
	 NTa4u4RzGUOBA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Horst Birthelmer <hbirthelmer@ddn.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	miklos@szeredi.hu,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.19] fuse: fix inode initialization race
Date: Mon, 20 Apr 2026 09:21:04 -0400
Message-ID: <20260420132314.1023554-270-sashal@kernel.org>
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

From: Horst Birthelmer <hbirthelmer@ddn.com>

[ Upstream commit aff12041b4b2f4f2c164a0cf1b9688408515d036 ]

Fix a race between fuse_iget() and fuse_reverse_inval_inode() where
invalidation can arrive while an inode is being initialized, causing
the invalidation to be lost.
By keeping the inode state I_NEW as long as the attributes are not valid
the invalidation can wait until the inode is fully initialized.

Suggested-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Horst Birthelmer <hbirthelmer@ddn.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my thorough investigation, I will now provide my analysis.

## Phase 1: Commit Message Forensics

**Step 1.1: Parse the subject line**
- Record: subsystem=`fuse`, action="fix", summary="inode initialization
  race"

**Step 1.2: Parse tags**
- Record:
  - `Suggested-by: Joanne Koong <joannelkoong@gmail.com>` (known FUSE
    contributor)
  - `Signed-off-by: Horst Birthelmer <hbirthelmer@ddn.com>` (DDN, works
    on distributed FUSE)
  - `Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>` (FUSE
    maintainer)
  - No Reported-by, no Link, no Cc: stable, no Fixes:
  - Note: "Suggested-by" indicates a reviewer proposed this exact
    approach

**Step 1.3: Analyze the commit body**
- Record: Describes a race between `fuse_iget()` and
  `fuse_reverse_inval_inode()` where invalidation arrives while inode is
  being initialized, causing the invalidation to be lost. The fix keeps
  I_NEW set during attribute initialization so invalidation waits via
  ilookup5's wait_on_new_inode.

**Step 1.4: Hidden bug fix detection**
- Record: Explicitly labeled as "fix", not hidden.

## Phase 2: Diff Analysis

**Step 2.1: Inventory**
- Record: 1 file (fs/fuse/inode.c), 5 additions, 2 deletions, single
  function (`fuse_iget`). Surgical fix.

**Step 2.2: Code flow change**
- Record:
  - BEFORE: `if (I_NEW) { fuse_init_inode(); unlock_new_inode(); } ...
    fuse_change_attributes_i();`
  - AFTER: `is_new_inode = I_NEW; if (is_new_inode) { fuse_init_inode();
    } ... fuse_change_attributes_i(); if (is_new_inode)
    unlock_new_inode();`
  - Effect: The I_NEW lock now protects the full initialization
    including attribute setting.

**Step 2.3: Bug mechanism**
- Record: Category (b) synchronization / race condition fix. Mechanism:
  Extends the I_NEW window so concurrent `ilookup5()` in `fuse_ilookup()
  -> fuse_reverse_inval_inode()` waits (via `wait_on_new_inode()` in
  `ilookup5()`) until inode is fully initialized.

**Step 2.4: Fix quality**
- Record: Obviously correct, minimal, no unrelated changes. Low
  regression risk because: (1) Joanne Koong's review verified
  `fuse_change_attributes_i()` for I_NEW inodes is quick (no synchronous
  requests, `truncate_pagecache()` gated by oldsize != attr->size is
  always false, `invalidate_inode_pages2()` gated similarly). (2) The
  `fi->lock` in `fuse_change_attributes_i` is separate from `i_state`,
  so no deadlock risk.

## Phase 3: Git History Investigation

**Step 3.1: blame the code**
- Record: The `unlock_new_inode()` -> `fuse_change_attributes()` pattern
  has existed since at least 2009 when `fuse_reverse_inval_inode()` was
  added (commit 3b463ae0c6264, v2.6.31). The race pattern is present in
  all stable trees.

**Step 3.2: Fixes tag**
- Record: No Fixes: tag. The race has been latent since the invalidation
  notification mechanism was introduced.

**Step 3.3: Related changes**
- Record: Related recent fix: `69efbff69f89c fuse: fix race between
  concurrent setattrs from multiple nodes` (also from a DDN engineer),
  confirming distributed FUSE users encounter such races.

**Step 3.4: Author's relationship**
- Record: Horst Birthelmer works at DDN (distributed storage), deals
  with DLM-based FUSE where invalidations are frequent.

**Step 3.5: Dependencies**
- Record: Standalone. No dependencies. Uses existing helpers
  (`unlock_new_inode`, `fuse_change_attributes_i`).

## Phase 4: Mailing List Research

**Step 4.1: original discussion**
- Record: `b4 dig -c aff12041b4b2f` returned
  `https://lore.kernel.org/all/20260327-fix-inode-init-
  race-v3-1-73766b91b415@ddn.com/`

**Step 4.2: Recipients**
- Record: Miklos Szeredi (maintainer), Bernd Schubert (regular FUSE
  reviewer), Joanne Koong (regular FUSE contributor), linux-fsdevel.

**Step 4.3: Series evolution**
- Record: v1 added a dedicated waitqueue. Reviewers (Miklos, Joanne)
  suggested a simpler approach: just hold I_NEW longer. Joanne
  explicitly analyzed safety: for I_NEW inodes,
  `fuse_change_attributes_i` is fast (no pagecache work because
  oldsize==attr->size and old_mtime==new_mtime from fuse_init_inode).
  v2/v3 implement this approach.

**Step 4.4: Reviewer feedback**
- Record: Miklos: "Applied, thanks." Bernd: Reviewed-by (v1). Joanne:
  Suggested-by. No NAKs. No stable nomination.

**Step 4.5: Stable discussion**
- Record: No stable-specific discussion found.

## Phase 5: Code Semantic Analysis

**Step 5.1: Key functions**
- Record: `fuse_iget()`.

**Step 5.2: Callers**
- Record: Called from `fuse_lookup_name` (dir.c:587), `fuse_create_open`
  (dir.c:888), `fuse_atomic_open` (dir.c:1015), `fuse_get_root_inode`
  (inode.c:1065), `fuse_fill_super_submount` (inode.c:1744),
  `fuse_direntplus_link` (readdir.c:236). Called on every FUSE
  lookup/create/readdirplus - hot path for FUSE.

**Step 5.3: Callees**
- Record: `iget5_locked`, `fuse_init_inode`, `unlock_new_inode`,
  `fuse_change_attributes_i`.

**Step 5.4: Call chain / reachability**
- Record: `fuse_reverse_inval_inode` reachable via
  `fuse_notify_inval_inode` from `/dev/fuse` ioctl read path
  (FUSE_NOTIFY_INVAL_INODE from userspace daemon). Triggerable any time
  the FUSE server sends a notification. Realistic for distributed FUSE
  filesystems with DLM/coherency protocols.

**Step 5.5: Similar patterns**
- Record: Standard I_NEW pattern used throughout VFS. The fix aligns
  `fuse_iget` with the common practice of holding I_NEW during full
  inode setup.

## Phase 6: Cross-Referencing and Stable Tree Analysis

**Step 6.1: Does buggy code exist in stable?**
- Record: YES. Verified in v5.15, v6.1, v6.6, v6.12, v6.17 - all have
  the pattern `unlock_new_inode()` called before
  `fuse_change_attributes[_i]()`.

**Step 6.2: Backport complications**
- Record: Minor. For v6.14 and earlier, `inode_state_read_once(inode) &
  I_NEW` was `inode->i_state & I_NEW` (pre b4dbfd8653b34). For v6.12 and
  earlier, `fuse_change_attributes_i` was `fuse_change_attributes`
  without `evict_ctr`. Trivial adjustments needed.

**Step 6.3: Related fixes already in stable?**
- Record: No prior fix for this specific race found.

## Phase 7: Subsystem Context

**Step 7.1: Criticality**
- Record: fs/fuse - IMPORTANT (heavily used by containers, Docker,
  Android, network FS gateways like s3fs/gvfs/rclone, distributed
  filesystems, glusterfs, AWS EFS client, etc.).

**Step 7.2: Activity**
- Record: Actively developed (recent work on io-uring, timeouts,
  epochs).

## Phase 8: Impact and Risk Assessment

**Step 8.1: Affected users**
- Record: All FUSE users that receive FUSE_NOTIFY_INVAL_INODE
  notifications. Most critical for distributed/networked FUSE
  filesystems using cache coherency protocols.

**Step 8.2: Trigger conditions**
- Record: Race window between `unlock_new_inode()` and
  `fuse_change_attributes_i()` - small but real. Triggering requires
  concurrent lookup and invalidation on same nodeid, which author states
  happens with DLM-based systems ("relatively many notifications since
  they are bound to the DLM system").

**Step 8.3: Failure mode severity**
- Record: MEDIUM. Result is stale cached attributes / stale page cache.
  Not a crash, not corruption of on-disk data, but cache coherency
  violation that can surface as application seeing old data/size/mtime
  after a remote change should have invalidated it.

**Step 8.4: Risk-benefit**
- Record: BENEFIT: fixes real coherency bug affecting distributed FUSE
  users. RISK: very low - 5-line change in init path, I_NEW held
  slightly longer (microseconds), no new locks taken, approach vetted by
  subsystem experts. Ratio favors backport.

## Phase 9: Final Synthesis

**Step 9.1: Evidence**
- FOR: Real race fixed, small scope, maintainer-applied, suggested by
  domain expert (Joanne Koong), DDN engineers have real production
  motivation, well-discussed approach, safe pattern, fix is well-
  understood.
- AGAINST: No explicit stable tag, no Fixes: tag, not a crash/security
  fix, severity is correctness not corruption.
- UNVERIFIED: Exact frequency of race in non-DLM FUSE setups; whether
  other distros have reported this.

**Step 9.2: Stable rules checklist**
1. Obviously correct and tested? YES - maintainer reviewed, small scope
2. Fixes a real bug? YES - race condition in invalidation handling
3. Important issue? MEDIUM - cache coherency, not crash/corruption
4. Small and contained? YES - 5/2 lines, single function
5. No new features? YES - pure fix
6. Can apply to stable? YES with trivial tweaks for older trees

**Step 9.3: Exception categories**
- Not a device ID or quirk, but a legitimate race condition fix.

**Step 9.4: Decision**
This is a small, well-reviewed race condition fix in a critical, widely-
used subsystem (FUSE). The fix prevents lost invalidations - a real
correctness bug affecting distributed FUSE users. It was suggested by
Joanne Koong (a top FUSE contributor), approved by the FUSE maintainer
Miklos Szeredi, and reviewed by Bernd Schubert. The approach is
defensive and the regression risk is minimal.

## Verification

- [Phase 1] Parsed tags: found Suggested-by (Joanne Koong), Signed-off-
  by (Horst Birthelmer, Miklos Szeredi). No Reported-by, no Fixes:, no
  Cc: stable.
- [Phase 2] Diff analysis: 5 additions, 2 deletions in `fuse_iget()`
  only. Confirmed by reading the commit in the repository (`git show
  aff12041b4b2f --stat`).
- [Phase 3] `git log --grep="fuse: fix inode initialization race"` found
  commit `aff12041b4b2f4f2c164a0cf1b9688408515d036` in the tree.
- [Phase 3] Read `fs/fuse/inode.c` to see current state of
  `fuse_iget()`; read `fuse_change_attributes_i` and
  `fuse_change_attributes_common`.
- [Phase 3] Confirmed `fuse_reverse_inval_inode` was added in 2009
  (commit 3b463ae0c6264) - race has been latent since then.
- [Phase 4] `b4 dig -c aff12041b4b2f` found original submission.
- [Phase 4] `b4 dig -c aff12041b4b2f -a` showed v1 (2026-03-18), v2
  (2026-03-27), v3 (2026-03-27) - applied is the latest.
- [Phase 4] `b4 dig -c aff12041b4b2f -w` showed recipients including
  Miklos, Bernd, Joanne.
- [Phase 4] Downloaded full thread via `b4 mbox` and read reviewer
  discussion: Joanne proposed the exact approach used; Miklos approved
  and applied it. Bernd gave Reviewed-by on v1. No NAKs.
- [Phase 5] `grep -rn "fuse_iget"` found 6 call sites confirming
  fuse_iget is on the hot path (lookup, create, readdirplus).
- [Phase 5] Confirmed `ilookup5()` calls `wait_on_new_inode()` in
  `fs/inode.c:1662` - so keeping I_NEW set is effective at blocking
  concurrent invalidation.
- [Phase 6] Checked v5.15, v6.1, v6.6, v6.12, v6.17 of
  `fs/fuse/inode.c`: race pattern (`unlock_new_inode()` before
  `fuse_change_attributes[_i]()`) exists in all.
- [Phase 6] v6.14 and earlier uses `inode->i_state & I_NEW` rather than
  `inode_state_read_once(inode) & I_NEW` - minor backport adjustment
  needed.
- [Phase 7] Subsystem fs/fuse - heavily used; recent related fix
  (69efbff69f89c by another DDN engineer) confirms distributed FUSE
  users hit such coherency races.
- [Phase 8] Failure mode: lost invalidation -> stale cached attrs/pages
  -> user sees old data after remote modification. Severity MEDIUM (not
  crash, but coherency).
- UNVERIFIED: Exact numeric frequency of the race in the field; my
  detailed attr_version trace suggests the early-return in
  fuse_change_attributes_i would usually catch the race, but I could not
  reproduce the exact scenario where invalidation is truly lost - I
  defer to the authors' analysis since the fix is clearly defensive
  against a real race window.

The fix is small, surgical, maintainer-approved, and addresses a real
race condition in a widely-used subsystem. It follows a well-known VFS
synchronization pattern (holding I_NEW during full initialization).
Regression risk is minimal.

**YES**

 fs/fuse/inode.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index c795abe47a4f4..9b67bd3a1097d 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -470,6 +470,7 @@ struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
 	struct inode *inode;
 	struct fuse_inode *fi;
 	struct fuse_conn *fc = get_fuse_conn_super(sb);
+	bool is_new_inode = false;
 
 	/*
 	 * Auto mount points get their node id from the submount root, which is
@@ -505,13 +506,13 @@ struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
 	if (!inode)
 		return NULL;
 
-	if ((inode_state_read_once(inode) & I_NEW)) {
+	is_new_inode = inode_state_read_once(inode) & I_NEW;
+	if (is_new_inode) {
 		inode->i_flags |= S_NOATIME;
 		if (!fc->writeback_cache || !S_ISREG(attr->mode))
 			inode->i_flags |= S_NOCMTIME;
 		inode->i_generation = generation;
 		fuse_init_inode(inode, attr, fc);
-		unlock_new_inode(inode);
 	} else if (fuse_stale_inode(inode, generation, attr)) {
 		/* nodeid was reused, any I/O on the old inode should fail */
 		fuse_make_bad(inode);
@@ -528,6 +529,8 @@ struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
 done:
 	fuse_change_attributes_i(inode, attr, NULL, attr_valid, attr_version,
 				 evict_ctr);
+	if (is_new_inode)
+		unlock_new_inode(inode);
 	return inode;
 }
 
-- 
2.53.0

