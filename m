Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21D950F724;
	Mon, 31 Aug 2026 13:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183775; cv=none; b=W3c0ZVDfZPiR3drKVKd4x580F96VYLnNds3ha9J00Mxud9RjLlfCbnBnGysaDRc05Q06d/IwLCZp56nG+E2dOQ3FL3IGK0AzYH5+gXNo6QrFknOEiTZSYbisQhO1ARyPvbk61Uu6ANJtiM3iZIRMYpw3EupwveCa2SG0465Gesg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183775; c=relaxed/simple;
	bh=mKJ31VF80Wf3Fh/GI29ZoPGECPfwMkVhquQ8y3acgZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=augASJS8cO9VaRC/cecjYxAJutJmWX17cLrl3FATpkHmdxZ/FGBk9tgYlsWGgS43BoQFdfXAadS8oqwhTNdVyzkZ4qb8iJDS4btpTAlL8iESfHAb+H2ySTJVgFZbsZAM1FPxRpMHqNHo47fWG4EmJIVpQDAxLcZksSGzBpxMaUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gIF7t26W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gIF7t26W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47B71F00A3D;
	Mon, 31 Aug 2026 13:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183772;
	bh=gmDbspS2i41vpBVRai8FL2zjVKSMIYFwP2o1AIYRj9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gIF7t26WOpbHqcNqqegcWOgTBNEDI+A5+Dle4u27LOL16QNMZmdEjPOYYNm5zJKWa
	 DdGBMXaFpbQqiNqvcGsKQsjlBAIMd0bwzYIZM8Z2+yOj3YKadkLVoTSOudC6poq91J
	 0oA19A+y8yZVVg9UQcLcU0Pp43sR2LPqRwicei1MITJ8yEsdRZeao4q679g+doLiyr
	 5G4FfYrr3oxxlBEhHWjXN4klJqdHLM0KPite3Pl0atsJGgybh/ole/QIpVMKqB9E6a
	 7vgaUS0BalpHgffpIXs6OFeFJzzLzUR7Xp7h59DexiVH+1S0jAe/LTOf8sDSlN6Pez
	 AhfpypNYuKKWw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	agk@redhat.com,
	snitzer@kernel.org,
	song@kernel.org,
	yukuai@fygo.io,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] dm-raid: only requeue bios when dm is suspending
Date: Mon, 31 Aug 2026 09:25:23 -0400
Message-ID: <20260831133314.4125787-295-sashal@kernel.org>
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

From: Benjamin Marzinski <bmarzins@redhat.com>

[ Upstream commit 97cb8be0fd4c50d310988e0822f7e91d1711e6f8 ]

returning DM_MAPIO_REQUEUE from the target map() function only requeues
the bio during noflush suspends. During regular operations or during
flushing suspends, it fails the bio. Failing the bio during flushing
suspends is the correct behavior here. We cannot handle the bio, and we
cannot suspends while it is outstanding. But during normal operations,
we should not push the bio back to dm. Instead, wait for the reshape
to be resumed.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `dm-raid: only requeue bios when dm is
suspending`

