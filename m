Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C8259E341;
	Mon, 31 Aug 2026 13:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184318; cv=none; b=iZY9O4XF0FQvhiu8xEbmXXp9VnUX+w77zEeeTudZQ63ImR1kJsjnTmFPNU5HDxgJC+5/jaUuDlu6qg+8tfi7LLhjdRcWb9LvdQmWa5t5w0oPQMyNDN+bFosyjUGmHuvYYkUa8VwAuwB0PgHDod3iGmW2j4rzoGBYuZNdS9duwe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184318; c=relaxed/simple;
	bh=cdmxezoG2NhgFLxFaNitAC1Dqq0nXhsX2FUtDWN5vDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=to32qjZrZbrPEC6dl9FZYxKgVGbucbLPs8ryhBJGjlbmtPjxx1izN7cx1fKkxaNMRNZQHTZuW1OZ817V2gJY90eM032tLw6qu7az9xTBbwLPeydEWo1kk8P44E6iu0P16/R+kDUJbmyDigKVSUZ5h/aps5ZZmKCxsZRflevRMik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dw5Wc4CP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dw5Wc4CP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82871F00A3E;
	Mon, 31 Aug 2026 13:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184314;
	bh=5Gc5cieWiY2ZaOrfJQ4Gy1CSbFlsmXPWmBPayW7jOLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dw5Wc4CPMGMkkhWeYcsp1zXLUT2nOe4T94hLydih7s6oFZ7FjRh4vWeBLRSEcrj7G
	 eLKsDm9jEe+dR8krjO9V8Psq/t1NGJuOXQE26xnNG0daTA6EsuxGygk+ly5f00KLhX
	 PTIJOfv6vWV/2Qqy30fHZoal1y1QQG9iFPG1Lf4CuRYVYClb1R0uJtOnb2un7rEqja
	 SpP6cEQwrhtJQh62k2+c2hI/M21z7kBeeqXb+mAmz2CjeiwvbbnCqWDFa916Ar/erf
	 HrtxbTnF9p94mCBUxZR1/67kmwYu+9/0TAMyVjofLzfCBvVXpaHSaUiFSKJpRFD5GP
	 4o+Qoow6hl8eQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rosen Penev <rosenp@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] net: ibm: emac: fix unchecked platform_get_irq return value
Date: Mon, 31 Aug 2026 09:30:46 -0400
Message-ID: <20260831133314.4125787-618-sashal@kernel.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 1681cb1bde051c3b9ebbd337c0bfdd3e74167b2f ]

platform_get_irq() returns a negative errno on failure.
Commit a598f66d9169 replaced irq_of_parse_and_map() (which returns 0
on failure) with platform_get_irq() but dropped the error check.
Without it, a negative IRQ number is passed to devm_request_irq(),
which fails with -EINVAL instead of propagating the real error
from platform_get_irq().

Add the missing error check and goto err_gone.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260601040201.103481-1-rosenp@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[net: ibm: emac]` `[fix]` — restore missing error checking
on `platform_get_irq()` return value in `emac_probe()`.

### Step 1.2: Tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** Jacob Keller \<jacob.e.keller@intel.com\>
- **Acked-by:** — none
- **Link:**
  https://patch.msgid.link/20260601040201.103481-1-rosenp@gmail.com
- **Cc: stable:** — none (expected)
- **Signed-off-by:** Rosen Penev (author), Jakub Kicinski (net
  maintainer); ignore pipeline-added SOBs

Notable: reviewed by a netdev reviewer; no syzbot/user reports.

### Step 1.3: Body Analysis
**Record:**
- **Bug:** Commit `a598f66d9169` switched from `irq_of_parse_and_map()`
  (returns 0 on failure, with an explicit check) to `platform_get_irq()`
  (returns negative errno on failure) but removed the error check.
- **Symptom:** A negative IRQ number is passed to `devm_request_irq()`,
  which returns `-EINVAL` instead of the real errno from
  `platform_get_irq()`.
- **Root cause:** API semantics mismatch during refactor — old API used
  0 for failure; new API uses negative errnos and requires an explicit
  check.
- **Version info:** Bug introduced by `a598f66d9169` ("net: ibm: emac:
  use platform_get_irq"), present since v6.18 in this tree.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Yes — despite the straightforward message, this is a
functional probe-path bug, not cosmetic cleanup. Mishandling
`-EPROBE_DEFER` can prevent deferred reprobing (verified against
`platform_get_irq()` / `platform_get_irq_optional()` in
`drivers/base/platform.c`).

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/net/ethernet/ibm/emac/core.c` (+5 lines)
- **Function:** `emac_probe()`
- **Scope:** Single-file, surgical fix in driver probe error path

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `dev->emac_irq = platform_get_irq(...)` → immediately
  `devm_request_irq(..., dev->emac_irq, ...)`
