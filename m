Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C0A3C46C
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2qXJ6hhD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A113C433C8;
	Wed, 15 Nov 2023 19:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077552;
	bh=6RVySMLIEUVg/qfz98rdQ29WFUa3T9BMawvajcpbnRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2qXJ6hhDhhyyt7ofydb8GoQr3dGRxiJxCfSimDvc9X4k61wL7JiiUchoqSRi/4FQd
	 49ukdkOPtpMyW1iCW4wsecv5XAvo0ZUBt1g8J6YcS3MTe+SWndWDG6IbSlEgO7lYZt
	 cYOdjU89CRFb36EG9w9OEe0OdQ7JRgC63p0Cyums=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chancel Liu <chancel.liu@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 352/603] ASoC: soc-pcm.c: Make sure DAI parameters cleared if the DAI becomes inactive
Date: Wed, 15 Nov 2023 14:14:57 -0500
Message-ID: <20231115191637.896027852@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chancel Liu <chancel.liu@nxp.com>

[ Upstream commit 3efcb471f871cc095841d411f98c593228ecbac6 ]

The commit 1da681e52853 ("ASoC: soc-pcm.c: Clear DAIs parameters after
stream_active is updated") tries to make sure DAI parameters can be
cleared properly through moving the cleanup to the place where stream
active status is updated. However, it will cause the cleanup only
happening in soc_pcm_close().

Suppose a case: aplay -Dhw:0 44100.wav 48000.wav. The case calls
soc_pcm_open()->soc_pcm_hw_params()->soc_pcm_hw_free()->
soc_pcm_hw_params()->soc_pcm_hw_free()->soc_pcm_close() in order. The
parameters would be remained in the system even if the playback of
44100.wav is finished.

The case requires us clearing parameters in phase of soc_pcm_hw_free().
However, moving the DAI parameters cleanup back to soc_pcm_hw_free()
has the risk that DAIs parameters never be cleared if there're more
than one stream, see commit 1da681e52853 ("ASoC: soc-pcm.c: Clear DAIs
parameters after stream_active is updated") for more details.

To meet all these requirements, in addition to do DAI parameters
cleanup in soc_pcm_hw_free(), also check it in soc_pcm_close() to make
sure DAI parameters cleared if the DAI becomes inactive.

Fixes: 1da681e52853 ("ASoC: soc-pcm.c: Clear DAIs parameters after stream_active is updated")
Signed-off-by: Chancel Liu <chancel.liu@nxp.com>
Link: https://lore.kernel.org/r/20230920153621.711373-2-chancel.liu@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-pcm.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 54704250c0a2c..0a20122b3e555 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -698,14 +698,12 @@ static int soc_pcm_clean(struct snd_soc_pcm_runtime *rtd,
 
 	if (!rollback) {
 		snd_soc_runtime_deactivate(rtd, substream->stream);
-		/* clear the corresponding DAIs parameters when going to be inactive */
-		for_each_rtd_dais(rtd, i, dai) {
-			if (snd_soc_dai_active(dai) == 0)
-				soc_pcm_set_dai_params(dai, NULL);
 
-			if (snd_soc_dai_stream_active(dai, substream->stream) == 0)
-				snd_soc_dai_digital_mute(dai, 1, substream->stream);
-		}
+		/* Make sure DAI parameters cleared if the DAI becomes inactive */
+		for_each_rtd_dais(rtd, i, dai)
+			if (snd_soc_dai_active(dai) == 0 &&
+			    (dai->rate || dai->channels || dai->sample_bits))
+				soc_pcm_set_dai_params(dai, NULL);
 	}
 
 	for_each_rtd_dais(rtd, i, dai)
@@ -936,6 +934,15 @@ static int soc_pcm_hw_clean(struct snd_soc_pcm_runtime *rtd,
 
 	snd_soc_dpcm_mutex_assert_held(rtd);
 
+	/* clear the corresponding DAIs parameters when going to be inactive */
+	for_each_rtd_dais(rtd, i, dai) {
+		if (snd_soc_dai_active(dai) == 1)
+			soc_pcm_set_dai_params(dai, NULL);
+
+		if (snd_soc_dai_stream_active(dai, substream->stream) == 1)
+			snd_soc_dai_digital_mute(dai, 1, substream->stream);
+	}
+
 	/* run the stream event */
 	snd_soc_dapm_stream_stop(rtd, substream->stream);
 
-- 
2.42.0



