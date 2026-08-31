Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF205A4116;
	Mon, 31 Aug 2026 13:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184334; cv=none; b=h5VbfF/33Ab85t2UlJphKh/UIgXAdMoi2WtiHojmNbe3PuyFggbnQZf55FHxFB1UL2DCAIw9r4QbLkbokrd7Hn8bRayOlJo6sjdLlCZPNldxbCRzmUuHVTqt3XjpZR88LZdc24JCGXb9ihm+ishH3mwQwEbbe8cSOwtFvEGJTu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184334; c=relaxed/simple;
	bh=cF0Rwb4iiVUoE6QIsHGC7SlZyMYl0ckqTJN20oDZzuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JUaNVPiv8fcweBACmkqCX6OoCW4IR9zE+bBomPxKF+FdOjzanpLr+KCO4PGChEcv3ntBlS+8Svszx3l/JzYvbJpgYB+zGcTlqcXJ4B21sbCa0GHiPvVmpjHyo8NOHFDBtcXITVX1WiuGMiV09e4vdVbiVGH3GtM/d3m+G5iJaHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jqOYAdeX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jqOYAdeX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD0D1F00A3E;
	Mon, 31 Aug 2026 13:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184331;
	bh=KlS/P84QSh8TJgklCQ5BAZQdOWGMmdpiND2aQ7OWxRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jqOYAdeXyzskRVFUYm+h97hGAGGcpxwFV0ejZccXzh3Wajbni3UB09ARLIQ2MnLDL
	 xhEzHzVBDYt05FZOQXgIom/PInBu85XpfGtbmYLRyF2xzyXSJFHsPujHOJwk+uhWYR
	 KX2Hn9ADv55Vgj/7Y8HfRQRa/g8WHOnftIjDxWVB9SSIuX4eqs3KEw/zrf42DaB4c3
	 XVIpbx70ozBosblmRdMQUcHAhofZF+nfg0jVcqDgD7xgcmfQMhw31tWmDcHuj3SOvW
	 3CsvRv0T21fZY39HXZY+tB3hDIYzckpJxrnTFEDijeIvN5KZadQWC17wfsEQwlDAHo
	 KsJRb67aM88ag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	matthew.brost@intel.com,
	thomas.hellstrom@linux.intel.com,
	rodrigo.vivi@intel.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/xe/guc: Add support for NO_RESPONSE_BUSY in CTB
Date: Mon, 31 Aug 2026 09:30:58 -0400
Message-ID: <20260831133314.4125787-630-sashal@kernel.org>
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

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit 4d33314decfeac8b82d771a1bd083a59f4ac6fae ]

We only have support for G2H NO_RESPONSE_BUSY messages over MMIO,
but it turned out that GuC also uses that type of messages in CTB.

The following error was recently observed on BMG after adding VGT
policy updates to the GT restart sequence:

 [] xe 0000:03:00.0: [drm] *ERROR* Tile0: GT1: G2H channel broken on read, type=3, reset required
 [] xe 0000:03:00.0: [drm] *ERROR* Tile0: GT1: CT dequeue failed: -95
 ...
 [] xe 0000:03:00.0: [drm] *ERROR* Tile0: GT1: Timed out wait for G2H, fence 21965, action 5502, done no
 [] xe 0000:03:00.0: [drm] PF: Tile0: GT1: Failed to push 1 policy KLV (-ETIME)
 [] xe 0000:03:00.0: [drm] Tile0: GT1: { key 0x8004 : no value } # engine_group_config

where type=3 was this unrecognized NO_RESPONSE_BUSY message.

Note that GuC might send the real RESPONSE message right after
the BUSY message, so we must be prepared to update our g2h_fence
data twice before sender actually wakes up and clears the flags.

Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Link: https://patch.msgid.link/20260410110457.573-1-michal.wajdeczko@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[drm/xe/guc]` `[Add support for]` — Extend GuC CTB (Command
Transport Buffer) handling to recognize `GUC_HXG_TYPE_NO_RESPONSE_BUSY`
messages, mirroring existing MMIO-path support.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Michal Wajdeczko \<michal.wajdeczko@intel.com\>
- **Cc:** Daniele Ceraolo Spurio \<daniele.ceraolospurio@intel.com\>
- **Reviewed-by:** Daniele Ceraolo Spurio
  \<daniele.ceraolospurio@intel.com\>
