Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5E460CDBE;
	Mon, 19 Oct 2026 14:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418617; cv=none; b=V8UNsNL3yvucQX37F8f/14ddkCRH7YTRMfkIa9Vjamy4+zxNYhjyfbWrgsCHhuaj3x7sW82eYB/wM2wXoSMrHbiyV5THW2zxew0uaMCdAN/PzkhvVrCzrRsg1SeHeMB/i02I7xFEObdmL5aIAfACKLEUif2ZiWWOiNjwEVjRGbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418617; c=relaxed/simple;
	bh=fCUTEl0b1W8KLxi4E4CkZep17k0SiVhk41S214XJOs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Iy4/ZxRH0713duHzoKT7GaiS0c/ucfdQpA9Bw95ghST7nFeCU3EOqSGrg8Rbm5e444OlYuK3iGNRUNqo+gjNQtiQcrNvWLeJ27N0UUipZ0/dgj9u4Ip+pLD2kHDsuCKKEjnEzwyoVkTR3J4IsiQyy8YKE968351cXm8b+T3GwRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dEqNycs6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dEqNycs6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA211F000CC;
	Mon, 19 Oct 2026 14:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418613;
	bh=NCXnOb/Qt6E1FqyI644FJZPlqfJtKu2NgUfugrMeSWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dEqNycs65360LlXzW/yYv+CCsfOGXluyNNhuZ8wGkIELQ08Y0rsfFjiGUZJA/+vLl
	 3xWf4NAQEM0IP/Cn0vtoZoH/0a8Cs17dyP1HYNr/rlTVPTNgf8pDLN2pZnWnUwmPoJ
	 kxQs+K1ro1c+DLdrboULgqkJMbeBwyVXxqNZ5h2+K6E8BxLaPgm2A6pXfV/EBTARmH
	 N4fKnO3N868tuaEPz7bXp3oq3GGHgtKEG49B41oJj/wESjxjN72yPI2sOLsdGsawGg
	 D8GZ8GA0ZxzISpQyA9aD1j7RfPOQWKPt6XhiK7BcDP/PLLiqHJM3vMs4q28qkq5sMt
	 IskYIubG8arMg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yun Zhou <yun.zhou@windriver.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	marcin.s.wojtas@gmail.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] net: mvneta_bm: add suspend/resume support to prevent crash after resume
Date: Mon, 19 Oct 2026 09:51:04 -0400
Message-ID: <20261019135441.1420968-373-sashal@kernel.org>
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

From: Yun Zhou <yun.zhou@windriver.com>

[ Upstream commit 140be217df577961bea1ca36240439a463026cbd ]

The mvneta driver uses the hardware Buffer Manager (BM) for RX buffer
allocation. During suspend, mvneta disables its clock, causing BM to
lose all buffer address state. On resume, mvneta_bm_port_init() re-
attaches the BM pool to the NIC, but BM hardware returns stale/garbage
buffer addresses. When NAPI poll processes these buffers, DMA cache
sync hits an invalid virtual address causing a kernel panic:

 Unable to handle kernel paging request at virtual address b0000080
 PC is at v7_dma_inv_range
 Call trace:
  v7_dma_inv_range from arch_sync_dma_for_cpu+0x94/0x158
  arch_sync_dma_for_cpu from __dma_sync_single_for_cpu+0xc4/0x15c
  __dma_sync_single_for_cpu from mvneta_rx_swbm+0x6c8/0xf48
  mvneta_rx_swbm from mvneta_poll+0x6fc/0x70c
  mvneta_poll from __napi_poll.constprop.0+0x2c/0x1e0
  __napi_poll.constprop.0 from net_rx_action+0x160/0x2c4
  net_rx_action from handle_softirqs+0xd8/0x2b8
  handle_softirqs from run_ksoftirqd+0x30/0x94
  run_ksoftirqd from smpboot_thread_fn+0x100/0x204
  smpboot_thread_fn from kthread+0xf4/0x110
  kthread from ret_from_fork+0x14/0x28

