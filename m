Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88651632F1B;
	Mon, 19 Oct 2026 14:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418737; cv=none; b=awjcn+nzpoDvmY8pP/a0VEntRTmY6NGJD+TF56KnmrIXZ2NyzaWRiNR8aetNV0N2KFBa9YSaQvDkmVCZnMCzxIF4dsUcvahEVW8ZhbtMvIS8Q8UopO7NF89Tj4hwkj71uy7atQ6NG9rqOnpCg7qSsnUQMSZg/Pz5vy0ZQAXTZBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418737; c=relaxed/simple;
	bh=401LqcwXCf/+f0cY/n+VTGh7mNcCtlVIYof+x6FrNG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NO6AbeiFaPdtnYVnGL3/Xhh9b+k8PzOqbvOn16w2EL45VhPKMll4nEfiwbQBSVGXTkSneNxWL3Ixk7nDbZ1c52dBU8/PoRN4uU+7cmoSDi8PjgZTs2yS7v7pKsdvRYpbC0xOLZqbK+1GEcCtHv26dxDv4OrPwAcs95mELIuQTAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kcpdNswp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kcpdNswp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E911F000C9;
	Mon, 19 Oct 2026 14:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418734;
	bh=7I6Sb1q+kKDR3InApJmi6kDqrK4mWzyufDDhKPEIcOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kcpdNswpIi/+Onxxfnj3VfiD0NGDAD7o9fw9i/loN6GEt9lugYCe0RFHxBFy/+KEt
	 lscGdfVT8rShGgClSUlSSevFtlXYMGerJUbMllqRtouF866Y4hdNd/0OvW+qQIzZ0X
	 +pAPP+3EyOQQtj+Z6UFyeYB8NsHmD6zynUn9IDAJpg5SKQ4ZHYdIlMyLqR0hAGABLk
	 aVUfZOdS45jwV5taCrRi4h3Bf/UBNMbnYPECRJJvdq+PuL+suerKHtkkvUcZpDjIt3
	 Py3YSr3fuqOiWwwhvRt/hrTBG7uECq6wqR+2b2pNBr9lNMqRGFTCPw5i85u4iYR2iN
	 p+wW/J4uMIrLw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mariano Baragiola <mbaragiola@linux.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	ajay.kathat@microchip.com,
	claudiu.beznea@tuxon.dev,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] wifi: wilc1000: validate monitor transmit frame headers
Date: Mon, 19 Oct 2026 09:52:29 -0400
Message-ID: <20261019135441.1420968-458-sashal@kernel.org>
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

From: Mariano Baragiola <mbaragiola@linux.com>

[ Upstream commit 9d96e037ff90a2fc81a841b2002d500a5a4a5351 ]

wilc_wfi_mon_xmit() reads the radiotap length before ensuring that the
fixed header is present. After stripping that header, it reads the frame
type and all three 802.11 addresses without checking how much frame data
remains.

A truncated monitor injection can therefore cause out-of-bounds reads.
Validate the radiotap header first, use the common 802.11 helper to check
the variable header length, and require a complete three-address header
before using the addresses. This covers QoS and four-address data headers
while rejecting short control headers that this path cannot classify.

Signed-off-by: Mariano Baragiola <mbaragiola@linux.com>
Link: https://patch.msgid.link/20260728192610.2236361-1-mbaragiola@linux.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a **5.15.221** tree (`pending-5.15`). The buggy
`wilc_wfi_mon_xmit()` path is present, the OOB is real, and the fix is a
small validation change that belongs here.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[wifi: wilc1000:] [validate] [check radiotap and 802.11
headers before reading them on monitor TX]**

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
From the candidate message:
- **Link:** `https://patch.msgid.link/20260728192610.2236361-1-
  mbaragiola@linux.com`
- **Signed-off-by:** Mariano Baragiola (author)
- **Signed-off-by:** Johannes Berg (wireless maintainer; accepted the
  patch)
- No `Fixes:` / `Cc: stable` / `Reported-by` / `Reviewed-by` in the
  candidate text (absence is expected here)

Original mailing-list submission (verified via `b4 mbox` / Openwall, not
the candidate markers) also had:
- **Fixes:** `c5c77ba18ea6 ("staging: wilc1000: Add SDIO/SPI 802.11
  driver")`
