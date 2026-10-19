Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE3553875B;
	Mon, 19 Oct 2026 14:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418681; cv=none; b=M/O0ZSdK3K50IYKthoXdXUZbxEWcxPvwBN/xuPrvcdlLJIYv8sJQoVfXYDJuuRCtDKEC9P/c8ul9w+q9+wMatXOYYOomrMOBZ14KoOL+9oZU7MtcbwN6aXf3zYBDRLatr7OTR3FtcbI7qNShd/OMKNuTs3P3S9gClD40c447LSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418681; c=relaxed/simple;
	bh=jrQMOA/SM4mc01xbFxhcMqq6uwiY2uRcd+zxTo7vtqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mdydJ9MFpZ6Bw+hwXyXUQgwaLRB1VM7T/92dqgVYQSYCd2p6hU+10eU0QRtp8dyidQH0j+3EsX5lM5HS/GGTRUhqEEBnH28/DmqSTZ7nZHkQCZpCjPhLhRFpvD/dIDPnWJcGnUfzZDsWFHiIjkDpqb0/3FytJMkkSfAgq9r1r9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FYh1Z35Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FYh1Z35Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43161F000C4;
	Mon, 19 Oct 2026 14:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418678;
	bh=1GBZygteAOTn7BJ5HKhZvdqg98ATeVmYxOHQkitqReU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FYh1Z35YrvPMr2AKY+hn/4u/rj/z6BSpBvwvu4oQ8uI4SWQjnUvKVmMfT3obnVV6K
	 oHFlE+k63RpPibpVOpFkxfpSnSWOZT7FRgL7sfwqkRMoKAnNXLT7d9yFT4EshAEEt4
	 7Nz160dkmxxIqUtm59AXwzGWiNoEJML6HEd2X45E1LVLRBe/ipCfWOEMd19rj0iXLk
	 2qQNy7ksTh4/i8r1E2INXkSCLXQMl7Cg/rmnDLvwj2KK0+oJJvjryOf/YnShz/1I+7
	 /wTMl68j5BxbnECrM/0j+seFpxwcqHaCZ3KLS26hAZuhaqqsKJDzfj0iGduq5lr4I4
	 Kci6n3q9y9AGw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Muhtasham Nawr al-Mahmud <muhtaseem2005@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] ALSA: hda/realtek: Fix speakers on ASUS PM3406CHA
Date: Mon, 19 Oct 2026 09:51:50 -0400
Message-ID: <20261019135441.1420968-419-sashal@kernel.org>
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

From: Muhtasham Nawr al-Mahmud <muhtaseem2005@gmail.com>

[ Upstream commit 0eee030c2c09c7a44be778de5f451d9e7a2f09c1 ]

The ASUS ExpertBook PM3406CHA uses an ALC256 codec with subsystem
ID 1043:1664. On Linux boot, the internal speakers are silent even
though playback is routed to the codec and the speaker pin is
configured for output.

The codec starts with coefficient 0x10 set to 0x1d20. Writing 0x7f20
to coefficient 0x10 immediately restores internal speaker output.

This was reproduced on the affected hardware from a fresh boot using
hda-verb. Reducing a larger initialization sequence showed that this
coefficient write alone is sufficient; no GPIO, EAPD, pin-control, or
other coefficient changes are required. After applying the coefficient
in userspace, speaker output also remains functional across suspend
and resume.

Add a machine-specific HDA fixup that writes the required coefficient.

The fixup has been compile-tested, but could not be boot-tested because
the affected hardware is no longer available.

Closes: https://bugs.launchpad.net/ubuntu/+source/alsa-driver/+bug/2162718
Signed-off-by: Muhtasham Nawr al-Mahmud <muhtaseem2005@gmail.com>
Link: https://patch.msgid.link/20260924144512.3989-1-muhtaseem2005@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a machine-specific Realtek HDA quirk for silent speakers on one
ASUS laptop. The local tree is **6.18.57**; the ALC256 driver and quirk
tables are already here, and the SSID entry is not.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[ALSA: hda/realtek]** **[Fix]** **[restore internal speakers
on ASUS ExpertBook PM3406CHA]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Closes: https://bugs.launchpad.net/ubuntu/+source/alsa-
  driver/+bug/2162718` — Ubuntu bug with a real user report
- `Link: https://patch.msgid.link/20260924144512.3989-1-
  muhtaseem2005@gmail.com` — original submission
- `Signed-off-by: Muhtasham Nawr al-Mahmud <muhtaseem2005@gmail.com>` —
  author
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>` — ALSA maintainer
  applied it
