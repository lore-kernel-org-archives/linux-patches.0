Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B800C582BB4;
	Mon, 19 Oct 2026 13:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418130; cv=none; b=EIc/l/RG1C7kOgLbMxN/LBNXqqsLAen3YTJwchDZzrvKPxVr+sz6HewdYOfSxYLdMHFwLC0mchXUPA6R7ufO8bMgn8DmS+vatmU4bpjEx0LhOu++lMK2qb68k3fV2erWXytV2Zb1hOPd1Q7lfV9eNG0F5uAWdcYDFDzsH3Ivm8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418130; c=relaxed/simple;
	bh=2U0d5qrDcG5/pZEA05xrfVXhbNnZqGT1IUbK0M81VSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E5eOVbE/uEAvcA6VCqIbvoYWocJNWmtwR2n1NvHcrktNVJKlAUmD8MRhiePFiIe58kePkSQI2CG/8wsbqVxi0BMb5a02L4pee3oAwFHNymcgk6olyZvw7NHqoOlFXlJqtRd9cZbG+KOsEnduxjZ9SrJdQFxwOY1xj85179BWUBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MEk2e+45; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MEk2e+45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26A71F000C5;
	Mon, 19 Oct 2026 13:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418127;
	bh=ylNlqt/szmOgKj0nVcAf3216sWQ1woDYsv0ewQgQCgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MEk2e+458gokLKtX4lBbykt9OoFKDiVEgDbjxMr89FF6d4jocLdgAFdlwWLHoOrN9
	 IFzVthwtyT6FE5J7dA9JIu/JdESUoHhWJAIWrFoG86lGfmpFRsd8ycnXnNmp85K/Su
	 RL0stjdaD6weJtovke0HHl50aG6hgp1tHmjj4GVVWad+BJ562dqTbLOkPceToRSFuH
	 nBFy81PTcbSoJvbeYktHuUL4j6jfIfz8SjOCg4BznxdOuJNeh9I37zG3YDeoxCNyWs
	 omkG636ENiHfOcxZ8NiTRVWfjHdDBVdfm9ga0/wHeRTSkjBLGZ7LVhQGqvIhCrttkI
	 U92vzwLYjnlHw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Can Peng <pengcan@kylinos.cn>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] wifi: brcmfmac: Set DMA direction for msgbuf packet IDs
Date: Mon, 19 Oct 2026 09:45:22 -0400
Message-ID: <20261019135441.1420968-31-sashal@kernel.org>
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

From: Can Peng <pengcan@kylinos.cn>

[ Upstream commit f0ba5fd51ff23077ce66cb9be79d41a4b7c19c5e ]

brcmf_msgbuf_init_pktids() takes the DMA direction from its callers,
but never stores it in the packet ID state.  Since the state is zeroed,
pktids->direction remains DMA_BIDIRECTIONAL for both the TX and RX
packet ID pools.

All msgbuf packet ID map and unmap paths use pktids->direction.  As a
result, TX buffers requested with DMA_TO_DEVICE and RX buffers requested
with DMA_FROM_DEVICE are mapped and unmapped as DMA_BIDIRECTIONAL
instead.

Store the caller-provided direction when initializing the packet ID
state.

Signed-off-by: Can Peng <pengcan@kylinos.cn>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20260724092530.674624-1-pengcan@kylinos.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **5.15.221** (`pending-5.15`). The missing
`pktids->direction` store is present here, so this is a one-line DMA
correctness fix for this tree.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[wifi / brcmfmac]** **[Set]** Store DMA direction on msgbuf
packet ID pools so TX/RX map/unmap use the caller’s direction instead of
the zeroed `DMA_BIDIRECTIONAL` default.

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
From the commit text under review:
- **Acked-by:** Arend van Spriel `<arend.vanspriel@broadcom.com>`
  (brcm80211 maintainer)
- **Link:**
  `https://patch.msgid.link/20260724092530.674624-1-pengcan@kylinos.cn`
- **Signed-off-by:** Can Peng `<pengcan@kylinos.cn>` (author)
- **Signed-off-by:** Johannes Berg `<johannes.berg@intel.com>` (wireless
  maintainer)
- No **Fixes:** / **Cc: stable** / **Reported-by** in the applied
  message (expected for this review queue)

