Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292D143636A;
	Mon, 31 Aug 2026 13:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183214; cv=none; b=cr+jDawbArav4WjcWlJv3pCbKW4lMCdYS44noCXyr/FGwKs59P1gmZ6KIvbpxY57VpMzYE+7tCyiS5U7RxKWIpZAhrXg2Hrl/ZRc+2j2u5SoynPp2wrwp34GXx9i7YL0DUGfkih46g5sAOqewCzqvgiI2D/rewNkKyQu4IHKtes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183214; c=relaxed/simple;
	bh=GgoK44ToOxpQOb9pHrS0uWo5FrJYpbjz15udKZwiH4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n/Zjrd0JBwsmeGZtfqX0AkZgvuwIfm97JgsRp500eKBd6n4/W+lk6crxY5tDGCiztacKAWlKi9c/yZtqIYSRwOLXQ0gxctNHgyl3Vh4VdoExVRnn4PZpeVZyXqMqrQJvJbBDEyuD+OQBdUgzcZ/UVbIGQXuhYRzQI757tv8HO6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nAbybSi7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nAbybSi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDD91F00A3E;
	Mon, 31 Aug 2026 13:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183211;
	bh=vUpCbj518q8jGpORKgaCJbcqBE6unMNUixhJOVRkWu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nAbybSi7sayZdVEQOVempz2oG/rdHC0S7DwaBn7rQ2FpK6WkB1j9ETgV0N5Se8H/t
	 K4s/jYZl/JEaKO/K5IaGyPHTthJfSTc6wt7xVKssMBzgRxBfIeTgNNYOciWESx0Xwb
	 q0S18Uydpa6KNlPPEYCCz7Qxtk4Qb4eRhEv5kvdms6bML9upcQ4TjjsxBdP3sHhrJK
	 ZasCqqmRfp1PlGfDRgX0BVFdFuU4E8nxFAcqdRsy+Sd5wAoth+xbKjnO4vKd7/0j8y
	 dyRq59ZUdtamkgB/w5vPwXr83HbfXtK6Pepr2JAA+3iaXveBRyO8obnfX0YRcd7uWm
	 aNQZNO4gNp8Eg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Breno Leitao <leitao@debian.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] netconsole: take target_cleanup_list_lock in drop_netconsole_target()
Date: Mon, 31 Aug 2026 09:20:39 -0400
Message-ID: <20260831133314.4125787-11-sashal@kernel.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 91aeb87f052367a5a2743cc93777dfb4386f2f14 ]

drop_netconsole_target() unlinks the target while only holding
target_list_lock. However, when the underlying interface has been
unregistered, netconsole_netdev_event() moves the target from
target_list to target_cleanup_list, and netconsole_process_cleanups_core()
walks that list under target_cleanup_list_lock only.

If a user removes the configfs target at the same time the cleanup
worker is iterating target_cleanup_list, list_del() can corrupt the list
because the two paths take disjoint locks while operating on the same
list node.

Acquire target_cleanup_list_lock around the list_del() so the unlink is
serialised against netconsole_process_cleanups_core() regardless of
which list the target currently belongs to. The state transition that
downgrades STATE_DEACTIVATED to STATE_DISABLED is left intact and is
performed under the same combined locking, preserving the existing
ordering with resume_target().

Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260604-netcons_fix_before_move-v3-3-ab055b3a6aa5@debian.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable backport analysis: `netconsole: take target_cleanup_list_lock
in drop_netconsole_target()`

**Local tree:** `v6.18.44` (Linux 6.18.44 stable)
**Mainline commit:** `91aeb87f05236` (not present in this tree)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[netconsole]` `[take/acquire lock]` — Serialize
`drop_netconsole_target()` list unlink against
`netconsole_process_cleanups_core()` by taking
`target_cleanup_list_lock`.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Breno Leitao `<leitao@debian.org>` (author)
- **Signed-off-by:** Paolo Abeni `<pabeni@redhat.com>` (netdev
  committer)
- **Link:** https://patch.msgid.link/20260604-netcons_fix_before_move-
  v3-3-ab055b3a6aa5@debian.org
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, `Reviewed-
  by:`, `Tested-by:`

Notable: netdev maintainer committed it; no syzbot/fuzzer report.

### Step 1.3: Body analysis
**Record:**
- **Bug:** `drop_netconsole_target()` unlinks a target under only
  `target_list_lock`, while `netconsole_netdev_event()` can move the
  target to `target_cleanup_list`, and
  `netconsole_process_cleanups_core()` walks that list under only
  `target_cleanup_list_lock`.
- **Symptom:** Concurrent `list_del()` vs. list iteration can corrupt
  the kernel linked list.
- **Root cause:** Disjoint locks on the same list node.
- **Fix:** Hold `target_cleanup_list_lock` around the `list_del()` path.
- **Version info:** None in the message; bug exists wherever deferred
  cleanup (`target_cleanup_list`) exists.

### Step 1.4: Hidden bug fix?
**Record:** No — this is an explicit concurrency/list-corruption fix,
not disguised cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/net/netconsole.c` (+2 lines on mainline; user's
  diff shows +4 with surrounding context)
