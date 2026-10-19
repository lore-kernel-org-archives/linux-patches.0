Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B15E5AAA79;
	Mon, 19 Oct 2026 14:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418440; cv=none; b=uqvl/7dxOOqddJHYlOGt0YJv3ac2uInbKK1yoGhI5wrylwQItc2yoqcH3oTdbhKjrPGqPMI48gxIDwnKQgUm/q8JiXv9N/kgkLZAi123rb/IrGTYF8YdcVDAuqfGPXzW6oMtPmzmW14ZVQdCwlPNYIGMK1CFb0e7LRGhscq/r3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418440; c=relaxed/simple;
	bh=Ehvru5+ldJBduoygYSuQdUwKqM8A7a0cDhK8j4//YYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vjgz37SZrDtJcbG2Nn08mrWa6POYSjllBxvWycWsHZKAV+JDCXLD8EC4kZ8qE3BwLp2OSk54uZ2q9ZxV8KvZ8mHijopIESm0OFLXCIPqG3tGbaO5wSMfohC3wvU39JG05KPY3MNzurdGztKZToz3xGZkrrcxikuG3pGqI8R/fqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ELLcva8r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ELLcva8r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7AA21F000C6;
	Mon, 19 Oct 2026 14:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418437;
	bh=1PkHk1uLwav5pSsmfdAoI/HuuNXk14LCPIv1GCHnexA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ELLcva8roZbsJD0gAuOVFxCGpYoELknoNocCUgO8bIzLGVSvk7yy+XnOAJgKUnrAT
	 VRLZwhvUnfiuUqSEIPReh3cRuNrWFzgzlkAEX0ddaWJZ5gPvB96SbCiPxPatzegSPT
	 Q1WXMTolO6bJGTCLhBoWvaXzCvjVF3g+GTa2xSrUhRgZax/1+9LSM7dRiuH12ck13c
	 Kf8hL+DzFR4GNCRgW558GYYie8B4gbU9wgObK8TywmGUM5E0dZ1wN1FNwA9lxje3P0
	 UriyAPAervYGUycLSXe9D9UTjP402q1pakjTgBsGXvUt3Cw2ygA0fIyIB6S/vKhk8/
	 SLI2hDkXnWI7A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jinhui Guo <guojinhui.liam@bytedance.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	oliver@neukum.org,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	linux-usb@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] net: usb: cdc_ether: add quirk for AMI BMC stale link events
Date: Mon, 19 Oct 2026 09:48:59 -0400
Message-ID: <20261019135441.1420968-248-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Transfer-Encoding: 8bit

From: Jinhui Guo <guojinhui.liam@bytedance.com>

[ Upstream commit 089ca284afb0f3b2870a5ce41524cbc91ed350d4 ]

On AMD Genoa/Turin platforms the BMC-provided USB-Ethernet gadget
(American Megatrends, VID 0x046b PID 0xffb0) intermittently fails to
respond to ARP after AC cold boot.  usbmon captures a stale
NETWORK_CONNECTION(off) immediately followed by
NETWORK_CONNECTION(on) on the interrupt endpoint (~130us apart)
after enumeration.  Because alloc_netdev() leaves
__LINK_STATE_NOCARRIER cleared, netif_carrier_ok() returns true
when the spurious OFF arrives, so usbnet_cdc_status() cannot
recognise it as redundant and schedules EVENT_LINK_CHANGE.
__handle_link_change() then calls unlink_urbs(), killing ~60 rx
URBs whose payload has already been DMA'd into memory — xHCI trace
confirms them completing as -ECONNRESET with non-zero residual
length.  rx_complete() drops these unconditionally.  The following
ON restores the carrier and re-submits URBs, but the ARP reply is
already lost; the interface looks "up but silent" until ifdown/ifup.

Fix this by adding a device-specific quirk with FLAG_LINK_INTR set,
which makes usbnet_probe() call netif_carrier_off() after bind.
With initial carrier == OFF, usbnet_cdc_status() recognises the
spurious OFF as matching the current state and drops it; the
subsequent ON is the first real event and brings the link up
cleanly without ever tearing down the rx queue.  The scheduled
link-change kevent is harmless because EVENT_DEV_OPEN is not yet
set at probe time.

