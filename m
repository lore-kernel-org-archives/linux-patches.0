Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820C13BB11C;
	Fri, 15 May 2026 16:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861296; cv=none; b=sZ92/FaKCWHySTjmktnWUTd27lVK1oYq7kiH5F7U3O7LC5hobVLGlverO2cbyrBOCEaPVLlLQBxmNRBs6ljPfTwLWgw3aHJ8PM6iiYpXgsgmtDDcpqkZhE+iKDDg/tbALsaIekhJYp3B5pZjK6RZ8ViKKeEJ/onsIhm7fJaIbwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861296; c=relaxed/simple;
	bh=dBOfHkZjdbbLwAsSmvFIFWkdTXHaZ+1FGLemPoiYidw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hNabj3PpJmiVCfW4rIza7WzI7I5lKcoJoQlbMK9daoD13bbgnojM8rfxh1BlO0zS67TfLVrjx/J7iXFIDSjxtPq6RpzatARMuqEXAO2P7xVd4EdR5dz2Yvodfj3wLouV1iRPaqfcQ9McaxehOmAYWm/f0BtoDOmC9oiC2GxIyJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B78pwE7r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B78pwE7r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C24C2BCB0;
	Fri, 15 May 2026 16:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861296;
	bh=dBOfHkZjdbbLwAsSmvFIFWkdTXHaZ+1FGLemPoiYidw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B78pwE7rJI1F6n0f7FRpsxhT/a+TQi1icyQfoyIfacFx8arseMqNa9YzNAFLtWman
	 IpKB0DM1Pq5jxP+7w40fW8d4osbkBavnubQyFCyo6dnuj2Nt4Izcb1/4DGe4jpTLme
	 6pt1Cu6jz8u0Rtbxjow0hxkdSiWKxiIjLKvNi5M0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 247/474] ASoC: qcom: q6apm-dai: reset queue ptr on trigger stop
Date: Fri, 15 May 2026 17:45:56 +0200
Message-ID: <20260515154720.343186066@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

commit cab45ab95ce7600fc0ff84585c77fd45b7b0d67c upstream.

Reset queue pointer on SNDRV_PCM_TRIGGER_STOP event to be inline
with resetting appl_ptr. Without this we will end up with a queue_ptr
out of sync and driver could try to send data that is not ready yet.

Fix this by resetting the queue_ptr.

Fixes: 3d4a4411aa8bb ("ASoC: q6apm-dai: schedule all available frames to avoid dsp under-runs")
Cc: Stable@vger.kernel.org
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260402081118.348071-6-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6apm-dai.c |    1 +
 sound/soc/qcom/qdsp6/q6apm.c     |    2 ++
 2 files changed, 3 insertions(+)

--- a/sound/soc/qcom/qdsp6/q6apm-dai.c
+++ b/sound/soc/qcom/qdsp6/q6apm-dai.c
@@ -321,6 +321,7 @@ static int q6apm_dai_trigger(struct snd_
 	case SNDRV_PCM_TRIGGER_STOP:
 		/* TODO support be handled via SoftPause Module */
 		prtd->state = Q6APM_STREAM_STOPPED;
+		prtd->queue_ptr = 0;
 		break;
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
--- a/sound/soc/qcom/qdsp6/q6apm.c
+++ b/sound/soc/qcom/qdsp6/q6apm.c
@@ -225,6 +225,8 @@ int q6apm_map_memory_regions(struct q6ap
 
 	mutex_lock(&graph->lock);
 
+	data->dsp_buf = 0;
+
 	if (data->buf) {
 		mutex_unlock(&graph->lock);
 		return 0;


