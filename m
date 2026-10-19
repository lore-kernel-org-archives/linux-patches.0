Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9B0596E86;
	Mon, 19 Oct 2026 13:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418346; cv=none; b=HSbhRBiJmwy8c7ZLRIoBtgoIeoUvSu84rBJKZqI7cy71KBfEJNdkYzvgRMuTqXrxfIWe+reFaHB6SFvbGhZS8lbbv4I6qu0OW7BB76I0Y7ImEKtbcfgc33871qlPeVAd2G1FDhdPhov+3lQSv8EDRY+QzeHgf3o24cjBd1i3h/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418346; c=relaxed/simple;
	bh=C9NWfxuEA2cMfz50KywijBboyeDr+E31tD6u+5sY7ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rqXfD752E6UnUDF4vB/01+lf/puDFM4SlCZBaC7sfF6r3Sy2ZAYP6sNdxnkl1ewmGnXMMdLOh2dSKkiHRnslvARzS/M2mfYadgKnlqxmCrIUymqpgrd5qVIamrBe+YSqlm/aMHxdcZa7+1e+j+pBU2qfEJuDVam56RG6bTCT0eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z3JD3CE6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z3JD3CE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61E41F000C6;
	Mon, 19 Oct 2026 13:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418343;
	bh=5qXRc1pChq8c2rbghpVxms4satxts1jPmhPnSOFpmWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z3JD3CE6aVNOAAfQPOLqmsg9xQqp83YAH9SvXt12CwjbW2gQEDvv+zHFHqjlBDIxS
	 Zm3RMrk4oh7ICigwQbKpO70d6lpGEAHg83iyxOZCcuNbSiUce5af3C7V5FiClUXlMo
	 2q6bwV9KGDTWu4fa3PwqJdtYrzpzPCABMSE0Yi2UuPddyHh30UWXWGvVfpMRZC7O3R
	 vaAeeNmCdH0lNK4ruyDuc/rifUNIzBY7VWgZ9brka7Ts9lMxLlCaJS07C5BKka/+Hn
	 SW212Io5luwcfvVZitcf6Uz1/f3j7eibXm4QqGxtbX9EJeEp5XEghRNQrA9ryvzQkT
	 2D/JRXmZOG36g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Matus Gajdos <matuszpd@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] ALSA: usb-audio: Add native DSD support for Cambridge Audio streamers
Date: Mon, 19 Oct 2026 09:47:51 -0400
Message-ID: <20261019135441.1420968-180-sashal@kernel.org>
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

From: Matus Gajdos <matuszpd@gmail.com>

[ Upstream commit 4e1462e7cd6a9b920f441842726cc2b9d232673e ]

The Cambridge Audio streamer advertises the UAC2 RAW_DATA format on
altsetting 2 of its playback interface, but without the DSD_RAW quirk
flag the driver exposes it only as a SPECIAL format that cannot be
used.

Add QUIRK_FLAG_DSD_RAW for the device (USB ID 22e8:ca10), so the
altsetting is exposed as DSD_U32_BE, enabling native DSD64/128/256
playback.

Tested with: gst-launch-1.0 filesrc location=file.dsf ! \
                            avdemux_dsf ! dsdconvert ! \
                            alsasink device=hw:2,0

Signed-off-by: Matus Gajdos <matuszpd@gmail.com>
Link: https://patch.msgid.link/20261002125237.82188-1-matuszpd@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a two-line USB quirk that enables native DSD on an existing
device. The local tree is **6.18.57** (`v6.18.57-155-gcdf239ca885b2`).
The DSD_RAW machinery is already here; only the Cambridge Audio ID is
missing.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: `[ALSA/usb-audio] [add] Add native DSD support for Cambridge
Audio streamers`

