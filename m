Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FABE56060E;
	Mon, 19 Oct 2026 13:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418249; cv=none; b=cQQuVdgoCYoVsTnUSPx6XXzKgDr4gcdCPICVPVYli+L4osAqYnNHz8IES8VKWJj3KDgj56pR9DUfiit945xbCF4xI47pjy+KCcZNXT2YYQJrb6Hw4MTyMClMiIzevLfbOXZGzg92SQzkpFw4e6y6S1y08XUCEXdGoqJr/wtH5Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418249; c=relaxed/simple;
	bh=ZurOGsfyONY0BT3+yL2fwTxVMYH4sihGfdJZcmpDjUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q9dkYSMvUoXQyjz5gjenlPIjY5Y0+F5oy2QdP0+OEVutV0GOdaIfklAbm98JFRBaxbLmWx+sGOrRlz+y+GXczJooe3mvix8gtRRWQyeOWqN0DJn3KMuY2YHtsSI8QERgAXO13qrrjZqpl45d08hk83+7sWbFNeSXCh1yLB8Enyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OYMNfXwf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OYMNfXwf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA421F000C8;
	Mon, 19 Oct 2026 13:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418246;
	bh=5dfLBhlJU9dTFBKNxV+OINhjJmjUkAJbcLNa6+f0iac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OYMNfXwf00fBgkKpjK7W7IpbyBUm/LCuHowlQVX4p6qaPwyHMa/GvUq4xS6cP1NCu
	 p2fmUVachrCDBVwPrcHx71F2xyfZlQoQviBkOTGOwHbGFj0xNDRDqkZOGW/f9MALYF
	 77HkX+QUQ0JJV7R4fpldKnR4XSvRxuB+1oyebd3zosyWcY/KljTqsytLNUpDhFYL14
	 HTn5XDJ5a7gIluaEEBSnQjSwtqn9xumPQz/gDm1w3iImb4Yrs7pii+ApqaJgoSLTYI
	 RmBn6vWhQPpAWHneDYDZoy3EiWpVXali6cGjoUCxStY2QQrX/ZPoRkea0jbU97x6Ci
	 xrsLZ3uLCpqBQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xiubo Li <xiubo.li@clyso.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	amarkuze@redhat.com,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] ceph: fix use-after-dereference of NULL ci in __ceph_remove_cap()
Date: Mon, 19 Oct 2026 09:46:47 -0400
Message-ID: <20261019135441.1420968-116-sashal@kernel.org>
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

From: Xiubo Li <xiubo.li@clyso.com>

[ Upstream commit a354d7eaa1a57f1532c8072a424cc2d339a73cc0 ]

The NULL check for "ci" in __ceph_remove_cap() was dead code because
ci was dereferenced via &ci->netfs.inode before the check, and
cap->session was dereferenced via session->s_mdsc->fsc->client even
earlier.  On a double-remove, both cap->ci and cap->session are set
to NULL by the first call, so the second call would crash before
ever reaching the guard.

Move ci, session, cl, and inode initializations after the NULL check
so that the early-return actually works.

Signed-off-by: Xiubo Li <xiubo.li@clyso.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: this is a real NULL-deref regression in this
6.12 tree, the hunk matches locally, and the original crash was
production-confirmed.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [ceph] [fix] restore a dead NULL-ci guard in
`__ceph_remove_cap()` so a second remove does not crash

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Xiubo Li <xiubo.li@clyso.com> (author; Ceph FS
  maintainer)
- Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
- Signed-off-by: Ilya Dryomov <idryomov@gmail.com> (Ceph maintainer who
  applied it)
- No Fixes: tag (expected for this review pipeline)
- No Reported-by / Tested-by / Link / Cc: stable
- Ignore any pipeline “Upstream commit” / “Signed-off-by: Sasha Levin”
  markers; they are not part of this evaluation

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: the `if (!ci)` early-return in `__ceph_remove_cap()` is dead.
  `ci` is used as `&ci->netfs.inode` before the check, and
  `cap->session` is used as `session->s_mdsc->fsc->client` even earlier.
- Symptom/failure mode: on a second remove, `cap->ci` (and often
  `cap->session`) are already NULL, so the second call NULL-derefs and
  oopses before the guard.
- Version info in the message: none.
- Root cause (author): initializers were placed before the NULL check,
  so the check cannot run.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not disguised. Explicit crash fix: move loads after the existing
“already removed” guard.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `fs/ceph/caps.c` only (+10 / -7; net ~3 lines of real change)
- Function: `__ceph_remove_cap()`
- Scope: single-function surgical fix

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before (this tree, `fs/ceph/caps.c` 1142–1155):
  - `session = cap->session`
  - `cl = session->s_mdsc->fsc->client`  (deref session)
  - `ci = cap->ci`
  - `inode = &ci->netfs.inode`           (deref ci)
  - then `if (!ci) return;`