Original mailing-list submission (openwall / LKML, msgid
`20260724092530.674624-1-pengcan@kylinos.cn`) **did** include:
- `Fixes: 9a1bb60250d2 ("brcmfmac: Adding msgbuf protocol.")`
- `Cc: stable@vger.kernel.org`

Those tags were dropped when the patch was applied. That is
author/maintainer intent, not a pipeline “already selected” marker.
Decision below is still on technical merit.

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
**Bug:** `brcmf_msgbuf_init_pktids()` takes `enum dma_data_direction
direction` but never writes `pktids->direction`. `pktids` is zeroed, and
`DMA_BIDIRECTIONAL == 0`.
**Symptom:** TX pools created with `DMA_TO_DEVICE` and RX pools with
`DMA_FROM_DEVICE` are mapped/unmapped as bidirectional.
**Version:** Introduced with msgbuf (2014); no version cutoff in the
message.
**Root cause:** Missing store of a parameter that every map/unmap path
already reads.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup. It is an explicit DMA-direction
correctness fix. The unused parameter plus zeroed field is the entire
bug.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- **File:** `drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c`
- **Scope:** +1 line in `brcmf_msgbuf_init_pktids()` (`pktids->direction
  = direction;`)
- **Classification:** single-file surgical fix
- Mainline hunk context uses `kzalloc_objs` / `kzalloc_obj`; this 5.15
  tree uses `kcalloc` / `kzalloc`. The added line is the same.

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
**Before:** After allocating the array and `pktids`, only `array` and
`array_size` are set. `direction` stays 0.
**After:** The caller-provided direction is stored.
**Path:** Probe/init (`brcmf_proto_msgbuf_attach`), then every TX/RX
`dma_map_single` / `dma_unmap_single` via `pktids->direction`.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: **Logic / DMA API correctness** (with IOMMU and cache/bounce
side effects).
Callers already pass the right direction:

```1580:1585:drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
        msgbuf->tx_pktids = brcmf_msgbuf_init_pktids(NR_TX_PKTIDS,
                                                     DMA_TO_DEVICE);
        if (!msgbuf->tx_pktids)
                goto fail;
        msgbuf->rx_pktids = brcmf_msgbuf_init_pktids(NR_RX_PKTIDS,
                                                     DMA_FROM_DEVICE);
```

Map/unmap always use `pktids->direction` (`brcmf_msgbuf_alloc_pktid`,
`brcmf_msgbuf_get_pktid`, `brcmf_msgbuf_release_array`). Verified
`DMA_BIDIRECTIONAL = 0` in `include/linux/dma-direction.h`.

Verified DMA consequences in this tree:
- **IOMMU:** `dma_info_to_prot()` maps BIDIRECTIONAL → `IOMMU_READ |
  IOMMU_WRITE`, TO_DEVICE → `IOMMU_READ` only, FROM_DEVICE →
  `IOMMU_WRITE` only (`drivers/iommu/dma-iommu.c`). TX SKBs currently
  get device **write** permission they should not have.
- **Docs:** Networking TX must be `DMA_TO_DEVICE`, RX `DMA_FROM_DEVICE`
  (`Documentation/core-api/dma-api-howto.rst`).
- **SWIOTLB / non-coherent:** direction selects bounce copy and
  `arch_sync_dma_*` behavior.

Step 2.4: ASSESS THE FIX QUALITY
Record: Obviously correct: the parameter exists only to be stored. One
assignment, no API/lock/structure change. Regression risk is low: it
uses the directions the callers already requested. Using stricter TX
mapping (device read-only) is the intended, safer model.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: Buggy code from **`9a1bb60250d2`** (“brcmfmac: Adding msgbuf
protocol.”, Hante Meuleman, 2014-07-30). `git describe --contains` →
`v3.17-rc1`. Field, parameter, and missing store have been this way
since introduction. `git merge-base --is-ancestor 9a1bb60250d2b HEAD`
succeeded.

