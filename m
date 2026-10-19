Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D432603184;
	Mon, 19 Oct 2026 14:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418595; cv=none; b=aUnpdnKgPRxLR+KEXPApGppBuLPJCMKUqxA0/1M+dotZW+lXSbYtCBg9ESZbqVMDIBwh2zR0qC/1aW0vmtYFXj/4PAe/kbV8EincIhcK3rAx+/TBuplZ2AajuTJw8gqObmvLYZlnNPMiFeeEDVfMhD1JLTbh+YAgtMI6g/3/nYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418595; c=relaxed/simple;
	bh=mcRr6LrbaxMg040FMMP22PLFb87DbvCCOqm4F87lmm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cyoc3xWD1tBef49ZRgDq4EmY17syvGjw/pQYgh37ArkmFNcH2hAJiav9xdrtHAbJh8YjsIiZdQ1Y69ygiuGvySzBUdsbXizIlHuVUjbeDBORcZxerHOJATQ23MtMYumon//sP/m91qQNvtYpIYqlwt3iMiNsuHxldbhlJRivhBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CGCPml05; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CGCPml05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2798E1F000C4;
	Mon, 19 Oct 2026 14:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418592;
	bh=eIwmmsrxddpO5P8aeETLYCt/NLH6/c+bYbOwhVgcEL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CGCPml052cLvtkb1VPeuKkpX6w9nqkZL91yjdF+WW3DPNpCu6znRs58xgVIIpyHJD
	 heVO5959Hi3B1BlcYT68M2fXIwaVFbMvhz1YK2iwvoS9oXrEbEPrCbbYiKfauCpxTH
	 Gq6Zw1EgNFz47Np2iP/UCH8wzANLxckbfXreLOBfJaBjy8T/UDrRX9foqMUv4wIKh2
	 grUlJYDGSN9AmQW1TOSZvM64ywvqW2iHvBdOTBjoV+lzgEdnmkDPobubvrdK3zRJCL
	 i8GQ0Ewl+lX14znL+JCOBEQuWE96b4lkUW6OahI7O2HF/CYkuFU6GKbVH9gtNAsqSg
	 AFRCx4UO2LIxA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Michael Reeves <michael.reeves077@gmail.com>,
	Peng Fan <peng.fan@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	linux-kernel@vger.kernel.org,
	driver-core@lists.linux.dev
Subject: [PATCH AUTOSEL 6.18-6.12] regmap: Remove debugfs before cache teardown
Date: Mon, 19 Oct 2026 09:50:48 -0400
Message-ID: <20261019135441.1420968-357-sashal@kernel.org>
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

From: Michael Reeves <michael.reeves077@gmail.com>

[ Upstream commit 834035934cef9e60169de682f4dc9feafd49e51a ]

regmap_exit() and regmap_reinit_cache() destroy the register cache before
removing debugfs. A concurrent debugfs cache operation can therefore
access cache state after the backend exit callback starts freeing it.

Remove debugfs before cache teardown, and clear the debugfs pointer after
removal. During cache reinitialization, recreate debugfs only after the
new cache initializes successfully.

Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Link: https://patch.msgid.link/20261006-regcache-lifecycle-submit-v3-1-37bdd82fd47c@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.57**. The buggy teardown order is present at
`v6.18.57`; this commit is a small UAF-lifecycle fix that applies here
and should be backported.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[regmap] [Remove] Remove debugfs before cache teardown`

- Subsystem: `regmap` (drivers/base/regmap)
- Verb: “Remove” — here it is a lifecycle reorder, not a feature
  deletion
- Intent: tear down debugfs *before* the register cache so concurrent
  debugfs cache ops cannot touch freed cache state

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Reviewed-by: Peng Fan <peng.fan@nxp.com>` — NXP reviewer, active on
  regmap
- `Link: https://patch.msgid.link/20261006-regcache-lifecycle-
  submit-v3-1-37bdd82fd47c@gmail.com`
