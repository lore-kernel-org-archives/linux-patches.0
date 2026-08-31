Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F18A4A8439;
	Mon, 31 Aug 2026 13:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183931; cv=none; b=qPfCxWhP9vt5oY8ZoGeDLaax9kPSfqKdwA8mLACJTZv7GWK06LUYHa3plNVG6O6zySNMm6oQbdJHcekJvFdeqLq4t7eaWWekRDJtuwmnNXocxfLWSrb70tgGdkS+q2mZF+aXvuubD4gRZLQ9kkjgLWTNKNcNyKHZjJAQzfHUQaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183931; c=relaxed/simple;
	bh=NnyVT+3OviRXelVeXsANKAz/6O8j4rnEUqs+1TL+XLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JKwUw0E2UjmZtkfd7xoy/jcG4mFslhBrMvFOtu68aVxFGtkttza4gN7SpUba9EwNSXafxFFh6bYl3LBcw5ZtQikHgfef4gFyy0iV/qVXLV3pSwJSXI7bGD9fN7zVH3fStvnAko6JqmPfdHKrfuyO9X0RqgEcd9nsRBge33YTRPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jl1l/0sI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jl1l/0sI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C531F00ACA;
	Mon, 31 Aug 2026 13:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183928;
	bh=aKT4gODfvKlzm3TMiYaXXiEE6Mze5yFBLKeXm2vxc9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jl1l/0sI16HoNqJyMegiqV2soMlzfuqo3WsWfKgAcW9NPCHnLOHbmDO+Cud4h7gRV
	 MdEDCceukj3Lpcg8J4fl6WFBmk7S+31jC3p615OQyuttciTGHESmQiPmAx8FSCH2Ce
	 se7HhhOpWmXwG7qMFN6DBgzrpQld5LIz5exPzg+ggHVgzoK0fW7sENxVD+FF2Pu2jO
	 IYlxF+VhRzrnDGphQxjuhgKrfEPSlGEC5UM8KCYlBStAZyPf4CyZEDVF5VTSfjM3vE
	 kzGh3MpPLPVTCdQIGf4qeYeA/ak6kZ2VmRiTmTquPOzGE+jLdRPFZpVjZ8WWJIrUtR
	 R8YHcNij9aVWg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] dpaa2-switch: fix the error path in dpaa2_switch_rx()
Date: Mon, 31 Aug 2026 09:26:54 -0400
Message-ID: <20260831133314.4125787-386-sashal@kernel.org>
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

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit 74c1c9f5c0c30bbd0c2cf87b6e3507e7ea46c13d ]

In case of an error in dpaa2_switch_rx(), the dpaa2_switch_free_fd()
function is called in order to free the FD. This is incorrect since the
dpaa2_switch_free_fd() is intended to be used on Tx frame descriptors,
meaning that it expects in the software annotation area of the FD data
to find a valid skb pointer on which to call dev_kfree_skb().

Fix this by extracting the dma_unmap_page() from
dpaa2_switch_build_linear_skb() directly into the dpaa2_switch_rx()
function. This allows us to directly use free_pages() in case of an
error before an SKB was created and kfree_skb() afterwards.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://patch.msgid.link/20260528173452.1953102-3-ioana.ciornei@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `dpaa2-switch: fix the error path in
dpaa2_switch_rx()`

**Local tree:** `v6.18.44-1-gef4bf62bccf3c` (kernel version **6.18.44**)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[dpaa2-switch]` `[fix]` — correct the error path in
`dpaa2_switch_rx()` when freeing received frame descriptors.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Ioana Ciornei \<ioana.ciornei@nxp.com\> (author)
- **Link:** https://patch.msgid.link/20260528173452.1953102-3-
  ioana.ciornei@nxp.com (patch 3/N of a series)
- **Signed-off-by:** Jakub Kicinski \<kuba@kernel.org\> (netdev
  maintainer merge)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Cc: stable, or
  syzbot tags
