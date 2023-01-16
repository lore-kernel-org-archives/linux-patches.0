Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D1033EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:56:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0DAC433F1;
	Mon, 16 Jan 2023 15:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884618;
	bh=CSjnrmGcOwKxEg3v82J1nM3cCnXwSL8rJzqR53Oq7YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I8OPt7CdbIS7cAzflujK8WnStqx5iGOZVnETffqfp2bHotsHNhw2L+u4P72KmG/aV
	 xE6/tlcPA1qCchjzfyRBqhFiWRUb4utKgM+5p7atOKqDCYiMfsCQNk/bBf25VoaHn0
	 XF7KceOfdJTtt/we1GWpFzTiqp7Z9gk0RfXS1ac8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChiYuan Huang <cy_huang@richtek.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 044/183] ASoC: rt9120: Make dev PM runtime bind AsoC component PM
Date: Mon, 16 Jan 2023 16:49:27 +0100
Message-Id: <20230116154805.239336956@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: ChiYuan Huang <cy_huang@richtek.com>

commit 7161bd540eebebae2bbe8c79de25d8caf12dbf78 upstream.

RT9120 uses PM runtime autosuspend to decrease the frequently on/off
spent time. This exists one case, when pcm is closed and dev PM is
waiting for autosuspend time expired to enter runtime suspend state.
At the mean time, system is going to enter suspend, dev PM runtime
suspend won't be called. It makes the rt9120 suspend consumption
current not as expected.

This patch can fix the rt9120 dev PM issue during runtime autosuspend
and system suspend by binding dev PM runtime and ASoC component PM.

Fixes: 80b949f332e3 ("ASoC: rt9120: Use pm_runtime and regcache to optimize 'pwdnn' logic")
Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
Link: https://lore.kernel.org/r/1672301033-3675-1-git-send-email-u0084500@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt9120.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/soc/codecs/rt9120.c b/sound/soc/codecs/rt9120.c
index 644300e88b4c..fcf4fbaed3c7 100644
--- a/sound/soc/codecs/rt9120.c
+++ b/sound/soc/codecs/rt9120.c
@@ -177,8 +177,20 @@ static int rt9120_codec_probe(struct snd_soc_component *comp)
 	return 0;
 }
 
+static int rt9120_codec_suspend(struct snd_soc_component *comp)
+{
+	return pm_runtime_force_suspend(comp->dev);
+}
+
+static int rt9120_codec_resume(struct snd_soc_component *comp)
+{
+	return pm_runtime_force_resume(comp->dev);
+}
+
 static const struct snd_soc_component_driver rt9120_component_driver = {
 	.probe = rt9120_codec_probe,
+	.suspend = rt9120_codec_suspend,
+	.resume = rt9120_codec_resume,
 	.controls = rt9120_snd_controls,
 	.num_controls = ARRAY_SIZE(rt9120_snd_controls),
 	.dapm_widgets = rt9120_dapm_widgets,
-- 
2.39.0



