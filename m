Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF10EC8E5
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:37:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3381CC433C9;
	Mon, 26 Jun 2023 18:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804657;
	bh=k8cebMUC1HzA/OLOaDTCYsdJDPnZSo/0ZJcUIwKpstA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DyJ4goQsvff1nXZgnRmhvJNeztLKHV5FcdMaw75flt3L5voz4zfK4pBsTTpLYecQC
	 PxRVJwivtvVqk2bLqCpLQF91p9shEdw1ycjghhCXSvDS7feZ/exYHXz8VcGifwd8Ov
	 z/Zh/8Ijki2j9cwH/OluKQBXKZ/1aFxgI+42JW6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangtao Li <tiny.windzz@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 30/60] mmc: mvsdio: convert to devm_platform_ioremap_resource
Date: Mon, 26 Jun 2023 20:12:09 +0200
Message-ID: <20230626180740.764186004@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180739.558575012@linuxfoundation.org>
References: <20230626180739.558575012@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yangtao Li <tiny.windzz@gmail.com>

[ Upstream commit 0a337eb168d6cbb85f6b4eb56d1be55e24c80452 ]

Use devm_platform_ioremap_resource() to simplify code.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Link: https://lore.kernel.org/r/20191215175120.3290-11-tiny.windzz@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 8d84064da0d4 ("mmc: mvsdio: fix deferred probing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mvsdio.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
index 74a0a7fbbf7fd..203b617126014 100644
--- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@ -696,16 +696,14 @@ static int mvsd_probe(struct platform_device *pdev)
 	struct mmc_host *mmc = NULL;
 	struct mvsd_host *host = NULL;
 	const struct mbus_dram_target_info *dram;
-	struct resource *r;
 	int ret, irq;
 
 	if (!np) {
 		dev_err(&pdev->dev, "no DT node\n");
 		return -ENODEV;
 	}
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	irq = platform_get_irq(pdev, 0);
-	if (!r || irq < 0)
+	if (irq < 0)
 		return -ENXIO;
 
 	mmc = mmc_alloc_host(sizeof(struct mvsd_host), &pdev->dev);
@@ -758,7 +756,7 @@ static int mvsd_probe(struct platform_device *pdev)
 
 	spin_lock_init(&host->lock);
 
-	host->base = devm_ioremap_resource(&pdev->dev, r);
+	host->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(host->base)) {
 		ret = PTR_ERR(host->base);
 		goto out;
-- 
2.39.2



