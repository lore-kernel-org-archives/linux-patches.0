Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE65C3C2774;
	Mon, 20 Apr 2026 13:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691608; cv=none; b=sQ2PVBsqhxgV0OGIAT2mq7j/oTFgl+q71dCqfYubYcwAnjAgcXZWYqlpI+EXaoV94nYCIYbCPnTXqeqbPU0jFVVP2hxrzWQQOShRF1MuFczsYLNchKD+r5qmlj2+W75kDk8xhgNDsyJO7bFJIhoxZ25XQN/SdgQeMWw+aLGpkQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691608; c=relaxed/simple;
	bh=zNaoH0AUU3IETA0aOc1dRkhTGox/YjeGvMQCoQ0m/1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y7Wrb+u4bOHofBGU3M+EAG9ZW4CrAwJGcj5RNsgiLZhYh5+dIoB3QIwRcIwhTaA+1t9Hocex0WiUHyNv9ydBwMhq7jUugE0sYI/LxgZE9awxiq5rHWJ9cA5AOSGFzOGru84K/2vq2lI1cM2pNAnig02qgReT4VM4JBPLHnAlbJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tYB/7ThB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tYB/7ThB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611AAC2BCB7;
	Mon, 20 Apr 2026 13:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691608;
	bh=zNaoH0AUU3IETA0aOc1dRkhTGox/YjeGvMQCoQ0m/1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tYB/7ThBZW/htnFAEUMb0jnbtJpS4ONCEXDmPBFRljT9fCeqUFhuKAGzvsWZfTY1w
	 oP72y1mtwOVNS+aGCUEAxRY2LnZ5+Ewq1t9sk0yolXS4a+mKjIKlV+ZBqVYQsWATIE
	 CurSep4jThujYv74g/WzQfMJwwS6mUvGppTf9Rm9kIC4Hr/PIaarXeQHCtAgFXznV6
	 AjDS2uNh7xryvoaSGrxff2udhB/DG8MDkAY7VVDAlD8TWpEi0BXLkMOPjoklCxou5w
	 +/MrkQ89vgDFka2v4wZGdDHLoPAbCwqPOLj1318Ezw/S91Wu3hd01j5pfgljVc17ob
	 bQWDR3+P8FlBw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	agk@redhat.com,
	snitzer@kernel.org,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] dm cache: prevent entering passthrough mode after unclean shutdown
Date: Mon, 20 Apr 2026 09:18:43 -0400
Message-ID: <20260420132314.1023554-129-sashal@kernel.org>
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

From: Ming-Hung Tsai <mtsai@redhat.com>

[ Upstream commit a373b3d5289e50ab26d4cf776bf5891436ff3658 ]

dm-cache assumes all cache blocks are dirty when it recovers from an
unclean shutdown. Given that the passthrough mode doesn't handle dirty
blocks, we should not load a cache in passthrough mode if it was not
cleanly shut down; or we'll risk data loss while updating an actually
dirty block.

Also bump the target version to 2.4.0 to mark completion of passthrough
mode fixes.

Reproduce steps:

1. Create a writeback cache with zero migration_threshold to produce
   dirty blocks.

dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
dmsetup create cdata --table "0 131072 linear /dev/sdc 8192"
dmsetup create corig --table "0 262144 linear /dev/sdc 262144"
dd if=/dev/zero of=/dev/mapper/cmeta bs=4k count=1 oflag=direct
dmsetup create cache --table "0 262144 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writeback smq \
2 migration_threshold 0"

2. Write the first cache block dirty

fio --filename=/dev/mapper/cache --name=populate --rw=write --bs=4k \
--direct=1 --size=64k

3. Ensure the number of dirty blocks is 1. This status query triggers
   metadata commit without flushing the dirty bitset, setting up the
   unclean shutdown state.

dmsetup status cache | awk '{print $14}'

4. Force reboot, leaving the cache uncleanly shutdown.

echo b > /proc/sysrq-trigger

5. Activate the above cache components, and verify the first data block
   remains dirty.

dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
dmsetup create cdata --table "0 131072 linear /dev/sdc 8192"
dmsetup create corig --table "0 262144 linear /dev/sdc 262144"
dd if=/dev/mapper/cdata of=/tmp/cb0.bin bs=64k count=1
dd if=/dev/mapper/corig of=/tmp/ob0.bin bs=64k count=1
md5sum /tmp/cb0.bin /tmp/ob0.bin # expected to be different

6. Try bringing up the cache in passthrough mode. It succeeds, while the
   first cache block was loaded dirty due to unclean shutdown, violates
   the passthrough mode's constraints.

dmsetup create cache --table "0 262144 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 passthrough smq 0"
dmsetup status cache | awk '{print $14}'

7. (Optional) Demonstrate the integrity issue: invalidating the dirty
   block in passthrough mode doesn't write back the dirty data, causing
   data loss.

fio --filename=/dev/mapper/cache --name=invalidate --rw=write --bs=4k \
--direct=1 --size=4k  # overwrite the first 4k to trigger invalidation
dmsetup remove cache
dd if=/dev/mapper/corig of=/tmp/ob0new.bin bs=64k count=1
cb0sum=$(dd if=/tmp/cb0.bin bs=4k count=15 skip=1 | md5sum | \
awk '{print $1}')
ob0newsum=$(dd if=/tmp/ob0new.bin bs=4k count=15 skip=1 | md5sum | \
awk '{print $1}')
echo "$cb0sum, $ob0newsum"  # remaining 60k should differ (data loss)

Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a complete analysis. Let me
compile my findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: dm cache (device-mapper cache target)
- **Action verb**: "prevent" — indicates fixing a dangerous condition
- **Summary**: Prevents entering passthrough mode after unclean
  shutdown, which would cause data loss

### Step 1.2: Tags
- **Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>** — author, active
  dm-cache contributor
- **Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>** — dm
  subsystem maintainer
- No Fixes: tag, no Reported-by:, no Cc: stable (as expected for
  candidates)

### Step 1.3: Commit Body Analysis
The bug is clearly described: dm-cache assumes all cache blocks are
dirty after unclean shutdown. Passthrough mode doesn't handle dirty
blocks (reads from origin, writes go to origin + invalidate cache hits).
If a cache with potentially dirty blocks is loaded in passthrough mode
after an unclean shutdown, invalidating a dirty cache block discards
data that was never written back to the origin — causing **data loss**.

Detailed 7-step reproduction steps are provided with concrete commands.

### Step 1.4: Hidden Bug Fix Detection
This is explicitly a data integrity protection fix. The word "prevent"
combined with the description of data loss makes the intent unambiguous.

**Record**: Bug fix preventing data loss in dm-cache passthrough mode
after unclean shutdown.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **dm-cache-metadata.c**: +9 lines (new
  `dm_cache_metadata_clean_when_opened()` function)
- **dm-cache-metadata.h**: +5 lines (function declaration + comment)
- **dm-cache-target.c**: +17 lines changed (passthrough check in
  `can_resume()` + version bump)
- **Total**: ~31 lines added, 1 line modified
- **Functions modified**: `can_resume()` (body extended), new function
  `dm_cache_metadata_clean_when_opened()`
- **Scope**: single-subsystem surgical fix

### Step 2.2: Code Flow Change
1. **dm-cache-metadata.c**: New accessor function reads
   `cmd->clean_when_opened` under READ_LOCK. Trivial, obviously correct.
2. **dm-cache-target.c `can_resume()`**: Before the change,
   `can_resume()` only checked for failed resume retries. After, it also
   checks if we're in passthrough mode with an unclean shutdown.
3. **Version bump**: 2.3.0 → 2.4.0 — cosmetic marker for the behavioral
   change.

### Step 2.3: Bug Mechanism
This is a **data corruption / data loss** bug:
- The constructor (`cache_ctr` at line 2470) checks
  `dm_cache_metadata_all_clean()` which reads the **on-disk dirty
  bitset** — stale after an unclean shutdown
- The runtime (`__load_mapping_v1`/`__load_mapping_v2`) checks
  `clean_when_opened` and treats all blocks as dirty when false
- The gap: constructor says "all clean" (stale bitset), but runtime
  later marks everything dirty — passthrough mode then incorrectly
  invalidates blocks without writeback

