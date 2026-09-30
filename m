Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE8C3E0C4D;
	Wed, 30 Sep 2026 19:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796099; cv=none; b=cFmpbB9VHx+SYzfyhj128H2q2oLs8P/lFpsxNHZ/OkmZtE5YXpZeg5peiNEqRSACR7b5i6gf8ZJuu2YinMwhsPdg0NE4+87wJaOOv6IsL6q66QYUo5iJ5mR6pt4AHgs1d51iL3kxG1Zws4UJcQZHl+4fo7daQbRW2Ve6Su4y3fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796099; c=relaxed/simple;
	bh=WDmcT8z7sC1SLMM6ndNAwpc+ctLzzKO9krsF0OeFkG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZrSfNWu8bJOU+ItZk6jgVi/YzKPCcC+dNeXBASeQQtdo5lrhWVnPpowL5k3uFipy62RxdVKahju+Wf4Sz/6TRZePGjdwCuko3g8eXytiJm6J15rJvIAIWZ/3yyHzjUKt5faRiRZYPWP7Cjv97d1WJDsu9iYu+7xBSO7TXx/aV7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tMdzzG43; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tMdzzG43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3F71F000FF;
	Wed, 30 Sep 2026 19:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796097;
	bh=/EqyC2SEQ6/uKNL2PNFFTKFNSv36XzfqPyNxeVaKY40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tMdzzG43yMnD0rWatelJg8yY/h9yUKKLc09HfG6QVA383VamjhsxZoicc9YPeotyO
	 VRKtorMZ0aMTKe4rc34XnUiIkCHcRRpjDCGSkLaF+UcSQvP6pkGAZvLeFhnjoZcWCD
	 JZiodTUJyfQAk+Gf+kBQI8jUbS40ba2zdX/Hgy90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0792/1193] ALSA: hda: trace PCM open only after assigning a stream
Date: Wed, 30 Sep 2026 17:24:36 +0200
Message-ID: <20260930152451.842730729@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ae56e2361ca46..8603c105ed772 100644
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



