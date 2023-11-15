Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5773A8F3
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yTV1ctos"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB93C433C8;
	Wed, 15 Nov 2023 19:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077948;
	bh=8+YbkS5J10BWNW/akEzExnI9uoaTTSja1FvyP7yCUOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yTV1ctossr7rsmK996raMqQ5ykyi61i+I4LGIIIsqQkfHcubxpANUswtUg6MD7/n9
	 uiZcyCk1AePF2xjNfRvbD9eiLZxCdzOLzhfxLQYBFJElSLRljrIu6VR/nKEgZHodBt
	 nrNoRNJkNc4caeIoI5GPC+YAEdVXVESsUf9+tFTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Tony Lindgren <tony@atomide.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/379] drivers/clocksource/timer-ti-dm: Dont call clk_get_rate() in stop function
Date: Wed, 15 Nov 2023 14:21:31 -0500
Message-ID: <20231115192646.119504096@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>

[ Upstream commit 12590d4d0e331d3cb9e6b3494515cd61c8a6624e ]

clk_get_rate() might sleep, and that prevents dm-timer based PWM from being
used from atomic context.

Fix that by getting fclk rate in probe() and using a notifier in case rate
changes.

Fixes: af04aa856e93 ("ARM: OMAP: Move dmtimer driver out of plat-omap to drivers under clocksource")
Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/1696312220-11550-1-git-send-email-ivo.g.dimitrov.75@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-ti-dm.c | 36 ++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/clocksource/timer-ti-dm.c b/drivers/clocksource/timer-ti-dm.c
index 00af1a8e34fbd..ec86aecb748f1 100644
--- a/drivers/clocksource/timer-ti-dm.c
+++ b/drivers/clocksource/timer-ti-dm.c
@@ -141,6 +141,8 @@ struct dmtimer {
 	struct platform_device *pdev;
 	struct list_head node;
 	struct notifier_block nb;
+	struct notifier_block fclk_nb;
+	unsigned long fclk_rate;
 };
 
 static u32 omap_reserved_systimers;
@@ -254,8 +256,7 @@ static inline void __omap_dm_timer_enable_posted(struct dmtimer *timer)
 	timer->posted = OMAP_TIMER_POSTED;
 }
 
-static inline void __omap_dm_timer_stop(struct dmtimer *timer,
-					unsigned long rate)
+static inline void __omap_dm_timer_stop(struct dmtimer *timer)
 {
 	u32 l;
 
@@ -270,7 +271,7 @@ static inline void __omap_dm_timer_stop(struct dmtimer *timer,
 		 * Wait for functional clock period x 3.5 to make sure that
 		 * timer is stopped
 		 */
-		udelay(3500000 / rate + 1);
+		udelay(3500000 / timer->fclk_rate + 1);
 #endif
 	}
 
@@ -349,6 +350,21 @@ static int omap_timer_context_notifier(struct notifier_block *nb,
 	return NOTIFY_OK;
 }
 
+static int omap_timer_fclk_notifier(struct notifier_block *nb,
+				    unsigned long event, void *data)
+{
+	struct clk_notifier_data *clk_data = data;
+	struct dmtimer *timer = container_of(nb, struct dmtimer, fclk_nb);
+
+	switch (event) {
+	case POST_RATE_CHANGE:
+		timer->fclk_rate = clk_data->new_rate;
+		return NOTIFY_OK;
+	default:
+		return NOTIFY_DONE;
+	}
+}
+
 static int omap_dm_timer_reset(struct dmtimer *timer)
 {
 	u32 l, timeout = 100000;
@@ -742,7 +758,6 @@ static int omap_dm_timer_stop(struct omap_dm_timer *cookie)
 {
 	struct dmtimer *timer;
 	struct device *dev;
-	unsigned long rate = 0;
 
 	timer = to_dmtimer(cookie);
 	if (unlikely(!timer))
@@ -750,10 +765,7 @@ static int omap_dm_timer_stop(struct omap_dm_timer *cookie)
 
 	dev = &timer->pdev->dev;
 
-	if (!timer->omap1)
-		rate = clk_get_rate(timer->fclk);
-
-	__omap_dm_timer_stop(timer, rate);
+	__omap_dm_timer_stop(timer);
 
 	pm_runtime_put_sync(dev);
 
@@ -1112,6 +1124,14 @@ static int omap_dm_timer_probe(struct platform_device *pdev)
 		timer->fclk = devm_clk_get(dev, "fck");
 		if (IS_ERR(timer->fclk))
 			return PTR_ERR(timer->fclk);
+
+		timer->fclk_nb.notifier_call = omap_timer_fclk_notifier;
+		ret = devm_clk_notifier_register(dev, timer->fclk,
+						 &timer->fclk_nb);
+		if (ret)
+			return ret;
+
+		timer->fclk_rate = clk_get_rate(timer->fclk);
 	} else {
 		timer->fclk = ERR_PTR(-ENODEV);
 	}
-- 
2.42.0



