Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465B13AF65A;
	Mon, 20 Apr 2026 13:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776692021; cv=none; b=aRrhf5JiJrk7+dBxVoH2P/Qj/Y0hQ035pOnA517oKQPgBIVMX+yQktspWOHI/yhFRUkqtXIRolfcgchtSRAtRT3KESG8GtYM3+VFQ5hFpZ8c/ByMXZXSQTElATRdoYl6vxFidBdvd0hrfzNvVI2S5VYIj2lr3xJhNW9hpaSjydA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776692021; c=relaxed/simple;
	bh=FPzntFDjCsVlk2qVhaZyDApNEGaYDXr8wadJNHS/q3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WW52E3XkuP8Vra9jRzOqmO9Z4VsEQY9LWnKe5GPzxG4ZgVK9zVCXfbwWsutL+Fl2Bk3Tk+AwjIkUN1fisgTeWWMXntgKQz65LF9UU3d1tGxd/LaFwiyJr3B5y9UE3MAVwVs7vp7cKNGe7Slm2U2cD8WhjjE3/eZWijeAjhDZmWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dDx+JbKE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dDx+JbKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40AAFC2BCB6;
	Mon, 20 Apr 2026 13:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776692021;
	bh=FPzntFDjCsVlk2qVhaZyDApNEGaYDXr8wadJNHS/q3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dDx+JbKE4lw++H2SONXrHvJO5vLIVUKCbaQzNkNMHqWyGacTuUMNYmdimazaIYYYk
	 MXz4Q0uiDAcCr5SQAyAtsP1Es1Qsjid0eO12+osdL22hcBy2k8tj1Z51YuZDwP5Kb/
	 h1+Ibj5l/5PvYXf+wFHsHhpRTUsywWQVjv6N133TDl6di7uA4a4uDJl7UMaBw4Mm47
	 J7wxHwehOsGuRYPmGBM6Fv8loL6+FmPbdlX1Vklwxy7WXfcJOrszDgEL4KajXjGfbw
	 lMQ80BVEOEQzJPa6iXf8OSHhehEpHAs8LAJTYGzDiUzRRljAlaDtfZmXLPAf5r0cXg
	 p0NALItvrqumA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rong Zhang <i@rong.moe>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] ALSA: usb-audio: Add quirk flags for Feaulle Rainbow
Date: Mon, 20 Apr 2026 09:22:01 -0400
Message-ID: <20260420132314.1023554-327-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rong Zhang <i@rong.moe>

[ Upstream commit 4f84e6caf38b05991b3b2afc0ddf4e48c2752d1d ]

Feaulle Rainbow is a wired USB-C dynamic in-ear monitor (IEM) featuring
active noise cancellation (ANC).

The supported sample rates are 48000Hz and 96000Hz at 16bit or 24bit,
but it does not support reading the current sample rate and results in
an error message printed to kmsg. Set QUIRK_FLAG_GET_SAMPLE_RATE to skip
the sample rate check.

Its playback mixer reports val = -15360/0/128. Setting -15360 (-60dB)
mutes the playback, so QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE is needed.

Add a quirk table entry matching VID/PID=0x0e0b/0xfa01 and applying
the mentioned quirk flags, so that it can work properly.

Quirky device sample:

  usb 7-1: New USB device found, idVendor=0e0b, idProduct=fa01, bcdDevice= 1.00
  usb 7-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
  usb 7-1: Product: Feaulle Rainbow
  usb 7-1: Manufacturer: Generic
  usb 7-1: SerialNumber: 20210726905926

Signed-off-by: Rong Zhang <i@rong.moe>
Link: https://patch.msgid.link/20260409-feaulle-rainbow-v1-1-09179e09000d@rong.moe
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed. Let me compile the complete
analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: `ALSA: usb-audio`
- **Action verb**: "Add" (quirk flags)
- **Summary**: Adds USB audio quirk table entry for the Feaulle Rainbow
  IEM device (VID 0x0e0b, PID 0xfa01)

### Step 1.2: Tags
- **Signed-off-by**: Rong Zhang `<i@rong.moe>` (author)
- **Signed-off-by**: Takashi Iwai `<tiwai@suse.de>` (ALSA subsystem
  maintainer - merged it)
- **Link**: `https://patch.msgid.link/20260409-feaulle-
  rainbow-v1-1-09179e09000d@rong.moe`
- No Fixes: tag (expected for quirk additions)
- No Reported-by: (author is the device user/tester)
- No Cc: stable (expected; that's why we're reviewing)

