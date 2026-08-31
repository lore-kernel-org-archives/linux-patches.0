Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453954B384C;
	Mon, 31 Aug 2026 13:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184327; cv=none; b=AKKNT06YdPp0T0J7DTrXTyn2uPQeVkVXQL+zZCGBASfQPwXzVEl2yhNuoa8J/M6qNlCm4VVyOC0tZ8ZzMnddUq82IIyzKxT6vc+TpT49rEk5Cl7kP5Vr/IMG5s9SMmNOSpOp0rbDz6qnEInWcOICV9ASJ75/QvtGabDvs0QnKr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184327; c=relaxed/simple;
	bh=jdfpGoPZA9TMbjKm/lVmCyD/toiMM33TSs7TSqWXGIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qM7UaP+j51GxlASVdYvJMXrg7NmKyW66VYoYhCGWNWCMfEN6WOMUo+/f5tcak3F02EU3kEUVA34MNU+HtOFRG2ShtJiBniKlalpt8+UUX41A1YK0Bf5KOi2/5q4PVi97/nEH40T0TqxN8Qm5mfvp0mTNA7O0vbleay2Sz6EErf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aDU5fxeS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aDU5fxeS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE661F00A3E;
	Mon, 31 Aug 2026 13:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184324;
	bh=sRp1R+0aiX6vs4E4s0mu/8jpNsnzWXMkGzc5VOvhLas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aDU5fxeSZNj7eOKX3mpzIQpHNl7o2h3yC7zzsSiaZiU7QsXTQH9wkApgvy9eOC4Ym
	 TRahuSz6BSTPwpQzZ3eqHdF/X5j4nex3mphDTUsnT4Qjfyv4NqWYoYltglTU6vTGdO
	 7mYGP8ElQrR55LPzqBV7NY/YqOyjSo8gxmhc+XZoM09/Ug+y5XoM2t3Pe8kCZ8mANe
	 C6JXcUgKwdwVnI+b17OrHvn/267S1x18ttJN7LJuGPzP5j7Meqwgv5K2voO75q4TYG
	 GqDs5+UlNs2YPmWHFmxwo+7Js4Du41u6XhpqW+RzLvnk7sDTuh0fIDR9XqrWdnRYig
	 zY9s0zJP+defw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alex Markuze <amarkuze@redhat.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	slava@dubeyko.com,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ceph: convert inode flags to named bit positions and atomic bitops
Date: Mon, 31 Aug 2026 09:30:53 -0400
Message-ID: <20260831133314.4125787-625-sashal@kernel.org>
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

From: Alex Markuze <amarkuze@redhat.com>

[ Upstream commit e120e2b666851c4c0c7bffd315ff69a09f9fe4ac ]

Define named bit-position constants for all CEPH_I_* inode flags and
derive the bitmask values from them.  This gives every flag a named
_BIT constant usable with the test_bit/set_bit/clear_bit family.
The intentionally unused bit position 1 is documented inline.

Convert all flag modifications to use atomic bitops (set_bit,
clear_bit, test_and_clear_bit).  The previous code mixed lockless
atomic ops on some flags (ERROR_WRITE, ODIRECT) with non-atomic
read-modify-write (|= / &= ~) on other flags sharing the same
unsigned long.  A concurrent non-atomic RMW can clobber an
adjacent lockless atomic update -- for example, a lockless
clear_bit(ERROR_WRITE) could be silently resurrected by a
concurrent ci->i_ceph_flags |= CEPH_I_FLUSH under the spinlock.
Using atomic bitops for all modifications eliminates this class
of race entirely.

Flags whose only users are now the _BIT form (ERROR_WRITE,
ASYNC_CHECK_CAPS) have their old mask defines removed to document
that callers must use the _BIT constant with the set_bit/test_bit
family.  ERROR_FILELOCK and SHUTDOWN retain their mask defines
because they are still used via bitmask tests in lockless readers
(ceph_inode_is_shutdown, reconnect_caps_cb).

The direct assignment in ceph_finish_async_create() is converted
from i_ceph_flags = CEPH_I_ASYNC_CREATE to set_bit().  This
inode is I_NEW at this point -- still invisible to other threads
and guaranteed to have zero flags from alloc_inode -- so either
form is safe, but set_bit() keeps the conversion uniform.

Signed-off-by: Alex Markuze <amarkuze@redhat.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `ceph: convert inode flags to named bit
positions and atomic bitops`

