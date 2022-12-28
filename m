Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696C71875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2530C433F0;
	Wed, 28 Dec 2022 16:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243332;
	bh=ScbmVO2G9W420ThA0cgjAtmOyYxKf4s7sgdebJVQe5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=epD05XKETFrZr2TwQnRLFirHz8NDrubly6ztTgI0PEsqW3K2mY4wiQcsbVQ6NQrGe
	 +d52fdBdy90V+4/hAMYqmNwdHXSnh+PsKQu12NleylJtB+T3L2QVr6eHFwm9C+vCcS
	 h0vj+lutGJpcBkrvSuaUexyIzVdoQpTrueKrC+U8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0481/1146] ALSA: pcm: Set missing stop_operating flag at undoing trigger start
Date: Wed, 28 Dec 2022 15:33:40 +0100
Message-Id: <20221228144343.248602541@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 5c8cc93b06d1ff860327a273abf3ac006290d242 ]

When a PCM trigger-start fails at snd_pcm_do_start(), PCM core tries
to undo the action at snd_pcm_undo_start() by issuing the trigger STOP
manually.  At that point, we forgot to set the stop_operating flag,
hence the sync-stop won't be issued at the next prepare or other
calls.

This patch adds the missing stop_operating flag at
snd_pcm_undo_start().

Fixes: 1e850beea278 ("ALSA: pcm: Add the support for sync-stop operation")
Link: https://lore.kernel.org/r/b4e71631-4a94-613-27b2-fb595792630@carlh.net
Link: https://lore.kernel.org/r/20221205132124.11585-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_native.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 33769ca78cc8..9238abbfb2d6 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -1432,8 +1432,10 @@ static int snd_pcm_do_start(struct snd_pcm_substream *substream,
 static void snd_pcm_undo_start(struct snd_pcm_substream *substream,
 			       snd_pcm_state_t state)
 {
-	if (substream->runtime->trigger_master == substream)
+	if (substream->runtime->trigger_master == substream) {
 		substream->ops->trigger(substream, SNDRV_PCM_TRIGGER_STOP);
+		substream->runtime->stop_operating = true;
+	}
 }
 
 static void snd_pcm_post_start(struct snd_pcm_substream *substream,
-- 
2.35.1



