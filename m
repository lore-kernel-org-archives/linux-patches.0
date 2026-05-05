Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB751337BBD;
	Tue,  5 May 2026 09:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974743; cv=none; b=Vs7TBqZGhUBtS44UIMLNUILo2j+Ym8giptDpdOS3cgflBkDxqTB6YMh/tjIehL4i5dgwYxqGYnL+vSbeHRxs6YUevisJBbwEMLTldrSQ6Ck2cqw9nqFoafsWjKjiYsei3f6X160jewv6dbP7LdGg82+c26FI2/p32l8+AUcNSx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974743; c=relaxed/simple;
	bh=y1Qfm0/uyx8vh96/sDNbnmLNVzbgaLb2euW3sAZ87qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dr3JuMYl+IaR3fVKQjJOrb4T/uLWrXXVa2/J0g3SWxAg73arOnknQSsbCWjyiG2es83j8apt7ywvfmbAZm8DchFXmrCk2Sw2WYTiXuBGF9Rvdaf0awB139M1sw3n5FVhtE8B4dasLYDhwZUHAXaZzFxL7k+CrPaKi3SGipH5YqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FzTSWr5W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FzTSWr5W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A28AC2BCB9;
	Tue,  5 May 2026 09:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777974742;
	bh=y1Qfm0/uyx8vh96/sDNbnmLNVzbgaLb2euW3sAZ87qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FzTSWr5WdJd8ONxMCuS6TcVZhoigKDuNTesK4DqVzz5MX7cr/xWNmHInKL3cTuOxQ
	 M9LiOtZAFfRytPjhvAGLDJO3oKbg1pfbi23IjtgapVBs/BSilcv/YXyrcnwN+3NhvH
	 XRWRTC56Od3fQ16AY18MtA6bdDpgb7Q1X6VxywrLMgXwqOI5v5vGH2BMlLDSOu/T5G
	 4dxFSADna51qZELpIOnMAA38+ddA2Tzq50nNiXwIJGqjvZhK7RwYx+dQpAptdvLKIT
	 hyL4L9/k9WlrDtdVlPC0+Dg/0xqa0DQLhsOc0K2atrSt78iYqq0XYgu3461QWkEb+A
	 HTCYfiQJtnLwQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Troy Mitchell <troy.mitchell@linux.spacemit.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	dlan@kernel.org,
	linux-sound@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	spacemit@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] ASoC: spacemit: move hw constraints from hw_params to startup
Date: Tue,  5 May 2026 05:51:26 -0400
Message-ID: <20260505095149.512052-10-sashal@kernel.org>
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

From: Troy Mitchell <troy.mitchell@linux.spacemit.com>

[ Upstream commit 6b4afbaaa342eaa52172e0be5ef8d1fcbf9ff460 ]

Hardware constraints should be applied in the startup callback rather
than hw_params, as hw_params may be called too late for the constraints
to take effect properly.

Move the channel count and format constraints for I2S and DSP_A/DSP_B
modes into a new startup callback. This also tightens the I2S mode
channel constraint from 1-2 to exactly 2, matching the actual hardware
behavior.

Signed-off-by: Troy Mitchell <troy.mitchell@linux.spacemit.com>
Link: https://patch.msgid.link/20260429-k3-i2s-v1-2-2fe99db11ecb@linux.spacemit.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase Walkthrough
Step 1.1 Record: Subsystem `ASoC: spacemit`; action verb `move`; intent
is to apply PCM hardware constraints in `.startup` instead of
`.hw_params`.

Step 1.2 Record: Tags present: `Signed-off-by: Troy Mitchell`, `Link: ht
tps://patch.msgid.link/20260429-k3-i2s-v1-2-
2fe99db11ecb@linux.spacemit.com`, `Signed-off-by: Mark Brown`. No
`Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by`, `Acked-by`, or
`Cc: stable`.

Step 1.3 Record: The body says constraints in `.hw_params` may be too
late to affect ALSA parameter negotiation, and that I2S should be
constrained to exactly 2 channels. Symptom is invalid PCM
formats/channel counts being allowed for the SpacemiT I2S mode. No crash
trace or affected kernel versions are stated.

