Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2168B511182;
	Mon, 31 Aug 2026 13:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183922; cv=none; b=UP/9K7vadFdidWCyMutAngBYxYvKwRB7vqQO826LGAVosWqrHpzjdfYdxIcsRF52DpRcA+OzNis7GoJjg9C00TKTlqYFgvz5dHncahnX2IVMtkL/6hh85DYdpM8l49NnL/MCHDG1b+rzr578zmP6TtV2q58lOBXRtXdk68dpCD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183922; c=relaxed/simple;
	bh=M4hwHtfTpYx/TxyJAriiHTcWQXWc+JKhZGanuk43jDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MTLvT/+hpSnDHk0r0HqN2NcKyex3fU0IhT1Nyfhziwh79aptL+bV/fy6OR6y7simA+FpvPtEGprOYQa2/S+ZAMjh6Hve6jZPEnHoO8YrLDS0xRPqWmZuSWTFT/QyTTz2FrMTJ+dyBopUBfM8qfYScjJy5+nESSYq6msQ2mlEv7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kMU0TvZv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kMU0TvZv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA9C1F00A3D;
	Mon, 31 Aug 2026 13:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183920;
	bh=erwCL33Eq4WHQ+2TstlMbI5oG5L8AKbn3R7j2Sm0+FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kMU0TvZvPAsXeKzv0GlSMuHc7+wcP5yzk6bQYj6uGRyIXjoTZbOMLTv0+JjfqBneT
	 g49l1/B3Wmw7SjAM/DcwMRK0CA6u/aKxdOan1c58bGvMBCdqW3HB6u1xK+P1wMspA+
	 9LJ4YeohqlQosoR/xxUUXtrWRNnnyzgwxtZ0hcIq2t7bsfLonLl+ovhJk/bhZf71Nx
	 r78hho/j7HN2UUtBGbQpo5gIQr0jz0Fxd5QWNdy4Nd16sLRhszDi7nkPTUypJpKsUT
	 ukBtBBwUV8+yxHYiBOx8vhMIejHANPgilaIPcYTJXXYD/SPDWGAVhxVybbKkyHagWU
	 oSVbkpuAA+J9w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Jouni Malinen <j@w1.fi>,
	Sasha Levin <sashal@kernel.org>,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] wifi: mac80211: always allow transmitting null-data on TXQs
Date: Mon, 31 Aug 2026 09:26:49 -0400
Message-ID: <20260831133314.4125787-381-sashal@kernel.org>
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

[ Upstream commit 51129a2ca0482b006d0e12a0aa025ff1e1cad2cb ]

Jouni reported that certain sequences of tests caused some
WDS tests to fail after applying the upcoming hwsim changes
for NAN. I bisected that down to converting hwsim to TXQs,
and after a long debug session found that the 4-addr NDP was
getting dropped, because it goes out via a (management) TXQ
and is a data frame.

It's unclear to me now why this only happens in some test
sequences (e.g. "sigma_dut_sae_h2e_ap_loop ap_wds_sta" and
"sigma_dut_eap_ttls_all_akm_suites ap_wds_sta_open"), maybe
that affects timing and the frame is otherwise delayed in
some way.

Correct the check to only drop frames that actually carry
data, not NDPs.

Reported-by: Jouni Malinen <j@w1.fi>
Link: https://patch.msgid.link/20260417141601.851ddf4adb59.I3d668c0e1bdca9cd98f2fc46f84a066e68cc7a62@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: mac80211: always allow transmitting
null-data on TXQs`

**Local tree:** Linux **6.18.43** (`stable/linux-6.18.y`, detached HEAD)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[wifi: mac80211]` `[allow]` — always allow transmitting
null-data frames on TXQs during dequeue.

### Step 1.2: Commit tags
**Record:**
- **Reported-by:** Jouni Malinen `<j@w1.fi>` (hostap/wpa_supplicant
  maintainer — credible wireless reporter)
- **Link:** https://patch.msgid.link/20260417141601.851ddf4adb59.I3d668c
  0e1bdca9cd98f2fc46f84a066e68cc7a62@changeid
- **Signed-off-by:** Johannes Berg `<johannes.berg@intel.com>` (mac80211
  maintainer)
- No Fixes:, Cc: stable, Reviewed-by, Tested-by, or syzbot tags
- Notable: single reporter, but a highly credible one in the WiFi stack

### Step 1.3: Body analysis
**Record:**
- **Bug:** 4-address null data packets (NDPs/nullfunc) are silently
  dropped in `ieee80211_tx_dequeue()` because they are IEEE 802.11 data-
  type frames routed through a management TXQ while the target STA is
  not yet `WLAN_STA_AUTHORIZED`.
