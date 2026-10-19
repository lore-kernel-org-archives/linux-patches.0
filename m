Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E408160C107;
	Mon, 19 Oct 2026 14:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418623; cv=none; b=J78e/Xp44vktYAXp02Gv0+/YtuBPGDhSnVWqBw/CUTZDxrKDTsml37MBOUNcjSPmBojqJ4ITJmTuJ8lLenkmlrOdnfC7M8rF+xTTvl9Us5k2JcyPF7k10GHbfdaRjsD/pxEp2ZHC0MvgtwfP358HW7zV5G5T1AQe1sxBlC1tb5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418623; c=relaxed/simple;
	bh=2c82SetbSEqyygDALnnoMxFEdB6ansr0CWIlBjhAMAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bOp+hiNMKT3XwjU3Z9rqnAcS1C15FbYje8u2P92Roef6krMrYC5PtoD62HXUgzAgNr7Ta2bHMPYLPiTTw26dFzhE0QN3G8Dm2ajleXbhqDGvgyLYkil3Hes91/boYRQdWuTUmUUgMdMTfC+h7JtU/Zstco636+7NyPBfWONjjys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XsgMMs8F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XsgMMs8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9A11F000C4;
	Mon, 19 Oct 2026 14:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418620;
	bh=lMhrqwPw+FGLBnkvsxlHHRpMLzpmVg0Nh8ecw1O7ps0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XsgMMs8FB2vgr/NRKG6OEJ8dHqCcFsr+TPQLKYgcuNSWpMy+LOS6WbsQ7ei8A+p+n
	 98PKobukXDaNxo0PGIdAdZOhJPcX/J+AeImpf94FrVST/UPm/bhEtC4SWJAuBlGR75
	 4xBtlUxraJ6Cg1AsXybKVo8aH+njZeLgo83Lrqk7atrCXWALkQK2uYijP7UbOyjMng
	 1R9SiGqL38G4DYtzE9qfq0xNRNS07ZFh5CZUY2KNsebaTGDexhyirfFmbdbRvlzXEt
	 dR9exrYm7tYtKeq/Krf0ZsQDWapGf40zUrPohkyLHUiVu5VIoBSRDCU8LNQuZfv1JI
	 aCUn6wJ0x6tAw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alex Elder <elder@riscstar.com>,
	Sashiko <sashiko-bot@kernel.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com,
	netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] net: stmmac: use dma_addr_t for DMA addresses
Date: Mon, 19 Oct 2026 09:51:09 -0400
Message-ID: <20261019135441.1420968-378-sashal@kernel.org>
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

From: Alex Elder <elder@riscstar.com>

[ Upstream commit 0c1f9020d2ada55aed8a2e055903ad9cd5d49dab ]

