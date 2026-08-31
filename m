Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8CC55C331;
	Mon, 31 Aug 2026 13:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184031; cv=none; b=hWAfc58qaItnIHYxR0UKMD91nLM3CGJ3ER5kpNwc7f18CvsdefOmg0iF/EJ+uaPosRCHU3G8gRoD3iGx//s9rOKeUZS9hrRYK3zJppzx5TRaoKP+IJq7EeEcapmAjMGwU4GNkApSNIw4LTkvCD4R9+xr2Xn1qGcq2psyv9a2Ixo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184031; c=relaxed/simple;
	bh=CXf2XXNXyH+N999dw91S990cWsJg0zFZCl5pXNWl4P0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ThBAlAKHdBLC1awExsj/w9nLArDl3sfsUbZc+WvZegM0ICCd6FGGVynUHY6HdJxrMTPxhCEhDC3bxmoRnTiXE80zuBHj+qzbC5zGW+rFI52+jXnna9j2LnQrW5DE3Hb7X7TPRWt4ZZuY+Wcu0cC9JAmeHDLrCcZcjs4CjwDUnz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aCo322JB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aCo322JB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1754E1F000E9;
	Mon, 31 Aug 2026 13:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184028;
	bh=MYn0f3VU4AfkZURexRgzvVmSfbJTJTQAyw1KqLC7Coc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aCo322JBciqsccrsHNRNaEc8LeH6wzrVGqB3ypxd5zE2TYpIDKFneL1LMKScosp26
	 SZms5b3/z/1LFWqAAp0DQjUlaYM0xdzR0Z4EVpL/FmYz/xmbzRZsyak5WrD6Lr5uV7
	 omVmGKI3gTBSshX4m9nSNY1KPzsGQ9qR1XGCJLLP7Pg1o9DZwpjND3i2gcStQ3/IfG
	 /9XO1gcKjOTLI8vnzCKJyIIJdi8Drv+C3+bLgpPFBCACWzDFE5/+YJB8mKhoNXsXPP
	 aGOOgqizJ0LQZTKsSofGXi2e+dErRMKROE41sgIcuQi7rckrfyytP68d1bodx2yiTY
	 jrACiHF1FdlEw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] wifi: mac80211: ibss: wait for in-flight TX on disconnect
Date: Mon, 31 Aug 2026 09:27:55 -0400
Message-ID: <20260831133314.4125787-447-sashal@kernel.org>
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

From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

[ Upstream commit d0e69d9afa59b93c30294eba89b1f15f69e91105 ]

While leaving an IBSS in ieee80211_ibss_disconnect() mac80211 flushes
stations, turns the carrier off and immediately tells the driver to
leave as well. While there may be synchronize_net() in station flush
and in this code later, packets can still be transmitted due to
cross-CPU race conditions after carrier off is set.
Therefore, it's possible for a race to happen where a TX to the
driver occurs while or after telling it to leave the IBSS. This can
be confusing to drivers, and in the case of iwlwifi leads to an
attempt to use invalid queues.

Move netif_carrier_off() to occur before sta_info_flush() during
IBSS disconnect, and add synchronize_net() if flushing didn't,
so that the synchronize_net() always happens between turning the
carrier off and telling the driver, avoiding this race.

Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260706223751.da1ce439cc93.If5cf482f87ab98ce66dd48724e24c81fed236d3f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: mac80211: ibss: wait for in-flight TX
on disconnect`

**Local tree:** `v6.18.44` (`stable/linux-6.18.y`, HEAD `2736c32da98b9`)
**Upstream commit:** `d0e69d9afa59` (mainline, Jul 7 2026)
**Candidate on autosel:** `8763b7cb9523a` — **not yet applied** to this
checkout

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[wifi: mac80211: ibss]` — implicit **fix**
(wait/synchronize) — ensure in-flight TX completes before telling the
driver to leave IBSS on disconnect.

