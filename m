Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519044FDE7E;
	Mon, 31 Aug 2026 13:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183702; cv=none; b=eD3KkeuuYSD1yrQlG46dN24nvZNbRvczHwF4Xyq51rEEwMf5sHgn/f5BhUBhHudpnL+N9geuWT/n/nfmCClYgqqHXbTYBAAGrULmM0rQKznnHuTTbY4S36BjEOBTN/WDF+dUV/SxzbaVhsvRaJqaOXlmrWQwn3Xrhsg+KXI8z0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183702; c=relaxed/simple;
	bh=uOJ1vWj2VM07q7M+Pz47bsHnuTzOkzBD4MMzLa1aa5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I39rG7ckPIhuPbejV5ZfpRUS+nGp+rINfxI9QVwyApCdxn0gzOMvR1FfE9pfnFqmShOFEmfxMnuQhk6SwtkSazcaICDJuh2Zlp8rAP0NBciju8uZ3rJypfPmPz1LMXJlzL0yopBVR3uy8y/1GcFq/+B/Ft0P6AB/zgaXYFj+xDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kSIXvF4G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kSIXvF4G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0437F1F00A3F;
	Mon, 31 Aug 2026 13:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183700;
	bh=tNvTxfEvxz+PlqY1G7kjoYqpVR3CjRcJQQ/PBkURF5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kSIXvF4GjS8oP6IQONuJQJriQO5I66XUGDaKWsCc0goQ8IxqiSv667v9qTwr14M6a
	 CK5XLb//K15nb4uSUzzASAqbib868OfBJf+1i4t8VE+vRnE19g7tutQqQCxbzlyOle
	 qUAm5uLmWcH+9fl4ooOv+HzBbvHbhqDQmMUzzWrweDxRC7hy2RiIjT5DY3ZnzcoN/n
	 +zgkVIbvt3+SZeFeVnkpECRVNoG2S0Xuwo0yPS8Ue1JLRxeiu4LKDzhCAqRH3R0VK2
	 nwXd2egBepYhenA0bVdiluvWp+lVBfZ7dJwoNiD5z5cdjR1cWxwuF9OvDKBYFWMraR
	 KobSGAStG4jUQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lu Yao <yaolu@kylinos.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>,
	tzimmermann@suse.de,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-fbdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] fbcon: don't suspend/resume when vc is graphics mode
Date: Mon, 31 Aug 2026 09:24:40 -0400
Message-ID: <20260831133314.4125787-252-sashal@kernel.org>
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

From: Lu Yao <yaolu@kylinos.cn>

[ Upstream commit 70d9d5f5fcd940f627bd403aaa6f65de724eef6b ]

Don't need to do suspend/resume for fbcon in graphic mode.

Doing this may cause error, eg:
  At the beginning, starting the Xorg with single screen and then an
  external screen was plugged in. After logging out in Xorg, fbdev
  info may using screen which is connected later on for info always
  using first connected connector in list in func 'drm_setup_crtcs_fb'.
  Then, S3 executed, fbcon found that the information did not match
  and do atomic to switch fb. However, Xorg will not re-bind the crtc
  fb but continues doing ioctl. At this time, the fb is incorrect.

With some modifications by Helge Deller.

