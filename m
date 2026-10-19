Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8968F60DC99;
	Mon, 19 Oct 2026 14:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418620; cv=none; b=LXqiZim7KNFByL3HTXrCm41W7Ows/cr/71nZ9xyk2Qof+aZwaXFhLjfeZX7BDkGb1mmYC84do0XMxu6rrNWHfQB/SzsQqPa6cRWU5rzvxiH6W5v086zNgY+qJobF5kgopPLbFA+eRdIHVN/nlJuF9DINIx8a2CeclWBOJ6W7BAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418620; c=relaxed/simple;
	bh=KpLOk1av7k0zl2CaSVlymrcTVVvV5iQVAccJkWH5yvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q23yLtbDHUyEXfE209hc2tEj6s1tPmaFWPvuPKhwh447gVq19eguo5rGbQLrmjFjOE8tUd2oiNo+08Ykf2Q9YtUnAml6yRuWpVq+Wy1lzIOIZKqAm3pgTMVVT2ayjJO7dWR6Sc7KyHoyZsFBBvHC1OMU3NSqJwwMmNJ4EDLwUIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YI04yy6y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YI04yy6y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82821F000C7;
	Mon, 19 Oct 2026 14:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418617;
	bh=mnaL5otcCVmLncN82I/gGeIqDFm//zYq1IbI5vD0Ao0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YI04yy6yhXO+H71HjdlCIHL53qwbiruQkwll4YvvStAFaa1tY+aLF2zSS0ZUVdt2S
	 /0SaW5RlUQ62b6Y0PK8a/yza2uJ0FzmhdzetBfsNxwftkajWhFSG9U/PVqTUKoxZfw
	 J9Q3b/otzZ53Dog6clNGwQbZrepUO+gAQOWr3bmp6ShoMACZCJe16/vP2d1p+lVj0d
	 WnJrwv++QhoAC/lHbkgpRRIkwAWnysJXQ4AXDl06hsQG3pLt8enGK1rxAETjJ0yY2G
	 5Mta/XzwctEXM5jrGBwGbDt5O9PrAKhUq6qNqip2pZguU1ryPLUOgIJ4WGgMBTvDft
	 7EKZeEimiTRDA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Andrea della Porta <andrea.porta@suse.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] misc: rp1: clear chained IRQ handlers on teardown
Date: Mon, 19 Oct 2026 09:51:07 -0400
Message-ID: <20261019135441.1420968-376-sashal@kernel.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 82aa033fef523ab4f0165afbc1c1fb0dadb89f94 ]

rp1_probe() installs a chained handler for each parent MSI-X vector and
stores the rp1 device pointer as handler data. rp1_unregister_interrupts()
then disposes the child IRQ mappings, removes the IRQ domain, and frees
the PCI IRQ vectors without first removing those chained handlers.

If a teardown path runs after the handlers have been installed, a later
parent IRQ can still call rp1_chained_handle_irq() with stale handler
data and a removed IRQ domain. Clear the chained handlers before
disposing mappings and freeing the vectors.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Andrea della Porta <andrea.porta@suse.com>
Link: https://patch.msgid.link/20260616151028.69890-1-pengpeng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a 3-line IRQ teardown UAF fix in the Raspberry Pi 5 RP1 driver.
The local tree is **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). The RP1
driver exists here (since v6.17), and the buggy teardown path is the
original driver code.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[misc: rp1:] [clear] [chained IRQ handlers on teardown]**
- Subsystem: `misc: rp1` (Raspberry Pi RP1 PCI misc driver)
- Verb: “clear” — teardown/cleanup of leftover IRQ state, not a feature
  add

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Fixes:** none (expected for this review)
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** Andrea della Porta `<andrea.porta@suse.com>` (RP1
  maintainer per MAINTAINERS)
- **Acked-by:** none
- **Link:**
  `https://patch.msgid.link/20260616151028.69890-1-pengpeng@iscas.ac.cn`
- **Cc: stable:** none (expected; not a negative)
- **Signed-off-by:** Pengpeng Hou (author); Greg Kroah-Hartman (char-
  misc)
- Ignore pipeline SOBs (none present on this commit)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `rp1_probe()` installs chained handlers on parent MSI-X
  vectors with `rp1` as handler data. `rp1_unregister_interrupts()`
  disposes mappings, removes the IRQ domain, and frees PCI vectors
  without uninstalling those handlers.
