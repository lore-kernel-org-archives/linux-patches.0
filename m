Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D948B595CFC;
	Mon, 19 Oct 2026 13:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418395; cv=none; b=uHX9q6KYSvrWDSVCbzzPcEr3zq2fwTasH1kJi97XweKboM2TCwUg12M+GjuagPaJIoT7WCLMuLTUIJndQtBXAvNVnNIHsB3z1rnDLwpOB4xMRLBQ4yvp337oK38wYbXpapcj8Zkk7QgqtcflMebWNwdx0V3uZTxYsykmo4XQqz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418395; c=relaxed/simple;
	bh=P66v0MFcjpFBBQ7Yu6q/NYGEp+iqSRlLoM1XYJ5hoQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VZELo//yjeIlVwMiBYwn7ZW3xpygnxWLFvjNOkGYQOAMv0yhSBvej+sD6kry5kcTtWUt0teTY8JnwOioO2BnW1JpCJz84C6aE7wsc0O/zQsBLuAhJ88mKvZdYwNHFy+Ad4LCXoS8LTaul82EJQ+9b+RJmtBCFXbJz2MdlIrdOXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JA+VWVGq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JA+VWVGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCF71F000CA;
	Mon, 19 Oct 2026 13:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418392;
	bh=0N0TwlDZhrT8hTl0UNPRaU0LL/t6pHOExRMNal93nAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JA+VWVGqvWALDmn+cCRtTExaQ1D4Pdrj4WQevvLKODcARsUUP8SuZ2h+8v4ZTQsXW
	 O0DbU6iZetkyYR3gA/SG2KRiv4dqOXTF4RcXZXD6QhTjr/xMf8jumwGEa0ebhPU+YU
	 oHpMtTHoUqwNXq3tZNaKpsILtjSoinwbHNhK8n/zlvCI2KWSqrEYFYTF6WWh+OvR8p
	 vQN7PostB4S7Lp63MZ320eqrmEFWpLA2FpjbkvJ0UdnrmCrELNNKv3t0YvQtX+qAlX
	 jny54ZHTcS31G+ekQIIEYYA0+l1+p+kRHwaiQPkD8JY7uNbu6+1LA1+uVAk9mm9sid
	 8UT5NSfzIHCWA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Carl Quist <equalizerjr@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ALSA: hda/realtek: Enable mute LED on HP Laptop 15-dy0xxx
Date: Mon, 19 Oct 2026 09:48:28 -0400
Message-ID: <20261019135441.1420968-217-sashal@kernel.org>
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

From: Carl Quist <equalizerjr@gmail.com>

[ Upstream commit eb2b516900f2cff6c931a0d664a625ee93855779 ]

The mute LED on the HP Laptop 15-dy0xxx (PCI SSID 103c:864f, Realtek
ALC236) does not work, because the machine has no entry in the quirk
table. No fixup is applied, so no mute LED classdev is registered and
nothing ever drives the LED.

The LED is controlled by COEF index 0x07, bit 0. This was verified on
the hardware with hda-verb: setting the bit lights the mute LED and
clearing it turns the LED off.

  hda-verb /dev/snd/hwC0D0 0x20 SET_COEF_INDEX 0x07
  hda-verb /dev/snd/hwC0D0 0x20 SET_PROC_COEF 0x1     # LED on
  hda-verb /dev/snd/hwC0D0 0x20 SET_PROC_COEF 0x200   # LED off

That is exactly what ALC236_FIXUP_HP_MUTE_LED_COEFBIT2 configures, and
the closely related HP Laptop 15-dw0xxx (103c:85f0) already uses it.
Bit 9 (0x200) is set by default on this board and is preserved by the
fixup's read-modify-write.

Tested on an HP Laptop 15-dy0xxx (SKU 7FU54UA#ABA, board 864F,
BIOS F.40).

