Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B9446B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:24:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0781AC433EF;
	Mon, 16 Jan 2023 16:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886277;
	bh=XtJfKgbnTbUifaexgNZCFK6BnbTpFrUuNVKDGKvIlEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G+0ZtEGGU7Mq9wlHH2R/G6c0oTErX9wy+vS3XQB874cVvjuOyODwyTJREW863tYzz
	 wv18G2JDWSmrwOMfgtgWP2HTgq3XP/OCVe3MTJNEFnqD6BfW8jQBbLPrEpnPXU3Ctr
	 F1ftJfhHlE6aIJ3Jm7rrDbciBfLw0KnfDu9+PTvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 369/658] rtc: pic32: Move devm_rtc_allocate_device earlier in pic32_rtc_probe()
Date: Mon, 16 Jan 2023 16:47:37 +0100
Message-Id: <20230116154926.456760800@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

[ Upstream commit 90cd5c88830140c9fade92a8027e0fb2c6e4cc49 ]

The pic32_rtc_enable(pdata, 0) and clk_disable_unprepare(pdata->clk)
should be called in the error handling of devm_rtc_allocate_device(),
so we should move devm_rtc_allocate_device earlier in pic32_rtc_probe()
to fix it.

Fixes: 6515e23b9fde ("rtc: pic32: convert to devm_rtc_allocate_device")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Link: https://lore.kernel.org/r/20221123015953.1998521-1-cuigaosheng1@huawei.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pic32.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-pic32.c b/drivers/rtc/rtc-pic32.c
index 17653ed52ebb..40f293621b01 100644
--- a/drivers/rtc/rtc-pic32.c
+++ b/drivers/rtc/rtc-pic32.c
@@ -326,16 +326,16 @@ static int pic32_rtc_probe(struct platform_device *pdev)
 
 	spin_lock_init(&pdata->alarm_lock);
 
+	pdata->rtc = devm_rtc_allocate_device(&pdev->dev);
+	if (IS_ERR(pdata->rtc))
+		return PTR_ERR(pdata->rtc);
+
 	clk_prepare_enable(pdata->clk);
 
 	pic32_rtc_enable(pdata, 1);
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	pdata->rtc = devm_rtc_allocate_device(&pdev->dev);
-	if (IS_ERR(pdata->rtc))
-		return PTR_ERR(pdata->rtc);
-
 	pdata->rtc->ops = &pic32_rtcops;
 	pdata->rtc->range_min = RTC_TIMESTAMP_BEGIN_2000;
 	pdata->rtc->range_max = RTC_TIMESTAMP_END_2099;
-- 
2.35.1



