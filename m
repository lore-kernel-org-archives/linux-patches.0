Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9644647013F;
	Mon, 31 Aug 2026 13:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184135; cv=none; b=GCKHCwbhoOEyX8P8EyObe+crxpFYMdrIqi13RkBo8ufmrjmurbOUVNmwWVClhNf1KpwFIULA4bHfRAet/ZcsQLYf4pOCwng+GIFjZXF2D0ygY4oXBvnCJ8ZAaBeiqIA/+3yC2hl7WRtHIKv1ZvezPVEjT2xHptBIeh/lhXltZww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184135; c=relaxed/simple;
	bh=43XdvBZIXnEtZ7bXoHLMHYwlygpWxKt49tSwN52yY5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M+i9Y9W8PEzre41nfYWSowm6youQbDobX6Gg7xuPlIYoQ0XbMYg9XTq3Trp5+q5Jlh03xK4czK5MIVGA4fB6V67Vg1Ux3TSBXgFQmWLmeytT8bYtDvEqVOaMtqpbXrdHv79qHmWoEG09TEk3SpfZYChD9UgWKvCItM7+xTO0q1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=leLkA3W3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="leLkA3W3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627881F00ACF;
	Mon, 31 Aug 2026 13:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184132;
	bh=c2ZdKldU5FcP/3B2lyQTye4/dO04aD45VcbKM3gltdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=leLkA3W33PDnD7Fw/m2gFnSp1ffAPoAtVyRgRF37Z9WPQFvsWVn7GMNjVCpqz4RD9
	 d07G/vPuD+aJSn+vNATR61NsjBvWI4tUZOTMAEoe4ocLkz3PEavTIKwAORmEKuGBU8
	 CQPnTzkbhvfT90eQ3aWavFHSE2KqFku1CCCoagdhJV7eUo24MJNdXVGoEIo7OHV3eG
	 8yqxEw6LsfITwhiwsBd2NVIg+I3KWKi4OIVmXs+gGF9a3S0oZ9h82Bx90QXdzjG6JY
	 A9R8K7Sw7I/WRO92NIXarQcaBiz4NeT6kwXoooTBcbYg96Pysf+7fjFo8mz6BL1a/B
	 D6kDGgWSVbmgg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xu Rao <raoxu@uniontech.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ata: libata-pmp: add JMicron JMS562 quirk
Date: Mon, 31 Aug 2026 09:28:59 -0400
Message-ID: <20260831133314.4125787-511-sashal@kernel.org>
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

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit c62aff1174cf88e10716c7513702443c47551fc6 ]

JMicron JMS562, as used in QNAP QDA-A2AR RAID1 adapters, may
keep the exported ATA device not ready while the array is rebuilding.

In this state, libata may repeatedly try to softreset and classify
the fan-out link.  On the affected adapter, this can time out, make
PMP/SCR access fail, and eventually disable the fan-out link before
the RAID volume is exported.

A failing boot shows the fan-out link failing SRST, PMP access
timing out, SCR read failing, and the link being disabled:

  ata4.00: softreset failed (device not ready)
  ata4.15: qc timeout after 3000 msecs (cmd 0xe4)
  ata4.00: failed to read SCR 0 (Emask=0x4)
  ata4.00: failed to recover link after 3 tries, disabling

After that, the root filesystem on the exported RAID volume cannot
be found.

Add JMS562 to the existing JMicron PMP quirk that disables LPM,
avoids softreset on fan-out links, and assumes an ATA device.  This
prevents libata from dropping the exported RAID volume during rebuild
recovery.

Signed-off-by: Xu Rao <raoxu@uniontech.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
- Record: `[ata: libata-pmp] [add] JMicron JMS562 quirk for QNAP
  QDA-A2AR RAID adapter boot failure during array rebuild`

**Step 1.2 — Tags**
- Record:
  - `Signed-off-by: Xu Rao <raoxu@uniontech.com>` (author)
  - `Reviewed-by: Damien Le Moal <dlemoal@kernel.org>` (libata
    maintainer)
  - `Signed-off-by: Niklas Cassel <cassel@kernel.org>` (committer)
  - No `Fixes:`, `Reported-by:`, `Tested-by:`, `Cc:
    stable@vger.kernel.org`, or `Link:` tags
  - Notable: maintainer review from Damien Le Moal; no syzbot/fuzzer
    involvement

