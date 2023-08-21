Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF8A1171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:10:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3356C433C8;
	Mon, 21 Aug 2023 20:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648604;
	bh=CfeFDhCIAOBaxxXEcvHBEmT7Oy1DtkZM5jpIhnh3JMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ul7Qr0bZKVhGHgj5alB7rXT8sSCIpGErtnLaryRXYQZtA2/9pzUvo3UkegWo7myHm
	 fHfNvIxSnR1Uw7Z+++RNjJn0881zvijOt/8sJOpzNo2w4kJX2c1Ej2DFMLfoMakq2J
	 d7TaaRl20PiaTE+32hysZBJ1/kbDad9Hk68bpglA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Chen <harperchen1110@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.4 218/234] mmc: sunplus: fix return value check of mmc_add_host()
Date: Mon, 21 Aug 2023 21:43:01 +0200
Message-ID: <20230821194138.515290311@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wei Chen <harperchen1110@gmail.com>

commit dce6d8f985fa1ef5c2af47f4f86ea65511b78656 upstream.

mmc_add_host() may return error, if we ignore its return value,
1. the memory allocated in mmc_alloc_host() will be leaked
2. null-ptr-deref will happen when calling mmc_remove_host()
in remove function spmmc_drv_remove() because deleting not
added device.

Fix this by checking the return value of mmc_add_host(). Moreover,
I fixed the error handling path of spmmc_drv_probe() to clean up.

Fixes: 4e268fed8b18 ("mmc: Add mmc driver for Sunplus SP7021")
Cc: stable@vger.kernel.org
Signed-off-by: Wei Chen <harperchen1110@gmail.com>
Link: https://lore.kernel.org/r/20230622090233.188539-1-harperchen1110@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sunplus-mmc.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/sunplus-mmc.c b/drivers/mmc/host/sunplus-mmc.c
index db5e0dcdfa7f..a55a87f64d2a 100644
--- a/drivers/mmc/host/sunplus-mmc.c
+++ b/drivers/mmc/host/sunplus-mmc.c
@@ -902,7 +902,7 @@ static int spmmc_drv_probe(struct platform_device *pdev)
 
 	ret = mmc_of_parse(mmc);
 	if (ret)
-		goto probe_free_host;
+		goto clk_disable;
 
 	mmc->ops = &spmmc_ops;
 	mmc->f_min = SPMMC_MIN_CLK;
@@ -911,7 +911,7 @@ static int spmmc_drv_probe(struct platform_device *pdev)
 
 	ret = mmc_regulator_get_supply(mmc);
 	if (ret)
-		goto probe_free_host;
+		goto clk_disable;
 
 	if (!mmc->ocr_avail)
 		mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
@@ -927,9 +927,17 @@ static int spmmc_drv_probe(struct platform_device *pdev)
 	host->tuning_info.enable_tuning = 1;
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret)
+		goto pm_disable;
 
-	return ret;
+	return 0;
+
+pm_disable:
+	pm_runtime_disable(&pdev->dev);
+
+clk_disable:
+	clk_disable_unprepare(host->clk);
 
 probe_free_host:
 	if (mmc)
-- 
2.41.0



