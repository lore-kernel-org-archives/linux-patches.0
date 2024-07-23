Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD68156F29;
	Tue, 23 Jul 2024 18:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759291; cv=none; b=U1Q8ACx8V6hMSjLqQ47KtO5HFnp2Orhw2pMLttFKYpvxCO6/N+S8s0Oh+37zDTvBbfFv0XW0sc2nHizxVaLA3AfQrERp3FQ6zYo6YCth2xV6af/MlcwizwzLPi3lCHKYUQOlwzn+vZVf8w6op4NKCgcUTr0Fv9+XQRxP82ijNag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759291; c=relaxed/simple;
	bh=N5TzJmOdEt9EboksZBS669TliK5Tu7JibZLbUCD7q3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KU5T6pDmSuJy5au1fsOVc2ec4/00F+TJ3dp4019C5aP916Lim7SFWNHSQdzvxiJwiue5p3LB2vo5IN+zDSUPq6VhGTXDSEEOAyI3VNAgAsjTJ2U5Keam6y/MVuqGOiHzm+DrvlGpncG3cw8qAf8j2IokrKedoGu/XjSJFAQm+1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z1X1aMb4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z1X1aMb4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7299C4AF09;
	Tue, 23 Jul 2024 18:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759291;
	bh=N5TzJmOdEt9EboksZBS669TliK5Tu7JibZLbUCD7q3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z1X1aMb4PRz56uNhaPWplYU55F4et2gNzm/JfJMqej4wdpHfb3QbJSocNIMroyRyM
	 eT99Bm9wkM2SPAvUl9wCvu+j3W60IcM5p3JPBe5BidfLf7D59ZVcCpVi2kUMB7OQ3S
	 4cdHQ/wlUbecUZRgya0d5uk4UMOYpe7B+QuVi7/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Jai Luthra <j-luthra@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/105] ALSA: dmaengine: Synchronize dma channel after drop()
Date: Tue, 23 Jul 2024 20:23:36 +0200
Message-ID: <20240723180405.524475806@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jai Luthra <j-luthra@ti.com>

[ Upstream commit e8343410ddf08fc36a9b9cc7c51a4e53a262d4c6 ]

Sometimes the stream may be stopped due to XRUN events, in which case
the userspace can call snd_pcm_drop() and snd_pcm_prepare() to stop and
start the stream again.

In these cases, we must wait for the DMA channel to synchronize before
marking the stream as prepared for playback, as the DMA channel gets
stopped by drop() without any synchronization. Make sure the ALSA core
synchronizes the DMA channel by adding a sync_stop() hook.

Reviewed-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Signed-off-by: Jai Luthra <j-luthra@ti.com>
Link: https://lore.kernel.org/r/20240611-asoc_next-v3-1-fcfd84b12164@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/dmaengine_pcm.h         |  1 +
 sound/core/pcm_dmaengine.c            | 10 ++++++++++
 sound/soc/soc-generic-dmaengine-pcm.c |  8 ++++++++
 3 files changed, 19 insertions(+)

diff --git a/include/sound/dmaengine_pcm.h b/include/sound/dmaengine_pcm.h
index 2df54cf02cb33..74b8ef419d4fa 100644
--- a/include/sound/dmaengine_pcm.h
+++ b/include/sound/dmaengine_pcm.h
@@ -36,6 +36,7 @@ snd_pcm_uframes_t snd_dmaengine_pcm_pointer_no_residue(struct snd_pcm_substream
 int snd_dmaengine_pcm_open(struct snd_pcm_substream *substream,
 	struct dma_chan *chan);
 int snd_dmaengine_pcm_close(struct snd_pcm_substream *substream);
+int snd_dmaengine_pcm_sync_stop(struct snd_pcm_substream *substream);
 
 int snd_dmaengine_pcm_open_request_chan(struct snd_pcm_substream *substream,
 	dma_filter_fn filter_fn, void *filter_data);
diff --git a/sound/core/pcm_dmaengine.c b/sound/core/pcm_dmaengine.c
index 494ec0c207fad..d142609570347 100644
--- a/sound/core/pcm_dmaengine.c
+++ b/sound/core/pcm_dmaengine.c
@@ -349,6 +349,16 @@ int snd_dmaengine_pcm_open_request_chan(struct snd_pcm_substream *substream,
 }
 EXPORT_SYMBOL_GPL(snd_dmaengine_pcm_open_request_chan);
 
+int snd_dmaengine_pcm_sync_stop(struct snd_pcm_substream *substream)
+{
+	struct dmaengine_pcm_runtime_data *prtd = substream_to_prtd(substream);
+
+	dmaengine_synchronize(prtd->dma_chan);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(snd_dmaengine_pcm_sync_stop);
+
 /**
  * snd_dmaengine_pcm_close - Close a dmaengine based PCM substream
  * @substream: PCM substream
diff --git a/sound/soc/soc-generic-dmaengine-pcm.c b/sound/soc/soc-generic-dmaengine-pcm.c
index 3b99f619e37eb..bece8927b056c 100644
--- a/sound/soc/soc-generic-dmaengine-pcm.c
+++ b/sound/soc/soc-generic-dmaengine-pcm.c
@@ -318,6 +318,12 @@ static int dmaengine_copy_user(struct snd_soc_component *component,
 	return 0;
 }
 
+static int dmaengine_pcm_sync_stop(struct snd_soc_component *component,
+				   struct snd_pcm_substream *substream)
+{
+	return snd_dmaengine_pcm_sync_stop(substream);
+}
+
 static const struct snd_soc_component_driver dmaengine_pcm_component = {
 	.name		= SND_DMAENGINE_PCM_DRV_NAME,
 	.probe_order	= SND_SOC_COMP_ORDER_LATE,
@@ -327,6 +333,7 @@ static const struct snd_soc_component_driver dmaengine_pcm_component = {
 	.trigger	= dmaengine_pcm_trigger,
 	.pointer	= dmaengine_pcm_pointer,
 	.pcm_construct	= dmaengine_pcm_new,
+	.sync_stop	= dmaengine_pcm_sync_stop,
 };
 
 static const struct snd_soc_component_driver dmaengine_pcm_component_process = {
@@ -339,6 +346,7 @@ static const struct snd_soc_component_driver dmaengine_pcm_component_process = {
 	.pointer	= dmaengine_pcm_pointer,
 	.copy_user	= dmaengine_copy_user,
 	.pcm_construct	= dmaengine_pcm_new,
+	.sync_stop	= dmaengine_pcm_sync_stop,
 };
 
 static const char * const dmaengine_pcm_dma_channel_names[] = {
-- 
2.43.0