Step 1.4 Record: This is a hidden bug fix: it is phrased as
moving/refactoring constraints, but it corrects when ALSA constraints
are installed and prevents unsupported hardware parameters.

Step 2.1 Record: One file changed, `sound/soc/spacemit/k1_i2s.c`, 32
insertions and 13 deletions. Modified functions/objects: new
`spacemit_i2s_startup`, existing `spacemit_i2s_hw_params`, and
`spacemit_i2s_dai_ops`. Scope is single-file, driver-local, surgical.

Step 2.2 Record: Before, the driver advertised broad 1-2 channel and
S16/S32 capabilities and only added mode-specific constraints inside
`.hw_params`, after parameters had already been selected. After,
`.startup` constrains I2S to 2ch/S16 and DSP_A/DSP_B to 1ch/S32 before
userspace parameter selection completes.

Step 2.3 Record: Bug category is logic/correctness in hardware parameter
negotiation. There is no memory safety, locking, refcounting, or
resource lifetime change.

Step 2.4 Record: Fix quality is good: it moves existing constraints to
the ALSA callback used for early constraints and tightens I2S channels.
Regression risk is low but not zero: unsupported mono I2S streams will
now fail earlier, which is intended if the author’s hardware statement
is correct.

Step 3.1 Record: `git blame` shows the changed constraint code was
introduced by `fce217449075d` / local full SHA
`fce217449075d59b29052b8cdac567f0f3e22641`, “ASoC: spacemit: add i2s
support for K1 SoC”, first described as contained before `v6.19-rc1`.

Step 3.2 Record: No `Fixes:` tag in this candidate, so there was no tag
to follow. I inspected the driver-introduction commit instead.

Step 3.3 Record: Recent file history contains the original driver plus
two small later fixes: failure handling for `spacemit_i2s_init_dai()`
and an `sspa_clk` error-check fix. No prerequisite refactor is needed
for this patch.

Step 3.4 Record: Author Troy Mitchell authored the original K1 I2S
driver and one related later fix, so he is directly familiar with this
driver.

Step 3.5 Record: The patch is part of a 7-patch series, but `b4` and
`git apply --check` confirmed patch 2 applies cleanly standalone to the
current tree.

Step 4.1 Record: `b4 dig` against a temporary commit matched the lore
thread at the provided patch-msgid URL. `b4 dig -a` found only v1. The
full thread shows Mark Brown applied patch 2 to `broonie/sound.git
for-7.1` as commit `6b4afbaaa342`.

Step 4.2 Record: `b4 dig -w` shows ASoC/sound maintainers and lists were
included, including Mark Brown, Liam Girdwood, Jaroslav Kysela, Takashi
Iwai, `linux-sound`, and relevant SpacemiT/RISC-V lists.

Step 4.3 Record: No separate bug report, syzbot report, or user report
was linked for this specific patch.

Step 4.4 Record: Series context: patches 1-3 are described as K1 bug
fixes/refactoring; patches 4-7 are K3 feature/binding work. Mark Brown
explicitly noted fixes and new features had no textual overlap and
applied only patches 2 and 3 from the subset.

Step 4.5 Record: Stable-specific web search was blocked by lore Anubis,
and a local pending-branch grep was stopped after timing out. No stable-
specific discussion was verified.

Step 5.1 Record: Key function added/modified: `spacemit_i2s_startup`;
key function simplified: `spacemit_i2s_hw_params`.

Step 5.2 Record: Callers verified: `.startup` is called through
`snd_soc_dai_startup()` from `__soc_pcm_open()`. `.hw_params` is called
through `snd_soc_dai_hw_params()` from `__soc_pcm_hw_params()`.

Step 5.3 Record: Key callees are `snd_pcm_hw_constraint_minmax()` and
`snd_pcm_hw_constraint_mask64()` in startup, and clock/DMA/register
setup remains in `hw_params`.

Step 5.4 Record: Reachability is via ALSA PCM open and hw_params
operations; userspace audio applications can trigger the affected
negotiation path by opening/configuring a PCM device for this DAI.

