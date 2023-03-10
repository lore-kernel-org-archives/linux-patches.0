Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0CB8820
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776BDC4339B;
	Fri, 10 Mar 2023 14:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460054;
	bh=ltRKPzrt6mpEDBakqYpt4yPj73ZXhsnph6hnRNgHZGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tmbA45qMHd/Gp1gnYRzph8DlhzjWczsyAiDYFTJrI9/xcVis2McrDlaupBprhcPsJ
	 6uwV1EArb4CVWRJmoMGJu1t4xo/oc8S2Ys5Uxwf/LyfE8UEA596M2xeA1eBq5nMfI0
	 WspACsG7UvC0f6+Fp8x8bgHYX/yBzbNCE7CBXwAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steffen Aschbacher <steffen.aschbacher@stihl.de>,
	Alexandru Ardelean <alex@shruggie.ro>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 207/529] ASoC: tlv320adcx140: fix ti,gpio-config DT property init
Date: Fri, 10 Mar 2023 14:35:50 +0100
Message-Id: <20230310133814.601883103@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Steffen Aschbacher <steffen.aschbacher@stihl.de>

[ Upstream commit 771725efe5e2e5396dd9d1220437e5f9d6b9ca9d ]

When the 'ti,gpio-config' property is not defined, the
device_property_count_u32() will return an error, rather than zero.

The current check, only handles a return value of zero, which assumes that
the property is defined and has nothing defined.

This change extends the check to also check for an error case (most likely
to be hit by the case that the 'ti,gpio-config' is not defined).

In case that the 'ti,gpio-config' and the returned 'gpio_count' is not
correct, there is a 'if (gpio_count != ADCX140_NUM_GPIO_CFGS)' check, a few
lines lower that will return -EINVAL.
This means that someone tried to define 'ti,gpio-config', but with the
wrong number of GPIOs.

Fixes: d5214321498a ("ASoC: tlv320adcx140: Add support for configuring GPIO pin")
Signed-off-by: Steffen Aschbacher <steffen.aschbacher@stihl.de>
Signed-off-by: Alexandru Ardelean <alex@shruggie.ro>
Link: https://lore.kernel.org/r/20230213073805.14640-1-alex@shruggie.ro
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320adcx140.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tlv320adcx140.c b/sound/soc/codecs/tlv320adcx140.c
index 53a80246aee19..a6241a0453694 100644
--- a/sound/soc/codecs/tlv320adcx140.c
+++ b/sound/soc/codecs/tlv320adcx140.c
@@ -870,7 +870,7 @@ static int adcx140_configure_gpio(struct adcx140_priv *adcx140)
 
 	gpio_count = device_property_count_u32(adcx140->dev,
 			"ti,gpio-config");
-	if (gpio_count == 0)
+	if (gpio_count <= 0)
 		return 0;
 
 	if (gpio_count != ADCX140_NUM_GPIO_CFGS)
-- 
2.39.2



