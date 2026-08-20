Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBDA377A89;
	Thu, 20 Aug 2026 15:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239261; cv=none; b=sN43auIOfxZIfnQ0GY9CEXreHDg6B1LflcuuBcus2WJgCJTh+77q3WErCOnKtmNgSjYyuac2vwlyxk6ahsXo9nZxeTv6JByox8C4gW884q5xkh+m+VgX87GueH0MEJdFSPUz2hF5Q1CT22IV4KHF51mjPWeu89Y05PociiV3z6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239261; c=relaxed/simple;
	bh=ckCkJ0JqskxhEqD6DzUkLO0VWgNfZEEgrthfU4m8Ajo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxpqIHWicOWapD4IAwVHyAxnRWcw3X3e+jEUzjm63hUYV7psF8JFkM0H0w73vyPxvNveEMtRJ0tB7ClnaORNrMVYCzNUaaT+h8EaiUHV4MktYxNkB6N4jI/UWuXqZgXM/nwPRoE4rBrlv6sRPjJbw9jT+UJvktfVx89yV4byyLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NtdlCqD0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NtdlCqD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246711F000E9;
	Thu, 20 Aug 2026 15:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239259;
	bh=/laNU3Vf5NYOqmLdJ4VLZ9t3PYNrRFvi6B4+Q01ZF4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NtdlCqD0W/gdDZnxm49iOdj4juX+UuHEBhulzijUfdA93DLUxveyzaXjvVBNY0ZwT
	 VEchYZDB0+hsWmledcPbxbR3OOHal3GzZF26C0xj6QuHZThf+HFn1WMU9zGwIfI4N0
	 mj/kJidnERhZ76py3nPAKcEM09dW05yfzjG1V8gQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 166/217] ASoC: SOF: ipc4-topology: Refresh copier IPC payload before widget setup
Date: Thu, 20 Aug 2026 16:55:34 +0200
Message-ID: <20260820145242.744503945@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 0c0e418dbcf0582bf80d8dbfd9b306607c065992 upstream.

The ipc_config_data buffer for copier widgets is built once during
ipc_prepare (called from sof_pcm_setup_connected_widgets) and cached
for reuse. For host copiers this buffer contains the copier_data with
gtw_cfg.node_id (host DMA ID). For DAI copiers it additionally includes
a dma_config_tlv trailer with stream_id and dma_channel_id for HDA link
DMA.

On suspend/resume, both host and link DMA streams are released and
re-allocated with potentially different stream tags. The underlying
copier_data and dma_config_tlv structures are correctly updated by
host_config and sdw_hda_dai_hw_params respectively. However, since the
widget list (spcm->stream[].list) persists across suspend,
sof_pcm_hw_params skips sof_pcm_setup_connected_widgets and ipc_prepare
never runs again to rebuild ipc_config_data. The stale cached payload
is then sent to firmware with boot-time DMA channel assignments, causing
DMA channel conflicts that lead to firmware errors and crashes.

Fix this by refreshing copier_data and dma_config_tlv portions of
ipc_config_data in sof_ipc4_widget_setup right before the IPC message
is sent. This ensures the payload always reflects the current DMA state
regardless of whether ipc_prepare ran.

For DAI copiers, the gtw_cfg.config_length in copier_data is temporarily
inflated to include the TLV size (matching the ipc_config_data layout)
before copying, then restored, mirroring what
sof_ipc4_prepare_copier_module does when first building the buffer.

Fixes: e9c6b118de1a ("ASoC: SOF: make dma_config_tlv be an array")
Cc: stable@vger.kernel.org
Link: https://github.com/thesofproject/sof/issues/10700
Link: https://github.com/thesofproject/sof/issues/10955
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Link: https://patch.msgid.link/20260730054822.5913-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc4-topology.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -3007,6 +3007,15 @@ static int sof_ipc4_widget_setup(struct
 		ipc_size = ipc4_copier->ipc_config_size;
 		ipc_data = ipc4_copier->ipc_config_data;
 
+		/*
+		 * Refresh copier_data in ipc_config_data for host copiers.
+		 * The node_id may have been updated by host_config after
+		 * ipc_prepare, e.g. when host stream tags change after a
+		 * suspend/resume cycle.
+		 */
+		if (swidget->id != snd_soc_dapm_buffer)
+			memcpy(ipc_data, &ipc4_copier->data, sizeof(ipc4_copier->data));
+
 		msg = &ipc4_copier->msg;
 		break;
 	}
@@ -3015,6 +3024,9 @@ static int sof_ipc4_widget_setup(struct
 	{
 		struct snd_sof_dai *dai = swidget->private;
 		struct sof_ipc4_copier *ipc4_copier = dai->private;
+		struct sof_ipc4_copier_data *copier_data;
+		u32 gtw_cfg_config_length;
+		u32 tlv_size;
 
 		pipeline = pipe_widget->private;
 		if (pipeline->use_chain_dma)
@@ -3023,6 +3035,27 @@ static int sof_ipc4_widget_setup(struct
 		ipc_size = ipc4_copier->ipc_config_size;
 		ipc_data = ipc4_copier->ipc_config_data;
 
+		/*
+		 * Refresh copier_data and dma_config_tlv in ipc_config_data.
+		 * These may have been updated after ipc_prepare, e.g. when
+		 * link DMA stream tags change after a suspend/resume cycle.
+		 *
+		 * copier_data->gtw_cfg.config_length does not include the
+		 * TLV size (it was restored after sof_ipc4_prepare_copier_module),
+		 * so temporarily inflate it to match the ipc_config_data layout.
+		 */
+		copier_data = &ipc4_copier->data;
+		gtw_cfg_config_length = copier_data->gtw_cfg.config_length * 4;
+		tlv_size = ipc_size - sizeof(*copier_data) - gtw_cfg_config_length;
+
+		copier_data->gtw_cfg.config_length += tlv_size / 4;
+		memcpy(ipc_data, copier_data, sizeof(*copier_data));
+		copier_data->gtw_cfg.config_length = gtw_cfg_config_length / 4;
+
+		if (tlv_size)
+			memcpy(ipc_data + sizeof(*copier_data) + gtw_cfg_config_length,
+			       &ipc4_copier->dma_config_tlv, tlv_size);
+
 		msg = &ipc4_copier->msg;
 		break;
 	}


