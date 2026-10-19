Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1BE4FFA48;
	Mon, 19 Oct 2026 13:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418252; cv=none; b=ZiRm43vvCOjpG87tuNjeQKCKKwEBjR9RweU9Q14zZDc2z+aE7sJBe9bdsHR1IDSWUDSkOZP3gV8MaIulDMoiLFLEhO+vbFivJXRGj+pjQX5yFIf6ta6EV9cRV9yRP6fxOdN9YeoT6mECsXwcZL/78HkuUA0L4jn3JkBdnb5T7YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418252; c=relaxed/simple;
	bh=Wh9qhL8mCgT5QJA6GF6krnahySZ6C+OVWUpRqBcJP6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lbdkTslnH2Lq8ba6Ada9KRfOsNp3mb7vjVF7qNpgiW2o2z+mb6AraSb73Hgx4iNDTI45nttsjXNMgnEpYxyllYYrnWXEDr/DsiyQ6j1rS32rsYbJaiDPQXkqE3PXYzhVLlPOr+0DvgKBzNOoA4/B2BVmVug8FQu28h4Obq+Ob0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M725uWws; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M725uWws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D231F000C6;
	Mon, 19 Oct 2026 13:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418249;
	bh=wE1RMnUDMMnvpx7rc/PtXVu9rOvIEpslybb3iEFRjXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M725uWwsj1cRTG9dlepKZGKCbKlT+pQxQ1bmvu6kd6At8mUHoS0CKsYa7lCGndK6A
	 LrCOeQMqmQWi7mP0nuQFIVsY7+AvrUGsrW3LYKPgGN0gStxehGWs43Oimh84msw6Pc
	 Rjzp7XQl9sfvSZLBzwbq3x27tNbBDLLpklfcWEex/OW8KugWC+kwaCKeqjcDU2zuio
	 ctNgle8cbWordTQ0VtpUPQUvw7m+gcYCufEnYZ3ft4c8exiGx/QUuetdXSAHThB9c2
	 d5bAoPDI460llKrGeicKi2CX3e1b6QzSjLabypBqHBUsamh7iFSwUekkDZgWMYuoHO
	 fA9n5qKdqM14A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhi-Jun You <hujy652@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18] wifi: mt76: wed: fix kernel panic on non-DBDC MT7986
Date: Mon, 19 Oct 2026 09:46:49 -0400
Message-ID: <20261019135441.1420968-118-sashal@kernel.org>
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

From: Zhi-Jun You <hujy652@gmail.com>

[ Upstream commit 8a177dabeeead47dda4d4f91331282790eed0097 ]

In mt76_wed_init_rx_buf, it's hardcoded to use MT_RXQ_MAIN.
But for non-DBDC MT7986 MT_RXQ_BAND1 is used for RX data queue which
leads to kernel panic when attaching WED.

Use the correct RX queue by checking WED version and band_idx.

v2 and band 1 -> MT_RXQ_BAND1
Others -> MT_RXQ_MAIN

Kernel panic:

Unable to handle kernel access to user memory outside uaccess routines at virtual address 0000000000000000
Mem abort info:
  ESR = 0x0000000096000005
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x05: level 1 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000005, ISS2 = 0x00000000
  CM = 0, WnR = 0, TnD = 0, TagAccess = 0
  GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
