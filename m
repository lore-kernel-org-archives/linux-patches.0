Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D828500AB2;
	Mon, 19 Oct 2026 13:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418332; cv=none; b=VQDoJ4zOf3aHOPd3x5f+LBLVJCxrs3G32Dur+slapfiFD6doG1YIax/wgIh/LxAFYRF4HGmQ+3AoAfzhC0UOgRHujXd1SANFSOSF4RnSBFcOiu8oKcaxPVHbj0sgmdKiLMyKtx1Wl0vNgSHWXp1yDvJ3+vo3Q/NLtsPRCPEEzPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418332; c=relaxed/simple;
	bh=b416kC/7CaYadZQDJ9zlNw1KeykzNXi6AefTmPsk9d0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gH0A0xQ6QsUxXeYYn6FkcztXSsl7X3UPvjtschmCWrlb1KupgXFBmakK0BdLj6Oaas/k3pdIkRsG6KoiqsNSYJA0qE/QnXbECeX/lfxf3xsIAPt/dkGEv7Y/nL3zF9WXl6fJ3s/9Rk+AnPOlaIvDho9LfqbHByl9/gPT2wuyHO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eDEguPhG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eDEguPhG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1801F000C7;
	Mon, 19 Oct 2026 13:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418327;
	bh=WAqhhXzj65SZ1X+PrGy9aIEIqNsKhn7pV/K6lVOjYDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eDEguPhGPzyOSR8HN+aXNhuUjaiy0dVkof5Ydr6yqPwHdwpcrE0IwGO+zhA31t7Pl
	 TNQuFSbx3HyriK2RKsIfPUnMkO96NuvRUY/Ef/C2XtisXWTw3/JQelh8YijfteWQze
	 2cmWl3iPQDcZHoyx7N+G11ucehL8b/GqdHLviKiYcdohK/IXFou5nenwJIugkslQGx
	 5rgjtyMBCYeUYo4hPBAyvGX5zRdWUboReOYk36dH8IkuehSUcTx3fDwm8yzF/9sNMr
	 IdsMxzPW6dLdA2dyu/VMKWA6gF3I8Ja7xnxgkJ4VBTrE16HIz11zbndfqhUjQNlErF
	 y9RoIVwR9ZxAQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ASoC: codecs: uda1342: Leave cache-only mode before syncing
Date: Mon, 19 Oct 2026 09:47:40 -0400
Message-ID: <20261019135441.1420968-169-sashal@kernel.org>
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

[ Upstream commit 29da72e58fde87e632f2fa43e448fcd1e3ab31b0 ]

uda1342_suspend() puts the regmap into cache-only mode. uda1342_resume()
marks the cache dirty and syncs it, but does not first leave cache-only
mode and ignores sync failures.

Leave cache-only mode before syncing the dirty cache, propagate sync
failures, and restore cache-only/dirty state on failure.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260704072140.67222-1-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **v7.3-rc4**. The UDA1342 resume path never left
cache-only mode, so after suspend the codec stays cache-only and later
register writes never reach hardware.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[ASoC/codecs/uda1342] [Leave / prevent incorrect PM cache
state] [Disable cache-only mode before `regcache_sync()` on resume, and
fail resume if sync fails]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Fixes:** none (expected for this review)
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** none
- **Acked-by:** none
- **Cc: stable:** none (expected)
- **Link:**
  https://patch.msgid.link/20260704072140.67222-1-pengpeng@iscas.ac.cn
- **Signed-off-by:** Pengpeng Hou (author); Mark Brown (ASoC
  maintainer). Ignore any Sasha Levin SOB if present.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `uda1342_suspend()` sets `regcache_cache_only(..., true)`.
  `uda1342_resume()` marks the cache dirty and calls `regcache_sync()`
  without leaving cache-only mode, and ignores the sync return value.
- **Symptom:** After suspend/resume the map stays cache-only, so later
  `regmap` writes update only the cache. On this tree, `regcache_sync()`
  also `WARN_ON`s and returns `-EINVAL` if `cache_only` is still set.