Step 3.2: FOLLOW THE FIXES: TAG
Record: Applied commit has no Fixes tag. Original submission fixes
**`9a1bb60250d2`**, which **is** in this tree. No later intermediate fix
stores `direction` (`git log --grep` on this file found none).

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Recent related commit already here: **`ddb864ea9ca2e`** (“wifi:
brcmfmac: unmap dma buffer in brcmf_msgbuf_alloc_pktid()”) — error-path
unmap, still using `pktids->direction`. Standalone; not part of a
numbered series.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Can Peng has **no** other commits in this 5.15 brcm80211
history. Arend van Spriel is the listed brcm80211 maintainer
(`MAINTAINERS`) and **Acked-by** the patch.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: No new helpers. The one-line store applies on the existing
`kcalloc`/`kzalloc` function. **Standalone.**

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record: `b4 dig -c` on this tree cannot target the mainline SHA (commit
not present). lore.kernel.org fetch returned 403. Thread recovered from:
- https://lists.openwall.net/linux-kernel/2026/07/24/732 (v1 submission)
- https://lkml.iu.edu/hypermail/linux/kernel/2608.0/00969.html (Ack)

Single revision. No NAK. Maintainer ack only.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: To: Arend van Spriel. Cc: linux-wireless, brcm80211 lists,
linux-kernel, **stable@vger.kernel.org**. Ack from the brcm80211
maintainer. Applied by Johannes Berg.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla/user crash in the message. Bug is from code
inspection (parameter never stored).

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone 1-line patch, not `N/M`.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: Author Cc’d stable on submission. Targeted
lore.kernel.org/stable search did not return a later rejection thread
(lore 403 / search noise). **UNVERIFIED:** no explicit stable-list NAK
found.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `brcmf_msgbuf_init_pktids()` only. Consumers of the field:
`brcmf_msgbuf_alloc_pktid`, `brcmf_msgbuf_get_pktid`,
`brcmf_msgbuf_release_array`.

Step 5.2: TRACE CALLERS
Record:
- Init: `brcmf_proto_msgbuf_attach()` → TX `DMA_TO_DEVICE`, RX
  `DMA_FROM_DEVICE`.
- Alloc: TX from `brcmf_msgbuf_txflow`; RX from
  `brcmf_msgbuf_rxbuf_data_fill` and ioctl/event buffer post.
- Get/unmap: TX status and RX complete paths.
Hot path for **PCIe** brcmfmac (`CONFIG_BRCMFMAC_PCIE` selects
`BRCMFMAC_PROTO_MSGBUF`). SDIO/USB use BCDC, not this file.

Step 5.3: TRACE CALLEES
Record: `dma_map_single` / `dma_unmap_single` with `pktids->direction`.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Userspace networking on Broadcom FullMAC **PCIe** WiFi (TX/RX).
Unprivileged traffic hits this path. Not an init-only leak.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: All four map/unmap sites in this file already use
`pktids->direction`. No second missing store.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: **Yes.** `msgbuf.c` lines 294–313 omit the store. Introduced in
v3.17, present for the entire 5.15 lifetime. `git log --grep="Set DMA
direction for msgbuf"` on this file is empty.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **Clean apply** of the one added line. Context around allocators
differs (`kcalloc` vs mainline `kzalloc_objs`); do not transplant the
mainline hunk blindly—only add `pktids->direction = direction;`.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: Only the 2022 unmap-on-alloc-failure fix (`ddb864ea9ca2e`).
Direction is still unset.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **wifi / brcmfmac msgbuf (PCIe).** **IMPORTANT** — common
laptop/embedded Broadcom FullMAC PCIe devices, not core mm/VFS.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Mature driver (msgbuf since 2014). File still gets targeted
fixes; this is an old latent bug, not churn from a new API.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: **Driver-specific / config-specific:** `CONFIG_BRCMFMAC` +
`CONFIG_BRCMFMAC_PCIE` (msgbuf). Not SDIO/USB BCDC. Enabled in several
ARM/arm64 defconfigs; widely used on x86 laptops with Broadcom PCIe
WiFi.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Every TX map and RX buffer post for msgbuf. Common path.
Unprivileged traffic can trigger it. Not a rare race.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- **IOMMU:** TX buffers mapped writable to the device → expanded DMA
  attack surface / isolation bug. **HIGH** (security-relevant).
- **Non-coherent / bounce DMA:** extra or wrong sync/copy vs the
  documented TX/RX directions → possible packet corruption. **HIGH** if
  it hits; **MEDIUM** on typical coherent x86 without IOMMU
  (BIDIRECTIONAL is documented to “work” at a cost).