- `Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>` (author)
- `Signed-off-by: Mark Brown <broonie@kernel.org>` (regmap maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Acked-by:`, or `Cc:
  stable` (absence is expected for this review)
- Ignored pipeline markers: `[Upstream commit 834035934cef…]`, `Signed-
  off-by: Sasha Levin`

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `regmap_exit()` and `regmap_reinit_cache()` call
  `regcache_exit()` *before* `regmap_debugfs_exit()`. A concurrent
  debugfs cache operation can then run after the backend `exit` callback
  has started freeing cache memory.
- **Symptom:** use-after-free / invalid cache access from debugfs
  (registers dump, rbtree dump, `cache_only` sync).
- **Root cause:** debugfs lifetime is not drained before cache teardown.
  `debugfs_remove_recursive()` is the drain point and must run first.
- **Fix:** remove debugfs first; NULL `map->debugfs` after removal; on
  reinit, recreate debugfs only after `regcache_init()` succeeds.
- **Versions:** none named. Blame shows this order has existed since
  2011–2012.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised. It is an explicit UAF/lifecycle fix. The reinit
change also closes a second hole: old code recreated debugfs *before*
the new cache existed, so `cache_ops->debugfs_init` / cache dumps could
run against a destroyed cache.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- `drivers/base/regmap/regmap-debugfs.c`: +1 (`map->debugfs = NULL`)
- `drivers/base/regmap/regmap.c`: +9 / −6
- Functions: `regmap_debugfs_exit()`, `regmap_reinit_cache()`,
  `regmap_exit()`
- Scope: surgical, two files, net +4 lines in this tree (`1/0` and
  `9/6`)

Mainline context in the submission has `debugfs_dummy_id` / `dummy_ida`;
this 6.18 tree does not. The functional hunks are the same and already
applied as `944c051717d77`.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:

Hunk 1 — `regmap_debugfs_exit()`:
- Before: `debugfs_remove_recursive(map->debugfs)` left a stale dentry
  pointer.
- After: `map->debugfs = NULL` immediately after removal.

Hunk 2 — `regmap_reinit_cache()`:
- Before: `regcache_exit` → `regmap_debugfs_exit` →
  `regmap_debugfs_init` → `regcache_init`.
- After: `regmap_debugfs_exit` → `regcache_exit` → `regcache_init` → on
  success `regmap_debugfs_init`. Failed cache init leaves debugfs down
  instead of exposing a dead cache.

Hunk 3 — `regmap_exit()`:
- Before: `regcache_exit` then `regmap_debugfs_exit`.
- After: reverse that order.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **(d) Memory safety / UAF** plus **(g) lifecycle correctness**.

Verified mechanism:
- `regcache_rbtree_exit()` does `kfree(map->cache); map->cache = NULL`.
- `rbtree_show()` does `rbtree_ctx = map->cache` then walks
  `rbtree_ctx->root` under the map lock.
- `regmap_read_debugfs()` calls `regmap_read()`, which can hit
  `regcache_read()` / `cache_ops`.
- `regmap_cache_only_write_file()` can call `regcache_sync()` on a
  destroyed cache.

`debugfs_remove_recursive()` waits for in-flight file ops
(`debugfs_file_get` / `active_users_drained` in `fs/debugfs/file.c`).
Calling it *after* `regcache_exit()` is the wrong order: ops already in
flight (or still open until remove starts) can touch freed cache.
Calling it first drains those ops, then the cache can be freed.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct. Standard “remove debugfs, then free private
data” pattern. No API/data-structure change.
`debugfs_remove_recursive()` already sleeps, so moving it earlier does
not add a new sleep-in-atomic constraint. Reinit already documents that
callers must serialize against other *regmap* calls; this still
serializes *userspace* debugfs, which the driver cannot.

Regression risk: **low**. Failed `regcache_init()` now skips debugfs
recreate (debugfs stays gone). That is safer than the old “debugfs live,
cache dead/uninitialized” window.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record (on parent of `944c051717d77`):
- `regcache_exit` before debugfs in `regmap_reinit_cache`:
  `bf315173359b2` (Mark Brown, 2011-12-03)
- `regmap_debugfs_exit` added there: `a24f64a6483767` (2012-01-26)
- `regcache_exit` before debugfs in `regmap_exit`: `5d1729e7f02f05`
  (2011-09-19) then `31244e396fa9e4` (2011-07-20)
- `debugfs_remove_recursive` without NULL: `a52eaeb1898bc0` (2013-10-24)

The buggy order is ancient and is in this 6.18 tree.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Not applicable. Introduced with original regmap
debugfs/cache teardown, not a recent regression.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- `530792efa6cb8` “regmap: Call regmap_debugfs_exit() prior to _init()”
  — same “debugfs off before reuse” idea.
- `9f711c9321cff` “regmap: get rid of redundant
  debugfs_file_{get,put}()” — debugfs core now owns the drain; this
  patch is the remaining lifecycle piece.
- This is **patch 1/2** of “regmap: Fix cache lifecycle locking and
  teardown”. Patch 2 (“Drop map lock during cache init and exit”) is a
  **separate lockdep** fix (`Fixes: fd4ebc07b4df`). Patch 2’s upstream
  `abff0a48b110` is **not** in this tree and is **not** a prerequisite
  for patch 1.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Only this commit by Michael Reeves under `drivers/base/regmap/`
in this tree. Not the subsystem maintainer. Applied by **Mark Brown**.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Standalone. Uses existing `regmap_debugfs_exit` /
`regcache_exit` / `regcache_init`. Dummy-ida context from later mainline
is absent here and is not required.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 944c051717d77` →
  https://patch.msgid.link/20261006-regcache-lifecycle-
  submit-v3-1-37bdd82fd47c@gmail.com
- Revisions:
  - v1 (2026-09-25): lockdep-only, no debugfs reorder
  - v2 (2026-10-04): added this debugfs ordering fix
  - v3 (2026-10-06): this version; maple irqsave helpers are **patch 2
    only**
- Peng Fan: `Reviewed-by` on patch 1; no NAK
- Mark Brown applied both to `broonie/regmap.git for-7.3`
  (`834035934cef`, `abff0a48b110`)
- No reviewer asked for `Cc: stable`
- Cover letter testing (Apple M3, lockdep, KUnit) is mainly for patch 2;
  patch 1 is justified by code inspection

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): Mark Brown, Greg Kroah-Hartman, Rafael Wysocki,
Danilo Krummrich, Liam Howlett; lists: linux-kernel, driver-core, maple-
tree, asahi, linux-mm. Subsystem maintainer received and applied it.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot, bugzilla, or user crash report. Bug is from code
analysis of teardown vs debugfs.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Series of 2. This patch does not depend on maple irqsave helpers
or dropping the map lock. Patch 2 is a different bug (lockdep during
Apple GPIO probe).

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: No stable-list discussion found (lore.kernel.org returned 403;
searches did not hit this subject). UNVERIFIED beyond that negative
search.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `regmap_debugfs_exit`, `regmap_reinit_cache`, `regmap_exit`
(callers of `regcache_exit` / debugfs init).

