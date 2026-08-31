Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D3353B5FE;
	Mon, 31 Aug 2026 13:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183938; cv=none; b=fLrpkXL+5XqMSr2ykja8KLqHjdTSpq8yEOa7V6khDMnQDafE3PFZ3rK6UHEzBOVtcWWg+U/PZOlXkdawsxy/YdXA5IfSwbH5Iozg2QnoQcCr/0oekcDKCG/mZ0tSxuuDs8UGOpXU5GJTBezX/nx3tO6F9KvMg/vMrIvjSgMsFCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183938; c=relaxed/simple;
	bh=BWronw7LbUR+XzbnlxwneCzdZptZ7YifxLAIFekZ6h0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PAucpac3eMUskxjenHDp67yUwkpQlXzq1gqQGVrvBr9Idc1zDURIKf86OVKl43sU/YiaZp90aHrK9zg41yCK0fY4HWIu4YskrB06ajwwdZy4iRN2KdMxcVLOtHAI6Ac8zvUw+eMw2LsoVKb6INUcbarAjF8Iy7yZyxyf43LxC0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JVg88Wpx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JVg88Wpx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD041F00ACA;
	Mon, 31 Aug 2026 13:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183935;
	bh=nUjakMz7XCw/mM8U//7fZqVX+Mh5FMZMN57/lTdmwBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JVg88Wpx8v2sFH3iGgMTEuG0rftKS1DzSraoRRSNe2Hqxr4Z29+qGzZss57ujRwO2
	 8XwLces+tJdaK2uvv6sBZzgTnf1lqMkGXlnDB7ZPTt+s7SpbAVOmLhu4kZ+N4RyRiZ
	 RhINA8Zj1S9dT3jfWsx/qfty4INFbVamxWS2S1hBXmuKJjGYxcf9YihvfE5QGuDmwv
	 TktCsSsbaSvVYdgMFSPHv5iLHwQCXNlnA5QTAt3bWQOq1U9bwSilwTwvaveatIIwgI
	 UymCWgshCyGTlOGbFz5y+Q/A6I9nnAxqngnXkPPPRuwdSAA6HJ5ZmlrnvQcbu+2bUp
	 ob6Chckp3rRSQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] netfs: Fix decision whether to disallow write-streaming due to fscache use
Date: Mon, 31 Aug 2026 09:26:58 -0400
Message-ID: <20260831133314.4125787-390-sashal@kernel.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit b61cbeadaa83a712afb2f759aa7e65d43cdef322 ]

netfs_perform_write() buffers data by writing it into the pagecache for
later writeback.  If the folio it wants to write to isn't present, it uses
"write streaming" in which is will store partial data in a non-uptodate,
but dirty folio.

However, when fscache is in use, this is a potential problem as writes to
the cache have to be aligned to the cache backend's DIO granularity, and so
netfs_perform_write() attempts to suppress write-streaming in such a case,
requiring the folio content to be fetched first unless the entire folio is
going to be overwritten.  This allows the content to be written to the
cache too.

Unfortunately, the test netfs_perform_write() uses isn't correct because it
doesn't take into account the fact that the object lookup is asynchronous
and farmed off to a work queue, so there's a short window in which the
cache is doing a lookup but the test fails because the answer is undefined.

This can be triggered by the generic/464 xfstest, and causes a warning to
be emitted in cachefiles (in code not yet upstream) because it sees a write
that doesn't have its bounds rounded out to DIO alignment.

Fix this by changing the condition to whether FSCACHE_COOKIE_IS_CACHING is
set on a cookie rather than whether the cookie is marked enabled.  Note
that this is really just a hint as to whether we allow write streaming or
not and no other aspects of the cookie or cache object are accessed.