Fix by adding suspend/resume callbacks to the BM driver:

- suspend: drain all buffers (with DMA unmapping), free the BPPE
  regions, and reset pool state to FREE before stopping BM and gating
  the clock.

- resume: enable the clock, reinitialize BM defaults, and restore pool
  read/write pointers and size registers. Pool allocation and buffer
  refill are handled by mvneta_resume() through the normal
  mvneta_bm_port_init() path, which sees pools as FREE and performs
  full initialization identical to probe.

Add a device_link (DL_FLAG_AUTOREMOVE_CONSUMER) in mvneta_probe to
guarantee BM resumes before mvneta and suspends after mvneta. If the
link cannot be created, fall back to SW buffer management to avoid a
potential crash on resume due to unordered PM transitions.

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Link: https://patch.msgid.link/20260630060311.4072140-1-yun.zhou@windriver.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a real resume panic in an existing driver, and the local 7.3-rc4
tree already has the affected `mvneta`/`mvneta_bm` code. The patch is a
contained PM completion, not a new API.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[net/mvneta_bm] [add] add suspend/resume support to prevent
crash after resume`

Subsystem prefix is `net: mvneta_bm`. The verb is “add”, but the rest of
the subject names a crash after resume. That is a bug fix framed as
adding the missing PM callbacks.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Signed-off-by: Yun Zhou <yun.zhou@windriver.com>` (author)
- `Link: https://patch.msgid.link/20260630060311.4072140-1-
  yun.zhou@windriver.com`
- `Signed-off-by: Paolo Abeni <pabeni@redhat.com>` (netdev maintainer,
  applied it)
- No `Fixes:` tag (expected for this review)
- No `Cc: stable@vger.kernel.org` (expected)
- No `Reported-by:`, `Tested-by:`, `Reviewed-by:`, or `Acked-by:`
- Notable: author is Wind River, so this came from a commercial embedded
  product, not a theoretical cleanup

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** Marvell NETA hardware Buffer Manager (BM) has no
  suspend/resume. `mvneta_suspend()` gates the NETA clock; BM loses
  buffer-address state. On resume, `mvneta_bm_port_init()` reattaches
  pools while BM still returns stale/garbage addresses.
- **Symptom:** kernel panic: `Unable to handle kernel paging request at
  virtual address b0000080` in `v7_dma_inv_range` ←
  `arch_sync_dma_for_cpu` ← `__dma_sync_single_for_cpu` ←
  `mvneta_rx_swbm` ← `mvneta_poll`.
- **Version info:** none in the message. BM exists since v4.6; `mvneta`
  PM exists since v4.12.
- **Root cause (author):** clock gating drops BM register/pool state;
  resume reuses that garbage in NAPI RX DMA sync.
- **Fix:** BM suspend drains/unmaps/frees pools and sets type `FREE`; BM
  resume re-clocks and restores registers; `mvneta_resume()` then re-
  inits pools via the existing `mvneta_bm_port_init()` path. A
  `device_link` orders BM before `mvneta` on resume.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a hidden fix. The subject says “add … support”, but the body
is an oops-on-resume report with a full ARM stack. Adding PM callbacks
here is completing missing power-management, which is an allowed stable
class (hardware/PM workaround), not a new userspace feature.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- `drivers/net/ethernet/marvell/mvneta.c`: +18 (probe only)
- `drivers/net/ethernet/marvell/mvneta_bm.c`: +72
- Total: **90 insertions, 0 deletions** (under the stable ~100-line
  guideline)
- Functions: `mvneta_probe`; new `mvneta_bm_suspend`,
  `mvneta_bm_resume`; `mvneta_bm_pool_create` error paths;
  `mvneta_bm_driver.driver.pm`
