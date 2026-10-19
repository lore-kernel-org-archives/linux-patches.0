Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BD863020F;
	Mon, 19 Oct 2026 14:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418730; cv=none; b=hekT6ndq7dBOI18bGDkbFgwfKSM4Jrwk/OsOB0hZXLOZQsJCezW95tOmygZMmLUs6tTH+qZ8q/iuIxnX+HruzG1drG/s9eE9SJWwbY4lncIft1qaFHdkg6jEwKAPsNXo/9MWunLq81KfZGrWOaRD6UhIy1bnUPZX6B2ykNUY5zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418730; c=relaxed/simple;
	bh=qvoG948+wlY6YhQE8UFJDGh3inRWIHWrZ1ygpY4gKuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cjxQ1F7Pq7r2Ngi01k0FWUr1xsuveSkv8qWj6bdsrSBQyupjgL+bWk187GQnaN7pRY6hMeb4zYvxT95NwmdV/d4TP+jT68+XtBhLR31j7v8d0qlHz7HLBWqnkVBEi5LyMU61ZitKqqRB94rRMJpuegyoIpZ6NV7Mzk/Fp24YcAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YWNFuYXy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YWNFuYXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168A21F000CB;
	Mon, 19 Oct 2026 14:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418726;
	bh=DJWgP9LAVP+WfTHuThDxm+9DemxUo7ypk1YTH37/tT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YWNFuYXyMz64LMhuCQ/6Rk3RLS/LQxbO2M+9pHq2dWeBNXRPiHSk8y6Q21st3TBO/
	 grsRI+EOFrQGPSWpk8tXTMh5n3SNNCbAzTaV245AXhoV+Ik/1Ig+4jk1iq2WfxLjPz
	 9ln7g08oUhNd0YOgQvEfUjRI1tB692RfOaeHKEw2J3UaueTM5uqS3Df5kR5mMtKiwZ
	 nJcbfv8lTy33Fz2gXlAvmirxu3XpgDJjHwlDz1fUeUuhHP5ieP8SCdDdUpN+bJ1ooS
	 eI2xLI5a/w1GJ7+y9Nw8ZhNyfgs0xcdyyFJtVbyriMspUB6gih3uin0A/7S3Xa2QZS
	 bERiG2EDLd0rw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ayala Beker <ayala.beker@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: mld: drop connection on D3 resume failure
Date: Mon, 19 Oct 2026 09:52:24 -0400
Message-ID: <20261019135441.1420968-453-sashal@kernel.org>
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

From: Ayala Beker <ayala.beker@intel.com>

[ Upstream commit 4f5384b58b483e4aec576ce461dec45b41df18db ]

When FW crashes on D3 exit, iwl_mld_nic_error() sets
STATUS_RESET_PENDING and queues restart wk, but mac80211's resume
callback synchronously calls iwl_trans_stop_device() which clears
the flag. As a result restart wk skips sw_reset, and the FW error
recovery buffer is never read.

The new FW boots with empty BA state and initial sequence numbers,
while the AP still holds its A-MPDU RX reorder window.
This causes MPDUs to be dropped as IWL_RX_MPDU_REORDER_BA_OLD_SN until
ADDBA is renegotiated.

We don't know how long the firmware has been in an error state
or whether the AP still considers us associated, so keeping the
connection alive is not worth it.
Call ieee80211_resume_disconnect() when iwl_mld_wait_d3_notif() fails,
and let userspace reassociate.

