Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2953F4DD6;
	Wed, 20 May 2026 18:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300341; cv=none; b=InMMWzQJ/SmbRoHbVkinJnYsngBbgpjP+gzVFbhvRzUvrrCVFnHEplkyHiDLMLS8LJ9zHmo9KgzwD6RbIkpAiAZHigoUDB9Sp156P90Rimg1jeBlzrcwxG+4m9TmU3Fes72qmpIaWlKXuimQcIYrzGhN3OUSbOc1dttNxXw5tAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300341; c=relaxed/simple;
	bh=/aOTtiMKYGhIfPRqvziVdNGhDeB+AfOEIay+nkgvC7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j1ON3sqY657VL6vJcLLXdZU1EV/wVUvKR1pbOTsO7YRJuIA5oiY4EisrOJTbn0s/3tSzdGK2GgpiKoSoPUyi4C3pIXkZb2tNodoUUyycIbMq+kTQR5Alr/+FuoKSALoMopeT91HvJOOlX8SHfKG9N+hLGWN2rx14lQ/NaMDRg6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lMT/MfV9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lMT/MfV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD411F000E9;
	Wed, 20 May 2026 18:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300340;
	bh=dqiiHuA2MGYNGQn5Qi7SPIcHu5hYiQkNJO9ITpV+G0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lMT/MfV930dLkFb9FDp/786OV8cC2DkArBYtS3ET6AINVM2O2OGCTOnws91a2dzop
	 nZFiWsOe+aztSDBbMbTijbqEzaI16W42Z9/cBi/CHRhpipPGnBB4IZXhz8a9YP57mI
	 JDGFVga0YDT7aCtzIjbVXNu4RKIRmTNdPWowS4sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <b42378@freescale.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 121/666] ASoC: soc-compress: use function to clear symmetric params
Date: Wed, 20 May 2026 18:15:32 +0200
Message-ID: <20260520162113.840501380@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 07c774dd64ba0c605dbf844132122e3edbdbea93 ]

Current soc-compress.c clears symmetric_rate, but it clears rate only,
not clear other symmetric_channels/sample_bits.

	static int soc_compr_clean(...)
	{
		...
		if (!snd_soc_dai_active(cpu_dai))
=>			cpu_dai->symmetric_rate = 0;

		if (!snd_soc_dai_active(codec_dai))
=>			codec_dai->symmetric_rate = 0;
		...
	};

This feature was added when v3.7 kernel [1], and there was only
symmetric_rate, no symmetric_channels/sample_bits in that timing.

symmetric_channels/sample_bits were added in v3.14 [2],
but I guess it didn't notice that soc-compress.c is updating symmetric_xxx.

We are clearing symmetry_xxx by soc_pcm_set_dai_params(), but is soc-pcm.c
local function. Makes it global function and clear symmetry_xxx by it.

[1] commit 1245b7005de02 ("ASoC: add compress stream support")
[2] commit 3635bf09a89cf ("ASoC: soc-pcm: add symmetry for channels and
			   sample bits")

Fixes: 3635bf09a89c ("ASoC: soc-pcm: add symmetry for channels and sample bits")
Cc: Nicolin Chen <b42378@freescale.com>
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/87ms15e3kv.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc.h      | 3 +++
 sound/soc/soc-compress.c | 4 ++--
 sound/soc/soc-pcm.c      | 4 ++--
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index db3b464a91c7b..cd467f8babdb6 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -1452,6 +1452,9 @@ struct snd_soc_dai *snd_soc_find_dai(
 struct snd_soc_dai *snd_soc_find_dai_with_mutex(
 	const struct snd_soc_dai_link_component *dlc);
 
+void soc_pcm_set_dai_params(struct snd_soc_dai *dai,
+			    struct snd_pcm_hw_params *params);
+
 #include <sound/soc-dai.h>
 
 static inline
diff --git a/sound/soc/soc-compress.c b/sound/soc/soc-compress.c
index f787f60a16a11..249cafe54f561 100644
--- a/sound/soc/soc-compress.c
+++ b/sound/soc/soc-compress.c
@@ -69,10 +69,10 @@ static int soc_compr_clean(struct snd_compr_stream *cstream, int rollback)
 	snd_soc_dai_digital_mute(codec_dai, 1, stream);
 
 	if (!snd_soc_dai_active(cpu_dai))
-		cpu_dai->symmetric_rate = 0;
+		soc_pcm_set_dai_params(cpu_dai, NULL);
 
 	if (!snd_soc_dai_active(codec_dai))
-		codec_dai->symmetric_rate = 0;
+		soc_pcm_set_dai_params(codec_dai, NULL);
 
 	snd_soc_link_compr_shutdown(cstream, rollback);
 
diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 83e6a76da7e63..628322790c878 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -458,8 +458,8 @@ int dpcm_dapm_stream_event(struct snd_soc_pcm_runtime *fe, int dir,
 	return 0;
 }
 
-static void soc_pcm_set_dai_params(struct snd_soc_dai *dai,
-				   struct snd_pcm_hw_params *params)
+void soc_pcm_set_dai_params(struct snd_soc_dai *dai,
+			    struct snd_pcm_hw_params *params)
 {
 	if (params) {
 		dai->symmetric_rate	   = params_rate(params);
-- 
2.53.0



