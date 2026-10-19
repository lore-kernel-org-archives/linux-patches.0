Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B422D6070B6;
	Mon, 19 Oct 2026 14:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418605; cv=none; b=iv3IIh4UPytH7Nn2BUEAu/R8DPr/v3A7Bm46vmFOCvzV8/jYZ8ikUlwCdACU7C33Yiv+jgjaZ4U0Bf9YkoJM0KeKhgMSWjPvB0V7fJ89kgHbyBd6xV/v7FucvXPATMY6BEQRbD999Max0mCAYDYyWf44hoETDxYyr0Qyzgp4n60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418605; c=relaxed/simple;
	bh=Opv6Dq5IPgwtPYeMVrpI7uDhBkUO2SaBh4P9fDleTDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fhV5nHEMWVdb9dwIAWahRC6N8265J4gCxlPspbwEq+SX79gsa5QHeJ0PcJpNvCwFQS4VUR0rttvjabQwfO8vLhkJ4+6VNurxSfJiVwlnh6eY4a99QEInCO102fO9Vw+vjfI8o0Hp0klKgKIPKT0Np4lWhu2rOs3bE3CdHE4hr1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y9FoWcEL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y9FoWcEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9791A1F000C4;
	Mon, 19 Oct 2026 14:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418602;
	bh=8RY2n4h9VU8wvRSi8/XoaDA5iRfpjbn361O2gW9yk9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y9FoWcELNY41yP/UoEmi7f8Z7A+BQivcWZ7nLLHUf4NBz4wtenbso6V4PhYAxojRK
	 ufkPbE6hcR0duexYy3NTAZBSOSu7Vxt4rTHxyaadqw6vHazZJ4pFuDnu9uDeAGEjdt
	 v5/npDOC49MAl+0Q/j5uPK9/QC5tGB9hz//8FSezNVkci8C2y+hwjqRLAW4N6ReBIg
	 Zcp8OC3ImomCMsyaOwKC0QrLBj3QM+J40QIMmf6wuJjWrPIIW8OkG5UJOLp12BTost
	 n6PxZ4anfUzn7Bx4hshxPeddmxetjb3bV9OEJGDZYVm/JgJBB3tPG3HNvimHdYYuoN
	 AFkBfTd6XgHYQ==
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
Subject: [PATCH AUTOSEL 6.18-6.1] ASoC: codecs: max98396: Unwind supplies on resume failure
Date: Mon, 19 Oct 2026 09:50:56 -0400
Message-ID: <20261019135441.1420968-365-sashal@kernel.org>
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

[ Upstream commit d20de7409dfa8e3341af7f157cd42130bd4ba3a7 ]

max98396_resume() enables the core, pvdd, and vbat supplies before
leaving cache-only mode, resetting the device, and replaying cached
register state. The function currently ignores regcache_sync() failures,
and the optional pvdd/vbat enable failures return without unwinding
supplies that were already enabled in this resume attempt.

Rework the function to use common error labels. This propagates sync
failures, restores cache-only/dirty state on failed cache replay, and
disables each supply acquired by this resume path before returning the
error.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260704040651.47558-1-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **v7.3-rc4** (`7.3.0-rc4`). The MAX98396 resume path
has been in this lineage since v6.0, and this patch is a small, self-
contained error-path fix for that path.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[ASoC/codecs/max98396] [Unwind] [Disable supplies and restore
cache state if resume fails]**
Subsystem prefix `ASoC: codecs: max98396:`. Verb **Unwind** is error-
path cleanup language; the body is a real leak/error-propagation fix,
not a refactor.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Fixes:** none (expected)
- **Reported-by / Tested-by / Reviewed-by / Acked-by:** none on the
  commit itself
- **Link:**
  https://patch.msgid.link/20260704040651.47558-1-pengpeng@iscas.ac.cn
- **Cc: stable:** none (expected)
- **Signed-off-by:** Pengpeng Hou (author); Mark Brown (ASoC
  maintainer). Ignore any Sasha Levin SOB from candidate prep.

No syzbot, no multi-user reports.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `max98396_resume()` enables core / optional pvdd / vbat, then
  leaves cache-only, resets, and calls `regcache_sync()`.
  `regcache_sync()` errors are ignored. If optional pvdd/vbat enable
  fails, already-enabled supplies are not disabled.
- **Symptom:** Regulator enable-count leak after a failed resume; resume
  can report success while cached register state was not written back
  (codec left in reset/defaults → broken audio after suspend).
- **Version info:** none in the message.
- **Root cause:** Missing unwind and ignored `regcache_sync()` return.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Yes, a real bug fix described as error-path rework.** “Common
error labels” is the usual shape of a leak fix: added `goto` cleanup,
`regulator_disable` / `regulator_bulk_disable`, restore cache-
only/dirty, propagate `regcache_sync()` failure.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- **File:** `sound/soc/codecs/max98396.c` — **+21 / −3** (`git show
  --stat`: 24 lines changed)
