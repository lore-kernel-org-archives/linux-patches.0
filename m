Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D9754FEB5;
	Mon, 19 Oct 2026 13:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418221; cv=none; b=PvKT4t2x2N7RWZTCX0aLi32aQPZafuM9Om+CmMKeB/lb6/CoQl97EXYiP2LaWhGHf3ox6k7ztEeoAyVdlmCjKdCW/sAIQ459+xaTVsOg9Xq04+NhVYV6eaUs1Tfp8V+LiJ4WQheVl6z0fsD0hxYKQFnN3ZKA8R/d8oGAbkVK+eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418221; c=relaxed/simple;
	bh=n9wHKD2O9IpNjCp2rrC4hUtFJkVuW27YbDBf7dw322s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iZHNvb/yrlm4YphT0fAydjqotWJO5pDT6dn1YQzRKZbkbEcmVZaIMDtvYHMCG/BcxyRVmsWpM8STd80e6kuQr5D5gi5hyxNEg2xMw3oNSFO60QNHMnZtlgA+x1D30whV2oLHSaAfTYO4AfrBzH/NWL837PVewootkZKP+A1+jhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bXfBdrsr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bXfBdrsr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3706B1F000C4;
	Mon, 19 Oct 2026 13:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418218;
	bh=aIN5BhUeoH5hONmFrj7uiLaPc6hxPRvbFMgdVeU9bDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bXfBdrsrRGgWDFqvbAMpfruuTrpZtIN/aI/EDW0POm+A+HaJLtp7BfTcVcGudtlVg
	 RoOxqJI2Nihylg2E9kBhJ5rDLBiRR1jhj/SYc6pd8hItlwUiUia9F6QL0Ol6qX+V0Z
	 dVp9ucunW8iEyfIra6iCzA0O1taz2CFd9aVwUxQyxIt4kqwVRxJtTOXEUwNc0l2FU7
	 HxMQCAIqIc2fayo+w+v3kM91eKm20hJe4bESTEzVgeaZiSQG5OZcQN8KK0BIUkOhGv
	 O0CP4aQYFsskF0Pb8lAMwv77SeD8xv3fnQGIlPwEg9PLgi+bm6e473wfGFs/B5X1eB
	 aq2ywfIyKsz8A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bob Song <songxiebing@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] ALSA: hda/realtek: add missing error checks for COEF index reads in alc269
Date: Mon, 19 Oct 2026 09:46:27 -0400
Message-ID: <20261019135441.1420968-96-sashal@kernel.org>
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

From: Bob Song <songxiebing@kylinos.cn>

[ Upstream commit 5b106b40ed22098f2bc049efb645148d038444bd ]

alc_read_coef_idx() and alc_read_coefex_idx() can return -1 on error
via snd_hda_codec_read(). Several codec initialization and shutdown
functions save these return values and later write them back to
hardware registers without checking for errors, potentially corrupting
COEF register state on a read failure.

Add error checks in:
- alc282_init() and alc282_shutup(): check coef78 before write-back
- alc285_hp_init(): check coef38/coef0d/coef36 before update, check
  val before write-back, and break polling loop on error
- alc294_hp_init(): break polling loop on read error

Signed-off-by: Bob Song <songxiebing@kylinos.cn>
Link: https://patch.msgid.link/20260730015302.253008-1-songxiebing@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This tree is **6.1.188**. The unguarded COEF save/restore paths are
present in `sound/pci/hda/patch_realtek.c`, and the same class of bug
already went to stable in 2014 because writing a failed COEF read can
stall the codec.

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
Record: `[ALSA/hda/realtek] [add] missing error checks for COEF index
reads in alc269`

