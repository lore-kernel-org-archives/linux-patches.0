Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B906611A;
	Sat, 30 Dec 2023 12:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XFPKjmXH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8836C433C7;
	Sat, 30 Dec 2023 12:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938139;
	bh=ndT55241ZEdB/Z9jZa/6vUbDjdZeEGF7H62km5CQrYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XFPKjmXH1SY4pBXiJhifIViE6iIoDgq41Xu9TO0MbvmrVF8WviANMkmtirOnkrym5
	 fnpdGK/7b4fQA+7swAQT/y4N9cmZWoY7W1/8IqNeeerBDrH/Qgg+22iUTfyc8AxJG1
	 3l2joho/e+G/fDmYuShwEYkGOh1696BS/7SYH5pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengqiao Xia <xiazhengqiao@huaqin.corp-partner.google.com>,
	Hsin-Yi Wang <hsinyi@google.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/112] ASoC: hdmi-codec: fix missing report for jack initial status
Date: Sat, 30 Dec 2023 11:59:14 +0000
Message-ID: <20231230115808.052525763@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
References: <20231230115806.714618407@linuxfoundation.org>
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
index 4d3c3365488a2..d8259afc60b08 100644
--- a/sound/soc/codecs/hdmi-codec.c
+++ b/sound/soc/codecs/hdmi-codec.c
@@ -834,8 +834,9 @@ static int hdmi_dai_probe(struct snd_soc_dai *dai)
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
@@ -864,6 +865,13 @@ static int hdmi_codec_set_jack(struct snd_soc_component *component,
 
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



