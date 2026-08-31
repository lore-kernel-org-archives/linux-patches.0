Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB51352A2E3;
	Mon, 31 Aug 2026 13:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183879; cv=none; b=mRUFi9ULFCn+MsSYKIy4Aewu0Yjxn1V+XXg9lCwMiTfK7O1IoRfL0wfi8FR5q638BYLB+XSuYnTYyS/iTE9FOT4Y5HHX131NdklcPsqM04fwpnm3dtUqoMNaLcZc8sdcIQaiaisvVdEeK3643VXrhorCCqikxtkpX/h0+M/C65Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183879; c=relaxed/simple;
	bh=sU3mqGD6Yv9vpBjFJ+rAUnYV2pIoGf8U1cilLIrzAqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Eo4d0R5Rtsyei2Ueh00hlISkeNMzMGSyUbisQ3C0oiqSXF9jUoLiiC2FyJABRHFnDplROfGm9zGmTzc9MLaweaH80TBLzNIO2Ovsoa/zPoJkyqND5kC7i0v8ONFIuZA7v4fwzlsJ4SG5bXpmrPds2lYP2NN6a9yzqoV/8vmF4Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HFQdH1yM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HFQdH1yM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75FEF1F00A3D;
	Mon, 31 Aug 2026 13:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183876;
	bh=J2Jw5sWgvHqjZIXUDjEAfq88hH8ePVNKIO0/CdBgR+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HFQdH1yMQyq4n128Db5+CAniGv2huDq54zGRQpsncq+Zqt4os0kItfg7znKoFZfZ6
	 ta/vz9YS/ywBhLP1POsTVG9lv6V5TPf9hddDhemaE2S2LXZzQmik8vu/7QHdE9fYer
	 dc7GvRn6k9dUn4Hz9NvWSqytq7lz70JtsqTVVRDMeAMMIiGYmrDMPY8s0zYGxb10J9
	 R2jUr5nLZa/GpIn3pODM29KPlEMj6PiTAfqqtmuUFfxLto6dquJ9zAxnUkMMouXet2
	 b/8McsGPxA+rQb1zUPVZ4y5MxL004q9qjJPIjji4j36GIVStSCac+1bydARx/uLtez
	 Gtchvv/91NvXw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>,
	simona@ffwll.ch,
	maddy@linux.ibm.com,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 6.18] fbdev: Wrap user-invoked calls to fb_set_var() in helper
Date: Mon, 31 Aug 2026 09:26:24 -0400
Message-ID: <20260831133314.4125787-356-sashal@kernel.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 6f611e5e5f3327cf2e2daabe6ee5acac58cc784e ]

Handle fbcon during display updates in fb_set_var_from_user(). Check
with fbcon if the mode change is possible, update hardware state and
finally update fbcon. Update all callers.

Only the FBIOPUT_VSCREENINFO ioctl currently does all steps. Other
mode-changes callers in sysfs and driver code are missing fbcon-related
steps.

With the new helper, ps3fb and sh_mobile_lcdcfb no longer maintain
fbcon state themselves.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `fbdev: Wrap user-invoked calls to
fb_set_var() in helper`