- After:
  - declare the locals
  - `ci = cap->ci; if (!ci) return;`
  - then load `session`, `cl`, `inode`
- Path: second/concurrent remove of the same `struct ceph_cap`. Normal
  first remove is unchanged.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: NULL pointer dereference (memory-safety), restoring a
  race/double-remove guard
- Mechanism: first `__ceph_remove_cap()` always does `cap->ci = NULL`
  and, unless `s_cap_iterator == cap`, also `cap->session = NULL`. A
  second call then hits NULL `session` or NULL `ci` during initializer
  evaluation. Moving the check first makes the early-return real again.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: C initializers must not run before the pointer they
  depend on is checked.
- Minimal: only reorders existing locals; no API/lock/data-structure
  change.
- Regression risk: very low. The only behavioral change on the already-
  removed path is dropping `doutc(cl, "inode is NULL\n")`, which could
  not run safely anyway because `cl` comes from `session`.
- Residual: `session` is still not NULL-checked after `ci` is confirmed
  non-NULL. In this tree `cap->session` is only set to NULL in
  `__ceph_remove_cap()` (non-iterator case) and in
  `iterate_session_caps()` after `!cap->ci`, so session-NULL with ci-
  non-NULL is not a current assignment pattern.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Function exists since Sage Weil 2009 (`a8599bd821d084`).
- Real NULL-ci guard added in `e5cafce3ad0f8` (“ceph: fix race in
  concurrent __ceph_remove_cap invocations”, Luis Henriques, 2020; in
  v5.11-rc1). That commit *moved* `mdsc` init *after* `if (!ci)` for
  this exact crash.
- Regression: `38d46409c4639` (“ceph: print cluster fsid and client
  global_id in all debug logs”, Xiubo Li, 2023; in v6.7-rc1) added `cl =
  session->s_mdsc->fsc->client` and `inode = &ci->netfs.inode` *before*
  the check so `doutc()` could use them. That made the 2020 guard dead
  again.

Step 3.2: FOLLOW THE FIXES: TAG
Record: no Fixes: tag. The commit that reintroduced the crash is
`38d46409c4639`, which **is** an ancestor of this tree (`git merge-base
--is-ancestor` exit 0). Original 2020 fix `e5cafce3ad0f8` is also here.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- `ea60ed6fcf29e` — UAF in `__ceph_remove_cap()` (rb_erase ordering);
  already here.
- `a76d0a9c288ea` — wrapper `ceph_remove_cap()` with its own `if (!ci)`
  check; already here.
- Recent `fs/ceph/caps.c` work is unrelated (revoke, UAF in
  kick_flushing, deadcode).
- Standalone; subject is not “patch X/Y”. A later mainline series
  proposing `RB_CLEAR_NODE()` instead of `ci=NULL` is **not** in this
  tree (`ceph_cap_is_removed` does not exist) and is not required for
  this fix.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Xiubo Li is listed in MAINTAINERS for Ceph FS and is a regular
`fs/ceph/` contributor in this history. Ilya Dryomov (other Ceph
maintainer) committed it.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: none. It only reorders locals against code this tree already has
(`ci->netfs.inode`, `doutc`, `lockdep_assert_held`). Applies standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- Mainline SHA: `a354d7eaa1a57f1532c8072a424cc2d339a73cc0` (not an
  ancestor of HEAD; object exists locally).
- `b4 dig -c a354d7eaa1a5`: https://patch.msgid.link/20260714-ceph-fix-
  remove-cap-v1-1-27b5bc6ee2f6@clyso.com
- `b4 dig -a`: single v1, no v2/v3.
- Thread is two messages: the patch and Dubeyko “Makes sense.” +
  Reviewed-by. No NAK, no requested respin.
- Applied by Ilya Dryomov (CommitDate Wed Aug 26 2026).

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): Xiubo Li, Ilya Dryomov, Alex Markuze, Viacheslav
Dubeyko, ceph-devel, linux-kernel. Right maintainers were on To/Cc.

Step 4.3: SEARCH FOR THE BUG REPORT
Record:
- This 2026 patch itself has no new syzbot/bugzilla link.
- The guard it restores was for a **production oops**: Ceph tracker
  43272, “unable to handle kernel NULL pointer at
  `__ceph_remove_cap+0x2a`”. Stack: `trim_caps_cb` →
  `iterate_session_caps` → `dispatch`, with `evict`/`destroy_inode` in
  the trace; MDS reconnect/stale-caps workload. Ilya identified NULL
  `cap->ci`. That is the same function and the same check
  `e5cafce3ad0f8` added (Cc: stable).

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: standalone one-patch series (`change-id: 20260714-ceph-fix-
remove-cap-cf7d8a7a242a`). Unrelated later `RB_CLEAR_NODE` RFC is not a
prerequisite for 6.12.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: UNVERIFIED for lore.kernel.org/stable HTML (Anubis 403). Full
review thread was recovered via `b4 dig -m`. No reviewer asked to skip
stable; no NAK.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `__ceph_remove_cap()` only.