Signed-off-by: Ayala Beker <ayala.beker@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260717172958.3e10c8498f53.Icf5644b42d79e984ecc16abfa873bd37f611e778@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a real WoWLAN resume recovery bug in `iwlwifi` MLD: after a
firmware crash on D3 exit the driver keeps the association, so traffic
is dropped. The local tree is **7.3.0-rc4**
(`v7.3-rc4-27-gf0100363d8c37`); the MLD D3 path exists here, and the
three-line fix is self-contained.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[wifi: iwlwifi: mld:] [drop] [drop the association when
D3/WoWLAN resume fails to get firmware notifications]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Fixes:` — none (expected; not a negative signal)
- `Reported-by:` — none
- `Tested-by:` — none
- `Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>`
  (iwlwifi maintainer)
- `Acked-by:` — none
- `Link: https://patch.msgid.link/20260717172958.3e10c8498f53.Icf5644b42
  d79e984ecc16abfa873bd37f611e778@changeid`
- `Cc: stable@vger.kernel.org` — none (expected)
- `Signed-off-by: Ayala Beker <ayala.beker@intel.com>` (author)
- `Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>`
  (iwlwifi-next maintainer)
- No syzbot / kernel test robot tags

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** Firmware crash on D3 exit. `iwl_trans_fw_error()` →
  `iwl_trans_schedule_reset()` sets `STATUS_RESET_PENDING` and queues
  restart work. mac80211 resume then calls `iwl_trans_stop_device()`,
  which clears that flag, so restart work skips SW reset and never reads
  the FW error recovery buffer.
- **Symptom:** New firmware boots with empty BA state / initial SNs
  while the AP still has its A-MPDU RX reorder window. RX MPDUs are
  dropped as `IWL_RX_MPDU_REORDER_BA_OLD_SN` until ADDBA is
  renegotiated. Association state with the AP is also unknown.
- **Version info:** none in the message. MLD D3 code has existed since
  the MLD driver was added (in this history: `d1e879ec600f9`, present by
  v6.15).
- **Root cause (author):** keep-alive after a failed D3 resume is not
  safe; disconnect and let userspace reassociate.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a hidden cleanup. Explicit recovery/correctness fix for a
broken post-resume connection.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/net/wireless/intel/iwlwifi/mld/d3.c` (+3 / −0)
- Function: `iwl_mld_wowlan_resume()`
- Scope: single-file surgical fix (3 lines on the existing error path)

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record: Before, `iwl_mld_wait_d3_notif()` failure logged `"Couldn't get
the d3 notifs"` and `goto err`, which sets `in_hw_restart = true` and
returns `1`. mac80211 treats `1` as “full reconfig on wakeup” and
**keeps** the STA associated. After, if `bss_vif->cfg.assoc`, it also
calls `ieee80211_resume_disconnect(bss_vif)` so mac80211 tears the
connection down during resume reconfig. The same function already did
that on the success path when `keep_connection` is false.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: `[Logic / correctness]` — failed D3 resume left a zombie
association. Firmware BA state is reset; AP reorder window is not.
`ieee80211_resume_disconnect()` sets
`IEEE80211_SDATA_DISCONNECT_RESUME`, taints keys, and
`ieee80211_sta_restart()` later calls `ieee80211_sta_connection_lost()`.
This matches MVM: `__iwl_mvm_resume()` always runs
`iwl_mvm_d3_disconnect_iter` unless `keep` is true (and `keep` stays
false on error).

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct and minimal. `ieee80211_resume_disconnect()`
is documented for the resume callback; `iwl_mld_wowlan_resume()` is
called only from `iwl_mld_resume()`. Must be used here rather than
`ieee80211_hw_restart_disconnect()`, which WARNs unless
`local->in_reconfig`. Guarded by `bss_vif->cfg.assoc`. Regression risk
is low: extra disconnect only when D3 notifs already failed, which is
already treated as a restart-needed error.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: The `iwl_mld_wait_d3_notif()` error path comes from
`d1e879ec600f9` (“wifi: iwlwifi: add iwlmld sub-driver”, 2025-03-05).
Present in this tree; `git merge-base --is-ancestor d1e879ec600f9 v6.15`
succeeds. The bug is old relative to 7.3, not brand-new code.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Buggy behavior is the original MLD wowlan-
resume error path, not a later regression.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Recent `mld/d3.c` work is other WoWLAN validation (`validate
D3_END notif size`, `validate WoWLAN notif header`, wake-packet checks).
`ieee80211_resume_disconnect` on the *success* path was added in
`99f201a9a7d59` (keep_connection). No prerequisite refactor is required
for these three lines. No later commits on this file after
`4f5384b58b483`.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Ayala Beker is a regular Intel iwlwifi contributor (MVM and
MLD). Reviewed by Emmanuel Grumbach; applied by Miri Korenblit. Strong
maintainer signal.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Submitted as **patch 4/8** of `iwlwifi-next` updates
(2026-07-17). Cover letter: “A couple of fixes, features and cleanups.”
Other patches (wake-packet validation, scan-abort init, MVM sync frames,
SAR define move, MCC v2, debug log, BIOS code move) do not change this
error path. Standalone: uses existing `ieee80211_resume_disconnect()`
and `bss_vif->cfg.assoc`.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record: `b4 dig -c 4f5384b58b483` → https://patch.msgid.link/20260717172
958.3e10c8498f53.Icf5644b42d79e984ecc16abfa873bd37f611e778@changeid
`b4 dig -a`: single v1 series, no v2/v3.
Mbox (`b4 dig -m`): 9 messages, cover + 8 patches, **no replies, NAKs,
or reviewer concerns**. `Reviewed-by: Emmanuel Grumbach` was already on
the submission. No `Cc: stable` in-thread.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: `b4 dig -w` recipients: Johannes Berg
(`johannes@sipsolutions.net`), `linux-wireless@vger.kernel.org`, Ayala
Beker, Emmanuel Grumbach, Miri Korenblit. Right maintainers/list.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No `Reported-by` / bugzilla / syzbot. Bug is described from
driver/firmware analysis, not a public user report.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Mixed iwlwifi-next dump; this hunk does not depend on 1–3 or
5–8.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org HTTP 403 from this environment. No stable-list
discussion verified. `b4` thread does not mention stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `iwl_mld_wowlan_resume()`; calls
`ieee80211_resume_disconnect()`.

