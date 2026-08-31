Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0179A4E72CC;
	Mon, 31 Aug 2026 13:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183616; cv=none; b=Y++8YjqAQxLkUx8fd6vUFo81Z1SKx5SkFw4ZtMcTLheahfbjg/2VanwedRs2O38UggIfrWb2V6uFQ+nWFY2EcmDHgH6iuLiFZQYJWaVwQ/+5vrYLK+56iuTFgcqHfsNUuRQxU6OChTfzjY4NKPGvh4KtBOXitueyXjGHlFQCSgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183616; c=relaxed/simple;
	bh=vkj8uX3eX6J+roaNRlRmqvE+e0tMqJtGQEBsIjdOc+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aSZwisn3DzVmINtPyR6/y/puzSr09a2dMcFlqMOyLzIB2goyYVWiAmQJ1yzPMUuZYRQDVL+gLGoFNcXxnHMKUCtxCX9fonADQGn1eWWgTU2GmW8vdKFGwDu/JnFEYSv0O8qlRh25wjV55eAOGKstmx4H7ooJxSmAoqY65W6ngoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RGLxyybF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RGLxyybF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE261F00ADB;
	Mon, 31 Aug 2026 13:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183610;
	bh=Yq6Mdxh0jkqBSFkAD2RA+4AJxPzQN+7r6ks3XffwD1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RGLxyybFJTfvebRFa0MqjNnYLe0kkmU55DhcRRJtypWCObZmSQsVS7CdTxsldeBcD
	 7hne+H6ETHhyQkAggjqYzbdLjO5FzHAk+PuniLOtUdWxmRk5lhYcDJ8qwcEbjq0tbo
	 qfLNnEd8C0j6RU7j2woIZVPR0zjBSjJQZfqH4WTEKZ8/7jh3i3KmjRreE7yoWStFdP
	 ql1SaQgEpnIPxgdbwoFjglDTaBFQ9B63xJSrSL2oL9u0n+zJRFlx7g5X5SROU+exTZ
	 v7cU7OTUeCNybm70xkGARwhN2nQjSDwBphBGVPpsm0W9ibiMvCI67G0jDJkwUvDsro
	 dWV1QUwrtaX3w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sgoutham@marvell.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	linux-arm-kernel@lists.infradead.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] net: thunderx: fix PTP device ref leak in nicvf_probe()
Date: Mon, 31 Aug 2026 09:23:45 -0400
Message-ID: <20260831133314.4125787-197-sashal@kernel.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

[ Upstream commit 2bcf59eefb9f00a2b1d426b639ee49c305a80695 ]

cavium_ptp_get() acquires a reference to the PTP PCI device
through pci_get_device(). If any initialization step fails
after cavium_ptp_get(), the PTP PCI device reference is leaked.
Add a common error path to release the PTP reference before
returning from probe failures.

Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Link: https://patch.msgid.link/20260525082611.61817-1-lihaoxiang@isrc.iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
# Stable Backport Analysis: `net: thunderx: fix PTP device ref leak in
nicvf_probe()`

**Local tree:** `stable/linux-6.18.y` at `v6.18.44` (Makefile: 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[net: thunderx]` `[fix]` — PTP PCI device reference leak in
`nicvf_probe()` error paths.

### Step 1.2: Tags
**Record:**
- **Link:** `https://patch.msgid.link/20260525082611.61817-1-
  lihaoxiang@isrc.iscas.cn`
- **Signed-off-by:** Haoxiang Li `<lihaoxiang@isrc.iscas.ac.cn>`
  (author)
- **Signed-off-by:** Jakub Kicinski `<kuba@kernel.org>` (net maintainer
  merge)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable@vger.kernel.org`, or syzbot links

### Step 1.3: Body analysis
**Record:**
- **Bug:** `cavium_ptp_get()` takes a PCI device reference via
  `pci_get_device()`. Any probe failure after a successful
  `cavium_ptp_get()` returns without calling `cavium_ptp_put()`.
- **Symptom:** PCI device reference leak on probe failure (not a crash
  on the happy path).
- **Root cause:** Missing shared error-path cleanup; success path stores
  the ref in `nic->ptp_clock` and `nicvf_remove()` calls
  `cavium_ptp_put()`, but error paths bypass that.
- **Version info:** None in the message.

### Step 1.4: Hidden bug fix?
**Record:** No — explicitly labeled a reference leak fix.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/net/ethernet/cavium/thunder/nicvf_main.c` (+4 / −2
  lines)
- **Function:** `nicvf_probe()`
- **Scope:** Single-file, surgical probe error-path fix

### Step 2.2: Code flow change
**Record:**
- **Hunk 1 (pci_enable_device failure):** Before: `return
  dev_err_probe(...)` leaked the PTP ref. After: `goto err_put_ptp`.
- **Hunk 2 (shared error tail):** Before: `err_disable_device` returned
  without releasing PTP. After: new `err_put_ptp:` calls
  `cavium_ptp_put(ptp_clock)` before `return err`. All existing `goto
  err_*` chains that reach `err_disable_device` now release the PTP
  reference.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Resource / reference-count leak on probe error path