- **Version info in message:** none
- **Root cause (author):** resume never disables cache-only before sync,
  and never reports sync failure.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. It is an explicit PM correctness fix
(leave cache-only, propagate errors, restore dirty/cache-only on
failure).

===============================================================
PHASE 2: DIFF ANALYSIS
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `sound/soc/codecs/uda1342.c` (+8 / -1)
- Function: `uda1342_resume()`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** `regcache_mark_dirty()` then `regcache_sync()` with
  `cache_only` still true; return 0 always.
- **After:** `regcache_cache_only(..., false)`, mark dirty, `ret =
  regcache_sync()`. On failure, re-enter cache-only, mark dirty, return
  `ret`.
- Path: system-sleep resume (and the runtime-resume callback used by
  `pm_runtime_force_resume()`).

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** logic / PM correctness (cache-only left enabled; ignored
  error)
- **Mechanism:** suspend enables cache-only. Resume must disable it
  before sync so writes hit I2C. Leaving it set means `_regmap_write()`
  takes the cache-only early return and never calls `map->reg_write()`.
  This tree also has `WARN_ON(map->cache_only)` in `regcache_sync()`, so
  the old resume warns and returns `-EINVAL` without restoring hardware.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Matches the usual ASoC pattern (`tas2552_runtime_resume()` and many
  others).
- Minimal, obviously correct.
- Failure unwind matches other codecs: stay cache-only and dirty so a
  later resume can retry.
- Regression risk is low: one driver, resume path only, no API change.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Buggy resume introduced in `de0fb25e37aae` (“ASoC: codecs: Add uda1342
  codec driver”, Binbin Zhou, 2024-10-09).
