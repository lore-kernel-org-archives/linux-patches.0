Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64EE4EA387;
	Mon, 11 May 2026 22:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778538001; cv=none; b=KqTY8nC0w4en7TU9Fp9LJBMhE8Uw8kiB5UMWBejzRvuxtxWBLeyMNwIVTTXcLVgtkzSItm/zSEY+ijQ6z3/dpi+iw//zsiJwk9duo6x/GFTz9ijJspAQ7YBT4vKohrbv0BQMEg4hhmJYbyQshcr8XZj8K00WzvaxnHh87DyOhLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778538001; c=relaxed/simple;
	bh=kFgmMNGmlIo0zSBNgHG9+naS/KZNXllqUo/TClMYRb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ogojiSiyADnf3HxQbusZyatc42P+do1HJ8nYLyIuqoXLij1oR7AEocoiQJ4xU36WZRS/UTKZQ9BlG8WmUHtjioslt8+YL8XTAEznlN4uILyEjQIfNVZ7Q9jCklU9prdfGW21Vqxoi5JMHSdUK8129b1B1jXFwNFYCdrNISzjyew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jphv9JB6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jphv9JB6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4AA9C2BCFA;
	Mon, 11 May 2026 22:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778538001;
	bh=kFgmMNGmlIo0zSBNgHG9+naS/KZNXllqUo/TClMYRb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jphv9JB6lkrAt8R8oILbYOO1l8UmL2rh1bmE9Oafg7RFMwLsdkphrR1qHoqS6N/11
	 BZr0kPpwK6v53wSxxr+7rvFK2s6xRCOsZvoasFmxNalcEhJ/lwm0oaYIMItCyTx7HP
	 SuEvqL0/R38JtXMMc1v+LQF1ScVKmvFjnJoJS39Ao/uM/m8Shvz7dDe18438Nn6CBd
	 SZaCkt/UjvaXcmcov26ZMxpjUz+SSYgkafN956lR+DNrjcrqTcXUnNt1BtjaNVOrNU
	 8NuNCH0IbklzqZbWOFZtaLR6EzTglcSWEUFVXmUeas3FPPzccT2d7lGyrVLxg+9OrD
	 sTWSAxPcxrnhQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?R=C3=A1mon=20van=20Raaij?= <ramon@vanraaij.eu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] ALSA: hda/realtek: Add codec SSID quirk for Lenovo Yoga Pro 9 16IMH9
Date: Mon, 11 May 2026 18:19:19 -0400
Message-ID: <20260511221931.2370053-20-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511221931.2370053-1-sashal@kernel.org>
References: <20260511221931.2370053-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.6
Content-Transfer-Encoding: 8bit

From: Rámon van Raaij <ramon@vanraaij.eu>

[ Upstream commit 56722cfbb78d7eb41756cd78dc5192d08bd14f3d ]

The Yoga Pro 9 16IMH9 (codec SSID 17aa:38d6) shares PCI audio device
subsystem ID 17aa:3811 with the Legion S7 15IMH05. The existing
SND_PCI_QUIRK entry for the Legion routes both machines to
ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS, which does not bind the TAS2781
smart amplifiers, resulting in near-silent built-in speakers.

Add an HDA_CODEC_QUIRK entry immediately before the conflicting PCI quirk
that matches the Yoga Pro 9's unique codec SSID and routes it to
ALC287_FIXUP_TAS2781_I2C. Codec quirks are evaluated after PCI quirks and
take precedence, leaving the Legion S7 15IMH05 entry unaffected.

This follows the same pattern used to disambiguate PCI SSID 17aa:3847
(shared between Yoga Pro 7 14IMH9 and Legion 7 16ACHG6), where a
HDA_CODEC_QUIRK for codec SSID 17aa:38cf resolves the conflict.

Signed-off-by: Rámon van Raaij <ramon@vanraaij.eu>
Link: https://patch.msgid.link/20260430191224.patch1-ramon@vanraaij.eu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase Walkthrough
### Phase 1: Commit Message Forensics
Step 1.1 Record: Subsystem is `ALSA: hda/realtek`; action is `Add`;
claimed intent is adding a codec-SSID quirk so Lenovo Yoga Pro 9 16IMH9
uses the TAS2781 fixup instead of the Legion S7 PCI-SSID fixup.