- **Cc:** `stable@vger.kernel.org`
- **To:** Ajay Singh, Claudiu Beznea (WILC maintainers)
- **Cc:** linux-wireless, linux-kernel

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** `wilc_wfi_mon_xmit()` calls
  `ieee80211_get_radiotap_len(skb->data)` before the skb is known to
  contain a radiotap header, then after `skb_pull()` reads frame type
  and three 802.11 addresses with no remaining-length check.
- **Symptom:** truncated monitor injection causes **out-of-bounds
  reads**.
- **Root cause:** missing bounds checks on radiotap length and 802.11
  header length.
- **Fix:** validate radiotap version/length, use
  `ieee80211_get_hdrlen_from_skb()`, require a full 3-address header,
  drop short frames.
- **Version info:** none in the body. Original `Fixes:` points at the
  2015 driver introduction.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: **Not hidden.** The message names OOB reads and describes the
missing checks. The new `drop:` path also stops returning `-1` from
`ndo_start_xmit` without freeing the skb.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- **File:** `drivers/net/wireless/microchip/wilc1000/mon.c` only (~+25 /
  -5)
- **Function:** `wilc_wfi_mon_xmit()`
- **Scope:** single-file surgical fix

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Local code today (verified in this tree):

```156:195:drivers/net/wireless/microchip/wilc1000/mon.c
        rtap_len = ieee80211_get_radiotap_len(skb->data);
        if (skb->len < rtap_len)
                return -1;

        skb_pull(skb, rtap_len);

        if (skb->data[0] == 0xc0 &&
is_broadcast_ether_addr(&skb->data[4])) {
                // ...
        }
        skb->dev = mon_priv->real_ndev;

        ether_addr_copy(srcadd, &skb->data[10]);
        ether_addr_copy(bssid, &skb->data[16]);
```

Record:
- **Radiotap:** before: read `it_len` with no minimum-size or version
  check, then `return -1` (invalid `netdev_tx_t`, skb not consumed).
  After: require `sizeof(*rtap_hdr)`, `it_version == 0`, `rtap_len >=
  sizeof(*rtap_hdr)`, else drop and free.
- **802.11 header:** before: `skb->data[0]`, `&skb->data[4]`,
  `&skb->data[10]`, `&skb->data[16]` with no length check. After:
  `ieee80211_get_hdrlen_from_skb()` and `hdr_len >= sizeof(struct
  ieee80211_hdr_3addr)` (24 bytes).
- **Deauth match:** `data[0] == 0xc0` replaced by
  `ieee80211_is_deauth(hdr->frame_control)`; broadcast dest uses
  `hdr->addr1`.
- **Address copy:** hardcoded offsets 10/16 replaced by `hdr->addr2` /
  `hdr->addr3` (same layout, now only after a 24-byte header is proven
  present).
- **Drop path:** `dev_kfree_skb(skb); return NETDEV_TX_OK;` — correct TX
  contract.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: **(d) Memory safety / (g) logic.** Category: **buffer overflow /
out-of-bounds read**.
- `ieee80211_get_radiotap_len()` does `get_unaligned_le16(&hdr->it_len)`
  at offset 2. A 0–1 byte skb is already an OOB read.
- If `skb->len == rtap_len`, `skb_pull()` leaves an empty skb;
  `data[0]`, `data[4]`, `data[10]`, `data[16]` are then OOB.
- Need 22 bytes after radiotap for addr3 (`data[16..21]`); nothing
  enforced that.

Step 2.4: ASSESS THE FIX QUALITY
Record: **Obviously correct and minimal.** Uses existing helpers.
Dropping short control headers is intentional (this path needs
addr2/addr3). QoS/4-address data still pass because their hdrlen is ≥ 24
and addr2/addr3 stay at the same offsets.
- **Regression risk:** low. Valid full 3-address injects unchanged.
  Short frames that previously hit OOB are now dropped.
- **Not introduced:** deauth path still does not free the original skb;
  `skb2` allocation failure still returns `-ENOMEM`. Pre-existing.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: The TX path is from **c5c77ba18ea6** (`staging: wilc1000: Add
SDIO/SPI 802.11 driver`, 2015-05-24). Length check `skb->len < rtap_len`
is from **60959e53f839** (2016). Address copies from **870709141599**
(2019). Bug has been in this driver for the whole 5.15 lifetime.

