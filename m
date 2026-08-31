Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721D94AD7F5;
	Mon, 31 Aug 2026 13:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184106; cv=none; b=Wd3lssfJYcp/I10zjBVAWyIraTZQNybE5vS05w6OS6VamwmE9BlS4poA+OVHh0UnNo4GLv31fWW3iP+GbvxX1m7fgVvzEI8jVDm3elKmnaSUBl1Ezw2yOLo4TTXipNMYoo2OMe6Fo7Errph7laFoibk/rmW42n/vVLURFu0hEsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184106; c=relaxed/simple;
	bh=Uk3deyNc6IyZ9UHG1tRiGfESvAEVt3YX1B0xoBuDCQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AFldOQYZ4iQ1QaudgeSOVxO4rChmU7LNMBUz1Bs+Uympqr36jazf1OScLBJaH+NcJ+tVInL2YL9aCdThwybCX7rmEp3P7LB/wS+7AdkVGh9e1B0KkbVeKd5asvrHNcT3LZ3UFSGGdJG3+TJQwwm+2doBuqfk3E2fmIau5oNXspw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PrOk3PGc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PrOk3PGc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5BFA1F000E9;
	Mon, 31 Aug 2026 13:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184103;
	bh=mxb+OX744UctfYKRoE/CDKw5ggMM/hQGuQfvjfOr9/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PrOk3PGcCt8peackB4lQTkQIsc+DrEFBaSbzQnU7dZR1xIThUDNgW4EIYdPR6L0le
	 WvIinX3hj4rJQ/0Eh7dQI0Lon7x40WB+mXgLy5MD5/cnXslO3eCwPjUc+gZpZFxuAb
	 FZDxIHkkb1Ujxinl/h9LOABe0SQXDJWNg+JWjr2FyxWpBhnT+ncUK8DZkkDtZZ0053
	 59RMlZgW6Dh/+dpPhlISY4e/d+R2slB3stCebyltloniTALGp6b1ge1tYQrxWdZSyF
	 /2vOHKA8NYS9sPmiWEubM8Rq++/NBguq8EtAE2ztMlOzzfIXufCV8CYBSmJMk9ncG2
	 zx0QF1OgNmXuQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Baojun Xu <baojun.xu@ti.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	shenghao-ding@ti.com,
	kevin-lu@ti.com,
	sen@ti.com,
	lgirdwood@gmail.com,
	broonie@kernel.org,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: hda/tas2781: Fix device-0 reset issue and handle -EXDEV in block data processing
Date: Mon, 31 Aug 2026 09:28:40 -0400
Message-ID: <20260831133314.4125787-492-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Baojun Xu <baojun.xu@ti.com>

[ Upstream commit 513480da5e9c8f55b4f8f5e89f386e26188fbb3f ]

Fix reset for device-0:‌ In older projects (e.g., Merino), the hardware
reset pin for the first SPI device (device-0) is ineffective, causing
initialization failures. Added a software reset sequence for device-0
to ensure proper initialization.

‌Handle -EXDEV correctly:‌ When processing block data, if the data does
not belong to the current SPI device, the driver returned -EXDEV.
This error code is now ignored to allow the driver to continue iterating
through the block data and correctly calculate the total block size.

Signed-off-by: Baojun Xu <baojun.xu@ti.com>
Link: https://patch.msgid.link/20260609105253.19510-1-baojun.xu@ti.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ALSA: hda/tas2781: Fix device-0 reset issue
and handle -EXDEV in block data processing

**Local tree:** Linux **6.18.44** (`git describe HEAD` → `v6.18.44`,
Makefile `VERSION.PATCHLEVEL.SUBLEVEL` = 6.18.44)

**Commit under review:** `513480da5e9c8` (on `master`, **not** in this
6.18.44 tree)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse Subject Line
**Record:** `[ALSA: hda/tas2781]` `[Fix]` — Fix device-0 reset issue and
handle `-EXDEV` in block data processing.

### Step 1.2: Parse All Commit Message Tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Link:**
  `https://patch.msgid.link/20260609105253.19510-1-baojun.xu@ti.com`
- **Cc: stable:** — none
- **Signed-off-by:** Baojun Xu `<baojun.xu@ti.com>` (author), Takashi
  Iwai `<tiwai@suse.de>` (ALSA maintainer merge)