- **Link:** https://patch.msgid.link/20260410110457.573-1-
  michal.wajdeczko@intel.com
- **No** Fixes:, Reported-by:, Tested-by:, Acked-by:, or Cc:
  stable@vger.kernel.org
- Notable: Reviewed-by from a co-developer; no syzbot/fuzzer report;
  real hardware log in commit body

### Step 1.3: Body Analysis
**Record:**
- **Bug:** GuC can send `NO_RESPONSE_BUSY` (HXG type 3) over the CTB G2H
  channel, but the CT path only handled it over MMIO. CT treats type 3
  as unknown and marks the channel broken.
- **Symptom:** `G2H channel broken on read, type=3, reset required` →
  `CT dequeue failed: -95` → `Timed out wait for G2H` → `Failed to push
  1 policy KLV (-ETIME)` with action `0x5502`
  (`GUC_ACTION_PF2GUC_UPDATE_VGT_POLICY`)
- **Trigger context:** Observed on BMG (Battlemage) during VGT policy
  updates in the GT restart sequence
- **Root cause:** Missing CTB handler for an existing GuC protocol
  message type; a final response may follow the BUSY message on the same
  fence

### Step 1.4: Hidden Bug Fix?
**Record:** Yes. Despite "Add support" wording, this is a protocol-
handling bug fix. The driver already handles `NO_RESPONSE_BUSY` on MMIO
(`xe_guc.c`) and in the relay path (`xe_guc_relay.c`); only the CT
blocking-send path was missing it.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/gpu/drm/xe/xe_guc_ct.c` — +36 / −2 lines
- **Functions modified:** `struct g2h_fence`, `g2h_fence_init` area,
  `guc_ct_send_recv()`, `parse_g2h_response()`, `parse_g2h_msg()`
- **New:** `g2h_fence_reinit()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code Flow Changes
**Record:**
- **`g2h_fence`:** Adds `counter` and `wait` fields for BUSY state
- **`g2h_fence_reinit()`:** Clears response-side fields via
  `memset_after()` while preserving `seqno` and `response_buffer`
- **`parse_g2h_msg()`:** Routes `GUC_HXG_TYPE_NO_RESPONSE_BUSY` to
  `parse_g2h_response()` instead of the `default` broken-channel path
- **`parse_g2h_response()`:** On BUSY, uses `xa_load()` instead of
  `xa_erase()` (fence stays registered); reinitializes fence state; sets
  `wait=true` and `counter`; skips buffer space release for intermediate
  messages
- **`guc_ct_send_recv()`:** On `g2h_fence.wait`, reinitializes fence and
  loops back to `wait_event_timeout()` for the final response

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Logic / protocol correctness — missing handler for a
  valid GuC message type
- **Mechanism:** When GuC sends type 3 over CTB, `parse_g2h_msg()` hits
  `default`, logs "channel broken", calls `CT_DEAD()`, returns
  `-EOPNOTSUPP` (−95). The waiting `guc_ct_send_recv()` then times out.
  The CT channel is left in a broken state requiring GT reset.

### Step 2.4: Fix Quality
**Record:**
- Fix is obviously correct: mirrors the existing MMIO `NO_RESPONSE_BUSY`
  pattern and the established `NO_RESPONSE_RETRY` CT handling
- Minimal, self-contained, no API changes
- Low regression risk: only affects the BUSY message path; fence lookup
  semantics are carefully preserved for intermediate vs. final responses

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** The `parse_g2h_msg()` switch (lines 1411–1427) dates to
commit `308dc9b27874d` (initial xe driver import, Jul 2025). It has
handled `NO_RESPONSE_RETRY` since import but never `NO_RESPONSE_BUSY`.
MMIO BUSY handling was added in `1d087cb7d81f9` (Nov 2023) and is
present in this tree.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related File History
**Record:**
- `1d087cb7d81f9` — MMIO `NO_RESPONSE_BUSY` fix (in tree)
- `3c01e01214026` — MMIO follow-up for unexpected messages after BUSY
  (in tree)
- `4d33314decfea` — this CTB fix (NOT in tree; `git merge-base --is-
  ancestor` returns 1)
- Recent `xe_guc_ct.c` changes are unrelated CT state/retry fixes

### Step 3.4: Author Context
**Record:** Michal Wajdeczko is an active Intel xe/GuC contributor
(`159afd92bae81`, `2506af5f8109a`, etc. on `xe_guc_ct.c`). Reviewed by
Daniele Ceraolo Spurio (co-developer).

