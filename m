Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D753B27D1;
	Wed, 23 Sep 2026 14:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174469; cv=none; b=WJ3rwt61SB24Gy2Ts755h1uxEPdTqHN6prVd72ff+3JAc5+cfxjN+tg/4SPStpZpfvsedOJPpvvRI9iQ/gJA/Td/k/EVm/t15GFMfZn2PGQThMO3eRn0nEwNeysloQiTmFQD0EAcpye0itpKIN/WoxFYVL+O3B21uY5GcEhGBFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174469; c=relaxed/simple;
	bh=UGZ/wDE5ntBZidcYoIlKfAzR1a0y588mWtgBsXaUbxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MrGRG/cdvIAMQ9B2p7aIMr824zGds3StdBDw+jYnh/JahIHHQznZ/AY2vXiLLWCjIsjGVhnVa+VPSBZfLEzpz9Oq0RRrVMbUsblwImeEh3B/HpJFbvcRgj62tij1qq/slOjcX/F5MkN3XAsP6bTckFoXdDfMMh6wU1H0rsuirZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OLHZU2HR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OLHZU2HR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86EED1F00893;
	Wed, 23 Sep 2026 14:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174468;
	bh=yoPJOQoJPYmOXzTu+0zTqp+HrhpJrcNQtf6jwa0jClE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OLHZU2HRPR2FfqSjI3ATAZe/+9raVbEnxr/eQDwgweeffDUC2tS9cFaO72MOJSOKO
	 szwwDLRZlWVzKKWy8C1aEAt3GOJb+HpCl+K8bl2hMHa6JcrnvGIh+Gz83EeukyhFIR
	 RmmrPe+J4mjqv0xe1CGOQhiP+OoQeTgrXA25ma94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 124/398] ALSA: hda: trace PCM open only after assigning a stream
Date: Wed, 23 Sep 2026 16:03:18 +0200
Message-ID: <20260923140646.653206126@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 sound/hda/common/controller.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/hda/common/controller.c b/sound/hda/common/controller.c
index b1cfd9bd4dcb7..98ab47977e318 100644
--- a/sound/hda/common/controller.c
+++ b/sound/hda/common/controller.c
@@ -584,11 +584,11 @@ static int azx_pcm_open(struct snd_pcm_substream *substream)
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



