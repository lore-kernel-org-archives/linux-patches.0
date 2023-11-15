Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613042C870
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OVSNMael"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104A2C433CA;
	Wed, 15 Nov 2023 19:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076374;
	bh=6zy5ygfmEZBaau4gMmIqcckRB1BYiYtakFe5zWja6cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OVSNMaelR7oedkhRbyxERFFU4+yIa136sfymenRv8vExirC2ThosAWAjlJE5o73gB
	 HdHBQIpYfPtPNy9f6qp7qLY/5br5CoKOU+/RjzCY6+w6jH3kFZ6jWCcjIh2uE0QmqX
	 FV06yHHEuy/vsRhYXLjt9Ypcdwkyg50iej5qd5rY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 227/550] drm/tve200: Convert to platform remove callback returning void
Date: Wed, 15 Nov 2023 14:13:31 -0500
Message-ID: <20231115191616.498410404@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit e2fd3192e267dcb01f5de5baa221677c349de828 ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is (mostly) ignored
and this typically results in resource leaks. To improve here there is a
quest to make the remove callback return void. In the first step of this
quest all drivers are converted to .remove_new() which already returns
void.

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230507162616.1368908-51-u.kleine-koenig@pengutronix.de
Stable-dep-of: 3c4babae3c4a ("drm: Call drm_atomic_helper_shutdown() at shutdown/remove time for misc drivers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tve200/tve200_drv.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/tve200/tve200_drv.c b/drivers/gpu/drm/tve200/tve200_drv.c
index 40b1168ad671f..984aa8f0a5427 100644
--- a/drivers/gpu/drm/tve200/tve200_drv.c
+++ b/drivers/gpu/drm/tve200/tve200_drv.c
@@ -236,7 +236,7 @@ static int tve200_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int tve200_remove(struct platform_device *pdev)
+static void tve200_remove(struct platform_device *pdev)
 {
 	struct drm_device *drm = platform_get_drvdata(pdev);
 	struct tve200_drm_dev_private *priv = drm->dev_private;
@@ -247,8 +247,6 @@ static int tve200_remove(struct platform_device *pdev)
 	drm_mode_config_cleanup(drm);
 	clk_disable_unprepare(priv->pclk);
 	drm_dev_put(drm);
-
-	return 0;
 }
 
 static const struct of_device_id tve200_of_match[] = {
@@ -264,7 +262,7 @@ static struct platform_driver tve200_driver = {
 		.of_match_table = of_match_ptr(tve200_of_match),
 	},
 	.probe = tve200_probe,
-	.remove = tve200_remove,
+	.remove_new = tve200_remove,
 };
 drm_module_platform_driver(tve200_driver);
 
-- 
2.42.0



