Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2810933555F;
	Mon,  6 Apr 2026 11:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775473561; cv=none; b=U7+A3+/KF2FaFr+o4AOfRA6N8aOSNYsu3y4MPI/8JKeE0rMbqrpnrQyG+cmQkvJjd+Apy7VQieueXWBG7UvmfpKm0nFfYwOaPN9nRaobiZ5rMVvZmVxugRPkXemA5xEfNJKpTSUEixTWqESX6y0JfK7txuS68Rc/Dda+0FPukT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775473561; c=relaxed/simple;
	bh=Qe8DOIxAq+HU8ga3u1xmR2ZpZz+XnkjjX6LknOS2sgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X2r6vDzRgTFCmbgFcUfa5QpstMuIYasJgEo8wJR/j879oK3hmQKgyhwQ5ZiDZyNws3cfgWpOMn2df2k0g3ZLlEbXP2zSHW1A/kI4E3cw0bO2lD0J1LPf0UDMRRQTDJcIJDKNKbHuutK8Vy3+OZhxk/UJaUvDCQGKs3ZXAxSnO2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sbs8XHDA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sbs8XHDA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECB6C19425;
	Mon,  6 Apr 2026 11:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775473560;
	bh=Qe8DOIxAq+HU8ga3u1xmR2ZpZz+XnkjjX6LknOS2sgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sbs8XHDA7Odg+CWTzgY8H26swhD869r1PjtRAOKL7v7Sf972DvbBQokk8uyTTsVkN
	 skDv57hScoepNX/cj+Oz4ets8G2w6UgA0b15sYbHQdrtyNAfmFtAK5rbW1Rn6nROBg
	 4+WBS87CDNZV/FJqDjNNyUWSe5NEOK0bKEgU29b4xlA9gMZKRCwv00S9kn2lx+6qeD
	 HBef+lzLQNMHlmnnF3Z7geIa5+FIes8jtQOeZnPldRroTSD/0yrC3qlGSD0Eb/GVa/
	 VqrK+vp+M89u56m6mdNuJ2Sryi2vEamlJ9JJAfD3GyLF1zKFllWl87b2WBmOCYTvx6
	 hAF2YP2bqDp2w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alexander Savenko <alex.sav4387@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] ALSA: hda/realtek: Add quirk for Lenovo Yoga Pro 7 14IMH9
Date: Mon,  6 Apr 2026 07:05:39 -0400
Message-ID: <20260406110553.3783076-5-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406110553.3783076-1-sashal@kernel.org>
References: <20260406110553.3783076-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.11
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Savenko <alex.sav4387@gmail.com>

[ Upstream commit 217d5bc9f96272316ac5a3215c7cc32a5127bbf3 ]

The Lenovo Yoga Pro 7 14IMH9 (DMI: 83E2) shares PCI SSID 17aa:3847
with the Legion 7 16ACHG6, but has a different codec subsystem ID
(17aa:38cf). The existing SND_PCI_QUIRK for 17aa:3847 applies
ALC287_FIXUP_LEGION_16ACHG6, which attempts to initialize an external
I2C amplifier (CLSA0100) that is not present on the Yoga Pro 7 14IMH9.

As a result, pin 0x17 (bass speakers) is connected to DAC 0x06 which
has no volume control, making hardware volume adjustment completely
non-functional. Audio is either silent or at maximum volume regardless
of the slider position.

Add a HDA_CODEC_QUIRK entry using the codec subsystem ID (17aa:38cf)
to correctly identify the Yoga Pro 7 14IMH9 and apply
ALC287_FIXUP_YOGA9_14IMH9_BASS_SPK_PIN, which redirects pin 0x17 to
DAC 0x02 and restores proper volume control. The existing Legion entry
is preserved unchanged.

This follows the same pattern used for 17aa:386e, where Legion Y9000X
and Yoga Pro 7 14ARP8 share a PCI SSID but are distinguished via
HDA_CODEC_QUIRK.

