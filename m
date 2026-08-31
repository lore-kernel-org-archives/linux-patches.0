Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F45F5AB254;
	Mon, 31 Aug 2026 13:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184365; cv=none; b=uCv0Ut9y9eN6kYQEpHI4aZ+c8YCdLX7nbdz9UdDXsV0wTp7LufKOcxE2vZz2E1ijyQQeEJWlocs0imkxnSemnFH2wc1ZKdzHX1T9JLTMDHDufA5Ivu+uJltSNYuSdCUcS6LLWg9Q6mP1+cxgJ7kzlg2bjMP0KQpSBpJyntgYd10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184365; c=relaxed/simple;
	bh=FUvGGQSrqapgwzOF5Lvn3299DaF6QeiaUfYOEyQoo5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LccCqcagDM5iKibyYrTI+LBjwxKLzSyToTDSOqyVAOQrXBqfu8CldeImWTY1Rqi22xvj7WXsb/6rnsT/7U9BnATq4/oIRqnWDpuj4VUH6AyxBQATr7ltrgkpwxuZzU7v6raHbGDa4KXcDqQcOmeYMyt8pWNEPQaXZHbzwAJ5fQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IY4/DTA4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IY4/DTA4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492CB1F00A3D;
	Mon, 31 Aug 2026 13:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184363;
	bh=ORZNPa7Z3pgPA0ZDMhqg+Le/qDl+ftpftynmGICbH6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IY4/DTA482OOzkC/9rPSXD4m/eJQ2sHYIbYHHSZoABRRssTnSSH5nZL0JKtmqXgVF
	 LounbNgWumaWK2O6DhhLHpu+6/wCyXzRxA3QgWgETSox+1p6HLXPo8uPzGPeyXkjvX
	 QDKCEqROQpV6pChClOJwG6cKt2TR09ixYtH9q/OnY24EZuq7cqs/dYN1ZFRn+FPYXB
	 g23bYKkV+T+Yw9FVSr1uiWPD+eZyoLqHKda5XO+xS8L996eA8eYlPwci2wgKMbN/JT
	 Bof4wnLHV3vc5uZh0p0OVVuHrzDxPITVmGT+ziRi0HR36ZR3sU/+334anZLZ51LWel
	 BKD26O738i3BQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Avinash Bhatt <avinash.bhatt@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: mld: keep healthy link on EMLSR missed beacon exit
Date: Mon, 31 Aug 2026 09:31:17 -0400
Message-ID: <20260831133314.4125787-649-sashal@kernel.org>
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

From: Avinash Bhatt <avinash.bhatt@intel.com>

[ Upstream commit 4b6d725ff01cb92becda6e805143e331fdf1d73e ]

When EMLSR exits due to beacon loss on the current link, the driver
should keep the link that is still receiving beacons. The previous
code always called get_primary_link(), keeping the primary link
regardless of which link is actually losing beacons. If the primary
link is the one losing beacons, the driver exits EMLSR onto the
degraded link and the connection is lost eventually.

When both links lose beacons, keep the primary link. When only the
current link loses beacons -- whether due to signal loss or a BSS
parameter change -- keep the other link.

Signed-off-by: Avinash Bhatt <avinash.bhatt@intel.com>
Link: https://patch.msgid.link/20260517100550.b2d700f7775e.I8e9189ce6cf4388878beab14e56341becd5f427c@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: iwlwifi: mld: keep healthy link on
EMLSR missed beacon exit`

**Local tree:** Linux **6.18.44** (`v6.18.44`, `VERSION=6 PATCHLEVEL=18
SUBLEVEL=44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[wifi: iwlwifi: mld]` `[keep]` — When exiting EMLSR due to
missed beacons, keep the healthy link instead of always keeping the
primary link.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Avinash Bhatt `<avinash.bhatt@intel.com>` (author)
- **Link:** `https://patch.msgid.link/20260517100550.b2d700f7775e...`
  (patch submission reference)
- **Signed-off-by:** Miri Korenblit
  `<miriam.rachel.korenblit@intel.com>` (Intel iwlwifi maintainer)
- **No** Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, Cc:
  stable@vger.kernel.org