- **Function:** `max98396_resume()` only
- **Scope:** single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record (verified against `703ee0557f892` original resume and current
`max98396_resume()`):

| Path | Before | After |
|---|---|---|
| core enable fails | return, nothing enabled | unchanged |
| pvdd enable fails | **return with core still enabled** | `goto
err_core_supplies` → disable core |
| vbat enable fails | **return with core (+ pvdd) still enabled** |
`goto err_pvdd` → disable pvdd if present, then core |
| `regcache_sync()` fails | **ignored; return 0** | restore cache-only +
mark dirty, unwind vbat/pvdd/core, **return error** |
| success | return 0 | return 0 |

Error labels check optional regulators before disable (`if
(max98396->vbat)` / `if (max98396->pvdd)`), so NULL optional supplies
are not disabled.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** (a) error-path resource leak + (g) ignored return /
  incorrect success
- **Mechanism:** resume acquired regulators without matching disable on
  later failure; `regcache_sync()` failure was dropped so PM treated a
  failed register restore as success.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Unwind order matches enable order (core → pvdd → vbat). Labels are
  correct for optional supplies.
- Restoring `regcache_cache_only(true)` + `regcache_mark_dirty()` after
  a failed sync is the standard pattern so a later resume can retry.
- **Regression risk:** low. Error paths only. `device_resume()` in this
  tree sets `dev->power.is_suspended = false` **before** the callback
  (`drivers/base/power/main.c` line 1129), so a later suspend may
  `regulator_disable()` already-disabled supplies and warn. That class
  of imbalance already existed on some old failure paths; leaking
  enables (keeping rails on) is worse. Sibling ASoC patches in the same
  series use the same unwind-on-resume-fail pattern.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Driver added: `b585811367705` (“ASoC: max98396: add amplifier driver”)
- Buggy regulator resume: **`703ee0557f892` (“ASoC: max98396: add
  voltage regulators”, 2022-06-27)** — **present in v6.0** (`git merge-
  base --is-ancestor 703ee0557f892 v6.0` succeeded; not in v5.19)
- Resume body was unchanged from that commit until this fix (blame:
  Daniel Mack 2022 for enable/return, Pengpeng Hou 2026 for gotos)

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: **No Fixes: tag.** Introducing commit is `703ee0557f892`, in
this tree and in v6.0+.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Later history is probe/PM-macro/style (`c009893bc5864`
SYSTEM_SLEEP_PM_OPS, DAPM convert, named initializers). **No
prerequisite refactor of resume.** **Standalone** for this file. Cover
letter lists it as **18/19** of an independent per-codec series, not a
stacked dependency.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Pengpeng Hou is **not** the ASoC maintainer. Same week: many
`Propagate regcache_sync() errors` codec patches. Maintainer who applied
this one: **Mark Brown**.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: **None required.** Touches only `max98396_resume()`, existing
`regulator_*` / `regcache_*` APIs. Can apply standalone. No follow-ups
on this file after `d20de7409dfa8`.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- **b4 dig:**
  https://patch.msgid.link/20260704040651.47558-1-pengpeng@iscas.ac.cn
- **Series:** v1 only, **[PATCH 00/19] ASoC: codecs: propagate
  regcache_sync() failures** (`20260704034845.14291-1`)
- Cover letter (from saved mbox): *“This series is source-audited only.
  I did not test on the affected hardware.”* Explicitly calls out
  max98396 as one of four patches that also unwind resources.
- **No NAK** on this patch. Richard Fitzgerald `Reviewed-by` on sibling
  Cirrus patches (wm2200/cs4349/wm8962). Mark Brown discussed revert-on-
  sync-fail for wm8962 and said not to over-engineer recovery without a
  real use case — **not a NAK of unwind/propagate**.
- Mark applied **18/19** (skipped 03/19 lpass-wsa-macro) to `for-7.3`.
- **No reviewer Cc: stable** on this patch.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: Recipients included Mark Brown, Liam Girdwood, linux-sound,
codec vendors. **No Reviewed-by on the max98396 patch itself.** Applied
by the ASoC maintainer.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: **No user/syzbot/bugzilla report.** Source audit only.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: 19 independent per-driver patches. This one does not need the
others.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: **UNVERIFIED** — lore.kernel.org HTTP search returned 403.
Thread retrieved via `b4 dig -m` has no stable discussion.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**
Record: `max98396_resume()` only. Helpers used:
`regulator_bulk_enable/disable`, `regulator_enable/disable`,
`regcache_cache_only`, `regcache_mark_dirty`, `regcache_sync`,
`max98396_reset()`.

