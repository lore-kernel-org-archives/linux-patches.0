Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C413E51C0;
	Mon, 20 Apr 2026 13:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691490; cv=none; b=afmIAdUaUN70Q96lyxW5j3H5/nk6d+47R6Di80k4ykOmP7dT1GsDgTv5D4TW6hOlm8Gt5xNeP9NmC9YfjHLqwu5CSBf5pO9ljC/tByQDFJvSXHUd7m+Zo6J2EFL7Fy5xZuIdOK33x+mFLZPPo08BtRYZWGwGqdwPsLZ4Q1+AJrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691490; c=relaxed/simple;
	bh=7TQ9hUneeJHjOa2d72CSq1bOeMUupaSmCfwh+du39mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ffIZBdCNc5iro0Krb7C5kZRyhGiZGGoq32a1n9BGDzLLUP1+A9k2Qt0wW+vz2zTstEPfDQgmsce6x0qLnxTnHeSbAW1oijUU6OkT4DVKeIw48MDikKE2k0BsuSNXoKCKpvNfgBqDAgQgfKsOWlthRjyKdkT/s6NfkBjGMYhf3eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uWiPMPe5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uWiPMPe5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367D9C19425;
	Mon, 20 Apr 2026 13:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691490;
	bh=7TQ9hUneeJHjOa2d72CSq1bOeMUupaSmCfwh+du39mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uWiPMPe58YdsgeGZFAV+nH5Pl8qTzR/lFRMDcXe5Ki+ksg+p+ZTSao7YEyLxLRvqT
	 bfGu3+T92KCSDjhXMBaE2TAev84fQPkcYrXyv23Wkxb2WXTCaz9zI5nVBH+JoWj3fa
	 KAEtdu37FNWSehCojlz/PrOv7V469iPXit7qa+E52rzZvVmDRePZ/DNjw2Bm4OBooE
	 4QVGn2+1Hk+dkTRUCoC3pTozPy75NndqdTqlHIbsc9ogRfQkDBQE6x1BEWf9+9FwiC
	 2BKqF73LJZzr9xgRJqUV4ShAVBa3RJvXWe3G7F1YWtaO9X/MAfuD/klLOiT4oxJ6LN
	 iBb5dVJagD+0w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] ALSA: compress: Refuse to update timestamps for unconfigured streams
Date: Mon, 20 Apr 2026 09:17:34 -0400
Message-ID: <20260420132314.1023554-60-sashal@kernel.org>
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit cf6c18cf83e48986ac40a053d09d3c33624135f6 ]

There are a number of mechanisms, including the userspace accessible
timestamp and buffer availability ioctl()s, which allow us to trigger
a timestamp update on a stream before it has been configured. Since
drivers might rely on stream configuration for reporting of pcm_io_frames,
including potentially doing a division by the number of channels, and
these operations are not meaningful for an unconfigured stream reject
attempts to read timestamps before any configuration is done.

Signed-off-by: Mark Brown <broonie@kernel.org>
Acked-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260401-alsa-unconfigured-tstamp-v1-1-694c2cb5f71d@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This confirms: `snd_compr_ioctl_avail` calls `snd_compr_calc_avail`
(line 267) which calls `snd_compr_update_tstamp` **before** the state
check at line 275. So even the AVAIL ioctl triggers the `->pointer()`
callback before checking state. The fix in `snd_compr_update_tstamp`
itself properly guards *both* paths (TSTAMP and AVAIL).

Now let me finalize the analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `ALSA: compress`
- Action verb: "Refuse" (defensive/preventive - indicates preventing
  incorrect behavior)
- Summary: Refuse timestamp updates for streams that haven't been
  configured yet.

Record: [ALSA: compress] [Refuse] [Prevent timestamp update on
unconfigured streams]

**Step 1.2: Tags**
- `Signed-off-by: Mark Brown <broonie@kernel.org>` - Author is the ASoC
  subsystem maintainer