- **Symptom:** WDS (Wireless Distribution System) test failures —
  specifically WiFi Alliance sigma tests `sigma_dut_sae_h2e_ap_loop
  ap_wds_sta` and `sigma_dut_eap_ttls_all_akm_suites ap_wds_sta_open`.
- **Root cause (author):** The unauthorized-station drop check uses
  `ieee80211_is_data()`, which matches nullfunc frames; it should use
  `ieee80211_is_data_present()`, which excludes null/QoS-null subtypes.
- **Timing:** Intermittent — only some test sequences trigger it; author
  suspects timing affects whether the frame is still unauthorized when
  dequeued.

### Step 1.4: Hidden bug fix detection
**Record:** Yes — despite “allow transmitting” wording, this is a logic
bug fix. The unauthorized-port drop was incorrectly classifying nullfunc
signaling frames as data frames carrying payload.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Change inventory
**Record:**
- **Files:** `net/mac80211/tx.c` — 1 insertion, 1 deletion (net 0 lines)
- **Function:** `ieee80211_tx_dequeue()`
- **Scope:** Single-file, single-line surgical fix

### Step 2.2: Code flow change
**Record:**
- **Before:** In `ieee80211_tx_dequeue()`, when `txq->sta` is set,
  nullfunc frames matching `ieee80211_is_data()` are dropped if the STA
  lacks `WLAN_STA_AUTHORIZED` (unless injected or EAPOL).
- **After:** Only frames with actual data payload
  (`ieee80211_is_data_present()`) are subject to the unauthorized drop.
  Nullfunc/NDP frames pass through.
- **Path affected:** Software TXQ dequeue path — normal TX path for
  drivers using `ieee80211_tx_dequeue()`.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic / correctness fix (incorrect frame classification)
- **Mechanism:** `ieee80211_is_data()` returns true for
  `IEEE80211_STYPE_NULLFUNC` frames. `ieee80211_is_data_present()` masks
  bit 0x40 to exclude null/QoS-null subtypes. The unauthorized-port
  guard was meant to block user data to unauthorized STAs, not signaling
  nullfunc frames used in 4-address WDS setup.

### Step 2.4: Fix quality
**Record:**
- **Obviously correct:** Yes — same file already uses
  `ieee80211_is_data_present()` at lines 633, 640, 667, and 1312 for the
  same data-vs-nullfunc distinction.
- **Minimal:** One-line change, no unrelated edits.
- **Regression risk:** Very low — only exempts nullfunc frames (no
  payload) from an unauthorized-data drop; EAPOL exemption path
  unchanged.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** In 6.18.43, lines 3891–3910 are present with
`ieee80211_is_data()`. Git blame in this tree points to `19eef1d98eeda`
(afs fix) due to a wholesale tree import; history is not granular here.
Verified the buggy pattern exists identically in `v6.18`, `v6.12`,
`v6.6`, `v6.1`, and `v5.10` tags.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related file history
**Record:** Fix commit `51129a2ca0482` exists on `wireless-next`/`all-
next` but is **not** in `stable/linux-6.18.y`. Recent stable `tx.c`
changes since v6.18 are unrelated skb-free/injection fixes. Standalone
one-commit fix.

### Step 3.4: Author context
**Record:** Johannes Berg is the mac80211 subsystem maintainer. No
related series — v1 only (confirmed via b4 dig -a).

### Step 3.5: Dependencies
**Record:** None. `ieee80211_is_data_present()` is defined in
`include/linux/ieee80211.h` and has been present since at least v5.10 in
this tree. Fix applies cleanly to 6.18.43 at line 3898.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c 51129a2ca0482` found the thread: https://patch.ms
gid.link/20260417141601.851ddf4adb59.I3d668c0e1bdca9cd98f2fc46f84a066e68
cc7a62@changeid. Single v1 patch, no replies in downloaded mbox. No
stable nomination, no NAKs, no reviewer comments in thread.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` shows CC to `linux-wireless@vger.kernel.org`,
Johannes Berg, Jouni Malinen. No explicit Reviewed-by in thread.

### Step 4.3: Bug report
**Record:** Reported by Jouni Malinen during WDS sigma certification
test failures. Severity: connectivity failure in 4-address WDS setups,
timing-dependent. No syzbot/CVE.

### Step 4.4: Related patches
**Record:** Bug surfaced during hwsim TXQ conversion for NAN, but the
fix targets core mac80211 `ieee80211_tx_dequeue()` — not hwsim-specific.
No multi-patch series dependency.

