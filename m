Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8914A8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C381C433C8;
	Sun, 16 Jul 2023 20:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537874;
	bh=8yNNvwTOOgPkkaA5EKZSqC+TnEhYh3ugK4aZ09tzEBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uOHIjBQlM8XIxSWwoTei0B8JMoEFDToFwdzELdjjTi/7oWCoezKOSjw1lpiy/32KT
	 nhucLigoPdOExXFBocrWRN7Rl6kagm2JzbSCCpvD1dRba751P/W4ryv4+LNajRFONF
	 9dH+ZYD+3Ybp9G7LxGINrtcqVnt0Oxmd3iR3HQJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	XuDong Liu <m202071377@hust.edu.cn>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Maxime Ripard <maxime@cerno.tech>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 252/800] drm: sun4i_tcon: use devm_clk_get_enabled in `sun4i_tcon_init_clocks`
Date: Sun, 16 Jul 2023 21:41:45 +0200
Message-ID: <20230716194954.951261608@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: XuDong Liu <m202071377@hust.edu.cn>

[ Upstream commit 123ee07ba5b7123e0ce0e0f9d64938026c16a2ce ]

Smatch reports:
drivers/gpu/drm/sun4i/sun4i_tcon.c:805 sun4i_tcon_init_clocks() warn:
'tcon->clk' from clk_prepare_enable() not released on lines: 792,801.

In the function sun4i_tcon_init_clocks(), tcon->clk and tcon->sclk0 are
not disabled in the error handling, which affects the release of
these variable. Although sun4i_tcon_bind(), which calls
sun4i_tcon_init_clocks(), use sun4i_tcon_free_clocks to disable the
variables mentioned, but the error handling branch of
sun4i_tcon_init_clocks() ignores the required disable process.

To fix this issue, use the devm_clk_get_enabled to automatically
balance enable and disabled calls. As original implementation use
sun4i_tcon_free_clocks() to disable clk explicitly, we delete the
related calls and error handling that are no longer needed.

Fixes: 9026e0d122ac ("drm: Add Allwinner A10 Display Engine support")
Fixes: b14e945bda8a ("drm/sun4i: tcon: Prepare and enable TCON channel 0 clock at init")
Fixes: 8e9240472522 ("drm/sun4i: support TCONs without channel 1")
Fixes: 34d698f6e349 ("drm/sun4i: Add has_channel_0 TCON quirk")
Signed-off-by: XuDong Liu <m202071377@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20230430112347.4689-1-m202071377@hust.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_tcon.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun4i_tcon.c b/drivers/gpu/drm/sun4i/sun4i_tcon.c
index 523a6d7879210..936796851ffd3 100644
--- a/drivers/gpu/drm/sun4i/sun4i_tcon.c
+++ b/drivers/gpu/drm/sun4i/sun4i_tcon.c
@@ -778,21 +778,19 @@ static irqreturn_t sun4i_tcon_handler(int irq, void *private)
 static int sun4i_tcon_init_clocks(struct device *dev,
 				  struct sun4i_tcon *tcon)
 {
-	tcon->clk = devm_clk_get(dev, "ahb");
+	tcon->clk = devm_clk_get_enabled(dev, "ahb");
 	if (IS_ERR(tcon->clk)) {
 		dev_err(dev, "Couldn't get the TCON bus clock\n");
 		return PTR_ERR(tcon->clk);
 	}
-	clk_prepare_enable(tcon->clk);
 
 	if (tcon->quirks->has_channel_0) {
-		tcon->sclk0 = devm_clk_get(dev, "tcon-ch0");
+		tcon->sclk0 = devm_clk_get_enabled(dev, "tcon-ch0");
 		if (IS_ERR(tcon->sclk0)) {
 			dev_err(dev, "Couldn't get the TCON channel 0 clock\n");
 			return PTR_ERR(tcon->sclk0);
 		}
 	}
-	clk_prepare_enable(tcon->sclk0);
 
 	if (tcon->quirks->has_channel_1) {
 		tcon->sclk1 = devm_clk_get(dev, "tcon-ch1");
@@ -805,12 +803,6 @@ static int sun4i_tcon_init_clocks(struct device *dev,
 	return 0;
 }
 
-static void sun4i_tcon_free_clocks(struct sun4i_tcon *tcon)
-{
-	clk_disable_unprepare(tcon->sclk0);
-	clk_disable_unprepare(tcon->clk);
-}
-
 static int sun4i_tcon_init_irq(struct device *dev,
 			       struct sun4i_tcon *tcon)
 {
@@ -1223,14 +1215,14 @@ static int sun4i_tcon_bind(struct device *dev, struct device *master,
 	ret = sun4i_tcon_init_regmap(dev, tcon);
 	if (ret) {
 		dev_err(dev, "Couldn't init our TCON regmap\n");
-		goto err_free_clocks;
+		goto err_assert_reset;
 	}
 
 	if (tcon->quirks->has_channel_0) {
 		ret = sun4i_dclk_create(dev, tcon);
 		if (ret) {
 			dev_err(dev, "Couldn't create our TCON dot clock\n");
-			goto err_free_clocks;
+			goto err_assert_reset;
 		}
 	}
 
@@ -1293,8 +1285,6 @@ static int sun4i_tcon_bind(struct device *dev, struct device *master,
 err_free_dotclock:
 	if (tcon->quirks->has_channel_0)
 		sun4i_dclk_free(tcon);
-err_free_clocks:
-	sun4i_tcon_free_clocks(tcon);
 err_assert_reset:
 	reset_control_assert(tcon->lcd_rst);
 	return ret;
@@ -1308,7 +1298,6 @@ static void sun4i_tcon_unbind(struct device *dev, struct device *master,
 	list_del(&tcon->list);
 	if (tcon->quirks->has_channel_0)
 		sun4i_dclk_free(tcon);
-	sun4i_tcon_free_clocks(tcon);
 }
 
 static const struct component_ops sun4i_tcon_ops = {
-- 
2.39.2



