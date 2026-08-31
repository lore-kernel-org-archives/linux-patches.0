Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8689E584949;
	Mon, 31 Aug 2026 13:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184206; cv=none; b=DSoIcC9fPJhu1llJwDDiKIGonFkMbXYaOR7t9NEyT18KC7pqv3mRsLZLV+15TvfAxHPcnXMPh8DIrjB/DyTiBHx5Whw/MvvnkRjYCB7BXgeuoxK31faSJ837qnBe5KBnj8FJ6TCx7+bebMQJ6hSOM3FTaV46Y2j0FsztAIJyatM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184206; c=relaxed/simple;
	bh=4y03MqQclKP8jiIqOyJb40JHX+rL0b1xDEjpCRCms5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PNgmB78C3Dlp0YDYSr3AReMa4QNDv0RfpRbKQo6oVQ0v+BFe+7tbrmYB/Ot5MT6yM2l63SF1SRirb1CKt57esOXfA/Ndx/JzkTdHeDGLzgVFTb/NOE0EfyFYPQOtkCpkZ5TYpECchAcznPjnHgZvp/Md/t+0+LffChZ83OIwZSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g1UeJ6SM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g1UeJ6SM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C0F1F00ADE;
	Mon, 31 Aug 2026 13:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184203;
	bh=fXc9SvZzWsuRQJ4R+6xHP+5bAiTCqeAN3HTLReOWjjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g1UeJ6SMAGewV/g0ccrsiI9WNQ9Za1MMUU9DVctm6apXzlx1hB/l+aVnDXSDjkh4N
	 QvgaAOM3tu4ncCUg6rHdS4vcbEcudDnVQzOvq366W6IAHphDTJsU0LdsOnZhOCdcN+
	 LWAt3nE4/TQqKAJy/7avYheqcDs+6Y22nmtYfbU157k9/pw6XKoOCk4sAEfHfnDwcl
	 9vd6C4FKC59DyuYX27WgwsxigtTSeAOoBWgO9j1O9v7XRoQ42s8AhimbM6JlTV/UlF
	 wkdcjBzJ0UsMDkIfc+DHqzoLshCBfImV/eeXDEJ0TBl/ibZ3hIPPmyY+I2WHndIb/5
	 qK960JzLWCTGA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] wifi: cfg80211: validate assoc response length before status and IE access
Date: Mon, 31 Aug 2026 09:29:41 -0400
Message-ID: <20260831133314.4125787-553-sashal@kernel.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit b760113aeca2e9362d56bf9e9263373ffe6c8eb3 ]

cfg80211_rx_assoc_resp() initialises the status and response-IE fields
of cfg80211_connect_resp_params from the management frame before
proving that the frame is long enough for those offsets. S1G and
regular association responses also have different IE offsets, but the
S1G path only patched resp_ie after the unsafe initialiser had already
run.

Defer resp_ie, resp_ie_len, and status to after the link-iteration
loop. Use a bool to remember whether the frame is S1G, then validate
the appropriate minimum length and set all three fields in a single
if/else block. Funnel short-frame and SME-reject cleanup through a
shared free_bss label for the abandon paths.

Assisted-by: Codex:gpt-5.5
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260707025336.22557-2-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: cfg80211: validate assoc response
length before status and IE access`

**Local tree:** `v6.18.44-1-g2736c32da98b9` (kernel **6.18.44**)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[wifi: cfg80211]` **`validate`** — validate association-
response frame length before reading status code and IE fields in
`cfg80211_rx_assoc_resp()`.

### Step 1.2: Tags
**Record:**
- **Assisted-by:** Codex:gpt-5.5, Claude:claude-opus-4.8
- **Signed-off-by:** Zhao Li \<enderaoelyther@gmail.com\>
- **Link:** https://patch.msgid.link/20260707025336.22557-2-
  enderaoelyther@gmail.com
- **Signed-off-by:** Johannes Berg \<johannes.berg@intel.com\> (cfg80211
  maintainer)
