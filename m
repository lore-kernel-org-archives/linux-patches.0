Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6867F2EA16C;
	Tue, 17 Jun 2025 16:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177903; cv=none; b=U7dz4otx3inRDYPrpRf5xZI+3+4AT7hXwSplwB3bNI3/20SB/IMaasb6BeX5Q5VrbRZzM8wUcFQ/4dziph4KkY9ntMv0zIrkoRFQ8dLD8+z+KhkrLyxVrk2diPLLHv9DIaC/lFFDFswQEjFpIRLmycfxitHAaO09TD34lQ1NB4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177903; c=relaxed/simple;
	bh=OtP2v9o1TSZg+/A52ji0CxcIiYK9RNevRLvzZHbzpWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tX8Jc/quNl/Cv7IUA35pX3seqBYgDuCjDHcM7Ds06vLuvRr5A2b0oJTSMuo9PSe9vHE1X9wONku+EE7Zi+rVOJztXfhQAX1l0iPJ3HeYkvLfZ1KlDroLgVPop1a9DDLIg29lq9hAMZUXXneLMSMPZQYh0TN8m42dEpeFywbKcp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rSUHtUxD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSUHtUxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A784C4CEE3;
	Tue, 17 Jun 2025 16:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177903;
	bh=OtP2v9o1TSZg+/A52ji0CxcIiYK9RNevRLvzZHbzpWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rSUHtUxD3i9S5ZA0Qyh7HOlT4KjniagCuThRfEadvx3FCZQROUNX/4F6Ax3UiF7ut
	 GhNAvQBO3lL2GPLkZhfF37gcquUaopAr0jBaM+yZfpB+piMaFKpp6/8iOko4yk7qvi
	 CQQ97GgaLfG8oZdD4XiizXLAPBLxFs6cdGw6+7/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuuki NAGAO <wf.yn386@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 391/512] ASoC: ti: omap-hdmi: Re-add dai_link->platform to fix card init
Date: Tue, 17 Jun 2025 17:25:57 +0200
Message-ID: <20250617152435.430882720@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cf43ac19c4a6d..55e7cb96858fc 100644
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
 	card->dai_link->codecs		= &snd_soc_dummy_dlc;
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



