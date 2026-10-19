Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2F54C7B2B;
	Mon, 19 Oct 2026 14:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418489; cv=none; b=Kmd/MdOIafUsC9NFue64Vd2/2qmD4PcJl4qqvh02ZKZJjOLcoiT6U+OOewAj/t8qj0jInhfXHNYNdhLnmOBI/j8lKszX0nbxuJ7ZYjLa+TV8wRzS4a2BlZQZrS7nx4JmGBMtWZLSREcN2zsvHqGupD4yU/zMmRbX7rlYpHAuSm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418489; c=relaxed/simple;
	bh=jtz6INkpERdZ7fXTKOwsqLtCyJcTAJTfPTX9u+/pG8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iA3K0LZzoH4/fp4FV6DWVCq2V88uNgqedzeUlbwzZg6L0SbO42YqRq6U+SyMzKLYgwwMqq5Cfle0HM2YBT/piwOaaYcz2XE5fAvcY48reeOcKNsV3V68NyC7k8MFxoUUktCFB/TqB8uAuup1eMtV0WR7GeJDy1U3oDAWIiVA2zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zcbx5XVr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zcbx5XVr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B4D1F000C7;
	Mon, 19 Oct 2026 14:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418486;
	bh=V6K2WhP3zDMm7pCJDjDTcWpb3EHpqlbzXjNyB7l1Km4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zcbx5XVrA+yruLQhJFnAUf8fwVTZeKH1gH3HmOVhVd2l6BrZZPxc24O8kD+pp1pXd
	 r0BILJdjR/yNwvlW26YcaTwHUsutKnU1q/xIDxEyNKERcXnCUNCnhwpn0HHzb2Xhoa
	 0uvlCVI3R/ccKP/ojrSlW0SlQSod0/ie8a2C7OMekp5w3p+6R4o0fuIAr7tdiLeNQc
	 iwj65LMrRVGXizC2XRzk9GufpUL6xgM5HEh7kPV+du4DAG9TiaPnkEibWl2twMIJiV
	 AN+D2ipAOGp3rknSkfIM3s0+LtTwsxsnsVklkvMwXG+dPSX/4Tx0svTVqxpl8ScZ4H
	 /8jiXjNhHZmhw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Guopeng Zhang <zhangguopeng@kylinos.cn>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	viro@zeniv.linux.org.uk,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] fs/namespace: notify pollers of legacy propagation changes
Date: Mon, 19 Oct 2026 09:49:34 -0400
Message-ID: <20261019135441.1420968-283-sashal@kernel.org>
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

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

[ Upstream commit 0ae44a20835e5cf37d03a83e70c92e92deda3703 ]

Changing mount propagation through the legacy mount API changes
user-visible mountinfo contents, including the shared: and master:
optional fields.

The mount_setattr() path already touches the mount namespace after
change_mnt_propagation(), so pollers of /proc/<pid>/mountinfo are woken
when the namespace event changes.

The legacy mount --make-* path also changes propagation through
change_mnt_propagation(), and MOVE_MOUNT_SET_GROUP updates the
propagation relationship of the target mount. Both paths currently
return without touching the affected mount namespace.

As a result, userspace polling /proc/<pid>/mountinfo can miss these
propagation-only changes even though mountinfo has changed.

A simple reproducer that polls /proc/self/mountinfo while changing
propagation shows the inconsistency.

Before this change:

  legacy MS_SHARED: poll ret=0 revents=0x0
  mount_setattr MS_SHARED: poll ret=1 revents=0xa

After this change:

  legacy MS_SHARED: poll ret=1 revents=0xa
  mount_setattr MS_SHARED: poll ret=1 revents=0xa

Fix this by touching the affected mount namespace after successful
propagation changes in do_change_type() and do_set_group().

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Link: https://patch.msgid.link/20260601032911.940507-1-guopeng.zhang@linux.dev
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: the miss is real in 6.18.53, the helpers exist,
and the patch is a small ABI wake-up fix. Below is the full 9-phase
write-up.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: `[fs/namespace] [notify] notify pollers of legacy propagation
changes`