**Step 1.2 — Tags**
Record:
- `Signed-off-by: Bob Song <songxiebing@kylinos.cn>` (author)
- `Link: https://patch.msgid.link/20260730015302.253008-1-
  songxiebing@kylinos.cn`
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>` (ALSA maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable` (absence expected)
- Ignore any pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit
  ...]` if present

**Step 1.3 — Body**
Record:
- Bug: `alc_read_coef_idx()` / `alc_read_coefex_idx()` can return `-1`
  via `snd_hda_codec_read()`. Init/shutdown save that value and write it
  back.
- Symptom: COEF register corruption on read failure (wrong headphone-amp
  / depop state; historically this class of write can stall the codec).
- Root cause: missing `!= -1` checks on save/restore and on depop
  polling.
- No version bounds in the message.

**Step 1.4 — Hidden bug fix?**
Record: Yes. “Add missing error checks” is a real error-path fix, not
style. Same pattern as `alc_update_coefex_idx()` and
`alc269_fill_coef()` in this tree.

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
Record:
- File in the candidate: `sound/hda/codecs/realtek/alc269.c` (`+14/-8`)
- Functions: `alc282_init`, `alc282_shutup`, `alc285_hp_init`,
  `alc294_hp_init`
- Scope: single-file surgical fix

**Step 2.2 — Flow change**
Record:
- `alc282_init` / `alc282_shutup`: save coef 0x78, temporarily write
  `0x9004`, then restore. After: restore only if `coef78 != -1`.
- `alc285_hp_init`: depop poll `val & 0x8000` for up to 20×50ms, then
  write `val` and restore coef 0x38/0x0d/0x36. After: stop poll on `-1`;
  skip those writes if the saved/read value is `-1`.
- `alc294_hp_init`: same poll pattern on bit `0x0080`; after: break on
  `-1`. No val write-back here.

**Step 2.3 — Bug mechanism**
Record: Logic / hardware-state corruption on error.
- `codec_read()` in this tree returns `-1` when `snd_hdac_exec_verb()`
  fails (`sound/hda/hdac_device.c`).
- COEF payload is 16-bit, so `-1` becomes `0xFFFF` on write.
- `alc_update_coef_idx(..., mask, coefXX)` with `coefXX == -1` does
  `(current & ~mask) | 0xFFFFFFFF` and sets every bit.
- `val & 0x8000` is true for `-1`, so the depop loop always runs the
  full ~1s then writes `0xFFFF`.

**Step 2.4 — Fix quality**
Record: Obviously correct and matches existing `if (val != -1)` guards.
Success path unchanged. Regression risk is low: skipping a restore when
there is no valid saved value is safer than writing `0xFFFF`.

## Phase 3: Git history

**Step 3.1 — Blame / introduction**
Record:
- ALC282 save/restore: `7b5c7a0240b11` (2014) “Fix the noise after
  suspend and resume on ALC282 codec” — ancestor of this HEAD.
- ALC285 HP init: `3c24e48330adf` (2021) — ancestor of this HEAD.
- 2014 COEF-guard: `f3ee07d8b6e06` “Avoid setting wrong COEF on ALC269 &
  co” — ancestor of this HEAD; `Cc: stable`; documented that writing
  after a `-1` read can stall the codec and broke resume on Acer AO725.

**Step 3.2 — Fixes: tag**
Record: None. The incomplete coverage of `f3ee07d8b6e06` is the
historical analogue.

**Step 3.3 — Related file history**
Record: Recent `patch_realtek.c` commits are quirks, not this fix. `git
log --grep="missing error checks"` / `"COEF index reads"` on this file:
no hit. Candidate `5b106b40ed220` is **not** an ancestor of HEAD.

**Step 3.4 — Author**
Record: Bob Song (Kylinos), not the ALSA maintainer. Takashi Iwai
applied it after a v1→v2 split.

**Step 3.5 — Dependencies**
Record: Standalone. Needs only `alc_read_coef*_idx()` returning `-1`,
which this tree already has. No new helpers.

## Phase 4: Mailing list

**Step 4.1 — Original discussion**
Record: `b4 dig -c 5b106b40ed220` →
https://patch.msgid.link/20260730015302.253008-1-songxiebing@kylinos.cn
- v1 combined this with a `codec->bus->pci` NULL check.
- Takashi: “Could you split the NULL check to another patch? Basically
  it's a completely different sort of fix from others.”
- v2: this COEF patch only. Takashi: “Applied to for-next branch.
  Thanks.”
- No NAK, no stable nomination, no reviewer concern about the COEF
  checks.

**Step 4.2 — Recipients (`b4 dig -w`)**
Record: `tiwai@suse.com`, `perex@perex.cz`, `linux-sound@`, `linux-
kernel@`. Maintainer was To: and applied it.

**Step 4.3 — Bug report**
Record: No syzbot/bugzilla for *these* sites. The stall/resume failure
for the same `-1` write pattern is documented in `f3ee07d8b6e06` /
bugzilla 52181.

**Step 4.4 — Series**
Record: v2 series patch 1/2 is this fix; patch 2/2 is the PCI NULL check
(separate). This patch is self-contained.

**Step 4.5 — Stable list**
Record: lore.kernel.org WebFetch returned 403 (Anubis). UNVERIFIED
whether stable@ already discussed this specific commit. Full linux-sound
thread was recovered via `b4 dig -m`.

## Phase 5: Code semantics (this tree)

**Step 5.1 — Functions**
Record: `alc282_init`, `alc282_shutup`, `alc285_hp_init`,
`alc294_hp_init` in `sound/pci/hda/patch_realtek.c`.

**Step 5.2 — Callers (verified)**
Record:
- `alc282_init` / `alc282_shutup`: codec `0x10ec0282` (`spec->init_hook`
  / `spec->shutup`).
- `alc285_hp_init`: from `alc225_init` on boot and S3/S4 resume (skipped
  only for ALC287/ALC245).
- `alc225_init`: ALC215/245/285/289, ALC225/295/299, ALC287.
- `alc294_hp_init`: from `alc294_init` on boot / S4 restore;
  ALC234/274/294 and ALC700.
- `alc_init()` runs `spec->init_hook`; `.init = alc_init`.
- `alc_suspend()` → `alc_shutup()` → `spec->shutup`; `alc_resume()` →
  `patch_ops.init`.

**Step 5.3 — Callees**
Record: `alc_read_coef*_idx`, `alc_write_coef*_idx`,
`alc_update_coef*_idx`, `snd_hda_codec_write`, `msleep`.

**Step 5.4 — Reachability**
Record: Yes. Probe, suspend, and resume on common Realtek laptop codecs.
Not an obscure config path.

**Step 5.5 — Similar patterns**
Record: Already guarded in this file:
- `__alc_update_coefex_idx()`: `if (val != -1)`
- `alc269_fill_coef()`: `if (val != -1 && ...)` before write
These four functions were the remaining save/restore holes.

## Phase 6: This checkout (6.1.188)

**Step 6.1 — Does the buggy code exist?**
Record: Yes. Unguarded write-backs:

```3429:3431:sound/pci/hda/patch_realtek.c
        /* Headphone capless set to normal mode */
        alc_write_coef_idx(codec, 0x78, coef78);
}
```

```3465:3468:sound/pci/hda/patch_realtek.c
        alc_auto_setup_eapd(codec, false);
        alc_shutup_pins(codec);
        alc_write_coef_idx(codec, 0x78, coef78);
}
```

```3718:3727:sound/pci/hda/patch_realtek.c
        val = alc_read_coefex_idx(codec, 0x58, 0x00);
        for (i = 0; i < 20 && val & 0x8000; i++) {
                msleep(50);
                val = alc_read_coefex_idx(codec, 0x58, 0x00);
        } /* Wait for depop procedure finish  */

        alc_write_coefex_idx(codec, 0x58, 0x00, val); /* write back the
result */
        alc_update_coef_idx(codec, 0x38, 1<<4, coef38);
