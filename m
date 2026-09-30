Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E1050C2B7;
	Wed, 30 Sep 2026 15:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783444; cv=none; b=mU0+yFCOl+fGeU3xD53wZjSRq0AT6Mq29RFTTdEB9nlbMzcNoqqJAMlic2irufexbjkUH/JdPetrzEyY382JA5Q94NOv8jH0xQyFfG0SO3v6rDc19T9T+2+Gm7UCF8mIjAAVbvgVg9gQhuT4o6yQJhjw0fpeqzZne4Rv46VOW0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783444; c=relaxed/simple;
	bh=HG0H8QT0q7Lqru/7PI1bFn5LXP04sB1RJwvP/LEY1kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzPj+5XPBom9PpCBxMGdzvW6+Cu1St/IMSNTujSkt9lZVmoFT+WzyhQvAVxliNY54PSfgsQteqII2+usro9HIDy6LHZLVV/3lc2GwEvIkz9nT0G9AdqXaGkAFqz8ofFJYw/3VrP09ZPMC8pYpq1Rk4ud9ifyUAqR1AP0NLi50aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2kLTjPFS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2kLTjPFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010531F000FF;
	Wed, 30 Sep 2026 15:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783438;
	bh=AZUCbE5pziRmuDh5LZGj7l4AxpczFHj27Whg71OdwKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2kLTjPFSQsAoEVlYNBE7WmF0tbmpVc+EM2i9ma4W8RuXukeoLSRbfOF4DZJrzUo51
	 bCgr4HdQMiIAV6MGNpUgOL/tte1Te6bAc7rrBOEcwEiIFy46eeadCmiyCXkdl7eoJO
	 vGPG7DZRFb3HKtb78RGzW7CeLCGv7UWtBE83ELkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 397/595] ALSA: hda: trace PCM open only after assigning a stream
Date: Wed, 30 Sep 2026 17:24:50 +0200
Message-ID: <20260930152356.212244002@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Slavin Liu <bolin.liu@seu.edu.cn>

[ Upstream commit c9e6e5f38bf75276605f1952b22285f5f3abcaff ]

Stream assignment can fail when hardware streams are exhausted.
Move the tracepoint after the NULL check because its payload accesses
the assigned stream tag.

Detected by static analysis and reviewed with AI-assisted source auditing.

Fixes: 184865085b88 ("ALSA: hda - rename hda_intel_trace.h to hda_controller_trace.h")
Assisted-by: LLM
Signed-off-by: Slavin Liu <bolin.liu@seu.edu.cn>
Link: https://patch.msgid.link/20260913125154.109944-1-bolin.liu@seu.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_controller.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_controller.c b/sound/pci/hda/hda_controller.c
index ea76395d71d38..16e47468cd668 100644
--- a/sound/pci/hda/hda_controller.c
+++ b/sound/pci/hda/hda_controller.c
@@ -588,11 +588,11 @@ static int azx_pcm_open(struct snd_pcm_substream *substream)
 	snd_hda_codec_pcm_get(apcm->info);
 	mutex_lock(&chip->open_mutex);
 	azx_dev = azx_assign_device(chip, substream);
-	trace_azx_pcm_open(chip, azx_dev);
 	if (azx_dev == NULL) {
 		err = -EBUSY;
 		goto unlock;
 	}
+	trace_azx_pcm_open(chip, azx_dev);
 	runtime->private_data = azx_dev;
 
 	runtime->hw = azx_pcm_hw;
-- 
2.53.0



