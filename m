Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4A256CE20;
	Mon, 19 Oct 2026 13:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418283; cv=none; b=YZRixITc2ZhloTxuRmLrMKdud+iknhAUfh2v6gBuFY4xaNuYP/mIZzmhPIy3QgjFivDWqNooxb9apgnrpBMNC4Gw+o2x2r2qt+6Yu3JazeDbetmyqge/uJL+WeRFiNKas+66jwBsubtLlzSrC1OvLo1CJAdODZCxeJJ6bridK2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418283; c=relaxed/simple;
	bh=de3eDLS7qmBPaPKiZdyRQShbPn6YRvSjGFk1pxma31Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i2Wm0Tg8FcSLcLotWiCjB/91qV7rb6h9aNJmlouvPVqZVGIxdUjFQ5TxxO5cbijNBrZUmyvcKqseDAPQZgUOkpd4YWFpTnKe3Wwm/GbbUcxh4uJlu0V8FaqZMlNFj1X+tp0bRC0seLWbkqKFn6+pv0CI4bZYGR45Y8gvyrA3LZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TpMczUZ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TpMczUZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1AE81F000C7;
	Mon, 19 Oct 2026 13:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418279;
	bh=+8NqKn6uNWtbTSb6EmjgDYhq5VdfpwBYEPmX5T+PrgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TpMczUZ1YzjUUwxab9jQQC2xGp2/YSbuBUCUoaDSJ+psnObrQsAI1Wz2qz0kYtBgc
	 5FKSRMeZlg4RcA0K+n17Lqp3VFuPi3k5Jz9N+Ah9lsd42Alkl9pRLz/8cfQASICBUS
	 Tgt41GHdhFfuCURR2AG0AxBjK3aMEWyCU07rdPF3LgYF7c/WGWp8lDtClMnYwc62Dy
	 5mMLTWYEGc/O5nLYJvBRzEv6pX6TybeXQ+y8uXrTGpc818UevqkXVL/HAESderhIF1
	 zq2TH+YUDenr9uALJBGspwHHrp/Io6IXOMRvEevnxsFaRiLvX8eEkPRwFxNhOkUR1c
	 0BYCRp05060PQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Csaba Budai <ilyr73@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ALSA: hda/realtek: Fix ALC700 audio on Intel Hades Canyon
Date: Mon, 19 Oct 2026 09:47:06 -0400
Message-ID: <20261019135441.1420968-135-sashal@kernel.org>
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

From: Csaba Budai <ilyr73@gmail.com>

[ Upstream commit 1fcccdc20a76b4639b00124cf2a379b837bd2bf7 ]

On Intel Hades Canyon systems with an ALC700 codec, analog audio can
become unusable after rebooting from Windows into Linux.

The affected system uses codec subsystem ID 8086:2073. In the broken
state, Realtek coefficient 0x1b has value 0x4a4b. Setting bit 0x0400
changes it to 0x4e4b and immediately restores normal analog playback.

The BIOS also sets this bit after disabling and re-enabling onboard
audio, while Windows may leave it cleared. Linux currently does not
restore it during codec initialization.

Add a machine-specific fixup for Intel Hades Canyon which sets only
bit 0x0400 of coefficient 0x1b during HDA_FIXUP_ACT_INIT.

The fix has been verified across Windows -> Linux reboots on an Intel
NUC8i7HNB with an ALC700 codec.

Signed-off-by: Csaba Budai <ilyr73@gmail.com>
Link: https://patch.msgid.link/20260821102514.11194-1-ilyr73@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
This is a machine-specific ALSA Realtek quirk for Intel Hades Canyon.
The local tree is **6.12.111**; the same Realtek tables exist here, just
in `sound/pci/hda/patch_realtek.c` instead of later `alc269.c`.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[ALSA: hda/realtek]** **[Fix]** **ALC700 analog audio unusable
on Intel Hades Canyon after Windows reboot**

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- **Signed-off-by:** Csaba Budai \<ilyr73@gmail.com\> (author)
- **Link:**
  https://patch.msgid.link/20260821102514.11194-1-ilyr73@gmail.com
- **Signed-off-by:** Takashi Iwai \<tiwai@suse.de\> (ALSA maintainer,
  applied the patch)
- **No Fixes:** tag (expected)
- **No Cc: stable** (expected)
- **No Reported-by / Tested-by / Reviewed-by / Acked-by**
  - Author states the fix was verified on an Intel NUC8i7HNB (in the
    body, not a Tested-by tag)
