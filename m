Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBF32DFF0E;
	Tue, 17 Jun 2025 16:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176393; cv=none; b=R7wiS5VyQPuKftENgkvIbq2RSLP9BxO9GReEnQ244ojO951+N855A55Br2HRyrRdK/yjeYWG2NFLI0OZ+CrIQY09FjE4EOk53DcldbutnifSLCycvvfUyjmEv88rEhmC0VThjktyiOqbUvseS0w9/egHTs1wDGmPcuB5bqY/Ows=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176393; c=relaxed/simple;
	bh=xW4nolXN0jaIvHbemW+VDjTf7CNlrys/4GKxoEtKEuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9PhXOX/GQXBpTCm8oqOsPMhF7/gk1E6XL8scU48htz2hUQOkZ1FQ9EUdD82Nf51UvIfwWdyn1T/Rz24qMG2KjqHOAlZbE2B2tvgfE5XdYFOvAd+xYuiUDtitPi8qrviK4aSlxroU0zRP+taMLQFP84fZPA+K2Y+UiXb3y7wxjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DpKqtD68; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DpKqtD68"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E195C4CEE3;
	Tue, 17 Jun 2025 16:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176392;
	bh=xW4nolXN0jaIvHbemW+VDjTf7CNlrys/4GKxoEtKEuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DpKqtD68mGZKbpjRZ8LFPG4Aw4VKyJQfn7Nx5pYnZEfRPXE2sM4VkDT3rQFhftbK6
	 dxu554fDNaVjbo4i20QVktv+eeE8PD5PUDxHNZ0LQXLmXrBVII9mmWlyQzh0LIqnpq
	 c3UWdqeVCAPr9rGbLSRx9LNLqOW4aag3jGy21B7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuuki NAGAO <wf.yn386@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 273/356] ASoC: ti: omap-hdmi: Re-add dai_link->platform to fix card init
Date: Tue, 17 Jun 2025 17:26:28 +0200
Message-ID: <20250617152349.186943667@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yuuki NAGAO <wf.yn386@gmail.com>

[ Upstream commit bae071aa7bcd034054cec91666c80f812adeccd9 ]

The removed dai_link->platform component cause a fail which
is exposed at runtime. (ex: when a sound tool is used)
This patch re-adds the dai_link->platform component to have
a full card registered.

Before this patch:
$ aplay -l
**** List of PLAYBACK Hardware Devices ****
card 1: HDMI [HDMI], device 0: HDMI snd-soc-dummy-dai-0 []
  Subdevices: 1/1
  Subdevice #0: subdevice #0

$ speaker-test -D plughw:1,0 -t sine
speaker-test 1.2.8
Playback device is plughw:1,0
Stream parameters are 48000Hz, S16_LE, 1 channels
Sine wave rate is 440.0000Hz
Playback open error: -22,Invalid argument

After this patch which restores the platform component:
$ aplay -l
**** List of PLAYBACK Hardware Devices ****
card 0: HDMI [HDMI], device 0: HDMI snd-soc-dummy-dai-0 [HDMI snd-soc-dummy-dai-0]
  Subdevices: 0/1
  Subdevice #0: subdevice #0

-> Resolve the playback error.

Fixes: 3b0db249cf8f ("ASoC: ti: remove unnecessary dai_link->platform")

Signed-off-by: Yuuki NAGAO <wf.yn386@gmail.com>
Link: https://patch.msgid.link/20250531141341.81164-1-wf.yn386@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ti/omap-hdmi.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/soc/ti/omap-hdmi.c b/sound/soc/ti/omap-hdmi.c
index 0a731b21e5a58..72fabf22a02ee 100644
--- a/sound/soc/ti/omap-hdmi.c
+++ b/sound/soc/ti/omap-hdmi.c
@@ -361,17 +361,20 @@ static int omap_hdmi_audio_probe(struct platform_device *pdev)
 	if (!card->dai_link)
 		return -ENOMEM;
 
-	compnent = devm_kzalloc(dev, sizeof(*compnent), GFP_KERNEL);
+	compnent = devm_kzalloc(dev, 2 * sizeof(*compnent), GFP_KERNEL);
 	if (!compnent)
 		return -ENOMEM;
-	card->dai_link->cpus		= compnent;
+	card->dai_link->cpus		= &compnent[0];
 	card->dai_link->num_cpus	= 1;
 	card->dai_link->codecs		= &asoc_dummy_dlc;
 	card->dai_link->num_codecs	= 1;
+	card->dai_link->platforms	= &compnent[1];
+	card->dai_link->num_platforms	= 1;
 
 	card->dai_link->name = card->name;
 	card->dai_link->stream_name = card->name;
 	card->dai_link->cpus->dai_name = dev_name(ad->dssdev);
+	card->dai_link->platforms->name = dev_name(ad->dssdev);
 	card->num_links = 1;
 	card->dev = dev;
 
-- 
2.39.5