### Step 1.3: Commit Body Analysis
Two real issues described:
1. Device does not support reading current sample rate, producing error
   messages in kmsg. `QUIRK_FLAG_GET_SAMPLE_RATE` skips that unsupported
   operation.
2. Device's playback mixer reports val = -15360/0/128 where -15360
   (-60dB) mutes playback, but the driver treats it as minimum volume,
   not mute. `QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE` correctly treats the
   minimum as mute.

The commit includes USB enumeration output proving the device exists and
has been tested.

### Step 1.4: Hidden Bug Fix Detection
This is an explicit hardware quirk addition. It fixes incorrect device
behavior without needing the word "fix" — the device doesn't work
properly without these flags.

Record: This is a hardware workaround, a well-known exception category
for stable.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed**: 1 (`sound/usb/quirks.c`)
- **Lines added**: 2
- **Lines removed**: 0
- **Scope**: Single table entry addition; purely data, no logic changes

### Step 2.2: Code Flow Change
The diff adds a single `DEVICE_FLG()` entry to the `quirk_flags_table[]`
sorted array:

```c
DEVICE_FLG(0x0e0b, 0xfa01, /* Feaulle Rainbow */
           QUIRK_FLAG_GET_SAMPLE_RATE |
QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
```

Inserted in VID-sorted order between 0x0d8c and 0x0ecb entries.

### Step 2.3: Bug Mechanism
Category (h): **Hardware workarounds**. This is a device ID + quirk
flags addition to an existing quirk table. The flags are well-
established:
- `QUIRK_FLAG_GET_SAMPLE_RATE`: Causes `clock.c` to skip the unsupported
  get-sample-rate call
- `QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE`: Causes `mixer_quirks.c` to set
  `cval->min_mute = 1` for playback

### Step 2.4: Fix Quality
- Obviously correct: adds a table entry matching one VID/PID pair
- Minimal: 2 lines, data-only
- Zero regression risk: only affects this specific USB device
  (0x0e0b:0xfa01)
- Signed off by Takashi Iwai (ALSA maintainer)

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The `quirk_flags_table` was introduced in commit `4d4dee0aefec3`
(2021-07-29, v5.15). The table structure has been stable for years with
entries regularly added.

### Step 3.2: Fixes Tag
No Fixes: tag — expected for a quirk/device-ID addition. Not a
regression fix; it's new hardware enablement.

### Step 3.3: File History
Recent commits to `sound/usb/quirks.c` are dominated by similar quirk
additions (Scarlett, NeuralDSP, AB17X, SPACETOUCH, etc.). This is a
well-trodden pattern.

### Step 3.4: Author
Rong Zhang is the device owner/user. The patch was accepted and merged
by Takashi Iwai, the ALSA subsystem maintainer, which is strong
validation.

### Step 3.5: Dependencies
- `QUIRK_FLAG_GET_SAMPLE_RATE`: existed since v5.15
- `QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE`: renamed from
  `QUIRK_FLAG_MIXER_MIN_MUTE` in v6.18 (commit `ace1817ab49b3`). Stable
  trees <6.18 would need the old flag name, which is a trivial one-word
  substitution.
- No other dependencies.

---

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1-4.5
b4 dig could not match the commit (it's not yet in a commit the local
tree knows). Lore.kernel.org was behind anti-bot protection. The Link in
the commit message (`patch.msgid.link/20260409-feaulle-
rainbow-v1-1-09179e09000d@rong.moe`) confirms this is v1, patch 1/1 — a
standalone single-patch submission. It was merged quickly by Takashi
Iwai, indicating no review concerns.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.5
The `quirk_flags_table` is consulted via
`snd_usb_init_quirk_flags_table()` during USB audio device
initialization. The function iterates the table, matches by USB ID, and
sets `chip->quirk_flags`. These flags are then checked in:
- `sound/usb/clock.c` (line ~490): if `QUIRK_FLAG_GET_SAMPLE_RATE` is
  set, skip reading sample rate → prevents error messages
- `sound/usb/mixer_quirks.c` (line ~4649): if
  `QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE`, set `cval->min_mute = 1` → makes
  the minimum volume level act as mute

Both code paths are well-exercised by the ~139 existing `DEVICE_FLG`
entries in the table.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1
The `quirk_flags_table` exists in all active stable trees since v5.15.
Both quirk flags exist (though `MIXER_PLAYBACK_MIN_MUTE` was called
`MIXER_MIN_MUTE` before v6.18).

### Step 6.2: Backport Complications
- For 6.18+ and 7.0: clean apply
- For 6.6.y, 6.1.y, 5.15.y: trivial flag rename needed
  (`QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE` → `QUIRK_FLAG_MIXER_MIN_MUTE`)
