Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9A244A400;
	Mon, 31 Aug 2026 13:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183254; cv=none; b=Tc9RKJrmnnk3TML41IT4ahxbzVi8iWXnLbIvlRpRgdFAIQdJJu/gEf4PPUHdyfQp0aLR6gXecaqClRoL3eaTzzjcxlBdrBBH7SQDnvKjliXsVdYmMySWzyt7PFcTYAuTcChcA9azsuVZWMCtfVaCdRUGrtqUeBeYAJOxXDAwCuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183254; c=relaxed/simple;
	bh=XDxuBPFmz957YXRDN3G+Fvtv4sTdp217PAFXDircdks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cY800IA3x22kAHBvvi1hnnw1P6/fUEwe7KlqvObBH4EJvrwwpGCIXlusI8XITPzCJNJIpXxJnEYpFrh85WL0jSdvhIvIE6UCb2VmmnAmjLrcIG2WNcKcOKreSZFXLrC3b9um9kazSUyMerwc0TE6ssf6E/Y95Q7+h1de9cnIMUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hyRd9uvt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hyRd9uvt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495781F000E9;
	Mon, 31 Aug 2026 13:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183252;
	bh=qKKiT9zSevn4nBBGZoSgxkneBjYrg3Mq8hCg18KSQWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hyRd9uvtZDVu4sY7uyLqsl3gYcMxW2rvxuIuLNvMq495gkY8YKrcz4s5Nc8koL5AO
	 G2hiudllKORsEhAVgjLQiZ+CBrrY/KVMy9Lz0piPJGImNzYSaSOlS7sy1RHWZJzhC9
	 yMVxbIyfHGPwKCWVTHxzuOlGikKe5FC5qw7rcmYr06ectQA16JJmGU7BWW6NHfixrW
	 wLlaZxjFTxsdnvmqe7CCx0iJbmQxlVVpJeFfuPiGbhkJJAeCL5FXlXm43lK8W/ZUVg
	 I9d3+On3aWAphuFEEMdHVhRNZ9byR2NNyvz3S14oQbbZVLcJMgGtKlvyLx//7ArzIa
	 3rwCIeIfDDQNQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: mvm: fix P2P-Device binding handling
Date: Mon, 31 Aug 2026 09:21:05 -0400
Message-ID: <20260831133314.4125787-37-sashal@kernel.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit b74e377cad9271950c57472867c469e4b5b2ff0c ]

Our binding handling for P2P-Device can run into the following
scenario, as observed by our testing:

 - a station interface is connected on some channel
 - the P2P-Device does a remain-on-channel (ROC) on that channel
 - the ROC ends, and the P2P-Device is removed from the binding,
   but the phy_ctxt pointer is left around as a PHY cache so we
   don't need to recalibrate to the channel again and again in
   case it's not shared
 - a binding update by the station interface, even a removal,
   will re-add the P2P-Device to the binding
 - the P2P-Device is removed, which removes the PHY context, but
   it's still in the binding so the firmware crashes

Since the P2P device is removed from the binding and only re-
added by unrelated code, but we want to keep the phy_ctxt around
as a cache for future ROC usage, fix it by adding a boolean that
indicates whether or not the P2P-Device should be added to the
binding, and handle that in the binding iterator. That way, the
station interface cannot re-add the P2P-Device to the binding
when that isn't active.

Assisted-by: Github Copilot:claude-opus-4-6
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20260527230313.07f94335ae06.I384238b0859343c4a9a9dda20682be1aad89cc9d@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: iwlwifi: mvm: fix P2P-Device binding
handling`

**Local tree:** Linux **6.18.44** (`git describe HEAD` → `v6.18.44`,
Makefile `VERSION=6 PATCHLEVEL=18 SUBLEVEL=44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse Subject Line
**Record:** `[wifi: iwlwifi: mvm]` `[fix]` — Correct P2P-Device binding
handling so a cached PHY context does not cause stale re-inclusion in
firmware bindings.

### Step 1.2: Parse All Commit Message Tags
**Record:**
| Tag | Value |
|-----|-------|
| Assisted-by | Github Copilot:claude-opus-4-6 |
| Signed-off-by | Johannes Berg \<johannes.berg@intel.com\> |
| Link | https://patch.msgid.link/20260527230313.07f94335ae06.I384238b08
59343c4a9a9dda20682be1aad89cc9d@changeid |
| Signed-off-by | Miri Korenblit \<miriam.rachel.korenblit@intel.com\> |

**Notable patterns:** No `Fixes:`, `Reported-by:`, `Cc: stable`, or
syzbot tags. Author is iwlwifi subsystem maintainer (Johannes Berg).
Link points to patch submission (May 2026 message ID).

