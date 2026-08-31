Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF23C50DDA1;
	Mon, 31 Aug 2026 13:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183769; cv=none; b=ZYIjk211vhFVcqd1Ylr3imPuxBLWWgN3lThvi/5fQYXEexfYD8W81fjLJyLignB8e0aMmckl3vIHh/B/SGKmsTRGfps9fF4+qQJqDppVgVTKUOtCFOnCVtGYaaoysIxkrB2QdVK2tz9z2xdtdQeI8tQLNu865eaSwHRjyM2W8uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183769; c=relaxed/simple;
	bh=6aQXyXvy6ClEwNi0a9SjPsN7BvdsMNdLnTMeFcn16Mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k8a2AZM0DM2CR0MEntYOnxCvwvq9+OBUs5AsYpRpBS5vzzGSAIBZKfkUFEgysxochwAeKCvcGL5Sjd/cQ3W9aYJ/x2tK7rO/Nocm5dZXBVAM8VCvnZ3U8Sa/QE0AByNzUX+Il+nGt4YygvBUjSIauHK35rYOaEC1VGV38Mvswi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I+Zog3Ky; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I+Zog3Ky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DFE21F000E9;
	Mon, 31 Aug 2026 13:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183766;
	bh=mY7vBTNMj5okLY9XpvpQUohcvN3B1Veh3GEY1CdggbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I+Zog3KyOpaJAlfguWFGUi+Z7bU6atLU2LDjxUM3jvhw52JkLWamQ5Klz9GIpAWEX
	 SLVklNCzidCQVzj9K5cE6gNJnAvPd4pHVFAEFr6J+zGBcKJrQoCTTiSaXrSw0EHoNO
	 ZNE9a+lDWFjSOAA7rpwPkWSiVxj2wTtaTW8B03UkrNZvAu2whIJKHW+Oi1yZfZKGwV
	 7Pk99IoHy6467oLf+IMbPn0KBj7IAdwOsJQjwfw6XcN7NF9MhfdLhVrtyIH8JOsj4o
	 pXash0d0yEWwnw3y1fdmqdHMqkA9qUOPpKQWaflkA+kk6g4bJrj+s3CUCSPn71tR31
	 cA0mTF/3tGL7Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tianze Shao <shaotianze@outlook.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	oder_chiou@realtek.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ASoC: rt712-sdca: reset codec at io_init to fix silent headphone
Date: Mon, 31 Aug 2026 09:25:20 -0400
Message-ID: <20260831133314.4125787-292-sashal@kernel.org>
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

From: Tianze Shao <shaotianze@outlook.com>

[ Upstream commit 4c9854ad3cdc7ce408453207f153bb910cc6f3c1 ]

On ThinkPad X1 Carbon Gen 13 (Lunar Lake, RT712-SDCA version VA) the
3.5mm headphone jack is silent after rebooting from Windows.
rt712_sdca_va_io_init() gates rt712_sdca_calibration() on the persisted
vendor SW_CONFIG1 flag, and io_init writes SW_CONFIG1=1 at the end
regardless of whether the calibration succeeded. Across a warm reboot
the codec keeps power, so SW_CONFIG1 stays unchanged, the calibration
may be skipped, and the retained state can be invalid, leaving the
headphone amp disabled.

This patch mimics the reset sequence in rt711-sdca.c, it adds an
rt712_sdca_reset() helper, and calls it from io_init so the codec is
reset before initialization. RT712_PARA_VERB_CTL,
RT712_HIDDEN_REG_SW_RESET and RT712_HDA_LEGACY_RESET_CTL are already
defined but were unused. The reset clears SW_CONFIG1 and the analog
state so rt712_sdca_calibration() runs from a clean state and
completes.

Problem reproducible: boot Windows (headphone is good) -> reboot
to Linux (silent).
The reproducibility may depend on Windows' behaviour.

Signed-off-by: Tianze Shao <shaotianze@outlook.com>
Link: https://patch.msgid.link/TYCPR01MB872223CB999D2099A5E0F58DC4F62@TYCPR01MB8722.jpnprd01.prod.outlook.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ASoC: rt712-sdca: reset codec at io_init to
fix silent headphone

