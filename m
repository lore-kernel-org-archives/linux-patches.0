Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB1D3AB28F;
	Tue, 24 Mar 2026 11:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774351177; cv=none; b=SkNd9/2sYXcZf7Z/yBg2IP12FWdqOcdRyTOmI4tzbvH9bWt3GuCdHs/PnzZq0OykOA3EDLdzbsBclN3GxMWquNGNO345W2NOm/DQZjRbNIehpnmHakem9ycbdsCyiIiSUNXldAcvlBF7sqK1biJqeSwwfrLRpMp7o1k2G8At7cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774351177; c=relaxed/simple;
	bh=TXsyT9+84fckF4zvFVBSoQgz75KUKdLbJd8dEvuYupw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LaYqEpjOY+opPbjzp81XaxVYdyZQaUBu6Wwb/+NOoKWi6TaOggzx9SKz/xeNqokP/EsCoZNyJ/FgCrHKWgPmz1Qc8FKDGp/WTEB4YlIzW4gaB4nFQpv9Y1XskcuQd/UAjzh6vwQwlyJ88Z0RsS9L/G8jzE20fjiDKMEslBRhcX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o9p6MUia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o9p6MUia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9702C19424;
	Tue, 24 Mar 2026 11:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774351177;
	bh=TXsyT9+84fckF4zvFVBSoQgz75KUKdLbJd8dEvuYupw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o9p6MUia0E7XcXyi3C7Bem0oySg44h1WwSaCNJ+3PRhnzkPyREDSIzAly5R3tin8B
	 CyI+wsIBi7Hmh7admHghGLRGfDueNjKFbA8FR+0lZ7B0u+sXNv+MD5OhQGrK70EMf6
	 Y/TqYWwGbiG77RfnHvbhWXrmSF82DIynzPAHk9HNmwQHsyqC3KkSrWCwPoyiWOwJra
	 eUo97dNTYZfDDIATlA/7RZyPxpV+2ZnIeB8XKMKGPgkZQxzNdUm9HE6520YIPA5uYG
	 /oA63kBn3ND0M1rMQsTSYzf0k09CE/kJLTKapl/wNfF46toGjc96b6ZiBW75bZLoCX
	 jqMgT1L4mlUqQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Paul SAGE <paul.sage@42.fr>,
	Rishon Jonathan R <mithicalaviator85@gmail.com>,
	Vincent MORVAN <vinc@42.fr>,
	Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	pavan.chebbi@broadcom.com,
	mchan@broadcom.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.1] tg3: replace placeholder MAC address with device property
Date: Tue, 24 Mar 2026 07:19:12 -0400
Message-ID: <20260324111931.3257972-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260324111931.3257972-1-sashal@kernel.org>
References: <20260324111931.3257972-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paul SAGE <paul.sage@42.fr>

[ Upstream commit e4c00ba7274b613e3ab19e27eb009f0ec2e28379 ]

On some systems (e.g. iMac 20,1 with BCM57766), the tg3 driver reads
a default placeholder mac address (00:10:18:00:00:00) from the
mailbox. The correct value on those systems are stored in the
'local-mac-address' property.

This patch, detect the default value and tries to retrieve
the correct address from the device_get_mac_address
function instead.

The patch has been tested on two different systems:
- iMac 20,1 (BCM57766) model which use the local-mac-address property
- iMac 13,2 (BCM57766) model which can use the mailbox,
    NVRAM or MAC control registers

Tested-by: Rishon Jonathan R <mithicalaviator85@gmail.com>

Co-developed-by: Vincent MORVAN <vinc@42.fr>
Signed-off-by: Vincent MORVAN <vinc@42.fr>
Signed-off-by: Paul SAGE <paul.sage@42.fr>
Signed-off-by: Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20260314215432.3589-1-atharvatiwarilinuxdev@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a comprehensive analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
Record: [tg3 (Broadcom ethernet)] [replace] — Replace placeholder MAC
address with the correct one from device firmware property on affected
Apple systems.

### Step 1.2: Tags
- **Tested-by:** Rishon Jonathan R — tested on real hardware (two iMac
  models)
- **Co-developed-by:** Vincent MORVAN (42.fr)
- **Signed-off-by:** Vincent MORVAN, Paul SAGE (original author),
  Atharva Tiwari (respin author), Jakub Kicinski (netdev maintainer)