Subsystem is VFS mount-namespace (`fs/namespace.c`). Verb is “notify”,
which here means adding a missing userspace wake-up after a state
change.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Signed-off-by:** Guopeng Zhang `<zhangguopeng@kylinos.cn>` (author)
- **Link:** `https://patch.msgid.link/20260601032911.940507-1-
  guopeng.zhang@linux.dev`
- **Signed-off-by:** Christian Brauner (Amutable) `<brauner@kernel.org>`
  (VFS maintainer; applied the patch)
- **No Fixes: tag** (expected for this review queue)
- **No Cc: stable** (expected)
- **No Reported-by / Tested-by / Reviewed-by / Acked-by**
- Pipeline-only tags (`[Upstream commit …]`, `Signed-off-by: Sasha
  Levin`) ignored per instructions

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `mount(MS_SHARED|MS_PRIVATE|MS_SLAVE|MS_UNBINDABLE)`
  (`do_change_type`) and `move_mount(MOVE_MOUNT_SET_GROUP)`
  (`do_set_group`) change propagation (and therefore
  `/proc/<pid>/mountinfo` `shared:` / `master:` / `unbindable` fields)
  but never call `touch_mnt_namespace()`.
- **Symptom:** `poll()` on `/proc/self/mountinfo` returns 0 /
  `revents=0` after a legacy `--make-*` change. The same change via
  `mount_setattr()` already wakes pollers (`revents=0xa` =
  `EPOLLERR|EPOLLPRI`).
- **Failure mode:** userspace that waits on mountinfo can miss a real,
  user-visible table change.
- **Version info:** none in the message. Bug is in the legacy `mount()`
  path, which has existed since shared-subtree days.
- **Root cause (author):** those two paths return after
  `change_mnt_propagation()` / SET_GROUP list updates without bumping
  `ns->event` or waking `ns->poll`.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not a disguised cleanup. It is an explicit correctness/ABI fix:
pollers must be woken when mountinfo contents change.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- **File:** `fs/namespace.c` only (`+7` lines, no deletions)
- **Functions:** `do_change_type()`, `do_set_group()`
- **Scope:** single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Hunk 1 (`do_change_type`):** after the `change_mnt_propagation()`
  walk, previously returned 0 with no namespace event. After: take
  `guard(mount_locked_reader)()`, then
  `touch_mnt_namespace(mnt->mnt_ns)`, then return 0. Normal success path
  of `mount(--make-shared/slave/private/unbindable)`. Error paths
  unchanged.
- **Hunk 2 (`do_set_group`):** after copying slave/share linkage onto
  `to`, previously returned 0. After: same lock +
  `touch_mnt_namespace(to->mnt_ns)`. Normal success path of
  `MOVE_MOUNT_SET_GROUP`. Error paths unchanged.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** logic/correctness + userspace ABI (missing poll wake-up)
- **Mechanism:** `touch_mnt_namespace()` does `ns->event = ++event` and
  `wake_up_interruptible(&ns->poll)`. `mounts_poll()` in
  `fs/proc_namespace.c` waits on that queue and sets `EPOLLERR|EPOLLPRI`
  when `ns->event` changes. `show_mountinfo` prints `shared:%i`,
  `master:%i`, `propagate_from:%i`, `unbindable` from the same
  propagation state. Those fields change without a corresponding event,
  so pollers keep a stale view.
- Locking: v1 used `lock_mount_hash()` (`write_seqlock`), which bumps
  `mount_lock` and forces seqcount readers to retry. Christian asked for
  `guard(mount_locked_reader)()` (`read_seqlock_excl`) so topology
  seqcount readers are not spuriously invalidated. That is the committed
  form.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- **Quality:** obviously correct. Same helper already used by
  `mount_setattr_commit()` after `change_mnt_propagation()`.