Step 3.2: FOLLOW THE FIXES: TAG
Record: Original submission tagged **Fixes: c5c77ba18ea6**. `git merge-
base --is-ancestor c5c77ba18ea6 HEAD` succeeded. Introduced in
**v4.2-rc1**. Present in this tree.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: `mon.c` on this branch is only a handful of commits (staging
move, strlcpy, error-path cleanup, netdev register crash). **No prior
monitor-header validation.** Other wilc1000 OOB fixes **are** already
here (`validate assoc response length`, `fix out-of-bounds read in P2P
public action frames`, `fix RX buffer OOB-write`, etc.). This patch is
**standalone**, subject `[PATCH]` not `X/Y`.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: No other Mariano Baragiola wilc1000 commits in this tree.
Johannes Berg’s SOB is the maintainer acceptance. WILC maintainers were
on To:.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Functional helpers all exist here:
- `ieee80211_get_radiotap_len()` — `include/net/ieee80211_radiotap.h`
- `ieee80211_get_hdrlen_from_skb()` — `net/wireless/util.c`
  (`EXPORT_SYMBOL`)
- `ieee80211_is_deauth()`, `struct ieee80211_hdr_3addr` —
  `include/linux/ieee80211.h`
- `NETDEV_TX_OK` — `include/linux/netdevice.h`
- Includes already pulled via `cfg80211.h` → `netdev.h`

**One backport tweak:** `struct ieee80211_radiotap_header_fixed` is
**not** in 5.15 (`git merge-base --is-ancestor 57be3d3562ca HEAD`
failed). That type was added in 2024 (`wifi: radiotap: Avoid -Wflex-
array-member-not-at-end warnings`) for a compiler warning. In this tree
`sizeof(struct ieee80211_radiotap_header)` is **8** (flex array has size
0) — same as the fixed header. Substitute `struct
ieee80211_radiotap_header *rtap_hdr`. **Can apply standalone** with that
one-identifier change.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- **Lore/msgid:** `20260728192610.2236361-1-mbaragiola@linux.com`
  (2026-07-28)
- **b4 mbox:** **1 message in the thread** — no review replies, no NAK,
  no v2
- **Openwall:** same single-patch post
- Johannes applied it (SOB on the committed version). Single-revision,
  no later unapplied vN.
- Author nominated **Cc: stable** and **Fixes:** on the original post.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: To: Ajay Singh, Claudiu Beznea. Cc: linux-wireless, linux-
kernel, stable. Applied by **Johannes Berg**. No on-list Reviewed-by
found.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla tag. Bug is from code inspection of the TX
path. Reachable from userspace `ndo_start_xmit` on the monitor netdev
(creating that iface is `NL80211_IFTYPE_MONITOR` in
`add_virtual_intf()`).

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone. Related wilc1000 OOB work in the same period (P2P
public action, assoc-response length) is already on this 5.15 branch;
this commit is a different file/path.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable returned HTTP 403. Original patch **was**
Cc’d to stable@. No evidence of a NAK against backporting. UNVERIFIED:
later stable-list debate beyond that CC.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: **`wilc_wfi_mon_xmit()`** only.

Step 5.2: TRACE CALLERS
Record: Registered as `.ndo_start_xmit` on the monitor netdev created by
`wilc_wfi_init_mon_interface()` from `add_virtual_intf()` when type is
`NL80211_IFTYPE_MONITOR`. Call context: process, packet TX (inject). Not
IRQ.

Step 5.3: TRACE CALLEES
Record: `ieee80211_get_radiotap_len`, `skb_pull`,
`ieee80211_get_hdrlen_from_skb`, `ieee80211_is_deauth`,
`is_broadcast_ether_addr`, `ether_addr_copy`, `mon_mgmt_tx`,
`wilc_mac_xmit` (consumes skb; `dev_kfree_skb` on its error paths),
`dev_kfree_skb`, `netif_rx`.