- Ignore any pipeline-added Sasha Levin SOB / Upstream-commit markers if
  present

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** On Intel Hades Canyon (codec SSID **8086:2073**, ALC700),
  analog audio can become unusable after rebooting from Windows into
  Linux.
- **Symptom:** Analog playback does not work until a BIOS-level audio
  disable/enable or until coef 0x1b bit 0x0400 is set.
- **Root cause:** Windows may leave Realtek coefficient 0x1b as
  **0x4a4b** (bit 0x0400 clear). BIOS sets that bit (value becomes
  **0x4e4b**). Linux never restores it at codec init.
- **Fix:** Machine-specific HDA fixup that sets only bit 0x0400 of coef
  0x1b at `HDA_FIXUP_ACT_INIT`.
- **Version info:** None in the message. Hardware is the 2018 Intel
  NUC8i7HNB; ALC700 support has been in-tree since 2016.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: **Not a hidden fix.** The subject and body are an explicit
hardware-quirk bug fix. It is not cleanup, refactoring, or a new
feature.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- **File (upstream):** `sound/hda/codecs/realtek/alc269.c` (**+20 /
  -0**)
- **Functions/tables:**
  1. Enum: add `ALC700_FIXUP_INTEL_HADES_CANYON`
  2. New `alc700_fixup_intel_hades_canyon()`
  3. `alc269_fixups[]` entry (`HDA_FIXUP_FUNC`)
  4. `alc269_fixup_tbl[]` PCI quirk `SND_PCI_QUIRK(0x8086, 0x2073, ...)`
- **Scope:** Single-file surgical hardware quirk. No API, no data-
  structure, no locking changes.

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- **Before:** SSID 8086:2073 has no match in `alc269_fixup_tbl`.
  `patch_alc269()` still probes ALC700 (`0x10ec0700`) but never restores
  coef 0x1b bit 0x0400. After a Windows boot that left the bit clear,
  analog playback stays broken across Linux boot.
- **After:** `snd_hda_pick_fixup()` matches 8086:2073. During
  `alc_init()` → `snd_hda_apply_fixup(..., HDA_FIXUP_ACT_INIT)`, the new
  function does `alc_update_coef_idx(codec, 0x1b, 0x0400, 0x0400)`,
  which is `(val & ~0x0400) | 0x0400` — set one bit, leave the rest.
- **Path:** Codec init (probe and resume), not an error path. Gated to
  this SSID only.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- **Category:** Hardware quirk / logic correctness (missing codec-init
  restore of a vendor coefficient).
- **Mechanism:** Windows leaves a vendor bit cleared; Linux did not put
  it back. The fix is the standard Realtek INIT coef update used by many
  existing fixups (e.g. `alc269vb_fixup_aspire_e1_coef`).

Step 2.4: ASSESS THE FIX QUALITY
Record:
- **Quality:** Obviously correct and matches existing INIT-coef fixups.
  Mask/set of a single bit is the intended `alc_update_coef_idx` usage
  (verified in `__alc_update_coefex_idx`: `(val & ~mask) | bits_set`).
- **Regression risk:** Very low. Only SSID 8086:2073 is changed. Other
  machines are untouched. Worst case on this SKU is a wrong vendor bit;
  author and BIOS both indicate that bit should be set.
- **No public API / no locking / no refcount changes.**

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Surrounding enum: `ALC700_FIXUP_INTEL_REFERENCE` from
  **b84e843644f211** (PeiSen Hou, 2017-09-01).