Link: https://github.com/nomad4tech/lenovo-yoga-pro-7-linux
Tested-by: Alexander Savenko <alex.sav4387@gmail.com>
Signed-off-by: Alexander Savenko <alex.sav4387@gmail.com>
Link: https://patch.msgid.link/20260331082929.44890-1-alex.sav4387@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Lore is blocking automated access. Let me check the GitHub link
mentioned in the commit.

Record: [Phase 4: Could not access lore.kernel.org due to access
restrictions. The patch was accepted by Takashi Iwai (ALSA maintainer)
which is the strongest signal for ALSA patches.]

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions modified**
No functions are modified. The change only adds a table entry to the
`alc269_fixup_tbl[]` static array.

**Step 5.2-5.4: Call chain**
The quirk table is looked up during HDA codec probe. The
`HDA_CODEC_QUIRK` macro matches on codec subsystem ID. When matched, it
applies `ALC287_FIXUP_YOGA9_14IMH9_BASS_SPK_PIN` which calls
`alc287_fixup_yoga9_14iap7_bass_spk_pin` — a function that already
exists and is already used by other quirk entries (Yoga 9 14IMH9 with
PCI SSIDs 17aa:38d2 and 17aa:38d7).

Record: [Only a static table entry addition. The fixup function and all
supporting code already exist. No new code paths created.]

**Step 5.5: Similar patterns**
Already verified: The same `HDA_CODEC_QUIRK` + `SND_PCI_QUIRK`
disambiguation pattern is used for `0x17aa:0x386e` (Legion Y9000X vs
Yoga Pro 7 14ARP8) and for `0x17aa:0x3802` (DuetITL vs Yoga Pro 9). This
is a well-established pattern.

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1: Does buggy code exist in stable?**
The Legion 7 16ACHG6 PCI SSID quirk (17aa:3847) exists in the tree. The
fixup definition `ALC287_FIXUP_YOGA9_14IMH9_BASS_SPK_PIN` was added in
v6.9-rc1. So stable trees >= 6.9 have the prerequisite. For older trees
(6.6.y, 6.1.y), the fixup definition would need to be present (would
need to check if it was backported).

**Step 6.2: Backport complications**
The file was recently split (`ALSA: hda: Split Realtek HD-audio codec
driver` in commit aeeb85f26c3bb). In stable trees, the code is likely
still in the old location (`sound/pci/hda/patch_realtek.c`). The
backport would need to target the old file path, but the actual change
(adding one table entry) is trivial.

**Step 6.3: No related fixes already in stable for this specific
device.**

Record: [Needs path adjustment for older stables where code is in
sound/pci/hda/patch_realtek.c. The prerequisite fixup
ALC287_FIXUP_YOGA9_14IMH9_BASS_SPK_PIN must exist in the target stable
tree (present since v6.9-rc1).]

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1:** Subsystem: sound/hda (ALSA HDA audio). Criticality:
IMPORTANT — audio is essential for laptop users.

**Step 7.2:** Very active subsystem with frequent quirk additions (the
recent history shows many similar patches).

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Who is affected**
Users of the Lenovo Yoga Pro 7 14IMH9 laptop — a specific but popular
consumer laptop.

**Step 8.2: Trigger conditions**
Every boot. Volume control is completely broken without this quirk. The
user cannot adjust volume at all.

**Step 8.3: Failure mode severity**
Audio volume control completely non-functional — either silent or
maximum volume. This is a HIGH severity usability issue for a laptop.
Not a crash, but makes the device partially unusable.

**Step 8.4: Risk-benefit ratio**
- BENEFIT: HIGH — restores volume control for all users of this specific
  laptop model
- RISK: VERY LOW — 1 table entry addition, using existing fixup,
  following established pattern, no code logic changes, cannot affect
  any other device
- Ratio: Strongly favorable

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence compiled**

FOR backporting:
- Fixes completely broken volume control on a specific laptop (audio
  either silent or max)
- Trivial 1-line functional change (+ 3 comment lines)
- Uses existing fixup definition — no new code
- Follows established disambiguation pattern (HDA_CODEC_QUIRK)
- Tested by the device owner
- Accepted by ALSA maintainer Takashi Iwai
- Classic hardware quirk — explicit exception category for stable

AGAINST backporting:
- File path changed in recent mainline (code was split to new location)
  — may need path adjustment