**Step 5.2: TRACE CALLERS**
Record:
- `regmap_exit()`: many drivers (ASoC via
  `snd_soc_component_exit_regmap`, HDA, MFD, media/DVB, IIO, input, USB,
  leds, syscon, kunit, `devres` cleanup). Common unbind/remove path.
- `regmap_reinit_cache()`: ASoC (mt8192/mt8183, tas2764/tas2770, da7219,
  ssm3515), MFD (wm8994, wm8400), IIO (kx022a, several light/pressure
  sensors), pinctrl-aw9523. Probe/runtime rediscovery.
- `regmap_debugfs_exit()` also from `regmap_attach_dev()` (already exit-
  then-init) and `__regmap_init` error paths.

**Step 5.3: TRACE CALLEES**
Record: `debugfs_remove_recursive` (sleeps until file ops drain),
`regmap_debugfs_free_dump_cache`, `regcache_exit` → `cache_ops->exit`
(rbtree/maple/flat free `map->cache`).

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Reachable from userspace:
1. Open `/sys/kernel/debug/regmap/<dev>/registers` or `rbtree`
2. Concurrent unbind / module unload / `regmap_reinit_cache()`
3. Old order frees cache while the read can still run → UAF

Needs `CONFIG_DEBUG_FS` (stubs make this a no-op otherwise) and
typically debugfs access (often root). Distro/Android kernels commonly
enable debugfs.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Only rbtree implements `cache_ops->debugfs_init` here.
Maple/flat have no extra debugfs file, but the shared `registers` /
`cache_only` files still go through the cache. Same class of bug as
other “remove debugfs before free private data” fixes.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** `git describe HEAD` = `v6.18.57-155-gcdf239ca885b2`.
`make kernelversion` = `6.18.57`. At tag `v6.18.57`,
`regmap_exit`/`regmap_reinit_cache` still call `regcache_exit` first.
`git merge-base --is-ancestor 944c051717d77 v6.18.57` is false — the fix
is not in the 6.18.57 baseline.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply.** Candidate `944c051717d77` applied here with
only missing dummy-ida context vs mainline. No refactor blocking it.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No other commit in this tree reorders cache vs debugfs teardown.
Patch 2 is absent and not required.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `drivers/base/regmap` — **IMPORTANT/CORE-adjacent**. Shared
register cache for ASoC, MFD, IIO, pinctrl, regulators, etc.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature (2011+) and still actively maintained by Mark Brown. This
is a long-standing lifecycle bug, not a brand-new subsystem.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Any user with `CONFIG_REGMAP` + `CONFIG_DEBUG_FS` and a cached
regmap. Driver-specific devices, but the core path is widely used. No-op
if debugfs is off.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Concurrent debugfs access during
`regmap_exit`/`regmap_reinit_cache`. Timing-dependent. Typical trigger
is root/debugfs; unprivileged access depends on debugfs mount mode.
Unbind during a dump is realistic (USB audio, codec remove, module
unload).

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Use-after-free of cache memory → oops or memory corruption.
**HIGH** (UAF). Not a guaranteed panic on every unbind; still a real
memory-safety bug.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** Prevents UAF on a common infrastructure path when debugfs
  is used around teardown/reinit.