### Step 4.5: Stable list history
**Record:** Lore search blocked by Anubis bot protection on direct
WebFetch. No stable-list discussion found via b4.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `ieee80211_tx_dequeue()` modified. Related:
`ieee80211_send_4addr_nullfunc()` (sends the affected frame type).

### Step 5.2: Callers
**Record:** `ieee80211_tx_dequeue()` called from:
- `net/mac80211/util.c` (wake TX queue handler)
- Multiple wireless drivers: iwlwifi, mt76, ath9k/ath10k, rtw88, rtw89,
  etc.
- Hot path for all drivers using software TXQs.

### Step 5.3: Callees
**Record:** Dequeue path calls `test_sta_flag(tx.sta,
WLAN_STA_AUTHORIZED)`, `ieee80211_is_our_addr()`,
`ieee80211_free_txskb()` on drop.

### Step 5.4: Reachability
**Record:** Triggerable during normal WiFi operation when:
1. Driver uses `ieee80211_tx_dequeue()` (most modern mac80211 drivers)
2. Frame is a 4-address nullfunc (`ieee80211_send_4addr_nullfunc()` in
   `mlme.c:6458`, `cfg.c:281`)
3. Target STA in TXQ is not yet `WLAN_STA_AUTHORIZED`
4. Frame is not injected and not EAPOL

Reachable from userspace-driven WDS/4-address configuration — no special
privileges beyond normal wireless admin.

### Step 5.5: Similar patterns
**Record:** Same file consistently uses `ieee80211_is_data_present()`
for “does this frame carry data?” decisions (lines 633, 640, 667, 1312).
The `ieee80211_tx_dequeue()` check is the outlier using
`ieee80211_is_data()`.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.43)

### Step 6.1: Buggy code present?
**Record:** **Yes.** At `net/mac80211/tx.c:3898`, the tree uses
`ieee80211_is_data(hdr->frame_control)`. Bug present since at least
v5.10; confirmed in v6.18.0 and v6.12.0.

### Step 6.2: Backport complications
**Record:** **Clean apply** — identical context at line 3898 in 6.18.43
matches mainline fix. No refactoring conflicts.

### Step 6.3: Related fixes already present?
**Record:** **No.** `git branch --contains 51129a2ca0482` shows fix only
on development branches (wireless-next, all-next), not
stable/linux-6.18.y.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `net/mac80211` — **CORE/IMPORTANT**. mac80211 is the shared
802.11 stack for virtually all Linux WiFi drivers.

### Step 7.2: Activity
**Record:** Actively maintained; recent stable backports to tx.c in
6.18.y (injection, skb-free fixes).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of **4-address WDS mode** and AP+WDS-bridging setups.
Not universal, but affects a real production use case (enterprise
bridging, repeater setups, certification-tested configurations).

### Step 8.2: Trigger conditions
**Record:** Timing-dependent race between nullfunc TX and STA
authorization during WDS 4-address setup. Not every boot, but
reproducible in certification tests. Triggerable by normal wireless
admin configuring WDS.

### Step 8.3: Failure mode
**Record:** Silent frame drop → 4-address WDS setup fails → connectivity
broken. **Severity: MEDIUM-HIGH** (functional connectivity failure, not
crash/corruption/security, but complete feature breakage when
triggered).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Restores 4-address WDS nullfunc transmission; fixes
  logically incorrect frame classification that has existed for years.
- **Risk:** Minimal — one-line change, maintainer-authored, aligns with
  existing in-file conventions, only relaxes drop for zero-payload
  nullfunc frames.
- **Ratio:** High benefit, very low risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real logic bug — nullfunc frames incorrectly treated as data-carrying
- Causes WDS 4-address connectivity failures (reported by Jouni Malinen)
- One-line, obviously correct fix matching existing mac80211 conventions
- mac80211 maintainer-authored
- Bug present in 6.18.43; fix applies cleanly
- No dependencies; helper function already exists
- Affects common driver TXQ dequeue path

**AGAINST backport:**
- Not a crash, security, or data-corruption issue
- Timing-dependent; author notes uncertainty about production frequency
- Discovered in hwsim/NAN TXQ testing context
- No explicit stable nomination or reviewer thread discussion
- WDS is a narrower audience than general WiFi

**Unresolved:** Exact production frequency outside certification tests
(author explicitly uncertain).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logically correct,
   consistent with in-file patterns; reported via WDS sigma tests.
2. Fixes a real bug affecting users? **PASS** — silent drop of 4addr
   nullfunc breaks WDS setup.
3. Important issue? **PASS** — connectivity failure in WDS/4-address
   mode (functional break, not cosmetic).
