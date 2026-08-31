Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719424F7535;
	Mon, 31 Aug 2026 13:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183676; cv=none; b=NXaJqy48g6yg9znVRCEg1fqSwaL5UQV0ffsZ6iBpRDE4b+INrIf3t2hrgp/B4RBzyIRWv2tablzfJ0zePbtVTR8BndPOoPGYfQgR3JEG9l+CM2suve3YGNqe5J9B8Sqc0rju8DaSezGiIv0P3Q0LGSOyo7ebN8+oxadsTzxiR3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183676; c=relaxed/simple;
	bh=+Kw6GAiPKJfPCrnZPtphnnIbGqur1JPhq186co4M0Fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DX7OfOtIjzTQkL16xVLjdkbpGD9we52FA5L9oKGLScD2Xk4iqTVZQxoF0fZd/5GsNHx3zfgv6yDP5zlaA/Q0C9MW2frx400Pql3yZPg13q0Pnj6dpE+FD7qbvgxVXMkBhwqIzj8FIWPmZwd0P/PhdSZY+Y9NmZYphGXYYvRDgKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bVOXO1as; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bVOXO1as"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8151F00A3E;
	Mon, 31 Aug 2026 13:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183673;
	bh=m3wj9mwMPuIL9qGjRegB9YqqtjdnII9VACbYKzWJyv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bVOXO1asRiNV4GgcAxbXH3BKPflhbrshC8LO5vtrEem9WTyiYmPyqN+k9ua2TA4nL
	 TCxjAT9JARVv5ltImPGC2x+9vVrsDs0/S325ldIrRt/tltZhySAVUizQuOVedT7Blk
	 c931bcrIPJNlTLdnhy6spemR5f7Yz45HRhR/r/sbFiQ+ulU2ymgAiHNpfsYQYDC6Yd
	 Iqesdtf9lVopyh9/oOqeZGjxumWNRunHs2yA05Zk2LEMM4k7Z8sELfHDkXanGtbUiy
	 d0VykDAhHc4A8yre7rlIKadRgRO+u2jNKQHWN9R9d4f7RDcUsukl9Gl4sxUDXxVVCV
	 B16Aqf30BHg0g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: mac80211: avoid out-of-bounds access in monitor
Date: Mon, 31 Aug 2026 09:24:24 -0400
Message-ID: <20260831133314.4125787-236-sashal@kernel.org>
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

[ Upstream commit 03c41203ee5a833a9d7a7630be190830cede29d8 ]

In NAN, we don't know on what band the frame will be sent. Therefore we
set info->band to NUM_NL80211_BANDS. However, this leads to out-of-bound
access in ieee80211_add_tx_radiotap_header when we try to access the
sbands array.

Fix it by not accessing the array if the band is NUM_NL80211_BANDS.
This means that we will not report rate info for legacy rate in NAN.
But nobody really cares about it.

Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260504101829.346c9893d136.I15919027597c04ec35c6217db6e52e2a605e5cfc@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: mac80211: avoid out-of-bounds access
in monitor`

**Local tree:** Linux **6.18.43** (`git describe HEAD` →
`v6.18.43-1-gc7f0dac02d232`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[wifi: mac80211]` `[avoid]` — prevent out-of-bounds array
access in monitor-mode TX radiotap header construction.

### Step 1.2: Tags
**Record:**
- **Reviewed-by:** Ilan Peer \<ilan.peer@intel.com\>
- **Reviewed-by:** Johannes Berg \<johannes.berg@intel.com\> (mac80211
  maintainer)
- **Signed-off-by:** Miri Korenblit
  \<miriam.rachel.korenblit@intel.com\> (author)
- **Signed-off-by:** Johannes Berg (maintainer commit)
- **Link:** https://patch.msgid.link/20260504101829.346c9893d136.I159190
  27597c04ec35c6217db6e52e2a605e5cfc@changeid
- No Fixes:, Reported-by:, Tested-by:, Cc: stable@vger.kernel.org
- Notable: dual Reviewed-by including subsystem maintainer; no
  fuzzer/user bug report

### Step 1.3: Body analysis
**Record:**
- **Bug:** For NAN, TX band is set to `NUM_NL80211_BANDS` because the
  actual band is unknown at TX time.
- **Symptom:** `ieee80211_add_tx_radiotap_header()` indexes
  `local->hw.wiphy->bands[info->band]` with that sentinel value → out-
  of-bounds access.