### Step 3.5: Dependencies
**Record:** Standalone. Uses `memset_after()` (present in
`include/linux/string.h`), `GUC_HXG_TYPE_NO_RESPONSE_BUSY` and
`GUC_HXG_BUSY_MSG_0_COUNTER` (present in `abi/guc_messages_abi.h`). No
prerequisite commits required. Cherry-pick to HEAD applies cleanly
(+36/−2, auto-merge, no conflicts).

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:**
- **b4 dig -c 4d33314decfea:** https://patch.msgid.link/20260410110457.5
  73-1-michal.wajdeczko@intel.com
- **Series:** v1 (Apr 3) → v2 (Apr 8) → v3 (Apr 10); committed version
  is v3
- **Review:** Reviewed-by Daniele Ceraolo Spurio in v3
- **CI:** Patchwork CI reported failure, but for unrelated IGT test
  changes — not a functional objection to the patch logic
- **Stable nomination:** None found in mbox thread

### Step 4.2: Reviewers
**Record:** CC'd to `intel-xe@lists.freedesktop.org` and Daniele Ceraolo
Spurio. Reviewed-by from co-developer.

### Step 4.3: Bug Report
**Record:** No external bug tracker link. Reproducible failure described
in commit message with full dmesg on BMG hardware.

### Step 4.4: Related Patches
**Record:** Part of a single-patch series (not multi-patch). Related
MMIO fixes (`1d087cb7d81f9`, `3c01e01214026`) are already in this tree.

### Step 4.5: Stable List
**Record:** No stable-list discussion found.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `guc_ct_send_recv()`, `parse_g2h_response()`,
`parse_g2h_msg()`, `g2h_fence_reinit()`

### Step 5.2: Callers
**Record:** `xe_guc_ct_send_recv()` is reached via
`xe_guc_ct_send_block()` from many subsystems:
- `xe_gt_sriov_pf_policy.c` — VGT policy (action 0x5502, the reported
  failure)
- `xe_gt_sriov_pf_config.c`, `xe_gt_sriov_pf_control.c`,
  `xe_gt_sriov_pf_migration.c`
- `xe_guc.c`, `xe_guc_pc.c`, `xe_guc_submit.c`,
  `xe_guc_engine_activity.c`, `xe_guc_relay.c`

### Step 5.3: Callees
**Record:** `wait_event_timeout()`, `xa_load()`/`xa_erase()`,
`g2h_release_space()`, `wake_up_all()`, `memset_after()`

### Step 5.4: Reachability
**Record:** Triggered during normal GuC CT blocking operations — GT
reset recovery, SR-IOV PF policy/config pushes, GuC init/load, engine
activity queries. These run during device operation and GT reset paths
on systems with `CONFIG_DRM_XE`.

### Step 5.5: Similar Patterns
**Record:** MMIO path in `xe_guc.c:1458–1486` already waits through BUSY
for final response. Relay path in `xe_guc_relay.c:839–841` handles BUSY.
CT path had `NO_RESPONSE_RETRY` but not BUSY — clear inconsistency.

---

## Phase 6: Cross-Reference Against Local Tree (v6.18.43)

### Step 6.1: Buggy Code Present?
**Record:** Yes. At `parse_g2h_msg()` lines 1416–1426, type 3 falls
through to `default` and marks the G2H channel broken.
`parse_g2h_response()` has no BUSY branch. Confirmed: `git merge-base
--is-ancestor 4d33314decfea HEAD` returns 1 (fix not present).

### Step 6.2: Backport Complications
**Record:** Clean apply verified: `git cherry-pick --no-commit
4d33314decfea` auto-merges with no conflicts (+36/−2). No structural
refactoring conflicts in `xe_guc_ct.c`.

### Step 6.3: Related Fixes Already Present?
**Record:** MMIO BUSY handling (`1d087cb7d81f9`) and relay BUSY handling
are present. CT BUSY handling is the remaining gap — no duplicate fix in
tree.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem and Criticality
**Record:** `drivers/gpu/drm/xe/` — Intel Xe GPU driver. **IMPORTANT**
for Intel discrete/integrated GPU users. BMG (Battlemage) platform
support is present (`xe_pci.c` `bmg_desc`, `xe_vsec.c`, GuC firmware
defs in `xe_uc_fw.c`).

