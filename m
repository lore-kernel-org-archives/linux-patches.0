Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1468133C198;
	Tue,  5 May 2026 09:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974756; cv=none; b=WLHxm1EgCljA3SOLwgsDdgHcZBaWBJu9r4NDRr2YaOR3naIyoOmVHr9/jV+WOv1fDmkC0MprPJbpKUCGWRokAcLcBj3W6dG7KXA+Yf8t+hLxveQjmB1rpR2Xk4Zub3n5wuRbRU6tXgOaFALgnv0/Ff2KWNuWx4vlir6sS2Eoi0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974756; c=relaxed/simple;
	bh=+NQZq6ow+W7k9MhTGLX6BfAec5X/c3w9rFb+3sB/PBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AMlknSet/SdbeWqqZW6xQxcxtpwrQ6vmIoa+OGMKsgWFqRWVyEhVWerbzYNGnnz5urZSIK3ahVWy8Zc3hTJ1cCyG0+jS1Vz3nJv5/RCgw3jzW5CKiZeqIgAJ0YJaRMvpGGfzdwiqyBabgURnyXKnBs79YwH64NIOSEWDBgcpLqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CC6EZJM5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CC6EZJM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BDC6C2BCB4;
	Tue,  5 May 2026 09:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777974756;
	bh=+NQZq6ow+W7k9MhTGLX6BfAec5X/c3w9rFb+3sB/PBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CC6EZJM5OYL3U5SI1rWkohLrK8krGAIwSbaAYWGisstNub/CcVzpEUaOIoBT3Zp63
	 scjHlMCwWUCc/Moege7OwRewb5YYx+qPEjS3ovmLOoZvq2XsyVutJSr19r+9jYz5SA
	 v8hDnz8soAKDaV/XuiLyjyTx7dEKQKO0YxEDZ8yaULwPuNOLShcsMXzHuwpqq/dgHt
	 j7ZNW98WoOgD9w+FfC8PQpb49ywpfMw53t7kJECP9iShrWqPcntZqMVXMpT1R6s4WI
	 pQu9tMuBzFqO0OVXx3oTOewKrfwPEIzaBD9qTb3f5AMl5vFdl5tw9RqcEaROAPodqA
	 EW8juRVbgMbLA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yuxuan Qiu <yuxuanqiu596@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] ALSA: hda/realtek: enable mute LED support on ThinkBook 16p
Date: Tue,  5 May 2026 05:51:30 -0400
Message-ID: <20260505095149.512052-14-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260505095149.512052-1-sashal@kernel.org>
References: <20260505095149.512052-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuxuan Qiu <yuxuanqiu596@gmail.com>

[ Upstream commit 597aa74b0e73f5e0c915b5d0c95cb296774589bd ]

On ThinkBook 16p systems the platform mute LED is present and
bound to the audio-mute trigger, but it does not react to Master
mute changes.

The affected fixup chain sets up the DAC routing, but does not enable
vmaster mute LED handling. Because of that, the generic HDA code does
not mark Master Playback Switch with SNDRV_CTL_ELEM_ACCESS_SPK_LED,
and the audio-mute trigger never receives speaker mute updates.

Add a ThinkBook-specific wrapper around alc287_fixup_bind_dacs() and
enable spec->gen.vmaster_mute_led during PRE_PROBE. This keeps the
existing DAC binding logic unchanged while allowing the normal generic
LED path to drive the mute LED.

Signed-off-by: Yuxuan Qiu <yuxuanqiu596@gmail.com>
Link: https://patch.msgid.link/20260424112107.22206-1-yuxuanqiu596@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

Step 1.1 Record: subsystem `ALSA: hda/realtek`; action verb `enable`;
claimed intent is enabling speaker mute LED support on Lenovo ThinkBook
16p systems whose LED is already bound to `audio-mute` but not updated
by Master mute changes.