- **Reviewed-by:** Michael Chan — tg3/Broadcom maintainer
- **Link:** patch.msgid.link to v4 submission
- No Fixes: tag (expected), no Cc: stable (expected)

Notable: Reviewed by the actual tg3 maintainer (Michael Chan at
Broadcom).

### Step 1.3: Body Text
Bug: On iMac 20,1 with BCM57766, the driver reads placeholder MAC
`00:10:18:00:00:00` from the mailbox. The correct MAC is in the `local-
mac-address` firmware property. The address `00:10:18:xx:xx:xx` is a
Broadcom OUI — the placeholder passes `is_valid_ether_addr()` but is not
the real device-unique address.

Record: [Bug: NIC gets hardcoded placeholder MAC instead of real unique
MAC] [Symptom: wrong MAC address, potential MAC collisions, broken
networking] [Affects Apple iMac 20,1 with BCM57766] [Root cause:
firmware stores real MAC in property, mailbox contains placeholder]

### Step 1.4: Hidden Bug Fix?
This IS a real bug fix — not disguised. The NIC literally gets the wrong
MAC address on affected hardware, making networking broken or unreliable
(MAC collisions if multiple affected machines are on the same network).

Record: [Yes, this is a real hardware bug fix — a hardware workaround
for broken firmware on Apple systems]

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **1 file changed:** `drivers/net/ethernet/broadcom/tg3.c`
- **+11 lines:** New 6-line helper `tg3_is_default_mac_address()` + 4
  lines of checking in `tg3_get_device_address()` (including blank line)
- **Functions modified:** New `tg3_is_default_mac_address()`, modified
  `tg3_get_device_address()`
- **Scope:** Single-file surgical fix

### Step 2.2: Code Flow Change
**Before:** `tg3_get_device_address` tries: (1)
`eth_platform_get_mac_address` (OF/DT + arch), (2) SSB core, (3)
mailbox, (4) NVRAM, (5) MAC control registers. If result passes
`is_valid_ether_addr()`, returns it — even if it's the Broadcom
placeholder.

**After:** Same flow, but after getting a valid address, checks if it
matches the known placeholder `00:10:18:00:00:00`. If so, calls
`device_get_mac_address()` which checks fwnode properties (including
ACPI `local-mac-address`) and nvmem — sources that
`eth_platform_get_mac_address()` doesn't check.

The key: `eth_platform_get_mac_address()` only uses
`of_get_mac_address()` (DT) and `arch_get_platform_mac_address()`. Apple
iMacs use ACPI, not DT. So `eth_platform_get_mac_address` returns
-ENODEV, the mailbox returns the placeholder, and before this fix the
placeholder was accepted as valid.

### Step 2.3: Bug Mechanism
Category: (h) Hardware workaround + (g) Logic/correctness fix.
The placeholder `00:10:18:00:00:00` is a valid unicast Ethernet address
(Broadcom OUI), so existing validation passes. But it's not a real
unique MAC — every affected system would have the same address.

### Step 2.4: Fix Quality
- **Obviously correct:** Uses `ether_addr_equal()` and
  `device_get_mac_address()` — established kernel APIs
- **Minimal/surgical:** ~11 lines, well-contained
- **Regression risk:** Very low — only activates for one specific
  placeholder MAC
- **Reviewer quality:** Michael Chan (Broadcom/tg3 maintainer) gave
  Reviewed-by
- **Tested:** On two different iMac models (one needing the fix, one
  not)

Record: [High quality fix, minimal scope, very low regression risk]

---

## PHASE 3: GIT HISTORY

### Step 3.1: Blame
- `tg3_get_device_address` originated in the initial tree import (2005,
  Linus)
- Refactored by Jakub Kicinski in 2021 (commit `a04436b27a934`) to
  accept `u8 *addr` parameter
- The `is_valid_ether_addr()` check at the end exists in all stable
  trees

Record: [Buggy behavior present since tg3 driver inception (2005); code
stable since 2021 refactor]

### Step 3.2: Fixes Tag — N/A (no Fixes: tag, expected)

### Step 3.3: File History
Recent changes to tg3.c are mostly unrelated (PCI fixes, timer renames,
CRC32, etc.). This is a standalone fix with no dependencies.

Record: [Standalone patch, no prerequisites or related series]

