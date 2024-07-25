Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B31FFC18;
	Thu, 25 Jul 2024 14:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919042; cv=none; b=gROhTFXOdwIcpcjbVg/0aEDESdiXiQwWoIAtUWG3rPVbjPNDngIR5BDNt8d+P980q4Or/ZfZKG/yanbpZRgAPZ9reIIkDKb4Illg3gXZnqKrOXsylPNXvqKj2b9hp4f5EwSnYfKf9EyF1WfZwwUatf+5dnJbCc5pM3035ZtQMtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919042; c=relaxed/simple;
	bh=70ZZjRJA5tLmjc0enfO8tESAVi+WBx6t388KCK0vcoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gO6QzsoOSSBn2S9h75hGtTbNV832JbmkHwqCy2a+m+ittDJ0avt+ACwVXV9ZQZNsaVif7nikYFBvpL14ntj9raTLSa0kKmYnZgSqpTUjN5PSMXHk9DVr0IbKOyKpLKx4nv92QmyBnxrayg3e9G+/uoF1TXrxdgn4FKlHlCo/vIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=caNLGf9A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="caNLGf9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F56C116B1;
	Thu, 25 Jul 2024 14:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919042;
	bh=70ZZjRJA5tLmjc0enfO8tESAVi+WBx6t388KCK0vcoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=caNLGf9AGiVdSS/kjIocQvqoTxwIPmWPrNW1Q/V/NQNbeASa7D/rG1hFCgECsOl8a
	 vvZq6ftLDDARobjOsdbhcMO8GLUvrBVvfET3VoAi2ejL0sTFoXUkSgYShueUwXdNiU
	 6LbTzNUPEhr6tXdP5cTeuGQN66mm2GTyVjSXT0Fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 58/59] ALSA: pcm_dmaengine: Dont synchronize DMA channel when DMA is paused
Date: Thu, 25 Jul 2024 16:37:48 +0200
Message-ID: <20240725142735.445997715@linuxfoundation.org>
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

From: Shengjiu Wang <shengjiu.wang@nxp.com>

commit 88e98af9f4b5b0d60c1fe7f7f2701b5467691e75 upstream.

When suspended, the DMA channel may enter PAUSE state if dmaengine_pause()
is supported by DMA.
At this state, dmaengine_synchronize() should not be called, otherwise
the DMA channel can't be resumed successfully.

Fixes: e8343410ddf0 ("ALSA: dmaengine: Synchronize dma channel after drop()")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/1721198693-27636-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/pcm_dmaengine.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/sound/core/pcm_dmaengine.c
+++ b/sound/core/pcm_dmaengine.c
@@ -345,8 +345,12 @@ EXPORT_SYMBOL_GPL(snd_dmaengine_pcm_open
 int snd_dmaengine_pcm_sync_stop(struct snd_pcm_substream *substream)
 {
 	struct dmaengine_pcm_runtime_data *prtd = substream_to_prtd(substream);
+	struct dma_tx_state state;
+	enum dma_status status;
 
-	dmaengine_synchronize(prtd->dma_chan);
+	status = dmaengine_tx_status(prtd->dma_chan, prtd->cookie, &state);
+	if (status != DMA_PAUSED)
+		dmaengine_synchronize(prtd->dma_chan);
 
 	return 0;
 }