Subsystem is ALSA USB-audio. The verb is “Add”, but the body is a
device-specific quirk, not a new driver or API.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- `Signed-off-by: Matus Gajdos <matuszpd@gmail.com>` (author)
- `Link:
  https://patch.msgid.link/20261002125237.82188-1-matuszpd@gmail.com`
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>` (ALSA maintainer)
- No `Fixes:` tag (expected)
- No `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-by:`, or `Cc:
  stable`
- Ignored: `[Upstream commit ...]` and `Signed-off-by: Sasha Levin`
  (pipeline)

Notable: maintainer SOB; author included a concrete `gst-launch` test
command in the body.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- Bug: device `22e8:ca10` advertises UAC2 `RAW_DATA` on playback
  altsetting 2, but without `QUIRK_FLAG_DSD_RAW` the driver exposes that
  altsetting only as `SPECIAL`, which userspace cannot use.
- Symptom: native DSD64/128/256 playback is unavailable on Cambridge
  Audio streamers.
- Root cause: UAC has no dedicated DSD bit; the driver only remaps
  `RAW_DATA` to `DSD_U32_BE` when `QUIRK_FLAG_DSD_RAW` is set and
  `fp->dsd_raw` is true.
- Version info: none in the message.
- Tested with an explicit GStreamer DSD playback pipeline.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not a disguised cleanup. It is a hardware quirk / device-ID
addition so advertised DSD actually works. That is the standard ALSA
usb-audio DSD_RAW pattern.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `sound/usb/quirks.c` (+2 / -0)
- Function/data: `quirk_flags_table[]` only
- Scope: single-file, two-line table insertion

```2376:2383:sound/usb/quirks.c
        DEVICE_FLG(0x21b4, 0x0230, /* Ayre QB-9 Twenty */
                   QUIRK_FLAG_DSD_RAW),
        DEVICE_FLG(0x21b4, 0x0232, /* Ayre QX-5 Twenty */
                   QUIRK_FLAG_DSD_RAW),
        DEVICE_FLG(0x22e8, 0xca10, /* Cambridge Audio streamers */
                   QUIRK_FLAG_DSD_RAW),
        DEVICE_FLG(0x2522, 0x0007, /* LH Labs Geek Out HD Audio 1V5 */
                   QUIRK_FLAG_SET_IFACE_FIRST),
```

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- Before: `22e8:ca10` has no table entry. Probe does not set
  `QUIRK_FLAG_DSD_RAW`. UAC2 `RAW_DATA` stays
  `SNDRV_PCM_FMTBIT_SPECIAL`.
- After: exact VID:PID match ORs `QUIRK_FLAG_DSD_RAW`.
  `snd_usb_interface_dsd_format_quirks()` then returns
  `SNDRV_PCM_FMTBIT_DSD_U32_BE` when `fp->dsd_raw` is set.
- Path: device probe / format parse (init), not an error path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: `[Hardware workaround / USB quirk ID]`
Mechanism: UAC2 `RAW_DATA` is only treated as native DSD when the
existing `QUIRK_FLAG_DSD_RAW` flag is set. This device advertises that
format but was missing from the allow-list.

Verified in this tree:
- `format.c` sets `fp->dsd_raw = true` and `SNDRV_PCM_FMTBIT_SPECIAL`
  for `UAC2_FORMAT_TYPE_I_RAW_DATA`
- `quirks.c:2078-2079` remaps only if `(chip->quirk_flags &
  QUIRK_FLAG_DSD_RAW) && fp->dsd_raw`

**Step 2.4: ASSESS THE FIX QUALITY**

Record: Obviously correct and minimal. Same `DEVICE_FLG(...,
QUIRK_FLAG_DSD_RAW)` pattern already used for Ayre, ddHiFi, XMOS,
McIntosh, HEM, etc. No API, lock, or struct change. Regression risk is
confined to `22e8:ca10`; other devices are untouched. Matching is exact
VID:PID (`snd_usb_init_quirk_flags_table()` returns on first match;
there is no `VENDOR_FLG(0x22e8)`).

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- New lines are this commit. Surrounding DSD_RAW entries date to
  `f7fea075edfa08` (Jussi Laako, 2023) and `c84bd6c810d188` (2024).
- The DSD_RAW mechanism itself is `68e851ee4cfd2` (“Move generic DSD raw
  detection into quirk_flags”), 2021-07-29, first appeared in
  **v5.15-rc1**. `git merge-base --is-ancestor 68e851ee4cfd2 HEAD` →
  yes.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. Not applicable. The “bug” is a missing device
allow-list entry, not a regression from a specific commit.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record: Recent `sound/usb/quirks.c` history is full of the same class of
patches (JBL FIXED_RATE, Audient IGNORE_CTL_ERROR,
LEAK/PureAudio/Comtrue DSD_RAW, etc.). This commit is standalone, not
`patch X/Y`.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: `git log --author="Matus Gajdos" -- sound/usb/` shows only this
commit. Author is a hardware user, not the subsystem maintainer.
Maintainer Takashi Iwai applied it the next day.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: No prerequisites. Parent of this tree already has `DEVICE_FLG`,
`QUIRK_FLAG_DSD_RAW`, `fp->dsd_raw`, and the Ayre / LH Labs insertion
context. Applies standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c 8a762801bd078` →
  https://patch.msgid.link/20261002125237.82188-1-matuszpd@gmail.com
