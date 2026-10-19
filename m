Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB26D4F185F;
	Mon, 19 Oct 2026 13:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418360; cv=none; b=XIH2VPCpAsGOmMkP+rsJvo4+7XlpqswVzDANu2rEkXioBBT3Pf6rr2zpWdBZXk31pYLX5sBMYaeySrB0gWKfH9TN1ZzSZY2a7oM0I76EYL89iOj3dEjjXtJzSv9UcB7XhB6ibIWH3t2cxfBI0Ff3VdN2nSwMwfk8lv/6Ujj++lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418360; c=relaxed/simple;
	bh=0KbxphkeODaSEDyNeYXSFWGb0RaeSpFxXIwDgHjEAz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O/Vuxssa7cqJ0RN+BJQW/Elu9utqacZMh1VM0xqcEXhaRWqgdgn5M4A32vsqiIGoKGtQpTaEecxfxSBQVKO0gLKmBjWJNpEBDFjbRTifQ9nnh5hX1MtX4/x4Dvbdf1Fem1SdcQh7t3J2v4ygyI0N1YSG6D1eNaxHgsN+axHDYiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JiP7bD93; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JiP7bD93"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA0F1F000C7;
	Mon, 19 Oct 2026 13:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418357;
	bh=1AKUpDJZQ0cu+3G2w9NcNnSdUdk3ZgI/qmO+33iDkz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JiP7bD93qPE9WA9e38XYoKSlZLw1t2pLBVFtmIFZrTJtP6H2a/cXYniMofqnzYnaY
	 suZ7dcrYKFQVoeqHevU4JR4sLlnafIbNYx8ry2fl8dLew6XfC6F/wwc8Uc8rx9i5Gv
	 AkjZdsXEyNjAtao19RlWYNaNWJjpH1bRNrwTOkR43IPLT28ay0RdQmJ5M+ecOHNp6c
	 L6TgC3J+iCKVa8COewC7T2HDtCphtmwQNcKsV0E1G8Cx/wNnMMZsIGxQ7bV2ZYO+Zb
	 QyLlQJnkQEQ96Cs2rM/qGSCsnRdq7tIhRGLTtJtWhXajVFUDbZcns29T2OB26kcC4+
	 LkiPt9ZOF0C1g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Marcos Paulo Medeiros <maarcospm1996@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	rafael@kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ACPI: video: force native backlight on Acer Nitro AN515-46
Date: Mon, 19 Oct 2026 09:48:01 -0400
Message-ID: <20261019135441.1420968-190-sashal@kernel.org>
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

From: Marcos Paulo Medeiros <maarcospm1996@gmail.com>

[ Upstream commit 525ba51157ac6e1772b5412eae26b20dd7ef8bda ]

The Acer Nitro AN515-46 is a hybrid graphics laptop whose internal
panel is driven by the AMD GPU (Radeon 680M); the discrete NVIDIA GPU
only drives external outputs. The firmware nevertheless advertises the
NVIDIA WMI EC backlight GUID, so the backlight type resolves to
nvidia_wmi_ec. The nvidia-wmi-ec-backlight driver however fails to
probe ("EC backlight control failed: AE_NOT_FOUND") and, since the
backlight type is still nvidia_wmi_ec, amdgpu skips registering its
own backlight device. The result is no backlight device at all,
leaving the brightness keys and the desktop brightness slider
non-functional.

Booting with acpi_backlight=native makes amdgpu register its backlight
interface and brightness control works. Add a DMI quirk to use the
native backlight on this model by default.

Signed-off-by: Marcos Paulo Medeiros <maarcospm1996@gmail.com>
Link: https://patch.msgid.link/20260727132151.12792-1-maarcospm1996@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a DMI hardware quirk for a real backlight failure on the Acer
Nitro AN515-46. The buggy detection path, amdgpu skip, and Rembrandt GPU
support are all present in this 6.12.111 tree, and the 8-line table
entry matches the existing quirk pattern.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [ACPI: video] [force] [DMI quirk to use native backlight on Acer
Nitro AN515-46]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Marcos Paulo Medeiros (author)
- Link: https://patch.msgid.link/20260727132151.12792-1-
  maarcospm1996@gmail.com