### Step 1.2: Tags
**Record:**
- **Fixes:** — absent (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** Johannes Berg `<johannes.berg@intel.com>` (mac80211
  maintainer)
- **Acked-by:** — none
- **Link:** https://patch.msgid.link/20260706223751.da1ce439cc93.If5cf48
  2f87ab98ce66dd48724e24c81fed236d3f@changeid
- **Cc: stable:** — absent (expected)
- **Signed-off-by:** Pagadala Yesu Anjaneyulu, Miri Korenblit, Johannes
  Berg (ignore pipeline SOB)

Notable: maintainer Reviewed-by; no syzbot/user reports; Intel-internal
fix.

### Step 1.3: Body analysis
**Record:**
- **Bug:** On IBSS disconnect, mac80211 flushes stations, turns carrier
  off, then immediately calls `drv_leave_ibss()`. Cross-CPU races allow
  TX to reach the driver during/after leave.
- **Symptom:** Driver confusion; iwlwifi attempts to use invalid queues.
- **Root cause:** `synchronize_net()` may be skipped when
  `sta_info_flush()` returns 0 (no stations); carrier was turned off too
  late; no guaranteed net stack drain between carrier-off and
  `drv_leave_ibss()`.
- **Version info:** None in message; fix landed in mainline after v6.18.

### Step 1.4: Hidden bug fix?
**Record:** Yes — despite no "fix" in subject, this is a
synchronization/race fix disguised as ordering cleanup. Not cosmetic.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `net/mac80211/ibss.c` only (+3 / -6 lines)
- **Functions:** `ieee80211_ibss_disconnect()`,
  `ieee80211_csa_connection_drop_work()`, `ieee80211_ibss_leave()`
- **Scope:** Single-file surgical fix

### Step 2.2: Code flow per hunk

**Hunk 1 — `ieee80211_ibss_disconnect()`:**
- **Before:** `sta_info_flush()` → incomplete-sta cleanup →
  `netif_carrier_off()` → … → `drv_leave_ibss()`
- **After:** `netif_carrier_off()` → `sta_info_flush()`; if flush
  returned 0, `synchronize_net()` → … → `drv_leave_ibss()`
- **Path:** IBSS disconnect / leave / CSA drop

**Hunk 2 — `ieee80211_csa_connection_drop_work()`:**
- **Before:** disconnect → `synchronize_rcu()` → purge skb queue
- **After:** disconnect → purge skb queue (RCU sync removed; disconnect
  now guarantees `synchronize_net()`)

**Hunk 3 — `ieee80211_ibss_leave()`:**
- **Before:** disconnect → … → `synchronize_rcu()` → purge skb queue
- **After:** disconnect → purge skb queue

### Step 2.3: Bug mechanism
**Record:** **Race condition / synchronization bug**
- `sta_info_flush()` only calls `synchronize_net()` when stations are
  actually flushed (`free_list` non-empty); returns 0 with no sync when
  empty.
- Old ordering allowed new TX between flush and carrier-off; even after
  carrier-off, in-flight TX on other CPUs could reach the driver after
  `drv_leave_ibss()`.
- Fix: carrier-off first (blocks new xmit via `!netif_carrier_ok()` in
  `__dev_direct_xmit()`), then always `synchronize_net()` before
  `drv_leave_ibss()`.

### Step 2.4: Fix quality
**Record:** Obviously correct; mirrors the existing IBSS merge path in
the same file (`netif_carrier_off()` + `synchronize_net()` before
`drv_leave_ibss()` at lines 244–249). Minimal. Low regression risk —
adds only ordering + one conditional sync call; maintainer-reviewed.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Current disconnect ordering in this tree dates to the v6.18
import (`5d324e5159d9e`). Deeper per-line history not available in this
shallow stable checkout; bug appears longstanding in IBSS disconnect
(merge path already had the correct pattern separately).

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related file history
**Record:** Fix is standalone (v1 only on lore). On `autosel` branch,
only this commit touches `ibss.c` for this issue. Mainline fix
`d0e69d9afa59` is **not** in `remotes/stable/linux-6.18.y`.

### Step 3.4: Author context
**Record:** Pagadala Yesu Anjaneyulu — Intel iwlwifi contributor.
Johannes Berg (maintainer) reviewed. Miri Korenblit committed upstream.

### Step 3.5: Dependencies
**Record:** None. Self-contained; no series prerequisites. Applies
cleanly to current `ibss.c` in this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c 8763b7cb9523a` → https://patch.msgid.link/2026070
6223751.da1ce439cc93.If5cf482f87ab98ce66dd48724e24c81fed236d3f@changeid
Single-message thread (patch only, no replies). v1 only.

### Step 4.2: Reviewers
**Record:** `b4 dig -w`: CC'd `johannes@sipsolutions.net`, `linux-
wireless@vger.kernel.org`, Miri Korenblit, Johannes Berg. Appropriate
maintainers included.

### Step 4.3: Bug report
**Record:** No external bug report. iwlwifi invalid-queue issue
described in commit message only (Intel-internal).

### Step 4.4: Related patches
**Record:** Standalone; not part of a series.

### Step 4.5: Stable list
**Record:** Not searched on lore stable list; no stable nomination found
in thread (thread has no replies).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `ieee80211_ibss_disconnect()`, `sta_info_flush()` /
`__sta_info_flush()`, `drv_leave_ibss()`, `ieee80211_ibss_leave()`,
`ieee80211_csa_connection_drop_work()`

### Step 5.2: Callers
**Record:**
- `ieee80211_ibss_disconnect()` ← `ieee80211_ibss_leave()`,
  `ieee80211_csa_connection_drop_work()`
- `ieee80211_ibss_leave()` ← `ieee80211_leave_ibss()` in `cfg.c`
  (nl80211 `.leave_ibss` op)
- Userspace triggers via `NL80211_CMD_LEAVE_IBSS` / interface down; CSA
  radar path triggers disconnect work

### Step 5.3: Callees
**Record:** `netif_carrier_off()`, `sta_info_flush()` (may call
`synchronize_net()` internally), `synchronize_net()`,
`drv_leave_ibss()`, `ieee80211_bss_info_change_notify()`

### Step 5.4: Reachability
**Record:** Reachable from userspace via cfg80211/nl80211 when leaving
ad-hoc/IBSS mode or on CSA-driven disconnect. Not obscure kernel-only
init path.

### Step 5.5: Similar patterns
**Record:** IBSS merge path in same file already uses
`netif_carrier_off()` + `synchronize_net()` before `drv_leave_ibss()` —
confirms the disconnect path was missing this established pattern.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current tree at lines 678–708 of
`net/mac80211/ibss.c` has `sta_info_flush()` before
`netif_carrier_off()`, then `drv_leave_ibss()` with no guaranteed
`synchronize_net()` when flush returns 0.

### Step 6.2: Backport complications
**Record:** Clean apply expected — autosel commit `8763b7cb9523a` is a
trivial 9-line change against identical code in this tree.

### Step 6.3: Related fixes already present?
**Record:** **No.** `git log remotes/stable/linux-6.18.y` does not
contain `d0e69d9afa59` or `8763b7cb9523a`.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `net/mac80211` — **IMPORTANT** (wireless stack; affects all
WiFi users on affected paths; IBSS/adhoc is a niche but real mode).

### Step 7.2: Subsystem activity
**Record:** Actively maintained; iwlwifi is a widely deployed driver.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users leaving IBSS/adhoc mode (or dropped by CSA/radar) with
drivers that assume no TX after `leave_ibss` — notably **iwlwifi**.
Config-specific (`NL80211_IFTYPE_ADHOC`), not universal.

### Step 8.2: Trigger conditions
**Record:** IBSS leave, interface teardown, CSA connection drop.
Userspace-triggerable via nl80211. Race is timing-dependent but
realistic on SMP. Unprivileged users can trigger if they control the
wireless interface.

### Step 8.3: Failure mode severity
**Record:** Driver TX after IBSS teardown → invalid queue usage in
iwlwifi (`WARN_ON` paths in `mvm/tx.c`). Severity: **MEDIUM-HIGH** for
affected users (driver malfunction, possible packet loss/warnings; race
class can escalate depending on driver). Not a mass crash, but a real
correctness bug in a common driver.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** MEDIUM — fixes real disconnect race for IBSS+iwlwifi;
  aligns with proven pattern already in same file
- **Risk:** LOW — 9 lines, maintainer-reviewed, no API changes
- **Ratio:** Favorable for stable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real cross-CPU race on IBSS disconnect
- Concrete iwlwifi impact (invalid queues)
- Small, surgical, maintainer-reviewed fix
- Matches existing correct IBSS merge pattern in same file
- Buggy code confirmed in v6.18.44 tree; fix not yet applied
- Applies cleanly

**AGAINST backport:**
- IBSS/adhoc is a niche mode
- No public bug report or syzbot reproducer
- Failure mode may be WARN-level rather than panic (unverified crash
  severity)
- `synchronize_rcu()` removal rationale not discussed on lore (only
  maintainer review)

**Unresolved:**
- Exact kernel version that introduced the buggy disconnect ordering
  (history too shallow to pinpoint)
- Whether iwlwifi issue always manifests as WARN vs harder failure

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic sound; Reviewed-by
   maintainer; mirrors in-tree pattern
2. Fixes real bug affecting users? **PASS** — race on IBSS disconnect
   with iwlwifi impact
3. Important issue? **PASS** — driver malfunction on disconnect (MEDIUM-
   HIGH for affected config)
4. Small and contained? **PASS** — 9 lines, 1 file
5. No new features/APIs? **PASS** — ordering/sync only
6. Can apply to local tree? **PASS** — clean apply to current `ibss.c`

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs).

### Step 9.4: Decision rationale

For **linux-6.18.y** (this checkout): the buggy disconnect sequencing
exists, the fix is small and maintainer-approved, and it prevents a
realistic SMP race where TX reaches iwlwifi after IBSS teardown. The fix
follows an established pattern already used in the IBSS merge path in
the same file. Conservative stable criteria are met.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message and
  `git show 8763b7cb9523a`
- [Phase 2] Diff analysis: 3 insertions, 6 deletions in `ibss.c`;
  verified `sta_info_flush()` conditional `synchronize_net()` at
  `sta_info.c:1684-1687`
- [Phase 2] Verified `__dev_direct_xmit()` carrier check at
  `net/core/dev.c:4853-4854`
- [Phase 3] `git describe HEAD` → v6.18.44; tree is
  `stable/linux-6.18.y`
- [Phase 3] `git show remotes/stable/linux-6.18.y:net/mac80211/ibss.c` →
  buggy ordering confirmed
- [Phase 3] Fix not in stable: `git log remotes/stable/linux-6.18.y | rg
  d0e69d9` → empty; merge-base with fix is `Linux 6.18`
- [Phase 3] `git show d0e69d9afa59` → upstream mainline commit confirmed
- [Phase 4] `b4 dig -c 8763b7cb9523a` → lore URL found
- [Phase 4] `b4 dig -a` → v1 only
- [Phase 4] `b4 dig -w` → Johannes Berg, linux-wireless CC'd
- [Phase 4] `/tmp/ibss_thread.mbox` → single patch, no replies, no
  stable nomination
- [Phase 5] `grep ieee80211_ibss_leave` → called from `cfg.c:3223`
  (nl80211 leave_ibss)
- [Phase 5] Verified IBSS merge correct pattern at `ibss.c:244-249`
- [Phase 5] iwlwifi invalid queue paths at `mvm/tx.c:814`
  (`WARN_ON(queue == IWL_MVM_INVALID_QUEUE)`)
- [Phase 6] Read current `ibss.c:653-710` and `1814-1828` — buggy code
  present, `synchronize_rcu()` still in leave paths
- [Phase 6] `git show 8763b7cb9523a` on autosel — patch applies to
  identical code
- [Phase 8] IBSS reachability via `cfg.c` `.leave_ibss` op confirmed
- **UNVERIFIED:** Exact introduction commit of buggy disconnect ordering
  (shallow history)
- **UNVERIFIED:** Whether iwlwifi issue always causes only WARN vs oops

**YES**

 net/mac80211/ibss.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 6e36b09fe97f8..6ca2ff354e768 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -675,7 +675,9 @@ static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sdata)
 
 	ifibss->state = IEEE80211_IBSS_MLME_SEARCH;
 
-	sta_info_flush(sdata, -1);
+	netif_carrier_off(sdata->dev);
+	if (!sta_info_flush(sdata, -1))
+		synchronize_net();
 
 	spin_lock_bh(&ifibss->incomplete_lock);
 	while (!list_empty(&ifibss->incomplete_stations)) {
@@ -689,8 +691,6 @@ static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sdata)
 	}
 	spin_unlock_bh(&ifibss->incomplete_lock);
 
-	netif_carrier_off(sdata->dev);
-
 	sdata->vif.cfg.ibss_joined = false;
 	sdata->vif.cfg.ibss_creator = false;
 	sdata->vif.bss_conf.enable_beacon = false;
@@ -717,7 +717,6 @@ static void ieee80211_csa_connection_drop_work(struct wiphy *wiphy,
 			     u.ibss.csa_connection_drop_work);
 
 	ieee80211_ibss_disconnect(sdata);
-	synchronize_rcu();
 	skb_queue_purge(&sdata->skb_queue);
 
 	/* trigger a scan to find another IBSS network to join */
@@ -1823,8 +1822,6 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 	memset(&ifibss->ht_capa, 0, sizeof(ifibss->ht_capa));
 	memset(&ifibss->ht_capa_mask, 0, sizeof(ifibss->ht_capa_mask));
 
-	synchronize_rcu();
-
 	skb_queue_purge(&sdata->skb_queue);
 
 	timer_delete_sync(&sdata->u.ibss.timer);
-- 
2.53.0