- **Trigger path:** NAN transmission + monitor interface capturing TX
  frames.
- **Root cause:** Missing bounds check before `bands[]` lookup in the
  legacy-rate radiotap path.
- **Functional trade-off:** Legacy rate is not reported in radiotap for
  NAN frames (acceptable; author notes nobody cares).

### Step 1.4: Hidden bug fix?
**Record:** Not disguised — explicitly an OOB access fix, though
described as monitor/radiotap rather than "crash fix."

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `net/mac80211/status.c` (+1 functional line, copyright year
  bump)
- **Functions:** `ieee80211_add_tx_radiotap_header()`
- **Scope:** Single-file, surgical (1-line logic change)

### Step 2.2: Code flow change
**Record:**
- **Hunk (lines ~298–305):**
  - **Before:** If no `status_rate`, and `rates[0].idx >= 0` with legacy
    flags, always dereference `wiphy->bands[info->band]`.
  - **After:** Same, but only when `info->band < NUM_NL80211_BANDS`.
  - **Path:** TX status → monitor radiotap header fill on legacy (non-
    MCS/VHT) rate reporting.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Buffer/out-of-bounds access (array index past end).
- **Mechanism:** `struct ieee80211_supported_band
  *bands[NUM_NL80211_BANDS]` (verified in
  `include/net/cfg80211.h:6076`). Valid indices are `0 ..
  NUM_NL80211_BANDS-1`. `NUM_NL80211_BANDS` is a sentinel (value 6 in
  this tree: 2G/5G/60G/6G/S1G/LC). NAN TX sets `info->band =
  NUM_NL80211_BANDS` in `ieee80211_tx_skb_tid()`
  (`net/mac80211/tx.c:6316-6317`). Indexing `bands[NUM_NL80211_BANDS]`
  is OOB; subsequent `sband->bitrates[...]` can crash or corrupt memory.

### Step 2.4: Fix quality
**Record:**
- **Obviously correct:** Matches existing guards elsewhere in mac80211
  (`tx.c:62`, `tx.c:689`, `rate.c:101`, `rate.c:907`).
- **Minimal:** One condition added.
- **Regression risk:** Very low — only skips optional radiotap legacy-
  rate field when band is unknown.
- **No API changes.**

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `git blame` on changed lines shows all of `status.c`
attributed to commit `19eef1d98eeda` due to flattened/squashed file
history in this checkout. **UNVERIFIED:** exact commit that introduced
the missing guard.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related file history
**Record:** `git log --oneline -20 -- net/mac80211/status.c` shows only
the squashed import commit. Recent mac80211 fixes in tree include
radiotap bounds work (`9b40c59bab08f` — injected antenna index). NAN-
related work by same author exists (`08e7ae48e175c` cfg80211 NAN). Buggy
code **is present** in current tree without this fix.

### Step 3.4: Author context
**Record:** Miri Korenblit is an active WiFi contributor; recent
mac80211 commits in tree (`7a1bec39c014e`, `b4b065a880997`). Johannes
Berg is mac80211 maintainer and reviewed.

