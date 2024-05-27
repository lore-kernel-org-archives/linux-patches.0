Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73DE168C4;
	Mon, 27 May 2024 19:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837587; cv=none; b=lRCUeMa9Wth8abcYfxUROWYKRBIXslBEaUmh9z73JLk0ohGwuZEV4Z9M0adqOTZMj1YQxB/6UNepJ8O0yEkbmcQRX43bOsuOXKLsqUvBTIE3+7BjIM17uua1aGRxgd33n05jkj6U6zHLvU+iqFz2qgeJzk5IJ1jih9GgMLPcKxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837587; c=relaxed/simple;
	bh=jg55G0MttxSZ0/2QIPHh6OMEH8kLeEpC5Kvex8O/PYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pzkrbguyOcVyo0a8lQweISGvQ/2ZcXwMEkwcnwR26ubBn2PmoyNaDkJa++XN3LqTeJ3jS7ye+6jBfiuwlFaNZO3U2lY0livxN7t5kOQGnucEZqNFtIBvsdhn/crUybAFP5v4zpuRwBox131qxlIENSyn2uZ1XjO+7niWaOgRaQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KPjXlaFH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KPjXlaFH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF86C2BBFC;
	Mon, 27 May 2024 19:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837587;
	bh=jg55G0MttxSZ0/2QIPHh6OMEH8kLeEpC5Kvex8O/PYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KPjXlaFHJ588qbaFfEg1PbIzmwwSqINGrLdFWx9psfAdidjxvkjywdXdJF3ZrWjxX
	 d6WtiaaFGnm65oYPTwrBp8w4e4PjdJ/R3/E5my/v+RTaj6xpWZKD3jEdKcXIIT0azl
	 gIArvuIxdoNTLl70m+3/mEankIVlr0Q8mBIRXA2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday M Bhat <uday.m.bhat@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 068/493] ASoC: SOF: pcm: Restrict DSP D0i3 during S0ix to IPC3
Date: Mon, 27 May 2024 20:51:10 +0200
Message-ID: <20240527185631.978181860@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

[ Upstream commit 90a2353080eedec855d63f6aadfda14104ee9b06 ]

Introduce a new field in struct sof_ipc_pcm_ops that can be used to
restrict DSP D0i3 during S0ix suspend to IPC3. With IPC4, all streams
must be stopped before S0ix suspend.

Reviewed-by: Uday M Bhat <uday.m.bhat@intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://msgid.link/r/20240408194147.28919-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc3-pcm.c  |  1 +
 sound/soc/sof/pcm.c       | 13 ++++++-------
 sound/soc/sof/sof-audio.h |  2 ++
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/sound/soc/sof/ipc3-pcm.c b/sound/soc/sof/ipc3-pcm.c
index 330f04bcd75d2..a7cf52fd76455 100644
--- a/sound/soc/sof/ipc3-pcm.c
+++ b/sound/soc/sof/ipc3-pcm.c
@@ -409,4 +409,5 @@ const struct sof_ipc_pcm_ops ipc3_pcm_ops = {
 	.trigger = sof_ipc3_pcm_trigger,
 	.dai_link_fixup = sof_ipc3_pcm_dai_link_fixup,
 	.reset_hw_params_during_stop = true,
+	.d0i3_supported_in_s0ix = true,
 };
diff --git a/sound/soc/sof/pcm.c b/sound/soc/sof/pcm.c
index f03cee94bce62..8804e00e7251b 100644
--- a/sound/soc/sof/pcm.c
+++ b/sound/soc/sof/pcm.c
@@ -325,14 +325,13 @@ static int sof_pcm_trigger(struct snd_soc_component *component,
 			ipc_first = true;
 		break;
 	case SNDRV_PCM_TRIGGER_SUSPEND:
-		if (sdev->system_suspend_target == SOF_SUSPEND_S0IX &&
+		/*
+		 * If DSP D0I3 is allowed during S0iX, set the suspend_ignored flag for
+		 * D0I3-compatible streams to keep the firmware pipeline running
+		 */
+		if (pcm_ops && pcm_ops->d0i3_supported_in_s0ix &&
+		    sdev->system_suspend_target == SOF_SUSPEND_S0IX &&
 		    spcm->stream[substream->stream].d0i3_compatible) {
-			/*
-			 * trap the event, not sending trigger stop to
-			 * prevent the FW pipelines from being stopped,
-			 * and mark the flag to ignore the upcoming DAPM
-			 * PM events.
-			 */
 			spcm->stream[substream->stream].suspend_ignored = true;
 			return 0;
 		}
diff --git a/sound/soc/sof/sof-audio.h b/sound/soc/sof/sof-audio.h
index 85b26e3fefa8f..05e2a899d746c 100644
--- a/sound/soc/sof/sof-audio.h
+++ b/sound/soc/sof/sof-audio.h
@@ -116,6 +116,7 @@ struct snd_sof_dai_config_data {
  *				  triggers. The FW keeps the host DMA running in this case and
  *				  therefore the host must do the same and should stop the DMA during
  *				  hw_free.
+ * @d0i3_supported_in_s0ix: Allow DSP D0I3 during S0iX
  */
 struct sof_ipc_pcm_ops {
 	int (*hw_params)(struct snd_soc_component *component, struct snd_pcm_substream *substream,
@@ -135,6 +136,7 @@ struct sof_ipc_pcm_ops {
 	bool reset_hw_params_during_stop;
 	bool ipc_first_on_start;
 	bool platform_stop_during_hw_free;
+	bool d0i3_supported_in_s0ix;
 };
 
 /**
-- 
2.43.0



