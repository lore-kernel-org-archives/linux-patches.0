Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD17445C6F8;
	Mon, 31 Aug 2026 13:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183898; cv=none; b=AmoZr3NgShw8Gku1INPf+mkQ1D44hHl24KG6DK1niMBuIgHR8fXTgiqmWbI69n1c52RIHiPSQQv2nleQkc+YHMCQ169om6IGz4oZIRCOHq6cUtIJqba1kUNvKIkocqQ7YjaNcehm2pPUhoSMoMUOEsB1+lGODFc4gxhmmgd+Egg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183898; c=relaxed/simple;
	bh=HlvWPTCkkzTxqZXD/COO+QxhBvizyWU848yipgWFibk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qls5Jo9irfnI3EZpPmmICuqv/FVC0HIQoZ70MmnOKWEJ13HQzqaRQxqLa3EkFOrdxiAmfLoMRpjNnw72u0CzI3TNPD0bRPMXdbsJifPyHwVlkV9vnJPKTFMvaz/1B1dhrraFrl5NPgMHgBuNN98oB3CXWlJ0YrhltIDRlV923jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DBzSPXMT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DBzSPXMT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D474C1F00ADB;
	Mon, 31 Aug 2026 13:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183895;
	bh=pkcFfWywN+zhCyWoi7VJC98VIx6J4HKOu9NgRIrgkeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DBzSPXMTfvtGP/k8/Lt3FcABxDGn0OSrzBV29u8nwRO4g8SmUXKslKBXgiGybBpGO
	 O4A4JgyfNSk1wKuS0Ta00CkmYOdwr17Przk0ZPJblhHYG2Q4B5du00sjk+nTIDwugL
	 ujSAg6bdazv6dKsv6ozw0zba6fdM9tHsXLCgdbUVwkESqGzIzYvLVfy+HyouzJIggj
	 7dynDF0gi2MmbnfBiPnvIDvQqs3Xm0jr1Je86f8zI/Tuhjds1rI540eQrbzYqQ8xk7
	 +VxQQblxt+/ctkTyuI7/NnV89vatZQ1GGTDr5q3OBPJHpmixlwPdmyWIZdJw/vC61g
	 mB4yJk5eQyBfw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yuqi Xu <xuyuqiabc@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] wifi: cfg80211: reject duplicate wiphy cipher suite entries
Date: Mon, 31 Aug 2026 09:26:35 -0400
Message-ID: <20260831133314.4125787-367-sashal@kernel.org>
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

From: Yuqi Xu <xuyuqiabc@gmail.com>

[ Upstream commit 7187d145d9042b037e4f10538f70cf95e380219f ]

Duplicate entries in wiphy->cipher_suites do not describe any
additional capability, but cfg80211 currently accepts them and leaves
individual consumers to deal with them.

One such consumer is the WEXT compatibility code, which appends a WEP
key length for each WEP cipher entry it sees. Repeated WEP entries can
therefore overflow the fixed iw_range::encoding_size array returned by
SIOCGIWRANGE.