Signed-off-by: Carl Quist <equalizerjr@gmail.com>
Link: https://lore.kernel.org/CAOtcGaxXndKxTK5MVSEcmF-LUy+V51K7fhE=qvLA+VvW5ZyCNA@mail.gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a one-line Realtek HDA mute-LED quirk for PCI SSID `103c:864f`.
The local tree is **6.12.111** (`pending-6.12`). The helper it uses
already exists here; only the table entry is missing.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[ALSA: hda/realtek] [Enable] Enable mute LED on HP Laptop
15-dy0xxx`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Signed-off-by: Carl Quist <equalizerjr@gmail.com>` (author)
- `Link: https://lore.kernel.org/CAOtcGaxXndKxTK5MVSEcmF-
  LUy+V51K7fhE=qvLA+VvW5ZyCNA@mail.gmail.com`
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>` (ALSA maintainer)
- No `Fixes:` tag (expected)
- No `Cc: stable` (expected)
- No `Reported-by:` / `Tested-by:` / `Reviewed-by:` / `Acked-by:`
- Hardware test is in the body (“Tested on an HP Laptop 15-dy0xxx…”)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** HP Laptop 15-dy0xxx (PCI SSID `103c:864f`, ALC236) has no
  quirk-table entry, so no mute-LED classdev is registered and the LED
  never lights.
- **Symptom:** mute LED does not track mute state.
- **Root cause:** missing `SND_PCI_QUIRK` for this SSID. LED is COEF
  index `0x07` bit 0, verified with `hda-verb` on real hardware.
- **Fix:** reuse existing `ALC236_FIXUP_HP_MUTE_LED_COEFBIT2` (same as
  HP Laptop 15-dw0xxx `103c:85f0`).
- **Version info:** none beyond the model; hardware SKU `7FU54UA#ABA`,
  BIOS F.40.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. It is an explicit hardware-quirk
addition for a non-working mute LED.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File in mainline: `sound/hda/codecs/realtek/alc269.c` (+1 / -0)
- Function/table: `alc269_fixup_tbl[]`
- Scope: single-file, one-line surgical quirk
- Local equivalent file: `sound/pci/hda/patch_realtek.c` (HDA codecs
  were not yet split in 6.12)

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record: Before, SSID `103c:864f` matches no entry, so
`snd_hda_pick_fixup()` applies no ALC236 mute-LED fixup. After, that
SSID maps to `ALC236_FIXUP_HP_MUTE_LED_COEFBIT2`, which at
`HDA_FIXUP_ACT_PRE_PROBE` registers a mute-LED classdev. Probe-time
only; no other SSIDs change.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **(h) Hardware workaround.** Missing `SND_PCI_QUIRK` for a
laptop whose ALC236 mute LED is driven by COEF `0x07` bit 0.

Verified against this tree’s helper:

```4763:4776:sound/pci/hda/patch_realtek.c
static void alc236_fixup_hp_mute_led_coefbit2(struct hda_codec *codec,
                                          const struct hda_fixup *fix,
int action)
{
        struct alc_spec *spec = codec->spec;

        if (action == HDA_FIXUP_ACT_PRE_PROBE) {
                spec->mute_led_polarity = 0;
                spec->mute_led_coef.idx = 0x07;
                spec->mute_led_coef.mask = 1;
                spec->mute_led_coef.on = 1;
                spec->mute_led_coef.off = 0;
                snd_hda_gen_add_mute_led_cdev(codec, coef_mute_led_set);
        }
}
```

`alc_update_coef_idx()` is RMW (`(val & ~mask) | bits_set`), so bit 9
(`0x200`) is preserved as the commit claims.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct: one existing fixup, one SSID, gated by PCI
subsystem ID. Regression risk is limited to this exact machine. No API,
locking, or hot-path change.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: There is no “buggy line” — the bug is a **missing** table entry.
The helper `alc236_fixup_hp_mute_led_coefbit2` was added in
`0659400f18c0e` (2023-07-19, “Enable Mute LED on HP Laptop 15s-eq2xxx”)
with `Cc: stable`. That helper is an ancestor of this HEAD.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Not applicable. The missing-SSID pattern is the
same as many later quirk adds.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: This tree already contains the same class of patches, e.g.:
- `dda834cc2048d` — HP 14s-dr1xxx mute LED (`0x86c8`, COEFBIT2), landed
  2026-09-21