- **No** Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, Cc:
  stable@
- **Notable:** Maintainer sign-off; part of v2 3-patch series (this is
  patch 2/3)

### Step 1.3: Body analysis
**Record:**
- **Bug:** `cfg80211_rx_assoc_resp()` sets `status`, `resp_ie`, and
  `resp_ie_len` from the management frame before verifying `data->len`
  is large enough.
- **S1G nuance:** S1G and regular assoc responses use different IE
  offsets; the S1G branch only corrected `resp_ie` after the unsafe
  initializer had already run.
- **Symptom:** Out-of-bounds reads on short/malformed association-
  response buffers passed into an exported cfg80211 callback.
- **Fix approach:** Defer those three fields until after the link loop;
  record S1G with a bool; validate minimum length per frame type;
  consolidate BSS cleanup under `free_bss`.
- **Version info:** None stated in commit message.

### Step 1.4: Hidden bug fix?
**Record:** **Yes** — despite “validate” wording, this is a concrete
memory-safety fix (OOB read + unsigned underflow on `resp_ie_len`), not
cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `net/wireless/mlme.c` only (~35 insertions, ~21 deletions)
- **Function modified:** `cfg80211_rx_assoc_resp()`
- **Scope:** Single-file, surgical fix in one exported function

### Step 2.2: Code flow per hunk
**Record:**
1. **Struct initializer:** Before — reads `mgmt->u.assoc_resp.variable`,
   computes `resp_ie_len`, reads `status_code` immediately. After — only
   safe fields initialized; `is_s1g = false` added.
2. **S1G link loop:** Before — overwrites `resp_ie`/`resp_ie_len` for
   S1G. After — sets `is_s1g = true` only.
3. **Post-loop validation (new):** Checks `data->len` against
   `offsetof(..., u.s1g_assoc_resp.variable)` (28) or `offsetof(...,
   u.assoc_resp.variable)` (30); on failure `goto free_bss`. Then sets
   `resp_ie`, `resp_ie_len`, `status`.
4. **SME-reject path:** Before — duplicated BSS cleanup loop. After —
   `goto free_bss` shared label; same
   `cfg80211_unhold_bss`/`cfg80211_put_bss` behavior.

### Step 2.3: Bug mechanism
**Record:** **Memory safety / bounds validation**
- **OOB read:** `le16_to_cpu(mgmt->u.assoc_resp.status_code)` at offset
  26 requires `len >= 28`; no check existed.
- **Unsigned underflow:** `resp_ie_len = data->len - offsetof(...,
  variable)` wraps to a huge value when `data->len < offsetof`,
  affecting `nlmsg_new()` sizing and `nla_put()` copies downstream.
- **S1G partial fix gap:** S1G IE offset differs (28 vs 30), but unsafe
  initializer always ran first.

### Step 2.4: Fix quality
**Record:** Obviously correct; minimal; mirrors existing kernel
`offsetof` length-guard patterns. **Regression risk:** Low — only adds
early returns on frames that were already malformed; BSS cleanup
preserved via `free_bss`.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy lines in current tree all trace to `5d324e5159d9e` in
this checkout’s shallow history (merge root). The unsafe initializer
pattern is present in `net/wireless/mlme.c` as checked out.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related file history
**Record:** Only two commits touch `net/wireless/mlme.c` in this tree
(`5d324e5159d9e`, `c3ab9657866fc` radar fix). This patch is
**standalone** (patch 2/3 of a series; does not depend on patch 1/3 for
assoc_resp logic).

### Step 3.4: Author context
**Record:** Zhao Li submitted the series; **Johannes Berg** (cfg80211
maintainer) signed off. v2 changelog notes revision per Johannes’ review
on patch 1.

