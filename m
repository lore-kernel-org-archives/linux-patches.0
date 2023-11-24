Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4162E655;
	Fri, 24 Nov 2023 18:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CG45EjfW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 995DBC433C7;
	Fri, 24 Nov 2023 18:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851201;
	bh=ABZ0sv1ZUudFE/W7eIuEA/OvjCg1y1qIYFUsKYQZ46o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CG45EjfWEcAGgpqw2kOXLtwugWHUPC2GoCLtbPNtxXs64L871K6AIXfBya7V3/dAJ
	 wQx46rt1AId4GfTSZPBSq5zirnNWs8U0uCMq1ad0emwciVGRNefG/VVx7WP2aQALGz
	 zs5syH1199yL/32PDqzJQIndHSMxYUn4Te29mcYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.5 329/491] ASoC: soc-dai: add flag to mute and unmute stream during trigger
Date: Fri, 24 Nov 2023 17:49:25 +0000
Message-ID: <20231124172034.450900602@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

commit f0220575e65abe09c09cd17826a3cdea76e8d58f upstream.

In some setups like Speaker amps which are very sensitive, ex: keeping them
unmute without actual data stream for very short duration results in a
static charge and results in pop and clicks. To minimize this, provide a way
to mute and unmute such codecs during trigger callbacks.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20231027105747.32450-2-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
[ johan: backport to v6.6.2 ]
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/sound/soc-dai.h |    1 +
 sound/soc/soc-dai.c     |    7 +++++++
 sound/soc/soc-pcm.c     |   12 ++++++++----
 3 files changed, 16 insertions(+), 4 deletions(-)

--- a/include/sound/soc-dai.h
+++ b/include/sound/soc-dai.h
@@ -355,6 +355,7 @@ struct snd_soc_dai_ops {
 
 	/* bit field */
 	unsigned int no_capture_mute:1;
+	unsigned int mute_unmute_on_trigger:1;
 };
 
 struct snd_soc_cdai_ops {
--- a/sound/soc/soc-dai.c
+++ b/sound/soc/soc-dai.c
@@ -641,6 +641,10 @@ int snd_soc_pcm_dai_trigger(struct snd_p
 			ret = soc_dai_trigger(dai, substream, cmd);
 			if (ret < 0)
 				break;
+
+			if (dai->driver->ops && dai->driver->ops->mute_unmute_on_trigger)
+				snd_soc_dai_digital_mute(dai, 0, substream->stream);
+
 			soc_dai_mark_push(dai, substream, trigger);
 		}
 		break;
@@ -651,6 +655,9 @@ int snd_soc_pcm_dai_trigger(struct snd_p
 			if (rollback && !soc_dai_mark_match(dai, substream, trigger))
 				continue;
 
+			if (dai->driver->ops && dai->driver->ops->mute_unmute_on_trigger)
+				snd_soc_dai_digital_mute(dai, 1, substream->stream);
+
 			r = soc_dai_trigger(dai, substream, cmd);
 			if (r < 0)
 				ret = r; /* use last ret */
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -896,8 +896,10 @@ static int __soc_pcm_prepare(struct snd_
 	snd_soc_dapm_stream_event(rtd, substream->stream,
 			SND_SOC_DAPM_STREAM_START);
 
-	for_each_rtd_dais(rtd, i, dai)
-		snd_soc_dai_digital_mute(dai, 0, substream->stream);
+	for_each_rtd_dais(rtd, i, dai) {
+		if (dai->driver->ops && !dai->driver->ops->mute_unmute_on_trigger)
+			snd_soc_dai_digital_mute(dai, 0, substream->stream);
+	}
 
 out:
 	return soc_pcm_ret(rtd, ret);
@@ -939,8 +941,10 @@ static int soc_pcm_hw_clean(struct snd_s
 		if (snd_soc_dai_active(dai) == 1)
 			soc_pcm_set_dai_params(dai, NULL);
 
-		if (snd_soc_dai_stream_active(dai, substream->stream) == 1)
-			snd_soc_dai_digital_mute(dai, 1, substream->stream);
+		if (snd_soc_dai_stream_active(dai, substream->stream) == 1) {
+			if (dai->driver->ops && !dai->driver->ops->mute_unmute_on_trigger)
+				snd_soc_dai_digital_mute(dai, 1, substream->stream);
+		}
 	}
 
 	/* run the stream event */


