Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD7250AC07;
	Mon, 31 Aug 2026 13:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183756; cv=none; b=lKoRUOxdHtaZrHPhWLp6pu3jUZSoCuuCXRKDuQPjcWGYcGcE06HhvPbHZpocMkbPn/AK4GXB/tSuXvp4KU5fZpqUwWLfKzdSBoWFkxDzqyVRY57F8gBeswfUk4UrjWvSmeoavZKhfvX5rX9Tl4Ee3vj2bElsJ/tcKnObltHjjsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183756; c=relaxed/simple;
	bh=Nv1clVkTbwhmS1TNHrU9czEmQZYpscNee5+cCKWARTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LseMLN6d41Z+ohxBY/XRsx0W5kxCV8PMnP4UztDpqqWKqWed22LXd7IYbR3RtAGQWyPhdDihiB/xmd5wSZwE8CKaHTb8Pqvg9bXVhEvFstmFG2JJTTtYHygXH53TvKmTRdYisVgd6+eoxkVGaB+CnOwAC2acaljBvxhTBt0eVjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FcKc2ODv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FcKc2ODv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E001F00A3D;
	Mon, 31 Aug 2026 13:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183753;
	bh=UW5bx7oAdwutq6GKQNZ/Rv1t+ZX0mLZ7g6+04SdcEzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FcKc2ODvchpj1Jn4SUSHf+YaVccnb1VKNXKvFyvV4sNZo8H+Zh7XVtkr6LHQcUFaK
	 JAVB2BswhcnnAXW0tIZ4XuUcojCVdH+k4OymVogrofu1i9qDbBLrHbRbXLQdM26Aeu
	 IyVrNqZlA1mqWkRInSZf+MpbCELw1yz78yMZkpZnX8BjhPL35cLf8YGzpaDOrgMBLa
	 hsXWe3v1s4ge1OTsJBQ36KgdSETWivRoDYfQvN4mmx4Px2L+SA8EwfDjhNBl9BP/vP
	 ro1TeY/Z+UHPIPdWf6XE9y3b76uKKGRfggKntxqeFhvggocz+7OQxP94XjExlofwlh
	 vdMW/RJNVz35Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Nikhil P. Rao" <nikhil.rao@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	brett.creeley@amd.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] pds_core: quiesce DMA before freeing resources
Date: Mon, 31 Aug 2026 09:25:11 -0400
Message-ID: <20260831133314.4125787-283-sashal@kernel.org>
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

From: "Nikhil P. Rao" <nikhil.rao@amd.com>

[ Upstream commit 6443f4f20bdae726fe01cf5946fba9742a0ffda6 ]

pdsc_teardown() frees DMA buffers but does not disable bus mastering,
leaving the device able to perform DMA after the buffers are freed.
This can lead to use-after-free if the device writes to freed memory.

Add pci_clear_master() to pdsc_teardown() to disable bus mastering
before freeing resources, ensuring all DMA is quiesced.

Add pci_set_master() to pdsc_setup() to re-enable bus mastering,
which is needed for the firmware recovery path since pdsc_teardown()
now disables it.

Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
Link: https://patch.msgid.link/20260604213637.3844317-1-nikhil.rao@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
- Record: `[pds_core] [quiesce] DMA before freeing resources` —
  explicitly a DMA quiesce/safety fix in the AMD Pensando core driver.

