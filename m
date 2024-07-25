Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84C619A29C;
	Thu, 25 Jul 2024 14:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918389; cv=none; b=GDRFP/yFsxXLVibpBGt/+EJEzgiTf7gpNCjyH62ue+OuqiYcGdWHVAbvhV7ipoTdg+kQ+W9WpLD0Nzlgbt9tBOTboxUvePWAvXsUbroVqta34yu0I7DPr+Yx2MxOLJu5U8YVTum+oui1+TsEcndRj2h/uQi0LBVv4Od8jk9+pGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918389; c=relaxed/simple;
	bh=QsG3dx0mBl8GtHmVd18FQH4nn5+oU887JRhCdFH/TPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQw+kLC0tJczUR2OVkWd9Ozt6psVdQ3hf4cm3lHPeCZIPvNPzpUx+1aTizUw/hbrwU6xE2If64zyHxyOXyjUR6FiMQ6EpkpX/6xbPoRB9zMqThwkrRW3AXHCFc9MHZZRkjEOKaOXhEi+HEO+rzZFP5utLRU+GzxA9nUNaVyIJgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UAey/UxE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UAey/UxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 357D1C32782;
	Thu, 25 Jul 2024 14:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918389;
	bh=QsG3dx0mBl8GtHmVd18FQH4nn5+oU887JRhCdFH/TPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UAey/UxEKDsSMk2S9W1BirqXZDR1PfKVZD761npLRvDzf98yerUQdLwGlUl/92e1d
	 OnQ/b3sCnckRsrWFCHwIFGjPEEa1FX2QLcbNFa8zBQ4EcfXMt5g+MuqRXpwVmD/Wv0
	 +f6yc+ku0rBes20HOJX2cbwstAOq2C8cUBUk93G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 27/29] ALSA: pcm_dmaengine: Dont synchronize DMA channel when DMA is paused
Date: Thu, 25 Jul 2024 16:36:43 +0200
Message-ID: <20240725142732.835497220@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142731.814288796@linuxfoundation.org>
References: <20240725142731.814288796@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