Notable: Intel maintainer sign-off; no syzbot or user bug reports in the
message.

### Step 1.3: Body analysis
**Record:**
- **Bug:** On EMLSR missed-beacon exit, driver always called
  `iwl_mld_get_primary_link()`, even when the primary link was the one
  losing beacons.
- **Symptom:** Driver exits EMLSR onto the degraded link → connection is
  eventually lost.
- **Intended behavior:** Both links lose beacons → keep primary; only
  current link loses beacons → keep the other (healthy) link.
- **Root cause:** Wrong link-selection logic in
  `iwl_mld_handle_missed_beacon_notif()`.

### Step 1.4: Hidden bug fix?
**Record:** Not disguised — this is an explicit connectivity bug fix,
though the subject uses "keep" rather than "fix".

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/net/wireless/intel/iwlwifi/mld/link.c` (+11 / -6
  lines)
- **Function:** `iwl_mld_handle_missed_beacon_notif()`
- **Scope:** Single-file, surgical change in one EMLSR exit path

### Step 2.2: Code flow change
**Record:**

| Hunk | Before | After |
|------|--------|-------|
| EMLSR exit condition | Single `if` with three OR'd conditions; all
paths exit with `iwl_mld_get_primary_link(vif)` | Split into two
branches: (1) both links fail → primary; (2) only current link fails →
`iwl_mld_get_other_link(vif, link_id)` |
| Comments | Threshold description only | Adds explicit link-selection
policy comments |

**Affected path:** Firmware missed-beacon notification handler during
active EMLSR (multi-link WiFi).

### Step 2.3: Bug mechanism
**Record:** **Category:** Logic / correctness fix (wrong link retained
on EMLSR exit).

When the notification's `link_id` is the sick link and only that link
exceeds the beacon-loss threshold, the driver must exit EMLSR while
keeping the *other* link. The old code always kept the primary, which is
wrong when the primary is the degraded link.

### Step 2.4: Fix quality
**Record:**
- **Obviously correct:** Yes — mirrors existing patterns in the same
  driver (see Phase 5).
- **Minimal:** Yes — restructures one conditional, no API changes.
- **Regression risk:** Very low — `iwl_mld_get_other_link()` already
  exists and is used elsewhere; `iwl_mld_exit_emlsr()` already validates
  `link_to_keep` against `vif->active_links`.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `git blame -L 604,612` on `link.c` attributes all buggy
lines to the tree base in this shallow checkout (`^7e22de67e545d`). Repo
is shallow (500 commits); full introduction commit cannot be determined
here. Buggy code is present in 6.18.44.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: File history
**Record:** `git log --oneline -30 --
drivers/net/wireless/intel/iwlwifi/mld/link.c` returns only the shallow-
root commit due to shallow clone. Related iwlwifi mld fixes are being
backported to 6.18 (e.g., ratatoskr references `[PATCH 6.18 313/377]
wifi: iwlwifi: mld: dont dereference a pointer before NULL checking
it`). **Standalone fix** — patch 05/15 in iwlwifi-fixes series, no
series dependency for this hunk.

### Step 3.4: Author context
**Record:** Avinash Bhatt (Intel); Signed-off-by Miri Korenblit (Intel
iwlwifi maintainer). Part of `iwlwifi-fixes` updates series (v1 May 16,
v2 May 17, v3 May 19, 2026).

### Step 3.5: Dependencies
**Record:** **No dependencies.** `iwl_mld_get_other_link()` is defined
inline in `mlo.h` and already used in this tree (`stats.c`,
`mac80211.c`). Fix applies standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- `b4 dig -c 1bdfba6279e21` — no output (blob hash, not a commit;
  shallow tree).
- **Ratatoskr:** [PATCH iwlwifi-fixes
  05/15](https://ratatoskr.run/linux-wireless/2026/05/15794895) — Miri
  Korenblit, May 16, 2026.
- **Series revisions:** v1 (May 16), v2 (May 17), v3 (May 19).
- Patch content matches the analyzed diff exactly.
- lore.kernel.org direct fetch blocked (Anubis bot protection).

### Step 4.2: Reviewers
**Record:** `b4 dig -w` not run successfully (no valid commitish).
Series is from Intel iwlwifi maintainer on linux-wireless. No explicit
Reviewed-by in commit message.

### Step 4.3: Bug report
**Record:** No external bug report, syzbot, or user Reported-by. Bug
described via code-path analysis by Intel engineers.

### Step 4.4: Related patches
**Record:** Part of 15-patch iwlwifi-fixes series; this hunk is self-
contained. Related prior art in legacy `iwl_mvm` driver had similar
dual-link beacon-loss logic (spinics reference), showing this is a known
EMLSR concern.

### Step 4.5: Stable list history
**Record:** Not searched on lore stable list (fetch blocked). Ratatoskr
shows other iwlwifi mld patches already queued for 6.18 stable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `iwl_mld_handle_missed_beacon_notif()`,
`iwl_mld_exit_emlsr()`, `iwl_mld_get_primary_link()`,
`iwl_mld_get_other_link()`

### Step 5.2: Callers
**Record:** `iwl_mld_handle_missed_beacon_notif()` is called from
firmware notification handling (and KUnit tests). Triggered by firmware
beacon-loss events on associated MLO interfaces — runtime path for Intel
WiFi 7 MLO/EMLSR users.

### Step 5.3: Callees
**Record:** `iwl_mld_exit_emlsr()` → `_iwl_mld_exit_emlsr()` →
`ieee80211_set_active_links_async()` to deactivate the sick link and
keep `link_to_keep`.

### Step 5.4: Reachability
**Record:** Reachable when:
1. Interface is associated with 2+ active links (EMLSR),
2. Firmware sends missed-beacon notification,
3. Beacon-loss thresholds are exceeded.

Users with Intel iwlwifi MLO/EMLSR hardware on supported APs can hit
this during real-world signal degradation or BSS parameter changes.

### Step 5.5: Similar patterns
**Record:** Same driver already uses `iwl_mld_get_other_link()` for
EMLSR exit on the degraded link:

```396:399:drivers/net/wireless/intel/iwlwifi/mld/stats.c
        if (sig < exit_emlsr_thresh)
                iwl_mld_exit_emlsr(mld, vif,
IWL_MLD_EMLSR_EXIT_LOW_RSSI,
                                   iwl_mld_get_other_link(vif,
bss_conf->link_id));
```

```2225:2229:drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
        if (chsw->link_id == primary && chsw->block_tx)
                selected = iwl_mld_get_other_link(vif, primary);
        else
                selected = primary;
