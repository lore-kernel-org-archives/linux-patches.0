Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DF83DBA7
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQ+gaZ/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44750C433C9;
	Wed, 15 Nov 2023 20:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078514;
	bh=n6TDXw9u6GpcW+hUcXoorRq8fUtG77oPszgw1rK/2xE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wQ+gaZ/lAfQvzjGg/y8+lu03k6/cR0JH3bPNzBVDJdfkPbM3TtH9m5LmuKcyIV2cB
	 8FipPDlE0Nkb7Cfe0ygbsQIFjYn/A7kxB2mAYH3GKVcB/Ey4xqqFel0D3nT8qdAC6J
	 Al7JPVgU1HqTDarOWKXuGGtWO2ntR8JNG/tPORso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 369/379] ASoC: hdmi-codec: register hpd callback on component probe
Date: Wed, 15 Nov 2023 14:27:24 -0500
Message-ID: <20231115192706.987143280@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

[ Upstream commit 15be353d55f9e12e34f9a819f51eb41fdef5eda8 ]

The HDMI hotplug callback to the hdmi-codec is currently registered when
jack is set.

The hotplug not only serves to report the ASoC jack state but also to get
the ELD. It should be registered when the component probes instead, so it
does not depend on the card driver registering a jack for the HDMI to
properly report the ELD.

Fixes: 25ce4f2b3593 ("ASoC: hdmi-codec: Get ELD in before reporting plugged event")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20231106104013.704356-1-jbrunet@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/hdmi-codec.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/sound/soc/codecs/hdmi-codec.c b/sound/soc/codecs/hdmi-codec.c
index 0b1cdb2d60498..4d3c3365488a2 100644
--- a/sound/soc/codecs/hdmi-codec.c
+++ b/sound/soc/codecs/hdmi-codec.c
@@ -861,18 +861,13 @@ static int hdmi_codec_set_jack(struct snd_soc_component *component,
 			       void *data)
 {
 	struct hdmi_codec_priv *hcp = snd_soc_component_get_drvdata(component);
-	int ret = -ENOTSUPP;
 
 	if (hcp->hcd.ops->hook_plugged_cb) {
 		hcp->jack = jack;
-		ret = hcp->hcd.ops->hook_plugged_cb(component->dev->parent,
-						    hcp->hcd.data,
-						    plugged_cb,
-						    component->dev);
-		if (ret)
-			hcp->jack = NULL;
+		return 0;
 	}
-	return ret;
+
+	return -ENOTSUPP;
 }
 
 static int hdmi_dai_spdif_probe(struct snd_soc_dai *dai)
@@ -948,6 +943,21 @@ static int hdmi_of_xlate_dai_id(struct snd_soc_component *component,
 	return ret;
 }
 
+static int hdmi_probe(struct snd_soc_component *component)
+{
+	struct hdmi_codec_priv *hcp = snd_soc_component_get_drvdata(component);
+	int ret = 0;
+
+	if (hcp->hcd.ops->hook_plugged_cb) {
+		ret = hcp->hcd.ops->hook_plugged_cb(component->dev->parent,
+						    hcp->hcd.data,
+						    plugged_cb,
+						    component->dev);
+	}
+
+	return ret;
+}
+
 static void hdmi_remove(struct snd_soc_component *component)
 {
 	struct hdmi_codec_priv *hcp = snd_soc_component_get_drvdata(component);
@@ -958,6 +968,7 @@ static void hdmi_remove(struct snd_soc_component *component)
 }
 
 static const struct snd_soc_component_driver hdmi_driver = {
+	.probe			= hdmi_probe,
 	.remove			= hdmi_remove,
 	.dapm_widgets		= hdmi_widgets,
 	.num_dapm_widgets	= ARRAY_SIZE(hdmi_widgets),
-- 
2.42.0



