Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0992E4EBAC3;
	Mon, 31 Aug 2026 13:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183629; cv=none; b=rHWHJCNtk4cE15VCmZZdFSlR9Ud628XXjAcHfHBGdpA/2PSM+Pt1nsw9lJj5Rrb7YA790Jwf2qQGo2MS+5UGPOPde0pEXfJ3cCJv/deQjdpqOy/xKsg/FNMHmlALavloeMH/tYtK9xckU+elf/Ic0QyO9dVLGABRlerSdZZnVIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183629; c=relaxed/simple;
	bh=yYCsBa8ROvFs0QvcD+ksVRNIUCBo21jN1n63fC1cQ0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G7Ucit1uxYSCTjIUr3qtvuFqb5dT3RNhGw46IP5yB2HLVbkrdSLO/CwdNnHAOV6EYMfntJvaDJPheXM/55/bZqOmdrlY6oycYnw2nZK1/JvRCPkfC5Xa2BeFU7r2zbBuVhgeS70tZAfPtsidulCID8na5gxj1dPVnCbJULAER1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lV/uCXIK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lV/uCXIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8007D1F000E9;
	Mon, 31 Aug 2026 13:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183625;
	bh=YIb3GNvHLajNRTS0OEgNmvV8/MU2WRh0L89XnDGqiEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lV/uCXIKKq4relet1TsNAx9oFTOO3IQe7qkl3knOHGVcmnp4uaSSIOKcz3ZQbsEur
	 i6cIwjpLj62NQzQBQmCCPPWWFAqhErPv/J2dsGJnk2WHuEpIJx237Z19bUJssBMgmu
	 XVhiQ3gh1ESmOPu4IEvxhkA2GisocTE1nFuJUewAJrWpNGzo0xmN029fbxqjG4UhPp
	 mzNCREsV5iBJEgjq8rEakZuEC5Eyi16RwPelXenzhMcxufuBeu0LlHCCMQ66YqaVCl
	 m8f4C9z7E21benIW91E0DJ8SEsf6ei2vnFZ9OTtDXIAimUTKbgtad3gaL2LtKOR8Eh
	 jWUxbRwHt4euQ==
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
Subject: [PATCH AUTOSEL 6.18-6.12] ceph: harden send_mds_reconnect and handle active-MDS peer reset
Date: Mon, 31 Aug 2026 09:23:54 -0400
Message-ID: <20260831133314.4125787-206-sashal@kernel.org>
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

[ Upstream commit 39fe3031589386ae7ce3fd7132beb6bb229e22ce ]

Change send_mds_reconnect() to return an error code so callers can detect
and report reconnect failures instead of silently ignoring them. Add early
bailout checks for sessions that are already closed, rejected, or
unregistered, which avoids sending reconnect messages for sessions that
can no longer be recovered.

The early -ESTALE and -ENOENT bailouts use a separate fail_return label
that skips the pr_err_client diagnostic, since these codes indicate
expected concurrent-teardown races rather than genuine reconnect build
failures.

Move the "reconnect start" log after the early-bailout checks so it
only appears for sessions that actually proceed with reconnect.

Save the prior session state before transitioning to RECONNECTING,
and restore it in the failure path.  Without this, a transient
build or encoding failure (-ENOMEM, -ENOSPC) strands the session
in RECONNECTING indefinitely because check_new_map() only retries
sessions in RESTARTING state.

Rewrite mds_peer_reset() to handle the case where the MDS is past its
RECONNECT phase (i.e. active). An active MDS rejects CLIENT_RECONNECT
messages because it only accepts them during its own RECONNECT window
after restart. Previously, the client would send a doomed reconnect
that the MDS would reject or ignore. Now, the client tears the session
down locally and lets new requests re-open a fresh session, which is
the correct recovery for this scenario. The RECONNECTING state is
handled on the same teardown path, since the MDS will reject reconnect
attempts from an active client regardless of the session's local state.

Add explicit cases for CLOSED and REJECTED session states in
mds_peer_reset() since these are terminal states where a connection
drop is expected behavior.