- **Minimal:** two call sites, no API or structural change.
- **Regression risk:** low. Extra exclusive seqlock after
  `namespace_excl` matches existing lock order (`namespace_sem` then
  `mount_lock`). Wake-up is after a successful mutation only. Using the
  reader-exclusive guard avoids extra `mount_lock` sequence bumps, which
  is why v1 was revised.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Propagation loop in `do_change_type` dates to Al Viro / Miklos Szeredi
  (2008–2011); `do_change_type` itself goes back to shared-subtree
  (`07b20889e3052`, contained in v2.6.15-rc1).
- `do_set_group` body is from Pavel Tikhomirov (`9ffb14ef61bab`,
  contained in v5.15-rc1).
- Neither path ever called `touch_mnt_namespace()` until this commit.
- `mount_setattr_commit()` has called `touch_mnt_namespace()` since
  `e257039f0fc7da` / `2a1867219c7b2` (mount_setattr, contained in
  v5.12-rc1). That is the inconsistency the author measured.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. Not applicable. The missing wake-up is original
behavior of `do_change_type`, not a recent regression.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record:
- Related: `12cdd1af7a6d1 do_change_type(): use guards`, `7b99ee2c5c83b
  do_set_group(): use guards` (already in v6.18.53; this patch sits on
  that form).
- `cffd0441872e7` uniform permission checks; `d8cc0362f918d` SET_GROUP
  graph fix — adjacent but not prerequisites for this wake-up.
- Standalone. Not `patch X/Y`.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Guopeng Zhang is not the VFS maintainer. Other `master` commits
under that name are mostly cgroup/docs. This mount patch was applied by
Christian Brauner to `vfs-7.3.mount`.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record:
- Needs `touch_mnt_namespace()`, `guard(mount_locked_reader)()`,
  `do_change_type()`, `do_set_group()`. All exist at v6.18.53
  (`mount_locked_reader` from `d154f18575899`, contained in the 6.18
  cycle).
- Applies standalone. No follow-up in this file after 2026-06-01 that
  amends this wake-up.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- **b4 dig:** https://patch.msgid.link/20260601032911.940507-1-
  guopeng.zhang@linux.dev
- **v1:** 2026-05-29, https://patch.msgid.link/20260529095441.1744006-1-
  guopeng.zhang@linux.dev
- **v2:** 2026-06-01 (committed version)
- Christian on v1: `lock_mount_hash()` would make seqcount readers retry
  on propagation-only changes; use `guard(mount_locked_reader)()`
  instead. Author agreed and sent v2.
- No NAK. Christian applied v2 to `vfs/vfs.git` branch `vfs-7.3.mount`
  (commit `0ae44a20835e`).
- No reviewer `Cc: stable` in the thread.
- lore HTTP fetch returned 403; threads were retrieved with `b4 dig -m`
  / `b4 mbox`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): To/Cc Alexander Viro, Christian Brauner, Jan Kara,
linux-fsdevel, linux-kernel. Brauner reviewed v1 and merged v2. Viro and
Kara were CCed; no extra Acked-by in the mbox.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No syzbot, bugzilla, or extra reporters. Evidence is the
author’s side-by-side poll reproducer (`legacy MS_SHARED: poll ret=0` vs
`mount_setattr: poll ret=1`). Severity from that: userspace misses a
mountinfo update. How many users: not quantified; the interfaces (`mount
--make-*`, `MOVE_MOUNT_SET_GROUP`, poll on mountinfo) are used by
systemd/libmount, `findmnt --poll`, and container runtimes.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Single patch, v1→v2 lock change only. Not part of a larger
series.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org/stable search via WebFetch was 403. No stable
discussion was found in the fsdevel mboxes. UNVERIFIED whether anyone
previously requested or rejected this for -stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

semcode MCP is not available. Callers/callees were traced with grep and
by reading the functions.

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: `do_change_type`, `do_set_group`; they call
`touch_mnt_namespace` and `guard(mount_locked_reader)`.