### Step 7.2: Activity
**Record:** Actively maintained — recent commits on `xe_guc_ct.c`
include CT state management, fence synchronization, and resource-leak
fixes.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of Intel Xe GPUs with GuC CT communication —
especially BMG with SR-IOV PF enabled, but any platform where GuC sends
`NO_RESPONSE_BUSY` over CTB during blocking operations.

### Step 8.2: Trigger Conditions
**Record:** GuC sends `NO_RESPONSE_BUSY` (type 3) on the CTB G2H channel
while the host is blocked in `guc_ct_send_recv()`. Observed during VGT
policy push (action 0x5502) on BMG; can affect any
`xe_guc_ct_send_block()` caller when GuC is temporarily busy. Requires
`CONFIG_DRM_XE` and functioning GuC CT.

### Step 8.3: Failure Severity
**Record:** **CRITICAL** — CT G2H channel marked broken (`CT_DEAD`),
operations fail with `-ETIME`/`-EOPNOTSUPP`, SR-IOV policy/config
provisioning fails, GT reset required. GPU functionality degrades or
becomes unusable until reset.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH — prevents CT channel corruption and cascading
  failures on a widely used communication path
- **Risk:** LOW — 36 lines, one file, follows established patterns,
  verified clean cherry-pick
- **Ratio:** Strongly favors backport

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Fixes a real, observed hardware failure on BMG
- Causes CT channel breakage and GPU reset requirement — serious
  stability impact
- Small, surgical, reviewed fix following existing MMIO/relay patterns
- Buggy code confirmed present in v6.18.43; fix not yet applied
- Cherry-picks cleanly
- Affects many callers of blocking CT send (SR-IOV, GuC init, engine
  activity, etc.)

**AGAINST backport:**
- Commit message trigger (VGT policy in GT restart sequence) may be a
  newer mainline integration; however, VGT policy push via
  `xe_guc_ct_send_block()` already exists in 6.18.43, and the bug is
  protocol-general, not restart-specific
- No explicit stable nomination or wide user reports beyond Intel
  internal testing
- CI reported unrelated test failures (not a functional NAK)

**Unresolved:** Whether the exact "VGT policy during GT restart" call
path from mainline is already in 6.18.43 — but this does not affect the
verdict because the underlying CT BUSY bug is present and reachable via
existing policy push paths.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — mirrors MMIO handling;
   Reviewed-by; observed fix on BMG
2. Fixes a real bug affecting users? **PASS** — documented dmesg on real
   hardware
3. Important issue? **PASS** — CRITICAL: CT channel broken, GPU reset,
   operation failures
4. Small and contained? **PASS** — 36 lines, 1 file
5. No new features or APIs? **PASS** — protocol parity fix, no userspace
   changes
6. Can apply to local tree? **PASS** — verified clean cherry-pick

### Step 9.3: Exception Categories
**Record:** Hardware quirk/workaround category does not apply. This is a
driver protocol-handling bug fix.

### Step 9.4: Decision Rationale
This commit closes a longstanding gap where the xe driver's GuC CT
blocking-send path did not handle `NO_RESPONSE_BUSY`, a message type the
GuC firmware legitimately sends and that the MMIO and relay paths
already handle. In v6.18.43, receiving type 3 on CTB corrupts the G2H
channel and causes timeouts and failures across SR-IOV policy, config,
and other GuC operations. The fix is small, reviewed, self-contained,
and applies cleanly to this tree.

---

## Verification

- [Phase 1] Parsed commit message and tags from `git show 4d33314decfea`
- [Phase 1] Confirmed action 0x5502 =
  `GUC_ACTION_PF2GUC_UPDATE_VGT_POLICY` in `guc_actions_sriov_abi.h`
- [Phase 1] Confirmed type 3 = `GUC_HXG_TYPE_NO_RESPONSE_BUSY` in
  `guc_messages_abi.h`
- [Phase 2] Full diff reviewed via `git show 4d33314decfea`
- [Phase 2] Read current buggy code at `xe_guc_ct.c:1411–1427` and
  `1357–1380`
- [Phase 3] `git describe HEAD` → v6.18.43
- [Phase 3] `git merge-base --is-ancestor 4d33314decfea HEAD` → exit 1
  (not in tree)
- [Phase 3] `git merge-base --is-ancestor 1d087cb7d81f9 HEAD` → exit 0
  (MMIO fix in tree)