In jumbo_frm() (implemented in both "chain_mode.c" and "ring_mode.c"),
an unsigned integer local variable is used to hold the value returned
by dma_map_single().  On systems where a dma_addr_t is 64 bits, the
subsequent dma_mapping_error() check of the returned value operates
only on the low 32 bits (whose high bit won't be sign-extended).  In
this case, dma_mapping_error() would return 0 (no error) even if there
were one.

Fix this in both spots by using a dma_addr_t for the local variable.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/linux-devicetree/20260606010122.21A211F00899@smtp.kernel.org/
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: Alex Elder <elder@riscstar.com>
Link: https://patch.msgid.link/20260812163832.271742-2-elder@riscstar.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`pending-6.12`). The buggy `unsigned int
des2` path is present here, and this type-correctness fix should be
backported.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[net: stmmac] [use] [store dma_map_single() results as
dma_addr_t in jumbo_frm()]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Reported-by: Sashiko <sashiko-bot@kernel.org>` — static-analysis bot,
  not a user crash
- `Link: https://lore.kernel.org/linux-
  devicetree/20260606010122.21A211F00899@smtp.kernel.org/` — Sashiko
  report
- `Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>` —
  stmmac/netdev reviewer
- `Signed-off-by: Alex Elder <elder@riscstar.com>` — author
- `Link:
  https://patch.msgid.link/20260812163832.271742-2-elder@riscstar.com` —
  v2 1/2 of a net-next series
- `Signed-off-by: Jakub Kicinski <kuba@kernel.org>` — net maintainer
- No `Fixes:` tag (expected)
- No `Cc: stable` (expected)
- Ignore pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit ...]`
  if present on a candidate wrapper

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `jumbo_frm()` in `chain_mode.c` and `ring_mode.c` stores
  `dma_map_single()` in `unsigned int des2`. On 64-bit `dma_addr_t`,
  `dma_mapping_error()` only sees the low 32 bits.
- **Symptom:** a failed mapping is treated as success
  (`dma_mapping_error()` returns 0).
- **Root cause:** `DMA_MAPPING_ERROR` is `~(dma_addr_t)0`
  (`0xFFFFFFFFFFFFFFFF` on 64-bit). Truncating to `unsigned int` yields
  `0xFFFFFFFF`, which promotes to `0x00000000FFFFFFFF` and does not
  match all-ones.
- **Version info:** none in the message. The pattern dates to at least
  2016 (`f8be0d78be6e7`).

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised. It is an explicit correctness fix for a truncated
DMA error check. Changing `des2` to `dma_addr_t` also stops truncating
the address stored in `tx_skbuff_dma[].buf` (`dma_addr_t`) used for
later unmap.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- `drivers/net/ethernet/stmicro/stmmac/chain_mode.c`: +2/−1
- `drivers/net/ethernet/stmicro/stmmac/ring_mode.c`: +2/−1
- Functions: `jumbo_frm()` in both files
- Scope: single-function surgical type change in two parallel
  implementations (4 insertions, 2 deletions)

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** `unsigned int des2 = dma_map_single(...)`; then
  `cpu_to_le32(des2)`, `dma_mapping_error(..., des2)`,
  `tx_skbuff_dma[entry].buf = des2`.
- **After:** `dma_addr_t des2` so the error check and `buf` store use
  the full DMA address.
- Path: jumbo TX mapping in `stmmac_xmit()` when `enh_desc` is set and
  the frame is large enough (`>= 4KiB` ring / `> 8KiB` chain).
- Same local is reused for later `dma_map_single()` calls in those
  functions, so all mapping sites in `jumbo_frm()` are fixed.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** type / width bug that breaks error detection (and
  truncates unmap addresses).
- **Mechanism:** 32-bit truncation of a 64-bit `dma_addr_t` so
  `dma_mapping_error()` never sees `DMA_MAPPING_ERROR`.
- Verified in this tree:

```92:98:include/linux/dma-mapping.h
static inline int dma_mapping_error(struct device *dev, dma_addr_t
dma_addr)
{
        debug_dma_mapping_error(dev, dma_addr);

        if (unlikely(dma_addr == DMA_MAPPING_ERROR))
                return -ENOMEM;
        return 0;
}
```

`DMA_MAPPING_ERROR` is `~(dma_addr_t)0`. The current buggy locals:

```23:41:drivers/net/ethernet/stmicro/stmmac/chain_mode.c
        unsigned int bmax, buf_len, des2;
        ...
        des2 = dma_map_single(priv->device, skb->data,
                              buf_len, DMA_TO_DEVICE);
        desc->des2 = cpu_to_le32(des2);
        if (dma_mapping_error(priv->device, des2))
                return -1;
        tx_q->tx_skbuff_dma[entry].buf = des2;
```

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: use the type `dma_map_single()` actually returns.
- Minimal; no API or behavior change on the success path with a 32-bit
  DMA mask.
- Regression risk is low. `desc->des2` is still `__le32`, so hardware
  still gets the low 32 bits (same as before). Maxime asked to make that
  truncation explicit; that is the follow-up `c11c497af866c`
  (`lower_32_bits()`), not required for this fix to be correct.
- `cpu_to_le32()` already casts to `__u32` on little-endian; standalone
  apply should not break the build.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- `unsigned int ... des2` in ring_mode: `f8be0d78be6e7` (2016-11-15,
  “change dma descriptors to `__le32`”).
- chain_mode declaration last touched by `2c91b39912278` (already in
  this tree: “fix integer underflow in chain mode”); that commit kept
  `unsigned int des2`.
- `jumbo_frm()` itself: `286a837217204` (2011).
- Bug is long-standing, not new in 6.12.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Introducer is the 2011/2016 DMA-descriptor
code, present in this tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record (this tree):
- `2c91b39912278` net: stmmac: fix integer underflow in chain mode
  (already here)
- `133160135a6d7` STMMAC_GET_ENTRY rename
- Mainline follow-up: `c11c497af866c` net: stmmac: convert DMA address
  to lower 32 before assignment (clarity; not in this tree; not a
  functional prerequisite)
- This is standalone 1/2 of “DMA address handling fixes”; 2/2 is
  style/clarity.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Alex Elder is not the stmmac maintainer; two origin stmmac
commits are this pair. Reviewed by Maxime Chevallier; applied by Jakub
Kicinski.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: No new helpers. `dma_addr_t` and `dma_mapping_error()` exist
here. `git apply --check` of `0c1f9020d2ada` succeeded on this tree.
Parent-tree vs this tree only differs in `is_jumbo_frm()` (untouched).
Standalone apply: yes.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 0c1f9020d2ada` →
  https://patch.msgid.link/20260812163832.271742-2-elder@riscstar.com