- **Function:** `drop_netconsole_target()`
- **Scope:** Single-file, surgical locking fix

### Step 2.2: Code flow change
**Record:**
- **Before:** `list_del(&nt->list)` under `target_list_lock` only.
- **After:** `mutex_lock(&target_cleanup_list_lock)` →
  `spin_lock_irqsave(&target_list_lock)` → state handling + `list_del()`
  → unlock spinlock → `mutex_unlock(&target_cleanup_list_lock)`.
- **Path affected:** Configfs target removal (`drop_item` callback),
  error/admin teardown path.

### Step 2.3: Bug mechanism
**Record:** **Category:** Race condition / list corruption.
**Mechanism:** Two paths operate on the same `list_head` with non-
overlapping locks (`target_list_lock` vs. `target_cleanup_list_lock`).
Matches the locking pattern already used in `enabled_store()` (disable)
and `netconsole_netdev_event()`.

### Step 2.4: Fix quality
**Record:** Obviously correct; mirrors existing lock ordering in the
same file. Minimal regression risk; no API changes. On 6.18.44 the same
mutex addition around `list_del()` is sufficient without
`STATE_DEACTIVATED` logic (not in this tree).

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `drop_netconsole_target()` list unlink dates to
`0bcc1816188e57` (2007). The race was introduced when deferred cleanup
was added in `97714695ef904` (2024-08-13, Breno Leitao). That commit is
an ancestor of this tree.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag. Bug introduced by `97714695ef904`
("Defer netpoll cleanup to avoid lock release during list traversal").

### Step 3.3: Related file history
**Record:** Recent netconsole fixes in this tree include race fixes
(e.g. `00764aa5c9bbb` userdata locking). `STATE_DEACTIVATED` /
`resume_wq` commits (`e8f4005ab2d48`, `220dbe3c76ed1`, `4cfcd6acc295c`)
are on `master` only — **not** in 6.18.44.

### Step 3.4: Author context
**Record:** Breno Leitao authored the deferred-cleanup infrastructure
and this fix. Paolo Abeni committed both.

### Step 3.5: Dependencies
**Record:** Standalone for the cleanup-list race on 6.18.44. Mainline
patch is v3 3/5 of a series, but this specific hunk does not require
other series patches for the race described. `STATE_DEACTIVATED`
handling in mainline is additional context not present here.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c 91aeb87f05236` → https://patch.msgid.link/2026060
4-netcons_fix_before_move-v3-3-ab055b3a6aa5@debian.org
Series: v1 (2026-05-29), v3 (2026-06-04, 5 patches). Applied version is
latest v3.

### Step 4.2: Reviewers
**Record:** `b4 dig -w`: CC'd netdev maintainers (Miller, Kicinski,
Abeni, Dumazet, etc.) and `netdev@vger.kernel.org`.

### Step 4.3: Bug report
**Record:** No external bug report; issue found by code analysis during
the netconsole fix series.

### Step 4.4: Series context
**Record:** Part of "netconsole: Fix reported problems" (v3 0/5). This
patch (3/5) is self-contained for the cleanup-list race.

### Step 4.5: Stable list history
**Record:** No `Cc: stable` or stable-list discussion found in the
downloaded mbox thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `drop_netconsole_target()`,
`netconsole_process_cleanups_core()`, `netconsole_netdev_event()`,
`enabled_store()` (disable path).

### Step 5.2: Callers
**Record:**
- `drop_netconsole_target` → configfs `drop_item` (admin removes target
  via configfs)
- `netconsole_process_cleanups_core` → `netconsole_process_cleanups()`
  and directly from `netconsole_netdev_event()`
- `netconsole_netdev_event` → netdev notifier (interface
  unregister/release/join/changename)

### Step 5.3: Callees
**Record:** `list_del()`, `list_move()`, `do_netpoll_cleanup()`,
`mutex_lock`/`spin_lock_irqsave`.

### Step 5.4: Reachability
**Record:** Requires `CONFIG_NETCONSOLE` + `CONFIG_NETCONSOLE_DYNAMIC`.
Trigger: netdev unregister (or manual disable moving target to cleanup
list) concurrent with configfs target removal. Admin/root configfs
access required — not unprivileged userspace, but reachable in
production netconsole setups.

### Step 5.5: Similar patterns
**Record:** All other paths that touch `target_cleanup_list` already
take `target_cleanup_list_lock` first, then `target_list_lock`.
`drop_netconsole_target()` is the outlier.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current `drop_netconsole_target()` at lines
1329–1331:

```1329:1331:drivers/net/netconsole.c
        spin_lock_irqsave(&target_list_lock, flags);
        list_del(&nt->list);
        spin_unlock_irqrestore(&target_list_lock, flags);
