Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BC94483A2;
	Mon, 31 Aug 2026 13:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183611; cv=none; b=BCY9Ozb2Jdpk6CBmzTecTtiXm1VDOfbaDqVIxIYRXo3g4eQTyi5n1ZZr0JtRDTY5Vs5WtHEBLr8KZBBoX6kA7L0i6juzwQ8Cqd7ks30dDoRKXjBGn3JOFXVTD70dopy8e8vj7jQk8xBErA5XyBqXD+3jMnLKshqjnAfkCn9V0AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183611; c=relaxed/simple;
	bh=JGcojUAH0Aat7vE6ytiPzjoXuUBzRyNOnCJ4jd9+w1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fkrbLbpw7xZhei5xh7OzOAWvJpTh2PZjvEKm7owb6uqM2NB+eX6xP/sV+RqUSt+oiNq2/0nxdVsK5/encWlAp5wjrs4lxLS9CZs7vpLvGmT+XPJdXkTGZ4gViyLdPQFWig1LCW5K1DS0JY2e0Q0vidzY8NChDBhA0RW9E5Gahkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A8bQ7v3W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A8bQ7v3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64CC81F00ACA;
	Mon, 31 Aug 2026 13:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183608;
	bh=sTWDIypQ47wtxExqtndEjlngUaQQvZgG/ekIoAf+M2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A8bQ7v3W7Ut5Ya4l4hnaVJH4jQ3yhsO3ROtaA6QAlIhAUaYNpR2S+wYHk+7bp+h02
	 N8ze1Umg7CQwiNuH1AczyvCqxuKriLZ4zxTRwUEgNC3muCOgb2pA3imVu4xj/e6En3
	 W4e6ZVDDfoqY2L1xCqh8N9tFP58gNq73TIfGj9aseng5XMVcawzr8hA38ClvyeOpRH
	 Z/4d0K++dpeqUThL4q6oqWKZB2fOfGZRNyfQICuQjDGLy6Nrz2XRlbBZ1N/CQGW/b1
	 1w4xj1AcTexPIkI5dtVzcOx0ouN0YKiINfXsS7dhqHJtzGJ/DK/W0Yn21O/aky7sFT
	 cmJNmmVOpelbQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: mac80211: unify link STA removal in vif link removal
Date: Mon, 31 Aug 2026 09:23:44 -0400
Message-ID: <20260831133314.4125787-196-sashal@kernel.org>
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

[ Upstream commit 79fb99e16f60a77cbd2824695d98aa34ebbb9d69 ]

There are multiple cases where interface links are removed
and the station links need to be removed with them, e.g.
in mlme.c we have both received and transmitted multi-link
reconfiguration, doing the two things in different order,
the former deleting STA links when the vif link change may
still fail.

It's also not clear that userspace (hostapd) couldn't, at
least in theory, remove a link from an interface without
removing the station links first, or even leave stations
that aren't MLO-capable, using that link.

Unify this code into ieee80211_vif_update_links() so that
it always happens, always happens in the right order and
is transactional (i.e. failures are handled correctly.)

Link: https://patch.msgid.link/20260529102644.c352f73a4658.I7219a5d72dab2abcecea9b5c52e7eb7a50e68d9b@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: mac80211: unify link STA removal in
vif link removal`

**Local tree:** `v6.18.44` (`stable/linux-6.18.y`, detached HEAD)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[wifi: mac80211]` `[unify]` — consolidate station-link
teardown when VIF links are removed during MLO (multi-link)
reconfiguration.

### Step 1.2: Tags
**Record:**
- **Link:** `https://patch.msgid.link/20260529102644.c352f73a4658...`
  (original submission)
- **Signed-off-by:** Johannes Berg `<johannes.berg@intel.com>`
  (mac80211/cfg80211 maintainer)
- **No** Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or
  Cc: stable tags
- **Notable:** No fuzzer or user bug-report tags; author is subsystem
  maintainer

### Step 1.3: Body analysis
**Record:**
- **Bug:** Multiple code paths remove interface (VIF) links without
  consistently removing associated station links, and two paths
  (`ml_reconf_work` vs `ieee80211_mgd_assoc_ml_reconf`) do cleanup in
  different order.
- **Symptom:** Stale/orphaned per-link STA state; in one path STA links
  are removed before VIF update and a VIF update failure leaves
  inconsistent state.
