Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952A253445D;
	Mon, 31 Aug 2026 13:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183920; cv=none; b=IgaMzsQhJEM8BipTIkORpgMVhSAbVweLNFsHLr5mqOWARITcGlFxpkMXKHYDJ2dd3WBT2FpVWxDQrfnKomaiXdLgz9l/BGQMIj8IS8COdqE5ZA1cQNEWIz+wJWF85ocinN2JqkwUktj7bGzXFXltPsfpohmT/Ni4vgSSXWohsss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183920; c=relaxed/simple;
	bh=VbGYHwMRLeCjqZ7ALbnJB4+mP7qtdzR+fO0BCiMVbxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mcMBUBxE7/Msfqu7kEx0+hf8udFMStS+h5talPWZwYTyV3hTJFtxIvWP7Cj1wvSt7ua48W+bLCe3p9fVokCR73Y8H9AJ0D0V2UCaAFLxpbJ8fmDW4PvvQYsOFF84fePOt7Vjsi74prK2tWEhV9fVavJfyFK5pW7NXHdE2z5HjbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nz4aN8ZG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nz4aN8ZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7281F000E9;
	Mon, 31 Aug 2026 13:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183918;
	bh=b1f0TQYeHA2+bRhIr+SRXjRb0rSk0DfsBSL36YQrvPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nz4aN8ZGJNDW/jETlgGCB3+FOtClKfF18eZgqaDueXFQxN+1SvMzaQGs2cW3NnuDL
	 6KProifgjugmPzEFy3C7vQuIMEaWpxruHKZWAcKs1qWdKWb4F1nvecEEOBFEGtcwVf
	 OWheSZm7qlgi2T3YSjc9gK0cZ2VH7bYEV5cQZuKzWiKQ6BxPEgdSYCPlxEHWFip/IP
	 ksTTHShTB955+eXqBtERSk+qAYWXae7k36QKWZzjhWnHLlkfMPJ7KDRGCsr3weMMOH
	 EdKxNDj3TgXa/lX+wC84sxxB9POSbhrE3ZumbdJayR3gvTcQh9bKyjSZeuDtMzw68h
	 0mALcicYTLMWQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Philipp Oster <philippdev5396@outlook.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	shenghao-ding@ti.com,
	kevin-lu@ti.com,
	baojun.xu@ti.com,
	sen@ti.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: hda/tas2781: clear cali_data.total_sz when calibration read fails
Date: Mon, 31 Aug 2026 09:26:48 -0400
Message-ID: <20260831133314.4125787-380-sashal@kernel.org>
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

From: Philipp Oster <philippdev5396@outlook.de>

[ Upstream commit b6016332b8899a9775addf9b630b0a53a849c8ed ]

tas2563_save_calibration() assigns cali_data.total_sz before it reads the
per-device calibration data from EFI, but its error paths return without
clearing it again. cali_data.cali_reg_array is left all zero, because the
function returns before the register addresses are assigned.

On the first playback tasdev_load_calibrated_data() does

	if (!data || !cali_data->total_sz)
		return;

which passes, since total_sz is still non-zero. It then issues five
4-byte bulk writes to p->r0_reg, p->r0_low_reg, p->invr0_reg, p->pow_reg
and p->tlimit_reg, all of which are 0. Register 0 decodes to book 0 /
page 0 / register 0x00, so the auto-incrementing block write zeroes
registers 0x00 to 0x03. Register 0x03 is PB_CFG1, which holds AMP_LEVEL,
so the amplifier gain is set to its minimum and the speaker stays silent.

This is reproducible on a Lenovo Yoga 7 14ARB7 (two TAS2563 on I2C,
ACPI INT8866) whose factory calibration was never written to UEFI, so the
EFI read fails with EFI_NOT_FOUND. The two woofers driven by the
amplifiers are silent while the tweeters driven directly by the ALC287
play. Reading the amplifier registers over i2c shows PWR_CTL = 0x00
(active) and the TDM slots correctly programmed by the RCA profile, but
PB_CFG1 = 0x00. With this change PB_CFG1 keeps its power-on default of
0x20 and both woofers play.

tas2781_save_calibration() in tas2781_hda.c already clears total_sz on
failure; do the same for the TAS2563 variant.

