Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCB35476C7;
	Mon, 31 Aug 2026 13:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183980; cv=none; b=bHLn0+ApOkE/eD1D1rn90jkOVwexNxtW9shgU5h6NcFz1quOcPAuOIBwe5gC/H1mYx6CfOse05BNZU46DEQxBHVt4aRJPAOXLck7H0GrMyJJ2EeMBknPhozGSUUOHRtRuq9EdGaM5o2BUytUh4DxC6+4+h6jNgtu0o1JVLB2esk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183980; c=relaxed/simple;
	bh=y8AdEZGZaFA0+N3Aeir87mUp8oEv5lHRQmzJBJ2JJzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pTGuDuarCMpyAfsWhOlR3WWOimL4ICasuAQfAisnKm4UMEzgyts0lCSYJkhKscR9o1EBdC37KJ9uEVqcqwcK8hHJnsIqWl79ZWdnL2+pCY1WF4or52k5FO4OmMv/I5OhnfEZbagtwbz6mzL+BiVW8PVr76KoGkU1L7LUkU0ECwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DV9T3ojo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DV9T3ojo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9664E1F00ACF;
	Mon, 31 Aug 2026 13:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183976;
	bh=64yaWOhzviJxtXdpK55atq3ydHviVQgosiUBPc1Y9zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DV9T3ojoLVhps2lZTSQcnXPKafqgfB2e46SI4ubgJv2gQPeUeQk0+B3fULq7ZijjI
	 J0JykCiodjVQkJFfn0/UYiYyUIa1lJI92ezzyNBlrMNgIykGny4HzE81DeJKjbz2bC
	 i3eV/wlf/g28Ac/aqF9Us4jkU9qaqlFry+9nj1HMgzFOmC1GbGNK/aKVkAEHp2qzhX
	 XYFgkmoayDgibKaloSbk0b9LQyB0Ij/WuC1CZ8vJaPEFwqK8pjEVnTAeCS91HFm8a+
	 HzHcSSLfGWcoC85a4m7oBg5UPu6WySBDfcQbZr0wwdT/ZJgnHUlDgirWJ+8A47smff
	 1v1pMCJplXgVA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chris Aherin <chrisaherin@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ALSA: hda/realtek: Add quirk for Lenovo Yoga 7 16IAP7
Date: Mon, 31 Aug 2026 09:27:24 -0400
Message-ID: <20260831133314.4125787-416-sashal@kernel.org>
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

From: Chris Aherin <chrisaherin@gmail.com>

[ Upstream commit b70f007a9fc665ee988683fd5085ab34e2c10ad3 ]

The Yoga 7 16IAP7 (board LNVNB161216, codec SSID 17aa:386a) has pin
complex 0x17 (bass speakers) wrongly reported as unconnected, causing
only one of four speaker pins (0x14) to be configured and resulting in
mono/tinny audio.

SOF corrupts the PCI subsystem ID to 17aa:0000, preventing SND_PCI_QUIRK
from matching. HDA_CODEC_QUIRK is used instead, which matches against
codec->core.subsystem_id read directly from the HDA codec register and
unaffected by the SOF bug.

Applies ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN, the same fixup used for
the Yoga 7 14IAL7, which corrects pin 0x17's default configuration and
enables both speaker pairs.

Signed-off-by: Chris Aherin <chrisaherin@gmail.com>
Link: https://patch.msgid.link/20260622001210.20553-1-chrisaherin@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ALSA: hda/realtek: Add quirk for Lenovo Yoga
7 16IAP7

