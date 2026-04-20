Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459133A1D1C;
	Mon, 20 Apr 2026 13:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776690947; cv=none; b=oefPBOnj1kXnXtZ45aZCGy3BV+YbBFo26U3FhIBFUvzJ78vanhjKeZqJeVRT6vT8NwmwWHtMiwLJ7N0y+2qPXCnVYdh8maEPAGzUTpFGqZMbhdn0O/te6wxVOdbsk2yvWVoHLK1Y5zaawbqJ4BupM/iQQwJ9yMAY/xvTDSJoqR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776690947; c=relaxed/simple;
	bh=I08iWKfEmQEfJeKYRN2XAeadK5RKPg3wszDX3YiYvm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qh2qMKAjwXI0BSCeDJnKfTPlB3hYWuCBuJ+N+amk3mlwr73+pSdvfgjr3O6+E2TbSsyDCgDQvsBZFmndVBhZp7axrf4hemBOBP7qYHq6KtF7rcZJ4HWdDZWmXngvO8Es5AUp4hdmVkbRK04F83WvDi/alH93SAet0xBgbwLnJAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZmdlfF+C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZmdlfF+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB3FC2BCB4;
	Mon, 20 Apr 2026 13:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776690946;
	bh=I08iWKfEmQEfJeKYRN2XAeadK5RKPg3wszDX3YiYvm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZmdlfF+Ci1U9mwNN4q+RYzhLEf5/MQLYotGwJLvC/tN5203rcTYw1ulYjGocmaX7l
	 C45W/BBxLNzNwjFhFPRDVPjZw7TiuQ9/Evnd8dBt7cSkaBOww0FycqCA061niCZgmd
	 RhkRW3nxBVPooX3ueViVg4gQB1r5jsrHvBIhO/y9Y1mYwiOWuhkeHJvKpwnyRZ089X
	 H1hs/IPGK4TZv4ptWNK3oN4RfmA4WaUqT9aFtLdvuh3OToTHBauGIwACjVSlYpngVh
	 TDbauE1PnLc5rK52ccGZQBuvV/u6E8WYz49FCeQcn4BUv9hMaxbNmU0cf3lgRo+mog
	 sH7SFP7EKvIaQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ahmed Naseef <naseefkm@gmail.com>,
	Bjorn Helgaas <helgaas@kernel.org>,
	Caleb James DeLisle <cjd@cjdns.fr>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.6] PCI: Prevent assignment to unsupported bridge windows
Date: Mon, 20 Apr 2026 09:07:50 -0400
Message-ID: <20260420131539.986432-4-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Transfer-Encoding: 8bit

From: Ahmed Naseef <naseefkm@gmail.com>

[ Upstream commit 92427ab4378faa168d6953d0f8574b8fc1edcc14 ]

Previously, pci_read_bridge_io() and pci_read_bridge_mmio_pref()
unconditionally set resource type flags (IORESOURCE_IO or IORESOURCE_MEM |
IORESOURCE_PREFETCH) when reading bridge window registers. For windows that
are not implemented in hardware, this may cause the allocator to assign
space for a window that doesn't exist.

For example, the EcoNET EN7528 SoC Root Port doesn't support the
prefetchable window, but since a downstream device had a prefetchable BAR,
the allocator mistakenly assigned a prefetchable window:

  pci 0001:00:01.0: [14c3:0811] type 01 class 0x060400 PCIe Root Port
  pci 0001:00:01.0: PCI bridge to [bus 01-ff]
  pci 0001:00:01.0: bridge window [mem 0x28000000-0x280fffff]: assigned
  pci 0001:00:01.0: bridge window [mem 0x28100000-0x282fffff pref]: assigned
  pci 0001:01:00.0: BAR 0 [mem 0x28100000-0x281fffff 64bit pref]: assigned

pci_read_bridge_windows() already detects unsupported windows by testing
register writability and sets dev->io_window/pref_window accordingly.