- Scope: single-subsystem surgical change (Marvell NETA + its BM
  companion)

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
1. **`mvneta_probe` BM attach:** after successful
   `mvneta_bm_port_init()`, add `device_link_add(mvneta, BM,
   DL_FLAG_AUTOREMOVE_CONSUMER)`. On failure, destroy long/short pools,
   `mvneta_bm_put()`, clear `pp->bm_priv` and fall back to SW BM.
   Before: HW BM could be used with unordered PM vs BM.
2. **`mvneta_bm_pool_create` error paths:** after `dma_free_coherent()`,
   set `bm_pool->virt_addr = NULL`. Before: dangling pointer; suspend’s
   `dma_free_coherent()` could double-free.
3. **New `mvneta_bm_suspend`:** for each non-FREE pool,
   `mvneta_bm_bufs_free()`, disable pool, free BPPE,
   `mutex_destroy(&buf_lock)`, set type `FREE`; then
   `MVNETA_BM_STOP_MASK` and `clk_disable_unprepare()`. Before: BM had
   no suspend; clock/state left live or stale.
4. **New `mvneta_bm_resume`:** `clk_prepare_enable()`,
   `mvneta_bm_default_set()`, restore per-pool read/write pointers and
   size, `MVNETA_BM_START_MASK`. Pool refill stays in existing
   `mvneta_resume()` → `mvneta_bm_port_init()`.
5. **Driver `.pm`:** `DEFINE_SIMPLE_DEV_PM_OPS` + `pm_sleep_ptr()`.
   Before: no PM ops on the BM platform driver.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: `[Hardware PM / stale DMA addresses after resume]` plus a small
`[double-free hardening]` on `virt_addr`.

Mechanism: BM hardware state does not survive clock/power loss. Resume
still programmed the NIC to consume BM buffers, so NAPI DMA-synced
garbage (`b0000080`) and oopsed. Suspend now tears pools down to `FREE`;
resume brings BM up first (device_link); `mvneta_bm_pool_use()` sees
`FREE` and does full probe-style alloc/fill.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Quality is good after v2–v6. Drain + unmap, BPPE free, type
reset, clock error check, register restore, device_link with SW-BM
fallback, `mutex_destroy` paired with `mutex_init` in
`mvneta_bm_pool_use()`, and `virt_addr` NULL on alloc failure are all
consistent with existing `mvneta_bm_pool_destroy()` / probe paths.

Regression risk is **low–medium**: new PM callbacks can leak if drain is
incomplete (`dev_warn` if `buf_num` remains), and `mutex_destroy`
assumes no concurrent `hwbm_pool_add()` (the device_link is what makes
that true). No public API or core-kernel change. Paolo applied it; no
NAK in the thread.

Verified call order with the link (consumer=`mvneta`, supplier=`BM`):
mvneta suspends first, BM suspends second; BM resumes first, mvneta
resumes second. That matches the code: `mvneta_suspend()` does **not**
destroy BM pools; `mvneta_bm_suspend()` does; `mvneta_resume()` calls
`mvneta_bm_port_init()` only after BM resume.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- BM attach in probe: `dc35a10f68d37` (Marcin Wojtas, 2016-03-14) “net:
  mvneta: bm: add support for hardware buffer management”, **v4.6-rc1**
- Probe BM get/init structure: `965cbbec7f207` (Gregory CLEMENT,
  2018-07-18)
- `mvneta` suspend/resume: `9768b45ceb0bc` “net: mvneta: support suspend
  and resume”, **v4.12-rc1**
- Buggy situation (PM on neta, none on BM) has been in tree since
  **v4.12** (~2017)

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. The missing BM PM has been there since
`9768b45ceb0bc` (v4.12) against BM from `dc35a10f68d37` (v4.6). Both are
ancestors of this checkout (`git merge-base --is-ancestor` not needed
for those; they are in file history here).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Same author, nearby: `fd398d6480987` “net: mvneta: re-enable percpu
  interrupt on resume” (independent resume IRQ bug, already in this
  tree)
