Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BCE285077;
	Tue, 17 Jun 2025 16:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179159; cv=none; b=CNm7rPIgoaJxyuFIdTQ0zJEhau70ynJ7yxIA9lvKjwDa9PT/vD6dgxhN3ygpjRXDHYNu+mM1ehx3uFAqeoKIKvPkF/7Y+xtzY9LA6lRdsKTkdk3KXgpyA6l78NmsZaq8Fs4QL5Ygqq+3MDTOzAae7S2ahIhsQJlT9o8D/KZqK8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179159; c=relaxed/simple;
	bh=30+gQ6oJURlLKs6y+DUPkuH9ALnxR1tlPc1Uxc0Acnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iyblkiwovC5ZEJEWXcxs55qELTTDJyUgPQC8zTgCsi4tfG+x+r+ahoK460B2qVkcdFHGtCsSNA31a8BXP67WFGg0ekIUvfE77mhHasbLwYQAOOubSe3CnNLOehg8wm90Iwgd/1BkzAiyWg7og1kKLslA4ik2L2uKUpt8rkLyeXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DTNpif7g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DTNpif7g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07AA1C4CEE3;
	Tue, 17 Jun 2025 16:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179159;
	bh=30+gQ6oJURlLKs6y+DUPkuH9ALnxR1tlPc1Uxc0Acnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DTNpif7gs/0vKO+C0U3IulqsGQNasWqUjDNUUEqo6dS8W5FShGhyySAcQf3MfsW4O
	 2b/UlXBqvPdr3rYyQzVCSMtv66VtWoD9oXvyQCLOXK0VgzBSxHqULWHDJGnW4yNbvO
	 BGl4Z/yJxFbw8zfukrrO6bwmJbO9aAtc02I66pqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 639/780] ASoC: Intel: avs: Fix PPLCxFMT calculation
Date: Tue, 17 Jun 2025 17:25:47 +0200
Message-ID: <20250617152517.497022631@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 347c8d6db7c9d65d93ef226849b273823f54eaea ]

HDAudio transfer types utilize SDxFMT for front-end (HOST) and PPLCxFMT
for back-end (LINK) side when setting up the stream. BE's
substream->runtime duplicates FE runtime so switch to using BE's
hw_params to address incorrect format values on the LINK side when FE
and BE formats differ.

The problem is introduced with commit d070002a20fc ("ASoC: Intel: avs:
HDA PCM BE operations") but the code has been shuffled around since then
so direct 'Fixes:' tag does not apply.

Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20250530141025.2942936-4-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/pcm.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/soc/intel/avs/pcm.c b/sound/soc/intel/avs/pcm.c
index 6116465c8f9b1..fc51fa1fd40d2 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -449,9 +449,10 @@ static int avs_dai_hda_be_hw_free(struct snd_pcm_substream *substream, struct sn
 
 static int avs_dai_hda_be_prepare(struct snd_pcm_substream *substream, struct snd_soc_dai *dai)
 {
-	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct snd_soc_pcm_runtime *be = snd_soc_substream_to_rtd(substream);
 	const struct snd_soc_pcm_stream *stream_info;
 	struct hdac_ext_stream *link_stream;
+	const struct snd_pcm_hw_params *p;
 	struct avs_dma_data *data;
 	unsigned int format_val;
 	unsigned int bits;
@@ -459,14 +460,15 @@ static int avs_dai_hda_be_prepare(struct snd_pcm_substream *substream, struct sn
 
 	data = snd_soc_dai_get_dma_data(dai, substream);
 	link_stream = data->link_stream;
+	p = &be->dpcm[substream->stream].hw_params;
 
 	if (link_stream->link_prepared)
 		return 0;
 
 	stream_info = snd_soc_dai_get_pcm_stream(dai, substream->stream);
-	bits = snd_hdac_stream_format_bits(runtime->format, runtime->subformat,
+	bits = snd_hdac_stream_format_bits(params_format(p), params_subformat(p),
 					   stream_info->sig_bits);
-	format_val = snd_hdac_stream_format(runtime->channels, bits, runtime->rate);
+	format_val = snd_hdac_stream_format(params_channels(p), bits, params_rate(p));
 
 	snd_hdac_ext_stream_decouple(&data->adev->base.core, link_stream, true);
 	snd_hdac_ext_stream_reset(link_stream);
-- 
2.39.5



