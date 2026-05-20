Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372934F5E0;
	Wed, 20 May 2026 18:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300584; cv=none; b=urEnXZAYB2ns/dkOdsoIgVIHK7oUDed0Prx8wELaPNeKx2wGie5brZJzIUwUKA1QWDafFKZQf9JrJe+MIhoKlQPlRMDICfQRjcJglIQJHmCdFvmedgcRYEFLy0ASIPVIZ4uMQZjqBnFyRD5rB4sGWDixi2TaVyWzZbulGXn0eP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300584; c=relaxed/simple;
	bh=QH21lA2z2KAe4B969Xds+K2z1i43MFGKVzvsLsNj+F0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dLofFJ83tuiMQW4R3l36enOQIYkOxeml+WGJLsRClAnB9pTNzgz0gLvxNoXxnZ5frFJ5DUH1up1i3CLxgx0ZnCbsC4dZAV6JIA3kIy0mjSdD12DTrA3CWCYT6ShxP5TN1CRXfLPkYdGfLta7//5swY8M9KFBoU5pjybKroeqMvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yqkg+KkM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yqkg+KkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E12A1F000E9;
	Wed, 20 May 2026 18:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300583;
	bh=W3QsQLeqCPbBUhzWzf0R5QDG9e5dihTnzaFocW1v/kA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yqkg+KkMKuuYAY0vI+PnYK6rg6lEwFyfbrITxEMQDrpsweXr4P65MDIPu9c7opAbl
	 F+eXtm7TLzBfQ4J1F/Kp9WmEV8hQWlpA2Pbbwg1Lx61d0sUVU/6zvhv06XYxw8jK38
	 fWvbxEFWiY2pqCgf8u5bcBSQeFF/e0ScEvQSeJPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 230/666] ASoC: SOF: compress: return the configured codec from get_params
Date: Wed, 20 May 2026 18:17:21 +0200
Message-ID: <20260520162116.198358719@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c469bb706e4a4..b64a5d99fe608 100644
--- a/sound/soc/sof/compress.c
+++ b/sound/soc/sof/compress.c
@@ -247,6 +247,7 @@ static int sof_compr_set_params(struct snd_soc_component *component,
 	sstream->sampling_rate = params->codec.sample_rate;
 	sstream->channels = params->codec.ch_out;
 	sstream->sample_container_bytes = pcm->params.sample_container_bytes;
+	sstream->codec_params = params->codec;
 
 	spcm->prepared[cstream->direction] = true;
 
@@ -259,9 +260,10 @@ static int sof_compr_set_params(struct snd_soc_component *component,
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
index 843be3b6415d9..53bcc627ae8b5 100644
--- a/sound/soc/sof/sof-priv.h
+++ b/sound/soc/sof/sof-priv.h
@@ -17,6 +17,7 @@
 #include <sound/sof/info.h>
 #include <sound/sof/pm.h>
 #include <sound/sof/trace.h>
+#include <sound/compress_params.h>
 #include <uapi/sound/sof/fw.h>
 #include <sound/sof/ext_manifest.h>
 
@@ -119,6 +120,7 @@ struct sof_compr_stream {
 	u32 sampling_rate;
 	u16 channels;
 	u16 sample_container_bytes;
+	struct snd_codec codec_params;
 	size_t posn_offset;
 };
 
-- 
2.53.0