- Series: v1 2026-08-11; v2 2026-08-12 `[PATCH net-next v2 0/2] net:
  stmmac: DMA address handling fixes`
- Applied to **net-next** (not `net`) by Jakub on 2026-08-17
- Cover: “ensure DMA errors don't get lost due to casting the result to
  an integer of the wrong size”
- No NAKs. Maxime: “I think this is good as-is” + `Reviewed-by`
- Maxime noted `cpu_to_le32(des2)` still truncates into `__le32` and
  doubted jumbo on true 64-bit descriptor addresses; that is pre-
  existing hardware-descriptor width, not a regression from this patch
- No reviewer `Cc: stable`

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): netdev maintainers (Kicinski, Dal, Pabeni, Lunn),
STM32/stmmac (Torgue, Coquelin), Maxime Chevallier. Appropriate
audience.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: Sashiko static analysis, not syzbot and not a user oops. The
lore `linux-devicetree` link is a bot dump; no independent user
reproduction was found. The bug is still visible in the code.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Companion 2/2 (`c11c497af866c`) only wraps
`cpu_to_le32(lower_32_bits(des2))`. This commit is the actual fix.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org returned HTTP 403 via WebFetch. `b4` thread has
no stable discussion. UNVERIFIED: whether this hash was already
requested on stable@; that does not change the technical verdict.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `jumbo_frm()` in `chain_mode.c` and `ring_mode.c`.

**Step 5.2: TRACE CALLERS**
Record:
- `stmmac_jumbo_frm()` macro → `hw->mode->jumbo_frm`
- Only call site: `stmmac_xmit()` when `priv->plat->enh_desc` and
  `is_jumbo_frm(skb->len)`
- Context: process / NAPI TX, not IRQ
- `dwmac4_ring_mode_ops` (DWMAC ≥ 4.00) has no `jumbo_frm`; those chips
  do not use this path
- Affected: DWMAC100 / DWMAC1000 (and early DWMAC4 that still install
  `ring_mode_ops`/`chain_mode_ops`) with enhanced descriptors

**Step 5.3: TRACE CALLEES**
Record: `dma_map_single()`, `dma_mapping_error()`, `cpu_to_le32()`,
`stmmac_prepare_tx_desc()`. On error, `return -1` → `stmmac_xmit` `goto
dma_map_err`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: userspace send / jumbo MTU → `ndo_start_xmit` = `stmmac_xmit` →
`jumbo_frm`. TSO/GSO with `priv->tso` uses `stmmac_tso_xmit` instead.
Reachable from userspace on jumbo MTU. Mapping failure is an error path
(IOMMU / swiotlb pressure).

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: non-jumbo TX in `stmmac_xmit` already uses `dma_addr_t des`.
This is leftover jumbo-path width mismatch. Historical related fix in-
tree: `06a80a7d09cc3` (descriptor addresses >32-bit).

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. Local tree is **6.12.111** (`p-6.12-3-gc504cf0baa3d8`).
Both files still have `unsigned int ... des2`. Introduced no later than
2016; present since this series branched. `git merge-base --is-ancestor
0c1f9020d2ada HEAD` is false (fix not here).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Expected **clean apply**. `git show 0c1f9020d2ada | git apply
--check` succeeded. Only unrelated `is_jumbo_frm()` signature drift vs
mainline parent.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No `dma_addr_t` jumbo_frm fix in this tree. `2c91b39912278` is a
different jumbo underflow fix and left `des2` as `unsigned int`.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `drivers/net/ethernet/stmicro/stmmac` — Synopsys DWMAC, used on
STM32, Rockchip, Allwinner, i.MX, Qualcomm, Intel, etc. Criticality:
**IMPORTANT** (common Ethernet), this path **PERIPHERAL-to-IMPORTANT**
(older GMAC + jumbo).

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively maintained, but `chain_mode.c`/`ring_mode.c` jumbo
logic is mature (2011). This is an old bug, not churn from new code.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver-specific, config `CONFIG_STMMAC_ETH`, older DWMAC with
`enh_desc`, jumbo frames, **and** 64-bit `dma_addr_t` (typical
arm64/x86_64). 32-bit `dma_addr_t` already compared equal to
`DMA_MAPPING_ERROR`.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Jumbo TX (`skb->len >= 4KiB` ring / `> 8KiB` chain) plus
`dma_map_single()` failure. Not every packet. Unprivileged users can
send jumbo frames if MTU allows; they cannot force IOMMU exhaustion
easily. Mapping failure is uncommon but real.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record:
- Failed mapping treated as success
- Descriptor programmed with `0xFFFFFFFF`
- NIC DMAs from that address (wrong memory / bus error / possible leak
  of physical memory onto the wire)