**Local tree:** Linux **6.18.43** (`v6.18.43-1-gc7f0dac02d232`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[dm-raid]` `[fix/implied]` — Only requeue bios when DM is
suspending (reshape-interrupted I/O path).

### Step 1.2: Tags
**Record:**
- **Fixes:** — none
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Link:** — none
- **Cc: stable:** — none (expected for manual review)
- **Signed-off-by:** Benjamin Marzinski `<bmarzins@redhat.com>`, Mikulas
  Patocka `<mpatocka@redhat.com>`

No syzbot, no user bug reports in the message. Authors are dm/md
maintainers.

### Step 1.3: Body analysis
**Record:**
- **Bug:** `STRIPE_WAIT_RESHAPE` in raid456 causes `raid_map()` to
  return `DM_MAPIO_REQUEUE`. That only requeues during **noflush**
  suspend; otherwise DM fails the bio with `BLK_STS_IOERR`.
- **Symptom:** Spurious I/O failures on dm-raid456 when reshape is
  interrupted and I/O crosses the reshape position during **normal**
  operation (not suspend).
- **Correct behavior:** During normal ops, wait on `wait_for_reshape`
  for reshape to resume. During suspend, abort/wake I/O so suspend can
  complete (deadlock avoidance).
- **Root cause:** `STRIPE_WAIT_RESHAPE` is returned unconditionally when
  `reshape_interrupted()`, without distinguishing suspend vs. normal
  operation.

### Step 1.4: Hidden bug fix?
**Record:** No — explicitly described as correcting when bios are
requeued vs. failed. Real I/O-path bug fix, not cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
| File | Change |
|------|--------|
| `drivers/md/md.h` | +1 enum flag `MD_DM_SUSPENDING`, doc comment |
| `drivers/md/dm-raid.c` | Set/clear `MD_DM_SUSPENDING` in
presuspend/postsuspend (+12 lines) |
| `drivers/md/raid5.c` | Gate `STRIPE_WAIT_RESHAPE` on dm+suspending (+4
lines net) |

**Functions:** `raid_presuspend`, `raid_presuspend_undo`,
`raid_postsuspend`, `make_stripe_request`
**Scope:** Small, 3-file surgical fix.

### Step 2.2: Code flow (per hunk)

**Hunk 1 — `raid_presuspend`:** Before → only set `RT_FLAG_RS_FROZEN`.
After → also `set_bit(MD_DM_SUSPENDING)` so raid5 knows DM suspend is in
progress.

**Hunk 2 — `raid_presuspend_undo`:** Clears `MD_DM_SUSPENDING` if
presuspend is rolled back.

**Hunk 3 — `raid_postsuspend`:** Clears `MD_DM_SUSPENDING` after suspend
completes.

**Hunk 4 — `make_stripe_request` out path:** Before → always convert
`STRIPE_SCHEDULE_AND_RETRY` + `reshape_interrupted()` to
`STRIPE_WAIT_RESHAPE`. After → only convert when **not** dm-raid, **or**
dm-raid **and** `MD_DM_SUSPENDING` is set. Otherwise keep
`STRIPE_SCHEDULE_AND_RETRY` → caller waits on `wait_for_reshape`.

### Step 2.3: Bug mechanism
**Record:** **Logic/correctness fix** in dm-raid456 reshape I/O
handling.

Broken path (present in 6.18.43):
1. Reshape interrupted; I/O crosses reshape position.
2. `make_stripe_request` → `STRIPE_WAIT_RESHAPE`.
3. `raid5_make_request` → `md_free_cloned_bio`, returns `false`.
4. `md_handle_request` (no `gendisk`, has `prepare_suspend`) → returns
   `false`.
5. `raid_map` → `DM_MAPIO_REQUEUE`.
6. `dm_handle_requeue` — not noflush suspending → `BLK_STS_IOERR` (bio
   failed).

Fix: During normal dm-raid ops, stay in `STRIPE_SCHEDULE_AND_RETRY` wait
loop. Only take abort path during actual DM suspend.

### Step 2.4: Fix quality
**Record:** Obviously correct, minimal, matches existing
`prepare_suspend`/`wait_for_reshape` design. Low regression risk — only
narrows when `STRIPE_WAIT_RESHAPE` fires for dm-raid. Complements
`ff6b93410192b` ("md: wake raid456 reshape waiters before suspend")
already in this tree.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy lines at `raid5.c:6056-6059` blame to `19eef1d98eeda`
(tree import point; granular upstream history not available in this
stable checkout). `STRIPE_WAIT_RESHAPE` and `reshape_interrupted`
handling are present in 6.18.43.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:**
- `ff6b93410192b` — related suspend deadlock fix for native md (already
  in 6.18.43).
- `raid_presuspend` + `prepare_suspend` infrastructure present in
  current `dm-raid.c`.
- Commit under review **not** in this tree (`MD_DM_SUSPENDING` absent).

### Step 3.4: Author context
**Record:** Marzinski/Patocka are dm/md maintainers. Web search found
prior dm-raid456 reshape deadlock/requeue discussion in the v6.7
regression series (Benjamin Marzinski proposing dm-raid requeue during
suspend).

### Step 3.5: Dependencies
**Record:** Self-contained. Requires existing `STRIPE_WAIT_RESHAPE`,
`reshape_interrupted()`, `raid_presuspend`/`prepare_suspend` — all
present in 6.18.43. No series dependency.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c <hash>` — **failed** (commit not in local git).
`b4 dig` with author email — **failed**. No matching `.mbx` in
workspace. lore.kernel.org — **blocked** (Anubis bot protection).

### Step 4.2: Reviewers
**Record:** UNVERIFIED — could not fetch mailing list thread.

### Step 4.3: Bug reports
**Record:** No `Reported-by`/`Link` in commit. Web search found related
dm-raid456 reshape test failures (`lvconvert-raid-reshape-stripes-load-
reload.sh`, `lvconvert-repair-raid.sh`) in the v6.7 regression thread —
contextual, not a direct report for this exact patch.

### Step 4.4: Series context
**Record:** Part of ongoing dm-raid456 reshape I/O fixes. Standalone;
does not require other unmerged patches.

### Step 4.5: Stable list
**Record:** UNVERIFIED — lore stable list inaccessible.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `make_stripe_request`, `raid5_make_request`,
`md_handle_request`, `raid_map`, `dm_handle_requeue`, `raid_presuspend`,
`raid5_prepare_suspend`.

### Step 5.2: Callers
**Record:**
- `raid_map` ← dm target map (all dm-raid I/O)
- `raid5_make_request` ← `md_handle_request` ← `raid_map`
- `raid_presuspend` ← dm suspend path

All common block-I/O and device-mapper admin paths.

### Step 5.3: Callees
**Record:** `wait_woken(&wait_for_reshape)`, `prepare_suspend` →
`wake_up(&conf->wait_for_reshape)`, `dm_handle_requeue` →
`__noflush_suspending()`.

### Step 5.4: Reachability
**Record:** Triggered when dm-raid456 reshape is interrupted and I/O
hits the reshape boundary — realistic during `lvconvert`, table reload,
reshape freeze. Userspace block I/O is the trigger. Not obscure or init-
only.

### Step 5.5: Similar patterns
**Record:** `mddev_is_dm()` checks exist elsewhere in raid5.c.
`DM_MAPIO_REQUEUE` only requeues under noflush suspend (`dm.c:929-939`).
Same pattern as other dm-raid reshape fixes.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.43)

