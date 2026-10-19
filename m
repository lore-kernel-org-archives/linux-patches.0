Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC524E0B6A;
	Mon, 19 Oct 2026 13:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418088; cv=none; b=LSWmpTUpqN97UkMKOKvw/ayvJ9xzJz3y9yQ6yq5nUKWsHpNIjztKOBQIPMF0LVB08z0t8/xqfwL58qnAW0hY/t8CMG8eknGROheorIOhBKZvreJa5sLxrGxEtJlpeSq7gs1n+IpXmkd/AgLh3kc1FyBMid/VE28e7uMVuyeajhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418088; c=relaxed/simple;
	bh=CCCkZGrH5vk3HVHXeEajIAsjdCp6kQyrwsDC0sjXb20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SxC7K8q15wub/Ry53NIyZEnmOBzdBk5GRJR86z6V4RpDNBvbzywLKgM1CTxn+AmXctS8l1G408dPiFDSYZ9jlgyA1vwBkrvfOjfx3nhMD8fGYoSoWVxYK/8mgoZZ6kYPfoFGPNC7XMJuxMRQhCPH+fUTGF4ya1KLqz5uCqx2UFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JtNuvU1N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JtNuvU1N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7211F000C6;
	Mon, 19 Oct 2026 13:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418085;
	bh=8MyCnyVjuDkCWTOXbthwEjWPs5nnvJurQGBkZhq41Es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JtNuvU1NhYBWSPhnBiEPSYR0S8U8E8YBpUwWS0ruyLRDrfkAWp4b53mGXDpaP6xxZ
	 /l2ZvVrnwFUcdCKu3LfYzORQ717YdHXz8TuNvnBW3ewcX7RcoJoC9WPiOu5FZWrfqk
	 UVoLq1hE4wNYTA5PUmMt4o9ENnnbna7kjIcV2E1jtjGpUgRM6ESQM/vrPK72wHfdlF
	 ZBKJZZ5MNaqalmmeiVJKVbW3t7DdDmLJ+sDaPWyHXLmJGbFDlzgZdjQzsrbdxWylmP
	 A72WaoXaLY5XmdqRNGx+4bBY/0TQb3fLLlIJMaQbhyWgLJx01gdl9OjJtP/ymfYo3i
	 +o1j/VncrdXRg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jiaxing Hu <gahing@gahingwoo.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	joro@8bytes.org,
	heiko@sntech.de,
	iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] iommu/rockchip: Clear stale page faults before enabling stall
Date: Mon, 19 Oct 2026 09:44:53 -0400
Message-ID: <20261019135441.1420968-2-sashal@kernel.org>
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

From: Jiaxing Hu <gahing@gahingwoo.com>

[ Upstream commit b10d5920cafa292ee3cab9c20f813da4fe4f00b8 ]

Boot firmware can leave an IOMMU bank in PAGE_FAULT_ACTIVE before the
driver has configured paging:

  PAGE_FAULT_ACTIVE=1  STALL_ACTIVE=0  IDLE=1

Such a bank ignores CMD_ENABLE_STALL and never reaches STALL_ACTIVE, so
rk_iommu_enable_stall()'s readx_poll_timeout() spins until it times out
(seen on the RK3576 NPU, whose MMUs share this poll across banks).

Rather than special-casing these banks in the stall path, acknowledge the
stale fault with CMD_PAGE_FAULT_DONE before enabling stall, so every bank
starts from a clean state and the normal stall sequence applies to all of
them.  Banks without a pending fault are untouched.

Signed-off-by: Jiaxing Hu <gahing@gahingwoo.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local checkout is mainline **7.3-rc4**. The stall-timeout path is in
this tree, and the 13-line firmware leftover workaround is a real IOMMU
enable failure, not a new API.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[iommu/rockchip] [Clear] [acknowledge leftover
PAGE_FAULT_ACTIVE so stall enable does not poll-timeout]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Signed-off-by: Jiaxing Hu \<gahing@gahingwoo.com\> (author)
- Signed-off-by: Will Deacon \<will@kernel.org\> (IOMMU maintainer;
  applied the patch)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, Link:,
  or Cc: stable (absence of Fixes/Cc:stable is expected for this review)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** Boot firmware can leave an IOMMU bank in
  `PAGE_FAULT_ACTIVE=1`, `STALL_ACTIVE=0`, `IDLE=1` before the driver
  configures paging.