- [Phase 3] `git merge-base --is-ancestor 3c01e01214026 HEAD` → exit 0
- [Phase 3] `git blame` on `parse_g2h_msg` switch → `308dc9b27874d`
- [Phase 4] `b4 dig -c 4d33314decfea` → lore URL found
- [Phase 4] `b4 dig -c 4d33314decfea -a` → v1/v2/v3 series, v3 committed
- [Phase 4] `b4 dig -c 4d33314decfea -w` → CC intel-xe, Daniele Ceraolo
  Spurio
- [Phase 4] `b4 dig -m /tmp/no_response_busy.mbx` → Reviewed-by
  confirmed, no stable Cc
- [Phase 5] Grep `xe_guc_ct_send_block` → 10+ call sites across xe
  driver
- [Phase 5] Read MMIO BUSY handler at `xe_guc.c:1458–1486`
- [Phase 5] Read relay BUSY handler at `xe_guc_relay.c:839–841`
- [Phase 6] Confirmed `GUC_HXG_TYPE_NO_RESPONSE_BUSY` absent from
  `xe_guc_ct.c` grep
- [Phase 6] Cherry-pick test: clean auto-merge, +36/−2
- [Phase 6] Confirmed `memset_after` in `include/linux/string.h:508`
- [Phase 6] Confirmed BMG platform in `xe_pci.c`, `xe_vsec.c`,
  `xe_uc_fw.c`
- [Phase 7] Confirmed `xe_gt_sriov_pf_policy.c` uses
  `xe_guc_ct_send_block` for action 0x5502
- [Phase 8] Failure mode verified from commit message dmesg and code
  path analysis

**YES**The background search finished and confirmed the commit: upstream
`4d33314decfea` (stable-prepared as `a405c6d35e5cc`), plus related MMIO-
side fixes already in this tree.

**Verdict for Linux 6.18.43: YES**

The CT blocking-send path in `xe_guc_ct.c` doesn't handle GuC
`NO_RESPONSE_BUSY` (type 3) messages, so it marks the G2H channel broken
and causes timeouts/failures (seen on BMG during VGT policy pushes).
MMIO and relay paths already handle this message type. The fix is small
(36 lines, one file), reviewed, and cherry-picks cleanly onto
v6.18.43.The ancestry check finished: `4d33314decfea` is **not** in
v6.18.43 (`merge-base --is-ancestor` returned exit 1). That matches the
earlier finding — the CTB `NO_RESPONSE_BUSY` fix still needs to be
backported to this tree.

 drivers/gpu/drm/xe/xe_guc_ct.c | 38 ++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_ct.c b/drivers/gpu/drm/xe/xe_guc_ct.c
index 4158e8af13908..b9d265ad06a0e 100644
--- a/drivers/gpu/drm/xe/xe_guc_ct.c
+++ b/drivers/gpu/drm/xe/xe_guc_ct.c
@@ -82,13 +82,16 @@ static void ct_dead_capture(struct xe_guc_ct *ct, struct guc_ctb *ctb, u32 reaso
 struct g2h_fence {
 	u32 *response_buffer;
 	u32 seqno;
+	/* fields below this point are setup based on the response */
 	u32 response_data;
 	u16 response_len;
 	u16 error;
 	u16 hint;
 	u16 reason;
+	u32 counter;
 	bool cancel;
 	bool retry;
+	bool wait;
 	bool fail;
 	bool done;
 };
@@ -102,6 +105,11 @@ static void g2h_fence_init(struct g2h_fence *g2h_fence, u32 *response_buffer)
 	g2h_fence->seqno = ~0x0;
 }
 
