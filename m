Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0A953D591;
	Mon, 19 Oct 2026 14:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418713; cv=none; b=nWLKTURiy/pLrYUmLSsrAAFUtKd6P6JSh7NCdKYshoAnGGhjqqwer+1LyZodDl0cmJdE4b1c4fLSP8ChjdZOV7cNZ3TrTu+xlgqAl+1yHENRG4yLVdiUEWDWhAjCiSgSSxo3iG3pAAs3yqNLQuXoISzpHJ06kXhFTDsORDI1PIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418713; c=relaxed/simple;
	bh=ICjwcPGSyuHCHj38lFIHkB179DMBWGKL3U2PAeLo/3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EQ9qKU21Lfg2hnTfA8Oh3Obvu4h74BZbShW+sUwRDaWTVp1psHkDD6Rr2FXM7/l6/nB7lVth+Dm0+RCLMLXAgS62pI4VR81k9UxRnQ1EfGSZrxVyzmFno2J+oIrVNZgsXEVtFavuIOawuJm7cVVGTL5Le7qrR6kBbP/ZAnHRvK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bnsccmgx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bnsccmgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5A91F000C5;
	Mon, 19 Oct 2026 14:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418710;
	bh=MCfvKyKdZX37EObaSz3b1VNDIt/oWHvY2bMR4aaE0zY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BnsccmgxPALbW7KkR+HFLpkjxejXQoiwpVfYwFq37RL2zIV+fw9ZaiNBCvJfPVAlA
	 xtJQabswhPyklzD75Ij9pO8umqniRx/Y3m8QtYKsnuE9Ci3qZPyE2zlFUMVTGKWS8X
	 iHy0Zpqf5ssWsiq7VI2iKdtnZKHQ6rFjRLCkT0YiczazgqBQSccXwUWHKMgrk6ff5C
	 vEA7+qKUw7kaKuKJeNNssKTJ0obwvS8Vxc3jC2ukNFCnGEs+SvyItGTzwyW9km7vQj
	 KYKdPyXqn85P+rhv5PINR5Da1SiUEX7uS4aBZzVVtarmYWP/BV4QqiwRn+gBelFN2g
	 gismD1jmNreoQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Iva=20Kasprzakov=C3=A1?= <iva@yenya.net>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] Bluetooth: fix BT dependency for submodules
Date: Mon, 19 Oct 2026 09:52:12 -0400
Message-ID: <20261019135441.1420968-441-sashal@kernel.org>
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

From: Iva Kasprzaková <iva@yenya.net>

[ Upstream commit 6ec1896b5331563fedf3f01014aba9c9e35d7f29 ]

The modules rfcomm (BT_RFCOMM), bnep (BT_BNEP), hidp (BT_HIDP), and
bluetooth_6lowpan (BT_6LOWPAN) are dependent on the bluetooth module
(BT, tristate) only transitively through the boolean BT_BREDR for the
first three and through the boolean BT_LE for the bluetooth_6lowpan.
Therefore, the modules can be selected as built-in even if the BT=m.
The combination of BT=m and =y for the said modules leads to the kernel
build system silently ignoring those modules, without ever compiling
them as built-in or as loadable modules.

Add BT as a direct dependency to the Kconfig of rfcomm, bnep, hidp, and
bluetooth_6lowpan. The modules set to =y when BT=m will default to =m,
rather then getting silently ignored by the build system.

