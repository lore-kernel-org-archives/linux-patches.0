Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8E553F9BB;
	Mon, 19 Oct 2026 14:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418723; cv=none; b=L2j8WdLE65xvbTu/M+lKW+jjKnPL1IFdgx6S1Plv9H703zGfDhrDwB76OHES3WRSMq0SWOw9FvRI9e+3tT6b66gfANoDhfirDLTYv4LnLDvC/i4GeKWZUjUn1fUMsLUMfkLT37RKd9zoYcx8nwYblTpKFllmf0xr7UGoAPMApfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418723; c=relaxed/simple;
	bh=++X0frGjoGy9FF1OPPzbPItCI8j7Z01sMLl2eAaan/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gU7B7nNMM18HPEhDLimBshjRamlx2Wd0QBjhuNZ16nkSYNe2W4bRaPeA8j/GJeYkQht0eBsoE1cNts2UQhVwEYi8MLtjhyn1eGemRUeja66elvvsoqneKB0GIyJ2L/RFm6ZQRRgiBNHh976o6pivlZsW/xp7sB+vW56w8i0ppSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eK0XhjQg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eK0XhjQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFB81F000CB;
	Mon, 19 Oct 2026 14:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418720;
	bh=ACbfuDX4SmepyLpW4JiPlajQNzRadVRjDpG4gszd+WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eK0XhjQgWXbkhTSHKW+3LayqUxZjQ80tRl38NkUn06wK0jTvMS21uVTMiFI4zA+Z8
	 ZDJ49BDLRJopg8zl0DfBZEFF0sFu+pyDSNmKFL24Swl5UyofHC6ElKg+IjrEDteWD5
	 q4J+ueTWTEYI0yUbNX2+EjXjOsXI9bzO4HEw3DMDWVq2/Jxhqhxmd4r3Gsl0WiTgBF
	 7KnAxne+7emT/9ZrFBDC4vtRNkhVEQvUucy2o1O+0AeuIUFBO0Z+mmwp3UTNM6UsGC
	 TRIfqXfiiVUvrnob/fO9mTrSi4PzQdUZd4J59W7VUN9xnmJOE9tEIt99Xgc4quwz2t
	 0+TRX4Dq7x3sw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Heyang Tan <thy15333007817@163.com>,
	Christian Lamparter <chunkeey@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	chunkeey@googlemail.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] wifi: p54: validate firmware record lengths
Date: Mon, 19 Oct 2026 09:52:19 -0400
Message-ID: <20261019135441.1420968-448-sashal@kernel.org>
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

From: Heyang Tan <thy15333007817@163.com>

[ Upstream commit db7b86bd97b380ece8fa39cfdd7502a9fd35e56f ]

The p54 firmware parser accesses component ID and component version
records without checking that their lengths cover the fields being read.
A malformed record can therefore make the parser read past the record.

Validate the component ID and component version record lengths before
accessing their data. The descriptor record is also checked against the
shortest descriptor length found in the supported firmware images.

Reject descriptor values that underflow the RX offset or produce an empty
RX range before updating the driver state.

Assisted-by: LLM Codex
Signed-off-by: Heyang Tan <thy15333007817@163.com>
Tested-by: Christian Lamparter <chunkeey@gmail.com>
Link: https://patch.msgid.link/20260918083349.891-1-thy15333007817@163.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.57**. The p54 firmware parser here still lacks
record-length checks, so this is a real bounds-check fix for this
series.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: `[wifi: p54:] [validate] firmware record lengths` — wireless p54
firmware parser; “validate” is a correctness/safety fix, not a feature.

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- `Assisted-by: LLM Codex`
- `Signed-off-by: Heyang Tan <thy15333007817@163.com>` (author)
- `Tested-by: Christian Lamparter <chunkeey@gmail.com>` (original p54
  author; hardware test)
- `Link:
  https://patch.msgid.link/20260918083349.891-1-thy15333007817@163.com`
- `Signed-off-by: Johannes Berg <johannes.berg@intel.com>` (wireless
  maintainer)
