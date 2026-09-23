Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFBF5221E4;
	Wed, 23 Sep 2026 14:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173240; cv=none; b=qr1nP88U6TQzcjKjz3ufCZNQJTEiQrOuVwKagkzN/f9czpZrUQUH6kkySXbTUTN7ZrOXFe40ENpXVAX0JYr+Ef0p51WXIb04sfiws8hGJsBQvPjtjdbSqIAtvpqeHfsSw5ib4d1aoWUEk+bJV4exNgrHoziYYJbTtiM2I0f3+Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173240; c=relaxed/simple;
	bh=pdcxTG1qDtW5q4zHkFnhM8ArgwkARfRJG2x8mPhHy6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BnXp81cvs6E6o2RLOinWskNgfNzHUZY2L/4O5EGO2uTI+zGLmujwQ4i5rcBuPxRlfTlgkEe1s6m0gbbB7Nuarc0Q1B2T79ebmXPoG0fo3b6WC4TbQY9M4qO4QDvJLbfs1w9NkI4WXZjV/CeIoIKE8yAoPrSvqwtM2CwqNFQsaDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QbQE8Yw1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QbQE8Yw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DAF01F000FF;
	Wed, 23 Sep 2026 14:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173238;
	bh=YzuIlIadm1CQtudveXI9J6PWs1fB+2iFNX0LqRvuHyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QbQE8Yw1Iic3E55iqXCiSgiqKk3zCw/oP/sZHfHuSJKM4gmFS6HE7spVEB3Cs5L0x
	 SQYuQ/jXhndlcONXCnt1YRu+n4zbu21LQS4GNYt8B0n8Uo7kMiZwk9dNir6KosSnTs
	 EmcRTUU3N6Pw14NN/xR9m26XoKA7ToDOtvqvDByY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 150/438] ALSA: hda: trace PCM open only after assigning a stream
Date: Wed, 23 Sep 2026 16:02:51 +0200
Message-ID: <20260923140648.657935602@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index afec5c5546ec7..18dae022b324f 100644
--- a/sound/hda/common/controller.c
+++ b/sound/hda/common/controller.c
@@ -586,11 +586,11 @@ static int azx_pcm_open(struct snd_pcm_substream *substream)
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