- Notable: subject indicates patch 3 of a series; no external bug report
  cited

### Step 1.3: Body analysis
**Record:**
- **Bug:** `dpaa2_switch_rx()` error path calls
  `dpaa2_switch_free_fd()`, which is designed for **TX** frame
  descriptors. It expects an skb pointer in the software annotation area
  at the buffer start and calls `dev_kfree_skb()`.
- **Symptom:** On RX errors, wrong teardown — interpreting raw RX page
  data as an skb pointer, wrong DMA unmap (`dma_unmap_single` vs
  `dma_unmap_page`), potential kernel oops / memory corruption.
- **Root cause:** RX buffers are `dev_alloc_pages()` + `dma_map_page()`
  with no skb stored in SWA; TX buffers store skb back-pointers for
  confirmation.
- **Fix approach:** Move `dma_unmap_page()` into `dpaa2_switch_rx()`;
  use `free_pages()` before skb exists; use `kfree_skb()` after skb
  creation.

### Step 1.4: Hidden bug fix?
**Record:** No — explicitly labeled and described as a bug fix. Misuse
of TX free helper on RX error path is a classic wrong-free-path bug.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c` only
- **Scope:** ~30 lines changed; 3 functions touched
- **Functions:** `dpaa2_switch_build_linear_skb()`, `dpaa2_switch_rx()`,
  `err_free_fd` label
- **Classification:** Single-file surgical fix

### Step 2.2: Code flow per hunk

**Hunk 1 — `dpaa2_switch_build_linear_skb()`:**
- **Before:** Unmaps DMA page internally, takes only `fd`.
- **After:** Caller provides `fd_vaddr` after unmapping; function only
  builds skb.
- **Path:** Normal RX skb construction.

**Hunk 2 — start of `dpaa2_switch_rx()`:**
- **Before:** No early unmap; unmap deferred to `build_linear_skb`.
- **After:** Unmap at entry so all error paths have valid `vaddr` for
  page free.
- **Path:** All RX frames on control interface FQ.

**Hunk 3 — `__skb_vlan_pop()` failure:**
- **Before:** `goto err_free_fd` → `dpaa2_switch_free_fd()` on skb-owned
  buffer.
- **After:** `kfree_skb(skb); return;`
- **Path:** Post-skb error path.

**Hunk 4 — `err_free_fd`:**
- **Before:** `dpaa2_switch_free_fd(ethsw, fd)` (TX helper).
- **After:** `free_pages((unsigned long)vaddr, 0)` (RX page free).
- **Path:** Pre-skb error paths (bad `if_id`, invalid format,
  `build_skb()` failure).

### Step 2.3: Bug mechanism
**Record:** **Wrong free function / memory safety bug**
- `dpaa2_switch_free_fd()` at lines 1015–1035 reads `skb = *skbh` from
  buffer start, then `dma_unmap_single()` + `dev_kfree_skb()`.
- RX buffers from `dpaa2_switch_add_bufs()` (lines 2591–2598) are plain
  pages — first bytes are packet data, not an skb pointer.
- Error before skb: NULL/invalid pointer deref + wrong unmap → **kernel
  oops**.
- Error after skb (`__skb_vlan_pop`): double-free / use of TX path on
  skb buffer → **crash or corruption**.

### Step 2.4: Fix quality
**Record:**
- **Obviously correct:** Matches existing `dpaa2_switch_free_bufs()`
  (lines 2559–2570) and sibling `dpaa2_eth_free_rx_fd()` in
  `dpaa2-eth.c`.
- **Minimal:** No API changes, no new features.
- **Regression risk:** Low — only error paths change; success path
  unchanged.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `dpaa2_switch_rx()` and `err_free_fd:
