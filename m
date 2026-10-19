Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262F064234F;
	Mon, 19 Oct 2026 14:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418777; cv=none; b=Kfa/ZUBHmmX7nmf+BVP4cxBjV31OT3CvzuJm4tCHQzBYmqPskbdWBnhinaW1+nareM04dsxP2FQ0jUXa2Ib2s5PtsfUOa28lhn8Qj1ilVryjBMOmLnu4jtvP1dZVLj5OYqIzZi5YsLLDpuc3TjdsE6Drn/DZx1H1X0behg0oFhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418777; c=relaxed/simple;
	bh=Z6rRgUDqoTPhXOWUBBJmlcPobv6lwEgJ5SzQ14hZGCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BDBDCO04mwm9CbwrXIpdcmTFtew6NW4MNaGcik4GP61VoW2tOHIz7SsDcaqpNW9p0SCDBybMqeU/8vE30Z5iZg4DPHP3k8I4vI3qXMw/gQXStKmp66hcaDRuIJ6Jg19ko4c2m/JigV2CsH6pDBXm+w5x6B0lxplFc3LH7RNnBog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LWPfA+iY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LWPfA+iY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269D61F000C7;
	Mon, 19 Oct 2026 14:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418775;
	bh=+5V9mU+RXqdOADrsld+Cp1WhwgJ5e4PE7jhOOwElKns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LWPfA+iYmWJKJAAZY3O4sSV/Ap9Rwy5O4HGKw9hpqH1qr3SBnXLW3p11a9wh+6nTe
	 usfjUE/Hjwl1ihme3esX8VU5cSFDFHEGXgTBjNNjvrT3JgNisNR+nWULC6Ig379T1f
	 kLkB0lZg+6zarsUll/sXfJ27nQMQ2mOg9at5xTlJM+KWajKTxEHWHgPdArbNKNbyhE
	 Qqt/KeXCTAc7yZn+dLJuS0F29j/UpydC+klZtxD06pXt8ZQJMSBVDv2L8ySWxp5NJ0
	 258DCWhwN8XW6cIB8myLRzafhXrFG76wJWRYM4a/+iYF9CaOGMgGAYBDqA4pVWiat0
	 o3DGU6IQdPs/w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Muralidhara M K <muralidhara.mk@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	naveenkrishna.chatradhi@amd.com,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] platform/x86/amd/hsmp: Validate ACPI UID before parsing socket index
Date: Mon, 19 Oct 2026 09:52:58 -0400
Message-ID: <20261019135441.1420968-487-sashal@kernel.org>
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

From: Muralidhara M K <muralidhara.mk@amd.com>

[ Upstream commit 4c7d1b4cd75a775326e6802608440f7642284ea6 ]

hsmp_get_uid() passed the device UID directly to kstrtou16(uid + 2)
without checking it.  A NULL UID or one shorter than three characters
would dereference a NULL pointer or read past the end of the string.

Reject such UIDs with -EINVAL before stripping the "ID" prefix.

Signed-off-by: Muralidhara M K <muralidhara.mk@amd.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/20260625123337.886435-3-muralidhara.mk@amd.com
Link: https://patch.msgid.link/20260629155634.1807598-2-muralidhara.mk@amd.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This checkout is **Linux 7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). The
analysis is whether `4c7d1b4cd75a7` (“Validate ACPI UID before parsing
socket index”) is a technically sound stable backport for this tree’s
HSMP ACPI driver.

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
- Record: `[platform/x86/amd/hsmp] [Validate] Reject NULL/short ACPI
  UIDs before `kstrtou16(uid + 2)``