Check dev->io_window/pref_window so we don't set the resource flags for
unsupported windows, which prevents the allocator from assigning space to
them.

After this commit, the prefetchable BAR is correctly allocated from the
non-prefetchable window:

  pci 0001:00:01.0: bridge window [mem 0x28000000-0x281fffff]: assigned
  pci 0001:01:00.0: BAR 0 [mem 0x28000000-0x280fffff 64bit pref]: assigned

Suggested-by: Bjorn Helgaas <helgaas@kernel.org>
Link: https://lore.kernel.org/all/20260113210259.GA715789@bhelgaas/
Signed-off-by: Ahmed Naseef <naseefkm@gmail.com>
Signed-off-by: Caleb James DeLisle <cjd@cjdns.fr>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260312165332.569772-4-cjd@cjdns.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture. Let me compile the full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject line.**
Record: [PCI] [Prevent] Prevents resource allocator from assigning space
to unsupported bridge windows (IO and prefetchable memory).

**Step 1.2: Tags.**
- Suggested-by: Bjorn Helgaas (PCI maintainer suggested the fix
  approach)
- Link: https://lore.kernel.org/all/20260113210259.GA715789@bhelgaas/
  (original suggestion)
- Signed-off-by: Ahmed Naseef (original author of the fix)
- Signed-off-by: Caleb James DeLisle (series author)
- Signed-off-by: Bjorn Helgaas (PCI maintainer committed it)
- Link: https://patch.msgid.link/20260312165332.569772-4-cjd@cjdns.fr
  (patch submission)
- No Fixes: tag (expected for review candidates)
- No Cc: stable (expected)

**Step 1.3: Body analysis.**
The commit describes that `pci_read_bridge_io()` and
`pci_read_bridge_mmio_pref()` unconditionally set resource type flags
when reading bridge window registers. For hardware-unsupported windows
(registers hardwired to 0), both base and limit read as 0, and since `0
<= 0` is true, a bogus window is created. The allocator then assigns
space to a non-existent window. The concrete example is the EcoNET
EN7528 SoC root port, which doesn't support prefetchable windows,
causing a WiFi device (mt7615e) to be placed in a non-existent window
and fail.

**Step 1.4: Hidden bug fix?**
This is an explicit bug fix. The word "Prevent" in the subject indicates
fixing incorrect behavior. The commit clearly describes a failure mode
where devices become non-functional.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory.**
- 1 file changed: `drivers/pci/probe.c`
- +6 lines, 0 lines removed
- Functions modified: `pci_read_bridge_io()`,
  `pci_read_bridge_mmio_pref()`
- Scope: single-file, very surgical fix

**Step 2.2: Code flow change.**
Two early returns are added:
1. `pci_read_bridge_io()`: If `!dev->io_window`, return immediately
   before reading any IO window registers or setting any resource flags.
2. `pci_read_bridge_mmio_pref()`: If `!dev->pref_window`, return
   immediately before reading any prefetchable window registers or
   setting any resource flags.

**Step 2.3: Bug mechanism.**
This is a **logic/correctness fix**. The bug is that
`pci_read_bridge_bases()` calls these functions unconditionally for ALL
bridges, even those where `pci_read_bridge_windows()` has already
determined the window is unsupported. When registers are hardwired to 0,
`base == limit == 0`, and `0 <= 0` creates a bogus resource.

**Step 2.4: Fix quality.**
The fix is obviously correct. The `io_window` and `pref_window` flags
are already set correctly by `pci_read_bridge_windows()` during
enumeration and are already used by `pci_bridge_check_ranges()` in
setup-bus.c. This fix simply extends the same guard to
`pci_read_bridge_bases()`. Zero regression risk -- if the window IS
supported, `io_window`/`pref_window` is set to 1 and the early return is
not taken.

## PHASE 3: GIT HISTORY

