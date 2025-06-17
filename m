Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529ED2FA622;
	Tue, 17 Jun 2025 16:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179096; cv=none; b=UmH+zSbRQKvOW8qpxGr9Yzomz1DCCdH94nK22idwk3t4aIv13arrjWaNsZw73LJDlRDwND0gCAiR98BLkgrjwVIAI7vEJVxOfGzAOjZkwVTayh1c8cn20TPbK72lDT2hDCmH18AdpfQDaVASGtDCzqBYi4IoK4MwKhI9tVxHqhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179096; c=relaxed/simple;
	bh=beexzcq9Y5Z2PZiWbNz1x0BbujIpLxzbVdBiCezc7ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXY6O5ir7VA5FsDjTEw7HdJxN06uciofrXrbs4WsYSugvwVFJaDyHcqWtfEM25KPhGnBDXcMao3RcqJiVN3bwNvvUSMeolbghgOLze5X9B6z7C06LqTYbUGpkAk5LvN9HdC49XtFzsidyZUuoTr8EJ1zlb+6SxvH+KnsXQwuhVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DKGwXuzT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DKGwXuzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6917C4CEE3;
	Tue, 17 Jun 2025 16:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179096;
	bh=beexzcq9Y5Z2PZiWbNz1x0BbujIpLxzbVdBiCezc7ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DKGwXuzT9YRpxyAT9Viu9Tuxt1uJUVSN6CeS7Ys6/VhM6Yu1PVQhNgiVxwiUYq81F
	 jggGDK27vsr+OTabprEaDc8pmzDQzsWYIoB9wtKsqbUJlGsspSo8PoQtvKvGlCGCI2
	 TZUoT98AYnWuK4JtaNHG3+eA0p2gz0TQEsbpMC5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuuki NAGAO <wf.yn386@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 647/780] ASoC: ti: omap-hdmi: Re-add dai_link->platform to fix card init
Date: Tue, 17 Jun 2025 17:25:55 +0200
Message-ID: <20250617152517.829628204@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