- **After:** If `dev->emac_irq < 0`, set `err = dev->emac_irq` and `goto
  err_gone`; otherwise proceed to `devm_request_irq()`
- **Path affected:** IRQ setup during platform device probe,
  specifically the failure path

### Step 2.3: Bug Mechanism
**Record:** **Category:** Error-path / API misuse / probe-deferral bug
- `platform_get_irq()` can return `-EPROBE_DEFER`, `-ENXIO`, etc.
- `request_irq()` path does `irq_to_desc(irq)`; invalid/negative IRQ →
  `-EINVAL`
- Without the check, `-EPROBE_DEFER` becomes `-EINVAL`, breaking
  deferred probe
- Even for permanent failures, wrong errno is returned and a misleading
  second error is logged

### Step 2.4: Fix Quality
**Record:** Obviously correct; matches the documented
`platform_get_irq()` usage pattern in `drivers/base/platform.c`. Minimal
change, no API changes, very low regression risk.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Line 3045 (`platform_get_irq`) introduced by `a598f66d91693`
(Oct 2024). Prior code used `irq_of_parse_and_map()` with an explicit
`if (!dev->emac_irq)` check since 2007-era code.

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag. Manually identified introducing
commit `a598f66d9169`, confirmed present in this tree (`git merge-base
--is-ancestor` → YES).

### Step 3.3: Related File History
**Record:** Recent related commits in this tree:
- `a103cdb0681e7` — NULL deref fix (moved ioremap before `request_irq`;
  already backported)
- `c09c2e236eef6` — UAF fix during device removal (already in tree)
- `a598f66d9169` — introduced the bug
- On net-next: `8084fc9292c2b` fixes the same class of bug in `mal.c`
  (not in 6.18.y)

Standalone fix; not part of a multi-patch series.

### Step 3.4: Author Context
**Record:** Rosen Penev is an active contributor to IBM EMAC cleanup.
Multiple recent emac commits in this tree. Jacob Keller reviewed.

### Step 3.5: Dependencies
**Record:** No dependencies. Applies after `a103cdb0681e7` reordering
(`git apply --check` passes cleanly on current HEAD).

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:** `b4 dig -c 1681cb1bde051` found v1 only:
- https://patch.msgid.link/20260601040201.103481-1-rosenp@gmail.com
- No stable nomination found in thread
- No NAKs found

### Step 4.2: Reviewers
**Record:** `b4 dig -w` — CC'd netdev maintainers (Kicinski, Abeni,
Miller, etc.) and IBM EMAC reviewers (Horman, Nelson, Lunn).

### Step 4.3: Bug Reports
**Record:** No external bug report or syzbot link. Bug identified via
code review during driver cleanup.

### Step 4.4: Related Patches
**Record:** Companion fix `8084fc9292c2b` for `mal.c` same issue;
separate commit, not a prerequisite.

### Step 4.5: Stable List
**Record:** lore.kernel.org/stable search blocked by bot protection;
could not verify stable-list discussion.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `emac_probe()` — only function modified.