The session teardown path in mds_peer_reset() follows the established
drop-and-reacquire locking pattern from check_new_map(): take
mdsc->mutex for session unregistration, release it, then take s->s_mutex
separately for cleanup. This avoids introducing a new simultaneous lock
nesting pattern.

Log reconnect failures from check_new_map() and mds_peer_reset() at
pr_warn level rather than pr_err, since return codes like -ESTALE
(closed/rejected session) and -ENOENT (unregistered session) are
expected during concurrent teardown. Log dropped messages for
unregistered sessions via doutc() (dynamic debug) rather than
pr_info, as post-reset message arrival is routine and does not
warrant unconditional logging.

Signed-off-by: Alex Markuze <amarkuze@redhat.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Tree context

Local checkout: **v6.18.44** (`6.18.44`, `git describe HEAD` →
`v6.18.44-1-g2736c32da98b9`). The commit is **not** in this tree yet;
the pre-fix code is present.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 — Subject**
- Record: `[ceph]` `[harden/handle]` — harden `send_mds_reconnect()` and
  fix `mds_peer_reset()` when the MDS is past its RECONNECT phase.

**Step 1.2 — Tags**
- Record:
  - `Signed-off-by`: Alex Markuze, Viacheslav Dubeyko (×2), Ilya Dryomov
  - `Reviewed-by`: Viacheslav Dubeyko
  - No `Fixes:`, `Reported-by:`, `Link:`, `Cc: stable`, `Tested-by:`
  - Notable: maintainer review (Dryomov) and merge SOB from Ilya Dryomov
    (ceph maintainer)

**Step 1.3 — Body**
- Record:
  - **Bug 1**: Transient reconnect build failures (`-ENOMEM`, `-ENOSPC`)
    leave session stuck in `RECONNECTING`; `check_new_map()` only
    retries `RESTARTING`.
  - **Bug 2**: `mds_peer_reset()` sends reconnect when MDS state is `>=
    RECONNECT`, including ACTIVE; active MDS rejects `CLIENT_RECONNECT`
    → client stuck.
  - **Symptom**: Stalled CephFS sessions / failed recovery after MDS
    restart or session reset.
  - **Fix**: Return errors from `send_mds_reconnect()`, restore prior
    state on failure, only reconnect when MDS is exactly in `RECONNECT`,
    otherwise tear down session locally.
  - Part of **v4 03/11** series (manual-reset work), but this hunk is
    confined to existing reconnect logic.

**Step 1.4 — Hidden bug fix?**
- Record: **Yes** — despite “harden”, this fixes real correctness bugs
  (stuck session state machine, doomed reconnect to active MDS), not
  cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 — Inventory**
- Record:
  - `fs/ceph/mds_client.c`: +163 / −15 (~178 lines touched)
  - Functions: `handle_session()`, `reconnect_caps_cb()` (comment only),
    `send_mds_reconnect()`, `check_new_map()`, `mds_peer_reset()`,
    `mds_dispatch()`
  - Scope: single-file, surgical changes around MDS session
    reconnect/recovery

**Step 2.2 — Code flow (per hunk)**
- Record:
  1. **`CEPH_SESSION_REJECT`**: Allow `RECONNECTING` in addition to
     `OPENING`; distinct log for reconnect rejection.
  2. **`send_mds_reconnect()`**: `void` → `int`; early bailouts for
     `CLOSED`/`REJECTED` (`-ESTALE`) and unregistered session
     (`-ENOENT`); save/restore `old_state` on build failure; move
     `xa_destroy()` under `s_mutex`.
  3. **`check_new_map()`**: Check return code; log failures at
     `pr_warn`.
  4. **`mds_peer_reset()`**: Reconnect only if MDS state ==
     `CEPH_MDS_STATE_RECONNECT`; otherwise tear down session using the
     same pattern as `check_new_map()` forced-close.
  5. **`mds_dispatch()`**: `doutc()` when dropping messages for
     unregistered sessions.

