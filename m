Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767C5136672;
	Tue, 14 May 2024 11:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686990; cv=none; b=ZgZkeXxWyDNCxBeLF/1/bhabR6q7szk5pRiJ7AQTWtC51eSQt+ATxTz2LlLlJWx4yNiXKkiteMBC8MVJ/iDKp6QrSKjAvPbxwiNehoKAhOKZWTW5sjvdtHL8TZo46YehaKd/RadXmJ0EHQ9+gT7aQeIrhRmq5iWDakbh5ml5o54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686990; c=relaxed/simple;
	bh=tdk23UCMreSNmkf2YlSwCGorZW/Kot3nqQV1ffed0LY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQ1Jev8hz+1f3Ehm/xs1mf/JNbnGM1z2UYpCMGeTNtDb5/HRPiXPyhQw2H/Gxhh0fkxiR9s90tXMxQ9hTroYYPUpRwv1nytOyZfqUiKAaR9z6cxagNJxXpKpJYw6IrxpzKuYgjds22W0IifWjQse08ezHpugp01hG4220aQlj+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nf80zLay; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nf80zLay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54EDC2BD10;
	Tue, 14 May 2024 11:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686990;
	bh=tdk23UCMreSNmkf2YlSwCGorZW/Kot3nqQV1ffed0LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nf80zLayqAESK7v2NL0zLrskYa7w8TDi/DpOcugXe0suITBfslQnV9Kvn21N/jGWW
	 Zr4bwIagCMKrfZy7NQB7tvaAblu+X037YpxkYv396noWQqlWgpK290E/RVfbStnf8J
	 zfBMFOm/pjPC+Fl+QNP/CctMIpuPXq+TsrClWuCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 27/84] ASoC: meson: axg-tdm-interface: manage formatters in trigger
Date: Tue, 14 May 2024 12:19:38 +0200
Message-ID: <20240514100952.719719439@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit bf5e4887eeddb48480568466536aa08ec7f179a5 ]

So far, the formatters have been reset/enabled using the .prepare()
callback. This was done in this callback because walking the formatters use
a mutex so it could not be done in .trigger(), which is atomic by default.

It turns out there is a problem on capture path of the AXG series.
The FIFO may get out of sync with the TDM decoder if the IP are not enabled
in a specific order. The FIFO must be enabled before the formatter starts
producing data. IOW, we must deal with FE before the BE. The .prepare()
callback is called on the BEs before the FE so it is not OK for the AXG.

The .trigger() callback order can be configured, and it deals with the FE
before the BEs by default. To solve our problem, we just need to start and
stop the formatters from the .trigger() callback. It is OK do so now that
the links have been made 'nonatomic' in the card driver.

Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20211020114217.133153-3-jbrunet@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/axg-tdm-interface.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/sound/soc/meson/axg-tdm-interface.c b/sound/soc/meson/axg-tdm-interface.c
index 34aff050caf25..dc2fe9e2baadd 100644
--- a/sound/soc/meson/axg-tdm-interface.c
+++ b/sound/soc/meson/axg-tdm-interface.c
@@ -351,13 +351,29 @@ static int axg_tdm_iface_hw_free(struct snd_pcm_substream *substream,
 	return 0;
 }
 
-static int axg_tdm_iface_prepare(struct snd_pcm_substream *substream,
+static int axg_tdm_iface_trigger(struct snd_pcm_substream *substream,
+				 int cmd,
 				 struct snd_soc_dai *dai)
 {
-	struct axg_tdm_stream *ts = snd_soc_dai_get_dma_data(dai, substream);
+	struct axg_tdm_stream *ts =
+		snd_soc_dai_get_dma_data(dai, substream);
+
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+	case SNDRV_PCM_TRIGGER_RESUME:
+	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+		axg_tdm_stream_start(ts);
+		break;
+	case SNDRV_PCM_TRIGGER_SUSPEND:
+	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
+	case SNDRV_PCM_TRIGGER_STOP:
+		axg_tdm_stream_stop(ts);
+		break;
+	default:
+		return -EINVAL;
+	}
 
-	/* Force all attached formatters to update */
-	return axg_tdm_stream_reset(ts);
+	return 0;
 }
 
 static int axg_tdm_iface_remove_dai(struct snd_soc_dai *dai)
@@ -397,8 +413,8 @@ static const struct snd_soc_dai_ops axg_tdm_iface_ops = {
 	.set_fmt	= axg_tdm_iface_set_fmt,
 	.startup	= axg_tdm_iface_startup,
 	.hw_params	= axg_tdm_iface_hw_params,
-	.prepare	= axg_tdm_iface_prepare,
 	.hw_free	= axg_tdm_iface_hw_free,
+	.trigger	= axg_tdm_iface_trigger,
 };
 
 /* TDM Backend DAIs */
-- 
2.43.0