Step 5.5 Record: Similar local ASoC pattern verified: many drivers
install constraints in `.startup`, and ASoC core comments confirm
startup is part of PCM open.

Step 6.1 Record: The file is absent at `v6.18` and present with the same
blob in `v6.19`, `v7.0`, `v7.0.3`, `pending-6.19`, and `pending-7.0`.
Likely relevant stable trees start at 6.19.y.

Step 6.2 Record: Backport difficulty is low: the patch applies cleanly
to the current 7.0.3 checkout, and the file blob is identical in checked
6.19/7.0 branches.

Step 6.3 Record: No related fix for this exact subject exists in checked
stable branches; the candidate commit exists locally as `6b4afbaaa342`
but is not contained in the checked pending stable branches I verified.

Step 7.1 Record: Subsystem is ASoC platform driver under
`sound/soc/spacemit`; criticality is PERIPHERAL/driver-specific.

Step 7.2 Record: Subsystem activity is low and localized: only four
local commits under `sound/soc/spacemit`, including the original driver
and small fixes.

Step 8.1 Record: Affected population is config/platform-specific:
`CONFIG_SND_SOC_K1_I2S`, depending on `COMPILE_TEST || ARCH_SPACEMIT`,
`HAVE_CLK`, and `DMA_CMA`.

Step 8.2 Record: Trigger is normal PCM device open/parameter selection
on SpacemiT K1 I2S hardware. Unprivileged reachability depends on local
audio device permissions, which I did not verify.

Step 8.3 Record: Failure mode is unsupported audio configuration being
accepted or constrained too late, causing bad/failed audio operation
rather than a verified crash, corruption, or security issue. Severity:
MEDIUM for affected hardware users.

Step 8.4 Record: Benefit is moderate: corrects real hardware parameter
negotiation for a supported driver. Risk is low: one driver, one file,
no ABI/API change, clean apply, and maintainer-applied.

Step 9.1 Record: Evidence for backporting: real driver correctness bug,
normal userspace audio path, introduced in stable-relevant 6.19-era
driver, small contained patch, clean apply, maintainer accepted.
Evidence against: no reporter/test tag, no crash/security/data-loss
evidence, exact “I2S is 2ch only” hardware fact not independently
verified outside author/maintainer review.

Step 9.2 Record: Stable rules: obviously correct enough: yes, based on
ALSA callback ordering and existing constraints; real bug: yes;
important issue: moderate hardware functionality bug, not critical;
small/contained: yes; no new API/feature: yes; can apply: yes to checked
6.19/7.0-family trees.

Step 9.3 Record: No automatic exception category like device ID, quirk,
DT-only, build-only, or documentation-only applies.

Step 9.4 Record: Decision is to backport. The risk is low and the patch
fixes a real, user-visible hardware configuration bug in a stable-
relevant driver.

## Verification
- [Phase 1] Parsed commit `6b4afbaaa342` with `git show`; confirmed tags
  and lack of `Fixes`/reporter/stable tags.
- [Phase 2] Inspected candidate diff; confirmed only `k1_i2s.c` changes,
  adding `.startup` and moving constraints out of `.hw_params`.
- [Phase 3] Ran `git blame` on changed lines; confirmed original code
  from `fce217449075d`.
- [Phase 3] Ran file history and author history; found only localized
  SpacemiT I2S changes.
- [Phase 4] Used `b4 am`, `b4 mbox`, and `b4 dig`; confirmed v1 thread,
  maintainer application to `for-7.1`, and reviewer/maintainer
  recipients.
- [Phase 5] Read ASoC core code; confirmed startup occurs during PCM
  open and hw_params occurs later during ALSA hardware parameter setup.
- [Phase 6] Checked tags/branches and patch application; confirmed file
  presence from `v6.19` onward and clean standalone apply.
- [Phase 7] Read `Kconfig`; confirmed driver-specific SpacemiT K1 I2S
  config scope.
- [Phase 8] Assessed trigger/failure from verified ALSA call paths and
  driver-advertised constraints.
