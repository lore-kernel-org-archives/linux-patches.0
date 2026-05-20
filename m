Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0BA36F421;
	Wed, 20 May 2026 16:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295409; cv=none; b=Ydc8DbmIoxLBWntBTou8llYxV3fjeY+B/sQ2yLKw40/L1io3jNSpFIDOZwEu/hEnp1OZIxG9TNxNcwHjg/HVbWgeOeagwxxAvxHR9Z1dDFbh6/Kv13X96ClcLq79n1Sy1FzusYtmuiReq7cciMGtXg6xPjVgEJg/PYV5U1EcOa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295409; c=relaxed/simple;
	bh=hH+Mt3ImWEdPX1vgW7adQelMP0npwEBYqixuR4vKYC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kkGxZaINxchToqAwXeVMTI+wkTr8sEmgN1E38EmiyAWjTMzMYJNCaz4spakp42GuXqr4DWdOPPniIVcZJGjLMF07CYyICstYwHXnzT+UK7QFYMOCpVb3uVrtxQqjJYGHADwfldGr/LJHwZ68i+kadWHYy0k6+Y4gaLn9xd5NA3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1CnMv4bv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1CnMv4bv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFE21F000E9;
	Wed, 20 May 2026 16:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295408;
	bh=HjU+OKbub41H07jmrzYQuQXRqq5HiNtftB0NletDh8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1CnMv4bvvK7yTwn89+sfc3s520eipmS0j3LliEq85aJnB67jzkYvYjsWX7HZM9DRw
	 VNBYFN9QiZSOAafWsnACkewQcZL3eawVyt5BBeuvRizHJkXYL6RC9f/sZekraCOmme
	 OYt0HmShtfmGSIRjtZprdQE8Pp1ShNTYjeh5Uyrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0408/1146] ASoC: SOF: compress: return the configured codec from get_params
Date: Wed, 20 May 2026 18:10:58 +0200
Message-ID: <20260520162157.432578573@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 90f056eae1c33..a676ffc2379df 100644
--- a/sound/soc/sof/compress.c
+++ b/sound/soc/sof/compress.c
@@ -255,6 +255,7 @@ static int sof_compr_set_params(struct snd_soc_component *component,
 	sstream->sampling_rate = params->codec.sample_rate;
 	sstream->channels = params->codec.ch_out;
 	sstream->sample_container_bytes = pcm->params.sample_container_bytes;
+	sstream->codec_params = params->codec;
 
 	spcm->prepared[cstream->direction] = true;
 
@@ -267,9 +268,10 @@ static int sof_compr_set_params(struct snd_soc_component *component,
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
index 693d063830fae..38753b088fc1d 100644
--- a/sound/soc/sof/sof-priv.h
+++ b/sound/soc/sof/sof-priv.h
@@ -17,6 +17,7 @@
 #include <sound/sof/info.h>
 #include <sound/sof/pm.h>
 #include <sound/sof/trace.h>
+#include <sound/compress_params.h>
 #include <uapi/sound/sof/fw.h>
 #include <sound/sof/ext_manifest.h>
 
@@ -111,6 +112,7 @@ struct sof_compr_stream {
 	u32 sampling_rate;
 	u16 channels;
 	u16 sample_container_bytes;
+	struct snd_codec codec_params;
 	size_t posn_offset;
 };
 
-- 
2.53.0