### Step 3.4: Author
- Atharva Tiwari: 3 commits total in tree (MFD, I2C) — not a tg3 regular
- Paul SAGE: 0 other commits — first-time contributor
- BUT: Reviewed by Michael Chan (Broadcom tg3 maintainer), which
  compensates

Record: [Authors are not regular tg3 contributors, but fix is reviewed
by the tg3 maintainer]

### Step 3.5: Dependencies
- `device_get_mac_address()` exists in `net/ethernet/eth.c` since ~v4.x
- `ether_addr_equal()` exists in all stable trees
- No new dependencies needed

Record: [Standalone, all APIs available in stable trees]

---

## PHASE 4: MAILING LIST

### Findings from lore:
- **4 versions** of the patch, addressing constructive feedback each
  time
- **Merged into net.git** (not net-next) — maintainers treated this as a
  bug fix
- **Pulled into v7.0-rc5** by Linus
- **No NAKs** at any point
- **No stable discussion** by reviewers
- Reviewers: Florian Fainelli (Broadcom), Andrew Lunn, Simon Horman,
  Jakub Kicinski, Michael Chan

Record: [Merged as bug fix into net tree; no concerns raised; reviewed
by multiple networking experts]

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Functions
- New: `tg3_is_default_mac_address()` — simple comparison helper
- Modified: `tg3_get_device_address()` — adds fallback check

### Step 5.2: Callers
`tg3_get_device_address()` is called from `tg3_init_one()` at line 17906
— the PCI probe function. This is called once during driver
initialization for every tg3 device.

### Step 5.3-5.4: Call Chain
`tg3_init_one()` (PCI probe) → `tg3_get_device_address()` → (now)
`tg3_is_default_mac_address()` → possibly `device_get_mac_address()`.

If `tg3_get_device_address()` fails, the driver probe fails entirely
("Could not obtain valid ethernet address, aborting").

Record: [Called once during device probe; affects ALL users with
affected hardware; failure = no network interface]

### Step 5.5: Similar Patterns
The `eth_platform_get_mac_address` → `device_get_mac_address` pattern
difference is well-understood. Other drivers use
`device_get_mac_address` directly.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Code in Stable?
Yes — `tg3_get_device_address()` exists in ALL stable trees. The
function has been present since 2005. The current form (with `u8 *addr`
parameter) exists since 2021, which covers stable trees 5.15.y and
newer.

### Step 6.2: Backport Complications
The patch should apply cleanly to stable trees from 5.15.y onward
(post-2021 refactor). For older trees (5.10.y and earlier), the function
signature is different and would need adaptation.

### Step 6.3: Related Fixes Already in Stable?
No — this is the first fix for this specific issue.

Record: [Clean apply expected for 5.15.y+; may need minor rework for
5.10.y]

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
- Path: `drivers/net/ethernet/broadcom/` — Network driver (Broadcom tg3)
- Criticality: **IMPORTANT** — BCM57766 is a common Broadcom ethernet
  chip used in many systems

### Step 7.2: Activity
Active subsystem with regular maintenance. The tg3 driver is mature and
widely deployed.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is Affected?
Users of Apple iMac systems (specifically iMac 20,1, possibly others)
with BCM57766 Broadcom ethernet running Linux. This is hardware-specific
but affects ALL users of that hardware.

### Step 8.2: Trigger Conditions
- **Always** triggered on boot for affected hardware — not intermittent
- Not a race or timing issue — deterministic
- Not exploitable from userspace (probe path)

### Step 8.3: Failure Mode
Wrong MAC address: The NIC gets placeholder `00:10:18:00:00:00` instead
of its unique MAC. Consequences:
- MAC conflicts if multiple affected machines on the same network
- DHCP may assign wrong IPs or refuse to serve
- Network functionality degraded or broken
- **Severity: MEDIUM-HIGH** (broken networking on affected hardware)

### Step 8.4: Risk-Benefit
- **Benefit:** HIGH for affected users — fixes completely broken
  networking
- **Risk:** VERY LOW — only activates for one specific placeholder MAC;
  uses established APIs; reviewed by maintainer; tested on real hardware
- **Ratio:** Very favorable

---

## PHASE 9: SYNTHESIS

### Step 9.1: Evidence Compilation

