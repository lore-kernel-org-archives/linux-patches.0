Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543194570EC;
	Mon, 31 Aug 2026 13:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183283; cv=none; b=QBo4yy638b/gWhd4PP/FSTxpSNtnR2iaT/vjcjLK2/XIP6I2AOsYYO+u83WtBnWQcXJKRVVUlLn/Vk0QswHQdtsvrqQeoryGejVSDYH2cJZAYYAb1tLAhWTEdzAnDacqGakwxw7vpBAefua8Sz72XSGAI8nLdr5R2EGBaNb46DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183283; c=relaxed/simple;
	bh=nc905L7O2isCtGXYoIvxxMHbhZ8IjiW+2nWM37+TWEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jHaZMwKx6ShbWkPy5KZPFwmWo7gXoSKbEu/SQ2TzOJ3s1jlT5/vKa04casglfiTXNSdEf0rEZVygdNs73DxNAjXJj06MhqNW3YcrI3Sq9qzGQQAA3W+qt10Qvc0L+dfLsM1tUvWAaxV9EarrAGtWW/6ZfHan4rIkg7zadp8Mgc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LkX6jknh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LkX6jknh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477771F00ADF;
	Mon, 31 Aug 2026 13:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183280;
	bh=suBB6sMnaRiFD/+vEeFBmjXPBsbA6V2QiMRWp064h8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LkX6jknhSgKIfTdQ1vm9tpy+L9A+0qjlmV+Z8AanhpK55nFFvQQxyP45Al6LMAQR3
	 cuBuDK3kC3LtjhX0wFk9fEV8kRrkWohELRnTfhPrMoq7o0wlhNAP+iarmUeXyNqm1T
	 GF2JM4A32W/5+hQ3VoVHMyhU2xT6VcdDVy6RqCjTCCh0DsQyYJ50dcYNhOvHfXhf0U
	 w6puUhkmxBJLneahWJdAMPXjVoF6d62xDk88hiQ+anW+K/aYYcdnidUnGy8Bq6kKlN
	 XAgE4kpCKzVSo9CY+tDYpeQBoR+JPLjckNeKFh+KI3IPHCj/P5WifFelru04GrzLKV
	 SZBccebv5s9Rw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>,
	Maharaja Kennadyrajan <maharaja.kennadyrajan@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	jjohnson@kernel.org,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: ath12k: Prevent incorrect vif chanctx switch when handling multi-radio contexts
Date: Mon, 31 Aug 2026 09:21:21 -0400
Message-ID: <20260831133314.4125787-53-sashal@kernel.org>
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

From: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>

[ Upstream commit 675aa75bfc29fb18c6e4d58904a91c1d37228217 ]

When multiple links switch channel contexts around the same time, mac80211
may complete CSA for several links together and invoke
ath12k_mac_op_switch_vif_chanctx() with an array of vifs spanning more than
one underlying radio in a single-wiphy configuration.

The driver currently assumes that all entries in the vifs array belong to the
same radio and derives the radio context from the first element. On multi-radio
hardware, this can lead to incorrect vdev selection/updates and may corrupt
driver state when the number of vifs exceeds what a single radio supports.

Fix this by validating each vif's switch request and then processing vifs
grouped by their associated radio. For each vif, ensure the band does not
change across the switch and that both old/new channel contexts resolve to a
valid ath12k device. Reject attempts to move a vif between radios (not
supported for now) and return -EOPNOTSUPP to upper layers.

