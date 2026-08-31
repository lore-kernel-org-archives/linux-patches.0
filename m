Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6F74AC2D0;
	Mon, 31 Aug 2026 13:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184024; cv=none; b=SG9PAgmRvTAHojUuMejdDXY7R7fT8tWQwBJT65w3Do/eJ896ptxPK+D5uga97CNInZVTzovIWV2g4cy/EYu05JMfz6vzyXS/nr+kM1Z9YF8bGFfXhA8MgPjcvaTqXMCbmZxNgaXCD9y7aw6DUB2eN5UItywAChikU9X77RzQgAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184024; c=relaxed/simple;
	bh=4Ugd7NZthPGB7/aS8BHE5sDi+bHMactzDm59QVZV/M0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YmPk+I8tE7uuNcemvQH7Xe95lViRynB+KFTsU/cfJZzvJZwcnIedCLhWpAU/u4wlXuEMSWJ9AuwfgSZ2AY9iyu/8I5DgO4DKjmQ9sQz7gbudJ0mIDNvfJn2UaxC8wQ5YJ/Hbs1GXZ47U/Y5vEkdyrRhkqRj64IxxNApxmLTROVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GEHEExPq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GEHEExPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9AD51F00ADB;
	Mon, 31 Aug 2026 13:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184020;
	bh=5pyJ96Qnm8dDNN9ZwyaQBPz/6YRx72SlNJlQ0MsCvAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GEHEExPq8hXWHWAheueGRRGnMwsvTX1IlvuEuQeuzQnjfEKq/sC6tF/W+C4B6UNPp
	 tE/T7z/Eo7ATvNkEDB1Jaw70f8v5654hK8qiL/NcyVVfV4IBKigH5eNezPEuKd3Ckr
	 9NrRIqCuqEkB1WV5L+cKWQAKdC7iMMhPF/MC0DzoKDOuZ9SouYxKCtzUqk3/wfwIkH
	 /09jnGuLHrVkWwua4GYcUOFn4vKdvstDCaE4GYi+iniVsN20KkkEJOQjcpZvsCTocp
	 SSywt+YJyOaTym2FkTX+59kdOxBoI/lifpipeYF1R27xZEnCShY8EplcOqQwd4C79k
	 GFai0ehVLpNHw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	longli@microsoft.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] net: mana: hardening: Reject zero max_num_queues from MANA_QUERY_VPORT_CONFIG
Date: Mon, 31 Aug 2026 09:27:50 -0400
Message-ID: <20260831133314.4125787-442-sashal@kernel.org>
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

From: Erni Sri Satya Vennela <ernis@linux.microsoft.com>

[ Upstream commit 93ca1575dd1f43e24ad85663305e13114f9acdf1 ]

As a part of MANA hardening for CVM, validate that max_num_sq and
max_num_rq returned by MANA_QUERY_VPORT_CONFIG are not zero. These
values flow into apc->num_queues, which is used as an allocation count
and loop bound. A zero value would result in zero-size allocations and
incorrect driver behavior.

Return -EPROTO if either value is zero.

Signed-off-by: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
Link: https://patch.msgid.link/20260430085638.1875400-1-ernis@linux.microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `net: mana: hardening: Reject zero
max_num_queues from MANA_QUERY_VPORT_CONFIG`

**Local tree:** Linux **6.18.43** (`v6.18.43-1-gc7f0dac02d232`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[net: mana]` `[hardening/validate]` — Reject zero
`max_num_sq` / `max_num_rq` from `MANA_QUERY_VPORT_CONFIG` firmware
response.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Erni Sri Satya Vennela
  `<ernis@linux.microsoft.com>` (author)
- **Signed-off-by:** Jakub Kicinski `<kuba@kernel.org>` (committer)
- **Link:** https://patch.msgid.link/20260430085638.1875400-1-
  ernis@linux.microsoft.com
- **No** Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, Cc:
  stable@vger.kernel.org
- Notable: Same author (Erni) as the already-backported MANA CVM TOCTOU
  fix (`09ec063d87c2d`) in this tree.

### Step 1.3: Body Analysis
**Record:**
- **Bug:** Firmware may return `max_num_sq == 0` or `max_num_rq == 0`
  from `MANA_QUERY_VPORT_CONFIG`.
- **Symptom:** Values flow into `apc->num_queues` (via
  `mana_init_port()`), used as allocation count and loop bound → zero-
  size allocations and incorrect driver behavior.