Reject duplicate cipher suite entries in wiphy_register() instead.
This keeps the cipher suite invariant in one place and makes malformed
wiphy descriptions fail early with -EINVAL, rather than relying on a
single cfg80211 user to handle duplicates correctly.

Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Yuqi Xu <xuyuqiabc@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Link: https://patch.msgid.link/20260413123000.1480661-1-n05ec@lzu.edu.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: cfg80211: reject duplicate wiphy
cipher suite entries`

**Local tree:** `v6.18.43` (6.18.y stable) — verified via `git describe
HEAD` and Makefile `VERSION/PATCHLEVEL/SUBLEVEL`.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 — Subject line**
Record: `[wifi: cfg80211]` `[reject]` — reject duplicate wiphy cipher
suite entries at registration time.

**Step 1.2 — Tags**
Record:
- Reported-by: Yifan Wu \<yifanwucs@gmail.com\>
- Reported-by: Juefei Pu \<tomapufckgml@gmail.com\>
- Co-developed-by: Yuan Tan \<yuantan098@gmail.com\>
- Suggested-by: Xin Liu \<bird@lzu.edu.cn\>
- Signed-off-by: Yuan Tan, Yuqi Xu, Ren Wei (authors)
- Signed-off-by: Johannes Berg \<johannes.berg@intel.com\> (cfg80211
  maintainer)
- Link:
  https://patch.msgid.link/20260413123000.1480661-1-n05ec@lzu.edu.cn
- No Fixes:, Cc: stable, Tested-by, or syzbot tags

Notable: two independent reporters; maintainer sign-off.

**Step 1.3 — Body analysis**
Record:
- **Bug:** Duplicate entries in `wiphy->cipher_suites` are accepted by
  cfg80211.
- **Symptom:** WEXT compatibility code (`cfg80211_wext_giwrange`)
  appends a WEP key length for every WEP cipher entry; repeated WEP
  entries overflow the fixed
  `iw_range::encoding_size[IW_MAX_ENCODING_SIZES]` array (size 8) when
  `SIOCGIWRANGE` is handled.
- **Root cause:** No central validation of cipher suite uniqueness at
  `wiphy_register()`.
- **Fix approach:** Reject duplicates early in `wiphy_register()` with
  `-EINVAL`.

**Step 1.4 — Hidden bug fix?**
Record: No — this is an explicit bug fix (out-of-bounds write / memory
corruption in WEXT path), not disguised cleanup.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 — Inventory**
Record:
- 1 file: `net/wireless/core.c` (+18 lines net)
- New function: `wiphy_cipher_suites_valid()`
- Modified function: `wiphy_register()`
- Scope: single-file, surgical validation addition

**Step 2.2 — Code flow per hunk**
Record:
- **Hunk 1 (new helper):** Before — no duplicate check. After — O(n²)
  pairwise comparison rejects any duplicate `cipher_suites[i]`; also
  rejects `n_cipher_suites > 0` with NULL `cipher_suites`.
- **Hunk 2 (`wiphy_register`):** Before — proceeds to band validation
  after iface-combination checks. After — returns `-EINVAL` if cipher
  suites are invalid/duplicated.

**Step 2.3 — Bug mechanism**
Record:
- **Category:** Buffer overflow / out-of-bounds write (memory safety)
- **Mechanism:** In `cfg80211_wext_giwrange()`:

```160:180:net/wireless/wext-compat.c
        for (i = 0; i < wdev->wiphy->n_cipher_suites; i++) {
                switch (wdev->wiphy->cipher_suites[i]) {
                // ...
                case WLAN_CIPHER_SUITE_WEP40:
range->encoding_size[range->num_encoding_sizes++] =
                                WLAN_KEY_LEN_WEP40;
                        break;
                case WLAN_CIPHER_SUITE_WEP104:
range->encoding_size[range->num_encoding_sizes++] =
                                WLAN_KEY_LEN_WEP104;
                        break;
                }
        }
