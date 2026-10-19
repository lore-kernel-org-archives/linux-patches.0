Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8597527FAA;
	Mon, 19 Oct 2026 14:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418577; cv=none; b=Mnzy0/lWLNNx11QgnAOJKVVox9CnJcdiLKxuscFbadjN6PYNbgbVqQ17gnEAc4C5dth0rcM3pprO49nRvn/iipM+EUXlZMEWOoOoKe8SiEim77KsDFYQNOvZnqLJYL6dmVJiX25WaqX9mkahvSAA+uWxW/cJNkLvvgt3GnbpPNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418577; c=relaxed/simple;
	bh=H5bx14eHgHrAlHbq5Av0q/wky2hMBG7AsqxKUd1ahVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QxQ1fZbmiIcCsvMFDMhv30kGu3PRVhBQtOS4Unoe/Vv1UXnZq3w+edBhXVCMWuaykfsB2Ft+0etknSX4HoZV4CSCSnfHIanZJJPigBJRbtdmdBMLmQVhCYut3BvrOQTu3wXRRjp1sKzfg7Gcs0e6KymTlsxR/eBf41BNHv+dips=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=crbzpjmZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="crbzpjmZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F611F000CA;
	Mon, 19 Oct 2026 14:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418573;
	bh=bk/DI9RFZeexxtAaHB7BsUX5Ya90d3OBuO88xMA81E4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=crbzpjmZVSoNpxAqFY8NxHlBUkXR399233CikFQeuuX5DiJgM70MJAWiY1lfvo1ub
	 W2+3ilFtnh7PhKPZD06WFFm7CIQiNyzlZTuKx8W6+x2vc/oaKJvGpmxR4xwxJM3kJa
	 UMd5g+WNVpybVKWhosji+xfdUxD7D5WOYFMT0Mwx9W7qcQFKofodte61XPjXhzBbqy
	 4DX23o6K3pKB/iiW6CAbtpYt29Zqm+1x6DyXxGZn47SQgVtNQr2WQibMaTT6DO9mx0
	 wLW2KCmQsiToIhaocfenN7460Zi/hCRE+6LhUbvibYdxVGcetJmb3MyeqmiyheHRVf
	 2bY332SQMdNKg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: mld: cancel wiphy work before freeing wiphy
Date: Mon, 19 Oct 2026 09:50:35 -0400
Message-ID: <20261019135441.1420968-344-sashal@kernel.org>
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

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit c99bc4d4e0ba6f4661b2b914c96a597d26e7cc05 ]

When we fail to load the fw during op-mode start, we purge the list
of the async handlers but we don't cancel the work.
Same when we stop the op-mode.

Before freeing wiphy, we need to cancel/flush any pending wiphy work,
otherwise the work will fire with a freed memory.
cfg80211 will do it anyway, but it will warn.

Cancel the work in those cases.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20260714165826.07aa49f755a2.I734a27b1b0eeb5b0e821aee3318fee8dc0a6bc03@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: this is a small UAF/WARN fix in iwlwifi MLD,
the buggy path exists in this 7.3-rc4 tree, and the change is self-
contained.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[iwlwifi/mld] [cancel] cancel wiphy work before freeing wiphy`
- Subsystem: `wifi: iwlwifi: mld`
- Action verb: **cancel** (prevent leftover work from running after
  teardown)
- Intent: stop pending `wiphy_work` before `ieee80211_free_hw()` so it
  cannot run against freed memory

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Reviewed-by: Johannes Berg <johannes.berg@intel.com>` —
  mac80211/cfg80211 and iwlwifi maintainer
- `Link: https://patch.msgid.link/20260714165826.07aa49f755a2.I734a27b1b
  0eeb5b0e821aee3318fee8dc0a6bc03@changeid`
- `Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>`
  (author; ignore any Sasha Levin SOB)
- **No** `Fixes:`, **no** `Cc: stable`, **no** `Reported-by`, **no**
  `Tested-by` — expected for this review pipeline
- Notable: maintainer Reviewed-by; no syzbot/KASAN report in the message

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** On op-mode start firmware-load failure, async handler *list*
  is purged (`iwl_mld_stop_fw()` →
  `iwl_mld_cancel_async_notifications()`), but `async_handlers_wk` is
  not cancelled. Same gap on op-mode stop.
- **Symptom:** Pending wiphy work can run after `ieee80211_free_hw()`;
  cfg80211 still drains/cancels and **WARNs**.