- **Notable:** No syzbot; HP/Canonical contacts on original patch CC
  list (verified via `b4 dig -w`)

### Step 1.3: Analyze Commit Body
**Record:**
- **Bug 1 (reset):** On older HP projects (e.g., Merino), the hardware
  reset GPIO for SPI device-0 is ineffective. Driver only performed
  software reset when no GPIO was present, so device-0 could fail to
  initialize.
- **Bug 2 (-EXDEV):** During firmware block processing, writes to
  channels not owned by the current SPI device intentionally return
  `-EXDEV` from `tasdevice_spi_change_chn_book()`.
  `tasdevice_process_block()` treated this as a real error, breaking
  firmware parsing/loading.
- **Symptom:** Amplifier initialization / firmware download failures →
  no audio on affected HP laptops.
- **Root cause:** Incorrect reset sequencing (HW-only when GPIO present)
  and mishandling of intentional `-EXDEV` in shared fmwlib code.

### Step 1.4: Detect Hidden Bug Fixes
**Record:** Not disguised — explicitly described as fixes. Both are real
functional bugs (hardware quirk + error-handling logic), not cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory Changes
**Record:**
- `sound/hda/codecs/side-codecs/tas2781_hda_spi.c`: ~16 lines changed
  (reset logic restructured)
- `sound/soc/codecs/tas2781-fmwlib.c`: 3 error checks modified (+3 lines
  net)
- **Functions:** `tas2781_spi_reset()`, `tasdevice_process_block()`
- **Scope:** Single-file surgical fix in SPI driver + 3 guarded
  conditions in shared fmwlib

### Step 2.2: Code Flow Change (per hunk)

**Hunk 1 — `tas2781_spi_reset()`:**
- **Before:** If `tas_dev->reset` GPIO exists → HW reset only; else → SW
  reset via register write.
- **After:** If GPIO exists → HW reset, **then always** SW reset via
  `TASDEVICE_REG_SWRESET`.
- **Path:** Called before firmware download in `tascodec_spi_fw_load()`
  (line 680).

**Hunk 2-4 — `tasdevice_process_block()`:**
- **Before:** Any `rc < 0` from write/bulk_write/update_bits → `is_err =
  true` → error log + potential `cur_prog`/`cur_conf` reset.
- **After:** `-EXDEV` ignored when `tas_priv->isspi` is true; other
  errors still handled.
- **Path:** Firmware block loading during `tasdevice_prmg_load()` /
  `tasdevice_select_cfg_blk()`.

### Step 2.3: Bug Mechanism
**Record:**
- **Category (a):** Hardware workaround — ineffective reset GPIO on
  device-0
- **Category (g):** Logic/correctness — intentional `-EXDEV`
  misclassified as failure
- **Mechanism:** `tasdevice_spi_change_chn_book()` returns `-EXDEV` when
  `chn != p->index` (lines 179-183 of current tree), with `dev_dbg("Not
  error...")`. Without the fix, `is_err` triggers state corruption at
  lines 989-994 of `tas2781-fmwlib.c`.

### Step 2.4: Fix Quality
**Record:**
- Fix is minimal and obviously correct.
- SW reset after HW reset is low risk (TI author, HP-validated
  hardware).
- `-EXDEV` guard is narrowly scoped to `isspi && rc == -EXDEV`; I2C path
  unchanged.
- **Regression risk:** Very low.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame Changed Lines
**Record:**
- `tas2781_spi_reset()` HW/SW if-else: introduced in `9fa6a693ad8dc`
  (2025-04-29, refactor to shared fmwlib); original function from
  `bb5f86ea50ffb` (2024-12-16).
- `tasdevice_process_block()` error check: from `915f5eadebd29b`
  (2023-06-18, original fmwlib).
- Buggy reset logic present since April 2025 refactor; EXDEV mishandling
  since fmwlib creation.

### Step 3.2: Follow Fixes: Tag
**Record:** No `Fixes:` tag — N/A.

### Step 3.3: File History
**Record:** Recent stable backports to this tree for same driver:
- `16b65c8ca3160` — Ignore reset check for SPI device (already in
  6.18.y)
