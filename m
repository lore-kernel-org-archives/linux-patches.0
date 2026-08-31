Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BAF510446;
	Mon, 31 Aug 2026 13:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183778; cv=none; b=cr1itFAgOOymiFyE3W76Ybs57QVz3LHHZigw7wYb5fyp4fQaLpmzdUNZRUnLs15Iy84XX0XcgCbnnqXHLRs+D6SWvdHs7GkySVpQV6C0xHTQXQDwgzVHIZbRqA9xGO2+jtVK3l83ajb8V5822J3cm3bjJGZWrWgOuLvPNaEUzns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183778; c=relaxed/simple;
	bh=ljGFZCsmgSE3jYZ3gPIaEIazQCojsNQqSd3YXNwjcpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FIHLfQWyIeKHIZtZeE9l5UvnnOBc1wqmY6/j9L/lT07M+gHyoPCsaAGWIgu0nMFxQJU5MtVSaM+zhXAGDfxCqUzZVywNaxc0s6TlekZTu0cRMxUNHfZ/ZDYZrmBvLa4xSXF80VW0nh08EuiVqZ3oVdScOe5q5bHk+T0KdkXG6yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RTH9Jxap; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RTH9Jxap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B2B1F00A3F;
	Mon, 31 Aug 2026 13:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183776;
	bh=SiyEExvIx/kl19F6wk5aTZc+Umy6csgK8vWmJEh4ays=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RTH9JxapWj5B0vLArtzR5KL9mK765akqUM5nYLpbnAv+wL7ruf7lY2jTjH11MRR7/
	 kjg14iugqD6yohTiVwrbmMmsDxgBmO3aZHZyUgLiDsn+7t3as8KVyJ0b+Koe9Y+JCN
	 ovG2dau0yWm8D25cPGIFfz7kgLRRQzY58Y5PF4OU60E0zDQmG6Kk6aJiSm/8inqoEw
	 AjcTIFbDdYn1tppg6cnQFy0TGO3um0E2uYzD3Bi7iPdrDkVslKlMOAt8VEjUi7/vef
	 FTNjDu6sPpFeNQngdduVXDriTVSega1SFBL2QRa/peca+1AQSSyQaHNDFN+tHrXjEB
	 ec7PRApKYxoHg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jiajia Liu <liujiajia@kylinos.cn>,
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
Subject: [PATCH AUTOSEL 6.18-5.10] wifi: mt76: transform aspm_conf for pci_disable_link_state
Date: Mon, 31 Aug 2026 09:25:25 -0400
Message-ID: <20260831133314.4125787-297-sashal@kernel.org>
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

From: Jiajia Liu <liujiajia@kylinos.cn>

[ Upstream commit 2dd78856223484895306351df1f903a4b75d213f ]

commit b478e162f227 ("PCI/ASPM: Consolidate link state defines") changed
PCIE_LINK_STATE_L0S (1) to (BIT(0) | BIT(1)). PCI_EXP_LNKCTL_ASPM_L0S (1)
and PCI_EXP_LNKCTL_ASPM_L1 (2) are no longer matched with
PCIE_LINK_STATE_L0S (3) and PCIE_LINK_STATE_L1 (4).

On the platform enabling ASPM L0s and L1, mt76_pci_disable_aspm is not able
to disable L1. Fix this by transforming aspm_conf to pcie link state.

Signed-off-by: Jiajia Liu <liujiajia@kylinos.cn>
Link: https://patch.msgid.link/20260602054349.42429-1-liujia6264@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[wifi: mt76]` `[transform]` — Convert PCI LNKCTL ASPM
register bits to `PCIE_LINK_STATE_*` values before calling
`pci_disable_link_state()`.

### Step 1.2: Commit Message Tags
**Record:**
- **Signed-off-by:** Jiajia Liu `<liujiajia@kylinos.cn>` (author)
- **Link:**
  https://patch.msgid.link/20260602054349.42429-1-liujia6264@gmail.com
- **Signed-off-by:** Felix Fietkau `<nbd@nbd.name>` (mt76 maintainer)
- No `Fixes:`, `Reported-by:`, `Cc: stable`, `Tested-by:`, or `Reviewed-
  by:` tags
