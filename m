Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A795073A0;
	Mon, 31 Aug 2026 13:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183745; cv=none; b=B69uApcFqfefUmL4Iq4+HYjUBZ89q1KIYgsXK1PXbwnNeshdZM577AoGrss66OBRN7tl60rAUiu/2Ojb1yUEPp2ImCsXBVDTQhx9u8OMHEqkIVYGVBZdUQEu7+R5Q6NOsvBsdWW1FbyJIp572DeuWggCWh0fvYanBOxOQtoZtBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183745; c=relaxed/simple;
	bh=kK1aO7mm/Sjdl6ShM3gtjqViSePMcDQTo4OhfgAJaiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cNS/xTPYYPZL72oiCZ7CJO4qQV8NKFRbK91ZrKeyDK0OYJTHmas1g9NmIC271TyQf+CRv6a6OGOmdQ68cMXtiPBNC3JixReJ/vGoTTYbDI2JmcFHmJVQ450XNtml8RFbUiZLNV4DeXVOzoYVkdFs+mmIpheqgY8O7vhZSVrMKhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QSBocgEN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QSBocgEN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9591F00A3E;
	Mon, 31 Aug 2026 13:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183742;
	bh=QcRiy7EsNXkKQ0pBtMrEGi9AV8gEyn7siXmGqyX6rL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QSBocgENCohCeMCC3ZGQu6oeoXYopBvnEe9FyUpxCqqnxaLbp4bo0WiWs8uiTvum/
	 ySrcO/qdGR/ttmos6Vg+NZBJdxLqOsYYjGf5dGT5ayG5YQeNg6nNHP/uHljpsj5T8I
	 jorDQyRRG7BPkPzH0mXimbg2kHvYXix9+K1ScYiEuGjN6zhTxPZviCUoaBxJef/vhr
	 SNcoMqfdonATQVZZCWhMKA/PUOMbMeoUJ13TugP7C+NT6yHyd7D71hT10eCXz9xRXA
	 cST0j/gTAO2BvQSP8WVfjPaEQUTqXm67yWV6vUtV3WzAQ11wF8jmXoxXzJsh+TsUjC
	 fE+SgMUu/KtDQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: mld: honor BSS_CHANGED_BEACON_ENABLED
Date: Mon, 31 Aug 2026 09:25:05 -0400
Message-ID: <20260831133314.4125787-277-sashal@kernel.org>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit a342c99cb70dde344723f6c802efd24e614f4fda ]

We should stick to mac80211's flow to start / stop beaconing. This
allows to stop beaconing before we remove the BIGTK.

Note that the start and stop beaconing flows are not exactly symmetric.
When we start beaconing, we just update the beacon template. We assume
that mac80211 won't update the beacons, if we're not supposed to be
sending it.

Also note that we now send the beacon template after the broadcast
station was added to the firmware: the broadcast station is added in
the start_ap() flow, while the beacon template is now added in the
link_changed() flow which happens later. This is not what we did
before this patch, but this sequence is supported by the firmware as
well.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260511203428.cf10e5754171.I8022517c6c5aedb4b56fba30a5545de8f62dddbe@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: iwlwifi: mld: honor
BSS_CHANGED_BEACON_ENABLED`

**Local tree:** Linux **6.18.44** (`git describe HEAD` → `v6.18.44`,
`make kernelversion` → `6.18.44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 – Subject line**
Record: `[wifi: iwlwifi: mld]` `[honor]` — Implement proper handling of
mac80211 `BSS_CHANGED_BEACON_ENABLED` in the Intel MLD (WiFi 7) driver.

**Step 1.2 – Tags**
Record:
- `Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>`
  (author)
- `Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>`
  (series submitter)
- `Link: https://patch.msgid.link/20260511203428...` (patch submission)
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, `Tested-
  by:`, or `Reviewed-by:` tags

**Step 1.3 – Body analysis**
Record:
- **Bug:** Driver does not follow mac80211’s beacon start/stop flow;
  beaconing is not stopped when mac80211 disables it.
- **Symptom:** On AP teardown, firmware may continue beaconing while
  keys (specifically BIGTK) are removed.