- **Mechanism:** `cavium_ptp_get()` (lines 59–76 of `cavium_ptp.c`)
  calls `pci_get_device()` and, on success, returns `ptp` without
  `pci_dev_put()`. The caller must call `cavium_ptp_put()`, which does
  `pci_dev_put(ptp->pdev)`. Error paths after a successful get never did
  that; only `nicvf_remove()` did on the success path.

### Step 2.4: Fix quality
**Record:**
- Fix is minimal and mirrors the remove path.
- `cavium_ptp_put(NULL)` is safe (`if (!ptp) return;` in
  `cavium_ptp.c:81–82`), so the `-ENODEV`/virtualized path (`ptp_clock =
  NULL`) is handled.
- Low regression risk; no API or locking changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- `cavium_ptp_get()` in probe: `4a8755096466d` (Sunil Goutham,
  2018-01-15) — `net: thunderx: add timestamping support`
- `pci_enable_device` early return without cleanup: same era; later
  changed to `dev_err_probe` in `52583c8d8b12f2` (2021) without adding
  `cavium_ptp_put()`
- Bug present since PTP support was added (~v4.16 era); present in this
  6.18.y tree

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag. Introducing commit is
`4a8755096466d`.

### Step 3.3: Related file history
**Record:**
- `42330a32933fb` — `net: thunderx: Fix missing destroy_workqueue of
  nicvf_rx_mode_wq` (probe error-path fix in the same function; already
  in 6.18.y)
- `c1055b76ad00a` — mutex init ordering fix in same probe
- `a7d40cbb24900` — `imply CAVIUM_PTP` build fix
- Standalone one-commit fix; not part of a series

### Step 3.4: Author context
**Record:** Haoxiang Li has similar probe leak fixes in this tree
(`715cce38424fb` liquidio BAR leak, `dc8347f263b21` ipa SMEM leak). Not
the thunderx maintainer, but pattern matches accepted stable leak fixes.