- Neighboring NUC 8 quirk 8086:2074 from **d1ee66c5d3c5a0** (2021, "fix
  mic boost on Intel NUC 8") — already in this tree.
- ALC700 codec ID `HDA_CODEC_ENTRY(0x10ec0700, "ALC700", patch_alc269)`
  from **6fbae35a3170c** (2016-05-30).
- The “buggy” state is missing a quirk that was never present; the codec
  path has existed since **v4.8-era / 2016**.

Step 3.2: FOLLOW THE FIXES: TAG
Record: **No Fixes: tag.** Not applicable. This is a missing machine
quirk, not a regression from a specific earlier commit.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- This tree already carries many Realtek `Add quirk` backports in
  `patch_realtek.c`.
- Related ALC700 history in-tree: 6fbae35a3170c (add ALC700),
  2d7fe6185722b (ALC700 no-sound), b84e843644f21 (ALC700 jack detect).
- Upstream file split **aeeb85f26c3bb** (“ALSA: hda: Split Realtek HD-
  audio codec driver”, 2025-07-11) is **not** an ancestor of this 6.12
  tree — that is why the path differs.
- **Standalone** patch (not X/Y). No later follow-up on origin/master
  targeting Hades Canyon / 8086:2073.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Csaba Budai has this one ALSA commit on origin/master. Not the
subsystem maintainer. **Takashi Iwai** (ALSA maintainer) applied it with
“Applied now. Thanks.”

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record:
- Required pieces **are already here:** `alc_update_coef_idx`,
  `HDA_FIXUP_ACT_INIT`, `alc269_fixups[]`, `alc269_fixup_tbl[]`,
  `ALC700_FIXUP_INTEL_REFERENCE`, `patch_alc269` for 0x10ec0700,
  `alc_init()` calling `snd_hda_apply_fixup(..., HDA_FIXUP_ACT_INIT)`.
- **No functional prerequisites.** Only a path rewrite (`alc269.c` →
  `patch_realtek.c`). Insertion anchors exist: enum after
  `ALC700_FIXUP_INTEL_REFERENCE`, quirk table immediately before
  `0x8086, 0x2074`. `alc287_fixup_lenovo_yoga_book_9i()` (the function
  above the new helper upstream) **does** exist in this tree.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- **b4 dig -c 1fcccdc20a76b:**
  https://patch.msgid.link/20260821102514.11194-1-ilyr73@gmail.com
- **b4 dig -a:** single **v1**, no later revisions.
- Maintainer reply (Takashi Iwai, 2026-08-23): **“Applied now.
  Thanks.”** No NAK, no requested changes, no stable discussion.
- Direct lore.kernel.org WebFetch returned **403**; thread recovered via
  `b4 dig -m`.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (**b4 dig -w**): Csaba Budai, Jaroslav Kysela, Takashi Iwai,
linux-sound@, linux-kernel@. Right maintainers were on To/Cc. Applied by
Takashi.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No bugzilla/syzbot link. Evidence is the author’s dual-boot
report plus BIOS/Windows coefficient comparison (0x4a4b vs 0x4e4b).
Severity from the reporter: analog audio unusable until the bit is set.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone v1. No series companions. No later origin/master
commits touching this SSID.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable WebFetch returned **403**. No stable-list
discussion recovered via b4. **UNVERIFIED:** whether anyone already
requested this on stable@ (does not change the technical merit).

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: New `alc700_fixup_intel_hades_canyon()`. Tables: enum,
`alc269_fixups[]`, `alc269_fixup_tbl[]`. Semcode MCP not available;
identified from hunks and grep.

Step 5.2: TRACE CALLERS
Record:
- `snd_hda_pick_fixup()` in `patch_alc269()`
  (`sound/pci/hda/patch_realtek.c` ~12583) selects the quirk from
  PCI/codec SSID.
- `alc_init()` (`spec->init` / `.init = alc_init`) calls
  `snd_hda_apply_fixup(codec, HDA_FIXUP_ACT_INIT)` (~954). That runs on
  codec init (probe and resume).
- Impact surface: **only** devices matching **8086:2073**.

Step 5.3: TRACE CALLEES
Record: `alc_update_coef_idx` → `alc_update_coefex_idx` (NID 0x20,
mutex) → `__alc_update_coefex_idx`: read-modify-write vendor coef.
Standard, already used throughout this file.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Userspace does not need a special syscall. Booting Linux on this
NUC (especially after Windows) enumerates HDA → `patch_alc269` → INIT
fixup. **Reachable from normal device use.** Dual-boot is a realistic
trigger.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Many INIT-time `alc_update_coef_idx` fixups already exist
(`alc269_fixup_hweq`, `alc269vb_fixup_aspire_e1_coef`,
`alc269_fixup_stereo_dmic`). Same pattern. No other 8086:2073 / Hades
Canyon quirk in this tree.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- **Yes.** Local tree: **pending-6.12**, `git describe`
  **p-6.12-3-gc504cf0baa3d8**, `make kernelversion` **6.12.111**.
- ALC700 + `patch_alc269` present since 6fbae35a3170c (in this tree).
- **No** `ALC700_FIXUP_INTEL_HADES_CANYON` and **no**
  `SND_PCI_QUIRK(0x8086, 0x2073, ...)`.
- `git merge-base --is-ancestor 1fcccdc20a76b HEAD` → **not present**.
- Bug is a long-standing missing restore, not something introduced after
  6.12 branched.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **Minor path rewrite, otherwise clean.** Upstream file
`sound/hda/codecs/realtek/alc269.c` is the post-2025 split; 6.12 still
has `sound/pci/hda/patch_realtek.c`. All four hunks have matching
context (enum order, `ALC700_FIXUP_INTEL_REFERENCE` verbs, 8086:2074
quirk). This is the same class of adjustment already used for other
Realtek quirk backports in this tree.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: **No.** Grep found no Hades Canyon / 0x2073 /
`ALC700_FIXUP_INTEL_HADES_CANYON`. Neighboring NUC 8 quirk (2074) is
unrelated (mic boost on a different SKU).

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **ALSA HD-audio / Realtek codec** (`sound/pci/hda/`).
**IMPORTANT** for users of this hardware (common laptop/NUC audio
stack), **PERIPHERAL** in the sense that only one SSID is affected. Not
core mm/VFS.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Very active: this 6.12 tree already has a long stream of Realtek
quirk backports. The pattern is mature and well-understood.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: **Driver/platform-specific:** Intel Hades Canyon NUC (NUC8i7HNB
/ SSID 8086:2073) with ALC700. Dual-boot Windows→Linux users are the
ones who hit the broken coefficient. Other machines unchanged.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Reboot from Windows into Linux (Windows left coef 0x1b bit
0x0400 clear). Not every boot if BIOS left the bit set. Not a race.
Unprivileged users do not need a special exploit; they just have no
analog sound.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: Analog audio **unusable** (no playback) until BIOS toggle or
this coef write. **MEDIUM** for the kernel as a whole, **HIGH** for
those users (device functionally broken). Not a panic/UAF, but a real
hardware functional failure — the exact class stable regularly takes as
HDA quirks.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit:** Restores analog audio on a shipping Intel NUC after dual-
  boot. Matches BIOS. Tested on the machine.
- **Risk:** Very low (20 lines, SSID-gated, one bit set, standard
  helper).
- **Ratio:** Strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Real user-visible bug: analog playback dead after Windows→Linux
  reboot.
- Explicit hardware quirk (SSID + INIT coef), the documented stable
  exception.
- Small (+20), obviously correct, SSID-scoped.
- ALC700 and all helpers exist in 6.12; bug is not post-branch.
- Maintainer Takashi Iwai applied v1 with no objections.
- Same style as many quirks already in this tree.

**AGAINST backporting:**
- Affects one NUC SKU, mainly dual-boot.
- Upstream path differs; cherry-pick needs a file-path adjustment.
- No syzbot/CVE/crash.

**UNRESOLVED:**
- Could not read lore.kernel.org/stable (403). No evidence it was
  rejected for stable.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — bit set matches measured
   0x4a4b→0x4e4b; verified on NUC8i7HNB; maintainer applied.
2. Fixes a real bug that affects users? **PASS** — analog audio unusable
   after dual-boot.
3. Important issue? **PASS** — hardware-quirk class; functional audio
   failure on a real product (not a crash, but in-scope for stable
   quirks).
4. Small and contained? **PASS** — 20 lines, one file, one SSID.
5. No new features or APIs? **PASS** — quirk only.
6. Can apply to the local tree? **PASS** — needs path rewrite to
   `patch_realtek.c`; context matches.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: **Hardware quirk / workaround** (HDA/Realtek codec quirk table).
This is an automatic YES category in the stable rules given above.

Step 9.4: MAKE YOUR DECISION
This should be backported to this 6.12 tree. The ALC700 path is old;
only the Hades Canyon restore is missing. The upstream split into
`alc269.c` is after 6.12, so the backport is the same hunks in
`sound/pci/hda/patch_realtek.c`.

------------------------------------------------
What problem it solves and why it matters
------------------------------------------------
On Intel Hades Canyon (SSID 8086:2073), Windows can leave Realtek coef
0x1b with bit 0x0400 clear. Linux never sets it, so analog playback
stays dead across boot. Dual-boot NUC users on 6.12 hit this today. The
fix restores that one BIOS bit at codec INIT.

Risk vs benefit
------------------------------------------------
Benefit is restoring audio on that SKU. Risk is a one-bit vendor coef
write gated by PCI quirk, using an existing helper. Path rewrite is
mechanical.

------------------------------------------------
Verification
------------------------------------------------
- [Phase 1] Parsed tags: SOB Csaba Budai, Link msgid, SOB Takashi Iwai;
  no Fixes/Cc-stable/Reported-by.
- [Phase 2] Diff: +20 in one file; enum + INIT func + fixup table +
  SND_PCI_QUIRK(0x8086, 0x2073).
- [Phase 2] `__alc_update_coefex_idx`: `(val & ~mask) | bits_set` with
  mask=bits_set=0x0400 sets one bit.
- [Phase 3] `git describe HEAD` / `make kernelversion`: p-6.12-3,
  **6.12.111**.
- [Phase 3] `git merge-base --is-ancestor 1fcccdc20a76b HEAD`: **not in
  this tree**.
- [Phase 3] `git merge-base --is-ancestor 6fbae35a3170c HEAD`: ALC700
  support **is** in this tree (2016).
- [Phase 3] `git merge-base --is-ancestor aeeb85f26c3bb HEAD`: codec
  split **not** in this tree (old path).
- [Phase 3] Blame: `ALC700_FIXUP_INTEL_REFERENCE` from b84e843644f211;
  8086:2074 from d1ee66c5d3c5a0.
- [Phase 4] `b4 dig -c 1fcccdc20a76b`: lore/msgid match; v1 only;
  Takashi “Applied now. Thanks.”
- [Phase 4] `b4 dig -w`: linux-sound + Takashi Iwai + Jaroslav Kysela.
- [Phase 4] WebFetch lore: **403**; thread via `b4 dig -m /tmp/hades-
  canyon.mbox`.
- [Phase 5] Callers: `patch_alc269` → `snd_hda_pick_fixup` → `alc_init`
  → `HDA_FIXUP_ACT_INIT`.
- [Phase 6] Grep: no 0x2073 / Hades Canyon / HADES_CANYON in
  `patch_realtek.c`; insertion points present.
- [Phase 8] Failure: analog playback unusable; SSID-scoped; not a crash.
- UNVERIFIED: stable@ mailing list discussion (HTTP 403).

**YES**

 sound/hda/codecs/realtek/alc269.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index bc33930e83b9f..8196235c31d2b 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3820,6 +3820,7 @@ enum {
 	ALC225_FIXUP_DELL_WYSE_MIC_NO_PRESENCE,
 	ALC225_FIXUP_S3_POP_NOISE,
 	ALC700_FIXUP_INTEL_REFERENCE,
+	ALC700_FIXUP_INTEL_HADES_CANYON,
 	ALC274_FIXUP_DELL_BIND_DACS,
 	ALC274_FIXUP_DELL_AIO_LINEOUT_VERB,
 	ALC298_FIXUP_TPT470_DOCK_FIX,
@@ -4040,6 +4041,19 @@ static void alc287_fixup_lenovo_yoga_book_9i(struct hda_codec *codec,
 	__snd_hda_apply_fixup(codec, id, action, 0);
 }
 
+static void alc700_fixup_intel_hades_canyon(struct hda_codec *codec,
+					    const struct hda_fixup *fix,
+					    int action)
+{
+	/*
+	 * Windows may leave coef 0x1b bit 0x0400 cleared, causing broken
+	 * analog playback after rebooting into Linux.  Restore the bit
+	 * during codec initialization.
+	 */
+	if (action == HDA_FIXUP_ACT_INIT)
+		alc_update_coef_idx(codec, 0x1b, 0x0400, 0x0400);
+}
+
 static const struct hda_fixup alc269_fixups[] = {
 	[ALC233_FIXUP_WUJIE_SPEAKERS] = {
 		.type = HDA_FIXUP_PINS,
@@ -5092,6 +5106,10 @@ static const struct hda_fixup alc269_fixups[] = {
 			{}
 		}
 	},
+	[ALC700_FIXUP_INTEL_HADES_CANYON] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc700_fixup_intel_hades_canyon,
+	},
 	[ALC274_FIXUP_DELL_BIND_DACS] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc274_fixup_bind_dacs,
@@ -7653,6 +7671,8 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x2782, 0xa128, "Positivo N15RPE-S", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x2782, 0xa212, "Lunnen Ground 14", ALC269VC_FIXUP_LUNNEN_GROUND_14),
 	SND_PCI_QUIRK(0x7017, 0x2014, "Star Labs StarFighter", ALC233_FIXUP_STARLABS_STARFIGHTER),
+	SND_PCI_QUIRK(0x8086, 0x2073, "Intel NUC 8 Hades Canyon",
+		      ALC700_FIXUP_INTEL_HADES_CANYON),
 	SND_PCI_QUIRK(0x8086, 0x2074, "Intel NUC 8", ALC233_FIXUP_INTEL_NUC8_DMIC),
 	SND_PCI_QUIRK(0x8086, 0x2080, "Intel NUC 8 Rugged", ALC256_FIXUP_INTEL_NUC8_RUGGED),
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", ALC256_FIXUP_INTEL_NUC10),
-- 
2.53.0

