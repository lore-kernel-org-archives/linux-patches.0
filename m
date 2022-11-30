Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C2179C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:53:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170EDC433D7;
	Wed, 30 Nov 2022 18:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834402;
	bh=9eK/YfM8SsXmkglH0WxqzhlfaZd4V7b6t66rSlpQoZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sIXkD6e32zWbNAyRITjur3Ja5vv36wpGnjsLZmeh7Pd2FEcklVhgB8iGNE+/2dc7T
	 IdCPy5qLeQi8HGiPaWEzmDUxLZgJ0fbkZ9W3Cj6NDsoo4Qtih5EXHt00vO8t/hvmlu
	 fFzJjARbEsXV9KsMtvwQeVlNpidvSZ8kNwRu56Yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 241/289] ASoC: stm32: dfsdm: manage cb buffers cleanup
Date: Wed, 30 Nov 2022 19:23:46 +0100
Message-Id: <20221130180549.573905141@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Olivier Moysan <olivier.moysan@foss.st.com>

[ Upstream commit 7d945b046be3d2605dbb1806e73095aadd7ae129 ]

Ensure that resources allocated by iio_channel_get_all_cb()
are released on driver unbind.

Signed-off-by: Olivier Moysan <olivier.moysan@foss.st.com>
Link: https://lore.kernel.org/r/20221109170849.273719-1-olivier.moysan@foss.st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/stm/stm32_adfsdm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/soc/stm/stm32_adfsdm.c b/sound/soc/stm/stm32_adfsdm.c
index 643fc8a17018..837c1848d9bf 100644
--- a/sound/soc/stm/stm32_adfsdm.c
+++ b/sound/soc/stm/stm32_adfsdm.c
@@ -304,6 +304,11 @@ static int stm32_adfsdm_dummy_cb(const void *data, void *private)
 	return 0;
 }
 
+static void stm32_adfsdm_cleanup(void *data)
+{
+	iio_channel_release_all_cb(data);
+}
+
 static struct snd_soc_component_driver stm32_adfsdm_soc_platform = {
 	.open		= stm32_adfsdm_pcm_open,
 	.close		= stm32_adfsdm_pcm_close,
@@ -350,6 +355,12 @@ static int stm32_adfsdm_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->iio_cb))
 		return PTR_ERR(priv->iio_cb);
 
+	ret = devm_add_action_or_reset(&pdev->dev, stm32_adfsdm_cleanup, priv->iio_cb);
+	if (ret < 0)  {
+		dev_err(&pdev->dev, "Unable to add action\n");
+		return ret;
+	}
+
 	component = devm_kzalloc(&pdev->dev, sizeof(*component), GFP_KERNEL);
 	if (!component)
 		return -ENOMEM;
-- 
2.35.1