**Step 5.2: TRACE CALLERS**

Record:
- `do_change_type()` ← `path_mount()` when flags include
  `MS_SHARED|MS_PRIVATE|MS_SLAVE|MS_UNBINDABLE` ← `do_mount()` /
  `mount()` syscall.
- `do_set_group()` ← `vfs_move_mount()` when `MNT_TREE_PROPAGATION` ←
  `move_mount()` with `MOVE_MOUNT_SET_GROUP`.
- `touch_mnt_namespace()` also used from `commit_tree`,
  `set_mount_attributes`, `mount_setattr_commit`, umount/expiry paths.
- `mounts_poll()` is `.poll` for `/proc/<pid>/mounts` and
  `/proc/<pid>/mountinfo`.

**Step 5.3: TRACE CALLEES**

Record: `change_mnt_propagation()` (under `namespace_sem` exclusive),
`invent_group_ids()`, `may_change_propagation()`, then the new lock +
`touch_mnt_namespace()` (`ns->event++`, `wake_up_interruptible`). No
allocation on the added path.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Userspace-reachable via `mount(2)` and `move_mount(2)` with
`CAP_SYS_ADMIN` in the relevant namespace (`may_change_propagation`).
Unprivileged user+mount namespaces (containers) can hit it. Pollers of
procfs mountinfo are the observers. This is a common container/systemd
path, not an obscure config.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: `mount_setattr_commit()` already does `change_mnt_propagation()`
then `touch_mnt_namespace()`. Historical `0e55a7cca4b66`
(“touch_mnt_namespace when the mount flags change”) and `5addc5dd8836a`
(make `/proc/mounts` pollable) are the same contract: if
mountinfo/mounts text changes, bump the event. This commit fills the
remaining propagation-only hole.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:
- Local tree: **6.18.53** (`Makefile` VERSION=6 PATCHLEVEL=18
  SUBLEVEL=53; `git describe HEAD` = `v6.18.53-5049-g0f0bdc2b0dffb`;
  branch `autosel`).
- At **v6.18.53**, `do_change_type()` and `do_set_group()` return after
  propagation updates with **no** `touch_mnt_namespace()`. The bug is
  present.
- The autosel cherry-pick (`3e32bcbd6febbb`) is ignored as pipeline
  state, not as “already selected.”

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply** to v6.18.53. Exact context matches both hunks.
`guard(mount_locked_reader)()` and `touch_mnt_namespace()` are already
in this series.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: `mount_setattr_commit()` already notifies. No earlier equivalent
fix for the legacy/`SET_GROUP` paths at v6.18.53.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **VFS mount namespace** (`fs/namespace.c`,
`fs/proc_namespace.c`). **CORE** for anyone using mounts; poll on
mountinfo is a long-standing userspace ABI.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Actively maintained (Brauner/Viro). The bug is old; the new
mount API made the missing wake-up obvious by contrast.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: Anyone polling `/proc/*/mountinfo` or `/proc/*/mounts` while
another task changes propagation via legacy `mount()` or
`MOVE_MOUNT_SET_GROUP`. Typical: systemd/libmount monitors, `findmnt
--poll`, container runtimes. Not universal on every syscall, but not a
rare driver either.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: Trigger is `mount --make-shared/slave/private/unbindable`
(optionally `MS_REC`) or `move_mount(..., MOVE_MOUNT_SET_GROUP)` while a
poller is waiting. Needs mount-admin capability in the namespace.
Unprivileged in a user+mount ns. Not a race in the kernel sense; it is a
missing notification on a fully deterministic path. Common during
container setup; easy to miss if the same process both changes
propagation and does not poll.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record:
- Failure: poll does not wake; userspace keeps a stale view of
  `shared:`/`master:`/`unbindable` until some later unrelated mount
  event.
- Actual propagation in the kernel is correct; this is not a graph
  corruption bug.
