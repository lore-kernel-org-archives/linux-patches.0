Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A98E5914C;
	Tue, 23 Jan 2024 00:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970107; cv=none; b=XJSz4QBE3S/0z+4CJM6R5vzhlbDqoYHbL/EFFJrkRWAcd+qaZKz6cPfnvq+kOsDu2X1/6maOCTXVrJDCbgaHtZOJA0aHVWfM5Fhh/3K47xmXK/3zjxdB8OGdHdro850f74WgOzmqhRaB5kN2mnO/UYZ2Uysg316Hi2ijurcmWAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970107; c=relaxed/simple;
	bh=REZaYdpOqw7EuGlUgmzBpgeDxX+JyGGVH/nh1N2jQ/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aK0eatYmOcoz5e4cqsIv/72WiURBIl44wLbcueMp2iGnEdeeazES071tjSMK/J56NkABEJ8b93uOz22fKQ6CgpOLaMepRd5ihAuQqceuh/waSwhqhcRgfoLzi8nvEPfzTe1EI8nmJrRDFeVAtjxdt+gOAEfetXxOt3KlOTgUeik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D3LA4bl6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D3LA4bl6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E9FC433F1;
	Tue, 23 Jan 2024 00:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970107;
	bh=REZaYdpOqw7EuGlUgmzBpgeDxX+JyGGVH/nh1N2jQ/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D3LA4bl6GoLsIv1X03TQ2gjy3Ykw6v1i0xor+ab84pvEIhdmBphvJCSRylHHA6gqh
	 ZxDX2S6vp4+7vqoFLpXtB9IiJ/mP/CxOmw2IaizMaPNiZ+rX95Dk8GD//5KsuYN+P3
	 tdOfslUTcBh+bYYn1eDq1IiwgJ1TiPFt2YKVbnpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 590/641] ALSA: hda: Properly setup HDMI stream
Date: Mon, 22 Jan 2024 15:58:14 -0800
Message-ID: <20240122235836.681159604@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