Signed-off-by: Lu Yao <yaolu@kylinos.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[fbcon]` `[don't]` (preventive) — skip suspend/resume fbcon
work when the virtual console is in graphics mode (`KD_GRAPHICS`).

### Step 1.2: Commit Tags
**Record:** Tags present:
- `Signed-off-by: Lu Yao <yaolu@kylinos.cn>` (author)
- `Signed-off-by: Helge Deller <deller@gmx.de>` (fbdev maintainer)

Notable absences (expected for manual review):
- No `Fixes:` tag
- No `Reported-by:` tag
- No `Cc: stable@vger.kernel.org`
- No `Link:` to bug report or syzbot
- No `Tested-by:` / `Reviewed-by:` / `Acked-by:`

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** `fbcon_suspended()` / `fbcon_resumed()` run fbcon
  cursor/screen update logic even when the VC is in graphics mode (Xorg
  owns the display).
- **Symptom:** After multi-monitor hotplug + Xorg logout + S3
  suspend/resume, fbdev metadata can point at the wrong connector; fbcon
  resume triggers an atomic framebuffer switch while Xorg keeps using
  the old framebuffer, leaving the display in a broken state.
- **Root cause (author):** fbcon should not touch the framebuffer in
  graphics mode; resume path can call into `update_screen()` →
  `fbcon_switch()` → `fb_set_var()`, provoking DRM atomic
  reconfiguration.
- **Version info:** None stated.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Yes — despite the short message, this is a real
suspend/resume correctness fix, not cosmetic cleanup. It aligns
`fbcon_suspended()` / `fbcon_resumed()` with the `KD_TEXT` guards
already used in `fbcon_modechanged()`, `fbcon_init()`, and other fbcon
paths.

---

## Phase 2: Diff Analysis

### Step 2.1: Change Inventory
**Record:**
- **File:** `drivers/video/fbdev/core/fbcon.c` (+3 net lines)
- **Functions:** `fbcon_suspended()`, `fbcon_resumed()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code Flow Change
**Record:**

| Hunk | Before | After |
|------|--------|-------|
| `fbcon_suspended()` | Always calls `fbcon_cursor(vc, false)` | Only if
`vc->vc_mode == KD_TEXT && con_is_visible(vc)` |
| `fbcon_resumed()` | Always calls `update_screen(vc)` | Only if
`vc->vc_mode == KD_TEXT && con_is_visible(vc)` |

Affected path: system suspend/resume via `fb_set_suspend()` →
`fbcon_suspended()` / `fbcon_resumed()`, commonly reached from DRM fbdev
(`drm_fb_helper_set_suspend()` → `drm_fbdev_client_suspend/resume`).

### Step 2.3: Bug Mechanism
**Record:** **Logic / correctness fix** in suspend/resume path.

- `update_screen(vc)` expands to `redraw_screen(vc, 0)`
  (`include/linux/vt_kern.h`).
- `redraw_screen()` always calls `vc->vc_sw->con_switch(vc)` — for fbcon
  that is `fbcon_switch()`, which calls `fb_set_var()` and can reprogram
  the DRM framebuffer.
- `redraw_screen()` only skips the final `do_update_region()` when
  `vc->vc_mode == KD_GRAPHICS`; it still runs `con_switch` /
  `fb_set_var` in graphics mode.
- `fbcon_modechanged()` already bails out on `vc->vc_mode != KD_TEXT`;
  `fbcon_suspended/resumed` did not — that inconsistency is the bug.

For `fbcon_suspended()`, `fbcon_cursor()` already returns early when
`!fbcon_is_active()`, and `fbcon_is_active()` requires `KD_TEXT`. The
suspend-side change is mostly consistency plus a `con_is_visible()`
guard; the resume-side `update_screen()` guard is the substantive fix.

### Step 2.4: Fix Quality
**Record:**
- **Quality:** High — matches existing pattern at lines 642, 1124, 2074,
  2686 in the same file.
- **Regression risk:** Very low — fbcon should not manipulate the
  framebuffer while X/compositor holds graphics mode.
- **Red flags:** None.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame / Introduction
**Record:**
- `fbcon_suspended()` / `fbcon_resumed()` core logic dates to the
  original fbcon import (`1da177e4c3f4`, 2005).
- Wrapper path via `fb_set_suspend()` consolidated in `50c5056356340`
  (2019, "fbdev: directly call fbcon_suspended/resumed").
- Buggy unconditional `update_screen()` in `fbcon_resumed()` has been
  present for many years; it only becomes problematic with modern DRM
  atomic fbdev emulation and multi-connector setups.

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag in the commit message.

### Step 3.3: Related File History
**Record:** Recent `fbcon.c` changes in this tree are unrelated fbcon
bug fixes (NULL deref, OOB read, type fixes). No prior fix for this
graphics-mode suspend/resume issue found. Standalone patch, not part of
a series.

### Step 3.4: Author Context
**Record:**
- Lu Yao (Kylin OS) — platform vendor reporting a real multi-monitor +
  S3 scenario.
- Helge Deller — active fbdev maintainer with recent fbcon fixes in this
  tree (e.g. `d78bd6cc68276 fbcon: Fix null-ptr-deref in soft_cursor`).

### Step 3.5: Dependencies
**Record:** No dependencies. Uses `KD_TEXT`, `con_is_visible()`, and
existing helpers already in 6.18.44. Applies standalone.

---

## Phase 4: Mailing List and External Research

### Step 4.1–4.5: Lore / b4 dig
**Record:**
- `b4 dig -c <commit>` could not be run — this commit is not in the
  checked-out tree (candidate only, no commit hash).
- Direct lore.kernel.org fetch returned 403 (bot protection).
- No matching `.mbx` file found in the workspace.
- **UNVERIFIED:** Full mailing-list review thread, reviewer stable
  nominations, and patch series evolution.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `fbcon_suspended()`, `fbcon_resumed()`, callers
`fb_set_suspend()`, `fbcon_switch()`, `redraw_screen()`.

### Step 5.2: Callers
**Record:** `fb_set_suspend()` called from:
- `drm_fb_helper_set_suspend()` / `drm_fbdev_client_suspend/resume()`
  (DRM fbdev path — relevant to the reported bug)
- Legacy fbdev drivers (i915 intelfb, nvidia, aty, etc.)
- `fbsysfs.c` sysfs interface

Suspend/resume is a common system-wide path on laptops/desktops.

### Step 5.3: Callees
**Record:** `fbcon_cursor()`, `update_screen()` → `redraw_screen()` →
`hide_cursor()`, `con_switch()` (`fbcon_switch()`), `fb_set_var()`,
potential `fb_set_par()`.

### Step 5.4: Reachability
**Record:** Reachable on every S3/hibernate cycle while DRM fbdev
emulation is active. Trigger requires graphics mode (typical when
Xorg/Wayland compositor is running, or after logout with VC still in
graphics mode). Userspace does not need special privileges beyond normal
suspend.

### Step 5.5: Similar Patterns
**Record:** Same `con_is_visible(vc) && vc->vc_mode == KD_TEXT` guard
used elsewhere in `fbcon.c` (lines 642, 1124, 2074).
`fbcon_modechanged()` uses `vc->vc_mode != KD_TEXT` early return (line
2686).

---

## Phase 6: Cross-Reference Against Local Tree (v6.18.44)

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** Current tree at
`drivers/video/fbdev/core/fbcon.c:2651-2674` still has unconditional
`fbcon_cursor()` and `update_screen()` with no `KD_TEXT` check. Fix is
not yet applied (`git log -S "Update screen when in text mode only"`
returned empty).

### Step 6.2: Backport Complications
**Record:** **Clean apply expected** — 3-line logical change in a stable
area of `fbcon.c`, no structural conflicts with recent local changes.

### Step 6.3: Related Fixes Already Present?
**Record:** No equivalent fix found in this tree.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem / Criticality
**Record:** `drivers/video/fbdev/core/` — framebuffer console over DRM
fbdev emulation. **IMPORTANT** for desktop/laptop users relying on fbdev
+ suspend/resume; not universal core-kernel, but widely used on
Intel/AMD DRM systems with fbdev client enabled.

### Step 7.2: Activity
**Record:** fbcon remains actively maintained in 6.18.y (multiple fbcon
fixes in recent history on this branch).

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of DRM fbdev emulation with:
- Graphics mode active (`KD_GRAPHICS`, typical under Xorg)
- Multi-connector hotplug scenarios
- System suspend (S3) / resume

Config-dependent on `CONFIG_DRM_FBDEV_CLIENT` / fbdev emulation, but
that is common on desktop distros.

### Step 8.2: Trigger Conditions
**Record:** Specific but realistic: external monitor hotplug while X
running, logout, then S3. Not every boot, but reproducible on real
hardware per commit message. Unprivileged users can trigger via normal
suspend.

### Step 8.3: Failure Mode Severity
**Record:** Wrong framebuffer bound after resume; display corruption /
broken Xorg ioctl path. Not a kernel oops, but a **HIGH** functional
failure on resume — system may need reboot to recover display.
Suspend/resume breakage is a common stable backport category.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Prevents fbcon from disturbing DRM framebuffer state
  during S3 when graphics mode is active.
- **Risk:** Very low — only skips work that should never run in graphics
  mode.
- **Ratio:** Strong benefit, minimal risk.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, described hardware scenario (multi-monitor + S3 + Xorg/fbdev)
- Maintainer sign-off (Helge Deller)
- Tiny, obviously correct fix matching existing fbcon guards
- Bug mechanism verified in code: `update_screen()` → `fbcon_switch()` →
  `fb_set_var()` runs even in `KD_GRAPHICS`
- Buggy code present since early fbcon, still unfixed in v6.18.44
- Suspend/resume display breakage is user-visible and painful

**AGAINST backport:**
- No syzbot/KASAN report or `Reported-by:` from upstream
- Failure mode is display corruption, not kernel crash/panic
- Suspend-side change is partially redundant (`fbcon_cursor` already
  inactive in graphics mode)
- Mailing-list review unverified

**Unresolved:**
- Full lore review thread not accessible
- No independent `Tested-by:` confirmation

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic matches established
   fbcon patterns; maintainer SOB; scenario described (no independent
   test tag).
2. Fixes a real bug affecting users? **PASS** — concrete multi-monitor
   S3 scenario.
3. Important issue? **PASS** — suspend/resume display corruption on
   common laptop/desktop setup (**HIGH** severity).
4. Small and contained? **PASS** — 3 net lines, one file, two functions.
5. No new features or APIs? **PASS**.
6. Can apply to local tree? **PASS** — buggy code present, no
   prerequisites.

### Step 9.3: Exception Categories
**Record:** None (not a device ID, quirk, DT, build, or docs fix).
Qualifies on straight bug-fix merits.

### Step 9.4: Decision Rationale
For **v6.18.44**, this commit closes a long-standing gap where fbcon
resume can invoke `fb_set_var()` through `update_screen()` while the VC
is in graphics mode. That is exactly the wrong time for fbcon to
reprogram the DRM framebuffer. The fix is minimal, consistent with the
rest of `fbcon.c`, endorsed by the fbdev maintainer, and addresses a
real suspend/resume regression path on DRM+fbdev systems. The missing
lore verification does not outweigh the clear code-path analysis.

---

## Verification

- **[Phase 1]** Parsed commit message and tags manually from user-
  provided text.
- **[Phase 2]** Read diff and current `fbcon.c` at lines 2651–2710;
  confirmed `update_screen` → `redraw_screen` → `con_switch` path in
  `vt.c:929-987`.
- **[Phase 2]** Confirmed `fbcon_switch()` calls `fb_set_var()` at
  `fbcon.c:2134`.
- **[Phase 2]** Confirmed `fbcon_is_active()` requires `KD_TEXT` at
  `fbcon.c:287-292`.
- **[Phase 3]** `git describe HEAD` → `v6.18.44`; `make kernelversion` →
  `6.18.44`.
- **[Phase 3]** `git blame` on `fbcon_suspended/resumed` — original code
  from 2005, structure unchanged.
- **[Phase 3]** `git show 50c5056356340` — `fb_set_suspend` → fbcon path
  since 2019.
- **[Phase 3]** `git log -S "Update screen when in text mode only"` —
  fix not in tree.
- **[Phase 4]** `b4 dig` — cannot run without commit hash (candidate not
  merged).
- **[Phase 4]** lore.kernel.org fetch — 403 Forbidden; **UNVERIFIED**
  mailing-list discussion.
- **[Phase 5]** `grep fb_set_suspend` — callers include
  `drm_fbdev_client.c:65-86`, `drm_fb_helper.c:729-737`.
- **[Phase 5]** Read `drm_fbdev_client_suspend/resume` and
  `fb_set_suspend` in `fbmem.c:650-661`.
- **[Phase 5]** Confirmed `KD_TEXT` + `con_is_visible` pattern at
  `fbcon.c:642,1124,2074`.
- **[Phase 6]** Buggy unconditional code confirmed present at
  `fbcon.c:2660-2673`.
- **[Phase 6]** No duplicate fix found via `git log --grep` / `-S`
  searches.
- **[Phase 8]** Failure mode assessed as display corruption after S3,
  not kernel crash.

**YES**The background searches finished and match what we already
concluded:

- **Commit lookup:** The fix (`fbcon: don't suspend/resume when vc is
  graphics mode`) is **not in v6.18.44** yet. A pickaxe search for
  `vc->vc_mode == KD_TEXT` in `fbcon.c` only turned up older, unrelated
  commits.
- **Author / b4 dig:** `git log --author="Lu Yao"` didn’t find this
  patch in the tree (only unrelated commits). `b4 dig` couldn’t be run
  without a merged commit hash.

That supports the earlier **YES** for backport: the bug is still present
in this tree, and the patch is a small, standalone guard around
`fbcon_suspended()` / `fbcon_resumed()` when the VC is in graphics
mode.The author-email search (`git log --author="yaolu"`) also didn’t
find the fbcon patch in this tree — only unrelated amdgpu, btrfs, and
x86 commits. That further confirms it’s a candidate not yet merged into
v6.18.44, consistent with the **YES** backport recommendation.

 drivers/video/fbdev/core/fbcon.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 35210f2bb7b2b..532522c2aed05 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2657,8 +2657,9 @@ void fbcon_suspended(struct fb_info *info)
 		return;
 	vc = vc_cons[par->currcon].d;
 
-	/* Clear cursor, restore saved data */
-	fbcon_cursor(vc, false);
+	/* Clear cursor, restore saved data when in text mode */
+	if ((vc->vc_mode == KD_TEXT) && con_is_visible(vc))
+		fbcon_cursor(vc, false);
 }
 
 void fbcon_resumed(struct fb_info *info)
@@ -2670,7 +2671,9 @@ void fbcon_resumed(struct fb_info *info)
 		return;
 	vc = vc_cons[par->currcon].d;
 
-	update_screen(vc);
+	/* Update screen when in text mode only */
+	if ((vc->vc_mode == KD_TEXT) && con_is_visible(vc))
+		update_screen(vc);
 }
 
 static void fbcon_modechanged(struct fb_info *info)
-- 
2.53.0