- `dc60a7d2dc78b` — HP 15s-eq1xxx mute LED (`0x8706`, COEFBIT2)
- `b685eba97a5ae` — HP 14s-dr5xxx mute LED
Standalone; not patch X/Y.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: `git log --author="Carl Quist" -- sound/pci/hda/` in this tree
is empty. Author is an end-user reporter, not the subsystem maintainer.
Takashi Iwai applied the patch the same day.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Only prerequisite is `ALC236_FIXUP_HP_MUTE_LED_COEFBIT2`,
present here. The commit mentions 15-dw0xxx (`103c:85f0`,
`b28d3d0841a60`, 2026-07-03) as a related user of the same fixup; that
SSID is **not** in this tree and is **not** required. Can apply
standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c eb2b516900f2c` →
  https://patch.msgid.link/CAOtcGaxXndKxTK5MVSEcmF-
  LUy+V51K7fhE=qvLA+VvW5ZyCNA@mail.gmail.com
- `b4 dig -a`: single v1, 2026-08-05, Carl Quist. No later revision.
- Thread: Takashi Iwai: “Applied now. But at the next time, please
  submit to linux-sound@vger.kernel.org, instead.”
- No NAK, no stable objection, no requested changes.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: `b4 dig -w` recipients: Carl Quist, `alsa-devel@alsa-
project.org`, `tiwai@suse.de`. Subsystem maintainer received and applied
it.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: The submission is the bug report. Hardware-verified with `hda-
verb` and a named SKU. Lore fetch of the search URL returned 403; the
thread was obtained via `b4 dig -m` instead.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone. Sibling 15-dw0xxx (`b28d3d0841a60`) was AUTOSEL’d
for 6.18 — same pattern, different SSID. Not a dependency.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: Web search of lore.kernel.org/stable for this subject did not
return a 15-dy0xxx discussion. No evidence it was rejected for stable.
Closely analogous COEFBIT2 mute-LED quirks are already in this 6.12
tree.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: Table `alc269_fixup_tbl[]` only. Runtime path uses existing
`alc236_fixup_hp_mute_led_coefbit2()` →
`snd_hda_gen_add_mute_led_cdev()` → `coef_mute_led_set()` →
`alc_update_coef_led()`.

**Step 5.2: TRACE CALLERS**
Record: `alc269_fixup_tbl` is passed from the ALC269-family probe path:

```12583:12584:sound/pci/hda/patch_realtek.c
        snd_hda_pick_fixup(codec, alc269_fixup_models,
                       alc269_fixup_tbl, alc269_fixups);