- **Failure mode:** A later parent IRQ can still call
  `rp1_chained_handle_irq()` with stale handler data and a removed IRQ
  domain → use-after-free / invalid `irq_find_mapping()` / crash.
- **Version info:** none in the message. Driver introduced in
  `49d63971f9634` (first in v6.17). Fix landed in v7.3-rc1.
- **Root cause:** missing `irq_set_chained_handler_and_data(..., NULL,
  NULL)` before domain teardown / `pci_free_irq_vectors()`.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. It is an explicit teardown bug fix
(stale chained IRQ handler). Same class as many irqchip/PCI host drivers
that clear chained handlers on remove.

===============================================================
PHASE 2: DIFF ANALYSIS
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/misc/rp1/rp1_pci.c` — **+3 / -0**
- Function: `rp1_unregister_interrupts()`
- Scope: single-file, surgical

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record: Before: unregister disposed child mappings,
`irq_domain_remove()`, then `pci_free_irq_vectors()`, leaving parent
MSI-X vectors still pointing at `rp1_chained_handle_irq` + `rp1`. After:
those chained handlers/data are cleared first, then
mappings/domain/vectors are torn down.

Callers of unregister (verified in this tree):
- `rp1_probe()` error path `err_unregister_interrupts` (domain create
  fail, mid-loop mapping fail, `of_platform_default_populate` fail)
- `rp1_remove()` after `of_platform_depopulate()`

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Memory safety / UAF + stale IRQ dispatch**
- `rp1_chained_handle_irq()` does `irq_desc_get_handler_data(desc)` then
  `irq_find_mapping(rp1->domain, hwirq)`.
- After `irq_domain_remove()` that domain is gone; after unbind, `rp1`
  is `devm_kzalloc` memory that will be freed.
- Mechanism of the fix: standard `irq_set_chained_handler_and_data(irq,
  NULL, NULL)` uninstall (kernel converts NULL → `handle_bad_irq`,
  masks, drops chained action). Verified in `kernel/irq/chip.c`.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct and the established pattern (many drivers do
the same: pcie-mediatek, gpio-rockchip, irq-lan966x-oic, etc.). Minimal,
no API change.
Regression risk: **low**. Clearing handlers that were never installed
(domain-create failure before the install loop) is the same pattern
other drivers use. `irq_chip_pm_put()` on uninstall is a no-op when
`irq_get_pm_device()` is NULL, which is typical for these MSI-X vectors.
`pci_alloc_irq_vectors` failure already goes to `err_out`, not
unregister, so `pci_irq_vector()` is only used after vectors exist.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: Buggy `rp1_unregister_interrupts()` (and the chained-handler
install loop) came from **`49d63971f9634`** (“misc: rp1: RaspberryPi RP1
misc driver”, Andrea della Porta, 2025-05-29). First contained in
**v6.17**. Long-lived relative to 7.3; not last-month code.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag. Introduced-by is the original driver commit
above. `git merge-base --is-ancestor 49d63971f9634 HEAD` is true in this
tree.

**Step 3.3: CHECK FILE HISTORY**
Record: File history is small (8 commits). Related later commits
(`0764fd10406f3` OF-node put, `d7f0b6a15dde2` irq_domain_create_linear)
are independent, not prerequisites of this 3-line change. Standalone,
not “patch X/Y”.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Pengpeng Hou is a contributor, not the RP1 maintainer. Same-area
follow-up: `0764fd10406f3` (separate OF refcount bug). Weight comes from
**Reviewed-by Andrea della Porta** (listed maintainer) and Greg KH
applying it.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Uses `irq_set_chained_handler_and_data` and `pci_irq_vector`,
both long-standing. Applies standalone. No series.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 82aa033fef523` →
  https://patch.msgid.link/20260616151028.69890-1-pengpeng@iscas.ac.cn
- `b4 dig -a`: **v1 only**, no later revisions
- Thread (saved mbox): Andrea della Porta replied with **Reviewed-by**
  only. No NAK, no stable tag request, no risk flags.