- **Failure mode:** use-after-free of wiphy/`iwl_mld` if the work runs;
  otherwise `WARN_ON(!list_empty(&rdev->wiphy_work_list))` in
  `cfg80211_dev_free()`.
- **Root cause:** cancel of `async_handlers_wk` was removed from the
  generic purge helper; start-fail/stop still free the wiphy with work
  queued.
- **Version info in message:** none

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised. Explicit teardown correctness / UAF-prevention.
Not style cleanup.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/net/wireless/intel/iwlwifi/mld/mld.c` — **+3 lines**, 0
  removed (`git show --stat`: 3 insertions)
- Functions: `iwl_op_mode_mld_start()`, `iwl_op_mode_mld_stop()`
- Scope: **single-file surgical fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
Hunk 1 (`iwl_op_mode_mld_start`, firmware/NVM failure):
- **Before:** `wiphy_unlock` → `rtnl_unlock` → `goto err` →
  `ieee80211_free_hw()` with `async_handlers_wk` possibly still on
  `wiphy_work_list`.
- **After:** `wiphy_work_cancel(mld->wiphy, &mld->async_handlers_wk)`
  while `wiphy_lock` is still held, then unlock/free.
- Path: **error path** (fw load or NVM read failure during probe/op-mode
  start).

Hunk 2 (`iwl_op_mode_mld_stop`):
- **Before:** lock, `iwl_mld_low_latency_stop` /
  `iwl_mld_deinit_time_sync`, unlock, `ieee80211_unregister_hw` /
  `ieee80211_free_hw`.
- **After:** same, but cancel `async_handlers_wk` under the wiphy lock
  first.
- Path: **teardown** (module unload / transport op-mode leave).

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** memory safety (use-after-free of work item / wiphy) +
  leftover-work WARN
- **Mechanism:** `wiphy_work_queue()` during RX after ALIVE;
  `iwl_mld_stop_fw()` purges `async_handlers_list` but (after
  59a5876e474ac) no longer cancels the work. `ieee80211_free_hw()` →
  `wiphy_free()` → `cfg80211_dev_free()` WARNs if the list is non-empty.
  Worker `cfg80211_wiphy_work()` can also run
  `iwl_mld_async_handlers_wk()` after unlock and race teardown.
- **Fix:** `wiphy_work_cancel()` under the wiphy mutex (required by
  `lockdep_assert_held(&wiphy->mtx)` in `wiphy_work_cancel()`).

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: both sites already hold `wiphy_lock`; cancel of a
  not-queued work is a no-op (`list_empty` check in
  `wiphy_work_cancel()`).
- Minimal; no API/data-structure change.
- Regression risk: **very low**. Cancel vs flush is appropriate here (do
  not run handlers from a dead/going-away FW). Does not restore the lock
  requirement on `iwl_mld_cancel_async_notifications()`.
- Residual (pre-existing, not introduced here): NVM-fail path still does
  not call `iwl_mld_stop_fw()`; cancel avoids running those handlers
  during free. That is strictly safer than leaving work queued.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Surrounding start-fail/stop skeleton: `d1e879ec600f9` (“wifi: iwlwifi:
  add iwlmld sub-driver”, 2025-02/03) — first appeared in **v6.15**.
- The two new cancel lines: `c99bc4d4e0ba6` (this commit, 2026-07-14).
- Stop-path `wiphy_lock` wrapper: `83128399f3b492` (Benjamin Berg,
  2025-05).

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Historical chain (verified with `git show` /
`git log -S`):
1. `4f7a07791944e` (2025-04, Fixes: d1e879ec600f9) — cancel async notifs
   on start failure specifically because work can run after
   `ieee80211_free_hw` (**UAF**).
2. `833026098b2d9` — fold cancel+purge into
   `iwl_mld_cancel_async_notifications()`.
3. **`59a5876e474ac` (2026-05-26, in v7.2, not in v7.1)** — **removed**
   `wiphy_work_cancel()` from that helper so it can run without the
   wiphy lock. That **reopened** the free-without-cancel hole.
4. This commit puts cancel back on the two paths that actually free the
   wiphy.

`59a5876e474ac` **is** an ancestor of this tree (`git merge-base --is-
ancestor` → yes via v7.2).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Nearby: `a40ad60a47f7c` purge-on-NIC-error; `59a5876e474ac` remove
  cancel from helper.
- This is **not** patch-dependent on other hunks in the 15-patch
  iwlwifi-next dump; parent is unrelated `21b3263b90e80` (“mvm: validate
  monitor notif link_id”).
- Standalone: **yes**.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Miri Korenblit is a primary iwlwifi MLD author (driver
introduction and most async-handler work). Johannes Berg reviewed. High
confidence in the diagnosis.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record:
- Needs `wiphy_work_*` and `struct wiphy_work async_handlers_wk` —
  present since MLD intro in this tree.
- Needs the start-fail `if (ret)` / stop `wiphy_lock` shape — present.
- Needs `59a5876e474ac` as the regression that made cancel missing; that
  commit is in this tree.
- **Can apply standalone: yes** (already an ancestor of HEAD).

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c c99bc4d4e0ba6`: **[PATCH iwlwifi-next 08/15]**
  https://patch.msgid.link/20260714143119.07aa49f755a2.I734a27b1b0eeb5b0
  e821aee3318fee8dc0a6bc03@changeid
