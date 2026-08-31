Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9B44582EA;
	Mon, 31 Aug 2026 13:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183279; cv=none; b=NHq6noe4iUjMyAJElSiVSd+i+5055KHOoWimyf27J6JT19zWfXFLno2AK1f7ykv/3b0ZSOzQowquNahxBJX63f0UFO1nIeVrUvB3AKBjalxLCEG8Su2Ztj/cpDNBr39MUqYKdZlz7NxIOzJk0WRLJXBuTnLPstl5JWJwRhhkokM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183279; c=relaxed/simple;
	bh=YJizs2VqBuIyojrxVICumIbnQrmoxahOKx5orOk+J9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lrGQA01f8gN1iWyFwLg9D6jnFBdM6CDWc1JnI5nc0qrWn5LGYJrHLFz6GN1qUWeC49qvqT3leBD6mrP04o5KS8kJANXTAAFj+4bpyC6MwNWbDDJmYJHxOcvkl9CRnXfnpkv84QkzYzjqhMLhYMTTcaK5GAj6ae8+G+/O77Fgrug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cet1VFYp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cet1VFYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DED31F000E9;
	Mon, 31 Aug 2026 13:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183277;
	bh=Mv1Ml1dy034fuDULIdoxng0b3t1Uqj3HHmg1kDNJjak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cet1VFYppTYsj2vb7lK5LBN8tCRqms5OwvI7ENvEXnjwCFRsdSQTbVEpFtf9+E1od
	 qhrTzL9uHKrIb3QGWSgV2HtzfeAsqGfJ1wQn+nE0BZsXjk7kJqk1D1h52uHke2EUL3
	 W3Dw+M5JvNK30DqksofIZOjha8/gJysW6mCPEQMKinpC2xGk8p4mBUW/Xu71pBGQxw
	 UBoPPNGWC0Ep+SXW/bWdkuILNbxuG8VdZ9YBSRleq6bkE/gzjsNs612JxmGqFydf+i
	 AZTI+art8WXxVHcPBHDp2YHh1nDCBATQ1MfqaWHvBxKHu2IY2GxBukTFWA35gs2OKY
	 gzsk8CQawCh7Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] wifi: iwlwifi: pcie: null RX pointers after free
Date: Mon, 31 Aug 2026 09:21:19 -0400
Message-ID: <20260831133314.4125787-51-sashal@kernel.org>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 2c79d7a7b583050c9f58041465cb46fe3483ab5d ]

When iwl_pcie_tx_init() fails after RX init, nic init unwinds via
iwl_pcie_rx_free().