### Step 6.1: Buggy code present?
**Record:** **YES.** Current tree at `raid5.c:6056-6059`:

```6056:6059:drivers/md/raid5.c
        if (ret == STRIPE_SCHEDULE_AND_RETRY &&
reshape_interrupted(mddev)) {
                bi->bi_status = BLK_STS_RESOURCE;
                ret = STRIPE_WAIT_RESHAPE;
                pr_err_ratelimited("dm-raid456: io across reshape
position while reshape can't make progress");
```

`MD_DM_SUSPENDING` **not** present. `raid_presuspend` has
`prepare_suspend` call but no suspending flag.

### Step 6.2: Backport difficulty
**Record:** **Clean apply** expected — small additive change, no
conflicting refactors in these functions.

### Step 6.3: Duplicate fix?
**Record:** **None.** `ff6b93410192b` fixes native-md suspend deadlock;
does not fix dm-raid normal-operation I/O failure.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
**Record:** `drivers/md` — device-mapper / md RAID. **Criticality:
IMPORTANT** (storage stack, LVM dm-raid users).

### Step 7.2: Activity
**Record:** Actively maintained; multiple recent stable backports in
this tree (raid5 hang fixes, dm-raid NULL deref, reshape suspend fix).

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** dm-raid456 users (LVM `raid` target, reshaping arrays).
Config-specific, but affects production storage setups.