Step 5.2: TRACE CALLERS
Record (this tree):
- `ceph_remove_cap()` in `fs/ceph/caps.c` — wrapper; already has a safe
  `if (!ci) return` using caller `mdsc`, then calls
  `__ceph_remove_cap()`.
- `ceph_purge_inode_cap()` in `fs/ceph/caps.c` — **direct** call, no
  inner NULL check.
- `ceph_purge_inode_cap()` callers: `remove_session_caps_cb()`
  (`fs/ceph/mds_client.c`), `ceph_inode_shutdown()` (`fs/ceph/inode.c`).
- Wrapper callers include `__ceph_remove_caps()` from
  `ceph_evict_inode()`, `trim_caps_cb()`, and cap import/export in
  `caps.c`.
- Context: inode eviction, session teardown, cap trim, MDS dispatch /
  `ceph_con_workfn` workqueue — not a one-time init path.

Step 5.3: TRACE CALLEES
Record: `lockdep_assert_held`, `rb_erase`,
`spin_lock(&session->s_cap_lock)`, `__ceph_queue_cap_release`,
`ceph_put_cap`, `ceph_change_snap_realm`, `__cap_delay_cancel`.
Unchanged by this patch.

Step 5.4: FOLLOW THE CALL CHAIN
Record: reachable from CephFS runtime: MDS reconnect/trim
(`trim_caps_cb` / `iterate_session_caps`) and inode eviction. Userspace
mounts CephFS; MDS recovery and memory reclaim trigger cap trim.
Unprivileged users do not need a special syscall beyond using a mounted
CephFS.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: wrapper `ceph_remove_cap()` already does the check correctly.
`__ceph_remove_cap()` is the remaining broken copy after
`38d46409c4639`. Direct `ceph_purge_inode_cap()` still needs the inner
guard.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: YES. Local tree is **pending-6.12 / 6.12.111** (`git describe
HEAD` = `p-6.12-3-gc504cf0baa3d8`, Makefile VERSION=6 PATCHLEVEL=12
SUBLEVEL=111). Current `fs/ceph/caps.c:1142-1155` is exactly the pre-
patch code. Candidate `a354d7eaa1a5` is **not** an ancestor of HEAD.
Regression `38d46409c4639` (v6.7-rc1) **is** an ancestor.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: clean apply. The old hunk in this checkout matches the commit
diff exactly (verified by matching the current function prologue). No
`netfs.inode` mismatch.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: `e5cafce3ad0f8` is here but is ineffective because of
`38d46409c4639`. No later equivalent reorder exists in this `caps.c`.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [fs/ceph — CephFS client] [IMPORTANT: production distributed
filesystem; not core VFS for every machine, but crash/data-path for all
CONFIG_CEPH_FS users]

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: actively maintained (recent cap UAF/revoke fixes). This
particular guard dates to 2020 and was broken by 2023 debug logging, not
by new 6.12-only infrastructure.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: CephFS client users (`CONFIG_CEPH_FS`). Enterprise/HPC/cloud
deployments commonly run this.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: concurrent `__ceph_remove_cap()` on the same cap — historically
`iterate_session_caps` (`trim_caps_cb` / `remove_session_caps_cb`) vs
inode eviction, especially around MDS reconnect/stale caps. Timing-
dependent; documented as a real oops, not a lab-only theory. Trigger is
kernel Ceph client activity, not a raw unprivileged syscall to an unused
subsystem.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: NULL deref → kernel oops in `__ceph_remove_cap`. Severity
**CRITICAL**. Tracker 43272 is exactly that oops.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: high — restores a stable-worthy crash guard that 6.12 still
  has on paper but cannot execute.
- Risk: very low — ~10-line local reorder, no locking/API change, first-
  remove path identical.
- Ratio: strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real NULL deref / oops, not cleanup.
- Production crash already recorded (tracker 43272); 2020 fix was Cc:
  stable.
- 6.12 contains the v6.7 debug-log regression that killed that guard.
- Tiny, obviously correct, applies cleanly here.
- Written and applied by Ceph maintainers; reviewed with no NAK.
- Direct caller `ceph_purge_inode_cap()` still bypasses the wrapper
  check.