Then, iterate through the input vifs, collect all unprocessed entries that map
to the same radio, and invoke ath12k_mac_update_vif_chan() separately for each
radio group. This removes any reliance on mac80211 providing the array grouped
by radio or sharing old_ctx pointers across vifs.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.5-01651-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>
Co-developed-by: Maharaja Kennadyrajan <maharaja.kennadyrajan@oss.qualcomm.com>
Signed-off-by: Maharaja Kennadyrajan <maharaja.kennadyrajan@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260522091828.3199584-1-maharaja.kennadyrajan@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[wifi: ath12k]` `[Prevent]` — Prevent incorrect vif chanctx
switch when handling multi-radio contexts.

### Step 1.2: Tags
**Record:**
- **Tested-on:** QCN9274 hw2.0 PCI
  WLAN.WBE.1.5-01651-QCAHKSWPL_SILICONZ-1
- **Signed-off-by:** Aditya Kumar Singh, Maharaja Kennadyrajan, Jeff
  Johnson
- **Co-developed-by:** Maharaja Kennadyrajan
- **Reviewed-by:** Baochen Qiang, Rameshkumar Sundaram (Qualcomm ath12k
  developers)
- **Link:** https://patch.msgid.link/20260522091828.3199584-1-
  maharaja.kennadyrajan@oss.qualcomm.com
- No Fixes:, Reported-by:, Cc: stable, or syzbot tags
- Notable: Hardware-tested on real QCN9274; dual Reviewed-by from
  subsystem developers

### Step 1.3: Body Analysis
**Record:**
- **Bug:** `ath12k_mac_op_switch_vif_chanctx()` assumes all entries in
  the `vifs` array belong to the same radio, deriving the radio (`ar`)
  from `vifs[0]` only. When mac80211 completes CSA for multiple links
  simultaneously across radios in a single-wiphy multi-radio
  configuration, vifs from different radios are passed in one array.
- **Symptom:** Incorrect vdev selection/updates; driver state corruption
  when vif count exceeds single-radio capacity.
- **Root cause:** Reliance on mac80211 grouping vifs by radio or sharing
  old_ctx pointers across vifs — neither is guaranteed.
- **Fix approach:** Validate each vif individually, group by radio,
  process each group with the correct `ar`. Reject unsupported band
  changes and cross-radio moves with `-EOPNOTSUPP`.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Yes — explicitly a bug fix despite "Prevent" wording. Also
adds `WARN_ON(!arvif)` in `ath12k_mac_update_vif_chan()` which prevents
a NULL dereference before `arvif->vdev_id` is accessed (current code
dereferences `arvif` at line 10893 before the `is_started` check at
10899, with no NULL guard).

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/net/wireless/ath/ath12k/mac.c` only
- **Scope:** ~3 lines added in `ath12k_mac_update_vif_chan()`, ~70 lines
  changed in `ath12k_mac_op_switch_vif_chanctx()`
- **Functions modified:** `ath12k_mac_update_vif_chan()`,
  `ath12k_mac_op_switch_vif_chanctx()`
- **Classification:** Single-file, focused driver fix

### Step 2.2: Code Flow Changes
**Record:**
- **Hunk 1 (`ath12k_mac_update_vif_chan`):** Before → dereferences
  `arvif->vdev_id` in debug print without NULL check. After →
  `WARN_ON(!arvif); continue;` added before dereference.
- **Hunk 2 (`ath12k_mac_op_switch_vif_chanctx`):** Before → gets `ar`
  from `vifs[0].old_ctx`, validates only first vif's old/new ctx match
  same radio, calls `ath12k_mac_update_vif_chan(ar, vifs, n_vifs)` for
  entire array. After → validates each vif's band/old/new ctx/radio,
  builds `ar_map[]`, groups vifs by radio, calls
  `ath12k_mac_update_vif_chan(group_ar, group_vifs, count)` per radio
  group.

### Step 2.3: Bug Mechanism
**Record:** **Category:** Logic/correctness bug + potential NULL pointer
dereference. **Mechanism:** WMI vdev restart/stop/start commands are
sent via the `ar` (radio) context. Using radio A's `ar` to process vifs
belonging to radio B sends vdev operations to the wrong pdev/firmware,
corrupting driver state. The `WARN_ON(!arvif)` addition fixes a
secondary NULL deref when `arvif` lookup fails for a vif on the wrong
radio.