**Local tree:** Linux 6.18.44 (`git describe HEAD` →
`v6.18.44-1-g2736c32da98b9`, `make kernelversion` → 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[ALSA: hda/realtek]` `[Add]` — Add hardware quirk for
Lenovo Yoga 7 16IAP7 speaker pin configuration.

### Step 1.2: Tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none (author is the reporter)
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Cc: stable@vger.kernel.org** — not present (not a negative signal)
- **Link:**
  https://patch.msgid.link/20260622001210.20553-1-chrisaherin@gmail.com
- **Signed-off-by:** Chris Aherin (author), Takashi Iwai (ALSA
  maintainer, applied)
- Notable: maintainer reply "Applied now. Thanks." on lore thread

### Step 1.3: Body analysis
**Record:**
- **Bug:** Pin complex 0x17 (bass speakers) wrongly reported as
  unconnected on Yoga 7 16IAP7 (board LNVNB161216, codec SSID
  `17aa:386a`).
- **Symptom:** Only pin 0x14 configured → mono/tinny audio from a
  4-speaker laptop.
- **Root cause:** SOF corrupts PCI subsystem ID to `17aa:0000`, so
  `SND_PCI_QUIRK` cannot match; codec SSID from HDA register is still
  correct.
- **Fix approach:** Add `HDA_CODEC_QUIRK` for `17aa:386a`, reusing
  existing `ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN` (same as Yoga 7
  14IAL7).
- **Version info:** None explicit; hardware is 12th-gen Intel Yoga 7.

### Step 1.4: Hidden bug fix?
**Record:** Yes — despite "Add quirk" wording, this fixes a real
hardware/audio configuration bug causing degraded speaker output.
Classic audio codec quirk fix.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `sound/hda/codecs/realtek/alc269.c` (+1 line)
- **Functions modified:** `alc269_fixup_tbl[]` (static quirk table only)
- **Scope:** Single-file, single-line surgical addition

### Step 2.2: Code flow change
**Record:**
- **Before:** Yoga 7 16IAP7 (`17aa:386a`) has no quirk entry → no bass-
  speaker pin fixup applied → pin 0x17 stays "unconnected."
- **After:** Codec SSID `17aa:386a` matches `HDA_CODEC_QUIRK` →
  `ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN` runs at codec init → pin 0x17
  configured as internal speaker.
- **Path:** Device probe / codec initialization (normal boot path).

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Hardware workaround / audio codec quirk
- **Mechanism:** Wrong default pin configuration for bass speakers; SOF
  PCI SSID corruption prevents PCI-based quirk matching.
  `HDA_CODEC_QUIRK` matches `codec->core.subsystem_id` directly
  (verified in `snd_hda_pick_fixup()` at
  `sound/hda/common/auto_parser.c:1053-1073`).

### Step 2.4: Fix quality
**Record:**
- **Obviously correct:** Reuses proven fixup already applied to Yoga 7
  14IAL7 (`0x3869`) and multiple other Lenovo models.
- **Minimal:** One table entry, no logic changes.
- **Regression risk:** Very low — only affects machines with codec SSID
  `17aa:386a`.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Insertion point (after `0x3869` entry, line 7443) dates to
`aeeb85f26c3bb` (Takashi Iwai, 2025-07-09, driver split). The missing
quirk is an omission for this SSID, not a recently introduced
regression.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related file history
**Record:** Multiple similar quirk additions in this tree recently:
- `1386d16761c0b` — Yoga 7 2-in-1 14AKP10 (`HDA_CODEC_QUIRK`, same
  fixup)
- `e656ef8698e28` — Yoga 7 2-in-1 16AKP10
- `6b2c0cd5f9689` — Legion Pro 7 codec SSID quirk (Cc: stable,
  backported pattern)
Standalone single-patch series (v1 only per `b4 dig -a`).

### Step 3.4: Author context
**Record:** Chris Aherin — user reporter/submitter, not subsystem
maintainer. Takashi Iwai (maintainer) applied the patch.

### Step 3.5: Dependencies
**Record:**
- Requires `HDA_CODEC_QUIRK` macro — present since `05be28fe8521f`
- Requires `ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN` fixup and
  `alc287_fixup_yoga9_14iap7_bass_spk_pin()` — present since driver
  split (`aeeb85f26c3bb`)
- **Standalone:** Yes; no series dependencies
- **Applies cleanly:** `git show e0f99d035db25 --
  sound/hda/codecs/realtek/alc269.c | git apply --check` succeeds

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **URL:**
  https://patch.msgid.link/20260622001210.20553-1-chrisaherin@gmail.com
- **Revisions:** v1 only (no v2/v3)
- **Maintainer feedback:** Takashi Iwai: "Applied now. Thanks."
- **Stable nomination:** None in thread
- **NAKs/concerns:** None

### Step 4.2: Reviewers
**Record:** CC'd: perex@perex.cz (ALSA lead), tiwai@suse.com, linux-
sound@vger.kernel.org, linux-kernel@vger.kernel.org. Appropriate
subsystem coverage.

### Step 4.3: Bug report
**Record:** No external bug tracker; author report from real hardware
(board LNVNB161216). Functional audio defect, not a crash.

### Step 4.4: Related patches
**Record:** Same fixup pattern as Yoga 7 14IAL7 (`SND_PCI_QUIRK
0x3869`), Yoga 7 2-in-1 models (`HDA_CODEC_QUIRK 0x391c/0x391d`). This
is the same family of fixes.

### Step 4.5: Stable list history
**Record:** Could not search lore stable archive (403/bot protection on
WebFetch). No stable nomination found in downloaded mbox thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `alc269_fixup_tbl[]` (quirk table); fixup applied via
`alc287_fixup_yoga9_14iap7_bass_spk_pin()` through
`ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN`.

### Step 5.2: Callers
**Record:** Quirk table consumed by `snd_hda_pick_fixup()` during
Realtek codec probe (`snd_hda_pick_fixup` → `hda_quirk_lookup_id` / loop
at `auto_parser.c:1067-1080`). Called on every HDA Realtek codec
initialization.

### Step 5.3: Callees
**Record:** Fixup sets pin config `{ 0x17, 0x90170121 }` and speaker
connections via `alc287_fixup_yoga9_14iap7_bass_spk_pin()`
(`alc269.c:3408-3423`).

### Step 5.4: Reachability
**Record:** Triggered at boot when Yoga 7 16IAP7 HDA codec probes —
common laptop audio init path. Affects all users of this hardware
running SOF (typical on Intel laptops).

### Step 5.5: Similar patterns
**Record:** Multiple `HDA_CODEC_QUIRK` entries for Lenovo Yoga models
using the same bass-speaker fixup already exist in this tree (e.g.,
`0x391c`, `0x391d`). Established, proven pattern.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Does buggy code exist?
**Record:** **Yes.** The quirk table exists but lacks `17aa:386a`.
Neighbor entry `SND_PCI_QUIRK(0x17aa, 0x3869, ...)` is at line 7443.
Fixup infrastructure is fully present. Commit is **not** in HEAD (`git
merge-base --is-ancestor e0f99d035db25 HEAD` → exit 1).

### Step 6.2: Backport complications
**Record:** **Clean apply** — verified with `git apply --check`. No
conflicts expected; insertion is one line after existing `0x3869` entry.

### Step 6.3: Related fixes already present?
**Record:** The fixup `ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN` and
`HDA_CODEC_QUIRK` infrastructure are already in 6.18.44. The specific
`0x386a` entry is the only missing piece.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **sound/hda** — IMPORTANT. Affects laptop audio for a
specific Lenovo model; not core kernel, but affects real end-user
hardware.

### Step 7.2: Subsystem activity
**Record:** Actively maintained — 20+ realtek quirk commits in recent
history on this tree.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Lenovo Yoga 7 16IAP7 (codec SSID `17aa:386a`) users,
especially with SOF where PCI SSID is corrupted to `17aa:0000`.

### Step 8.2: Trigger conditions
**Record:** Every boot on affected hardware with default HDA driver.
Common configuration (Intel laptop + SOF). Not security-relevant; not
user-triggerable beyond normal use.

### Step 8.3: Failure mode severity
**Record:** Mono/tinny audio — **MEDIUM** functional defect. No crash,
corruption, or security impact. Significant quality-of-life issue for
affected laptop owners.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Restores proper stereo/4-speaker audio on a real laptop
  model
- **Risk:** Very low — 1-line quirk using existing, tested fixup
- **Ratio:** Strong benefit, negligible risk. Matches established stable
  pattern for HDA codec quirks.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backporting:**
- Fixes real hardware audio defect on Lenovo Yoga 7 16IAP7
- Hardware quirk exception — explicitly allowed for stable
- One-line, surgical, reuses existing fixup
- Maintainer-applied and merged upstream (`b70f007a9fc66`)
- All prerequisites present in 6.18.44
- Applies cleanly
- Identical pattern to recent stable-worthy commits in same file (e.g.,
  `6b2c0cd5f9689`, `1386d16761c0b`)

**AGAINST backporting:**
- No crash/corruption/security impact — functional audio only
- No Tested-by or explicit stable nomination
- Affects narrow hardware population

**Unresolved:** None material to the decision.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — reuses proven fixup;
   maintainer applied
2. Fixes real bug affecting users? **PASS** — mono/tinny audio on real
   hardware
3. Important issue? **PASS** — functional hardware defect (MEDIUM
   severity; quirk category is stable-standard)
4. Small and contained? **PASS** — 1 line, 1 file
5. No new features/APIs? **PASS** — table entry only, no new fixup logic
6. Can apply to local tree? **PASS** — verified clean apply

### Step 9.3: Exception category
**Record:** **Hardware quirk/workaround** — audio codec pin
configuration for broken hardware reporting. Automatic stable
qualification per stable-kernel-rules exceptions.

### Step 9.4: Decision rationale

For Linux **6.18.44**, this commit should be backported. The Yoga 7
16IAP7 lacks a quirk entry that sibling models already have; the
required fixup and `HDA_CODEC_QUIRK` infrastructure are present; the
patch is a single line that applies cleanly. While the failure mode is
degraded audio rather than a crash, HDA codec quirks for laptop speaker
misconfiguration are routinely accepted into stable trees, and this
patch follows the exact same pattern as other Lenovo Yoga quirk commits
already in 6.18.y.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message and
  `git show e0f99d035db25`
- [Phase 1] Confirmed no Fixes:/Reported-by:/Cc: stable tags; found
  Link: and Takashi Iwai SOB
- [Phase 2] Diff: +1 line in `alc269_fixup_tbl[]`,
  `HDA_CODEC_QUIRK(0x17aa, 0x386a, ...)`
- [Phase 2] Read `alc287_fixup_yoga9_14iap7_bass_spk_pin()` at
  `alc269.c:3408-3423`
- [Phase 3] `git describe HEAD` → v6.18.44; `git blame -L 7440,7450` →
  table from Jul 2025 split
- [Phase 3] `git log -S 'ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN'` →
  present since `aeeb85f26c3bb`
- [Phase 3] `git log -S 'HDA_CODEC_QUIRK'` on `hda_local.h` → macro
  since `05be28fe8521f`
- [Phase 3] `git merge-base --is-ancestor e0f99d035db25 HEAD` → exit 1
  (not in tree)
- [Phase 3] `git show e0f99d035db25 | git apply --check` → clean apply
- [Phase 4] `b4 dig -c e0f99d035db25` → lore URL found
- [Phase 4] `b4 dig -a` → v1 only
- [Phase 4] `b4 dig -w` → perex, tiwai, linux-sound CC'd
- [Phase 4] `b4 dig -m /tmp/yoga7_16iap7.mbox` → Takashi "Applied now.
  Thanks."; no stable/CC discussion
- [Phase 5] Read `snd_hda_pick_fixup()` codec SSID matching at
  `auto_parser.c:1048-1080`
- [Phase 5] Grep: `0x386a` not in `alc269.c` (quirk absent); fixup and
  similar quirks present
- [Phase 6] Confirmed `HDA_CODEC_QUIRK` and
  `ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN` exist in 6.18.44
- [Phase 6] Compared with `6b2c0cd5f9689` (similar codec SSID quirk, Cc:
  stable in stable tree)
- [Phase 8] Failure mode: mono/tinny audio, MEDIUM severity, no
  crash/security impact

**YES****Verdict: YES** — backport to this tree (Linux 6.18.44).

This is a one-line `HDA_CODEC_QUIRK` for the Lenovo Yoga 7 16IAP7
(`17aa:386a`). It reuses the existing
`ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN` fixup to correct bass-speaker
pin 0x17, which SOF leaves misconfigured when PCI SSID is corrupted to
`17aa:0000`. The fixup infrastructure is already in 6.18.44, the patch
applies cleanly, and it matches the pattern of other Lenovo Yoga quirk
commits already in this tree.

Impact is degraded (mono/tinny) audio on affected hardware, not a crash
— but it fits the standard stable hardware-quirk category.

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index ab6fc1fdf3ff2..0c12158e5ea78 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7448,6 +7448,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3865, "Lenovo 13X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3866, "Lenovo 13X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3869, "Lenovo Yoga7 14IAL7", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
+	HDA_CODEC_QUIRK(0x17aa, 0x386a, "Lenovo Yoga 7 16IAP7", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	HDA_CODEC_QUIRK(0x17aa, 0x386e, "Legion Y9000X 2022 IAH7", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x386e, "Yoga Pro 7 14ARP8", ALC285_FIXUP_SPEAKER2_TO_DAC1),
 	HDA_CODEC_QUIRK(0x17aa, 0x38a8, "Legion Pro 7 16ARX8H", ALC287_FIXUP_TAS2781_I2C), /* this must match before PCI SSID 17aa:386f below */
-- 
2.53.0