### Step 8.2: Trigger conditions
**Record:** Reshape interrupted/frozen **and** I/O crosses reshape
position **and** not in DM suspend. Moderately common during reshape
admin operations. Unprivileged users can trigger via normal filesystem
I/O on the dm device.

### Step 8.3: Failure severity
**Record:** Spurious `BLK_STS_IOERR` on in-flight I/O → application
errors, possible failed LVM operations. **Severity: HIGH** for affected
workloads (incorrect I/O failure, not kernel crash). Suspend deadlock is
a separate issue addressed by related patches.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for dm-raid reshape users — prevents incorrect I/O
  failure.
- **Risk:** LOW — ~15 lines, internal flag, narrow condition change.
- **Ratio:** Strong benefit, minimal risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real bug in 6.18.43 — verified in source
- Incorrect I/O failure on production storage path
- Small, surgical, maintainer-authored fix
- Complements existing reshape suspend fix already in tree
- Obviously correct logic: wait during normal ops, abort only during
  suspend
- dm/md maintainers signed off

**AGAINST backport:**
- Affects dm-raid456 reshape edge case, not all kernel users
- No syzbot/user Reported-by in commit message
- Mailing list review not verified

**UNRESOLVED:**
- Original lore thread and explicit stable nomination not verified
- Exact upstream commit date/hash not in this checkout

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic verified in code;
   maintainer SOBs; no Tested-by
2. Fixes real bug affecting users? **PASS** — spurious I/O errors on dm-
   raid456 reshape
3. Important issue? **PASS** — incorrect I/O failure on storage path
   (HIGH)
4. Small and contained? **PASS** — ~15 lines, 3 files
5. No new features/APIs? **PASS** — internal `MD_DM_SUSPENDING` flag
   only
6. Can apply to local tree? **PASS** — all prerequisite code present;
   clean apply expected

### Step 9.3: Exception categories
**Record:** N/A — standard bug fix, not device-ID/quirk/build/doc
exception.

### Step 9.4: Decision rationale
This commit fixes a real regression in dm-raid456: I/O that should block
waiting for reshape resume is instead failed because `DM_MAPIO_REQUEUE`
does not requeue outside noflush suspend. The buggy code exists in Linux
6.18.43, the fix is minimal and self-contained, and the failure mode
(spurious I/O errors during reshape operations) matters to stable users
running LVM dm-raid.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit
  message
- **[Phase 2]** Read current `raid5.c:6056-6060`, `dm-
  raid.c:3341-3360,3824-3867`, `md.c:395-426`, `dm.c:872-939,1446-1454`
- **[Phase 2]** Traced `STRIPE_WAIT_RESHAPE` → `md_free_cloned_bio` →
  `false` → `DM_MAPIO_REQUEUE` → `BLK_STS_IOERR` path
- **[Phase 3]** `git describe HEAD` → v6.18.43
- **[Phase 3]** `git blame -L 6056,6060 drivers/md/raid5.c` → lines at
  tree base
- **[Phase 3]** `git log --grep='only requeue bios'` → not in tree
- **[Phase 3]** `grep MD_DM_SUSPENDING` → not in tree (fix not applied)
- **[Phase 3]** `git log --oneline ff6b93410192b` → related suspend fix
  present
- **[Phase 4]** `b4 dig -c <hash>` → failed (commit not local)
- **[Phase 4]** lore.kernel.org → blocked by Anubis
- **[Phase 4]** Web search → related dm-raid456 reshape context (v6.7
  regression thread)
- **[Phase 5]** `grep md_handle_request, STRIPE_WAIT_RESHAPE,
  prepare_suspend` → call chain verified
- **[Phase 6]** Buggy unconditional `STRIPE_WAIT_RESHAPE` confirmed in
  6.18.43
- **[Phase 6]** `raid_presuspend`/`prepare_suspend` infrastructure
  confirmed present
- **[Phase 8]** `dm_handle_requeue` noflush-only requeue behavior
  confirmed at `dm.c:929-939`