**Step 5.2: TRACE CALLERS**
Record:
- `iwl_mld_wowlan_resume()` ← `iwl_mld_resume()` in `mld/mac80211.c`
  (mac80211 `.resume`)
- `iwl_mld_resume()` ← `drv_resume()` in `ieee80211_reconfig()` when
  `local->wowlan`
- `iwl_mld_wait_d3_notif()` also used by `iwl_mld_no_wowlan_resume()`;
  this patch does **not** change that path (no-wowlan resume is handled
  in `iwl_mld_mac80211_start()`; mac80211 already cleaned state)

**Step 5.3: TRACE CALLEES**
Record: `ieee80211_resume_disconnect()` →
`ieee80211_reconfig_disconnect(..., IEEE80211_SDATA_DISCONNECT_RESUME)`
→ set sdata flag + `KEY_FLAG_TAINTED`. Later `ieee80211_sta_restart()` →
`ieee80211_sta_connection_lost()`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace/system suspend with WoWLAN → resume →
`ieee80211_reconfig()` → `iwl_mld_resume()`. If wait for D3 notifs
fails, return 1 still triggers full reconfig **and** (with this patch)
disconnect. Reachable on laptops with Intel MLD (Wi-Fi 7) firmware and
WoWLAN. Unprivileged users do not trigger it directly; any user who
suspends the machine can.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: MVM already disconnects on D3 resume unless `keep` is true
(`iwl_mvm_d3_disconnect_iter`). Same `ieee80211_resume_disconnect()`
already used in this function when wowlan status says not to keep the
connection. MLD also has `iwl_mld_restart_disconnect_iter` for invalid
recovery blobs during `iwl_mld_send_recovery_cmd()` — a different path,
and it does not cover “recovery buffer never read.”

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. Tree is **7.3.0-rc4**.
`drivers/net/wireless/intel/iwlwifi/mld/d3.c` and
`iwl_mld_wowlan_resume()` exist (`CONFIG_IWLMLD`). Error path introduced
with MLD (`d1e879ec600f9`, in v6.15+). `ieee80211_vif.cfg.assoc` exists
in this tree.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply on this tree. Context around the wait-d3-notif error
path matches the hunk. No conflicting local changes.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No other commit greps as an alternate fix for “D3 resume
failure” disconnect in MLD. MVM already had the equivalent behavior;
this fills the MLD gap.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `[drivers/net/wireless/intel/iwlwifi/mld]` `[IMPORTANT]` — not
core mm/VFS, but Intel Wi-Fi 7 (MLD) on laptops; WoWLAN resume is a
common path.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively developed (frequent mld/d3.c changes). Bug is in
original wowlan-resume error handling, not a one-off new feature.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver/config-specific: `CONFIG_IWLMLD` + `CONFIG_PM_SLEEP`,
Intel MLD firmware, WoWLAN enabled. Typical: recent Intel Wi-Fi 7
laptops.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Not every resume. Trigger is D3-exit firmware failure
(crash/timeout so D3 notifs never arrive). Timing-dependent around
firmware error vs resume `stop_device`. Not a syscall smash; any
suspend/resume with WoWLAN can hit it if FW dies on the way out of D3.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Not a panic. User-visible **broken Wi-Fi after sleep**:
interface still associated, MPDUs dropped as old SN, possible stale
association if the AP already dropped the client. Severity **HIGH**
(serious connectivity failure on a common laptop path), not CRITICAL (no
oops/deadlock/corruption).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record: Benefit high for affected users (restores a clean reassociate
instead of a zombie session). Risk very low (3 lines, existing API,
error path only, same pattern as MVM and the local success path). Ratio
strongly favors applying it.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real post-resume connectivity bug (dropped MPDUs / unknown
  association), not style
- Matches MVM’s long-standing “disconnect unless keep” D3 resume
  behavior
- 3-line, obviously correct use of `ieee80211_resume_disconnect()` from
  the resume callback
- Reviewed by Emmanuel Grumbach; applied by Miri Korenblit; To: Johannes
  Berg
- Buggy path present in this 7.3 tree since MLD introduction
- Standalone; series-mates are unrelated
- Tiny error-path change; disconnect is conservative when firmware state
  is untrustworthy

AGAINST:
- No crash, UAF, or CVE; not every resume
- No user `Reported-by` / syzbot
- Mixed “fixes, features and cleanups” series (this patch itself is a
  fix)
- Lore HTTP 403; no independent stable-list confirmation