Internal error: Oops: 0000000096000005 [#1]  SMP
CPU: 1 UID: 0 PID: 925 Comm: kmodloader Tainted: G           O        6.18.26 #0 NONE
Tainted: [O]=OOT_MODULE
Hardware name: Acer Connect Vero W6m (DT)
pstate: 40400005 (nZcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : page_pool_alloc_frag_netmem+0x1c/0x1bc
lr : page_pool_alloc_frag+0xc/0x34
sp : ffffffc081dab660
x29: ffffffc081dab660 x28: ffffffc081dabc60 x27: ffffff80091af040
x26: 0000008000000000 x25: ffffff80091a8898 x24: ffffff80091a5440
x23: 0000000000001000 x22: 0000000140000000 x21: ffffff80091a2040
x20: ffffff8003f1d780 x19: 0000000000000000 x18: 0000000000000020
x17: ffffffbfbf0ac000 x16: ffffffc080ee0000 x15: ffffff80049d47ca
x14: 000000000000037b x13: 000000000000037b x12: 0000000000000001
x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000000
x8 : ffffff8003f1d7c0 x7 : 0000000000000000 x6 : ffffff8003f1d780
x5 : 0000000000000680 x4 : 0000000000000000 x3 : 0000000000002824
x2 : 0000000000000000 x1 : ffffffc081dab71c x0 : 0000000000000000
Call trace:
 page_pool_alloc_frag_netmem+0x1c/0x1bc (P)
 page_pool_alloc_frag+0xc/0x34
 mt76_wed_init_rx_buf+0xf8/0x2ac [mt76]
 mtk_wed_start+0x79c/0x12ac
 mt7915_dma_start+0x274/0x63c [mt7915e]
 mt7915_dma_start+0x5b4/0x63c [mt7915e]
 mt7915_dma_init+0x49c/0x81c [mt7915e]
 mt7915_register_device+0x24c/0x530 [mt7915e]
 mt7915_mmio_probe+0x91c/0x1980 [mt7915e]
 platform_probe+0x58/0xa0
 really_probe+0xb8/0x2a8
 __driver_probe_device+0x74/0x118
 driver_probe_device+0x3c/0xe0
 __driver_attach+0x88/0x154
 bus_for_each_dev+0x60/0xb0
 driver_attach+0x20/0x28
 bus_add_driver+0xdc/0x200
 driver_register+0x64/0x118
 __platform_driver_register+0x20/0x30
 init_module+0x74/0x1000 [mt7915e]
 do_one_initcall+0x4c/0x1f8
 do_init_module+0x50/0x210
 load_module+0x15f8/0x1b10
 __do_sys_init_module+0x1a8/0x260
 __arm64_sys_init_module+0x18/0x20
 invoke_syscall.constprop.0+0x4c/0xd0
 do_el0_svc+0x3c/0xd0
 el0_svc+0x18/0x60
 el0t_64_sync_handler+0x98/0xdc
 el0t_64_sync+0x158/0x15c
Code: aa0003f3 a9025bf5 a90363f7 d2820017 (b9400000)

Signed-off-by: Zhi-Jun You <hujy652@gmail.com>
Link: https://patch.msgid.link/20260715152113.553-1-hujy652@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This tree is **6.6.157** (`pending-6.6`). The panic is real here, but
the mainline patch has to be rewritten onto `mt7915/mmio.c` because
`wed.c` does not exist yet.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[wifi: mt76: wed:] [fix] [kernel panic on non-DBDC MT7986 when
attaching WED because RX buf init used the wrong queue]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Signed-off-by: Zhi-Jun You <hujy652@gmail.com>` (author)
- `Link:
  https://patch.msgid.link/20260715152113.553-1-hujy652@gmail.com` (v2
  1/2 of a 2-patch series)
- `Signed-off-by: Felix Fietkau <nbd@nbd.name>` (mt76 maintainer)
- No `Fixes:` tag (expected for this review)
- No `Cc: stable@vger.kernel.org` (expected)
- No `Reported-by:` / `Tested-by:` / `Reviewed-by:` / `Acked-by:`
- Sibling patch 2/2 has the same msgid stem `20260715152113.553-2` and
  **is already in this 6.6 tree** as `8eae5e5aa09da` (`wifi: mt76:
  mt7915: fix net_fill_forward_path for non-DBDC mt7986`)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `mt76_wed_init_rx_buf` always uses `MT_RXQ_MAIN`. Non-DBDC
  MT7986 uses `MT_RXQ_BAND1` for the RX data queue.
- **Symptom:** NULL deref oops while attaching WED, in
  `page_pool_alloc_frag_netmem`. Full oops from **Acer Connect Vero
  W6m**, kernel 6.18.26, PID `kmodloader` during `mt7915e` probe.
- **Root cause:** wrong RX queue → uninitialized `page_pool` (NULL) →
  fault at `page_pool_alloc_frag*`.
- **Fix:** `wed->version == 2 && dev->phy.band_idx` → `MT_RXQ_BAND1`,
  else `MT_RXQ_MAIN`.
- Crash taint includes `O` (OOT module), but the call trace is in-tree
  `mt76` / `mt7915e` / `mtk_wed_start`.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. Explicit panic fix with a stack trace. Not
cleanup/refactor.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/net/wireless/mediatek/mt76/wed.c` (+6 / −1)
- Function: `mt76_wed_init_rx_buf`
- Scope: single-file, surgical (~5 lines of logic)

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** `q = &dev->q_rx[MT_RXQ_MAIN]` always, then
  `mt76_get_page_pool_buf(q, ...)`.
- **After:** pick `MT_RXQ_BAND1` for WED v2 + band 1; otherwise
  `MT_RXQ_MAIN`.
- Path: WED RX buffer init during `mtk_wed_start` from
  `mt7915_dma_start` (probe / DMA start), not a rare error path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- Category: **NULL pointer dereference** (memory safety) from **wrong-
  queue logic**.
- Mechanism: for non-DBDC MT7986, `mt7915_band_config` sets `band_idx =
  1` and DMA only allocates `q_rx[MT_RXQ_BAND1]`. `MT_RXQ_MAIN` is left
  with `page_pool == NULL`. `mt76_get_page_pool_buf` →
  `page_pool_dev_alloc_frag(NULL)` → oops.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct given DMA queue allocation in `mt7915/dma.c`.
- Minimal; no API/locking/refcount changes.
- Regression risk low: DBDC and band-0 devices still use `MT_RXQ_MAIN`.
- Backport caveat: in 6.6 the same logic lives in
  `mt7915_mmio_wed_init_rx_buf` (`dev` is `struct mt7915_dev *`), so the
  condition must use `dev->mt76.phy.band_idx` (or
  `dev->phy.mt76->band_idx`), not `dev->phy.band_idx`.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Hardcoded `MT_RXQ_MAIN` in 6.6: `mt7915/mmio.c:635`, from
  `2f5c3c77fc9b6` (`wifi: mt76: switch to page_pool allocator`,
  2023-02-03). Present in this tree.
- WED RX itself: `4f831d18d12da` (`wifi: mt76: mt7915: enable WED RX
  support`, 2022-12-01). Present.
- MT7986 one-A-die `band_idx = 1`: `mt7915_band_config` in `init.c`.
  Present.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Bug is the hardcoded MAIN queue vs MT7986
band-1 mapping, present since WED RX + page_pool.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- `wed.c` added later by `8a7386e787ef4` (`wifi: mt76: move wed common
  utilities in wed.c`, 2024-02-22). **Not in pending-6.6** (`git merge-
  base --is-ancestor` → not ancestor).
- Related 6.6 history: WED enable for MT7986, WED RX, page_pool switch,
  several WED robustness fixes.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record:
- Author is not the mt76 maintainer; maintainer Felix Fietkau signed
  off.
- Same author, same series date: `8eae5e5aa09da` already on pending-6.6
  (patch 2/2).
- Felix has many mt7915/WED fixes on this branch.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record:
- Standalone logic; does **not** need the `wed.c` move.
- Needed in 6.6: `wed->version` (exists, `u8 version` in
  `mtk_wed_device`), `phy.band_idx`, `MT_RXQ_BAND1`, page_pool RX — all
  present.
- Series 1/2; 2/2 is independent (forward-path queue) and already
  applied.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig` on sibling `8eae5e5aa09da` matched msgid
  `20260715152113.553-*`.
- RFC (2026-06-13): “single band MT7986”
- v1 (2026-06-30):
  https://patch.msgid.link/20260630150649.1629-1-hujy652@gmail.com (and
  1629-2)