- **Fix:** Return `-EPROTO` if either value is zero.
- **Context:** CVM (Confidential VM) hardening — firmware/hypervisor
  responses treated as untrusted.
- **Root cause:** Missing input validation on firmware-reported queue
  limits.

### Step 1.4: Hidden Bug Fix?
**Record:** Yes. Labeled "hardening" but is a real input-validation bug
fix. Without it, zero queue counts propagate into driver state and cause
broken device behavior.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/net/ethernet/microsoft/mana/mana_en.c` (+6 lines)
- **Function:** `mana_query_vport_cfg()`
- **Scope:** Single-file, surgical validation in one function.

### Step 2.2: Code Flow Change
**Record:**
- **Hunk (lines ~1263–1268):**
  - **Before:** Accept any `max_num_sq`/`max_num_rq` from firmware after
    status check.
  - **After:** Reject zero values with `netdev_err()` + `-EPROTO`.
- **Path affected:** Port initialization during `mana_init_port()` →
  `mana_probe_port()` probe path.

### Step 2.3: Bug Mechanism
**Record:** **Input validation / logic correctness bug.**
- `mana_init_port()` computes `max_queues = min(max_txq, max_rxq)` and
  clamps `apc->num_queues` down to that value.
- With zero firmware values, `apc->num_queues` becomes 0.
- `kcalloc(0, ...)` returns `ZERO_SIZE_PTR` (non-NULL), passing `!ptr`
  checks.
- `netif_set_real_num_tx_queues(ndev, 0)` and
  `netif_set_real_num_rx_queues(ndev, 0)` both require `txq/rxq >= 1`
  and return `-EINVAL`.
- Probe can still register a netdev with carrier on before queue setup
  fails on attach.

### Step 2.4: Fix Quality
**Record:** Obviously correct, minimal, mirrors existing `-EPROTO` usage
for bad firmware status. No API changes. Very low regression risk — only
rejects values that are fundamentally invalid (a NIC cannot have zero
TX/RX queues).

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Lines `*max_sq = resp.max_num_sq` / `*max_rq =
resp.max_num_rq` blame to `19eef1d98eeda` (tree import). MANA driver and
`mana_query_vport_cfg()` exist in this 6.18.43 tree. Fix not yet
present.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related File History
**Record:** Recent MANA fixes in this tree include CVM/security-oriented
patches:
- `09ec063d87c2d` — TOCTOU fix in `hw_channel.c` (CVM, same author Erni)
- `6d13eaa13341a` — RX packet length validation (untrusted NIC data,
  backported with Cc: stable)
- `da87896f34e0a` — NULL guards to prevent panic on attach failure
Standalone fix; no "patch X/Y" series indicator.

### Step 3.4: Author Context
**Record:** Erni Sri Satya Vennela is an active MANA contributor with
multiple probe/teardown/CVM fixes already in this tree.

### Step 3.5: Dependencies
**Record:** None. Uses existing `mana_query_vport_cfg_resp` struct
(`include/net/mana/mana.h`), `netdev_err()`, and `-EPROTO`. Applies
standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Patch Discussion
**Record:** `b4 dig -c <sha>` not possible (commit not in local tree).
`b4 dig` with message-id failed (wrong syntax). WebFetch of
patch.msgid.link blocked by bot protection. **UNVERIFIED:** Full lore
review thread content.

### Step 4.2: Reviewers
**Record:** **UNVERIFIED** — could not fetch mailing list thread.

### Step 4.3: Bug Report
**Record:** No Reported-by or bugzilla/syzbot links. Bug identified
through CVM hardening code review, not a user crash report.

### Step 4.4: Related Series
**Record:** Part of broader MANA CVM hardening effort (same author as
TOCTOU fix). No evidence this is one patch of a multi-patch dependency
chain.

### Step 4.5: Stable List Discussion
**Record:** **UNVERIFIED** — could not search lore stable list. No Cc:
stable in commit message (expected for manual review candidates).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `mana_query_vport_cfg()` (modified), callers:
`mana_init_port()`.

### Step 5.2: Callers
**Record:**
- `mana_init_port()` → called from `mana_probe_port()` (probe) and
  `mana_attach()` (attach/resume)
- Triggered during MANA vPort probe/attach on Azure VMs with
  CONFIG_MICROSOFT_MANA.

### Step 5.3: Callees
**Record:** `mana_send_request()`, `mana_verify_resp_hdr()`,
`netdev_err()`.

### Step 5.4: Reachability
**Record:** Reachable during PCI probe / netdev attach of MANA devices.
Not userspace-triggerable directly, but firmware/hypervisor can return
bad `MANA_QUERY_VPORT_CONFIG` data (especially relevant in CVM where DMA
memory is shared/unencrypted per `hw_channel.c` comments).

### Step 5.5: Similar Patterns
**Record:** Driver already validates indirection table size (warn +
default). `gdma_main.c` clamps `gc->max_num_queues` against firmware
limits but does not explicitly reject zero at vport level.
`mana_rss_table_alloc()` already rejects `indir_table_sz == 0`. This
adds the analogous check for queue counts.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** `drivers/net/ethernet/microsoft/mana/mana_en.c`
lines 1263–1264 assign firmware values without zero check.
`mana_query_vport_cfg_resp` struct exists in `include/net/mana/mana.h`.
MANA driver fully present in 6.18.43.

### Step 6.2: Backport Complications
**Record:** **Clean apply.** Verified patch context matches local file
exactly (`python3` context check: `old found: True`). No conflicting
changes in the hunk area.

### Step 6.3: Related Fixes Already Present?
**Record:** Related MANA CVM/security fixes present (TOCTOU, packet
length validation). This specific zero-queue validation is **not**
present (`git log --grep="Invalid max queues"` — no match).

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
**Record:** `drivers/net/ethernet/microsoft/mana/` — network driver
(Microsoft Azure Network Adapter). **Criticality: IMPORTANT**
(production Azure VM networking, including CVM deployments).

### Step 7.2: Activity
**Record:** Actively maintained — 10+ MANA commits in recent history of
`mana_en.c` alone, including multiple stable-worthy bug fixes.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Azure VM users with MANA NICs (`CONFIG_MICROSOFT_MANA`).
Most acute for CVM (SEV-SNP/TDX) where firmware responses are explicitly
untrusted.

### Step 8.2: Trigger Conditions
**Record:** Firmware/hypervisor returns `max_num_sq == 0` or `max_num_rq
== 0` in `MANA_QUERY_VPORT_CONFIG`. Not a normal operational case;
requires buggy or malicious firmware. In CVM, malicious host is in
threat model.

### Step 8.3: Failure Mode Severity
**Record:** Without fix:
1. `apc->num_queues` set to 0
2. `kcalloc(0, ...)` returns `ZERO_SIZE_PTR` (passes NULL checks)
3. `mana_probe_port()` can succeed through `register_netdev()` +
   `netif_carrier_on()`
4. Queue allocation fails later with `-EINVAL` from
   `netif_set_real_num_*_queues()`
5. Results in broken/unusable netdev rather than clean probe failure

**Severity: MEDIUM-HIGH** — not a demonstrated kernel panic, but real
incorrect driver state and CVM input-validation gap. Consistent with
other MANA hardening already accepted into this stable tree.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Fail fast at config query; prevent broken netdev
  registration; CVM input validation aligned with existing MANA stable
  backports.
- **Risk:** Very low — 6 lines, only rejects impossible values.
- **Ratio:** Favorable for backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real validation bug with verified code path in this tree
- Causes broken driver state (registered netdev with 0 queues)
- CVM security hardening — same category as TOCTOU fix already in
  6.18.43
- Small, surgical, obviously correct
- Clean apply to local tree
- Same subsystem already receiving similar stable backports (`6d13eaa`,
  `09ec063d87c2d`)

**AGAINST backport:**
- No crash report, syzbot, or CVE cited
- Requires abnormal firmware response
- Without fix, failure is degraded functionality rather than kernel oops
- No explicit Cc: stable or maintainer stable nomination visible
- Mailing list review unverified

**UNRESOLVED:**
- Full lore review thread content
- Whether reviewers explicitly nominated for stable

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic is trivial; no Tested-
   by but pattern is standard.
2. Fixes real bug affecting users? **PASS** — broken netdev state on
   invalid firmware response.
3. Important issue? **PASS** — CVM input validation / broken device
   state (MEDIUM-HIGH; precedented in this tree's MANA backports).
4. Small and contained? **PASS** — 6 lines, one function.
5. No new features/APIs? **PASS** — validation only.
6. Can apply to local tree? **PASS** — context verified, code present.

### Step 9.3: Exception Categories
**Record:** None directly (not device ID, DT, build fix, or docs).
Qualifies as driver hardening/input-validation bug fix.

### Step 9.4: Decision Rationale
This tree (6.18.43) already carries MANA CVM hardening fixes from the
same team. The buggy code is present, the patch applies cleanly, and the
failure mode (zero queues propagating into driver state, potentially
registering a broken netdev) is a real correctness bug. While not as
severe as buffer overflow or UAF, it meets stable criteria for this tree
given established precedent and the CVM threat model where firmware
responses must not be trusted.

---

## Verification

- **[Phase 1]** Parsed commit message: subject, tags (SOB x2, Link),
  body text analyzed
- **[Phase 1]** Confirmed no Fixes:/Reported-by:/Cc: stable tags
- **[Phase 2]** Read diff: +6 lines in `mana_query_vport_cfg()`, adds
  zero-check returning `-EPROTO`
- **[Phase 2]** Read `mana_init_port()` (lines 3122–3162): `max_queues =
  min(max_txq, max_rxq)` clamps `apc->num_queues`
- **[Phase 2]** Read `mana_init_port_context()` (line 1010):
  `kcalloc(apc->num_queues, ...)`
- **[Phase 2]** Read `mana_create_txq()` (line 2373):
  `kcalloc(apc->num_queues, ...)`
- **[Phase 2]** Read `netif_set_real_num_tx_queues()` (line 3190): `txq
  < 1` returns `-EINVAL`
- **[Phase 2]** Read `netif_set_real_num_rx_queues()` (line 3240): `rxq
  < 1` returns `-EINVAL`
- **[Phase 2]** Read `mana_probe_port()` (lines 3415–3446): probe can
  succeed to `register_netdev()` + `netif_carrier_on()` before queue
  setup
- **[Phase 3]** `git describe HEAD`: v6.18.43-1-gc7f0dac02d232
- **[Phase 3]** `git blame -L 1263,1264`: lines exist since tree import
  `19eef1d98eeda`
- **[Phase 3]** `git log --grep="Invalid max queues"`: no match — fix
  not in tree
- **[Phase 3]** `git show 09ec063d87c2d`: CVM TOCTOU fix from same
  author, already in tree
- **[Phase 3]** `git show 6d13eaa13341a`: packet length validation
  backported with Cc: stable
- **[Phase 3]** `git log --author="ernis" --
  drivers/net/ethernet/microsoft/mana/`: multiple MANA fixes
- **[Phase 4]** `b4 dig` with message-id: failed (syntax/args)
- **[Phase 4]** WebFetch patch.msgid.link: blocked by bot protection —
  **UNVERIFIED** lore content
- **[Phase 5]** Grep callers: `mana_query_vport_cfg` called only from
  `mana_init_port()`
- **[Phase 5]** Read `hw_channel.c` line 278: CVM DMA sharing comment
  confirms threat model
- **[Phase 5]** Read `include/net/mana/mana.h` lines 704–713:
  `mana_query_vport_cfg_resp` struct confirmed
- **[Phase 6]** `git describe HEAD`: 6.18.43 tree confirmed
- **[Phase 6]** Read current `mana_en.c` lines 1263–1264: buggy code
  present (no zero check)
- **[Phase 6]** Python context check: patch hunks match local file (`old
  found: True`)
- **[Phase 6]** `git log --oneline -10 --
  drivers/net/ethernet/microsoft/mana/mana_en.c`: active MANA
  maintenance
- **[Phase 8]** Traced failure path: zero queues → broken probe state →
  `-EINVAL` on queue setup

**YES**The background history search finished successfully: `git log -S`
found **no commits** in this tree containing `"Invalid max queues from
vPort config"` or `"max_sq == 0"` in `mana_en.c`, which confirms the
zero-queue validation fix is **not** already present locally.

That matches the earlier analysis — the buggy code is still in the
6.18.43 tree, the patch applies cleanly, and the backport recommendation
remains **YES**.

 drivers/net/ethernet/microsoft/mana/mana_en.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index adf25acb0d46f..b61da240ac1bb 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1262,6 +1262,12 @@ static int mana_query_vport_cfg(struct mana_port_context *apc, u32 vport_index,
 
 	*max_sq = resp.max_num_sq;
 	*max_rq = resp.max_num_rq;
+
+	if (*max_sq == 0 || *max_rq == 0) {
+		netdev_err(apc->ndev, "Invalid max queues from vPort config\n");
+		return -EPROTO;
+	}
+
 	if (resp.num_indirection_ent > 0 &&
 	    resp.num_indirection_ent <= MANA_INDIRECT_TABLE_MAX_SIZE &&
 	    is_power_of_2(resp.num_indirection_ent)) {
-- 
2.53.0