- `tx_skbuff_dma[].buf` also truncated, so unmap can be wrong
- Severity: **HIGH** (wrong DMA address / potential corruption). Not a
  guaranteed panic on every jumbo packet.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** medium-high for affected 64-bit DWMAC jumbo users; closes
  a real DMA error-handling hole
- **Risk:** very low (2-line type change per file, no locking/API
  change)
- **Ratio:** favorable

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real, verifiable type bug: truncated `dma_mapping_error()` on 64-bit
  `dma_addr_t`
- Failure can program the NIC with a bogus DMA address
- Also stores a full address in `tx_skbuff_dma[].buf`
- ~6 lines, obviously correct, reviewed, applied by net maintainer
- Buggy code is in this 6.12 tree and has been for years
- Patch applies cleanly
- Same driver already uses `dma_addr_t` on the normal TX path

AGAINST:
- Submitted to **net-next**, not `net` (not treated as an urgent
  regression)
- Sashiko/static analysis, no user oops
- Jumbo + older GMAC + mapping failure is a narrow trigger
- Reviewer noted 32-bit descriptors cannot represent full 64-bit
  addresses (pre-existing)
- Companion `lower_32_bits()` patch is not included (optional clarity)

UNRESOLVED:
- Stable@ archives not readable via WebFetch (403)
- Exact Sashiko warning text in the large 47-message dump was not
  isolated beyond the type issue this patch names

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — type matches DMA API;
   reviewed; in mainline since 2026-08-17
2. Fixes a real bug that affects users? **PASS** — missed DMA mapping
   errors on 64-bit `dma_addr_t`
3. Important issue? **PASS** — wrong DMA address on mapping failure
   (corruption / crash / possible leak), even if the window is uncommon
4. Small and contained? **PASS** — 6 lines, two files, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — `git apply --check` clean on
   6.12.111

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None (not a device ID/quirk/DT/build/docs exception). Qualifies
as a normal small bugfix.

**Step 9.4: MAKE YOUR DECISION**
The local 6.12 tree still truncates `dma_map_single()` to `unsigned int`
in `jumbo_frm()`, so `dma_mapping_error()` cannot see
`DMA_MAPPING_ERROR` on 64-bit `dma_addr_t`. That is a real DMA
correctness bug, the fix is surgical, and it applies here without
prerequisites. Narrow trigger does not outweigh the severity of
programming a failed mapping into the NIC.

### What the commit solves and why it matters to stable users
On 64-bit `dma_addr_t` platforms, a failed jumbo TX mapping is
misclassified as success, and the MAC may DMA using `0xFFFFFFFF`. 6.12
users of DWMAC1000-class stmmac with jumbo MTU on arm64/x86_64 are
exposed.

### Stable rules / risk
Meets the stable bar: real bug, small, no new API, clean apply. Risk is
a type change of a local. Benefit is correct mapping-error handling and
a full-width unmap address.

### Concerns
Optional follow-up `c11c497af866c` only makes 32-bit descriptor
truncation explicit; not required. No need to wait for other series
patches.

## Verification
- [Phase 1] Parsed tags: Sashiko Reported-by, Maxime Reviewed-by, Jakub
  SOB; no Fixes/Cc stable
