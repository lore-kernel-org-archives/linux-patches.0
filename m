Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0658F174F0
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:13:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B354C433C9;
	Wed,  9 Aug 2023 11:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579588;
	bh=dB4i023ufZ1dnK0w1/jujlQDKggac9FZJ6Xs3fHcVvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o4Zpti0Qv3Pe497CVhP/i3AFj3t7MlTltQYMDKijXeWzjBwqF8gdQ763aKFu802d7
	 g5bclVx1Mq3VmbXZXBI4b370mFJWz+6Rv+QPPtMw+vhlbdGe4lDFckVPr/YvM8GT29
	 vrzL5pWQ6pYdftVv+SM/SsG+77W07HtJwvQ4E+Ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rajan Vaja <rajan.vaja@xilinx.com>,
	Michal Simek <michal.simek@xilinx.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 016/323] clocksource/drivers/cadence-ttc: Use ttc driver as platform driver
Date: Wed,  9 Aug 2023 12:37:34 +0200
Message-ID: <20230809103658.838891209@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rajan Vaja <rajan.vaja@xilinx.com>

[ Upstream commit f5ac896b6a23eb46681cdbef440c1d991b04e519 ]

Currently TTC driver is TIMER_OF_DECLARE type driver. Because of
that, TTC driver may be initialized before other clock drivers. If
TTC driver is dependent on that clock driver then initialization of
TTC driver will failed.

So use TTC driver as platform driver instead of using
TIMER_OF_DECLARE.

Signed-off-by: Rajan Vaja <rajan.vaja@xilinx.com>
Tested-by: Michal Simek <michal.simek@xilinx.com>
Acked-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/1573122988-18399-1-git-send-email-rajan.vaja@xilinx.com
Stable-dep-of: 8b5bf64c89c7 ("clocksource/drivers/cadence-ttc: Fix memory leak in ttc_timer_probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-cadence-ttc.c | 26 +++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/clocksource/timer-cadence-ttc.c b/drivers/clocksource/timer-cadence-ttc.c
index a7eb858a84a0f..b1df0ded8f521 100644
--- a/drivers/clocksource/timer-cadence-ttc.c
+++ b/drivers/clocksource/timer-cadence-ttc.c
@@ -23,6 +23,8 @@
 #include <linux/of_irq.h>
 #include <linux/slab.h>
 #include <linux/sched_clock.h>
+#include <linux/module.h>
+#include <linux/of_platform.h>
 
 /*
  * This driver configures the 2 16/32-bit count-up timers as follows:
@@ -472,13 +474,7 @@ static int __init ttc_setup_clockevent(struct clk *clk,
 	return err;
 }
 
-/**
- * ttc_timer_init - Initialize the timer
- *
- * Initializes the timer hardware and register the clock source and clock event
- * timers with Linux kernal timer framework
- */
-static int __init ttc_timer_init(struct device_node *timer)
+static int __init ttc_timer_probe(struct platform_device *pdev)
 {
 	unsigned int irq;
 	void __iomem *timer_baseaddr;
@@ -486,6 +482,7 @@ static int __init ttc_timer_init(struct device_node *timer)
 	static int initialized;
 	int clksel, ret;
 	u32 timer_width = 16;
+	struct device_node *timer = pdev->dev.of_node;
 
 	if (initialized)
 		return 0;
@@ -540,4 +537,17 @@ static int __init ttc_timer_init(struct device_node *timer)
 	return 0;
 }
 
-TIMER_OF_DECLARE(ttc, "cdns,ttc", ttc_timer_init);
+static const struct of_device_id ttc_timer_of_match[] = {
+	{.compatible = "cdns,ttc"},
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, ttc_timer_of_match);
+
+static struct platform_driver ttc_timer_driver = {
+	.driver = {
+		.name	= "cdns_ttc_timer",
+		.of_match_table = ttc_timer_of_match,
+	},
+};
+builtin_platform_driver_probe(ttc_timer_driver, ttc_timer_probe);
-- 
2.39.2



