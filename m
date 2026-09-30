Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A3F263F4A;
	Wed, 30 Sep 2026 17:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788539; cv=none; b=sVYZstWgccQiL4RIIfVl+K6dJ84BzS+xTL+k/VEP3Tkw1JU+2zhpnn51Q6+l68PCFpcHs2Cp/8hOYNAL3nFz8XRxvLFLe4XnVtaqu5J2owsXlBLnsX2W4lvtO+K65EpvuOkY9tojIOo5ozjukphNx2j8zyHVFtiP+eUP6p1Whgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788539; c=relaxed/simple;
	bh=pjF0SdQSiOuu93rGd1bG3CHK+maUWq1qx22f9bjlG/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okhquqECHdgtEFW2Oacf1CG3IfviDNPiQV2tXweTlPGE6vPE9AZbpdxIxD2uaTvueuftqIInZmaPUKTwnU1gdCFCkED2AntkRtYeS4webOVKnwE4LJkOu0Dzrw8xuDeb5w1nyQ1S6hPS7FtxTNgUHW+jcYEQsnBXQwA0BBN6E4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CceyLPst; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CceyLPst"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2251F000FF;
	Wed, 30 Sep 2026 17:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788538;
	bh=/nGtigCZK3JdbDsLA1iGx30FsNVeDRJL+hMzW0UPRyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CceyLPstlPnLVr3K/PTohPi+hlKmhjUSWrJ7p2xzASpOEiQQQLk8mqUK42Z71hzQ8
	 cywfTj2e4nG4lmgbBvJ4NiHGwdS/OuxqLsYclfiPYvJXUp5gWVnr00esunu2Amc1dr
	 59+KoIdEMc39ZEcPHYjxRsaFWJ7RmcBP6PhAA7t0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 115/877] ALSA: hda: trace PCM open only after assigning a stream
Date: Wed, 30 Sep 2026 17:17:06 +0200
Message-ID: <20260930152417.219226083@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bd13ea0c9352e..7c0574eb54c61 100644
--- a/sound/pci/hda/hda_controller.c
+++ b/sound/pci/hda/hda_controller.c
@@ -593,11 +593,11 @@ static int azx_pcm_open(struct snd_pcm_substream *substream)
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