- `b4 dig -a`: v1 then **v2** “wifi: iwlwifi: updates - 07-14-2026”
  https://patch.msgid.link/20260714165826.07aa49f755a2.I734a27b1b0eeb5b0
  e821aee3318fee8dc0a6bc03@changeid
  Committed `Link:` is **v2** (latest).
- Lore WebFetch returned **403**; patchwork bot-blocked. Review body
  beyond tags is **UNVERIFIED**. No NAK found in b4 metadata.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): Miri Korenblit; Johannes Berg
(`johannes@sipsolutions.net` / intel.com); `linux-
wireless@vger.kernel.org`. Maintainer was To/Cc and `Reviewed-by`.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No `Reported-by` / bugzilla / syzbot. Author-found from code
(consistent with 4f7a077’s earlier UAF write-up). User count:
**UNVERIFIED**, but the start-fail path is firmware-load failure — a
real probe path.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: 08/15 of a mixed iwlwifi-next batch, not a dependent 1/N fix
series. Parent commit unrelated. No other series patch required for this
hunk.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: WebSearch of lore.kernel.org/stable for this subject did **not**
find a stable-specific thread. **UNVERIFIED** that anyone nominated or
rejected it on stable@ (absence of Cc:stable is expected).

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `iwl_op_mode_mld_start`, `iwl_op_mode_mld_stop`. Related
callees: `wiphy_work_cancel`, `iwl_mld_load_fw`, `iwl_mld_stop_fw`,
`ieee80211_free_hw`.

**Step 5.2: TRACE CALLERS**
Record:
- `iwl_mld_ops.start = iwl_op_mode_mld_start` — op-mode start from
  iwlwifi transport when `iwlmld` is selected
  (`iwl_opmode_register("iwlmld", ...)`).
- Stop is the matching `.stop` callback on unbind/unload.
- Context: process, probe/remove — not IRQ. Reachable whenever
  CONFIG_IWLMLD hardware probes or the module is removed.

**Step 5.3: TRACE CALLEES**
Record:
- Start-fail: `iwl_mld_load_fw()` on error after ALIVE calls
  `iwl_mld_stop_fw()` → purges list, does **not** cancel work.
- Then `ieee80211_free_hw()` → `wiphy_free()` → `put_device()` →
  `wiphy_dev_release()` → `cfg80211_dev_free()` which
  `WARN_ON(!list_empty(&rdev->wiphy_work_list))` then
  `cancel_work_sync(&rdev->wiphy_work)`.
- Worker: `cfg80211_wiphy_work()` → `wk->func` →
  `iwl_mld_async_handlers_wk()`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace/admin trigger: load iwlwifi on MLD firmware (Wi-Fi 7
Intel), failed firmware/NVM, or unload. Not a syscall exploit path;
**driver probe/remove**. Common enough for production laptops.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: MVM already cancels/flushes analog work in `iwl_mvm_mac_stop()`
(`wiphy_work_cancel` on `async_handlers_wiphy_wk`). MLD
`iwl_mld_mac80211_stop()` already cancels `add_txqs_wk` but **not**
`async_handlers_wk`. This commit aligns MLD teardown with that rule.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- Local tree: **v7.3-rc4** (`git describe HEAD` →
  `v7.3-rc4-27-gf0100363d8c37`; `VERSION=7 PATCHLEVEL=3 SUBLEVEL=0
  EXTRAVERSION=-rc4`).
- MLD driver **present**
  (`drivers/net/wireless/intel/iwlwifi/mld/mld.c`).
- Regression `59a5876e474ac` **is** in this history (v7.2+).
- Current file already contains both `wiphy_work_cancel` calls (this
  commit is ancestor of HEAD). Pre-fix parent of `c99bc4d4e0ba6` matches
  the supplied diff exactly.
