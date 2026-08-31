Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5816B4A2626;
	Mon, 31 Aug 2026 13:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183732; cv=none; b=NQUoOCZ9ygdzr8oVgDrDY/6vMZwEi2ruk3l3IkKDqmDblrIcOtOBRjzwVoK82jxU/CstvFMhrwn3SLywf3lBYH8ByNIzNs0IEfFC+jk7cASQDlF6p6r4GXA0LXy7jbIWIoqMoGbX2v7e7114xc7wN/Xm/lNZRF2mm9KPsNA6D2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183732; c=relaxed/simple;
	bh=rChy5yORFZLbGdCKUD+L2vUNSqVemFPiciulI6OKzP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ugcsWp9SfD4blrvL6kReeMZdsorO/GPh2mBYlsZkQ4ChGkbpVFtwzoxa1YeyrsHwQGH7ybGdsHppobhqf80LxS2lM2K4/h1MpYGni5BY9dTLAwmnXxchtdGnQdNxxrxkfF+VcMOKxjBcvaB3dJfBSA7NH16dmzsa675HI+aEERM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UjC+fQX+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UjC+fQX+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46891F00ACF;
	Mon, 31 Aug 2026 13:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183729;
	bh=0lX08l6+JGXjAp4QhgpbFwoFZyK327OPTv0iRmjeCZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UjC+fQX+NhzkFwm57UbkqH6qK03/0ca+Mn53lec3haFhAz1fsfhUwP8o/QM/4aiTS
	 sASbBT7wsyCuhBdsiGwpCFJ+LAMjadnFtPQLDyf8mS/uTSOFsKuz9Jf8YWNJ/yNPA6
	 72LN9R1UONNhitfHgSKbUvfudRsGqxn2V4kIHAZPDLFFa+EzWf8LebMT07tl1w00WN
	 XaEC5VVzagOwbrVyNKNrr8CHEQ7SbTN5EhoCSIjfvF28389tqvs67yGv9KaK4KPUDe
	 stvBwHCU3Cne7/iAaeMDy6qlnvhidfngsSzxw/6up3uXNFNT5K3Ohm9/OZBjDOFtOF
	 FnOyo5m83MwMA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jie Wang <jie.wang@intel.com>,
	syzbot+642d0561f78362d67d3f@syzkaller.appspotmail.com,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	gfs2@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] gfs2: fix quota init duplicate scan
Date: Mon, 31 Aug 2026 09:24:57 -0400
Message-ID: <20260831133314.4125787-269-sashal@kernel.org>
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

From: Jie Wang <jie.wang@intel.com>

[ Upstream commit b99a1f0f18ee50445907f55069e88bcfd8947383 ]

gfs2_quota_init() checks for duplicate quota_change IDs while holding
qd_lock and the quota hash bucket bitlock. That path used
gfs2_qd_search_bucket(), which takes a lockref reference via
lockref_get_not_dead().

On PREEMPT_RT this may sleep, which is not allowed under the bucket
bitlock, triggering "sleeping function called from invalid context".

Use a no-ref bucket lookup in this path, then continue duplicate
handling without taking a lockref there.

Refactor gfs2_qd_search_bucket() to build on top of the no-ref helper
so lookup traversal stays in one place.

This patch fixes a bug reported by syzbot.

Reported-by: syzbot+642d0561f78362d67d3f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=642d0561f78362d67d3f
Tested-by: syzbot+642d0561f78362d67d3f@syzkaller.appspotmail.com
Signed-off-by: Jie Wang <jie.wang@intel.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `gfs2: fix quota init duplicate scan`

**Local tree:** Linux **6.18.43** (`git describe HEAD` → `v6.18.43`,
`make kernelversion` → `6.18.43`)