- **Severity: MEDIUM.** Userspace ABI miss, not
  oops/deadlock/corruption. Can make mount monitors and orchestrators
  act on stale topology.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** medium. Restores the documented poll contract for a
  change that is already visible in mountinfo, and matches
  `mount_setattr()`.
- **Risk:** very low. +7 lines, existing helper, lock form chosen by the
  VFS maintainer specifically to avoid extra seqcount retries.
- **Ratio:** favorable for 6.18.y.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

**For backporting:**
- Real, reproduced bug: legacy `MS_SHARED` poll ret=0 vs `mount_setattr`
  poll ret=1.
- User-visible `/proc/<pid>/mountinfo` contents change (`shared:`,
  `master:`, `unbindable`) without a poll event.
- Same subsystem already notifies on the `mount_setattr()` path; this
  closes the hole for `mount()` and `MOVE_MOUNT_SET_GROUP`.
- 7-line, obviously correct change; VFS maintainer reviewed locking and
  merged v2.
- Bug and helpers exist in this 6.18.53 tree; patch applies cleanly.
- Reachable from `mount(2)` / `move_mount(2)`; pollable proc files have
  been an ABI since `5addc5dd8836a`.

**Against backporting:**
- Not a crash, deadlock, data-corruption, or security fix.
- No extra user/syzbot reports; author found it by comparing APIs.
- `do_change_type` has omitted this wake-up since shared-subtree
  (~2.6.15) without a flood of reports.
- No `Cc: stable` in review (absence is expected, not a veto).
- Importance is “oh, that’s not good” ABI correctness, not oops-class.

**Unresolved:**
- Could not query lore.kernel.org/stable over HTTP (403). No evidence
  the patch was previously rejected for stable.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — matches
   `mount_setattr_commit`; v2 lock change from Brauner; author showed
   before/after poll results.
2. Fixes a real bug that affects users? **PASS** — pollers of mountinfo
   miss propagation-only updates; documented proc poll ABI
   (`5addc5dd8836a`, `mounts_poll`).
3. Important issue? **PASS** (medium / “oh, that’s not good”) — stale
   mount-table view for systemd/libmount/container monitors; not oops-
   class, but it is a userspace-visible contract break on core VFS, not
   trivia.
4. Small and contained? **PASS** — 7 lines, one file, two success-path
   sites.
5. No new features or APIs? **PASS** — only wakes existing waiters.
6. Can apply to the local tree? **PASS** — v6.18.53 context matches;
   `mount_locked_reader` and `touch_mnt_namespace` exist.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: None (not a device ID, quirk, DT, build, or docs fix). It is a
normal small ABI/correctness fix.

**Step 9.4: MAKE YOUR DECISION**

This should be backported to **this** 6.18.53 tree. The bug is present
here, the fix is small and already the pattern used by
`mount_setattr()`, and leaving poll silent while mountinfo
`shared:`/`master:` fields change is a real userspace-visible failure,
not a cleanup.

Stable rules in this tree explicitly allow “oh, that’s not good” issues.
A broken `poll()` on `/proc/<pid>/mountinfo` after `mount --make-*` is
that: monitors used in production can miss a topology change the kernel
already committed. Risk is negligible compared with that benefit.

===============================================================
What the commit solves for stable users
===============================================================

On 6.18.y, `mount --make-shared` (and related flags) and
`MOVE_MOUNT_SET_GROUP` update propagation and the text of mountinfo, but
do not increment `mnt_namespace->event` or wake `ns->poll`. Tools
waiting on that fd do not re-read, so they can keep stale `shared:` /
`master:` / `unbindable` state. `mount_setattr()` already notifies. The
patch adds the same `touch_mnt_namespace()` after the two missing
success paths, under `mount_locked_reader` so lookup seqcounts are not
bumped.

No extra commits are required. No new ABI. Regression risk is a spurious
extra wake (harmless) or the brief exclusive seqlock (same class as
other namespace operations).

===============================================================
Verification
===============================================================