- First appeared in **v6.13-rc1**. Present in this 7.3-rc4 tree.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Introducer is `de0fb25e37aae`, confirmed
ancestor of HEAD.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Only four commits on the file: driver add, two `i2c_device_id`
cleanups, then this fix. Standalone, not patch X/Y.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Pengpeng Hou is a regular small-fix contributor, not the UDA1342
author. Original driver is Binbin Zhou (Loongson). Mark Brown applied
the patch. Related work around the same time: many ASoC “propagate
`regcache_sync()` errors” patches.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None. Uses `regcache_cache_only` / `regcache_mark_dirty` /
`regcache_sync`, all long-standing. Applies standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 29da72e58fde8` →
  https://patch.msgid.link/20260704072140.67222-1-pengpeng@iscas.ac.cn
- `b4 dig -a`: only **v1**
- Thread: submission + Mark Brown “Applied to sound.git for-7.3”. No
  NAK, no requested revisions, no reviewer `Cc: stable`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): Liam Girdwood, Mark Brown, Jaroslav Kysela,
Takashi Iwai, Linus Walleij, Charles Keepax, Uwe Kleine-König, linux-
sound, linux-kernel. Maintainer Mark Brown applied it.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No `Reported-by`, syzbot, or bugzilla. Bug is from code
inspection. Driver was added for **Loongson-2K1000** (`7d04763cae994`
series: “Add uda1342 codec required on Loongson-2K1000”), so there are
real boards, even with no in-tree `.dts` match for `nxp,uda1342`.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone v1. Same resume pattern exists across ASoC codecs.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable returned 403. No evidence this was
discussed on stable (UNVERIFIED beyond the 403).

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `uda1342_resume()`; `uda1342_suspend()` unchanged.

**Step 5.2: TRACE CALLERS**
Record:
- Wired via `DEFINE_RUNTIME_DEV_PM_OPS(uda1342_pm_ops, uda1342_suspend,
  uda1342_resume, NULL)`:
  - system sleep: `pm_runtime_force_suspend` / `pm_runtime_force_resume`
  - runtime: `uda1342_suspend` / `uda1342_resume`
- `.pm = pm_sleep_ptr(&uda1342_pm_ops)` so system sleep uses these ops.
- Probe never calls `pm_runtime_enable()`, so runtime autosuspend is
  unused. System suspend still calls `GET_CALLBACK(dev,
  runtime_suspend/resume)` from `pm_runtime_force_*`
  (`drivers/base/power/runtime.c`).

**Step 5.3: TRACE CALLEES**
Record: `regcache_cache_only`, `regcache_mark_dirty`, `regcache_sync`.
Sync uses maple ops (`REGCACHE_MAPLE`) and `_regmap_write`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record:
- Userspace: suspend/resume (or hibernation) with
  `CONFIG_SND_SOC_UDA1342` and a `nxp,uda1342` I2C device.
- After a “successful” old resume, `uda1342_mute()` /
  `uda1342_hw_params()` → `regmap_update_bits()` → `_regmap_write()`
  cache-only early return → no I2C write.
- Reachable on real Loongson-2K1000 hardware; not a syscall fuzzer path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same leave-cache-only-then-sync pattern in many codecs
(`tas2552.c`, `wm8962.c`, etc.). This driver was the one that omitted
it.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- `git describe HEAD` → **v7.3-rc4-27-gf0100363d8c37**
- `make kernelversion` → **7.3.0-rc4**
- Driver present: `sound/soc/codecs/uda1342.c`
- `git merge-base --is-ancestor de0fb25e37aae HEAD` → yes
- Bug introduced in v6.13-rc1, still in this lineage. Current file
  already has the fixed resume (expected: this is the mainline commit
  under review).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply. Surrounding resume/probe code is the original
driver plus trivial `i2c_device_id` init cleanups. No refactor.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No earlier equivalent fix. Later `86fc3483a4d60` (“regcache:
Warn if regcache_sync() is called in cache_only mode”, also v7.3-rc1)
makes the old resume a `WARN_ON` + `-EINVAL` on this tree.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **ASoC codec driver** (`sound/soc/codecs/`). Criticality:
**PERIPHERAL** (one NXP codec, Loongson-2K1000). Not core mm/fs/net.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: ASoC codecs are actively developed. This file itself is quiet
(four commits). Mature for this driver: the PM bug was present from
introduction.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Users of **CONFIG_SND_SOC_UDA1342** / `nxp,uda1342` (documented
for Loongson-2K1000). Driver- and config-specific, not universal.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record:
- Trigger: system suspend/resume with this codec.
- Common on any machine that sleeps.
- Not an unprivileged syscall exploit path.
- Not a timing race.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record:
- On this tree: `WARN_ON` in `regcache_sync()` and resume returns
  `-EINVAL` → hardware not restored.
- Even without that warn: cache-only left set → mute/volume/hw_params
  never programmed to the chip; audio broken after resume.
- Severity: **HIGH** for those devices (broken audio / failed resume),
  not a panic or filesystem corruption.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** medium-high for UDA1342 boards; zero elsewhere.
- **Risk:** very low (8 lines, one function, standard pattern).
- **Ratio:** favorable.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real suspend/resume bug: cache-only never cleared, so post-resume
  register writes never hit I2C.
- On this 7.3-rc4 tree, `regcache_sync()` additionally WARNs and fails
  if cache-only is still set.
- Small, surgical, matches other ASoC codecs; maintainer applied v1 with
  no objections.
- Driver exists here since v6.13; no extra prerequisites.
- Error return lets the PM core fail resume instead of pretending it
  succeeded.

AGAINST:
- Peripheral codec, no in-tree DTS, no user/syzbot report.
- Author is not the original driver author; no `Tested-by`.
- Not a security/UAF/deadlock class issue.

UNRESOLVED:
- Stable list search on lore returned 403.
- No public confirmation of a user-reproduced resume failure (code
  analysis only).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — standard pattern; applied by
   Mark Brown. No extra tester tag.
2. Fixes a real bug that affects users? **PASS** — resume leaves the
   codec in cache-only; Loongson-2K1000 uses this codec.
3. Important issue? **PASS** — broken audio / failed resume after sleep;
   WARN_ON on this tree. Not a panic, but user-visible PM breakage.
4. Small and contained? **PASS** — 8 insertions, 1 deletion, one
   function.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — file and helpers exist;
   context matches.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None (not a device ID / DT / build / docs exception). It is a
normal small bug fix.

**Step 9.4: MAKE YOUR DECISION**
This tree has the UDA1342 driver and the broken resume. The patch is the
usual, low-risk ASoC fix: leave cache-only, sync, report errors. That is
appropriate to backport here.

**What the commit solves for this tree:** After suspend, resume never
turns cache-only off. Sync then either WARNs/`-EINVAL` (this 7.3 code)
or leaves later `regmap` writes stuck in the cache. Audio after sleep is
wrong. The patch restores hardware and reports I2C/sync failure.

**Stable rules:** Small, obviously correct, no new API, applies cleanly,
real PM bug.

**Risk vs benefit:** Very low regression risk vs fixing resume for this
codec.

**Concerns:** Niche hardware, no tester tag. Not enough to reject a
9-line resume fix whose code is present in this checkout.

Verification:
- [Phase 1] Parsed tags: Link to msgid `20260704072140.67222-1`; SOBs
  Hou and Brown; no Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: `uda1342_resume()` +8/-1; add
  `regcache_cache_only(false)`, check `regcache_sync()`, unwind on error
- [Phase 2] `_regmap_write()`: cache_only + !cache_bypass returns 0
  without `reg_write` (verified in `drivers/base/regmap/regmap.c`)
- [Phase 2] `regcache_sync()`: `WARN_ON(map->cache_only)` returns
  `-EINVAL` (verified line 437 of `regcache.c`)
- [Phase 3] `git describe HEAD`: v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion`: 7.3.0-rc4
- [Phase 3] `git blame` on parent: buggy resume is `de0fb25e37aae`
  (v6.13-rc1)
