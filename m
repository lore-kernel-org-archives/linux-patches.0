Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DA0380;
	Tue, 23 Jan 2024 02:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975746; cv=none; b=HqPZU8lhNh8dpUTisNmXgpqvlM+rTnZA2mvD9zKf4n74Ju06r7ti068fHDWZOgm7wEnfqEfvVyckof7Iwp4I3m1bhxU6EFKL9zbn+DzR+aJYHNzKSRS6LZ5HNVM7bI8/7N3f2XGXIw6cWQWBzPWIE+J/szfVWymUi8L2Q1RuISY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975746; c=relaxed/simple;
	bh=ArVpwiEGbIO1QU0DTdTdAzxkAQ6pXZMNHNLdvG71EZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ushm4uTQmfHw8347oN48IxVDQrRmQl7+Bzs12THUAHDVKlT5wrS3vbAuBrbhzWvalXlMGv2/DtibG86ZdmDA14JbMlPm/Qf3pjgJ2/PVJ5DiE7ifw2sI4GarkJ0GK344MAyKJBPBa5QWBMyr3x7TdXn/A2Jrod1oYw4x0kbl2Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bMeZcqSQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bMeZcqSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B43FC43394;
	Tue, 23 Jan 2024 02:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975746;
	bh=ArVpwiEGbIO1QU0DTdTdAzxkAQ6pXZMNHNLdvG71EZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bMeZcqSQf9qd90JGXjQGKWnObBN7DfxjbUd8Ys6+FxGGsWUJ0AfGJMXA6eBmfSNa2
	 g3Ug+cKrgaDdKoi2nM5QyeXsn1LsiWYUlfAVcJpllqG9WDJfAB2q6u65L0jlqLz31U
	 u/fy5Lm9+HQvMSTyaK3FTSh1a9Z8aP2e85GTpAbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 531/583] ALSA: hda: Properly setup HDMI stream
Date: Mon, 22 Jan 2024 15:59:42 -0800
Message-ID: <20240122235828.358090234@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit 454abb80e26ab85323a30e52aa7b0ee9aae1d38a ]

Since commit 4005d1ba0a7e ("ASoC: soc-dai: don't call PCM audio ops if
the stream is not supported") HDMI playback is broken with avs driver.
This happens because for HDMI stream (unlike generic HDA one)
channels_min for stream is not set when creating PCMs. Fix this by
setting the value based on first available converter.

Fixes: 4005d1ba0a7e ("ASoC: soc-dai: don't call PCM audio ops if the stream is not supported")
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://lore.kernel.org/r/20240112113349.2905328-1-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 78cee53fee02..038db8902c9e 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2301,6 +2301,7 @@ static int generic_hdmi_build_pcms(struct hda_codec *codec)
 	codec_dbg(codec, "hdmi: pcm_num set to %d\n", pcm_num);
 
 	for (idx = 0; idx < pcm_num; idx++) {
+		struct hdmi_spec_per_cvt *per_cvt;
 		struct hda_pcm *info;
 		struct hda_pcm_stream *pstr;
 
@@ -2316,6 +2317,11 @@ static int generic_hdmi_build_pcms(struct hda_codec *codec)
 		pstr = &info->stream[SNDRV_PCM_STREAM_PLAYBACK];
 		pstr->substreams = 1;
 		pstr->ops = generic_ops;
+
+		per_cvt = get_cvt(spec, 0);
+		pstr->channels_min = per_cvt->channels_min;
+		pstr->channels_max = per_cvt->channels_max;
+
 		/* pcm number is less than pcm_rec array size */
 		if (spec->pcm_used >= ARRAY_SIZE(spec->pcm_rec))
 			break;
-- 
2.43.0



