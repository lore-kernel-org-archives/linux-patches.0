Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820AA528E9C;
	Mon, 19 Oct 2026 14:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418584; cv=none; b=ib4tOwTrlSyLkxTq4AQiC/CjHl4GN3fJBqP0gs0KJWJbdxU9jzYXJ3j5IXXqVSAM5aD67shls7U0le48YJDEE7AQfAAIICoTAMDvGNX2V/gyWaH1egbMPlO5hsnz/wB732Y5ordzw+84xoCMTMtlMv60O3DxJ4N40PjB36nJN1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418584; c=relaxed/simple;
	bh=WDzIbKo4KLjrS4lSNJREq6bBYJ+b6B6bMFaHdQRkxYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b4zYS85R4l46CoJC4khq0V9LGM0Hg4koj2wbpOrVKk9HIs1Hyn2s+ZqfUnOxltOGSjWgWKIIQvaF7DK7VN+BhRwQKFAmjyxqu3jZKWTwUv1iYSmzIihhl7yXYaN5hwdonWQLWPDSK62bReYOg3JsPvqR5zx6637y50XFztxME7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MIFVaIj3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MIFVaIj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574001F000C4;
	Mon, 19 Oct 2026 14:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418581;
	bh=6cgidK+zeGuACZ/n/MWCuGvUglgmjVNS9L7Qx+HPLZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MIFVaIj3glebXWQ4T5nUShQiZcEkLUA9LwB/KsPHIEICRTfmbk2xo4h3h5Yv9ruCx
	 1+b3jhrx9KdA6M9v8idMarMj9hnFS6daJ2oSUFINa+a5RWy5EMSDja5s/CGoRI9GS+
	 SZGN2FGvqsZCIoDuI3glMdNs86bXngIr7w3fmVfSZO4ftiVojrM8TTYhJ8avgZ+0GU
	 XFw5n23qUC/GlqiKBQemD3ze4/rTTjFOip5W9YWge2mvA3xGy+dhUTVO/+ji8VMYlk
	 Z4dhRosRf1DSn5MiTA17LKPzTe2ZCNyx0noNFR9XcyoZzTSv4PpLgqoFrXFYwQchYd
	 +m7FDHWKHAeHA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>,
	hjc@rock-chips.com,
	andyshrk@163.com,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-rockchip@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] drm/rockchip: dw_hdmi: Use resume_early pm ops for system suspend
Date: Mon, 19 Oct 2026 09:50:40 -0400
Message-ID: <20261019135441.1420968-349-sashal@kernel.org>
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

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit af3a9eadc11896f6677bcb7102bfb7c84be48d2d ]

rockchip_drm_sys_resume()/drm_mode_config_helper_resume() is called
before the resume pm ops of dw-hdmi. This result in an atomic_enable()
before dw_hdmi_rockchip_resume()/dw_hdmi_resume() is called.

Resume (without changes):
- rockchip_drm_sys_resume()
  - drm_mode_config_helper_resume()
    - atomic_enable()
- dw_hdmi_rockchip_resume()
  - dw_hdmi_resume()
    - dw_hdmi_init_hw()

Change to use resume_early pm ops for system suspend to ensure pm ops
for dw-hdmi is run before rockchip-drm pm ops. Also fix a possible NULL
pointer dereference timing issue while at it.

Resume (with changes):
- dw_hdmi_rockchip_resume_early()
  - dw_hdmi_resume()
    - dw_hdmi_init_hw()
- rockchip_drm_sys_resume()
  - drm_mode_config_helper_resume()
    - atomic_enable()

Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Tested-by: Heiko Stuebner <heiko@sntech.de> #rk3328
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20260518193748.2482823-12-jonas@kwiboo.se
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have the 6.18.y picture: the buggy resume path is in v6.18.53, the
patch is self-contained, and the DSI sibling already uses the same
late/early PM ordering. Compiling the full nine-phase verdict next.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [drm/rockchip: dw_hdmi] [Use] [switch HDMI system-resume
callback to resume_early so dw-hdmi re-inits before rockchip-drm
atomic_enable]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Tested-by: Heiko Stuebner <heiko@sntech.de> #rk3328 (Rockchip DRM
  maintainer; hardware-tested)
- Signed-off-by: Jonas Karlman <jonas@kwiboo.se> (author)
- Signed-off-by: Heiko Stuebner <heiko@sntech.de> (subsystem maintainer
  applied it)
- Link:
  https://patch.msgid.link/20260518193748.2482823-12-jonas@kwiboo.se