- References upstream commit `b478e162f227` ("PCI/ASPM: Consolidate link
  state defines") as the change that broke the existing code

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** `mt76_pci_disable_aspm()` passes raw `PCI_EXP_LNKCTL`
  register bits (`aspm_conf`) directly to `pci_disable_link_state()`,
  but after `b478e162f227` the `PCIE_LINK_STATE_*` constants no longer
  match those register bit positions.
- **Symptom:** On platforms with ASPM L0s and L1 enabled, L1 cannot be
  disabled via `pci_disable_link_state()`; the function returns success
  and exits early.
- **Root cause:** `PCIE_LINK_STATE_L0S` changed from `1` to `3`
  (`BIT(0)|BIT(1)`); `PCIE_LINK_STATE_L1` changed from `2` to `4`
  (`BIT(2)`). `PCI_EXP_LNKCTL_ASPM_L0S`/`L1` remain `1`/`2`.
- **Version info:** Regression tied to `b478e162f227` (merged May 2024).

### Step 1.4: Hidden Bug Fix Detection
**Record:** Yes — despite the neutral "transform" wording, this is a
functional regression fix. The driver was written to disable ASPM
because it causes MCU hangs and WiFi instability on mt76 hardware; the
broken mapping silently leaves L1 active.

---

## Phase 2: Diff Analysis

### Step 2.1: Change Inventory
**Record:**
- **Files:** `drivers/net/wireless/mediatek/mt76/pci.c` only (+7 / -1)
- **Function modified:** `mt76_pci_disable_aspm()`
- **Scope:** Single-file surgical fix

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `pci_disable_link_state(pdev, aspm_conf)` where
  `aspm_conf` holds `PCI_EXP_LNKCTL` bits (e.g. `0x3` for L0s+L1).
- **After:** Build `state` by mapping register bits to API constants:
  - `PCI_EXP_LNKCTL_ASPM_L0S` → `PCIE_LINK_STATE_L0S`
  - `PCI_EXP_LNKCTL_ASPM_L1` → `PCIE_LINK_STATE_L1`
  - Then call `pci_disable_link_state(pdev, state)`.
- **Path affected:** Normal probe path when `CONFIG_PCIEASPM` is enabled
  and the OS has ASPM control.

### Step 2.3: Bug Mechanism
**Record:** **Logic/correctness fix — API value mismatch regression.**

When `aspm_conf = 0x3` (L0s+L1 in LNKCTL):
- Broken: `pci_disable_link_state(pdev, 0x3)` sets `link->aspm_disable
  |= 0x3`
- In `pcie_config_aspm_link()`: `state &= (link->aspm_capable &
  ~link->aspm_disable)` — bits 0 and 1 are cleared, but
  `PCIE_LINK_STATE_L1` is `BIT(2)` = 4, which is **not** cleared
- Function returns 0 (success) and exits early — L1 remains enabled

When `aspm_conf = 0x2` (L1 only): `aspm_disable |= 2` does not map to
`PCIE_LINK_STATE_L1` (4) — L1 not disabled.

### Step 2.4: Fix Quality
**Record:** Obviously correct — matches how every other driver in the
tree calls `pci_disable_link_state()` (using `PCIE_LINK_STATE_*`
constants, not register values). Minimal, no new APIs, very low
regression risk.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Buggy `pci_disable_link_state(pdev, aspm_conf)` call
introduced in `f37f05503575c` (Oct 2019, "mt76: mt76x2e: disable
pcie_aspm by default"). Worked correctly until `b478e162f227` changed
the `PCIE_LINK_STATE_*` definitions.

### Step 3.2: Fixes Tag
**Record:** N/A — no `Fixes:` tag. Referenced commit `b478e162f227` is
confirmed in this tree (`git merge-base --is-ancestor` succeeds).

### Step 3.3: Related File History
**Record:** `pci.c` has only 3 commits in this tree. No related fix
already applied. The fix commit itself is not yet in
`stable/linux-6.18.y`.

### Step 3.4: Author Context
**Record:** Jiajia Liu has other kernel contributions. Felix Fietkau
(mt76 maintainer) Signed-off-by on the patch.

### Step 3.5: Dependencies
**Record:** Requires `b478e162f227` (present in tree). Standalone — no
series dependencies. Applies cleanly to current `pci.c`.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Patch Discussion
**Record:** `b4 am 20260602054349.42429-1-liujia6264@gmail.com` found
thread at
https://patch.msgid.link/20260602054349.42429-1-liujia6264@gmail.com.
Single-message thread (initial submission only); no review replies or
stable nominations in the mbox.

### Step 4.2: Reviewers
**Record:** `b4 am` reported 0 code-review messages. Felix Fietkau
maintainer sign-off in the patch itself.

### Step 4.3: Bug Report
**Record:** No external bug report or syzbot link. Bug identified via
code analysis of the `b478e162f227` API change impact.

### Step 4.4: Related Patches
**Record:** Standalone 1-patch fix. mt76 is the only driver passing raw
LNKCTL values to `pci_disable_link_state()` (verified via grep).

### Step 4.5: Stable List History
**Record:** Not searched — no stable discussion found in the patch
thread. Not applicable as a negative signal.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `mt76_pci_disable_aspm()` modified.

### Step 5.2: Callers
**Record:** Called during PCI probe from:
- `mt76x0/pci.c`, `mt76x2/pci.c` — always
- `mt7615/pci.c`, `mt7915/pci.c`, `mt7996/pci.c` — always
- `mt7921/pci.c`, `mt7925/pci.c` — when `disable_aspm` module param is
  set (default false)

### Step 5.3: Callees
**Record:** `pci_disable_link_state()` → `__pci_disable_link_state()` →
sets `link->aspm_disable` and calls `pcie_config_aspm_link()`. Fallback:
`pcie_capability_clear_word()` on LNKCTL if API call fails.

### Step 5.4: Reachability
**Record:** Triggered at device probe on systems with `CONFIG_PCIEASPM`
and ASPM enabled in firmware/BIOS — common on laptops and desktops. Not
userspace-triggerable, but affects every boot/probe of affected mt76
hardware.

### Step 5.5: Similar Patterns
**Record:** All other `pci_disable_link_state()` callers use
`PCIE_LINK_STATE_*` constants correctly. mt76 is the sole offender.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** Local tree is **v6.18.44** (`stable/linux-6.18.y`).
Buggy code at line 34 of `pci.c`. Regression commit `b478e162f227` is an
ancestor of HEAD.

### Step 6.2: Backport Complications
**Record:** Clean apply expected — no conflicting changes to this
function in 6.18.y.

### Step 6.3: Fix Already Present?
**Record:** No — fix not in tree. `git log --grep='transform aspm_conf'`
returns nothing.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem Criticality
**Record:** `drivers/net/wireless/mediatek/mt76` — IMPORTANT (WiFi
driver, multiple widely-used MediaTek chips).

### Step 7.2: Activity Level
**Record:** Actively maintained; mt76 is a core WiFi driver family with
ongoing development.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of mt76x0, mt76x2, mt7615, mt7915, mt7996 PCI WiFi
devices (always calls ASPM disable). mt7921/mt7925 users who set
`disable_aspm=1`. Config-dependent on `CONFIG_PCIEASPM` and platform
ASPM settings.

### Step 8.2: Trigger Conditions
**Record:** Device probe on platforms with ASPM L0s and/or L1 enabled in
PCI config — common default on modern systems. Not timing-dependent.

### Step 8.3: Failure Mode Severity
**Record:** **HIGH** functional impact — ASPM L1 remains active when the
driver intends to disable it. Original 2019 commit documented this
causes "continuous mcu hangs and instability" on mt76 hardware. Not a
kernel oops, but serious WiFi reliability regression.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH for affected mt76 users — restores intended ASPM
  disabling behavior
- **Risk:** VERY LOW — 6-line mapping fix, maintainer-approved, matches
  established driver patterns
- **Ratio:** Strongly favors backport

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real regression from `b478e162f227` (in tree since v6.9)
- Prevents ASPM L1 disable on mt76 — known to cause MCU
  hangs/instability
- Small, surgical, maintainer-signed fix
- Buggy code and prerequisite both present in v6.18.44
- Only driver in tree with this incorrect usage pattern

**AGAINST backport:**
- No syzbot report or user bug report filed
- mt7921/mt7925 only affected when module param set
- Not a security issue or kernel crash

**Unresolved:** No review-thread discussion beyond initial submission.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — mapping is verifiably
   correct; maintainer SOB
2. Fixes a real bug? **PASS** — regression from PCI API change
3. Important issue? **PASS** — WiFi instability on affected hardware
   (HIGH functional)
4. Small and contained? **PASS** — 7 lines, 1 file
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — prerequisite present, clean apply

### Step 9.3: Exception Categories
**Record:** Hardware workaround — restoring ASPM disable that prevents
known hardware instability. Qualifies under quirk/workaround exception.

### Step 9.4: Decision Rationale
This is a clear regression fix for the locally checked-out **6.18.y**
tree. Commit `b478e162f227` changed `PCIE_LINK_STATE_*` semantics; mt76
was the only driver still passing raw LNKCTL register values. The result
is that `pci_disable_link_state()` returns success without actually
disabling L1, leaving mt76 devices exposed to the exact ASPM-related
instability the driver was designed to prevent. The fix is minimal,
correct, and maintainer-approved.

---

## Verification

- [Phase 1] Parsed subject, tags, body; identified regression from
  `b478e162f227`
- [Phase 2] Read diff: 7 lines in `mt76_pci_disable_aspm()`, maps LNKCTL
  bits to `PCIE_LINK_STATE_*`
- [Phase 2] Verified values: `PCI_EXP_LNKCTL_ASPM_L0S=1`, `L1=2`;
  `PCIE_LINK_STATE_L0S=3`, `L1=4` in `include/linux/pci.h`
- [Phase 2] Traced `pcie_config_aspm_link()` line 961: `state &=
  (capable & ~aspm_disable)` — confirmed L1 (bit 2) not cleared when
  `aspm_disable=0x3`
- [Phase 3] `git describe HEAD`: v6.18.44
- [Phase 3] `git merge-base --is-ancestor b478e162f227 HEAD`: confirmed
  present
- [Phase 3] `git show b478e162f227^:include/linux/pci.h`: old
  `PCIE_LINK_STATE_L0S=BIT(0)`, `L1=BIT(1)` matched register bits
- [Phase 3] `git blame pci.c:34`: introduced in `f37f05503575c` (2019)
- [Phase 3] Fix not in tree: `git log --grep='transform aspm_conf'`
  empty
- [Phase 4] `b4 am 20260602054349...`: found patch thread, 1 message,
  Felix Fietkau SOB
- [Phase 5] `grep mt76_pci_disable_aspm`: 7 call sites across mt76 PCI
  drivers
- [Phase 5] `grep pci_disable_link_state`: mt76 is sole driver passing
  register values
- [Phase 6] Buggy code confirmed at `pci.c:34` in v6.18.44
- [Phase 6] `b478e162f227` on `stable/linux-6.18.y` via grep of branch
  log
- [Phase 8] Original commit `f37f05503575c` message documents ASPM
  causes "mcu hangs and instability"

**YES**The background checks finished and match the earlier analysis:

- **Stable branch search:** `b478e162f227d` ("PCI/ASPM: Consolidate link
  state defines") is on `stable/linux-6.18.y`, so the regression this
  mt76 fix addresses is present in your v6.18.44 tree.
- **Author history:** Jiajia Liu has other kernel fixes (Bluetooth,
  mt76, btmtk, i915); Felix Fietkau signed off on this patch.

**Verdict unchanged: YES** — backport the fix to restore correct ASPM
disabling on mt76 PCI WiFi devices.

 drivers/net/wireless/mediatek/mt76/pci.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/pci.c b/drivers/net/wireless/mediatek/mt76/pci.c
index b5031ca7f73fb..4c864afefe2f2 100644
--- a/drivers/net/wireless/mediatek/mt76/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/pci.c
@@ -30,8 +30,14 @@ void mt76_pci_disable_aspm(struct pci_dev *pdev)
 
 	if (IS_ENABLED(CONFIG_PCIEASPM)) {
 		int err;
+		int state = 0;
 
-		err = pci_disable_link_state(pdev, aspm_conf);
+		if (aspm_conf & PCI_EXP_LNKCTL_ASPM_L0S)
+			state |= PCIE_LINK_STATE_L0S;
+		if (aspm_conf & PCI_EXP_LNKCTL_ASPM_L1)
+			state |= PCIE_LINK_STATE_L1;
+
+		err = pci_disable_link_state(pdev, state);
 		if (!err)
 			return;
 	}
-- 
2.53.0