Also apply the same fix to netfs_write_begin().

Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260625140640.3116900-2-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[netfs] [fix] decision whether to disallow write-streaming
due to fscache use` — subsystem is netfs (network filesystem library /
fscache integration); action verb is "Fix"; intent is correcting the
condition that decides when write-streaming must be suppressed for
fscache DIO alignment.

### Step 1.2: Commit Message Tags
**Record:**
- **Reported-by:** Marc Dionne `<marc.dionne@auristor.com>` — real-world
  reporter (AuriStor/AFS ecosystem)
- **Signed-off-by:** David Howells `<dhowells@redhat.com>` — author,
  netfs/fscache maintainer
- **Signed-off-by:** Christian Brauner (Amutable) `<brauner@kernel.org>`
  — VFS maintainer merge
- **Link:**
  https://patch.msgid.link/20260625140640.3116900-2-dhowells@redhat.com
- **cc:** Paulo Alcantara, netfs@lists.linux.dev, linux-
  fsdevel@vger.kernel.org
- No Fixes:, Cc: stable@vger.kernel.org, Tested-by:, Reviewed-by:, or
  syzbot tags
- Notable: single real-world reporter; patch is part of a June 2026
  netfs fix series (sibling patches already in this tree)

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** `netfs_perform_write()` and `netfs_write_begin()` use
  `netfs_is_cache_enabled()` to decide whether to suppress write-
  streaming when fscache is active. That helper requires
  `cookie->cache_priv`, but fscache object lookup is asynchronous
  (queued to a worker). During the lookup window,
  `FSCACHE_COOKIE_IS_CACHING` is already set but `cache_priv` is not yet
  populated.
- **Symptom:** Write-streaming proceeds when it should not; cachefiles
  sees writes whose bounds are not rounded to DIO granularity.
  Reproducible via xfstests `generic/464`; triggers a warning in
  cachefiles (per commit message).
- **Root cause:** Test checks "cache enabled" (needs `cache_priv`)
  instead of "cache is being set up / caching"
  (`FSCACHE_COOKIE_IS_CACHING`).
- **Fix:** New `netfs_is_cache_maybe_enabled()` checks
  `FSCACHE_COOKIE_IS_CACHING`; used in both write paths.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Not disguised — this is an explicit correctness fix for a
race between async fscache lookup and write-streaming policy. The commit
message clearly describes mechanism, trigger, and failure mode.

---

## Phase 2: Diff Analysis

### Step 2.1: Change Inventory
**Record:**
- `fs/netfs/internal.h`: +12 lines (new `netfs_is_cache_maybe_enabled()`
  inline)
- `fs/netfs/buffered_write.c`: 1 line changed (`netfs_is_cache_enabled`
  → `netfs_is_cache_maybe_enabled`)
- `fs/netfs/buffered_write.c` function: `netfs_perform_write()`
- `fs/netfs/buffered_read.c`: 1 line changed; function:
  `netfs_write_begin()`
- **Scope:** Single-subsystem, surgical fix (~16 lines total)

### Step 2.2: Code Flow Change
**Record:**
- **Hunk 1 (`buffered_write.c`):** Before: if `cookie->cache_priv` unset
  during async lookup, streaming write allowed on non-uptodate folio.
  After: if `FSCACHE_COOKIE_IS_CACHING` is set (set at lookup start in
  `fscache_begin_lookup()`), prefetch path is taken instead of streaming
  write.
- **Hunk 2 (`buffered_read.c`):** Before: during lookup window,
  `!netfs_is_cache_enabled()` is true, so `netfs_skip_folio_read()` may
  skip required preload of cache granule. After:
  `!netfs_is_cache_maybe_enabled()` is false during lookup, so
  read/preload proceeds correctly.
- **Hunk 3 (`internal.h`):** Adds helper using only
  `fscache_cookie_valid()` + `FSCACHE_COOKIE_IS_CACHING` bit — no
  `cache_priv` dereference.

### Step 2.3: Bug Mechanism
**Record:** **Category:** Race condition / logic correctness bug in
fscache integration.
- `fscache_begin_lookup()` sets `FSCACHE_COOKIE_IS_CACHING` immediately
  (line 560 of `fscache_cookie.c`)
- `cookie->cache_priv` is set later in `cachefiles_lookup_cookie()`
  worker (line 193 of `fs/cachefiles/interface.c`)
- Old `netfs_is_cache_enabled()` requires `cache_priv`, so returns false
  during the lookup race window
- Result: write-streaming with unaligned partial folio data incompatible
  with fscache DIO requirements

### Step 2.4: Fix Quality
**Record:** Fix is minimal and logically sound — uses the same
`FSCACHE_COOKIE_IS_CACHING` flag that `fscache_begin_cookie_access()`
relies on. Commit notes this is intentionally a "hint" with no other
cookie state accessed. Low regression risk; aligns with already-
backported sibling fix `8ab75e445c161` from the same series.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** `netfs_is_cache_enabled()` and its use in
`buffered_write.c`/`buffered_read.c` introduced in `5d324e5159d9e` (6.18
merge, Nov 2025). The async lookup path setting
`FSCACHE_COOKIE_IS_CACHING` before `cache_priv` is populated has been
present since the fscache rewrite landed in 6.18. Bug present in this
tree since 6.18.

### Step 3.2: Fixes: Tag
**Record:** No Fixes: tag present — N/A.

### Step 3.3: Related File History
**Record:** Recent netfs fixes in this tree include multiple stable
backports from the same June 2026 series:
- `8ab75e445c161` — async cache object creation in
  `netfs_create_write_req()` (patch -3 of series)
- `7838131e296df`, `1bb33d959aabc`, `a9b89752c2726` — writeback fixes
  from same msgid thread
- Target commit `046acff3d6cd0` (upstream `b61cbeadaa83`) is patch -2;
  **not yet in this tree**
- Standalone fix — no "patch X/Y" dependency; sibling -3 already present

### Step 3.4: Author Context
**Record:** David Howells is the netfs/fscache subsystem
author/maintainer. Multiple related netfs stable fixes from him are
already in 6.18.44.

### Step 3.5: Dependencies
**Record:** No hard prerequisites beyond code already in 6.18.44.
`FSCACHE_COOKIE_IS_CACHING` exists in `include/linux/fscache.h` (bit 2).
`git apply --check` on the patch succeeds cleanly against HEAD.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:** `b4 dig -c 046acff3d6cd0` →
https://patch.msgid.link/20260625140640.3116900-2-dhowells@redhat.com.
`b4 dig -a` returned only one revision (no multi-version history in
cache). Lore fetch blocked by Anubis bot protection — full thread
content UNVERIFIED.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` returned same URL only; detailed recipient list
UNVERIFIED. Merged by Christian Brauner; CC'd netfs and linux-fsdevel
lists.