- `b4 dig -a`: **v1 only**, 2026-10-02, Matus Gajdos. No v2/v3.
- Thread (mbox, 2 messages): submission + Takashi Iwai “Applied now.
  Thanks.”
- No NAK, no requested changes, no reviewer `Cc: stable`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): To/Cc were Jaroslav Kysela, Takashi Iwai, linux-
sound, linux-kernel. Correct ALSA maintainers. Iwai applied it.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No external bugzilla/syzbot report. The author is the reporter
and tester. USB ID `22e8:ca10` is Cambridge Audio (vendor `22e8` is CA;
Windows INF lists `VID_22E8&PID_CA10` as Cambridge Audio USB Audio).

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Standalone single patch. Not part of a series.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: No stable-list discussion found for this ID/subject. lore HTML
fetches returned 403; search did not turn up a prior rejection. Similar
DSD_RAW ID additions **have** been sent to stable historically (`Cc:
stable` on McIntosh `99248c8902f50`, HEM `122e2cb7e1a30`, LEAK
`c83fc13960643`).

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: No function body changed. Data: `quirk_flags_table[]`.
Consumers: `snd_usb_init_quirk_flags_table()`,
`snd_usb_interface_dsd_format_quirks()`.

**Step 5.2: TRACE CALLERS**

Record:
- `snd_usb_init_quirk_flags()` in `sound/usb/card.c:728` →
  `snd_usb_init_quirk_flags_table()` during USB-audio probe
- `parse_audio_format_i()` in `sound/usb/format.c:157` →
  `snd_usb_interface_dsd_format_quirks()`

Probe/format-parse path, not IRQ/hot path.

**Step 5.3: TRACE CALLEES**

Record: Table walk + `chip->quirk_flags |= p->flags`. Later, DSD remap
returns a format bit. No alloc, no lock in the new code (lock already
exists around flag init in `card.c`).

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: USB plug-in → `snd_usb_audio` probe → quirk flags → format parse
→ PCM device with `DSD_U32_BE` on altsetting 2 → userspace (`alsasink`,
etc.). Reachable whenever this streamer is connected. Unprivileged
playback once the device node is accessible.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Dozens of identical `QUIRK_FLAG_DSD_RAW` table entries in the
same file. This is the standard allow-list, not a one-off.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: Yes. This is 6.18.57. `QUIRK_FLAG_DSD_RAW` and `fp->dsd_raw`
have been here since v5.15. Parent of the candidate has **no** `0x22e8`
entry. Without this patch, Cambridge Audio `22e8:ca10` still exposes
`SPECIAL` instead of DSD. The device is not new-to-6.19 infrastructure;
only the ID is new.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: Clean apply. Parent context is exactly Ayre QX-5 Twenty then LH
Labs Geek Out. No refactor of the table in 6.18.y.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No other Cambridge Audio / `0x22e8` quirk. No alternate DSD fix
for this ID. `git grep 0x22e8 -- sound/usb` only hits this new line.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: `[sound/usb (ALSA USB-audio)] [IMPORTANT]` — common driver, but
this change is device-specific.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Actively maintained. Frequent small quirk-table updates from
Takashi Iwai and hardware vendors. Mature pattern, low churn in the
matching logic itself.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: Driver-specific / device-specific. Only USB `22e8:ca10`
(Cambridge Audio streamers). PCM users of that device are unchanged; DSD
users gain a working format.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: Trigger is plugging in that streamer and opening the
RAW_DATA/DSD altsetting. Common for owners of that hardware; impossible
for everyone else. Not a race.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: `[Missing hardware capability / unusable advertised format]
[MEDIUM as a bug; YES as a quirk exception]`
Not a panic, UAF, or corruption. Without the quirk, advertised DSD is
unusable (`SPECIAL`). With it, native DSD works. That is the same class
as USB/codec/SFP quirks the stable rules call out.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- Benefit: high for owners of these streamers (DSD actually works); zero
  effect elsewhere.
- Risk: very low (2 lines, exact VID:PID, existing flag, maintainer-
  applied, hardware-tested).
- Ratio: strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Hardware quirk / USB ID addition — explicit stable exception
- 2-line, obviously correct, no API change
- Infrastructure present in this 6.18.y tree since v5.15
- Applies cleanly
- Author tested real DSD64/128/256 playback
- Applied by ALSA maintainer Takashi Iwai; no objections
- Same pattern already used (and historically Cc:stable) for other DACs
- Only `22e8:ca10` is affected