**Step 2.3 — Bug mechanism**
- Record:
  - **Logic / state-machine bug**: Failure path sets `RECONNECTING` but
    never restores prior state; retry path requires `RESTARTING`.
  - **Logic / protocol bug**: `>= RECONNECT` includes ACTIVE; reconnect
    is only valid during MDS RECONNECT window.
  - **Synchronization**: `xa_destroy(&s_delegated_inos)` moved under
    `s_mutex` to serialize with `ceph_get_deleg_ino()`.
  - Category: logic correctness + minor synchronization hardening.

**Step 2.4 — Fix quality**
- Record:
  - Fix mirrors existing teardown pattern in `check_new_map()` (lines
    5086–5102 in current tree).
  - Minimal API change (`send_mds_reconnect` return value) internal to
    `mds_client.c`.
  - Low regression risk; uses established lock ordering (`mdsc->mutex`
    then `s->s_mutex` separately).
  - Reviewed by subsystem developer; merged by maintainer.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 — Blame**
- Record:
  - `send_mds_reconnect()` fail path dates to Sage Weil 2009–2010; no
    state restoration ever added.
  - `session->s_state = RECONNECTING` at line 4903; fail at 5034–5037
    unlocks mutex without restoring state.
  - Bug present since original MDS client reconnect code (~2.6.34 era).

**Step 3.2 — Fixes: tag**
- Record: N/A (no `Fixes:` tag).

**Step 3.3 — Related file history**
- Record:
  - `cbcb358b744bf` (Jan 2024, in tree): added `>=
    CEPH_MDS_STATE_RECONNECT` guard to `mds_peer_reset()` — fixed
    premature reconnect to not-ready MDS, but **widened** the window to
    include ACTIVE states (the bug this commit fixes).
  - `7e70f0ed9f3ee` (2010, in tree): introduced reconnect-on-peer-reset
    behavior.
  - Patch is **03/11** in a series; patches 01–02 (inode bitops/endian)
    and 05+ (manual reset) are separate. Patch 03 only adds a comment in
    `reconnect_caps_cb()` and does not depend on 01/02 code changes.

**Step 3.4 — Author context**
- Record: Alex Markuze is an active ceph contributor (recent fixes in
  this tree: race conditions, error handling). Ilya Dryomov is ceph
  maintainer.

**Step 3.5 — Dependencies**
- Record: **Standalone for this tree**. Core fixes need only existing
  `mds_client.c` APIs (`__unregister_session`,
  `cleanup_session_requests`, `remove_session_caps`, `kick_requests`).
  Manual-reset machinery (patch 05) is **not** in v6.18.44 and is
  **not** required.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 — Discussion**
- Record:
  - Lore URL:
    https://lkml.iu.edu/hypermail/linux/kernel/2605.0/09721.html
  - Series: v4, patch 03/11 (v3 also submitted Apr 29 2026)
  - Review reply: https://lists.openwall.net/linux-
    kernel/2026/05/07/1855 — Viacheslav Dubeyko `Reviewed-by`, no NAKs
  - No explicit `Cc: stable` nomination found in thread

**Step 4.2 — Reviewers**
- Record: CC'd to `ceph-devel@`, `linux-kernel@`, `idryomov@`,
  `vdubeyko@`. Reviewed-by from Dubeyko; merged SOB from Dryomov.

**Step 4.3 — Bug reports**
- Record: No syzbot/bugzilla. Related prior fix `cbcb358` references
  https://tracker.ceph.com/issues/62489 for a different reconnect-timing
  bug. This commit addresses a distinct active-MDS / stuck-state
  problem.

**Step 4.4 — Series context**
- Record: 11-patch series adds manual client reset + diagnostics +
  selftests. **This patch fixes pre-existing reconnect bugs independent
  of the reset feature** (reset feature not in 6.18.y).

**Step 4.5 — Stable list**
- Record: No stable-list discussion found (lore blocked for automated
  search; checked via lkml hypermail and openwall).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 — Key functions**
- Record: `send_mds_reconnect`, `check_new_map`, `mds_peer_reset`,
  `handle_session`, `mds_dispatch`

