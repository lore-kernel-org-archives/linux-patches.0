Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC92A20F88
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:05:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6714BC433C7;
	Fri, 21 Jul 2023 19:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966346;
	bh=zrBr1JTdWayiambjun45njPeLHYBUFyfaJY+ECqmxlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gyeBAvNG21F51VNvBU3OahRGelUIKsXmeR/RYDBdwP+1Y4VmDr9D6mXqjp8Myjjn+
	 NBMSv0mJLwjBNhi886/Hz1Wc8dJREoehckamZlSfcxBr7rehOnouzdwzfeoTM37E9i
	 oIEpPcqoO0Vxst+YMAEaZuVWCkLewDMz1NKRsGiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuijing Li <shuijing.li@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Fei Shao <fshao@chromium.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Alexandre Mergnat <amergnat@baylibre.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 311/532] pwm: mtk_disp: Fix the disable flow of disp_pwm
Date: Fri, 21 Jul 2023 18:03:35 +0200
Message-ID: <20230721160631.271125536@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shuijing Li <shuijing.li@mediatek.com>

[ Upstream commit bc13d60e4e1e945b34769a4a4c2b172e8552abe5 ]

There is a flow error in the original mtk_disp_pwm_apply() function.
If this function is called when the clock is disabled, there will be a
chance to operate the disp_pwm register, resulting in disp_pwm exception.
Fix this accordingly.

Fixes: 888a623db5d0 ("pwm: mtk-disp: Implement atomic API .apply()")
Signed-off-by: Shuijing Li <shuijing.li@mediatek.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Tested-by: Fei Shao <fshao@chromium.org>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Alexandre Mergnat <amergnat@baylibre.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-mtk-disp.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/pwm/pwm-mtk-disp.c b/drivers/pwm/pwm-mtk-disp.c
index 92ba02cfec92f..a581d8adab59c 100644
--- a/drivers/pwm/pwm-mtk-disp.c
+++ b/drivers/pwm/pwm-mtk-disp.c
@@ -79,14 +79,11 @@ static int mtk_disp_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	if (state->polarity != PWM_POLARITY_NORMAL)
 		return -EINVAL;
 
-	if (!state->enabled) {
-		mtk_disp_pwm_update_bits(mdp, DISP_PWM_EN, mdp->data->enable_mask,
-					 0x0);
-
-		if (mdp->enabled) {
-			clk_disable_unprepare(mdp->clk_mm);
-			clk_disable_unprepare(mdp->clk_main);
-		}
+	if (!state->enabled && mdp->enabled) {
+		mtk_disp_pwm_update_bits(mdp, DISP_PWM_EN,
+					 mdp->data->enable_mask, 0x0);
+		clk_disable_unprepare(mdp->clk_mm);
+		clk_disable_unprepare(mdp->clk_main);
 
 		mdp->enabled = false;
 		return 0;
-- 
2.39.2