- v2 (2026-07-15, applied):
  https://patch.msgid.link/20260715152113.553-1-hujy652@gmail.com
- v2 1/2 is the committed version. Change vs RFC: “single band” → “non-
  DBDC”.
- lore.kernel.org fetches returned 403; thread text confirmed via
  ratatoskr mirrors.
- No NAK found. Merged by Felix Fietkau (2026-07-31) as `8a177dabeeead`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w` on sibling): Zhi-Jun You; Felix Fietkau
(`nbd@nbd.name`); Lorenzo Bianconi; Ryder Lee / Shayne Chen / Sean Wang
(MediaTek); `linux-wireless`; `linux-mediatek`; Benjamin Larsson
(Suggested-by on 2/2). Maintainer merged it.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla. Concrete oops from Acer Connect Vero W6m
(MT7986). Real hardware, probe-time crash with WED.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: 2-patch v2 series. 1/2 = this panic. 2/2 =
`net_fill_forward_path` wrong WDMA queue; already in 6.6. Independent;
1/2 is the crash fix.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable returned 403. **UNVERIFIED** whether
anyone mailed stable@. 2/2 of the same series is already in this 6.6
tree, so the series is treated as 6.6-relevant.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: Mainline `mt76_wed_init_rx_buf`. In this tree:
`mt7915_mmio_wed_init_rx_buf`.

**Step 5.2: TRACE CALLERS**
Record:
- Assigned as `wed->wlan.init_rx_buf` in `mt7915_mmio_wed_init`.
- Called from `mtk_wed_rx_buffer_alloc` → `dev->wlan.init_rx_buf(dev,
  dev->wlan.rx_npkt)` (`mtk_wed.c`).
- That runs from `mtk_wed_start` ← `mt7915_dma_start` ←
  `mt7915_dma_init` ← `mt7915_register_device` ← probe.
- Reachable on device probe when WED is attached (`wed_enable` module
  param).

**Step 5.3: TRACE CALLEES**
Record: `mt76_get_rxwi`, `mt76_get_page_pool_buf` →
`page_pool_dev_alloc_frag(q->page_pool)`, `mt76_rx_token_consume`. First
page_pool alloc is the crash site.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record:
```
module load mt7915e
  → mt7915_mmio_probe / register_device
  → mt7915_dma_init → mt7915_dma_start
  → mtk_wed_device_start → mtk_wed_rx_buffer_alloc
  → mt7915_mmio_wed_init_rx_buf
  → mt76_get_page_pool_buf(uninitialized MT_RXQ_MAIN)
  → oops
