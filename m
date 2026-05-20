Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE05D32B10B;
	Wed, 20 May 2026 16:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294943; cv=none; b=N9YsdY4zoXJUVN/M8LLx235KiYPuP3CYfs7OVorCmOA1uMjcioruzoZhTxIVDY1W5iW0aNwir55IjBwjfzVrzktvfIczT7/epa9JoZMv16xyXQ8fjWD7OR1iMen/i5dMDVWQYO0Tmaa7sT1MiKZzU+sNc1dhKQbBt//SQKjx95I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294943; c=relaxed/simple;
	bh=OtOeY6wisukgC/MAyo+QBUtoZfQgbfjUnsnfRwLs9nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LswthA9jhiziWChWz4TMaVwrn0zKmiNJw/48RIh4w5lm9DAmuj/cr8nWE5wZmMdFHiP74Gr/hu0brSKiigtEAD3DlEzAqx0y2OZ0EsB4zPuucoQUi6oqx1t3wBkT0NL4yfkoQWfh+G9cQraJiRuFQ/JsKFIhTqefwjwJ0KHiB2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=10EbIzN8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="10EbIzN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0261F000E9;
	Wed, 20 May 2026 16:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294942;
	bh=BWLghqFjo+IiTlSw7fkE/C2OdLB76cyyMEw61sLPfuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=10EbIzN8RhiibXva6CO/n3l71CrhZuIKXXEQIPk7n7Mej1hByWPU4BPuKL081eFXm
	 oUU4UZuuIYHbpRquzEjGibeA0Eey4I4BWhMCWKwQcVZxf29uNHGjswtVM7O8OQ6qUA
	 igTL1tMPx6ppfKg5QlQraC4CULrZzije5F0156/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <b42378@freescale.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0231/1146] ASoC: soc-compress: use function to clear symmetric params
Date: Wed, 20 May 2026 18:08:01 +0200
Message-ID: <20260520162153.479934131@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 7d8376c8e1bed..1e0b7cd8d956e 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -1412,6 +1412,9 @@ struct snd_soc_dai *snd_soc_find_dai(
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
index afa9fad4457f2..9b12eedb77c33 100644
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



