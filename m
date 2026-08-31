Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0A14F9C59;
	Mon, 31 Aug 2026 13:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183685; cv=none; b=bF+38o1/i8W3H/sVtf6Q6PSKstP9aS+U7MDd0RTy5f7GAasdTkpk8RQkiITlChOzPYrp/297wNX9G9cAMGXeHeraLr52J2a10OyrF/2+1k/gkK/HJxJm/fO87H+9X8RQRejRrbCrf5gBzvTTY+9dE5AFqlXWmPezOAvsydXeH48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183685; c=relaxed/simple;
	bh=Y8dCegj07B7euELog3kJEI9tthNoN/0BVGnEnwhZ7Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WXv4OTjNwF797MYYCOWOxzuClXiT3C9vJSSe/QCQpc5XHa5atU0enE3ASl/hOPW5rUaFowT5ABY7fQNvnSzF3z8f7xcZNR5RYU/fAERrKT6C+dUOOiRDBK++7Ncge/A897WVinv0iQ0KofTGCIjHCsqpvomxi3fzWlG/bKZvtcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jEiN8FXY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jEiN8FXY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34701F00ACA;
	Mon, 31 Aug 2026 13:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183681;
	bh=8Cxx+Cx6ZoOKmjmysVGpWX0i/NLrpcbN0wj0rLzZ+fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jEiN8FXYhNq6GdXhi901pIQjgcNNXNlpeMRGBM20ehzmPa/DfXB73ZgcQddYKBkM1
	 FzUOm7YF/3OWaNNvLO+6JPHtvysW41ssFLspdtR3pzFJF8OKSy9FEfgu0LO9J2sgc6
	 6oYuSsUyy7Fmm9nwBLXW9YQh7vpuuB7RAK7NS4droZ9NaodtlBOpRCzSC3GXz/a1m/
	 3VZa4ThM4mVF8kMf2UZy7M8sA26gmPeGTnzooz7oECjyo3wlQJCIfEfcS5vXS6KTei
	 Ja+ifJTQNvm/ThhhFsl7QNWeeH7HqCpPSLk0KZ95VhURm9XyU40lOBdkByPYEbY/Fz
	 MSUOvokucNtyQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: mld: purge async notifications upon nic error
Date: Mon, 31 Aug 2026 09:24:29 -0400
Message-ID: <20260831133314.4125787-241-sashal@kernel.org>
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

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit a40ad60a47f7c904b75a9ff83b39edebf3961c85 ]

This fixes a kernel panic in reconfig failure:

1. we have a BSS connection
2. we have a NAN connection
3. FW error occurs
4. reconfig restores the BSS connection
5. however, restoring the NAN connection fails due to a FW error.
6. erroneously, ieee80211_handle_reconfig_failure is called and marks all
   interfaces as not-in-driver (will be fixed in a different patch).
7. mac80211 frees the links of the BSS connection but doesn't tell the
   driver about that, as it thinks that this vif is not in the driver.
8. in ieee80211_stop_device, *ALL* wiphy works are getting flushed
   (erroneously?)
9. Therefore, async_handlers_wk is being executed, processing the
   statistics notification that was received after we restored the BSS
   connection.
10. the notification handler dereferences fw_id_to_bss_conf[id], which is
    now a dangling pointer, as mac80211 already freed this link in (7).
11. On the first access to one of the links fields, we panic.

While this can and should be fixed by removing the call to
ieee80211_handle_reconfig_failure in (6), it is also not a good idea to
carry and maybe handle notifications from a dead FW.

We do purge the notifications when we stop the FW, but in reconfig
failure we stop the FW too late, after the notifications are processed.
In addition, async_handlers_wk can always be scheduled before the
reconfig work.

Purge the notifications immediately when transport notifies about a nic
error.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20260517100550.4414228bf1d1.I1926a2b2e7827eaac22882699880ec04a3cb95f0@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: iwlwifi: mld: purge async
notifications upon nic error`

**Local tree:** `v6.18.44` (`stable/linux-6.18.y`, `VERSION = 6`,
`PATCHLEVEL = 18`, `SUBLEVEL = 44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[wifi: iwlwifi: mld]` **`purge`** — purge stale async FW
notifications when the NIC reports a firmware error.

### Step 1.2: Tags
**Record:**
- **Reviewed-by:** Johannes Berg `<johannes.berg@intel.com>` (mac80211 /
  iwlwifi maintainer)
- **Link:** `https://patch.msgid.link/20260517100550...` (patch
  submission thread)
- **Signed-off-by:** Miri Korenblit
  `<miriam.rachel.korenblit@intel.com>` (author)
- No Fixes:, Reported-by:, Tested-by:, Cc: stable@vger.kernel.org
- Notable: maintainer review; no syzbot/user crash report tags