### Step 2.4: Fix Quality
- **Obviously correct**: The check is a simple boolean read of an
  existing, well-tested field
- **Minimal**: Only adds essential check code
- **Regression risk**: Very low — worst case, a cache that should be
  refused in passthrough mode is correctly refused (fail-safe)

**Record**: Small, surgical fix. ~31 lines total. Three files, one
subsystem. Fix is fail-safe (blocks dangerous mode, doesn't change data
paths).

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The `can_resume()` function was introduced by `5da692e2262b8` (Ming-Hung
Tsai, 2025-03-06), first in v6.15-rc1.

### Step 3.2: Fixes Tag
No Fixes: tag present. The underlying bug has existed since
`2ee57d587357f` ("dm cache: add passthrough mode", 2013-10-24, v3.13),
which never validated `clean_when_opened` before allowing passthrough
mode activation after a crash.

### Step 3.3: File History
The author (Ming-Hung Tsai) has contributed 10+ dm-cache fixes,
including out-of-bounds access fixes, BUG_ON prevention, and other
critical corrections. All accepted by the dm maintainer tree.

### Step 3.4: Author Assessment
Ming-Hung Tsai is a Red Hat engineer who has been a prolific dm-cache
bug fixer. Their patches go through Mikulas Patocka (dm maintainer) who
co-signs them.

### Step 3.5: Dependencies
This commit depends on `5da692e2262b8` which introduced `can_resume()`.
That commit is in v6.15+. For the 7.0.y tree, this dependency is
satisfied.

**Record**: Bug has existed since v3.13 (2013). Fix depends on
`can_resume()` from v6.15+.

---

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1-4.5
Could not access lore.kernel.org directly (Anubis protection). However,
b4 dig confirms the related series (v3 of 2 patches by Ming-Hung Tsai,
submitted to dm-devel, CC'd dm maintainers Joe Thornber, Heinz
Mauelshagen, Mike Snitzer, and Mikulas Patocka). The series went through
3 revisions, indicating active review. The commit analyzed is a follow-
up fix likely from a later submission.

**Record**: Author is well-known to dm maintainers. Prior patches in the
same series were reviewed and merged. Could not verify specific lore
discussion for this exact commit.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.4: Key Functions
- `can_resume()` is called from `cache_preresume()` which is the DM
  target's `.preresume` callback — called during device activation
- `passthrough_mode()` checks `cache->features.io_mode ==
  CM_IO_PASSTHROUGH`
- `dm_cache_metadata_clean_when_opened()` reads `cmd->clean_when_opened`
  which is set from the CLEAN_SHUTDOWN superblock flag during metadata
  open

The constructor check at line 2470 (`dm_cache_metadata_all_clean`) reads
the on-disk dirty bitset, which is **stale after an unclean shutdown** —
the dirty bitset is not flushed on every dirty block write, only on
clean shutdown. The CLEAN_SHUTDOWN flag is the authoritative indicator.