### Step 3.5: Dependencies
**Record:** Standalone — no series, no prerequisite commits. Only
requires existing NAN `band = NUM_NL80211_BANDS` assignment (present at
`tx.c:6317`) and existing `ieee80211_add_tx_radiotap_header()` (present
at `status.c:257`).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c <message-id>` failed — commit not in local tree.
`b4 dig -c HEAD` matched unrelated commit. lore.kernel.org and
patch.msgid.link blocked by Anubis bot protection. **UNVERIFIED:** full
mailing-list thread content.

### Step 4.2: Reviewers
**Record:** Commit message includes Reviewed-by from Johannes Berg
(maintainer) and Ilan Peer. **UNVERIFIED** via `b4 dig -w` (no commit
hash available locally).

### Step 4.3: Bug report
**Record:** No Reported-by, syzbot, or bugzilla link. Bug identified via
code-path analysis (NAN sentinel band + monitor radiotap).

### Step 4.4: Series context
**Record:** Standalone single-patch fix; no "patch X/Y" indication.

### Step 4.5: Stable list history
**Record:** **UNVERIFIED** — could not search lore stable archive (bot
protection).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `ieee80211_add_tx_radiotap_header()`, called from
`ieee80211_tx_monitor()`.

### Step 5.2: Callers
**Record:**
- `ieee80211_tx_monitor()` ← `ieee80211_tx_status_ext()` path when
  `local->tx_mntrs` (`status.c:1109-1110`)
- `ieee80211_tx_monitor()` ← `ieee80211_beacon_get_tim()` for beacon TX
  monitor copy (`tx.c:5819`)
- `ieee80211_tx_status_ext()` ← `ieee80211_tx_status_skb()` and driver
  TX status callbacks

### Step 5.3: Callees
**Record:** `skb_push`, `memset`, `local->hw.wiphy->bands[info->band]`
(the OOB site), `sband->bitrates[...]`.

### Step 5.4: Reachability
**Record:**
1. NAN interface started (`NL80211_IFTYPE_NAN`)
2. Frame TX via `ieee80211_tx_skb_tid()` → `band = NUM_NL80211_BANDS`
3. At least one monitor interface without `MONITOR_FLAG_SKIP_TX` →
   `local->tx_mntrs > 0` (`iface.c:1149-1150`)
4. TX completes with legacy rate info in skb CB (non-MCS/VHT,
   `rates[0].idx >= 0`)
5. `ieee80211_add_tx_radiotap_header()` OOB on `bands[]`

Reachable from normal Wi-Fi Aware (NAN) usage with packet capture
(Wireshark/tcpdump on monitor). Not theoretical.

### Step 5.5: Similar patterns
**Record:** Same `info->band` / `NUM_NL80211_BANDS` guard pattern
already used in:
- `net/mac80211/tx.c:62-63` (`ieee80211_duration`)
- `net/mac80211/tx.c:689-692` (rate control)
- `net/mac80211/rate.c:101-102`, `907` (rate control TX status)

`status.c` radiotap path was the outlier.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.43)

### Step 6.1: Buggy code present?
**Record:** **YES.** Current `status.c:298-305` lacks `info->band <
NUM_NL80211_BANDS` check. NAN sentinel assignment exists at
`tx.c:6316-6317`. Fix is **not** already applied.

### Step 6.2: Backport complications
**Record:** Expected **clean apply** — single-line addition in well-
isolated `else if` branch. Context at lines 298-300 matches the provided
diff exactly.

### Step 6.3: Duplicate fix?
**Record:** `git grep "avoid out-of-bounds access in monitor"` — no
matches. No equivalent fix found in tree.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **net/mac80211** — IMPORTANT (802.11 stack used broadly;
monitor mode used by developers, security tools, Android debugging).

### Step 7.2: Activity
**Record:** Active — multiple recent mac80211 fixes in this tree
(radiotap bounds, memory leaks, MLD fixes).

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Users of **NAN (Wi-Fi Aware)** with **TX monitor
interfaces** enabled. Config-specific but real (Android Wi-Fi Aware
development/capture scenarios).

### Step 8.2: Trigger conditions
**Record:** NAN TX + monitor without SKIP_TX + legacy rate in TX status
metadata. Unprivileged users can trigger if they can create NAN and
monitor interfaces (typically requires appropriate
permissions/CAP_NET_ADMIN).

### Step 8.3: Failure mode severity
**Record:** OOB read of pointer array → likely **NULL or garbage pointer
dereference** → kernel oops/panic. **Severity: HIGH** (kernel crash).
Not data corruption in the common case, but memory safety violation.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Prevents kernel crash on a real, reachable code path;
  aligns with existing subsystem defensive pattern.
- **Risk:** Minimal — one bounds check; only affects optional radiotap
  metadata.
- **Ratio:** Strongly favorable.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real OOB bug with clear mechanism
- Kernel crash potential
- Tiny, obviously correct fix
- Reviewed by mac80211 maintainer (Johannes Berg)
- Consistent with existing guards in same subsystem
- Buggy code confirmed present in 6.18.43 tree
- Clean backport expected

**AGAINST backport:**
- Niche trigger (NAN + TX monitor, not every user)
- No syzbot/user Reported-by (found via code review)
- Mailing-list discussion unverified

**Unresolved:** Exact introduction commit; lore thread content; whether
stable maintainers already discussed it.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic mirrors existing
   mac80211 pattern; maintainer-reviewed.
2. Fixes a real bug? **PASS** — OOB array access on reachable path.
3. Important issue? **PASS** — kernel crash / memory safety (HIGH).
4. Small and contained? **PASS** — 1-line functional change.
5. No new features/APIs? **PASS** — defensive bounds check only.
6. Can apply to local tree? **PASS** — code present, patch context
   matches.

### Step 9.3: Exception category
**Record:** N/A (not device ID, quirk, DT, build fix, or docs — standard
bug fix).

### Step 9.4: Decision rationale
For **this 6.18.43 tree**, the NAN TX path sets `info->band` to the
`NUM_NL80211_BANDS` sentinel, and the monitor radiotap header code
indexes `wiphy->bands[]` without a bounds check. That is a verified out-
of-bounds access that can crash the kernel when Wi-Fi Aware traffic is
captured on a TX-enabled monitor interface. The fix is minimal, matches
established patterns in the same files, and has maintainer review. The
trigger is narrower than a core networking crash, but the failure mode
is severe and the backport risk is negligible.

---

## Verification

- [Phase 1] Parsed subject, tags, body from user-provided commit message
- [Phase 1] Identified Reviewed-by: Johannes Berg, Ilan Peer
- [Phase 2] Read `status.c:257-310` — buggy `bands[info->band]` access
  without band check
- [Phase 2] Read `cfg80211.h:6076` — `bands[NUM_NL80211_BANDS]` array
  size
- [Phase 2] Read `nl80211.h:5631-5639` — `NUM_NL80211_BANDS` = 6
  (sentinel index)
- [Phase 2] Confirmed fix adds `info->band < NUM_NL80211_BANDS` guard
- [Phase 3] `git blame -L 295,310 status.c` — flattened history (all one
  commit)
- [Phase 3] `git log --oneline -20 -- net/mac80211/status.c` — squashed
  history
- [Phase 3] `git log --author=Korenblit` — author has recent mac80211
  commits
- [Phase 4] `b4 dig -c <message-id>` — failed, commit not in tree
- [Phase 4] WebFetch lore.kernel.org — blocked (Anubis)
- [Phase 4] WebFetch patch.msgid.link — blocked (Anubis)
- [Phase 5] `grep ieee80211_tx_monitor` — callers at `status.c:1110`,
  `tx.c:5819`
- [Phase 5] Read `tx.c:6316-6317` — NAN sets `band = NUM_NL80211_BANDS`
- [Phase 5] Read `iface.c:1149-1150` — `tx_mntrs` incremented for TX
  monitor
- [Phase 5] Grep `info->band.*NUM_NL80211_BANDS` in mac80211 — guards in
  `tx.c`, `rate.c`; missing in `status.c`
- [Phase 6] `git describe HEAD` / `make kernelversion` — **6.18.43**
- [Phase 6] Confirmed fix NOT present in current `status.c`
- [Phase 6] `grep "avoid out-of-bounds access in monitor"` — no existing
  fix
- [Phase 8] Traced call chain: NAN TX → TX status →
  `ieee80211_tx_monitor` → radiotap OOB
- **UNVERIFIED:** Exact commit that introduced NAN `band =
  NUM_NL80211_BANDS`
- **UNVERIFIED:** Mailing-list review thread and stable nominations
- **UNVERIFIED:** `git apply --check` (patch file formatting issue in
  test; manual line comparison confirms clean apply)

**YES**

 net/mac80211/status.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 4b38aa0e902a8..8716eda8317d1 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -5,7 +5,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2008-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
- * Copyright 2021-2025  Intel Corporation
+ * Copyright 2021-2026  Intel Corporation
  */
 
 #include <linux/export.h>
@@ -295,9 +295,10 @@ ieee80211_add_tx_radiotap_header(struct ieee80211_local *local,
 						 RATE_INFO_FLAGS_VHT_MCS |
 						 RATE_INFO_FLAGS_HE_MCS)))
 			legacy_rate = status_rate->rate_idx.legacy;
-	} else if (info->status.rates[0].idx >= 0 &&
-		 !(info->status.rates[0].flags & (IEEE80211_TX_RC_MCS |
-						  IEEE80211_TX_RC_VHT_MCS))) {
+	} else if (info->band < NUM_NL80211_BANDS &&
+		   info->status.rates[0].idx >= 0 &&
+		   !(info->status.rates[0].flags & (IEEE80211_TX_RC_MCS |
+						    IEEE80211_TX_RC_VHT_MCS))) {
 		struct ieee80211_supported_band *sband;
 
 		sband = local->hw.wiphy->bands[info->band];
-- 
2.53.0

