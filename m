Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38ED514766;
	Mon, 31 Aug 2026 13:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183804; cv=none; b=DP3ciwzkcsMgVlZCFtR2/1sPudnzd2M4ad0gR9Tx0WBGlN1nocNeGT84xbVlvdPaDZOXZO/lihHtRd+DbAiZN86tSDpMO/nDkOIyYw2WtPEoZxu+SBgDLHI3mRJCCM/blHtwpA8AmdYG6Rx+ENBRNUoXddomNuhH3y5NCAAOxN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183804; c=relaxed/simple;
	bh=M+jV4jw02+zlwNrX5y6KOU0jpuYzV9m4jW+9fSu8wE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e6QRIRq4sp2G9Mv10poiIt/ZwkuQ6t0c9oAxyP22Kz2bcxljvwJ+0e0dCawXncAhqaAMmn/fGvixWN5fZVXHksxcLnPtjqbgRO3z4KhVLEjdG2WHg7EAMhEUXN3G9Ew10iLnYDnid17RXGnWXOLCDGtezV12AqXS9GJFNn9w2d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NaiLUZ9f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NaiLUZ9f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16791F00A3D;
	Mon, 31 Aug 2026 13:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183801;
	bh=aOlKkpl7lnMnMyUPUnKNyC/W/D+wodVWQDgw4tJDr8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NaiLUZ9f+dyHAfmPxc2qCvkbyEg7iZYxfY/9Sgd6eSm0t+XZ9iWsvjOJ25hzXqmc/
	 N69JrUlWbdJs2bLrR9gjbybLMpanqK20OFUqRCCjBB/6XS5Vt58JAKYDaXzSdKZHpu
	 1684bOsohr60Qj9QZExKcTKt2oG8UxDTs5oDjlT/oB99nEPMAQ1v4a+gWXDc0gIv1h
	 2npDTIz96vMGrcPAA6ver31hRXIhnxLTn66qiPiWstZSkjWn4vxGpeyEY5l3VRRvbe
	 jfkuRMW/gfhhsJ3GmRYr3aoWHo9smE3ivWbbpLUIzU8YsvK+pDfIfK7q53ioU4fkkO
	 aCO77UtbXNoJA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Koba Ko <kobak@nvidia.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	dave@stgolabs.net,
	jic23@kernel.org,
	vishal.l.verma@intel.com,
	djbw@kernel.org,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] cxl/region: Validate partition index before array access
Date: Mon, 31 Aug 2026 09:25:40 -0400
Message-ID: <20260831133314.4125787-312-sashal@kernel.org>
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

From: Koba Ko <kobak@nvidia.com>

[ Upstream commit 16329b510f76e5b824e05bf8add8b29850f1f16f ]

construct_region() reads cxled->part and uses it to index
cxlds->part[] without checking for a negative value. If the
partition was never resolved, part remains at its initial value
of -1, causing an out-of-bounds array access.

Add a guard to return -EBUSY when part is negative.

The check was dropped during a merge.

