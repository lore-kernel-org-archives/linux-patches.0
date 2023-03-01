Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05874847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C28FC433EF;
	Wed,  1 Mar 2023 18:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694321;
	bh=yopj1Ok402VLqO03d/DGnckaXgp6bdvXmnEXhDwCoZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bbgiZl6MuqpFct1sjTCaFQUg8UT7aISdMMT6VutYY1fdW2NLgGZxn5m3vzpwmha4V
	 U8nMzG9csB1YveABb29iRM0tmWG2M1KwmGQSY4XyboFWWPpt07U9sN42g6okxyL4sp
	 fGutiXmkxcDJ1mAf7XFCL89S7y4aK7L1yD6J47mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Firago <a.firago@yadro.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 20/42] ASoC: codecs: es8326: Fix DTS properties reading
Date: Wed,  1 Mar 2023 19:08:41 +0100
Message-Id: <20230301180657.966102355@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
References: <20230301180657.003689969@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexey Firago <a.firago@yadro.com>

[ Upstream commit fe1e7e8ce2c47bd8fd9885eab63fca0a522e94c9 ]

Seems like properties parsing and reading was copy-pasted,
so "everest,interrupt-src" and "everest,interrupt-clk" are saved into
the es8326->jack_pol variable. This might lead to wrong settings
being saved into the reg 57 (ES8326_HP_DET).

Fix this by using proper variables while reading properties.

Signed-off-by: Alexey Firago <a.firago@yadro.com>
Reviewed-by: Yang Yingliang <yangyingliang@huawei.com
Link: https://lore.kernel.org/r/20230204195106.46539-1-a.firago@yadro.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8326.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
index 87c1cc16592bb..555125efd9ad3 100644
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -729,14 +729,16 @@ static int es8326_probe(struct snd_soc_component *component)
 	}
 	dev_dbg(component->dev, "jack-pol %x", es8326->jack_pol);
 
-	ret = device_property_read_u8(component->dev, "everest,interrupt-src", &es8326->jack_pol);
+	ret = device_property_read_u8(component->dev, "everest,interrupt-src",
+				      &es8326->interrupt_src);
 	if (ret != 0) {
 		dev_dbg(component->dev, "interrupt-src return %d", ret);
 		es8326->interrupt_src = ES8326_HP_DET_SRC_PIN9;
 	}
 	dev_dbg(component->dev, "interrupt-src %x", es8326->interrupt_src);
 
-	ret = device_property_read_u8(component->dev, "everest,interrupt-clk", &es8326->jack_pol);
+	ret = device_property_read_u8(component->dev, "everest,interrupt-clk",
+				      &es8326->interrupt_clk);
 	if (ret != 0) {
 		dev_dbg(component->dev, "interrupt-clk return %d", ret);
 		es8326->interrupt_clk = 0x45;
-- 
2.39.0