### Step 4.3: Bug Report
**Record:** Reported-by Marc Dionne (AuriStor). Trigger: xfstests
`generic/464`. Failure: cachefiles warning on non-DIO-aligned write
bounds. No syzbot/bugzilla link.

### Step 4.4: Related Patches
**Record:** Same series (`20260625140640.3116900-*`): patches -3, -4,
-5, -6 already backported to this tree; patch -2 (this commit) is the
missing piece addressing write-streaming during async lookup.

### Step 4.5: Stable List
**Record:** UNVERIFIED — could not search lore stable list due to bot
protection. Commit was committed to stable queue by Sasha Levin on a
separate branch (`autosel~217`) but is NOT in current 6.18.44 HEAD.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Modified Functions
**Record:** `netfs_is_cache_maybe_enabled()` (new),
`netfs_perform_write()`, `netfs_write_begin()`

### Step 5.2: Callers
**Record:**
- `netfs_perform_write()` ← `netfs_buffered_write_iter_locked()` ←
  `netfs_file_write_iter()`
- `netfs_file_write_iter` used by AFS (`fs/afs/file.c`) and CIFS/SMB
  (`fs/smb/client/cifsfs.c`)
- `netfs_write_begin()` is deprecated but still present; called from
  legacy write_begin paths
- Reachable from normal userspace `write()`/`pwrite()` syscalls on
  fscache-enabled network filesystems

### Step 5.3: Callees
**Record:** In fixed path: `netfs_prefetch_for_write()`,
`copy_folio_from_iter_atomic()`, `netfs_begin_cache_read()`,
`netfs_alloc_request()` — standard buffered-write helpers.

### Step 5.4: Reachability
**Record:** Trigger requires CONFIG_FSCACHE + cachefiles backend + netfs
client (AFS, CIFS with fscache, etc.) + write to non-uptodate folio
during or just after first cookie lookup. Userspace writes are the
trigger — realistic for fscache deployments.