- Bug was introduced **before** this 7.3 branch (in v7.2), not after.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply** on this tree (already applied). Surrounding
`iwl_op_mode_mld_start`/`stop` matches the patch. `wiphy_work_cancel`
exists in `net/wireless/core.c`.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: `4f7a07791944e` / `833026098b2d9` / `59a5876e474ac` are all
here. No alternate fix of this hole besides `c99bc4d4e0ba6`. `git log
--grep='cancel wiphy work'` only this commit.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `drivers/net/wireless/intel/iwlwifi/mld` — Intel Wi-Fi MLD
(CONFIG_IWLMLD). **IMPORTANT** (shipping Wi-Fi 7 NICs), not core mm/VFS,
not staging.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Very active (NAN, RSC, scan, firmware API churn in recent `git
log` on `mld.c`). Mature enough that this is a teardown correctness fix,
not new-feature scaffolding.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **driver-specific / config-specific** — CONFIG_IWLMLD users
(Intel MLD firmware devices). Not universal.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record:
- Start-fail: firmware load/init failure after ALIVE (missing/bad fw,
  PNVM/init timeout) — **realistic probe path**.
- Stop: op-mode teardown/unload.
- Timing: leftover `wiphy_work` after list purge.
- Unprivileged trigger: only if an unprivileged user can unload the
  driver or force fw failure — typically **admin/probe**. Not a syzbot-
  style syscall UAF, but probe-fail is still user-visible.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record:
- Confirmed: `WARN_ON` in `cfg80211_dev_free()` if work remains queued
  (taint; panic if `panic_on_warn`).
- Author/prior commit (`4f7a077`): work running after
  `ieee80211_free_hw` is **UAF**. cfg80211’s `cancel_work_sync` in
  `cfg80211_dev_free` reduces but does not make the WARN or the post-
  unlock race imaginary (`cfg80211_wiphy_work` can run after
  `wiphy_unlock` and before free).
- Severity: **HIGH** (WARN + realistic UAF race on probe fail / unload).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: **high** for IWLMLD users — stops WARN/UAF on fw init failure
  and stop.
- Risk: **very low** — 3 lines, existing API, lock already held.
- Ratio: strongly in favor of including the fix.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real teardown bug: pending `async_handlers_wk` after wiphy free
- Regression from `59a5876e474ac` (in this tree); restores cancel only
  where memory is freed
- Same UAF class as `4f7a07791944e` (explicit “access freed memory”)
- 3-line, obviously correct, maintainer Reviewed-by
- Applies to this tree’s MLD code; prerequisites present
- cfg80211 documents leftover work with WARN_ON

AGAINST:
- No Fixes:/Cc:stable/Reported-by (not a negative per pipeline rules)
- Error/teardown path, not hot datapath
- cfg80211 already `cancel_work_sync`s, so many hits are WARN rather
  than a guaranteed oops
- 08/15 series member (but standalone)

UNRESOLVED:
- Full lore review text (HTTP 403)
- Whether stable@ already discussed this subject
- How often start-fail hits with work still queued (depends on
  notifications after ALIVE)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — lock already held; Johannes
   reviewed; cancel is the documented API.
2. Fixes a real bug that affects users? **PASS** — leftover wiphy work
   on fw-start failure and op-mode stop.
3. Important issue? **PASS** — UAF risk + `WARN_ON` in cfg80211 (HIGH).
4. Small and contained? **PASS** — +3 lines, one file, two call sites.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — MLD + `wiphy_work_cancel` +
   matching functions exist (commit already in 7.3-rc4).

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary small
bugfix.

**Step 9.4: MAKE YOUR DECISION**

This tree is **7.3-rc4** and contains the iwlwifi MLD op-mode. The hole
is real here: after `59a5876e474ac`, start-fail and stop free the wiphy
without cancelling `async_handlers_wk`. That is a use-after-free/WARN
class bug on firmware load failure — a path users hit. The fix is three
lines, matches cfg80211’s contract, and does not need the rest of the
15-patch series.

---

### What the commit solves
On MLD op-mode start, firmware can ALIVE and queue `async_handlers_wk`.
Failure then purges the handler list in `iwl_mld_stop_fw()` but leaves
the wiphy work queued. `ieee80211_free_hw()` then frees that memory.
cfg80211 still `cancel_work_sync`s and **WARNs**; there is also a window
after `wiphy_unlock` where the worker can run. The same missing cancel
exists in `iwl_op_mode_mld_stop`. Cancelling under the wiphy lock closes
that.

### Stable rules
Meets all six criteria for **this** tree: small, correct, no new API,
real WARN/UAF, code present.