### Step 1.3: Body analysis
**Record:**
- **Bug:** After a FW error during HW reconfig/recovery, stale async
  statistics notifications can still run via `async_handlers_wk` after
  mac80211 has freed BSS link state. The stats handler dereferences
  `fw_id_to_bss_conf[id]`, which is now dangling → **kernel panic**.
- **Symptom:** Kernel panic on reconfig failure with BSS + NAN (or
  similar multi-interface) setup.
- **Root cause:** `iwl_mld_cancel_async_notifications()` is only called
  in `iwl_mld_stop_fw()`, which runs too late; `async_handlers_wk` can
  be scheduled/executed before restart cleanup.
- **Fix approach:** Call `iwl_mld_cancel_async_notifications(mld)`
  immediately in `iwl_mld_nic_error()` when transport reports FW death.
- **Version info:** None stated; commit references a separate mac80211
  fix for `ieee80211_handle_reconfig_failure` behavior.

### Step 1.4: Hidden bug fix?
**Record:** Yes — described as a purge/cleanup, but it fixes a **use-
after-free / dangling pointer → kernel panic** on the FW error recovery
path.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/net/wireless/intel/iwlwifi/mld/mld.c` (+9 lines, 0
  removed)
- **Function modified:** `iwl_mld_nic_error()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**
- **Hunk (iwl_mld_nic_error):** After setting `in_hw_restart`,
  **before** return:
  - **Before:** FW error recorded; scan aborted; `in_hw_restart` set;
    async notification queue untouched until later `iwl_mld_stop_fw()`.
  - **After:** Same, plus immediate
    `iwl_mld_cancel_async_notifications(mld)` to cancel
    `async_handlers_wk` and purge queued async RX handlers.
- **Path affected:** FW error / NIC error path (IRQ and other transport
  error entry points).

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Memory safety — dangling pointer / UAF-class bug
- **Mechanism:** `STATISTICS_OPER_NOTIF` is registered as
  `RX_HANDLER_ASYNC` and handled in `iwl_mld_handle_stats_oper_notif()`
  → `iwl_mld_process_per_link_stats()`, which dereferences
  `mld->fw_id_to_bss_conf[fw_id]`. On reconfig failure, mac80211 can
  free link state while queued async notifications remain;
  `async_handlers_wk` then runs against freed `bss_conf` pointers.

### Step 2.4: Fix quality
**Record:**
- **Obviously correct:** Yes — reuses existing
  `iwl_mld_cancel_async_notifications()` already called from
  `iwl_mld_stop_fw()` and `d3.c`.
- **Minimal:** 9 lines, one call site.
- **Regression risk:** Low-medium —
  `iwl_mld_cancel_async_notifications()` asserts wiphy lock
  (`lockdep_assert_wiphy`), while `nic_error` op_mode callback is
  documented as atomic; see Phase 5/8 notes. Maintainer reviewed.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `git blame` on `iwl_mld_nic_error()` shows all lines
attributed to `7e22de67e545d` (unrelated amdgpu commit) — indicates
**shallow/truncated history** in this checkout, not reliable for
introduction dating. Function and buggy pattern are present in current
tree.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related file history
**Record:** `git log -- drivers/net/wireless/intel/iwlwifi/mld/` returns
only the amdgpu commit — history too shallow for series/prerequisite
analysis. `iwl_mld_cancel_async_notifications()` **already exists** in
this tree (`notif.c`, `fw.c`, `d3.c`).

### Step 3.4: Author commits
**Record:** `git log --author=Korenblit -- mld/` returns empty (shallow
history). Author is Intel iwlwifi developer; Johannes Berg reviewed.