- No Fixes:, Reported-by, Reviewed-by, Acked-by, or Cc: stable (absence
  expected)
- Ignore pipeline tags: [Upstream commit
  af3a9eadc11896f6677bcb7102bfb7c84be48d2d], Signed-off-by: Sasha Levin

Notable: maintainer Tested-by on real RK3328 hardware.

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: on system resume, `rockchip_drm_sys_resume()` →
  `drm_mode_config_helper_resume()` → atomic enable runs before
  `dw_hdmi_resume()` → `dw_hdmi_init_hw()`.
- Symptom: HDMI hardware (DDC I2C, HPD, interrupt mutes) is restored
  after DRM has already tried to re-enable the display pipeline.
- Secondary: “possible NULL pointer dereference timing issue” — resume
  can run with NULL drvdata.
- No stack trace, syzbot report, or CVE. Author gave simulated-suspend
  (`pm_test`) and `rtcwake` test steps in the mailing-list version.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not disguised. It is an explicit PM-ordering fix plus a NULL
check. It was patch 11/11 of a series titled “Misc cleanup and propagate
bus format”, and was added in v2; the other patches are unrelated
cleanups/prep. This hunk is a standalone bug fix.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c` (+4/-3, 7 lines)
- Functions: `dw_hdmi_rockchip_resume` renamed to
  `dw_hdmi_rockchip_resume_early`; `dw_hdmi_rockchip_pm` table
- Scope: single-file surgical PM-ops change

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: `.resume` (normal phase) unconditionally calls
  `dw_hdmi_resume(hdmi->hdmi)`.
- After: `.resume_early` (early phase) calls it only if
  `dev_get_drvdata()` is non-NULL.
- `SET_SYSTEM_SLEEP_PM_OPS(NULL, resume)` →
  `SET_LATE_SYSTEM_SLEEP_PM_OPS(NULL, resume_early)`.
- Suspend remains NULL. Hibernation thaw/restore move from thaw/restore
  to thaw_early/restore_early, matching the same ordering intent.

Resume phase order is resume_noirq → resume_early → resume. HDMI
therefore always re-inits before rockchip-drm’s `.resume`.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Primary: logic/correctness + hardware resume ordering. Sibling `dw-
  mipi-dsi-rockchip.c` already uses `SET_LATE_SYSTEM_SLEEP_PM_OPS` with
  the comment that it must run before `rockchip_drm_drv` re-enables
  panels.
- Secondary: memory safety — NULL check before `hdmi->hdmi` dereference
  when the platform device has probed (`component_add`) but not bound
  (`platform_set_drvdata` is in bind, not probe).

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: Linux PM runs all `resume_early` callbacks before
  any `.resume`. That is the standard way to order a component ahead of
  the DRM master.
- Minimal; no API or data-structure change.
- Regression risk low: same pattern as the in-tree DSI sibling; only
  resume is registered; `dw_hdmi_init_hw()` only re-inits mutes, DDC
  I2C, and HPD.
- NULL check does not cover `hdmi->hdmi` being `ERR_PTR` after a failed
  bind; that is a leftover hole, not a regression from this patch.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Buggy resume path introduced by `27c9130baef543` (“drm/rockchip:
  dw_hdmi: Handle suspend/resume”, Douglas Anderson, 2019-06-04), first
  in v5.3-rc1.
- That commit is an ancestor of this tree.
- That commit already documented the failure on rk3288 Chromebooks (HDMI
  HPD and DDC I2C stop working after suspend) and that Chrome OS 3.14
  used late/early PM ops because VOP sometimes resumed before dw-hdmi.
  Mainline used normal `.resume` because the author could not reproduce
  it then. This patch is the proper late/early fix for that known issue.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. The introducing commit is `27c9130baef543`,
present here.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- Only two resume-related commits on this file: 27c9130baef543 (add
  resume) and this one.
- Recent 6.18.y file history is unrelated (SCLIN mask, FIELD_PREP,
  whitespace).
- Series-local neighbors (output_port, whitespace, empty helpers) are
  not functional prerequisites of this hunk.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Jonas Karlman is a regular Rockchip HDMI/dw-hdmi contributor.
Heiko Stuebner (maintainer) applied the series and tested it on rk3328.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record:
- Series v2 11/11; cover letter says patches 1–10 are cleanup / YCbCr-
  Deep Color prep. Patch 11 only changes PM ops.
- `SET_LATE_SYSTEM_SLEEP_PM_OPS` exists in this tree’s
  `include/linux/pm.h`.
- `dw_hdmi_resume()` exists in `drivers/gpu/drm/bridge/synopsys/dw-
  hdmi.c`.
- Applies standalone. No missing helpers.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- b4 dig:
  https://patch.msgid.link/20260518193748.2482823-12-jonas@kwiboo.se
- v1 (2026-05-10): 10 patches, no resume_early change
- v2 (2026-05-18): this patch added (“v2: New patch”)
- Applied by Heiko 2026-06-02 as
  `af3a9eadc11896f6677bcb7102bfb7c84be48d2d`
- No NAK. No reviewer asked for further revisions of this hunk.
- Author included CONFIG_PM_DEBUG / rtcwake test instructions and noted
  a separate RK356x EHCI/OHCI clock issue, not this bug.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: Recipients included Heiko Stuebner, Sandy Huang, Andy Yan, DRM
maintainers, dri-devel, linux-rockchip. Heiko tested and applied. No
other Acked-by/Reviewed-by on this patch.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla link. Real-world grounding is the 2019
Chromebook report in 27c9130baef543 plus Heiko’s rk3328 Tested-by.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone vs the rest of the v2 series. DSI sibling
`e584cdc154993` (“drm/rockchip: dsi: Reconfigure hardware on resume()”)
used the same late PM ops and had Cc: stable.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: UNVERIFIED. lore.kernel.org/stable returned an Anubis bot-check
page; WebFetch to lore returned 403.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `dw_hdmi_rockchip_resume_early` (was `dw_hdmi_rockchip_resume`);
`dw_hdmi_rockchip_pm`.

Step 5.2: TRACE CALLERS
Record: Invoked by the PM core as `dev_pm_ops.resume_early` on the
`dwhdmi-rockchip` platform driver. Triggered by system suspend/resume
(and freeze/thaw/restore via LATE_SYSTEM_SLEEP_PM_OPS). Not a syscall
hot path; it is the Chromebook/SBC sleep path.

Step 5.3: TRACE CALLEES
Record: `dev_get_drvdata` → `dw_hdmi_resume` → `dw_hdmi_init_hw` →
`initialize_hdmi_ih_mutes`, `dw_hdmi_i2c_init`, optional
`phy.ops->setup_hpd`.

Step 5.4: FOLLOW THE CALL CHAIN
Record:
- Userspace: `echo mem > /sys/power/state` / rtcwake / systemd suspend.
- DRM side: `rockchip_drm_sys_resume` → `drm_mode_config_helper_resume`
  → `drm_atomic_helper_resume` (atomic commit / enable).
- HDMI platform device is a component, not a child of the DRM device;
  sibling `.resume` order is not guaranteed. `platform_set_drvdata` is
  in `dw_hdmi_rockchip_bind`, while probe only does `component_add`, so
  resume-before-bind can see NULL drvdata.
- Reachable on any Rockchip board with this HDMI IP and CONFIG_PM_SLEEP
  (RK3288/RK3328/RK3399/RK3568, including Chromebooks).

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record:
- `dw-mipi-dsi-rockchip.c` already uses
  `SET_LATE_SYSTEM_SLEEP_PM_OPS(NULL, dw_mipi_dsi_rockchip_resume)` in
  this tree for the same reason.
- `dw_hdmi_qp-rockchip.c` still uses `SET_SYSTEM_SLEEP_PM_OPS`
  (different HDMI QP IP, not this patch).
- imx8mp and meson dw-hdmi glue still use normal SYSTEM_SLEEP PM ops.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- Local tree: `git describe HEAD` = v6.18.53-5049-g0f0bdc2b0dffb; `make
  kernelversion` = 6.18.53 (6.18.y).
- v6.18.53 still has:
  `SET_SYSTEM_SLEEP_PM_OPS(NULL, dw_hdmi_rockchip_resume)`
  and `dw_hdmi_resume(hdmi->hdmi)` with no NULL check
  at `drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c`.
- Bug present since v5.3 (2019), long before 6.18 branched.
- Upstream commit `af3a9eadc11896` is not an ancestor of HEAD (`git
  merge-base --is-ancestor` failed); this is a backport candidate, not
  already in 6.18.y proper.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Clean apply. The resume function in v6.18.53 is identical to the
parent of this change. `SET_LATE_SYSTEM_SLEEP_PM_OPS` and
`dw_hdmi_resume()` already exist here. Surrounding unbind/bridge-ref
changes from later series patches are not required.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No other resume-ordering fix on this file. DSI already has the
analogous LATE PM ops. No earlier version of this HDMI fix in 6.18.53.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: DRM Rockchip HDMI glue (`drivers/gpu/drm/rockchip/`). IMPORTANT
(common SoC display, not core mm/fs). Affects
RK3288/RK3328/RK3399/RK356x HDMI (Chromebooks, SBCs, TV boxes).

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Mature driver (HDMI glue since ~2015). Resume path untouched
from 2019 until this patch. Low churn on the PM ops themselves.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver-specific / platform-specific. Users of Rockchip dw-hdmi
who suspend the system. CONFIG_PM_SLEEP. Not universal, but a well-used
platform class in Android, Chromebook, and ARM SBCs.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record:
- Trigger: system suspend/resume with this HDMI driver bound (and the
  NULL path if probed but unbound).
- Common on laptops/Chromebooks; less so on always-on appliances.
- Unprivileged users typically cannot suspend; the HPD/I2C break is
  still a real admin/user-visible failure after lid-close/sleep.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- Primary: HDMI HPD and DDC I2C not restored before DRM atomic enable →
  hotplug/EDID/output broken after resume. HIGH for affected hardware
  (display not coming back is a serious functional bug), not a kernel
  panic.
- Secondary: NULL deref if resume runs before bind → oops. Less common.
  HIGH if hit, MEDIUM likelihood.
- Overall: HIGH (suspend/resume display breakage on real hardware).

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: high for Rockchip HDMI suspend users; restores the ordering
  Chrome OS already needed.
- Risk: very low (7 lines, established LATE PM pattern already in the
  same DRM driver).
- Ratio: favor backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real resume-ordering bug: DRM atomic enable before
  `dw_hdmi_init_hw()`.
- User-visible: HDMI HPD/DDC broken after sleep (documented on rk3288
  Chromebooks in 2019; re-tested on rk3328 in 2026).
- Same fix already used by dw-mipi-dsi-rockchip in this tree, and that
  DSI change went to stable with Cc: stable.
- Possible NULL deref on resume before bind.
- 7-line surgical change; applies cleanly to v6.18.53.
- Maintainer Tested-by and Signed-off-by.
- Buggy code has been in this tree since v5.3; no missing prerequisites.

AGAINST:
- No Fixes:/Cc: stable (expected for this pipeline; not a negative).
- Buried as 11/11 in a cleanup series (but the hunk is independent and
  was added specifically in v2).
- Not a panic/corruption/CVE; display-after-suspend rather than a crash.
- No extra Reviewed-by besides maintainer apply/test.
- UNVERIFIED whether stable@ already discussed rejecting it.

UNRESOLVED:
- lore.kernel.org/stable search blocked (Anubis/403).
- Incomplete NULL check if bind failed and left `hdmi->hdmi` as ERR_PTR
  (pre-existing).

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — PM phase ordering is well-
   defined; Heiko tested on rk3328.
2. Fixes a real bug that affects users? PASS — HDMI not correctly re-
   inited before DRM resume; Chromebook-class hardware.
3. Important issue (crash, security, corruption, deadlock)? PASS —
   suspend/resume display breakage plus a possible oops; hardware resume
   workaround, same class as the DSI stable fix.
4. Small and contained? PASS — 7 lines, one file.
5. No new features or APIs? PASS.
6. Can apply to the local tree? PASS — v6.18.53 has the old resume
   function and the LATE PM macro.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Hardware suspend/resume workaround on an existing driver (quirk-
class). Not a new driver, ID, or API.

Step 9.4: MAKE YOUR DECISION
This belongs on 6.18.y. The buggy `.resume` path is in this checkout,
the switch to `resume_early` is the same proven pattern as the in-tree
DSI sibling, and the patch is tiny with maintainer hardware testing.

What it solves for stable users: after system sleep on Rockchip dw-hdmi
boards, DRM can re-enable the pipeline before HDMI DDC/HPD/init, so
hotplug and HDMI output fail. Moving the callback to `resume_early`
forces `dw_hdmi_init_hw()` first, and skips a NULL drvdata deref if the
component never bound.

Risk is low; benefit is a real resume fix on shipping SoCs. No series
dependencies are required for this hunk.

Verification:
- [Phase 1] Parsed tags: Tested-by Heiko (rk3328), SOB Jonas + Heiko,
  Link msgid ...-12; no Fixes/Reported-by/Cc:stable
- [Phase 1] Cover letter via b4 mbox: patch 11/11 of v2 “Misc cleanup”;
  “v2: New patch”; Heiko “Series: Tested-by” and Applied
- [Phase 2] Diff: rename resume→resume_early, add `if (hdmi)`,
  SET_SYSTEM_SLEEP→SET_LATE_SYSTEM_SLEEP; +4/-3
- [Phase 2] Confirmed LATE_SYSTEM_SLEEP_PM_OPS maps resume_fn to
  `.resume_early` in include/linux/pm.h:321-327,350-351
- [Phase 2] Confirmed rockchip_drm_drv.c:260-262 still uses
  SET_SYSTEM_SLEEP_PM_OPS for sys_resume
- [Phase 2] drm_mode_config_helper_resume() calls
  drm_atomic_helper_resume() (drm_modeset_helper.c:250)
- [Phase 3] git blame parent: resume added in 27c9130baef543 (Douglas
  Anderson, 2019)
- [Phase 3] git show 27c9130baef543: documented Chromebook HPD/I2C break
  and Chrome OS late/early PM ops
- [Phase 3] git describe --contains 27c9130baef543 → v5.3-rc1; git
  merge-base --is-ancestor 27c9130baef543 HEAD → yes
- [Phase 3] git log --oneline --grep resume_early --
  drivers/gpu/drm/rockchip/ → only this commit
- [Phase 4] b4 dig -c af3a9eadc11896: lore thread found; v1 had no this
  patch; v2 added it; applied as af3a9eadc11896
- [Phase 4] b4 dig -a: v1 2026-05-10, v2 2026-05-18
- [Phase 4] b4 dig -w: Heiko, dri-devel, linux-rockchip CC’d
- [Phase 4] b4 dig -m /tmp/thread.mbox: no NAKs; Heiko tested+applied
- [Phase 4] lore.kernel.org WebFetch 403; stable search Anubis-blocked →
  UNVERIFIED stable@ discussion
- [Phase 5] Callers: PM core resume_early on dwhdmi-rockchip; callees
  dw_hdmi_resume→dw_hdmi_init_hw
- [Phase 5] platform_set_drvdata in bind (line 580), probe only
  component_add — NULL drvdata on unbound resume is real
- [Phase 5] Sibling dw-mipi-dsi-rockchip.c:1346 already
  SET_LATE_SYSTEM_SLEEP_PM_OPS in this tree; introduced by e584cdc154993
  with Cc: stable
- [Phase 6] git describe HEAD: v6.18.53-5049-g0f0bdc2b0dffb; make
  kernelversion 6.18.53
- [Phase 6] git show v6.18.53:dw_hdmi-rockchip.c has
  SET_SYSTEM_SLEEP_PM_OPS + unchecked dw_hdmi_resume
- [Phase 6] git merge-base --is-ancestor af3a9eadc11896 HEAD → no (not
  in 6.18.y proper)
- [Phase 6] Resume hunk in v6.18.53 identical to parent of this change;
  SET_LATE and dw_hdmi_resume exist in v6.18.53
- [Phase 8] Failure mode: HDMI broken after suspend (HIGH); possible
  NULL oops (HIGH if hit)
- UNVERIFIED: whether stable@ previously rejected this patch (lore
  blocked)

**YES**

 drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c b/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
index 727cdf768161a..ff34aeef3a6ff 100644
--- a/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
@@ -635,17 +635,18 @@ static void dw_hdmi_rockchip_remove(struct platform_device *pdev)
 	component_del(&pdev->dev, &dw_hdmi_rockchip_ops);
 }
 
-static int __maybe_unused dw_hdmi_rockchip_resume(struct device *dev)
+static int __maybe_unused dw_hdmi_rockchip_resume_early(struct device *dev)
 {
 	struct rockchip_hdmi *hdmi = dev_get_drvdata(dev);
 
-	dw_hdmi_resume(hdmi->hdmi);
+	if (hdmi)
+		dw_hdmi_resume(hdmi->hdmi);
 
 	return 0;
 }
 
 static const struct dev_pm_ops dw_hdmi_rockchip_pm = {
-	SET_SYSTEM_SLEEP_PM_OPS(NULL, dw_hdmi_rockchip_resume)
+	SET_LATE_SYSTEM_SLEEP_PM_OPS(NULL, dw_hdmi_rockchip_resume_early)
 };
 
 struct platform_driver dw_hdmi_rockchip_pltfm_driver = {
-- 
2.53.0