**Step 5.2: TRACE CALLERS**
Record: Only wired through `SYSTEM_SLEEP_PM_OPS(max98396_suspend,
max98396_resume)` → `max98396_pm` → `i2c_driver.driver.pm`. Called from
**system sleep resume**, not a hot syscall path.

**Step 5.3: TRACE CALLEES**
Record: Regulator enable/disable and regmap cache replay after
`max98396_reset()`. Probe enables the same supplies and uses
`devm_add_action_or_reset()` to unwind; **resume has no equivalent**
without this patch.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace suspend (`/sys/power/state` or equivalent) →
`dpm_resume` → `device_resume` → driver resume. **Reachable on any
machine with this codec that suspends.** Not unprivileged-exploit in the
UAF sense; it is a normal PM path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same author’s series applies the same propagate/unwind pattern
across many ASoC codecs. This driver uniquely also unwinds three
supplies.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** File `sound/soc/codecs/max98396.c` is present.
Introducing commit `703ee0557f892` is an ancestor of HEAD. Bug since
**v6.0**. Current HEAD already contains `d20de7409dfa8` (the candidate);
pre-image of resume matches the patch’s before-state.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply** to this lineage’s pre-fix resume (identical to
v6.0-era function). `SYSTEM_SLEEP_PM_OPS` conversion (`c009893bc5864`)
did not change resume body. No conflicting local changes to that
function.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No earlier alternate fix of this leak. No later revert/follow-up
on this file.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **ASoC codec driver** (`sound/soc/codecs/max98396.c`).
**PERIPHERAL / driver-specific** (MAX98396/MAX98397 speaker amps, I2C,
ACPI IDs `ADS8396`/`ADS8397`). Not core mm/net/fs.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: ASoC codecs are actively developed; this file is **mature**
(driver 2022, regulators 2022, few functional changes since). Long-lived
bug, not a brand-new subsystem.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**
Record: **Driver-specific / config-specific**
(`CONFIG_SND_SOC_MAX98396`). Implied by a large ASoC codec umbrella
Kconfig; in-tree DT only has the binding example (no board `.dts` in
this tree). ACPI/OF/I2C IDs exist for real hardware.

**Step 8.2: TRIGGER CONDITIONS**
Record:
- System suspend/resume with this codec bound.
- **pvdd/vbat enable fail:** uncommon (regulator failure).
- **`regcache_sync()` fail:** more realistic (I2C error after
  reset/power-up). Old code returned **0** in that case — **every such
  failure was silent**.
- Unprivileged user cannot typically force I2C failure; they can trigger
  suspend.

**Step 8.3: FAILURE MODE SEVERITY**
Record:
- Regulator leak / enable-count imbalance → **HIGH for that class, but
  rare trigger**
- Silent successful resume with unrestored registers → **broken audio
  after suspend**, device in reset defaults → **MEDIUM** (user-visible,
  not panic/corruption)
- **Overall severity: MEDIUM** (important for this hardware, not a
  kernel-wide crash)

**Step 8.4: RISK-BENEFIT RATIO**
Record:
- **Benefit:** medium for MAX98396/97 users (correct resume failure, no
  leaked supplies, cache left retryable)
- **Risk:** low (21 lines, one function, error paths, obvious labels)
- **Ratio:** favorable

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real bugs: leaked enabled regulators on resume failure; ignored
  `regcache_sync()` so resume can succeed with hardware not restored
- Small, contained, obviously correct unwind
- Bug in this tree since v6.0 (`703ee0557f892`)
- No extra APIs/features; no series dependency
- ASoC maintainer merged it; sibling patches reviewed
- Matches stable’s usual error-path leak / missing-cleanup pattern

**AGAINST:**
- Source-audited only; author did not test on hardware
- No user/syzbot reports
- Not a panic, UAF, or data-corruption bug
- Peripheral codec, not core
- Possible extra `regulator_disable` on the *next* suspend if PM still
  treats the device as resumed after a failed callback (pre-existing PM
  interaction, mild)

**UNRESOLVED:**
- lore.kernel.org search 403; no independent confirmation of stable-list
  discussion
- No in-tree board DT showing how widely this amp is shipped (ACPI IDs
  still indicate real products)

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** on correctness (labels match
   enable order). **Weak on hardware test** (source audit), but soak in
   this 7.3-rc tree and maintainer merge count as review, not a FAIL.
2. Fixes a real bug that affects users? **PASS** — leak + silent failed
   cache replay after suspend.
3. Important issue? **PASS at MEDIUM** — not crash/security, but broken-
   audio-after-resume and regulator leak on a production PM path. Error-
   path resource cleanup is an accepted stable class.