### Step 5.2: Callers
**Record:** `emac_probe()` is the `platform_driver.probe` callback,
invoked during device enumeration/boot on platforms with
`CONFIG_IBM_EMAC`.

### Step 5.3: Callees
**Record:** `platform_get_irq()` → may call `of_irq_get()` → can return
`-EPROBE_DEFER`; `devm_request_irq()` → `request_irq()` → rejects
invalid IRQ numbers.

### Step 5.4: Reachability
**Record:** Triggered during EMAC device probe on PowerPC/embedded
systems with IBM EMAC in device tree. Boot-time path for affected
hardware.

### Step 5.5: Similar Patterns
**Record:** Same unchecked-`platform_get_irq` pattern exists in `mal.c`
(lines 635–645) in this tree; fixed upstream separately in
`8084fc9292c2b`.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Tree is `stable/linux-6.18.y` at **v6.18.44**.
Buggy code at line 3045 of `core.c` — no check after
`platform_get_irq()`. Introducing commit `a598f66d9169` is in tree since
v6.18. Fix commit `1681cb1bde051` is **NOT** in tree.

### Step 6.2: Backport Complications
**Record:** **Clean apply.** `git show 1681cb1bde051 | git apply
--check` succeeds on current HEAD despite intervening `a103cdb0681e7`
ioremap reorder.

### Step 6.3: Related Fixes Already Present?
**Record:** `a103cdb0681e7` (NULL deref / probe ordering) and
`c09c2e236eef6` (UAF) are in tree. This specific `platform_get_irq`
check is not.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem Criticality
**Record:** `drivers/net/ethernet/ibm/emac` — **PERIPHERAL** (legacy IBM
PowerPC embedded Ethernet). Important for affected hardware, not
universal.

### Step 7.2: Activity
**Record:** Actively maintained in 2024–2026 with multiple devm/cleanup
commits and recent stable backports (`a103cdb0681e7`, `c09c2e236eef6`).

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of `CONFIG_IBM_EMAC` on PowerPC/embedded platforms
with IBM EMAC in device tree.

### Step 8.2: Trigger Conditions
**Record:** When `platform_get_irq()` fails — missing/misconfigured IRQ
in DT, or IRQ not yet available (`-EPROBE_DEFER`). Uncommon on correctly
configured systems; realistic during boot ordering on deferred-probe
paths.

### Step 8.3: Failure Mode Severity
**Record:**
- **Without fix on `-EPROBE_DEFER`:** Probe returns `-EINVAL` instead of
  deferring → driver may fail permanently → **no network on affected
  hardware** (HIGH functional impact)
- **Without fix on `-ENXIO`:** Probe still fails, but wrong errno and
  misleading log (MEDIUM)
- No crash, corruption, or security impact identified

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Restores correct probe deferral and errno propagation;
  fixes regression from `a598f66d9169` already in 6.18.y
- **Risk:** Very low — 5-line error-path addition matching kernel API
  documentation
- **Ratio:** Favorable for backport

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR:**
- Real regression from `a598f66d9169` (in this tree)
- `-EPROBE_DEFER` → `-EINVAL` conversion breaks deferred probe
- Matches documented `platform_get_irq()` usage pattern
- Small, surgical, applies cleanly
- Reviewed-by on netdev
- Related emac probe fixes already backported to 6.18.y

**AGAINST:**
- Legacy driver, small user base
- On permanent IRQ failure, probe fails either way
- No user reports or syzbot findings
- Not crash/corruption class

**UNRESOLVED:**
- No stable-list discussion verified (lore blocked)
- No confirmed user report of deferral failure in the field

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — matches API docs; reviewed;
   trivial logic
2. Fixes a real bug? **PASS** — regression; broken `-EPROBE_DEFER`
   handling
3. Important issue? **PASS** — probe deferral failure can prevent driver
   binding/network on affected hardware
4. Small and contained? **PASS** — 5 lines, one file
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — clean apply verified