- No `Fixes:` tag (expected: this is a missing hardware quirk, not a
  regression)
- No `Cc: stable@vger.kernel.org` (expected for this review queue)
- No `Reported-by:` / `Tested-by:` in the git message; the Launchpad
  thread supplies both in practice
- Ignore pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit ...]`

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** ASUS ExpertBook PM3406CHA (ALC256, SSID `1043:1664`) boots
  with internal speakers silent even though ALSA routes playback to the
  codec and the speaker pin is an output.
- **Symptom:** no audible speaker output; HDMI/Bluetooth still work
  (Launchpad).
- **Root cause:** vendor coefficient `0x10` comes up as `0x1d20`.
  Writing `0x7f20` restores output. Isolated with `hda-verb` from a
  larger init sequence; GPIO/EAPD/pin-control/other coeffs were not
  required. After the userspace write, audio still worked across
  suspend/resume.
- **Version info:** Launchpad reporter: Ubuntu 24.04.4, kernel
  `7.0.0-28-generic`; author also tested on `7.2.6-arch2-1`.
- **Caveat in the message:** author compile-tested the kernel patch but
  no longer had the laptop for a kernel boot-test.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. This is an explicit hardware-quirk bug
fix.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `sound/hda/codecs/realtek/alc269.c`  **+10 / -0**
- Functions/tables: `enum { ... }` (add `ALC256_FIXUP_ASUS_PM3406CHA`),
  `alc269_fixups[]`, `alc269_fixup_tbl[]`
- Scope: **single-file surgical hardware quirk**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
1. Enum: add a new fixup ID used as an index into `alc269_fixups[]`.
2. Fixup table: `HDA_FIXUP_VERBS` writing nid `0x20`
   `AC_VERB_SET_COEF_INDEX 0x10` then `AC_VERB_SET_PROC_COEF 0x7f20`.
3. Quirk table: `SND_PCI_QUIRK(0x1043, 0x1664, "ASUS ExpertBook
   PM3406CHA", ALC256_FIXUP_ASUS_PM3406CHA)`.

Before: `alc269_probe()` has no PCI-SSID match for `1043:1664`.
Launchpad shows a pin-match fallback (`"ALC256: picked fixup (pin
match)"` with empty name) that does not enable speakers.

After: PCI SSID match wins (`snd_hda_pick_fixup` runs first;
`snd_hda_pick_pin_fixup` returns immediately if `fixup_id` is already
set). Verbs are queued at `HDA_FIXUP_ACT_PROBE` via
`snd_hda_add_verbs()` and executed in `alc_init()` after Realtek init,
including resume.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **[Hardware workaround / codec quirk]**
Broken: ALC256 coef `0x10` left at `0x1d20` on this SKU, so the internal
amp/output path stays muted.
Fix: machine-specific init/resume verb write of `0x7f20`. Same pattern
as `ALC269_FIXUP_DELL_M101Z` (speaker enable via coef verbs).

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct for this class of fix: one SSID, two verbs,
existing `HDA_FIXUP_VERBS` machinery. Isolated to `1043:1664`. ALSA
maintainer accepted it. Low regression risk for other machines. Residual
risk is headphone routing on this one SKU if coef `0x10` is also a
HP/speaker switch on ALC256 (GX502/GU502 comments use `0x10` that way
with different values). That is unverified on this SKU; Takashi still
applied the patch, and the Launchpad reporter confirmed speakers work.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: There is no “introduced-by” regression. The bug is a **missing
quirk**. Surrounding table entries (`0x1043:0x1663` / `0x1683`,
`ALC269_FIXUP_DELL_M101Z`) already exist at `v6.18.57`. ALC256
(`0x10ec0256`) is a first-class ID in this file
(`HDA_CODEC_ID(0x10ec0256, "ALC256")`).

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Not applicable. This is new-hardware quirk
coverage, not a revert of a bad change.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Related: `0156c22fb0ca8` “Add support for ASUS Commercial laptops
  using CS35L41 HDA” adds **PM3406CKA** (`0x1043:0x1454`) with
  `ALC287_FIXUP_CS35L41_I2C_2`. That is a **different SKU** with Cirrus
  companion amps. Copying it to CHA would be wrong.
- Similar silent-speaker quirk already in this tree: `e561c2740b628`
  Higole F9B.
- Standalone 10-line patch, not `X/Y` of a series. No follow-up on this
  SSID after the candidate.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Only this commit by Muhtasham Nawr al-Mahmud under `sound/hda/`.
Not the subsystem maintainer. Applied by Takashi Iwai (`MAINTAINERS`:
sound maintainer).

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None. Uses `HDA_FIXUP_VERBS`, `SND_PCI_QUIRK`,
`alc269_fixups[]`, `alc269_fixup_tbl[]` — all present at `v6.18.57`. Can
apply standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 0eee030c2c09…` matched msgid
  `20260924144512.3989-1-muhtaseem2005@gmail.com`
- Series: **v1 RFC only** (no v2/v3)
- LKML: https://lkml.iu.edu/2609.3/01658.html (patch),
  https://lkml.iu.edu/2609.3/11978.html (reply)
- Takashi Iwai: “The code change looks OK, so I applied this now.” **No
  NAK, no requested changes.**
- lore.kernel.org fetches returned 403; discussion recovered via `b4
  dig`, Patchew, and LKML IU.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): Muhtasham Nawr al-Mahmud; Jaroslav Kysela; Takashi
Iwai; Kailang Yang (Realtek); `linux-sound@vger.kernel.org`; `linux-
kernel@vger.kernel.org`. Subsystem maintainer reviewed and applied.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record (Launchpad #2162718):
- Reporter: Nguyễn Trọng Tuyền, 2026-08-03, ASUS ExpertBook P3
  PM3406CHA, Ryzen 7 8840HS, ALC256, SSID `1043:1664`.
- Thought it was the same as PM3406CKA (#2133791, `1043:1454`); that SKU
  needed CS35L41, this one does not.
- Author isolated coef `0x10` on the hardware; reporter later: “It works
  perfectly on my laptop (Ubuntu 24.04.4, kernel 7.0.0-28). My speakers
  are finally working again!”
- Independent user confirmation of the userspace workaround. Kernel-
  patch `Tested-by` was offered but not in the commit.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone RFC. Not part of a multi-patch series. PM3406CKA
CS35L41 quirk is a different machine and must not be reused.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: No stable-list hit for PM3406CHA (lore.kernel.org/stable 403;
web search did not show a stable NAK or prior rejection). UNVERIFIED
that it was ever discussed on stable@; absence is not a negative.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: No function bodies changed. Data: `ALC256_FIXUP_ASUS_PM3406CHA`,
`alc269_fixups[]`, `alc269_fixup_tbl[]`. Consumers: `alc269_probe()` →
`snd_hda_pick_fixup()` → `snd_hda_apply_fixup()`; `alc_init()` →
`snd_hda_apply_verbs()`.

**Step 5.2: TRACE CALLERS**
Record:
- `alc269_probe()` calls `snd_hda_pick_fixup(..., alc269_fixup_tbl,
  alc269_fixups)` then `snd_hda_apply_fixup(..., HDA_FIXUP_ACT_PROBE)`.
- `alc_init()` (codec `.init`, including resume) calls
  `snd_hda_apply_verbs()` then `HDA_FIXUP_ACT_INIT`.
- `HDA_FIXUP_VERBS` are applied only at `HDA_FIXUP_ACT_PROBE` to
  **register** the list; documented to run at init and resume
  (`snd_hda_add_verbs` comment in `auto_parser.c`).
- Path: HD-audio codec probe on this laptop, then PCM playback. Not IRQ-
  hot.

**Step 5.3: TRACE CALLEES**
Record: `snd_hda_sequence_write()` of two vendor verbs on nid `0x20`
(Realtek vendor processing node). No alloc/lock/API change.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Unprivileged playback on this laptop triggers the silent path
today. After the quirk, probe/init writes the coef. Userspace-reachable
on the affected SKU.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same file already uses coef-`0x10` verbs
(`ALC269_FIXUP_ASUS_N7601ZM`, `ALC274_FIXUP_ASUS_ZEN_AIO_27`) and
speaker-enable verbs (`ALC269_FIXUP_DELL_M101Z`). This matches
established Realtek practice.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- `git describe HEAD` → `v6.18.57-155-gcdf239ca885b2`
- `make kernelversion` / Makefile → **6.18.57**
- `git merge-base --is-ancestor 97902f970e5cd v6.18.57` → **not an
  ancestor** (the quirk is **not** in the 6.18.57 baseline)
- At `v6.18.57`, `alc269_fixup_tbl` goes `0x1663` then `0x1683`; **no
  `0x1664` / PM3406CHA**
- File `sound/hda/codecs/realtek/alc269.c` exists (split in
  `aeeb85f26c3bb`, long before 6.18)
- ALC256 ID table present at v6.18.57
- Bug is the missing SSID quirk; it exists on this 6.18.y tree

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply expected.** Insertion points at v6.18.57:
- enum: `ALC269_FIXUP_DELL_M101Z` then `ALC269_FIXUP_SKU_IGNORE`
- `alc269_fixups[]`: same pair of entries
- quirk table: `0x1663` then `0x1683`
No struct/API mismatch.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No other `PM3406CHA` / `0x1043:0x1664` fix. PM3406CKA CS35L41
entry is a different SSID and amp topology.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **ALSA HD-audio Realtek codec** (`sound/hda/codecs/realtek/`).
**IMPORTANT** for laptop audio, not core mm/VFS. Quirk-table maintenance
is routine in stable.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: High churn of per-machine quirks (mute LEDs, SSIDs, silent
speakers). Mature driver, new rows for new laptops. That is the intended
stable pattern.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver-specific / SSID-specific.** Only ASUS ExpertBook
PM3406CHA (`PCI SSID 1043:1664`, ALC256). No effect on other machines.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Every boot / every speaker playback on that laptop. Not a race.
Unprivileged user playing audio. Reported on Ubuntu 24.04.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Internal speakers completely silent while the stack looks
healthy. Not a panic/UAF. **MEDIUM–HIGH functional** for owners of that
laptop (device unusable for built-in audio). HDMI/BT still work.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** High for that SKU (speakers work). Matches the stable
  hardware-quirk exception. User-confirmed.
- **Risk:** Very low: +10 lines, one SSID, existing verb mechanism,
  maintainer-acked. Possible headphone interaction on this SKU only
  (unverified).
- **Ratio:** Strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real user-visible bug: silent internal speakers
- Ubuntu Launchpad #2162718; original reporter confirmed the coef
  workaround
- Isolated, machine-specific `HDA_FIXUP_VERBS` + `SND_PCI_QUIRK`
- +10 lines, one file, no new API
- Driver, ALC256 support, and quirk tables already in 6.18.57
- Same pattern as existing speaker/coef quirks
- Takashi Iwai applied the RFC as-is
- Explicit stable exception: hardware quirk / SSID enablement for an
  existing driver

AGAINST:
- Not a crash, UAF, or security bug
- Author could not boot-test the kernel patch after losing the laptop
  (userspace path was tested; reporter confirmed it)
- Unverified headphone behavior if coef `0x10` is a HP/speaker mux on
  this SKU

UNRESOLVED:
- lore.kernel.org HTTP 403 (discussion recovered elsewhere)
- No stable@ thread found
- Headphone path on this SKU not documented

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — standard quirk; hda-verb
   isolation; Launchpad confirmation; maintainer applied
2. Fixes a real bug that affects users? **PASS** — silent speakers,
   filed and confirmed
3. Important issue? **PASS** for this class (hardware quirk / broken
   audio on a shipping laptop), not CRITICAL crash
4. Small and contained? **PASS** — 10 lines, one SSID
5. No new features or APIs? **PASS** — quirk only
6. Can apply to the local tree? **PASS** — 6.18.57 has the file and
   insertion context; SSID not already present

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Hardware quirk / existing-driver SSID enablement.** Automatic
YES category in the stable rules given in the prompt.

**Step 9.4: MAKE YOUR DECISION**

This belongs on 6.18.y. The ALC256 Realtek driver already enumerates
this laptop; without the SSID row, speakers stay silent. The change is a
two-verb init/resume write gated to `1043:1664`, the same style as other
Realtek speaker quirks already in this file. It applies cleanly to this
tree and does not need the unrelated PM3406CKA CS35L41 patch.

Verification:
- [Phase 1] Parsed tags: `Closes:` Launchpad 2162718; `Link:` patch
  msgid; SOB author + Takashi Iwai; no `Fixes:`/`Cc: stable`
- [Phase 1] Body: silent speakers; coef `0x10` `0x1d20`→`0x7f20`; hda-
  verb isolation
- [Phase 2] Diff: +10 in `alc269.c`; enum + `HDA_FIXUP_VERBS` +
  `SND_PCI_QUIRK(0x1043,0x1664)`
- [Phase 2] `auto_parser.c`: `HDA_FIXUP_VERBS` registered at PROBE, run
  from `alc_init()` after codec init and on resume
- [Phase 3] No `Fixes:` tag; missing-quirk, not a regression
- [Phase 3] Related `0156c22fb0ca8` is PM3406CKA CS35L41 (`0x1454`),
  different hardware
- [Phase 3] Author has only this hda commit; Takashi applied it
- [Phase 4] `b4 dig -c 0eee030c2c09…`: RFC v1 only; recipients include
  Iwai/Kysela/Realtek/linux-sound
- [Phase 4] Takashi: “The code change looks OK, so I applied this now.”
  No NAK
- [Phase 4] Launchpad: reporter confirmed speakers work with the coef
  write
- [Phase 4] lore.kernel.org direct fetch: 403; used b4/Patchew/LKML IU
  instead
- [Phase 5] Call chain: `alc269_probe` → `snd_hda_pick_fixup` → verbs →
  `alc_init`/`snd_hda_apply_verbs`
- [Phase 5] Pin-match cannot override once PCI SSID is set
  (`snd_hda_pick_pin_fixup` early return)
- [Phase 6] `git describe HEAD` = `v6.18.57-155-gcdf239ca885b2`;
  kernelversion 6.18.57
- [Phase 6] `git merge-base --is-ancestor 97902f970e5cd v6.18.57` failed
  → quirk **not** in 6.18.57 baseline
- [Phase 6] `git show v6.18.57:…alc269.c` has `0x1663` then `0x1683`, no
  `0x1664`; DELL_M101Z/SKU_IGNORE insertion points exist
- [Phase 6] ALC256 `0x10ec0256` present at v6.18.57
- [Phase 7] ALSA Realtek; Takashi Iwai in MAINTAINERS
- [Phase 8] Failure mode: silent speakers on one laptop SSID; severity
  MEDIUM–HIGH functional; risk very low
- UNVERIFIED: headphone interaction of coef `0x10` on this SKU; no
  stable@ discussion recovered

**YES**

 sound/hda/codecs/realtek/alc269.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index fa5bc54ff083d..a40b85fbaf393 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3678,6 +3678,7 @@ enum {
 	ALC269_FIXUP_SONY_VAIO,
 	ALC275_FIXUP_SONY_VAIO_GPIO2,
 	ALC269_FIXUP_DELL_M101Z,
+	ALC256_FIXUP_ASUS_PM3406CHA,
 	ALC269_FIXUP_SKU_IGNORE,
 	ALC269_FIXUP_ASUS_G73JW,
 	ALC269_FIXUP_ASUS_N7601ZM_PINS,
@@ -4089,6 +4090,14 @@ static const struct hda_fixup alc269_fixups[] = {
 			{}
 		}
 	},
+	[ALC256_FIXUP_ASUS_PM3406CHA] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x10 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x7f20 },
+			{}
+		}
+	},
 	[ALC269_FIXUP_SKU_IGNORE] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc_fixup_sku_ignore,
@@ -7184,6 +7193,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1652, "ASUS ROG Zephyrus Do 15 SE", ALC289_FIXUP_ASUS_ZEPHYRUS_DUAL_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1662, "ASUS GV301QH", ALC294_FIXUP_ASUS_DUAL_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1663, "ASUS GU603ZI/ZJ/ZQ/ZU/ZV", ALC285_FIXUP_ASUS_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1043, 0x1664, "ASUS ExpertBook PM3406CHA", ALC256_FIXUP_ASUS_PM3406CHA),
 	SND_PCI_QUIRK(0x1043, 0x1683, "ASUS UM3402YAR", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x16a3, "ASUS UX3402VA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x16b2, "ASUS GU603", ALC289_FIXUP_ASUS_GA401),
-- 
2.53.0