### Step 5.5: Similar Patterns
**Record:** Same class of bug fixed in `8ab75e445c161` for
`netfs_create_write_req()` — premature "cache not enabled" check before
async lookup completes. Systematic issue in netfs/fscache integration.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Local tree is `v6.18.44` (Makefile VERSION=6,
PATCHLEVEL=18, SUBLEVEL=44). Current HEAD `2736c32da98b9` does NOT
contain the fix (`git merge-base --is-ancestor 046acff3d6cd0 HEAD` → NOT
IN TREE). Buggy `netfs_is_cache_enabled(ctx)` calls confirmed at
`buffered_write.c:281` and `buffered_read.c:663`.

### Step 6.2: Backport Complications
**Record:** Clean apply verified (`git apply --check` passes). No
refactoring conflicts expected.

### Step 6.3: Related Fixes Already Present?
**Record:** Sibling fix `8ab75e445c161` (same series, async cache
creation) already in tree. This commit is the complementary fix for
write-streaming/write_begin paths — not redundant.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem Criticality
**Record:** **IMPORTANT** — netfs library used by AFS, CIFS/SMB, and
other network filesystems. fscache/cachefiles provides local caching.
Affects data path integrity for enterprise/embedded deployments using
fscache.

### Step 7.2: Activity
**Record:** Highly active — 20+ netfs stable fixes already in 6.18.44,
indicating ongoing stabilization of the new fscache/netfs stack
introduced in 6.18.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users with CONFIG_FSCACHE and cachefiles enabled on netfs-
backed filesystems (AFS, CIFS with fscache volume). Not universal, but
real production deployments (AuriStor reported).

### Step 8.2: Trigger Conditions
**Record:** Write to a file whose fscache cookie is in
`FSCACHE_COOKIE_STATE_LOOKING_UP` (async lookup in progress). Timing-
dependent but reproducible (`generic/464` xfstest). Unprivileged users
can trigger via normal file writes.

### Step 8.3: Failure Mode Severity
**Record:** Misaligned partial writes to fscache backend; cachefiles
WARN on DIO alignment violation. Risk of incorrect cache content / cache
coherency issues. **Severity: MEDIUM-HIGH** (not a kernel panic, but
cache data integrity issue with real test reproducer).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH for fscache users — closes race that defeats write-
  streaming suppression, complements already-backported series fixes
- **Risk:** LOW — 16-line change, uses established flag, applies
  cleanly, no API changes
- **Ratio:** Strongly favors backport

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real bug with documented race (async lookup vs. `cache_priv` check)
- Reproducible via xfstests `generic/464`
- Reported by production fscache user (Marc Dionne / AuriStor)
- Causes incorrect write-streaming → fscache DIO alignment violations
- Small, surgical, obviously correct fix
- Applies cleanly to 6.18.44
- Sibling patches from same series already in this stable tree
- David Howells (subsystem maintainer) authored fix

**AGAINST backport:**
- Only affects CONFIG_FSCACHE + cachefiles users (subset of users)
- Primary visible symptom described as cachefiles WARN (not oops/panic)
- Full mailing list review discussion UNVERIFIED

**UNRESOLVED:**
- Full lore thread content (bot-blocked)
- Whether stable list already discussed this specific patch

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic verified against
   `fscache_begin_lookup()` / `cachefiles_lookup_cookie()` code; xfstest
   reproducer cited
2. Fixes a real bug affecting users? **PASS** — Marc Dionne report +
   xfstests
3. Important issue? **PASS** — cache data integrity / incorrect fscache
   writes (MEDIUM-HIGH)
4. Small and contained? **PASS** — 3 files, ~16 lines
5. No new features or APIs? **PASS** — internal helper only
6. Can apply to local tree? **PASS** — verified clean apply

### Step 9.3: Exception Categories
**Record:** None (not device ID, quirk, DT, build fix, or docs).
Standard bug fix.

### Step 9.4: Decision Rationale

For **linux-6.18.y** (this checkout at v6.18.44): the buggy code is
present, the async fscache lookup race is real and verified in source,
related fixes from the same patch series are already in this tree, and
the fix is minimal with clear benefit for fscache users. This is
appropriate stable material — a correctness fix for the 6.18
fscache/netfs stack that prevents misaligned cache writes during the
async cookie lookup window.

---

## Verification

- [Phase 1] Parsed commit message from `git show 046acff3d6cd0`:
  subject, tags, body
- [Phase 2] Diff analysis: 3 files, 14 insertions/2 deletions; read
  current `buffered_write.c:277-298`, `buffered_read.c:659-667`,
  `internal.h:230-240`