- Pipeline-only (ignored): `[Upstream commit
  db7b86bd97b380ece8fa39cfdd7502a9fd35e56f]`, `Signed-off-by: Sasha
  Levin`
- No `Fixes:`, no `Cc: stable` (expected)
- No `Reported-by:`, no syzbot tag on the commit itself

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: component ID and component version records are used without
  checking that `len` covers the fields read. A short record can make
  the parser read past the record.
- Extra: descriptor records are checked against the shortest known valid
  length (`0xa` words). Descriptor RX values that underflow `0x3500` or
  produce an empty RX window are rejected before driver state is
  updated.
- Symptom: out-of-bounds read of the firmware blob; invalid
  `rx_start`/`rx_end` (the old code even had `/* FIXME add sanity
  checking */`).
- Version info: none in the message. The parser dates to 2009 in this
  tree.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not hidden. Explicit bounds and range checks. The descriptor
work implements the old FIXME.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/net/wireless/intersil/p54/fwio.c` (+37 / −5)
- Function: `p54_parse_firmware()`
- Scope: single-file surgical fix

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- `BR_CODE_COMPONENT_ID`: previously `be32_to_cpup(bootrec->data)` with
  no length check. After: reject if `len < sizeof(struct
  bootrec_comp_id)/sizeof(*bootrec->data)` i.e. `len < 1`.
- `BR_CODE_COMPONENT_VERSION`: previously `strnlen(..., 24)` even for a
  short record. After: require `len >= DIV_ROUND_UP(24, 4)` (= 6 words),
  then `strnlen` limited to `sizeof(struct bootrec_comp_ver)` (still 24;
  no functional change for valid records).
- `BR_CODE_DESCR`: previously stored `rx_start` and `rx_end - 0x3500`
  with an explicit FIXME. After: require `len >= 0xa`; compute
  `rx_start`/`rx_end` locally; reject if `rx_end < 0x3500` or `rx_end -
  0x3500 <= rx_start`; only then write `priv->rx_start` /
  `priv->rx_end`.

`len` is in **u32 words**, matching the existing loop `bootrec->data +
len <= end_data`.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: memory safety (OOB read) + integer underflow / invalid RX
  window.
- Mechanism: the outer loop only keeps the *declared* record inside the
  blob. If `len` is 0 and the record is at the end,
  `be32_to_cpup(bootrec->data)` reads `*end_data` (past the firmware).
  `strnlen(..., 24)` can read up to 24 bytes past a short version
  record. `rx_end - 0x3500` wraps if `rx_end < 0x3500`;
  `p54_assign_address()` then uses that window as firmware memory.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct for the OOB: don’t read fields the record does not
  contain.
- `len < 0xa` matches the packed descriptor through `padding2` (40 bytes
  / 10 words); `rx_mtu` remains gated on `len == 11`.
- Regression risk is low: checks only reject truncated/inconsistent
  records. Christian Lamparter tested PCI and USB, including firmware
  down to 2.5.2.0.
- Reviewer nits on v2 (`len != 1` vs `len < 1`, local `bootrec_comp_ver
  *`) are style; he called v2 “technically correct.” A later v3 only
  restyles the same checks and is not in this tree. v2 is what Johannes
  merged.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: Unchecked parser body is from `76074e1670b197` (“p54: Move
firmware code”, 2009-06-23, Christian Lamparter). Present in this tree
(`git merge-base --is-ancestor` succeeded). The logic is older than that
(original p54 driver `eff1a59c48e3`, also in this tree).

Step 3.2: FOLLOW THE FIXES: TAG
Record: No `Fixes:` tag. N/A. Introducer is the 2009 move / original
2007 driver, both ancestors of HEAD.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record (same directory, already in this tree):
- `da1b9a55ff116` / `d38f5d868a0a4`: p54 EEPROM/RX length checks
  (malicious USB / KASAN)
- `3bdcc4d61212b` / `d2fb6b588dc5b`: p54 EEPROM/PDA length checks (`Cc:
  stable`)
This patch is standalone, not patch X/Y. It does not depend on those
EEPROM fixes.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Heyang Tan has this p54 fix and an unrelated octeontx2 debugfs
change. Not the subsystem maintainer. Weight comes from Christian’s
Tested-by and Johannes’s SOB.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: No new helpers or structs. Uses existing `bootrec_comp_id`,
`bootrec_comp_ver`, `bootrec_desc`. Standalone. `git diff v6.18.57
ac2ff9b564e82^ -- fwio.c` is empty, so it applies cleanly to this
series.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c db7b86bd97b380ece8fa39cfdd7502a9fd35e56f` →
  https://patch.msgid.link/20260918083349.891-1-thy15333007817@163.com