- **Risk:** Very low — ~10 lines, order swap + NULL + delayed debugfs
  recreate.
- **Ratio:** Favor backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real UAF: cache freed while debugfs files can still run
  (`rbtree_show`, `regmap_read_debugfs`, `regcache_sync` from
  `cache_only`)
- `debugfs_remove_recursive()` is the documented drain; it must run
  before `regcache_exit`
- Bug present in this 6.18.57 tree since 2011–2012
- Small, obviously correct, reviewed, applied by the regmap maintainer
- Applies cleanly; no dependency on patch 2
- Hidden extra fix: do not recreate debugfs on a not-yet-initialized
  cache

AGAINST:
- No syzbot/user report
- Needs debugfs and concurrent teardown
- Series patch 1/2 (but self-contained)
- Maintainer queued it for 7.3, not as an emergency -fixes drop
- No `Cc: stable` (not a negative per these rules)

UNRESOLVED:
- lore.kernel.org HTTP 403; thread recovered via `b4 dig` + LKML mirrors
- No stable-list thread found

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — order is the documented
   debugfs lifetime rule; v3 reviewed; KUnit mentioned in the series;
   maintainer applied it
2. Fixes a real bug that affects users? **PASS** — UAF on debugfs vs
   cache teardown
3. Important issue? **PASS** — UAF/oops, HIGH; not a style change
4. Small and contained? **PASS** — 2 files, ~10 net lines
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — clean against 6.18.57

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not an ID/quirk/DT/build/docs exception. Ordinary memory-safety
fix.

**Step 9.4: MAKE YOUR DECISION**
Backport. The bug exists in this tree, the fix is the correct lifecycle,
and risk is minimal. Debugfs-only does not make a UAF incommensurate
with stable: CONFIG_DEBUG_FS is common, and `regmap_exit` runs on
ordinary unbind.

What it solves for stable users: a use-after-free if debugfs is used
while a cached regmap is torn down or its cache is reinitialized. That
is a crash/corruption class bug in widely used driver-core code.

Risk vs benefit: large benefit relative to a four-line-class reorder. No
public API change. Patch 2 is not required.