- lore WebFetch returned 403; discussion recovered via `b4 dig -m`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc included Andrea della Porta, Arnd Bergmann,
Greg Kroah-Hartman, linux-kernel. Maintainer reviewed; Greg merged via
char-misc.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla/Reported-by. Bug is from code inspection of
the probe/remove teardown path. Still a real reachable path (probe error
after handler install, and `rp1_remove`).

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone v1. Not part of a multi-patch series.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable WebFetch returned 403. **UNVERIFIED**
whether stable@ already discussed this; no local `git log --grep` hit
besides the commit itself.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: KEY FUNCTIONS**
Record: Modified: `rp1_unregister_interrupts()`. Related:
`rp1_chained_handle_irq()`, `rp1_probe()`, `rp1_remove()`.

**Step 5.2: TRACE CALLERS**
Record:
- `rp1_probe()` → `err_unregister_interrupts` (device enumeration / PCI
  probe; error after IRQ setup)
- `rp1_remove()` (module unload / PCI unbind)
Impact surface is this driver only. `CONFIG_MISC_RP1` on Raspberry Pi 5.

**Step 5.3: TRACE CALLEES**
Record: `pci_get_drvdata`, `irq_set_chained_handler_and_data`,
`pci_irq_vector`, `irq_find_mapping`, `irq_dispose_mapping`,
`irq_domain_remove`, `pci_free_irq_vectors`. No new locks/allocs.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Reachable from PCI probe and driver remove. Not a syscall hot
path. Root/module unload or probe failure after MSI-X setup can trigger
it. `rp1_chained_handle_irq` is hardirq/chained context — a stale call
is an oops, not a recoverable error.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Clearing chained handlers with `(irq, NULL, NULL)` is widespread
(PCI hosts, GPIO, irqchip). RP1 was missing that standard teardown.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** `drivers/misc/rp1/rp1_pci.c` is present. Install of
chained handlers is still at probe lines 263–264. The missing-clear bug
was in this file from `49d63971f9634` (v6.17). This checkout already
contains the fix (`82aa033fef523` is an ancestor of HEAD; first in
**v7.3-rc1**). That is the mainline landing, not a reason to treat the
bug as imaginary.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply** to this tree’s RP1 file. Hunk is isolated in
`rp1_unregister_interrupts()`. Later `irq_domain_create_linear()` switch
does not conflict. Unregister body before the fix matches the posted
diff.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This exact fix is already in this 7.3-rc4 checkout (mainline).
No alternate/competing fix. Later OF-node and irq_domain commits do not
supersede it.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: SUBSYSTEM AND CRITICALITY**
Record: **drivers/misc/rp1** — RP1 PCI bridge on Raspberry Pi 5
(Ethernet, USB, I2C, SPI, UART). **IMPORTANT** (popular board, not core
mm/net), not staging.

**Step 7.2: SUBSYSTEM ACTIVITY**
Record: Mature-enough but still receiving correctness fixes. Maintainer:
Andrea della Porta. Reviewed this patch.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: WHO IS AFFECTED**
Record: **Driver-specific / config-specific:** `CONFIG_MISC_RP1`,
Raspberry Pi 5 (and any board with RP1 PCI ID `PCI_VENDOR_ID_RPI` /
`PCI_DEVICE_ID_RPI_RP1_C0`).

**Step 8.2: TRIGGER CONDITIONS**
Record:
- Probe failure after chained handlers are installed (mapping fail mid-
  loop, DT populate fail)
- Device remove / module unload / PCI unbind after successful probe
Not every boot. Not unprivileged-userspace-triggerable in the usual
config (needs probe fail or admin unbind). Timing: any parent MSI-X
after domain removal.

**Step 8.3: FAILURE MODE SEVERITY**
Record: Stale chained handler → `rp1_chained_handle_irq()` on removed
domain / freed `rp1` → **oops / UAF**. Severity: **HIGH** (crash; UAF is
also a memory-safety issue).

**Step 8.4: RISK-BENEFIT RATIO**
Record:
- Benefit: **high** for RP1/Pi 5 users (prevents IRQ oops/UAF on failed
  probe and unbind)
- Risk: **very low** (3 lines, standard API, maintainer-reviewed)
- Ratio: strongly in favor of including the fix in trees that have this
  driver

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR backporting:
- Real bug: chained IRQ handlers left installed across domain/vector
  teardown
- Failure is oops/UAF in hardirq context, not cosmetic
- Reachable on probe error and `rp1_remove()`
- 3-line, obviously correct, matches in-tree teardown idiom
- Reviewed by the RP1 maintainer; merged by Greg KH
- Driver exists in this tree; patch applies cleanly
- Raspberry Pi 5 is a widely deployed platform