```

`target_cleanup_list` infrastructure is present (since `97714695ef904`).
Bug present since Aug 2024 in this series.

### Step 6.2: Backport complications
**Record:** **Needs rework** — literal mainline patch does not apply
(`git apply --check` fails at line 1452; stable `drop_netconsole_target`
is at ~1323). Adapted backport is trivial: add
`mutex_lock/unlock(&target_cleanup_list_lock)` around the existing
`list_del` block (2 lines).

### Step 6.3: Related fixes already present?
**Record:** Fix `91aeb87f05236` is **not** in this tree (`git merge-base
--is-ancestor` confirms).

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/net/netconsole.c` — **IMPORTANT** (network logging;
used on servers for remote crash logs). Config-gated
(`CONFIG_NETCONSOLE_DYNAMIC`).

### Step 7.2: Activity
**Record:** Actively maintained; multiple netconsole fixes landed in
6.18.y.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Systems using dynamic netconsole (configfs-managed targets),
especially during netdev teardown or target disable concurrent with
configfs removal.

### Step 8.2: Trigger conditions
**Record:** Interface unregister/disable moves target to
`target_cleanup_list`; admin simultaneously removes configfs target.
Uncommon but realistic during network reconfiguration or module unload.
Requires root.

### Step 8.3: Failure mode
**Record:** Kernel linked-list corruption → possible oops/panic.
**Severity: HIGH** (crash); not a security issue for unprivileged users.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Prevents real list corruption in production netconsole
  setups
- **Risk:** Very low — 2-line lock addition matching established pattern
- **Ratio:** Favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real, verifiable race in existing 6.18.44 code
- List corruption can crash the kernel
- Fix is in mainline (`91aeb87f05236`)
- Minimal, obviously correct, matches existing lock ordering
- Bug introduced by code already in this tree (`97714695ef904`)
- Same author who introduced the infrastructure

**AGAINST backport:**
- Narrow audience (`CONFIG_NETCONSOLE_DYNAMIC`)
- Requires admin/configfs action
- Literal patch does not apply cleanly (needs simple adaptation)
- No user/fuzzer report

**Unresolved:** No runtime crash report; no explicit stable nomination
in lore thread.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — lock ordering matches
   sibling paths; committed to mainline by netdev maintainer.
2. Fixes real bug affecting users? **PASS** — concrete list-corruption
   race on configfs removal.
3. Important issue? **PASS** — kernel crash (HIGH severity, niche
   config).
4. Small and contained? **PASS** — 2 lines effective change on this
   tree.
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS with adaptation** — core fix applies;
   literal hunk does not (`git apply --check` fails).

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs).

### Step 9.4: Decision rationale
This is a real concurrency bug in code present in Linux 6.18.44 since
deferred cleanup was added. The fix is minimal, follows the file's
established locking discipline, and is already in mainline. While the
audience is limited to dynamic-netconsole users, list corruption is a
serious failure mode. The patch needs a small backport adjustment for
6.18.44's simpler `drop_netconsole_target()`, but the fix itself is
independent of the `STATE_DEACTIVATED` machinery that exists only on
newer mainline.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
  and `git show 91aeb87f05236`
- **[Phase 2]** Diff analysis: +2 lines on mainline; race between
  `drop_netconsole_target` and `netconsole_process_cleanups_core`
- **[Phase 3]** `git describe HEAD` → v6.18.44
- **[Phase 3]** `git blame` on `drop_netconsole_target`: base from 2007;
  race introduced `97714695ef904` (2024-08-13)
- **[Phase 3]** `97714695ef904` is ancestor of HEAD
- **[Phase 3]** `STATE_DEACTIVATED` commits not in tree
- **[Phase 3]** Fix `91aeb87f05236` not in tree
- **[Phase 4]** `b4 dig -c 91aeb87f05236`: lore URL found
- **[Phase 4]** `b4 dig -a`: v1 and v3 series; v3 is latest
- **[Phase 4]** `b4 dig -w`: netdev maintainers CC'd
- **[Phase 4]** Mbox thread: no stable nomination or Reviewed-by found
- **[Phase 5]** `grep` confirmed all `target_cleanup_list_lock` users
  except `drop_netconsole_target`
- **[Phase 5]** Read `netconsole_netdev_event`, `enabled_store`,
  `netconsole_process_cleanups_core`
- **[Phase 6]** Buggy code confirmed at lines 1329–1331 in local tree
- **[Phase 6]** `git apply --check` on mainline patch: **fails** (needs
  adaptation)
- **[Phase 6]** `git log --oneline -20 -- drivers/net/netconsole.c`:
  active subsystem
- **[Phase 8]** Failure mode: list corruption → crash, HIGH severity,
  config-specific

---

**YES**

 drivers/net/netconsole.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 06345487d6aac..fec111d64f611 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -1326,9 +1326,11 @@ static void drop_netconsole_target(struct config_group *group,
 	unsigned long flags;
 	struct netconsole_target *nt = to_target(item);
 
+	mutex_lock(&target_cleanup_list_lock);
 	spin_lock_irqsave(&target_list_lock, flags);
 	list_del(&nt->list);
 	spin_unlock_irqrestore(&target_list_lock, flags);
+	mutex_unlock(&target_cleanup_list_lock);
 
 	/*
 	 * The target may have never been enabled, or was manually disabled
-- 
2.53.0

