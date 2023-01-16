Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8D36FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630FAC433EF;
	Mon, 16 Jan 2023 16:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887497;
	bh=E/xtEKpcotnSv3+96DD3nmGH4DRqoxr4INUwukIKP48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ox/lgyedsPsvPsbdRD3EMCZbQexLtTgt03zKMLJAe3PFXLEGALMzmPpGwbLnoBhv3
	 P3MASkBxZiYIjifZwF0Ai4+ZY9OP7TLQQj1IPpPOVhAC9n/h4Be1+Ps+IzXDGyx55e
	 wisklK2iPxPxehGUnKe7zWIqRzzur0q++nbe6SHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 141/521] mmc: wmt-sdmmc: fix return value check of mmc_add_host()
Date: Mon, 16 Jan 2023 16:46:43 +0100
Message-Id: <20230116154853.576383876@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 29276d56f6ed138db0f38cd31aedc0b725c8c76c ]

mmc_add_host() may return error, if we ignore its return value, the memory
that allocated in mmc_alloc_host() will be leaked and it will lead a kernel
crash because of deleting not added device in the remove path.

So fix this by checking the return value and goto error path which will call
mmc_free_host(), besides, clk_disable_unprepare() also needs be called.

Fixes: 3a96dff0f828 ("mmc: SD/MMC Host Controller for Wondermedia WM8505/WM8650")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221101063023.1664968-10-yangyingliang@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/wmt-sdmmc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/wmt-sdmmc.c b/drivers/mmc/host/wmt-sdmmc.c
index f8b169684693..a132bc822b5c 100644
--- a/drivers/mmc/host/wmt-sdmmc.c
+++ b/drivers/mmc/host/wmt-sdmmc.c
@@ -863,11 +863,15 @@ static int wmt_mci_probe(struct platform_device *pdev)
 	/* configure the controller to a known 'ready' state */
 	wmt_reset_hardware(mmc);
 
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret)
+		goto fail7;
 
 	dev_info(&pdev->dev, "WMT SDHC Controller initialized\n");
 
 	return 0;
+fail7:
+	clk_disable_unprepare(priv->clk_sdmmc);
 fail6:
 	clk_put(priv->clk_sdmmc);
 fail5_and_a_half:
-- 
2.35.1