- Surrounding table context may differ slightly (nearby entries may be
  absent), but this is a simple insertion.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1
- **Subsystem**: Sound / USB audio (`sound/usb/`)
- **Criticality**: IMPORTANT — USB audio is widely used (headsets, DACs,
  IEMs, webcams)

### Step 7.2
Very active subsystem — frequent quirk additions, well-maintained by
Takashi Iwai.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
Users who own the Feaulle Rainbow USB-C IEM (VID 0x0e0b, PID 0xfa01).

### Step 8.2: Trigger Conditions
Triggers every time the device is plugged in. Without the quirk:
- Error messages appear in kmsg (sample rate read failure)
- Minimum playback volume is not treated as mute, causing incorrect
  volume behavior

### Step 8.3: Failure Mode Severity
- Without quirk: error messages in kernel log + incorrect audio mixer
  behavior (LOW-MEDIUM severity)
- With quirk: device works properly

### Step 8.4: Risk-Benefit
- **Benefit**: Makes a real USB audio device work correctly for its
  users
- **Risk**: Essentially zero — 2-line data-only addition, scoped to a
  single VID/PID, uses existing well-tested quirk infrastructure

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary
**FOR backporting:**
- Classic USB audio hardware quirk — explicitly listed as an exception
  category (always YES)
- 2 lines, data-only change, zero logic changes
- Uses well-established quirk flags present in all active stable trees
- Merged by ALSA subsystem maintainer Takashi Iwai
- Fixes real device behavior (error messages + incorrect volume
  handling)
- Zero regression risk (only affects this specific device)
- Identical pattern to dozens of previously backported quirk additions

**AGAINST backporting:**
- None

### Step 9.2: Stable Rules Checklist
1. Obviously correct? **YES** — trivial table entry
2. Fixes a real bug? **YES** — device doesn't work properly without it
3. Important issue? **YES** — hardware enablement quirk
4. Small and contained? **YES** — 2 lines, 1 file
5. No new features or APIs? **YES** — no new features
6. Can apply to stable? **YES** — trivially, with minor flag rename for
   <6.18

### Step 9.3: Exception Category
**Hardware quirk/workaround** — this is the textbook example of a
stable-appropriate quirk addition.

---

## Verification

- [Phase 1] Parsed tags: Signed-off-by Rong Zhang (author) and Takashi
  Iwai (maintainer), Link to patch.msgid.link
- [Phase 2] Diff analysis: 2 lines added to `quirk_flags_table[]` in
  `sound/usb/quirks.c`, single DEVICE_FLG entry
- [Phase 2] Verified both flags exist: `QUIRK_FLAG_GET_SAMPLE_RATE`
  checked at `clock.c:490`, `QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE` checked
  at `mixer_quirks.c:4649`
- [Phase 3] git blame: quirk_flags_table introduced in commit
  4d4dee0aefec3 (2021-07-29, v5.15)
- [Phase 3] git tag: `QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE` (renamed)
  present from v6.18+; older trees use `QUIRK_FLAG_MIXER_MIN_MUTE`
- [Phase 3] git log: recent quirks.c history shows regular quirk
  additions (identical pattern)
- [Phase 3] Author Rong Zhang has no prior commits in sound/usb/ — they
  are the device owner
- [Phase 4] b4 dig failed (commit not in local tree). Lore blocked by
  anti-bot. Patch is v1, 1/1 (standalone, no series dependencies).
- [Phase 5] `DEVICE_FLG` count: 139 existing entries in the table —
  well-established pattern
- [Phase 6] quirk_flags_table exists since v5.15 — present in all active
  stable trees
- [Phase 8] Risk: zero — data-only, single-device-scoped, well-tested
  infrastructure
- UNVERIFIED: Could not access lore.kernel.org discussion thread due to
  anti-bot protection. This does not affect the decision since the
  commit is a straightforward quirk addition signed off by the
  maintainer.

**YES**

 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index d3a69995c1ad5..e95a228def2f0 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2281,6 +2281,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
 	DEVICE_FLG(0x0d8c, 0x0014, /* C-Media */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M | QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
+	DEVICE_FLG(0x0e0b, 0xfa01, /* Feaulle Rainbow */
+		   QUIRK_FLAG_GET_SAMPLE_RATE | QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
 	DEVICE_FLG(0x0ecb, 0x205c, /* JBL Quantum610 Wireless */
 		   QUIRK_FLAG_FIXED_RATE),
 	DEVICE_FLG(0x0ecb, 0x2069, /* JBL Quantum810 Wireless */
-- 
2.53.0

