Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FED815C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97B4C433D6;
	Mon,  5 Dec 2022 19:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268402;
	bh=7cFMZPfc+s0l26yFGgGL849IE2C638W8nzRrpxIyCjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XX+KBvLJ0XScuEiKFlwvVuMQpsiIYmZXc1kYai423HS9guSMUDaiUxylrwLJgmJ1h
	 nvCzs43PsZIZHXFjt+RMFpLHIoqJXqvWhRyE1D76bSDMX+dI7I92sxAQUeDUfDHoCV
	 5Swdz3ix/YZyy+lfBpbm0rnBNqqurgTt67s/kzu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.0 088/124] mmc: mtk-sd: Fix missing clk_disable_unprepare in msdc_of_clock_parse()
Date: Mon,  5 Dec 2022 20:09:54 +0100
Message-Id: <20221205190810.918734228@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
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

commit c61bfb1cb63ddab52b31cf5f1924688917e61fad upstream.

The clk_disable_unprepare() should be called in the error handling
of devm_clk_bulk_get_optional, fix it by replacing devm_clk_get_optional
and clk_prepare_enable by devm_clk_get_optional_enabled.

Fixes: f5eccd94b63f ("mmc: mediatek: Add subsys clock control for MT8192 msdc")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221125090141.3626747-1-cuigaosheng1@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mtk-sd.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -2573,13 +2573,11 @@ static int msdc_of_clock_parse(struct pl
 			return PTR_ERR(host->src_clk_cg);
 	}
 
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