### Step 5.5: Similar Patterns
Commit `5b1fe7bec8a8d` ("dm cache metadata: set dirty on all cache
blocks after a crash", 2018) fixed the same root issue for the normal
(non-passthrough) code path — it was Cc'd to stable. This commit fixes
the passthrough-specific gap.

**Record**: Bug is reachable from userspace (dmsetup commands). The
constructor check is insufficient because it reads stale on-disk data.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Code Existence
- Passthrough mode exists since v3.13 (all stable trees)
- `can_resume()` exists since v6.15 (7.0.y, 6.15.y+)
- `clean_when_opened` field exists since the beginning of dm-cache

### Step 6.2: Backport Complications
For 7.0.y: should apply cleanly (all prerequisites present, version is
2.3.0).
For trees < 6.15: would need adaptation (no `can_resume()`, check would
go directly in `cache_preresume()`).

**Record**: Clean apply expected for 7.0.y. Older trees need adaptation.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Criticality
- **Subsystem**: dm-cache (device-mapper caching layer)
- **Criticality**: IMPORTANT — used by LVM's lvmcache, enterprise
  storage stacks, and production workloads
- Data loss in a caching layer is especially severe as users expect
  transparent, reliable behavior

### Step 7.2: Activity
dm-cache has received numerous bug fixes recently, with Ming-Hung Tsai
being the most active contributor.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
Users of dm-cache in passthrough mode after an unclean shutdown (power
failure, crash, sysrq-b). This includes LVM cache users (lvmcache) on
enterprise systems.

### Step 8.2: Trigger Conditions
1. Have a dm-cache with dirty blocks in writeback mode
2. Experience an unclean shutdown (crash, power loss)
3. Resume the cache in passthrough mode
4. Write to the cached region (triggers invalidation of dirty blocks)
5. Data loss occurs silently

### Step 8.3: Failure Mode
**DATA LOSS** — dirty data in the cache is silently discarded without
writeback to the origin device. Severity: **CRITICAL**.

### Step 8.4: Risk-Benefit Ratio
- **Benefit**: Very high — prevents silent data loss in production
  storage
- **Risk**: Very low — the fix only adds a fail-safe check that blocks a
  dangerous operation
- **Ratio**: Strongly favorable for backporting

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backporting:**
- Fixes silent data loss (CRITICAL severity)
- Small, contained fix (~31 lines, 3 files, 1 subsystem)
- Obviously correct — reads an existing, well-tested flag
- Fail-safe behavior (refuses dangerous operation rather than modifying
  data paths)
- Author is an established dm-cache contributor
- Co-signed by dm maintainer Mikulas Patocka
- Detailed reproduction steps demonstrate the bug is real and
  triggerable
- Related fix (`5b1fe7bec8a8d` from 2018) for non-passthrough path was
  Cc: stable

**AGAINST backporting:**
- Version bump from 2.3.0 to 2.4.0 (cosmetic, could be dropped for
  stable)
- Adds a new accessor function (trivial, just reads existing field)
- Dependency on `can_resume()` from v6.15+ (present in 7.0.y)

### Step 9.2: Stable Rules Checklist
1. **Obviously correct and tested?** YES — trivial accessor + simple
   conditional, with detailed repro steps
2. **Fixes a real bug?** YES — silent data loss on unclean shutdown with
   passthrough mode
3. **Important issue?** YES — data corruption/loss, CRITICAL severity
4. **Small and contained?** YES — ~31 lines, single subsystem
5. **No new features or APIs?** Correct — the new function is a private
   internal accessor, not user-facing
6. **Can apply to stable?** YES for 7.0.y (all prerequisites present)

### Step 9.3: Exception Categories
Not applicable — this is a straightforward critical bug fix.

### Step 9.4: Decision
This is a clear YES. It prevents silent data loss in dm-cache, is small
and surgical, obviously correct, and meets all stable kernel criteria.

---

## Verification

- [Phase 1] Parsed tags: Signed-off-by from Ming-Hung Tsai (author) and
  Mikulas Patocka (dm maintainer). No Fixes/Cc:stable tags (expected).
- [Phase 2] Diff analysis: ~31 lines added across 3 files. New trivial
  accessor `dm_cache_metadata_clean_when_opened()`, passthrough check in
  `can_resume()`, version bump.
- [Phase 2] Verified constructor check at line 2470-2486 calls
  `dm_cache_metadata_all_clean()` which reads stale on-disk dirty bitset
  — insufficient after crash.
- [Phase 2] Verified `blocks_are_clean_separate_dirty()` reads on-disk
  bitset (dm_bitset_cursor), not the `clean_when_opened` flag.
- [Phase 2] Verified `__load_mapping_v1` (line 1343) and
  `__load_mapping_v2` (line 1385) check `cmd->clean_when_opened` and
  treat all blocks as dirty when false.
- [Phase 3] git blame: `can_resume()` introduced by `5da692e2262b8`
  (2025-03-06, v6.15-rc1).
- [Phase 3] Passthrough mode introduced by `2ee57d587357f` (2013-10-24,
  v3.13) — bug has existed since then.
- [Phase 3] `git tag --contains 5da692e2262b8`: first appears in
  v6.15-rc1, present in 7.0.
- [Phase 3] `git tag --contains 2ee57d587357f`: present since v3.13, in
  all stable trees.
- [Phase 3] Version was 2.2.0 → 2.3.0 by `c2662b1544cbd` (same
  author/series), now 2.3.0 → 2.4.0.
- [Phase 4] b4 dig: found the related series (v3, 2 patches) on dm-
  devel. CC'd Joe Thornber, Heinz Mauelshagen, Mike Snitzer, Mikulas
  Patocka.
- [Phase 4] lore.kernel.org blocked by Anubis. Could not fetch specific
  discussion for this commit.
- [Phase 5] `clean_when_opened` is set at line 508 from CLEAN_SHUTDOWN
  flag in superblock, well-established mechanism.
- [Phase 5] `5b1fe7bec8a8d` (2018) fixed same root issue for non-
  passthrough path, was Cc: stable.
- [Phase 6] All prerequisites present in 7.0.y tree. Clean apply
  expected.
- [Phase 7] dm-cache is IMPORTANT subsystem used by LVM, enterprise
  storage.
- [Phase 8] Failure mode: silent data loss (CRITICAL). Trigger: unclean
  shutdown + passthrough mode resume + write.
- UNVERIFIED: Could not verify specific mailing list discussion or
  reviewer feedback for this exact commit due to lore.kernel.org access
  restrictions.

**YES**

 drivers/md/dm-cache-metadata.c |  9 +++++++++
 drivers/md/dm-cache-metadata.h |  5 +++++
 drivers/md/dm-cache-target.c   | 19 ++++++++++++++++++-
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 57158c02d096e..70e0c6c064082 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -1824,3 +1824,12 @@ int dm_cache_metadata_abort(struct dm_cache_metadata *cmd)
 
 	return r;
 }