Signed-off-by: Koba Ko <kobak@nvidia.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260414024527.3399590-1-kobak@nvidia.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[cxl/region] [validate] [partition index before array
access in construct_region()]`

### Step 1.2: Tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** Alison Schofield `<alison.schofield@intel.com>` (CXL
  maintainer/contributor)
- **Acked-by:** — none
- **Link:**
  https://patch.msgid.link/20260414024527.3399590-1-kobak@nvidia.com
- **Cc: stable@vger.kernel.org:** — absent (not a negative signal)
- **Signed-off-by:** Koba Ko `<kobak@nvidia.com>`, Dave Jiang
  `<dave.jiang@intel.com>` (ignore pipeline-added SOBs)

Notable: maintainer Reviewed-by, no syzbot/user reports.

### Step 1.3: Body Analysis
**Record:**
- **Bug:** `construct_region()` reads `cxled->part` and indexes
  `cxlds->part[part]` without validating `part` is non-negative.
  Unresolved partition leaves `part == -1` (initial value).
- **Symptom:** Out-of-bounds array access on `cxlds->part[-1]`.
- **Root cause:** Guard `if (part < 0) return ERR_PTR(-EBUSY)` was
  accidentally dropped during a merge.
- **Version info:** None explicit in message.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Not disguised — explicit OOB/array-bounds bug fix, though
described as restoring a lost merge guard.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/cxl/core/region.c` (+3 lines)
- **Function:** `construct_region()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `part = READ_ONCE(cxled->part)` then immediately
  `cxlds->part[part].mode` — with `part == -1`, indexes before
  `part[0]`.
- **After:** Early `if (part < 0) return ERR_PTR(-EBUSY)` before array
  access.
- **Path:** Region autodiscovery during endpoint port probe
  (`cxl_add_to_region()` → `construct_region()`).

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Buffer overflow / out-of-bounds access (negative array
  index).
- **Mechanism:** `cxled->part` initialized to `-1` in
  `drivers/cxl/core/port.c`; if DPA does not map to any partition,
  `hdm.c` warns but continues with `part == -1`. `construct_region()`
  then reads `cxlds->part[-1].mode` from a 2-element array
  (`CXL_NR_PARTITIONS_MAX`).

### Step 2.4: Fix Quality
**Record:**
- Obviously correct — restores guard from `be5cbd0840275`.
- Minimal (3 lines).
- Low regression risk: matches existing pattern in
  `cxl_region_attach()`; `-EBUSY` propagates through opportunistic
  `discover_region()` which already tolerates failures via `dev_dbg()`.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:**
- `construct_region()` introduced in `5ec67596e368cd` (2025-02-21, "Drop
  goto pattern of construct_region()").
- Partition indexing `cxlds->part[part].mode` added in `be5cbd0840275`
  (2025-02-03, "Kill enum cxl_decoder_mode") **with** the `part < 0`
  guard.
- Guard lost in merge `b6faa9c613787b` (2025-03-14, merge of
  `for-6.15/guard_cleanups` into `cxl-for-next2`).
- Bug present since that merge; confirmed in this tree at v6.18.44.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag. Root regression is merge
`b6faa9c613787b` dropping guard from `be5cbd0840275`. Both are ancestors
of v6.18.44.

### Step 3.3: Related File History
**Record:**
- Recent `region.c` changes in 6.18: poison injection, SPA/DPA
  translation, lock refactors — unrelated to this guard.
- Standalone fix; not part of a multi-patch series.

### Step 3.4: Author Context
**Record:** Koba Ko has limited CXL history in this tree (2 unrelated
commits). Reviewer Alison Schofield is an active CXL contributor
(region, port, trace fixes).

### Step 3.5: Dependencies
**Record:** No prerequisites. Fix is self-contained. Note: upstream diff
shows `struct cxl_region_context *ctx` signature; this tree uses `struct
cxl_endpoint_decoder *cxled` directly — trivial adaptation, same guard
placement.

---

## Phase 4: Mailing List and External Research

### Step 4.1–4.5
**Record:**
- **b4 dig:** Cannot run `-c <commit>` — commit not present in this
  checkout.
- **Lore/patch.msgid.link:** Blocked by Anubis bot protection; could not
  read thread.
- **UNVERIFIED:** Reviewer stable nomination, NAKs, series revisions.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `construct_region()`, called from `cxl_add_to_region()`.

### Step 5.2: Callers
**Record:**
- `cxl_add_to_region()` ← `discover_region()` in `drivers/cxl/port.c`
- `discover_region()` ← `cxl_endpoint_port_probe()` via
  `device_for_each_child()`
- Runs during CXL endpoint port probe after decoder enumeration

### Step 5.3: Callees
**Record:** `__create_region()`, `__construct_region()`,
`READ_ONCE(cxled->part)`, `cxlds->part[part].mode`.

### Step 5.4: Reachability
**Record:**
- Triggered on CXL hardware probe with `CONFIG_CXL_REGION=y`.
- Reachable when endpoint decoder has HPA range but `part` unresolved
  (`-1`).
- `hdm.c` explicitly allows this: warns `"does not map any partition"`
  and returns success.
- Not a syscall path, but standard driver probe on real hardware.

### Step 5.5: Similar Patterns
**Record:** Existing guards elsewhere in same file:
- `cxl_region_attach()`: `if (cxled->part < 0) return -ENODEV` (line
  1946)
- Poison context: `if (ctx->part < 0) return 0` (line 2758)

The missing guard in `construct_region()` is inconsistent — attach path
is protected, construction path is not.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Exists?
**Record:** **YES.** Local tree is **v6.18.44** (`make kernelversion` =
6.18.44). `construct_region()` at lines 3515–3543 lacks `part < 0` check
and uses `cxlds->part[part].mode` with `part` potentially `-1`.

### Step 6.2: Backport Complications
**Record:** Clean apply expected — 3 lines after `part =
READ_ONCE(cxled->part)`. Function signature differs slightly from
upstream patch (uses `cxled` not `ctx`), but guard is identical.

### Step 6.3: Related Fixes Already Present?
**Record:** `cxl_region_attach()` already has `part < 0` check (from
`be5cbd0840275`). The `construct_region()` guard specifically is
**missing** — this fix is still needed.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem Criticality
**Record:** `drivers/cxl/` — CXL memory subsystem. **IMPORTANT** for CXL
hardware users; not universal core kernel, but memory-related.

### Step 7.2: Activity
**Record:** Actively developed in 6.18 (poison, region management, lock
refactors).

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users with CXL memory devices and region autodiscovery
enabled (`CONFIG_CXL_REGION`). Systems where endpoint decoder DPA does
not map to a partition.

### Step 8.2: Trigger Conditions
**Record:**
- Endpoint decoder enumerated with `part == -1` (initial value or post-
  invalidate)
- Decoder has valid HPA range and `CXL_DECODER_STATE_AUTO`
- No existing region for that HPA range → `construct_region()` called
- Moderately plausible on misconfigured or partially mapped CXL devices

### Step 8.3: Failure Mode Severity
**Record:** OOB read of `cxlds->part[-1]` — **HIGH** severity (kernel
oops/KASAN report, possible crash; undefined behavior reading memory
before array). Not data corruption in common case, but real crash risk
on probe.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Prevents OOB access on CXL probe path; restores
  intentionally added safety check.
- **Risk:** Very low — 3-line guard, reviewed, matches existing code
  patterns.
- **Ratio:** Strong benefit, minimal risk.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real OOB bug with concrete trigger path (unresolved partition index)
- Small, surgical, obviously correct fix
- Restores guard accidentally dropped in merge `b6faa9c613787b`
- Reviewed by CXL maintainer (Alison Schofield)
- Buggy code confirmed present in v6.18.44
- Consistent with existing `part < 0` guards in same file

**AGAINST backport:**
- CXL region is hardware/config-specific (not all users)
- No user/syzbot report in commit message
- Mailing list discussion unverified

**UNRESOLVED:**
- Lore thread content and any explicit stable nomination

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — restores known-good guard;
   maintainer reviewed
2. Fixes real bug affecting users? **PASS** — OOB on CXL probe with
   unmapped partition
3. Important issue? **PASS** — OOB/crash on driver probe (HIGH)
4. Small and contained? **PASS** — 3 lines, one function
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — buggy code present; trivial
   adaptation

### Step 9.3: Exception Categories
**Record:** None (standard bug fix, not device ID/quirk/build fix).

### Step 9.4: Decision Rationale

This commit fixes a genuine out-of-bounds array access in
`construct_region()` when an endpoint decoder's partition index remains
at its initial value of `-1`. That state is explicitly allowed by
`hdm.c` (warning only, probe continues). The guard was added in
`be5cbd0840275` and accidentally dropped during merge `b6faa9c613787b`;
the fix simply restores it. For the locally checked-out **6.18.44**
tree, the vulnerable code is present and the patch applies cleanly with
at most a trivial signature adaptation.

---

## Verification

- [Phase 1] Parsed commit message: subject, Reviewed-by, Link tag; no
  Fixes/Reported-by
- [Phase 2] Diff: 3-line guard before `cxlds->part[part]` access in
  `construct_region()`
- [Phase 3] `git describe HEAD`: v6.18.44; `make kernelversion`: 6.18.44
- [Phase 3] `git blame -L 3515,3530`: `construct_region()` from
  `5ec67596e368cd`, partition indexing from `b6faa9c613787b` lineage
- [Phase 3] `git show be5cbd0840275`: added both
  `cxlds->part[part].mode` and `if (part < 0) return ERR_PTR(-EBUSY)`
- [Phase 3] `git show b6faa9c613787b:drivers/cxl/core/region.c`:
  confirmed guard absent after merge
- [Phase 3] `git merge-base --is-ancestor b6faa9c613787b v6.18.44`:
  merge is in this tree
- [Phase 3] `git log -S "if (part < 0)"`: only addition in
  `be5cbd0840275`; no later removal commit (lost in merge conflict
  resolution)
- [Phase 4] `b4 dig -c`: failed — commit not in checkout
- [Phase 4] WebFetch lore/patch.msgid.link: blocked by Anubis —
  **UNVERIFIED** mailing list discussion
- [Phase 5] `grep cxl_add_to_region`: caller chain port.c → region.c
  confirmed
- [Phase 5] `grep cxled->part`: init `-1` in port.c:2076; set `-1` on
  invalidate region.c:2133; unresolved path hdm.c:405-407
- [Phase 5] `CXL_NR_PARTITIONS_MAX = 2` in cxlmem.h — `part[-1]` is OOB
- [Phase 5] Existing guards at region.c:1946 and 2758 confirmed
- [Phase 6] Current `construct_region()` at 3515-3543: no `part < 0`
  check — bug present
- [Phase 6] `cxl_region_attach()` guard present — partial protection
  only, OOB occurs before attach
- [Phase 8] Failure mode: OOB read on probe — HIGH severity for affected
  CXL configs

**YES**

 drivers/cxl/core/region.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 41b64d871c5a1..e09ba89889397 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -3521,6 +3521,9 @@ static struct cxl_region *construct_region(struct cxl_root_decoder *cxlrd,
 	int rc, part = READ_ONCE(cxled->part);
 	struct cxl_region *cxlr;
 
+	if (part < 0)
+		return ERR_PTR(-EBUSY);
+
 	do {
 		cxlr = __create_region(cxlrd, cxlds->part[part].mode,
 				       atomic_read(&cxlrd->region_id));
-- 
2.53.0