### Step 3.5: Prerequisites
**Record:** **None required** for this hunk. Patch applies to current
`mlme.c` without structural dependencies. Local tree lacks
`assoc_encrypted` field present in some newer trees — mbox patch matches
local tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** Local mbox `v2_20260707_enderaoelyther_wifi_cfg80211_validat
e_rx_tx_mlme_callback_frame_lengths_before_access.mbx` contains v2
series. `b4 mbox` on patch 2 msgid returned only the patch itself (no
review replies in cached thread). lore.kernel.org blocked by bot
protection.

### Step 4.2: Reviewers
**Record:** Johannes Berg reviewed v2 series (noted in patch 1
changelog). Maintainer sign-off on this commit confirmed.

### Step 4.3: Bug reports
**Record:** No syzbot, bugzilla, or user Reported-by tags. Series patch
1 documents concrete mwifiex short-frame path for **different**
functions (`cfg80211_rx_mlme_mgmt`), not this one.

### Step 4.4: Related patches
**Record:** 3-patch series:
1. `cfg80211_rx_mlme_mgmt` / `cfg80211_tx_mlme_mgmt` length validation
2. **This commit** — `cfg80211_rx_assoc_resp`
3. `ieee80211_rx_mgmt_deauth` length validation in mac80211

Each is independently backportable.

### Step 4.5: Stable list history
**Record:** Could not search lore stable list (bot protection). No
stable nomination found in local mbox.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `cfg80211_rx_assoc_resp()` (modified)

### Step 5.2: Callers
**Record:**
- `net/mac80211/mlme.c` — primary path; validates `len < 24 + 6`
  (returns early) before calling
- `drivers/net/wireless/marvell/mwifiex/cmdevt.c` —
  `mwifiex_process_assoc_resp()` calls directly with
  `priv->assoc_rsp_buf` / `priv->assoc_rsp_size` (no equivalent length
  gate)

### Step 5.3: Callees
**Record:** `cfg80211_sme_rx_assoc_resp()`,
`trace_cfg80211_send_rx_assoc()`, `nl80211_send_rx_assoc()`,
`__cfg80211_connect_result()`, `cfg80211_unhold_bss()`,
`cfg80211_put_bss()`

### Step 5.4: Reachability
**Record:** **Yes** — exported `EXPORT_SYMBOL` callback invoked from
driver association-completion path during WiFi connect. Malicious or
buggy firmware/driver can supply short buffers. Downstream
`nl80211_send_connect_result()` uses `cr->resp_ie_len` in `nlmsg_new()`
and `nla_put()`.

### Step 5.5: Similar patterns
**Record:** Same series adds identical length-guard pattern to
`cfg80211_rx_mlme_mgmt()` and mac80211 deauth handler — systematic fix
for cfg80211 MLME frame parsing.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **Yes** — current `net/wireless/mlme.c` lines 35–39
initialize `resp_ie`, `resp_ie_len`, and `status` before any length
check; S1G branch at 61–66 partially adjusts `resp_ie` only.

### Step 6.2: Backport complications
**Record:** **Clean apply expected** — all patch anchor strings verified
present in local file; no `assoc_encrypted` mismatch.

### Step 6.3: Related fixes already present?
**Record:** **No** — `git log --grep` found no equivalent validation
commit for this function in this tree.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **net/wireless (cfg80211)** — IMPORTANT/CORE for WiFi;
affects all cfg80211 users.

### Step 7.2: Activity
**Record:** Active in 6.18 (MLO, S1G link handling in
`cfg80211_rx_assoc_resp`).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** WiFi station connect paths using cfg80211 — especially
drivers calling `cfg80211_rx_assoc_resp()` directly (mwifiex confirmed
in-tree).

### Step 8.2: Trigger conditions
**Record:** Association-response buffer shorter than minimum fixed-field
size passed to `cfg80211_rx_assoc_resp()`. mac80211 mitigates its own
path (`len >= 30`), but exported API has no such guard. Trigger is
plausible with misbehaving firmware/drivers, not merely theoretical
given documented similar mwifiex issues in the same series.