- [Phase 1] Body: truncated `dma_mapping_error()` on 64-bit `dma_addr_t`
- [Phase 2] Diff: `unsigned int des2` → `dma_addr_t des2` in both
  `jumbo_frm()` implementations (+4/−2)
- [Phase 2] `include/linux/dma-mapping.h`: `dma_mapping_error()`
  compares to `DMA_MAPPING_ERROR` (`~(dma_addr_t)0`)
- [Phase 2] Local `chain_mode.c`/`ring_mode.c` still use `unsigned int
  des2`; `tx_skbuff_dma[].buf` is `dma_addr_t`
- [Phase 3] Blame: `f8be0d78be6e7` (2016) / `286a837217204` (2011); in
  this tree
- [Phase 3] Mainline SHA `0c1f9020d2ada`; follow-up `c11c497af866c` is
  clarity-only
- [Phase 3] `git merge-base --is-ancestor 0c1f9020d2ada HEAD` → not in
  this tree
- [Phase 4] `b4 dig -c 0c1f9020d2ada`: lore/msgid v2 1/2 net-next
  series; applied to netdev/net-next
- [Phase 4] `b4 dig -a`: v1 then v2; Maxime suggested `lower_32_bits()`,
  still Reviewed-by on the type fix
- [Phase 4] `b4 dig -w`: netdev + STM32/stmmac CCs
- [Phase 4] mbox cover: “DMA errors don't get lost due to casting”
- [Phase 4] UNVERIFIED: stable@ mailing list (lore 403)
- [Phase 5] Callers: `stmmac_xmit()` → `stmmac_jumbo_frm()`; DWMAC4 ≥
  4.00 ops have no `jumbo_frm`
- [Phase 5] Non-jumbo TX already uses `dma_addr_t des`
- [Phase 6] `git describe HEAD` / `make kernelversion`: 6.12.111
- [Phase 6] `git apply --check` of `0c1f9020d2ada`: success
- [Phase 6] `git diff 0c1f9020d2ada^ -- chain_mode.c ring_mode.c`: only
  `is_jumbo_frm()` drift
- [Phase 8] Failure mode: missed mapping error → NIC DMA at
  `0xFFFFFFFF`; severity HIGH
- UNVERIFIED: isolated full text of the original Sashiko diagnostic line

**YES**

 drivers/net/ethernet/stmicro/stmmac/chain_mode.c | 3 ++-
 drivers/net/ethernet/stmicro/stmmac/ring_mode.c  | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/chain_mode.c b/drivers/net/ethernet/stmicro/stmmac/chain_mode.c
index 2515608878235..5b0bab33ce4b6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/chain_mode.c
+++ b/drivers/net/ethernet/stmicro/stmmac/chain_mode.c
@@ -20,9 +20,10 @@ static int jumbo_frm(struct stmmac_tx_queue *tx_q, struct sk_buff *skb,
 	unsigned int nopaged_len = skb_headlen(skb);
 	struct stmmac_priv *priv = tx_q->priv_data;
 	unsigned int entry = tx_q->cur_tx;
-	unsigned int bmax, buf_len, des2;
+	unsigned int bmax, buf_len;
 	unsigned int i = 1, len;
 	struct dma_desc *desc;
+	dma_addr_t des2;
 
 	desc = tx_q->dma_tx + entry;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/ring_mode.c b/drivers/net/ethernet/stmicro/stmmac/ring_mode.c
index 88a8d22812f5d..1e6541937cb27 100644
--- a/drivers/net/ethernet/stmicro/stmmac/ring_mode.c
+++ b/drivers/net/ethernet/stmicro/stmmac/ring_mode.c
@@ -20,8 +20,9 @@ static int jumbo_frm(struct stmmac_tx_queue *tx_q, struct sk_buff *skb,
 	unsigned int nopaged_len = skb_headlen(skb);
 	struct stmmac_priv *priv = tx_q->priv_data;
 	unsigned int entry = tx_q->cur_tx;
-	unsigned int bmax, len, des2;
+	unsigned int bmax, len;
 	struct dma_desc *desc;
+	dma_addr_t des2;
 
 	if (priv->extend_desc)
 		desc = (struct dma_desc *)(tx_q->dma_etx + entry);
-- 
2.53.0