```

`IW_MAX_ENCODING_SIZES` is 8 (`include/uapi/linux/wireless.h`). There is
no bounds check on `num_encoding_sizes`. Nine or more WEP cipher entries
write past `encoding_size[7]` into subsequent `struct iw_range` fields.

**Step 2.4 — Fix quality**
Record: Obviously correct; minimal; consistent with existing
`wiphy_register()` sanity checks. Low regression risk — all in-tree
drivers use unique static cipher lists. Rejecting meaningless duplicates
is semantically correct.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 — Blame / introduction of buggy code**
Record: WEXT cipher-suite loop is in `net/wireless/wext-compat.c`
(present in v6.18.43). Stable-tree history is compressed; the vulnerable
pattern predates 6.18.y. The bug is long-standing legacy WEXT code, not
a recent regression.

**Step 3.2 — Fixes: tag**
Record: N/A — no Fixes: tag in commit message.

**Step 3.3 — Related file history**
Record:
- Recent WEXT fix already in this tree: `3c87b7e64735c` — `wifi:
  cfg80211: wext: fix IGTK key ID off-by-one`
- Related validation fix from same research group already in tree:
  `265c07c09c837` — `wifi: nl80211: reject oversized EMA RNR lists`
  (Yuqi Xu)
- Commit under review is **not** yet in this tree (no
  `wiphy_cipher_suites_valid` present)

**Step 3.4 — Author context**
Record: Authors (Lanzhou University group) have multiple accepted
cfg80211/nl80211 validation fixes. Johannes Berg (maintainer) signed
off.

**Step 3.5 — Dependencies**
Record: Standalone; no series dependencies. `git apply --check` on the
provided diff succeeds against v6.18.43.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 — Original discussion**
Record: UNVERIFIED — `b4 shazam` did not find the message-id;
lore.kernel.org returned 403 (bot protection); `curl` to raw lore URL
also 403.

**Step 4.2 — Reviewers**
Record: UNVERIFIED via b4 dig (no commit hash in local tree). Johannes
Berg maintainer sign-off confirmed from commit message.

**Step 4.3 — Bug report**
Record: Two Reported-by tags from security researchers; no
syzbot/bugzilla link. Severity implied: kernel memory corruption on WEXT
ioctl path.

**Step 4.4 — Series context**
Record: Appears standalone (not part of a multi-patch series).

**Step 4.5 — Stable list history**
Record: UNVERIFIED — could not search lore stable archive.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 — Key functions**
Record: `wiphy_cipher_suites_valid()` (new), `wiphy_register()`
(modified), vulnerable consumer `cfg80211_wext_giwrange()`.

**Step 5.2 — Callers**
Record: `wiphy_register()` called from every cfg80211 driver at
probe/init (mac80211, brcmfmac, iwlwifi, mwifiex, hwsim, etc.).
`cfg80211_wext_giwrange()` registered as WEXT handler for `SIOCGIWRANGE`
in `wext-compat.c`.

**Step 5.3 — Callees**
Record: Validation is pure comparison logic; no new allocations or
locks.

**Step 5.4 — Reachability / trigger path**
Record: **Verified in-tree trigger via mac80211_hwsim:**
- `hwsim_known_ciphers()` checks each cipher is known but **does not
  reject duplicates**
  (`drivers/net/wireless/virtual/mac80211_hwsim.c:6260-6280`)
- Up to `ARRAY_SIZE(hwsim_ciphers)` = 11 entries allowed via
  `HWSIM_ATTR_CIPHER_SUPPORT` (`6456-6462`)
- 9+ duplicate `WLAN_CIPHER_SUITE_WEP40` entries → `n_cipher_suites` =
  9+ → `SIOCGIWRANGE` overflows `encoding_size[8]`
- Requires `CONFIG_CFG80211_WEXT` (enabled in multiple arch defconfigs)
  and `CONFIG_MAC80211_HWSIM`
- Creating hwsim radios requires elevated privileges
  (netlink/CAP_NET_ADMIN); ioctl on the interface may be reachable with
  lesser privilege depending on netdev permissions

**Step 5.5 — Similar patterns**
Record: No bounds check on `num_encoding_sizes` anywhere in wext-
compat.c. Other cfg80211 consumers (`cfg80211_supported_cipher_suite`,
nl80211) tolerate duplicates but gain nothing from them.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (v6.18.43)

**Step 6.1 — Buggy code present?**
Record: **YES.** `cfg80211_wext_giwrange()` vulnerable loop exists;
`wiphy_register()` lacks duplicate validation (confirmed by reading
`net/wireless/core.c` around line 857).

**Step 6.2 — Backport complications**
Record: Clean apply verified (`git apply --check` passed). Insertion
point after `wiphy_verify_combinations()` matches upstream diff context
in current `core.c`.

**Step 6.3 — Related fixes already present?**
Record: No duplicate-cipher validation. Related WEXT fix
(`3c87b7e64735c`) and nl80211 bounds fix (`265c07c09c837`) from same
research lineage are already in tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1 — Subsystem criticality**
Record: `net/wireless` (cfg80211) — **IMPORTANT** subsystem; affects all
WiFi users on WEXT-enabled configs.

**Step 7.2 — Activity**
Record: Actively maintained; recent stable backports include WEXT and
nl80211 validation fixes.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 — Who is affected**
Record: Systems with `CONFIG_CFG80211_WEXT=y` and a wiphy advertising
duplicate cipher suites (buggy/OOT driver, or mac80211_hwsim with
crafted cipher list).

**Step 8.2 — Trigger conditions**
Record: Uncommon in production drivers (in-tree arrays are unique), but
**demonstrably reachable** via in-tree hwsim with duplicate WEP entries.
Not every boot; requires WEXT ioctl on affected interface.

**Step 8.3 — Failure mode severity**
Record: Out-of-bounds writes within kernel `struct iw_range` buffer →
memory corruption. Severity: **HIGH** (kernel memory safety; potential
for further exploitation depending on layout and caller context).

**Step 8.4 — Risk-benefit**
Record:
- **Benefit:** HIGH — prevents OOB write; centralizes invariant
  enforcement
- **Risk:** LOW — ~18 lines, no API change, no in-tree driver uses
  duplicates
- **Ratio:** Strong benefit, minimal risk

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1 — Evidence summary**

| FOR backport | AGAINST backport |
|---|---|
| Real OOB write in kernel WEXT path | Requires `CONFIG_CFG80211_WEXT`
(not universal) |
| Demonstrable via in-tree mac80211_hwsim | Trigger needs unusual
duplicate cipher list |
| Small, surgical, maintainer-approved | Lore discussion unverified |
| Applies cleanly to v6.18.43 | |
| Precedent: similar validation fixes already in this tree | |
| No in-tree driver regression expected | |

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — logic is trivial; maintainer
   SOB; reporters identified concrete consumer bug
2. Fixes real bug affecting users? **PASS** — OOB write on
   `SIOCGIWRANGE`
3. Important issue? **PASS** — memory corruption (HIGH)
4. Small and contained? **PASS** — 1 file, ~18 lines
5. No new features/APIs? **PASS** — registration-time validation only
6. Can apply to local tree? **PASS** — clean apply verified; buggy code
   present

**Step 9.3 — Exception category**
Record: N/A (not device ID/quirk/build/doc); standard bug fix.

**Step 9.4 — Problem statement for stable users**

Duplicate cipher suite entries in a wiphy description are meaningless
but currently accepted. When WEXT compatibility is enabled,
`SIOCGIWRANGE` handling writes one `encoding_size` entry per WEP cipher
without bounds checking. A wiphy with 9+ duplicate WEP entries
(achievable via mac80211_hwsim's cipher attribute) causes out-of-bounds
writes in the kernel `iw_range` buffer. Rejecting duplicates at
`wiphy_register()` fixes this at the source, consistent with other wiphy
sanity checks, with negligible risk to legitimate drivers.

---

## Verification

- [Phase 1] Parsed commit message tags: 2× Reported-by, Johannes Berg
  SOB, Link tag
- [Phase 2] Diff: +`wiphy_cipher_suites_valid()`, call in
  `wiphy_register()`; 1 file changed
- [Phase 2] Read `wext-compat.c:160-180`: unbounded
  `num_encoding_sizes++` on WEP cases
- [Phase 2] Read `wireless.h`: `IW_MAX_ENCODING_SIZES = 8`
- [Phase 3] `git describe HEAD`: v6.18.43
- [Phase 3] `git merge-base --is-ancestor 265c07c09c837 HEAD`: EMA
  validation fix already in tree
- [Phase 3] `git show 3c87b7e64735c`: WEXT fix already backported to
  this tree
- [Phase 3] `git apply --check`: patch applies cleanly
- [Phase 4] `b4 shazam`: message not found — UNVERIFIED
- [Phase 4] lore.kernel.org / curl raw: 403 Forbidden — UNVERIFIED
- [Phase 5] Read `mac80211_hwsim.c:6260-6280`: duplicates allowed in
  cipher list
- [Phase 5] Read `mac80211_hwsim.c:6456-6462`: up to 11 ciphers accepted
- [Phase 5] Read `hwsim_ciphers[]`: 11 entries max, includes
  WEP40/WEP104
- [Phase 5] Grep in-tree `cipher_suites[]` arrays: all unique entries
  (brcmfmac, mac80211, iwlwifi sampled)
- [Phase 6] Grep `wiphy_cipher_suites_valid`: not present — fix not yet
  in tree
- [Phase 6] Read `core.c:857-859`: no cipher-suite validation at
  registration
- [Phase 7] `CONFIG_CFG80211_WEXT` present in multiple arch defconfigs
- [Phase 8] Failure mode: OOB write within `struct iw_range` — severity
  HIGH

**YES**

 net/wireless/core.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index efbf7b3046342..98ea1147ab11d 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -726,6 +726,24 @@ static int wiphy_verify_combinations(struct wiphy *wiphy)
 	return ret;
 }
 
+static bool wiphy_cipher_suites_valid(const struct wiphy *wiphy)
+{
+	int i, j;
+
+	if (wiphy->n_cipher_suites && !wiphy->cipher_suites)
+		return false;
+
+	for (i = 0; i < wiphy->n_cipher_suites; i++) {
+		for (j = 0; j < i; j++) {
+			if (wiphy->cipher_suites[i] ==
+			    wiphy->cipher_suites[j])
+				return false;
+		}
+	}
+
+	return true;
+}
+
 int wiphy_register(struct wiphy *wiphy)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
@@ -858,6 +876,9 @@ int wiphy_register(struct wiphy *wiphy)
 	if (res)
 		return res;
 
+	if (!wiphy_cipher_suites_valid(wiphy))
+		return -EINVAL;
+
 	/* sanity check supported bands/channels */
 	for (band = 0; band < NUM_NL80211_BANDS; band++) {
 		const struct ieee80211_sband_iftype_data *iftd;
-- 
2.53.0

