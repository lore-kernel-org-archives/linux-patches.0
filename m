Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D91B1F76DE;
	Tue,  3 Dec 2024 15:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239897; cv=none; b=gPaJ80qEzLLmyFRQYq2C1gxkCpk07rwjNXF7EVsc2+FWWWdt6Zu9SXsb12FMg2r6aweqFJWaxILsrnciXuWn+5Fjj336WKxPGMipl3D2egF70d4Pe/zqPUBRm/dUE5X3uH01FrPhC/g9ou19eQn6Tyfy0ykrntHOgVwTLfindFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239897; c=relaxed/simple;
	bh=v8GLLvtzfjVVUdRHIvRVHaLVaxx1sFJBSfpqAtBPXCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OUGtt1gBwi8t3FyKpqMsXWLNbT7IMRWOIocBvvGkivw+h8s+qE/tL5Pi0UC8lT6He+Y/YnpQLRgkTU72awYpJkioy+U5yevGheVdxt9g90kXY4lGmmv0iU5Zp8bhnhWuKWLJWiduGWt4ujqrvA5vrqPg+kNOuc0g26Avf+TBa5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qskBcW44; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qskBcW44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F87CC4CED6;
	Tue,  3 Dec 2024 15:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239897;
	bh=v8GLLvtzfjVVUdRHIvRVHaLVaxx1sFJBSfpqAtBPXCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qskBcW44XnBoOc7ssbL6DdFOoTGGP5EnuLlvhb0EGUgPLugDieF9N9hxwVJwT9WJX
	 0pMSBQLnIMvjzktMUgGZk1o4gfRb/GU+IkU7q1sZLGvrhUBpVql03LlLW9P6y8/LPt
	 hH6gSsUrwi2Xuw7xu+eCA8DkPU/qy6drLhRFwQoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 771/817] rtc: st-lpc: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Tue,  3 Dec 2024 15:45:43 +0100
Message-ID: <20241203144026.109745363@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit b6cd7adec0cf03f0aefc55676e71dd721cbc71a8 ]

If request_irq() fails in st_rtc_probe(), there is no need to enable
the irq, and if it succeeds, disable_irq() after request_irq() still has
a time gap in which interrupts can come.

request_irq() with IRQF_NO_AUTOEN flag will disable IRQ auto-enable when
request IRQ.

Fixes: b5b2bdfc2893 ("rtc: st: Add new driver for ST's LPC RTC")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://lore.kernel.org/r/20240912033727.3013951-1-ruanjinjie@huawei.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-st-lpc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-st-lpc.c b/drivers/rtc/rtc-st-lpc.c
index d492a2d26600c..c6d4522411b31 100644
--- a/drivers/rtc/rtc-st-lpc.c
+++ b/drivers/rtc/rtc-st-lpc.c
@@ -218,15 +218,14 @@ static int st_rtc_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	ret = devm_request_irq(&pdev->dev, rtc->irq, st_rtc_handler, 0,
-			       pdev->name, rtc);
+	ret = devm_request_irq(&pdev->dev, rtc->irq, st_rtc_handler,
+			       IRQF_NO_AUTOEN, pdev->name, rtc);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to request irq %i\n", rtc->irq);
 		return ret;
 	}
 
 	enable_irq_wake(rtc->irq);
-	disable_irq(rtc->irq);
 
 	rtc->clk = devm_clk_get_enabled(&pdev->dev, NULL);
 	if (IS_ERR(rtc->clk))
-- 
2.43.0