- `Acked-by: Vinod Koul <vkoul@kernel.org>` - Vinod Koul is the original
  compress_offload author
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>` - Takashi Iwai is the
  ALSA top-level maintainer
- `Link:` to patch.msgid.link (the submission)

Record: Authored by ASoC subsystem maintainer, Acked by compress_offload
author, merged by ALSA maintainer. Strong review pedigree.

**Step 1.3: Commit Body**
The commit describes: userspace-accessible timestamp and buffer
availability ioctls can trigger a timestamp update on a stream before it
has been configured. Drivers might rely on stream configuration for
reporting `pcm_io_frames`, including "potentially doing a division by
the number of channels." Since these operations are not meaningful for
unconfigured streams, reject attempts to read timestamps before
configuration.

Record: Bug = calling driver `->pointer()` callback before `set_params`
has been called. Symptom = potential divide-by-zero in drivers (number
of channels = 0 before configuration). Root cause = missing state
validation in `snd_compr_update_tstamp()`.

**Step 1.4: Hidden Bug Fix?**
This is explicitly a defensive fix preventing a divide-by-zero crash.
The "Refuse" language hides what is actually a crash prevention fix.

Record: YES, this is a hidden bug fix. The commit message explicitly
says "doing a division by the number of channels" which is the crash
mechanism.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Single file: `sound/core/compress_offload.c`
- Lines added: ~7 (switch statement checking SNDRV_PCM_STATE_OPEN)
- Lines removed: 0
- Function modified: `snd_compr_update_tstamp()`
- Classification: Single-file surgical fix

**Step 2.2: Code Flow Change**
Before: `snd_compr_update_tstamp()` immediately calls
`stream->ops->pointer()` with no state validation.
After: A switch statement checks if `stream->runtime->state ==
SNDRV_PCM_STATE_OPEN` (pre-configuration state) and returns `-EBADFD` if
so, preventing the `->pointer()` call.

**Step 2.3: Bug Mechanism**
Category: Divide-by-zero / uninitialized state access. When a compress
offload stream is just opened (state = OPEN), driver parameters
(channels, sample_container_bytes) are zero. Calling `->pointer()` in
this state causes drivers like SOF's `sof_compr_pointer()` to execute
`div_u64(..., sstream->channels * sstream->sample_container_bytes)`
which divides by zero.

**Step 2.4: Fix Quality**
- Obviously correct: The state check pattern is used extensively
  throughout this same file (lines 276, 391, 446, 652, 846, 946, 998)
- Minimal: 7 lines added
- No regression risk: Returning -EBADFD for OPEN state is the standard
  pattern used by all other ioctls
- The caller `snd_compr_calc_avail` already has comment "Still need to
  return avail even if tstamp can't be filled in" showing it handles the
  error

## PHASE 3: GIT HISTORY

**Step 3.1: Blame**
- `snd_compr_update_tstamp()` was introduced by commit b21c60a4edd22e
  (2011, v3.3-era) by Vinod Koul as part of the original
  compress_offload support
- The bug has existed since the very beginning (~2011)

**Step 3.2: Fixes tag**
- No Fixes: tag present (expected for autosel candidates)

**Step 3.3: File history**
- Recent changes to the file: 64-bit timestamp infrastructure
  (2c92e2fbe9e22c, Sept 2025) made the issue more visible since it
  changed the pointer callback signature, but the underlying bug
  predates that

**Step 3.4: Author**
- Mark Brown (`broonie@kernel.org`) is the ASoC subsystem maintainer -
  one of the most trusted kernel developers

**Step 3.5: Dependencies**
- This fix applies independently. It only adds a state check using
  existing infrastructure (`SNDRV_PCM_STATE_OPEN`).
- NOTE: In older stable trees (pre-6.12ish), the function signature may
  differ (uses `snd_compr_tstamp` instead of `snd_compr_tstamp64`), but
  the state check logic is identical and would need only trivial
  adaptation.

## PHASE 4: MAILING LIST

Lore was blocked by Anubis anti-bot protection. However:
- The patch was v1 (no revisions needed, indicating it was clean from
  the start)
- It was Acked by the compress_offload author Vinod Koul
- Merged directly by ALSA maintainer Takashi Iwai

Record: Could not fetch lore discussion. Strong review indicators from
tags.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions modified**
- `snd_compr_update_tstamp()` - the internal timestamp update helper

**Step 5.2: Callers**
- `snd_compr_calc_avail()` (line 209) - called from AVAIL/AVAIL64 ioctls
- `snd_compr_tstamp()` (line 760) - called from TSTAMP/TSTAMP64 ioctls
- Both paths are directly reachable from userspace via ioctl

**Step 5.3-5.4: Call chain**
`open() → ioctl(SNDRV_COMPRESS_TSTAMP) → snd_compr_tstamp() →
snd_compr_update_tstamp() → stream->ops->pointer()` - This is directly
triggerable by any user with access to the compress device.

**Step 5.5: Similar patterns**
- Confirmed: `sof_compr_pointer()` does `div_u64(..., sstream->channels
  * sstream->sample_container_bytes)` at line 384-385
- `sst_cdev_tstamp()` does `div_u64(fw_tstamp.hardware_counter,
  stream->num_ch * ...)` at line 348-349
- Both would divide by zero if called before set_params

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Code exists in stable trees**
- The buggy function `snd_compr_update_tstamp()` has existed since 2011
  (v3.3)
- Present in ALL active stable trees
- NOTE: The 64-bit tstamp infrastructure is only in v6.12+. Older trees
  use `snd_compr_tstamp` struct. The fix concept applies to all, but the
  exact patch applies cleanly only to v7.0 and trees with the 64-bit
  tstamp change.

**Step 6.2: Backport complications**
- For v7.0: Applies cleanly (verified function matches exactly)
- For older trees: Needs minor adaptation (different struct type in
  signature)

**Step 6.3: Related fixes**
- No similar state check has been applied to `snd_compr_update_tstamp`
  before

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: Subsystem**
- `sound/core/` - ALSA core, IMPORTANT criticality
- Compress offload is used by mobile/embedded platforms (Qualcomm, Intel
  Atom, SOF)

**Step 7.2: Activity**
- Active subsystem with recent work (64-bit tstamp infrastructure added
  in 2025)

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Who is affected**
- Users of ALSA compressed audio (primarily mobile/embedded, Android,
  Intel Atom, SOF platforms)

**Step 8.2: Trigger conditions**
- Trivially triggerable: open compress device, call TSTAMP or AVAIL
  ioctl before SET_PARAMS
- Can be triggered by unprivileged user with access to the audio device
- No special timing required - completely deterministic

**Step 8.3: Failure severity**
- Divide-by-zero → kernel oops/crash → **CRITICAL**

**Step 8.4: Risk-benefit**
- BENEFIT: Very high - prevents deterministic kernel crash from
  userspace
- RISK: Very low - 7 lines, uses established pattern, authored by ASoC
  maintainer, acked by compress_offload author

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR:**
1. Fixes a divide-by-zero crash triggerable from userspace (CRITICAL)
2. Extremely small and surgical fix (7 lines)
3. Uses an existing, well-established pattern (same check at 6+ other
   locations in the file)
4. Authored by ASoC subsystem maintainer Mark Brown
5. Acked by compress_offload original author Vinod Koul
6. Bug exists since 2011 - affects all stable trees
7. Multiple drivers have the vulnerable division (SOF, Intel Atom)

**Evidence AGAINST:**
1. Needs minor adaptation for trees without 64-bit tstamp (pre-6.12ish)

**Stable rules checklist:**
1. Obviously correct? YES - uses identical pattern to 6+ other ioctls in
   same file
2. Fixes a real bug? YES - divide-by-zero crash
3. Important issue? YES - kernel crash triggerable from userspace
4. Small and contained? YES - 7 lines, single function
5. No new features/APIs? Correct - purely defensive check
6. Applies to stable? YES for 7.0 (clean apply); needs minor rework for
   older trees

## Verification

- [Phase 1] Parsed tags: Signed-off-by Mark Brown (ASoC maintainer),
  Acked-by Vinod Koul (compress_offload author), Signed-off-by Takashi
  Iwai (ALSA maintainer)
- [Phase 2] Diff analysis: 7 lines added in `snd_compr_update_tstamp()`,
  adds state check for SNDRV_PCM_STATE_OPEN
- [Phase 3] git blame: `snd_compr_update_tstamp()` introduced in commit
  b21c60a4edd22e (2011), present in all stable trees
- [Phase 3] git show b21c60a4edd22e: confirmed original compress_offload
  commit
- [Phase 3] git merge-base: confirmed 64-bit tstamp infrastructure
  (2c92e2fbe9e22c) is ancestor of v7.0
- [Phase 4] Lore blocked by Anubis; relied on tag analysis for review
  evidence
- [Phase 5] Grep callers: `snd_compr_update_tstamp` called from lines
  209 and 760, both ioctl-reachable
- [Phase 5] Verified SOF driver `sof_compr_pointer()` does `div_u64(...,
  sstream->channels * sstream->sample_container_bytes)` at line 384-385
- [Phase 5] Verified Intel Atom `sst_cdev_tstamp()` does `div_u64(...,
  stream->num_ch * ...)` at line 348-349
- [Phase 5] Verified `snd_compr_set_params()` sets channels (line 256 in
  sof compress.c), confirming channels=0 before set_params
- [Phase 6] git show v7.0:compress_offload.c: function matches current
  HEAD exactly, clean apply confirmed
- [Phase 6] Existing divide-by-zero protection commit 678e2b44c8e3fec
  (2018) validates this class of bug is real
- [Phase 7] Identified `snd_compr_ioctl_avail` line 267 calls
  update_tstamp BEFORE its own state check at line 275, confirming both
  AVAIL and TSTAMP paths are vulnerable
- [Phase 8] Failure mode: divide-by-zero → kernel oops, severity
  CRITICAL, trivially triggerable from userspace

This is a textbook stable backport: a small, surgical fix preventing a
deterministic kernel crash (divide-by-zero) that is trivially
triggerable from userspace via ioctl. Authored and reviewed by the top
three relevant maintainers.

**YES**

 sound/core/compress_offload.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index fdba6e4b25fdc..67b3b1a3b5261 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -192,6 +192,14 @@ static int snd_compr_update_tstamp(struct snd_compr_stream *stream,
 {
 	if (!stream->ops->pointer)
 		return -ENOTSUPP;
+
+	switch (stream->runtime->state) {
+	case SNDRV_PCM_STATE_OPEN:
+		return -EBADFD;
+	default:
+		break;
+	}
+
 	stream->ops->pointer(stream, tstamp);
 	pr_debug("dsp consumed till %u total %llu bytes\n", tstamp->byte_offset,
 		 tstamp->copied_total);
-- 
2.53.0