- After this commit: `ede0f99cef53a` “net: mvneta: bm: fix device
  reference leak on failed lookup” — different `mvneta_bm_get()` leak,
  not a revert/fix of this PM code
- No “patch X/Y” on this commit. Standalone.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Yun Zhou is not the mvneta maintainer; two recent mvneta resume
fixes in this tree. Original BM author Marcin Wojtas was on Cc. Applied
by Paolo Abeni.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record:
- `mutex_destroy` on `hwbm_pool.buf_lock` needs the mutex conversion
  `6dcdd884e2a4b` (**v5.3-rc1**). Present here (`include/net/hwbm.h` has
  `struct mutex buf_lock`).
- `DEFINE_SIMPLE_DEV_PM_OPS` / `pm_sleep_ptr`: `1a3c7bb088266`
  (**v5.17**). Present here.
- `DL_FLAG_AUTOREMOVE_CONSUMER`: renamed in **v4.19**. Present here.
- `priv->pdev` is set in `mvneta_bm_probe()` before drvdata is
  published, so `pp->bm_priv->pdev->dev` in `device_link_add` is valid.
- Can apply standalone **in this tree**. No missing helpers.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 140be217df577`: https://patch.msgid.link/20260630060311.407
  2140-1-yun.zhou@windriver.com
- Series: **v2 → v6** (no v1 in b4’s match list)
  - v2 2026-06-14, v3 06-16, v4 06-18, v5 06-25, v6 06-30
- Changelog (from v6 mbox): v2 added drain/device_link; v3 restored pool
  registers and `DEFINE_SIMPLE_DEV_PM_OPS`; v4 SW-BM fallback if link
  fails; v5 disable-before-free; v6 `mutex_destroy` + `virt_addr = NULL`
- Applied to **netdev/net-next.git**, not `net` (feature-sized PM
  addition, but still a crash fix)
- No NAK. Paolo’s only follow-up: sashiko flagged **pre-existing**
  issues, asked for a later follow-up — not a NAK of this patch
- No reviewer `Cc: stable` in the v6 thread

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): Yun Zhou; Marcin Wojtas; Andrew Lunn; Dave Miller;
Eric Dumazet; Jakub Kicinski; Paolo Abeni; netdev; linux-kernel. Right
lists/maintainers. Human review of earlier versions was mostly sashiko
notes forwarded by Simon Horman (v2) and Jakub Kicinski (v5) as
“plausible”. Paolo applied v6.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No bugzilla/syzbot link. Evidence is the ARM oops in the commit
and Wind River authorship. lore.kernel.org HTTP fetch returned 403;
thread was recovered via `b4 dig -m`.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Single-patch series. Related but independent: `fd398d6480987`
(percpu IRQ on resume). Not a prerequisite for this diff.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable HTTP 403. Local `git log` on these files
shows no stable-list discussion of this subject. UNVERIFIED whether
anyone already requested/rejected it on stable@.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `mvneta_probe`, `mvneta_bm_pool_create`, `mvneta_bm_suspend`
(new), `mvneta_bm_resume` (new), `mvneta_bm_driver` pm pointer.

**Step 5.2: TRACE CALLERS**
Record:
- `mvneta_bm_suspend`/`resume`: platform PM via `dev_pm_ops` (system
  suspend/hibernate)
- `mvneta_bm_port_init` ← `mvneta_probe` and `mvneta_resume` (verified
  in `mvneta.c`)
- `mvneta_bm_pool_use` ← only `mvneta_bm_port_init` (long and short
  pools)
- `mvneta_poll` ← NAPI; chooses `mvneta_rx_hwbm` if `pp->bm_priv` else
  `mvneta_rx_swbm`

**Step 5.3: TRACE CALLEES**
Record: suspend uses `mvneta_bm_bufs_free` (DMA unmap +
`hwbm_buf_free`), `mvneta_bm_pool_disable`, `dma_free_coherent`,
`mutex_destroy`, `clk_disable_unprepare`. Resume uses
`clk_prepare_enable`, `mvneta_bm_default_set`, register writes, BM
START.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace/system suspend on Armada 38x/XP with
`CONFIG_MVNETA_BM` and a DT `buffer-manager` phandle. Reachable on real
HW (Wind River). Not a syscall fuzz path; it is a common S2R path on
those boards.

Note on the stack naming: `mvneta_poll` uses `mvneta_rx_hwbm` when
`bm_priv` is set. The oops shows `mvneta_rx_swbm`. Verified that
`mvneta_swbm_rx_frame()` does `dma_sync_single_for_cpu(...,
rx_desc->buf_phys_addr, ...)` and can be inlined into `mvneta_rx_swbm`.
That matches DMA-sync-of-garbage if resume fell back to SW BM
(`mvneta_resume` clears `bm_priv` when `mvneta_bm_port_init` fails)
while RX descriptors still held stale phys addrs, or if the reporter’s
kernel named the RX path differently. The BM clock-loss story is still
consistent with “invalid address in DMA sync after resume”.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: `mvneta` already had `SIMPLE_DEV_PM_OPS(mvneta_pm_ops, ...)`. BM
was the missing half. No sibling Marvell BM driver in this path.
`device_link_add` is used only in this probe site under
`drivers/net/ethernet/marvell/`.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. Tree is **v7.3-rc4** (`git describe HEAD` =
`v7.3-rc4-27-gf0100363d8c37`, `VERSION=7 PATCHLEVEL=3 SUBLEVEL=0
EXTRAVERSION=-rc4`).
- `140be217df577` **is** an ancestor of HEAD (`git merge-base --is-
  ancestor` succeeded).
- Files `drivers/net/ethernet/marvell/mvneta.c` and `mvneta_bm.c` exist;
  BM probe/remove, `mvneta_suspend`/`mvneta_resume`, and
  `mvneta_bm_port_init` are present.
- Bug class (BM without PM while neta has PM) dates to v4.12.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean in this tree** — the commit is already applied. Probe BM
block has been stable in shape since 2018. Helpers used by the patch
exist here.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This fix is already on HEAD. No alternate older fix for BM
resume. Follow-up `ede0f99cef53a` is a different `mvneta_bm_get()` ref
leak, not a replacement for this change.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `[net/ethernet/marvell mvneta + mvneta_bm] [IMPORTANT]` — not
core mm/VFS, but the onboard NIC on Armada 370/38x/XP/3700. BM is
**32-bit only** (`depends on !64BIT`), Armada 38x/XP. Crash takes down
networking after resume on those SoCs.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature driver (2016 BM, 2017 PM). Recent churn is resume fixes
(`fd398d6480987`, this commit), not a rewrite. Long-present bug, not a
brand-new subsystem.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **driver-specific / config-specific / platform-specific** —
`CONFIG_MVNETA` + `CONFIG_MVNETA_BM` on 32-bit Armada 38x/XP with DT
`buffer-manager`. That is exactly Wind River / NAS / router class
hardware. SW-BM-only boards are unaffected except for the new
device_link failure path (falls back to SW BM).

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: System suspend/resume with HW BM in use. Common on embedded
devices that sleep. Not unprivileged-syscall; still a production resume
path. Not a tiny race window.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: `[Kernel paging request / panic in NAPI RX] [CRITICAL]`

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit: high** — prevents oops and dead NIC after resume on
  affected Marvell SoCs.
- **Risk: low–medium** — 90 lines, two files, new PM callbacks but they
  mirror existing destroy/probe; device_link fallback is fail-safe (SW
  BM).
- **Ratio:** benefit outweighs risk. Fits “oops / hardware PM” stable
  policy.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Documented kernel panic with stack after resume
- Real product kernel (Wind River)
- Bug present since v4.12; code is in this tree
- 90 lines, two files, no new UAPI
- Completes PM that `mvneta` already had; allowed hardware/PM class
- v6 addressed drain, ordering, mutex, dangling `virt_addr`
- Accepted by Paolo Abeni; no NAK
- Under the documented ~100-line stable size cap

AGAINST:
- Landed in **net-next**, not `net` (looks feature-sized)
- “add support” wording; new callbacks rather than a 5-line tweak
- Six revisions; not trivial at v1
- No `Tested-by` besides the author
- Oops symbol is `mvneta_rx_swbm` while HW BM poll uses `mvneta_rx_hwbm`
  (explained above, not a reason to drop a panic fix)
- Sashiko noted other pre-existing issues (not shown to break this
  patch)

UNRESOLVED:
- Could not read lore.kernel.org/stable (HTTP 403)
- Could not open sashiko’s full pre-existing-issue list (Paolo linked
  it; described as pre-existing)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — v6 matches existing
   destroy/probe; author hit the panic; maintainer applied it.
2. Fixes a real bug that affects users? **PASS** — resume oops on Armada
   + BM.
3. Important issue? **PASS** — kernel panic / paging request (CRITICAL).
4. Small and contained? **PASS** — 90 insertions, 2 files, one driver
   pair.
5. No new features or APIs? **PASS** — no UAPI; PM ops are the missing
   half of existing suspend/resume (hardware/PM workaround exception).
6. Can apply to the local tree? **PASS** — already in v7.3-rc4; helpers
   exist.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Hardware/PM workaround (missing suspend/resume causing a crash).
Not a new driver, not a new userspace API.

**Step 9.4: MAKE YOUR DECISION**
This tree is v7.3-rc4 and already contains the mvneta BM driver, mvneta
PM, and this commit’s helpers. The change fixes a user-visible panic on
resume, is contained, and is the correct completion of PM for a driver
that already suspends. It should be backported.

------------------------------------------------
What problem it solves for stable users
------------------------------------------------
On 32-bit Marvell Armada boards that use hardware buffer management,
suspend gates clocks and the BM forgets buffer addresses. Resume
reattaches the NIC to that hardware and NAPI DMA-syncs garbage,
panicking in `v7_dma_inv_range`. After resume, Ethernet is dead and the
kernel has oopsed. Stable users of these SoCs (embedded, NAS, Wind
River-style products) hit this on ordinary S2R.

------------------------------------------------
Risk vs benefit
------------------------------------------------
Benefit is a panic fix on a real resume path. Risk is a modest amount of
new PM code, already iterated through v6 and aligned with
`mvneta_bm_pool_destroy()` / `mvneta_bm_pool_use()`. Device-link failure
falls back to SW BM instead of leaving a crashy configuration.

------------------------------------------------
Verification
------------------------------------------------
- [Phase 1] Parsed tags: Yun Zhou SOB, Paolo Abeni SOB, msgid.link; no
  Fixes/Cc-stable/Reported-by
- [Phase 1] Body: ARM paging oops in DMA sync during `mvneta_poll` after
  resume
- [Phase 2] Diff: +18 `mvneta.c` (device_link + SW BM fallback), +72
  `mvneta_bm.c` (PM ops + virt_addr NULL)
- [Phase 2] `mvneta_poll` HW vs SW split and `dma_sync_single_for_cpu`
  in `mvneta_swbm_rx_frame` verified in source
- [Phase 3] BM introduced `dc35a10f68d37` (v4.6-rc1); mvneta PM
  `9768b45ceb0bc` (v4.12-rc1)
- [Phase 3] `git merge-base --is-ancestor 140be217df577 HEAD` → IS
  ancestor
- [Phase 3] hwbm mutex: `6dcdd884e2a4b` (v5.3);
  DEFINE_SIMPLE_DEV_PM_OPS: `1a3c7bb088266` (v5.17)
- [Phase 3] Follow-up `ede0f99cef53a` is a different leak, not a
  fix/revert of this patch
- [Phase 4] `b4 dig -c 140be217df577`: v2–v6, applied to net-next; no
  NAK; Paolo asked about pre-existing sashiko issues
- [Phase 4] `b4 dig -w`: netdev maintainers on To/Cc
- [Phase 4] `b4 dig -m`: v6 changelog + Paolo reply parsed from mbox
- [Phase 4] lore HTTP 403; stable@ search UNVERIFIED via WebFetch
- [Phase 5] Callers: `mvneta_bm_port_init` from probe and
  `mvneta_resume` only
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` = 7.3.0-rc4
- [Phase 6] BM and mvneta PM files present; commit already on this
  branch