- Series: v2 submitted 2026-09-18 (this is the committed version).
- Christian Lamparter, 2026-09-19: tested USB (`isl3887usb` LM87) and
  PCI (LM86), plus older 2.5.2.0 firmware; `Tested-by`. Called the
  `sizeof`/`DIV_ROUND_UP` checks “technically correct”; asked for
  readability (`len != 1`, local version pointer). No NAK.
- v3 (2026-10-09) is that style follow-up (`len != 1`, `len < 6`, local
  pointer). Not the merged commit.
- Syzbot CI on v2: KASAN build/boot/fuzz passed (no new findings).
- Direct lore.kernel.org fetch returned 403; thread recovered via `b4
  dig -m`.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): To `linux-wireless@`, Cc Christian Lamparter.
Johannes Berg merged it. Christian is the long-time p54 author.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla `Reported-by` on this commit. Bug is from
code inspection. Author later asked whether a CVE is appropriate (OOB
firmware parser). Christian’s answer to that CVE question was not
retrieved (UNVERIFIED). Practical trigger is a malformed firmware file,
not a BadUSB frame.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone v2. v3 is cosmetic and unmerged here. Related p54
length-check work is EEPROM/PDA, already in this tree.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: No useful `lore.kernel.org/stable` hit for this subject. No
known “do not backport” discussion.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `p54_parse_firmware()` only.

Step 5.2: TRACE CALLERS
Record:
- `p54pci.c`: after firmware request, before upload
- `p54usb.c`: `p54u_start_ops()` after firmware load
- `p54spi.c`: `p54spi_request_firmware()` (`"3826.arm"`)
All probe/firmware-load paths, not the datapath.

Step 5.3: TRACE CALLEES
Record: `le32_to_cpu` / `be32_to_cpup` / `strnlen` / `wiphy_err`.
Descriptor fields feed `priv->rx_start`, `priv->rx_end`, `headroom`,
`tailroom`, `privacy_caps`, `rx_keycache_size`, `rx_mtu`.

Step 5.4: FOLLOW THE CALL CHAIN
Record: USB/PCI/SPI probe → `request_firmware[_nowait]` →
`p54_parse_firmware`. Reachable whenever p54 hardware is present and
firmware is loaded. Firmware comes from the host (`isl3886pci`,
`isl3887usb`, `3826.arm`, etc.), not from the USB packet stream.
Unprivileged users normally cannot plant that file; a bad file still
oopses/reads OOB in kernel.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same class as the p54 EEPROM/PDA length checks already in this
tree. `BR_CODE_EXPOSED_IF` in this same function still walks `exp_if`
from `len` without a per-record fit check; that is a leftover, not a
reason to drop this hunk.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. This checkout is `v6.18.57-155-gcdf239ca885b2`,
kernelversion `6.18.57`.
`v6.18.57:drivers/net/wireless/intersil/p54/fwio.c` still does
unvalidated `be32_to_cpup`, `strnlen(..., 24)`, and `rx_end - 0x3500`
with the FIXME. Bug introduced ~2009, long before 6.18.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Clean apply. Pre-candidate `fwio.c` matches `v6.18.57`. No
refactor between mainline context and this series.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: EEPROM/PDA validation is already here; it does not cover this
firmware bootrec parser. No earlier version of this exact fix in
6.18.57.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: `drivers/net/wireless/intersil/p54` — old
Prism54/ISL38xx/STLC45xx (USB/PCI and Nokia N800/N810 SPI). Criticality:
PERIPHERAL, but real hardware and already-supported in 6.18.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Mature/low churn. Recent work is mostly bounds checks. A long-
standing parser hole is more, not less, relevant for stable.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Users with p54 USB/PCI/SPI (`CONFIG_P54_*`) and a malformed or
truncated firmware image.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Device probe / firmware load. Common with p54 hardware; the
*malformed* case is uncommon (bad file, truncated image, attacker-
controlled firmware path). Not a hot-path race. Unprivileged trigger is
limited (firmware is host-provided).

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- Short records near the end of the blob: kernel OOB read (KASAN-class).
  Severity HIGH for memory safety; practical exploitability is lower
  than the USB EEPROM bugs.