### Step 1.3: Analyze Commit Body
**Record:**
- **Bug:** After P2P-Device ROC ends, driver removes P2P from binding
  but keeps `phy_ctxt` as a channel cache. A later station-interface
  binding update re-adds the inactive P2P-Device to the binding via the
  binding iterator (matching `phy_ctxt`). When the P2P-Device is later
  removed, PHY context is torn down while P2P remains in the firmware
  binding → **firmware crash**.
- **Symptom:** Firmware crash on a specific P2P + station coexistence
  sequence.
- **Root cause:** Binding iterator cannot distinguish “has cached
  phy_ctxt” from “should be in binding”.
- **Fix approach:** Add `p2p_in_binding` boolean; only include
  P2P-Device in binding when actively in ROC.

### Step 1.4: Detect Hidden Bug Fixes
**Record:** Not disguised — explicitly a bug fix. The error-path
rollback in `iwl_mvm_roc_link()` (clear flag + `binding_remove_vif` on
`add_p2p_bcast_sta` failure) is a secondary correctness fix preventing a
leaked binding state.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory Changes
**Record:**
| File | Change |
|------|--------|
| `binding.c` | +3 lines in iterator |
| `mac80211.c` | +10 lines (cleanup, roc_link, error path) |
| `mvm.h` | +1 bool field + doc comment |
| `time-event.c` | +1 line (clear flag on ROC cleanup) |

**Functions modified:** `iwl_mvm_iface_iterator`,
`iwl_mvm_cleanup_iterator`, `iwl_mvm_roc_link`, `iwl_mvm_cleanup_roc`.
**Scope:** Single-subsystem, surgical (≈15 functional lines).

### Step 2.2: Code Flow Change (per hunk)

**Hunk 1 — `iwl_mvm_iface_iterator` (binding.c):**
- **Before:** Any vif sharing `phy_ctxt` is included in binding updates.
- **After:** P2P-Device vifs with `!p2p_in_binding` are skipped even if
  `phy_ctxt` matches.
- **Path:** All binding add/remove/update operations via
  `iwl_mvm_binding_update()`.

**Hunk 2 — `iwl_mvm_cleanup_iterator` (mac80211.c):**
- **Before:** No `p2p_in_binding` reset on interface cleanup.
- **After:** `p2p_in_binding = false` on cleanup.
- **Path:** HW restart / interface teardown cleanup.

**Hunk 3 — `iwl_mvm_roc_link` (mac80211.c):**
- **Before:** Add binding, add bcast sta; no flag tracking.
- **After:** Set `p2p_in_binding = true` after binding add; on bcast-sta
  failure, remove binding and clear flag.
- **Path:** P2P ROC start (non-MLD binding path).

**Hunk 4 — `iwl_mvm_cleanup_roc` (time-event.c):**
- **Before:** Remove binding on ROC end (non-MLD path) but leave
  `phy_ctxt` cached.
- **After:** Also clear `p2p_in_binding = false`.
- **Path:** P2P ROC completion/cancellation.

**Hunk 5 — `mvm.h`:**
- Add `bool p2p_in_binding` to `struct iwl_mvm_vif`.

### Step 2.3: Bug Mechanism
**Record:** **Category:** Logic/correctness bug in driver–firmware state
synchronization. **Mechanism:** Commit `84ef7cbe90e9e` (“Don't always
bind/link the P2P Device interface”) decoupled binding lifetime from
`phy_ctxt` lifetime for performance (PHY cache reuse after ROC). The
binding iterator still keyed only on `phy_ctxt` equality, so inactive
P2P-Device could be silently re-bound during unrelated station binding
updates, leaving firmware with a binding entry pointing at removed PHY
state.

### Step 2.4: Fix Quality
**Record:** Fix is minimal and clearly correct — tracks binding intent
separately from PHY cache. Low regression risk: flag defaults to `false`
(safe); only set `true` during active ROC binding. MLD firmware path
uses `link_changed` instead of bindings for P2P ROC, so unaffected; the
iterator guard is harmless for MLD.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame Changed Lines
**Record:**
- `binding.c` iterator logic: original binding code from 2013
  (`8ca151b568b67a`, Johannes Berg); `phy_ctxt` check from 2023
  (`650cadb730105f`).
- `time-event.c` “keep PHY context” comment and `binding_remove_vif` on
  ROC end: **`84ef7cbe90e9e`** (Ilan Peer, 2023-10-23) — this commit
  introduced the bug scenario.