Step 1.2 Record: tags present are `Signed-off-by: Yuxuan Qiu
<yuxuanqiu596@gmail.com>`, `Link:
https://patch.msgid.link/20260424112107.22206-1-yuxuanqiu596@gmail.com`,
and `Signed-off-by: Takashi Iwai <tiwai@suse.de>`. No `Fixes:`,
`Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-by:`, or `Cc:
stable@vger.kernel.org` tag was present.

Step 1.3 Record: the commit describes a real hardware behavior bug: the
platform mute LED exists and is registered with the `audio-mute`
trigger, but `Master Playback Switch` lacks
`SNDRV_CTL_ELEM_ACCESS_SPK_LED`, so ALSA control LED notifications never
drive the LED. No kernel crash, corruption, or security symptom is
claimed. No affected kernel version is explicitly stated.

Step 1.4 Record: this is a hardware quirk/fix disguised as an enablement
patch. It is not a new driver or new API; it enables an existing generic
HDA LED path for an existing Realtek/Lenovo fixup chain.

## Phase 2: Diff Analysis

Step 2.1 Record: one file changed, `sound/hda/codecs/realtek/alc269.c`,
with 12 insertions and 1 replacement in the submitted patch. Modified
areas are a new helper `alc287_fixup_tb_vmaster_led()` and the
`ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD` fixup table entry.
Scope is single-file and surgical.

Step 2.2 Record: before,
`ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD` directly called
`alc287_fixup_bind_dacs()`, which adjusts DAC routing and amp mute
behavior during `HDA_FIXUP_ACT_PRE_PROBE`. After, it calls a wrapper
that sets `spec->gen.vmaster_mute_led = 1` during `PRE_PROBE`, then
calls the same DAC binding function. Normal DAC binding behavior is
preserved.

Step 2.3 Record: bug category is hardware quirk / logic correctness for
LED control metadata. The broken mechanism is missing
`vmaster_mute_led`, verified in `generic.c`: when set,
`snd_hda_gen_build_controls()` adds `SNDRV_CTL_ELEM_ACCESS_SPK_LED` to
`Master Playback Switch`; the ALSA control LED layer then follows that
control and fires the `audio-mute` LED trigger.

Step 2.4 Record: the fix is obviously simple: a one-bit flag is set
before auto config parsing/building controls, and the existing fixup
function is still invoked. Main regression risk is that the changed
fixup ID is shared by several Lenovo ThinkPad/ThinkBook SSIDs, not only
ThinkBook 16p. Verified matching entries include ThinkPad P1/Z-series,
ThinkBook 16P, ThinkBook 13x, and ThinkBook 16P Gen5 on current
branches. The behavioral change is limited to LED control tagging, so
risk is low.

## Phase 3: Git History Investigation

Step 3.1 Record: `git blame` on current `v7.0.3` points changed lines to
the Realtek driver split commit `aeeb85f26c3b` because the file moved.
`git log -S` traced the actual related history: ThinkBook 16P IDs
`0x38a9/0x38ab` were added by `6214e24cae9b` in v6.8; Gen4 was switched
to the affected MG/CS35L41 fixup by `dca5f4dfa925` in v6.9; Gen5 was
switched by `34c8e74cd666` in v6.13. The affected MG/CS35L41 fixup was
introduced earlier by `d93eeca627db`.

Step 3.2 Record: no `Fixes:` tag is present, so there was no tagged
introducing commit to follow. Related history nevertheless shows the
affected ThinkBook 16P quirk chain exists in maintained stable-era
kernels.

Step 3.3 Record: recent file history shows many ALSA Realtek quirk and
mute LED fixes. Related ThinkBook commits are `dca5f4dfa925` and
`34c8e74cd666`, both fixing ThinkBook 16P volume/mute behavior by
selecting the same MG/CS35L41 fixup. No prerequisite patch for this new
wrapper was identified beyond the target tree already having
`alc287_fixup_bind_dacs()` and
`ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD`.