- **Root cause:** Missing `BSS_CHANGED_BEACON_ENABLED` handler; beacon
  template was sent too early in `start_ap()` instead of via
  `link_info_changed`.
- **Version info:** None stated.

**Step 1.4 – Hidden bug fix?**
Record: **Yes.** Although the subject says “honor,” this is a
driver/mac80211 contract bug: beaconing must stop before key removal on
AP stop.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 – Inventory**
Record:
- `drivers/net/wireless/intel/iwlwifi/mld/ap.c` (+25/−4): new
  `iwl_mld_stop_beacon()`, remove early beacon update from `start_ap`
- `drivers/net/wireless/intel/iwlwifi/mld/ap.h` (+4): declare
  `iwl_mld_stop_beacon()`
- `drivers/net/wireless/intel/iwlwifi/mld/mac80211.c` (+6/−2): handle
  `BSS_CHANGED_BEACON_ENABLED`, add `WARN_ON(!link->enable_beacon)` for
  `BSS_CHANGED_BEACON`
- **Functions:** `iwl_mld_stop_beacon()` (new),
  `iwl_mld_start_ap_ibss()`, `iwl_mld_link_info_changed_ap_ibss()`
- **Scope:** Single-subsystem, surgical (~32 lines)

**Step 2.2 – Code flow changes**
Record:
- **Hunk 1 (`iwl_mld_stop_beacon`):** Sends `BEACON_TEMPLATE_CMD` with
  `byte_cnt = 0` and valid `link_id` → tells firmware to stop beaconing.
  Only if `BEACON_TEMPLATE_CMD` version ≥ 15.
- **Hunk 2 (`start_ap`):** Removes `iwl_mld_update_beacon_template()`
  call; beacon setup deferred to `link_info_changed`.
- **Hunk 3 (`link_info_changed`):** On `BSS_CHANGED_BEACON`, only update
  if `enable_beacon` is true (with `WARN_ON`). On
  `BSS_CHANGED_BEACON_ENABLED` with `!enable_beacon`, call
  `iwl_mld_stop_beacon()`.

**Step 2.3 – Bug mechanism**
Record: **Logic / correctness fix** — missing mac80211 callback
handling. mac80211 notifies drivers to stop beaconing
(`BSS_CHANGED_BEACON_ENABLED`) **before** removing keys; iwl_mld ignored
this, so firmware could keep transmitting beacons while BIGTK/GTK keys
were torn down.

**Step 2.4 – Fix quality**
Record: Fix is minimal and matches patterns used by ath10k, ath11k,
mt76, rtw88, etc. Low regression risk. Minor concern: `cmd_ver < 15`
silently skips stop (partial coverage on older firmware).

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 – Blame**
Record: This stable tree has shallow per-file history (single unrelated
commit on blame). iwl_mld code is present as part of the 6.18.44 import.
Buggy pattern (`BSS_CHANGED_BEACON` only, no
`BSS_CHANGED_BEACON_ENABLED`) is present in the checked-out tree.

**Step 3.2 – Fixes: tag**
Record: N/A — no `Fixes:` tag.

**Step 3.3 – Related file history**
Record: Part of Intel iwlwifi update series `[PATCH 0/15] wifi: iwlwifi:
updates - 2026-05-11` (patch 4/15). Patch 5/15 only moves the function
to `ap.c` (refactor, not a functional prerequisite).

**Step 3.4 – Author context**
Record: Emmanuel Grumbach is a long-time iwlwifi maintainer. Miri
Korenblit submits Intel iwlwifi series regularly.

**Step 3.5 – Dependencies**
Record: **Standalone.** No prerequisite commits required; patch 5/15 is
optional cleanup.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 – Original discussion**
Record: `b4 dig` failed (commit not in this tree). Patch content
verified from local mbox
`20260511_miriam_rachel_korenblit_wifi_iwlwifi_updates_2026_05_11.mbx`.
Lore URL blocked by bot protection.

**Step 4.2 – Reviewers**
Record: Not verified from lore (fetch blocked). Series cover letter
lists Intel iwlwifi maintainers as authors.

**Step 4.3 – Bug report**
Record: No external bug report or syzbot link. Internal Intel finding.