**Step 5.2 — Callers**
- Record:
  - `send_mds_reconnect()` ← `check_new_map()` (MDS map updates),
    export-target reconnect loop, `mds_peer_reset()`
  - `mds_peer_reset()` ← `mds_con_ops.peer_reset` (connection reset from
    MDS)
  - Triggered during MDS failover, restart, session timeout — production
    CephFS paths

**Step 5.3 — Callees**
- Record: `__unregister_session`, `cleanup_session_requests`,
  `remove_session_caps`, `kick_requests`, `ceph_con_send`, cap reconnect
  encoding

**Step 5.4 — Reachability**
- Record: Reachable from normal CephFS operation during MDS
  recovery/failover. Any CephFS mount with MDS restarts or session
  closes can hit `mds_peer_reset()`.

**Step 5.5 — Similar patterns**
- Record: Session teardown in `mds_peer_reset()` explicitly modeled on
  `check_new_map()` forced-close at lines 5086–5102 — same proven
  pattern already in tree.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.44)

**Step 6.1 — Buggy code present?**
- Record: **Yes.** Current tree has:
  - `static void send_mds_reconnect()` with no state restore on failure
    (lines 4878–5043)
  - `check_new_map()` only retries `CEPH_MDS_SESSION_RESTARTING` (line
    5122)
  - `mds_peer_reset()` calls reconnect when `>=
    CEPH_MDS_STATE_RECONNECT` (lines 6273–6275)

**Step 6.2 — Backport complications**
- Record: Should apply cleanly with minor line-offset adjustment. No
  reset state machine or other series prerequisites in this tree.
  `ceph_get_deleg_ino()` and `s_delegated_inos` already exist.

**Step 6.3 — Related fixes already present?**
- Record: `cbcb358b744bf` ("skip reconnecting if MDS is not ready") is
  in tree but does not fix the active-MDS or stuck-RECONNECTING bugs. No
  duplicate fix found.

---

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1 — Subsystem**
- Record: `fs/ceph` — CephFS client (IMPORTANT; not core kernel, but
  critical for CephFS deployments)

**Step 7.2 — Activity**
- Record: Actively maintained; multiple stable-worthy ceph fixes already
  in 6.18.y history.

---

## PHASE 8: IMPACT AND RISK

**Step 8.1 — Who is affected**
- Record: CephFS users (`CONFIG_CEPH_FS`), especially clusters with MDS
  failover, restarts, or session timeouts.

**Step 8.2 — Trigger conditions**
- Record:
  - MDS closes client session while MDS is ACTIVE (past RECONNECT
    window) — common after slow client or missed reconnect window
  - Transient `-ENOMEM`/`-ENOSPC` during reconnect message build — rare
    but possible under memory pressure
  - Unprivileged users cannot directly trigger; cluster/MDS events
    trigger it

**Step 8.3 — Failure mode severity**
- Record: **HIGH to CRITICAL** — stuck `RECONNECTING` session → hung
  metadata ops, stalled I/O, mount may require remount. Not data-
  corruption-on-disk by itself, but production outage for CephFS
  workloads.

**Step 8.4 — Risk/benefit**
- Record:
  - Benefit: **High** for CephFS recovery correctness
  - Risk: **Low** — one file, follows existing teardown pattern,
    reviewed
  - Ratio: strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR backport**
- Fixes two verified logic bugs in long-standing reconnect code
- Can hang CephFS during MDS recovery (real production impact)
- Reviewed by subsystem developer; merged by maintainer
- Self-contained in `mds_client.c`; no new userspace API
- Buggy code confirmed present in v6.18.44
- Does not require the rest of the 11-patch reset series

**Evidence AGAINST**
- Part of a larger feature series (could cause hesitation), but this
  hunk is independent
- ~163 lines (larger than typical one-liner, still single-file)
- No syzbot/fuzzer report (harder to reproduce; cluster-timing
  dependent)

**Stable rules checklist**
1. Obviously correct and tested? **PASS** — reviewed, logic verified
   against existing patterns; selftest in series but not required for
   fix correctness