- UNVERIFIED: Independent hardware documentation proving I2S mode is
  exactly 2 channels; this claim comes from the commit author and
  maintainer-accepted patch.
- UNVERIFIED: Stable mailing-list search results, because lore WebFetch
  was blocked and one local pending-branch grep was stopped after
  timeout.

**YES**

 sound/soc/spacemit/k1_i2s.c | 45 ++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 13 deletions(-)

diff --git a/sound/soc/spacemit/k1_i2s.c b/sound/soc/spacemit/k1_i2s.c
index 1cb99f1abc7cd..bb73d32a1b097 100644
--- a/sound/soc/spacemit/k1_i2s.c
+++ b/sound/soc/spacemit/k1_i2s.c
@@ -106,6 +106,37 @@ static void spacemit_i2s_init(struct spacemit_i2s_dev *i2s)
 	writel(0, i2s->base + SSINTEN);
 }
 
+static int spacemit_i2s_startup(struct snd_pcm_substream *substream,
+	struct snd_soc_dai *dai)
+{
+	struct spacemit_i2s_dev *i2s = snd_soc_dai_get_drvdata(dai);
+
+	switch (i2s->dai_fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
+	case SND_SOC_DAIFMT_I2S:
+		snd_pcm_hw_constraint_minmax(substream->runtime,
+					     SNDRV_PCM_HW_PARAM_CHANNELS,
+					     2, 2);
+		snd_pcm_hw_constraint_mask64(substream->runtime,
+					     SNDRV_PCM_HW_PARAM_FORMAT,
+					     SNDRV_PCM_FMTBIT_S16_LE);
+		break;
+	case SND_SOC_DAIFMT_DSP_A:
+	case SND_SOC_DAIFMT_DSP_B:
+		snd_pcm_hw_constraint_minmax(substream->runtime,
+					     SNDRV_PCM_HW_PARAM_CHANNELS,
+					     1, 1);
+		snd_pcm_hw_constraint_mask64(substream->runtime,
+					     SNDRV_PCM_HW_PARAM_FORMAT,
+					     SNDRV_PCM_FMTBIT_S32_LE);
+		break;
+	default:
+		dev_dbg(i2s->dev, "unexpected format type");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int spacemit_i2s_hw_params(struct snd_pcm_substream *substream,
 				  struct snd_pcm_hw_params *params,
 				  struct snd_soc_dai *dai)
@@ -157,22 +188,9 @@ static int spacemit_i2s_hw_params(struct snd_pcm_substream *substream,
 			dma_data->maxburst = 32;
 			dma_data->addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
 		}
-
-		snd_pcm_hw_constraint_minmax(substream->runtime,
-					     SNDRV_PCM_HW_PARAM_CHANNELS,
-					     1, 2);
-		snd_pcm_hw_constraint_mask64(substream->runtime,
-					     SNDRV_PCM_HW_PARAM_FORMAT,
-					     SNDRV_PCM_FMTBIT_S16_LE);
 		break;
 	case SND_SOC_DAIFMT_DSP_A:
 	case SND_SOC_DAIFMT_DSP_B:
-		snd_pcm_hw_constraint_minmax(substream->runtime,
-					     SNDRV_PCM_HW_PARAM_CHANNELS,
-					     1, 1);
-		snd_pcm_hw_constraint_mask64(substream->runtime,
-					     SNDRV_PCM_HW_PARAM_FORMAT,
-					     SNDRV_PCM_FMTBIT_S32_LE);
 		break;
 	default:
 		dev_dbg(i2s->dev, "unexpected format type");
@@ -303,6 +321,7 @@ static int spacemit_i2s_dai_remove(struct snd_soc_dai *dai)
 static const struct snd_soc_dai_ops spacemit_i2s_dai_ops = {
 	.probe = spacemit_i2s_dai_probe,
 	.remove = spacemit_i2s_dai_remove,
+	.startup = spacemit_i2s_startup,
 	.hw_params = spacemit_i2s_hw_params,
 	.set_sysclk = spacemit_i2s_set_sysclk,
 	.set_fmt = spacemit_i2s_set_fmt,
-- 
2.53.0