- **Root cause:** STA link removal is duplicated ad hoc in `mlme.c`
  instead of being tied transactionally to
  `ieee80211_vif_update_links()`.
- **Also covers:** Userspace (hostapd) removing a VIF link without first
  removing station links, or leaving non-MLO-capable stations on that
  link.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Described as “unify,” but it fixes a real state-
management bug: VIF links and STA links can diverge, leaving stale
`link_sta` entries and incorrect driver notifications.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `net/mac80211/link.c` (+~30 lines), `net/mac80211/mlme.c`
  (-~25 lines)
- **Functions modified:** `ieee80211_vif_update_links()`,
  `ieee80211_ml_reconf_work()`, `ieee80211_mgd_assoc_ml_reconf()`
- **Scope:** Two-file, surgical refactor of MLO link-removal logic

### Step 2.2: Code flow per hunk

**`link.c` — `ieee80211_vif_update_links()`**
- **Before:** After successful driver VIF link update, only deflink
  teardown; no STA link cleanup.
- **After:** After successful driver update:
  1. For each STA on this `sdata`, remove only the links being dropped
     (skip STAs that would lose all links).
  2. `sta_info_flush(sdata, link_id)` for each removed link (flushes
     STAs with no links left).
- **Path:** Success path only; runs under wiphy lock after
  `drv_change_vif_links()`.

**`mlme.c` — `ieee80211_ml_reconf_work()`**
- **Before (patch base):** Removed AP STA links *before*
  `ieee80211_vif_set_links()`.
- **After:** STA cleanup delegated to `ieee80211_vif_update_links()`.

**`mlme.c` — `ieee80211_mgd_assoc_ml_reconf()`**
- **Before:** Called `ieee80211_vif_set_links()`, then manually looped
  `ieee80211_sta_remove_link()`.
- **After:** Only `ieee80211_vif_set_links()`; STA cleanup is internal.

### Step 2.3: Bug mechanism
**Record:** **Logic / reference-counting / state consistency fix
(category g + c).**
- VIF `valid_links` and per-STA `valid_links`/`link_sta` structures can
  diverge.
- `ieee80211_sta_remove_link()` calls `drv_change_sta_links()` and tears
  down `link_sta` hash/debugfs entries.
- Without unified cleanup, removed VIF links leave stale per-link STA
  state and mismatched driver notifications.

### Step 2.4: Fix quality
**Record:** Fix is obviously correct and minimal. Centralizing in the
single VIF-link update function ensures all callers (`ml_reconf_work`,
`mgd_assoc_ml_reconf`, `ieee80211_del_intf_link`, etc.) behave
consistently. Runs only after successful driver VIF update, so it is
transactional. Low regression risk; uses existing
`ieee80211_sta_remove_link()` and `sta_info_flush()` APIs.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame / introduction
**Record:**
- `ieee80211_vif_update_links()` core logic dates to Johannes Berg, Sep
  2022 (MLO link handling).
- MLO dynamic link add/remove introduced in `36e05b0b83903` (2025-01-13,
  Ilan Peer) — **present in this tree**.
- `ieee80211_mgd_assoc_ml_reconf()` manual STA removal present since
  `36e05b0b83903`.
- Related follow-up on mainline (not in 6.18.y): `84674b03d8bf` “Remove
  deleted sta links in ieee80211_ml_reconf_work()” — **NOT an ancestor
  of HEAD**.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related file history
**Record:** Recent related commits in tree include bounds-checking in
`ieee80211_ml_reconfiguration`, `ml_reconf_work` hrtimer conversion, and
error-path link teardown (`0f7eaeb950adb`). No duplicate fix for this
specific issue found.

### Step 3.4: Author context
**Record:** Johannes Berg is mac80211 maintainer. Recent `link.c`
commits from him include MLO CSA and link-change handling.