```
Userspace-reachable via loading the driver (typically root). Not a
syscall fuzz path; it is a boot/probe crash on affected hardware.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: `mt7915/testmode.c` already uses `q = phy->mt76->band_idx ?
MT_RXQ_BAND1 : MT_RXQ_MAIN`. DMA init uses the same band_idx split. Same
author’s 2/2 fixes the matching forward-path mistake.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** Tree is 6.6.157 (`pending-6.6`). `wed.c` is absent.
Equivalent bug:

```
mt7915_mmio_wed_init_rx_buf:
    q = &dev->mt76.q_rx[MT_RXQ_MAIN];   /* mmio.c:635 */
```

`mt7915_dma.c`: allocate `MT_RXQ_MAIN` only if
`!dev->phy.mt76->band_idx`; allocate `MT_RXQ_BAND1` if `dbdc_support ||
band_idx`. `mt7915_band_config` sets `band_idx = 1` for MT7986 one-A-die
(non-DBDC). Introduced with WED RX + page_pool (2022–2023), well before
6.6.

`git merge-base --is-ancestor 8a177dabeeead pending-6.6` → **not
present**.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Needs a small backport**, not a clean apply. Same if/else in
`mt7915/mmio.c`, with `dev->mt76.phy.band_idx` /
`dev->phy.mt76->band_idx`. `wed->version` exists and is set to 2 for
non-netsys-v1 (MT7986) in `mtk_wed.c`. Minor conflict, not a rewrite.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No equivalent RX-buf queue selection. 2/2 (`8eae5e5aa09da`) is
here and addresses the same hardware mapping, not this NULL deref.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `drivers/net/wireless/mediatek/mt76` + MediaTek WED.
**IMPORTANT** (common Filogic/MT7986 WiFi, OpenWrt/embedded), not core
mm/VFS.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature and actively fixed on 6.6 (WED null-ptr, register
mapping, MT7981, chainmask for non-DBDC band 1).

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver-specific: MT7986 (and similar mt798x) **non-DBDC**
(single A-die) with `CONFIG_NET_MEDIATEK_SOC_WED` and `wed_enable`. Real
product: Acer Connect Vero W6m. Default `wed_enable` is false, but WED
is used on these SoCs.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Every probe with WED attached on that SKU. Not a race. Needs
privilege to load the module; typical as a platform driver at boot.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Kernel oops/panic on WiFi/WED attach. **CRITICAL** for those
devices (WiFi unusable; can panic the box).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** high for MT7986 non-DBDC + WED (prevents probe oops).
- **Risk:** low (5-line queue index; other SKUs unchanged).
- **Ratio:** benefit ≫ risk. Backport must retarget `mmio.c`.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Documented oops: NULL `page_pool` in WED RX init.
- Same bug in this tree (`mt7915_mmio_wed_init_rx_buf` + DMA not
  allocating MAIN when `band_idx == 1`).
- Small, obviously correct queue selection.
- mt76 maintainer signed off; RFC → v1 → v2.
- Sibling 2/2 already on 6.6.
- MT7986 + WED RX + page_pool all exist here.
- `wed->version` and `band_idx` exist.

AGAINST:
- Patch file `wed.c` is not in 6.6 (moved in 6.8-era `8a7386e787ef4`).
- Needs a few-line context backport.
- WED off by default; subset of MT7986 boards.
- Crash log tainted OOT; still in-tree frames.

UNRESOLVED:
- Stable ML discussion (lore/stable 403).
- Whether every reviewer asked for Cc: stable (not seen on v2 1/2).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — matches DMA allocation;
   maintainer merged; oops on real HW.
2. Fixes a real bug that affects users? **PASS** — probe oops on non-
   DBDC MT7986 + WED.
3. Important issue? **PASS** — kernel oops, severity CRITICAL for that
   hardware.
4. Small and contained? **PASS** — ~5 lines, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** with a backport to
   `mt7915/mmio.c` (stable rule: apply cleanly **or come with a
   backport**). Not a missing-feature case.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None (not a device ID/quirk/DT/build/doc). Ordinary crash fix.

**Step 9.4: MAKE YOUR DECISION**
The 6.6 tree has the same panic path under a pre-`wed.c` name. Selecting
this for 6.6 is justified; apply the same `version == 2 && band_idx`
check in `mt7915_mmio_wed_init_rx_buf`.

---

**What the commit solves for this tree:** On non-DBDC MT7986, the main
phy is band 1, so only `MT_RXQ_BAND1` is allocated. WED RX init still
pulls from `MT_RXQ_MAIN`, whose `page_pool` is NULL, and the kernel
oopses in `page_pool_alloc_frag` during `mt7915e` probe. That mapping is
already in 6.6 `init.c`/`dma.c`; only the RX-buf picker is wrong.

**Stable rules:** Real, important crash; tiny logic fix; no new API.
File path changed after 6.6, so it needs a short backport, not a NAK.

**Risk vs benefit:** Low risk, high benefit on Filogic devices that
enable WED (including the reported Acer Vero W6m class).

**Concerns:** Must edit
`drivers/net/wireless/mediatek/mt76/mt7915/mmio.c` and use
`dev->mt76.phy.band_idx` (or `dev->phy.mt76->band_idx`) because `dev` is
`struct mt7915_dev *` here. Do not require `8a7386e787ef4`.

Verification:
- [Phase 1] Subject/tags: fix panic; SOB Zhi-Jun You + Felix Fietkau;
  Link `20260715152113.553-1`; no Fixes/Cc-stable
- [Phase 1] Series: v2 1/2; 2/2 already `8eae5e5aa09da` on pending-6.6
- [Phase 2] Diff: 6 insertions in `mt76_wed_init_rx_buf`; queue MAIN vs
  BAND1
- [Phase 3] Blame on 6.6: `q = &dev->mt76.q_rx[MT_RXQ_MAIN]` from
  `2f5c3c77fc9b6` (page_pool); present
- [Phase 3] `8a7386e787ef4` (wed.c split) **not** ancestor of
  pending-6.6
- [Phase 3] Fix `8a177dabeeead` **not** ancestor of pending-6.6
- [Phase 4] b4 dig: RFC → v1 → v2; applied v2; Felix merged 2026-07-31
- [Phase 4] Recipients: mt76 maintainers + linux-wireless/mediatek
- [Phase 4] UNVERIFIED: lore.kernel.org and lore.kernel.org/stable HTTP
  403; used ratatoskr mirrors
- [Phase 5] Caller: `mtk_wed_rx_buffer_alloc` → `wlan.init_rx_buf` from
  `mtk_wed_start` / probe
- [Phase 6] `git show pending-6.6:Makefile`: VERSION 6 / PATCHLEVEL 6 /
  SUBLEVEL 157
- [Phase 6] `git cat-file` pending-6.6 `wed.c`: path does not exist
- [Phase 6] pending-6.6 `mmio.c:635`: hardcoded `MT_RXQ_MAIN`; `init.c`
  sets `band_idx = 1` for one-A-die MT7986
- [Phase 6] DMA: MAIN allocated only if `!band_idx`; BAND1 if
  `dbdc_support || band_idx`
- [Phase 6] `wed->version` exists; set to 2 for MT7986-class WED
- [Phase 8] Failure: NULL page_pool deref → oops; CRITICAL for that
  SKU+WED
- UNVERIFIED: whether an out-of-tree module contributed besides in-tree
  frames (taint `O`)

**YES**

 drivers/net/wireless/mediatek/mt76/wed.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/wed.c b/drivers/net/wireless/mediatek/mt76/wed.c
index fbd7e59c73aaf..2ebf4edc689e9 100644
--- a/drivers/net/wireless/mediatek/mt76/wed.c
+++ b/drivers/net/wireless/mediatek/mt76/wed.c
@@ -33,10 +33,15 @@ u32 mt76_wed_init_rx_buf(struct mtk_wed_device *wed, int size)
 {
 	struct mtk_wed_bm_desc *desc = wed->rx_buf_ring.desc;
 	struct mt76_dev *dev = mt76_wed_to_dev(wed);
-	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
 	struct mt76_txwi_cache *t = NULL;
+	struct mt76_queue *q;
 	int i;
 
+	if (wed->version == 2 && dev->phy.band_idx)
+		q = &dev->q_rx[MT_RXQ_BAND1];
+	else
+		q = &dev->q_rx[MT_RXQ_MAIN];
+
 	for (i = 0; i < size; i++) {
 		dma_addr_t addr;
 		u32 offset;
-- 
2.53.0