Signed-off-by: Philipp Oster <philippdev5396@outlook.de>
Link: https://patch.msgid.link/20260720-tas2781-calfix-v1-1-3a5fa6ad90bc@outlook.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ALSA hda/tas2781 calibration `total_sz` fix

**Local tree:** Linux **6.18.44** (`v6.18.44-2-g1b9e1abadee04`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[ALSA: hda/tas2781]` `[clear]` — clear stale
`cali_data.total_sz` on TAS2563 EFI calibration read failure.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Philipp Oster `<philippdev5396@outlook.de>`
  (author)
- **Link:** `https://patch.msgid.link/20260720-tas2781-calfix-v1-1-
  3a5fa6ad90bc@outlook.de`
- **Signed-off-by:** Takashi Iwai `<tiwai@suse.de>` (ALSA maintainer)
- No `Fixes:`, `Cc: stable`, `Reported-by:`, `Tested-by:`, `Reviewed-
  by:`

Notable: maintainer merge, detailed hardware reproduction, no
syzbot/fuzzer signal.

### Step 1.3: Body analysis
**Record:**
- **Bug:** `tas2563_save_calibration()` sets `cd->total_sz` before EFI
  reads; error paths return without clearing it. `cali_reg_array` stays
  zero because register addresses are assigned only on success.
- **Symptom:** On first playback, bogus bulk writes to register 0 zero
  `PB_CFG1` (AMP_LEVEL); woofers silent, tweeters (ALC287) still work.
- **Trigger:** Lenovo Yoga 7 14ARB7 (two TAS2563/INT8866), factory
  calibration absent from UEFI (`EFI_NOT_FOUND`).
- **Root cause (author):** Stale non-zero `total_sz` makes downstream
  calibration load proceed with zero register addresses and zeroed data.
- **Precedent:** `tas2781_save_calibration()` already clears `total_sz`
  on failure.

### Step 1.4: Hidden bug fix?
**Record:** Yes — explicit functional bug fix disguised as a small
error-path correction. Not cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `sound/hda/codecs/side-codecs/tas2781_hda_i2c.c` (+3 lines)
- **Function:** `tas2563_save_calibration()`
- **Scope:** Single-file, surgical (3 error paths)

### Step 2.2: Code flow per hunk
**Record:**
| Hunk | Before | After |
|------|--------|-------|
| snprintf failure | `return -EINVAL` with stale `total_sz` |
`cd->total_sz = 0; return -EINVAL` |
| EFI `get_variable` failure | same | same fix |
| `total_sz != offset` mismatch | same | same fix |

Normal success path unchanged; `is_user_space_calidata = true` and
register assignment still only on success.

### Step 2.3: Bug mechanism
**Record:** **Logic / state-consistency bug** — invalid calibration
state (`total_sz > 0`, zero `cali_reg_array`, zeroed `data`) left after
partial EFI read failure. Downstream `tasdev_load_calibrated_data()` can
issue bulk writes to register address 0, corrupting `PB_CFG1`.

**Note:** Commit message cites `if (!data || !cali_data->total_sz)
return;` in `tasdev_load_calibrated_data()`. That exact guard is **not
present** in this 6.18.44 tree; the user-space calibration path is gated
by `is_user_space_calidata`. The failure mode is still plausible if
`is_user_space_calidata` is true with unset registers, or if related
mainline logic differs. The `total_sz = 0` cleanup matches the
established `tas2781_save_calibration()` pattern regardless.

### Step 2.4: Fix quality
**Record:** Obviously correct, minimal, mirrors existing
`tas2781_save_calibration()` behavior (`tas2781_hda.c:228-230`). Very
low regression risk.

---

## PHASE 3: GIT HISTORY

### Step 3.1: Blame
**Record:** Buggy `tas2563_save_calibration()` present since file
introduction at merge `5d324e5159d9e` (6.18-rc8 era). `git blame` shows
error paths never cleared `total_sz`.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:** Related stable commits in this tree:
- `819268882628f` — skip UEFI calibration quirk (ASUS ROG Xbox Ally X)
- `00d880c469b75` — TAS2563 `speaker_id` init fix (Yoga 7 class
  hardware)
- `3646c928bb77c` — speaker ID retrieval refactor

Standalone fix; not part of a multi-patch series.

### Step 3.4: Author
**Record:** Philipp Oster — first-time contributor to this subsystem in
this tree; patch merged by Takashi Iwai.

### Step 3.5: Dependencies
**Record:** None. Applies standalone to `tas2563_save_calibration()`
only.

---

## PHASE 4: MAILING LIST / EXTERNAL RESEARCH

### Step 4.1–4.5
**Record:**
- `b4 dig` without commit hash failed (no commit in tree yet).
- Lore/patch.msgid.link blocked (Anubis 403 / bot protection).
- Could not retrieve review thread or stable nominations from lore.

**Inferred from commit:** Hardware-tested on Lenovo Yoga 7 14ARB7;
maintainer (Iwai) merged.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `tas2563_save_calibration()`,
`tasdev_load_calibrated_data()`, `tasdevice_dev_bulk_write()`

### Step 5.2: Callers
**Record:**
- `tas2563_save_calibration` → called from `tasdevice_dspfw_init()` via
  `hda_priv->save_calibration()` (return value **ignored**)
- `tasdev_load_calibrated_data` → called from
  `tasdevice_select_tuningprm_cfg()` on first DSP config load during
  playback

### Step 5.3: Callees
**Record:** `efi.get_variable()`, `devm_kzalloc()`,
`tasdevice_dev_bulk_write()` / `regmap_bulk_write()`

### Step 5.4: Reachability
**Record:** Triggered at audio init/playback on machines using TAS2563
HDA path (INT8866 ACPI). Lenovo Yoga 7 14ARB7 (`0x17aa:0x3870`) is in
this tree. User-visible without special privileges.

### Step 5.5: Similar patterns
**Record:** `tas2781_save_calibration()` already does
`cali_data->total_sz = 0` on EFI failure. TAS2563 variant was missing
the same cleanup.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **Yes.** `tas2563_save_calibration()` at lines 344–388
returns on error without clearing `total_sz`. INT8866/TAS2563 and Yoga 7
14ARB7 quirk present since 6.18-rc8.

### Step 6.2: Backport difficulty
**Record:** Clean apply expected — 3 identical lines on three existing
`return -EINVAL` paths.

### Step 6.3: Related fixes already present?
**Record:** `tas2781_save_calibration()` already clears `total_sz` on
failure. This specific TAS2563 fix is **not** yet in the tree.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem / criticality
**Record:** `sound/hda` — TAS2781 side-codec driver. **IMPORTANT**
(laptop audio on specific Lenovo hardware).

### Step 7.2: Activity
**Record:** Actively maintained in 6.18.y (multiple tas2781 stable
backports already landed).

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Users of Lenovo Yoga 7 14ARB7 and other INT8866/TAS2563 HDA
laptops missing factory UEFI calibration data.

### Step 8.2: Trigger conditions
**Record:** Boot + first playback when EFI calibration variables are
absent (`EFI_NOT_FOUND`). Reproducible on affected factory configs per
commit message.

### Step 8.3: Failure mode / severity
**Record:** **Silent woofer speakers** (partial audio loss). **MEDIUM-
HIGH** — not a crash or security issue, but serious functional
regression on real hardware.

### Step 8.4: Risk vs benefit
**Record:**
- **Benefit:** HIGH for affected laptop users
- **Risk:** VERY LOW (3-line error-path cleanup, established pattern)
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR:**
- Real, reproducible hardware bug (silent woofers on Yoga 7 14ARB7)
- Fix mirrors proven `tas2781_save_calibration()` pattern
- Minimal, surgical, maintainer-merged
- Affected hardware and driver code exist in 6.18.44
- Ignored `save_calibration()` return makes stale state especially
  dangerous

**AGAINST:**
- Commit message references a `total_sz` guard in
  `tasdev_load_calibrated_data()` not found in this tree (mechanism
  partially unverified statically)
- Lore review thread inaccessible
- Narrow hardware scope (TAS2563 HDA + missing UEFI cal)

**UNRESOLVED:** Exact static path to bulk-write-to-register-0 in 6.18.44
without the cited guard; author hardware testing is the primary
evidence.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — mirrors existing code;
   hardware-tested per commit
2. Fixes real bug affecting users? **PASS** — silent speakers on Lenovo
   Yoga 7 14ARB7
3. Important issue? **PASS** — significant functional audio failure
   (MEDIUM-HIGH)
4. Small and contained? **PASS** — 3 lines, one function
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — code present, clean apply
   expected

### Step 9.3: Exception category
**Record:** Hardware-specific driver bug fix for existing
TAS2563/INT8866 support (similar to other tas2781 stable backports).

### Step 9.4: Decision rationale
This is a clear omission in error handling for TAS2563 UEFI calibration
reads. The TAS2781 variant already clears `total_sz` on failure; leaving
it set allows corrupted amplifier register programming and silent
woofers on laptops without factory calibration in UEFI. The fix is tiny,
low-risk, and addresses a user-visible defect on hardware already
supported in 6.18.44.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body; no syzbot/stable tags
- **[Phase 2]** Diff: +3× `cd->total_sz = 0` in
  `tas2563_save_calibration()` error paths
- **[Phase 3]** `git describe HEAD` → v6.18.44; `git blame` → bug since
  5d324e5159d9e; related tas2781 stable commits found
- **[Phase 3]** Confirmed `tas2781_save_calibration()` clears `total_sz`
  at `tas2781_hda.c:228-230`
- **[Phase 4]** `b4 dig` / lore / patch.msgid.link — **BLOCKED**
  (403/Anubis)
- **[Phase 5]** Traced callers: `tasdevice_dspfw_init()` →
  `save_calibration()` (ignored return); `tasdev_load_calibrated_data()`
  → `tasdevice_select_tuningprm_cfg()`
- **[Phase 5]** **UNVERIFIED:** `if (!data || !cali_data->total_sz)`
  guard in `tasdev_load_calibrated_data()` — not found in 6.18.44
- **[Phase 6]** Buggy code confirmed in tree; Yoga 7 14ARB7 quirk at
  `alc269.c:7449`; INT8866 at `tas2781_hda_i2c.c:681-688`
- **[Phase 6]** Fix not yet applied in tree
- **[Phase 8]** Failure mode: silent woofers; severity MEDIUM-HIGH;
  benefit/risk favors backport

**YES**Those three background `git log -S` searches timed out or errored
— broad history searches on this repo are slow. The needed context was
already gathered with narrower commands:

- **`tas2563_save_calibration`** and **INT8866/TAS2563 HDA support**
  have been in the tree since the `tas2781_hda_i2c.c` introduction
  around the 6.18-rc8 merge (`5d324e5159d9e`), confirmed via `git blame`
  and `git show`.
- The **Lenovo Yoga 7 14ARB7** quirk (`0x17aa:0x3870`,
  `ALC287_FIXUP_YOGA7_14ARB7_I2C`) was also present at that same point
  in `alc269.c`.

That was enough to support the backport verdict: **YES** for 6.18.44.

 sound/hda/codecs/side-codecs/tas2781_hda_i2c.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c b/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c
index ebfc08b5fb283..ea80fd774bf24 100644
--- a/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c
+++ b/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c
@@ -356,6 +356,7 @@ static int tas2563_save_calibration(struct tas2781_hda *h)
 			if (ret < 0 || ret >= sizeof(var8) - 1) {
 				dev_err(p->dev, "%s: Read %s failed\n",
 					__func__, var8);
+				cd->total_sz = 0;
 				return -EINVAL;
 			}
 			/*
@@ -373,6 +374,7 @@ static int tas2563_save_calibration(struct tas2781_hda *h)
 				dev_warn(p->dev,
 					"Dev %d: Caldat[%d] read failed %ld\n",
 					i, j, status);
+				cd->total_sz = 0;
 				return -EINVAL;
 			}
 			bedata = cpu_to_be32(*(uint32_t *)&data[offset]);
@@ -384,6 +386,7 @@ static int tas2563_save_calibration(struct tas2781_hda *h)
 	if (cd->total_sz != offset) {
 		dev_err(p->dev, "%s: tot_size(%lu) and offset(%u) mismatch\n",
 			__func__, cd->total_sz, offset);
+		cd->total_sz = 0;
 		return -EINVAL;
 	}
 
-- 
2.53.0