**Local tree:** `v6.18.44` (6.18.y stable)
**Commit under review:** `6f611e5e5f3327cf2e2daabe6ee5acac58cc784e` (not
in HEAD; present as git object, applies cleanly)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[fbdev]` `[wrap/consolidate]` — Introduce
`fb_set_var_from_user()` helper and route all user-invoked mode-change
paths through it.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Thomas Zimmermann `<tzimmermann@suse.de>` (author)
- **Signed-off-by:** Helge Deller `<deller@gmx.de>` (fbdev maintainer)
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, `Link:`,
  `Reviewed-by:`, `Tested-by:`, or `Acked-by:` tags

Notable: maintainer sign-off; absence of stable tag is expected for
manual review.

### Step 1.3: Body analysis
**Record:**
- **Bug described:** Only `FBIOPUT_VSCREENINFO` ioctl performs the full
  fbcon sequence (`fbcon_modechange_possible` → `fb_set_var` →
  `fbcon_update_vcs`). Sysfs mode-change paths and driver ioctl/reconfig
  paths skip the `fbcon_modechange_possible` check.
- **Symptom/failure mode:** Incomplete fbcon synchronization on mode
  changes; missing validation that resolution is not smaller than
  console font size.
- **Version info:** None in message.
- **Root cause:** Inconsistent fbcon handling across user-facing entry
  points after the ioctl-only fix from 2022.

### Step 1.4: Hidden bug fix detection
**Record:** Yes — despite refactor-style wording, this completes a real
correctness/safety gap. The original `fbcon_modechange_possible()`
commit (`e64242caef18b`, 2022) explicitly warned that undersized
resolutions cause character rendering to access memory outside the
graphics region. That check was ioctl-only; sysfs and driver paths
remained vulnerable.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Change inventory
**Record:**
| File | Change |
|------|--------|
| `fb_chrdev.c` | −5/+1 |
| `fbcon.c` | −2 (remove exports) |
| `fbmem.c` | +13 (new helper) |
| `fbsysfs.c` | −3/+1 |
| `ps3fb.c` | −4/+1 |
| `sh_mobile_lcdcfb.c` | −4/+1 |
| `include/linux/fb.h` | +2 |

**Functions modified:** `do_fb_ioctl()`, `activate()`,
`fb_set_var_from_user()` (new), `ps3fb_ioctl()`,
`sh_mobile_fb_reconfig()`
**Scope:** Small, multi-file but tightly focused consolidation.

### Step 2.2: Code flow per hunk
**Record:**
1. **`fb_chrdev.c` / `FBIOPUT_VSCREENINFO`:** Three-step inline sequence
   → single `fb_set_var_from_user()` call. Behavior unchanged.
2. **`fbmem.c`:** New helper encapsulates the three-step sequence.
3. **`fbsysfs.c` / `activate()`:** Before: `fb_set_var` +
   `fbcon_update_vcs` (no validation). After: `fb_set_var_from_user`
   (adds `fbcon_modechange_possible`).
4. **`ps3fb.c`:** Same — gains validation via helper; drops direct
   `fbcon.h` usage.
5. **`sh_mobile_lcdcfb.c`:** Before: `fb_set_var` then separate
   `fbcon_update_vcs`. After: single helper call with validation.
6. **`fbcon.c`:** Removes `EXPORT_SYMBOL` / `EXPORT_SYMBOL_GPL` from
   `fbcon_update_vcs` and `fbcon_modechange_possible`.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Memory safety / logic correctness (OOB access prevention
  + fbcon state consistency).
- **Mechanism:** `fbcon_modechange_possible()` rejects resolutions where
  font width/height exceeds effective `xres`/`yres` (with rotation).
  Sysfs (`store_mode`, `store_rotate`, `store_virtual`, `store_bpp` via
  `activate()`) and ps3fb/sh_mobile paths bypassed this check.
  Undersized modes could proceed to `fb_set_var` and fbcon rendering,
  risking out-of-bounds framebuffer access — the same failure mode
  documented in `e64242caef18b`.

### Step 2.4: Fix quality
**Record:**
- Fix is obviously correct: extracts ioctl’s already-proven three-step
  pattern.
- Minimal, no unrelated changes.
- **Regression risk:** Low for in-tree code. Removing exports of
  `fbcon_update_vcs` / `fbcon_modechange_possible` could affect out-of-
  tree GPL modules; in-tree users (`ps3fb`, `sh_mobile_lcdcfb`) are
  updated in the same patch. ps3fb/sh_mobile may now reject mode changes
  that previously succeeded but were unsafe — intentional behavior
  change.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- `fb_chrdev.c:88-92`: Added in `588b35634a5aa` (Thomas Zimmermann,
  2023) with full three-step sequence.
- `fbsysfs.c:23-25`: `fb_set_var` since 2005; `fbcon_update_vcs` added
  in `d88ca7e1a27eb` (2020, syzbot OOB fix); never gained
  `fbcon_modechange_possible`.
- **Bug introduced:** Gap since `e64242caef18b` (Jun 2022) when
  validation was ioctl-only.

### Step 3.2: Fixes tag
**Record:** N/A — no `Fixes:` tag. Related fix `e64242caef18b` is in
this tree (`git merge-base --is-ancestor` confirms).

### Step 3.3: Related file history
**Record:**
- `e64242caef18b` — ioctl-only font-size validation (Cc: stable # v5.4+)
- `d88ca7e1a27eb` — syzbot OOB in `vc_do_resize`, pulled
  `fbcon_update_vcs` out of `fb_set_var`
- Recent stable-relevant fbcon fixes in tree: OOB/null-ptr fixes
  (`076b1aa65f77a`, `6617df8c24631`)
- **Standalone:** Patch 1/4 of “Internalize fbcon” series; does not
  require patches 2–4 to function.

### Step 3.4: Author context
**Record:** Thomas Zimmermann is active fbdev/fbcon maintainer. Helge
Deller (co-author of original `fbcon_modechange_possible`) signed off.

### Step 3.5: Dependencies
**Record:** No prerequisite commits required.
`fbcon_modechange_possible` and `fbcon_update_vcs` exist in tree. `git
apply --check` passes cleanly on 6.18.44.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **b4 dig URL:**
  https://patch.msgid.link/20260527151551.258659-2-tzimmermann@suse.de
- **Series revisions:** v1 (2026-05-20), v2 (2026-05-22), v3
  (2026-05-27) — committed version is v3.
- **WebFetch of lore:** Blocked by Anubis bot protection; could not read
  full thread.
- **From search snippets:** AI review noted ps3fb gains
  `fbcon_modechange_possible` check as intentional behavioral change.

### Step 4.2: Reviewers
**Record:** CC list includes Helge Deller, Geert Uytterhoeven, Simona
Vetter, airlied, linux-fbdev, dri-devel, linuxppc-dev — appropriate
subsystem coverage.

### Step 4.3: Bug reports
**Record:** No direct bug report in this commit. Underlying issue
matches `e64242caef18b` rationale (OOB framebuffer access). Related
syzbot fix `d88ca7e1a27eb` addressed a different fbcon/OOB path.

### Step 4.4: Series context
**Record:** Part of 4-patch “fbdev: Internalize fbcon” series. Patches
2–4 handle `fb_blank_from_user` and unexporting fbcon symbols more
broadly. This patch is self-contained for the `fb_set_var` path.

### Step 4.5: Stable list history
**Record:** UNVERIFIED — could not search lore stable list due to fetch
blocking. Original `e64242caef18b` was explicitly nominated `Cc:
stable@vger.kernel.org # v5.4+`.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `fb_set_var_from_user()` (new), `activate()`,
`do_fb_ioctl()`, `ps3fb_ioctl()`, `sh_mobile_fb_reconfig()`.