- Bug present since **v6.7** (`git describe --contains 84ef7cbe90e9e5` →
  `v6.7_rc2~...`).

### Step 3.2: Follow Fixes Tag
**Record:** No `Fixes:` tag present. N/A.

### Step 3.3: Related File History
**Record:** Recent related commits in affected files include
`f9751163bffd3` (“clean up ROC on failure”) and `84ef7cbe90e9e`
(introduced the PHY-cache-without-binding design). No other fix for this
specific binding/PHY desync found in tree. **Standalone patch** — not
part of a multi-patch series in the commit message.

### Step 3.4: Author Context
**Record:** Johannes Berg is iwlwifi/mac80211 maintainer. Miri Korenblit
is active Intel iwlwifi contributor. High subsystem credibility.

### Step 3.5: Dependencies
**Record:** No prerequisite commits referenced. All modified symbols
(`iwl_mvm_binding_*`, `iwl_mvm_roc_link`, `iwl_mvm_cleanup_roc`, `struct
iwl_mvm_vif`) exist in 6.18.44. **Can apply standalone.**

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Patch Discussion
**Record:** `b4 dig -c <commit>` could not be run — commit is not in
this checkout (no matching `git log --grep`). `Link:` URL and
lore.kernel.org search blocked by Anubis bot protection. **UNVERIFIED:**
Full mailing-list review thread and any explicit stable nominations.

### Step 4.2: Reviewers
**Record:** UNVERIFIED — `b4 dig -w` requires commit hash not available
locally.

### Step 4.3: Bug Report
**Record:** Bug found by Intel internal testing per commit message (“as
observed by our testing”). No syzbot, bugzilla, or user `Reported-by:`
tags. Severity claimed: **firmware crash**.

### Step 4.4: Related Patches/Series
**Record:** UNVERIFIED from lore. Commit appears standalone from diff
scope.

### Step 4.5: Stable Mailing List
**Record:** UNVERIFIED — lore blocked.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `iwl_mvm_iface_iterator`, `iwl_mvm_binding_update`,
`iwl_mvm_binding_add_vif`, `iwl_mvm_binding_remove_vif`,
`iwl_mvm_roc_link`, `iwl_mvm_cleanup_roc`,
`__iwl_mvm_assign_vif_chanctx`, `__iwl_mvm_unassign_vif_chanctx`.

### Step 5.2: Callers (impact surface)
**Record:**
- `iwl_mvm_binding_add_vif` / `remove_vif` called from:
  - Station/AP chanctx assign/unassign (`mac80211.c` ~2991, ~3057,
    ~3144, ~5081, ~5143, ~5230)
  - P2P ROC link (`mac80211.c` ~4688)
  - ROC cleanup (`time-event.c` ~91)
- Binding iterator runs on **every** binding update for any interface
  sharing a PHY context.

### Step 5.3: Callees
**Record:** `ieee80211_iterate_active_interfaces_atomic`,
`iwl_mvm_binding_cmd` (firmware command), `iwl_mvm_phy_ctxt_unref` (on
P2P removal, `mac80211.c` ~1917).

### Step 5.4: Call Chain / Reachability
**Record:** Triggerable by normal userspace WiFi operations:
1. Station connected (`NL80211_IFTYPE_STATION`)
2. P2P-Device ROC (WiFi Direct discovery/off-channel operations)
3. ROC ends → station binding update (channel change, disconnect,
   interface removal)

Reachable from mac80211/nl80211 without root-only ioctl tricks.
**Userspace-reachable via standard WiFi stack.**

### Step 5.5: Similar Patterns
**Record:** The Oct 2023 commit `84ef7cbe90e9e` intentionally split
binding from PHY caching; this fix completes that design by tracking
binding membership explicitly. No other instances of this pattern found
in binding code.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Does Buggy Code Exist?
**Record:** **YES.** Verified:
- `p2p_in_binding` does **not** exist (`grep` → no matches).
- `binding.c` iterator has no P2P guard (lines 76–87).
- `time-event.c` removes binding on ROC end but keeps PHY (lines 89–98).
- `mac80211.c` `iwl_mvm_roc_link` adds binding without flag (lines
  4682–4695).
- Bug-introducing commit `84ef7cbe90e9e` is ancestor of HEAD.

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** All four files and target
locations match the patch context. Local `mvm.h` has additional fields
(`esr_active`, `link_selection_*`) but `roc_activity` placement is
identical; `bool p2p_in_binding` fits naturally after `roc_activity` at
line 502.