The freed RX members stayed non-NULL on the live transport object,
so later teardown or retry could touch stale RX state.
Set rx_pool, global_table, rxq, and alloc_page to NULL after free
to make repeated cleanup and retry paths safe.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260714141909.33e8978d8b36.Ibaedd4b0ce01405b940de7b90223b6d2c5136ffd@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[wifi: iwlwifi: pcie]` `[null]` — Null out RX pointers after
`iwl_pcie_rx_free()` so teardown/retry does not use stale state.

**Step 1.2 — Tags**

Record:
- Fixes: — not present (expected for candidate review)
- Reported-by: — none
- Tested-by: — none
- Reviewed-by: — none
- Acked-by: — none
- Link: https://patch.msgid.link/20260714141909.33e8978d8b36...
- Cc: stable@vger.kernel.org — not present (expected)
- Assisted-by: GitHubCopilot:gpt-5.3-codex
- Signed-off-by: Emmanuel Grumbach, Miri Korenblit (ignore pipeline-
  added SOBs)

Notable: no syzbot/user reports; author is Intel iwlwifi maintainer.

**Step 1.3 — Body**

Record:
- Bug: After RX init succeeds and `iwl_pcie_tx_init()` fails,
  `iwl_pcie_nic_init()` unwinds via `iwl_pcie_rx_free()`, but `rx_pool`,
  `global_table`, `rxq`, and `alloc_page` remain non-NULL.
- Symptom: Later teardown or retry can touch freed RX state.
- Root cause: `iwl_pcie_rx_free()` frees resources without clearing
  pointers, unlike the error path in `iwl_pcie_rx_alloc()`.

**Step 1.4 — Hidden bug fix?**

Record: Yes. Despite not using “fix” in the subject, this is a real
memory-safety bug (double-free / use-after-free) on an error path, not
cosmetic cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- File: `drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/rx.c` (+5 lines,
  copyright year tweak)
- Function: `iwl_pcie_rx_free()`
- Scope: single-file, surgical (~5 functional lines)

**Step 2.2 — Code flow change**

Record:
- Hunk 1 (`rx_pool`, `global_table`, `rxq`): before `kfree()` only →
  after `kfree()` + `= NULL`
- Hunk 2 (`alloc_page`): before `__free_pages()` without clearing →
  after `__free_pages()` + `alloc_page = NULL`
- Affected path: RX teardown in `iwl_pcie_rx_free()`, especially when
  called from `iwl_pcie_nic_init()` error unwind

**Step 2.3 — Bug mechanism**

Record: **Memory safety / double-free / UAF**
- `iwl_pcie_rx_alloc()` err path already NULLs pointers (lines 826–831).
- `iwl_pcie_rx_free()` did not, breaking the `if (!trans_pcie->rxq)`
  guard and leaving dangling pointers.
- On `iwl_trans_pcie_free()` after failed init: second
  `iwl_pcie_rx_free()` → double `kfree()` and UAF in
  `iwl_pcie_free_rbs_pool()`.
- On retry via `_iwl_pcie_rx_init()`: non-NULL `rxq` skips re-allocation
  and dereferences freed memory.

**Step 2.4 — Fix quality**

Record: Obviously correct; mirrors existing pattern in
`iwl_pcie_rx_alloc()` err path. Minimal, low regression risk.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record: `kfree()` lines in `iwl_pcie_rx_free()` trace to `5d324e5159d9e`
(v6.18-rc8 merge, Nov 2025). Bug present since this code landed in this
tree.

**Step 3.2 — Fixes: tag**

Record: N/A — no Fixes: tag.

**Step 3.3 — Related file history**

Record: Shallow history on `gen1_2/rx.c`; `iwl_pcie_nic_init()` tx-
failure unwind at lines 508–510 present at merge commit `5d324e5159d9e`.
Standalone one-commit fix.

**Step 3.4 — Author context**

Record: Emmanuel Grumbach is iwlwifi maintainer. Miri Korenblit has
multiple iwlwifi stable fixes in this tree (mvm/mld validation, race
fixes).

**Step 3.5 — Dependencies**

Record: None. No series markers. Self-contained.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record: `b4 dig` without commit hash failed (commit not in local repo).
`b4 dig` by subject failed (wrong usage). patch.msgid.link and
lore.kernel.org blocked by bot protection. **UNVERIFIED** for reviewer
feedback and stable nominations.

**Step 4.2 — Reviewers**

Record: **UNVERIFIED** — could not fetch thread.

**Step 4.3 — Bug report**

Record: No Reported-by or syzbot link. Bug identified by code-path
analysis.

**Step 4.4 — Related patches**

Record: **UNVERIFIED** for series context.

**Step 4.5 — Stable list**

Record: **UNVERIFIED** — lore blocked.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `iwl_pcie_rx_free()` (modified); callers `iwl_pcie_nic_init()`,
`iwl_trans_pcie_free()`.

**Step 5.2 — Callers**

Record:
- `iwl_pcie_nic_init()` (trans.c:508–510): calls `iwl_pcie_rx_free()`
  when `iwl_pcie_tx_init()` fails after RX init
- `iwl_trans_pcie_free()` (trans.c:1981): final teardown always calls
  `iwl_pcie_rx_free()`

**Step 5.3 — Callees**

Record: `cancel_work_sync()`, `iwl_pcie_free_rbs_pool()`,
`dma_free_coherent()`, `iwl_pcie_free_rxq_dma()`, `napi_disable()`,
`kfree()`, `__free_pages()`.

**Step 5.4 — Reachability**

Record:
1. `iwl_trans_start_fw()` → `iwl_pcie_nic_init()` → RX init OK, TX init
   fails → `iwl_pcie_rx_free()` (pointers left dangling)
2. Driver remove → `iwl_trans_pcie_free()` → second `iwl_pcie_rx_free()`
   → double-free/UAF
3. FW reload retry → `_iwl_pcie_rx_init()` sees non-NULL `rxq` → UAF

Triggered on probe/firmware-load failure (e.g. ENOMEM in TX path).
Reachable from normal driver operation.

**Step 5.5 — Similar patterns**

Record: `iwl_pcie_rx_alloc()` err path (lines 826–831) already NULLs the
same pointers. `base_rb_stts` was already NULLed in
`iwl_pcie_rx_free()`; this fix completes the pattern.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

**Step 6.1 — Buggy code present?**

Record: **YES.** Local tree is `v6.18.44` (`git describe HEAD`, `make
kernelversion`). `iwl_pcie_rx_free()` at lines 1243–1248 frees without
NULLing. Fix not yet applied.

**Step 6.2 — Backport complications**

Record: Clean apply expected — target lines match the provided diff
exactly. No conflicting changes found.

**Step 6.3 — Related fixes already present?**

Record: No. `git log --grep="RX pointers"` and `--grep="rx_free"` found
nothing. Only `rx_pool = NULL` in `iwl_pcie_rx_alloc()` err path, not in
`iwl_pcie_rx_free()`.

---

## Phase 7: Subsystem Context

**Step 7.1 — Subsystem**

Record: `drivers/net/wireless/intel/iwlwifi` PCIe transport —
**IMPORTANT** (Intel WiFi on many laptops/desktops; CONFIG_IWLWIFI).

**Step 7.2 — Activity**

Record: Active in 6.18.y — recent iwlwifi stable fixes (validation,
races, PTP). `gen1_2/` path is the PCIe RX/TX implementation in this
tree.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: Intel iwlwifi PCIe users (mvm/mld op-modes). Config-dependent on
`CONFIG_IWLWIFI`.

**Step 8.2 — Trigger conditions**

Record: `iwl_pcie_tx_init()` fails after successful RX init (e.g. ENOMEM
in `iwl_pcie_tx_alloc()` or `iwl_txq_init()`). Uncommon but valid; no
special privileges needed beyond loading the driver.

**Step 8.3 — Failure severity**

Record: Double-free and UAF on remove or retry → kernel
oops/crash/memory corruption. **Severity: HIGH/CRITICAL**.

**Step 8.4 — Risk vs benefit**

Record:
- Benefit: **HIGH** — prevents crash/corruption on init-failure +
  teardown/retry
- Risk: **VERY LOW** — 5 NULL assignments, established pattern
- Ratio: strongly favors backport

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence**

FOR:
- Real double-free/UAF on documented error path
- High severity (crash/corruption)
- Minimal, obviously correct fix matching existing err-path code
- Buggy code confirmed in 6.18.44
- iwlwifi maintainer authorship

AGAINST:
- Rare trigger (TX init failure after RX init)
- No fuzzer/user report (lower visibility, not lower severity)

UNRESOLVED:
- Mailing list review/stable nomination (lore blocked)
- Exact upstream commit SHA not in local repo

**Step 9.2 — Stable rules checklist**

1. Obviously correct and tested? **PASS** — mirrors
   `iwl_pcie_rx_alloc()` err path; no Tested-by
2. Fixes real bug affecting users? **PASS** — double-free/UAF on
   remove/retry after init failure
3. Important issue? **PASS** — crash/memory corruption (HIGH/CRITICAL)
4. Small and contained? **PASS** — ~5 lines, one function
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — lines match; fix not present

**Step 9.3 — Exception category**

Record: None (standard bug fix, not quirk/DT/build/doc).

**Step 9.4 — Problem summary**

When `iwl_pcie_nic_init()` fails at TX init after RX init, it calls
`iwl_pcie_rx_free()` but leaves `rxq`, `rx_pool`, `global_table`, and
`alloc_page` as dangling non-NULL pointers. A subsequent
`iwl_trans_pcie_free()` calls `iwl_pcie_rx_free()` again (double-free),
and a firmware-load retry calls `_iwl_pcie_rx_init()` which skips
allocation and uses freed memory (UAF). The fix NULLs those pointers
after free, consistent with the allocation error path.

---

## Verification

- [Phase 1] Parsed subject, tags, body from user-provided commit message
- [Phase 2] Read `rx.c` lines 766–834, 1083–1168, 1204–1249; confirmed
  diff target matches current file
- [Phase 2] Traced failure: `trans.c:508–510` calls `iwl_pcie_rx_free()`
  on `iwl_pcie_tx_init()` failure
- [Phase 2] Confirmed `iwl_pcie_rx_alloc()` err path NULLs pointers at
  lines 826–831
- [Phase 3] `git blame -L 1243,1248 rx.c`: lines from `5d324e5159d9e`
- [Phase 3] `git show 5d324e5159d9e:trans.c` lines 508–510: unwind path
  present at merge
- [Phase 3] `git log --grep="RX pointers"`: no existing fix in tree
- [Phase 4] `b4 dig`: no match (commit not local); patch.msgid.link and
  lore.kernel.org blocked — **UNVERIFIED**
- [Phase 5] `grep iwl_pcie_rx_free`: callers at `trans.c:509`,
  `trans.c:1981`
- [Phase 5] Read `tx.c:941–1004`: `iwl_pcie_tx_init()` can return error
  from alloc/init
- [Phase 5] Read `_iwl_pcie_rx_init()` lines 1090–1095: skips alloc when
  `rxq` non-NULL
- [Phase 6] `git describe HEAD`: `v6.18.44-1-g2736c32da98b9`; `make
  kernelversion`: `6.18.44`
- [Phase 6] Current `iwl_pcie_rx_free()` lacks NULL assignments (lines
  1243–1248)
- [Phase 6] `grep rx_pool = NULL` in pcie: only in alloc err path, not
  in `rx_free`
- [Phase 7] `git log -20 -- drivers/net/wireless/intel/iwlwifi/`: active
  iwlwifi maintenance
- [Phase 8] Failure mode: double-free/UAF on driver remove or FW retry
  after init failure — HIGH/CRITICAL

**YES**

 drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/rx.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/rx.c
index 619a9505e6d9d..c723839288f2e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/rx.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2003-2014, 2018-2024 Intel Corporation
+ * Copyright (C) 2003-2014, 2018-2024, 2026 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -1241,11 +1241,16 @@ void iwl_pcie_rx_free(struct iwl_trans *trans)
 		}
 	}
 	kfree(trans_pcie->rx_pool);
+	trans_pcie->rx_pool = NULL;
 	kfree(trans_pcie->global_table);
+	trans_pcie->global_table = NULL;
 	kfree(trans_pcie->rxq);
+	trans_pcie->rxq = NULL;
 
-	if (trans_pcie->alloc_page)
+	if (trans_pcie->alloc_page) {
 		__free_pages(trans_pcie->alloc_page, trans_pcie->rx_page_order);
+		trans_pcie->alloc_page = NULL;
+	}
 }
 
 static void iwl_pcie_rx_move_to_allocator(struct iwl_rxq *rxq,
-- 
2.53.0