**FOR backporting:**
1. Fixes a real bug — wrong MAC address on specific hardware
2. Very small and surgical (~11 lines added)
3. Reviewed by tg3 maintainer (Michael Chan at Broadcom)
4. Tested on real hardware (two different systems)
5. Merged into net.git (bug fix tree), not net-next
6. Very low regression risk — check only activates for one specific MAC
7. Hardware workaround pattern (similar to quirks)
8. All required APIs exist in stable trees
9. Standalone patch with no dependencies

**AGAINST backporting:**
1. Affects only specific Apple hardware subset
2. Not a crash/security/corruption issue — "just" wrong MAC
3. Authors are not regular tg3 contributors (mitigated by maintainer
   review)

### Step 9.2: Stable Rules Checklist
1. **Obviously correct and tested?** YES — reviewed by maintainer,
   tested on hardware
2. **Fixes a real bug?** YES — wrong MAC address on affected hardware
3. **Important issue?** MEDIUM-HIGH — broken networking, not a crash but
   renders the NIC unusable in practice
4. **Small and contained?** YES — ~11 lines in one file
5. **No new features or APIs?** YES — uses existing APIs, just adds a
   workaround check
6. **Can apply to stable?** YES — should apply cleanly to 5.15.y+

### Step 9.3: Exception Categories
This falls into the **QUIRKS and WORKAROUNDS** category — a hardware-
specific workaround for broken firmware behavior on specific systems.
These are explicitly listed as YES for stable.

### Step 9.4: Decision
This is a hardware workaround that fixes broken networking on specific
Apple iMac systems. It's small, well-reviewed, well-tested, and uses
established kernel APIs. The pattern matches the "hardware quirk"
exception that is always appropriate for stable.

---

## Verification

- [Phase 1] Parsed tags: Tested-by (real hardware), Reviewed-by (Michael
  Chan, tg3 maintainer), Co-developed-by (Vincent MORVAN), Link to
  submission
- [Phase 2] Diff analysis: +11 lines total — new 6-line helper + 4-line
  check in existing function; only activates for MAC `00:10:18:00:00:00`
- [Phase 2] Verified `eth_platform_get_mac_address()` uses
  `of_get_mac_address()` (DT only) at eth.c:492;
  `device_get_mac_address()` uses `fwnode_get_mac_address()` (ACPI+DT)
  at eth.c:616 — explains why Apple ACPI systems need the latter
- [Phase 3] git blame: `tg3_get_device_address` from 2005 (initial
  tree), refactored 2021 (a04436b27a934); present in all stable trees
- [Phase 3] Author check: Atharva Tiwari has 3 commits (none in tg3);
  Paul SAGE has 0 other commits
- [Phase 4] Lore search: patch went through 4 versions; merged into
  net.git (bug fix tree); pulled into v7.0-rc5; no NAKs; no stable
  discussion
- [Phase 5] tg3_get_device_address called from tg3_init_one (PCI probe,
  line 17906) — affects device initialization
- [Phase 5] If it returns error, probe fails with "Could not obtain
  valid ethernet address, aborting"
- [Phase 6] `device_get_mac_address` and `ether_addr_equal` exist in all
  active stable trees
- [Phase 8] Failure mode: wrong MAC address on affected hardware;
  severity MEDIUM-HIGH (broken networking)

**YES**

 drivers/net/ethernet/broadcom/tg3.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 75f66587983d7..a80f27e66ab52 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -17030,6 +17030,13 @@ static int tg3_get_invariants(struct tg3 *tp, const struct pci_device_id *ent)
 	return err;
 }
 
+static int tg3_is_default_mac_address(u8 *addr)
+{
+	static const u8 default_mac_address[ETH_ALEN] = { 0x00, 0x10, 0x18, 0x00, 0x00, 0x00 };
+
+	return ether_addr_equal(default_mac_address, addr);
+}
+
 static int tg3_get_device_address(struct tg3 *tp, u8 *addr)
 {
 	u32 hi, lo, mac_offset;
@@ -17103,6 +17110,10 @@ static int tg3_get_device_address(struct tg3 *tp, u8 *addr)
 
 	if (!is_valid_ether_addr(addr))
 		return -EINVAL;
+
+	if (tg3_is_default_mac_address(addr))
+		return device_get_mac_address(&tp->pdev->dev, addr);
+
 	return 0;
 }
 
-- 
2.51.0

