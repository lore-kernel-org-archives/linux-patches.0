Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F34F158211;
	Tue, 23 Jul 2024 18:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760143; cv=none; b=Hh+6pNm44TnKAY+U+EKgJ4bYjPA0IuJf3bO13HfFXBzsw1l4UH9VhD5BJIp39rt2NkZyrMbES9x3G5W+1w8o40Gq/2oyB4xDeXVHLscb0fwfyQrD9IogLtAGDYQ2nLNE9DJ6rAEI5FT4clwrdyq19vcpJawHFAxQMMRnVQwhSXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760143; c=relaxed/simple;
	bh=SyHGg2pHXrZ8oQ045QrH/XNtloxJCXM+XncNaBKXM+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Grw2Vdzi2mh03T6cNpFrJEvpmFvUoY3RF7JnQ8NbnpVjpar5TfYVHA08DqLf2wHXvre4kLIHsfmpQ4ui6Goq8qBJ15B6Lf1QFr4li3MtJv7kt4iUo+FKUK8IcI3Tm78DH526u2JJBV/+6Fkb0eqSm1ReTE8fLqapbDAW286mmrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iUPPjfHt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iUPPjfHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A731C4AF09;
	Tue, 23 Jul 2024 18:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760142;
	bh=SyHGg2pHXrZ8oQ045QrH/XNtloxJCXM+XncNaBKXM+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iUPPjfHtFCKtYVOCz65EZCtlUcSA8nZmC2f8U8nFyc/4OVZJFzQTgO4Ox2hRo6Uqr
	 unEusG1B9kmO7w2iOYzAADGtxzE6X+9RzH86VjzNLBjmqc1dxFywpg5yqdzeCS9Vot
	 WFDoL6QSxHPEID7ZVXbXr2hZYriB8YfG2qHUUNiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 117/163] ALSA: PCM: Allow resume only for suspended streams
Date: Tue, 23 Jul 2024 20:24:06 +0200
Message-ID: <20240723180147.994909668@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 1225675ca74c746f09211528588e83b3def1ff6a ]

snd_pcm_resume() should bail out if the stream isn't in a suspended
state.  Otherwise it'd allow doubly resume.

Link: https://patch.msgid.link/20240624125443.27808-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_native.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 0b76e76823d28..353ecd960a1f5 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -1775,6 +1775,8 @@ static int snd_pcm_pre_resume(struct snd_pcm_substream *substream,
 			      snd_pcm_state_t state)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
+	if (runtime->state != SNDRV_PCM_STATE_SUSPENDED)
+		return -EBADFD;
 	if (!(runtime->info & SNDRV_PCM_INFO_RESUME))
 		return -ENOSYS;
 	runtime->trigger_master = substream;
-- 
2.43.0