Signed-off-by: Iva Kasprzaková <iva@yenya.net>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`pending-6.12`). The buggy Kconfig is
present here; the fix is a small, correct build/config change that
should be backported.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[Bluetooth] [fix] Make RFCOMM/BNEP/HIDP/6LoWPAN depend directly
on tristate CONFIG_BT so they cannot be =y when BT=m`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Signed-off-by: Iva Kasprzaková \<iva@yenya.net\> (author)
- Signed-off-by: Luiz Augusto von Dentz \<luiz.von.dentz@intel.com\>
  (Bluetooth maintainer)
- No Fixes:, Reported-by, Tested-by, Reviewed-by, Acked-by, Link:, or
  Cc: stable
- Absence of Fixes:/Cc: stable is expected for this review queue and is
  not a negative

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** RFCOMM, BNEP, HIDP, and 6LoWPAN depend on CONFIG_BT only
  through boolean `BT_BREDR` / `BT_LE`. A boolean that depends on a
  tristate is `y` when the tristate is `m`, so the protocol options can
  be `y` while `BT=m`.
- **Symptom:** Those protocols are silently not compiled (neither built-
  in nor as modules).
- **Fix:** Add `depends on BT` so `=y` with `BT=m` becomes `=m` and they
  actually build.
- **Version info:** None in the message. Root cause is kconfig
  tristate/bool transitivity.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. This is an explicit Kconfig/build correctness fix,
not cleanup-as-fix.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- `net/bluetooth/Kconfig`: `BT_6LOWPAN` `depends on BT_LE && 6LOWPAN` →
  `depends on BT && BT_LE && 6LOWPAN`
- `net/bluetooth/bnep/Kconfig`: `BT_BNEP` `depends on BT_BREDR` →
  `depends on BT && BT_BREDR`
- `net/bluetooth/hidp/Kconfig`: `BT_HIDP` `depends on BT_BREDR && HID` →
  `depends on BT && BT_BREDR && HID`
- `net/bluetooth/rfcomm/Kconfig`: `BT_RFCOMM` `depends on BT_BREDR` →
  `depends on BT && BT_BREDR`
- **Scope:** 4 files, 4 insertions / 4 deletions. Surgical Kconfig-only
  change.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record: Before, Kconfig allowed `BT=m` + protocol `=y`. After, `depends