```

That is codec probe (device enumeration), not IRQ or a syscall hot path.

**Step 5.3: TRACE CALLEES**
Record: `alc_update_coef_idx()` → `__alc_update_coefex_idx()` does RMW
on NID `0x20`. Matches the `hda-verb` sequence in the commit
(`SET_COEF_INDEX 0x07` on `0x20`).

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace mute → LED classdev brightness →
`coef_mute_led_set()`. Reachable on this laptop whenever the user mutes.
Not a crash path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Many HP ALC236 laptops in this tree already use
`ALC236_FIXUP_HP_MUTE_LED_COEFBIT2` (`0x84ae`, `0x86c1`, `0x86c8`,
`0x8706`, `0x87b7`, `0x87d3`, …). This is the same established pattern.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- Tree: `p-6.12-2-gd38d58a4e0359`, `make kernelversion` = **6.12.111**,
  branch `pending-6.12`
- `git merge-base --is-ancestor eb2b516900f2c HEAD` → not an ancestor
  (commit not in this tree)
- `0x864f` is absent from `sound/pci/hda/patch_realtek.c`
- Helper and enum `ALC236_FIXUP_HP_MUTE_LED_COEFBIT2` are present (since
  v6.5-era `0659400f18c0e`)
- Insertion neighbors exist: `0x861f` then `0x869d` at lines 10898–10899

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Path remap only (`alc269.c` → `patch_realtek.c`). Context around
`0x861f`/`0x869d` matches. Expected: **clean apply with path
adjustment**, same as `dda834cc2048d` already on this branch.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No 15-dy0xxx / `0x864f` entry. Other COEFBIT2 HP mute-LED quirks
are present; none covers this SSID.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `sound/pci/hda` Realtek codec quirks. **IMPORTANT** for laptop
audio (very common driver), but this one line is **platform/device-
specific**.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Active: recent mute-LED quirk backports on this same file
(`faee5b4612c26`, `dda834cc2048d`, …). Mature quirk table; this is a
routine SSID add, not new infrastructure.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver-specific / platform-specific:** HP Laptop 15-dy0xxx
with PCI SSID `103c:864f` and `CONFIG_SND_HDA_CODEC_REALTEK`. No other
machines match this SSID.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Every mute toggle on that laptop. Unprivileged users can trigger
the LED path, but the current bug is “LED never works,” not a crash.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Mute LED stuck/off. **MEDIUM** for that hardware (broken
indicator, not oops/corruption). Still the documented stable **hardware-
quirk exception**.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** restores mute LED on a shipping HP 15-dy0xxx; same fix
  already used on many ALC236 HP models in this tree.
- **Risk:** very low — 1 line, SSID-gated, existing helper.
- **Ratio:** strongly favorable.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Hardware codec quirk (`SND_PCI_QUIRK`) — explicit stable exception
- Real, hardware-tested bug (named SKU, `hda-verb` proof)
- One line; existing `ALC236_FIXUP_HP_MUTE_LED_COEFBIT2` already in 6.12
- ALSA maintainer applied v1 with no objections
- Same class of quirks already backported to this tree (14s-dr1xxx two
  days ago)
- Sibling 15-dw0xxx quirk was AUTOSEL’d for 6.18

AGAINST:
- Not a crash, security issue, or data-corruption fix (LED-only)
- Mainline path differs (`alc269.c` vs `patch_realtek.c`) — trivial
  remap
- Author is not a regular ALSA contributor

UNRESOLVED:
- Direct lore.kernel.org HTTP fetch returned 403; thread recovered via
  `b4 dig -m`
- No dedicated stable-list thread found for this exact subject

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — 1-line SSID map; tested on
   named hardware; maintainer applied
2. Fixes a real bug that affects users? **PASS** — mute LED never driven
   on this laptop
3. Important issue? **PASS** under the hardware-quirk exception
   (severity MEDIUM: LED, not crash)
4. Small and contained? **PASS** — +1 line, one table
5. No new features or APIs? **PASS** — wires an existing fixup
6. Can apply to the local tree? **PASS** — helper present; insert
   between `0x861f` and `0x869d` in `patch_realtek.c`

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Hardware quirk / audio codec quirk** (`SND_PCI_QUIRK` in
Realtek HDA). Qualifies automatically.

**Step 9.4: MAKE YOUR DECISION**
The 6.12 tree already has the COEFBIT2 helper and many HP ALC236 mute-
LED SSIDs. This commit only adds `103c:864f`. That is the standard, low-
risk stable backport for Realtek laptop LED quirks.

Detailed explanation:
- **Problem:** Without a quirk, ALC236 on HP 15-dy0xxx never registers a
  mute-LED classdev, so the LED stays dead.
- **Why it matters here:** 6.12 users on that SKU still see a broken
  LED; the driver and helper are already in this tree.
- **Rules:** Matches the quirk exception; small, tested, no new API.
- **Risk vs benefit:** Benefit is a working LED on one HP model; risk is
  confined to that SSID.
- **Backport note:** Change the path to `sound/pci/hda/patch_realtek.c`;
  no other code changes needed.

Verification:
- [Phase 1] Parsed tags: author SOB Carl Quist; Link to lore Message-ID;
  maintainer SOB Takashi Iwai; no Fixes/Cc:stable/Reported-by
- [Phase 2] Diff: +1 `SND_PCI_QUIRK(0x103c, 0x864f, …,
  ALC236_FIXUP_HP_MUTE_LED_COEFBIT2)` in `alc269_fixup_tbl`
- [Phase 2] Helper in this tree at `alc236_fixup_hp_mute_led_coefbit2()`
  uses COEF 0x07 mask/on=1; `__alc_update_coefex_idx` is RMW
- [Phase 3] `git log -S alc236_fixup_hp_mute_led_coefbit2 --
  sound/pci/hda/patch_realtek.c` → `0659400f18c0e` (2023-07-19,
  Cc:stable); `git merge-base --is-ancestor 0659400f18c0e HEAD` →
  present
- [Phase 3] `git merge-base --is-ancestor eb2b516900f2c HEAD` → not in
  this tree
- [Phase 3] Related in-tree backports: `dda834cc2048d` (14s-dr1xxx),
  `dc60a7d2dc78b` (15s-eq1xxx)
- [Phase 4] `b4 dig -c eb2b516900f2c`: v1 only; Takashi “Applied now”;
  CC’d alsa-devel + tiwai
- [Phase 4] Sibling `b28d3d0841a60` (15-dw0xxx) AUTOSEL 6.18; not an
  ancestor of this HEAD and not required
- [Phase 5] Probe uses `snd_hda_pick_fixup(..., alc269_fixup_tbl, ...)`
- [Phase 6] `git describe HEAD` = `p-6.12-2-gd38d58a4e0359`; `make
  kernelversion` = 6.12.111; `0x864f` absent; insert point
  `0x861f`/`0x869d` at lines 10898–10899
- [Phase 8] Failure mode: mute LED not driven; severity MEDIUM; SSID-
  gated
- UNVERIFIED: lore.kernel.org HTTP 403 on search/direct Message-ID URLs
  (thread obtained via b4 instead)
- UNVERIFIED: no dedicated stable@ thread found for this exact commit

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 68d5e5aa7f62d..f2b0eb8501a78 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6772,6 +6772,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x860c, "HP ZBook 17 G6", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x860f, "HP ZBook 15 G6", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x861f, "HP Elite Dragonfly G1", ALC285_FIXUP_HP_GPIO_AMP_INIT),
+	SND_PCI_QUIRK(0x103c, 0x864f, "HP Laptop 15-dy0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x86c1, "HP Laptop 15-da3001TU", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x86c7, "HP Envy AiO 32", ALC274_FIXUP_HP_ENVY_GPIO),
-- 
2.53.0

