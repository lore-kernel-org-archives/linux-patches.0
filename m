Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4575481DD;
	Sat, 30 May 2026 17:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161161; cv=none; b=mErDzo0ZWZl2x+UUAsFfzYNMLbJHgd9TQ5hPtdjamxTWVw4WEmSOm4soxEmRJeKACpKA9XvfhmJjhXs8ngaKM3sm6sUZPaAd5NFDcWhU/jsqebJ2lnu9jyEwzCmqv/liw9VizKPHV8CplrwVblCPjRgXzv8/E8au/MoBK4hkuEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161161; c=relaxed/simple;
	bh=OqjKkIxnfb3pt6RFQ+OfP7U5T/lYojDnVIPp/evMZJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TH584qx7sVa42zeaAL3NePqmS6GzhLyRcNtCGpc4U6w3cXhHSAeVuYk4sXPxLf6ILiXKmZ3IrOaJxmFS6MT9LBSLtItjnMM1KZdYiljfwIqOYumoYf9QesfkwVU/gsEe58HQ6jLXYKdGdAmM9tMw7eAlxd9HYczRPoWWaUzO52g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mu0508GE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mu0508GE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138831F00893;
	Sat, 30 May 2026 17:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161160;
	bh=54y7Xkm0TMuTc4TatSifThrfkcyS2ZdoaH1MR8XAblk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mu0508GEikEcF64r1vu0jeTEuAe4tuGpn1O+ynaTYWPw3b0L7jQA40oHdOm5UD+pO
	 ZHCIO/W3Vf6KTx1QxbeYjisH2F8mtjtLjGipW0F1ymNT475VOhZ5HKQuJBTqMetQVy
	 dnmlL/VHBD4U273uKPH2YgN0fq/toQrXFZwf+JXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	V sujith kumar Reddy <Vsujithkumar.Reddy@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 544/969] ASoC: SOF: amd: Fix for reading position updates from stream box.
Date: Sat, 30 May 2026 18:01:08 +0200
Message-ID: <20260530160315.393594011@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: V sujith kumar Reddy <Vsujithkumar.Reddy@amd.com>

[ Upstream commit aae7e412b0ec0378e392b18c50b612dae09cdb74 ]

By default the position updates are read from dsp box when streambox
size is not defined.if the streambox size is defined to some value
then position updates can be read from the streambox.

Signed-off-by: V sujith kumar Reddy <Vsujithkumar.Reddy@amd.com>
Link: https://lore.kernel.org/r/20221123121911.3446224-2-vsujithkumar.reddy@amd.corp-partner.google.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 2c4fdd055f92 ("ASoC: SOF: compress: return the configured codec from get_params")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/amd/acp-common.c |  1 +
 sound/soc/sof/amd/acp-ipc.c    | 30 +++++++++++++++++++++++++++++-
 sound/soc/sof/amd/acp.h        |  4 ++++
 3 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/amd/acp-common.c b/sound/soc/sof/amd/acp-common.c
index 27b95187356e5..150e042e40392 100644
--- a/sound/soc/sof/amd/acp-common.c
+++ b/sound/soc/sof/amd/acp-common.c
@@ -76,6 +76,7 @@ struct snd_sof_dsp_ops sof_acp_common_ops = {
 	/*IPC */
 	.send_msg		= acp_sof_ipc_send_msg,
 	.ipc_msg_data		= acp_sof_ipc_msg_data,
+	.set_stream_data_offset = acp_set_stream_data_offset,
 	.get_mailbox_offset	= acp_sof_ipc_get_mailbox_offset,
 	.get_window_offset      = acp_sof_ipc_get_window_offset,
 	.irq_thread		= acp_sof_ipc_irq_thread,
diff --git a/sound/soc/sof/amd/acp-ipc.c b/sound/soc/sof/amd/acp-ipc.c
index dd030566e3725..dd6e53c63407f 100644
--- a/sound/soc/sof/amd/acp-ipc.c
+++ b/sound/soc/sof/amd/acp-ipc.c
@@ -192,13 +192,41 @@ int acp_sof_ipc_msg_data(struct snd_sof_dev *sdev, struct snd_pcm_substream *sub
 {
 	unsigned int offset = sdev->dsp_box.offset;
 
-	if (!substream || !sdev->stream_box.size)
+	if (!substream || !sdev->stream_box.size) {
 		acp_mailbox_read(sdev, offset, p, sz);
+	} else {
+		struct acp_dsp_stream *stream = substream->runtime->private_data;
+
+		if (!stream)
+			return -ESTRPIPE;
+
+		acp_mailbox_read(sdev, stream->posn_offset, p, sz);
+	}
 
 	return 0;
 }
 EXPORT_SYMBOL_NS(acp_sof_ipc_msg_data, SND_SOC_SOF_AMD_COMMON);
 
+int acp_set_stream_data_offset(struct snd_sof_dev *sdev,
+			       struct snd_pcm_substream *substream,
+			       size_t posn_offset)
+{
+	struct acp_dsp_stream *stream = substream->runtime->private_data;
+
+	/* check for unaligned offset or overflow */
+	if (posn_offset > sdev->stream_box.size ||
+	    posn_offset % sizeof(struct sof_ipc_stream_posn) != 0)
+		return -EINVAL;
+
+	stream->posn_offset = sdev->stream_box.offset + posn_offset;
+
+	dev_dbg(sdev->dev, "pcm: stream dir %d, posn mailbox offset is %zu",
+		substream->stream, stream->posn_offset);
+
+	return 0;
+}
+EXPORT_SYMBOL_NS(acp_set_stream_data_offset, SND_SOC_SOF_AMD_COMMON);
+
 int acp_sof_ipc_get_mailbox_offset(struct snd_sof_dev *sdev)
 {
 	const struct sof_amd_acp_desc *desc = get_chip_info(sdev->pdata);
diff --git a/sound/soc/sof/amd/acp.h b/sound/soc/sof/amd/acp.h
index b1414ac1ea985..b5bbdedb66697 100644
--- a/sound/soc/sof/amd/acp.h
+++ b/sound/soc/sof/amd/acp.h
@@ -144,6 +144,7 @@ struct acp_dsp_stream {
 	int stream_tag;
 	int active;
 	unsigned int reg_offset;
+	size_t posn_offset;
 };
 
 struct sof_amd_acp_desc {
@@ -205,6 +206,9 @@ int acp_dsp_block_read(struct snd_sof_dev *sdev, enum snd_sof_fw_blk_type blk_ty
 irqreturn_t acp_sof_ipc_irq_thread(int irq, void *context);
 int acp_sof_ipc_msg_data(struct snd_sof_dev *sdev, struct snd_pcm_substream *substream,
 			 void *p, size_t sz);
+int acp_set_stream_data_offset(struct snd_sof_dev *sdev,
+			       struct snd_pcm_substream *substream,
+			       size_t posn_offset);
 int acp_sof_ipc_send_msg(struct snd_sof_dev *sdev,
 			 struct snd_sof_ipc_msg *msg);
 int acp_sof_ipc_get_mailbox_offset(struct snd_sof_dev *sdev);
-- 
2.53.0