- No oops in the commit message. Severity still **HIGH** because DMA
  permission and coherency are real user-visible classes, not style.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record: **Benefit: high** (correct DMA direction on every packet for a
common WiFi driver; tighter IOMMU perms on TX). **Risk: very low** (one
assignment of an already-passed enum). **Ratio: strongly favors
backport.**

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

**FOR:**
- Real, long-standing bug: direction parameter never stored; field stays
  `DMA_BIDIRECTIONAL`.
- Code is in this 5.15 tree (`9a1bb60250d2` is an ancestor).
- One-line, obviously correct, no new API.
- IOMMU maps BIDIRECTIONAL as R+W; TX should be device-read-only.
- DMA API requires precise TX/RX directions for networking.
- Maintainer Acked-by; original submission had Fixes + Cc: stable
  (dropped on apply).
- Applies here with only the one store.

**AGAINST:**
- No crash/syzbot report; driver has “worked” since 2014 on many
  coherent platforms.
- Affects PCIe msgbuf only, not all brcmfmac buses.

**UNRESOLVED:**
- Could not `b4 dig` the mainline SHA (not in this checkout);
  lore.kernel.org HTTP 403.
- No evidence of a stable-list rejection.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — missing store; maintainer
   ack.
2. Fixes a real bug that affects users? **PASS** — wrong DMA direction
   on live TX/RX.
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   IOMMU write on TX buffers; coherency/bounce mismatch.
4. Small and contained? **PASS** — +1 line, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — add the assignment after
   `pktids->array_size = nr_array_entries;`.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Not a device-ID/quirk/DT/docs exception. Ordinary correctness
fix.

Step 9.4: MAKE YOUR DECISION
Backport. The bug exists in 5.15, the fix is the intended store of an
existing parameter, and DMA direction is not optional cosmetics: it
controls IOMMU prot and cache/bounce behavior on a production WiFi
datapath.

What it solves for stable users: PCIe brcmfmac currently maps TX and RX
SKBs as bidirectional. That grants the device write access to TX buffers
under IOMMU and uses the wrong sync/bounce path. Storing the caller
direction restores `DMA_TO_DEVICE` / `DMA_FROM_DEVICE` as the attach
path already requests.

Risk vs benefit: one assignment vs a persistent DMA-permission/coherency
bug. No prerequisites beyond code already in this tree.

Verification:
- [Phase 1] Tags on applied commit: Acked-by Arend van Spriel, Link
  msgid, SOBs Can Peng / Johannes Berg; no Fixes/Cc in applied text
- [Phase 1] Original mail: Fixes 9a1bb60250d2, Cc:
  stable@vger.kernel.org (openwall 2026-07-24)
- [Phase 2] Diff: +1 line `pktids->direction = direction;` in
  `brcmf_msgbuf_init_pktids`
- [Phase 2] Local `dma-direction.h`: `DMA_BIDIRECTIONAL = 0`
- [Phase 2] `dma_info_to_prot`: BIDIRECTIONAL → READ|WRITE; TO_DEVICE →
  READ
- [Phase 3] `git blame`: missing store since 9a1bb60250d2 (v3.17-rc1)
- [Phase 3] `git merge-base --is-ancestor 9a1bb60250d2b HEAD`: yes
- [Phase 3] This fix not in tree (`git log --grep` empty on msgbuf.c)
- [Phase 3] Related: ddb864ea9ca2e already in tree; still uses unset
  direction
- [Phase 4] b4 dig: cannot run on missing mainline SHA; lore 403
- [Phase 4] Thread: v1 only; Ack 2026-08-02; no NAK
- [Phase 5] Callers: attach + TX flow + RX/ioctl/event buffer post; PCIe
  msgbuf hot path
- [Phase 6] `git describe HEAD`: p-5.15-2-g6703e5d2f3a29; `make
  kernelversion`: 5.15.221
- [Phase 6] Local init still lacks the store (lines 310–313)
- [Phase 8] Failure: wrong DMA dir / IOMMU TX writable; severity HIGH
- UNVERIFIED: full lore.kernel.org thread via b4; explicit stable-list
  NAK (none found)

**YES**

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index 45fbcbdc7d9e4..de47d6b7e02b2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -310,6 +310,7 @@ brcmf_msgbuf_init_pktids(u32 nr_array_entries,
 	}
 	pktids->array = array;
 	pktids->array_size = nr_array_entries;
+	pktids->direction = direction;
 
 	return pktids;
 }
-- 
2.53.0