on BT` forces the protocol to follow BT’s tristate (`m` if BT is `m`).
No C code or ABI change.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Build/Kconfig correctness** (documented stable exception:
build fix). Mechanism: `net/Makefile` has `obj-$(CONFIG_BT) +=
bluetooth/`. With `BT=m` the bluetooth directory is descended as a
module (`need-builtin` unset). `scripts/Makefile.lib` then does `obj-y
:= $(filter-out %/, $(obj-y))`, so `rfcomm/` / `bnep/` / `hidp/` listed
as `obj-y` are dropped and never built.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct (standard tristate `depends on` pattern).
Minimal. Regression risk is very low: the only configs that change are
invalid ones (`BT=m` + proto `=y`), which currently produce missing
modules; they become `=m` and actually work. No API or data-structure
change.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record: The broken `depends on BT_BREDR` / `depends on BT_LE` lines come
from **65efd2bf48853** (“Bluetooth: Introduce BT_BREDR and BT_LE config
options”, Marcel Holtmann, 2014-11-02). That commit replaced `depends on
BT` with the booleans. Present since ~v3.19; well before 6.12.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag. The introducing commit is in this tree (`git
merge-base --is-ancestor 65efd2bf48853 HEAD` succeeded). Upstream fix
SHA from patchwork: **646d8e385271** — **not** an ancestor of this HEAD.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- HIDP extra deps: **6cc90ccd4f6cf** (“HID: fix BT_HIDP Kconfig
  dependencies”, 2022) — **in this tree**. Local line is `depends on
  BT_BREDR && INPUT && HID_SUPPORT` plus `select HID`, not upstream’s
  `depends on BT_BREDR && HID`.
- CMTP still exists here (`depends on BT_BREDR && ISDN_CAPI &&
  DEPRECATED`) and has the same class of bug; this patch does not touch
  it (CMTP was later removed). Standalone otherwise; v2 only added
  6LoWPAN.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Iva Kasprzaková has no other commits in this tree’s bluetooth
history. Luiz von Dentz (SOB / applier) is the Bluetooth maintainer.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: No functional prerequisites. HIDP hunk needs a one-line context
tweak (`BT && BT_BREDR && INPUT && HID_SUPPORT`). RFCOMM, BNEP, and
6LoWPAN match this tree exactly.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- Lore/msgid:
  https://patch.msgid.link/20260722130849.7813-1-iva@yenya.net
- v1: 2026-07-20 \<20260720150919.9602-1-iva@yenya.net\>
- v2 (applied): 2026-07-22
- Luiz asked v1 to also cover `BT_6LOWPAN`; v2 did that. No NAKs. No
  reviewer `Cc: stable`. Applied to bluetooth-next as 646d8e385271; in
  bluetooth-next pull 2026-08-07.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: Recipients: Marcel Holtmann, Luiz von Dentz, linux-bluetooth.
Luiz requested the 6LoWPAN addition and applied v2. BlueZ CI:
CheckPatch/BuildKernel/IncrementalBuild PASS; mgmt/mesh tester fails
look pre-existing, not caused by this Kconfig change.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla. Author analysis plus maintainer
confirmation. **In-tree proof:** `arch/arm/configs/s5pv210_defconfig`
has `CONFIG_BT=m`, `CONFIG_BT_RFCOMM=y`, `CONFIG_BT_BNEP=y`.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Single-patch series. v1→v2 only added 6LoWPAN. Not part of a
larger refactor.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: gnuweeb stable search for this subject found no discussion of
this patch (unrelated “dependency” hits only).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: No C functions. Symbols: `BT_RFCOMM`, `BT_BNEP`, `BT_HIDP`,
`BT_6LOWPAN`. Build sites: `net/bluetooth/Makefile`
`obj-$(CONFIG_BT_RFCOMM)` etc., gated by `net/Makefile`
`obj-$(CONFIG_BT) += bluetooth/`.

**Step 5.2: TRACE CALLERS**
Record: RFCOMM: DUN/OBEX/serial. BNEP: PAN. HIDP: Bluetooth HID.
6LoWPAN: BLE IPv6. Reachable whenever those Kconfig options are enabled.

**Step 5.3: TRACE CALLEES**
Record: N/A (Kconfig only).

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Yes, userspace-visible: missing
`rfcomm`/`bnep`/`hidp`/`bluetooth_6lowpan` when the bad combo is set.
`s5pv210_defconfig` is a concrete in-tree trigger.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: `BT_CMTP` in this tree still `depends on BT_BREDR` only
(deprecated). Out of this patch’s scope.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.**
- `net/bluetooth/rfcomm/Kconfig:4` `depends on BT_BREDR`
- `net/bluetooth/bnep/Kconfig:4` `depends on BT_BREDR`
- `net/bluetooth/hidp/Kconfig:4` `depends on BT_BREDR && INPUT &&
  HID_SUPPORT`
- `net/bluetooth/Kconfig:86` `depends on BT_LE && 6LOWPAN`
Introduced 2014 (65efd2bf48853); still here. Fix 646d8e385271 is **not**
in HEAD.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Minor conflict on HIDP only** (this tree still has
INPUT/HID_SUPPORT + `select HID`). Other three hunks apply cleanly.
Expected backport: add `BT &&` on the local HIDP depends line.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No equivalent `depends on BT &&` on these four symbols.
6cc90ccd4f6cf only added HID_SUPPORT.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `net/bluetooth` Kconfig. **IMPORTANT** — Bluetooth stack, not
core mm/VFS, but RFCOMM/HIDP/BNEP are widely used.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Active (many Luiz fixes on this branch). The bug itself is old
(2014), not churn from a new subsystem.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Config-specific: `CONFIG_BT=m` and a protocol `=y`. Hits custom
configs, oldconfig `BT=y`→`m` transitions, and **s5pv210_defconfig** in
this tree. Distros that set all of them to `=m` are unaffected.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: At **build** time, not a runtime race. Unprivileged users cannot
trigger it; builders/defconfigs can. Likelihood: uncommon but **real**
(in-tree defconfig).

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Protocols silently omitted — no RFCOMM TTY/DUN, no PAN, no
Bluetooth HID, no BT 6LoWPAN. Not a panic. **MEDIUM–HIGH** functional
breakage; matches stable’s “build error” / “oh, that’s not good”.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** High for affected configs — modules actually get built
  (s5pv210 RFCOMM/BNEP included).
- **Risk:** Very low — 4 Kconfig depends lines; only invalid configs
  change, and they change toward working.
- **Ratio:** Favor backport.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real Kconfig/build bug: `BT=m` + proto `=y` drops
  rfcomm/bnep/hidp/6lowpan (verified in `scripts/Makefile.lib` via
  `need-builtin`).
- In-tree `s5pv210_defconfig` has that combo.
- Bug exists in 6.12 since 65efd2bf48853 (2014).
- Four one-line depends fixes; no new API.
- Maintainer-requested v2, applied by Luiz, CI build PASS.
- Matches stable “build fix” exception.

**AGAINST:**
- Not a crash/UAF/security bug.
- No Cc: stable (must not count as a negative here).
- Lived a long time; many distros use all-`=m`.
- HIDP hunk needs a one-line context adjust.
- CMTP in 6.12 has the same pattern and is not fixed (deprecated).

**UNRESOLVED:** Exact mainline commit that switched HIDP from `INPUT &&
HID_SUPPORT` + `select HID` to `depends on HID` (post-6.12); does not
change the `depends on BT` fix.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — standard depends; Luiz
   applied; build CI passed.
2. Fixes a real bug that affects users? **PASS** — silent missing
   Bluetooth protocols; s5pv210_defconfig.
3. Important issue? **PASS** — build/config omission of
   RFCOMM/BNEP/HIDP/6LoWPAN (severity MEDIUM–HIGH, not panic).
4. Small and contained? **PASS** — 4 lines, Kconfig only.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — 3/4 clean; HIDP needs
   `depends on BT && BT_BREDR && INPUT && HID_SUPPORT`.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Build fix** (Kconfig dependency). Qualifies.

**Step 9.4: DECISION**
Backport. The bug is in this 6.12 tree, the fix is surgical and correct,
and it restores Bluetooth protocol modules that kbuild currently throws
away.

---

### What the commit solves for this tree

With `CONFIG_BT=m`, kbuild visits `net/bluetooth/` without `need-
builtin`. Protocol dirs listed as `obj-y` are filtered out, so
RFCOMM/BNEP/HIDP/6LoWPAN never compile. Adding `depends on BT` forces
those symbols to `=m` when BT is a module, which is the working
configuration. That includes `arch/arm/configs/s5pv210_defconfig` in
this checkout.

### Stable rules / risk vs benefit

Meets the rules: obviously correct, real user-visible build bug, small,
no new API. Benefit is restoring missing Bluetooth profiles; risk is a
Kconfig depends tweak on configs that already did not build those
objects.

### Concerns

HIDP must be backported as `depends on BT && BT_BREDR && INPUT &&
HID_SUPPORT` (this tree does not yet use `depends on HID`). CMTP is left
as-is (deprecated, not in the upstream patch).

---

Verification:
- [Phase 1] Tags: author SOB Iva Kasprzaková; maintainer SOB Luiz; no
  Fixes/Reported-by/Cc: stable
- [Phase 2] Diff: four `depends on BT &&` additions in Kconfig only
- [Phase 2] Kbuild: `scripts/Makefile.lib` drops `obj-y` directories
  when `need-builtin` is unset; `net/Makefile` uses `obj-$(CONFIG_BT) +=
  bluetooth/`
- [Phase 3] blame: 65efd2bf48853 (2014) introduced `depends on
  BT_BREDR`/`BT_LE`; ancestor of HEAD
- [Phase 3] `git merge-base --is-ancestor 646d8e385271 HEAD` failed —
  fix not in this tree
- [Phase 3] HIDP in this tree is 6cc90ccd4f6cf (`INPUT && HID_SUPPORT`),
  not upstream `depends on HID`
- [Phase 4] b4 dig: v1 20260720150919.9602-1-iva@yenya.net, v2
  20260722130849.7813-1-iva@yenya.net
- [Phase 4] Luiz asked for BT_6LOWPAN on v1; v2 applied to bluetooth-
  next 646d8e385271
- [Phase 4] Recipients: Holtmann, Luiz, linux-bluetooth; no stable
  nomination
- [Phase 4] stable lore search: no discussion of this patch
- [Phase 6] `git describe HEAD`: p-6.12-3-g710455e2077bb; `make
  kernelversion`: 6.12.111
- [Phase 6] Local files still have the old depends lines
- [Phase 8] `arch/arm/configs/s5pv210_defconfig`: CONFIG_BT=m +
  CONFIG_BT_RFCOMM=y + CONFIG_BT_BNEP=y
- [Phase 8] Failure mode: protocols silently not built; severity
  MEDIUM–HIGH
- UNVERIFIED: exact later commit that rewrote HIDP to `depends on HID`
  (not required for the 6.12 backport)

**YES**

 net/bluetooth/Kconfig        | 2 +-
 net/bluetooth/bnep/Kconfig   | 2 +-
 net/bluetooth/hidp/Kconfig   | 2 +-
 net/bluetooth/rfcomm/Kconfig | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/Kconfig b/net/bluetooth/Kconfig
index 6b2b65a667008..86618afb855d3 100644
--- a/net/bluetooth/Kconfig
+++ b/net/bluetooth/Kconfig
@@ -83,7 +83,7 @@ config BT_LE_L2CAP_ECRED
 
 config BT_6LOWPAN
 	tristate "Bluetooth 6LoWPAN support"
-	depends on BT_LE && 6LOWPAN
+	depends on BT && BT_LE && 6LOWPAN
 	help
 	  IPv6 compression over Bluetooth Low Energy.
 
diff --git a/net/bluetooth/bnep/Kconfig b/net/bluetooth/bnep/Kconfig
index aac02b5b0d170..f8087e2d2c00e 100644
--- a/net/bluetooth/bnep/Kconfig
+++ b/net/bluetooth/bnep/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config BT_BNEP
 	tristate "BNEP protocol support"
-	depends on BT_BREDR
+	depends on BT && BT_BREDR
 	select CRC32
 	help
 	  BNEP (Bluetooth Network Encapsulation Protocol) is Ethernet
diff --git a/net/bluetooth/hidp/Kconfig b/net/bluetooth/hidp/Kconfig
index e08aae35351a7..ba52c7296f18f 100644
--- a/net/bluetooth/hidp/Kconfig
+++ b/net/bluetooth/hidp/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config BT_HIDP
 	tristate "HIDP protocol support"
-	depends on BT_BREDR && HID
+	depends on BT && BT_BREDR && HID
 	help
 	  HIDP (Human Interface Device Protocol) is a transport layer
 	  for HID reports.  HIDP is required for the Bluetooth Human
diff --git a/net/bluetooth/rfcomm/Kconfig b/net/bluetooth/rfcomm/Kconfig
index 9b9953ebf4c02..e7af2d565cea8 100644
--- a/net/bluetooth/rfcomm/Kconfig
+++ b/net/bluetooth/rfcomm/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config BT_RFCOMM
 	tristate "RFCOMM protocol support"
-	depends on BT_BREDR
+	depends on BT && BT_BREDR
 	help
 	  RFCOMM provides connection oriented stream transport.  RFCOMM
 	  support is required for Dialup Networking, OBEX and other Bluetooth
-- 
2.53.0