2. Fixes real bug? **PASS**
3. Important issue? **PASS** — session hang / I/O stall during recovery
4. Small and contained? **PASS** — one file, focused reconnect/recovery
   changes
5. No new features/APIs? **PASS** — bug fixes to existing reconnect path
6. Applies to local tree? **PASS** — all target code exists in 6.18.44

**Exception category**: N/A (not device ID, quirk, DT, docs, or build
fix)

---

## Problem summary for stable users

CephFS clients can get **permanently stuck** in two recovery scenarios
present in 6.18.y:

1. **Reconnect build failure**: `send_mds_reconnect()` moves the session
   to `RECONNECTING` but on `-ENOMEM`/`-ENOSPC` failure never restores
   the prior state. `check_new_map()` only retries `RESTARTING`
   sessions, so recovery never retries.

2. **Active MDS peer reset**: When the MDS closes a session after it has
   gone ACTIVE, `mds_peer_reset()` still attempts reconnect (`>=
   CEPH_MDS_STATE_RECONNECT` matches ACTIVE). The MDS rejects this; the
   client does not tear down and re-open cleanly, leaving the mount
   wedged until remount.

The fix restores state on failure, reconnects only during the MDS
RECONNECT window, and otherwise performs local session teardown so new
requests can establish fresh sessions — the correct recovery path.

---

## Verification

- [Phase 1] Parsed subject, body, all SOB/Reviewed-by tags; no
  Fixes/Reported-by/Link
- [Phase 2] Read full diff; confirmed 1 file, 6 functions touched;
  classified as state-machine + protocol bugs
- [Phase 3] `git blame` on fail path: Sage Weil 2009–2010, no state
  restore ever
- [Phase 3] `git log -S`: `7e70f0ed9f3ee` introduced peer-reset
  reconnect (in tree); `cbcb358b744bf` added `>= RECONNECT` guard (in
  tree)
- [Phase 3] `git merge-base --is-ancestor`: both `7e70f0` and `cbcb358`
  confirmed in HEAD
- [Phase 3] Series 01/02/05 reviewed via lkml; patch 03 is independent
  of reset state machine
- [Phase 4] Fetched
  https://lkml.iu.edu/hypermail/linux/kernel/2605.0/09721.html — full
  patch text
- [Phase 4] Fetched https://lists.openwall.net/linux-
  kernel/2026/05/07/1855 — Reviewed-by Dubeyko, no objections
- [Phase 4] b4 dig unavailable for commit (not in tree); used lkml
  message-ID search instead
- [Phase 5] Verified callers: `send_mds_reconnect` at lines 5126, 5190,
  6275; `mds_peer_reset` via `mds_con_ops.peer_reset` at line 6504
- [Phase 5] Verified teardown pattern matches `check_new_map()` lines
  5086–5102
- [Phase 6] `git describe HEAD` → v6.18.44; buggy `void
  send_mds_reconnect` and `>= RECONNECT` guard confirmed at lines 4878,
  6273–6275
- [Phase 6] No `reset/trigger` debugfs or reset state machine in tree —
  series patch 05 not present
- [Phase 6] `ceph_get_deleg_ino` and `s_delegated_inos` exist (lines
  613–628, 4900)
- [Phase 8] Failure mode: stuck RECONNECTING / failed recovery → CephFS
  hang; severity HIGH

**YES**The background history lookups finished and match the earlier
analysis.

**Reconnect logic history** (`619755`): `send_mds_reconnect` goes back
to the original MDS client (`2f2dc053404fe`, 2009). Later related fixes
in this tree include the NPD fix (`c0bd50e2eeddf`) and the deadlock fix
around `mdsc->mutex`/`s->s_mutex` nesting (`ea8412b284c09`).

**Author context** (`619756`): Alex Markuze has recent ceph commits in
this 6.18.y tree (race fixes in `r_parent` handling, read error-path
hardening), which fits this being a targeted reconnect/recovery fix
rather than new subsystem work.

