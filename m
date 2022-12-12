Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47CF28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602E4C433F0;
	Mon, 12 Dec 2022 13:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670851586;
	bh=Qi7F2Hz6kwHyRCgxrnRrKVsbogZQ1IJ3XrIfJOd2h9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DdwpmvjUI6aeZB+1z7glfoXPjHsz1HIvyA1lY4kgp9gsWxFvLAYBfwLhLdhvZ25yX
	 njUab6f/thcFSKmaw3W+7OLinNI3SdZdyB7E8ZiBciWLXHjqIqdx1lWuaSf5kNryeC
	 jjTt/T1tnHL8sehLqg7L2OZN6Hhly/7ceRgl5g6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/123] mmc: mtk-sd: Fix missing clk_disable_unprepare in msdc_of_clock_parse()
Date: Mon, 12 Dec 2022 14:16:09 +0100
Message-Id: <20221212130926.962355206@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit c61bfb1cb63ddab52b31cf5f1924688917e61fad ]

The clk_disable_unprepare() should be called in the error handling
of devm_clk_bulk_get_optional, fix it by replacing devm_clk_get_optional
and clk_prepare_enable by devm_clk_get_optional_enabled.

Fixes: f5eccd94b63f ("mmc: mediatek: Add subsys clock control for MT8192 msdc")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221125090141.3626747-1-cuigaosheng1@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mtk-sd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/mtk-sd.c b/drivers/mmc/host/mtk-sd.c
index 99d8881a7d6c..9871c19d2b4e 100644
--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -2455,13 +2455,11 @@ static int msdc_of_clock_parse(struct platform_device *pdev,
 	if (IS_ERR(host->src_clk_cg))
 		host->src_clk_cg = NULL;
 
-	host->sys_clk_cg = devm_clk_get_optional(&pdev->dev, "sys_cg");
+	/* If present, always enable for this clock gate */
+	host->sys_clk_cg = devm_clk_get_optional_enabled(&pdev->dev, "sys_cg");
 	if (IS_ERR(host->sys_clk_cg))
 		host->sys_clk_cg = NULL;
 
-	/* If present, always enable for this clock gate */
-	clk_prepare_enable(host->sys_clk_cg);
-
 	host->bulk_clks[0].id = "pclk_cg";
 	host->bulk_clks[1].id = "axi_cg";
 	host->bulk_clks[2].id = "ahb_cg";
-- 
2.35.1