### Step 5.2: Callers
**Record:**
- `activate()` ← `store_mode`, `store_bpp`, `store_rotate`,
  `store_virtual` (sysfs, root-writable framebuffer attributes)
- `do_fb_ioctl()` ← `FBIOPUT_VSCREENINFO` (userspace ioctl on
  `/dev/fb*`)
- `ps3fb_ioctl()` ← `PS3FB_IOCTL_SETMODE` (PS3 platform)
- `sh_mobile_fb_reconfig()` ← `sh_mobile_lcdc_release()` on display
  hotplug/reconfig (SH Mobile embedded)

### Step 5.3: Callees
**Record:** `fbcon_modechange_possible()` → `fb_set_var()` →
`fbcon_update_vcs()`. Requires `console_lock()` + `lock_fb_info()` at
all call sites (already present).

### Step 5.4: Reachability
**Record:**
- Sysfs paths: reachable by privileged users (root) on any system with
  framebuffer sysfs nodes.
- Ioctl: reachable by users with framebuffer device access.
- ps3fb/sh_mobile: platform-specific but real hardware paths.
- **Userspace triggerable:** Yes (sysfs/ioctl, privileged).

### Step 5.5: Similar patterns
**Record:** ioctl path in `fb_chrdev.c` already had the correct three-
step pattern since 2022/2023. Sysfs and drivers were the inconsistent
outliers.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current tree at `fbsysfs.c:23-25` calls
`fb_set_var` + `fbcon_update_vcs` without `fbcon_modechange_possible`.
Same gap in `ps3fb.c:833-835` and `sh_mobile_lcdcfb.c:1768-1772`. Commit
`6f611e5` is **NOT** in HEAD.