**Step 1.2 — Tags**
- Record:
  - `Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>` (author)
  - `Link: https://patch.msgid.link/20260604213637.3844317-1-
    nikhil.rao@amd.com`
  - `Signed-off-by: Jakub Kicinski <kuba@kernel.org>` (netdev
    maintainer)
  - No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
    stable@vger.kernel.org`
  - Notable: netdev maintainer merge; no syzbot/fuzzer report

**Step 1.3 — Body analysis**
- Record:
  - **Bug:** `pdsc_teardown()` frees DMA buffers without disabling PCI
    bus mastering; device can still DMA into freed memory.
  - **Symptom:** Use-after-free (device writes to freed DMA buffers).
  - **Fix:** `pci_clear_master()` in `pdsc_teardown()` before resource
    free; `pci_set_master()` in `pdsc_setup()` to restore bus mastering
    for firmware recovery.
  - **Root cause:** Teardown frees coherent DMA (`dma_free_coherent`)
    while the PCI function remains bus-master enabled.

**Step 1.4 — Hidden bug fix?**
- Record: **No** — this is an explicit DMA UAF fix, not disguised
  cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
- Record:
  - 1 file: `drivers/net/ethernet/amd/pds_core/core.c` (+4 net lines in
    the provided diff; upstream diff also shows `cancel_work_sync`
    context)
  - Functions modified: `pdsc_setup()`, `pdsc_teardown()`
  - Scope: single-file, surgical (2 functional lines: `pci_set_master`,
    `pci_clear_master`)

**Step 2.2 — Code flow per hunk**

*Hunk 1 — `pdsc_setup()`*
- Before: setup proceeds with bus master state unchanged.
- After: explicitly re-enables bus mastering at start of setup.
- Path: init error recovery (`pdsc_fw_up()` →
  `pdsc_setup(PDSC_SETUP_RECOVERY)`), and normal setup after teardown
  cleared master.

*Hunk 2 — `pdsc_teardown()`*
- Before: reset → free queues/DMA (`pdsc_core_uninit`) → uninit device
  resources.
- After: reset → **disable bus mastering** → free queues/DMA.
- Path: driver remove, setup error paths, firmware-down recovery.

**Step 2.3 — Bug mechanism**
- Record: **Memory safety / DMA UAF**
  - `pdsc_core_uninit()` → `pdsc_qcq_free()` → `dma_free_coherent()` on
    admin/notify queue buffers.
  - Without `pci_clear_master()`, hardware may still perform DMA after
    buffers are returned to the DMA pool.
  - Especially critical on firmware recovery: `pdsc_fw_down()` calls
    `pdsc_teardown(PDSC_TEARDOWN_RECOVERY)` while `pci_disable_device()`
    is never called until full driver remove.

**Step 2.4 — Fix quality**
- Record:
  - Fix is standard PCI driver practice (many netdev drivers call
    `pci_clear_master()` before freeing DMA resources).
  - Minimal, obviously correct pairing: clear on teardown, restore on
    setup.
  - Low regression risk; `pci_set_master()` in setup is needed
    specifically because teardown now clears it (recovery path).
  - On first probe, `pci_set_master()` is already called in
    `pdsc_probe()` — duplicate call in setup is harmless.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
- Record:
  - `pdsc_teardown()` introduced in `523847df1b371` (Shannon Nelson,
    2023-04-19) — has never cleared bus master before freeing DMA.
  - `pdsc_setup()` same vintage.
  - Bug present since driver introduction in this tree (~2023).

**Step 3.2 — Fixes: tag**
- Record: N/A — no `Fixes:` tag in commit message.

**Step 3.3 — Related file history**
- Record:
  - `2f48b1d854e85` (2023): removed `pci_clear_master()` from
    `pdsc_remove()` error/cleanup paths, arguing `pci_disable_device()`
    already clears bus master.
  - That removal did **not** address `pdsc_teardown()`, which runs
    **before** `pci_disable_device()` in remove, and runs without
    `pci_disable_device()` during FW recovery.
  - Recent stable fixes in same driver: UAF (`9e0f80fac50ab`), deadlock
    (`19ef775c91c6b`) — same maintainer/author pattern of backporting
    pds_core stability fixes.
  - Standalone fix; not part of a multi-patch series.

**Step 3.4 — Author context**
- Record: Nikhil P. Rao (AMD) — active pds_core contributor; multiple
  recent stability fixes already in v6.18.44.

**Step 3.5 — Dependencies**
- Record: No prerequisites. Uses standard `pci_clear_master()` /
  `pci_set_master()` from `linux/pci.h`, both present in this tree.
  Applies standalone.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
- Record: `b4 dig -c <commit>` could not be run — commit is not in this
  checkout. Link fetch to patch.msgid.link and lore.kernel.org blocked
  by bot protection. **UNVERIFIED:** full review thread content.

**Step 4.2 — Reviewers**
- Record: **UNVERIFIED** via b4 dig -w. Commit message shows Jakub
  Kicinski merge only.

**Step 4.3 — Bug report**
- Record: No external bug report or syzbot link in commit message. Bug
  identified by code analysis (DMA after free).

**Step 4.4 — Related series**
- Record: Standalone 1-commit fix; no series dependency identified.

**Step 4.5 — Stable list history**
- Record: **UNVERIFIED** — lore stable search inaccessible.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
- Record: `pdsc_setup()`, `pdsc_teardown()`, `pdsc_core_uninit()`,
  `pdsc_qcq_free()`, `pdsc_fw_down()`, `pdsc_fw_up()`

**Step 5.2 — Callers of affected code**

`pdsc_teardown()` called from:
- `pdsc_setup()` error path
- `pdsc_remove()` / init error path (`main.c`)
- `pdsc_fw_down()` — firmware failure recovery
- `pdsc_fw_up()` error path
- `pdsc_reset_prepare()` → `pdsc_fw_down()` — PCI reset

`pdsc_setup()` called from:
- Driver init (`main.c`)
- `pdsc_fw_up()` — firmware recovery

**Step 5.3 — Key callees**
- `pdsc_teardown()` → `pdsc_devcmd_reset()` (MMIO admin commands),
  `pdsc_core_uninit()` → `dma_free_coherent()`, `pdsc_dev_uninit()` →
  `pci_free_irq_vectors()`
- `pdsc_setup()` → `pdsc_dev_init()` (allocates IRQ vectors, may need
  DMA), `pdsc_core_init()` (allocates coherent DMA)

**Step 5.4 — Reachability**
- Record:
  - **Userspace-reachable** via normal driver lifecycle (module
    load/unload, PCI hotplug) and **firmware health events**
    (`pdsc_health_thread` watchdog detects bad FW → `pdsc_fw_down()`).
  - Recovery path is the clearest trigger: teardown frees DMA while PCI
    device stays enabled and bus-master capable indefinitely until
    `pdsc_fw_up()` succeeds.

**Step 5.5 — Similar patterns**
- Record: Widespread pattern in this tree — `igc`, `ice`, `bnxt`,
  `e1000e`, etc. all call `pci_clear_master()` before teardown/free.
  Prior `pds_core` removal of `pci_clear_master()` from remove path
  (`2f48b1d854e85`) left the teardown/recovery gap unaddressed.

---

## Phase 6: Cross-Reference Against Local Tree (v6.18.44)

**Step 6.1 — Buggy code present?**
- Record: **YES.** Local tree is `v6.18.44` / `6.18.44`.
  `pdsc_teardown()` at lines 485–500 has no `pci_clear_master()`.
  `pdsc_setup()` at lines 454–483 has no `pci_set_master()`. DMA is
  freed in `pdsc_qcq_free()` via `dma_free_coherent()`. Fix not yet
  applied.

**Step 6.2 — Backport complications**
- Record: **Clean apply expected.** Insert `pci_clear_master()` after
  `pdsc_devcmd_reset()` and before `pdsc_core_uninit()` in
  `pdsc_teardown()`; insert `pci_set_master()` at start of
  `pdsc_setup()`.
- Note: upstream diff shows `cancel_work_sync(&pdsc->adminqcq.work)` in
  `pdsc_teardown()`; this tree already drains work inside
  `pdsc_qcq_free()` (commit `9e0f80fac50ab`). Backport needs only the
  two PCI master lines, not the work-cancel hunk.

**Step 6.3 — Related fixes already present?**
- Record: No existing fix for DMA quiesce on teardown. Related UAF fix
  `9e0f80fac50ab` addresses workqueue ordering, not bus mastering.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**
- Record: `drivers/net/ethernet/amd/pds_core` — AMD Pensando network
  device core driver (`CONFIG_PDS_CORE`). Criticality: **IMPORTANT**
  (hardware-specific, but stability bugs can cause memory corruption on
  affected servers).

**Step 7.2 — Activity**
- Record: Actively maintained; multiple stability fixes landed in
  v6.18.44 in 2026 from same author.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
- Record: Users with `CONFIG_PDS_CORE` and AMD Pensando/PDS hardware
  (PF/VF, fwctl, vDPA dependents). Not universal, but real production
  hardware.

**Step 8.2 — Trigger conditions**
- Record:
  - Firmware failure/recovery (`pdsc_fw_down`/`pdsc_fw_up`) — **most
    likely and severe** (no `pci_disable_device` on this path).
  - Driver remove (gap between `pdsc_teardown` and
    `pci_disable_device`).
  - Setup error during probe.
  - PCI reset prepare path.
  - Requires device with active bus mastering — normal after
    `pci_set_master()` in probe.

**Step 8.3 — Failure mode severity**
- Record: **HIGH** — DMA write to freed kernel memory → memory
  corruption, possible crash, potential security impact. Classic DMA-
  after-free.

**Step 8.4 — Risk vs benefit**
- Record:
  - **Benefit: HIGH** for affected hardware — prevents real DMA UAF on
    common recovery/remove paths.
  - **Risk: LOW** — 2-line standard PCI API usage, symmetric restore in
    setup.
  - Ratio: strongly favors backport.

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

*FOR backport:*
- Fixes real DMA use-after-free (memory corruption class bug)
- Small, surgical, standard PCI driver pattern
- Bug exists in v6.18.44 since driver introduction
- Firmware recovery path never disables bus master before freeing DMA
- Same driver already receives stable UAF/deadlock fixes
- `pci_set_master()` restore is required for recovery path correctness

*AGAINST backport:*
- Driver is hardware-specific (limited audience) — but stable rules
  allow driver bug fixes
- No syzbot/user report in commit message
- Mailing list review details unverified

*UNRESOLVED:*
- Full lore review thread content
- Whether reviewers explicitly nominated for stable

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — standard API usage;
   maintainer-merged; no Tested-by but mechanism is clear.
2. Fixes real bug affecting users? **PASS** — DMA UAF on
   teardown/recovery.
3. Important issue? **PASS** — memory corruption / potential crash (HIGH
   severity).
4. Small and contained? **PASS** — 2 functional lines.
5. No new features/APIs? **PASS** — uses existing PCI helpers only.
6. Can apply to local tree? **PASS** — code exists; clean apply.

**Step 9.3 — Exception category**
- Record: Hardware driver bug fix (DMA quiesce workaround) — qualifies
  under stable driver fix criteria.

**Step 9.4 — Decision rationale**

For **v6.18.44**, `pdsc_teardown()` frees coherent DMA buffers while the
PCI function can still act as a bus master. On the firmware recovery
path (`pdsc_fw_down()` → `pdsc_teardown()`), the device is never
`pci_disable_device()`'d, so bus mastering stays enabled across
teardown/setup cycles. The prior removal of `pci_clear_master()` from
`pdsc_remove()` (`2f48b1d854e85`) only addressed the final remove path
and did not fix the teardown/recovery gap. Adding `pci_clear_master()`
before DMA free and `pci_set_master()` on setup is the correct, minimal
fix.

---

## Verification

- [Phase 1] Parsed commit message: subsystem pds_core, explicit DMA UAF
  fix, tags listed
- [Phase 2] Diff analysis: `pci_clear_master` in teardown,
  `pci_set_master` in setup; `pdsc_core_uninit` → `dma_free_coherent`
  confirmed in `core.c:310-316`, `core.c:153-159`
- [Phase 3] `git describe HEAD`: v6.18.44; `make kernelversion`: 6.18.44
- [Phase 3] `git blame` on `pdsc_teardown`: introduced 2023-04-19
  (`523847df1b371`), no bus-master clear ever present
- [Phase 3] `git show 2f48b1d854e85`: removed `pci_clear_master` only
  from `main.c` probe/remove, not teardown
- [Phase 3] Recent pds_core stable fixes present: `9e0f80fac50ab` (UAF),
  `19ef775c91c6b` (deadlock)
- [Phase 4] UNVERIFIED: b4 dig and lore fetch blocked (commit not in
  tree; Anubis bot protection)
- [Phase 5] Callers traced via grep: `pdsc_teardown` from remove, setup
  errors, `pdsc_fw_down/up`, `pdsc_reset_prepare`
- [Phase 5] `pdsc_fw_down` at `core.c:543-567` calls teardown without
  `pci_disable_device`
- [Phase 5] `pdsc_probe` calls `pci_set_master` at `main.c:381`;
  `pci_disable_device` only at `main.c:461` after teardown
- [Phase 6] Buggy code confirmed present; fix not applied
- [Phase 6] Backport note: work draining already in `pdsc_qcq_free`
  (`core.c:147-149`); only PCI master lines needed
- [Phase 7] `CONFIG_PDS_CORE` in `drivers/net/ethernet/amd/Kconfig:189`
- [Phase 8] Failure mode: DMA UAF → memory corruption, severity HIGH

**YES**

 drivers/net/ethernet/amd/pds_core/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index d02e096a2c5fb..c8b64c79fde58 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -455,6 +455,8 @@ int pdsc_setup(struct pdsc *pdsc, bool init)
 {
 	int err;
 
+	pci_set_master(pdsc->pdev);
+
 	err = pdsc_dev_init(pdsc);
 	if (err)
 		return err;
@@ -487,6 +489,8 @@ void pdsc_teardown(struct pdsc *pdsc, bool removing)
 	if (!pdsc->pdev->is_virtfn)
 		pdsc_devcmd_reset(pdsc);
 
+	pci_clear_master(pdsc->pdev);
+
 	pdsc_core_uninit(pdsc);
 
 	if (removing) {
-- 
2.53.0

