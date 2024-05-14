Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2817E13D277;
	Tue, 14 May 2024 11:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686824; cv=none; b=NIAosUC6pRWCquMyMgTeO+aeEVhCbecjsPVN8amtMncbHIm1MBe2zpSMerSlANC9PnEmcrDxZhiiji629hRl7/ofaz4wV/PONysRysNCNJevFC4em2NaYKfVGO07Nx2lwnZsGcUFgqQLyS/39pTQDyo+Ba7gpWFKUhCsZfApgow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686824; c=relaxed/simple;
	bh=Sb8nnKnpB+BlFpDUNGQHWxFnVAitboSnMPts2G1hcKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=liwUlvVymwGZbm81IpL6+R44Nn0ebUy60hU03+8X+dJhi0g74aD/Q5ZysQPoI8rkfQBDKN7CvYWaq59bPIhMHR94zXMNowqoaN3mlcy2j3b8Zn4dg6CSqdikethQBKwUC6Ovqdo6jglZKg8kub7b1hTiVx2kH2Ex0yWg3OubIf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CpWIX93W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CpWIX93W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B59C2BD10;
	Tue, 14 May 2024 11:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686824;
	bh=Sb8nnKnpB+BlFpDUNGQHWxFnVAitboSnMPts2G1hcKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CpWIX93W5RAD9vxPP/0kugpsO/RE6AF0y4worJ3qi1WXjqmYL7nhqVaa8q0XDKV6F
	 wshyZaOEdvX8p6MKJbp2IsKWPFYElvDlFNEf3DQFuUn5jXeBn3GT/IAMlnRgNhoRm/
	 6HNBk7OqQOiwoS0277JWmT5ZBP4MD8681HxsMUEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 17/63] ASoC: meson: axg-tdm-interface: manage formatters in trigger
Date: Tue, 14 May 2024 12:19:38 +0200
Message-ID: <20240514100948.665603800@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 2a7ea41fc49e5..05d63cd7ac8ba 100644
--- a/sound/soc/meson/axg-tdm-interface.c
+++ b/sound/soc/meson/axg-tdm-interface.c
@@ -343,13 +343,29 @@ static int axg_tdm_iface_hw_free(struct snd_pcm_substream *substream,
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
@@ -389,8 +405,8 @@ static const struct snd_soc_dai_ops axg_tdm_iface_ops = {
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



