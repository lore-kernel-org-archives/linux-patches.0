Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF996FA1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:26:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7915DC433D6;
	Wed, 30 Nov 2022 18:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669832784;
	bh=T/JNdIwIo6UzgdF5WlTwOUXXb/5183hznI0RTYMs1WY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TnZgQDLG1ZjovEMMC+ICx3iBg40gY3o0kFv1+WE0ZeWJHHvlv5x7i0NQs3dalJ7En
	 nTlEGDyBReF76wH1DonTDl8pygZE2EqIC0bQJ6zlHexMrkgPAr5b7oW6uGk6JYMfB4
	 kACz5wvqD441QeHhNMISBQUL/xIWY4S+8Obh03/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/162] ASoC: soc-pcm: Dont zero TDM masks in __soc_pcm_open()
Date: Wed, 30 Nov 2022 19:21:59 +0100
Message-Id: <20221130180529.538227423@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 39bd801d6908900e9ab0cdc2655150f95ddd4f1a ]

The DAI tx_mask and rx_mask are set by snd_soc_dai_set_tdm_slot()
and used by later code that depends on the TDM settings. So
__soc_pcm_open() should not be obliterating those mask values.

The code in __soc_pcm_hw_params() uses these masks to calculate the
active channels so that only the AIF_IN/AIF_OUT widgets for the
active TDM slots are enabled. The zeroing of the masks in
__soc_pcm_open() disables this functionality so all AIF widgets
were enabled even for channels that are not assigned to a TDM slot.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 2e5894d73789 ("ASoC: pcm: Add support for DAI multicodec")
Link: https://lore.kernel.org/r/20221104132213.121847-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-pcm.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 8b8a9aca2912..0e2261ee07b6 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -723,11 +723,6 @@ static int soc_pcm_open(struct snd_pcm_substream *substream)
 		ret = snd_soc_dai_startup(dai, substream);
 		if (ret < 0)
 			goto err;
-
-		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-			dai->tx_mask = 0;
-		else
-			dai->rx_mask = 0;
 	}
 
 	/* Dynamic PCM DAI links compat checks use dynamic capabilities */
-- 
2.35.1