This is applied as a device-specific quirk rather than a change to
the shared cdc_info driver_info because some CDC devices never
send NETWORK_CONNECTION notifications; forcing carrier off for
them would leave the link permanently DOWN.  Restricting the change
to this VID/PID keeps that class of device untouched.

Tested on Genoa and Turin across 100+ AC cold boot cycles; ping
first-packet success rate went from intermittent to 100%.

Signed-off-by: Jinhui Guo <guojinhui.liam@bytedance.com>
Link: https://patch.msgid.link/20260730051341.24930-1-guojinhui.liam@bytedance.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Local tree is **6.12.111**. The buggy `cdc_ether` path is present here,
and this is a device-specific hardware quirk for an existing driver.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 PARSE THE SUBJECT LINE**
- Record: `[net: usb: cdc_ether] [add quirk] [AMI BMC VID 0x046b PID
  0xffb0 stale NETWORK_CONNECTION events]`

**Step 1.2 PARSE ALL COMMIT MESSAGE TAGS**
- Record:
  - `Signed-off-by: Jinhui Guo <guojinhui.liam@bytedance.com>` (author)
  - `Link: https://patch.msgid.link/20260730051341.24930-1-
    guojinhui.liam@bytedance.com`
  - `Signed-off-by: Jakub Kicinski <kuba@kernel.org>` (netdev maintainer
    applied it)
  - No `Fixes:`, no `Cc: stable`, no `Reported-by`, no `Reviewed-by`, no
    `Acked-by`, no `Tested-by` (absence of Fixes/Cc-stable is expected
    for this review)
  - Ignore pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit
    ...]` if present

**Step 1.3 ANALYZE THE COMMIT BODY TEXT**
- Record:
  - **Bug:** AMI BMC USB-Ethernet gadget on AMD Genoa/Turin (VID
    `0x046b` PID `0xffb0`) intermittently fails ARP after AC cold boot.
  - **Symptom:** Interface looks “up but silent” until `ifdown`/`ifup`.
  - **Root cause:** After enumeration, firmware emits stale
    `NETWORK_CONNECTION(off)` then `(on)` ~130µs apart. `alloc_netdev()`
    leaves `__LINK_STATE_NOCARRIER` clear, so `netif_carrier_ok()` is
    true; `usbnet_cdc_status()` treats OFF as a real transition,
    schedules `EVENT_LINK_CHANGE`, and `__handle_link_change()`
    `unlink_urbs()`s ~60 RX URBs. Completions come back as `-ECONNRESET`
    with payload already DMA’d; `rx_complete()` drops them, including
    the ARP reply.
  - **Fix:** Device-specific `driver_info` with `FLAG_LINK_INTR` so
    probe starts carrier OFF; redundant OFF is dropped; ON is the first
    real event.
  - **Why not global:** Some CDC devices never send
    `NETWORK_CONNECTION`; forcing carrier off would leave them
    permanently DOWN.
  - **Testing:** 100+ AC cold boots on Genoa and Turin; first-packet
    ping went from intermittent to 100%.

**Step 1.4 DETECT HIDDEN BUG FIXES**
- Record: Not hidden. This is an explicit hardware quirk for a real
  connectivity failure.

## PHASE 2: DIFF ANALYSIS

**Step 2.1 INVENTORY THE CHANGES**
- Record:
  - File: `drivers/net/usb/cdc_ether.c` only (~+16 lines, 0 removed)
  - Adds `ami_bmc_info` (clone of `cdc_info` plus `FLAG_LINK_INTR`)
  - Adds `USB_DEVICE_AND_INTERFACE_INFO(0x046b, 0xffb0, ...)` **before**
    the generic CDC Ethernet catch-all
  - Scope: single-file surgical quirk / device ID

**Step 2.2 UNDERSTAND THE CODE FLOW CHANGE**
- Record:
  - **Before:** `046b:ffb0` matches `USB_INTERFACE_INFO(...,
    USB_CDC_SUBCLASS_ETHERNET, ...)` → `cdc_info` (`FLAG_ETHER |
    FLAG_POINTTOPOINT`, no `FLAG_LINK_INTR`). Carrier starts ON. Stale
    OFF is a state change.
  - **After:** Same bind/status/unbind/filter/power callbacks, plus
    `FLAG_LINK_INTR`. `usbnet_probe()` calls `usbnet_link_change(dev, 0,
    0)` → `netif_carrier_off()`. Stale OFF matches current state and is
    ignored.

**Step 2.3 IDENTIFY THE BUG MECHANISM**
- Record: **Hardware workaround / logic correctness.** Stale firmware
  notifications plus default carrier-ON cause a false link-down that
  tears down RX URBs and drops in-flight frames (ARP).

**Step 2.4 ASSESS THE FIX QUALITY**
- Record: Minimal and obviously correct. `FLAG_LINK_INTR` is the
  established usbnet pattern (asix, smsc, dm9601, cdc_ncm, …).
  Restricted to one VID/PID. Regression risk is confined to `046b:ffb0`:
  initial carrier is OFF until the first ON notification. Author
  captured that ON always follows. No public API / data-structure
  change.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 BLAME THE CHANGED LINES**
- Record:
  - Generic `cdc_info` has existed since early usbnet.
  - `FLAG_LINK_INTR` added in `37e8273cd3059` (“usbnet: Set link down
    initially for drivers that update link state”, 2009).
  - Global FLAG on `cdc_ether` was removed in `71cc1fa9f2d71` (2010)
    because CDC Ethernet notifications are optional; devices that never
    send them stayed DOWN (`bugzilla.kernel.org/14791`). That is why
    this must be device-specific.
  - Carrier comparison in `usbnet_cdc_status()` added by `2d5c9dd2cde33`
    (“net: usb: cdc_ether: don't spew notifications”, 2024-08-08). That
    check is what lets a redundant OFF be dropped. Confirmed ancestor of
    HEAD.

**Step 3.2 FOLLOW THE FIXES: TAG**
- Record: No `Fixes:` tag. Not applicable. The interaction is long-
  standing default carrier-ON plus this BMC’s cold-boot notifications.

**Step 3.3 CHECK FILE HISTORY**
- Record: Recent `cdc_ether.c` history is other device IDs/quirks
  (`zte_cdc_info`, Cinterion WWAN IDs, ThinkPad dock). Same pattern.
  Standalone, not `patch X/Y`.

**Step 3.4 CHECK THE AUTHOR'S OTHER COMMITS**
- Record: `git log --author="Jinhui Guo" -- drivers/net/usb/` is empty
  in this tree. Author is not the subsystem maintainer. Applied by Jakub
  Kicinski. USB net maintainers were on To/Cc (Oliver Neukum, netdev).

**Step 3.5 CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
- Record: Can apply standalone. This tree already has:
  - `FLAG_LINK_INTR` and `usbnet_probe()` handling
  - `usbnet_cdc_status()` carrier filter (`2d5c9dd2cde33`)
  - `usbnet_cdc_bind` / `unbind` / `usbnet_cdc_update_filter` /
    `usbnet_manage_power`
  - Products table with the same Cinterion-then-catch-all context

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 FIND THE ORIGINAL PATCH DISCUSSION**
- Record:
  - `b4 dig -c 46651395...` failed (SHA not in this repo).
  - Lore WebFetch returned 403 (Anubis bot-check).
  - Openwall/Patchew/LKML recovered the thread:
    - https://lists.openwall.net/linux-kernel/2026/07/30/380 (v1,
      standalone `[PATCH]`)
    - https://lists.openwall.net/linux-kernel/2026/07/30/387 (author
      follow-up with usbmon + xHCI evidence)
  - Single revision. No v2/v3 found. No NAK found.

**Step 4.2 CHECK WHO REVIEWED THE PATCH**
- Record: To: Oliver Neukum, Andrew Lunn, David Miller, Eric Dumazet,
  Jakub Kicinski, Paolo Abeni. Cc: linux-usb, netdev. No `Reviewed-
  by`/`Acked-by` in the recovered thread. Kicinski’s SOB is the apply
  signal. Recipients were the right maintainers.

**Step 4.3 SEARCH FOR THE BUG REPORT**
- Record: No syzbot/bugzilla. Author is the reporter, with usbmon, CDC
  status traces, and xHCI Stop Ring / `-ECONNRESET` givebacks. Failure
  is AC-cold-boot only; DC reboot preserves gadget state. 100+ cycle
  test.

**Step 4.4 CHECK FOR RELATED PATCHES AND SERIES**
- Record: Standalone 16-line patch. Author’s follow-up mentions not
  changing shared `cdc_info` because a global `FLAG_LINK_INTR` attempt
  was reverted (the 2010 revert `71cc1fa9f2d71` is in this tree; the
  cited subject string does not match that commit — likely a
  misremembered title — but the technical reason matches the 2010
  revert).

**Step 4.5 CHECK STABLE MAILING LIST HISTORY**
- Record: lore.kernel.org/stable search was blocked (403). Openwall/web
  search found no stable-specific NAK or “do not backport” discussion.
  UNVERIFIED: whether anyone already requested this on stable@.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 KEY FUNCTIONS**
- Record: No function bodies changed. New `ami_bmc_info`; new
  `products[]` entry. Runtime path: `usbnet_probe()` → `FLAG_LINK_INTR`
  → `usbnet_link_change()`; status path remains `usbnet_cdc_status()`.

**Step 5.2 TRACE CALLERS**
- Record:
  - `usbnet_probe` is `cdc_driver.probe` (USB enumeration).
  - `usbnet_cdc_status` is the interrupt completion status callback.
  - `usbnet_open` submits the interrupt URB and RX URBs
    (`EVENT_DEV_OPEN`).
  - `__handle_link_change` unlinks RX URBs if carrier is down **and**
    `EVENT_DEV_OPEN` is set.

**Step 5.3 TRACE CALLEES**
- Record: `usbnet_link_change(dev, 0, 0)` synchronously
  `netif_carrier_off()` then defers `EVENT_LINK_CHANGE`. Probe-time
  kevent is a no-op because `EVENT_DEV_OPEN` is clear
  (`__handle_link_change` returns immediately).

**Step 5.4 FOLLOW THE CALL CHAIN**
- Record: Reachable on any host with this BMC gadget and
  `CONFIG_USB_NET_CDCETHER`. After boot, NetworkManager/`ip link set up`
  opens the netdev; stale notifications then hit the status path.
  Userspace-visible: lost ARP, silent interface.

**Step 5.5 SEARCH FOR SIMILAR PATTERNS**
- Record: Same file already has `zte_cdc_info` (device-specific
  status/bind). Many usbnet drivers use `FLAG_LINK_INTR`.
  `drivers/hid/hid-ids.h` defines `USB_VENDOR_ID_AMI 0x046b`;
  `unusual_devs.h` has another AMI BMC ID `0x046b:0xff40`. Vendor ID is
  consistent.

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1 DOES THE BUGGY CODE EXIST IN THIS TREE?**
- Record: Yes. Tree is `p-6.12-2-gd38d58a4e0359`, `make kernelversion` =
  **6.12.111**.
  - `cdc_info.flags = FLAG_ETHER | FLAG_POINTTOPOINT` (no
    `FLAG_LINK_INTR`) at `cdc_ether.c:525`.
  - Catch-all `USB_INTERFACE_INFO(USB_CLASS_COMM,
    USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE)` at line 944.
  - No `0x046b` / `0xffb0` / `ami_bmc` in this driver.
  - `usbnet_cdc_status()` has the `netif_carrier_ok() !=
    !!event->wValue` filter (`2d5c9dd2cde33`).
  - `rx_complete()` drops `-ECONNRESET`/`-ESHUTDOWN` via `goto block`.
  - `usbnet_probe()` applies `FLAG_LINK_INTR` after `register_netdev()`
    (author said “before register_netdev”; in this tree it is after, but
    `netif_carrier_off()` is still synchronous and status URBs start at
    `usbnet_open`, so the quirk still works).

**Step 6.2 CHECK FOR BACKPORT COMPLICATIONS**
- Record: Clean apply expected. Surrounding `cdc_info` / Cinterion
  `0x1e2d:0x0069` / generic catch-all match the patch context. Line
  numbers differ slightly (6.12 vs later mainline); context is
  identical.

**Step 6.3 CHECK IF RELATED FIXES ARE ALREADY HERE**
- Record: No AMI BMC quirk. `2d5c9dd2cde33` is the prerequisite filter,
  already present. No alternate fix for this VID/PID.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1 IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
- Record: `drivers/net/usb/cdc_ether.c` — USB CDC Ethernet.
  **IMPORTANT** for hosts using this gadget (AMD Genoa/Turin BMC USB
  NIC), not core mm/VFS. Common on enterprise servers.

**Step 7.2 ASSESS SUBSYSTEM ACTIVITY**
- Record: Mature driver (2005). Ongoing ID/quirk additions. USB
  NETWORKING DRIVERS in MAINTAINERS is “Odd Fixes”, `drivers/net/usb/`.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 WHO IS AFFECTED**
- Record: Driver-specific / config-specific: `CONFIG_USB_NET_CDCETHER`
  and AMI BMC gadget `046b:ffb0` (AMD Genoa/Turin and similar AMI BMC
  platforms). Other CDC devices unchanged.

**Step 8.2 TRIGGER CONDITIONS**
- Record: AC cold boot; firmware queues stale OFF/ON; interface already
  open so RX URBs exist. Intermittent race with ARP DMA vs Stop Ring.
  Unprivileged users do not trigger it; it is a boot/enumeration path.
  Common on affected servers that use the BMC USB NIC.

**Step 8.3 FAILURE MODE SEVERITY**
- Record: Lost RX frames (ARP) → interface up but no L2 connectivity
  until ifdown/ifup or peer re-ARP. Not a panic. **HIGH** operational
  impact on affected hardware (host-BMC or provisioning network dead
  after cold boot).

**Step 8.4 RISK-BENEFIT RATIO**
- Record:
  - **Benefit:** High for AMI BMC USB-Ethernet users on 6.12; fixes a
    real post-boot connectivity failure.
  - **Risk:** Very low — 16 lines, one VID/PID, existing flag, no
    locking/API change.
  - **Ratio:** Strongly favors backport.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1 COMPILE THE EVIDENCE**

FOR:
- Real, reproduced connectivity bug with usbmon/xHCI evidence
- Hardware quirk + device ID on an existing driver (stable exception)
- 16-line contained change
- `FLAG_LINK_INTR` is a long-standing, well-understood usbnet mechanism
- Does not change generic `cdc_info` (avoids the 2010 permanent-DOWN
  regression)
- Prerequisite carrier filter already in 6.12
- Tested 100+ AC cold boots; netdev maintainer applied it
- Affects enterprise AMD server BMC networking

AGAINST:
- Not a crash/security issue
- No `Reviewed-by` in recovered mail (Kicinski still applied it)
- Affects one VID/PID, not all users
- Author slightly misstated probe vs `register_netdev` order (does not
  break the fix here)

UNRESOLVED:
- Could not use `b4 dig` (SHA absent) or lore.kernel.org (403)
- Could not confirm stable@ discussion
- Author’s other `71cc1fa9f2d7` subject string does not match this
  tree’s commit of that SHA (2010 revert) — rationale still holds

**Step 9.2 STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — standard flag, 100+ boot
   test, maintainer SOB
2. Fixes a real bug that affects users? **PASS** — silent NIC after AC
   cold boot
3. Important issue? **PASS** — connectivity loss / dropped RX (HIGH, not
   panic)
4. Small and contained? **PASS** — +16 lines, one file, one VID/PID
5. No new features or APIs? **PASS** — quirk/ID only
6. Can apply to the local tree? **PASS** — code and prerequisites
   present; clean context

**Step 9.3 EXCEPTION CATEGORIES**
- Record: **Hardware quirk/workaround** and **device ID addition to an
  existing driver**.

**Step 9.4 DECISION**
This should be backported to this 6.12 tree. It is a small, device-
scoped quirk that fixes a real post-boot network failure on AMI BMC USB-
Ethernet, using infrastructure that already exists here.

### What the commit solves
On AMD Genoa/Turin, the AMI BMC USB CDC gadget emits a stale link-OFF
then link-ON right after cold-boot enumeration. Because CDC Ethernet
starts with carrier on, that OFF is treated as a real link-down, RX URBs
are unlinked, and in-flight ARP is dropped. The interface stays up but
silent. Starting carrier off for this VID/PID only makes the stale OFF a
no-op.

### Risk vs benefit
Benefit is restoring first-packet connectivity after AC cold boot on
affected servers. Risk is limited to `046b:ffb0` and is the intended
`FLAG_LINK_INTR` behavior.

### Concerns
None material for 6.12. Apply should be clean. Do not change generic
`cdc_info`.

### Verification
- [Phase 1] Parsed tags: author SOB, msgid Link, Kicinski SOB; no
  Fixes/Cc-stable/Reported-by
- [Phase 2] Diff: +16 lines in `cdc_ether.c`; `ami_bmc_info` with
  `FLAG_LINK_INTR`; ID `0x046b:0xffb0` before catch-all
- [Phase 3] `git describe HEAD` / `make kernelversion`:
  `p-6.12-2-gd38d58a4e0359`, **6.12.111**
- [Phase 3] `git merge-base --is-ancestor 46651395… HEAD`: commit not in
  this repo
- [Phase 3] `git merge-base --is-ancestor 2d5c9dd2cde33 HEAD`: yes
  (carrier filter present)
- [Phase 3] `git show 71cc1fa9f2d71`: 2010 partial revert removing
  `FLAG_LINK_INTR` from `cdc_info`
- [Phase 3] `git blame` `usbnet_cdc_status`: carrier check from
  `2d5c9dd2cde33`
- [Phase 3] `git log --oneline -20 -- drivers/net/usb/cdc_ether.c`:
  ID/quirk history; no AMI entry
- [Phase 3] `git log --author="Jinhui Guo" -- drivers/net/usb/`: empty
  in this tree
- [Phase 4] `b4 dig -c <sha>`: no match (SHA not local)
- [Phase 4] lore WebFetch: 403; used Openwall + Patchew instead
- [Phase 4] Author follow-up: usbmon OFF/ON ~130µs, xHCI `-ECONNRESET`
  length 1514, AC vs DC explanation
- [Phase 4] No NAK found; no v2 found
- [Phase 5] `usbnet_probe` FLAG_LINK_INTR →
  `usbnet_link_change(dev,0,0)` after `register_netdev` (lines
  1861–1877)
- [Phase 5] `__handle_link_change` returns if `!EVENT_DEV_OPEN`; else
  `unlink_urbs` when carrier down
- [Phase 5] `rx_complete` `-ECONNRESET`/`-ESHUTDOWN` → `goto block`
- [Phase 5] `usbnet_open` starts interrupt URB then sets
  `EVENT_DEV_OPEN`
- [Phase 6] No `ami_bmc`/`0x046b`/`0xffb0` in `cdc_ether.c`; catch-all
  still binds this device to `cdc_info`
- [Phase 6] `FLAG_LINK_INTR` defined in `include/linux/usb/usbnet.h:122`
- [Phase 6] `USB_DEVICE_AND_INTERFACE_INFO` exists in
  `include/linux/usb.h`
- [Phase 6] `CONFIG_USB_NET_CDCETHER` builds `cdc_ether.o`
- [Phase 7] HID confirms `USB_VENDOR_ID_AMI 0x046b`
- [Phase 8] Failure mode: dropped RX/ARP, silent interface — HIGH for
  this hardware
- UNVERIFIED: stable@ discussion (lore 403); exact mainline SHA not in
  this checkout

The patch is a textbook stable quirk: small, obviously correct, already
tested, and the buggy code is in this tree.

**YES**

 drivers/net/usb/cdc_ether.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index a032c1ded4063..05e625a461b49 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -532,6 +532,16 @@ static const struct driver_info	cdc_info = {
 	.manage_power =	usbnet_manage_power,
 };
 
+static const struct driver_info ami_bmc_info = {
+	.description =	"AMI BMC USB Ethernet",
+	.flags =	FLAG_ETHER | FLAG_POINTTOPOINT | FLAG_LINK_INTR,
+	.bind =		usbnet_cdc_bind,
+	.unbind =	usbnet_cdc_unbind,
+	.status =	usbnet_cdc_status,
+	.set_rx_mode =	usbnet_cdc_update_filter,
+	.manage_power =	usbnet_manage_power,
+};
+
 static const struct driver_info	zte_cdc_info = {
 	.description =	"ZTE CDC Ethernet Device",
 	.flags =	FLAG_ETHER | FLAG_POINTTOPOINT,
@@ -940,6 +950,12 @@ static const struct usb_device_id	products[] = {
 				      USB_CDC_SUBCLASS_ETHERNET,
 				      USB_CDC_PROTO_NONE),
 	.driver_info = (unsigned long)&wwan_info,
+}, {
+	/* AMI BMC gadget */
+	USB_DEVICE_AND_INTERFACE_INFO(0x046b, 0xffb0, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET,
+				      USB_CDC_PROTO_NONE),
+	.driver_info = (unsigned long)&ami_bmc_info,
 }, {
 	USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_ETHERNET,
 			USB_CDC_PROTO_NONE),
-- 
2.53.0

