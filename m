Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F90ABA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:19:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874EBC4339B;
	Tue,  7 Mar 2023 17:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209592;
	bh=mbCbirCOD3VZcDb8EZyztyIkhPAfYXla4pnnhBV7kzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KwaENJaoeeRN7BXV8n88JP2A1B8nE0/Cvazc8jSbzhZKsgopCIvJX7SoIe9vy8BPe
	 dbJB3MLjMmyIX9PBna/uky09g7suEe5nwrKHD9CNf5VCeVn/AJDjdArNmxGSyYrIZd
	 PeyWPm+7NX7emh1Z/e95JyZrRfvPjCfYtNXUK4LQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0269/1001] cpufreq: davinci: Fix clk use after free
Date: Tue,  7 Mar 2023 17:50:41 +0100
Message-Id: <20230307170033.385638255@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 5d8f384a9b4fc50f6a18405f1c08e5a87a77b5b3 ]

The remove function first frees the clks and only then calls
cpufreq_unregister_driver(). If one of the cpufreq callbacks is called
just before cpufreq_unregister_driver() is run, the freed clks might be
used.

Fixes: 6601b8030de3 ("davinci: add generic CPUFreq driver for DaVinci")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/davinci-cpufreq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/davinci-cpufreq.c b/drivers/cpufreq/davinci-cpufreq.c
index 9e97f60f81996..ebb3a81026816 100644
--- a/drivers/cpufreq/davinci-cpufreq.c
+++ b/drivers/cpufreq/davinci-cpufreq.c
@@ -133,12 +133,14 @@ static int __init davinci_cpufreq_probe(struct platform_device *pdev)
 
 static int __exit davinci_cpufreq_remove(struct platform_device *pdev)
 {
+	cpufreq_unregister_driver(&davinci_driver);
+
 	clk_put(cpufreq.armclk);
 
 	if (cpufreq.asyncclk)
 		clk_put(cpufreq.asyncclk);
 
-	return cpufreq_unregister_driver(&davinci_driver);
+	return 0;
 }
 
 static struct platform_driver davinci_cpufreq_driver = {
-- 
2.39.2



