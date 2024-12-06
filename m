Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EA3154449;
	Fri,  6 Dec 2024 15:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498453; cv=none; b=imlUia2QLzbuI0Qwq3ebIzvWEpg8X2Wqh2LCb+uYzuesuMrEIOM65zcrAVirGR9SpaSIRVAjn5bD1jAAK1KjQjzEXFK2rrUtENBuC6uPjB33TUMwr3q1DtL8WPY4tvVQgzp6OB+EIkjLmevMTKloVEmRA47WvSP+MA5C2zkKEPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498453; c=relaxed/simple;
	bh=h6gxRq9o3V7a+rgC9VuOwS6jsNKl1CIlsovMxjTrh0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qtIzptseJWvzrAavaANs92OlxXyXL2XSqIrXnSuzfImVAeA7pRyBXqzQ4C35cc8HDykYTAlGdOMQi3R/VabCwn5NJi4mzQVFAHG1lMLcb9JpqDE2Rdu10EwLDgesJG2Lnk6INCl216zDHaQy8MKafm7SsYTdbyUwDKgItgD40/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yphg/rEm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yphg/rEm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5544C4CED1;
	Fri,  6 Dec 2024 15:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498453;
	bh=h6gxRq9o3V7a+rgC9VuOwS6jsNKl1CIlsovMxjTrh0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yphg/rEmbTG5x73W0XFVd2N6oAFLhhX4lMti8O7viw1tRh4HxB0mtIdEtRTEmIr2V
	 KLzXT3qra5KP8CCOwiGTeUjguxOgpNafEUraR5+3WYuBLHtQhWcl5MNigmgfhN00tA
	 kNDbI6xigVuLy3UxssLHJeSpemL+ATkS14L3+QNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 558/676] rtc: st-lpc: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Fri,  6 Dec 2024 15:36:17 +0100
Message-ID: <20241206143715.165098156@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