### Step 6.3: Related Fixes Already Present?
**Record:** No — `grep p2p_in_binding` and `grep 'P2P-Device binding'`
found nothing in tree or local mbx files.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** `drivers/net/wireless/intel/iwlwifi/mvm` — **IMPORTANT**
(Intel WiFi, widely deployed; not core kernel but affects many
laptop/desktop users with `CONFIG_IWLWIFI`).

### Step 7.2: Subsystem Activity
**Record:** Active development — recent ROC/binding changes
(`f4c737d44969c`, `792eb35718367`, `f9751163bffd3`). The underlying bug
has existed since the Oct 2023 P2P binding refactor.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users of Intel iwlwifi (`CONFIG_IWLWIFI`) with
**P2P-Device** (WiFi Direct) on **non-MLD firmware API** (binding-based
ROC path, not `mld_api_is_used`). Station + P2P coexistence is common on
laptops.

### Step 8.2: Trigger Conditions
**Record:**
1. Station interface connected on a channel
2. P2P-Device ROC on same channel
3. ROC ends (PHY cached, binding removed)
4. Station binding update (even removal)
5. P2P-Device interface removed

**Likelihood:** Moderate for P2P users — requires specific sequencing
but each step is normal WiFi operation. Unprivileged users can trigger
via standard nl80211/mac80211.

### Step 8.3: Failure Mode Severity
**Record:** **Firmware crash** when P2P-Device removed with stale
binding entry. **Severity: CRITICAL** — device becomes non-functional
until reset/reload; potential for broader system instability depending
on firmware recovery.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH — prevents firmware crash on realistic P2P + station
  workflow.
- **Risk:** LOW — ~15 lines, single bool, no API changes, default-false
  is safe.
- **Ratio:** Strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Fixes real, reproducible (per Intel testing) firmware crash
- Bug exists in 6.18.44 (introduced 2023, never fixed here)
- Small, surgical, maintainer-authored fix
- No new features or APIs
- Affects common WiFi P2P + station scenario
- Error-path improvement in `iwl_mvm_roc_link` prevents secondary
  binding leak

**AGAINST backport:**
- Only affects non-MLD binding path (newer MLD firmware uses links, not
  bindings, for P2P ROC)
- No external user reports or syzbot — internal testing only
- Lore review unverified

**Unresolved:** Full mailing-list review thread; whether reviewers
nominated for stable.

### Step 9.2: Stable Rules Checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — logic is clear; Intel
internal testing cited |
| 2. Fixes real bug affecting users? | **PASS** — firmware crash on P2P
+ station sequence |
| 3. Important issue? | **PASS** — CRITICAL (firmware crash) |
| 4. Small and contained? | **PASS** — ~15 functional lines, 4 files |
| 5. No new features/APIs? | **PASS** — internal driver state flag only
|
| 6. Can apply to local tree? | **PASS** — all code present, clean apply
expected |

### Step 9.3: Exception Categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
bug fix.

### Step 9.4: Decision Rationale
For Linux **6.18.44**, the buggy code path is present and unfixed. The
commit addresses a firmware crash in a realistic P2P + station workflow
with a minimal, obviously correct state-tracking fix. Risk is low;
impact for affected iwlwifi P2P users is high. This meets all stable
kernel criteria.

---

## Verification

- [Phase 1] Parsed subject, tags, body; no Fixes/Reported-by/Cc:stable;
  maintainer authorship confirmed
- [Phase 2] Diff analysis: 4 files, binding iterator guard + flag
  lifecycle + error rollback
- [Phase 3] `git blame binding.c:79-87` → 2013 iterator, 2023 phy_ctxt
  check
- [Phase 3] `git blame time-event.c:89-98` → `84ef7cbe90e9e` introduced
  PHY-cache-without-binding
- [Phase 3] `git merge-base --is-ancestor 84ef7cbe90e9e HEAD` → bug
  commit in tree
- [Phase 3] `git describe --contains 84ef7cbe90e9e5` → first in v6.7
- [Phase 3] No Fixes: tag to follow
- [Phase 3] `git log --oneline -20` on affected files — no duplicate fix
  found
- [Phase 4] `b4 dig -c` — FAILED (commit not in checkout)
- [Phase 4] WebFetch lore/patch.msgid.link — BLOCKED by Anubis
- [Phase 4] Grep local mbx files for patch — not found
- [Phase 5] `grep binding_add_vif/binding_remove_vif` — traced all call
  sites
- [Phase 5] Read `iwl_mvm_roc_common`, `iwl_mvm_mld_roc_link` — MLD uses
  links not bindings for P2P ROC
- [Phase 5] Read `mac80211.c:1915-1920` — P2P removal calls
  `phy_ctxt_unref` (crash trigger)