dpaa2_switch_free_fd()` introduced in **0b1b7137045886** (2021-03-10,
Ioana Ciornei, "staging: dpaa2-switch: handle Rx path on control
interface"). Bug present since RX path was added.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related file history
**Record:** Recent related fixes in this tree:
- `1b381a638e185` — bounds check for `if_id` in IRQ handler
- `00f42ace446f1` — interrupt storm after bad `if_id`
- `89764cf44544e` — validate `num_ifs`
These show bad `if_id` frames are a real concern; `dpaa2_switch_rx()`
still hits `err_free_fd` on unknown `if_id` (line 2474) with the buggy
free.

### Step 3.4: Author context
**Record:** Ioana Ciornei is original dpaa2-switch author/maintainer
(multiple commits in this file). Jakub Kicinski merged.

### Step 3.5: Dependencies
**Record:** Patch is self-contained (moves unmap, changes error free).
No new structs or helpers. Part of series (3/N) but this hunk has no
hard dependency on prior patches. **Standalone backport: yes.**

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1–4.5
**Record:**
- `b4 dig -c <commit>`: **N/A** — commit not in local tree.
- Lore/patch.msgid.link fetch: **blocked** (Anubis bot protection).
- **UNVERIFIED:** Reviewer stable nominations, NAKs, series context
  beyond "patch 3".
- Link indicates May 28, 2026 netdev submission by driver author.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `dpaa2_switch_rx()`, `dpaa2_switch_build_linear_skb()`,
`dpaa2_switch_free_fd()` (unchanged, TX-only)

### Step 5.2: Callers
**Record:** `dpaa2_switch_rx()` called from dequeue path at line 2840
when `fq->type == DPSW_QUEUE_RX`, inside NAPI poll
(`dpaa2_switch_poll`). Hot path for control-interface RX on DPAA2
switch.

### Step 5.3: Callees
**Record:** `dpaa2_iova_to_virt()`, `dma_unmap_page()`, `build_skb()`,
`free_pages()`, `kfree_skb()`, `netif_receive_skb()` on success.

### Step 5.4: Reachability
**Record:** Triggered by received frames on switch control RX FQ during
normal networking/NAPI. Error paths:
1. `if_id >= num_ifs` — plausible (recent fixes for bad `if_id`)
2. Invalid FD format
3. `build_skb()` OOM
4. `__skb_vlan_pop()` failure

### Step 5.5: Similar patterns
**Record:** `dpaa2_eth_free_rx_fd()` explicitly documents "Not to be
used for Tx conf FDs" and uses `free_pages()`.
`dpaa2_switch_free_bufs()` uses identical RX teardown. Switch driver was
inconsistent.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **YES.** Current tree at lines 2458–2520 still has
`err_free_fd: dpaa2_switch_free_fd(ethsw, fd)`. Fix **not** yet applied.

### Step 6.2: Backport complications
**Record:** Expected **clean apply** — structure matches provided diff.
Manual line-offset verification confirms identical code layout (could
not auto-apply test patch due to hunk formatting, but source matches
diff hunks).

### Step 6.3: Related fixes already present?
**Record:** No equivalent fix in tree. Related `if_id` hardening exists
but does not fix wrong RX buffer free.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
**Record:** `drivers/net/ethernet/freescale/dpaa2/` — NXP DPAA2 Ethernet
Switch (`CONFIG_FSL_DPAA2_SWITCH`). **Criticality: PERIPHERAL**
(platform-specific), but error path can crash kernel.

### Step 7.2: Activity
**Record:** Actively maintained — multiple dpaa2-switch fixes in 6.18.y
recently.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Systems with `CONFIG_FSL_DPAA2_SWITCH` (NXP Layerscape MC
bus switch). Enterprise/embedded DPAA2 deployments.

### Step 8.2: Trigger conditions
**Record:** Any RX error on control interface — bad `if_id` most
realistic given recent related fixes. Not userspace-syscall reachable
directly, but network-delivered frames can trigger. **Likelihood:
low–medium** on error paths; **non-zero** with bad hardware/config.

### Step 8.3: Failure mode
**Record:** Kernel oops / invalid memory free / DMA API misuse.
**Severity: HIGH** (system crash on error path).

### Step 8.4: Risk vs benefit
**Record:**
- **Benefit:** Prevents crash on RX error teardown; fixes long-standing
  bug since 2021.
- **Risk:** Very low — ~30 lines, error-path only, mirrors established
  in-driver pattern.
- **Ratio:** Strong benefit, minimal risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real bug: TX free helper used on RX buffers
- Can cause kernel oops / memory corruption
- Present in 6.18.44 since RX path introduction (2021)
- Small, surgical, obviously correct
- Aligns with `dpaa2_switch_free_bufs()` and `dpaa2-eth` RX patterns
- Recent related `if_id` fixes suggest error paths are exercised
- No new features or APIs

**AGAINST backport:**
- Platform-specific driver (limited user base)
- Error paths are uncommon (not every boot)
- Mailing list review details unverified

**UNRESOLVED:**
- Full series context for patches 1–2
- Whether reviewers nominated for stable

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic matches existing RX
   free patterns in same subsystem; maintainer merged.
2. Fixes real bug affecting users? **PASS** — wrong free on RX error
   path.
3. Important issue? **PASS** — kernel crash on error path (HIGH
   severity).
4. Small and contained? **PASS** — single file, ~30 lines.
5. No new features/APIs? **PASS**.
6. Can apply to local tree? **PASS** — buggy code present; fix applies
   cleanly.

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
bug fix.

### Step 9.4: Decision rationale
For **6.18.44**, the buggy `err_free_fd` path has existed since the RX
handler was added. Using `dpaa2_switch_free_fd()` on RX page buffers is
incorrect and can crash the kernel when any RX error occurs. The fix is
minimal, follows established patterns in the same driver and in
`dpaa2-eth.c`, and only changes error handling. Platform scope is
narrow, but stable trees routinely take driver crash fixes for affected
hardware.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit
  message
- **[Phase 2]** Read `dpaa2-switch.c` lines 1015–1035, 2423–2521,
  2559–2603; confirmed TX vs RX buffer layout difference
- **[Phase 3]** `git describe HEAD` → v6.18.44; `git blame` → bug since
  0b1b7137045886 (2021-03-10)
- **[Phase 3]** `git show 0b1b7137045886` → original `err_free_fd` used
  `dpaa2_switch_free_fd`
- **[Phase 3]** `git log --oneline -20 -- dpaa2-switch.c` → related
  if_id fixes present
- **[Phase 3]** `git log --grep='dpaa2-switch: fix the error path'` →
  fix **not** in tree
- **[Phase 4]** `b4 dig -c HEAD` → unrelated match; commit not in tree
  for `-c`
- **[Phase 4]** WebFetch lore/patch.msgid.link → blocked by Anubis
  (**UNVERIFIED** review discussion)
- **[Phase 5]** Grep callers → `dpaa2_switch_rx` at line 2840 in NAPI
  dequeue
- **[Phase 5]** Read `dpaa2-eth.c` `dpaa2_eth_free_rx_fd()` and
  `dpaa2_eth_rx()` → correct RX pattern confirmed
- **[Phase 6]** Confirmed buggy code at lines 2519–2520 in 6.18.44
  checkout
- **[Phase 6]** Read Kconfig → `CONFIG_FSL_DPAA2_SWITCH` tristate driver
- **[Phase 8]** Classified failure as kernel oops on RX error path, HIGH
  severity

**YES**The analysis is complete: **backport to this tree (6.18.44) is
recommended.**

`dpaa2_switch_rx()` uses the TX helper `dpaa2_switch_free_fd()` on RX
error paths, but RX buffers are plain pages without an skb in the
software annotation area. That can cause a kernel oops on errors such as
bad `if_id`, invalid frame format, or `build_skb()` failure. The fix is
small (~30 lines), matches the existing RX teardown pattern in
`dpaa2_switch_free_bufs()` and `dpaa2-eth.c`, and the buggy code is
still present in your checkout.

 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 23 ++++++++++---------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 13e9e0f34a1b9..c65ecb187af3d 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2438,18 +2438,13 @@ static int dpaa2_switch_port_blocking_event(struct notifier_block *nb,
 
 /* Build a linear skb based on a single-buffer frame descriptor */
 static struct sk_buff *dpaa2_switch_build_linear_skb(struct ethsw_core *ethsw,
-						     const struct dpaa2_fd *fd)
+						     const struct dpaa2_fd *fd,
+						     void *fd_vaddr)
 {
 	u16 fd_offset = dpaa2_fd_get_offset(fd);
-	dma_addr_t addr = dpaa2_fd_get_addr(fd);
 	u32 fd_length = dpaa2_fd_get_len(fd);
 	struct device *dev = ethsw->dev;
 	struct sk_buff *skb = NULL;
-	void *fd_vaddr;
-
-	fd_vaddr = dpaa2_iova_to_virt(ethsw->iommu_domain, addr);
-	dma_unmap_page(dev, addr, DPAA2_SWITCH_RX_BUF_SIZE,
-		       DMA_FROM_DEVICE);
 
 	skb = build_skb(fd_vaddr, DPAA2_SWITCH_RX_BUF_SIZE +
 			SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
@@ -2475,6 +2470,7 @@ static void dpaa2_switch_tx_conf(struct dpaa2_switch_fq *fq,
 static void dpaa2_switch_rx(struct dpaa2_switch_fq *fq,
 			    const struct dpaa2_fd *fd)
 {
+	dma_addr_t addr = dpaa2_fd_get_addr(fd);
 	struct ethsw_core *ethsw = fq->ethsw;
 	struct ethsw_port_priv *port_priv;
 	struct net_device *netdev;
@@ -2482,10 +2478,14 @@ static void dpaa2_switch_rx(struct dpaa2_switch_fq *fq,
 	struct sk_buff *skb;
 	u16 vlan_tci, vid;
 	int if_id, err;
+	void *vaddr;
+
+	vaddr = dpaa2_iova_to_virt(ethsw->iommu_domain, addr);
+	dma_unmap_page(ethsw->dev, addr, DPAA2_SWITCH_RX_BUF_SIZE,
+		       DMA_FROM_DEVICE);
 
 	/* get switch ingress interface ID */
 	if_id = upper_32_bits(dpaa2_fd_get_flc(fd)) & 0x0000FFFF;
-
 	if (if_id >= ethsw->sw_attr.num_ifs) {
 		dev_err(ethsw->dev, "Frame received from unknown interface!\n");
 		goto err_free_fd;
@@ -2501,7 +2501,7 @@ static void dpaa2_switch_rx(struct dpaa2_switch_fq *fq,
 		}
 	}
 
-	skb = dpaa2_switch_build_linear_skb(ethsw, fd);
+	skb = dpaa2_switch_build_linear_skb(ethsw, fd, vaddr);
 	if (unlikely(!skb))
 		goto err_free_fd;
 
@@ -2519,7 +2519,8 @@ static void dpaa2_switch_rx(struct dpaa2_switch_fq *fq,
 		err = __skb_vlan_pop(skb, &vlan_tci);
 		if (err) {
 			dev_info(ethsw->dev, "__skb_vlan_pop() returned %d", err);
-			goto err_free_fd;
+			kfree_skb(skb);
+			return;
 		}
 	}
 
@@ -2534,7 +2535,7 @@ static void dpaa2_switch_rx(struct dpaa2_switch_fq *fq,
 	return;
 
 err_free_fd:
-	dpaa2_switch_free_fd(ethsw, fd);
+	free_pages((unsigned long)vaddr, 0);
 }
 
 static void dpaa2_switch_detect_features(struct ethsw_core *ethsw)
-- 
2.53.0