**Step 1.2 — Tags**
- Record:
  - `Signed-off-by: Muralidhara M K <muralidhara.mk@amd.com>` (author;
    AMD HSMP contributor)
  - `Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>` (pdx86
    maintainer)
  - `Link: https://patch.msgid.link/20260625123337.886435-3-
    muralidhara.mk@amd.com` (earlier series)
  - `Link: https://patch.msgid.link/20260629155634.1807598-2-
    muralidhara.mk@amd.com` (applied v2 1/4)
  - `Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>`
    (maintainer apply)
  - No `Fixes:`, no `Reported-by:`, no `Cc: stable` (absence is expected
    for this review)
  - Ignore any pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit
    ...]` markers

**Step 1.3 — Body**
- Record: Bug = `hsmp_get_uid()` calls `kstrtou16(uid + 2)` with no
  check. Symptom = NULL deref if UID is NULL, or read past the string if
  UID is shorter than three characters. Root cause = missing validation
  before stripping the `"ID"` prefix. No version range or reproducer in
  the message.

**Step 1.4 — Hidden bug fix?**
- Record: Not hidden. It is an explicit memory-safety check. The series
  cover letter calls it “ACPI input hardening,” which is still a real
  NULL/OOB fix, not style cleanup.

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
- Record: One file, `drivers/platform/x86/amd/hsmp/acpi.c`, **+3**
  (include + 2-line check). Function: `hsmp_get_uid()`. Scope: single-
  file surgical fix.

**Step 2.2 — Code flow**
- Record: Before: `uid = acpi_device_uid(ACPI_COMPANION(dev)); return
  kstrtou16(uid + 2, 10, sock_ind);`
  After: if `uid` is NULL or `strlen(uid) < 3`, return `-EINVAL`; else
  same parse.
  Path: ACPI HSMP probe / `init_acpi()`, not a hot path.

**Step 2.3 — Bug mechanism**
- Record: **NULL pointer dereference + out-of-bounds string read.**
  - `acpi_device` is `kzalloc`’d (`drivers/acpi/scan.c`), so
    `pnp.unique_id` starts NULL.
  - `unique_id` is only set when `ACPI_VALID_UID` (`kstrdup` of `_UID`).
    Missing `_UID`, or `kstrdup` failure, leaves NULL.
  - `acpi_device_uid()` is `#define acpi_device_uid(d)
    ((d)->pnp.unique_id)` — can be NULL.
  - `kstrtou16()` → `_parse_integer_fixup_radix()` reads `s[0]`
    immediately. NULL `uid` is a kernel oops.
  - UID shorter than 2 characters (`"0"`, `"1"`, `""`) makes `uid + 2`
    past the NUL; `kstrtou*` walks until NUL → heap overread.
  - `strlen == 2` (`"ID"`) is conservatively rejected; `kstrtou16("")`
    would have returned `-EINVAL` anyway.

**Step 2.4 — Fix quality**
- Record: Obviously correct and minimal. Valid `"ID00"`/`"ID01"` UIDs
  are unchanged. Regression risk is very low: probe fails with `-EINVAL`
  instead of oopsing. No API/locking/refcount change. Does not check the
  `"ID"` prefix itself; that is leftover firmware-format assumption, not
  a regression.

## Phase 3: Git history

**Step 3.1 — Blame**
- Record: Buggy `kstrtou16(uid + 2)` came from `ba8dcff0e9c4f` (“Add
  support for ACPI based probing”, Suma Hegde, 2024-01-06). Landed in
  **v6.9** (in v6.9, not in v6.8). Later moved unchanged in
  `969f915473d8c` (v6.13 directory split). Present for many releases.

**Step 3.2 — Fixes: tag**
- Record: None. Introducer is `ba8dcff0e9c4f`, ancestor of this HEAD.

**Step 3.3 — File history**
- Record: Nearby commits are later HSMP hardening (`0d7a266449453` _DSD
  count, `e5e511f5d9e05` data-plane gate). This patch is **standalone**;
  it does not need those.

**Step 3.4 — Author**
- Record: Muralidhara M K is a regular AMD HSMP author. Reviewed and
  applied by pdx86 maintainer Ilpo Järvinen.

**Step 3.5 — Dependencies**
- Record: None. Only uses existing `acpi_device_uid`, `strlen`,
  `kstrtou16`. Can apply by itself to any tree that has
  `hsmp_get_uid()`.

## Phase 4: Mailing list / external

**Step 4.1 — Original discussion**
- Record: `b4 dig -c 4c7d1b4cd75a7` matched
  https://patch.msgid.link/20260629155634.1807598-2-
  muralidhara.mk@amd.com
  Revisions: included in a larger 2026-06-25 series, then **v1 1/4**
  (2026-06-29) and **v2 1/4** of “ACPI input hardening and data-plane
  readiness gating.” Applied version is v2 1/4. No NAKs. Cover letter:
  Patches 1–2 validate ACPI input; this one is the UID check. Ilpo
  applied the series to `review-ilpo-next` and noted fixes go via for-
  next unless they are current-rc regressions — so not treated as a hot
  -rc regression, but still accepted as a real fix. No `Cc: stable` in
  the thread.

**Step 4.2 — Recipients (`b4 dig -w`)**
- Record: Ilpo Järvinen, `platform-driver-x86@vger.kernel.org`, `linux-
  kernel@vger.kernel.org`. Right maintainer and list.

**Step 4.3 — Bug report**
- Record: No syzbot/bugzilla/`Reported-by`. Bug is described from code
  review, not a user crash dump.

**Step 4.4 — Series**
- Record: v2 1/4 is self-contained. Later patches ( _DSD bounds, device
  threading, readiness gate) are separate bugs. This one does not need
  them.

**Step 4.5 — Stable list**
- Record: lore.kernel.org returned 403 via WebFetch. Thread mbox from
  `b4 dig -m` has **no** stable discussion. UNVERIFIED whether it was
  later requested on stable@.

## Phase 5: Semantic / call graph

**Step 5.1 — Functions**
- Record: `hsmp_get_uid()` only.

**Step 5.2 — Callers**
- Record: Only `init_acpi()` → `hsmp_acpi_probe()`
  (`platform_driver.probe`). Probe/init context, one call site.

**Step 5.3 — Callees**
- Record: `ACPI_COMPANION()`, `acpi_device_uid()`, `strlen()`,
  `kstrtou16()`.

**Step 5.4 — Reachability**
- Record: Triggered when `CONFIG_AMD_HSMP_ACPI` probes HID
  `ACPI_HSMP_DEVICE_HID` (AMD EPYC/MI300A HSMP ACPI). Not a syscall.
  Unprivileged users cannot inject ACPI `_UID`. Firmware with
  missing/short `_UID` (or numeric `_UID` like `"0"`) oopses at probe
  instead of failing the driver.

**Step 5.5 — Similar patterns**
- Record: Core ACPI already NULL-checks UID in
  `acpi_dev_uid_to_integer()` (`if (!uid) return -ENODATA`). HSMP was
  missing that same guard.

## Phase 6: This tree

**Step 6.1 — Buggy code here?**
- Record: Yes. File and `hsmp_get_uid()` exist. The 2-line check is
  already present at lines 97–98 because this commit **is an ancestor of
  HEAD**. Introduced v6.9; this is 7.3-rc4, so the driver and the bug
  (pre-fix) belong to this lineage.

**Step 6.2 — Backport difficulty**
- Record: Clean apply. `hsmp_get_uid()` body has been stable since v6.9
  aside from this check. This 7.3 tree already has extra includes from
  later commits; the three-line change itself is trivial.

**Step 6.3 — Other fix already here?**
- Record: This *is* the fix. No alternate UID validation exists besides
  these two lines.

## Phase 7: Subsystem

**Step 7.1**
- Record: `drivers/platform/x86/amd/hsmp` — AMD Host System Management
  Port. **PERIPHERAL / IMPORTANT for AMD server users**, not core
  mm/vfs. Used on EPYC and MI300A.

**Step 7.2**
- Record: Actively maintained (many 2026 HSMP commits by Muralidhara).
  Driver itself is mature since v6.9.

## Phase 8: Impact and risk

**Step 8.1 — Who**
- Record: Config- and firmware-specific: `CONFIG_AMD_HSMP_ACPI` on AMD
  servers whose BIOS exposes the HSMP ACPI object.

**Step 8.2 — Trigger**
- Record: Driver probe. Common on matching hardware with **correct**
  `"IDxx"` UID (then the new check is a no-op). Crash only if `_UID` is
  missing, empty, or shorter than 3 characters. Not a userspace trigger.
  Realistic for incomplete ACPI (VMs, BIOS bugs, numeric `_UID`).

**Step 8.3 — Failure mode**
- Record: Kernel oops on NULL deref or KASAN-class OOB read during
  probe. **Severity: HIGH** (crash). Not data corruption. Not a local
  privilege-escalation path by itself.

**Step 8.4 — Risk/benefit**
- Record: Benefit: prevent oops, fail probe cleanly. Risk: very low (3
  lines, error path only, valid firmware unchanged). Ratio strongly
  favors applying it.

## Phase 9: Synthesis

**Evidence FOR**
- Real NULL deref and string OOB, confirmed in `kstrtox` and ACPI UID
  init.
- 3-line, obviously correct check; same pattern as
  `acpi_dev_uid_to_integer()`.
- Reviewed and applied by the pdx86 maintainer.
- Standalone; no series dependencies.
- Driver and buggy code exist in this tree (since v6.9).
- Oops during probe is worse than `-EINVAL` probe failure.

**Evidence AGAINST**
- No user/`syzbot` report; found by review, framed as hardening.
- Trigger needs bad/non-spec `_UID`; production AMD BIOS should use
  `ID00`/`ID01`.
- Peripheral driver, not core.
- Maintainer routed it through for-next, not as an urgent -rc
  regression.

**Unresolved**
- Could not fetch lore.kernel.org HTML (403); used `b4 dig` mbox
  instead.
- No stable@ thread found in that mbox.

**Stable rules**
1. Obviously correct and tested? **PASS** — 2-line guard; W=1/checkpatch
   per cover letter; maintainer Reviewed-by.
2. Real user-visible bug? **PASS** — oops/OOB on missing or short
   `_UID`.
3. Important (crash/security/corruption)? **PASS** — probe-time kernel
   oops; HIGH, not theoretical UAF in a hot path.
4. Small and contained? **PASS** — +3 lines, one function.
5. No new features/APIs? **PASS**.
6. Applies to this tree? **PASS** — `hsmp_get_uid()` is here; change is
   trivial.

**Exception category:** none required; this is a normal small crash-
prevention fix.

This is a surgical memory-safety check in an existing driver. It does
not add features, does not need later series patches, and turns a
firmware-table oops into a failed probe. That meets stable criteria for
this tree.

Verification:
- [Phase 1] Parsed tags: Reviewed-by Ilpo; two msgid.link URLs; no
  Fixes/Reported-by/Cc: stable
- [Phase 2] Diff: +3 lines in `hsmp_get_uid()`; include `linux/string.h`
  + NULL/strlen check
- [Phase 2] Confirmed `kstrtou16` → `_parse_integer_fixup_radix()` reads
  `s[0]`
- [Phase 2] Confirmed `acpi_device` kzalloc and `unique_id` only set if
  `ACPI_VALID_UID`
- [Phase 3] `git describe HEAD` / `make kernelversion`: v7.3-rc4 /
  7.3.0-rc4
- [Phase 3] `git merge-base --is-ancestor 4c7d1b4cd75a7 HEAD`: yes
- [Phase 3] Blame: buggy parse from `ba8dcff0e9c4f` (v6.9); check from
  `4c7d1b4cd75a7`
- [Phase 3] `git merge-base --is-ancestor ba8dcff0e9c4f v6.9`: yes; not
  in v6.8
- [Phase 4] `b4 dig -c 4c7d1b4cd75a7`: lore URL and v2 1/4 series
- [Phase 4] `b4 dig -a`: 2026-06-25 series, then v1/v2 4-patch hardening
  series
- [Phase 4] `b4 dig -w`: Ilpo + platform-driver-x86
- [Phase 4] mbox: Ilpo applied 1/4; no NAK; no Cc: stable
- [Phase 4] WebFetch lore.kernel.org: 403 — used mbox instead
- [Phase 5] Callers: `init_acpi()` ← `hsmp_acpi_probe()` only
- [Phase 6] Current `acpi.c` already has the two-line check
- [Phase 8] Failure mode: NULL deref / OOB on probe → oops; valid `IDxx`
  unchanged
- UNVERIFIED: later stable@ requests beyond this thread mbox

**YES**

 drivers/platform/x86/amd/hsmp/acpi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/amd/hsmp/acpi.c b/drivers/platform/x86/amd/hsmp/acpi.c
index d0b74d243ce4c..674be31654776 100644
--- a/drivers/platform/x86/amd/hsmp/acpi.c
+++ b/drivers/platform/x86/amd/hsmp/acpi.c
@@ -21,6 +21,7 @@
 #include <linux/kstrtox.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/string.h>
 #include <linux/sysfs.h>
 #include <linux/uuid.h>
 
@@ -78,6 +79,8 @@ static inline int hsmp_get_uid(struct device *dev, u16 *sock_ind)
 	 * bytes to integer.
 	 */
 	uid = acpi_device_uid(ACPI_COMPANION(dev));
+	if (!uid || strlen(uid) < 3)
+		return -EINVAL;
 
 	return kstrtou16(uid + 2, 10, sock_ind);
 }
-- 
2.53.0

