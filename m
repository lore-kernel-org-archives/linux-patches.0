Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE916FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1E4C433C9;
	Sun, 17 Sep 2023 20:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981060;
	bh=phhe5laKqx6LASxCxHDK51e+orCxnxM/X6fQ0Xe5KKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w82tkHXbLzxwi/H/jK0xrE1dhvHyzTCGPGabr7XuKAvecWJOnIlRxFixk0RXY3XxA
	 v1KeHZSh8oObiGUCwF5dIiuvD//tHIOqDG16a65vQU4lWXXY5GV+wgJHfJmfPhdqrO
	 azZu5QdiE5gHj8Y5FRcifH8iC11F/ApuVlbuVYy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/219] pwm: atmel-tcb: Fix resource freeing in error path and remove
Date: Sun, 17 Sep 2023 21:13:15 +0200
Message-ID: <20230917191043.454185817@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit c11622324c023415fb69196c5fc3782d2b8cced0 ]

Several resources were not freed in the error path and the remove
function. Add the forgotten items.

Fixes: 34cbcd72588f ("pwm: atmel-tcb: Add sama5d2 support")
Fixes: 061f8572a31c ("pwm: atmel-tcb: Switch to new binding")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-atmel-tcb.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/pwm/pwm-atmel-tcb.c b/drivers/pwm/pwm-atmel-tcb.c
index 613dd1810fb53..2826fc216d291 100644
--- a/drivers/pwm/pwm-atmel-tcb.c
+++ b/drivers/pwm/pwm-atmel-tcb.c
@@ -450,16 +450,20 @@ static int atmel_tcb_pwm_probe(struct platform_device *pdev)
 	tcbpwm->clk = of_clk_get_by_name(np->parent, clk_name);
 	if (IS_ERR(tcbpwm->clk))
 		tcbpwm->clk = of_clk_get_by_name(np->parent, "t0_clk");
-	if (IS_ERR(tcbpwm->clk))
-		return PTR_ERR(tcbpwm->clk);
+	if (IS_ERR(tcbpwm->clk)) {
+		err = PTR_ERR(tcbpwm->clk);
+		goto err_slow_clk;
+	}
 
 	match = of_match_node(atmel_tcb_of_match, np->parent);
 	config = match->data;
 
 	if (config->has_gclk) {
 		tcbpwm->gclk = of_clk_get_by_name(np->parent, "gclk");
-		if (IS_ERR(tcbpwm->gclk))
-			return PTR_ERR(tcbpwm->gclk);
+		if (IS_ERR(tcbpwm->gclk)) {
+			err = PTR_ERR(tcbpwm->gclk);
+			goto err_clk;
+		}
 	}
 
 	tcbpwm->chip.dev = &pdev->dev;
@@ -470,7 +474,7 @@ static int atmel_tcb_pwm_probe(struct platform_device *pdev)
 
 	err = clk_prepare_enable(tcbpwm->slow_clk);
 	if (err)
-		goto err_slow_clk;
+		goto err_gclk;
 
 	spin_lock_init(&tcbpwm->lock);
 
@@ -485,6 +489,12 @@ static int atmel_tcb_pwm_probe(struct platform_device *pdev)
 err_disable_clk:
 	clk_disable_unprepare(tcbpwm->slow_clk);
 
+err_gclk:
+	clk_put(tcbpwm->gclk);
+
+err_clk:
+	clk_put(tcbpwm->clk);
+
 err_slow_clk:
 	clk_put(tcbpwm->slow_clk);
 
@@ -498,8 +508,9 @@ static void atmel_tcb_pwm_remove(struct platform_device *pdev)
 	pwmchip_remove(&tcbpwm->chip);
 
 	clk_disable_unprepare(tcbpwm->slow_clk);
-	clk_put(tcbpwm->slow_clk);
+	clk_put(tcbpwm->gclk);
 	clk_put(tcbpwm->clk);
+	clk_put(tcbpwm->slow_clk);
 }
 
 static const struct of_device_id atmel_tcb_pwm_dt_ids[] = {
-- 
2.40.1