- `24c22c644ea53` — Fix incorrect bit update for SPI
- `f8272331da877` — Cancel async firmware request at unbind

Shows active stable maintenance of this driver. Standalone fix, not part
of a series.

### Step 3.4: Author Context
**Record:** Baojun Xu is the TAS2781 HDA SPI driver author (TI). Takashi
Iwai merged. Related stable fix `16b65c8ca3160` by same author already
backported here.

### Step 3.5: Dependencies
**Record:** No prerequisites. Uses existing `isspi` field (set at line
240 of `tas2781_hda_spi.c`) and existing `-EXDEV` return in
`tasdevice_spi_change_chn_book()`. Applies standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Patch Discussion
**Record:**
- `b4 dig -c 513480da5e9c8` → v1 only:
  `https://patch.msgid.link/20260609105253.19510-1-baojun.xu@ti.com`
- Lore thread fetch blocked (Anubis bot protection) — could not read
  inline review replies.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` CC list includes `tiwai@suse.de`,
`broonie@kernel.org`, `linux-sound@vger.kernel.org`, HP contacts
(`letitia.tsai@hp.com`, `pin-hao.huang@hp.com`), Canonical
(`bill.yu@canonical.com`). Appropriate subsystem coverage.

### Step 4.3: Bug Report
**Record:** No formal bug report or syzbot link. Hardware issue
described in commit message referencing Merino project; HP PCI quirks in
tree confirm real hardware (`alc269.c` lines 7004-7042).

### Step 4.4: Related Patches
**Record:** Single-patch series (v1 only). Related prior fix
`16b65c8ca3160` already in this tree — complementary, not a dependency.

### Step 4.5: Stable Mailing List
**Record:** Not searched (lore blocked). No stable nomination found via
b4.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `tas2781_spi_reset()`, `tasdevice_process_block()`, callers
`tascodec_spi_fw_load()`, `tasdevice_select_cfg_blk()`,
`tasdevice_load_block_kernel()`.

### Step 5.2: Callers
**Record:**
- `tas2781_spi_reset()` → called from firmware load path before
  `tasdevice_prmg_load()` (probe/init path for SPI codec).
- `tasdevice_process_block()` → firmware loading during driver
  initialization and profile switching.
- Triggered when HP laptop with `ALC245_FIXUP_TAS2781_SPI_2` quirk loads
  TAS2781 SPI amplifier.

### Step 5.3: Callees
**Record:** `tasdevice_dev_write()`, `gpiod_set_value_cansleep()`,
`fsleep()` — standard register/GPIO operations.

### Step 5.4: Reachability
**Record:** Reachable on boot for affected HP Gemtree/Merino laptops
(PCI IDs `0x103c:0x8de8-0x8de9`, `0x103c:0x8ed5-0x8eda`). Requires
`CONFIG_SND_HDA_SCODEC_TAS2781_SPI`. User-visible: speakers don't work
without fix.

### Step 5.5: Similar Patterns
**Record:** `-EXDEV` intentionally used only in SPI `change_chn_book`
callback; `dev_dbg` already says "Not error". Fix aligns fmwlib with SPI
driver's intent.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Does Buggy Code Exist?
**Record:** **YES.** Current tree at HEAD has:
- `tas2781_spi_reset()` with if/else (HW-only when GPIO present) — lines
  192-204
- `tasdevice_process_block()` treating all `rc < 0` as errors — lines
  908, 940, 978
- `git merge-base --is-ancestor 513480da5e9c8 HEAD` → exit 1 (fix
  **not** present)
- Driver present: `git merge-base --is-ancestor bb5f86ea50ffb HEAD` →
  exit 0

### Step 6.2: Backport Complications
**Record:** **Clean apply verified** — `git cherry-pick --no-commit
513480da5e9c8` auto-merged both files without conflicts on 6.18.44.

### Step 6.3: Related Fixes Already Present?
**Record:** `16b65c8ca3160` (reset check ignore) already backported.
This commit is the next logical fix for the same driver/hardware — not a
duplicate.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** `sound/hda` + `sound/soc/codecs` — **IMPORTANT** (audio on
specific laptops, not core kernel).

### Step 7.2: Subsystem Activity
**Record:** Actively maintained in 6.18.y — 3 tas2781 SPI commits since
v6.18 tag.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users of HP Gemtree and Merino laptops with TAS2781 SPI
amplifiers (`CONFIG_SND_HDA_SCODEC_TAS2781_SPI`). Driver-specific, not
universal.

### Step 8.2: Trigger Conditions
**Record:** Every boot / driver probe on affected hardware. Not timing-
dependent. Unprivileged users cannot trigger directly, but all users on
these machines lose audio.

### Step 8.3: Failure Mode Severity
**Record:**
- Reset failure → firmware download fails → **no audio** (functional
  breakage, HIGH for affected users)
- EXDEV mishandling → false errors, `cur_prog`/`cur_conf` reset →
  **broken amplifier config** (HIGH for affected users)
- Not a kernel crash/oops, but complete loss of audio is user-visible
  and important.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH for HP Merino/Gemtree users (audio works)
- **Risk:** LOW — 23-line change, narrowly scoped, hardware quirk
  pattern
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Fixes real hardware bugs on HP laptops already quirked in this tree
- Initialization failure = no audio (important user impact)
- Small, surgical, applies cleanly to 6.18.44
- Same author's related fix already backported to this tree
- Hardware quirk workaround (ineffective reset GPIO) — classic stable
  material
- Merged by ALSA maintainer Takashi Iwai
- HP engineers on original patch CC list

**AGAINST backport:**
- Driver is relatively new (but present since 6.18.0 in this tree)
- Only affects SPI TAS2781 HDA path (limited audience)
- No syzbot/crash report (functional bug, not security)

**Unresolved:** Lore review thread content (bot-blocked); no explicit
Tested-by in commit.

### Step 9.2: Stable Rules Checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — logic clear; HP CC'd on
patch |
| 2. Fixes real bug affecting users? | **PASS** — audio init failure on
Merino/Gemtree |
| 3. Important issue? | **PASS** — complete audio failure on affected
laptops |
| 4. Small and contained? | **PASS** — 2 files, ~23 lines |
| 5. No new features/APIs? | **PASS** — hardware workaround + error
handling |
| 6. Can apply to local tree? | **PASS** — clean cherry-pick verified |

### Step 9.3: Exception Categories
**Record:** **Hardware quirk/workaround** — ineffective reset GPIO on
device-0; always perform software reset.

### Step 9.4: Decision Rationale

This commit fixes two real bugs in the TAS2781 HDA SPI driver that cause
amplifier initialization and firmware loading failures on HP Merino and
Gemtree laptops — hardware already supported via PCI quirks in
`alc269.c` in this 6.18.44 tree. The driver and buggy code are both
present; the fix is absent. The patch is small, self-contained, applies
cleanly, and follows the established pattern of tas2781 fixes already
backported to 6.18.y. While not a crash or security issue, complete loss
of audio on shipping laptop hardware meets stable criteria for an
important functional bug fix in an existing driver.

---

## Verification

- **[Phase 1]** Parsed commit `513480da5e9c8` message and tags via `git
  show`
- **[Phase 1]** Confirmed no Fixes:/Reported-by:/Tested-by: tags
- **[Phase 2]** Read current buggy code in `tas2781_hda_spi.c` lines
  188-205 and `tas2781-fmwlib.c` lines 860-998
- **[Phase 2]** Verified `-EXDEV` return path in
  `tasdevice_spi_change_chn_book()` lines 163-186
- **[Phase 2]** Verified `is_err` side effects at lines 989-994 of
  fmwlib
- **[Phase 3]** `git blame` on reset function and error checks
- **[Phase 3]** `git log --oneline -20` on both modified files
- **[Phase 3]** `git merge-base --is-ancestor` — fix NOT in HEAD, driver
  IS in HEAD
- **[Phase 4]** `b4 dig -c 513480da5e9c8` — found v1 patch URL
- **[Phase 4]** `b4 dig -w` — confirmed maintainer/HP CC list
- **[Phase 4]** `b4 dig -a` — single v1 revision only
- **[Phase 4]** UNVERIFIED: Lore thread review content (Anubis bot
  protection on fetch)
- **[Phase 5]** `grep` traced callers of `tasdevice_process_block` and
  `tas2781_spi_reset`
- **[Phase 5]** Verified `tas_priv->isspi = true` at line 240 of SPI
  driver
- **[Phase 5]** Grep found HP Merino/Gemtree PCI quirks in `alc269.c`
  lines 7004-7042
- **[Phase 6]** `git describe HEAD` → v6.18.44; Makefile confirms
  6.18.44
- **[Phase 6]** `git cherry-pick --no-commit 513480da5e9c8` — clean
  auto-merge
- **[Phase 6]** Confirmed fix not already in tree
- **[Phase 7]** `git log v6.18..HEAD` — 3 prior tas2781 SPI stable
  backports
- **[Phase 8]** Assessed impact on HP laptop users with TAS2781 SPI
  config

**YES**

 sound/hda/codecs/side-codecs/tas2781_hda_spi.c | 16 ++++++++--------
 sound/soc/codecs/tas2781-fmwlib.c              |  7 ++++---
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/sound/hda/codecs/side-codecs/tas2781_hda_spi.c b/sound/hda/codecs/side-codecs/tas2781_hda_spi.c
index ab2a2472d7bdc..30393ae09dcc3 100644
--- a/sound/hda/codecs/side-codecs/tas2781_hda_spi.c
+++ b/sound/hda/codecs/side-codecs/tas2781_hda_spi.c
@@ -193,15 +193,15 @@ static void tas2781_spi_reset(struct tasdevice_priv *tas_dev)
 		gpiod_set_value_cansleep(tas_dev->reset, 0);
 		fsleep(800);
 		gpiod_set_value_cansleep(tas_dev->reset, 1);
-	} else {
-		ret = tasdevice_dev_write(tas_dev, tas_dev->index,
-			TASDEVICE_REG_SWRESET, TASDEVICE_REG_SWRESET_RESET);
-		if (ret < 0) {
-			dev_err(tas_dev->dev, "dev sw-reset fail, %d\n", ret);
-			return;
-		}
-		fsleep(1000);
 	}
+
+	ret = tasdevice_dev_write(tas_dev, tas_dev->index,
+		TASDEVICE_REG_SWRESET, TASDEVICE_REG_SWRESET_RESET);
+	if (ret < 0) {
+		dev_err(tas_dev->dev, "dev sw-reset fail, %d\n", ret);
+		return;
+	}
+	fsleep(1000);
 }
 
 static int tascodec_spi_init(struct tasdevice_priv *tas_priv,
diff --git a/sound/soc/codecs/tas2781-fmwlib.c b/sound/soc/codecs/tas2781-fmwlib.c
index 2f6522f76df9b..0bcd8c131623a 100644
--- a/sound/soc/codecs/tas2781-fmwlib.c
+++ b/sound/soc/codecs/tas2781-fmwlib.c
@@ -905,7 +905,8 @@ static int tasdevice_process_block(void *context, unsigned char *data,
 						data[subblk_offset + 1],
 						data[subblk_offset + 2]),
 					data[subblk_offset + 3]);
-				if (rc < 0) {
+				if (rc < 0 &&
+				    !(tas_priv->isspi && rc == -EXDEV)) {
 					is_err = true;
 					dev_err(tas_priv->dev,
 					"process_block: single write error\n");
@@ -937,7 +938,7 @@ static int tasdevice_process_block(void *context, unsigned char *data,
 				data[subblk_offset + 1],
 				data[subblk_offset + 2]),
 				&(data[subblk_offset + 4]), len);
-			if (rc < 0) {
+			if (rc < 0 && !(tas_priv->isspi && rc == -EXDEV)) {
 				is_err = true;
 				dev_err(tas_priv->dev,
 					"%s: bulk_write error = %d\n",
@@ -975,7 +976,7 @@ static int tasdevice_process_block(void *context, unsigned char *data,
 				data[subblk_offset + 4]),
 				data[subblk_offset + 1],
 				data[subblk_offset + 5]);
-			if (rc < 0) {
+			if (rc < 0 && !(tas_priv->isspi && rc == -EXDEV)) {
 				is_err = true;
 				dev_err(tas_priv->dev,
 					"%s: update_bits error = %d\n",
-- 
2.53.0