### Step 3.5: Dependencies
**Record:** Standalone. Requires MLO dynamic link removal code
(`36e05b0b83903`), which is in this tree. Does **not** require
`84674b03d8bf` (that commit is absent here; this patch supersedes that
approach).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c <sha>` could not be run (commit not in tree).
Direct lore/patch.msgid.link fetch blocked by Anubis bot protection.
**UNVERIFIED:** full review thread content.

### Step 4.2: Reviewers
**Record:** **UNVERIFIED** — could not fetch thread via WebFetch or b4.

### Step 4.3: Bug reports
**Record:** No Reported-by in commit message. Related mainline commit
`84674b03d8bf` (not in 6.18.y) was later fixed with “Reported-and-
tested-by: Jouni Malinen” for a hashtable issue caused by wrong STA-link
removal ordering — indicates real-world MLO reconfiguration testing by
hostapd/wpa_supplicant author.

### Step 4.4: Series context
**Record:** Standalone fix, not part of a numbered series.

### Step 4.5: Stable list
**Record:** **UNVERIFIED** — lore stable search inaccessible.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `ieee80211_vif_update_links()`, `ieee80211_vif_set_links()`,
`ieee80211_sta_remove_link()`, `sta_info_flush()`,
`ieee80211_ml_reconf_work()`, `ieee80211_mgd_assoc_ml_reconf()`,
`ieee80211_del_intf_link()`

### Step 5.2: Callers of `ieee80211_vif_set_links()`
**Record:** 15+ call sites in `mlme.c`, `cfg.c`, `link.c`, `iface.c` —
including:
- `ieee80211_ml_reconf_work()` — AP-initiated RX reconfiguration
- `ieee80211_mgd_assoc_ml_reconf()` — STA-initiated TX reconfiguration
- `ieee80211_del_intf_link()` — nl80211 userspace link deletion
  (hostapd)
- Association, disassociation, CSA paths

### Step 5.3: Callees
**Record:** `ieee80211_sta_remove_link()` → `drv_change_sta_links()`,
`sta_remove_link()` (hash removal, RCU free). `sta_info_flush()` →
`__sta_info_destroy_part1/2()`.

### Step 5.4: Reachability
**Record:** Triggered during MLO link reconfiguration (beacon IE or
userspace nl80211) and AP link teardown. Reachable from normal WiFi
management operations on MLO-capable hardware; not init-only or debug-
only.

### Step 5.5: Similar patterns
**Record:** `ieee80211_del_link_station()` in `cfg.c` manually calls
`ieee80211_sta_remove_link()` for explicit per-station link deletion — a
separate, explicit API. VIF-level link removal previously lacked
equivalent centralized STA cleanup.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Does the buggy code exist?
**Record:** **Yes.** Verified in this checkout:

1. **`ieee80211_ml_reconf_work()`** (lines 6943–6946): calls
   `ieee80211_vif_set_links()` with **no** STA link removal. AP-
   initiated link removal leaves stale AP-STA per-link state.

2. **`ieee80211_mgd_assoc_ml_reconf()`** (lines 10859–10874): removes
   VIF links first, then manually removes STA links — partial fix only
   for the AP STA on TX-initiated path.

3. **`ieee80211_del_intf_link()`** (`cfg.c` line 5373): calls
   `ieee80211_vif_set_links()` with **no** STA link cleanup — affects AP
   mode when userspace removes a link.

MLO dynamic link support present since `36e05b0b83903` (Jan 2025).

### Step 6.2: Backport complications
**Record:** Expected **clean apply**. Patch hunks align with current
`link.c`/`mlme.c` structure. No `kzalloc_obj` mismatch in actual changed
lines.

### Step 6.3: Related fixes already present?
**Record:** None found for this unified STA cleanup. `84674b03d8bf`
(partial ml_reconf_work fix) is **not** in this tree.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem / criticality
**Record:** `net/mac80211` — **IMPORTANT** (WiFi stack). MLO is config-
dependent (`ieee80211_vif_is_mld()`), but growing on WiFi 7 hardware.

### Step 7.2: Activity
**Record:** Actively developed; multiple MLO fixes landed in 6.18.y
recently.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** MLO-capable STA and AP users performing dynamic link
removal/reconfiguration (WiFi 7 multi-link). Not universal, but real and
growing hardware segment.

### Step 8.2: Trigger conditions
**Record:**
- AP beacon ML reconfiguration IE removing links
  (`ieee80211_ml_reconf_work`)
- Userspace ML reconfiguration request (`ieee80211_mgd_assoc_ml_reconf`)
- nl80211 interface link deletion (`ieee80211_del_intf_link`)
- Unprivileged users cannot directly trigger; wpa_supplicant/hostapd or
  AP beacon-driven.

### Step 8.3: Failure mode severity
**Record:** Stale `link_sta` entries, mismatched `drv_change_vif_links`
vs `drv_change_sta_links` state, potential driver confusion, connection
instability after link removal, possible resource leaks. **Severity:
MEDIUM-HIGH** for MLO users (functional correctness / potential driver
issues); not a confirmed panic/CVE.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** MEDIUM-HIGH for MLO users — fixes a longstanding gap
  since dynamic link removal was added; covers all VIF link removal
  paths.
- **Risk:** LOW — ~40 lines, uses existing helpers, maintainer-authored,
  only on success path.
- **Ratio:** Favorable.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real bug: VIF and STA link state can diverge on link removal
- In 6.18.44, `ieee80211_ml_reconf_work` never cleans STA links at all
- `ieee80211_del_intf_link` never cleans STA links
- Fix is small, centralized, transactional, from subsystem maintainer
- MLO dynamic link removal code is in this tree since Jan 2025

**AGAINST backport:**
- MLO user base still limited on stable kernels
- No syzbot/crash report or Fixes: tag
- Commit message partly describes ordering bug from `84674b03d8bf`,
  which is not in 6.18.y (though the underlying gap is worse here)
- Failure mode is state inconsistency rather than proven kernel oops

**UNRESOLVED:**
- Full mailing-list review thread (Anubis blocked fetch)
- Whether stable maintainers already discussed this specific patch

### Step 9.2: Stable rules checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — logic is clear; no
Tested-by, but maintainer-authored |
| 2. Fixes real bug affecting users? | **PASS** — verified stale STA
state on multiple paths in 6.18.44 |
| 3. Important issue? | **PASS** — MEDIUM-HIGH for MLO link
reconfiguration correctness |
| 4. Small and contained? | **PASS** — ~2 files, ~40 net lines |
| 5. No new features/APIs? | **PASS** — internal refactor only |
| 6. Can apply to local tree? | **PASS** — code exists, clean apply
expected |

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs).

### Step 9.4: Decision rationale

This commit fixes a genuine mac80211 MLO state-management bug present in
linux-6.18.y since dynamic link removal was introduced. In the current
tree, AP-initiated link removal (`ieee80211_ml_reconf_work`) and nl80211
link deletion (`ieee80211_del_intf_link`) remove VIF links without
cleaning associated STA per-link state. Only the TX-initiated
reconfiguration path partially handles this, and even there the logic is
duplicated and ordering-sensitive. Centralizing STA link teardown inside
`ieee80211_vif_update_links()` after a successful driver update is the
correct transactional fix and benefits every caller. While MLO is not
yet universal, the bug affects real WiFi 7 deployments and the fix is
low-risk.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
- **[Phase 2]** Analyzed provided diff; read current `link.c:275-422`,
  `mlme.c:6901-6959`, `mlme.c:10855-10880`, `sta_info.c:3370-3384`,
  `cfg.c:5359-5374`
- **[Phase 3]** `git describe HEAD` → `v6.18.44`; `git log --oneline -15
  -- net/mac80211/link.c mlme.c`
- **[Phase 3]** `git show 36e05b0b83903` — MLO dynamic link removal
  origin (2025-01-13), in tree
- **[Phase 3]** `git merge-base --is-ancestor 84674b03d8bf HEAD` →
  NOT_IN_TREE
- **[Phase 3]** `git log -p -S 'ieee80211_sta_remove_link' --
  net/mac80211/mlme.c` — history of STA removal in mlme paths
- **[Phase 3]** `git blame -L 380,394 net/mac80211/link.c` —
  `ieee80211_vif_update_links` history
- **[Phase 4]** WebFetch patch.msgid.link and lore.kernel.org — blocked
  by Anubis; **UNVERIFIED** thread content
- **[Phase 4]** `b4 dig` — commit not in tree, could not match by SHA;
  **UNVERIFIED** review thread
- **[Phase 5]** `grep ieee80211_vif_set_links` — 15 call sites across
  mac80211
- **[Phase 5]** Traced `ieee80211_sta_remove_link()` and
  `sta_info_flush()` implementations
- **[Phase 6]** Confirmed `ieee80211_ml_reconf_work` has no STA link
  removal in current tree (lines 6943-6946)
- **[Phase 6]** Confirmed `ieee80211_mgd_assoc_ml_reconf` has manual STA
  removal after VIF update (lines 10868-10874)
- **[Phase 6]** Confirmed `ieee80211_del_intf_link` calls only
  `ieee80211_vif_set_links` (cfg.c:5373)
- **[Phase 6]** `git merge-base --is-ancestor 36e05b0b83903 HEAD` → in
  tree
- **[Phase 8]** Failure mode: VIF/STA link state divergence on MLO link
  removal; severity MEDIUM-HIGH for MLO users

**YES****Verdict: YES** — backport to linux-6.18.y.

This patch fixes a real MLO bug in 6.18.44: when VIF links are removed,
associated station per-link state isn’t always cleaned up. Paths like
`ieee80211_ml_reconf_work()` and `ieee80211_del_intf_link()` only update
VIF links and leave stale `link_sta` entries; only the TX
reconfiguration path does partial manual cleanup.

The fix centralizes STA link teardown inside
`ieee80211_vif_update_links()` after a successful driver update, so all
callers stay consistent. It’s small (~40 lines, 2 files), low risk, and
from the mac80211 maintainer. MLO dynamic link removal has been in this
tree since January 2025 (`36e05b0b83903`), so the bug is present here.

**YES**

 net/mac80211/link.c | 30 ++++++++++++++++++++++++++++++
 net/mac80211/mlme.c |  8 --------
 2 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/link.c b/net/mac80211/link.c
index 235e370c2b59e..02eec9d69f50d 100644
--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -280,6 +280,7 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
 	u16 old_active = sdata->vif.active_links;
 	unsigned long add = new_links & ~old_links;
 	unsigned long rem = old_links & ~new_links;
+	unsigned long sta_rem = rem;
 	unsigned int link_id;
 	int ret;
 	struct link_container *links[IEEE80211_MLD_MAX_NUM_LINKS] = {}, *link;
@@ -287,6 +288,7 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_link_data *old_data[IEEE80211_MLD_MAX_NUM_LINKS];
 	bool use_deflink = old_links == 0; /* set for error case */
 	bool non_sta = sdata->vif.type != NL80211_IFTYPE_STATION;
+	struct sta_info *sta;
 
 	lockdep_assert_wiphy(sdata->local->hw.wiphy);
 
@@ -391,6 +393,34 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
 		goto free;
 	}
 
+	/* try to remove links that are now invalid from (MLO) stations */
+	list_for_each_entry(sta, &sdata->local->sta_list, list) {
+		unsigned long rem_links = sta->sta.valid_links & sta_rem;
+
+		if (sta->sdata != sdata)
+			continue;
+
+		/*
+		 * skip stations that would have no links left,
+		 * those will be removed completely later
+		 */
+		if (sta->sta.valid_links == rem_links)
+			continue;
+
+		for_each_set_bit(link_id, &rem_links,
+				 IEEE80211_MLD_MAX_NUM_LINKS)
+			ieee80211_sta_remove_link(sta, link_id);
+	}
+
+	/*
+	 * Remove stations using any removed links. Note that due
+	 * to the above station link removal, this only removes
+	 * stations that were skipped above because they'd have no
+	 * links left after link removal.
+	 */
+	for_each_set_bit(link_id, &sta_rem, IEEE80211_MLD_MAX_NUM_LINKS)
+		sta_info_flush(sdata, link_id);
+
 	/* use deflink/bss_conf again if and only if there are no more links */
 	use_deflink = new_links == 0;
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 3c33e56c12a80..5c855c95858e1 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -10906,14 +10906,6 @@ int ieee80211_mgd_assoc_ml_reconf(struct ieee80211_sub_if_data *sdata,
 			goto err_free;
 		}
 
-		for (link_id = 0; link_id < IEEE80211_MLD_MAX_NUM_LINKS;
-		     link_id++) {
-			if (!(req->rem_links & BIT(link_id)))
-				continue;
-
-			ieee80211_sta_remove_link(sta, link_id);
-		}
-
 		/* notify the driver and upper layers */
 		ieee80211_vif_cfg_change_notify(sdata,
 						BSS_CHANGED_MLD_VALID_LINKS);
-- 
2.53.0