### Step 8.3: Failure mode severity
**Record:** OOB read of frame fields; `resp_ie_len` underflow →
oversized netlink allocation / OOB `nla_put` copy. **Severity: HIGH**
(kernel crash or memory corruption during WiFi association).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH — closes real bounds-check hole in exported cfg80211
  API
- **Risk:** LOW — small, localized, adds defensive validation only
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real memory-safety bug in exported cfg80211 function
- Driver (mwifiex) calls API without mac80211’s length guard
- Downstream code uses `resp_ie_len` in allocations/copies
- Small, maintainer-reviewed, self-contained fix
- Buggy code confirmed present in 6.18.44 tree
- Clean apply expected

**AGAINST backport:**
- mac80211 primary path already checks `len >= 30`
- No syzbot/user crash report attached to this specific patch
- Full series context suggests defense-in-depth across MLME handlers

**Unresolved:**
- Exact upstream commit SHA not in this checkout (fix not yet merged
  here)
- Full lore review thread not accessible (bot protection)
- Historical introduction date of bug not determinable in shallow
  history

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is straightforward;
   maintainer SOB; v2 reviewed
2. Fixes real bug affecting users? **PASS** — OOB read on exported WiFi
   connect callback
3. Important issue? **PASS** — crash/memory corruption potential (HIGH)
4. Small and contained? **PASS** — ~56 lines, one function, one file
5. No new features/APIs? **PASS** — validation only
6. Can apply to local tree? **PASS** — buggy code present; anchors match

### Step 9.3: Exception categories
**Record:** N/A (not device ID/quirk/build/docs); standard bug-fix
exception applies.

### Step 9.4: Decision rationale
This patch closes a genuine bounds-checking hole in
`cfg80211_rx_assoc_resp()`, an exported function on a common WiFi
connect path. Short frames can cause out-of-bounds reads and
`resp_ie_len` underflow before any validation. While mac80211 validates
length on its call path, mwifiex calls the API directly without
equivalent checks. The fix is small, maintainer-signed, and applies
cleanly to this 6.18.44 tree.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit
  message and local mbox
- **[Phase 2]** Diff analysis against user-provided diff and current
  `net/wireless/mlme.c`
- **[Phase 2]** Computed offsets: status at 26 (needs len≥28), assoc
  variable at 30, S1G variable at 28
- **[Phase 3]** `git blame -L 31,67 net/wireless/mlme.c`: buggy lines
  present
- **[Phase 3]** `git log --oneline -20 -- net/wireless/mlme.c`: shallow
  history noted
- **[Phase 3]** `git log --grep`: no duplicate fix found
- **[Phase 4]** Read local mbox series file; patch 2/3 identified as
  standalone
- **[Phase 4]** `b4 mbox` on msgid: saved single-message thread
- **[Phase 4]** lore.kernel.org fetch: blocked (bot protection) —
  **UNVERIFIED** for full thread/stable discussion
- **[Phase 5]** `grep cfg80211_rx_assoc_resp(`: callers in mac80211,
  mwifiex
- **[Phase 5]** Read mac80211 caller: `if (len < 24 + 6) return;` at
  line 6521
- **[Phase 5]** Read mwifiex `cmdevt.c`: direct call without length
  validation
- **[Phase 5]** Read `nl80211_send_connect_result()`: uses
  `cr->resp_ie_len` in `nlmsg_new` and `nla_put`
- **[Phase 6]** `git describe HEAD`: v6.18.44-1-g2736c32da98b9; `make
  kernelversion`: 6.18.44
- **[Phase 6]** Read current `mlme.c` lines 24–97: pre-fix buggy code
  confirmed
- **[Phase 6]** Python anchor check: all patch target strings FOUND
- **[Phase 8]** Failure mode: OOB read + unsigned underflow → HIGH
  severity