**Step 1.3 — Body analysis**
- Record:
  - **Bug:** JMicron JMS562 PMP (QNAP QDA-A2AR RAID1 adapter) keeps
    exported ATA device "not ready" during RAID rebuild
  - **Symptom:** libata repeatedly softresets/classifies fan-out link →
    PMP/SCR timeouts → link disabled → root filesystem on RAID volume
    not found at boot
  - **Failure log:** `softreset failed (device not ready)`, `qc
    timeout`, `failed to read SCR 0`, `failed to recover link after 3
    tries, disabling`
  - **Root cause:** Missing quirk; libata error-handling path
    incompatible with JMS562 behavior during rebuild
  - **Fix approach:** Add device ID `0x0562` to existing JMicron quirk
    block (disable LPM, avoid SRST, assume ATA)
  - **Version info:** None stated in commit message

**Step 1.4 — Hidden bug fix detection**
- Record: Not hidden — this is an explicit hardware quirk fix. "Add
  quirk" language is standard for ATA PMP workarounds; the commit
  clearly describes a real boot failure.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
- Record:
  - Files: `drivers/ata/libata-pmp.c` (+6, -1)
  - Function: `sata_pmp_quirks()`
  - Scope: Single-file, surgical quirk addition (~7 lines net)

**Step 2.2 — Code flow change**
- Record:
  - **Before:** JMicron vendor `0x197b` quirk applied only to device IDs
    `0x2352` (JMB350) and `0x0325` (JMB394)
  - **After:** Same quirk also applied to `0x0562` (JMS562)
  - **Affected path:** PMP attach → `sata_pmp_quirks()` → per-link flags
    set at initialization, before normal I/O
  - **Flags set:** `ATA_LFLAG_NO_LPM | ATA_LFLAG_NO_SRST |
    ATA_LFLAG_ASSUME_ATA` on all fan-out links

**Step 2.3 — Bug mechanism**
- Record:
  - **Category:** Hardware workaround / logic correctness fix
  - **Mechanism:** Without quirk, libata performs softreset (SRST) and
    link classification on a device that legitimately reports "not
    ready" during RAID rebuild. SRST/classify timeouts trigger error
    recovery that disables the link before the RAID volume becomes
    available. Quirk prevents SRST and assumes ATA class, matching
    proven JMicron PMP behavior.

**Step 2.4 — Fix quality**
- Record:
  - Obviously correct: extends an existing, proven quirk pattern for the
    same vendor
  - Minimal scope: one device ID + comment
  - Low regression risk: only affects JMS562 PMP hardware; flags mirror
    those already used for sibling JMicron chips
  - No API, structure, or behavioral changes beyond this device

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
- Record:
  - JMicron quirk block introduced by `0afc6f5ba9541` (2011, Thermaltake
    BlackX Duet / JMB350)
  - JMB394 added by `efb9e0f4f4378` (2014) — that commit included `Cc:
    stable@vger.kernel.org`
  - Current tree has the quirk for `0x2352` and `0x0325` but not
    `0x0562`
  - Bug is not from a recent regression — it's a missing quirk for
    hardware that was never covered

**Step 3.2 — Fixes: tag**
- Record: No `Fixes:` tag present; not applicable.

**Step 3.3 — Related file history**
- Record:
  - Recent `libata-pmp.c` changes in this tree are unrelated (FBS/CBS
    defer, tracepoints, spelling)
  - Commit `c62aff1174cf8` is the only mainline change to this quirk
    block since v6.18
  - Standalone: v2 submission notes "sent as [PATCH 6/6], but this is a
    standalone patch"

**Step 3.4 — Author context**
- Record: Xu Rao (UnionTech) — first ATA contribution in this tree.
  Patch reviewed and committed by libata maintainers (Damien Le Moal,
  Niklas Cassel).

**Step 3.5 — Dependencies**
- Record: No dependencies. `git apply --check` against current tree
  succeeds. Quirk infrastructure and target `else if` block both exist
  in v6.18.44.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
- Record:
  - Lore URL: https://patch.msgid.link/71B4D0BBEC4F886F+20260610052835.1
    111181-1-raoxu@uniontech.com
  - Series: v1 as `[PATCH 6/6]`, v2 as standalone `[PATCH v2]`
    (committed version)
  - Damien Le Moal: "It is really unfortunate that JMicron keeps having
    these issues. But I do not see any way around this" → `Reviewed-by:`
  - No NAKs found
  - No explicit stable nomination in thread