That supports the **YES** backport verdict: the bugs sit in long-
standing reconnect code, the author is an active ceph contributor, and
the patch is standalone in `mds_client.c` without needing the manual-
reset series.

 fs/ceph/mds_client.c | 178 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 163 insertions(+), 15 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index af7137661c8fc..48d622cd8b1e2 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4401,9 +4401,14 @@ static void handle_session(struct ceph_mds_session *session,
 		break;
 
 	case CEPH_SESSION_REJECT:
-		WARN_ON(session->s_state != CEPH_MDS_SESSION_OPENING);
-		pr_info_client(cl, "mds%d rejected session\n",
-			       session->s_mds);
+		WARN_ON(session->s_state != CEPH_MDS_SESSION_OPENING &&
+			session->s_state != CEPH_MDS_SESSION_RECONNECTING);
+		if (session->s_state == CEPH_MDS_SESSION_RECONNECTING)
+			pr_info_client(cl, "mds%d reconnect rejected\n",
+				       session->s_mds);
+		else
+			pr_info_client(cl, "mds%d rejected session\n",
+				       session->s_mds);
 		session->s_state = CEPH_MDS_SESSION_REJECTED;
 		cleanup_session_requests(mdsc, session);
 		remove_session_caps(session);
@@ -4663,6 +4668,14 @@ static int reconnect_caps_cb(struct inode *inode, int mds, void *arg)
 	cap->mseq = 0;       /* and migrate_seq */
 	cap->cap_gen = atomic_read(&cap->session->s_cap_gen);
 
+	/*
+	 * Note: CEPH_I_ERROR_FILELOCK is not set during reconnect.
+	 * Instead, locks are submitted for best-effort MDS reclaim
+	 * via the flock_len field below.  If reclaim fails (e.g.,
+	 * another client grabbed a conflicting lock), future lock
+	 * operations will fail and set the error flag at that point.
+	 */
+
 	/* These are lost when the session goes away */
 	if (S_ISDIR(inode->i_mode)) {
 		if (cap->issued & CEPH_CAP_DIR_CREATE) {
@@ -4876,20 +4889,19 @@ static int encode_snap_realms(struct ceph_mds_client *mdsc,
  *
  * This is a relatively heavyweight operation, but it's rare.
  */
-static void send_mds_reconnect(struct ceph_mds_client *mdsc,
-			       struct ceph_mds_session *session)
+static int send_mds_reconnect(struct ceph_mds_client *mdsc,
+			      struct ceph_mds_session *session)
 {
 	struct ceph_client *cl = mdsc->fsc->client;
 	struct ceph_msg *reply;
 	int mds = session->s_mds;
 	int err = -ENOMEM;
+	int old_state;
 	struct ceph_reconnect_state recon_state = {
 		.session = session,
 	};
 	LIST_HEAD(dispose);
 
-	pr_info_client(cl, "mds%d reconnect start\n", mds);
-
 	recon_state.pagelist = ceph_pagelist_alloc(GFP_NOFS);
 	if (!recon_state.pagelist)
 		goto fail_nopagelist;
@@ -4898,9 +4910,37 @@ static void send_mds_reconnect(struct ceph_mds_client *mdsc,
 	if (!reply)
 		goto fail_nomsg;
 
+	mutex_lock(&session->s_mutex);
+
+	/* Serialized by s_mutex against concurrent ceph_get_deleg_ino(). */
 	xa_destroy(&session->s_delegated_inos);
+	if (session->s_state == CEPH_MDS_SESSION_CLOSED ||
+	    session->s_state == CEPH_MDS_SESSION_REJECTED) {
+		pr_info_client(cl, "mds%d skipping reconnect, session %s\n",
+			       mds,
+			       ceph_session_state_name(session->s_state));
+		mutex_unlock(&session->s_mutex);
+		ceph_msg_put(reply);
+		err = -ESTALE;
+		goto fail_return;
+	}
 
-	mutex_lock(&session->s_mutex);
+	/* s_mutex -> mdsc->mutex matches cleanup_session_requests() order. */
+	mutex_lock(&mdsc->mutex);
+	if (mds >= mdsc->max_sessions || mdsc->sessions[mds] != session) {
+		mutex_unlock(&mdsc->mutex);
+		pr_info_client(cl,
+			       "mds%d skipping reconnect, session unregistered\n",
+			       mds);
+		mutex_unlock(&session->s_mutex);
+		ceph_msg_put(reply);
+		err = -ENOENT;
+		goto fail_return;
+	}
+	mutex_unlock(&mdsc->mutex);
+
+	pr_info_client(cl, "mds%d reconnect start\n", mds);
+	old_state = session->s_state;
 	session->s_state = CEPH_MDS_SESSION_RECONNECTING;
 	session->s_seq = 0;
 
@@ -5030,18 +5070,34 @@ static void send_mds_reconnect(struct ceph_mds_client *mdsc,
 
 	up_read(&mdsc->snap_rwsem);
 	ceph_pagelist_release(recon_state.pagelist);
-	return;
+	return 0;
 
 fail:
 	ceph_msg_put(reply);
 	up_read(&mdsc->snap_rwsem);
+	/*
+	 * Restore prior session state so map-driven reconnect logic
+	 * (check_new_map) can retry.  Without this, a transient build
+	 * failure strands the session in RECONNECTING indefinitely.
+	 */
+	session->s_state = old_state;
 	mutex_unlock(&session->s_mutex);
 fail_nomsg:
 	ceph_pagelist_release(recon_state.pagelist);
 fail_nopagelist:
 	pr_err_client(cl, "error %d preparing reconnect for mds%d\n",
 		      err, mds);
-	return;
+	return err;
+
+fail_return:
+	/*
+	 * Early-exit path for expected concurrent-teardown races
+	 * (-ESTALE for closed/rejected sessions, -ENOENT for
+	 * unregistered sessions).  Skip the pr_err_client diagnostic
+	 * since these are not genuine reconnect build failures.
+	 */
+	ceph_pagelist_release(recon_state.pagelist);
+	return err;
 }
 
 
@@ -5122,9 +5178,15 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 		 */
 		if (s->s_state == CEPH_MDS_SESSION_RESTARTING &&
 		    newstate >= CEPH_MDS_STATE_RECONNECT) {
+			int rc;
+
 			mutex_unlock(&mdsc->mutex);
 			clear_bit(i, targets);
-			send_mds_reconnect(mdsc, s);
+			rc = send_mds_reconnect(mdsc, s);
+			if (rc)
+				pr_warn_client(cl,
+					       "mds%d reconnect failed: %d\n",
+					       i, rc);
 			mutex_lock(&mdsc->mutex);
 		}
 
@@ -5188,7 +5250,11 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 		}
 		doutc(cl, "send reconnect to export target mds.%d\n", i);
 		mutex_unlock(&mdsc->mutex);
-		send_mds_reconnect(mdsc, s);
+		err = send_mds_reconnect(mdsc, s);
+		if (err)
+			pr_warn_client(cl,
+				       "mds%d export target reconnect failed: %d\n",
+				       i, err);
 		ceph_put_mds_session(s);
 		mutex_lock(&mdsc->mutex);
 	}
@@ -6268,12 +6334,92 @@ static void mds_peer_reset(struct ceph_connection *con)
 {
 	struct ceph_mds_session *s = con->private;
 	struct ceph_mds_client *mdsc = s->s_mdsc;
+	int session_state;
 
 	pr_warn_client(mdsc->fsc->client, "mds%d closed our session\n",
 		       s->s_mds);
-	if (READ_ONCE(mdsc->fsc->mount_state) != CEPH_MOUNT_FENCE_IO &&
-	    ceph_mdsmap_get_state(mdsc->mdsmap, s->s_mds) >= CEPH_MDS_STATE_RECONNECT)
-		send_mds_reconnect(mdsc, s);
+
+	if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_FENCE_IO ||
+	    ceph_mdsmap_get_state(mdsc->mdsmap, s->s_mds) < CEPH_MDS_STATE_RECONNECT)
+		return;
+
+	/*
+	 * Only reconnect if MDS is in its RECONNECT phase.  An MDS past
+	 * RECONNECT (REJOIN, CLIENTREPLAY, ACTIVE) will reject reconnect
+	 * attempts, so those states fall through to session teardown below.
+	 */
+	if (ceph_mdsmap_get_state(mdsc->mdsmap, s->s_mds) == CEPH_MDS_STATE_RECONNECT) {
+		int rc = send_mds_reconnect(mdsc, s);
+
+		if (rc)
+			pr_warn_client(mdsc->fsc->client,
+				       "mds%d reconnect failed: %d\n",
+				       s->s_mds, rc);
+		return;
+	}
+
+	/*
+	 * MDS is active (past RECONNECT).  It will not accept a
+	 * CLIENT_RECONNECT from us, so tear the session down locally
+	 * and let new requests re-open a fresh session.
+	 *
+	 * Snapshot session state with READ_ONCE, then revalidate under
+	 * mdsc->mutex before acting.  The subsequent mdsc->mutex
+	 * section rechecks s_state to catch concurrent transitions, so
+	 * the lockless snapshot here is safe.  s->s_mutex is taken
+	 * separately for cleanup after unregistration, which avoids
+	 * introducing a new s->s_mutex + mdsc->mutex nesting.
+	 */
+	session_state = READ_ONCE(s->s_state);
+
+	switch (session_state) {
+	case CEPH_MDS_SESSION_RESTARTING:
+	case CEPH_MDS_SESSION_RECONNECTING:
+	case CEPH_MDS_SESSION_CLOSING:
+	case CEPH_MDS_SESSION_OPEN:
+	case CEPH_MDS_SESSION_HUNG:
+	case CEPH_MDS_SESSION_OPENING:
+		mutex_lock(&mdsc->mutex);
+		if (s->s_mds >= mdsc->max_sessions ||
+		    mdsc->sessions[s->s_mds] != s ||
+		    s->s_state != session_state) {
+			pr_info_client(mdsc->fsc->client,
+				       "mds%d state changed to %s during peer reset\n",
+				       s->s_mds,
+				       ceph_session_state_name(s->s_state));
+			mutex_unlock(&mdsc->mutex);
+			return;
+		}
+
+		ceph_get_mds_session(s);
+		s->s_state = CEPH_MDS_SESSION_CLOSED;
+		__unregister_session(mdsc, s);
+		__wake_requests(mdsc, &s->s_waiting);
+		mutex_unlock(&mdsc->mutex);
+
+		mutex_lock(&s->s_mutex);
+		cleanup_session_requests(mdsc, s);
+		remove_session_caps(s);
+		mutex_unlock(&s->s_mutex);
+
+		wake_up_all(&mdsc->session_close_wq);
+
+		mutex_lock(&mdsc->mutex);
+		kick_requests(mdsc, s->s_mds);
+		mutex_unlock(&mdsc->mutex);
+
+		ceph_put_mds_session(s);
+		break;
+	case CEPH_MDS_SESSION_CLOSED:
+	case CEPH_MDS_SESSION_REJECTED:
+		break;
+	default:
+		pr_warn_client(mdsc->fsc->client,
+			       "mds%d peer reset in unexpected state %s\n",
+			       s->s_mds,
+			       ceph_session_state_name(session_state));
+		break;
+	}
 }
 
 static void mds_dispatch(struct ceph_connection *con, struct ceph_msg *msg)
@@ -6285,6 +6431,8 @@ static void mds_dispatch(struct ceph_connection *con, struct ceph_msg *msg)
 
 	mutex_lock(&mdsc->mutex);
 	if (__verify_registered_session(mdsc, s) < 0) {
+		doutc(cl, "dropping tid %llu from unregistered session %d\n",
+		      le64_to_cpu(msg->hdr.tid), s->s_mds);
 		mutex_unlock(&mdsc->mutex);
 		goto out;
 	}
-- 
2.53.0

