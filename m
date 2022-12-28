Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506961C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:34:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB86CC433EF;
	Wed, 28 Dec 2022 16:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245276;
	bh=uMPZJZriCIwf8DxTQjTugYFL0BWpn/O0UZhlxTTMv64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QtJJf5FfLiW9NivtD1NM8OFaStXx+xTKo1VVm3qdARk47mCi7z6Lsu8pUUJO2OydD
	 5xOu3rIzAqlDvK6XwMr1AgwI9ojgrFRhQ4W7+n9iTM9zAx6DBnTiVFBq7AKN/A6yM4
	 Rlm/3FTYMsq1wbiQJQP0TD/+IOLbrD9gRHE7XTjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yushan Zhou <katrinzhou@tencent.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0831/1146] rtc: rzn1: Check return value in rzn1_rtc_probe
Date: Wed, 28 Dec 2022 15:39:30 +0100
Message-Id: <20221228144352.729627105@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yushan Zhou <katrinzhou@tencent.com>

[ Upstream commit 9800f24f7bd5b99fb4fc4ce981427102e2e15a1c ]

The rzn1_rtc_probe() function utilizes devm_pm_runtime_enable()
but wasn't checking the return value. Fix it by adding missing
check.

Fixes: deeb4b5393e1 ("rtc: rzn1: Add new RTC driver")

Signed-off-by: Yushan Zhou <katrinzhou@tencent.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20221107092544.3721053-1-zys.zljxml@gmail.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-rzn1.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-rzn1.c b/drivers/rtc/rtc-rzn1.c
index ac788799c8e3..0d36bc50197c 100644
--- a/drivers/rtc/rtc-rzn1.c
+++ b/drivers/rtc/rtc-rzn1.c
@@ -355,7 +355,9 @@ static int rzn1_rtc_probe(struct platform_device *pdev)
 	set_bit(RTC_FEATURE_ALARM_RES_MINUTE, rtc->rtcdev->features);
 	clear_bit(RTC_FEATURE_UPDATE_INTERRUPT, rtc->rtcdev->features);
 
-	devm_pm_runtime_enable(&pdev->dev);
+	ret = devm_pm_runtime_enable(&pdev->dev);
+	if (ret < 0)
+		return ret;
 	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0)
 		return ret;
-- 
2.35.1



