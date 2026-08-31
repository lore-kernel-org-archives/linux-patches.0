Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5858950EC16;
	Mon, 31 Aug 2026 13:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183777; cv=none; b=qKz5i7s4ykvOnOEG2u0O499rVKCnsnzBz9DmbsCBicesDV7wYLtDT9Ge7e0G03xuU1Pr1ZKf9D7D/gdziCyF2MjtQkGp0F629p+qIZOHkoFP+fvz9JmUv0B5K06/yUcIghcStpqFxReH/DRkgx6oUenzuPI4DC0dqHw8VU7DQ0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183777; c=relaxed/simple;
	bh=txbjspL3j+vfyy7AjhKqpUMyMxG+nvfadGtyliGr+X4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AJcEEXvgtkxAJFUiH7DlXH5o+0HGTNHC77dhE6r/CBXUlL7Oxry1CUOPzyzj6pFSqnqdh1/nH0zdRDWFs4/E2TYZ0Ztaur0/3gi9oTZlXrFCIT0iHhrGy8myB3SvaheUbrUNzklSjrCkeNpAJjWXDHXKF1UbQbUiOM5b56MPLys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fsPrdVRO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fsPrdVRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136461F00A3E;
	Mon, 31 Aug 2026 13:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183774;
	bh=H/fuKbVRiiS/rbnkO4StakLav2Idmq2e4vdO0y5qkuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fsPrdVROUVRPg+TSAttLRUmjTSEdY6ENsmKQSgoAhLTBx6kanR+UX5PMwSCbtQF9T
	 Ob+nc7iUm1E6jn0vATmky7obSmhTg/CIKR7W4UhhbG1T1f2k8aGZ2GkcJWoMq1BzBj
	 JrkkDx9dfwxW7CO3/oug4rZbdRnJIYdMDpP3hqW4p0oDtxqsnMXkZjsBO6OUT1tyBv
	 wNDAp3WA15/2wzcI2ECusHIUvwgkntd/ZQOvSX+0N07vrgpiOIsAMaKp0uGZIvwTsi
	 RZc4+6fajDvKxgk/1oBfCsGY4GxgHlzx4/wr2uEEMpeGFVIkkTv4aOvoFA9j5QXvc4
	 evG2aKtn7DK/Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] wifi: cfg80211: validate rx/tx MLME callback frame lengths before access
Date: Mon, 31 Aug 2026 09:25:24 -0400
Message-ID: <20260831133314.4125787-296-sashal@kernel.org>
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

[ Upstream commit d5e4586546974179feca305a94e07fac3e9727fe ]

cfg80211_rx_mlme_mgmt() and cfg80211_tx_mlme_mgmt() call tracepoints
before rejecting frames shorter than the frame-control field. After
that, they only require len >= 2 before dispatching into subtype
handlers that assume their fixed fields are present.

The frames that trip this are not shorter than 2 bytes; they are short
relative to their subtype. mwifiex is a concrete in-tree example on the
length side: mwifiex_process_mgmt_packet() only requires a 4-address
ieee80211_hdr plus the 2-byte firmware length prefix before handing the
frame to cfg80211_rx_mlme_mgmt(). After stripping the length prefix and
removing addr4, pkt_len can be exactly 24: a bare 3-address management
header with no reason-code body. The existing WARN_ON(len < 2) does not
fire on such a frame, and cfg80211_process_deauth() then reads
u.deauth.reason_code as a two-byte access starting at offset 24,
immediately past the 24-byte buffer.

Add a frame-control length gate, then validate each subtype's minimum
frame size in an if/else-if chain that mirrors the dispatch logic. Trace
only after the frame is known to be well-formed.

Side effects of this change:
 - The WARN_ON(len < 2) is dropped. It only guarded the frame_control
   read, never the subtype fixed fields, and it does not fire on the
   frames that actually trigger the out-of-bounds read (which are >= 2).
   The len >= 2 check is kept as the guard before dereferencing
   frame_control, but without the warning: these are exported callbacks
   and a malformed frame from a driver should be dropped silently rather
   than backtraced.
 - cfg80211_tx_mlme_mgmt() previously routed every non-deauth subtype
   through disassociation handling; it now silently ignores unrecognised
   subtypes.

Assisted-by: Codex:gpt-5.5
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260707025336.22557-1-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: cfg80211: validate rx/tx MLME
callback frame lengths before access`

**Local tree:** `v6.18.44-1-g2736c32da98b9` (Linux **6.18.44**)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[wifi: cfg80211]` `[validate]` — Add length validation for
rx/tx MLME callback frames before accessing fixed subtype fields.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Link:** `https://patch.msgid.link/20260707025336.22557-1-
  enderaoelyther@gmail.com`