AGAINST:
- No user/syzbot report (inspection-driven)
- No Fixes:/Cc: stable (expected here; not a veto)
- Peripheral misc driver, not core kernel
- Trigger is teardown/error, not the steady-state IRQ path
- lore.kernel.org/stable search could not be fetched (403)

UNRESOLVED:
- Whether stable@ already discussed this (WebFetch 403)
- No runtime reproduction log in the thread (reviewer still acked)

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — 3-line standard uninstall;
   maintainer Reviewed-by; in mainline since 7.3-rc1
2. Fixes a real bug that affects users? **PASS** — leftover chained
   handler on RP1 unbind/probe fail
3. Important issue? **PASS** — oops/UAF, HIGH (not a hang/corruption of
   fs, but crash/memory safety)
4. Small and contained? **PASS** — +3 lines, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — file/function exist; hunk
   matches; no missing helpers

**Step 9.3: EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary small
bugfix.

**Step 9.4: DECISION**
This tree has the RP1 driver and the original teardown hole. The patch
is a minimal, correct fix for a crash/UAF on IRQ teardown. It meets
stable-kernel-rules. It should be in any tree that contains this driver
— including this 7.3 lineage.

Verification:
- [Phase 1] Parsed tags: Reviewed-by Andrea della Porta (RP1
  maintainer), Link to msgid 20260616151028.69890-1; no Fixes/Reported-
  by/Cc:stable
- [Phase 1] Body describes stale chained handler after domain/vector
  teardown
- [Phase 2] Diff: +3 lines in `rp1_unregister_interrupts()` only
- [Phase 2] Callers verified: `rp1_probe` error path line 276,
  `rp1_remove` line 286
- [Phase 2] Handler uses `irq_desc_get_handler_data` +
  `irq_find_mapping(rp1->domain, ...)` (`rp1_pci.c` 100–110)
- [Phase 2] `irq_set_chained_handler_and_data(NULL)` →
  `__irq_do_set_handler` uninstall path (`kernel/irq/chip.c` 950–988)
- [Phase 3] Blame: buggy unregister from `49d63971f9634`; driver first
  in v6.17; `git merge-base --is-ancestor 49d63971f9634 HEAD` true
- [Phase 3] No Fixes: tag; no prerequisite series; later file commits
  unrelated
- [Phase 4] `b4 dig -c 82aa033fef523`: lore URL found; `-a` shows v1
  only; `-w` lists Andrea/Arnd/Greg/lkml; mbox: Reviewed-by only, no NAK
- [Phase 4] lore WebFetch 403; stable@ search UNVERIFIED
- [Phase 5] Impact limited to MISC_RP1; chained handler in IRQ context
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` = 7.3.0-rc4; origin is torvalds/linux.git
- [Phase 6] `git merge-base --is-ancestor 82aa033fef523 HEAD` true (fix
  in v7.3-rc1); buggy install loop still present; apply would be clean
- [Phase 7] MAINTAINERS: RASPBERRY PI RP1 PCI DRIVER → Andrea della
  Porta
- [Phase 8] Failure mode: oops/UAF on parent IRQ after teardown;
  severity HIGH; risk very low
- UNVERIFIED: stable mailing-list history (HTTP 403)

The fix is small, surgical, and meets all stable kernel criteria.

**YES**

 drivers/misc/rp1/rp1_pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/misc/rp1/rp1_pci.c b/drivers/misc/rp1/rp1_pci.c
index 4d00dab48d475..847feb2cbb681 100644
--- a/drivers/misc/rp1/rp1_pci.c
+++ b/drivers/misc/rp1/rp1_pci.c
@@ -171,6 +171,9 @@ static void rp1_unregister_interrupts(struct pci_dev *pdev)
 	struct rp1_dev *rp1 = pci_get_drvdata(pdev);
 	int irq, i;
 
+	for (i = 0; i < RP1_INT_END; i++)
+		irq_set_chained_handler_and_data(pci_irq_vector(pdev, i), NULL, NULL);
+
 	if (rp1->domain) {
 		for (i = 0; i < RP1_INT_END; i++) {
 			irq = irq_find_mapping(rp1->domain, i);
-- 
2.53.0