- Signed-off-by: Rafael J. Wysocki (ACPI maintainer; applied the patch)
- No Fixes:, Reported-by, Tested-by, Reviewed-by, Acked-by, or Cc:
  stable (absence of the last two is expected for this review)
- Ignored: any pipeline-added Sasha Levin SOB / Upstream commit markers

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: hybrid AMD+NVIDIA laptop; internal panel is AMD Radeon 680M;
  firmware still advertises the NVIDIA WMI EC backlight GUID.
- Detection then returns `nvidia_wmi_ec`. `nvidia-wmi-ec-backlight`
  probe fails with "EC backlight control failed: AE_NOT_FOUND". Because
  the type stays `nvidia_wmi_ec`, amdgpu does not register a native
  backlight device.
- Symptom: no backlight device; brightness keys and the desktop slider
  do nothing.
- Workaround: `acpi_backlight=native` lets amdgpu register and
  brightness works.
- Root cause: firmware advertises NVIDIA EC backlight that does not
  actually work; autodetection prefers it over native AMD backlight.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not disguised. This is an explicit hardware-quirk bugfix: force
native backlight so the working GPU interface is used.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/acpi/video_detect.c` (+8 / −0)
- Function: static table `video_detect_dmi_table[]` (not a code-path
  change)
- Scope: single-file surgical DMI entry; callback is existing
  `video_detect_force_native`

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: this product is not in the table, so autodetection can select
  `nvidia_wmi_ec`.
- After: DMI match on vendor "Acer" / product "Nitro AN515-46" sets
  `acpi_backlight_dmi = acpi_backlight_native`.
- Path: init-time DMI check in `__acpi_video_get_backlight_type()`,
  which already prefers DMI over nvidia_wmi_ec autodetection.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: hardware workaround (DMI quirk)
- Mechanism: firmware reports NVIDIA EC backlight;
  `nvidia_wmi_ec_supported()` is true; type becomes
  `acpi_backlight_nvidia_wmi_ec`; GPU drivers then skip native
  registration via `acpi_video_backlight_use_native()`; the WMI EC
  driver fails probe; result is zero backlight devices.
- Fix: DMI override to native, which is checked before the nvidia_wmi_ec
  special case.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: same pattern as Dell G15 5515, Vostro 15 3535,
  Lenovo 82K8 already in this file.
- Minimal: 8 lines, one model, existing callback.
- Regression risk: very low; only that DMI product string is affected.
  Native is the workaround the author already confirmed.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: Insertion is after the HP OMEN 16-n0xxx native quirk
(`5b8d6a94f2e2c` in this tree). Surrounding native-force entries have
been in this file for many releases. `video_detect_force_native()` is
long-standing (lines 129–133).

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Bug is firmware/autodetect interaction, not a
single introducing commit. Related infrastructure:
- `fe7aebb40d42b` "ACPI: video: Add Nvidia WMI EC brightness control
  detection" — in this tree (`git merge-base --is-ancestor` exit 0);
  first in v6.1-rc1.
- `da11ef832972e` "drm/amdgpu: Don't register backlight when another
  backlight should be used" — in this tree; first in v6.1-rc1.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Recent `video_detect.c` commits on this branch are the same
class of DMI quirks (HP OMEN 16, Lenovo 82K8, Dell OptiPlex AIOs). No
missing refactor prerequisite. Standalone DMI addition, not a series.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Marcos Paulo Medeiros has this one ACPI video commit on
origin/master. Applied by Rafael J. Wysocki (ACPI maintainer). Hans de
Goede (backlight-detect author) was CCed.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Needs `acpi_backlight_nvidia_wmi_ec`,
`video_detect_force_native`, and GPU
`acpi_video_backlight_use_native()`. All exist here. Applies standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- Lore/msgid: https://patch.msgid.link/20260727132151.12792-1-
  maarcospm1996@gmail.com
- `b4 dig -a`: v1 only; no later revision.
- Thread: submission + Rafael "Applied as 7.3 material, thanks!" — no
  NAK, no requested changes.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): To Rafael J. Wysocki; Cc Len Brown, Hans de Goede,
linux-acpi. Maintainer applied it. No reviewer-flagged risk.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla link. Author describes a concrete device
failure and a working cmdline workaround. A later AN515-58 patch cites
the same nvidia_wmi_ec failure mode on a sibling model (not in this
commit).

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone 1/1. Same class as Dell G15 5515 ("nvidia-ec-wmi
present but should not use it") already in this file.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable search returned 403. UNVERIFIED whether
stable@ discussed this specific SHA. Not used as a negative signal.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: Table-only change. Callback: `video_detect_force_native()`.
Consumers: `__acpi_video_get_backlight_type()`,
`acpi_video_backlight_use_native()`, `nvidia_wmi_ec_backlight_probe()`,
`amdgpu_dm_register_backlight_device()`.

Step 5.2: TRACE CALLERS
Record:
- `dmi_check_system(video_detect_dmi_table)` at `video_detect.c:1013`
  during first `__acpi_video_get_backlight_type()`.
- `acpi_video_backlight_use_native()` called from amdgpu_dm, amdgpu
  atombios encoders, i915, nouveau, radeon, gma500 — GPU backlight
  registration.
- `nvidia_wmi_ec_backlight_probe()` refuses to bind unless type is
  `acpi_backlight_nvidia_wmi_ec`.

Step 5.3: TRACE CALLEES
Record: `video_detect_force_native()` only assigns `acpi_backlight_dmi =
acpi_backlight_native`. No alloc/lock/I/O.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Boot/GPU probe on this laptop → `nvidia_wmi_ec_supported()` true
(SOURCE=EC) → type nvidia_wmi_ec → amdgpu skips (`Skipping amdgpu DM
backlight registration`) → WMI probe calls LEVEL and hits `EC backlight
control failed: AE_NOT_FOUND` (exact string in `nvidia-wmi-ec-
backlight.c:52`) → no backlight device. Userspace brightness is broken.
Reachable on normal laptop use, not a fuzzer-only path.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same `video_detect_force_native` + NVIDIA EC mismatch already
used for Dell G15 5515, Vostro 15 3535, Lenovo 82K8 in this file.
Systematic firmware issue, not a one-off pattern.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes, this is pending-6.12 / 6.12.111 (`git describe HEAD` =
p-6.12-1-gf9fa14938873a).
- `acpi_backlight_nvidia_wmi_ec` in `include/acpi/video.h`
- `nvidia_wmi_ec_supported()` / return nvidia_wmi_ec in
  `video_detect.c:1044-1045`
- `nvidia-wmi-ec-backlight.c` present
- amdgpu skip at `amdgpu_dm.c:4843`
- Rembrandt/680M: `CHIP_YELLOW_CARP` PCI IDs `0x164D` and `0x1681` in
  `amdgpu_drv.c`
- No existing "Nitro AN515-46" entry

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Clean apply. Upstream hunk sits after HP OMEN 16-n0xxx and
before the "x86 android tablets" comment; that exact sequence is at
lines 912–922 here.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: Related nvidia_wmi_ec native quirks exist (Dell G15, Lenovo
82K8). This model is not covered. `git log --grep=AN515 --
drivers/acpi/video_detect.c` is empty.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: ACPI video backlight detection (`drivers/acpi/video_detect.c`).
IMPORTANT: laptop brightness on hybrid AMD/NVIDIA systems. Not core
mm/scheduler, but a common user-visible path.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Actively maintained; many DMI quirks already landed on this 6.12
branch. Mature table plus ongoing per-model entries.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver/platform-specific: Acer Nitro AN515-46 only (DMI
vendor+product). No effect on other machines.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Every boot on that model with default autodetection. No race.
Unprivileged users hit it via brightness keys/slider; they cannot fix it
without `acpi_backlight=native`.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: No backlight device; brightness control dead. Not a panic/UAF.
Severity MEDIUM–HIGH for that hardware (panel brightness unusable).
Matches the hardware-quirk exception.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: high for this 2022 Rembrandt+NVIDIA laptop — restores
  brightness without a cmdline workaround.
- Risk: very low — 8-line DMI entry, existing callback, DMI-gated.
- Ratio: strongly favorable.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real user-visible bug: no backlight on a shipping hybrid laptop.
- Mechanism exists in 6.12 (nvidia_wmi_ec detect + amdgpu skip + WMI
  probe failure).
- GPU (Radeon 680M / Yellow Carp) is supported here.
- 8-line DMI quirk using an existing helper; same pattern as quirks
  already on this branch.
- Applies cleanly.
- ACPI maintainer applied v1 with no objections; Hans de Goede CCed.
- Hardware quirk is an explicit stable exception.

AGAINST:
- No Fixes:/Cc: stable (expected; not a negative).
- One reporter (the author).
- Does not fix a crash/UAF; only brightness on one model.

UNRESOLVED:
- Could not read lore.kernel.org/stable (403). Does not change the
  technical case.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — existing callback; author
   confirmed `acpi_backlight=native`; maintainer applied.
2. Fixes a real bug that affects users? PASS — brightness keys/slider
   dead on this model.
3. Important issue? PASS — hardware quirk restoring essential display
   brightness (stable exception).
4. Small and contained? PASS — +8 lines, one DMI entry.
5. No new features or APIs? PASS.
6. Can apply to the local tree? PASS — matching context in this 6.12
   tree.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Hardware quirk/workaround (DMI native-backlight override for
broken NVIDIA WMI EC advertisement). Qualifies.

Step 9.4: MAKE YOUR DECISION
Backport to this 6.12.111 tree. The bug, the skip path, and the GPU
support are all here; the fix is the standard low-risk DMI quirk.

Verification:
- [Phase 1] Parsed tags: author SOB, Rafael SOB, msgid.link; no
  Fixes:/Reported-by/Cc: stable
- [Phase 1] Body: nvidia_wmi_ec selected, WMI probe AE_NOT_FOUND, amdgpu
  skips, no backlight device
- [Phase 2] Diff: +8 lines in `video_detect_dmi_table[]`,
  `video_detect_force_native` for Acer / Nitro AN515-46
- [Phase 2] Precedence verified: DMI return at
  `video_detect.c:1037-1038` is before nvidia_wmi_ec at 1044-1045
- [Phase 3] `git merge-base --is-ancestor 525ba51157ac6 HEAD` → not in
  this tree (candidate)
- [Phase 3] `fe7aebb40d42b` (nvidia_wmi_ec detect) is ancestor of HEAD;
  contained in v6.1-rc1
- [Phase 3] `da11ef832972e` (amdgpu skip native) is ancestor of HEAD;
  contained in v6.1-rc1
- [Phase 3] Similar quirks already here: HP OMEN 16, Lenovo 82K8, Dell
  G15 5515
- [Phase 4] `b4 dig -c 525ba51157ac6`: https://patch.msgid.link/20260727
  132151.12792-1-maarcospm1996@gmail.com
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: Rafael, Len Brown, Hans de Goede, linux-acpi
- [Phase 4] mbox: Rafael "Applied as 7.3 material, thanks!" — no NAK
- [Phase 4] UNVERIFIED: stable@ lore search (HTTP 403)
- [Phase 5] amdgpu skip: `amdgpu_dm.c:4843` `if
  (!acpi_video_backlight_use_native())`
- [Phase 5] WMI error string matches commit: `nvidia-wmi-ec-
  backlight.c:52` "EC backlight control failed: %s"
- [Phase 5] Callers of `acpi_video_backlight_use_native()`: amdgpu,
  i915, nouveau, radeon, gma500
- [Phase 6] `git describe HEAD` / `make kernelversion`: pending-6.12,
  6.12.111
- [Phase 6] Enum includes `acpi_backlight_nvidia_wmi_ec`; `nvidia-wmi-
  ec-backlight.c` exists
- [Phase 6] Rembrandt 680M IDs present: `0x1681` `CHIP_YELLOW_CARP` in
  `amdgpu_drv.c`
- [Phase 6] No "Nitro AN515-46" in this tree; HP OMEN + android-tablet
  context matches the hunk
- [Phase 8] Failure mode: no backlight device on this DMI model, not a
  kernel oops
- Note: an earlier probe of this workspace showed pending-5.10; the
  checkout used for the verdict is pending-6.12 / 6.12.111 as required

The patch is a small DMI quirk, the failure is real on this 6.12 tree,
and regression risk is limited to one product string.

**YES**

 drivers/acpi/video_detect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 2a562cb425081..2b48b02f8a953 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -917,6 +917,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "OMEN by HP Gaming Laptop 16-n0xxx"),
 		},
 	},
+	{
+	 .callback = video_detect_force_native,
+	 /* Acer Nitro AN515-46 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Nitro AN515-46"),
+		},
+	},
 
 	/*
 	 * x86 android tablets which directly control the backlight through
-- 
2.53.0