- `rx_end` underflow: wrapped firmware memory window used by
  `p54_assign_address()` / `p54_setup_mac()`. Severity MEDIUM–HIGH for
  driver malfunction / bad device addresses.
- Overall: HIGH memory-safety, not a universal panic on valid vendor
  firmware.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: stops OOB reads and bogus RX windows on a parser this tree
  has had since 2009; same robustness class as p54 fixes already in
  6.18.y.
- Risk: ~40-line, error-path-only; hardware-tested; no API change.
- Ratio: favorable.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

FOR:
- Real OOB read in `p54_parse_firmware()` plus RX-range underflow the
  original code flagged with FIXME.
- Small, contained, no new API.
- Present in this 6.18 tree for ~17 years; applies cleanly.
- Tested-by original p54 author on PCI and USB, including old firmware.
- Merged by Johannes Berg.
- Same validation pattern as other p54 stable fixes already here.

AGAINST:
- Niche driver; trigger is a bad firmware file, not a malicious URB.
- No syzbot/CVE on this specific patch.
- v3 is a later style tweak (not a functional hole in v2).

UNRESOLVED:
- Christian’s reply on CVE classification not retrieved.
- lore.kernel.org HTTP fetch 403; thread obtained via b4 instead.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — reviewer called v2
   technically correct; Tested-by on real devices.
2. Fixes a real bug that affects users? **PASS** — OOB read and invalid
   RX window on malformed firmware.
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   kernel OOB read / firmware-parser memory safety (HIGH). Not a
   universal oops on good firmware, but this class is accepted for
   stable.
4. Small and contained? **PASS** — one function, +37/−5.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — identical pre-image to
   v6.18.57 `fwio.c`.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: None (not a device ID, quirk, DT, build, or doc fix). Qualifies
as a normal bugfix.

Step 9.4: MAKE YOUR DECISION
Backport. The 6.18 parser still has the hole; the fix is small, tested,
and addresses a real OOB/underflow without depending on later refactors.

What it solves for this tree: `p54_parse_firmware()` can read past a
truncated component-ID/version record and can wrap `rx_end`. That hits
USB/PCI/SPI probe when firmware is loaded. Stable rules are met; risk is
low because valid images were tested and only invalid records are
rejected.

Verification:
- [Phase 1] Tags: Tested-by Christian Lamparter; SOB Johannes Berg; Link
  msgid 20260918083349.891-1; no Fixes/Cc:stable/Reported-by (expected).
- [Phase 2] Diff: +37/−5 in `p54_parse_firmware()`; ID `len < 1`,
  version `len < 6`, descriptor `len < 0xa` plus RX-range check.
  `bootrec_desc` packed size 42 bytes; `0xa` words covers fields used
  when `len != 11`.
- [Phase 3] `git blame` on parent: `76074e1670b197` (2009). `git merge-
  base --is-ancestor 76074e1670b197 HEAD` succeeded. No Fixes tag.
- [Phase 3] Related p54 length checks (`da1b9a55ff116`, `d38f5d868a0a4`,
  `3bdcc4d61212b`, `d2fb6b588dc5b`) are EEPROM/PDA, not this parser.
- [Phase 4] `b4 dig -c db7b86bd97b380ece8fa39cfdd7502a9fd35e56f`: v2
  lore thread; `-a` only v2 as committed series; `-w` linux-wireless +
  chunkeey. Christian: “technically correct” + Tested-by PCI/USB.