- Prerequisite fixup enum/definition only exists since v6.9-rc1 — older
  stable trees would need that too
- No Cc: stable tag (but this is expected and not a negative signal)

**Step 9.2: Stable rules checklist**
1. Obviously correct and tested? YES — tested by device owner, accepted
   by maintainer
2. Fixes a real bug? YES — broken volume control on a real laptop
3. Important issue? YES — audio completely unusable (no volume control)
4. Small and contained? YES — 4 lines, single table entry
5. No new features or APIs? CORRECT — no new features, just a quirk
   entry
6. Can apply to stable? YES for 6.12.y+ (may need path adjustment);
   6.9-6.11 needs path adjustment; <6.9 needs prerequisite

**Step 9.3: Exception category**
YES — this is a **hardware quirk/workaround** addition, one of the
explicitly listed exception categories that are almost always
appropriate for stable.

**Step 9.4: Decision**
This is a textbook stable backport candidate: a tiny hardware quirk
addition that fixes completely broken audio volume control on a specific
laptop model, using an existing fixup, with zero risk to other devices.

## Verification

- [Phase 1] Parsed tags: Tested-by from author, Signed-off-by from
  Takashi Iwai (ALSA maintainer)
- [Phase 2] Diff analysis: +4 lines (1 HDA_CODEC_QUIRK entry + 3 comment
  lines) in alc269_fixup_tbl[]
- [Phase 2] Verified the fix reuses existing
  ALC287_FIXUP_YOGA9_14IMH9_BASS_SPK_PIN fixup (line 6361)
- [Phase 3] git blame: Legion 16ACHG6 quirk at line 7574 exists in
  current tree (from aeeb85f26c3bb split commit)
- [Phase 3] git log -S: ALC287_FIXUP_YOGA9_14IMH9_BASS_SPK_PIN was
  introduced in commit 9b714a59b719b, which is in v6.9-rc1
- [Phase 3] Verified same disambiguation pattern used for 0x17aa:0x386e
  (HDA_CODEC_QUIRK at line 7582)
- [Phase 4] lore.kernel.org: Could not access due to Anubis block —
  UNVERIFIED mailing list discussion
- [Phase 5] Verified fixup definition at line 6361-6366: chains to
  alc287_fixup_yoga9_14iap7_bass_spk_pin + CS35L41_I2C_2
- [Phase 5] Confirmed fixup is already used by two other quirk entries
  (lines 7619, 7624)
- [Phase 6] Prerequisite exists since v6.9-rc1 — stable trees >= 6.12.y
  should have it; older may need check
- [Phase 6] File was split from sound/pci/hda/patch_realtek.c — backport
  needs path adjustment for older trees
- [Phase 8] Impact: volume control completely broken (silent or max) —
  confirmed from commit message
- [Phase 8] Risk: near-zero — table entry only, cannot affect other
  hardware
- UNVERIFIED: Could not verify mailing list discussion for stable
  nominations (lore blocked). This does not affect the decision since
  the technical merits are clear.

**YES**

 sound/hda/codecs/realtek/alc269.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index e55f57cca883a..22fbe9a277523 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7572,6 +7572,10 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3834, "Lenovo IdeaPad Slim 9i 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x383d, "Legion Y9000X 2019", ALC285_FIXUP_LEGION_Y9000X_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3843, "Lenovo Yoga 9i / Yoga Book 9i", ALC287_FIXUP_LENOVO_YOGA_BOOK_9I),
+	/* Yoga Pro 7 14IMH9 shares PCI SSID 17aa:3847 with Legion 7 16ACHG6;
+	 * use codec SSID to distinguish them
+	 */
+	HDA_CODEC_QUIRK(0x17aa, 0x38cf, "Lenovo Yoga Pro 7 14IMH9", ALC287_FIXUP_YOGA9_14IMH9_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3847, "Legion 7 16ACHG6", ALC287_FIXUP_LEGION_16ACHG6),
 	SND_PCI_QUIRK(0x17aa, 0x384a, "Lenovo Yoga 7 15ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3852, "Lenovo Yoga 7 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
-- 
2.53.0

