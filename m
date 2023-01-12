Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED0279C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3C1C433EF;
	Thu, 12 Jan 2023 14:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533362;
	bh=/DgKjMxU6hyD45A9yhMhmgnNb9IqEgRUFdJDPpDlL/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJMWFyj6qbSDHxX6GM7lMOHtU4v8+nM/YsqoeajdUMJXn7Rbmx0S4itRdq0Xq/hj8
	 b7UAju94jcmgdWQnhtb/IcW5iYPBV/wx0I5+hwHkKD6s5rFJHgoWnOb39s5R30rivr
	 qUcijYuP8EqzW7Nkc01+skfOWMGm6AyRWW+9JMBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 454/783] rtc: pic32: Move devm_rtc_allocate_device earlier in pic32_rtc_probe()
Date: Thu, 12 Jan 2023 14:52:50 +0100
Message-Id: <20230112135545.298841552@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index 2b6946744654..7be1ca1633fc 100644
--- a/drivers/rtc/rtc-pic32.c
+++ b/drivers/rtc/rtc-pic32.c
@@ -324,16 +324,16 @@ static int pic32_rtc_probe(struct platform_device *pdev)
 
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