```

Same unguarded poll in `alc294_hp_init`. Introduced 2014/2021; both are
in this tree.

**Step 6.2 — Backport difficulty**
Record: Minor path rework. Candidate path
`sound/hda/codecs/realtek/alc269.c` does not exist here; equivalent code
is `sound/pci/hda/patch_realtek.c`. Function bodies match the pre-patch
logic. Not a semantic conflict.

**Step 6.3 — Already fixed here?**
Record: No. `git merge-base --is-ancestor 5b106b40ed220 HEAD` failed. No
later substitute fix in this file.

## Phase 7: Subsystem

**Step 7.1**
Record: ALSA HD-audio Realtek codec. **IMPORTANT** (default audio on a
huge set of laptops).

**Step 7.2**
Record: Mature driver; current 6.1.y activity is mostly quirks. These
init/shutup paths have been stable for years, which is why leftover `-1`
write-backs still matter.

## Phase 8: Impact and risk

**Step 8.1 — Who**
Record: Users of ALC282, ALC215/225/285/289, ALC225/295/299,
ALC234/274/294, ALC700 — typical `CONFIG_SND_HDA_CODEC_REALTEK` x86
laptops.

**Step 8.2 — Trigger**
Record: Codec COEF read returns `-1` (verb timeout, invalid COEF on a
variant, flaky link during suspend/resume). Not an unprivileged syscall
exploit; it is a common device PM path.

**Step 8.3 — Failure mode**
Record: Wrong COEF restore / depop result. Severity **HIGH** for audio:
headphone noise, failed depop, or codec stall (the failure
`f3ee07d8b6e06` already shipped to stable). Not a kernel oops by itself.

**Step 8.4 — Ratio**
Record: Benefit medium-high (PM path on common hardware, same class as a
prior stable fix). Risk very low (~14 lines of `!= -1` guards, success
path identical).

## Phase 9: Synthesis

**Evidence FOR**
- Real write of error sentinel `-1`/`0xFFFF` into codec COEF state.
- `alc_update_coef_idx(..., saved)` with `saved == -1` sets all bits on
  a register that may still be readable.
- Depop poll treats `-1` as “still busy” for a full second.
- Same class as `f3ee07d8b6e06` (codec stall / resume failure, `Cc:
  stable`).
- Small, obviously correct, maintainer-applied.
- Buggy functions exist in this 6.1.188 tree and are not fixed.

**Evidence AGAINST**
- No user report for these four sites.
- Exact patch needs a file-path backport (`alc269.c` →
  `patch_realtek.c`).
- Static-analysis style; trigger is an already-failing verb.

**Unresolved**
- lore.kernel.org HTTP 403 for stable@ search (thread itself was
  retrieved with b4).

**Stable rules**
1. Obviously correct and tested? **PASS** (maintainer applied v2;
   success path unchanged)
2. Real user-visible bug? **PASS** (bad COEF restore on
   init/suspend/resume)
3. Important (stall / broken audio / register corruption)? **PASS**
   (same class as the 2014 stable COEF-stall fix)
4. Small and contained? **PASS** (`+14/-8`, four local checks)
5. No new features/APIs? **PASS**
6. Can apply here? **PASS** with a trivial path backport to
   `patch_realtek.c`

**Exception category:** none (not an ID/quirk/DT/build/docs exception).
It is a normal small bugfix.

This should go into this 6.1.188 tree. The bug is in the local
`alc282_*` / `alc285_hp_init` / `alc294_hp_init` paths; the fix is a few
`!= -1` guards that this tree already uses elsewhere.

Verification:
- [Phase 1] Parsed tags: author Bob Song; Link msgid; SOB Takashi Iwai;
  no Fixes/Reported-by/Cc stable
- [Phase 2] Diff: 14 insertions / 8 deletions; four functions; skip
  write-back and stop poll on `-1`
- [Phase 2] `codec_read()` in this tree returns `-1` on
  `snd_hdac_exec_verb()` failure (`sound/hda/hdac_device.c:988-997`)
- [Phase 3] `git merge-base --is-ancestor 7b5c7a0240b11 HEAD` — yes
  (ALC282 write-back, 2014)
- [Phase 3] `git merge-base --is-ancestor 3c24e48330adf HEAD` — yes
  (alc285_hp_init, 2021)
- [Phase 3] `git merge-base --is-ancestor f3ee07d8b6e06 HEAD` — yes
  (2014 COEF-guard, Cc:stable, codec stall)
- [Phase 3] `git merge-base --is-ancestor 5b106b40ed220 HEAD` — no (fix
  not in this tree)
- [Phase 4] `b4 dig -c 5b106b40ed220`: v1 split requested, v2 applied;
  no NAK
- [Phase 4] UNVERIFIED: lore.kernel.org/stable search (HTTP 403)
- [Phase 5] Callers: `alc_init` → init_hook; `alc_suspend` → shutup;
  `alc_resume` → init; vendor IDs 0x10ec0282 / 0215 / 0225 / 0234 / 0285
  / 0294 / …
- [Phase 6] `git describe HEAD`: `p-6.1-2-g8ee893656ef69`; `make
  kernelversion`: **6.1.188**
- [Phase 6] Buggy code present in `sound/pci/hda/patch_realtek.c` lines
  3430, 3467, 3719-3727, 3992
- [Phase 6] Target file `sound/hda/codecs/realtek/alc269.c` missing
  here; equivalent functions exist
- [Phase 8] Failure mode: COEF corruption / possible codec stall on
  resume; severity HIGH for audio, not a kernel oops

**YES**

 sound/hda/codecs/realtek/alc269.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index d88627558150f..3364f6ad91fcb 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -296,7 +296,8 @@ static void alc282_init(struct hda_codec *codec)
 		msleep(100);
 
 	/* Headphone capless set to normal mode */
-	alc_write_coef_idx(codec, 0x78, coef78);
+	if (coef78 != -1)
+		alc_write_coef_idx(codec, 0x78, coef78);
 }
 
 static void alc282_shutup(struct hda_codec *codec)
@@ -333,7 +334,8 @@ static void alc282_shutup(struct hda_codec *codec)
 
 	alc_auto_setup_eapd(codec, false);
 	alc_shutup_pins(codec);
-	alc_write_coef_idx(codec, 0x78, coef78);
+	if (coef78 != -1)
+		alc_write_coef_idx(codec, 0x78, coef78);
 }
 
 static const struct coef_fw alc283_coefs[] = {
@@ -585,15 +587,19 @@ static void alc285_hp_init(struct hda_codec *codec)
 
 	alc_write_coefex_idx(codec, 0x58, 0x00, 0xf888); /* HP depop procedure start */
 	val = alc_read_coefex_idx(codec, 0x58, 0x00);
-	for (i = 0; i < 20 && val & 0x8000; i++) {
+	for (i = 0; i < 20 && val != -1 && val & 0x8000; i++) {
 		msleep(50);
 		val = alc_read_coefex_idx(codec, 0x58, 0x00);
 	} /* Wait for depop procedure finish  */
 
-	alc_write_coefex_idx(codec, 0x58, 0x00, val); /* write back the result */
-	alc_update_coef_idx(codec, 0x38, 1<<4, coef38);
-	alc_update_coef_idx(codec, 0x0d, 0x110, coef0d);
-	alc_update_coef_idx(codec, 0x36, 3<<13, coef36);
+	if (val != -1)
+		alc_write_coefex_idx(codec, 0x58, 0x00, val); /* write back the result */
+	if (coef38 != -1)
+		alc_update_coef_idx(codec, 0x38, 1<<4, coef38);
+	if (coef0d != -1)
+		alc_update_coef_idx(codec, 0x0d, 0x110, coef0d);
+	if (coef36 != -1)
+		alc_update_coef_idx(codec, 0x36, 3<<13, coef36);
 
 	msleep(50);
 	alc_update_coef_idx(codec, 0x4a, 1<<15, 0);
@@ -858,7 +864,7 @@ static void alc294_hp_init(struct hda_codec *codec)
 
 	/* Wait for depop procedure finish  */
 	val = alc_read_coefex_idx(codec, 0x58, 0x01);
-	for (i = 0; i < 20 && val & 0x0080; i++) {
+	for (i = 0; i < 20 && val != -1 && val & 0x0080; i++) {
 		msleep(50);
 		val = alc_read_coefex_idx(codec, 0x58, 0x01);
 	}
-- 
2.53.0

