Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37093C23
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39AFDC433C8;
	Mon, 19 Jun 2023 10:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171199;
	bh=YPc0r6NfNEELinNLXJAgz1eeQAItNh35zU/sjR1QM/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M7fYUkB0VIpnl31hsGaqiAJeBLTqTYM6EaAfdNNVwNqaBvtH9P7Z61voKV53bKNWA
	 l26Wbkier6ja420JNOoBczjDZhZQf4zTWNmx3N5ilzZie5Cw2o+OxfGTR9+IOKweiE
	 aDywEpCNdMuj6TVaHqkgBMjAd2h833p4UDtgm9S0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 157/187] drm/bridge: ti-sn65dsi86: Avoid possible buffer overflow
Date: Mon, 19 Jun 2023 12:29:35 +0200
Message-ID: <20230619102205.181413751@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 95011f267c44a4d1f9ca1769e8a29ab2c559e004 ]

Smatch error:buffer overflow 'ti_sn_bridge_refclk_lut' 5 <= 5.

Fixes: cea86c5bb442 ("drm/bridge: ti-sn65dsi86: Implement the pwm_chip")
Signed-off-by: Su Hui <suhui@nfschina.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230608012443.839372-1-suhui@nfschina.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi86.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi86.c b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
index 1e26fa63845a2..0ae8a52acf5e4 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -298,6 +298,10 @@ static void ti_sn_bridge_set_refclk_freq(struct ti_sn65dsi86 *pdata)
 		if (refclk_lut[i] == refclk_rate)
 			break;
 
+	/* avoid buffer overflow and "1" is the default rate in the datasheet. */
+	if (i >= refclk_lut_size)
+		i = 1;
+
 	regmap_update_bits(pdata->regmap, SN_DPPLL_SRC_REG, REFCLK_FREQ_MASK,
 			   REFCLK_FREQ(i));
 
-- 
2.39.2