+
+int dm_cache_metadata_clean_when_opened(struct dm_cache_metadata *cmd, bool *result)
+{
+	READ_LOCK(cmd);
+	*result = cmd->clean_when_opened;
+	READ_UNLOCK(cmd);
+
+	return 0;
+}
diff --git a/drivers/md/dm-cache-metadata.h b/drivers/md/dm-cache-metadata.h
index 5f77890207fed..dca423522da6c 100644
--- a/drivers/md/dm-cache-metadata.h
+++ b/drivers/md/dm-cache-metadata.h
@@ -146,6 +146,11 @@ void dm_cache_metadata_set_read_only(struct dm_cache_metadata *cmd);
 void dm_cache_metadata_set_read_write(struct dm_cache_metadata *cmd);
 int dm_cache_metadata_abort(struct dm_cache_metadata *cmd);
 
+/*
+ * Query method.  Was the metadata cleanly shut down when opened?
+ */
+int dm_cache_metadata_clean_when_opened(struct dm_cache_metadata *cmd, bool *result);
+
 /*----------------------------------------------------------------*/
 
 #endif /* DM_CACHE_METADATA_H */
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 935ab79b1d0cd..962ac5ee081c2 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2929,6 +2929,9 @@ static dm_cblock_t get_cache_dev_size(struct cache *cache)
 
 static bool can_resume(struct cache *cache)
 {
+	bool clean_when_opened;
+	int r;
+
 	/*
 	 * Disallow retrying the resume operation for devices that failed the
 	 * first resume attempt, as the failure leaves the policy object partially
@@ -2945,6 +2948,20 @@ static bool can_resume(struct cache *cache)
 		return false;
 	}
 
+	if (passthrough_mode(cache)) {
+		r = dm_cache_metadata_clean_when_opened(cache->cmd, &clean_when_opened);
+		if (r) {
+			DMERR("%s: failed to query metadata flags", cache_device_name(cache));
+			return false;
+		}
+
+		if (!clean_when_opened) {
+			DMERR("%s: unable to resume into passthrough mode after unclean shutdown",
+			      cache_device_name(cache));
+			return false;
+		}
+	}
+
 	return true;
 }
 
@@ -3510,7 +3527,7 @@ static void cache_io_hints(struct dm_target *ti, struct queue_limits *limits)
 
 static struct target_type cache_target = {
 	.name = "cache",
-	.version = {2, 3, 0},
+	.version = {2, 4, 0},
 	.module = THIS_MODULE,
 	.ctr = cache_ctr,
 	.dtr = cache_dtr,
-- 
2.53.0

