Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B285D606134;
	Mon, 19 Oct 2026 14:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418601; cv=none; b=MNe0FEJJWysMgPMRLgqneBmXmwo7loB9qn/iV6Omjz2yFLDGQ2ickztlm1KBOb2waCqts/no+Y7+M4BqzLjpWLdn+zp5nZG+ro+z8ntnGUTUG/BzzE4Mxo346U7in3liFaE1cIUTPbLzhZBJ3WDHnuIikk5hthNbWl685kDFLxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418601; c=relaxed/simple;
	bh=PMgA9PZlf02ZMMOTWwvddXbD6Vd+7kTdfmbeboZtQ1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZTgnRaK7gXcykc1dNIN71PlwBmWhR+J7ypf0SOihrzi1A30TbYh25GBo20K44PbxommKbOmVWScjyrXiuDZnHiK98NVIhKKvg5MQkgSj3N9uF7zIPGc3UmFPpVwgfDWXXErSObhIgmAbZQCX+/Ju0UElFN85hvLuEyZetrcoMtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U3x7giZi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U3x7giZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC17D1F000C8;
	Mon, 19 Oct 2026 14:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418598;
	bh=1f/3E7GBQELuPmGfuS3V/GVdSIWaQRfdTZ0pogT42/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U3x7giZiGYq90ojmSCsCtoEpLgkZOL3CoO533x1tBTMMbRqaXQgF58W4sfoRA14GP
	 gYc5xL15WYswbxMPg3NRg13xebWMJmMeaSE6EkISxonLyj+bayYyKShgXlG6bXfBWw
	 IRxFhdUd0N1GqCOz+Lbn6oDWnnNQxeZWJbW6dKu3Ofd2wUB384RDRlT9erVStAiL16
	 cDYYGdyqnvql5R+dIGpAKyDxMaakYxTKOkFnK/qLHLDdVgEsYgInhy7C2fH21WsS5D
	 CS1HLV0wewhvlmeGv9wpB4aLLXwsdxOtMqJ0gjLoik6AMID5X2pAX+ZsEBEWtEBD1q
	 layPsnMXDkvNQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
	Xu Rao <raoxu@uniontech.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	mathias.nyman@intel.com,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] xhci: include all root port children in recovery prevention on link error
Date: Mon, 19 Oct 2026 09:50:53 -0400
Message-ID: <20261019135441.1420968-362-sashal@kernel.org>
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

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit e3d757dc9257f2638ca61eda4faef26c2daeea10 ]

Driver already prevents useless transfer retry and endpoint recovery
for devices directly connected to a root port with link errors.

These devices are either disconnecting or will be reset. Link is gone.

Move the flag indicating link error from the xhci device structure to
the root port strucure, allowing all child devices behind hubs to easily
check for root port link errors, avoiding useless transfer retries and
endpoint recovery.