### Step 6.2: Backport complications
**Record:** `git apply --check` on commit patch: **clean apply**. No
structural conflicts observed.

### Step 6.3: Related fixes already present?
**Record:** `e64242caef18b` (ioctl-only validation) is in tree. No
`fb_set_var_from_user` or equivalent consolidation. Gap remains open.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/video/fbdev` / `fbcon` — **IMPORTANT** (framebuffer
console on servers, embedded, legacy platforms; less universal than
mm/net but affects console stability).

### Step 7.2: Activity
**Record:** Actively maintained — recent fixes include UAF, null-ptr-
deref, and OOB fixes in fbdev/fbcon on this branch.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of fbdev with active fbcon text console who change
modes via sysfs or affected drivers (not only ioctl). Embedded (SH
Mobile), PS3, and general framebuffer sysfs users.

### Step 8.2: Trigger conditions
**Record:** Set framebuffer mode/rotation/virtual resolution via sysfs
to a value smaller than current console font dimensions while fbcon is
active in text mode. Requires privileged access. Not everyday, but
realistic for admin tooling and embedded hotplug scenarios.

### Step 8.3: Failure mode severity
**Record:** Out-of-bounds framebuffer memory access during console
character rendering → potential kernel oops, memory corruption.
**Severity: HIGH** (same class as the 2022 ioctl fix that went to
stable).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH — closes a known validation gap left by incomplete
  application of `e64242caef18b`.
- **Risk:** LOW — ~37 lines, behavior matches existing ioctl path;
  applies cleanly.
- **Ratio:** Strong benefit, low risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Fixes real OOB/corruption-class bug (documented in `e64242caef18b`)
- Completes ioctl-only fix from 2022 across sysfs and driver paths
- Small, surgical, applies cleanly to 6.18.44
- Maintainer sign-off (Helge Deller)
- Same bug class previously deemed stable-worthy (`Cc: stable` on
  original)
- Privileged userspace can trigger via sysfs

**AGAINST backport:**
- Adds new exported helper `fb_set_var_from_user` (kernel-internal, not
  userspace API)
- Removes exports of `fbcon_update_vcs` / `fbcon_modechange_possible`
  (minor ABI concern for OOT modules)
- Part of larger “internalize fbcon” series (but functionally
  standalone)
- No syzbot/user bug report for this specific gap

**Unresolved:** Full lore review thread content (fetch blocked).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic mirrors proven ioctl
   path; maintainer SOB.
2. Fixes real bug affecting users? **PASS** — sysfs/driver paths lack
   font-size validation.
3. Important issue? **PASS** — OOB memory access / potential crash or
   corruption (**HIGH**).
4. Small and contained? **PASS** — 7 files, ~37 lines net.
5. No new features/APIs? **PASS** (with nuance) — new kernel helper
   export only; no userspace API; behavior fix not feature addition.
6. Can apply to local tree? **PASS** — `git apply --check` succeeds.

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Qualifies
as a correctness/memory-safety bug fix.

### Step 9.4: Problem summary for stable users
When the 2022 fix added `fbcon_modechange_possible()` to prevent console
font rendering past framebuffer bounds, it was wired only into the
`FBIOPUT_VSCREENINFO` ioctl. Sysfs mode/rotation/virtual-resolution
writes and ps3fb/sh_mobile driver paths still allowed undersized modes,
risking the same out-of-bounds access. This commit routes all user-
invoked `fb_set_var` paths through one helper that performs validation,
hardware update, and fbcon refresh — closing that gap on 6.18.y.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body; no Reported-by/syzbot/Fixes
  tags.
- **[Phase 1]** Identified hidden bug fix via cross-reference to
  `e64242caef18b` message.
- **[Phase 2]** Diff inventory: 7 files, functions listed; bug = missing
  `fbcon_modechange_possible` on non-ioctl paths.
- **[Phase 3]** `git describe HEAD` → `v6.18.44`; `make kernelversion` →
  `6.18.44`.
- **[Phase 3]** `git blame` on `fb_chrdev.c:86-92` and
  `fbsysfs.c:16-26`.
- **[Phase 3]** `git show e64242caef18b` — original OOB rationale and
  ioctl-only placement confirmed.
- **[Phase 3]** `git merge-base --is-ancestor e64242caef18b HEAD` → in
  tree.
- **[Phase 3]** `git merge-base --is-ancestor 6f611e5 HEAD` → NOT in
  tree.
- **[Phase 3]** `git log -S fbcon_modechange_possible` — introduced
  `e64242caef18b`, ioctl placement `588b35634a5aa`.
- **[Phase 4]** `b4 dig -c 6f611e5` → lore URL found; v1/v2/v3 revisions
  listed.
- **[Phase 4]** `b4 dig -w` → CC list with Deller, Geert, linux-fbdev,
  dri-devel.
- **[Phase 4]** WebFetch lore URL → blocked (Anubis); thread content
  UNVERIFIED.
- **[Phase 5]** `grep` callers: `activate()` used by `store_mode`,
  `store_bpp`, `store_rotate`, `store_virtual`.
- **[Phase 5]** `grep` for `fbcon_update_vcs` /
  `fbcon_modechange_possible` — only fbdev core + ps3fb + sh_mobile.
- **[Phase 6]** Read current `fbsysfs.c`, `fb_chrdev.c`, `ps3fb.c`,
  `sh_mobile_lcdcfb.c` — buggy pattern confirmed.
- **[Phase 6]** `git show 6f611e5 | git apply --check` → clean apply.
- **[Phase 6]** `grep fb_set_var_from_user` → not in tree.
- **[Phase 8]** Failure mode from `e64242caef18b`: OOB graphics memory
  access; severity HIGH.

**YES****Verdict for 6.18.44:** **YES** — backport this commit.

It closes a real gap left by the 2022 ioctl-only
`fbcon_modechange_possible()` fix: sysfs mode/rotation/virtual writes
and ps3fb/sh_mobile paths could still set resolutions smaller than the
console font, risking out-of-bounds framebuffer access. The patch is
small (~37 lines), applies cleanly, and mirrors the ioctl path’s
existing three-step sequence.

**Commit:** `6f611e5e5f3327cf2e2daabe6ee5acac58cc784e` (not yet in this
tree).

 drivers/video/fbdev/core/fb_chrdev.c   |  6 +-----
 drivers/video/fbdev/core/fbcon.c       |  2 --
 drivers/video/fbdev/core/fbmem.c       | 13 +++++++++++++
 drivers/video/fbdev/core/fbsysfs.c     |  4 +---
 drivers/video/fbdev/ps3fb.c            |  5 +----
 drivers/video/fbdev/sh_mobile_lcdcfb.c |  5 +----
 include/linux/fb.h                     |  2 ++
 7 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/video/fbdev/core/fb_chrdev.c b/drivers/video/fbdev/core/fb_chrdev.c
index 4ebd16b7e3b8d..54f926fb411bd 100644
--- a/drivers/video/fbdev/core/fb_chrdev.c
+++ b/drivers/video/fbdev/core/fb_chrdev.c
@@ -85,11 +85,7 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 		var.activate &= ~FB_ACTIVATE_KD_TEXT;
 		console_lock();
 		lock_fb_info(info);
-		ret = fbcon_modechange_possible(info, &var);
-		if (!ret)
-			ret = fb_set_var(info, &var);
-		if (!ret)
-			fbcon_update_vcs(info, var.activate & FB_ACTIVATE_ALL);
+		ret = fb_set_var_from_user(info, &var);
 		unlock_fb_info(info);
 		console_unlock();
 		if (!ret && copy_to_user(argp, &var, sizeof(var)))
diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index df1ecbf3f5d02..35210f2bb7b2b 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2754,7 +2754,6 @@ void fbcon_update_vcs(struct fb_info *info, bool all)
 	else
 		fbcon_modechanged(info);
 }
-EXPORT_SYMBOL(fbcon_update_vcs);
 
 /* let fbcon check if it supports a new screen resolution */
 int fbcon_modechange_possible(struct fb_info *info, struct fb_var_screeninfo *var)
@@ -2782,7 +2781,6 @@ int fbcon_modechange_possible(struct fb_info *info, struct fb_var_screeninfo *va
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(fbcon_modechange_possible);
 
 int fbcon_mode_deleted(struct fb_info *info,
 		       struct fb_videomode *mode)
diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index 30a2c0d47e5c8..1533d43a0a0c9 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -346,6 +346,19 @@ fb_set_var(struct fb_info *info, struct fb_var_screeninfo *var)
 }
 EXPORT_SYMBOL(fb_set_var);
 
+int fb_set_var_from_user(struct fb_info *info, struct fb_var_screeninfo *var)
+{
+	int ret = fbcon_modechange_possible(info, var);
+
+	if (!ret)
+		ret = fb_set_var(info, var);
+	if (!ret)
+		fbcon_update_vcs(info, var->activate & FB_ACTIVATE_ALL);
+
+	return ret;
+}
+EXPORT_SYMBOL(fb_set_var_from_user);
+
 static void fb_lcd_notify_blank(struct fb_info *info)
 {
 	int power;
diff --git a/drivers/video/fbdev/core/fbsysfs.c b/drivers/video/fbdev/core/fbsysfs.c
index fe8bd33e64ab1..d363f94207c3e 100644
--- a/drivers/video/fbdev/core/fbsysfs.c
+++ b/drivers/video/fbdev/core/fbsysfs.c
@@ -20,9 +20,7 @@ static int activate(struct fb_info *fb_info, struct fb_var_screeninfo *var)
 	var->activate |= FB_ACTIVATE_FORCE;
 	console_lock();
 	lock_fb_info(fb_info);
-	err = fb_set_var(fb_info, var);
-	if (!err)
-		fbcon_update_vcs(fb_info, var->activate & FB_ACTIVATE_ALL);
+	err = fb_set_var_from_user(fb_info, var);
 	unlock_fb_info(fb_info);
 	console_unlock();
 	if (err)
diff --git a/drivers/video/fbdev/ps3fb.c b/drivers/video/fbdev/ps3fb.c
index dbcda307f6a67..1376d19b19aeb 100644
--- a/drivers/video/fbdev/ps3fb.c
+++ b/drivers/video/fbdev/ps3fb.c
@@ -29,7 +29,6 @@
 #include <linux/freezer.h>
 #include <linux/uaccess.h>
 #include <linux/fb.h>
-#include <linux/fbcon.h>
 #include <linux/init.h>
 
 #include <asm/cell-regs.h>
@@ -830,9 +829,7 @@ static int ps3fb_ioctl(struct fb_info *info, unsigned int cmd,
 				/* Force, in case only special bits changed */
 				var.activate |= FB_ACTIVATE_FORCE;
 				par->new_mode_id = val;
-				retval = fb_set_var(info, &var);
-				if (!retval)
-					fbcon_update_vcs(info, var.activate & FB_ACTIVATE_ALL);
+				retval = fb_set_var_from_user(info, &var);
 				console_unlock();
 			}
 			break;
diff --git a/drivers/video/fbdev/sh_mobile_lcdcfb.c b/drivers/video/fbdev/sh_mobile_lcdcfb.c
index dd950e4ab5ceb..6038f217ab427 100644
--- a/drivers/video/fbdev/sh_mobile_lcdcfb.c
+++ b/drivers/video/fbdev/sh_mobile_lcdcfb.c
@@ -15,7 +15,6 @@
 #include <linux/ctype.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
-#include <linux/fbcon.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/ioctl.h>
@@ -1765,11 +1764,9 @@ static void sh_mobile_fb_reconfig(struct fb_info *info)
 	var.height = ch->display.height;
 	var.activate = FB_ACTIVATE_NOW;
 
-	if (fb_set_var(info, &var) < 0)
+	if (fb_set_var_from_user(info, &var) < 0)
 		/* Couldn't reconfigure, hopefully, can continue as before */
 		return;
-
-	fbcon_update_vcs(info, true);
 }
 
 /*
diff --git a/include/linux/fb.h b/include/linux/fb.h
index da2fdabd18cb3..f622f5f520cf0 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -541,6 +541,8 @@ extern int fb_set_var(struct fb_info *info, struct fb_var_screeninfo *var);
 extern int fb_pan_display(struct fb_info *info, struct fb_var_screeninfo *var);
 extern int fb_blank(struct fb_info *info, int blank);
 
+int fb_set_var_from_user(struct fb_info *info, struct fb_var_screeninfo *var);
+
 /*
  * Helpers for framebuffers in I/O memory
  */
-- 
2.53.0