**Step 4.4 – Series context**
Record: Patch 4/15 in a 15-patch iwlwifi series. Functionally
independent of other patches.

**Step 4.5 – Stable list discussion**
Record: Not searched/found. No stable nomination in commit message
(expected for manual review).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 – Key functions**
Record: `iwl_mld_link_info_changed_ap_ibss()`,
`iwl_mld_start_ap_ibss()`, `iwl_mld_stop_beacon()` (new),
`iwl_mld_set_key_remove()`

**Step 5.2 – Callers**
Record:
- `iwl_mld_link_info_changed_ap_ibss()` ←
  `iwl_mld_mac80211_link_info_changed()` ← mac80211
  `drv_link_info_changed()`
- `iwl_mld_start_ap_ibss()` ← `.start_ap` / `.join_ibss` ops
- Key removal ← `iwl_mld_set_key_remove()` ← `.set_key(DISABLE_KEY)`

**Step 5.3 – Callees**
Record: `iwl_mld_send_cmd_pdu(BEACON_TEMPLATE_CMD)`,
`iwl_mld_update_beacon_template()`, `iwl_fw_lookup_cmd_ver()`

**Step 5.4 – Call chain / reachability**
Record:
```
ieee80211_stop_ap()
  → enable_beacon = false
  → ieee80211_link_info_change_notify(BSS_CHANGED_BEACON_ENABLED)
[driver should stop beacon]
  → ieee80211_remove_link_keys()
[BIGTK/GTK removed]
  → drv_stop_ap() → iwl_mld_stop_ap_ibss()
```
Userspace triggers this via `nl80211` AP stop (hostapd, wpa_supplicant
P2P GO, etc.). **Reachable from normal AP operation.**

**Step 5.5 – Similar patterns**
Record: **Every major mac80211 driver** handles
`BSS_CHANGED_BEACON_ENABLED` (ath10k, ath11k, ath12k, mt76, rtw88,
iwllegacy, etc.). iwl_mld is the outlier.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

**Step 6.1 – Buggy code exists?**
Record: **Yes.** Current tree at
`drivers/net/wireless/intel/iwlwifi/mld/mac80211.c:1157-1158` only
handles `BSS_CHANGED_BEACON`. `ap.c:279` still calls
`iwl_mld_update_beacon_template()` inside `start_ap`. iwl_mld subsystem
fully present (`CONFIG_IWLMLD`, 31 source files).

**Step 6.2 – Backport complications**
Record: **Clean apply expected.** File structure matches the patch
context (`index 5c59acc8c4c5` etc.). No conflicting changes detected.

**Step 6.3 – Related fixes already present?**
Record: **No.** `grep BSS_CHANGED_BEACON_ENABLED` under `iwlwifi/mld/`
returns zero matches.

---

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1 – Subsystem / criticality**
Record: `drivers/net/wireless/intel/iwlwifi/mld` — **IMPORTANT** (Intel
WiFi 7 MLD hardware driver; AP/P2P GO/IBSS modes).

**Step 7.2 – Activity**
Record: Active new driver (Copyright 2024–2025, MLD opmode `iwlmld`).
Targets BZ/SC/DR chip families.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 – Who is affected**
Record: Users of Intel MLD-capable hardware (`CONFIG_IWLMLD`) running
AP, P2P GO, or IBSS — especially WPA3 setups using BIGTK (key indices
6/7).

**Step 8.2 – Trigger conditions**
Record: **Common** — every AP stop/teardown. Requires AP/IBSS mode with
iwl_mld driver loaded. Not userspace-exploitable as a security
primitive, but normal admin operations trigger it.

**Step 8.3 – Failure mode severity**
Record: Firmware may continue beaconing after BIGTK removal → potential
**firmware assert, hang, or corrupted teardown**. Related iwl_mvm code
documents firmware asserts (0x2b00) from incorrect beacon/key teardown
ordering. Severity: **HIGH** (stability during normal operation).

**Step 8.4 – Risk vs benefit**
Record:
- **Benefit:** HIGH for affected hardware — fixes real teardown ordering
  bug
