Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295BF19CD11;
	Thu, 25 Jul 2024 14:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918693; cv=none; b=pXZZm583GNw1mdKc+YACJ1VqMgxWbSF5LWk4upKl30Z96PcrmPPMFKeWoSXyV2Matp/VsUEMajhbffa73KGH4HAOE66UB6a1lsBxYTQSpqC70OxaHoFZyLHMOBNv8GU7+5DBgFFkOXDOG0moBQwvGiRyYDqGL80Kbb9cPDcE2Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918693; c=relaxed/simple;
	bh=OKxne6J4qoskQLiLC1uYZMftrOn6Qy1b0T1Cc8RRzRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MAXhQ5LsLTbkgQ/lgNlV/bjAVHjqWaZ3gAEh5VHDsVmb5Syq4GDs/DUiaEBQAteS2dOtyk4OzkaJhRlPW25KraJjj1n12vY4BSUo1rLEr0FVqXP6wLOFgOvvtehK+JCOVolbRdmQYOWdgsJLuqyvnMuYrkjxWGxcYQmRPlnn7gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jMvyAtlj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jMvyAtlj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762AFC116B1;
	Thu, 25 Jul 2024 14:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918692;
	bh=OKxne6J4qoskQLiLC1uYZMftrOn6Qy1b0T1Cc8RRzRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jMvyAtljnpjgOD2WcBDlkgNY8ylz4kScNEtmRulwnGswIFsJRq7ek5xPEVSrr9FvW
	 qQbyd2M7+GTmnVs+IZbbKyaZITtolQ3v5lUv0hVEaOGzjtxuSSvrbvYl7ql6CPAwma
	 ikK4jIrhZVWnN3WKEmd07e4DAtgpOgPCvQEeKz/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 11/13] ALSA: pcm_dmaengine: Dont synchronize DMA channel when DMA is paused
Date: Thu, 25 Jul 2024 16:37:20 +0200
Message-ID: <20240725142728.466385861@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.029052310@linuxfoundation.org>
References: <20240725142728.029052310@linuxfoundation.org>
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
@@ -352,8 +352,12 @@ EXPORT_SYMBOL_GPL(snd_dmaengine_pcm_open
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