Step 5.4: FOLLOW THE CALL CHAIN
Record: nl80211 add monitor iface (typically `CAP_NET_ADMIN`) → inject
on that netdev → `wilc_wfi_mon_xmit()`. **Userspace-reachable** on
systems with WILC1000 and a monitor interface. Not a theoretical dead
path.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same driver already received several length-check OOB fixes on
this branch. `ieee80211_get_hdrlen_from_skb()` is the usual helper (e.g.
ath9k). This is the same class of bug, not a one-off style cleanup.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: **Yes.** `drivers/net/wireless/microchip/wilc1000/mon.c` lines
156–195. Introduced 2015; driver left staging in 2020 (`5625f965d7644`,
ancestor of HEAD). **5.15.221** has the bug.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Context around `wilc_wfi_mon_xmit()` matches the hunks.
**Expected difficulty: minor** — rename
`ieee80211_radiotap_header_fixed` → `ieee80211_radiotap_header`. No
other missing APIs.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: **This fix is not in the tree** (`git log --grep="validate
monitor transmit"` on that path is empty). Other wilc1000 OOB fixes do
not cover this TX path.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **wifi / wilc1000**
(`drivers/net/wireless/microchip/wilc1000/`). **PERIPHERAL/IMPORTANT for
its users:** IoT/embedded SDIO/SPI WiFi (Kconfig: “usually found in IoT
devices”). Not core mm/VFS, but a supported in-tree driver on 5.15 LTS,
which is exactly where those boards stay.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Actively receiving stable OOB/UAF fixes on this branch. Mature
driver, old bug.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: **Driver-specific / config-specific** (`CONFIG_WILC1000_SDIO` or
`CONFIG_WILC1000_SPI`), monitor interface in use.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Inject a short radiotap or short 802.11 frame on the monitor
netdev. Easy to hit once the iface exists. Creating it is privileged;
injection is still a **kernel** OOB, not a userspace-only issue.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: **OOB read** of skb/adjacent kernel memory; KASAN crash or info
leak into classification/TX. Invalid `ndo_start_xmit` `-1` can also
confuse the stack and leak the skb. **Severity: HIGH** (memory safety /
crash). Not a silent FS corruption, but in the sanitizer/OOB class that
stable regularly takes.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit:** high for WILC1000 + monitor users; closes a long-standing
  OOB on a reachable TX path.
- **Risk:** very low (~20 lines, drop path only for invalid frames, one
  type-name tweak).
- **Ratio:** favorable.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Real OOB reads in `ndo_start_xmit` on truncated injects (code-
  verified).
- Bug present since 2015; this 5.15 tree has the exact buggy code.
- Small, obviously correct validation; wireless maintainer SOB.
- Author Cc’d stable and tagged Fixes: c5c77ba18ea6 (in tree).
- Same driver already gets OOB backports on this branch.
- Helpers exist; drop path also fixes a wrong TX return / skb leak.

**AGAINST:**
- Niche IoT driver, monitor path, typically privileged setup.
- `ieee80211_radiotap_header_fixed` missing (one-line substitution).
- No syzbot/user crash log; no on-list review besides maintainer merge.

**UNRESOLVED:**
- lore.kernel.org HTTP 403; no extra review comments beyond the
  1-message thread.
- Whether Johannes dropped Fixes/Cc: stable when applying (candidate
  text lacks them; original mail had them).

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — bounds checks + existing
   helpers; maintainer applied it.
2. Fixes a real bug that affects users? **PASS** — OOB on monitor
   inject.
3. Important issue? **PASS** — kernel OOB read / crash; HIGH.
4. Small and contained? **PASS** — one function, ~20 lines.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — with
   `ieee80211_radiotap_header` instead of `_fixed`.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Not a device-ID/quirk/DT/docs exception. It is a **memory-safety
OOB fix**, which is core stable material.

Step 9.4: MAKE YOUR DECISION
The bug exists in this 5.15 tree, the failure is an OOB read on a
userspace-reachable TX path, and the fix is small. The missing `_fixed`
type is not a missing prerequisite; it is the same 8-byte header under
the older name.

Verification:
- [Phase 1] Parsed candidate tags: Link msgid, SOB Mariano Baragiola,
  SOB Johannes Berg; no Fixes in candidate text
- [Phase 1] b4 mbox + Openwall: original mail had Fixes: c5c77ba18ea6
  and Cc: stable@vger.kernel.org
- [Phase 2] Diff: one function `wilc_wfi_mon_xmit`; radiotap/802.11
  length checks + drop path
- [Phase 2] Local `mon.c` confirmed: `ieee80211_get_radiotap_len` then
  `return -1`; then `data[0]/[4]/[10]/[16]` with no length check
- [Phase 2] `ieee80211_get_radiotap_len` reads `it_len` at offset 2
  without a size check
- [Phase 3] blame: path from c5c77ba18ea6 (2015); `git merge-base --is-
  ancestor c5c77ba18ea6 HEAD` true
- [Phase 3] `git log --grep="validate monitor transmit" -- wilc1000`
  empty — fix not present
- [Phase 3] `57be3d3562ca` (`ieee80211_radiotap_header_fixed`) is
  **not** an ancestor