- [Phase 3] `git blame` on `internal.h:230-240` → introduced
  `5d324e5159d9e` (6.18)
- [Phase 3] `git log --oneline -30 -- fs/netfs/` → sibling fixes
  present, target commit absent
- [Phase 3] `git merge-base --is-ancestor 046acff3d6cd0 HEAD` → NOT IN
  TREE
- [Phase 3] `git log --oneline --grep="20260625140640"` → 4 related
  series commits in tree, this one missing
- [Phase 4] `b4 dig -c 046acff3d6cd0` → lore URL found
- [Phase 4] `b4 dig -a` → single revision
- [Phase 4] WebFetch lore URL → BLOCKED (Anubis)
- [Phase 5] `grep netfs_file_write_iter` → AFS, CIFS callers confirmed
- [Phase 5] Read `fscache_cookie.c:548-562` →
  `FSCACHE_COOKIE_IS_CACHING` set before async lookup completes
- [Phase 5] Read `cachefiles/interface.c:177-193` → `cache_priv` set in
  worker
- [Phase 6] `git describe HEAD` → v6.18.44; Makefile confirms 6.18.44
- [Phase 6] `git apply --check` on patch → applies cleanly
- [Phase 6] Grep confirms buggy `netfs_is_cache_enabled(ctx)` at lines
  281 and 663
- [Phase 7] `fs/netfs/Kconfig` confirms CONFIG_FSCACHE exists
- [Phase 8] Assessed severity from commit message + code path analysis
- UNVERIFIED: Full lore review thread content; stable@ mailing list
  prior discussion

**YES**Two background git commands timed out on this repo (`git branch
-a --contains` and a broad `-S` pickaxe search). I killed them and got
the same answers other ways:

- The fix commit resolves to `autosel~217` (not in current 6.18.44
  HEAD).
- `netfs_is_cache_enabled` landed with the 6.18 netfs/fscache work
  (`5d324e5159d9e` / `8ab75e445c161`).

That doesn’t change the earlier conclusion: backport **YES** for 6.18.y
— small fix for an async fscache lookup race, applies cleanly, and
sibling patches from the same series are already in the tree.

 fs/netfs/buffered_read.c  |  2 +-
 fs/netfs/buffered_write.c |  2 +-
 fs/netfs/internal.h       | 12 ++++++++++++
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 221287f8925a9..cccc860893f0a 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -660,7 +660,7 @@ int netfs_write_begin(struct netfs_inode *ctx,
 	 * within the cache granule containing the EOF, in which case we need
 	 * to preload the granule.
 	 */
-	if (!netfs_is_cache_enabled(ctx) &&
+	if (!netfs_is_cache_maybe_enabled(ctx) &&
 	    netfs_skip_folio_read(folio, pos, len, false)) {
 		netfs_stat(&netfs_n_rh_write_zskip);
 		goto have_folio_no_wait;
diff --git a/fs/netfs/buffered_write.c b/fs/netfs/buffered_write.c
index dd0ce7b769ce0..0f61746bee2ac 100644
--- a/fs/netfs/buffered_write.c
+++ b/fs/netfs/buffered_write.c
@@ -278,7 +278,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 		 * caching service temporarily because the backing store got
 		 * culled.
 		 */
-		if (netfs_is_cache_enabled(ctx)) {
+		if (netfs_is_cache_maybe_enabled(ctx)) {
 			if (finfo) {
 				netfs_stat(&netfs_n_wh_wstream_conflict);
 				goto flush_content;
diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index 645996ecfc803..d889caa401dc2 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -239,6 +239,18 @@ static inline bool netfs_is_cache_enabled(struct netfs_inode *ctx)
 #endif
 }
 
+static inline bool netfs_is_cache_maybe_enabled(struct netfs_inode *ctx)
+{
+#if IS_ENABLED(CONFIG_FSCACHE)
+	struct fscache_cookie *cookie = ctx->cache;
+
+	return fscache_cookie_valid(cookie) &&
+		test_bit(FSCACHE_COOKIE_IS_CACHING, &cookie->flags);
+#else
+	return false;
+#endif
+}
+
 /*
  * Get a ref on a netfs group attached to a dirty page (e.g. a ceph snap).
  */
-- 
2.53.0