- [Phase 3] `git merge-base --is-ancestor de0fb25e37aae HEAD`: yes
- [Phase 3] `git merge-base --is-ancestor 29da72e58fde8 HEAD`: yes
  (mainline commit under review)
- [Phase 3] File log: four commits, no series dependency
- [Phase 4] `b4 dig -c 29da72e58fde8`: lore msgid match; `-a`: v1 only;
  `-w`: ASoC maintainers CC’d; mbox: Brown applied, no NAK
- [Phase 4] lore.kernel.org/stable: 403 — UNVERIFIED
- [Phase 5] `DEFINE_RUNTIME_DEV_PM_OPS` + `pm_sleep_ptr`;
  `pm_runtime_force_suspend/resume` call the runtime callbacks
- [Phase 5] Probe does not `pm_runtime_enable()` — system sleep still
  uses `pm_runtime_force_*`
- [Phase 5] `7d04763cae994`: driver added for Loongson-2K1000
- [Phase 6] Pre-fix resume read from `29da72e58fde8^`: mark dirty +
  sync, no `cache_only(false)`
- [Phase 6] WARN_ON added in `86fc3483a4d60` (v7.3-rc1), present in this
  tree
- [Phase 8] Failure: WARN + failed resume / cache-only stuck; severity
  HIGH for this device
- UNVERIFIED: whether this was already requested on the stable list
  (HTTP 403)

**YES**

 sound/soc/codecs/uda1342.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/uda1342.c b/sound/soc/codecs/uda1342.c
index b0b29012842da..c21919bef4d72 100644
--- a/sound/soc/codecs/uda1342.c
+++ b/sound/soc/codecs/uda1342.c
@@ -308,9 +308,16 @@ static int uda1342_suspend(struct device *dev)
 static int uda1342_resume(struct device *dev)
 {
 	struct uda1342_priv *uda1342 = dev_get_drvdata(dev);
+	int ret;
 
+	regcache_cache_only(uda1342->regmap, false);
 	regcache_mark_dirty(uda1342->regmap);
-	regcache_sync(uda1342->regmap);
+	ret = regcache_sync(uda1342->regmap);
+	if (ret) {
+		regcache_cache_only(uda1342->regmap, true);
+		regcache_mark_dirty(uda1342->regmap);
+		return ret;
+	}
 
 	return 0;
 }
-- 
2.53.0

