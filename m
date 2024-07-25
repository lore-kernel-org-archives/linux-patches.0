Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E9D19D069;
	Thu, 25 Jul 2024 14:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919305; cv=none; b=uy0RCs41O8ay/IpyHwpLj7/ZXLQ1FioFbJusGGlqJgw5UXEymGrbtaKZtW/LFf48ctjoaa3lxq6yXxi9ZbSA2JoQaKiIsuUoxjcQZba/sfgqnaAcfsHqWnw3JDo83awB6o7lUppd9802Ms3ZYErv5ncv0pQfVNSw48GqqTXlu+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919305; c=relaxed/simple;
	bh=XFxPDBA9QDGEnWgIQ7FY9aGV4MuK7C3L+2lmfj8FSWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YEHOPKmHkQnlDHYobGrOdv2stCv/yD74tnROyAfBhEA6aMg0IJwDb+nyNpCLswe886QUVLPL8WpJoZrQ9IFXpOkkroMXH3vE09IZELHM5aygE1gIpB2GJBAUSfxJOp+wZuOmYwzFHDGeJsg31YUdVcAxX9Q5MBSSvtig0YIjkjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DVkEy7lD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DVkEy7lD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD728C116B1;
	Thu, 25 Jul 2024 14:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919305;
	bh=XFxPDBA9QDGEnWgIQ7FY9aGV4MuK7C3L+2lmfj8FSWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DVkEy7lDqLOU9uCJfmMKmXo/aU41LI++erR9Ohd/s1aaxILxkn7K0zO/qjNVzjjlW
	 TdtLmwXl76SNtHfqTHd2HJy+C2zQd7BJYDAJDIF3D+Ue8TRDkzajmt6lTMmkW6T5G4
	 TksgAIWan9jGRjngPHhOJXqZvwFp0iCtPcdeUhtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 86/87] ALSA: pcm_dmaengine: Dont synchronize DMA channel when DMA is paused
Date: Thu, 25 Jul 2024 16:37:59 +0200
Message-ID: <20240725142741.680747740@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -347,8 +347,12 @@ EXPORT_SYMBOL_GPL(snd_dmaengine_pcm_open
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


