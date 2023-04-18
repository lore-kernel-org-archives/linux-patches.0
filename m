Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7772572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7286AC4339B;
	Tue, 18 Apr 2023 12:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681822145;
	bh=T+bcKzURiSu7tT9sZV8X4D3tDFSjNO+KceGYoPkhe1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bbKcFU+1jgOA8velc89C4/PN00KOWH1tPd88iqNRFd5qXCUNks/DDBNAP1S5ItnMQ
	 qVGxUH0wKtKNdQ1h5Fy22NYwLbvVueAYoFOsu19kGEEVzbFnDsi+sszTQ5qvgdMpjl
	 joTuLRxK1JnEot70nmzLvKL+Gpl4sD7sbG4Q3xNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.2 010/139] ALSA: emu10k1: dont create old pass-through playback device on Audigy
Date: Tue, 18 Apr 2023 14:21:15 +0200
Message-Id: <20230418120314.090583853@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>

commit 8dd13214a810c695044aa168c0ddba1a9c433e4f upstream.

It could have never worked, as snd_emu10k1_fx8010_playback_prepare() and
snd_emu10k1_fx8010_playback_hw_free() assume the emu10k1 offset for the
ETRAM, and the default DSP code includes no handler for it. It also
wouldn't make a lot of sense to make it work, as Audigy has an own, much
simpler, pass-through mechanism. So just skip creation of the device.

Signed-off-by: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230405201220.2197938-1-oswald.buddenhagen@gmx.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/emu10k1/emupcm.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/sound/pci/emu10k1/emupcm.c
+++ b/sound/pci/emu10k1/emupcm.c
@@ -1781,17 +1781,21 @@ int snd_emu10k1_pcm_efx(struct snd_emu10
 	struct snd_kcontrol *kctl;
 	int err;
 
-	err = snd_pcm_new(emu->card, "emu10k1 efx", device, 8, 1, &pcm);
+	err = snd_pcm_new(emu->card, "emu10k1 efx", device, emu->audigy ? 0 : 8, 1, &pcm);
 	if (err < 0)
 		return err;
 
 	pcm->private_data = emu;
 
-	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK, &snd_emu10k1_fx8010_playback_ops);
+	if (!emu->audigy)
+		snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK, &snd_emu10k1_fx8010_playback_ops);
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &snd_emu10k1_capture_efx_ops);
 
 	pcm->info_flags = 0;
-	strcpy(pcm->name, "Multichannel Capture/PT Playback");
+	if (emu->audigy)
+		strcpy(pcm->name, "Multichannel Capture");
+	else
+		strcpy(pcm->name, "Multichannel Capture/PT Playback");
 	emu->pcm_efx = pcm;
 
 	/* EFX capture - record the "FXBUS2" channels, by default we connect the EXTINs 