- [Phase 3] compiled `sizeof(struct ieee80211_radiotap_header)` with FAM
  = 8
- [Phase 3] `ieee80211_get_hdrlen_from_skb`, `ieee80211_is_deauth`,
  `ieee80211_hdr_3addr`, `NETDEV_TX_OK` all exist
- [Phase 4] b4 mbox: 1-message thread, no NAK/v2; To: WILC maintainers
- [Phase 4] lore.kernel.org 403 — UNVERIFIED further review thread
- [Phase 5] caller is monitor `.ndo_start_xmit`; iface created from
  `add_virtual_intf()` MONITOR
- [Phase 5] `wilc_mac_xmit` frees skb on its error paths
- [Phase 6] `git describe HEAD` → p-5.15-2-g6703e5d2f3a29; `make
  kernelversion` → 5.15.221
- [Phase 6] driver not staging here (`5625f965d7644` is ancestor)
- [Phase 8] Failure mode: OOB read on truncated monitor TX, severity
  HIGH
- UNVERIFIED: later stable@ discussion after the original Cc

The patch is a real, small OOB fix for code this tree still has.
Backport with `struct ieee80211_radiotap_header` in place of
`ieee80211_radiotap_header_fixed`.

**YES**

 drivers/net/wireless/microchip/wilc1000/mon.c | 30 +++++++++++++++----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/mon.c b/drivers/net/wireless/microchip/wilc1000/mon.c
index c3d27aaec2974..c0fde3b0d8aab 100644
--- a/drivers/net/wireless/microchip/wilc1000/mon.c
+++ b/drivers/net/wireless/microchip/wilc1000/mon.c
@@ -142,6 +142,9 @@ static int mon_mgmt_tx(struct net_device *dev, const u8 *buf, size_t len)
 static netdev_tx_t wilc_wfi_mon_xmit(struct sk_buff *skb,
 				     struct net_device *dev)
 {
+	struct ieee80211_radiotap_header_fixed *rtap_hdr;
+	struct ieee80211_hdr_3addr *hdr;
+	unsigned int hdr_len;
 	u32 rtap_len, ret = 0;
 	struct wilc_wfi_mon_priv  *mon_priv;
 	struct sk_buff *skb2;
@@ -153,13 +156,26 @@ static netdev_tx_t wilc_wfi_mon_xmit(struct sk_buff *skb,
 	if (!mon_priv)
 		return -EFAULT;
 
+	if (skb->len < sizeof(*rtap_hdr))
+		goto drop;
+
+	rtap_hdr = (void *)skb->data;
+	if (rtap_hdr->it_version)
+		goto drop;
+
 	rtap_len = ieee80211_get_radiotap_len(skb->data);
-	if (skb->len < rtap_len)
-		return -1;
+	if (rtap_len < sizeof(*rtap_hdr) || skb->len < rtap_len)
+		goto drop;
 
 	skb_pull(skb, rtap_len);
+	hdr_len = ieee80211_get_hdrlen_from_skb(skb);
+	if (hdr_len < sizeof(*hdr))
+		goto drop;
 
-	if (skb->data[0] == 0xc0 && is_broadcast_ether_addr(&skb->data[4])) {
+	hdr = (void *)skb->data;
+
+	if (ieee80211_is_deauth(hdr->frame_control) &&
+	    is_broadcast_ether_addr(hdr->addr1)) {
 		skb2 = dev_alloc_skb(skb->len + sizeof(*cb_hdr));
 		if (!skb2)
 			return -ENOMEM;
@@ -191,8 +207,8 @@ static netdev_tx_t wilc_wfi_mon_xmit(struct sk_buff *skb,
 	}
 	skb->dev = mon_priv->real_ndev;
 
-	ether_addr_copy(srcadd, &skb->data[10]);
-	ether_addr_copy(bssid, &skb->data[16]);
+	ether_addr_copy(srcadd, hdr->addr2);
+	ether_addr_copy(bssid, hdr->addr3);
 	/*
 	 * Identify if data or mgmt packet, if source address and bssid
 	 * fields are equal send it to mgmt frames handler
@@ -207,6 +223,10 @@ static netdev_tx_t wilc_wfi_mon_xmit(struct sk_buff *skb,
 	}
 
 	return ret;
+
+drop:
+	dev_kfree_skb(skb);
+	return NETDEV_TX_OK;
 }
 
 static const struct net_device_ops wilc_wfi_netdev_ops = {
-- 
2.53.0