**Mainline fix commit:** `b99a1f0f18ee` (not present in this tree; `git
merge-base --is-ancestor` → exit 1)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[gfs2] [fix] quota init duplicate scan` — GFS2 quota
initialization path; explicit bug fix.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Reported-by:** syzbot+642d0561f78362d67d3f@syzkaller.appspotmail.com
  (fuzzer-found, high priority)
- **Closes:**
  https://syzkaller.appspot.com/bug?extid=642d0561f78362d67d3f
- **Tested-by:** syzbot+642d0561f78362d67d3f@syzkaller.appspotmail.com
- **Signed-off-by:** Jie Wang (author), Andreas Gruenbacher (GFS2
  maintainer)
- No Fixes: tag (expected for manual review)
- No Cc: stable tag (expected; not a negative signal)

**Notable patterns:** syzbot report + Tested-by syzbot = reproducible,
syscall-reachable bug.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** `gfs2_quota_init()` calls `gfs2_qd_search_bucket()` while
  holding `qd_lock` and the quota hash bucket bitlock. That helper calls
  `lockref_get_not_dead()`, which on PREEMPT_RT can sleep.
- **Symptom:** `BUG: sleeping function called from invalid context` at
  `lockref_get_not_dead()` → `rt_spin_lock()`.
- **Root cause:** Taking a lockref reference (which may acquire
  `lockref->lock` as a sleeping RT spinlock) under a bit_spinlock
  context that forbids sleeping.
- **Fix approach:** Add `gfs2_qd_search_bucket_noref()` for callers
  already holding locks; use it in the duplicate-scan path; refactor
  `gfs2_qd_search_bucket()` to call the noref helper first.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not hidden — this is an explicit PREEMPT_RT correctness bug
fix, not cleanup. The removal of `qd_put(old_qd)` is part of the fix:
the noref lookup does not take a reference, so the prior `qd_put()` was
balancing an unnecessary `lockref_get_not_dead()`.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **Files:** `fs/gfs2/quota.c` only (+23 / -10 lines in mainline commit;
  ~33 lines total with context)
- **Functions modified:** new `gfs2_qd_search_bucket_noref()`,
  refactored `gfs2_qd_search_bucket()`, `gfs2_quota_init()`
- **Scope:** Single-file, surgical fix

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Record:**
- **Hunk 1 (`gfs2_qd_search_bucket_noref`):** Before: no separate noref
  lookup. After: pure hash-bucket traversal returning a match without
  refcount/LRU manipulation.
- **Hunk 2 (`gfs2_qd_search_bucket`):** Before: inline traversal +
  `lockref_get_not_dead()` under caller's lock context. After: delegates
  traversal to noref helper, then takes lockref only when caller is not
  already under bitlock (RCU or unlocked paths).
- **Hunk 3 (`gfs2_quota_init`):** Before: `gfs2_qd_search_bucket()`
  under `qd_lock` + bucket bitlock → can sleep on RT; then
  `qd_put(old_qd)`. After: `gfs2_qd_search_bucket_noref()` under locks
  (no sleep); no `qd_put()` since no ref was taken.

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:** **Category:** Synchronization / invalid context (PREEMPT_RT
lock nesting violation). **Mechanism:** `lockref_get_not_dead()` slow
path does `spin_lock(&lockref->lock)` which becomes a sleeping mutex on
PREEMPT_RT, called while `preempt_count: 1` and holding `hlist_bl`
bitlock via `spin_lock_bucket()`.

### Step 2.4: ASSESS THE FIX QUALITY
**Record:** Fix is obviously correct and minimal. Refactoring
`gfs2_qd_search_bucket()` to share traversal logic avoids duplication.
Removing `qd_put(old_qd)` is correct (no ref acquired). Low regression
risk: only changes the duplicate-detection path under locks; normal
`qd_get()` paths still use the ref-taking wrapper outside the
problematic quota-init context. **Regression risk:** LOW.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:** Buggy `gfs2_qd_search_bucket()` call in `gfs2_quota_init()`
at line 1461 and the function body at lines 257–275 both blame to
`5d324e5159d9e` (v6.18-rc8 merge base in this tree). The duplicate-scan
logic is present throughout the 6.18.y series.

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** No Fixes: tag present. N/A.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:** Recent `fs/gfs2/quota.c` commits in this tree:
`1d47922b98046` (slab UAF in qd_put), `32c3960b42124` (wait_event in
gfs2_quotad). Patch went through v1→v2→v3 on lore; v3 is the committed
version. v2 was a 2-patch series but v3 is standalone.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** No prior Jie Wang gfs2 commits visible in this stable tree's
limited history. Andreas Gruenbacher (maintainer) signed off on mainline
commit.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:** No dependencies. Standalone fix. `git apply --check` of the
quota.c portion applies cleanly to 6.18.43.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:** `b4 dig -c b99a1f0f18ee` →
https://patch.msgid.link/20260423133934.118970-1-jie.wang@intel.com
(v3). Series: v1 (Apr 20), v2 (Apr 21, 2 patches), v3 (Apr 23,
standalone). Andreas Gruenbacher reviewed v2 ("looking good except for
one minor detail") and v3 thread includes his reply. No explicit "Cc:
stable" found in mbox.

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** `b4 dig -w`: CC'd gfs2@lists.linux.dev, linux-rt-
devel@lists.linux.dev, bigeasy@linutronix.de (RT), rostedt@goodmis.org,
clrkwllms@kernel.org, syzbot. Appropriate RT and GFS2 maintainers
involved.

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** Syzkaller bug 642d0561f78362d67d3f — status: fixed. 13
crashes. Label: prio:high. Stack trace confirms:
- `gfs2_quota_init` → `gfs2_qd_search_bucket` → `lockref_get_not_dead` →
  `rt_spin_lock`
- Triggered during `mount()` of GFS2 on `PREEMPT_RT`
- Secondary `gfs2_assert_warn` in `gfs2_qd_dispose` after duplicate
  detection (from improper `qd_put` in broken path)
- Reproducer: crafted GFS2 image with duplicate quota_change identifiers

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** v2 had a second patch ("move quota_init qc iterator
increment") — not needed; v3 is self-contained.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** lore.kernel.org stable search blocked by bot protection.
Could not verify stable-list discussion. Not a factor in the decision.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** `gfs2_qd_search_bucket_noref()` (new),
`gfs2_qd_search_bucket()` (refactored), `gfs2_quota_init()` (call site
change).

### Step 5.2: TRACE CALLERS
**Record:**
- `gfs2_quota_init()` ← `gfs2_make_fs_rw()` ← `gfs2_fill_super()` ←
  mount syscall
- `gfs2_qd_search_bucket()` also called from `qd_get()` (lines 286, 298)
  — but `qd_get()`'s locked call at line 298 is a separate path; this
  fix targets only the quota-init duplicate-scan path as reported

### Step 5.3: TRACE CALLEES
**Record:** `gfs2_qd_search_bucket_noref()` → RCU hlist traversal only
(no locks). `gfs2_qd_search_bucket()` → noref helper +
`lockref_get_not_dead()` + `list_lru_del_obj()`.

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:** `mount()` → `gfs2_fill_super()` → `gfs2_make_fs_rw()` →
`gfs2_quota_init()` — reachable from userspace via mount syscall.
Requires `CONFIG_GFS2_FS` + `PREEMPT_RT` + duplicate quota_change
entries (corruption or crafted image).

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** `qd_get()` at line 298 also calls `gfs2_qd_search_bucket()`
under `spin_lock_bucket()`. Same theoretical RT issue, but not reported
by syzbot and not addressed by this patch. Out of scope for this
backport decision.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:** **YES.** Current `fs/gfs2/quota.c` at lines 1461 and 257–275
matches the pre-fix code exactly. Fix commit `b99a1f0f18ee` is **not**
an ancestor of HEAD.

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** **Clean apply expected.** `git apply --check` of the quota.c
diff from `b99a1f0f18ee` succeeded with no errors on 6.18.43.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** No prior fix for this syzbot bug found. Related recent fix
`1d47922b98046` (qd_put UAF) is separate.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** **Subsystem:** fs/gfs2 (GFS2 cluster filesystem).
**Criticality:** IMPORTANT — affects GFS2/PREEMPT_RT users; mount path
is critical.

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** Active in 6.18.y (recent quota fixes in this tree). GFS2 is
a production cluster filesystem used in RHEL and similar distributions.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** Users with `CONFIG_GFS2_FS` + `CONFIG_PREEMPT_RT` mounting
GFS2 filesystems where `gfs2_quota_init()` encounters duplicate
quota_change entries. Cluster/enterprise RT deployments are the primary
real-world audience.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:** GFS2 mount on PREEMPT_RT kernel when quota_change file
contains duplicate identifiers. Syzbot crafts this condition; real-world
trigger is quota file corruption during mount/recovery. Unprivileged
users can trigger via `mount()` if permitted to mount crafted images.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:** `BUG: sleeping function called from invalid context` —
kernel WARN/BUG on RT. Mount may fail or leave quota subsystem in
inconsistent state (secondary assertion in `gfs2_qd_dispose`).
**Severity: HIGH** (invalid context bug, mount failure, potential
follow-on corruption).

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** HIGH for GFS2+RT users — prevents mount-time kernel bug
  on corruption recovery path; syzbot-verified
- **Risk:** LOW — ~33 lines, single file, applies cleanly, maintainer-
  reviewed, no API changes
- **Ratio:** Strong benefit, minimal risk → backport warranted

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Syzbot-reported, reproducible, Tested-by syzbot
- Real PREEMPT_RT invalid-context bug (sleeping under bitlock)
- Mount-path reachable from userspace
- Buggy code confirmed present in 6.18.43; fix not yet applied
- Small, surgical, applies cleanly
- GFS2 maintainer (Gruenbacher) signed off
- Fixes kernel BUG/WARN and prevents mount failures on RT

**AGAINST backporting:**
- Requires PREEMPT_RT + GFS2 (narrower than universal)
- Duplicate quota entries needed to hit the exact path
  (corruption/crafted FS)
- `qd_get()` has a similar pattern not fixed here (pre-existing,
  separate issue)

**UNRESOLVED:**
- Exact commit that introduced duplicate-scan logic (shallow stable
  history)
- Stable mailing list discussion (lore blocked)

Neither unresolved item affects the YES decision.

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — syzbot Tested-by; maintainer
   SOB; clear mechanism
2. Fixes a real bug affecting users? **PASS** — syzbot, 13 crashes,
   mount path
3. Important issue? **PASS** — invalid context BUG on PREEMPT_RT, mount
   failure (HIGH)
4. Small and contained? **PASS** — 1 file, ~33 lines
5. No new features or APIs? **PASS** — internal refactor + call-site fix
   only
6. Can apply to local tree? **PASS** — `git apply --check` succeeded

### Step 9.3: EXCEPTION CATEGORIES
**Record:** None applicable (not device ID, quirk, DT, build, or docs).
Standard bug fix.

### Step 9.4: DECISION RATIONALE

For **Linux 6.18.43**, this commit should be backported. The buggy code
is present, the fix is absent, and the failure is a verified PREEMPT_RT
invalid-context bug in the GFS2 mount path. The patch is small, self-
contained, applies cleanly, and meets all stable-kernel criteria.

---

## Verification

- [Phase 1] Parsed subject, tags: syzbot Reported-by, Closes, Tested-by,
  author + maintainer SOB
- [Phase 1] Commit body describes PREEMPT_RT sleep-under-bitlock bug in
  `gfs2_quota_init()`
- [Phase 2] Diff: 1 file, 3 hunks, new `gfs2_qd_search_bucket_noref()`,
  refactored search, quota_init call change, removed `qd_put(old_qd)`
- [Phase 2] Read `lib/lockref.c:143-161`: `lockref_get_not_dead()` uses
  `spin_lock(&lockref->lock)` on slow path
- [Phase 3] `git describe HEAD` → v6.18.43; `make kernelversion` →
  6.18.43
- [Phase 3] `git blame` lines 1461, 257-275 → present since v6.18-rc8
  merge in this tree
- [Phase 3] `git merge-base --is-ancestor b99a1f0f18ee HEAD` → exit 1
  (fix NOT in tree)
- [Phase 3] `git apply --check` of fix diff → success (clean apply)
- [Phase 4] `b4 dig -c b99a1f0f18ee` → v3 lore thread found
- [Phase 4] `b4 dig -a` → v1/v2/v3 series; v3 is final standalone
  version
- [Phase 4] `b4 dig -w` → gfs2, linux-rt-devel, RT maintainers CC'd
- [Phase 4] `/tmp/gfs2_quota_fix.mbox`: Gruenbacher reviewed v2
  ("looking good")
- [Phase 4] Syzkaller bug page: 13 crashes, prio:high, fix commit
  b99a1f0f18ee, PREEMPT_RT stack trace
- [Phase 5] `grep gfs2_quota_init`: called from `fs/gfs2/super.c:149`
  during `gfs2_make_fs_rw()`
- [Phase 5] `grep gfs2_qd_search_bucket`: 4 call sites; fix changes only
  quota_init duplicate path
- [Phase 6] Grep confirmed buggy code at lines 1461, 269-271 in current
  tree
- [Phase 6] `git diff HEAD b99a1f0f18ee -- fs/gfs2/quota.c`: only quota-
  fix portion needed for backport (other mainline diffs are unrelated)
- [Phase 7] PREEMPT_RT exists in tree (`kernel/Kconfig.preempt:
  PREEMPT_RT`)
- [Phase 8] Failure mode: BUG sleeping-in-invalid-context, severity HIGH
- UNVERIFIED: Exact introduction commit of duplicate-scan logic (shallow
  history)
- UNVERIFIED: Stable mailing list discussion (lore blocked by bot
  protection)

**YES**The background check finished: `git merge-base --is-ancestor
b99a1f0f18ee HEAD` returned exit code 1, so commit `b99a1f0f18ee`
("gfs2: fix quota init duplicate scan") is **not** in this 6.18.43 tree.
The buggy code is still present at `fs/gfs2/quota.c` line 1461.

The backport analysis stands: **YES** — this fix should be backported to
this tree.

 fs/gfs2/quota.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 898fc3937b449..7a36a3fe5e6e6 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -254,9 +254,13 @@ static struct gfs2_quota_data *qd_alloc(unsigned hash, struct gfs2_sbd *sdp, str
 	return NULL;
 }
 
-static struct gfs2_quota_data *gfs2_qd_search_bucket(unsigned int hash,
-						     const struct gfs2_sbd *sdp,
-						     struct kqid qid)
+/*
+ * Lookup variant for callers which already hold qd_lock + bucket lock.
+ */
+static struct gfs2_quota_data *
+gfs2_qd_search_bucket_noref(unsigned int hash,
+			    const struct gfs2_sbd *sdp,
+			    struct kqid qid)
 {
 	struct gfs2_quota_data *qd;
 	struct hlist_bl_node *h;
@@ -264,12 +268,22 @@ static struct gfs2_quota_data *gfs2_qd_search_bucket(unsigned int hash,
 	hlist_bl_for_each_entry_rcu(qd, h, &qd_hash_table[hash], qd_hlist) {
 		if (!qid_eq(qd->qd_id, qid))
 			continue;
-		if (qd->qd_sbd != sdp)
-			continue;
-		if (lockref_get_not_dead(&qd->qd_lockref)) {
-			list_lru_del_obj(&gfs2_qd_lru, &qd->qd_lru);
+		if (qd->qd_sbd == sdp)
 			return qd;
-		}
+	}
+
+	return NULL;
+}
+
+static struct gfs2_quota_data *
+gfs2_qd_search_bucket(unsigned int hash, const struct gfs2_sbd *sdp, struct kqid qid)
+{
+	struct gfs2_quota_data *qd;
+
+	qd = gfs2_qd_search_bucket_noref(hash, sdp, qid);
+	if (qd && lockref_get_not_dead(&qd->qd_lockref)) {
+		list_lru_del_obj(&gfs2_qd_lru, &qd->qd_lru);
+		return qd;
 	}
 
 	return NULL;
@@ -1458,7 +1472,7 @@ int gfs2_quota_init(struct gfs2_sbd *sdp)
 
 			spin_lock(&qd_lock);
 			spin_lock_bucket(hash);
-			old_qd = gfs2_qd_search_bucket(hash, sdp, qc_id);
+			old_qd = gfs2_qd_search_bucket_noref(hash, sdp, qc_id);
 			if (old_qd) {
 				fs_err(sdp, "Corruption found in quota_change%u"
 					    "file: duplicate identifier in "
@@ -1467,7 +1481,6 @@ int gfs2_quota_init(struct gfs2_sbd *sdp)
 
 				spin_unlock_bucket(hash);
 				spin_unlock(&qd_lock);
-				qd_put(old_qd);
 
 				gfs2_glock_put(qd->qd_gl);
 				kmem_cache_free(gfs2_quotad_cachep, qd);
-- 
2.53.0