===============================================================
Verification
===============================================================
- [Phase 1] Parsed tags: Reviewed-by Peng Fan; Link msgid; SOB Reeves +
  Mark Brown; no Fixes/Reported-by/Cc-stable
- [Phase 2] Diff: +NULL after `debugfs_remove_recursive`; swap
  `regcache_exit`/`regmap_debugfs_exit` in exit and reinit; delay
  `regmap_debugfs_init` until `regcache_init` succeeds
- [Phase 2] `regcache_rbtree_exit` kfree’s `map->cache`; `rbtree_show`
  dereferences it — UAF confirmed in this tree
- [Phase 2] `fs/debugfs/file.c`: `debugfs_remove_recursive` waits on
  `debugfs_file_get` / `active_users_drained`
- [Phase 3] Blame: teardown order from 2011–2012 (Brown/Papastamos)
- [Phase 3] `git merge-base --is-ancestor 944c051717d77 v6.18.57` → not
  in 6.18.57 baseline
- [Phase 3] Patch 2 `abff0a48b110` not an ancestor of HEAD; not a
  prerequisite
- [Phase 3] `fd4ebc07b4df` is in HEAD (only relevant to patch 2)
- [Phase 4] `b4 dig -c 944c051717d77`: lore msgid 20261006-regcache-
  lifecycle-submit-v3-1-…
- [Phase 4] `b4 dig -a`: v1 lockdep-only → v2 added this fix → v3
  applied
- [Phase 4] `b4 dig -w`: Mark Brown, driver-core, Greg KH CC’d; Peng Fan
  Reviewed-by; Mark applied to for-7.3
- [Phase 4] lore.kernel.org WebFetch 403; used b4 mbox + lkml.iu.edu
- [Phase 5] Callers: many `regmap_exit` sites; `regmap_reinit_cache` in
  ASoC/MFD/IIO/pinctrl
- [Phase 6] `git describe HEAD` = v6.18.57-155-gcdf239ca885b2; `make
  kernelversion` = 6.18.57; buggy order present at v6.18.57
- [Phase 6] Candidate diff vs this tree is clean (no dummy_ida here)
- [Phase 8] Failure mode: UAF → oops/corruption, HIGH; trigger: debugfs
  + teardown
- UNVERIFIED: no stable@ thread located (search did not find this
  subject)

**YES**

 drivers/base/regmap/regmap-debugfs.c |  1 +
 drivers/base/regmap/regmap.c         | 15 +++++++++------
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index c9b4c04b1cf60..98debe5020641 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -657,6 +657,7 @@ void regmap_debugfs_exit(struct regmap *map)
 {
 	if (map->debugfs) {
 		debugfs_remove_recursive(map->debugfs);
+		map->debugfs = NULL;
 		mutex_lock(&map->cache_lock);
 		regmap_debugfs_free_dump_cache(map);
 		mutex_unlock(&map->cache_lock);
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index a648218507236..b80bbe9033188 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1424,8 +1424,8 @@ int regmap_reinit_cache(struct regmap *map, const struct regmap_config *config)
 {
 	int ret;
 
-	regcache_exit(map);
 	regmap_debugfs_exit(map);
+	regcache_exit(map);
 
 	map->max_register = config->max_register;
 	map->max_register_is_set = map->max_register ?: config->max_register_is_0;
@@ -1441,12 +1441,16 @@ int regmap_reinit_cache(struct regmap *map, const struct regmap_config *config)
 	if (ret)
 		return ret;
 
-	regmap_debugfs_init(map);
-
 	map->cache_bypass = false;
 	map->cache_only = false;
 
-	return regcache_init(map, config);
+	ret = regcache_init(map, config);
+	if (ret)
+		return ret;
+
+	regmap_debugfs_init(map);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(regmap_reinit_cache);
 
@@ -1460,9 +1464,8 @@ void regmap_exit(struct regmap *map)
 	struct regmap_async *async;
 
 	regmap_detach_dev(map->dev, map);
-	regcache_exit(map);
-
 	regmap_debugfs_exit(map);
+	regcache_exit(map);
 	regmap_range_exit(map);
 	if (map->bus && map->bus->free_context)
 		map->bus->free_context(map->bus_context);
-- 
2.53.0