- **Assisted-by:** Codex:gpt-5.5, Claude:claude-opus-4.8
- **Signed-off-by:** Zhao Li `<enderaoelyther@gmail.com>`
- **Signed-off-by:** Johannes Berg `<johannes.berg@intel.com>`
  (cfg80211/mac80211 maintainer)
- **No** Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, Cc:
  stable@vger.kernel.org
- **Notable:** Maintainer sign-off; v2 series (patch 1/3) with Johannes
  Berg review noted in cover letter changelog

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** `cfg80211_rx_mlme_mgmt()` and `cfg80211_tx_mlme_mgmt()` only
  check `len >= 2` before dispatching to subtype handlers that read
  fixed fields (`reason_code`, `status_code`, etc.)
- **Symptom:** Out-of-bounds 2-byte read at offset 24 when a 24-byte
  management header (no body) is passed for deauth/disassoc
- **Concrete trigger:** `mwifiex_process_mgmt_packet()` can pass
  `pkt_len == 24` after stripping addr4 from a minimal 4-address frame
- **Root cause:** Validation guards frame_control (2 bytes) but not per-
  subtype minimum sizes (26 bytes for deauth/disassoc)
- **Version info:** None explicit in message

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not disguised — explicitly fixes out-of-bounds memory
access. The WARN_ON removal and tx subtype routing change are documented
side effects of the safety fix.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **File:** `net/wireless/mlme.c` only (+37 / -8 lines)
- **Functions modified:** `cfg80211_rx_mlme_mgmt()`,
  `cfg80211_tx_mlme_mgmt()`
- **Scope:** Single-file surgical fix

### Step 2.2: CODE FLOW CHANGE
**Record:**

**`cfg80211_rx_mlme_mgmt()` — before → after:**
- Before: trace → `WARN_ON(len < 2)` → dispatch by subtype → handlers
  read fixed fields
- After: check `len >= sizeof(fc)` → read `fc` → per-subtype
  `offsetofend()` validation → trace → dispatch
- Affected path: RX MLME frames from drivers (notably mwifiex host_mlme)

**`cfg80211_tx_mlme_mgmt()` — before → after:**
- Before: trace → `WARN_ON(len < 2)` → deauth or **everything else →
  disassoc**
- After: validate deauth/disassoc minimum lengths; unknown subtypes
  silently dropped
- Affected path: TX disconnect notifications from mac80211/mwifiex

### Step 2.3: BUG MECHANISM
**Record:**
- **Category:** Buffer overflow / out-of-bounds read (memory safety)
- **Mechanism:** `cfg80211_process_deauth()` reads
  `mgmt->u.deauth.reason_code` at offset 24–25:

```109:116:net/wireless/mlme.c
static void cfg80211_process_deauth(struct wireless_dev *wdev,
                                    const u8 *buf, size_t len,
                                    bool reconnect)
{
        ...
        u16 reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
```

  Minimum valid deauth frame is 26 bytes (`IEEE80211_DEAUTH_FRAME_LEN`).
A 24-byte buffer causes a read 2 bytes past the end.

### Step 2.4: FIX QUALITY
**Record:**
- Fix is obviously correct: mirrors dispatch logic with `offsetofend()`
  checks, same pattern used elsewhere in ieee80211 code
- Minimal and surgical
- Low regression risk: only rejects malformed frames that were already
  unsafe to process
- Moving tracepoints after validation is correct
- tx path fix for unrecognized subtypes prevents wrongly routing auth
  frames to disassoc handler

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:** All lines in `cfg80211_rx_mlme_mgmt()` /
`cfg80211_tx_mlme_mgmt()` blame to `5d324e5159d9e` (6.18 merge base in
this tree). Buggy insufficient-length check has been present since these
functions landed in this tree.

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** No Fixes: tag present. N/A.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:**
- Recent `mlme.c` commits: `c3ab9657866fc` (radar detection fix), merge
  base
- This fix is **not** yet in the local tree (buggy code still present at
  lines 149–167, 213–230)