```

The missed-beacon path was inconsistent with these — confirming this is
a logic bug, not a new design choice.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy code exists?
**Record:** **YES.** Current tree at lines 604–612 still has the buggy
unified `if` always calling `iwl_mld_get_primary_link(vif)`:

```604:612:drivers/net/wireless/intel/iwlwifi/mld/link.c
        if ((missed_bcon >= IWL_MLD_BCN_LOSS_EXIT_ESR_THRESH_2_LINKS &&
             scnd_lnk_bcn_lost >=
IWL_MLD_BCN_LOSS_EXIT_ESR_THRESH_2_LINKS) ||
            missed_bcon >= IWL_MLD_BCN_LOSS_EXIT_ESR_THRESH ||
            (bss_param_ch_cnt_link_id != link_id &&
             missed_bcon >=
             IWL_MLD_BCN_LOSS_EXIT_ESR_THRESH_BSS_PARAM_CHANGED)) {
                iwl_mld_exit_emlsr(mld, vif,
IWL_MLD_EMLSR_EXIT_MISSED_BEACON,
                                   iwl_mld_get_primary_link(vif));
        }
```

Full EMLSR/missed-beacon infrastructure exists (`constants.h`
thresholds, `iwl_mld_emlsr_active()`, notification handler).

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** Single hunk in one file;
`iwl_mld_get_other_link()` already present in `mlo.h`. Line numbers in
mainline diff (~663) vs stable tree (~604) differ slightly but context
is identical.

### Step 6.3: Related fixes already present?
**Record:** `git log --grep="keep healthy link"` — no matches. Fix is
**not** already in this tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
**Record:** `drivers/net/wireless/intel/iwlwifi/mld/` — Intel WiFi
driver, MLO/EMLSR path. **Criticality: IMPORTANT** (network connectivity
for Intel WiFi 7 hardware; not core kernel, but user-visible
connectivity).

### Step 7.2: Activity
**Record:** iwlwifi mld is actively developed (2024–2025 Intel
copyright, EMLSR support, ongoing iwlwifi-fixes series). MLD driver is
relatively new but present and functional in 6.18.y.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Intel iwlwifi users with MLO/EMLSR active (WiFi 7 multi-
link). Config/hardware-specific, but growing install base. Not
universal, but real production hardware.

### Step 8.2: Trigger conditions
**Record:**
- EMLSR active with 2 links
- Primary link loses beacons (signal loss or BSS parameter change) while
  secondary remains healthy
- Fairly plausible in mobile/roaming scenarios
- Not a syscall-exploitable security issue; connectivity bug

### Step 8.3: Failure mode severity
**Record:** **WiFi disconnection** — driver exits EMLSR onto the
degraded link instead of the healthy one, connection eventually lost.
**Severity: HIGH** for affected users (loss of network connectivity);
not kernel panic/oops.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for EMLSR users — prevents unnecessary
  disconnections
- **Risk:** VERY LOW — ~15 lines, uses existing helper, consistent with
  sibling code paths
- **Ratio:** Strong benefit, minimal risk

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real logic bug causing WiFi connection loss
- Buggy code confirmed in 6.18.44
- Small, surgical, obviously correct fix
- Uses existing `iwl_mld_get_other_link()` — no new APIs
- Consistent with low-RSSI and CSA EMLSR exit paths in same driver
- Intel maintainer-authored fix in iwlwifi-fixes series (v1→v3 reviewed)
- Applies cleanly to this tree
- Other iwlwifi mld fixes are already being backported to 6.18

**AGAINST backport:**
- Affects niche hardware subset (WiFi 7 MLO/EMLSR on Intel)
- No syzbot report or explicit user bug report
- No Tested-by in commit message

**Unresolved:**
- Full git history of when buggy code was introduced (shallow repo)
- Full lore.kernel.org review thread (bot-blocked)
- Whether v3 revision changed anything beyond v1 for this specific hunk

None of the unresolved items weaken the technical case.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic matches established
   driver patterns; maintainer sign-off; no Tested-by
2. Fixes a real bug? **PASS** — wrong link kept on EMLSR exit
3. Important issue? **PASS** — connection loss (HIGH for affected users)
4. Small and contained? **PASS** — 1 file, ~17 lines
5. No new features/APIs? **PASS** — behavior correction only
6. Can apply to local tree? **PASS** — code and helpers present; fix not
   yet applied

### Step 9.3: Exception categories
**Record:** N/A — standard driver bug fix, not device-ID/quirk/build/doc
exception.

### Step 9.4: Decision rationale

For **Linux 6.18.44**, the iwlwifi MLD driver with EMLSR support is
present, the buggy link-selection code is active, and the fix is a
minimal correction that aligns the missed-beacon exit path with how the
same driver already handles low-RSSI and CSA EMLSR exits. The failure
mode is real WiFi disconnection for Intel WiFi 7 MLO users — important
enough for stable despite the narrow hardware scope.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
- **[Phase 2]** Analyzed diff: split EMLSR exit conditional in
  `iwl_mld_handle_missed_beacon_notif()`
- **[Phase 3]** `git describe HEAD` → `v6.18.44`; `git rev-parse --is-
  shallow-repository` → `true` (500 commits)
- **[Phase 3]** `git blame -L 604,612 link.c` → buggy lines at tree base
- **[Phase 3]** `git log --grep="keep healthy link"` → no matches (fix
  not present)
- **[Phase 3]** `git log -S "iwl_mld_handle_missed_beacon_notif"` → only
  shallow root (history limited)
- **[Phase 4]** `b4 dig -c 1bdfba6279e21` → no result (blob hash, not
  commit)
- **[Phase 4]** WebFetch patch.msgid.link → blocked by Anubis
- **[Phase 4]** Ratatoskr iwlwifi-fixes 05/15 → confirmed patch content,
  v1/v2/v3 revisions, Intel maintainer series
- **[Phase 5]** `grep iwl_mld_get_other_link` → exists in `mlo.h`, used
  in `stats.c:398`, `mac80211.c:2227`
- **[Phase 5]** Read `iwl_mld_exit_emlsr()` in `mlo.c:195-247` →
  validates `link_to_keep`
- **[Phase 5]** Read `iwl_mld_get_other_link()` in `mlo.h:95-108`
- **[Phase 6]** Read `link.c:522-614` → confirmed buggy code present in
  6.18.44
- **[Phase 6]** `grep IWL_MLD_BCN_LOSS_EXIT_ESR_THRESH` → thresholds in
  `constants.h`, used in `link.c`
- **[Phase 7]** Confirmed iwlwifi mld subsystem present with EMLSR
  infrastructure
- **[Phase 8]** Failure mode: connection loss on EMLSR beacon exit →
  HIGH for affected users
- **UNVERIFIED:** Full lore.kernel.org review discussion (fetch blocked)
- **UNVERIFIED:** Exact mainline commit SHA and date bug was introduced
  (shallow repo)

**YES**The background `git log -S` search finished, but it didn’t add
much: this checkout is a shallow clone (500 commits), so history for
`iwl_mld_handle_missed_beacon_notif` and
`IWL_MLD_BCN_LOSS_EXIT_ESR_THRESH` only goes back to the tree root. We
still can’t pin when the buggy code was introduced from git history
here.

That doesn’t change the backport call. On **6.18.44**, the buggy logic
is present in `link.c`, the fix is small and self-contained, and it
matches how the same driver already handles other EMLSR exits.

**YES**

 drivers/net/wireless/intel/iwlwifi/mld/link.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/link.c b/drivers/net/wireless/intel/iwlwifi/mld/link.c
index e67ba3a24d025..49e3d97f286f9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/link.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/link.c
@@ -600,15 +600,20 @@ void iwl_mld_handle_missed_beacon_notif(struct iwl_mld *mld,
 	 * OR more than IWL_MLD_BCN_LOSS_EXIT_ESR_THRESH_BSS_PARAM_CHANGED
 	 * on current link and the link's bss_param_ch_count has changed on
 	 * the other link's beacon.
+	 *
+	 * When both links lose beacons, keep the primary (symmetric failure).
+	 * When only the current link is sick, keep the other link.
 	 */
-	if ((missed_bcon >= IWL_MLD_BCN_LOSS_EXIT_ESR_THRESH_2_LINKS &&
-	     scnd_lnk_bcn_lost >= IWL_MLD_BCN_LOSS_EXIT_ESR_THRESH_2_LINKS) ||
-	    missed_bcon >= IWL_MLD_BCN_LOSS_EXIT_ESR_THRESH ||
-	    (bss_param_ch_cnt_link_id != link_id &&
-	     missed_bcon >=
-	     IWL_MLD_BCN_LOSS_EXIT_ESR_THRESH_BSS_PARAM_CHANGED)) {
+	if (missed_bcon >= IWL_MLD_BCN_LOSS_EXIT_ESR_THRESH_2_LINKS &&
+	    scnd_lnk_bcn_lost >= IWL_MLD_BCN_LOSS_EXIT_ESR_THRESH_2_LINKS) {
 		iwl_mld_exit_emlsr(mld, vif, IWL_MLD_EMLSR_EXIT_MISSED_BEACON,
 				   iwl_mld_get_primary_link(vif));
+	} else if (missed_bcon >= IWL_MLD_BCN_LOSS_EXIT_ESR_THRESH ||
+		   (bss_param_ch_cnt_link_id != link_id &&
+		    missed_bcon >=
+		    IWL_MLD_BCN_LOSS_EXIT_ESR_THRESH_BSS_PARAM_CHANGED)) {
+		iwl_mld_exit_emlsr(mld, vif, IWL_MLD_EMLSR_EXIT_MISSED_BEACON,
+				   iwl_mld_get_other_link(vif, link_id));
 	}
 }
 EXPORT_SYMBOL_IF_IWLWIFI_KUNIT(iwl_mld_handle_missed_beacon_notif);
-- 
2.53.0