**YES**

 net/wireless/mlme.c | 56 ++++++++++++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 21 deletions(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 3fc175f9f8686..bf2c0d26e11c6 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -32,14 +32,10 @@ void cfg80211_rx_assoc_resp(struct net_device *dev,
 		.timeout_reason = NL80211_TIMEOUT_UNSPECIFIED,
 		.req_ie = data->req_ies,
 		.req_ie_len = data->req_ies_len,
-		.resp_ie = mgmt->u.assoc_resp.variable,
-		.resp_ie_len = data->len -
-			       offsetof(struct ieee80211_mgmt,
-					u.assoc_resp.variable),
-		.status = le16_to_cpu(mgmt->u.assoc_resp.status_code),
 		.ap_mld_addr = data->ap_mld_addr,
 	};
 	unsigned int link_id;
+	bool is_s1g = false;
 
 	for (link_id = 0; link_id < ARRAY_SIZE(data->links); link_id++) {
 		cr.links[link_id].status = data->links[link_id].status;
@@ -60,16 +56,32 @@ void cfg80211_rx_assoc_resp(struct net_device *dev,
 
 		if (cr.links[link_id].bss->channel->band == NL80211_BAND_S1GHZ) {
 			WARN_ON(link_id);
-			cr.resp_ie = (u8 *)&mgmt->u.s1g_assoc_resp.variable;
-			cr.resp_ie_len = data->len -
-					 offsetof(struct ieee80211_mgmt,
-						  u.s1g_assoc_resp.variable);
+			is_s1g = true;
 		}
 
 		if (cr.ap_mld_addr)
 			cr.valid_links |= BIT(link_id);
 	}
 
+	if (is_s1g) {
+		if (data->len < offsetof(struct ieee80211_mgmt,
+					 u.s1g_assoc_resp.variable))
+			goto free_bss;
+		cr.resp_ie = (u8 *)&mgmt->u.s1g_assoc_resp.variable;
+		cr.resp_ie_len = data->len -
+				 offsetof(struct ieee80211_mgmt,
+					  u.s1g_assoc_resp.variable);
+	} else {
+		if (data->len < offsetof(struct ieee80211_mgmt,
+					 u.assoc_resp.variable))
+			goto free_bss;
+		cr.resp_ie = mgmt->u.assoc_resp.variable;
+		cr.resp_ie_len = data->len -
+				 offsetof(struct ieee80211_mgmt,
+					  u.assoc_resp.variable);
+	}
+	cr.status = le16_to_cpu(mgmt->u.assoc_resp.status_code);
+
 	trace_cfg80211_send_rx_assoc(dev, data);
 
 	/*
@@ -78,22 +90,24 @@ void cfg80211_rx_assoc_resp(struct net_device *dev,
 	 * and got a reject -- we only try again with an assoc
 	 * frame instead of reassoc.
 	 */
-	if (cfg80211_sme_rx_assoc_resp(wdev, cr.status)) {
-		for (link_id = 0; link_id < ARRAY_SIZE(data->links); link_id++) {
-			struct cfg80211_bss *bss = data->links[link_id].bss;
-
-			if (!bss)
-				continue;
-
-			cfg80211_unhold_bss(bss_from_pub(bss));
-			cfg80211_put_bss(wiphy, bss);
-		}
-		return;
-	}
+	if (cfg80211_sme_rx_assoc_resp(wdev, cr.status))
+		goto free_bss;
 
 	nl80211_send_rx_assoc(rdev, dev, data);
 	/* update current_bss etc., consumes the bss reference */
 	__cfg80211_connect_result(dev, &cr, cr.status == WLAN_STATUS_SUCCESS);
+	return;
+
+free_bss:
+	for (link_id = 0; link_id < ARRAY_SIZE(data->links); link_id++) {
+		struct cfg80211_bss *bss = data->links[link_id].bss;
+
+		if (!bss)
+			continue;
+
+		cfg80211_unhold_bss(bss_from_pub(bss));
+		cfg80211_put_bss(wiphy, bss);
+	}
 }
 EXPORT_SYMBOL(cfg80211_rx_assoc_resp);
 
-- 
2.53.0

