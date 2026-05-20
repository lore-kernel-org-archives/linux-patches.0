Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B0A3C6A5C;
	Wed, 20 May 2026 17:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297850; cv=none; b=U7FEKmbGVtWhEWdQEtULy4DRQSO+oDlElFs3MhvGEg03vRjni4u4GVnhSmshOoHrDJbB1mj+2//bM0RwK37tfYCiR9LNY9tmNDYzb6t6jXQVj35vmDaHZVtUo7Gj+i/i4OrLqpBK0fYztX4s0ISGkEhBTMUNIvCVjoChkr5Cyno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297850; c=relaxed/simple;
	bh=w4tJb3hSwb+/MvKShvMKe20nKAWVdMcLanhV1fXC8lU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TNzt6MY1jmMPAqH378LOB27MWn4SDzGWWctAdhj/4cCwjpZ2s7tEZss+9uMsHsvC/u25piJVDyavxAMKLLk3DRIjqHwdR8nywXrWQG7yGNLZ0BEyVbrpGpMI6RMipg1hx3eymuaX5nnrK+gLb36mwav37fOR/ybeldWDjnf9FEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X2fQJUwL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X2fQJUwL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0291F000E9;
	Wed, 20 May 2026 17:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297849;
	bh=mkjJ1ejJNQSdyH6NPmLQTLpwhCJK4njrzM1iyk8jKjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X2fQJUwLYK8R/h0vnx8eBsEZy+5PR7HGQrnjhUEAHgTBABCtJVV90+zdv8TIkSiaI
	 lRDu83sArCjdrDzB4/8IkVn7+Nsxym2VhNGt3EqY4DjY1KOnYnS35+5C7jMLNGXB7B
	 SrZpCwRJjsA3KCCJ6CmRsIkosO5ol0cu796S6Kgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <b42378@freescale.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 188/957] ASoC: soc-compress: use function to clear symmetric params
Date: Wed, 20 May 2026 18:11:11 +0200
Message-ID: <20260520162138.629483894@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a9c058b06ab42..33968935d00a9 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -1414,6 +1414,9 @@ struct snd_soc_dai *snd_soc_find_dai(
 struct snd_soc_dai *snd_soc_find_dai_with_mutex(
 	const struct snd_soc_dai_link_component *dlc);
 
+void soc_pcm_set_dai_params(struct snd_soc_dai *dai,
+			    struct snd_pcm_hw_params *params);
+
 #include <sound/soc-dai.h>
 
 static inline
diff --git a/sound/soc/soc-compress.c b/sound/soc/soc-compress.c
index 7b81dffc6a935..b8402802ae784 100644
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
index 2c21fd528afd0..99299364c9ba3 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -423,8 +423,8 @@ void dpcm_dapm_stream_event(struct snd_soc_pcm_runtime *fe, int dir, int event)
 	snd_soc_dapm_stream_event(fe, dir, event);
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