4. Small and contained? **PASS** — +21/−3, one function, one file.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — driver and buggy resume exist
   here; pre-fix code matches the hunk.

**Step 9.3: EXCEPTION CATEGORIES**
Record: None (not a device ID, quirk, DT, build, or docs-only change).
Qualifies as a normal small bugfix.

**Step 9.4: DECISION**
This tree has the buggy resume path and the hardware driver. The patch
is a surgical fix for a real resume leak and a real ignored-error
success path. Conservative severity, but it meets the letter of the
stable rules and the “error-path leak = backport” guidance. Risk is low
enough to take it.

---

### What the commit solves for this tree

`max98396_resume()` can enable core (and maybe pvdd) supplies then
return without disabling them, and it previously ignored
`regcache_sync()`. After suspend, a failed I2C cache replay left the amp
in reset/defaults while PM thought resume succeeded. The patch unwinds
every supply this resume acquired, restores cache-only/dirty on sync
failure, and returns the error.

### Stable-rules fit

Small, obviously correct, no new API, applies to this tree’s long-
standing resume function. Importance is medium (driver PM error path),
not a core crash, but it is a real user-visible resume bug plus a
resource leak.

### Risk vs benefit

Benefit is correct suspend/resume for MAX98396/97. Risk is confined to
failure paths already returning errors (except the newly propagated sync
failure, which *should* fail).

### Concerns

Untested on hardware; no field reports. That is not enough to drop a
21-line leak/error-propagation fix for a driver this tree actually
ships.

### Verification
- **[Phase 1]** Parsed subject/tags/body from `git show d20de7409dfa8`;
  no Fixes/Reported-by/Cc stable; Link to msgid 20260704040651.47558-1
- **[Phase 2]** Diff: +21/−3 in `max98396_resume()` only; compared to
  original resume in `703ee0557f892`
- **[Phase 3]** `git blame -L 1574,1634 sound/soc/codecs/max98396.c`;
  introducer `703ee0557f892`; in v6.0, not v5.19; `git merge-base --is-
  ancestor` for both introducer and fix vs HEAD
- **[Phase 3]** `git log --oneline -- sound/soc/codecs/max98396.c`; no
  resume prerequisites; no follow-ups after the fix
- **[Phase 3]** `git describe HEAD` / `make kernelversion` / Makefile:
  **v7.3-rc4, 7.3.0-rc4**
- **[Phase 4]** `b4 dig -c/-a/-w/-m`: series 18/19, v1 only, cover
  letter “source-audited only”; Mark Brown applied to for-7.3; no NAK on
  this patch
- **[Phase 4]** lore HTTP search 403 — stable-list discussion
  **UNVERIFIED**
- **[Phase 5]** Callers: only `SYSTEM_SLEEP_PM_OPS` → i2c `.pm`; probe
  uses `devm_add_action_or_reset` for the same supplies
- **[Phase 6]** Buggy resume exists in this tree from v6.0; current file
  already has the fixed form
- **[Phase 8]** `device_resume()` sets `is_suspended = false` before the
  callback (main.c:1126–1129, 1192)
- **UNVERIFIED:** in-tree board usage (no `.dts` nodes; ACPI/OF IDs
  only)

**YES**

 sound/soc/codecs/max98396.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/max98396.c b/sound/soc/codecs/max98396.c
index 4b4e1fc98a6da..0255399c405df 100644
--- a/sound/soc/codecs/max98396.c
+++ b/sound/soc/codecs/max98396.c
@@ -1601,19 +1601,37 @@ static int max98396_resume(struct device *dev)
 	if (max98396->pvdd) {
 		ret = regulator_enable(max98396->pvdd);
 		if (ret < 0)
-			return ret;
+			goto err_core_supplies;
 	}
 
 	if (max98396->vbat) {
 		ret = regulator_enable(max98396->vbat);
 		if (ret < 0)
-			return ret;
+			goto err_pvdd;
 	}
 
 	regcache_cache_only(max98396->regmap, false);
 	max98396_reset(max98396, dev);
-	regcache_sync(max98396->regmap);
+	ret = regcache_sync(max98396->regmap);
+	if (ret < 0) {
+		regcache_cache_only(max98396->regmap, true);
+		regcache_mark_dirty(max98396->regmap);
+		goto err_vbat;
+	}
+
 	return 0;
+
+err_vbat:
+	if (max98396->vbat)
+		regulator_disable(max98396->vbat);
+err_pvdd:
+	if (max98396->pvdd)
+		regulator_disable(max98396->pvdd);
+err_core_supplies:
+	regulator_bulk_disable(MAX98396_NUM_CORE_SUPPLIES,
+			       max98396->core_supplies);
+
+	return ret;
 }
 
 static const struct dev_pm_ops max98396_pm = {
-- 
2.53.0

