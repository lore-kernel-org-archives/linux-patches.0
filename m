Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6232D8468;
	Thu, 25 Jul 2024 14:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919013; cv=none; b=L96l7/bOQ6m8+ArbtZgu/rB8IJJF+yefBJx/u8b1xcCZ/kkLRdNkuaR2zs8hBaCWcDa+5krgn/ubk616ORFdB9thntwz/q+lxq+/ER8FJ4WzQtk/h+oSpaXPGjYNt5OxYjZXQP+SP0zE53/aFRtT6VKmHo4dvxllqjcpaGNXw3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919013; c=relaxed/simple;
	bh=WQFPLNN06nFRM58jaVCGwQBSm0aX6tpvbsEBcffm6OY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uu800cDfS2HB81qRz50tqAL9+LnBv0WqgjT0DLXEOl/9a436wbPC6O6A2s1Q2S/ecdkd6lszQeSoTMRNWuLOSdbQiAUyBro9iScJU9qNHvcD5WP6qCnqRa8dbOYiRD1hl5OSWzJyO9A4kvF3h/uNLmVyiEPj4/Yg8our7gIJg8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fSqTqzRh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fSqTqzRh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D464CC116B1;
	Thu, 25 Jul 2024 14:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919013;
	bh=WQFPLNN06nFRM58jaVCGwQBSm0aX6tpvbsEBcffm6OY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fSqTqzRhGJ3A172GDwnTXvnjraPPA6vo1j+A4+TPNJINyddu63AXuEDZGw80NpBdr
	 VL0NS7YT7wFu2MjYcx0O4ATP2Bvg4vkJ35QjYnUTgr7yb6F9XTSFrAq6YJrGEfSbzK
	 cO+mo9t+jirI+TW7r+FaZihn3tasHFGJpa5opTc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Jai Luthra <j-luthra@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 25/59] ALSA: dmaengine: Synchronize dma channel after drop()
Date: Thu, 25 Jul 2024 16:37:15 +0200
Message-ID: <20240725142734.212368663@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
References: <20240725142733.262322603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8c5e38180fb04..618405da95b30 100644
--- a/include/sound/dmaengine_pcm.h
+++ b/include/sound/dmaengine_pcm.h
@@ -34,6 +34,7 @@ snd_pcm_uframes_t snd_dmaengine_pcm_pointer_no_residue(struct snd_pcm_substream
 int snd_dmaengine_pcm_open(struct snd_pcm_substream *substream,
 	struct dma_chan *chan);
 int snd_dmaengine_pcm_close(struct snd_pcm_substream *substream);
+int snd_dmaengine_pcm_sync_stop(struct snd_pcm_substream *substream);
 
 int snd_dmaengine_pcm_open_request_chan(struct snd_pcm_substream *substream,
 	dma_filter_fn filter_fn, void *filter_data);
diff --git a/sound/core/pcm_dmaengine.c b/sound/core/pcm_dmaengine.c
index be58505889a36..db22294452560 100644
--- a/sound/core/pcm_dmaengine.c
+++ b/sound/core/pcm_dmaengine.c
@@ -342,6 +342,16 @@ int snd_dmaengine_pcm_open_request_chan(struct snd_pcm_substream *substream,
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
index 9ef80a48707eb..d65dc1acff439 100644
--- a/sound/soc/soc-generic-dmaengine-pcm.c
+++ b/sound/soc/soc-generic-dmaengine-pcm.c
@@ -326,6 +326,12 @@ static int dmaengine_copy_user(struct snd_soc_component *component,
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
@@ -335,6 +341,7 @@ static const struct snd_soc_component_driver dmaengine_pcm_component = {
 	.trigger	= dmaengine_pcm_trigger,
 	.pointer	= dmaengine_pcm_pointer,
 	.pcm_construct	= dmaengine_pcm_new,
+	.sync_stop	= dmaengine_pcm_sync_stop,
 };
 
 static const struct snd_soc_component_driver dmaengine_pcm_component_process = {
@@ -347,6 +354,7 @@ static const struct snd_soc_component_driver dmaengine_pcm_component_process = {
 	.pointer	= dmaengine_pcm_pointer,
 	.copy_user	= dmaengine_copy_user,
 	.pcm_construct	= dmaengine_pcm_new,
+	.sync_stop	= dmaengine_pcm_sync_stop,
 };
 
 static const char * const dmaengine_pcm_dma_channel_names[] = {
-- 
2.43.0