This extends the previous endpoint recovery prevention in
commit b8c3b718087b ("usb: xhci: Don't try to recover an endpoint if port
is in error state.")
Only root port link errors can be detected early by xhci driver,
not link errors between external hubs and their children.

Tested-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20260806142113.2436238-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
- Record: `[xhci]` `[include]` extend existing root-port link-error
  recovery skip from the directly attached device to every device under
  that root port.

**Step 1.2: Tags**
- Record:
  - `Tested-by: Xu Rao <raoxu@uniontech.com>`
  - `Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>` (xhci
    maintainer)
  - `Link: https://patch.msgid.link/20260806142113.2436238-4-
    mathias.nyman@linux.intel.com`
  - `Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>`
  - No `Fixes:` / `Cc: stable` (expected for this review)
  - Pipeline `Signed-off-by: Sasha Levin` ignored
- Notable: maintainer-authored; tester is the person who hit the host-
  teardown bug.

**Step 1.3: Body**
- Record:
  - **Bug:** On a root port in SS.Inactive, xhci already skips URB
    enqueue and endpoint reset for the device plugged into that port
    (`VDEV_PORT_ERROR`). Devices behind hubs never get that flag, so
    they still retry transfers and reset endpoints after the root-port
    link is gone.
  - **Symptom:** Useless recovery while the hub driver is still sorting
    the port out. The existing comment on this path is “Can cause host
    hang.” The 2019 precursor (`b8c3b718087b`) documented host-
    controller stop after repeated endpoint resets on an inactive root
    port.
  - **Root cause:** The error flag lives on `xhci_virt_device`, and
    `handle_port_status()` only sets it on `xhci->devs[port->slot_id]`
    (the device directly on the root port).
  - **Fix:** Move the flag to `xhci_port->link_inactive` so every child
    that already has `vdev->rhub_port` can see the same root-port state.
  - **Limit:** Only root-port link errors are visible this way, not hub-
    to-child link errors.

**Step 1.4: Hidden bug fix?**
- Record: Not hidden. It is an explicit extension of a hang-prevention
  check. Moving the flag off `vdev` is a small structural change with
  standalone functional effect, not a pure cleanup.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
- Record:
  - `drivers/usb/host/xhci-ring.c`: `xhci_handle_halted_endpoint()`,
    `handle_port_status()` (~15+/12-)
  - `drivers/usb/host/xhci.c`: `xhci_urb_enqueue()`,
    `xhci_discover_or_reset_device()` (1+ / 3-)
  - `drivers/usb/host/xhci.h`: drop `vdev->flags` / `VDEV_PORT_ERROR`;
    add `xhci_port.link_inactive:1`
  - Net: 17 insertions, 23 deletions. Single-subsystem surgical change.

**Step 2.2: Control-flow change**
- Record:
  - **Before:** Port event with PLS==`XDEV_INACTIVE` and no `PORT_RESET`
    sets `vdev->flags |= VDEV_PORT_ERROR` on the directly attached slot
    only. `PORT_RC` clears it. `reset_device` also zeros `vdev->flags`.
    Halted-endpoint recovery and URB enqueue consult that per-device
    flag.
  - **After:** If the port is not in reset, `port->link_inactive = (pls
    == XDEV_INACTIVE)`. All devices whose `rhub_port` is that port skip
    recovery/enqueue. Device reset no longer clears the flag; port
    events drive it from real PLS.

**Step 2.3: Bug mechanism**
- Record: **Logic / correctness + hardware hang workaround.** Same class
  as the 2019 “don’t reset an endpoint on an inactive root port” fix.
  Also improves flag lifetime vs the stale-flag bug already fixed in
  this tree by `d77efd7b3def7` (clearing is now “link is not Inactive”,
  not “PORT_RC or reset_device succeeded”).

**Step 2.4: Fix quality**
- Record: Obviously correct for the stated gap. Minimal. Regression risk
  is low: skipping recovery when the root-port link is gone is the
  intended policy; clearing is tied to actual port state, which is
  stricter and more accurate than clearing on `reset_device` while the
  port may still be Inactive. Theoretical `rhub_port == NULL` deref
  exists in the new loads; `xhci_setup_addressable_virt_dev()` sets
  `rhub_port` before normal URB traffic, and mainline has no follow-up
  NULL-check fix on this path.

## Phase 3: Git history

**Step 3.1: Blame**
- Record: Flag set/clear in `handle_port_status()` is `d77efd7b3def7`
  (2025), which reworked `b8c3b718087b` (2019-06-18, v5.2-rc5 era, `Cc:
  stable`). The hang-prevention hole for hub children has been in the
  driver since 2019.

**Step 3.2: Fixes: tag**
- Record: None. The message names `b8c3b718087b`, which **is** an
  ancestor of this 6.12 tree (`git merge-base --is-ancestor` exit 0).

**Step 3.3: Related file history**
- Record:
  - `d77efd7b3def7` “fix stale flag preventing URBs after link state
    error is cleared” — already in this tree; this commit supersedes its
    per-vdev flag management.
  - Same-day series on `origin/master`: `e3d757dc9257f` (this) →
    `042aad8d0db66` (disconnect) → `7e0ef4332ed9b` (`EP_DROP_PENDING`).
  - None of those three are in this checkout.

**Step 3.4: Author**
- Record: Mathias Nyman is the xhci maintainer. This is his generic
  replacement for Xu Rao’s proposed `XHCI_NO_SOFT_RETRY` quirk on
  Renesas uPD720201.

**Step 3.5: Dependencies**
- Record: This patch does **not** need the later two to compile or to
  apply its own logic. The later two **do** need this
  (`rhub_port->link_inactive`). Local context differs
  (`readl(port->addr)` vs `xhci_portsc_readl()`, no `xhci_sideband`
  field); those are apply-noise, not semantic prerequisites. `rhub_port`
  itself (`06790c19086fe`) is already here.

## Phase 4: Mailing list

**Step 4.1: Original discussion**
- Record:
  - `b4 dig -c e3d757dc9257f`: lore `https://patch.msgid.link/2026080614
    2113.2436238-4-mathias.nyman@linux.intel.com`
  - Applied version is **[PATCH 03/17] xhci features and fixes for usb-
    next** (Aug 6 2026).
  - First posting was **[RFT PATCH 1/3] xhci: avoid futile stop endpoint
    command and host teardown** (`20260629123031.142133-2`).
  - Cover letter of that RFT: stop-endpoint timeout → `xHCI host
    controller not responding, assume dead`.
  - No NAK. No reviewer `Cc: stable` on this specific patch.

**Step 4.2: Recipients**
- Record: `b4 dig -w`: Mathias Nyman, gregkh, linux-usb, Xu Rao. Right
  list and USB maintainer.

**Step 4.3: Bug report**
- Record: Xu Rao, Renesas uPD720201 (`1912:0014`), Genesys Logic hub +
  RTL8153. Repro: bring Ethernet up, hot-unplug hub. Log:
  - `Transfer error` → `Soft-reset ep` → `xHCI host not responding to
    stop endpoint command` → `assume dead` → `HC died`.
  - Xu tested the **3-patch RFT as a whole** and said the teardown is
    gone; he also said the `EP_DROP_PENDING` path (patch 3 of that
    series) was used on disconnect. He agreed the generic series made
    the `XHCI_NO_SOFT_RETRY` quirk unnecessary.

**Step 4.4: Series context**
- Record: Standalone for *link-error* hub children. The reported hot-
  unplug teardown is a **disconnect** path that also wants
  `042aad8d0db66` and `7e0ef4332ed9b`. This commit is still the
  necessary first step and independently closes the Inactive-link gap.

**Step 4.5: stable@ discussion**
- Record: No stable-specific thread found for this SHA. The 2019
  precursor and the 2025 stale-flag fix both went to stable.

## Phase 5: Semantic / call-path analysis

**Step 5.1: Functions**
- Record: `xhci_handle_halted_endpoint()`, `handle_port_status()`,
  `xhci_urb_enqueue()`, `xhci_discover_or_reset_device()`. Structs:
  `xhci_virt_device`, `xhci_port`.

**Step 5.2: Callers of halted-endpoint recovery (this tree)**
- Record: transaction/babble/split errors, stall, bulk/interrupt soft-
  retry (`process_bulk_intr_td`), stream transferless events, stop-ep
  completion racing a stall. All of these run from xhci interrupt/event
  handling during normal USB I/O.

**Step 5.3: Callees**
- Record: `xhci_reset_halted_ep()` / `xhci_queue_reset_ep()` — the
  commands that, on a dead link, have hung or killed hosts.

**Step 5.4: Reachability**
- Record: Yes. Any USB transfer on a device under an xhci root port
  whose PLS is `XDEV_INACTIVE`. Hot-unplug / bad SuperSpeed link is a
  normal user action, not a debug path.

**Step 5.5: Similar patterns**
- Record: Same skip already exists for the directly attached device.
  Follow-up commits add `port->connected` and `EP_DROP_PENDING` for
  disconnect; they are not in this tree.

## Phase 6: This tree (6.12.111)

**Step 6.1: Buggy code present?**
- Record: **Yes.** `p-6.12-3-gc504cf0baa3d8`, `VERSION=6 PATCHLEVEL=12
  SUBLEVEL=111`.
  - `xhci.h:753` `VDEV_PORT_ERROR`
  - `xhci-ring.c:943` and `xhci.c:1572` still test `vdev->flags`
  - `xhci-ring.c:2024-2028` still sets the flag only on the directly
    attached `vdev`
- Candidate SHA `e3d757dc9257f` is **not** an ancestor of HEAD.

**Step 6.2: Backport difficulty**
- Record: **Minor context.** This tree still uses `readl(port->addr)`
  (not `xhci_portsc_readl`), `xhci_get_usb3_hcd()`, and has no
  `xhci_sideband`. The logic hunks (`VDEV_PORT_ERROR` →
  `rhub_port->link_inactive`, port-level PLS update, drop
  `virt_dev->flags = 0`) match this tree.

**Step 6.3: Related fixes already here**
- Record: `b8c3b718087b` and `d77efd7b3def7` are here. They only cover
  the directly attached device. Disconnect/`EP_DROP_PENDING` follow-ups
  are not here. Renesas `0x0014` still has only `XHCI_ZERO_64B_REGS`,
  not `XHCI_NO_SOFT_RETRY`.

## Phase 7: Subsystem

**Step 7.1**
- Record: USB xhci host controller. **IMPORTANT** — default host on most
  PCs, many embedded SoCs, Android.

**Step 7.2**
- Record: Actively maintained; this is a targeted hang-prevention fix in
  a mature path, not a new subsystem.

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
- Record: Users of xhci with a hub (or composite device with an
  integrated hub) under a root port that goes SS.Inactive, plus any
  topology that currently misses `VDEV_PORT_ERROR`. Confirmed hardware:
  Renesas uPD720201 + Genesys hub + RTL8153; the mechanism is not
  vendor-specific.

**Step 8.2: Trigger**
- Record: Root-port link Inactive (cable/hub/link training). Common in
  the field. Unprivileged users can unplug USB devices. Full Xu Rao hot-
  unplug teardown also needs the later disconnect patches.

**Step 8.3: Failure mode**
- Record: Endpoint reset / soft-retry on a dead link → stop-endpoint
  timeout → **`xHCI host controller not responding, assume dead`** →
  entire xhci bus torn down. **CRITICAL** (host death, all USB on that
  controller gone). The 2019 write-up also described host stop after
  repeated endpoint resets.

**Step 8.4: Risk/benefit**
- Record: Benefit high (prevents host teardown on a realistic USB event;
  closes a 2019 hang hole for hub children). Risk low (~20-line xhci-
  only change, no API, policy already used for direct-attach devices).
  Ratio favors backport.

## Phase 9: Synthesis

**For:**
- Real hang/host-death class bug; xhci is widely deployed.
- Extends a fix that already went to stable in 2019.
- Small, maintainer-written, tester-acked as part of the hang series.
- Buggy code is in 6.12; apply needs only local context tweaks.
- Standalone value: hub children currently do not skip recovery on root-
  port Inactive.

**Against:**
- First of a 3-patch hang series; Xu Rao’s hot-unplug case also needs
  the disconnect + `EP_DROP_PENDING` patches.
- No `Cc: stable` on this commit (not a negative per the review rules).
- Tiny leftover: `vdev` is still fetched in `handle_port_status()` for
  later `xhci_ring_device()`, so it is not unused.

**Unresolved:** Whether `rhub_port` can be NULL at `xhci_urb_enqueue()`
in some rare pre-address path — unverified as a real 6.12 trigger; not
used as a NO reason.

**Stable rules**
1. Obviously correct and tested — **PASS** (maintainer + Tested-by)
2. Real user-visible bug — **PASS** (host teardown / hang)
3. Important — **PASS** (CRITICAL: xhci assumed dead)
4. Small and contained — **PASS**
5. No new features/APIs — **PASS**
6. Applies to this tree — **PASS** (minor context)

**Exception category:** None required; ordinary bugfix.

This should be backported to **this** 6.12 tree. It is not a new
feature; it is the missing half of an existing hang-prevention check.
The later two series patches are additional (disconnect) coverage, not a
reason to keep this gap in 6.12.

## Verification
- [Phase 1] Parsed tags: Tested-by Xu Rao; Link msgid `...2436238-4`;
  maintainer SOB; no Fixes/Cc:stable
- [Phase 2] Diff: move `VDEV_PORT_ERROR` from `xhci_virt_device` to
  `xhci_port.link_inactive`; 17+/23-
- [Phase 3] `git describe HEAD` / Makefile: **6.12.111**
  (`p-6.12-3-gc504cf0baa3d8`)
- [Phase 3] `git merge-base --is-ancestor b8c3b718087b HEAD` → yes;
  `e3d757dc9257f` → no
- [Phase 3] `git blame` on flag set/clear: `d77efd7b3def7` (already in
  tree) over `b8c3b718087b` (2019)
- [Phase 3] `git show d77efd7b3def7`: stale-flag fix still uses per-vdev
  flag; this commit replaces that
- [Phase 4] `b4 dig -c e3d757dc9257f`: PATCH 03/17; earlier RFT 1/3
- [Phase 4] `b4 mbox` RFT cover: “stop endpoint command” / “assume dead”
- [Phase 4] Xu Rao: teardown gone after the 3-patch series;
  EP_DROP_PENDING used on unplug
- [Phase 4] Original report: Renesas 1912:0014, Genesys hub, RTL8153
  hot-unplug
- [Phase 5] Callers of `xhci_handle_halted_endpoint` in `xhci-ring.c`
  (soft retry, stall, transaction error)
- [Phase 6] Local `VDEV_PORT_ERROR` still present; `rhub_port` present;
  Renesas 0x0014 lacks `XHCI_NO_SOFT_RETRY`
- [Phase 8] Failure mode verified in `xhci-ring.c:1725` (“xHCI host not
  responding to stop endpoint command”)
- UNVERIFIED: lore.kernel.org HTTP fetch (403); used `b4` instead
- UNVERIFIED: concrete 6.12 NULL `rhub_port` at enqueue; not used for
  the verdict

**YES**

 drivers/usb/host/xhci-ring.c | 27 +++++++++++++++------------
 drivers/usb/host/xhci.c      |  4 +---
 drivers/usb/host/xhci.h      |  9 +--------
 3 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 6ce5874fc4b3d..dc18da8385a21 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1008,7 +1008,7 @@ static int xhci_handle_halted_endpoint(struct xhci_hcd *xhci,
 	 * Avoid resetting endpoint if link is inactive. Can cause host hang.
 	 * Device will be reset soon to recover the link so don't do anything
 	 */
-	if (ep->vdev->flags & VDEV_PORT_ERROR)
+	if (ep->vdev->rhub_port->link_inactive)
 		return -ENODEV;
 
 	/* add td to cancelled list and let reset ep handler take care of it */
@@ -2007,13 +2007,15 @@ static void xhci_cavium_reset_phy_quirk(struct xhci_hcd *xhci)
 static void handle_port_status(struct xhci_hcd *xhci, union xhci_trb *event)
 {
 	struct xhci_virt_device *vdev = NULL;
-	struct usb_hcd *hcd;
-	u32 port_id;
-	u32 portsc, cmd_reg;
-	unsigned int hcd_portnum;
 	struct xhci_bus_state *bus_state;
-	bool bogus_port_status = false;
 	struct xhci_port *port;
+	struct usb_hcd *hcd;
+	bool bogus_port_status = false;
+	unsigned int hcd_portnum;
+	u32 cmd_reg;
+	u32 port_id;
+	u32 portsc;
+	u32 pls;
 
 	/* Port status change events always have a successful completion code */
 	if (GET_COMP_CODE(le32_to_cpu(event->generic.field[2])) != COMP_SUCCESS)
@@ -2050,6 +2052,7 @@ static void handle_port_status(struct xhci_hcd *xhci, union xhci_trb *event)
 	bus_state = &port->rhub->bus_state;
 	hcd_portnum = port->hcd_portnum;
 	portsc = xhci_portsc_readl(port);
+	pls = portsc & PORT_PLS_MASK;
 
 	xhci_dbg(xhci, "Port change event, %d-%d, id %d, portsc: 0x%x\n",
 		 hcd->self.busnum, hcd_portnum + 1, port_id, portsc);
@@ -2061,12 +2064,12 @@ static void handle_port_status(struct xhci_hcd *xhci, union xhci_trb *event)
 		usb_hcd_resume_root_hub(hcd);
 	}
 
-	if (vdev && (portsc & PORT_PLS_MASK) == XDEV_INACTIVE) {
-		if (!(portsc & PORT_RESET))
-			vdev->flags |= VDEV_PORT_ERROR;
-	} else if (vdev && portsc & PORT_RC) {
-		vdev->flags &= ~VDEV_PORT_ERROR;
-	}
+	/*
+	 * Tag broken links to avoid retries while hub driver sorts it out.
+	 * Link status is not relible while port is in reset.
+	 */
+	if (!(portsc & PORT_RESET))
+		port->link_inactive = (pls == XDEV_INACTIVE);
 
 	if ((portsc & PORT_PLC) && (portsc & PORT_PLS_MASK) == XDEV_RESUME) {
 		xhci_dbg(xhci, "port resume event for port %d\n", port_id);
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 14eeb16f668b2..a4fab82da76b6 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1674,7 +1674,7 @@ static int xhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb, gfp_t mem_flag
 		goto free_priv;
 	}
 
-	if (xhci->devs[slot_id]->flags & VDEV_PORT_ERROR) {
+	if (xhci->devs[slot_id]->rhub_port->link_inactive) {
 		xhci_dbg(xhci, "Can't queue urb, port error, link inactive\n");
 		ret = -ENODEV;
 		goto free_priv;
@@ -4038,7 +4038,6 @@ static int xhci_discover_or_reset_device(struct usb_hcd *hcd,
 				xhci_get_slot_state(xhci, virt_dev->out_ctx));
 		xhci_dbg(xhci, "Not freeing device rings.\n");
 		/* Don't treat this as an error.  May change my mind later. */
-		virt_dev->flags = 0;
 		ret = 0;
 		goto command_cleanup;
 	case COMP_SUCCESS:
@@ -4090,7 +4089,6 @@ static int xhci_discover_or_reset_device(struct usb_hcd *hcd,
 	}
 	/* If necessary, update the number of active TTs on this root port */
 	xhci_update_tt_active_eps(xhci, virt_dev, old_active_eps);
-	virt_dev->flags = 0;
 	ret = 0;
 
 command_cleanup:
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index caa3fbee29f2c..87d43bc95bf33 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -741,14 +741,6 @@ struct xhci_virt_device {
 	struct xhci_port		*rhub_port;
 	struct xhci_interval_bw_table	*bw_table;
 	struct xhci_tt_bw_info		*tt_info;
-	/*
-	 * flags for state tracking based on events and issued commands.
-	 * Software can not rely on states from output contexts because of
-	 * latency between events and xHC updating output context values.
-	 * See xhci 1.1 section 4.8.3 for more details
-	 */
-	unsigned long			flags;
-#define VDEV_PORT_ERROR			BIT(0) /* Port error, link inactive */
 
 	/* The current max exit latency for the enabled USB3 link states. */
 	u16				current_mel;
@@ -1469,6 +1461,7 @@ struct xhci_port {
 	int			hcd_portnum;
 	struct xhci_hub		*rhub;
 	struct xhci_port_cap	*port_cap;
+	unsigned int		link_inactive:1;
 	unsigned int		lpm_incapable:1;
 	unsigned long		resume_timestamp;
 	bool			rexit_active;
-- 
2.53.0