Step 1.2 Record: Tags present are `Signed-off-by: Rámon van Raaij
<ramon@vanraaij.eu>`, `Link:
https://patch.msgid.link/20260430191224.patch1-ramon@vanraaij.eu`, and
`Signed-off-by: Takashi Iwai <tiwai@suse.de>`. No `Fixes:`, `Reported-
by:`, `Tested-by:`, `Reviewed-by:`, `Acked-by:`, or `Cc:
stable@vger.kernel.org` tag is present.

Step 1.3 Record: The commit describes a real hardware misidentification:
Yoga Pro 9 16IMH9 has codec SSID `17aa:38d6` but shares PCI audio SSID
`17aa:3811` with Legion S7 15IMH05, causing
`ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS` to be selected. The stated
symptom is near-silent built-in speakers because TAS2781 smart
amplifiers are not bound.

Step 1.4 Record: This is a bug fix disguised as an “add quirk” change.
It is a hardware-specific workaround for wrong quirk selection, one of
the standard stable exception categories.

### Phase 2: Diff Analysis
Step 2.1 Record: One file changed: `sound/hda/codecs/realtek/alc269.c`,
4 insertions, 0 deletions. No function body is changed; the modified
object is `alc269_fixup_tbl`. Scope is single-file, table-only,
surgical.

Step 2.2 Record: Before, a Yoga Pro 9 16IMH9 with PCI SSID `17aa:3811`
would hit the existing Legion S7 `SND_PCI_QUIRK` and get
`ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS`. After, the earlier
`HDA_CODEC_QUIRK(0x17aa, 0x38d6, ..., ALC287_FIXUP_TAS2781_I2C)` matches
by codec SSID first due table order and routes that machine to the
TAS2781 I2C fixup.

Step 2.3 Record: Bug category is hardware workaround / logic
correctness. The broken mechanism is ambiguous PCI SSID reuse; the fix
uses the more specific codec SSID.

Step 2.4 Record: Fix quality is high. It is a 4-line exact-match quirk,
no API change, no broad behavior change. Regression risk is very low and
limited to devices reporting codec SSID `17aa:38d6`.

### Phase 3: Git History
Step 3.1 Record: `git blame` shows the conflicting
`SND_PCI_QUIRK(0x17aa, 0x3811, "Legion S7 15IMH05", ...)` came from
`67f4c61a73e9b` by Eric Naim. `git describe --contains 67f4c61a73e9b`
reports `v7.1-rc1~166^2~6`; candidate `56722cfbb78d` is contained by
`v7.1-rc3~27^2~13`.

Step 3.2 Record: No `Fixes:` tag is present, so there is no tagged
introducer to follow. Manual blame identifies the relevant prior Legion
quirk.

Step 3.3 Record: Recent file history is mostly audio quirk additions.
Related commit `217d5bc9f9627` adds the same codec-SSID disambiguation
pattern for Yoga Pro 7 14IMH9 versus Legion 7 16ACHG6.

Step 3.4 Record: `git log --author='Rámon van Raaij' ... master --
sound/hda/codecs/realtek/alc269.c` returned no earlier matching commits
in this local history. Maintainer Takashi Iwai committed the patch.

Step 3.5 Record: Dependencies are the existing `HDA_CODEC_QUIRK`
infrastructure, `ALC287_FIXUP_TAS2781_I2C`, and the conflicting Legion
`17aa:3811` entry. All exist in the checked 7.0 tree; `git apply
--check` of the candidate diff against current `HEAD` succeeded.

### Phase 4: Mailing List / External Research
Step 4.1 Record: `b4 dig -c 56722cfbb78d -a` found one revision, v1, at
`https://patch.msgid.link/20260430191224.patch1-ramon@vanraaij.eu`. No
newer revision for this exact patch was found.

Step 4.2 Record: `b4 dig -c 56722cfbb78d -w` shows recipients were Rámon
van Raaij, `linux-sound@vger.kernel.org`, `alsa-devel@alsa-project.org`,
and Takashi Iwai. The maintainer replied “Applied now. Thanks.”

