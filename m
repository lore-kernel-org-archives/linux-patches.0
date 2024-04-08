Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137537E0F0;
	Mon,  8 Apr 2024 13:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583731; cv=none; b=Fz0wIufNucOj3XRSGaLNbY1iH8s62sVS4keJszCzGJNgL+bTjmywYAra0xWHWwZnCLzEArNCBo0PosCl8jbyzAit4TGXrsVgK/sk7yMynSFBibDvi/4T0HGDRsOc4dBKHtgb05PAFcM+JovKdF+n0iVg2wk9+dmH0I2ovLiSCHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583731; c=relaxed/simple;
	bh=46RYZRMPS0lp5irXPUp5ADvDzj4MyNC7oPoxjQMCxJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZSfGkQKCNNpUrIRlSZcME77dDnmDCt1YrBhJ0MQHH0fIK5Y/gCFEYhW13sjBeuQB8UMeLCqGfSTJEgZud+Up2OD1+zRLc0idzKAVKuPkAWly6SOMpxCHOIiqIj9eBar/mjH/Ew93dY8uhGZs7QVyPLJVJbwyqA7So9lY9QrjYXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=De0s1A6l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="De0s1A6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504F8C433F1;
	Mon,  8 Apr 2024 13:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583730;
	bh=46RYZRMPS0lp5irXPUp5ADvDzj4MyNC7oPoxjQMCxJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=De0s1A6lTY/uHQ3YH71zK/GX3udKV/KcmT5ixSwoxuadarLu2F8O32NflDrj3AyJS
	 CHnwZwDutrnZeYgtE14W6WjhjqQ+p0stskUV2ipWTmwMi6Og3ELIp/aRpfM78hZt5m
	 YDSnRV3t9quGTu2VpFkHMe952KMMTQqJwEKX+ZRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.8 213/273] ASoC: SOF: ipc4-topology: Save the DMA maximum burst size for PCMs
Date: Mon,  8 Apr 2024 14:58:08 +0200
Message-ID: <20240408125315.982378389@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 842bb8b62cc6f3546d61eb63115b32ebc6dd4a87 upstream.

When setting up the pcm widget, save the DSP buffer size (in ms) for
platform code to place a constraint on playback.

On playback the DMA will fill the buffer on start and if the period
size is smaller it will immediately overrun.

On capture the DMA will move data in 1ms bursts.

Cc: stable@vger.kernel.org # 6.8
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://msgid.link/r/20240321130814.4412-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc4-topology.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/ipc4-topology.c b/sound/soc/sof/ipc4-topology.c
index da4a83afb87a..bb4cf6dd1e18 100644
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -412,8 +412,9 @@ static int sof_ipc4_widget_setup_pcm(struct snd_sof_widget *swidget)
 	struct sof_ipc4_available_audio_format *available_fmt;
 	struct snd_soc_component *scomp = swidget->scomp;
 	struct sof_ipc4_copier *ipc4_copier;
+	struct snd_sof_pcm *spcm;
 	int node_type = 0;
-	int ret;
+	int ret, dir;
 
 	ipc4_copier = kzalloc(sizeof(*ipc4_copier), GFP_KERNEL);
 	if (!ipc4_copier)
@@ -447,6 +448,25 @@ static int sof_ipc4_widget_setup_pcm(struct snd_sof_widget *swidget)
 	}
 	dev_dbg(scomp->dev, "host copier '%s' node_type %u\n", swidget->widget->name, node_type);
 
+	spcm = snd_sof_find_spcm_comp(scomp, swidget->comp_id, &dir);
+	if (!spcm)
+		goto skip_gtw_cfg;
+
+	if (dir == SNDRV_PCM_STREAM_PLAYBACK) {
+		struct snd_sof_pcm_stream *sps = &spcm->stream[dir];
+
+		sof_update_ipc_object(scomp, &sps->dsp_max_burst_size_in_ms,
+				      SOF_COPIER_DEEP_BUFFER_TOKENS,
+				      swidget->tuples,
+				      swidget->num_tuples, sizeof(u32), 1);
+		/* Set default DMA buffer size if it is not specified in topology */
+		if (!sps->dsp_max_burst_size_in_ms)
+			sps->dsp_max_burst_size_in_ms = SOF_IPC4_MIN_DMA_BUFFER_SIZE;
+	} else {
+		/* Capture data is copied from DSP to host in 1ms bursts */
+		spcm->stream[dir].dsp_max_burst_size_in_ms = 1;
+	}
+
 skip_gtw_cfg:
 	ipc4_copier->gtw_attr = kzalloc(sizeof(*ipc4_copier->gtw_attr), GFP_KERNEL);
 	if (!ipc4_copier->gtw_attr) {
-- 
2.44.0