**Step 4.2 — Reviewers**
- Record: CC'd to `dlemoal@kernel.org`, `cassel@kernel.org`, `linux-
  ide@vger.kernel.org`. Reviewed by libata maintainer Damien Le Moal.

**Step 4.3 — Bug report**
- Record: Real-world hardware bug on QNAP QDA-A2AR; concrete dmesg log
  in commit message. No external bug tracker link. Severity for affected
  users: cannot boot when root is on rebuilding RAID volume.

**Step 4.4 — Related patches**
- Record: Originally part of a 6-patch series but maintainer confirmed
  v2 is standalone with no code changes from v1. No other series patches
  required.

**Step 4.5 — Stable list history**
- Record: No stable-list discussion found for this specific fix.
  Precedent: JMB394 quirk (`efb9e0f4f4378`) was explicitly nominated for
  stable.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
- Record: `sata_pmp_quirks()` (modified), called from
  `sata_pmp_attach()`

**Step 5.2 — Callers**
- Record:
  - `sata_pmp_attach()` defined in `libata-pmp.c`, called from `libata-
    eh.c` during error-handling/recovery when attaching a PMP device
  - Triggered during SATA PMP enumeration at boot or hot-plug

**Step 5.3 — Callees**
- Record: Uses `sata_pmp_gscr_vendor()`, `sata_pmp_gscr_devid()`,
  `ata_for_each_link()` — all standard libata PMP helpers

**Step 5.4 — Reachability**
- Record: Triggered whenever a JMicron JMS562 PMP is detected. Affects
  boot path for systems using QNAP QDA-A2AR as root storage. Not
  userspace-triggerable directly, but affects every boot on affected
  hardware.

**Step 5.5 — Similar patterns**
- Record: Identical quirk pattern already used for JMB350 (`0x2352`) and
  JMB394 (`0x0325`) in the same function. Same vendor, same flags, same
  failure mode (SRST breaks detection).

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code present?**
- Record:
  - Local tree: **v6.18.44** (`git describe HEAD`)
  - Commit `c62aff1174cf8` is **NOT** in this tree (`git merge-base
    --is-ancestor` → NOT)
  - Buggy code **exists**: lines 460–472 of `drivers/ata/libata-pmp.c`
    have JMicron quirk without `0x0562`
  - JMicron quirk infrastructure present since v3.x era; bug is absence
    of device ID, not post-branch regression

**Step 6.2 — Backport complications**
- Record: Clean apply confirmed (`git apply --check` passes). No
  conflicting changes to this hunk in v6.18.y. Expected difficulty:
  **clean apply**.

**Step 6.3 — Related fixes already present?**
- Record: No existing fix for JMS562 in this tree. `git log
  --grep="JMS562"` returns nothing.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**
- Record: `drivers/ata/` — libata PMP (Port Multiplier). Criticality:
  **IMPORTANT** (storage/boot path for affected hardware).

**Step 7.2 — Activity**
- Record: Mature subsystem with occasional quirk additions. PMP quirk
  table is stable; changes are typically small device-ID additions.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
- Record: Users of QNAP QDA-A2AR RAID1 adapters (JMicron JMS562 PMP)
  booting from or accessing RAID volumes during rebuild. Driver-
  specific, but impact is total for those users (unbootable system).

**Step 8.2 — Trigger conditions**
- Record: Boot or PMP attach while JMS562-managed RAID array is
  rebuilding. Reproducible on affected hardware per commit message. Not
  timing-dependent race — deterministic behavior mismatch.

**Step 8.3 — Failure severity**
- Record: Link disabled → storage unavailable → root filesystem not
  found. **Severity: CRITICAL** for affected users (unbootable system,
  potential data access loss during recovery window).

**Step 8.4 — Risk-benefit**
- Record:
  - **Benefit: HIGH** — restores bootability on real hardware with
    documented failure mode
  - **Risk: VERY LOW** — 7-line quirk addition, scoped to one PCI device
    ID, mirrors existing proven quirk
  - **Ratio: Strongly favors backport**

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

FOR backport:
- Real hardware bug with concrete dmesg and boot failure
- Hardware quirk/workaround — explicit stable exception category
- Small, surgical, obviously correct
- Reviewed by libata maintainer
- Applies cleanly to v6.18.44
- Standalone, no dependencies
- Precedent: prior JMicron PMP quirks backported to stable

AGAINST backport:
- Affects narrow hardware population (QNAP QDA-A2AR users)
- No syzbot/security angle
- No explicit stable nomination

UNRESOLVED: None material to the decision.

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — extends existing quirk;
   reviewed by maintainer
2. Fixes real bug affecting users? **PASS** — boot failure on QNAP
   QDA-A2AR
3. Important issue? **PASS** — unbootable system / root FS unavailable
   (CRITICAL for affected users)
4. Small and contained? **PASS** — 7 lines, one file
5. No new features or APIs? **PASS** — device quirk only
6. Can apply to local tree? **PASS** — clean apply verified;
   prerequisite code present

**Step 9.3 — Exception category**
- Record: **Hardware quirk/workaround** — adding device ID `0x0562` to
  existing JMicron PMP quirk table

**Step 9.4 — Decision rationale**

This commit adds the JMicron JMS562 (`0x0562`) to an existing, well-
tested PMP quirk block in `sata_pmp_quirks()`. Without it, libata's
softreset and link-recovery logic on the QNAP QDA-A2AR adapter can
disable the fan-out link during RAID rebuild, preventing the root
filesystem from appearing at boot. The fix is minimal, matches the
pattern used for other JMicron chips since 2011, applies cleanly to the
v6.18.44 tree, and was reviewed by the libata maintainer. This is
textbook stable material: a hardware-specific workaround for a serious,
reproducible boot failure.

---

## Verification

- [Phase 1] Parsed commit `c62aff1174cf8`: subject, body, tags
  (Reviewed-by: Damien Le Moal; no Fixes/Reported-by/stable tags)
- [Phase 2] Diff: +6/-1 in `sata_pmp_quirks()`, adds `devid == 0x0562`
  to JMicron quirk
- [Phase 3] `git blame -L 460,472`: quirk block from 2011/2014 commits;
  JMS562 not present
- [Phase 3] `git show efb9e0f4f4378`: JMB394 quirk had `Cc:
  stable@vger.kernel.org`
- [Phase 3] `git merge-base --is-ancestor c62aff1174cf8 HEAD`: commit
  NOT in tree
- [Phase 3] `git apply --check` on commit diff: applies cleanly
- [Phase 4] `b4 dig -c c62aff1174cf8`: found lore thread
- [Phase 4] `b4 dig -a`: v1 as patch 6/6, v2 standalone (committed
  version)
- [Phase 4] `b4 dig -w`: CC'd dlemoal, cassel, linux-ide
- [Phase 4] mbox: Damien Le Moal Reviewed-by, no NAKs, v2 confirmed
  standalone
- [Phase 5] `grep sata_pmp_attach`: caller in `libata-eh.c:3379`
- [Phase 5] Read `include/linux/libata.h`: confirmed flag meanings for
  NO_SRST, ASSUME_ATA, NO_LPM
- [Phase 6] `git describe HEAD`: v6.18.44
- [Phase 6] Read `drivers/ata/libata-pmp.c:460-472`: buggy code (missing
  0x0562) confirmed present
- [Phase 6] `git log v6.18..master -- drivers/ata/libata-pmp.c`: only
  this commit touches quirk block
- [Phase 8] Commit message dmesg: softreset failure → link disabled →
  root FS not found

**YES**

 drivers/ata/libata-pmp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index 48ac09d9031e6..299b1823e0d09 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -457,8 +457,13 @@ static void sata_pmp_quirks(struct ata_port *ap)
 		 * otherwise.  Don't try hard to recover it.
 		 */
 		ap->pmp_link[ap->nr_pmp_links - 1].flags |= ATA_LFLAG_NO_RETRY;
-	} else if (vendor == 0x197b && (devid == 0x2352 || devid == 0x0325)) {
+	} else if (vendor == 0x197b &&
+		   (devid == 0x0562 || devid == 0x2352 || devid == 0x0325)) {
 		/*
+		 * 0x0562: JMicron JMS562, as used in QNAP QDA-A2AR RAID1
+		 *         adapters.  The exported device may stay not ready
+		 *         while the array is rebuilding, and SRST/classify can
+		 *         time out before the RAID volume is exported.
 		 * 0x2352: found in Thermaltake BlackX Duet, jmicron JMB350?
 		 * 0x0325: jmicron JMB394.
 		 */
-- 
2.53.0