AGAINST:
- Not a crash, security hole, or data-corruption fix
- Enables a capability rather than stopping an oops
- Author is not a regular subsystem contributor (mitigated by maintainer
  apply)

UNRESOLVED:
- Could not fetch lore HTML (403); full thread recovered via `b4 dig -m`
- No independent second-user report beyond the author
- usb-ids listing for `22e8` confirms Cambridge Audio; `ca10` is in
  Windows CA USB-audio INF, not in every public usb-ids dump

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — 2-line allow-list; author
   `gst-launch` test; maintainer applied
2. Fixes a real bug that affects users? **PASS** — advertised DSD
   altsetting is unusable without the flag
3. Important issue? **PASS via quirk exception** — not a crash; hardware
   enablement for existing devices
4. Small and contained? **PASS** — +2 lines, one table
5. No new features or APIs? **PASS** — no new syscall/API/driver;
   existing `QUIRK_FLAG_DSD_RAW` only
6. Can apply to the local tree? **PASS** — clean context in 6.18.57

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: **Hardware quirk / USB device-ID addition to an existing
driver.** Automatic YES category.

**Step 9.4: MAKE YOUR DECISION**

This belongs on 6.18.y. The tree already has the DSD_RAW path; the
commit only names one USB ID so that device’s advertised RAW_DATA
altsetting becomes usable DSD. That is the same class of stable material
as other ALSA usb-audio DSD and USB quirks.

Verification:
- [Phase 1] Parsed tags: author SOB, Link to msgid, Takashi Iwai SOB; no
  Fixes/Reported-by/Cc:stable
- [Phase 1] Body: UAC2 RAW_DATA on altsetting 2 exposed as SPECIAL
  without DSD_RAW; tested gst-launch DSD pipeline
- [Phase 2] Diff: +2 lines in `quirk_flags_table[]` only —
  `DEVICE_FLG(0x22e8, 0xca10, QUIRK_FLAG_DSD_RAW)`
- [Phase 2] `format.c:59-62` sets `fp->dsd_raw` on UAC2 RAW_DATA;
  `quirks.c:2078-2079` remaps only with the flag
- [Phase 2] `snd_usb_init_quirk_flags_table()` exact VID:PID match; no
  `VENDOR_FLG(0x22e8)`
- [Phase 3] `68e851ee4cfd2` introduced DSD_RAW in v5.15-rc1; ancestor of
  this HEAD
- [Phase 3] Author has no other `sound/usb` commits; not a series
- [Phase 3] Parent of candidate has Ayre then LH Labs context and no
  `0x22e8`
- [Phase 4] `b4 dig -c 8a762801bd078`: lore msgid
  `20261002125237.82188-1-matuszpd@gmail.com`
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: Iwai, Kysela, linux-sound
- [Phase 4] mbox: Iwai “Applied now. Thanks.” No NAK, no stable
  nomination
- [Phase 4] WebFetch lore HTML: 403; discussion recovered from mbox
- [Phase 4] Similar historical DSD_RAW quirks carried `Cc: stable`
  (McIntosh, HEM, LEAK)
- [Phase 5] Callers: `card.c:728` probe; `format.c:157` format parse
- [Phase 6] `git describe HEAD` = v6.18.57-155-gcdf239ca885b2; `make
  kernelversion` = 6.18.57
- [Phase 6] `git merge-base --is-ancestor v6.18 HEAD` yes; candidate not
  in v6.18 release
- [Phase 6] Clean apply in this tree
- [Phase 7] ALSA USB-audio, actively quirk-maintained
- [Phase 8] Failure mode: unusable DSD format on one USB ID; severity
  medium, quirk-exception YES
- UNVERIFIED: live lore.kernel.org/stable thread contents (HTTP 403 /
  unhelpful search)

**YES**

 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 8dcba375bd4a3..be80d9d14e0ad 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2379,6 +2379,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_DSD_RAW),
 	DEVICE_FLG(0x21b4, 0x0232, /* Ayre QX-5 Twenty */
 		   QUIRK_FLAG_DSD_RAW),
+	DEVICE_FLG(0x22e8, 0xca10, /* Cambridge Audio streamers */
+		   QUIRK_FLAG_DSD_RAW),
 	DEVICE_FLG(0x2522, 0x0007, /* LH Labs Geek Out HD Audio 1V5 */
 		   QUIRK_FLAG_SET_IFACE_FIRST),
 	DEVICE_FLG(0x262a, 0x9302, /* ddHiFi TC44C */
-- 
2.53.0

