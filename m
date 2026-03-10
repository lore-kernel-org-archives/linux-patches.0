Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D39544103C;
	Tue, 10 Mar 2026 09:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133325; cv=none; b=OWpLJmwc1l5yBfjhiZFJT1rmClWkiOQ7Uk2SeUAs7HsFbhV9/y3XoTshm94kT0UFa+QYSgcXaEAFaDPsjUYIqK3rvy/woI6209yYSG/E4Yiz6f2LfHy+Sc5WEYXp7j4F9sjMvhzwT9M0ayyFx2YZDU8vj6U9vcuswfYaXy+0tXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133325; c=relaxed/simple;
	bh=19Gx4tdBnUxpmwRSAVsv3/VSZBu/Y9k0M5OKJaD6cg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RmKTh8iO9BA1MJzrQhrtAUE9mzhdlhZu6ikdARU0gARMaMU7NSyGFi9xDbFp0gCXhnXMgLYBujOhh/TaCvPqv0yMjily5DO/UWt8wHJ+uLScQACHSOPiv+2Ahbapfh9A3/gPTDYW3Xh73CX1B0W51O86Z0sMC/7uPXxbxeF72OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K02iwP/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K02iwP/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42398C2BCB3;
	Tue, 10 Mar 2026 09:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133325;
	bh=19Gx4tdBnUxpmwRSAVsv3/VSZBu/Y9k0M5OKJaD6cg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K02iwP/Dv+WtibUAmb+9CUGsjJcvg22wJWRwOAwztoBCMxT8TKkI5R8ZwBJyeYa1D
	 UjkjW9X/n7ys2hq4R0ZAiQOD8mU8SKFBntmrHAF4Dfz/pBR0Xvqma2iuhTgvuusQ30
	 AUI1S/P9iK2mcw6cihm1aTUm7fg4bzT69xxqX2KBazmbzMa9b4KQF5tMOiMoI/zWDi
	 Mpr7lzMqq4vqSDuhKI9f/TwE8lSWhmo8+bkTz7XVmA1j00RJ38AWoZlfz3gT+lA93m
	 TJ9SG0cBiHVMKKy+mIq+hIg/MlFYWPqb4FReC85uHF08zbsuWejw+P3vSqity2LQuT
	 VM1Rj1jGwqTlQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shuming Fan <shumingf@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	oder_chiou@realtek.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] ASoC: rt1321: fix DMIC ch2/3 mask issue
Date: Tue, 10 Mar 2026 05:01:13 -0400
Message-ID: <20260310090145.2709021-13-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260310090145.2709021-1-sashal@kernel.org>
References: <20260310090145.2709021-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Transfer-Encoding: 8bit

From: Shuming Fan <shumingf@realtek.com>

[ Upstream commit 986841dcad257615a6e3f89231bb38e1f3506b77 ]

This patch fixed the DMIC ch2/3 mask missing problem.

Signed-off-by: Shuming Fan <shumingf@realtek.com>
Link: https://patch.msgid.link/20260225091210.3648905-1-shumingf@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### What the commit fixes
The RT1321 codec's DMIC (Digital Microphone) channel mask was hardcoded
to `BIT(0) | BIT(1)`, which only enables channels 0 and 1. When more
than 2 channels are requested (e.g., channels 2/3), those channels would
be silently ignored because the mask didn't include them.

The fix dynamically calculates the channel mask using
`GENMASK(num_channels - 1, 0)` based on the actual number of channels
from the audio parameters, so all requested channels are properly
enabled.

### Stable kernel criteria assessment
- **Fixes a real bug**: Yes - DMIC channels 2/3 are non-functional on
  RT1321 hardware
- **Obviously correct**: Yes - using `params_channels()` with
  `GENMASK()` is the standard pattern (already used elsewhere in this
  driver for RT1320_DEV_ID)
- **Small and contained**: Yes - 3 lines changed in 1 file, only affects
  the RT1321 code path
- **No new features**: Correct - this purely fixes broken channel
  masking
- **Author**: Shuming Fan from Realtek (the codec vendor),
  reviewed/merged by Mark Brown (ASoC maintainer)

### Risk assessment
Very low risk. The change is isolated to the `RT1321_DEV_ID` case in
`rt1320_sdw_hw_params()`. It cannot affect RT1320 or any other device
path. The fix pattern (dynamic channel mask from params) is standard
practice.

### Applicability to stable trees
RT1321 support was added in commit `7bf9e646af9a0` which first appeared
in v6.18. This fix is only relevant to stable trees that include that
commit (6.18.y and newer).

### Verification
- `git log --oneline -20 -- sound/soc/codecs/rt1320-sdw.c` confirmed the
  file history and that RT1321 support was added in 7bf9e646af9a0
- `git tag --contains 7bf9e646af9a0` confirmed RT1321 support first
  appeared in v6.18
- `git show e52b9ff96a5eb --stat` confirmed the fix is 3 insertions, 2
  deletions in a single file
- Read the diff: verified the old code hardcoded `BIT(0) | BIT(1)` and
  the new code uses `GENMASK(num_channels - 1, 0)`
- The RT1320_DEV_ID case already had a different (working) channel mask
  approach, confirming this was an RT1321-specific oversight

This is a small, obvious bug fix from the hardware vendor that fixes
non-functional DMIC channels on RT1321 hardware. It meets all stable
kernel criteria.

**YES**

 sound/soc/codecs/rt1320-sdw.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt1320-sdw.c b/sound/soc/codecs/rt1320-sdw.c
index e6142645b9038..4d09dd06f2d83 100644
--- a/sound/soc/codecs/rt1320-sdw.c
+++ b/sound/soc/codecs/rt1320-sdw.c
@@ -1455,7 +1455,7 @@ static int rt1320_sdw_hw_params(struct snd_pcm_substream *substream,
 	struct sdw_port_config port_config;
 	struct sdw_port_config dmic_port_config[2];
 	struct sdw_stream_runtime *sdw_stream;
-	int retval;
+	int retval, num_channels;
 	unsigned int sampling_rate;
 
 	dev_dbg(dai->dev, "%s %s", __func__, dai->name);
@@ -1487,7 +1487,8 @@ static int rt1320_sdw_hw_params(struct snd_pcm_substream *substream,
 				dmic_port_config[1].num = 10;
 				break;
 			case RT1321_DEV_ID:
-				dmic_port_config[0].ch_mask = BIT(0) | BIT(1);
+				num_channels = params_channels(params);
+				dmic_port_config[0].ch_mask = GENMASK(num_channels - 1, 0);
 				dmic_port_config[0].num = 8;
 				break;
 			default:
-- 
2.51.0

