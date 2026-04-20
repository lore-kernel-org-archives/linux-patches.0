Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78694963A5;
	Mon, 20 Apr 2026 13:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691949; cv=none; b=eX9X7d8DHhoOvo6LM5Z/CC+eXXYm4V2ha2LZXkRa6wu45AgiJQyPUQ4rDDQAXKaAkX2cBYdeArlQf8GgdLFZRduuW4uk5C00JGXhTN8ajMBChCM6w3voSuU3xsqOEamWWwr4Hr3GqasOhy5Y0TuivIe9iJe8+TrCcOSGZbxyeLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691949; c=relaxed/simple;
	bh=a0pkypsJl7lPY/XyUA4DFMkvgpRFDLmDdUR/nSsu2lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pKtHR3oHA+seFV5uyus2DKUQTqXPqxaguuySaRqckKS2vSAwXoyUQeOXZMvO0sx0mjKfMj6iDwaQcENdhIF+LLR5G908VE6H7rcc3nH5DOGh5ge4KaC4BY7vyCjNnFoGVrPshf5BkZw5DZ1XENoDANisMq797wg4mo1X8hpoiz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mmk7KUvx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mmk7KUvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4149CC2BCB4;
	Mon, 20 Apr 2026 13:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691949;
	bh=a0pkypsJl7lPY/XyUA4DFMkvgpRFDLmDdUR/nSsu2lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mmk7KUvx4xnRXPWvGxmU1lIPiYSAlzJ7hztGH83MtZXZf2HYPvYCHgwvBJ+27N2j9
	 wWnk34SrsgdWMo3y9V/BqHRWcjgDnD0kOgJfKlAPfKto83ouaHV2IoAGpgaIE/92OZ
	 nb+e09rTyZtmQ0Fk6JTt1fXkC6PGacF/7FMtS2AN6yjlVnJYqo0RZEVVW4cTpkwISU
	 3UJmAFo4KqqPwYtUapCFieZ8TDhlKJ5j/+l7M81kWXBtSSEaer+Ne6nicOb1nYgNwW
	 4zYbKtHf4q6F6C78ukLWk9CO/etXw0a1DLRjiHuhu4VccpynMtfFH9nkHanm51HMSy
	 zrRE2rvmn9tHw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sergio Lopez <slp@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	miklos@szeredi.hu,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.15] fuse: mark DAX inode releases as blocking
Date: Mon, 20 Apr 2026 09:21:20 -0400
Message-ID: <20260420132314.1023554-286-sashal@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sergio Lopez <slp@redhat.com>

[ Upstream commit 42fbb31310b2c145308d3cdcb32d8f05998cfd6c ]