- **Risk:** LOW — ~30 lines, follows mac80211 contract, maintainer-
  authored
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR:**
- Real mac80211 contract violation (only iwl_mld driver missing this
  among peers)
- mac80211 explicitly stops beaconing before key removal
  (`cfg.c:1879-1887`)
- BIGTK removal while beaconing continues is a concrete failure scenario
- Small, surgical, maintainer fix
- Code and bug both exist in Linux 6.18.44
- Clean apply expected

**Evidence AGAINST:**
- No external crash report or syzbot finding
- `cmd_ver < 15` path leaves bug unfixed on older firmware (mitigated:
  MLD firmware likely always ≥ v15)
- iwl_mld is newer hardware with smaller install base than iwl_mvm
- Part of larger series (but this patch is standalone)

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** — matches mac80211 design and
   peer drivers; no Tested-by but logic is clear
2. Fixes a real bug? **PASS** — missing beacon-stop on AP teardown
3. Important issue? **PASS** — teardown stability / potential firmware
   crash
4. Small and contained? **PASS** — 3 files, ~32 lines
5. No new features/APIs? **PASS** — implements existing mac80211
   callback semantics
6. Can apply to local tree? **PASS** — iwl_mld code present, patch
   applies cleanly

**Exception category:** Standard driver bug fix (not device
ID/quirk/DT/docs).

---

## Problem Summary for Stable Users

When an AP on Intel MLD WiFi hardware is stopped, mac80211 tells the
driver to disable beaconing **before** removing encryption keys
(including BIGTK for WPA3 broadcast integrity). The iwl_mld driver
ignored `BSS_CHANGED_BEACON_ENABLED`, so the firmware could keep
transmitting beacons while keys were removed — violating the teardown
order mac80211 and every other major WiFi driver follow. This can cause
firmware instability during normal AP shutdown (hostapd, P2P GO, etc.).

The fix adds `iwl_mld_stop_beacon()` (empty beacon template to
firmware), handles `BSS_CHANGED_BEACON_ENABLED`, and moves beacon
template installation to the correct point in the mac80211 flow (after
broadcast STA is added).

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message and
  local mbox
- [Phase 2] Diff analysis: 3 files, `iwl_mld_stop_beacon()` +
  `link_info_changed` + `start_ap` reorder
- [Phase 3] `git describe HEAD` → v6.18.44; shallow mld git history (1
  entry); series context from mbox cover letter
- [Phase 4] `b4 dig` failed (commit not in tree); patch verified from `2
  0260511_miriam_rachel_korenblit_wifi_iwlwifi_updates_2026_05_11.mbx`;
  lore fetch blocked
- [Phase 5] `grep BSS_CHANGED_BEACON_ENABLED` across
  `drivers/net/wireless` — iwl_mld is only Intel driver missing it;
  traced `ieee80211_stop_ap()` ordering in `cfg.c:1879-1901`
- [Phase 6] Confirmed buggy code at `mac80211.c:1157-1158` and
  `ap.c:279`; `grep` shows no existing fix; `CONFIG_IWLMLD` present
- [Phase 7] iwl_mld subsystem confirmed (31 `.c` files, Kconfig entry)
- [Phase 8] Failure mode: beaconing continues during key teardown;
  severity HIGH for AP stop path
- [Phase 8] mac80211 key removal after beacon-disable notification
  verified at `cfg.c:1884-1887`
- [Phase 8] BIGTK handling in `mac80211.c:2141-2142` (`keyidx == 6 ||
  keyidx == 7`)
- [Phase 8] Peer driver pattern verified in `ath10k/mac.c:6212` and
  `ath11k/mac.c:3611`

**YES**The analysis is done for **Linux 6.18.44**.

**Verdict: YES** — backport this commit.

The iwl_mld driver in this tree ignores `BSS_CHANGED_BEACON_ENABLED`, so
on AP/P2P GO/IBSS teardown the firmware can keep beaconing while
mac80211 removes keys (including BIGTK). mac80211 expects beaconing to
stop first; other WiFi drivers already do this. The fix is small (~32
lines), self-contained, and should apply cleanly here.