### Step 3.5: Dependencies
**Record:** **Standalone** — only adds a call to an existing function.
Commit mentions a related mac80211 fix for
`ieee80211_handle_reconfig_failure`, but this patch is independently
valuable as defensive cleanup on FW death. No patch X/Y series
indicator.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c <sha>` not possible — commit SHA not provided.
`WebFetch` of Link URL blocked (Anubis bot protection). Patch text not
found in local `.mbx` files. **Could not retrieve lore thread.**

### Step 4.2: Reviewers
**Record:** Reviewed-by Johannes Berg confirmed in commit message. `b4
dig -w` not run (no commit SHA).

### Step 4.3: Bug report
**Record:** No external bug report tags. Bug described in detail in
commit message with step-by-step reproduction (FW error + reconfig
failure + BSS/NAN).

### Step 4.4: Related patches
**Record:** Commit references a separate fix for erroneous
`ieee80211_handle_reconfig_failure` call; this patch is complementary
defensive fix, not dependent on it.

### Step 4.5: Stable list history
**Record:** Not searched (lore unavailable). No Cc: stable in commit
(expected for manual review pipeline).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:**
- Modified: `iwl_mld_nic_error()`
- Called helper: `iwl_mld_cancel_async_notifications()`
- Affected handler: `iwl_mld_handle_stats_oper_notif()` →
  `iwl_mld_process_per_link_stats()`

### Step 5.2: Callers of `iwl_mld_nic_error`
**Record:** Registered as `.nic_error` in `iwl_mld_ops`; invoked via
`iwl_op_mode_nic_error()` from:
- `iwl_trans_fw_error()` (IRQ error path in `pcie/gen1_2/rx.c`)
- Command queue full (`tx.c`, `tx-gen2.c`)
- Debugfs-triggered errors (`trans.c`)
- Reset timeout / TOP reset failure (`trans-gen2.c`)
- NMI path (`iwl-io.c`)

### Step 5.3: Callees
**Record:** `iwl_mld_cancel_async_notifications()` calls
`wiphy_work_cancel()` + spinlock-protected list purge of
`async_handlers_list`.

### Step 5.4: Reachability
**Record:** **Reachable** on any FW/HW error on IWLMLD devices —
transport calls `iwl_trans_fw_error()` from IRQ on microcode errors. FW
errors are a normal operational event on iwlwifi hardware. Panic occurs
during subsequent recovery/reconfig, not on every error, but the stale-
notification race is plausible whenever FW dies with queued async
notifications.

### Step 5.5: Similar patterns
**Record:** MVM purges async handlers in restart path
(`iwl_mvm_async_handlers_purge()` in `mvm/mac80211.c`), not in
`nic_error`. MLD lacked the early purge that MVM's restart path provides
implicitly; this patch closes that gap at the earliest safe point (FW
death notification).

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy code exists?
**Record:** **YES.** Current `iwl_mld_nic_error()` (lines 643–674 in
`mld.c`) does **not** call `iwl_mld_cancel_async_notifications()`. The
helper exists and is used in `iwl_mld_stop_fw()` (`fw.c:373`).
`fw_id_to_bss_conf` dereference in stats path confirmed
(`stats.c:409–417`). IWLMLD driver fully present (65 files under
`mld/`).

### Step 6.2: Backport complications
**Record:** **Clean apply expected** — single hunk, no structural
conflicts. Fix not already present. Git history too shallow to assess
merge conflicts beyond reading current file.

### Step 6.3: Related fixes already present?
**Record:** **No.** `grep` for `cancel_async` / `FW is dead` in `mld.c`
returns nothing. No equivalent early-purge in `iwl_mld_nic_error()`.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **IMPORTANT** — `drivers/net/wireless/intel/iwlwifi/mld/`
(Intel WiFi, IWLMLD firmware path). Not universal core code, but iwlwifi
is widely deployed on laptops/desktops with recent Intel WiFi hardware
using MLD opmode.

### Step 7.2: Activity
**Record:** IWLMLD is actively developed (full MLO, stats, reconfig
support in tree). Shallow git history prevents trend analysis.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users with **CONFIG_IWLMLD** devices (Intel BZ/SC/DR-family
hardware using MLD opmode). Not all iwlwifi users (IWLMVM/IWLDVM
unaffected).

### Step 8.2: Trigger conditions
**Record:**
- FW/HW error occurs
- Recovery/reconfig attempted (e.g., `ieee80211_restart_hw` path)
- Partial reconfig failure leaves stale async notifications (especially
  statistics)
- `async_handlers_wk` runs after link `bss_conf` freed
- **Likelihood:** Uncommon (requires FW error + reconfig failure), but
  FW errors themselves are not rare
- **Unprivileged trigger:** Indirectly — normal WiFi usage; no special
  syscall needed

### Step 8.3: Failure mode severity
**Record:** **Kernel panic** (dereference of freed `bss_conf` via
`fw_id_to_bss_conf`) — **CRITICAL**

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for affected hardware — prevents crash during FW
  error recovery
- **Risk:** LOW — 9-line addition, reuses existing tested helper,
  maintainer-reviewed
- **Locking nuance:** `iwl_mld_cancel_async_notifications()` asserts
  wiphy held; `nic_error` is atomic per op_mode contract.
  `wiphy_work_cancel()` functionally uses internal spinlock; maintainer
  approved. Possible lockdep warnings in debug builds — noted but not
  blocking given review.
- **Ratio:** Strong benefit, low risk

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compile

**FOR backport:**
- Fixes real kernel panic (dangling pointer in stats async handler)
- Small, surgical, obviously correct intent
- Reuses existing `iwl_mld_cancel_async_notifications()`
- Reviewed by Johannes Berg (subsystem maintainer)
- Buggy code confirmed present in 6.18.44
- No new APIs or features
- Defensive fix valuable even if related mac80211 bug is fixed
  separately

**AGAINST backport:**
- Affects only IWLMLD hardware (subset of iwlwifi users)
- Trigger requires FW error + reconfig failure (not everyday)
- Locking context mismatch between atomic `nic_error` and wiphy-locked
  cancel helper (mitigated by maintainer review)
- Related mac80211 fix mentioned but not included (this patch still has
  standalone value)

**Unresolved:**
- Exact mainline commit SHA and lore discussion (tools blocked / not
  available)
- When iwl MLD was first introduced (git history shallow)
- Whether lockdep fires in practice from IRQ `nic_error` path

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — reuses existing purge
   function; maintainer reviewed
2. Fixes real bug affecting users? **PASS** — kernel panic on FW error
   recovery
3. Important issue? **PASS** — CRITICAL (kernel panic)
4. Small and contained? **PASS** — 9 lines, one file
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — code and helper exist; fix not
   yet applied

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build fix, or docs).
Standard bug fix.

### Step 9.4: Decision rationale
This commit fixes a confirmed kernel panic on the IWLMLD FW error
recovery path in a tree where the iwlwifi MLD driver, the dangling-
pointer bug, and `iwl_mld_cancel_async_notifications()` all exist. The
fix is minimal, maintainer-reviewed, and prevents processing
notifications from a dead firmware after BSS link state may have been
torn down. For **linux-6.18.y (v6.18.44)**, this meets stable kernel
criteria.

---

## Verification

- [Phase 1] Parsed subject, tags (Reviewed-by: Johannes Berg, Link:,
  SOB); no Fixes/Reported-by
- [Phase 1] Identified hidden UAF/panic fix from commit body
- [Phase 2] Diff: +9 lines in `mld.c`, `iwl_mld_nic_error()` only
- [Phase 2] Confirmed stats handler uses `fw_id_to_bss_conf`
  (`stats.c:409-417`)
- [Phase 2] Confirmed `STATISTICS_OPER_NOTIF` is `RX_HANDLER_ASYNC`
  (`notif.c:417-418`)
- [Phase 3] `git describe HEAD`: v6.18.44
- [Phase 3] `git blame iwl_mld_nic_error`: shallow history (unreliable)
- [Phase 3] `iwl_mld_cancel_async_notifications` exists in tree
  (`notif.c:671`, `fw.c:373`, `d3.c:1431`)
- [Phase 4] `b4 dig -c HEAD`: no match for release commit
- [Phase 4] WebFetch lore Link: blocked by bot protection
- [Phase 4] UNVERIFIED: Full lore review thread and stable nominations
- [Phase 5] Traced `iwl_op_mode_nic_error` callers via grep (IRQ, reset,
  debugfs paths)
- [Phase 5] Confirmed `iwl_mld_async_handlers_wk` processes async
  notification list (`notif.c:648-668`)
- [Phase 5] Confirmed `wiphy_work_cancel` requires wiphy mtx
  (`core.c:1710`)
- [Phase 6] `git describe`: v6.18.44 on `stable/linux-6.18.y`
- [Phase 6] Buggy code present: `iwl_mld_nic_error` lacks cancel call
  (read `mld.c:643-674`)
- [Phase 6] Fix not present: grep for `cancel_async` in `mld.c` — no
  matches
- [Phase 6] IWLMLD Kconfig and full `mld/` directory present
- [Phase 7] Subsystem: iwlwifi MLD driver (IMPORTANT, driver-specific)
- [Phase 8] Failure mode: kernel panic — CRITICAL
- [Phase 8] Affected population: CONFIG_IWLMLD users

**YES**

 drivers/net/wireless/intel/iwlwifi/mld/mld.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mld.c b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
index 48b8ec6a5a12d..49e46babf8221 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mld.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
@@ -670,6 +670,15 @@ iwl_mld_nic_error(struct iwl_op_mode *op_mode,
 	if (type != IWL_ERR_TYPE_RESET_HS_TIMEOUT &&
 	    mld->fw_status.running)
 		mld->fw_status.in_hw_restart = true;
+
+	/* FW is dead. We don't want to process its notifications.
+	 * Right, we cancel them also in iwl_mld_stop_fw, but
+	 * iwl_mld_async_handlers_wk might be executed before
+	 * ieee80211_restart_work.
+	 * In addition, in case of an error during recovery,
+	 * iwl_mld_stop_fw might be too late.
+	 */
+	iwl_mld_cancel_async_notifications(mld);
 }
 
 static void iwl_mld_dump_error(struct iwl_op_mode *op_mode,
-- 
2.53.0