- [Phase 6] `git describe HEAD` → v6.18.44
- [Phase 6] `grep p2p_in_binding` → not present (fix not applied)
- [Phase 6] Read current `binding.c:70-88`, `time-event.c:65-99`,
  `mac80211.c:4682-4695` — buggy code confirmed
- [Phase 8] Failure mode: firmware crash, severity CRITICAL
- **UNVERIFIED:** Mailing-list review feedback and stable nominations
- **UNVERIFIED:** Exact mainline commit SHA (not in this tree)

**YES**

 drivers/net/wireless/intel/iwlwifi/mvm/binding.c    |  5 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c   | 12 +++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h        |  3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c |  3 ++-
 4 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/binding.c b/drivers/net/wireless/intel/iwlwifi/mvm/binding.c
index 58e9a940024db..0812522edea0d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/binding.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/binding.c
@@ -2,7 +2,7 @@
 /*
  * Copyright (C) 2012-2014, 2020 Intel Corporation
  * Copyright (C) 2016 Intel Deutschland GmbH
- * Copyright (C) 2022, 2024 Intel Corporation
+ * Copyright (C) 2022, 2024, 2026 Intel Corporation
  */
 #include <net/mac80211.h>
 #include "fw-api.h"
@@ -76,6 +76,9 @@ static void iwl_mvm_iface_iterator(void *_data, u8 *mac,
 	if (vif == data->ignore_vif)
 		return;
 
+	if (vif->type == NL80211_IFTYPE_P2P_DEVICE && !mvmvif->p2p_in_binding)
+		return;
+
 	if (mvmvif->deflink.phy_ctxt != data->phyctxt)
 		return;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 44029ceb8f779..2d2587c6e9757 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1104,6 +1104,7 @@ static void iwl_mvm_cleanup_iterator(void *data, u8 *mac,
 	spin_unlock_bh(&mvm->time_event_lock);
 
 	mvmvif->roc_activity = ROC_NUM_ACTIVITIES;
+	mvmvif->p2p_in_binding = false;
 
 	mvmvif->bf_enabled = false;
 	mvmvif->ba_enabled = false;
@@ -4681,6 +4682,7 @@ static int iwl_mvm_add_aux_sta_for_hs20(struct iwl_mvm *mvm, u32 lmac_id)
 
 static int iwl_mvm_roc_link(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -4689,10 +4691,18 @@ static int iwl_mvm_roc_link(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	if (WARN(ret, "Failed binding P2P_DEVICE\n"))
 		return ret;
 
+	mvmvif->p2p_in_binding = true;
+
 	/* The station and queue allocation must be done only after the binding
 	 * is done, as otherwise the FW might incorrectly configure its state.
 	 */
-	return iwl_mvm_add_p2p_bcast_sta(mvm, vif);
+	ret = iwl_mvm_add_p2p_bcast_sta(mvm, vif);
+	if (ret) {
+		iwl_mvm_binding_remove_vif(mvm, vif);
+		mvmvif->p2p_in_binding = false;
+	}
+
+	return ret;
 }
 
 static int iwl_mvm_roc(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index e05efcecaaf3f..2628361332895 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -390,6 +390,8 @@ struct iwl_mvm_vif_link_info {
  *	and in eSR mode. Valid only for a STA.
  * @roc_activity: currently running ROC activity for this vif (or
  *	ROC_NUM_ACTIVITIES if no activity is running).
+ * @p2p_in_binding: indicates that this P2P-Device interface should be
+ *	added to the binding, i.e. is running ROC right now
  * @session_prot_connection_loss: the connection was lost due to session
  *	protection ending without receiving a beacon, so we need to now
  *	protect the deauth separately
@@ -500,6 +502,7 @@ struct iwl_mvm_vif {
 	struct iwl_mvm_time_event_data time_event_data;
 	struct iwl_mvm_time_event_data hs_time_event_data;
 	enum iwl_roc_activity roc_activity;
+	bool p2p_in_binding;
 
 	/* TCP Checksum Offload */
 	netdev_features_t features;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index 0b12ee8ad6180..1a3a8a3f0fb49 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2012-2014, 2018-2025 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2026 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2017 Intel Deutschland GmbH
  */
@@ -89,6 +89,7 @@ static void iwl_mvm_cleanup_roc(struct iwl_mvm *mvm)
 			} else {
 				iwl_mvm_rm_p2p_bcast_sta(mvm, vif);
 				iwl_mvm_binding_remove_vif(mvm, vif);
+				mvmvif->p2p_in_binding = false;
 			}
 
 			/* Do not remove the PHY context as removing and adding
-- 
2.53.0

