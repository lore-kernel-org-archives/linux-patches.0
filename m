Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED52F1BDF1;
	Wed,  3 Jan 2024 17:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ruamp1g2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC03C433C7;
	Wed,  3 Jan 2024 17:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301564;
	bh=YI1W9As392b1qFrc2ACkqs0gaoHWdY2QH9FQoBErVOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ruamp1g2ekGw7KHopOHDOQNUJo6fKmXScxt604/lc+WFFZ8Vk89GX4qrwHAfV3pZC
	 vXfwjiRR7z5XpDOEul16/4S6t+aJZ8kc+G+3B1G6Fmy+Y5knm69gxtkWlXaj1IoSCg
	 g60uKbAjFya+f7UO8WeqRO5IyWNGIxghS0JtUQIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengqiao Xia <xiazhengqiao@huaqin.corp-partner.google.com>,
	Hsin-Yi Wang <hsinyi@google.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 25/95] ASoC: hdmi-codec: fix missing report for jack initial status
Date: Wed,  3 Jan 2024 17:54:33 +0100
Message-ID: <20240103164857.879782899@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164853.921194838@linuxfoundation.org>
References: <20240103164853.921194838@linuxfoundation.org>
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

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 025222a9d6d25eee2ad9a1bb5a8b29b34b5ba576 ]

This fixes a problem introduced while fixing ELD reporting with no jack
set.

Most driver using the hdmi-codec will call the 'plugged_cb' callback
directly when registered to report the initial state of the HDMI connector.

With the commit mentionned, this occurs before jack is ready and the
initial report is lost for platforms actually providing a jack for HDMI.

Fix this by storing the hdmi connector status regardless of jack being set
or not and report the last status when jack gets set.

With this, the initial state is reported correctly even if it is
disconnected. This was not done initially and is also a fix.

Fixes: 15be353d55f9 ("ASoC: hdmi-codec: register hpd callback on component probe")
Reported-by: Zhengqiao Xia <xiazhengqiao@huaqin.corp-partner.google.com>
Closes: https://lore.kernel.org/alsa-devel/CADYyEwTNyY+fR9SgfDa-g6iiDwkU3MUdPVCYexs2_3wbcM8_vg@mail.gmail.com/
Cc: Hsin-Yi Wang <hsinyi@google.com>
Tested-by: Zhengqiao Xia <xiazhengqiao@huaqin.corp-partner.google.com>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://msgid.link/r/20231218145655.134929-1-jbrunet@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/hdmi-codec.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/hdmi-codec.c b/sound/soc/codecs/hdmi-codec.c
index 0a7e2f8ca71af..410fb59807f1b 100644
--- a/sound/soc/codecs/hdmi-codec.c
+++ b/sound/soc/codecs/hdmi-codec.c
@@ -843,8 +843,9 @@ static int hdmi_dai_probe(struct snd_soc_dai *dai)
 static void hdmi_codec_jack_report(struct hdmi_codec_priv *hcp,
 				   unsigned int jack_status)
 {
-	if (hcp->jack && jack_status != hcp->jack_status) {
-		snd_soc_jack_report(hcp->jack, jack_status, SND_JACK_LINEOUT);
+	if (jack_status != hcp->jack_status) {
+		if (hcp->jack)
+			snd_soc_jack_report(hcp->jack, jack_status, SND_JACK_LINEOUT);
 		hcp->jack_status = jack_status;
 	}
 }
@@ -873,6 +874,13 @@ static int hdmi_codec_set_jack(struct snd_soc_component *component,
 
 	if (hcp->hcd.ops->hook_plugged_cb) {
 		hcp->jack = jack;
+
+		/*
+		 * Report the initial jack status which may have been provided
+		 * by the parent hdmi driver while the hpd hook was registered.
+		 */
+		snd_soc_jack_report(jack, hcp->jack_status, SND_JACK_LINEOUT);
+
 		return 0;
 	}
 
-- 
2.43.0