AGAINST:
- No Fixes:/Cc: stable on this 2026 commit (not a negative under these
  rules).
- Affects only CephFS, not every kernel.
- Double-remove is a race, not every cap remove.

UNRESOLVED:
- lore.kernel.org/stable HTML search blocked (Anubis). Review mbox was
  obtained via b4.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — reorder after the pointer
   check; maintainer review + mainline apply.
2. Fixes a real bug that affects users? **PASS** — oops; same class as
   tracker 43272.
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   kernel NULL deref / oops.
4. Small and contained? **PASS** — one function, one file, 17-line diff.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — buggy code present; hunk
   matches 6.12.111.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: not an ID/quirk/DT/build/docs exception. Ordinary crash fix;
qualifies on the main rules.

Step 9.4: MAKE YOUR DECISION
This 6.12 tree still evaluates `session->s_mdsc` and `&ci->netfs.inode`
before `if (!ci)`. That is a crash on a second remove. The patch
restores the 2020 guard with no extra dependencies. It should be
backported.

What the commit solves and why it matters here:
`__ceph_remove_cap()` is supposed to no-op when `cap->ci` is already
NULL (first remove already ran, including the iterate_session_caps
delayed-remove case). In 6.12 those loads happen first, so the second
call oopses. CephFS hits this on cap trim/session teardown versus
eviction.

Risk vs benefit: benefit is avoiding a Ceph client oops; risk is a few
lines of initializer movement.

Concerns: none for this tree. No missing prerequisites; no conflicting
`RB_CLEAR_NODE` conversion.

Verification:
- [Phase 1] Tags: author/reviewer/maintainer SOBs only; no
  Fixes/Reported-by/Cc: stable
- [Phase 2] Diff: `__ceph_remove_cap()` in `fs/ceph/caps.c`, +10/-7,
  move ci/session/cl/inode after `if (!ci)`
- [Phase 3] `git blame fs/ceph/caps.c` 1142–1160: guard from
  `e5cafce3ad0f8` (v5.11); bad inits from `38d46409c4639` (v6.7-rc1)
- [Phase 3] `git show e5cafce3ad0f8`: original stable-bound NULL-ci fix
  moved mdsc after the check
- [Phase 3] `git show 38d46409c4639`: added `cl = session->...` and
  `inode = &ci->netfs.inode` before `if (!ci)`
- [Phase 3] `git merge-base --is-ancestor 38d46409c4639 HEAD` → yes;
  `e5cafce3ad0f8` → yes; `a354d7eaa1a5` → no
- [Phase 4] `b4 dig -c a354d7eaa1a5`: lore
  https://patch.msgid.link/20260714-ceph-fix-remove-
  cap-v1-1-27b5bc6ee2f6@clyso.com
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: Dryomov/Markuze/Dubeyko/ceph-devel CC’d
- [Phase 4] mbox: Dubeyko Reviewed-by, no NAK
- [Phase 4] tracker.ceph.com/issues/43272: production NULL deref in
  `__ceph_remove_cap` from `trim_caps_cb`
- [Phase 5] Callers: wrapper `ceph_remove_cap()` (safe) and
  `ceph_purge_inode_cap()` (unsafe direct)
- [Phase 6] `git describe HEAD`: p-6.12-3-gc504cf0baa3d8; `make
  kernelversion`: 6.12.111; buggy prologue present at caps.c:1144–1155
- [Phase 6] Current function text matches the patch’s old hunk exactly
- [Phase 8] Failure mode: kernel oops on NULL session/ci, severity
  CRITICAL
- UNVERIFIED: lore.kernel.org/stable HTML search (Anubis); not used for
  the verdict

**YES**

 fs/ceph/caps.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 7f4bb62df3def..91cb305815cbd 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1141,18 +1141,21 @@ int ceph_is_any_caps(struct inode *inode)
  */
 void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
 {
-	struct ceph_mds_session *session = cap->session;
-	struct ceph_client *cl = session->s_mdsc->fsc->client;
-	struct ceph_inode_info *ci = cap->ci;
-	struct inode *inode = &ci->netfs.inode;
+	struct ceph_mds_session *session;
+	struct ceph_client *cl;
+	struct ceph_inode_info *ci;
+	struct inode *inode;
 	struct ceph_mds_client *mdsc;
 	int removed = 0;
 
 	/* 'ci' being NULL means the remove have already occurred */
-	if (!ci) {
-		doutc(cl, "inode is NULL\n");
+	ci = cap->ci;
+	if (!ci)
 		return;
-	}
+
+	session = cap->session;
+	cl = session->s_mdsc->fsc->client;
+	inode = &ci->netfs.inode;
 
 	lockdep_assert_held(&ci->i_ceph_lock);
 
-- 
2.53.0