### Step 2.4: Fix Quality
**Record:** Fix is obviously correct — mirrors the per-vif iteration
pattern used by rtw89's `rtw89_ops_switch_vif_chanctx()`. Minimal
regression risk: only affects the multi-vif chanctx switch path, adds
proper validation, uses existing allocation patterns (`kzalloc_objs`,
`__free(kfree)`) already present in ath12k. Early returns on error
prevent partial corruption.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** `ath12k_mac_op_switch_vif_chanctx()` introduced in
`d889913205cf7` (Kalle Valo, 2022-11-28, "wifi: ath12k: driver for
Qualcomm Wi-Fi 7 devices"). Radio lookup from `vifs->old_ctx` added in
`314876885bdcc3` (Sriram R, 2024-04-09, "wifi: ath12k: vdev statemachine
changes for single wiphy") — this is when the bug was introduced. Both
commits are ancestors of HEAD.

### Step 3.2: Fixes Tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related File History
**Record:** Recent ath12k/mac.c commits include other stable-worthy
fixes (NULL deref, deadlock, scan state). No related chanctx fix already
present. `git log -S "ar_map"` returns empty — fix not yet applied to
this tree.

### Step 3.4: Author Context
**Record:** Authors are active Qualcomm ath12k contributors (Aditya
Kumar Singh, Maharaja Kennadyrajan). Multiple prior ath12k fixes in tree
from same team. Reviewed by Baochen Qiang and Rameshkumar Sundaram.

### Step 3.5: Dependencies
**Record:** Uses `kzalloc_objs()` and `__free(kfree)` — both present in
this tree (`3bf5e19c804d0` for kzalloc_objs; `__free(kfree)` already
used extensively in ath12k/mac.c). Uses `ath12k_generic_dbg()` — present
in debug.h. No series dependencies; standalone fix. Can apply
standalone.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:** `b4 dig -c <hash>` not possible — commit not merged into
this tree. `b4 dig` with message-id failed (wrong invocation).
lore.kernel.org and patch.msgid.link blocked by Anubis bot protection
(curl and WebFetch both returned challenge page). **UNVERIFIED:** Full
mailing list review thread content.

### Step 4.2: Reviewers
**Record:** **UNVERIFIED** via b4 dig -w. Commit message shows Reviewed-
by from two Qualcomm ath12k developers and Signed-off-by from Jeff
Johnson (ath maintainer).

### Step 4.3: Bug Report
**Record:** No external bug report or syzbot link. Bug identified
through code analysis and hardware testing (Tested-on: QCN9274).

### Step 4.4: Related Patches
**Record:** Standalone patch, not part of a series (no "patch X/Y" in
subject). No dependencies on other patches.

### Step 4.5: Stable List History
**Record:** **UNVERIFIED** — could not access lore.kernel.org/stable due
to bot protection.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `ath12k_mac_op_switch_vif_chanctx()` (mac80211 driver op),
`ath12k_mac_update_vif_chan()` (internal helper),
`ath12k_get_ar_by_ctx()` (radio lookup by channel context).

### Step 5.2: Callers
**Record:** `ath12k_mac_op_switch_vif_chanctx` registered at mac.c:13056
as `.switch_vif_chanctx` in `ieee80211_ops`. Called from mac80211 via
`drv_switch_vif_chanctx()` in `net/mac80211/driver-ops.c:414`. mac80211
invokes this during channel context switches in `net/mac80211/chan.c` —
both single-vif (`ieee80211_chsw_switch_vif`, line 1389) and multi-vif
(`ieee80211_chsw_switch_vifs`, line 1537) paths. Multi-vif path collects
ALL links with in-place reservations across all replacing chanctxs.

### Step 5.3: Callees
**Record:** `ath12k_get_ar_by_ctx()` → `ath12k_mac_get_ar_by_chan()`
(maps channel frequency to radio in multi-radio mode).
`ath12k_mac_update_vif_chan()` → `ath12k_mac_vdev_restart()`,
`ath12k_mac_vdev_stop()`, `ath12k_mac_vdev_start()` — all send WMI
commands to firmware via the `ar` pdev.

### Step 5.4: Reachability
**Record:** Triggered during CSA (Channel Switch Announcement) when
mac80211 swaps channel contexts. Reachable from AP channel switches, DFS
events, and MLO multi-link simultaneous CSA. Requires `CONFIG_ATH12K`
with multi-radio hardware (`ah->num_radio > 1`). Userspace triggers via
normal WiFi operations (hostapd channel changes, etc.).

### Step 5.5: Similar Patterns
**Record:** rtw89's `rtw89_ops_switch_vif_chanctx()` (mac80211.c:1369)
iterates each vif individually with per-vif link lookup — the correct
pattern. ath12k's pre-fix code was an outlier assuming single-radio
batch processing.

---

## Phase 6: Cross-Referencing Against Local Tree

### Step 6.1: Buggy Code Exists?
**Record:** **YES.** Local tree is **v6.18.44** (`git describe HEAD`).
Buggy code confirmed at mac.c:11635-11646 — uses `vifs->old_ctx` for
single `ar`, processes all `n_vifs` with that `ar`. Bug introduced by
`314876885bdcc3` (April 2024, present since ~v6.9). Multi-radio single-
wiphy support fully present (`ah->num_radio`, `wiphy->n_radio`, MLO
capable hardware registration at mac.c:14395+).

### Step 6.2: Backport Complications
**Record:** Clean apply expected. File structure matches diff context.
`kzalloc_objs`, `__free(kfree)`, `ath12k_generic_dbg` all available. No
conflicting changes in recent history. Expected difficulty: **clean
apply**.

### Step 6.3: Related Fixes Already Present?
**Record:** No — `git log -S "ar_map"` and `git grep "Prevent incorrect
vif chanctx"` return nothing. Fix not yet in tree.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem Criticality
**Record:** **drivers/net/wireless/ath/ath12k** — IMPORTANT. WiFi 7
driver for Qualcomm hardware (QCN9274, WCN7850, etc.). Not core kernel,
but affects all users of supported WiFi 7 hardware.

### Step 7.2: Subsystem Activity
**Record:** Actively developed — 20+ commits to ath12k/mac.c in recent
history. ath12k is a relatively young but production driver in v6.18.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of multi-radio ath12k hardware in single-wiphy MLO
configuration (`CONFIG_ATH12K=y/m`). Specifically QCN9274 and similar
WiFi 7 chipsets with 2+ radios. Not universal, but growing hardware
segment.

### Step 8.2: Trigger Conditions
**Record:** Simultaneous CSA across multiple links spanning more than
one radio. Occurs when mac80211 calls `ieee80211_chsw_switch_vifs()`
with `n_vifs > 1` and vifs map to different radios. Realistic on MLO
AP/STA setups during channel switches. Not timing-dependent race —
deterministic logic bug. Unprivileged users can trigger indirectly via
WiFi management (e.g., AP channel change affecting multiple MLO links).

### Step 8.3: Failure Mode Severity
**Record:** **HIGH** — Driver state corruption. Wrong vdev IDs sent to
wrong radio's firmware via WMI. Can cause WiFi disconnects, firmware
communication errors, potential kernel warnings/crashes. The added
`WARN_ON(!arvif)` path prevents NULL dereference when vif doesn't
resolve on the wrong radio. Not silent data corruption, but functional
breakage of wireless connectivity.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH for affected hardware — prevents state corruption
  during CSA on multi-radio WiFi 7 devices
- **Risk:** LOW — contained to one function's error handling path, uses
  established patterns, adds validation before processing
- **Ratio:** Strong benefit outweighs minimal risk

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backporting:**
- Fixes real, reproducible logic bug in multi-radio chanctx switching
- Can corrupt driver state / break WiFi on QCN9274-class hardware
- Hardware-tested (Tested-on: QCN9274)
- Reviewed by two Qualcomm ath12k developers
- Small, single-file, self-contained fix
- Bug present since April 2024 single-wiphy support (`314876885bdcc3`)
- Buggy code confirmed in v6.18.44
- Adds NULL safety guard preventing potential oops
- Follows pattern used by other WiFi drivers (rtw89)

**AGAINST backporting:**
- Only affects multi-radio ath12k hardware (not all users)
- No syzbot report or user bug report (identified proactively)
- CSA across multiple radios may be less common than single-radio
  operations

**UNRESOLVED:**
- Full lore.kernel.org review thread (bot protection blocked access)
- Whether reviewers explicitly nominated for stable

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic is sound, QCN9274
   tested, dual Reviewed-by
2. Fixes a real bug? **PASS** — incorrect radio selection with state
   corruption
3. Important issue? **PASS** — driver state corruption / connectivity
   loss (HIGH severity)
4. Small and contained? **PASS** — one file, ~75 lines, focused change
5. No new features or APIs? **PASS** — bug fix only, returns existing
   error codes
6. Can apply to local tree? **PASS** — all dependencies present, clean
   apply expected

### Step 9.3: Exception Categories
**Record:** N/A — standard driver bug fix, not a quirk/DT/build/doc
exception.

### Step 9.4: Decision Rationale

This commit fixes a deterministic bug in ath12k's channel context switch
handler for multi-radio single-wiphy configurations. The local tree
(v6.18.44) contains the buggy code introduced in April 2024 and lacks
this fix. When mac80211 passes vifs spanning multiple radios during
simultaneous CSA, the driver sends vdev WMI commands to the wrong radio,
corrupting driver state. The fix correctly groups vifs by radio and
validates each entry — a minimal, obviously correct change tested on
real hardware. While the affected hardware population is narrower than a
core kernel bug, WiFi 7 multi-radio devices are production hardware in
v6.18, and driver state corruption during channel switches is a serious
functional defect appropriate for stable.

---

## Verification

- **[Phase 1]** Parsed commit message: subject, tags (Tested-on,
  Reviewed-by x2, Link), body analysis
- **[Phase 2]** Diff analysis: 2 functions in mac.c, logic bug + NULL
  guard, ~75 lines
- **[Phase 3]** `git blame -L 11625,11649`: function from d889913
  (2022), radio lookup from 314876885bdcc3 (2024-04-09)
- **[Phase 3]** `git show 314876885bdcc3`: confirmed single-wiphy commit
  introduced the assumption
- **[Phase 3]** `git merge-base --is-ancestor`: both d889913 and
  314876885bdcc3 are in tree
- **[Phase 3]** `git log -S "ar_map"`: empty — fix not applied
- **[Phase 3]** `git log --oneline -20 --
  drivers/net/wireless/ath/ath12k/mac.c`: recent active development
- **[Phase 4]** `b4 dig -c HEAD`: failed (commit not in tree)
- **[Phase 4]** lore.kernel.org/patch.msgid.link: blocked by Anubis
  (UNVERIFIED: review thread)
- **[Phase 5]** `grep switch_vif_chanctx`: mac80211 chan.c:1537 calls
  with n_vifs spanning all reserved links
- **[Phase 5]** Read rtw89 mac80211.c:1369-1414: per-vif iteration
  pattern (comparison)
- **[Phase 5]** Read ath12k mac.c:10878-10907: confirmed NULL deref risk
  before fix
- **[Phase 6]** `git describe HEAD`: v6.18.44
- **[Phase 6]** Read mac.c:11625-11649: buggy code present (uses vifs[0]
  only)
- **[Phase 6]** `git merge-base --is-ancestor 3bf5e19c804d0 HEAD`:
  kzalloc_objs available
- **[Phase 6]** `grep __free(kfree)`: pattern already used in
  ath12k/mac.c
- **[Phase 6]** `grep ath12k_generic_dbg`: present in debug.h
- **[Phase 8]** Failure mode: driver state corruption on multi-radio
  CSA, severity HIGH

**YES**The background search finished: the commit isn’t in this tree yet
(no matches for “Prevent incorrect vif chanctx” or “multi-radio
contexts”), which matches evaluating it as a new backport candidate.

**Summary for v6.18.44:** **YES** — backport this fix.

The bug is real and present: on multi-radio ath12k hardware,
`ath12k_mac_op_switch_vif_chanctx()` picks the radio from `vifs[0]` but
processes the whole batch, so simultaneous CSA across radios can send
vdev WMI commands to the wrong radio and corrupt driver state. The patch
groups vifs by radio, validates each one, and adds a NULL guard in
`ath12k_mac_update_vif_chan()`. It’s a small, single-file change, tested
on QCN9274, and should apply cleanly here.

 drivers/net/wireless/ath/ath12k/mac.c | 87 +++++++++++++++++++++++----
 1 file changed, 76 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 4bb4482e27343..2f47054efa44e 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -10888,6 +10888,9 @@ ath12k_mac_update_vif_chan(struct ath12k *ar,
 			continue;
 		}
 
+		if (WARN_ON(!arvif))
+			continue;
+
 		ath12k_dbg(ab, ATH12K_DBG_MAC,
 			   "mac chanctx switch vdev_id %i freq %u->%u width %d->%d\n",
 			   arvif->vdev_id,
@@ -11628,23 +11631,85 @@ ath12k_mac_op_switch_vif_chanctx(struct ieee80211_hw *hw,
 				 int n_vifs,
 				 enum ieee80211_chanctx_switch_mode mode)
 {
-	struct ath12k *ar;
+	struct ath12k *curr_ar, *new_ar, *group_ar;
+	struct ieee80211_vif_chanctx_switch *v;
+	int i, j, count = 0;
 
 	lockdep_assert_wiphy(hw->wiphy);
 
-	ar = ath12k_get_ar_by_ctx(hw, vifs->old_ctx);
-	if (!ar)
-		return -EINVAL;
+	if (n_vifs == 0)
+		return 0;
 
-	/* Switching channels across radio is not allowed */
-	if (ar != ath12k_get_ar_by_ctx(hw, vifs->new_ctx))
-		return -EINVAL;
+	struct ath12k **ar_map __free(kfree) = kzalloc_objs(*ar_map, n_vifs);
 
-	ath12k_dbg(ar->ab, ATH12K_DBG_MAC,
-		   "mac chanctx switch n_vifs %d mode %d\n",
-		   n_vifs, mode);
-	ath12k_mac_update_vif_chan(ar, vifs, n_vifs);
+	if (!ar_map)
+		return -ENOMEM;
+
+	for (i = 0; i < n_vifs; i++) {
+		v = &vifs[i];
+
+		if (v->old_ctx->def.chan->band != v->new_ctx->def.chan->band) {
+			ath12k_generic_dbg(ATH12K_DBG_MAC,
+					   "mac chanctx switch band change not supported\n");
+			return -EOPNOTSUPP;
+		}
+
+		curr_ar = ath12k_get_ar_by_ctx(hw, v->old_ctx);
+		new_ar = ath12k_get_ar_by_ctx(hw, v->new_ctx);
+
+		if (!curr_ar || !new_ar) {
+			ath12k_generic_dbg(ATH12K_DBG_MAC,
+					   "unable to determine device for the passed channel ctx\n");
+			ath12k_generic_dbg(ATH12K_DBG_MAC,
+					   "Old freq %d MHz (device %s) to new freq %d MHz (device %s)\n",
+					   v->old_ctx->def.chan->center_freq,
+					   curr_ar ? "valid" : "invalid",
+					   v->new_ctx->def.chan->center_freq,
+					   new_ar ? "valid" : "invalid");
+			return -EINVAL;
+		}
 
+		/* Switching a vif between two radios is not allowed */
+		if (curr_ar != new_ar) {
+			ath12k_dbg(curr_ar->ab, ATH12K_DBG_MAC,
+				   "mac chanctx switch to another radio not supported\n");
+			return -EOPNOTSUPP;
+		}
+
+		ar_map[i] = curr_ar;
+	}
+
+	/* Group vifs by radio (ar) and process each group independently. */
+	bool *processed __free(kfree) = kzalloc_objs(*processed, n_vifs);
+
+	if (!processed)
+		return -ENOMEM;
+
+	struct ieee80211_vif_chanctx_switch *group_vifs __free(kfree) =
+						kzalloc_objs(*group_vifs, n_vifs);
+
+	if (!group_vifs)
+		return -ENOMEM;
+
+	for (i = 0; i < n_vifs; i++) {
+		if (processed[i])
+			continue;
+
+		group_ar = ar_map[i];
+
+		count = 0;
+		for (j = 0; j < n_vifs; j++) {
+			if (!processed[j] && ar_map[j] == group_ar) {
+				group_vifs[count++] = vifs[j];
+				processed[j] = true;
+			}
+		}
+
+		ath12k_dbg(group_ar->ab, ATH12K_DBG_MAC,
+			   "mac chanctx switch n_vifs %d mode %d\n",
+			   count, mode);
+		ath12k_mac_update_vif_chan(group_ar, group_vifs, count);
+	}
 	return 0;
 }
 
-- 
2.53.0