Step 3.4 Record: no prior local commits from Yuxuan Qiu were found under
the Realtek HDA paths. Takashi Iwai, the ALSA maintainer, applied the
patch in the mailing-list thread.

Step 3.5 Record: dependencies are minimal. Current `v7.0.3` accepts the
submitted patch with `git apply --check`. Older pre-driver-split stable
trees need a path adjustment from `sound/hda/codecs/realtek/alc269.c` to
`sound/pci/hda/patch_realtek.c`.

## Phase 4: Mailing List And External Research

Step 4.1 Record: no local commit hash for this candidate was available,
so `b4 dig -c <commit>` was not applicable. `b4 am` using message id
`20260424112107.22206-1-yuxuanqiu596@gmail.com` fetched the original
submission and reported one patch in a two-message thread. The yhbt lore
mirror confirmed the same patch text and one maintainer reply.

Step 4.2 Record: recipients verified from the mbox were Jaroslav Kysela,
Takashi Iwai, `linux-sound@vger.kernel.org`, and `linux-
kernel@vger.kernel.org`. Takashi Iwai replied “Thanks, applied now.” No
NAKs or concerns were present in the fetched thread.

Step 4.3 Record: there was no separate `Reported-by:` or bugzilla/syzbot
link in this patch. External search found the indexed patch and related
Lenovo mute LED/platform LED context, but no independent user bug report
for this exact issue.

Step 4.4 Record: the thread is a single-patch submission, not a multi-
patch series. No later revision was found by `b4 am`; the thread
contains only the patch and maintainer apply reply.

Step 4.5 Record: web search did not find a stable-specific discussion or
explicit stable request for this exact patch. Direct lore WebFetch was
blocked by Anubis, but the yhbt mirror and `b4` provided the thread
content.

## Phase 5: Code Semantic Analysis

Step 5.1 Record: modified functions/objects are
`alc287_fixup_tb_vmaster_led()` and the
`ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD` fixup table entry.

Step 5.2 Record: call path verified: `alc269_probe()` picks Realtek
fixups, applies `HDA_FIXUP_ACT_PRE_PROBE`, then runs
`alc269_parse_auto_config()`; `alc_build_controls()` later calls
`snd_hda_gen_build_controls()`. The affected code runs during codec
probe for matching Lenovo HDA SSIDs.

Step 5.3 Record: key callees are `alc287_fixup_bind_dacs()`,
`snd_hda_override_conn_list()`, and generic HDA control creation.
`generic.c` verifies `spec->vmaster_mute_led` directly controls whether
`SNDRV_CTL_ELEM_ACCESS_SPK_LED` is passed to `__snd_hda_add_vmaster()`.

Step 5.4 Record: runtime reachability is verified through hardware probe
and ALSA mixer control updates. Userspace changing `Master Playback
Switch` can trigger ALSA control LED notifications once the control has
the speaker LED access flag.

Step 5.5 Record: similar Realtek patterns exist: many HDA Realtek
commits add or fix mute LED quirks; current code also has existing
`vmaster_mute_led = 1` usage in another mute LED fixup and many
`snd_hda_gen_add_mute_led_cdev()` users.

## Phase 6: Cross-Referencing And Stable Tree Analysis

Step 6.1 Record: `v6.12` contains ThinkBook 16P `0x38a9/0x38ab` using
the affected fixup; `v6.13+` contains ThinkBook 16P Gen5 `0x38f9` using
the affected fixup. `for-greg/6.12-201` contains both ThinkBook 16P and
Gen5 using the affected fixup. `for-greg/6.6-201` contains the affected
fixup for several ThinkPad SSIDs but not the original ThinkBook 16P
`0x38a9/0x38ab`; its Gen5 `0x38f9` entry still uses
`ALC287_FIXUP_CS35L41_I2C_2`, so this exact ThinkBook 16p bug is not
fully verified there.