- Part of v2 3-patch series; **this commit is standalone** for the two
  cfg80211 callback functions (patches 2/3 fix `cfg80211_rx_assoc_resp`
  and `ieee80211_rx_mgmt_deauth` separately)

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** Zhao Li is not a regular mlme.c contributor in this tree.
Johannes Berg (maintainer) signed off and merged.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:** No prerequisites. Uses standard `offsetofend(struct
ieee80211_mgmt, ...)` which exists in this tree. Applies cleanly against
current `net/wireless/mlme.c`.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: ORIGINAL PATCH DISCUSSION
**Record:**
- Local mbox: `v2_20260707_enderaoelyther_wifi_cfg80211_validate_rx_tx_m
  lme_callback_frame_lengths_before_access.mbx`
- v2 changelog documents Johannes Berg review feedback (commit message
  rewrite)
- lore.kernel.org blocked by Anubis bot protection; `b4 dig -c` could
  not be run (commit not in local tree)
- No review replies in local mbox (patches only)

### Step 4.2: WHO REVIEWED THE PATCH
**Record:** Johannes Berg reviewed v1 per v2 changelog ("Per Johannes'
review"). Maintainer Signed-off-by on committed version.

### Step 4.3: BUG REPORT
**Record:** No external bug report or syzbot link. Bug identified via
static/code-path analysis with concrete mwifiex trigger documented by
author.

### Step 4.4: RELATED PATCHES AND SERIES
**Record:** 3-patch v2 series:
1. **This commit** — cfg80211 rx/tx MLME callbacks
2. `cfg80211_rx_assoc_resp()` length validation
3. `ieee80211_rx_mgmt_deauth()` read-before-check fix in mac80211

Patches 2/3 are related but **not required** for this commit to be
correct and self-contained.

### Step 4.5: STABLE MAILING LIST HISTORY
**Record:** Could not search lore (blocked). No stable nomination found
in local mbox.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: KEY FUNCTIONS
**Record:** `cfg80211_rx_mlme_mgmt()`, `cfg80211_tx_mlme_mgmt()`,
callees `cfg80211_process_auth/deauth/disassoc()`

### Step 5.2: TRACE CALLERS
**Record:**

| Caller | File | Notes |
|--------|------|-------|
| `ieee80211_report_disconnect()` | `net/mac80211/mlme.c:4547-4549` |
Always uses `IEEE80211_DEAUTH_FRAME_LEN` (26) buffers |
| Auth failure paths | `net/mac80211/mlme.c:4878,4944,5045` | mac80211
validates before calling |
| `mwifiex_process_mgmt_packet()` | `drivers/.../mwifiex/util.c:482` |
**Can pass pkt_len == 24** |
| `mwifiex_host_mlme_disconnect()` | `mwifiex/util.c:385` | Passes 26
bytes (safe) |

### Step 5.3: TRACE CALLEES
**Record:** Subtype handlers call `nl80211_send_*`, `cfg80211_sme_*`,
read `reason_code`/`status_code` from frame body.

### Step 5.4: CALL CHAIN / REACHABILITY
**Record:**
1. WiFi firmware delivers management frame to mwifiex
2. `mwifiex_process_mgmt_packet()` strips 4-addr header → 24-byte 3-addr
   frame
3. If `host_mlme_reg` and deauth/disassoc: calls
   `cfg80211_rx_mlme_mgmt(dev, skb->data, 24)`
4. `cfg80211_process_deauth()` reads past buffer end

**Reachable from userspace indirectly:** Malicious or buggy AP/firmware
can send short deauth/disassoc frames to mwifiex clients with host MLME
enabled. Config-dependent (`CONFIG_MWIFIEX`, host_mlme firmware
capability).

### Step 5.5: SIMILAR PATTERNS
**Record:** mac80211's `ieee80211_rx_mgmt_deauth()` has the same read-
before-check pattern (reads `reason_code` before `len` check at line
5011 vs 5015) — fixed in patch 3/3 of the series, separate from this
commit.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST?
**Record:** **YES.** Current tree at `net/wireless/mlme.c:149-167` and
`213-230` has the insufficient `WARN_ON(len < 2)` check. mwifiex trigger
path exists at `util.c:398-482`.

Verified minimum frame math:
- `ieee80211_mgmt` header = 24 bytes
- `u.deauth.reason_code` ends at byte 26
- mwifiex minimum after addr4 strip: `sizeof(ieee80211_hdr)` (30) −
  `ETH_ALEN` (6) = **24 bytes**

### Step 6.2: BACKPORT COMPLICATIONS
**Record:** Clean apply expected. Diff in local mbox matches current
file structure. No conflicting recent changes to these functions.

### Step 6.3: RELATED FIXES ALREADY PRESENT?
**Record:** **No.** `git log --grep` and `-S 'offsetofend(struct
ieee80211_mgmt, u.deauth.reason_code)'` found no matching fix in this
tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: SUBSYSTEM AND CRITICALITY
**Record:** `net/wireless` (cfg80211) — **CORE/IMPORTANT**. cfg80211 is
the central wireless configuration API used by all mac80211 drivers and
several fullmac drivers.

### Step 7.2: SUBSYSTEM ACTIVITY
**Record:** Actively maintained; recent stable backport `c3ab9657866fc`
in this tree.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: WHO IS AFFECTED
**Record:** Users of WiFi drivers calling `cfg80211_rx_mlme_mgmt()` /
`cfg80211_tx_mlme_mgmt()`. Primary concrete trigger: **mwifiex with host
MLME** (several SDIO device tables set `host_mlme = true`). mac80211
callers are generally safe due to `IEEE80211_DEAUTH_FRAME_LEN` usage.

### Step 8.2: TRIGGER CONDITIONS
**Record:**
- Receiving deauth/disassoc/auth frame with header only (no body) via
  mwifiex host_mlme path
- Requires connected state and matching BSSID checks in mwifiex
- Not every boot, but plausible with malformed AP traffic or firmware
  quirks
- Unprivileged remote trigger via WiFi network (AP sends short frame)

### Step 8.3: FAILURE MODE SEVERITY
**Record:** Out-of-bounds kernel memory read — **HIGH** severity
- KASAN: detectable crash
- Production without KASAN: potential info leak or unpredictable
  behavior
- Not a typical controlled write primitive, but real memory safety bug
  in core wireless path

### Step 8.4: RISK-BENEFIT RATIO
**Record:**
- **Benefit:** HIGH — prevents OOB read in exported cfg80211 API;
  defense-in-depth for all drivers
- **Risk:** LOW — ~37 lines, validation-only, maintainer-reviewed
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: EVIDENCE COMPILED

**FOR backport:**
- Real out-of-bounds read verified in code and frame-size math
- Concrete in-tree trigger path (mwifiex host_mlme, 24-byte frames)
- Small, surgical, maintainer-signed fix
- Buggy code confirmed present in 6.18.44 tree
- Fixes incorrect tx subtype routing (non-deauth → disassoc) that could
  cause same class of bug
- Exported API should validate inputs from drivers

**AGAINST backport:**
- No syzbot report or user crash report (theoretical/code-analysis
  discovery)
- Trigger requires specific driver config (mwifiex host_mlme)
- Related bugs in patches 2/3 not included (but separate functions)

**UNRESOLVED:**
- Full lore review thread (blocked by Anubis)
- Whether any reviewer explicitly nominated for stable

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — standard offsetofend
   validation; maintainer reviewed v2
2. Fixes a real bug? **PASS** — verified OOB read with mwifiex trigger
   path
3. Important issue? **PASS** — kernel memory safety (OOB read), HIGH
   severity
4. Small and contained? **PASS** — 1 file, ~37 lines
5. No new features or APIs? **PASS** — validation only
6. Can apply to local tree? **PASS** — code present, clean apply
   expected

### Step 9.3: EXCEPTION CATEGORIES
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
memory-safety bug fix.

### Step 9.4: DECISION RATIONALE

This commit fixes a verified out-of-bounds read in exported cfg80211
MLME callbacks. The buggy code exists in Linux 6.18.44, the fix is small
and maintainer-approved, and a concrete in-tree caller (mwifiex
host_mlme) can trigger it with 24-byte deauth/disassoc frames. While the
trigger is config-specific, cfg80211 is a core API that should reject
malformed driver input — making this appropriate for the 6.18.y stable
tree.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user query and local
  mbox
- **[Phase 2]** Read current `net/wireless/mlme.c:109-167,213-230`;
  confirmed OOB read at `reason_code` with 24-byte buffer
- **[Phase 2]** Computed frame sizes: header=24, deauth offsetofend=26,
  auth offsetofend=30
- **[Phase 3]** `git describe HEAD`: v6.18.44; `git blame`: buggy code
  at 5d324e5159d9e
- **[Phase 3]** `git log --grep` / `-S offsetofend`: fix not in tree
- **[Phase 4]** Read local mbox `v2_20260707_enderaoelyther_*.mbx`; v2
  Johannes Berg review noted
- **[Phase 4]** lore.kernel.org fetch: blocked (Anubis)
- **[Phase 4]** `b4 dig -c`: not attempted (commit not in tree)
- **[Phase 5]** `grep cfg80211_rx_mlme_mgmt`: callers in mac80211 (safe,
  26-byte) and mwifiex (unsafe path at util.c:482)
- **[Phase 5]** Read `mwifiex/util.c:398-482`: verified pkt_len can be
  24 after addr4 removal
- **[Phase 5]** Read `ieee80211.h:1162-1207`: confirmed struct layout
- **[Phase 5]** `IEEE80211_DEAUTH_FRAME_LEN` = 26 in
  `net/mac80211/ieee80211_i.h:85`
- **[Phase 6]** Buggy code confirmed present; fix absent
- **[Phase 6]** `sizeof(struct ieee80211_hdr)` = 30 (includes addr4);
  30−6=24 minimum after strip
- **[Phase 8]** Failure mode: OOB read, HIGH severity

**YES**The background `git log -S 'cfg80211_rx_mlme_mgmt'` search
finished. In this 6.18.44 tree it only surfaced merge commits — notably
`5d324e5159d9e` — and `git blame` attributes the current
`cfg80211_rx_mlme_mgmt()` / `cfg80211_tx_mlme_mgmt()` code to that same
point. That’s enough to confirm the buggy validation has been present
since these functions landed here; it doesn’t change the backport call.

**Verdict for this tree: YES** — the out-of-bounds read in cfg80211 MLME
callbacks is real, reachable via mwifiex host_mlme with 24-byte frames,
and the fix is small and maintainer-reviewed.

 net/wireless/mlme.c | 45 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 8 deletions(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index bf2c0d26e11c6..a304c0e8736f6 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -164,19 +164,35 @@ void cfg80211_rx_mlme_mgmt(struct net_device *dev, const u8 *buf, size_t len)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct ieee80211_mgmt *mgmt = (void *)buf;
+	__le16 fc;
 
 	lockdep_assert_wiphy(wdev->wiphy);
 
-	trace_cfg80211_rx_mlme_mgmt(dev, buf, len);
+	if (len < sizeof(fc))
+		return;
+
+	fc = mgmt->frame_control;
 
-	if (WARN_ON(len < 2))
+	if (ieee80211_is_auth(fc)) {
+		if (len < offsetofend(struct ieee80211_mgmt, u.auth.status_code))
+			return;
+	} else if (ieee80211_is_deauth(fc)) {
+		if (len < offsetofend(struct ieee80211_mgmt, u.deauth.reason_code))
+			return;
+	} else if (ieee80211_is_disassoc(fc)) {
+		if (len < offsetofend(struct ieee80211_mgmt, u.disassoc.reason_code))
+			return;
+	} else {
 		return;
+	}
+
+	trace_cfg80211_rx_mlme_mgmt(dev, buf, len);
 
-	if (ieee80211_is_auth(mgmt->frame_control))
+	if (ieee80211_is_auth(fc))
 		cfg80211_process_auth(wdev, buf, len);
-	else if (ieee80211_is_deauth(mgmt->frame_control))
+	else if (ieee80211_is_deauth(fc))
 		cfg80211_process_deauth(wdev, buf, len, false);
-	else if (ieee80211_is_disassoc(mgmt->frame_control))
+	else
 		cfg80211_process_disassoc(wdev, buf, len, false);
 }
 EXPORT_SYMBOL(cfg80211_rx_mlme_mgmt);
@@ -229,15 +245,28 @@ void cfg80211_tx_mlme_mgmt(struct net_device *dev, const u8 *buf, size_t len,
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct ieee80211_mgmt *mgmt = (void *)buf;
+	__le16 fc;
 
 	lockdep_assert_wiphy(wdev->wiphy);
 
-	trace_cfg80211_tx_mlme_mgmt(dev, buf, len, reconnect);
+	if (len < sizeof(fc))
+		return;
 
-	if (WARN_ON(len < 2))
+	fc = mgmt->frame_control;
+
+	if (ieee80211_is_deauth(fc)) {
+		if (len < offsetofend(struct ieee80211_mgmt, u.deauth.reason_code))
+			return;
+	} else if (ieee80211_is_disassoc(fc)) {
+		if (len < offsetofend(struct ieee80211_mgmt, u.disassoc.reason_code))
+			return;
+	} else {
 		return;
+	}
+
+	trace_cfg80211_tx_mlme_mgmt(dev, buf, len, reconnect);
 
-	if (ieee80211_is_deauth(mgmt->frame_control))
+	if (ieee80211_is_deauth(fc))
 		cfg80211_process_deauth(wdev, buf, len, reconnect);
 	else
 		cfg80211_process_disassoc(wdev, buf, len, reconnect);
-- 
2.53.0