### Step 3.5: Dependencies
**Record:** None. Uses existing `cavium_ptp_put()`; no structural
prerequisites. Fix not yet merged (`err_put_ptp` absent in this tree).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c HEAD` did not match this patch (different
commit). Lore/patch.msgid.link blocked by Anubis bot protection.
**UNVERIFIED:** full review thread and any `Cc: stable` nominations.

### Step 4.2: Reviewers
**Record:** **UNVERIFIED** (`b4 dig -w` not usable without commit hash).

### Step 4.3: Bug report
**Record:** No external bug report or syzbot link; found by code
inspection.

### Step 4.4: Related patches
**Record:** Standalone; no series dependency.

### Step 4.5: Stable list
**Record:** **UNVERIFIED** — lore stable search blocked.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `nicvf_probe()`, `cavium_ptp_get()`, `cavium_ptp_put()`

### Step 5.2: Callers
**Record:** `nicvf_probe()` is the PCI driver probe (`module_pci_driver`
path) — runs at device enumeration / module load for `THUNDER_NIC_VF`.

### Step 5.3: Callees
**Record:** `cavium_ptp_get()` → `pci_get_device()`; `cavium_ptp_put()`
→ `pci_dev_put()`.

### Step 5.4: Reachability
**Record:** Triggered when `CONFIG_THUNDER_NIC_VF` + `CONFIG_CAVIUM_PTP`
are enabled on Cavium ThunderX/Marvell 64-bit PCI systems and probe
fails after PTP device is found. Not userspace-syscall reachable; driver
probe error path only.

### Step 5.5: Similar patterns
**Record:** Same driver already had probe error-path gaps fixed
(`42330a32933fb` workqueue). `07a2e1cf39818` fixed NULL deref in
`cavium_ptp_put()`.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.y)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current tree at lines 2097–2108 and 2258–2262 shows
`cavium_ptp_get()` followed by error returns/`goto` chains without
`cavium_ptp_put()`. `err_put_ptp` not present.

### Step 6.2: Backport complications
**Record:** Clean apply expected — context matches the provided diff.

### Step 6.3: Related fixes already present?
**Record:** Other `nicvf_probe()` error-path fixes exist
(`42330a32933fb`); this PTP ref leak fix is **not** present.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
**Record:** `drivers/net/ethernet/cavium/thunder/` — ThunderX NIC VF
driver. **Criticality: PERIPHERAL** (platform-specific
datacenter/embedded hardware).

### Step 7.2: Activity
**Record:** Moderate recent activity (workqueue fix, XDP features, mutex
ordering).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of Cavium ThunderX NIC VF with PTP (`THUNDER_NIC_VF` +
`CAVIUM_PTP`). Not universal.

### Step 8.2: Trigger conditions
**Record:** Any `nicvf_probe()` failure after successful
`cavium_ptp_get()` — e.g. `pci_enable_device`, `pci_request_regions`,
DMA setup, `alloc_etherdev_mqs`, register setup, `register_netdev`
failures. Uncommon in steady state; more likely during bring-up,
hardware issues, or driver reload/debug. Not unprivileged-triggerable.

### Step 8.3: Failure mode severity
**Record:** PCI device reference leak per failed probe. Can prevent
proper PTP device teardown, accumulate refs on repeated probe attempts,
and interfere with module unload/reprobe. **Severity: MEDIUM** (resource
leak, not crash/corruption/security).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Correct probe error cleanup; aligns with prior thunderx
  probe fixes in stable
- **Risk:** Very low (4 lines, uses existing helper, NULL-safe)
- **Ratio:** Moderate benefit for affected hardware, very low risk

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence

**FOR:**
- Real, verifiable PCI ref leak on all post-`cavium_ptp_get()` error
  paths
- Bug since 2018; present in 6.18.y
- Small, obviously correct fix
- Precedent: `42330a32933fb` fixed a similar `nicvf_probe()` error-path
  bug in this stable tree
- Resource leaks are standard stable material per project norms
- Merged by net maintainer (Jakub Kicinski)

**AGAINST:**
- Platform-specific (ThunderX only)
- Only hits probe failure paths (rare in production)
- MEDIUM severity — no crash, corruption, or security impact
- No fuzzer/user reports

**UNRESOLVED:**
- Mailing list review details and stable nominations (lore blocked)

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is clear; no runtime
   test cited
2. Fixes a real bug? **PASS** — confirmed ref leak in code
3. Important issue? **PASS (borderline/MEDIUM)** — resource leak, not
   crash/corruption
4. Small and contained? **PASS** — 4 net lines, one file
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — buggy code exists; clean apply
   expected

### Step 9.3: Exception categories
**Record:** None (not a quirk/DT/build/doc fix; standard probe error-
path leak fix).

### Step 9.4: Decision rationale

For **linux-6.18.y**, this is a valid stable backport: the leak has been
present since PTP support was added, the fix is minimal and safe, and
the same driver's probe function already received a comparable error-
path fix in this tree. Impact is limited to ThunderX + PTP
configurations and probe-failure scenarios, but the fix cost is
negligible and prevents a real reference leak that can affect driver
reload and device lifecycle management on affected systems.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message
- [Phase 2] Read current `nicvf_probe()` at lines 2090–2263; confirmed
  missing `cavium_ptp_put()` on error paths
- [Phase 2] Read `cavium_ptp_get()`/`cavium_ptp_put()` in
  `cavium_ptp.c:59–85`; confirmed refcount contract
- [Phase 3] `git describe HEAD` → `v6.18.44`; branch
  `stable/linux-6.18.y`
- [Phase 3] `git blame -L 2095,2110` → PTP get added in `4a8755096466d`
  (2018)
- [Phase 3] `git show 4a8755096466d1` → original probe lacked
  `cavium_ptp_put()` on `pci_enable_device` failure
- [Phase 3] `git log -S "err_put_ptp"` → empty (fix not merged)
- [Phase 3] `42330a32933fb` in tree — prior thunderx probe error-path
  fix
- [Phase 4] WebFetch lore/patch.msgid.link → blocked by Anubis
  (**UNVERIFIED** review thread)
- [Phase 4] `b4 dig -c HEAD` → no match for this patch
- [Phase 5] `grep cavium_ptp_get` → only `nicvf_main.c` in thunder
  drivers
- [Phase 6] Confirmed buggy code at lines 2106–2108 (`return` without
  put) and 2260–2262 (no `err_put_ptp`)
- [Phase 6] `grep err_put_ptp` → not found
- [Phase 7] Read `drivers/net/ethernet/cavium/Kconfig` —
  `THUNDER_NIC_VF` implies `CAVIUM_PTP`
- [Phase 8] Assessed severity MEDIUM (probe-only PCI ref leak on niche
  hardware)

**YES**The background git search finished. It didn’t find the PTP ref-
leak fix (`err_put_ptp` isn’t in this tree), but it did turn up related
`nicvf_probe()` work already on 6.18.y — the workqueue destroy fix
(`42330a32933fb`), mutex init ordering (`c1055b76ad00a`), and the `imply
CAVIUM_PTP` build fix (`a7d40cbb24900`).

That matches the earlier analysis: the PTP reference leak is still
present in 6.18.44 and this patch should be backported.

**YES**

 drivers/net/ethernet/cavium/thunder/nicvf_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index 1be2dc40a1a63..e4dfd5cc15802 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -2104,8 +2104,10 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	err = pci_enable_device(pdev);
-	if (err)
-		return dev_err_probe(dev, err, "Failed to enable PCI device\n");
+	if (err) {
+		err = dev_err_probe(dev, err, "Failed to enable PCI device\n");
+		goto err_put_ptp;
+	}
 
 	err = pci_request_regions(pdev, DRV_NAME);
 	if (err) {
@@ -2259,6 +2261,8 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_release_regions(pdev);
 err_disable_device:
 	pci_disable_device(pdev);
+err_put_ptp:
+	cavium_ptp_put(ptp_clock);
 	return err;
 }
 
-- 
2.53.0