**Local tree:** Linux **6.18.44** (`v6.18.44-1-g2736c32da98b9`)
**Fix commit:** `4c9854ad3cdc7` (on `master`, **not** in current HEAD)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[ASoC: rt712-sdca]` `[fix]` — reset codec at `io_init` to
fix silent headphone on RT712-SDCA VA hardware.

### Step 1.2: Tags
**Record:**
- **Fixes:** — absent (expected for manual review)
- **Reported-by:** — absent
- **Tested-by:** — absent
- **Reviewed-by / Acked-by:** — absent
- **Link:** https://patch.msgid.link/TYCPR01MB872223CB999D2099A5E0F58DC4
  F62@TYCPR01MB8722.jpnprd01.prod.outlook.com
- **Signed-off-by:** Tianze Shao (author), Mark Brown (maintainer
  commit)
- **Cc: stable:** — absent
- Notable: Realtek engineers (Shuming Fan, Oder Chiou) were CC'd on
  submission; Mark Brown applied to `for-7.2`.

### Step 1.3: Body analysis
**Record:**
- **Bug:** On ThinkPad X1 Carbon Gen 13 (Lunar Lake, RT712-SDCA VA),
  3.5mm headphone is silent after warm reboot from Windows.
- **Symptom:** Headphone jack produces no audio; speakers may still
  work.
- **Root cause:** `rt712_sdca_va_io_init()` skips
  `rt712_sdca_calibration()` when persisted `SW_CONFIG1` is set. Across
  warm reboot the codec retains power/state; calibration is skipped but
  analog state may be invalid, leaving the HP amp disabled. `io_init`
  always writes `SW_CONFIG1=1` at the end regardless of calibration
  outcome.
- **Repro:** Boot Windows (headphone works) → reboot to Linux (silent).
- **Version info:** RT712-SDCA **VA** variant specifically; Lunar Lake
  platform.

### Step 1.4: Hidden bug fix?
**Record:** No — this is an explicit hardware-init bug fix, not
disguised cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `sound/soc/codecs/rt712-sdca.c` only (+11 lines)
- **Functions:** new `rt712_sdca_reset()`; call added in
  `rt712_sdca_io_init()`
- **Scope:** Single-file surgical fix

### Step 2.2: Code flow change
**Record:**
- **Hunk 1 (new helper):** Adds `rt712_sdca_reset()` writing
  `RT712_HIDDEN_REG_SW_RESET` via `RT712_PARA_VERB_CTL` and
  `RT712_HDA_LEGACY_RESET_CTL` — identical pattern to
  `rt711_sdca_reset()`.
- **Hunk 2 (`rt712_sdca_io_init`):** Calls reset after
  `pm_runtime_get_noresume()` and before reading `RT712_JD_PRODUCT_NUM`
  / version detection / `rt712_sdca_va_io_init()`.
- **Before:** Init proceeded with potentially stale codec state from
  prior OS boot.
- **After:** Codec is reset to clean state; `SW_CONFIG1` cleared;
  calibration runs when gated on `!hibernation_flag`.

### Step 2.3: Bug mechanism
**Record:** **Category (g) logic/correctness + (h) hardware
workaround.** Skipped calibration due to persisted `SW_CONFIG1` flag
across warm reboot leaves headphone amp in invalid state. Reset forces
clean init path.

### Step 2.4: Fix quality
**Record:** Obviously correct — mirrors proven `rt711_sdca_reset()` at
the same point in `io_init`. Minimal, no API changes. Low regression
risk; reset is standard codec bring-up practice already used in sibling
driver.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Calibration gating on `SW_CONFIG1` at lines 1741–1747 blame
to `5d324e5159d9e` (6.18-era merge). Buggy logic present since driver
landed in this tree.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:** Fix commit `4c9854ad3cdc7` on `master`. No duplicate fix in
current HEAD. Standalone single-patch series (v1 only).

### Step 3.4: Author context
**Record:** Tianze Shao submitted hardware-specific fix; Mark Brown
(ASoC maintainer) applied. Realtek engineers CC'd.

### Step 3.5: Dependencies
**Record:** Self-contained. All required register constants
(`RT712_PARA_VERB_CTL`, `RT712_HIDDEN_REG_SW_RESET`,
`RT712_HDA_LEGACY_RESET_CTL`) already defined in `rt712-sdca.h`.
`rt712_sdca_index_update_bits()` already exists. No prerequisite commits
needed.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** b4 dig found thread at https://patch.msgid.link/TYCPR01MB872
223CB999D2099A5E0F58DC4F62@TYCPR01MB8722.jpnprd01.prod.outlook.com.
Single v1 submission; Mark Brown applied with no objections or NAKs. No
explicit stable nomination in thread.

### Step 4.2: Reviewers
**Record:** CC'd: linux-sound, Shuming Fan, Oder Chiou (Realtek), Liam
Girdwood, Mark Brown, Jaroslav Kysela, Takashi Iwai, linux-kernel.

### Step 4.3: Bug report
**Record:** Author-reported on ThinkPad X1 Carbon Gen 13 with explicit
repro steps. No syzbot/bugzilla. Severity: complete loss of headphone
audio on affected path.

### Step 4.4: Series context
**Record:** Standalone 1/1 patch; no series dependencies.

### Step 4.5: Stable list history
**Record:** Not searched separately; no stable nomination found in patch
thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `rt712_sdca_reset()` (new), `rt712_sdca_io_init()`
(modified).

### Step 5.2: Callers
**Record:** `rt712_sdca_io_init()` called from `rt712-sdca-sdw.c` during
SoundWire slave attach when `hw_init` is false and status is
`SDW_SLAVE_ATTACHED` — standard device enumeration/probe path.

### Step 5.3: Callees
**Record:** `rt712_sdca_index_update_bits()` → index read/write on codec
registers. No allocation, no locking added.

### Step 5.4: Reachability
**Record:** Triggered at every codec `io_init` on boot/resume attach.
Affects all RT712-SDCA users; bug manifests on VA variant after warm
reboot from Windows with persisted codec state.

### Step 5.5: Similar patterns
**Record:** `rt711_sdca_reset()` in `rt711-sdca.c` (lines 75–82) called
at identical point in `rt711_sdca_io_init()` (line 1619). Same reset
register pattern.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy code exists?
**Record:** **YES.** Current tree has:
- `hibernation_flag` gating at lines 1741–1747 in
  `rt712_sdca_va_io_init()`
- `SW_CONFIG1=1` write at line 1909 in `rt712_sdca_io_init()`
- No `rt712_sdca_reset()` (grep confirmed absent)
- `git merge-base --is-ancestor 4c9854ad3cdc7 HEAD` → exit 1 (fix
  **not** in tree)

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** `git cherry-pick --no-commit
4c9854ad3cdc7` auto-merged successfully on current HEAD.

### Step 6.3: Related fixes already present?
**Record:** None found (`git log --grep` for "silent headphone" /
"rt712_sdca_reset" returned empty).

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
**Record:** ASoC / Realtek RT712-SDCA codec driver
(`sound/soc/codecs/`). **Criticality: IMPORTANT** — affects audio on
Intel Lunar Lake laptops (ThinkPad X1 Carbon Gen 13, etc.).

### Step 7.2: Activity
**Record:** RT712-SDCA driver is actively used; Intel LNL ACPI match
tables reference RT712 configurations in `soc-acpi-intel-lnl-match.c`.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users with RT712-SDCA **VA** on platforms that warm-reboot
from Windows (ThinkPad X1 Carbon Gen 13 confirmed). Config-dependent
(SDCA + RT712 VA hardware).

### Step 8.2: Trigger conditions
**Record:** Warm reboot from Windows to Linux with codec retaining
power/state. Common dual-boot scenario on laptops. Not unprivileged
syscall-triggered; hardware/boot-path triggered.

### Step 8.3: Failure mode severity
**Record:** **MEDIUM-HIGH** — complete loss of 3.5mm headphone output
(functional hardware breakage, not crash/corruption). Significant for
affected dual-boot users.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Restores headphone audio on affected premium laptops;
  follows established sibling-driver pattern.
- **Risk:** Very low — 11 lines, reset at init only, same as rt711-sdca.
- **Ratio:** Favorable for backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real, reproducible hardware bug on ThinkPad X1 Carbon Gen 13
- Complete headphone silence — serious functional regression
- Small (11 lines), surgical, obviously correct
- Mirrors proven `rt711_sdca_reset()` pattern
- Maintainer-applied; Realtek CC'd
- Buggy code present in 6.18.44; fix absent; patch applies cleanly
- Hardware quirk/workaround category (persisted codec state)

**AGAINST backport:**
- Narrow hardware scope (RT712 VA, specific reboot path)
- Not a crash/security/corruption/deadlock
- No multi-user reports or syzbot
- No explicit stable nomination or Tested-by

**Unresolved:** Exact kernel version when rt712-sdca driver first landed
(history in this tree is merge-heavy), but driver and buggy code are
confirmed present in 6.18.44.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — mirrors rt711-sdca; author
   reproduced on real hardware; maintainer applied.
2. Fixes real bug? **PASS** — silent headphone after Windows→Linux warm
   reboot.
3. Important issue? **PASS** — complete audio loss on affected hardware
   (hardware quirk exception applies).
4. Small and contained? **PASS** — 11 lines, 1 file.
5. No new features/APIs? **PASS** — internal reset helper only.
6. Can apply to local tree? **PASS** — cherry-pick auto-merged; all
   symbols/constants present.

### Step 9.3: Exception category
**Record:** **Hardware quirk/workaround** — codec retains invalid state
across warm reboot; reset at init restores proper operation.

### Step 9.4: Decision rationale

For **Linux 6.18.y**, the RT712-SDCA driver is present with the buggy
`SW_CONFIG1` hibernation gating. Users of ThinkPad X1 Carbon Gen 13 (and
similar Lunar Lake + RT712 VA machines) who dual-boot can lose headphone
output entirely. The fix is minimal, follows an established pattern in
the same subsystem, applies cleanly, and carries very low regression
risk. This fits stable's hardware workaround exception and addresses a
real user-visible functional bug.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
  and `git show 4c9854ad3cdc7`
- **[Phase 2]** Diff analysis: +11 lines in `rt712-sdca.c`; new
  `rt712_sdca_reset()`, call in `rt712_sdca_io_init()`
- **[Phase 3]** `git blame -L 1741,1747`: hibernation gating present
  since 6.18 merge
- **[Phase 3]** `git merge-base --is-ancestor 4c9854ad3cdc7 HEAD` → exit
  1 (fix not in tree)
- **[Phase 3]** `git show 4c9854ad3cdc7^:...` confirmed parent has buggy
  SW_CONFIG1 gating without reset
- **[Phase 4]** `b4 dig -c 4c9854ad3cdc7`: found lore thread; v1 only;
  Mark Brown applied
- **[Phase 4]** `b4 dig -w`: CC list includes Mark Brown, Realtek
  engineers, ASoC maintainers
- **[Phase 4]** Read `/tmp/rt712-reset.mbx`: no NAKs, no stable
  nomination, maintainer applied
- **[Phase 5]** `grep rt712_sdca_io_init`: caller in `rt712-sdca-
  sdw.c:187` on SDW attach
- **[Phase 5]** Read `rt711-sdca.c:75-82,1619`: confirmed identical
  reset pattern
- **[Phase 6]** `git describe HEAD` + Makefile: tree is 6.18.44
- **[Phase 6]** `grep rt712_sdca_reset` in tree: no matches (fix absent)
- **[Phase 6]** Read `rt712-sdca.c:1728-1909`: confirmed buggy code
  paths present
- **[Phase 6]** `grep RT712_HIDDEN_REG_SW_RESET` in `rt712-sdca.h`:
  constants defined, unused
- **[Phase 6]** `git cherry-pick --no-commit 4c9854ad3cdc7`: auto-merged
  cleanly
- **[Phase 7]** `grep` in `sound/soc/intel/`: LNL ACPI tables reference
  RT712 hardware
- **[Phase 8]** Assessed severity: functional audio loss, not kernel
  crash

**YES****Result:** The RT712-SDCA headphone fix (`4c9854ad3cdc7`) should
be backported to this **6.18.44** tree.

On ThinkPad X1 Carbon Gen 13 (RT712 VA), warm reboot from Windows can
leave the codec in a bad state and skip calibration, so the 3.5mm jack
stays silent. The patch is small (11 lines), mirrors the existing
`rt711_sdca_reset()` pattern, applies cleanly here, and the buggy code
is present without the fix yet.

**YES**

 sound/soc/codecs/rt712-sdca.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/soc/codecs/rt712-sdca.c b/sound/soc/codecs/rt712-sdca.c
index 0ebaae426e73b..d8b40663fa92f 100644
--- a/sound/soc/codecs/rt712-sdca.c
+++ b/sound/soc/codecs/rt712-sdca.c
@@ -1849,6 +1849,15 @@ static void rt712_sdca_vb_io_init(struct rt712_sdca_priv *rt712)
 	}
 }
 
+static void rt712_sdca_reset(struct rt712_sdca_priv *rt712)
+{
+	rt712_sdca_index_update_bits(rt712, RT712_VENDOR_REG,
+		RT712_PARA_VERB_CTL, RT712_HIDDEN_REG_SW_RESET,
+		RT712_HIDDEN_REG_SW_RESET);
+	rt712_sdca_index_update_bits(rt712, RT712_VENDOR_HDA_CTL,
+		RT712_HDA_LEGACY_RESET_CTL, 0x1, 0x1);
+}
+
 int rt712_sdca_io_init(struct device *dev, struct sdw_slave *slave)
 {
 	struct rt712_sdca_priv *rt712 = dev_get_drvdata(dev);
@@ -1876,6 +1885,8 @@ int rt712_sdca_io_init(struct device *dev, struct sdw_slave *slave)
 
 	pm_runtime_get_noresume(&slave->dev);
 
+	rt712_sdca_reset(rt712);
+
 	rt712_sdca_index_read(rt712, RT712_VENDOR_REG, RT712_JD_PRODUCT_NUM, &val);
 	rt712->hw_id = (val & 0xf000) >> 12;
 	rt712->version_id = (val & 0x0f00) >> 8;
-- 
2.53.0