Step 6.2 Record: expected backport difficulty is clean for current post-
split trees such as `v7.0.3`; minor manual backport for pre-split trees
because the same code lives in `sound/pci/hda/patch_realtek.c`.

Step 6.3 Record: no alternate stable fix for this exact mute LED issue
was found. Related ThinkBook volume/mute fixup selection commits exist
and are prerequisites for branches where the ThinkBook entries use the
affected MG/CS35L41 fixup.

## Phase 7: Subsystem And Maintainer Context

Step 7.1 Record: subsystem is ALSA HDA Realtek codec quirks, under sound
drivers. Criticality is peripheral/driver-specific, affecting Lenovo
systems with these Realtek/CS35L41 configurations.

Step 7.2 Record: subsystem activity is high; recent history shows many
Realtek quirk additions and mute LED fixes. This is typical stable
material when scoped to specific hardware behavior.

## Phase 8: Impact And Risk Assessment

Step 8.1 Record: affected population is driver-specific: Lenovo
ThinkBook/ThinkPad systems matching the shared
`ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD` quirk, especially
verified ThinkBook 16P/16P Gen5 entries in newer stable trees.

Step 8.2 Record: trigger condition is ordinary Master mute changes after
boot on affected hardware. This is user-triggerable through normal audio
controls. The failure is visible as a mute LED that does not track mute
state.

Step 8.3 Record: failure severity is LOW to MEDIUM. It is not a crash or
data-loss bug, but it is a real hardware/user-visible regression in mute
state indication.

Step 8.4 Record: benefit is moderate for affected laptops: restores
expected mute LED behavior using existing ALSA trigger infrastructure.
Risk is low: one bit is set during probe and existing DAC routing logic
remains unchanged. The only meaningful concern is wider impact on all
devices sharing the fixup ID, but the added effect is LED
metadata/control-trigger handling, not audio routing or power
sequencing.

## Phase 9: Final Synthesis

Step 9.1 Record:
Evidence for backporting: real user-visible hardware bug; tiny one-file
fix; uses existing generic HDA LED path; accepted by ALSA maintainer
Takashi Iwai; current tree patch applies cleanly; stable-style hardware
quirk; related ThinkBook fixup commits are already present in maintained
stable branches.
Evidence against backporting: no crash/security/corruption; no
`Reported-by` or `Tested-by`; fixup ID is shared beyond ThinkBook 16p;
older stable branches may need path adjustment and should only receive
this where the affected fixup/IDs exist.
Unresolved: exact upstream commit SHA was not available locally; no
independent bug report beyond the patch mail was found; exact
applicability to every active stable branch must be checked branch-by-
branch.

Step 9.2 Record:
1. Obviously correct and tested? Mostly yes by inspection and maintainer
   acceptance; no explicit `Tested-by`.
2. Fixes a real bug? Yes, verified mechanism: missing `vmaster_mute_led`
   prevents `SNDRV_CTL_ELEM_ACCESS_SPK_LED` tagging.
3. Important issue? Moderate, hardware/user-visible mute LED
   correctness, not critical stability.
4. Small and contained? Yes, one helper and one fixup function pointer
   change.
5. No new feature/API? Yes in stable sense: it enables existing LED
   trigger behavior for existing hardware; no new userspace API.
6. Can apply to stable trees? Yes on current post-split trees; older
   trees need path adjustment.

Step 9.3 Record: exception category applies: hardware-specific
quirk/workaround in an existing driver.

Step 9.4 Decision: backport. This is not a critical crash fix, but ALSA
HDA hardware quirks and mute LED fixes are normal stable material. The
patch is small, preserves existing routing logic, and fixes a concrete
hardware behavior problem on affected Lenovo systems. Backport only to
trees containing the affected fixup and relevant Lenovo entries, with
pre-split path adjustment where needed.

## Verification

- [Phase 1] Parsed supplied subject/body/tags; confirmed no `Fixes:`,
  `Reported-by`, `Tested-by`, `Reviewed-by`, or stable tag.
