Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3CABA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43707C433EF;
	Tue,  7 Mar 2023 17:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210164;
	bh=NhGsBGoqTdT0I8zUJPQxubvxLRtXHbikPeSRWymwZAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z/J7RrmuK33F0e2yjqvfwBvd1yHGjsuMcWYTbeSNTLgKjRJFRWzR1YNzNC+r2DivQ
	 4PMyDONoLZ9SuSYC/qATuuCwyNPdrviZqBqE/zN+EdtCcECsifQAmLJWg6ofjUmgJ2
	 PgpUg4vzSKmUWwVVxMR7Jn6XWt/ZidNtrs10ZxtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0426/1001] ASoC: qcom: q6apm-dai: Add SNDRV_PCM_INFO_BATCH flag
Date: Tue,  7 Mar 2023 17:53:18 +0100
Message-Id: <20230307170039.845280458@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit aa759f3f9f4394a3af65ad1772fca6cb9dd9e4cc ]

At the moment, playing audio with PulseAudio with the qdsp6 driver
results in distorted sound. It seems like its timer-based scheduling
does not work properly with qdsp6 since setting tsched=0 in
the PulseAudio configuration avoids the issue.

Apparently this happens when the pointer() callback is not accurate
enough. There is a SNDRV_PCM_INFO_BATCH flag that can be used to stop
PulseAudio from using timer-based scheduling by default.

According to https://www.alsa-project.org/pipermail/alsa-devel/2014-March/073816.html:

The flag is being used in the sense explained in the previous audio
meeting -- the data transfer granularity isn't fine enough but aligned
to the period size (or less).

q6apm-dai reports the position as multiple of

prtd->pcm_count = snd_pcm_lib_period_bytes(substream)

so it indeed just a multiple of the period size.

Therefore adding the flag here seems appropriate and makes audio
work out of the box.

Comment log inspired by Stephan Gerhold sent for q6asm-dai.c few years back.

Fixes: 9b4fe0f1cd79 ("ASoC: qdsp6: audioreach: add q6apm-dai support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230209122806.18923-4-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6apm-dai.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/qcom/qdsp6/q6apm-dai.c b/sound/soc/qcom/qdsp6/q6apm-dai.c
index bd35067a40521..7f02f5b2c33fd 100644
--- a/sound/soc/qcom/qdsp6/q6apm-dai.c
+++ b/sound/soc/qcom/qdsp6/q6apm-dai.c
@@ -64,7 +64,8 @@ struct q6apm_dai_data {
 static struct snd_pcm_hardware q6apm_dai_hardware_capture = {
 	.info =                 (SNDRV_PCM_INFO_MMAP | SNDRV_PCM_INFO_BLOCK_TRANSFER |
 				 SNDRV_PCM_INFO_MMAP_VALID | SNDRV_PCM_INFO_INTERLEAVED |
-				 SNDRV_PCM_INFO_PAUSE | SNDRV_PCM_INFO_RESUME),
+				 SNDRV_PCM_INFO_PAUSE | SNDRV_PCM_INFO_RESUME |
+				 SNDRV_PCM_INFO_BATCH),
 	.formats =              (SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE),
 	.rates =                SNDRV_PCM_RATE_8000_48000,
 	.rate_min =             8000,
@@ -82,7 +83,8 @@ static struct snd_pcm_hardware q6apm_dai_hardware_capture = {
 static struct snd_pcm_hardware q6apm_dai_hardware_playback = {
 	.info =                 (SNDRV_PCM_INFO_MMAP | SNDRV_PCM_INFO_BLOCK_TRANSFER |
 				 SNDRV_PCM_INFO_MMAP_VALID | SNDRV_PCM_INFO_INTERLEAVED |
-				 SNDRV_PCM_INFO_PAUSE | SNDRV_PCM_INFO_RESUME),
+				 SNDRV_PCM_INFO_PAUSE | SNDRV_PCM_INFO_RESUME |
+				 SNDRV_PCM_INFO_BATCH),
 	.formats =              (SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE),
 	.rates =                SNDRV_PCM_RATE_8000_192000,
 	.rate_min =             8000,
-- 
2.39.2