+static void g2h_fence_reinit(struct g2h_fence *g2h_fence)
+{
+	memset_after(g2h_fence, 0, seqno);
+}
+
 static void g2h_fence_cancel(struct g2h_fence *g2h_fence)
 {
 	g2h_fence->cancel = true;
@@ -1134,6 +1142,7 @@ static int guc_ct_send_recv(struct xe_guc_ct *ct, const u32 *action, u32 len,
 	/* READ_ONCEs pairs with WRITE_ONCEs in parse_g2h_response
 	 * and g2h_fence_cancel.
 	 */
+wait_again:
 	ret = wait_event_timeout(ct->g2h_fence_wq, READ_ONCE(g2h_fence.done), HZ);
 	if (!ret) {
 		LNL_FLUSH_WORK(&ct->g2h_worker);
@@ -1159,6 +1168,14 @@ static int guc_ct_send_recv(struct xe_guc_ct *ct, const u32 *action, u32 len,
 		return -ETIME;
 	}
 
+	if (g2h_fence.wait) {
+		xe_gt_dbg(gt, "H2G action %#x busy: counter %u\n",
+			  action[0], g2h_fence.counter);
+		/* we can't leave any response data if we want to wait again */
+		g2h_fence_reinit(&g2h_fence);
+		mutex_unlock(&ct->lock);
+		goto wait_again;
+	}
 	if (g2h_fence.retry) {
 		xe_gt_dbg(gt, "H2G action %#x retrying: reason %#x\n",
 			  action[0], g2h_fence.reason);
@@ -1354,7 +1371,12 @@ static int parse_g2h_response(struct xe_guc_ct *ct, u32 *msg, u32 len)
 		return -EPROTO;
 	}
 
-	g2h_fence = xa_erase(&ct->fence_lookup, fence);
+	/* don't erase as we still expect a final response with the same fence */
+	if (type == GUC_HXG_TYPE_NO_RESPONSE_BUSY)
+		g2h_fence = xa_load(&ct->fence_lookup, fence);
+	else
+		g2h_fence = xa_erase(&ct->fence_lookup, fence);
+
 	if (unlikely(!g2h_fence)) {
 		/* Don't tear down channel, as send could've timed out */
 		/* CT_DEAD(ct, NULL, PARSE_G2H_UNKNOWN); */
@@ -1365,6 +1387,12 @@ static int parse_g2h_response(struct xe_guc_ct *ct, u32 *msg, u32 len)
 
 	xe_gt_assert(gt, fence == g2h_fence->seqno);
 
+	/*
+	 * reinit as we might have already process this g2h_fence before
+	 * if we received a NO_RESPONSE_BUSY reply
+	 */
+	g2h_fence_reinit(g2h_fence);
+
 	if (type == GUC_HXG_TYPE_RESPONSE_FAILURE) {
 		g2h_fence->fail = true;
 		g2h_fence->error = FIELD_GET(GUC_HXG_FAILURE_MSG_0_ERROR, hxg[0]);
@@ -1372,6 +1400,9 @@ static int parse_g2h_response(struct xe_guc_ct *ct, u32 *msg, u32 len)
 	} else if (type == GUC_HXG_TYPE_NO_RESPONSE_RETRY) {
 		g2h_fence->retry = true;
 		g2h_fence->reason = FIELD_GET(GUC_HXG_RETRY_MSG_0_REASON, hxg[0]);
+	} else if (type == GUC_HXG_TYPE_NO_RESPONSE_BUSY) {
+		g2h_fence->wait = true;
+		g2h_fence->counter = FIELD_GET(GUC_HXG_BUSY_MSG_0_COUNTER, hxg[0]);
 	} else if (g2h_fence->response_buffer) {
 		g2h_fence->response_len = hxg_len;
 		memcpy(g2h_fence->response_buffer, hxg, hxg_len * sizeof(u32));
@@ -1379,7 +1410,9 @@ static int parse_g2h_response(struct xe_guc_ct *ct, u32 *msg, u32 len)
 		g2h_fence->response_data = FIELD_GET(GUC_HXG_RESPONSE_MSG_0_DATA0, hxg[0]);
 	}
 
-	g2h_release_space(ct, GUC_CTB_HXG_MSG_MAX_LEN);
+	/* don't release any space if it was an intermediate message */
+	if (!g2h_fence->wait)
+		g2h_release_space(ct, GUC_CTB_HXG_MSG_MAX_LEN);
 
 	/* WRITE_ONCE pairs with READ_ONCEs in guc_ct_send_recv. */
 	WRITE_ONCE(g2h_fence->done, true);
@@ -1416,6 +1449,7 @@ static int parse_g2h_msg(struct xe_guc_ct *ct, u32 *msg, u32 len)
 	case GUC_HXG_TYPE_RESPONSE_SUCCESS:
 	case GUC_HXG_TYPE_RESPONSE_FAILURE:
 	case GUC_HXG_TYPE_NO_RESPONSE_RETRY:
+	case GUC_HXG_TYPE_NO_RESPONSE_BUSY:
 		ret = parse_g2h_response(ct, msg, len);
 		break;
 	default:
-- 
2.53.0

