Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B51D1C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DCEC433C1;
	Wed, 23 Nov 2022 09:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196767;
	bh=WsIXFVNRibSQwsGOSyuuuzOYe11bjJTPVln2nNz7kfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eC1Fin1WnAWAQ7pEdA4gEQXJreVyimucIQGYxWy54MUVWp/004cX6tyue3DUjaM0u
	 LfbmZW+gb9f7u5DUAlGm500CAf94Qwduisr1lF1X7gxPX6zS7Lm1KC2oEDRCGlPAdo
	 oVPP/PEYc0xkEF5nKE4BKL87B6NokKgxDyibPf7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 119/314] pinctrl: mediatek: common-v2: Fix bias-disable for PULL_PU_PD_RSEL_TYPE
Date: Wed, 23 Nov 2022 09:49:24 +0100
Message-Id: <20221123084630.900296046@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit fed74d75277da865da9ba334d3f5d5e3e327971d ]

In pinctrl-paris we're calling the .bias_set_combo() callback when we
are asked to set the pin bias to either pull up/down or pull disable.

On newer platforms, this callback is mtk_pinconf_bias_set_combo(),
located in pinctrl-mtk-common-v2.c: this will check the "pull type"
assigned to the requested pin and in case said pin's pull type is
MTK_PULL_PU_PD_RSEL_TYPE, this function will set RSEL first, PUPD
last, which is fine.

The issue comes when we're requesting PIN_CONFIG_BIAS_DISABLE, as
this does *not* require setting RSEL but only PU_PD: in this case,
the arg is MTK_DISABLE (zero), which is not a supported RSEL, due
to which function mtk_pinconf_bias_set_rsel() returns a failure;
because of that, mtk_pinconf_bias_set_pu_pd() is never called,
hence the pin bias is never set to DISABLE.

To fix this issue, add a check to mtk_pinconf_bias_set_rsel(): if
we are entering that function with no pullup requested and at the
same time the arg is MTK_DISABLE, this means that we're trying to
disable pin bias, hence it's safe to return cleanly without ever
setting any RSEL register.
This makes mtk_pinconf_bias_set_combo() happy, going on with setting
the PU_PD registers, which is the only action to actually take to
disable bias on a pin/pingroup.

Fixes: fb34a9ae383a ("pinctrl: mediatek: support rsel feature")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221104105605.33720-1-angelogioacchino.delregno@collabora.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
index e1ae3beb9f72..b7921b59eb7b 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
@@ -709,6 +709,9 @@ static int mtk_pinconf_bias_set_rsel(struct mtk_pinctrl *hw,
 {
 	int err, rsel_val;
 
+	if (!pullup && arg == MTK_DISABLE)
+		return 0;
+
 	if (hw->rsel_si_unit) {
 		/* find pin rsel_index from pin_rsel array*/
 		err = mtk_hw_pin_rsel_lookup(hw, desc, pullup, arg, &rsel_val);
-- 
2.35.1