Step 4.3 Record: No separate bug report link or `Reported-by` tag is in
the candidate. Web search found public Yoga Pro 9i/TIAS2781/ALC287 audio
issue reports, but I did not use those as primary evidence for the exact
`17aa:38d6` SSID.

Step 4.4 Record: `b4 mbox -c` showed a later related patch for codec
SSID `17aa:38d5`, referencing this candidate commit and the same
hardware class. It is related context, not a prerequisite.

Step 4.5 Record: Web search for stable-specific discussion of
`56722cfbb78d` did not find a stable-thread result. Lore `WebFetch` was
blocked by anti-bot HTML, but `b4` access succeeded.

### Phase 5: Semantic Code Analysis
Step 5.1 Record: No function is modified. Key affected symbols are
`alc269_fixup_tbl`, `snd_hda_pick_fixup`, `HDA_CODEC_QUIRK`,
`ALC287_FIXUP_TAS2781_I2C`, and `ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS`.

Step 5.2 Record: `alc269_probe()` calls `snd_hda_pick_fixup(codec,
alc269_fixup_models, alc269_fixup_tbl, alc269_fixups)`.
`hda_codec_driver_probe()` calls the codec driver probe op, so this is
reached during HDA codec binding/probe.

Step 5.3 Record: `HDA_CODEC_QUIRK` sets `.match_codec_ssid = true`.
`snd_hda_pick_fixup()` checks such entries against
`codec->core.subsystem_id`; the TAS2781 fixup calls
`comp_generic_fixup(..., "i2c", "TIAS2781", ...)`. The Legion fixup is
HDA verb/coefficient based and does not call the TAS2781 component
binding helper.

Step 5.4 Record: Reachability is hardware probe path: HDA controller
probes codecs, Realtek codec driver probes, `alc269_probe()` picks the
fixup. The bug is not syscall/security-triggered; it affects audio
functionality on matching hardware.

Step 5.5 Record: Similar patterns exist in the same table, especially
`HDA_CODEC_QUIRK(0x17aa, 0x38cf, "Lenovo Yoga Pro 7 14IMH9", ...)`
immediately before a conflicting Legion PCI SSID entry.

### Phase 6: Stable Tree Analysis
Step 6.1 Record: In checked local refs, `HEAD` and `pending-6.18`
contain the conflicting `17aa:3811` Legion quirk and do not contain the
candidate `HDA_CODEC_QUIRK(0x17aa, 0x38d6, ...)`. Older checked pending
refs did not show the conflicting line in the `git grep` run.

Step 6.2 Record: Backport difficulty is clean for current `HEAD`: `git
apply --check` succeeded. For older trees without `HDA_CODEC_QUIRK` or
without the Legion `17aa:3811` quirk, this patch is either not
applicable or would need prerequisites.

Step 6.3 Record: No equivalent `17aa:38d6` codec quirk was found in
checked stable refs. Existing `SND_PCI_QUIRK(0x17aa, 0x38d6, ...)`
entries are PCI-SSID entries and do not fix the reported Yoga Pro 9 case
where the PCI SSID is `17aa:3811`.

### Phase 7: Subsystem Context
Step 7.1 Record: Subsystem is ALSA HDA Realtek codec support under
`sound/hda/codecs/realtek`. Criticality is driver-specific/important for
affected laptop users, not core-kernel-wide.

Step 7.2 Record: The subsystem is actively maintained; recent history
shows many Realtek laptop quirk additions and related fixes. Takashi
Iwai applied the patch.

### Phase 8: Impact / Risk
Step 8.1 Record: Affected population is Lenovo Yoga Pro 9 16IMH9 units
with codec SSID `17aa:38d6` on stable trees containing the Legion
`17aa:3811` quirk.

Step 8.2 Record: Trigger is normal boot/device probe and use of built-in
speakers. It is hardware/config specific, not unprivileged exploitation.

Step 8.3 Record: Failure mode is broken built-in speaker output,
described as near-silent speakers. Severity is high for affected
hardware functionality, though not crash/data-corruption/security
severity.