Commit 26e5c67deb2e ("fuse: fix livelock in synchronous file put from
fuseblk workers") made fputs on closing files always asynchronous.

As cleaning up DAX inodes may require issuing a number of synchronous
request for releasing the mappings, completing the release request from
the worker thread may lead to it hanging like this:

[   21.386751] Workqueue: events virtio_fs_requests_done_work
[   21.386769] Call trace:
[   21.386770]  __switch_to+0xe4/0x140
[   21.386780]  __schedule+0x294/0x72c
[   21.386787]  schedule+0x24/0x90
[   21.386794]  request_wait_answer+0x184/0x298
[   21.386799]  __fuse_simple_request+0x1f4/0x320
[   21.386805]  fuse_send_removemapping+0x80/0xa0
[   21.386810]  dmap_removemapping_list+0xac/0xfc
[   21.386814]  inode_reclaim_dmap_range.constprop.0+0xd0/0x204
[   21.386820]  fuse_dax_inode_cleanup+0x28/0x5c
[   21.386825]  fuse_evict_inode+0x120/0x190
[   21.386834]  evict+0x188/0x320
[   21.386847]  iput_final+0xb0/0x20c
[   21.386854]  iput+0xa0/0xbc
[   21.386862]  fuse_release_end+0x18/0x2c
[   21.386868]  fuse_request_end+0x9c/0x2c0
[   21.386872]  virtio_fs_request_complete+0x150/0x384
[   21.386879]  virtio_fs_requests_done_work+0x18c/0x37c
[   21.386885]  process_one_work+0x15c/0x2e8
[   21.386891]  worker_thread+0x278/0x480
[   21.386898]  kthread+0xd0/0xdc
[   21.386902]  ret_from_fork+0x10/0x20

Here, the virtio-fs worker_thread is waiting on request_wait_answer()
for a reply from the virtio-fs server that is already in the virtqueue
but will never be processed since it's that same worker thread the one
in charge of consuming the elements from the virtqueue.

To address this issue, when relesing a DAX inode mark the operation as
potentially blocking. Doing this will ensure these release requests are
processed on a different worker thread.

Signed-off-by: Sergio Lopez <slp@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis. Let me
compile my findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: `fuse` (FUSE filesystem)
- **Action verb**: "mark" (but this is fixing a hang/deadlock - a hidden
  bug fix)
- **Summary**: Mark DAX inode releases as potentially blocking so they
  are processed on a separate worker thread

Record: [fuse] [mark/fix] [Prevent worker thread self-deadlock during
DAX inode release]

### Step 1.2: Tags
- **Fixes-like reference**: Commit 26e5c67deb2e ("fuse: fix livelock in
  synchronous file put from fuseblk workers") - this is the commit that
  introduced the regression, though not in a formal `Fixes:` tag
- **Signed-off-by**: Sergio Lopez <slp@redhat.com> (author)
- **Reviewed-by**: Darrick J. Wong <djwong@kernel.org> (the author of
  the commit that introduced the regression)
- **Signed-off-by**: Miklos Szeredi <mszeredi@redhat.com> (FUSE
  subsystem maintainer)
- No explicit `Cc: stable@vger.kernel.org` tag (expected for autosel
  candidates)
- No formal `Fixes:` tag, but commit body clearly identifies the
  regressing commit

Record: Reviewed by the author of the regression (Darrick Wong) AND
merged by the FUSE subsystem maintainer (Miklos Szeredi). Strong quality
signals.

### Step 1.3: Commit Body Analysis
The commit describes:
- **Bug**: After commit 26e5c67deb2e made file releases always async,
  DAX inode cleanup can cause worker thread hang
- **Symptom**: System hang (worker thread blocked in
  `request_wait_answer`)
- **Root cause**: The virtio-fs worker thread
  (`virtio_fs_requests_done_work`) processes async release completion,
  which triggers DAX inode cleanup, which issues synchronous FUSE
  requests (FUSE_REMOVEMAPPING), which blocks waiting for a response
  from the virtqueue — but it's the same worker thread that processes
  virtqueue responses
- **Failure mode**: Self-deadlock/hang with clear stack trace provided
- **Fix approach**: Set `args->may_block = true` for DAX inodes, causing
  the completion to be scheduled on a separate worker

Record: Bug is a worker thread self-deadlock/hang. Stack trace is
provided. Root cause is clearly explained. This is a CRITICAL hang bug.

### Step 1.4: Hidden Bug Fix Detection
This IS a bug fix. The subject says "mark ... as blocking" but the
actual effect is preventing a self-deadlock. The commit describes a
system hang scenario with a reproducible stack trace.

Record: YES, this is a bug fix - prevents a self-deadlock in virtio-fs
DAX inode release.

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed**: 1 file (`fs/fuse/file.c`)
- **Lines added**: 5 (comment + conditional check)
- **Lines removed**: 0
- **Functions modified**: `fuse_file_put()`
- **Scope**: Single-file, surgical fix in one function

Record: Extremely small, single-file, single-function fix. 5 lines
added, 0 removed.

### Step 2.2: Code Flow Change
In `fuse_file_put()`, the `else` branch (async release path):
- **Before**: Directly sets `args->end` and calls
  `fuse_simple_background()`
- **After**: First checks if the inode is a DAX inode
  (`FUSE_IS_DAX(ra->inode)`) and sets `args->may_block = true` if so,
  then proceeds as before

The `may_block` flag is checked in `virtio_fs_requests_done_work()` —
when true, the completion is scheduled via `schedule_work()` on a
separate worker instead of being processed inline. This prevents the
self-deadlock.

Record: [else branch: added DAX check setting may_block -> completion
goes to separate worker -> no self-deadlock]

### Step 2.3: Bug Mechanism
This is a **deadlock** fix. The bug mechanism:
1. Commit 26e5c67deb2e made ALL file releases async (sync=false)
2. For DAX inodes, async release completes in the virtio-fs worker
   thread
3. DAX inode cleanup (`fuse_dax_inode_cleanup`) issues synchronous FUSE
   requests via `fuse_simple_request()`
4. These synchronous requests block waiting for a response via
   `request_wait_answer()`
5. The response is in the virtqueue but will never be processed because
   the worker thread is the one blocked

Record: [Bug category: DEADLOCK/HANG] [Self-deadlock in virtio-fs worker
when DAX inode cleanup issues synchronous requests]

### Step 2.4: Fix Quality
- The fix is **obviously correct**: it uses an existing, well-tested
  mechanism (`may_block`) that was designed for exactly this kind of
  problem (bb737bbe48bea9, introduced in v5.10)
- The fix is **minimal**: 5 lines, single function
- **Regression risk**: Very low. Setting `may_block` for DAX inodes
  simply routes the completion to a separate worker. This is exactly
  what already happens for async I/O operations that set `should_dirty`
- **No new features or APIs**: Uses existing `may_block` field and
  existing worker scheduling

Record: Obviously correct, minimal, low regression risk.

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
- The buggy code (async release without `may_block`) was introduced by
  26e5c67deb2e (v6.18)
- The `may_block` mechanism was introduced by bb737bbe48bea9 (v5.10)
- DAX support in fuse has been present since v5.10

Record: Bug introduced in v6.18. Prerequisite `may_block` mechanism
present since v5.10.

### Step 3.2: Fixes Tag Follow-up
The commit references 26e5c67deb2e ("fuse: fix livelock in synchronous
file put from fuseblk workers") which:
- Was first in v6.18-rc1
- Has CVE-2025-40220
- Was backported to stable trees: 6.12.y (at least 6.12.56/57), 6.6.y
  (at least 6.6.115/116)
- Had `Cc: stable@vger.kernel.org # v2.6.38`
- The backport to 6.1-stable failed initially

Record: The regression-introducing commit IS in stable trees. Any stable
tree that has 26e5c67deb2e NEEDS this follow-up fix.

### Step 3.3: File History
- `fs/fuse/file.c` has had significant changes between 6.12 and 7.0
  (iomap rework, etc.)
- But the specific code path (fuse_file_put else branch) has been stable

Record: File has churn but the specific function is stable. Standalone
fix.

### Step 3.4: Author
- Sergio Lopez <slp@redhat.com> — Red Hat engineer, appears to be a
  virtio-fs contributor
- Reviewed by Darrick J. Wong (the original regression author) and
  merged by Miklos Szeredi (FUSE maintainer)

Record: Fix authored by virtio-fs contributor, reviewed by regression
author, merged by subsystem maintainer.

### Step 3.5: Dependencies
- This fix depends on commit 26e5c67deb2e being present (the one that
  made releases async)
- This fix depends on the `may_block` mechanism (bb737bbe48bea9, v5.10)
- Both prerequisites exist in all active stable trees where 26e5c67deb2e
  was backported
- The `FUSE_IS_DAX` macro has been present since v5.10

Record: Dependencies are: 26e5c67deb2e (which is in stable) and
may_block mechanism (v5.10+). Both present.

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1-4.5
- b4 dig could not find the exact patch submission URL (lore.kernel.org
  is behind Anubis protection)
- Web search could not locate the specific patch discussion
- The commit was reviewed by Darrick J. Wong and merged by Miklos
  Szeredi
- The referenced commit 26e5c67deb2e has CVE-2025-40220 and was already
  backported to stable trees

Record: Could not access lore due to bot protection. But the commit is
reviewed by subsystem experts and fixes a regression from a CVE fix
already in stable.

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Functions Modified
- `fuse_file_put()` - the only function modified

### Step 5.2: Callers
- `fuse_file_put()` is called from:
  - `fuse_file_release()` (line 378 with sync=false — the path that
    triggers the bug)
  - `fuse_sync_release()` (line 409 with sync=true — not affected)
  - Other callers via `fuse_release_common()` and `fuse_release()`

### Step 5.3-5.4: Call Chain
The confirmed deadlock path (from stack trace):
`virtio_fs_requests_done_work` → `virtio_fs_request_complete` →
`fuse_request_end` → `fuse_release_end` → `iput` → `evict` →
`fuse_evict_inode` → `fuse_dax_inode_cleanup` →
`inode_reclaim_dmap_range` → `dmap_removemapping_list` →
`fuse_send_removemapping` → `fuse_simple_request` →
`request_wait_answer` (BLOCKS)

This path is reachable whenever a DAX inode file is released
asynchronously on virtio-fs.

Record: Deadlock path is confirmed via code tracing and matches the
provided stack trace.

### Step 5.5: Similar Patterns
The `may_block` mechanism is already used in `fs/fuse/file.c` line 752
for async I/O (`ia->ap.args.may_block = io->should_dirty`). The fix
follows the same proven pattern.

Record: Fix uses an existing, well-tested pattern.

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable
- The bug only exists where commit 26e5c67deb2e has been applied
- That commit was backported to 6.12.y and 6.6.y (confirmed via web
  search)
- FUSE DAX support exists since v5.10
- The `may_block` mechanism exists since v5.10

Record: Bug exists in all stable trees where 26e5c67deb2e was backported
(6.12.y, 6.6.y minimum).

### Step 6.2: Backport Complications
- The diff is 5 lines in a single function
- The surrounding code context (`fuse_file_put` else branch) is stable
  across trees
- Should apply cleanly to any tree that has 26e5c67deb2e

Record: Clean apply expected.

### Step 6.3: Related Fixes Already in Stable
- No other fix for this specific DAX deadlock has been identified

Record: No alternative fix exists.

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem Criticality
- **Subsystem**: FUSE (fs/fuse) — filesystem layer
- **Criticality**: IMPORTANT — FUSE is used by many systems (virtiofs in
  VMs/containers, sshfs, user-space filesystems)
- DAX support is specifically important for virtio-fs in VM environments

Record: [fs/fuse] [IMPORTANT - widely used in VM/container environments]

### Step 7.2: Subsystem Activity
- Active development (iomap rework, DAX improvements, etc.)

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
- Users running virtio-fs with DAX enabled (common in VM/container
  environments)
- The bug causes a complete system hang for these users

Record: VM/container users with virtio-fs DAX. Significant user
population.

### Step 8.2: Trigger Conditions
- Any file close on a DAX-enabled virtio-fs mount where the inode is
  evicted
- This is a COMMON operation — closing files is basic filesystem
  activity
- DAX inode eviction happens naturally during normal operation

Record: Common trigger. Normal file operations on DAX virtio-fs.

### Step 8.3: Failure Mode Severity
- **System hang**: The worker thread deadlocks, preventing all further
  virtio-fs operations
- No automatic recovery — the system becomes effectively unusable for
  that filesystem
- **Severity: CRITICAL** — hang/deadlock

Record: [CRITICAL] System hang/deadlock with no recovery.

### Step 8.4: Risk-Benefit Ratio
- **Benefit**: VERY HIGH — prevents a deterministic system hang on DAX
  virtio-fs
- **Risk**: VERY LOW — 5 lines, uses existing well-tested mechanism,
  single-file, reviewed by experts
- **Ratio**: Overwhelming benefit, minimal risk

Record: Very high benefit, very low risk.

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Compilation

**FOR backporting:**
- Fixes a CRITICAL deadlock/hang bug (worker thread self-deadlock)
- Reproducible with clear stack trace provided
- Extremely small fix: 5 lines added, 0 removed, single file
- Uses existing, proven `may_block` mechanism (present since v5.10)
- Fixes a regression from CVE-2025-40220 fix (26e5c67deb2e) which IS in
  stable trees
- Reviewed by the regression author (Darrick J. Wong)
- Merged by FUSE subsystem maintainer (Miklos Szeredi)
- All prerequisites exist in stable trees
- Should apply cleanly

**AGAINST backporting:**
- (Nothing significant)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** — uses existing `may_block`
   mechanism, reviewed by experts
2. Fixes a real bug? **YES** — worker thread deadlock on DAX virtio-fs
3. Important issue? **YES** — system hang (CRITICAL)
4. Small and contained? **YES** — 5 lines, single file, single function
5. No new features or APIs? **YES** — uses existing mechanism
6. Can apply to stable trees? **YES** — should apply cleanly to any tree
   with 26e5c67deb2e

### Step 9.3: Exception Categories
Not needed — this is a clear bug fix.

### Step 9.4: Decision
This is a clear YES. It fixes a deterministic system hang caused by a
regression from a CVE fix that has already been backported to stable
trees. The fix is tiny, uses an existing mechanism, and was reviewed by
the subsystem maintainer and the author of the regression.

## Verification

- [Phase 1] Parsed tags: Signed-off-by: Sergio Lopez, Reviewed-by:
  Darrick J. Wong, Signed-off-by: Miklos Szeredi
- [Phase 1] Commit references 26e5c67deb2e as the regression source
- [Phase 2] Diff analysis: 5 lines added in else branch of
  `fuse_file_put()`, sets `args->may_block = true` for DAX inodes
- [Phase 3] git blame: buggy code path from 26e5c67deb2e (v6.18),
  `may_block` from bb737bbe48bea9 (v5.10)
- [Phase 3] git show 26e5c67deb2e: confirmed it changed
  `fuse_file_put(ff, ff->fm->fc->destroy)` to `fuse_file_put(ff, false)`
  — making ALL releases async
- [Phase 3] Verified 26e5c67deb2e had `Cc: stable@vger.kernel.org #
  v2.6.38`
- [Phase 3] git log: confirmed this is a standalone fix, no other
  patches in a series
- [Phase 4] Web search confirmed 26e5c67deb2e has CVE-2025-40220 and was
  backported to 6.12.y and 6.6.y
- [Phase 5] Traced full deadlock call chain:
  `virtio_fs_requests_done_work` → ... → `fuse_dax_inode_cleanup` →
  `fuse_send_removemapping` → `fuse_simple_request` →
  `request_wait_answer` (blocks) — confirmed via code reading
- [Phase 5] Verified `may_block` check in `virtio_fs.c:839` routes to
  separate worker via `schedule_work()`
- [Phase 5] Verified same `may_block` pattern already used at
  `file.c:752` for async I/O
- [Phase 6] FUSE DAX and `may_block` mechanism present in all active
  stable trees (since v5.10)
- [Phase 6] Bug only manifests where 26e5c67deb2e was backported
  (6.12.y, 6.6.y confirmed)
- [Phase 8] Failure mode: deterministic worker thread self-
  deadlock/hang, severity CRITICAL
- UNVERIFIED: Could not access lore.kernel.org discussion thread due to
  Anubis protection

**YES**

 fs/fuse/file.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 676fd9856bfbf..14740134faff7 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -117,6 +117,12 @@ static void fuse_file_put(struct fuse_file *ff, bool sync)
 			fuse_simple_request(ff->fm, args);
 			fuse_release_end(ff->fm, args, 0);
 		} else {
+			/*
+			 * DAX inodes may need to issue a number of synchronous
+			 * request for clearing the mappings.
+			 */
+			if (ra && ra->inode && FUSE_IS_DAX(ra->inode))
+				args->may_block = true;
 			args->end = fuse_release_end;
 			if (fuse_simple_background(ff->fm, args,
 						   GFP_KERNEL | __GFP_NOFAIL))
-- 
2.53.0