- **UNVERIFIED:** Mailing list review thread; explicit stable
  nomination; upstream commit SHA

**YES**The background searches finished and match what the earlier
analysis already used:

- **Commit not in this tree** — no match for `MD_DM_SUSPENDING` or the
  subject line; the fix is still a candidate, not applied.
- **History** — `STRIPE_WAIT_RESHAPE` traces to the tree import point
  (`19eef1d98eeda`); no finer-grained upstream history in this 6.18.43
  checkout.
- **kernel.org search** — no useful commit hit from the web grep.

**Verdict unchanged: YES** for backport to this 6.18.43 tree. The buggy
path is present, and the patch is a small, low-risk fix for spurious I/O
errors on dm-raid456 during interrupted reshape outside of suspend.

 drivers/md/dm-raid.c | 6 ++++++
 drivers/md/md.h      | 2 ++
 drivers/md/raid5.c   | 7 +++++--
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 4bacdc499984b..9eee490c029e7 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3831,6 +3831,7 @@ static void raid_presuspend(struct dm_target *ti)
 	 * resume, raid_postsuspend() is too late.
 	 */
 	set_bit(RT_FLAG_RS_FROZEN, &rs->runtime_flags);
+	set_bit(MD_DM_SUSPENDING, &mddev->flags);
 
 	if (!reshape_interrupted(mddev))
 		return;
@@ -3847,13 +3848,16 @@ static void raid_presuspend(struct dm_target *ti)
 static void raid_presuspend_undo(struct dm_target *ti)
 {
 	struct raid_set *rs = ti->private;
+	struct mddev *mddev = &rs->md;
 
+	clear_bit(MD_DM_SUSPENDING, &mddev->flags);
 	clear_bit(RT_FLAG_RS_FROZEN, &rs->runtime_flags);
 }
 
 static void raid_postsuspend(struct dm_target *ti)
 {
 	struct raid_set *rs = ti->private;
+	struct mddev *mddev = &rs->md;
 
 	if (!test_and_set_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) {
 		/*
@@ -3864,6 +3868,8 @@ static void raid_postsuspend(struct dm_target *ti)
 		mddev_suspend(&rs->md, false);
 		rs->md.ro = MD_RDONLY;
 	}
+	clear_bit(MD_DM_SUSPENDING, &mddev->flags);
+
 }
 
 static void attempt_restore_of_faulty_devices(struct raid_set *rs)
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 2960a98747607..2ece7788f9075 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -343,6 +343,7 @@ struct md_cluster_operations;
  * @MD_HAS_SUPERBLOCK: There is persistence sb in member disks.
  * @MD_FAILLAST_DEV: Allow last rdev to be removed.
  * @MD_SERIALIZE_POLICY: Enforce write IO is not reordered, just used by raid1.
+ * @MD_DM_SUSPENDING: This DM raid device is suspending.
  *
  * change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is added
  */
@@ -362,6 +363,7 @@ enum mddev_flags {
 	MD_HAS_SUPERBLOCK,
 	MD_FAILLAST_DEV,
 	MD_SERIALIZE_POLICY,
+	MD_DM_SUSPENDING,
 };
 
 enum mddev_sb_flags {
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b19d870e41719..0d83c4adf8e83 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6054,8 +6054,11 @@ static enum stripe_result make_stripe_request(struct mddev *mddev,
 	raid5_release_stripe(sh);
 out:
 	if (ret == STRIPE_SCHEDULE_AND_RETRY && reshape_interrupted(mddev)) {
-		bi->bi_status = BLK_STS_RESOURCE;
-		ret = STRIPE_WAIT_RESHAPE;
+		if (!mddev_is_dm(mddev) ||
+		    test_bit(MD_DM_SUSPENDING, &mddev->flags)) {
+			bi->bi_status = BLK_STS_RESOURCE;
+			ret = STRIPE_WAIT_RESHAPE;
+		}
 		pr_err_ratelimited("dm-raid456: io across reshape position while reshape can't make progress");
 	}
 	return ret;
-- 
2.53.0