- **Symptom:** That bank ignores `CMD_ENABLE_STALL` and never reaches
  `STALL_ACTIVE`. `rk_iommu_enable_stall()`’s `readx_poll_timeout()`
  fails. Observed on the RK3576 NPU, whose MMUs share the stall poll
  across banks (`rk_iommu_is_stall_active()` ANDs every bank).
- **Root cause:** Stale firmware page-fault state blocks the stall
  command.
- **Fix:** Issue `CMD_PAGE_FAULT_DONE` on any bank that still has
  `PAGE_FAULT_ACTIVE`, then use the normal stall sequence. Banks without
  a pending fault are untouched.
- **Version info in message:** none beyond RK3576 NPU.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised. This is an explicit hardware/firmware leftover
workaround that prevents a stall-enable timeout.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/iommu/rockchip-iommu.c` — **+13 / -0**
- Function: `rk_iommu_enable_stall()`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** If stall is not already active and paging is enabled,
  broadcast `CMD_ENABLE_STALL` and poll until every bank reports
  `STALL_ACTIVE` (1 ms timeout, `RK_MMU_POLL_TIMEOUT_US=1000`). One
  stuck bank fails the whole poll.
- **After:** Same path, but first walk each bank; if
  `RK_MMU_STATUS_PAGE_FAULT_ACTIVE` is set, write
  `RK_MMU_CMD_PAGE_FAULT_DONE` to that bank’s command register, then
  enable stall as before.
- Path: initialization / attach / resume (`rk_iommu_enable` →
  `rk_iommu_enable_stall`), and also disable/suspend (return value
  ignored there).

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **[Hardware workaround / logic correctness]** Firmware leaves
`PAGE_FAULT_ACTIVE`. Hardware ignores `CMD_ENABLE_STALL` in that state.
`rk_iommu_enable()` treats stall timeout as fatal (`if (ret) goto
out_disable_clocks`), so the IOMMU never reaches
`rk_iommu_force_reset()` / paging setup and **device attach fails**. The
fix acks the leftover fault with the same command the IRQ handler
already uses (`RK_MMU_CMD_PAGE_FAULT_DONE`).

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Minimal and readable. Gated on `PAGE_FAULT_ACTIVE`, so idle
banks are unchanged. Uses the existing command encoding. Regression risk
is low; the only flagged concern is not also writing `RK_MMU_INT_CLEAR`
(see Phase 4), which is incomplete-ack, not a new deadlock or API
change.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- `rk_iommu_enable_stall()` introduced in **c68a292152d32**
  (`iommu/rockchip: rk3288 iommu driver`, 2014) — contained in
  **v3.19-rc1**.
- Multi-bank `num_mmu` loop: **cd6438c5f8446**, contained in
  **v4.6-rc1**.
- `readx_poll_timeout`: **0416bf6479acef**, contained in **v4.17-rc1**.
- The 13-line ack loop is this commit (**b10d5920cafa2**).

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag. Not applicable. Buggy interaction is firmware
leftover vs stall path that has existed for years.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Immediate parent on the file: **841363ebb5082** `iommu/rockchip: Take
  all DT clocks` — same author, same RFC series (patch 4/8). Different
  problem (extra clocks so DTE_ADDR writes land). **Not a code
  dependency** of the stall ack.
- No later commits on this file after b10d5920cafa2 in this tree.
- Standalone IOMMU change; Will applied 4/8 and 5/8 without the rest of
  the NPU series.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Jiaxing Hu is not the IOMMU maintainer. In this tree, two
rockchip-iommu commits (clocks + this). Will Deacon applied both.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Diff only needs `rk_iommu_enable_stall`, `num_mmu`,
`RK_MMU_STATUS_PAGE_FAULT_ACTIVE`, `RK_MMU_CMD_PAGE_FAULT_DONE` — all
present long before 7.3. **Can apply standalone.**

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- Lore (via b4):
  https://patch.msgid.link/20260718031146.3368811-6-gahing@gahingwoo.com
- Series: **[RFC PATCH v2 0/8] accel/rocket: RK3576 NPU (RKNN)
  enablement**
- This patch is **v2 5/8**. v1 had two “skip orphaned-fault banks”
  patches; v2 replaced them with this fault-ack after Chaoyi Chen asked
  whether clearing the fault avoids skipping banks.
- Will Deacon (2026-07-26): “Applied driver changes to iommu (rockchip)”
  for 4/8 and 5/8. No NAK on this patch.
- Cover letter: NPU bring-up is still incomplete (“full inference is not
  correct yet”). This IOMMU fix was still taken on its own.
- v3 of the wider series was not out when Will applied this; applied
  version is the latest for this hunk.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: Recipients included Will Deacon, Joerg Roedel, Robin Murphy,
Heiko Stuebner, iommu@lists.linux.dev, linux-rockchip. No human
Reviewed-by on 5/8 in the thread. Will applied it. Sashiko bot
(automated) commented.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla. Author hit it on a Radxa ROCK 4D while
bringing up the RK3576 NPU IOMMUs. Cover letter lists “clearing a stale
firmware page fault” as required for those IOMMUs to come up.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: RFC 8-patch NPU enablement. Only the two IOMMU driver patches
were merged. NPU DT/driver patches are **not** in this tree (no NPU
IOMMU nodes in `rk3576.dtsi`). This stall patch does not depend on them.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search returned HTTP 403. **UNVERIFIED**
whether stable@ discussed this. No in-tree grep hit except this commit.

Sashiko bot concern (verified from mbox): `CMD_PAGE_FAULT_DONE` without
`RK_MMU_INT_CLEAR` might leave a raw IRQ pending. On `rockchip,disable-
mmu-reset` instances (in-tree: px30, rk3288, rk3368, rk3399, rk356x,
rk3576 vdec), `rk_iommu_force_reset()` is skipped, then
`RK_MMU_INT_MASK` is programmed in `rk_iommu_enable()`. A leftover raw
bit could fire a page-fault IRQ. The existing IRQ handler already logs,
optionally `report_iommu_fault()`, zaps cache, issues `PAGE_FAULT_DONE`,
and clears INT_STATUS. That is a possible spurious IRQ/log, not a
verified panic. No follow-up commit addressed it; Will still applied the
patch.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `rk_iommu_enable_stall()` (modified). Helpers used:
`rk_iommu_read`, `rk_iommu_is_stall_active`,
`rk_iommu_is_paging_enabled`, `rk_iommu_command`.

**Step 5.2: TRACE CALLERS**
Record:
- `rk_iommu_disable()` line 928 — detach / runtime suspend. Return
  ignored.
- `rk_iommu_enable()` line 950 — attach / runtime resume. **Failure
  aborts enable.**
- `rk_iommu_enable()` called from `rk_iommu_attach_device()` (line 1064)
  and `rk_iommu_resume()` (line 1349).

**Step 5.3: TRACE CALLEES**
Record: MMIO status/command. No allocation, no new locks.
`writel(RK_MMU_CMD_PAGE_FAULT_DONE, base + RK_MMU_COMMAND)` matches
`rk_iommu_base_command()`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace/DMA attach or runtime PM resume →
`rk_iommu_attach_device` / `rk_iommu_resume` → `rk_iommu_enable` →
`rk_iommu_enable_stall`. Reachable on Rockchip SoCs with
`CONFIG_ROCKCHIP_IOMMU`. Trigger is firmware leftover + paging already
enabled. Not a syscall fuzz path; it is device bring-up.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: IRQ path already does `RK_MMU_CMD_PAGE_FAULT_DONE` (line 642)
plus `RK_MMU_INT_CLEAR`. No other stall-path fault ack. In-tree RK3576
`vdec_mmu` is two-bank (`reg` two regions), so the AND-poll issue is not
NPU-only in principle.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** Local tree: `git describe HEAD` =
**v7.3-rc4-27-gf0100363d8c37**, `make kernelversion` = **7.3.0-rc4**.
`rk_iommu_enable_stall()` is present; this commit is already an ancestor
of HEAD (`git merge-base --is-ancestor b10d5920cafa2 HEAD` succeeded).
Landed via `iommu-updates-v7.3` (not in v7.2). Stall path itself dates
to v3.19.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Hunk is a contiguous insert after the paging-enabled check.
Expected apply: **clean** on trees that have the 2016 multi-bank
`num_mmu` loop (v4.6+). No conflicting later edits on this function in
this checkout.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This is the only “stale page fault” commit. No alternate fix.
Sibling clocks change is independent.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **drivers/iommu/rockchip-iommu.c** — Rockchip IOMMU.
Criticality: **IMPORTANT** (platform IOMMU for multimedia/NPU DMA; not
core mm/VFS, but attach failure takes down the consumer device).

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature driver (2014), still receiving Rockchip bring-up fixes.
Joerg’s v7.3 pull: “Rework Rockchip state handling and fix clock, probe
and stale-fault handling.”

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **driver-specific / platform-specific** —
`CONFIG_ROCKCHIP_IOMMU` on Rockchip. Practical trigger reported on
RK3576 NPU MMUs (those DT nodes are **not** in this tree). Any multi-
bank instance whose firmware leaves `PAGE_FAULT_ACTIVE` can hit the same
poll (e.g. in-tree RK3576 `vdec_mmu` has two banks).

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Boot firmware leftover fault, then first stall enable while
paging is still enabled. Timing: probe/attach or resume, not a hot path.
Unprivileged users do not trigger it directly; it is firmware × driver
init. No public reproducer beyond the author’s ROCK 4D bring-up.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **IOMMU enable fails after a 1 ms poll**
(`RK_MMU_POLL_TIMEOUT_US=1000`). Attach returns error; the DMA device
does not get a working IOMMU. **Not** a panic, hang, UAF, or corruption.
Severity: **HIGH** for the affected device (non-functional), **MEDIUM**
system-wide (1 ms timeout + error, rest of the machine continues).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** Hardware/firmware workaround so stall enable succeeds;
  IOMMU attach can proceed. High for RK3576 NPU users; modest for other
  Rockchip boards unless firmware leaves the same bit.
- **Risk:** 13 lines, status-gated. Theoretical spurious IRQ if
  INT_STATUS is not cleared on `disable-mmu-reset` devices. No new
  locks/APIs.
- **Ratio:** Benefit outweighs risk. Same class as other hardware
  leftover/quirk fixes.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real, explained failure: stall poll times out, `rk_iommu_enable()`
  aborts, device attach fails.
- Small (+13), contained, status-gated.
- Same command the IRQ handler already uses.
- Will Deacon applied it independently of the unfinished NPU RFC.
- v7.3 IOMMU pull listed stale-fault handling as a fix.
- Driver and stall path exist in this tree since v3.19 / v4.6.
- Hardware/firmware workaround (stable exception category).
- No new APIs or features.

AGAINST:
- Originated in an RFC series to enable RK3576 NPU; NPU IOMMU DT is
  still not in this tree.
- Observed on that NPU, not reported on long-shipped VOP/VDEC.
- Not crash/security/corruption; 1 ms timeout then enable failure.
- Sashiko noted missing `INT_CLEAR`; unaddressed.
- No Fixes:/Cc:stable (not a negative by itself).

UNRESOLVED:
- lore.kernel.org/stable search HTTP 403.
- Whether in-tree vdec/vop firmware also leaves `PAGE_FAULT_ACTIVE`
  (author only cited NPU).
- Whether a leftover INT_STATUS after `PAGE_FAULT_DONE` actually fires
  on `disable-mmu-reset` hardware.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — logic matches the described
   hardware state; author tested on ROCK 4D; IOMMU maintainer applied
   it.
2. Fixes a real bug that affects users? **PASS** — stall timeout
   prevents IOMMU enable/attach.
3. Important issue? **PASS** — device IOMMU never comes up (not a panic,
   but hardware non-functional). Severity HIGH for that device.
4. Small and contained? **PASS** — 13 lines, one function.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — stall path and symbols are
   here; hunk is a clean insert.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Hardware quirk/workaround** — firmware leftover
`PAGE_FAULT_ACTIVE` so stall commands work. Not a new driver, not a new
userspace API.

**Step 9.4: MAKE YOUR DECISION**

This tree is 7.3-rc4; the stall path is old and the bug is a firmware
leftover vs that path, not a 7.3-only feature. The patch is a small,
maintainer-acked workaround that stops IOMMU attach from failing. Origin
in an unfinished NPU RFC does not make it a new API; Will merged it as a
standalone IOMMU fix. Missing `INT_CLEAR` is a residual IRQ-ack concern,
not a reason to drop a stall-timeout fix that already uses the
documented fault-done command.

Verification:
- [Phase 1] Parsed tags: only author SOB + Will Deacon SOB; no
  Fixes/Reported-by/Cc:stable
- [Phase 1] Body: PAGE_FAULT_ACTIVE leftover → ENABLE_STALL ignored →
  poll timeout on RK3576 NPU multi-bank poll
- [Phase 2] Diff: +13 in `rk_iommu_enable_stall()`; loop acks
  `PAGE_FAULT_ACTIVE` with `CMD_PAGE_FAULT_DONE`
- [Phase 2] `rk_iommu_enable()` returns on stall timeout before
  `force_reset` (line 950-952) — attach fails
- [Phase 3] git blame: function from c68a292152d32 (v3.19); poll from
  0416bf6479acef (v4.17); multi-mmu cd6438c5f8446 (v4.6)
- [Phase 3] git merge-base --is-ancestor b10d5920cafa2 HEAD: yes; not in
  v7.2; in v7.3-rc1
- [Phase 3] Sibling 841363ebb5082 is clocks-only; not required for this
  hunk
- [Phase 4] b4 dig -c b10d5920cafa2:
  https://patch.msgid.link/20260718031146.3368811-6-gahing@gahingwoo.com
- [Phase 4] b4 dig -a: RFC v1 (skip banks) → v2 (this ack); Will applied
  v2 4/8 and 5/8
- [Phase 4] b4 dig -w: iommu maintainers + rockchip list on CC
- [Phase 4] mbox: Will “Applied driver changes to iommu (rockchip)”;
  Sashiko INT_CLEAR warning; no human NAK
- [Phase 4] lore.kernel.org WebFetch/curl: HTTP 403 — stable-list
  discussion UNVERIFIED
- [Phase 5] Callers: disable (unchecked) and enable (fatal); enable from
  attach_device and resume
- [Phase 5] IRQ handler already issues PAGE_FAULT_DONE at line 642
- [Phase 6] git describe HEAD: v7.3-rc4-27-gf0100363d8c37; Makefile
  7.3.0-rc4; file present
- [Phase 6] No NPU IOMMU nodes in
  arch/arm64/boot/dts/rockchip/rk3576.dtsi; vdec_mmu is two-bank +
  disable-mmu-reset
- [Phase 7] iommu-updates-v7.3 merge text: “fix clock, probe and stale-
  fault handling”
- [Phase 8] Failure: 1 ms poll then IOMMU enable/attach failure; not
  oops/UAF
- UNVERIFIED: whether firmware leaves this bit on in-tree vdec/vop;
  whether INT_STATUS spurious IRQ reproduces; stable@ thread

The fix is small, surgical, and meets the stable criteria as a hardware
leftover workaround in a long-lived driver.

**YES**

 drivers/iommu/rockchip-iommu.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/iommu/rockchip-iommu.c b/drivers/iommu/rockchip-iommu.c
index 309ba78e27d4f..982ea9cafee1b 100644
--- a/drivers/iommu/rockchip-iommu.c
+++ b/drivers/iommu/rockchip-iommu.c
@@ -422,6 +422,19 @@ static int rk_iommu_enable_stall(struct rk_iommu *iommu)
 	if (!rk_iommu_is_paging_enabled(iommu))
 		return 0;
 
+	/*
+	 * Boot firmware can leave a bank in PAGE_FAULT_ACTIVE with no handler
+	 * (PAGE_FAULT_ACTIVE & !STALL_ACTIVE & IDLE).  Such a bank ignores
+	 * CMD_ENABLE_STALL and never reaches STALL_ACTIVE, timing out the poll
+	 * below.  Acknowledge any stale fault first so every bank starts clean.
+	 */
+	for (i = 0; i < iommu->num_mmu; i++) {
+		if (rk_iommu_read(iommu->bases[i], RK_MMU_STATUS) &
+		    RK_MMU_STATUS_PAGE_FAULT_ACTIVE)
+			writel(RK_MMU_CMD_PAGE_FAULT_DONE,
+			       iommu->bases[i] + RK_MMU_COMMAND);
+	}
+
 	rk_iommu_command(iommu, RK_MMU_CMD_ENABLE_STALL);
 
 	ret = readx_poll_timeout(rk_iommu_is_stall_active, iommu, val,
-- 
2.53.0