**Local tree:** Linux **6.18.44** (`git describe HEAD` →
`v6.18.44-1-g2736c32da98b9`)
**Commit analyzed:** `e120e2b666851` (on `master`, **not** in this tree)
**Patch applies cleanly:** `git show e120e2b666851 | git apply --check`
→ success

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[ceph]` `[convert]` — Convert Ceph inode `i_ceph_flags` to
named `_BIT` constants and use atomic bitops for all flag modifications.

### Step 1.2: Tags
**Record:**
| Tag | Value |
|-----|-------|
| Signed-off-by | Alex Markuze, Viacheslav Dubeyko, Ilya Dryomov |
| Reviewed-by | Viacheslav Dubeyko |
| Fixes: | **Absent** (expected for manual review) |
| Reported-by: | **Absent** |
| Tested-by: | **Absent** in commit; series cover letter has `Tested-by:
Viacheslav Dubeyko` |
| Cc: stable | **Absent** |
| Link: | **Absent** |

No syzbot, no CVE, no explicit stable nomination in the commit.

### Step 1.3: Body analysis
**Record:**
- **Bug:** `i_ceph_flags` mixes atomic per-bit ops
  (`set_bit`/`clear_bit`) with non-atomic word RMW (`|=` / `&= ~`) on
  the same `unsigned long`.
- **Symptom:** Concurrent non-atomic RMW can clobber adjacent atomic bit
  updates (example: `clear_bit(ERROR_WRITE)` resurrected by
  `ci->i_ceph_flags |= CEPH_I_FLUSH`).
- **Root cause:** Inconsistent flag-update mechanism on a shared
  bitfield.
- **Versions:** Not stated; prerequisite context is `fbeafe782bd98`
  (ODIRECT atomic bitops), which **is** in 6.18.44.

### Step 1.4: Hidden bug fix?
**Record:** **Yes.** Described as a conversion, but it fixes a real
concurrency defect class (CWE-366 / lost-update on shared bitfield).
Also removes spinlocks from some hot paths (`ERROR_WRITE`,
`ERROR_FILELOCK`) only after making all flag updates atomic.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
| File | Change |
|------|--------|
| `fs/ceph/super.h` | Define `_BIT` constants; convert
`ceph_set/clear_error_write()` to lockless `set_bit`/`clear_bit` |
| `fs/ceph/caps.c` | 12 flag mutations → atomic bitops |
| `fs/ceph/addr.c` | Pool-perm flags → `set_bit`; re-read flags after
update |
| `fs/ceph/file.c` | `ASYNC_CREATE`/`ERROR_WRITE` → atomic; rename
`CEPH_ASYNC_CREATE_BIT` → `CEPH_I_ASYNC_CREATE_BIT` |
| `fs/ceph/locks.c` | Lockless `test_bit`/`clear_bit` for
`ERROR_FILELOCK` |
| `fs/ceph/inode.c`, `snap.c`, `xattr.c`, `mds_client.c/h` | Mechanical
conversions |

**Scope:** 10 files, +74/−82 lines. Multi-file but mechanical; not a
refactor for its own sake.

### Step 2.2: Code flow (key hunks)
**Record:**
- **Before:** `ci->i_ceph_flags |= CEPH_I_FLUSH` (load/OR/store) under
  `cap_delay_lock`; `clear_bit(CEPH_I_ODIRECT_BIT, ...)` under
  `i_ceph_lock` (since `fbeafe782bd98`).
- **After:** All modifications use
  `set_bit`/`clear_bit`/`test_and_clear_bit`.
- **`ceph_set_error_write()`:** spinlock + `|=` → lockless `set_bit`.
- **`ceph_fl_release_lock()`:** spinlock + `&= ~` → lockless
  `clear_bit`.
- **`ceph_pool_perm_check()`:** builds flag mask then `|=` → individual
  `set_bit` calls; re-reads flags under lock before `goto check`.

### Step 2.3: Bug mechanism
**Record:** **Category:** Race condition / lost update on shared
bitfield.
**Mechanism:** Non-atomic word RMW is not composable with concurrent
atomic bitops on the same `unsigned long` unless all writers use atomic
bitops. A non-atomic `|=` can write back a stale word value and undo a
concurrent `clear_bit()` on a different bit.

### Step 2.4: Fix quality
**Record:** Fix is standard kernel practice for multi-bit `unsigned
long` fields. Minimal logic change; no API changes. Low regression risk;
slightly changes locking for `ERROR_WRITE`/`ERROR_FILELOCK`
(intentionally lockless, made safe by uniform atomic bitops).

---

## PHASE 3: GIT HISTORY

### Step 3.1: Blame
**Record:**
- `ceph_set/clear_error_write()`: Jeff Layton, 2017 (`26544c623e741a`) —
  non-atomic RMW under `i_ceph_lock`.
- ODIRECT `clear_bit()`: `fbeafe782bd98` (Viacheslav Dubeyko, Jul 2025)
  — **in 6.18.44**.
- ODIRECT flag itself: `321fe13c93987` (Jeff Layton, 2019) — xfstest
  generic/451 data-coherency fix.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag. Bug partially introduced/worsened by
`fbeafe782bd98`, which converted ODIRECT to atomic bitops while other
flags remained non-atomic RMW.

### Step 3.3: Related history
**Record:**
- `fbeafe782bd98` — Coverity CWE-366 fix for ODIRECT; ancestor of HEAD.
- Commit is **v4 01/11** of “ceph: manual client session reset” series;
  later patches add debugfs/tracepoints (not in 6.18.44).
- On `master`, 3 commits ahead of HEAD in `fs/ceph/super.h`; this is the
  oldest of them.

### Step 3.4: Author context
**Record:** Alex Markuze (Red Hat ceph contributor). Reviewed/acked by
Viacheslav Dubeyko (IBM, authored ODIRECT race fix). Committed by Ilya
Dryomov (ceph maintainer).

### Step 3.5: Dependencies
**Record:** **Standalone for backport purposes.** Patch 1/11 of a larger
series, but only renames/converts existing flag handling. No new
structures or APIs. `git apply --check` passes on 6.18.44 HEAD.

---

## PHASE 4: MAILING LIST / EXTERNAL

### Step 4.1: Discussion
**Record:** `b4 dig -c e120e2b666851` →
https://patch.msgid.link/20260507122737.2804094-2-amarkuze@redhat.com
Series: v1 (RFC 1/4) → v2 (1/7) → v3 (01/11) → v4 (01/11, committed
version).
WebFetch of lore blocked by bot protection; thread retrieved via `b4 dig
-m`.

### Step 4.2: Reviewers
**Record:** CC'd: `ceph-devel@vger.kernel.org`, `idryomov@gmail.com`,
`vdubeyko@redhat.com`. Multiple `Reviewed-by: Viacheslav Dubeyko` across
series. `Tested-by: Viacheslav Dubeyko` on cover letter.

### Step 4.3: Bug reports
**Record:** No external bug report. Related: Coverity CID findings for
ODIRECT in `fbeafe782bd98`. No syzbot.

### Step 4.4: Series context
**Record:** Patch 1 enables atomic flag handling for the manual session-
reset series (patches 2–11). Patches 2–11 are new functionality and
would not accompany this backport; patch 1 is independently correct.

### Step 4.5: Stable list
**Record:** No `Cc: stable` found in mbox thread grep. No stable-list
discussion found.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `ceph_set/clear_error_write()`,
`__cap_delay_requeue_front()`, `__prep_cap()`, `ceph_check_caps()`,
`ceph_block_o_direct()`, `ceph_block_buffered()`,
`ceph_pool_perm_check()`, `wake_async_create_waiters()`,
`ceph_fl_release_lock()`, `ceph_inode_shutdown()`.

### Step 5.2: Callers
**Record:**
- `ceph_start_io_direct()` / `ceph_start_io_read()` — from `file.c`
  read/write paths (common I/O).
- `__cap_delay_requeue_front()` — from `ceph_write_inode()` (sync/fsync
  path).
- `ceph_set/clear_error_write()` — from `file.c`, `addr.c` on I/O
  errors.
- `ceph_check_caps()` — cap management hot path.
- `ceph_fl_release_lock()` — file lock release.

### Step 5.3: Callees
**Record:** `set_bit`, `clear_bit`, `test_bit`, `test_and_clear_bit`,
`clear_and_wake_up_bit`, spinlocks (`i_ceph_lock`, `cap_delay_lock`).

### Step 5.4: Reachability
**Record:** All paths reachable from normal CephFS mount activity — file
I/O, cap flush, pool permission checks, file locking. Triggerable by
unprivileged users with access to mounted Ceph filesystem.

### Step 5.5: Similar patterns
**Record:** `fbeafe782bd98` already uses atomic bitops for ODIRECT only.
`clear_and_wake_up_bit(CEPH_ASYNC_CREATE_BIT, ...)` already uses atomic
ops for async-create. This commit unifies the pattern across all flags.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current tree has:
- `clear_bit(CEPH_I_ODIRECT_BIT, ...)` in `io.c` (`fbeafe782bd98`)
- Non-atomic `ci->i_ceph_flags |= CEPH_I_FLUSH` in
  `__cap_delay_requeue_front()` (line 551)
- Non-atomic `|=` / `&= ~` throughout `caps.c`, `super.h`, etc.

Fix commit `e120e2b666851` is **not** in this tree (only on `master`).

### Step 6.2: Backport complications
**Record:** **Clean apply** verified. No conflicting changes in 6.18.44
for these hunks.

### Step 6.3: Related fixes already present?
**Record:** `fbeafe782bd98` (partial ODIRECT fix with barriers) is
present. The unified atomic-bitops fix is **not** present. No duplicate
fix found.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem / criticality
**Record:** `fs/ceph` — CephFS client. **IMPORTANT** (network
filesystem; data/metadata integrity matters to production users).

### Step 7.2: Activity
**Record:** Actively maintained; recent fixes in caps, MDS client, and
I/O paths in 6.18.y.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** CephFS users (`CONFIG_CEPH_FS`). All workloads using mixed
buffered/direct I/O, cap flushing, write-error handling, or file
locking.

### Step 8.2: Trigger conditions
**Record:** Concurrent flag updates on the same inode from different
code paths — e.g., O_DIRECT mode transition (`io.c`) concurrent with cap
flush flagging (`caps.c`), or (after this patch) lockless
`ERROR_WRITE`/`ERROR_FILELOCK` updates concurrent with cap operations.
Realistic under multi-threaded I/O on the same file.

### Step 8.3: Failure mode severity
**Record:**
- **Corrupted `CEPH_I_ODIRECT` state** → buffered and direct I/O not
  properly excluded → **stale data reads** (the original problem ODIRECT
  flag was added to solve in xfstest generic/451).
- **Corrupted `CEPH_I_ERROR_WRITE`** → incorrect write-error
  propagation.
- **Corrupted cap flush flags** → delayed/incorrect metadata flush to
  MDS.
- **Severity: HIGH** (data integrity / coherency); not a typical kernel
  oops, but silent wrong-data risk.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit: HIGH** for CephFS correctness under concurrency.
- **Risk: LOW** — mechanical, reviewer-approved, applies cleanly, no new
  APIs.
- **Ratio:** Favorable.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Fixes a real, well-understood concurrency defect (atomic vs non-atomic
  bitfield updates).
- Prerequisite asymmetric pattern exists in 6.18.44 since
  `fbeafe782bd98`.
- CephFS data coherency impact (ODIRECT/buffered exclusion).
- Small, mechanical, maintainer-reviewed, applies cleanly.
- Filesystem correctness fix, not a feature add.

**AGAINST backport:**
- No user crash report or syzbot reproduction.
- Part of an 11-patch feature series (though patch 1 is self-contained).
- Most current-tree flag writers hold `i_ceph_lock`, which serializes
  many paths today; the worst races become fully exposed when this patch
  makes `ERROR_WRITE`/`ERROR_FILELOCK` lockless (which it also fixes
  atomically).
- No explicit stable nomination.

**Unresolved:** No runtime reproduction or KCSAN report for the specific
clobber scenario in 6.18.44. Impact inferred from code analysis and
maintainer description.

### Step 9.2: Stable rules checklist

| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — standard atomic-bitops
pattern; `Reviewed-by` + `Tested-by` on series |
| 2. Fixes real bug affecting users? | **PASS** — inode flag lost-update
can corrupt ODIRECT/cap/error state |
| 3. Important issue? | **PASS** — data coherency / metadata flush
correctness (**HIGH**) |
| 4. Small and contained? | **PASS** — ~156 lines, 10 files, mechanical
|
| 5. No new features/APIs? | **PASS** — behavior fix only |
| 6. Can apply to local tree? | **PASS** — verified clean apply on
6.18.44 |

### Step 9.3: Exception categories
**Record:** None (not a quirk, device ID, DT, build, or docs fix).

### Step 9.4: Decision rationale

For **Linux 6.18.44**, the asymmetric flag-update pattern introduced by
`fbeafe782bd98` is present and the fix is absent. The commit eliminates
a class of lost-update races on `i_ceph_flags` that can affect
O_DIRECT/buffered I/O exclusion and cap/error-flag correctness — issues
with direct data-integrity impact for CephFS production users. The patch
is small, obviously correct, self-contained, and applies cleanly.
Conservative stable policy still favors this kind of filesystem
coherency fix over leaving a known race in place.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user query and `git
  show e120e2b666851`
- **[Phase 2]** Diff analysis from provided patch; grep confirmed `|=` /
  `&= ~` and `set_bit`/`clear_bit` coexistence in tree
- **[Phase 3]** `git describe HEAD` → 6.18.44; `git show fbeafe782bd98`;
  `git blame` on `super.h:692-708`, `io.c:30-36`; `git merge-base --is-
  ancestor fbeafe782bd98 HEAD` → ancestor; commit on `master` not in
  HEAD
- **[Phase 4]** `b4 dig -c e120e2b666851` → lore URL; `b4 dig -a` →
  v1–v4 revisions; `b4 dig -w` → recipients; `b4 dig -m` → mbox saved;
  grep found `Tested-by`/`Reviewed-by`, no stable nomination
- **[Phase 5]** Grep callers of `__cap_delay_requeue_front`,
  `ceph_start_io_direct`, `ceph_set_error_write`; read `caps.c`, `io.c`,
  `locks.c`
- **[Phase 6]** `git show e120e2b666851 | git apply --check` → clean;
  grep confirms buggy pattern in HEAD; fix not in HEAD
- **[Phase 7]** Subsystem identified as `fs/ceph`
- **[Phase 8]** Failure mode derived from ODIRECT flag purpose
  (`321fe13c93987` xfstest generic/451) and flag semantics in `super.h`
- **UNVERIFIED:** No runtime reproduction of flag clobber on 6.18.44;
  lore thread body not fully readable via WebFetch (bot blocked), relied
  on mbox grep

**YES**The background searches finished and match the earlier analysis:

- **Commit location:** `e120e2b666851` ("ceph: convert inode flags to
  named bit positions and atomic bitops") is on `master`, not in the
  checked-out **6.18.44** tree.
- **Current tree state:** The asymmetric flag pattern is still present
  (atomic `clear_bit`/`set_bit` for ODIRECT mixed with non-atomic `|=` /
  `&= ~` elsewhere). No equivalent fix is already applied.
- **Backport readiness:** The patch applies cleanly to 6.18.44.

**Verdict for this tree: YES** — backport as a CephFS
concurrency/correctness fix with data-coherency impact.

 fs/ceph/addr.c       | 20 +++++++-------
 fs/ceph/caps.c       | 24 ++++++++---------
 fs/ceph/file.c       | 13 ++++-----
 fs/ceph/inode.c      |  4 +--
 fs/ceph/locks.c      | 22 ++++-----------
 fs/ceph/mds_client.c |  3 ++-
 fs/ceph/mds_client.h |  2 +-
 fs/ceph/snap.c       |  2 +-
 fs/ceph/super.h      | 64 +++++++++++++++++++++++---------------------
 fs/ceph/xattr.c      |  2 +-
 10 files changed, 74 insertions(+), 82 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index ea31c892a1fb1..9d496da6683e7 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -2565,7 +2565,8 @@ int ceph_pool_perm_check(struct inode *inode, int need)
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_string *pool_ns;
 	s64 pool;
-	int ret, flags;
+	int ret;
+	unsigned long flags;
 
 	/* Only need to do this for regular files */
 	if (!S_ISREG(inode->i_mode))
@@ -2607,20 +2608,19 @@ int ceph_pool_perm_check(struct inode *inode, int need)
 	if (ret < 0)
 		return ret;
 
-	flags = CEPH_I_POOL_PERM;
-	if (ret & POOL_READ)
-		flags |= CEPH_I_POOL_RD;
-	if (ret & POOL_WRITE)
-		flags |= CEPH_I_POOL_WR;
-
 	spin_lock(&ci->i_ceph_lock);
 	if (pool == ci->i_layout.pool_id &&
 	    pool_ns == rcu_dereference_raw(ci->i_layout.pool_ns)) {
-		ci->i_ceph_flags |= flags;
-        } else {
+		set_bit(CEPH_I_POOL_PERM_BIT, &ci->i_ceph_flags);
+		if (ret & POOL_READ)
+			set_bit(CEPH_I_POOL_RD_BIT, &ci->i_ceph_flags);
+		if (ret & POOL_WRITE)
+			set_bit(CEPH_I_POOL_WR_BIT, &ci->i_ceph_flags);
+	} else {
 		pool = ci->i_layout.pool_id;
-		flags = ci->i_ceph_flags;
 	}
+	/* Re-read flags under the lock so check: sees the updated bits. */
+	flags = ci->i_ceph_flags;
 	spin_unlock(&ci->i_ceph_lock);
 	goto check;
 }
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index d9924ef55f4a2..2974bb1184264 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -548,7 +548,7 @@ static void __cap_delay_requeue_front(struct ceph_mds_client *mdsc,
 
 	doutc(mdsc->fsc->client, "%p %llx.%llx\n", inode, ceph_vinop(inode));
 	spin_lock(&mdsc->cap_delay_lock);
-	ci->i_ceph_flags |= CEPH_I_FLUSH;
+	set_bit(CEPH_I_FLUSH_BIT, &ci->i_ceph_flags);
 	if (!list_empty(&ci->i_cap_delay_list))
 		list_del_init(&ci->i_cap_delay_list);
 	list_add(&ci->i_cap_delay_list, &mdsc->cap_delay_list);
@@ -1408,7 +1408,7 @@ static void __prep_cap(struct cap_msg_args *arg, struct ceph_cap *cap,
 	      ceph_cap_string(revoking));
 	BUG_ON((retain & CEPH_CAP_PIN) == 0);
 
-	ci->i_ceph_flags &= ~CEPH_I_FLUSH;
+	clear_bit(CEPH_I_FLUSH_BIT, &ci->i_ceph_flags);
 
 	cap->issued &= retain;  /* drop bits we don't want */
 	/*
@@ -1665,7 +1665,7 @@ static void __ceph_flush_snaps(struct ceph_inode_info *ci,
 		last_tid = capsnap->cap_flush.tid;
 	}
 
-	ci->i_ceph_flags &= ~CEPH_I_FLUSH_SNAPS;
+	clear_bit(CEPH_I_FLUSH_SNAPS_BIT, &ci->i_ceph_flags);
 
 	while (first_tid <= last_tid) {
 		struct ceph_cap *cap = ci->i_auth_cap;
@@ -2025,7 +2025,7 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags)
 
 	spin_lock(&ci->i_ceph_lock);
 	if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE) {
-		ci->i_ceph_flags |= CEPH_I_ASYNC_CHECK_CAPS;
+		set_bit(CEPH_I_ASYNC_CHECK_CAPS_BIT, &ci->i_ceph_flags);
 
 		/* Don't send messages until we get async create reply */
 		spin_unlock(&ci->i_ceph_lock);
@@ -2576,7 +2576,7 @@ static void __kick_flushing_caps(struct ceph_mds_client *mdsc,
 	if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE)
 		return;
 
-	ci->i_ceph_flags &= ~CEPH_I_KICK_FLUSH;
+	clear_bit(CEPH_I_KICK_FLUSH_BIT, &ci->i_ceph_flags);
 
 	list_for_each_entry_reverse(cf, &ci->i_cap_flush_list, i_list) {
 		if (cf->is_capsnap) {
@@ -2685,7 +2685,7 @@ void ceph_early_kick_flushing_caps(struct ceph_mds_client *mdsc,
 			__kick_flushing_caps(mdsc, session, ci,
 					     oldest_flush_tid);
 		} else {
-			ci->i_ceph_flags |= CEPH_I_KICK_FLUSH;
+			set_bit(CEPH_I_KICK_FLUSH_BIT, &ci->i_ceph_flags);
 		}
 
 		spin_unlock(&ci->i_ceph_lock);
@@ -2828,7 +2828,7 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
 	spin_lock(&ci->i_ceph_lock);
 
 	if ((flags & CHECK_FILELOCK) &&
-	    (ci->i_ceph_flags & CEPH_I_ERROR_FILELOCK)) {
+	    test_bit(CEPH_I_ERROR_FILELOCK_BIT, &ci->i_ceph_flags)) {
 		doutc(cl, "%p %llx.%llx error filelock\n", inode,
 		      ceph_vinop(inode));
 		ret = -EIO;
@@ -3206,7 +3206,7 @@ static int ceph_try_drop_cap_snap(struct ceph_inode_info *ci,
 		BUG_ON(capsnap->cap_flush.tid > 0);
 		ceph_put_snap_context(capsnap->context);
 		if (!list_is_last(&capsnap->ci_item, &ci->i_cap_snaps))
-			ci->i_ceph_flags |= CEPH_I_FLUSH_SNAPS;
+			set_bit(CEPH_I_FLUSH_SNAPS_BIT, &ci->i_ceph_flags);
 
 		list_del(&capsnap->ci_item);
 		ceph_put_cap_snap(capsnap);
@@ -3395,7 +3395,7 @@ void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
 				if (ceph_try_drop_cap_snap(ci, capsnap)) {
 					put++;
 				} else {
-					ci->i_ceph_flags |= CEPH_I_FLUSH_SNAPS;
+					set_bit(CEPH_I_FLUSH_SNAPS_BIT, &ci->i_ceph_flags);
 					flush_snaps = true;
 				}
 			}
@@ -3647,7 +3647,7 @@ static void handle_cap_grant(struct inode *inode,
 
 		if (ci->i_layout.pool_id != old_pool ||
 		    extra_info->pool_ns != old_ns)
-			ci->i_ceph_flags &= ~CEPH_I_POOL_PERM;
+			clear_bit(CEPH_I_POOL_PERM_BIT, &ci->i_ceph_flags);
 
 		extra_info->pool_ns = old_ns;
 
@@ -4812,7 +4812,7 @@ int ceph_drop_caps_for_unlink(struct inode *inode)
 			doutc(mdsc->fsc->client, "%p %llx.%llx\n", inode,
 			      ceph_vinop(inode));
 			spin_lock(&mdsc->cap_delay_lock);
-			ci->i_ceph_flags |= CEPH_I_FLUSH;
+			set_bit(CEPH_I_FLUSH_BIT, &ci->i_ceph_flags);
 			if (!list_empty(&ci->i_cap_delay_list))
 				list_del_init(&ci->i_cap_delay_list);
 			list_add_tail(&ci->i_cap_delay_list,
@@ -5077,7 +5077,7 @@ int ceph_purge_inode_cap(struct inode *inode, struct ceph_cap *cap, bool *invali
 
 		if (atomic_read(&ci->i_filelock_ref) > 0) {
 			/* make further file lock syscall return -EIO */
-			ci->i_ceph_flags |= CEPH_I_ERROR_FILELOCK;
+			set_bit(CEPH_I_ERROR_FILELOCK_BIT, &ci->i_ceph_flags);
 			pr_warn_ratelimited_client(cl,
 				" dropping file locks for %p %llx.%llx\n",
 				inode, ceph_vinop(inode));
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index ceb5706fe3665..7893150db858b 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -579,12 +579,12 @@ static void wake_async_create_waiters(struct inode *inode,
 
 	spin_lock(&ci->i_ceph_lock);
 	if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE) {
-		clear_and_wake_up_bit(CEPH_ASYNC_CREATE_BIT, &ci->i_ceph_flags);
+		/* Serialized by i_ceph_lock; the two ops touch different bits. */
+		clear_and_wake_up_bit(CEPH_I_ASYNC_CREATE_BIT, &ci->i_ceph_flags);
 
-		if (ci->i_ceph_flags & CEPH_I_ASYNC_CHECK_CAPS) {
-			ci->i_ceph_flags &= ~CEPH_I_ASYNC_CHECK_CAPS;
+		if (test_and_clear_bit(CEPH_I_ASYNC_CHECK_CAPS_BIT,
+				      &ci->i_ceph_flags))
 			check_cap = true;
-		}
 	}
 	ceph_kick_flushing_inode_caps(session, ci);
 	spin_unlock(&ci->i_ceph_lock);
@@ -747,7 +747,8 @@ static int ceph_finish_async_create(struct inode *dir, struct inode *inode,
 			 * that point and don't worry about setting
 			 * CEPH_I_ASYNC_CREATE.
 			 */
-			ceph_inode(inode)->i_ceph_flags = CEPH_I_ASYNC_CREATE;
+			set_bit(CEPH_I_ASYNC_CREATE_BIT,
+				&ceph_inode(inode)->i_ceph_flags);
 			unlock_new_inode(inode);
 		}
 		if (d_in_lookup(dentry) || d_really_is_negative(dentry)) {
@@ -2422,7 +2423,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 	if ((got & (CEPH_CAP_FILE_BUFFER|CEPH_CAP_FILE_LAZYIO)) == 0 ||
 	    (iocb->ki_flags & IOCB_DIRECT) || (fi->flags & CEPH_F_SYNC) ||
-	    (ci->i_ceph_flags & CEPH_I_ERROR_WRITE)) {
+	    test_bit(CEPH_I_ERROR_WRITE_BIT, &ci->i_ceph_flags)) {
 		struct ceph_snap_context *snapc;
 		struct iov_iter data;
 
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index b6c60d787692e..2804c64252980 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1153,7 +1153,7 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 		rcu_assign_pointer(ci->i_layout.pool_ns, pool_ns);
 
 		if (ci->i_layout.pool_id != old_pool || pool_ns != old_ns)
-			ci->i_ceph_flags &= ~CEPH_I_POOL_PERM;
+			clear_bit(CEPH_I_POOL_PERM_BIT, &ci->i_ceph_flags);
 
 		pool_ns = old_ns;
 
@@ -3216,7 +3216,7 @@ void ceph_inode_shutdown(struct inode *inode)
 	bool invalidate = false;
 
 	spin_lock(&ci->i_ceph_lock);
-	ci->i_ceph_flags |= CEPH_I_SHUTDOWN;
+	set_bit(CEPH_I_SHUTDOWN_BIT, &ci->i_ceph_flags);
 	p = rb_first(&ci->i_caps);
 	while (p) {
 		struct ceph_cap *cap = rb_entry(p, struct ceph_cap, ci_node);
diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
index dd764f9c64b9f..c4ff2266bb944 100644
--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -57,9 +57,7 @@ static void ceph_fl_release_lock(struct file_lock *fl)
 	ci = ceph_inode(inode);
 	if (atomic_dec_and_test(&ci->i_filelock_ref)) {
 		/* clear error when all locks are released */
-		spin_lock(&ci->i_ceph_lock);
-		ci->i_ceph_flags &= ~CEPH_I_ERROR_FILELOCK;
-		spin_unlock(&ci->i_ceph_lock);
+		clear_bit(CEPH_I_ERROR_FILELOCK_BIT, &ci->i_ceph_flags);
 	}
 	fl->fl_u.ceph.inode = NULL;
 	iput(inode);
@@ -271,15 +269,10 @@ int ceph_lock(struct file *file, int cmd, struct file_lock *fl)
 	else if (IS_SETLKW(cmd))
 		wait = 1;
 
-	spin_lock(&ci->i_ceph_lock);
-	if (ci->i_ceph_flags & CEPH_I_ERROR_FILELOCK) {
-		err = -EIO;
-	}
-	spin_unlock(&ci->i_ceph_lock);
-	if (err < 0) {
+	if (test_bit(CEPH_I_ERROR_FILELOCK_BIT, &ci->i_ceph_flags)) {
 		if (op == CEPH_MDS_OP_SETFILELOCK && lock_is_unlock(fl))
 			posix_lock_file(file, fl, NULL);
-		return err;
+		return -EIO;
 	}
 
 	if (lock_is_read(fl))
@@ -331,15 +324,10 @@ int ceph_flock(struct file *file, int cmd, struct file_lock *fl)
 
 	doutc(cl, "fl_file: %p\n", fl->c.flc_file);
 
-	spin_lock(&ci->i_ceph_lock);
-	if (ci->i_ceph_flags & CEPH_I_ERROR_FILELOCK) {
-		err = -EIO;
-	}
-	spin_unlock(&ci->i_ceph_lock);
-	if (err < 0) {
+	if (test_bit(CEPH_I_ERROR_FILELOCK_BIT, &ci->i_ceph_flags)) {
 		if (lock_is_unlock(fl))
 			locks_lock_file_wait(file, fl);
-		return err;
+		return -EIO;
 	}
 
 	if (IS_SETLKW(cmd))
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index ba9f96efc8ee7..af7137661c8fc 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3600,7 +3600,8 @@ static void __do_request(struct ceph_mds_client *mdsc,
 
 		spin_lock(&ci->i_ceph_lock);
 		cap = ci->i_auth_cap;
-		if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE && mds != cap->mds) {
+		if (test_bit(CEPH_I_ASYNC_CREATE_BIT, &ci->i_ceph_flags) &&
+		    mds != cap->mds) {
 			doutc(cl, "session changed for auth cap %d -> %d\n",
 			      cap->session->s_mds, session->s_mds);
 
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 0428a5eaf28c6..e91a199d56fd8 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -658,7 +658,7 @@ static inline int ceph_wait_on_async_create(struct inode *inode)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 
-	return wait_on_bit(&ci->i_ceph_flags, CEPH_ASYNC_CREATE_BIT,
+	return wait_on_bit(&ci->i_ceph_flags, CEPH_I_ASYNC_CREATE_BIT,
 			   TASK_KILLABLE);
 }
 
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index c65f2b202b2b3..0ba33749a37dd 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -700,7 +700,7 @@ int __ceph_finish_cap_snap(struct ceph_inode_info *ci,
 		return 0;
 	}
 
-	ci->i_ceph_flags |= CEPH_I_FLUSH_SNAPS;
+	set_bit(CEPH_I_FLUSH_SNAPS_BIT, &ci->i_ceph_flags);
 	doutc(cl, "%p %llx.%llx cap_snap %p snapc %p %llu %s s=%llu\n",
 	      inode, ceph_vinop(inode), capsnap, capsnap->context,
 	      capsnap->context->seq, ceph_cap_string(capsnap->dirty),
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 29a980e22dc26..1168103659b51 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -655,23 +655,34 @@ static inline struct inode *ceph_find_inode(struct super_block *sb,
 /*
  * Ceph inode.
  */
-#define CEPH_I_DIR_ORDERED	(1 << 0)  /* dentries in dir are ordered */
-#define CEPH_I_FLUSH		(1 << 2)  /* do not delay flush of dirty metadata */
-#define CEPH_I_POOL_PERM	(1 << 3)  /* pool rd/wr bits are valid */
-#define CEPH_I_POOL_RD		(1 << 4)  /* can read from pool */
-#define CEPH_I_POOL_WR		(1 << 5)  /* can write to pool */
-#define CEPH_I_SEC_INITED	(1 << 6)  /* security initialized */
-#define CEPH_I_KICK_FLUSH	(1 << 7)  /* kick flushing caps */
-#define CEPH_I_FLUSH_SNAPS	(1 << 8)  /* need flush snapss */
-#define CEPH_I_ERROR_WRITE	(1 << 9) /* have seen write errors */
-#define CEPH_I_ERROR_FILELOCK	(1 << 10) /* have seen file lock errors */
-#define CEPH_I_ODIRECT_BIT	(11) /* inode in direct I/O mode */
-#define CEPH_I_ODIRECT		(1 << CEPH_I_ODIRECT_BIT)
-#define CEPH_ASYNC_CREATE_BIT	(12)	  /* async create in flight for this */
-#define CEPH_I_ASYNC_CREATE	(1 << CEPH_ASYNC_CREATE_BIT)
-#define CEPH_I_SHUTDOWN		(1 << 13) /* inode is no longer usable */
-#define CEPH_I_ASYNC_CHECK_CAPS	(1 << 14) /* check caps immediately after async
-					     creating finishes */
+#define CEPH_I_DIR_ORDERED_BIT		(0)  /* dentries in dir are ordered */
+					     /* bit 1 historically unused */
+#define CEPH_I_FLUSH_BIT		(2)  /* do not delay flush of dirty metadata */
+#define CEPH_I_POOL_PERM_BIT		(3)  /* pool rd/wr bits are valid */
+#define CEPH_I_POOL_RD_BIT		(4)  /* can read from pool */
+#define CEPH_I_POOL_WR_BIT		(5)  /* can write to pool */
+#define CEPH_I_SEC_INITED_BIT		(6)  /* security initialized */
+#define CEPH_I_KICK_FLUSH_BIT		(7)  /* kick flushing caps */
+#define CEPH_I_FLUSH_SNAPS_BIT		(8)  /* need flush snaps */
+#define CEPH_I_ERROR_WRITE_BIT		(9)  /* have seen write errors */
+#define CEPH_I_ERROR_FILELOCK_BIT	(10) /* have seen file lock errors */
+#define CEPH_I_ODIRECT_BIT		(11) /* inode in direct I/O mode */
+#define CEPH_I_ASYNC_CREATE_BIT		(12) /* async create in flight for this */
+#define CEPH_I_SHUTDOWN_BIT		(13) /* inode is no longer usable */
+#define CEPH_I_ASYNC_CHECK_CAPS_BIT	(14) /* check caps after async creating finishes */
+
+#define CEPH_I_DIR_ORDERED		(1 << CEPH_I_DIR_ORDERED_BIT)
+#define CEPH_I_FLUSH			(1 << CEPH_I_FLUSH_BIT)
+#define CEPH_I_POOL_PERM		(1 << CEPH_I_POOL_PERM_BIT)
+#define CEPH_I_POOL_RD			(1 << CEPH_I_POOL_RD_BIT)
+#define CEPH_I_POOL_WR			(1 << CEPH_I_POOL_WR_BIT)
+#define CEPH_I_SEC_INITED		(1 << CEPH_I_SEC_INITED_BIT)
+#define CEPH_I_KICK_FLUSH		(1 << CEPH_I_KICK_FLUSH_BIT)
+#define CEPH_I_FLUSH_SNAPS		(1 << CEPH_I_FLUSH_SNAPS_BIT)
+#define CEPH_I_ERROR_FILELOCK		(1 << CEPH_I_ERROR_FILELOCK_BIT)
+#define CEPH_I_ODIRECT			(1 << CEPH_I_ODIRECT_BIT)
+#define CEPH_I_ASYNC_CREATE		(1 << CEPH_I_ASYNC_CREATE_BIT)
+#define CEPH_I_SHUTDOWN			(1 << CEPH_I_SHUTDOWN_BIT)
 
 /*
  * Masks of ceph inode work.
@@ -684,27 +695,18 @@ static inline struct inode *ceph_find_inode(struct super_block *sb,
 
 /*
  * We set the ERROR_WRITE bit when we start seeing write errors on an inode
- * and then clear it when they start succeeding. Note that we do a lockless
- * check first, and only take the lock if it looks like it needs to be changed.
- * The write submission code just takes this as a hint, so we're not too
- * worried if a few slip through in either direction.
+ * and then clear it when they start succeeding. The write submission code
+ * just takes this as a hint, so we're not too worried if a few slip through
+ * in either direction.
  */
 static inline void ceph_set_error_write(struct ceph_inode_info *ci)
 {
-	if (!(READ_ONCE(ci->i_ceph_flags) & CEPH_I_ERROR_WRITE)) {
-		spin_lock(&ci->i_ceph_lock);
-		ci->i_ceph_flags |= CEPH_I_ERROR_WRITE;
-		spin_unlock(&ci->i_ceph_lock);
-	}
+	set_bit(CEPH_I_ERROR_WRITE_BIT, &ci->i_ceph_flags);
 }
 
 static inline void ceph_clear_error_write(struct ceph_inode_info *ci)
 {
-	if (READ_ONCE(ci->i_ceph_flags) & CEPH_I_ERROR_WRITE) {
-		spin_lock(&ci->i_ceph_lock);
-		ci->i_ceph_flags &= ~CEPH_I_ERROR_WRITE;
-		spin_unlock(&ci->i_ceph_lock);
-	}
+	clear_bit(CEPH_I_ERROR_WRITE_BIT, &ci->i_ceph_flags);
 }
 
 static inline void __ceph_dir_set_complete(struct ceph_inode_info *ci,
diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index caf0fe4d2b1b7..7e8b1b2bda743 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -1056,7 +1056,7 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
 	if (current->journal_info &&
 	    !strncmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN) &&
 	    security_ismaclabel(name + XATTR_SECURITY_PREFIX_LEN))
-		ci->i_ceph_flags |= CEPH_I_SEC_INITED;
+		set_bit(CEPH_I_SEC_INITED_BIT, &ci->i_ceph_flags);
 out:
 	spin_unlock(&ci->i_ceph_lock);
 	return err;
-- 
2.53.0