The background `b4 dig` run didn’t find a lore match because it was
pointed at an unrelated commit in this tree; the patch itself was
verified from the local iwlwifi mbox instead.

 drivers/net/wireless/intel/iwlwifi/mld/ap.c   | 25 +++++++++++++++----
 drivers/net/wireless/intel/iwlwifi/mld/ap.h   |  6 ++++-
 .../net/wireless/intel/iwlwifi/mld/mac80211.c |  8 +++++-
 3 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/ap.c b/drivers/net/wireless/intel/iwlwifi/mld/ap.c
index 5c59acc8c4c5a..c29e4a77be058 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/ap.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/ap.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2024 Intel Corporation
+ * Copyright (C) 2024, 2026 Intel Corporation
  */
 #include <linux/crc32.h>
 
@@ -239,6 +239,25 @@ int iwl_mld_store_ap_early_key(struct iwl_mld *mld,
 	return -ENOSPC;
 }
 
+void iwl_mld_stop_beacon(struct iwl_mld *mld, struct ieee80211_vif *vif,
+			 struct ieee80211_bss_conf *link)
+{
+	struct iwl_mld_link *mld_link = iwl_mld_link_from_mac80211(link);
+	struct iwl_mac_beacon_cmd cmd = {};
+	int cmd_ver = iwl_fw_lookup_cmd_ver(mld->fw, BEACON_TEMPLATE_CMD, 14);
+
+	if (WARN_ON(!mld_link))
+		return;
+
+	if (cmd_ver < 15)
+		return;
+
+	/* leave byte_cnt 0 */
+	cmd.link_id = cpu_to_le32(mld_link->fw_id);
+
+	iwl_mld_send_cmd_pdu(mld, BEACON_TEMPLATE_CMD, &cmd);
+}
+
 static int iwl_mld_send_ap_early_keys(struct iwl_mld *mld,
 				      struct ieee80211_vif *vif,
 				      struct ieee80211_bss_conf *link)
@@ -276,10 +295,6 @@ int iwl_mld_start_ap_ibss(struct ieee80211_hw *hw,
 	if (vif->type == NL80211_IFTYPE_AP)
 		iwl_mld_send_ap_tx_power_constraint_cmd(mld, vif, link);
 
-	ret = iwl_mld_update_beacon_template(mld, vif, link);
-	if (ret)
-		return ret;
-
 	/* the link should be already activated when assigning chan context,
 	 * and LINK_CONTEXT_MODIFY_EHT_PARAMS is deprecated
 	 */
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/ap.h b/drivers/net/wireless/intel/iwlwifi/mld/ap.h
index 4a6f52b9552d7..a3b6bed814adf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/ap.h
+++ b/drivers/net/wireless/intel/iwlwifi/mld/ap.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2024 Intel Corporation
+ * Copyright (C) 2024, 2026 Intel Corporation
  */
 #ifndef __iwl_ap_h__
 #define __iwl_ap_h__
@@ -14,6 +14,10 @@ int iwl_mld_update_beacon_template(struct iwl_mld *mld,
 				   struct ieee80211_vif *vif,
 				   struct ieee80211_bss_conf *link_conf);
 
+void iwl_mld_stop_beacon(struct iwl_mld *mld,
+			 struct ieee80211_vif *vif,
+			 struct ieee80211_bss_conf *link_conf);
+
 int iwl_mld_start_ap_ibss(struct ieee80211_hw *hw,
 			  struct ieee80211_vif *vif,
 			  struct ieee80211_bss_conf *link);
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index 67b61765adf39..322669d78b193 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -1154,8 +1154,14 @@ iwl_mld_link_info_changed_ap_ibss(struct iwl_mld *mld,
 	if (link_changes)
 		iwl_mld_change_link_in_fw(mld, link, link_changes);
 
-	if (changes & BSS_CHANGED_BEACON)
+	if (changes & BSS_CHANGED_BEACON) {
+		WARN_ON(!link->enable_beacon);
 		iwl_mld_update_beacon_template(mld, vif, link);
+	}
+
+	/* Enabling beacons was already covered above */
+	if ((changes & BSS_CHANGED_BEACON_ENABLED) && !link->enable_beacon)
+		iwl_mld_stop_beacon(mld, vif, link);
 }
 
 static
-- 
2.53.0

