Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A4C3016E1;
	Sat, 30 May 2026 17:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161177; cv=none; b=ph/h1RbRXYUIecgdia7enIxrx6++w+s3HS34zr1y5j2headbCthF2t7nhJC7h8qEwdVTlp4EZgl/BRzT9L9OdK21V6kKnya1GVv/KEYEsyVNnDEYH5e5vy6YBlS0RQvmu+cYnZ9L0OJg+xkd5PqhixAURGPm7r9sR6txZIyNy10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161177; c=relaxed/simple;
	bh=lXiMLg8MvTfHsPjqdf0kCWBUO6+2Gj68rGO81Ws7SEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vzui19T/qpAASl1ZbkFXhdUfkV0pSigGSK82EXVoSjAj+G76KYsN695VoB9gvegSrM2JKRVOqjtxLPVEgjmDmOUXMxRaazMAL/cGo/aR13/ntbBMsA28kEe8ARCnDC8m+ZiAJVZAq2pV9CljkA1/xif1Ljc4fVTWmjyh1dYHUks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PhKY+7Mq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PhKY+7Mq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E73C1F00893;
	Sat, 30 May 2026 17:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161176;
	bh=X28fBZm+A9ijJfYWissvJposzhF2RNao+wBRdyHxA04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PhKY+7Mq5nQBl9uDJky150xTQ+a74zGvTb+A70pkbTFwZOz7I87IrVGRMc5wY8p8n
	 3y6KYqTh5wzQSz5BDss/ezkGU7B8ANtrLlQdHW9xVgEavFGi0O/VSSXYkkbpVqfPW9
	 4cD+TMKGIivaiG5U22Xop1f+alg2NC7dpZNJCjlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 548/969] ASoC: SOF: compress: return the configured codec from get_params
Date: Sat, 30 May 2026 18:01:12 +0200
Message-ID: <20260530160315.507891999@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 2c4fdd055f92a2fc8602dcd88bcea08c374b7e8b ]

The SOF compressed offload path accepts codec parameters in
sof_compr_set_params() and forwards them to firmware as
extended data in the SOF IPC stream params message.

However, sof_compr_get_params() still returns success without
filling the snd_codec structure. Since the compress core allocates
that structure zeroed and copies it back to userspace on success,
SNDRV_COMPRESS_GET_PARAMS returns an all-zero codec description
even after the stream has been configured successfully.

The stale TODO in this callback conflates get_params() with capability
discovery. Supported codec enumeration belongs in get_caps() and
get_codec_caps(). get_params() should report the current codec settings.

Cache the codec accepted by sof_compr_set_params() in the per-stream SOF
compress state and return it from sof_compr_get_params().

Fixes: 6324cf901e14 ("ASoC: SOF: compr: Add compress ops implementation")
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260325-sof-compr-get-params-v1-1-0758815f13c7@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/compress.c | 8 +++++---
 sound/soc/sof/sof-priv.h | 2 ++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/sound/soc/sof/compress.c b/sound/soc/sof/compress.c
index 71c66c1b518c6..5ce304f010cfd 100644
--- a/sound/soc/sof/compress.c
+++ b/sound/soc/sof/compress.c
@@ -240,6 +240,7 @@ static int sof_compr_set_params(struct snd_soc_component *component,
 	sstream->sampling_rate = params->codec.sample_rate;
 	sstream->channels = params->codec.ch_out;
 	sstream->sample_container_bytes = pcm->params.sample_container_bytes;
+	sstream->codec_params = params->codec;
 
 	spcm->prepared[cstream->direction] = true;
 
@@ -252,9 +253,10 @@ static int sof_compr_set_params(struct snd_soc_component *component,
 static int sof_compr_get_params(struct snd_soc_component *component,
 				struct snd_compr_stream *cstream, struct snd_codec *params)
 {
-	/* TODO: we don't query the supported codecs for now, if the
-	 * application asks for an unsupported codec the set_params() will fail.
-	 */
+	struct sof_compr_stream *sstream = cstream->runtime->private_data;
+
+	*params = sstream->codec_params;
+
 	return 0;
 }
 
diff --git a/sound/soc/sof/sof-priv.h b/sound/soc/sof/sof-priv.h
index 6f5b06473011d..77c9741fc1480 100644
--- a/sound/soc/sof/sof-priv.h
+++ b/sound/soc/sof/sof-priv.h
@@ -17,6 +17,7 @@
 #include <sound/sof/info.h>
 #include <sound/sof/pm.h>
 #include <sound/sof/trace.h>
+#include <sound/compress_params.h>
 #include <uapi/sound/sof/fw.h>
 #include <sound/sof/ext_manifest.h>
 
@@ -112,6 +113,7 @@ struct sof_compr_stream {
 	u32 sampling_rate;
 	u16 channels;
 	u16 sample_container_bytes;
+	struct snd_codec codec_params;
 	size_t posn_offset;
 };
 
-- 
2.53.0



