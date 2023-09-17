Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB21746F
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:36:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C99C433C8;
	Sun, 17 Sep 2023 20:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694983000;
	bh=SuwNVi/udvkiZb8ECgsul+BwfIoLx1mcmqpiU1n/ujQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UKUdM/4lB/5Hi6t1plB+qFVHHthNJJqi+pUsoNc8B+1HrHoZfprE9IblvGatwOSwF
	 te3GURjYgnVkJCabZTREMY1iqRbdgR07QcXbOEb2kxWek1m0eimwwODstzD3A45PbP
	 pW6GtjtgF6wsOWhWY71zTFmjEylpUhkCnWuMc4GE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 413/511] pwm: atmel-tcb: Convert to platform remove callback returning void
Date: Sun, 17 Sep 2023 21:14:00 +0200
Message-ID: <20230917191123.755480885@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 9609284a76978daf53a54e05cff36873a75e4d13 ]

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
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Stable-dep-of: c11622324c02 ("pwm: atmel-tcb: Fix resource freeing in error path and remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-atmel-tcb.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pwm/pwm-atmel-tcb.c b/drivers/pwm/pwm-atmel-tcb.c
index 36f7ea381838d..2a06b7dd224c9 100644
--- a/drivers/pwm/pwm-atmel-tcb.c
+++ b/drivers/pwm/pwm-atmel-tcb.c
@@ -500,7 +500,7 @@ static int atmel_tcb_pwm_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int atmel_tcb_pwm_remove(struct platform_device *pdev)
+static void atmel_tcb_pwm_remove(struct platform_device *pdev)
 {
 	struct atmel_tcb_pwm_chip *tcbpwm = platform_get_drvdata(pdev);
 
@@ -509,8 +509,6 @@ static int atmel_tcb_pwm_remove(struct platform_device *pdev)
 	clk_disable_unprepare(tcbpwm->slow_clk);
 	clk_put(tcbpwm->slow_clk);
 	clk_put(tcbpwm->clk);
-
-	return 0;
 }
 
 static const struct of_device_id atmel_tcb_pwm_dt_ids[] = {
@@ -564,7 +562,7 @@ static struct platform_driver atmel_tcb_pwm_driver = {
 		.pm = &atmel_tcb_pwm_pm_ops,
 	},
 	.probe = atmel_tcb_pwm_probe,
-	.remove = atmel_tcb_pwm_remove,
+	.remove_new = atmel_tcb_pwm_remove,
 };
 module_platform_driver(atmel_tcb_pwm_driver);
 
-- 
2.40.1