- [Phase 1] Parsed message/tags: author Guopeng Zhang; Link msgid
  20260601032911; SOB Christian Brauner; no Fixes/Reported-by/Cc-stable.
- [Phase 2] Diff: +7 lines in `fs/namespace.c`; `do_change_type` and
  `do_set_group` success paths only.
- [Phase 2] Confirmed `touch_mnt_namespace()` increments `ns->event` and
  wakes `ns->poll` (`fs/namespace.c` ~971–976).
- [Phase 2] Confirmed `mounts_poll()` waits on `ns->poll` and sets
  `EPOLLERR|EPOLLPRI` on event change (`fs/proc_namespace.c` 21–37).
- [Phase 2] Confirmed mountinfo prints `shared:`/`master:`/`unbindable`
  from that state (`fs/proc_namespace.c` 158–169).
- [Phase 2] Confirmed `mount_setattr_commit()` already calls
  `touch_mnt_namespace()` after `change_mnt_propagation()` (line 4785).
- [Phase 3] `git describe HEAD` / `make kernelversion` / Makefile: this
  tree is 6.18.53.
- [Phase 3] `git merge-base --is-ancestor 3e32bcbd6febbb v6.18.53`: not
  in v6.18.53 (bug still there).
- [Phase 3] `git show v6.18.53:fs/namespace.c`: both functions return
  without `touch_mnt_namespace`.
- [Phase 3] Blame: `do_change_type` loop 2008–2011; `do_set_group`
  `9ffb14ef61bab` (v5.15-rc1); `git describe --contains 07b20889e3052` →
  v2.6.15-rc1.
- [Phase 3] `mount_locked_reader` present at v6.18.53 (`d154f18575899` /
  `fs/mount.h:164`).
- [Phase 3] Patch context matches v6.18.53 exactly
  (`do_change_type`/`do_set_group` context match: True).
- [Phase 4] `b4 dig -c 0ae44a20835e`: v2 lore URL; `b4 dig -a`: v1
  2026-05-29, v2 2026-06-01.
- [Phase 4] v1 mbox: Brauner requested `guard(mount_locked_reader)`
  instead of `lock_mount_hash`; v2 applied to vfs-7.3.mount; no NAK.
- [Phase 4] `b4 dig -w`: Viro, Brauner, Jan Kara, linux-fsdevel CCed.
- [Phase 4] WebFetch lore/stable: 403; UNVERIFIED stable-list history.
- [Phase 5] Callers: `path_mount` → `do_change_type`; `vfs_move_mount` →
  `do_set_group` for `MOVE_MOUNT_SET_GROUP` (UAPI in
  `include/uapi/linux/mount.h`).
- [Phase 6] Local 6.18.53 has the bug; helpers present; clean apply.
- [Phase 8] Failure mode: missed poll on mountinfo, severity MEDIUM
  (ABI), not oops.
- UNVERIFIED: whether systemd/libmount has a public bug for this
  specific miss; no reporter besides the author.

The patch is small, already matches the `mount_setattr()` notification
path, and restores poll on a core proc file for a change that is already
user-visible in this 6.18.y tree.

**YES**

 fs/namespace.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index 3b6d7271eb3d1..ab050a939cb53 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2932,6 +2932,9 @@ static int do_change_type(const struct path *path, int ms_flags)
 	for (m = mnt; m; m = (recurse ? next_mnt(m, mnt) : NULL))
 		change_mnt_propagation(m, type);
 
+	guard(mount_locked_reader)();
+	touch_mnt_namespace(mnt->mnt_ns);
+
 	return 0;
 }
 
@@ -3414,6 +3417,10 @@ static int do_set_group(const struct path *from_path, const struct path *to_path
 		list_add(&to->mnt_share, &from->mnt_share);
 		set_mnt_shared(to);
 	}
+
+	guard(mount_locked_reader)();
+	touch_mnt_namespace(to->mnt_ns);
+
 	return 0;
 }
 
-- 
2.53.0