UNRESOLVED:
- Could not read lore/stable HTML (403). Thread contents were recovered
  via `b4 dig -m`.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — uses the documented resume-
   disconnect API; maintainer Reviewed-by
2. Fixes a real bug that affects users? **PASS** — WoWLAN resume leaves
   a dead/stale association
3. Important issue? **PASS** — serious connectivity loss after suspend,
   not a panic but user-visible and persistent until reassoc/ADDBA
4. Small and contained? **PASS** — 3 lines, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — MLD D3 resume code is here;
   context matches

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None (not a device ID/quirk/DT/build/docs exception). Qualifies
as a normal bugfix.

**Step 9.4: MAKE YOUR DECISION**
The local 7.3 tree has the MLD wowlan-resume error path. Without this
change, a firmware crash on D3 exit keeps the mac80211 association
through reconfig while BA state is reset, so traffic dies until ADDBA.
Disconnect-on-failure is the same policy MVM already uses and is a
three-line, low-risk fix.

Verification:
- [Phase 1] Parsed tags: Reviewed-by Emmanuel Grumbach; Link msgid; no
  Fixes/Reported-by/Cc-stable
- [Phase 1] Body: FW D3-exit crash → reset flag cleared by
  `iwl_trans_stop_device()` → empty BA vs AP reorder window → OLD_SN
  drops
- [Phase 2] Diff: +3 lines in `iwl_mld_wowlan_resume()` after
  `iwl_mld_wait_d3_notif()` failure
- [Phase 2] Confirmed `goto err` already sets `in_hw_restart` and
  returns 1; mac80211 `drv_resume()` res==1 does full reconfig and keeps
  association
- [Phase 2] Confirmed success path already calls
  `ieee80211_resume_disconnect()` when `keep_connection` is false
  (`99f201a9a7d59`)
- [Phase 2] Confirmed MVM `__iwl_mvm_resume()` disconnects all STATION
  vifs unless `keep` (false on error)
- [Phase 3] `git describe HEAD` / `make kernelversion`: v7.3-rc4 /
  7.3.0-rc4
- [Phase 3] `git blame`: error path from `d1e879ec600f9` (MLD intro);
  `git merge-base --is-ancestor d1e879ec600f9 v6.15` true
- [Phase 3] `git merge-base --is-ancestor 4f5384b58b483 v7.2` false
  (landed in 7.3 cycle)
- [Phase 3] No Fixes tag; no later d3.c commits after this one
- [Phase 3] Series 4/8 of mixed iwlwifi-next; parent is unrelated MVM
  patch; standalone
- [Phase 3] `iwl_trans_fw_error()` → `iwl_trans_schedule_reset()` sets
  `STATUS_RESET_PENDING`; `iwl_trans_stop_device()` clears it — matches
  the described mechanism (nic_error itself sets `in_hw_restart`, not
  the bit)
- [Phase 4] `b4 dig -c`: lore msgid match; `b4 dig -a`: v1 only; `b4 dig
  -w`: Johannes + linux-wireless + Intel iwlwifi maintainers
- [Phase 4] mbox: 9 messages, no replies/NAKs; cover lists this as a fix
  among mixed patches
- [Phase 4] lore.kernel.org WebFetch/curl 403 — UNVERIFIED via HTML;
  thread recovered with b4
- [Phase 5] Callers: `iwl_mld_resume` ← mac80211 wowlan resume;
  `ieee80211_sta_restart` honors `IEEE80211_SDATA_DISCONNECT_RESUME`
- [Phase 5] `agg.c` drops frames when `IWL_RX_MPDU_REORDER_BA_OLD_SN` is
  set
- [Phase 6] File and `iwl_mld_wait_d3_notif` error path present;
  `bss_vif->cfg.assoc` valid in this tree
- [Phase 7] iwlwifi MLD, important for Intel Wi-Fi 7 laptops
- [Phase 8] Failure: zombie association / packet drops after suspend,
  severity HIGH; fix risk very low
- UNVERIFIED: public stable@ discussion (lore HTTP 403)

The patch is a small, maintainer-reviewed recovery fix for a real WoWLAN
resume failure on hardware this tree already supports.

**YES**

 drivers/net/wireless/intel/iwlwifi/mld/d3.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/d3.c b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
index b75936125b46d..69d8afda9fcd9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
@@ -2077,6 +2077,9 @@ int iwl_mld_wowlan_resume(struct iwl_mld *mld)
 	ret = iwl_mld_wait_d3_notif(mld, &resume_data, true);
 	if (ret) {
 		IWL_ERR(mld, "Couldn't get the d3 notifs %d\n", ret);
+
+		if (bss_vif->cfg.assoc)
+			ieee80211_resume_disconnect(bss_vif);
 		goto err;
 	}
 
-- 
2.53.0