**Step 3.1: Blame.**
The affected functions have been in the kernel since Linus's initial
tree commit (v2.6.12, 2005). The `io_window` and `pref_window` fields
were added in commit `51c48b310183a` (v5.1) by Bjorn Helgaas. This means
the infrastructure to detect unsupported windows existed since v5.1, but
the detection was never used in `pci_read_bridge_bases()`.

**Step 3.2:** No Fixes: tag (expected).

**Step 3.3:** Recent changes to probe.c include `8278c6914306f` ("PCI:
Preserve bridge window resource type flags") which changed flag behavior
but is independent of this fix.

**Step 3.4:** Caleb James DeLisle is a new contributor adding EN7528
support. Ahmed Naseef authored this particular fix. Bjorn Helgaas (PCI
maintainer) suggested and signed off on the fix.

**Step 3.5:** The fix has no prerequisites. It uses `dev->io_window` and
`dev->pref_window` which have been present since v5.1.

## PHASE 4: MAILING LIST

The mbox file (7 messages) reveals a thorough review by Bjorn Helgaas.
He initially couldn't reproduce the bug (because his test device had
non-prefetchable BARs), but Ahmed Naseef provided a detailed config
access trace showing:
1. `pci_read_bridge_windows()` correctly detects pref_window = 0
2. Later, `pci_read_bridge_bases()` reads the same registers without
   checking, creates bogus resource
3. Allocator assigns prefetchable window to bridge that doesn't have one
4. WiFi device (mt7615e with prefetchable BARs) is placed in the bogus
   window and fails

Bjorn was satisfied with the explanation and committed the patch with
his own Signed-off-by. This is patch 3/3 of a series, but it's
completely self-contained in PCI core.

## PHASE 5: CODE SEMANTIC ANALYSIS

`pci_read_bridge_io()` and `pci_read_bridge_mmio_pref()` are called from
two sites:
1. `pci_read_bridge_windows()` -- already guards with
   `io_window`/`pref_window`; the early returns are redundant here but
   harmless
2. `pci_read_bridge_bases()` -- calls unconditionally, **this is where
   the bug manifests**

`pci_read_bridge_bases()` is called from `pci_bus_allocate_resources()`
in setup-bus.c for every PCI bridge during bus allocation. This is a
core enumeration path that runs on every system with PCI bridges.

## PHASE 6: STABLE TREE ANALYSIS

The buggy code (`pci_read_bridge_bases()` calling these functions
unconditionally) has existed since Linux 2.6.12. The
`io_window`/`pref_window` infrastructure was added in v5.1, so the fix
is applicable to all active stable trees (5.4.y through 6.12.y).

The fix may need minor context adjustment for kernels before v6.8 (where
`63c6ebb294b7c` changed function signatures), but the actual fix logic
(two early returns) is identical.

## PHASE 7: SUBSYSTEM AND CRITICALITY

PCI core (`drivers/pci/probe.c`) is CORE infrastructure used by all PCI
systems. The bug specifically affects embedded SoCs with limited bridge
window support, making it IMPORTANT for ARM/MIPS embedded users.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Who is affected:** Users of any platform with PCI bridges that lack IO
or prefetchable window support. This primarily includes embedded SoCs
(ARM, MIPS). The known affected device is EcoNET EN7528.

**Trigger conditions:** Automatic during PCI enumeration when a
downstream device has prefetchable BARs behind a bridge without
prefetchable window support. No user action needed.

**Failure mode:** Device non-functional (BARs placed in non-existent
window). Severity: HIGH -- the device completely fails to work (mt7615e
WiFi shows "Firmware is not ready for download").

**Risk-benefit ratio:** Benefit is HIGH (fixes device failure). Risk is
VERY LOW (6 lines, two early returns using already-tested flags, zero
side effects when windows ARE supported).

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR backporting:**
- Real bug fix that makes PCI devices completely non-functional on
  affected hardware