### Step 9.3: Exception Categories
**Record:** None (not device ID, quirk, DT, build, or docs fix).

### Step 9.4: Decision Rationale

This is a regression fix for code already in linux-6.18.y. The missing
check can convert `-EPROBE_DEFER` into `-EINVAL`, causing permanent
probe failure instead of deferred retry — a real functional bug on the
boot/probe path. The fix is minimal, matches kernel API requirements,
applies cleanly, and carries negligible risk. While the driver serves a
niche platform, stable has already accepted other emac probe fixes for
this tree.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message and
  `git show 1681cb1bde051`
- [Phase 2] Diff analysis: +5 lines in `emac_probe()` after
  `platform_get_irq()`
- [Phase 3] `git describe HEAD` → v6.18.44; `make kernelversion` →
  6.18.44
- [Phase 3] `git blame -L 3040,3055` → `platform_get_irq` from
  `a598f66d9169`
- [Phase 3] `git show a598f66d9169` → removed `irq_of_parse_and_map`
  error check
- [Phase 3] `git merge-base --is-ancestor a598f66d9169 HEAD` → YES
- [Phase 3] `git merge-base --is-ancestor 1681cb1bde051 HEAD` → NO (fix
  not in tree)
- [Phase 3] `git log --oneline -20 --
  drivers/net/ethernet/ibm/emac/core.c` → related history
- [Phase 4] `b4 dig -c 1681cb1bde051` → lore URL found, v1 only
- [Phase 4] `b4 dig -c 1681cb1bde051 -w` → netdev maintainers CC'd
- [Phase 4] `b4 dig -c 1681cb1bde051 -m /tmp/emac_irq_thread.mbox` →
  thread saved, Reviewed-by Keller
- [Phase 4] lore stable search → blocked by bot protection (UNVERIFIED
  for stable-list discussion)
- [Phase 5] Read `platform_get_irq()` / `platform_get_irq_optional()` in
  `drivers/base/platform.c` → can return `-EPROBE_DEFER`; docs require
  `if (irq < 0) return irq`
- [Phase 5] Read `request_threaded_irq()` in `kernel/irq/manage.c` →
  `irq_to_desc(irq)` returns NULL for invalid IRQ → `-EINVAL`
- [Phase 5] Grep `emac_probe` callers → platform driver probe callback
- [Phase 6] Read current `core.c` lines 3038–3058 → buggy code confirmed
  present
- [Phase 6] `git show 1681cb1bde051 | git apply --check` → applies
  cleanly
- [Phase 6] `git show a103cdb0681e7` → different fix (ioremap ordering),
  already in tree
- [Phase 8] `git tag --contains a598f66d9169` → present since v6.18
- [Phase 8] Grep `platform_get_irq` in emac → also unchecked in `mal.c`
  (separate upstream fix `8084fc9292c2b`, not in tree)

**YES**The branch search finished successfully. On `net-next/master` it
found:

- **`1681cb1bde051`** — `net: ibm: emac: fix unchecked platform_get_irq
  return value` (the commit under review)
- **`8084fc9292c2b`** — the companion fix for the same issue in `mal.c`

Neither is in the local **linux-6.18.y** tree at v6.18.44; the buggy
unchecked `platform_get_irq()` call is still present in `core.c`. The
analysis conclusion stands: **YES** for backport.

 drivers/net/ethernet/ibm/emac/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index f48568140480e..074cc6d1050eb 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -3044,6 +3044,11 @@ static int emac_probe(struct platform_device *ofdev)
 
 	/* Setup error IRQ handler */
 	dev->emac_irq = platform_get_irq(ofdev, 0);
+	if (dev->emac_irq < 0) {
+		err = dev->emac_irq;
+		goto err_gone;
+	}
+
 	err = devm_request_irq(&ofdev->dev, dev->emac_irq, emac_irq, 0, "EMAC",
 			       dev);
 	if (err) {
-- 
2.53.0