Step 8.4 Record: Benefit is high for affected laptops and also prevents
a regression caused by the shared PCI SSID quirk. Risk is very low: 4
lines, exact match, no new API, no shared logic changes.

### Phase 9: Synthesis
Step 9.1 Record: Evidence for backporting: real user-visible hardware
breakage, standard stable hardware-quirk category, tiny table-only
patch, maintainer-applied, exact existing pattern, clean apply to
current checked stable tree. Evidence against: no `Tested-by`, no `Cc:
stable`, no separate bug-report link in the commit, and not applicable
to trees lacking the prerequisite Legion quirk or `HDA_CODEC_QUIRK`
infrastructure. Unresolved: I did not independently verify the physical
uniqueness of codec SSID `17aa:38d6` beyond the submitted patch and
maintainer acceptance.

Step 9.2 Record: Stable rules: already upstream/mainline yes; obviously
correct yes by code inspection and `checkpatch`; fixes a real bug yes,
wrong quirk causing near-silent speakers; important enough yes as a
hardware quirk / broken device functionality; small and contained yes, 4
insertions; no new feature/API yes; applies cleanly to current checked
stable `HEAD`, with older-tree applicability depending on prerequisites.

Step 9.3 Record: Exception category applies: hardware quirk/workaround
for a specific laptop audio configuration.

Step 9.4 Record: Decision is YES for stable trees that contain the
conflicting Legion S7 `17aa:3811` quirk and the
`HDA_CODEC_QUIRK`/TAS2781 infrastructure. It should not be forced into
older trees where the buggy conflicting quirk is absent.

## Verification
- [Phase 1] Parsed commit `56722cfbb78d7eb41756cd78dc5192d08bd14f3d`
  with `git show`; confirmed tags and message.
- [Phase 2] Inspected diff: `sound/hda/codecs/realtek/alc269.c`, 4
  insertions.
- [Phase 3] Ran `git blame` around the conflicting quirk; confirmed
  `67f4c61a73e9b` introduced `17aa:3811`.
- [Phase 3] Ran `git show 67f4c61a73e9b`; confirmed it adds the Legion
  S7 quirk.
- [Phase 4] Ran `b4 dig -c 56722cfbb78d -a` and `-w`; found v1
  submission, recipients, and maintainer application.
- [Phase 5] Read `snd_hda_pick_fixup()`, `HDA_CODEC_QUIRK`,
  `alc269_probe()`, TAS2781 fixup, and Legion fixup paths.
- [Phase 6] Ran `git grep` across checked stable refs; found conflict in
  `HEAD` and `pending-6.18`, and no candidate codec quirk there.
- [Phase 6] Ran `git apply --check`; candidate applies to current
  checked `HEAD`.
- [Phase 8] Ran `scripts/checkpatch.pl --no-tree`; 0 errors, 0 warnings.
- UNVERIFIED: No runtime test on Lenovo Yoga Pro 9 16IMH9 hardware; no
  full build performed; exact affected stable branch set beyond checked
  local refs not exhaustively proven because broad branch containment
  checks were too slow and stopped.

**YES**

 sound/hda/codecs/realtek/alc269.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 3c02f50626ed4..29dafa3f1d15a 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7606,6 +7606,10 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3801, "Lenovo Yoga9 14IAP7", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	HDA_CODEC_QUIRK(0x17aa, 0x3802, "DuetITL 2021", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3802, "Lenovo Yoga Pro 9 14IRP8", ALC287_FIXUP_TAS2781_I2C),
+	/* Yoga Pro 9 16IMH9 shares PCI SSID 17aa:3811 with Legion S7 15IMH05;
+	 * use codec SSID to distinguish them
+	 */
+	HDA_CODEC_QUIRK(0x17aa, 0x38d6, "Lenovo Yoga Pro 9 16IMH9", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3811, "Legion S7 15IMH05", ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3813, "Legion 7i 15IMHG05", ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3818, "Lenovo C940 / Yoga Duet 7", ALC298_FIXUP_LENOVO_C940_DUET7),
-- 
2.53.0

