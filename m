Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23650522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:19:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E7CC433C7;
	Sun,  9 Jul 2023 11:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901568;
	bh=JHT+iMQO8LqS+kJkeHNuaxe3v0vmIk4Xw3W1hDP7sx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J0SLllqCV4Go71Sfnf2v12X8LRUkGekm+6cAMhCq4LZ+MtZDfLpn2EncY4ufnT8Yo
	 zYEQMAfydbXIAWV6w4BAdaj63EzSuoL72G/A3qBJ6Q1qSMrnNp+Q12715rqGKCKt0w
	 /riKgXTVztfGdNMbL7IlWMLt5qkitPqcenj3s9q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Mingxi <m202271825@hust.edu.cn>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Michal Simek <michal.simek@amd.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 038/431] clocksource/drivers/cadence-ttc: Fix memory leak in ttc_timer_probe
Date: Sun,  9 Jul 2023 13:09:46 +0200
Message-ID: <20230709111451.989200338@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Feng Mingxi <m202271825@hust.edu.cn>

[ Upstream commit 8b5bf64c89c7100c921bd807ba39b2eb003061ab ]

Smatch reports:
drivers/clocksource/timer-cadence-ttc.c:529 ttc_timer_probe()
warn: 'timer_baseaddr' from of_iomap() not released on lines: 498,508,516.

timer_baseaddr may have the problem of not being released after use,
I replaced it with the devm_of_iomap() function and added the clk_put()
function to cleanup the "clk_ce" and "clk_cs".

Fixes: e932900a3279 ("arm: zynq: Use standard timer binding")
Fixes: 70504f311d4b ("clocksource/drivers/cadence_ttc: Convert init function to return error")
Signed-off-by: Feng Mingxi <m202271825@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
Acked-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20230425065611.702917-1-m202271825@hust.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-cadence-ttc.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/clocksource/timer-cadence-ttc.c b/drivers/clocksource/timer-cadence-ttc.c
index 4efd0cf3b602d..0d52e28fea4de 100644
--- a/drivers/clocksource/timer-cadence-ttc.c
+++ b/drivers/clocksource/timer-cadence-ttc.c
@@ -486,10 +486,10 @@ static int __init ttc_timer_probe(struct platform_device *pdev)
 	 * and use it. Note that the event timer uses the interrupt and it's the
 	 * 2nd TTC hence the irq_of_parse_and_map(,1)
 	 */
-	timer_baseaddr = of_iomap(timer, 0);
-	if (!timer_baseaddr) {
+	timer_baseaddr = devm_of_iomap(&pdev->dev, timer, 0, NULL);
+	if (IS_ERR(timer_baseaddr)) {
 		pr_err("ERROR: invalid timer base address\n");
-		return -ENXIO;
+		return PTR_ERR(timer_baseaddr);
 	}
 
 	irq = irq_of_parse_and_map(timer, 1);
@@ -513,20 +513,27 @@ static int __init ttc_timer_probe(struct platform_device *pdev)
 	clk_ce = of_clk_get(timer, clksel);
 	if (IS_ERR(clk_ce)) {
 		pr_err("ERROR: timer input clock not found\n");
-		return PTR_ERR(clk_ce);
+		ret = PTR_ERR(clk_ce);
+		goto put_clk_cs;
 	}
 
 	ret = ttc_setup_clocksource(clk_cs, timer_baseaddr, timer_width);
 	if (ret)
-		return ret;
+		goto put_clk_ce;
 
 	ret = ttc_setup_clockevent(clk_ce, timer_baseaddr + 4, irq);
 	if (ret)
-		return ret;
+		goto put_clk_ce;
 
 	pr_info("%pOFn #0 at %p, irq=%d\n", timer, timer_baseaddr, irq);
 
 	return 0;
+
+put_clk_ce:
+	clk_put(clk_ce);
+put_clk_cs:
+	clk_put(clk_cs);
+	return ret;
 }
 
 static const struct of_device_id ttc_timer_of_match[] = {
-- 
2.39.2