- [Phase 4] WebSearch: v3 is style-only; syzbot CI passed v2.
  lore.kernel.org WebFetch 403.
- [Phase 4] UNVERIFIED: Christian’s CVE-classification reply.
- [Phase 5] Callers: `p54pci.c:79`, `p54usb.c:872`, `p54spi.c:166` on
  firmware load. `rx_end` used in `p54_assign_address()` /
  `p54_setup_mac()`.
- [Phase 6] `git describe HEAD` → `v6.18.57-155-gcdf239ca885b2`; `make
  kernelversion` → `6.18.57`. Buggy code in
  `v6.18.57:drivers/net/wireless/intersil/p54/fwio.c`. `git diff
  v6.18.57 ac2ff9b564e82^ -- fwio.c` empty.
- [Phase 8] Failure mode: OOB read of firmware blob; wrapped RX window.
  Severity HIGH for memory safety, driver-specific trigger.

**YES**

 drivers/net/wireless/intersil/p54/fwio.c | 42 +++++++++++++++++++++---
 1 file changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intersil/p54/fwio.c b/drivers/net/wireless/intersil/p54/fwio.c
index 3baf8ab01e22b..4b8e6cf711d8f 100644
--- a/drivers/net/wireless/intersil/p54/fwio.c
+++ b/drivers/net/wireless/intersil/p54/fwio.c
@@ -52,6 +52,13 @@ int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
 		u32 code = le32_to_cpu(bootrec->code);
 		switch (code) {
 		case BR_CODE_COMPONENT_ID:
+			if (len < sizeof(struct bootrec_comp_id) /
+				sizeof(*bootrec->data)) {
+				wiphy_err(priv->hw->wiphy,
+					  "firmware component ID is too short\n");
+				return -EINVAL;
+			}
+
 			priv->fw_interface = be32_to_cpup((__be32 *)
 					     bootrec->data);
 			switch (priv->fw_interface) {
@@ -72,16 +79,41 @@ int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
 			}
 			break;
 		case BR_CODE_COMPONENT_VERSION:
+			if (len < DIV_ROUND_UP(sizeof(struct bootrec_comp_ver),
+					       sizeof(*bootrec->data))) {
+				wiphy_err(priv->hw->wiphy,
+					  "firmware component version is too short\n");
+				return -EINVAL;
+			}
+
 			/* 24 bytes should be enough for all firmwares */
-			if (strnlen((unsigned char *) bootrec->data, 24) < 24)
-				fw_version = (unsigned char *) bootrec->data;
+			if (strnlen((unsigned char *)bootrec->data,
+				    sizeof(struct bootrec_comp_ver)) <
+				    sizeof(struct bootrec_comp_ver))
+				fw_version = (unsigned char *)bootrec->data;
 			break;
 		case BR_CODE_DESCR: {
 			struct bootrec_desc *desc =
 				(struct bootrec_desc *)bootrec->data;
-			priv->rx_start = le32_to_cpu(desc->rx_start);
-			/* FIXME add sanity checking */
-			priv->rx_end = le32_to_cpu(desc->rx_end) - 0x3500;
+			u32 rx_start, rx_end;
+
+			/* 0xa is the shortest descriptor in supported firmware. */
+			if (len < 0xa) {
+				wiphy_err(priv->hw->wiphy,
+					  "firmware descriptor is too short\n");
+				return -EINVAL;
+			}
+
+			rx_start = le32_to_cpu(desc->rx_start);
+			rx_end = le32_to_cpu(desc->rx_end);
+			if (rx_end < 0x3500 || rx_end - 0x3500 <= rx_start) {
+				wiphy_err(priv->hw->wiphy,
+					  "firmware descriptor has invalid RX range\n");
+				return -EINVAL;
+			}
+
+			priv->rx_start = rx_start;
+			priv->rx_end = rx_end - 0x3500;
 			priv->headroom = desc->headroom;
 			priv->tailroom = desc->tailroom;
 			priv->privacy_caps = desc->privacy_caps;
-- 
2.53.0