- [Phase 2] Read local `alc269.c`; confirmed `alc287_fixup_bind_dacs()`
  adjusts DAC routing and does not set `vmaster_mute_led`.
- [Phase 2] Read `generic.h` and `generic.c`; confirmed
  `vmaster_mute_led` means “add SPK-LED flag to vmaster mute switch” and
  is used when creating `Master Playback Switch`.
- [Phase 3] `git blame` and `git log -S` traced related ThinkBook/fixup
  history to `6214e24cae9b`, `dca5f4dfa925`, `34c8e74cd666`, and
  `d93eeca627db`.
- [Phase 3] `git show` confirmed `6214e24cae9b` added ThinkBook 16P IDs,
  `dca5f4dfa925` switched Gen4 to the affected fixup, and `34c8e74cd666`
  switched Gen5 to the affected fixup.
- [Phase 3] `git log --author="Yuxuan Qiu"` under Realtek paths found no
  prior local author commits.
- [Phase 4] `b4 am` fetched the two-message thread; `b4 mbox` saved and
  verified the full thread.
- [Phase 4] WebFetch of patch.msgid.link was blocked by Anubis; yhbt
  lore mirror successfully showed the patch and Takashi Iwai’s “Thanks,
  applied now.”
- [Phase 4] WebSearch found no stable-specific request for this exact
  patch.
- [Phase 5] `rg` and file reads verified the probe path:
  `alc269_probe()` applies PRE_PROBE fixups before auto config parsing,
  and `alc_build_controls()` calls generic control creation.
- [Phase 5] Read `control_led.c`; confirmed controls tagged with speaker
  LED access update the `audio-mute` LED trigger.
- [Phase 6] `git grep` verified `v6.12` and `for-greg/6.12-201` contain
  ThinkBook entries using the affected fixup; `for-greg/6.6-201`
  contains the affected fixup but not the original ThinkBook 16P IDs.
- [Phase 6] `git apply --check` against current `v7.0.3` succeeded.
- [Phase 8] Risk assessment verified the patch changes only LED metadata
  setup and preserves the existing `alc287_fixup_bind_dacs()` call.
- UNVERIFIED: exact candidate commit SHA, because the subject was not
  found as a local commit in the checked branches and only the mailing-
  list patch was available.
- UNVERIFIED: independent user bug report outside the patch thread.
- UNVERIFIED: clean application to every older stable branch without
  manual path adjustment.

**YES**

 sound/hda/codecs/realtek/alc269.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index ae74e1b69eb3a..44cf78ea6dc03 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3707,6 +3707,17 @@ static void alc287_fixup_lenovo_thinkpad_with_alc1318(struct hda_codec *codec,
 	spec->power_hook = alc287_s4_power_gpio3_default;
 	spec->gen.pcm_playback_hook = alc287_alc1318_playback_pcm_hook;
 }
+
+static void alc287_fixup_tb_vmaster_led(struct hda_codec *codec,
+					const struct hda_fixup *fix, int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	if (action == HDA_FIXUP_ACT_PRE_PROBE)
+		spec->gen.vmaster_mute_led = 1;
+
+	alc287_fixup_bind_dacs(codec, fix, action);
+}
 /* GPIO2: mute led GPIO3: micmute led */
 static void alc245_tas2781_spi_hp_fixup_muteled(struct hda_codec *codec,
 					  const struct hda_fixup *fix, int action)
@@ -6460,7 +6471,7 @@ static const struct hda_fixup alc269_fixups[] = {
 	},
 	[ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD] = {
 		.type = HDA_FIXUP_FUNC,
-		.v.func = alc287_fixup_bind_dacs,
+		.v.func = alc287_fixup_tb_vmaster_led,
 		.chained = true,
 		.chain_id = ALC287_FIXUP_CS35L41_I2C_2_THINKPAD_ACPI,
 	},
-- 
2.53.0

