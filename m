Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73E61096A
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:32:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4875FC433C8;
	Mon, 19 Jun 2023 10:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170760;
	bh=DU6+SJij55ntMww0/Jxq0CoifPnqCWq9Svzfl2pTS/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IKBNo11qaSlfvlP8MuWJMNL8D+CgT9qi+ETqbxWEDwcGHRHOStNOPmaPWoBlp96EL
	 g7mqXfbxDYi2Wqbbdfh8ZGJJ8BwQ85iwEojq3tV13TBGOVGPn/YCXckvCdaRLRHzKR
	 9BTqfqUPTbvvmBqV2bIodhaHMP7rdrzeZN8Rn6Hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 026/187] ASoC: soc-pcm: test if a BE can be prepared
Date: Mon, 19 Jun 2023 12:27:24 +0200
Message-ID: <20230619102158.909619921@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

[ Upstream commit e123036be377ddf628226a7c6d4f9af5efd113d3 ]

In the BE hw_params configuration, the existing code checks if any of the
existing FEs are prepared, running, paused or suspended - and skips the
configuration in those cases. This allows multiple calls of hw_params
which the ALSA state machine supports.

This check is not handled for the prepare stage, which can lead to the
same BE being prepared multiple times. This patch adds a check similar to
that of the hw_params, with the main difference being that the suspended
state is allowed: the ALSA state machine allows a transition from
suspended to prepared with hw_params skipped.

This problem was detected on Intel IPC4/SoundWire devices, where the BE
dailink .prepare stage is used to configure the SoundWire stream with a
bank switch. Multiple .prepare calls lead to conflicts with the .trigger
operation with IPC4 configurations. This problem was not detected earlier
on Intel devices, HDaudio BE dailinks detect that the link is already
prepared and skip the configuration, and for IPC3 devices there is no BE
trigger.

Link: https://github.com/thesofproject/sof/issues/7596
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com
Link: https://lore.kernel.org/r/20230517185731.487124-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc-dpcm.h |  4 ++++
 sound/soc/soc-pcm.c      | 20 ++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/sound/soc-dpcm.h b/include/sound/soc-dpcm.h
index 1e7d09556fe3e..b7bc1865b9e4a 100644
--- a/include/sound/soc-dpcm.h
+++ b/include/sound/soc-dpcm.h
@@ -123,6 +123,10 @@ int snd_soc_dpcm_can_be_free_stop(struct snd_soc_pcm_runtime *fe,
 int snd_soc_dpcm_can_be_params(struct snd_soc_pcm_runtime *fe,
 		struct snd_soc_pcm_runtime *be, int stream);
 
+/* can this BE perform prepare */
+int snd_soc_dpcm_can_be_prepared(struct snd_soc_pcm_runtime *fe,
+				 struct snd_soc_pcm_runtime *be, int stream);
+
 /* is the current PCM operation for this FE ? */
 int snd_soc_dpcm_fe_can_update(struct snd_soc_pcm_runtime *fe, int stream);
 
diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 7958c9defd492..1db82501fec18 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -2417,6 +2417,9 @@ int dpcm_be_dai_prepare(struct snd_soc_pcm_runtime *fe, int stream)
 		if (!snd_soc_dpcm_be_can_update(fe, be, stream))
 			continue;
 
+		if (!snd_soc_dpcm_can_be_prepared(fe, be, stream))
+			continue;
+
 		if ((be->dpcm[stream].state != SND_SOC_DPCM_STATE_HW_PARAMS) &&
 		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_STOP) &&
 		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_SUSPEND) &&
@@ -3057,3 +3060,20 @@ int snd_soc_dpcm_can_be_params(struct snd_soc_pcm_runtime *fe,
 	return snd_soc_dpcm_check_state(fe, be, stream, state, ARRAY_SIZE(state));
 }
 EXPORT_SYMBOL_GPL(snd_soc_dpcm_can_be_params);
+
+/*
+ * We can only prepare a BE DAI if any of it's FE are not prepared,
+ * running or paused for the specified stream direction.
+ */
+int snd_soc_dpcm_can_be_prepared(struct snd_soc_pcm_runtime *fe,
+				 struct snd_soc_pcm_runtime *be, int stream)
+{
+	const enum snd_soc_dpcm_state state[] = {
+		SND_SOC_DPCM_STATE_START,
+		SND_SOC_DPCM_STATE_PAUSED,
+		SND_SOC_DPCM_STATE_PREPARE,
+	};
+
+	return snd_soc_dpcm_check_state(fe, be, stream, state, ARRAY_SIZE(state));
+}
+EXPORT_SYMBOL_GPL(snd_soc_dpcm_can_be_prepared);
-- 
2.39.2



