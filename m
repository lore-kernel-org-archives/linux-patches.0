Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C6D15ACF
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECC8C433C8;
	Tue, 25 Jul 2023 11:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282846;
	bh=ajFG5oZk8RW+Sz0tYhfE7EYLpgWyaxTS03WHuL7RGQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=02ebc8fkKgqlLe+pS5erWksDqZBNESHfN+cSPlyT/U33JfurN/9z/uqW4UI8rM3Tk
	 dm+7QZTK4aXxliJT2gG2mhN01rOqwJ9IbXCR/XopI5DwLvkk0LPftc+jVLTRWjC/Oh
	 8if/0IPeCA84TTe/S1Vog2imt5cKsXIMQOzlGElQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Steev Klimaszewski <steev@kali.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 048/183] ASoC: codecs: wcd938x: fix codec initialisation race
Date: Tue, 25 Jul 2023 12:44:36 +0200
Message-ID: <20230725104509.699427197@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit 85a61b1ce461a3f62f1019e5e6423c393c542bff upstream.

Make sure to resume the codec and soundwire device before trying to read
the codec variant and configure the device during component probe.

This specifically avoids interpreting (a masked and shifted) -EBUSY
errno as the variant:

	wcd938x_codec audio-codec: ASoC: error at soc_component_read_no_lock on audio-codec for register: [0x000034b0] -16

when the soundwire device happens to be suspended, which in turn
prevents some headphone controls from being registered.

Fixes: 8d78602aa87a ("ASoC: codecs: wcd938x: add basic driver")
Cc: stable@vger.kernel.org      # 5.14
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reported-by: Steev Klimaszewski <steev@kali.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20230630120318.6571-1-johan+linaro@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wcd938x.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/soc/codecs/wcd938x.c
+++ b/sound/soc/codecs/wcd938x.c
@@ -3095,6 +3095,10 @@ static int wcd938x_soc_codec_probe(struc
 
 	snd_soc_component_init_regmap(component, wcd938x->regmap);
 
+	ret = pm_runtime_resume_and_get(dev);
+	if (ret < 0)
+		return ret;
+
 	wcd938x->variant = snd_soc_component_read_field(component,
 						 WCD938X_DIGITAL_EFUSE_REG_0,
 						 WCD938X_ID_MASK);
@@ -3112,6 +3116,8 @@ static int wcd938x_soc_codec_probe(struc
 			     (WCD938X_DIGITAL_INTR_LEVEL_0 + i), 0);
 	}
 
+	pm_runtime_put(dev);
+
 	wcd938x->hphr_pdm_wd_int = regmap_irq_get_virq(wcd938x->irq_chip,
 						       WCD938X_IRQ_HPHR_PDM_WD_INT);
 	wcd938x->hphl_pdm_wd_int = regmap_irq_get_virq(wcd938x->irq_chip,


