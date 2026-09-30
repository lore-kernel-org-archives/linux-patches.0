Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81C23BE642;
	Wed, 30 Sep 2026 16:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785876; cv=none; b=G0udWbF1AISd3cVs3PclZT0+2KWbyPUWEArmLoHJibL+XSfgtfwZ6Frg86jXez5Ts1jfED5pufH/vu8Jm0HvcAOioahtuDQiR7d9o9VpRY5bwO5vQ8IXOktdhvIhTu0l1k+aogx5RY1EIMSAzdBab8QLT2zuF1S+WWP2ARoEiyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785876; c=relaxed/simple;
	bh=5n8KFmoqpQo7NEWOKvAArVnz2Vx139p77meQ2XZh2qY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gBNlObi1rgxEbgUqUYZkYk2miyMUrL1tMYGaay1slvYT7BDVotONIWtqt4VGSfDpgCSol7Rh9TV8cofa/3ofdKeWbZuGaAByAPom4orvoNPcTYAGbHW4wryKk2Jm0J8jqP0IoHV953HHknohM6NjgK3fZA9bg5JRAbLUr3ujYMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kq35mpXR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kq35mpXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8D61F000FF;
	Wed, 30 Sep 2026 16:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785875;
	bh=6c6ggfq19UMlneC8vlULiKazfpyhIJVf/G0KiTtm4tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kq35mpXRbbTnvEJl2d2/tNrv+XVtQHZk06dciaEU3GZUhHjnGtgyVCNVV3hfsCKuP
	 oi4UcvoyiqmymYqk+3jsq2JZRH1gqtsGFYMOa9DF1AGKO4JYNZN9MLb6RP9GVNR3Af
	 dr9tJu3tU6XZImqq4YfJQp88ktEPnouTXSyK0hCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 663/982] ALSA: hda: trace PCM open only after assigning a stream
Date: Wed, 30 Sep 2026 17:23:19 +0200
Message-ID: <20260930152431.005043302@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 16ff8e510996b..8fc363a6fe96c 100644
--- a/sound/pci/hda/hda_controller.c
+++ b/sound/pci/hda/hda_controller.c
@@ -587,11 +587,11 @@ static int azx_pcm_open(struct snd_pcm_substream *substream)
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



