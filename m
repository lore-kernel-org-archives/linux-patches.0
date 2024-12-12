Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D3C215041;
	Thu, 12 Dec 2024 17:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025482; cv=none; b=ftBba4D+ROW+dT2GfNACoG6SevNxmRf+SXWb6mFSl81IJMpyLsycRw4lJNPQfOA5ZYf7xsilWjMPVZ8PrcqZ8oaBPw5IDKkUOTtMotfMlnebiyQhIeEZhnh8TixK7ickmZ9ebDESMb8gCFH46ZSn+nGduqT0vi6BF8Cuz5unkug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025482; c=relaxed/simple;
	bh=UhEOqj22f6dZjS7pQvQwJEEyEvUAge9r363dvRAnXU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6zpzK6A5vMrHE1q/BhGYaPK78PMObbr9xUB73t7asJpfzJtRXkbcFIvx08inWQiQUnVDiqzorbXHqPfUMVsyqoQ2J0iO2jlzACzMWGJh+JOdYQhUwl8eGbToxc+IqS2yaTwOlaPJnSjH4Hxy+txhm+gPQxE75So93mxPGMEuvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QfX8fEt/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QfX8fEt/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258C9C4CECE;
	Thu, 12 Dec 2024 17:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025482;
	bh=UhEOqj22f6dZjS7pQvQwJEEyEvUAge9r363dvRAnXU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QfX8fEt/X6aJgrt92RSOF8jDhybBwJbZPvprZCx6kPIPus9mq44ohttIWD8uZCGvu
	 Dxsn39lnPQiucvnd9ChiX6+w37XzpbuJNcdXUcIhzcKVMem+mJXyRyPGXAN/NXVXZd
	 rculsXyCoj4OalsngvJivznXIScCaGpH39xOdMAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 185/321] rtc: st-lpc: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Thu, 12 Dec 2024 16:01:43 +0100
Message-ID: <20241212144237.294428425@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 2031d042c5e44..d0cfc80342e10 100644
--- a/drivers/rtc/rtc-st-lpc.c
+++ b/drivers/rtc/rtc-st-lpc.c
@@ -221,15 +221,14 @@ static int st_rtc_probe(struct platform_device *pdev)
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
 
 	rtc->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(rtc->clk)) {
-- 
2.43.0