- [Phase 7] Kconfig: `MVNETA_BM` depends on `!64BIT`; Armada 38x/XP
- [Phase 8] Failure mode: kernel paging request in RX NAPI after resume,
  CRITICAL
- UNVERIFIED: full sashiko finding list; whether stable@ already
  discussed this patch

**YES**

 drivers/net/ethernet/marvell/mvneta.c    | 18 ++++++
 drivers/net/ethernet/marvell/mvneta_bm.c | 72 ++++++++++++++++++++++++
 2 files changed, 90 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 71ace291a8bff..2cb6723fe801c 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -5684,6 +5684,24 @@ static int mvneta_probe(struct platform_device *pdev)
 					 "use SW buffer management\n");
 				mvneta_bm_put(pp->bm_priv);
 				pp->bm_priv = NULL;
+			} else if (!device_link_add(&pdev->dev,
+						    &pp->bm_priv->pdev->dev,
+						    DL_FLAG_AUTOREMOVE_CONSUMER)) {
+				/*
+				 * Link guarantees BM resumes before mvneta.
+				 * Without it, BM may not be ready when
+				 * mvneta_bm_port_init() runs on resume,
+				 * causing stale buffer addresses and a crash.
+				 * Fall back to SW management to be safe.
+				 */
+				dev_warn(&pdev->dev,
+					 "failed to link to BM, use SW buffer management\n");
+				mvneta_bm_pool_destroy(pp->bm_priv,
+						       pp->pool_long, 1 << pp->id);
+				mvneta_bm_pool_destroy(pp->bm_priv,
+						       pp->pool_short, 1 << pp->id);
+				mvneta_bm_put(pp->bm_priv);
+				pp->bm_priv = NULL;
 			}
 		}
 		/* Set RX packet offset correction for platforms, whose
diff --git a/drivers/net/ethernet/marvell/mvneta_bm.c b/drivers/net/ethernet/marvell/mvneta_bm.c
index 6bb3804949190..e0c693c0a9106 100644
--- a/drivers/net/ethernet/marvell/mvneta_bm.c
+++ b/drivers/net/ethernet/marvell/mvneta_bm.c
@@ -129,6 +129,7 @@ static int mvneta_bm_pool_create(struct mvneta_bm *priv,
 	if (!IS_ALIGNED((u32)bm_pool->virt_addr, MVNETA_BM_POOL_PTR_ALIGN)) {
 		dma_free_coherent(&pdev->dev, size_bytes, bm_pool->virt_addr,
 				  bm_pool->phys_addr);
+		bm_pool->virt_addr = NULL;
 		dev_err(&pdev->dev, "BM pool %d is not %d bytes aligned\n",
 			bm_pool->id, MVNETA_BM_POOL_PTR_ALIGN);
 		return -ENOMEM;
@@ -139,6 +140,7 @@ static int mvneta_bm_pool_create(struct mvneta_bm *priv,
 	if (err < 0) {
 		dma_free_coherent(&pdev->dev, size_bytes, bm_pool->virt_addr,
 				  bm_pool->phys_addr);
+		bm_pool->virt_addr = NULL;
 		return err;
 	}
 
@@ -477,6 +479,75 @@ static void mvneta_bm_remove(struct platform_device *pdev)
 	clk_disable_unprepare(priv->clk);
 }
 
+static int mvneta_bm_suspend(struct device *dev)
+{
+	struct mvneta_bm *priv = dev_get_drvdata(dev);
+	int i;
+
+	/* Drain buffers and free pool resources while BM is still clocked */
+	for (i = 0; i < MVNETA_BM_POOLS_NUM; i++) {
+		struct mvneta_bm_pool *bm_pool = &priv->bm_pools[i];
+		int size_bytes;
+
+		if (bm_pool->type == MVNETA_BM_FREE)
+			continue;
+
+		mvneta_bm_bufs_free(priv, bm_pool, bm_pool->port_map);
+		if (bm_pool->hwbm_pool.buf_num)
+			dev_warn(&priv->pdev->dev,
+				 "pool %d: %d buffers not freed\n",
+				 bm_pool->id, bm_pool->hwbm_pool.buf_num);
+
+		mvneta_bm_pool_disable(priv, bm_pool->id);
+
+		if (bm_pool->virt_addr) {
+			size_bytes = sizeof(u32) * bm_pool->hwbm_pool.size;
+			dma_free_coherent(&priv->pdev->dev, size_bytes,
+					  bm_pool->virt_addr,
+					  bm_pool->phys_addr);
+			bm_pool->virt_addr = NULL;
+		}
+		/*
+		 * Safe to destroy: device_link guarantees all mvneta ports
+		 * have already suspended, so no hwbm_pool_add() can be in
+		 * progress holding buf_lock.  Pairs with mutex_init() in
+		 * mvneta_bm_pool_use() on resume.
+		 */
+		mutex_destroy(&bm_pool->hwbm_pool.buf_lock);
+		bm_pool->type = MVNETA_BM_FREE;
+	}
+
+	mvneta_bm_write(priv, MVNETA_BM_COMMAND_REG, MVNETA_BM_STOP_MASK);
+	clk_disable_unprepare(priv->clk);
+	return 0;
+}
+
+static int mvneta_bm_resume(struct device *dev)
+{
+	struct mvneta_bm *priv = dev_get_drvdata(dev);
+	int i, err;
+
+	err = clk_prepare_enable(priv->clk);
+	if (err)
+		return err;
+
+	/* Reinitialize BM hardware; pools are refilled by mvneta_resume() */
+	mvneta_bm_default_set(priv);
+
+	/* Restore pool registers lost during clock gating */
+	for (i = 0; i < MVNETA_BM_POOLS_NUM; i++) {
+		mvneta_bm_write(priv, MVNETA_BM_POOL_READ_PTR_REG(i), 0);
+		mvneta_bm_write(priv, MVNETA_BM_POOL_WRITE_PTR_REG(i), 0);
+		mvneta_bm_write(priv, MVNETA_BM_POOL_SIZE_REG(i),
+				priv->bm_pools[i].hwbm_pool.size);
+	}
+
+	mvneta_bm_write(priv, MVNETA_BM_COMMAND_REG, MVNETA_BM_START_MASK);
+	return 0;
+}
+
+static DEFINE_SIMPLE_DEV_PM_OPS(mvneta_bm_pm_ops, mvneta_bm_suspend, mvneta_bm_resume);
+
 static const struct of_device_id mvneta_bm_match[] = {
 	{ .compatible = "marvell,armada-380-neta-bm" },
 	{ }
@@ -489,6 +560,7 @@ static struct platform_driver mvneta_bm_driver = {
 	.driver = {
 		.name = MVNETA_BM_DRIVER_NAME,
 		.of_match_table = mvneta_bm_match,
+		.pm = pm_sleep_ptr(&mvneta_bm_pm_ops),
 	},
 };
 
-- 
2.53.0

