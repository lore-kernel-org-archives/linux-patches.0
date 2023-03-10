Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B46F847E
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DBE4C433EF;
	Fri, 10 Mar 2023 13:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678455993;
	bh=7z5tbFIpDWs2S9WL+KcOKz4si3ptgM4slA5eKyC3ePI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z/4yp1TN2Y32Ut4hRvgAIxIOtm7JmH5YKOOCZPlsV2IK058qLyhfSOHb8LPR01SxL
	 OTiAH7AosN3/A2Gb4xVmOc2bjIJ65EVt2oZDDgm66AQW63wSGLlMKy6dXNq9LnT4Ej
	 n2UGbWHN+3Wx+8ttKVpRYiyj0+rF3t3EPBJGINfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 045/193] cpufreq: davinci: Fix clk use after free
Date: Fri, 10 Mar 2023 14:37:07 +0100
Message-Id: <20230310133712.480054644@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
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
index d54a27c991218..3dacfc53a80da 100644
--- a/drivers/cpufreq/davinci-cpufreq.c
+++ b/drivers/cpufreq/davinci-cpufreq.c
@@ -138,12 +138,14 @@ static int __init davinci_cpufreq_probe(struct platform_device *pdev)
 
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