### Risk vs benefit
Benefit high for Intel MLD hardware; risk very low (idempotent cancel,
lock already held).

### Concerns
None that block inclusion. Not a dependent series member. NVM-fail still
does not `iwl_mld_stop_fw()` (pre-existing); this patch still improves
that path by not leaving work queued.

Verification:
- [Phase 1] Parsed subject/tags: Reviewed-by Johannes Berg; Link to v2
  msgid; no Fixes/Cc:stable/Reported-by
- [Phase 1] Body: purge-without-cancel on start-fail and stop; work vs
  freed wiphy; cfg80211 WARN
- [Phase 2] Diff: +3 lines in `mld.c`; `iwl_op_mode_mld_start` error
  path and `iwl_op_mode_mld_stop`; `wiphy_work_cancel`
- [Phase 2] `wiphy_work_cancel()` in `net/wireless/core.c` requires
  wiphy mutex; both sites already `wiphy_lock`
- [Phase 2] `cfg80211_dev_free()`:
  `WARN_ON(!list_empty(&rdev->wiphy_work_list))` then `cancel_work_sync`
- [Phase 3] `git describe HEAD`: v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` 7.3.0-rc4
- [Phase 3] `git merge-base --is-ancestor c99bc4d4e0ba6 HEAD` → yes
- [Phase 3] `git blame` start-fail/stop: skeleton `d1e879ec600f9` (MLD
  intro); cancel lines this commit
- [Phase 3] MLD first in v6.15 (`git merge-base --is-ancestor
  d1e879ec600f9 v6.15`); not in v6.14
- [Phase 3] `git show 59a5876e474ac`: removed `wiphy_work_cancel` from
  `iwl_mld_cancel_async_notifications`; in v7.2, not v7.1
- [Phase 3] `git show 4f7a07791944e`: original UAF fix on start-fail;
  Fixes: d1e879ec600f9
- [Phase 3] `git log -S wiphy_work_cancel -- mld/`: d1e879ec, 4f7a077,
  833026, 59a5876, c99bc4d4
- [Phase 3] Parent of candidate is unrelated mvm change; series 08/15 is
  a mixed iwlwifi-next batch
- [Phase 4] `b4 dig -c`: lore/patchwork msgid for 08/15; `-a`: v1 then
  v2 (applied); `-w`: Johannes + linux-wireless
- [Phase 4] WebFetch lore 403; patchwork bot wall; spinics 500 — review
  comments UNVERIFIED
- [Phase 4] No stable@ hit for this subject (search not useful)
- [Phase 5] `iwl_mld_ops.start` = `iwl_op_mode_mld_start`; RX path
  `wiphy_work_queue(&mld->async_handlers_wk)` in `notif.c`
- [Phase 5] `iwl_mld_load_fw` error after init sequence calls
  `iwl_mld_stop_fw` (purge, no cancel)
- [Phase 5] MVM `iwl_mvm_mac_stop` already cancels analogous wiphy work
- [Phase 6] Local `mld.c` already has both cancel sites; pre-image of
  parent matches the candidate diff
- [Phase 7] CONFIG_IWLMLD in
  `drivers/net/wireless/intel/iwlwifi/Kconfig`
- [Phase 8] Trigger: fw load fail after ALIVE / op-mode stop; severity
  HIGH (WARN + UAF race)
- UNVERIFIED: exact lore review discussion text; field frequency of this
  WARN

**YES**

 drivers/net/wireless/intel/iwlwifi/mld/mld.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mld.c b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
index cf003a4a37408..49fcbe6814677 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mld.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
@@ -440,6 +440,8 @@ iwl_op_mode_mld_start(struct iwl_trans *trans, const struct iwl_rf_cfg *cfg,
 	}
 
 	if (ret) {
+		/* wiphy memory is about to be freed, we should cancel any pending work */
+		wiphy_work_cancel(mld->wiphy, &mld->async_handlers_wk);
 		wiphy_unlock(mld->wiphy);
 		rtnl_unlock();
 		goto err;
@@ -505,6 +507,7 @@ iwl_op_mode_mld_stop(struct iwl_op_mode *op_mode)
 	iwl_mld_thermal_exit(mld);
 
 	wiphy_lock(mld->wiphy);
+	wiphy_work_cancel(mld->wiphy, &mld->async_handlers_wk);
 	iwl_mld_low_latency_stop(mld);
 	iwl_mld_deinit_time_sync(mld);
 	wiphy_unlock(mld->wiphy);
-- 
2.53.0