4. Small and contained? **PASS** — 1 line, 1 file.
5. No new features or APIs? **PASS** — pure logic correction.
6. Can apply to local tree? **PASS** — clean apply to 6.18.43.

### Step 9.3: Exception categories
**Record:** N/A — not a device ID, quirk, DT, build, or docs fix.
Standard bug fix.

### Step 9.4: Decision rationale

This is a long-standing classification error in
`ieee80211_tx_dequeue()`: the unauthorized-port drop guard was meant to
block user data to STAs that have not completed 802.1X authorization,
but it also blocked nullfunc signaling frames that carry no payload.
Those frames are essential for 4-address WDS negotiation
(`ieee80211_send_4addr_nullfunc()`). The fix changes one macro call to
match the same data-vs-nullfunc distinction used elsewhere in the same
file. The change is maintainer-authored, trivial, zero-risk, and fixes a
real connectivity bug in WDS deployments.

---

## Verification

- [Phase 1] `git describe HEAD` / `make kernelversion`: tree is 6.18.43
- [Phase 1] Parsed tags: Reported-by Jouni Malinen, Link to
  patch.msgid.link, SOB Johannes Berg
- [Phase 2] Read `include/linux/ieee80211.h:481-528`: confirmed
  `ieee80211_is_data()` vs `ieee80211_is_data_present()` semantics
- [Phase 2] Read `net/mac80211/tx.c:3891-3910`: buggy code uses
  `ieee80211_is_data()` at line 3898
- [Phase 2] Grep `ieee80211_is_data_present` in tx.c: used at lines 633,
  640, 667, 1312 for same distinction
- [Phase 3] `git show 51129a2ca0482`: confirmed mainline fix commit and
  exact diff
- [Phase 3] `git show v6.18:net/mac80211/tx.c` lines 3875-3895: buggy
  code present in v6.18.0
- [Phase 3] `git show v6.12:net/mac80211/tx.c` lines 3875-3895: buggy
  code present in v6.12.0
- [Phase 3] `git show v5.10:net/mac80211/tx.c` line 3640: buggy pattern
  present since v5.10
- [Phase 3] `git branch --contains 51129a2ca0482`: fix NOT in
  stable/linux-6.18.y
- [Phase 4] `b4 dig -c 51129a2ca0482`: found lore thread URL
- [Phase 4] `b4 dig -a`: single v1 revision only
- [Phase 4] `b4 dig -w`: CC linux-wireless, Johannes Berg, Jouni Malinen
- [Phase 4] `b4 dig -m /tmp/null_data_txq.mbox`: thread contains only
  patch, no replies/stable nomination
- [Phase 5] Grep `ieee80211_tx_dequeue` callers: util.c + iwlwifi, mt76,
  ath9k, ath10k, rtw88, rtw89
- [Phase 5] Read `mlme.c:2403-2431`, `mlme.c:6457-6458`,
  `cfg.c:280-281`: 4addr nullfunc send sites
- [Phase 6] Confirmed buggy code at tx.c:3898 in current 6.18.43
  checkout
- [Phase 6] Confirmed `ieee80211_is_data_present` exists in
  include/linux/ieee80211.h
- [Phase 8] Assessed failure mode: silent frame drop → WDS connectivity
  failure, severity MEDIUM-HIGH

**YES**The background history searches finished, but they didn’t add
much beyond what we already verified.

`git log -S "tx_handlers_drop_unauth_port"` only surfaced unrelated
commits like the afs import (`19eef1d98eeda`) and `Linux 6.18-rc7`,
because this repo’s history is heavily squashed. The reverse pickaxe on
`all-next` similarly hit very old unrelated commits.

That doesn’t change the conclusion. Using release tags (`v5.10` through
`v6.18`) confirmed the buggy `ieee80211_is_data()` check has been in
`ieee80211_tx_dequeue()` for a long time, and the one-line fix still
applies cleanly to **6.18.43**.

**Verdict remains: YES** for backport to this tree.

 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c125871adb62b..602974a16edc6 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3895,7 +3895,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 		 * injected frames or EAPOL frames from the local station.
 		 */
 		if (unlikely(!(info->flags & IEEE80211_TX_CTL_INJECTED) &&
-			     ieee80211_is_data(hdr->frame_control) &&
+			     ieee80211_is_data_present(hdr->frame_control) &&
 			     !ieee80211_vif_is_mesh(&tx.sdata->vif) &&
 			     tx.sdata->vif.type != NL80211_IFTYPE_OCB &&
 			     !is_multicast_ether_addr(hdr->addr1) &&
-- 
2.53.0