- Minimal fix: 6 lines added, 0 removed
- Obviously correct: uses existing `io_window`/`pref_window` flags
  already tested elsewhere
- PCI maintainer (Bjorn Helgaas) suggested, reviewed, and committed the
  fix
- Affects PCI core code present in all stable trees since v5.1
- Bug exists in all kernel versions since 2005 (base == limit == 0 case)
- The affected code path (`pci_read_bridge_bases()`) runs during normal
  PCI enumeration

**Evidence AGAINST backporting:**
- The only known affected hardware (EN7528) is new and not in stable
  trees
- No other hardware has reported this bug (though other embedded SoCs
  could be affected)
- This is patch 3/3 of a series (but is self-contained in PCI core)

**Stable rules checklist:**
1. Obviously correct? YES -- uses existing flags, minimal change
2. Fixes real bug? YES -- devices fail behind bridges without pref
   windows
3. Important issue? YES -- device non-functional
4. Small and contained? YES -- 6 lines in 1 file
5. No new features? CORRECT -- no new features
6. Can apply to stable? YES -- may need minor context adjustment for
   older trees

## Verification

- [Phase 1] Parsed tags: Suggested-by Bjorn Helgaas, two Signed-off-bys,
  two Links
- [Phase 2] Diff analysis: +6 lines in `pci_read_bridge_io()` and
  `pci_read_bridge_mmio_pref()`, adds early return when window not
  supported
- [Phase 3] git blame: buggy unconditional calls exist since v2.6.12;
  `io_window`/`pref_window` added in 51c48b310183a (v5.1)
- [Phase 3] git describe: 51c48b310183a first appeared in v5.1-rc1
- [Phase 3] `pci_bridge_check_ranges()` already correctly checks these
  flags, confirming the fix pattern is established
- [Phase 4] b4 mbox retrieved 7-message thread; Bjorn Helgaas reviewed,
  requested config trace, was satisfied, committed
- [Phase 4] Ahmed Naseef provided detailed config access trace proving
  the exact bug mechanism
- [Phase 4] Series is 3 patches (DT bindings, driver, core fix); patch
  3/3 is self-contained in PCI core
- [Phase 5] `pci_read_bridge_bases()` called from
  `pci_bus_allocate_resources()` -- standard PCI enumeration path
- [Phase 5] Two call sites for affected functions: one already guarded
  (pci_read_bridge_windows), one not (pci_read_bridge_bases)
- [Phase 6] `io_window`/`pref_window` present in all active stable trees
  (v5.1+)
- [Phase 6] Commit 8278c6914306f is independent; fix works on code both
  before and after it
- [Phase 8] Failure mode: device completely non-functional when BAR
  assigned to non-existent bridge window
- UNVERIFIED: Whether other production platforms besides EN7528 are
  affected in practice (likely given many embedded SoCs have limited
  bridge support)

**YES**

 drivers/pci/probe.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index bccc7a4bdd794..4eacb741b4ec1 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -395,6 +395,9 @@ static void pci_read_bridge_io(struct pci_dev *dev, struct resource *res,
 	unsigned long io_mask, io_granularity, base, limit;
 	struct pci_bus_region region;
 
+	if (!dev->io_window)
+		return;
+
 	io_mask = PCI_IO_RANGE_MASK;
 	io_granularity = 0x1000;
 	if (dev->io_window_1k) {
@@ -465,6 +468,9 @@ static void pci_read_bridge_mmio_pref(struct pci_dev *dev, struct resource *res,
 	pci_bus_addr_t base, limit;
 	struct pci_bus_region region;
 
+	if (!dev->pref_window)
+		return;
+
 	pci_read_config_word(dev, PCI_PREF_MEMORY_BASE, &mem_base_lo);
 	pci_read_config_word(dev, PCI_PREF_MEMORY_LIMIT, &mem_limit_lo);
 	base64 = (mem_base_lo & PCI_PREF_RANGE_MASK) << 16;
-- 
2.53.0

