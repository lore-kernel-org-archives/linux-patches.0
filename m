Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C79223711;
	Thu, 12 Dec 2024 17:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022987; cv=none; b=b+yIpXa62ui+Lv5qu20ROIS9TPYgEe8HyFjJfG2P5Yjd0RNS9WlOuTU9xLWFEVJz21KMVisn1/hJn2OP99PllAw+ADLid7ZrNzRp5WFEs4esjMRrgoiDAqS19q16cEz88rPLXXUmIA9tRFy2MjyPf4TI8KE4HNKr0PViSLhwkSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022987; c=relaxed/simple;
	bh=jDiilNXGbDBsqdz0QSYwuMK923mgqjZo3A62LsUJ+vE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CIe79fmhQpNKmQFUyH2DsWzTgL/RYUXPWmh6QuiaP5y3+2i5cgfU+2AAHC+fCcIX6OjQcdfWRZ/AFOdFC3XDK8f7w61ruwwB5j/FcP6ZsYfsQswFrM1zUWCbkyzBKUpbmqXbYI0lDzD1JpUTz8BWog56qe3pyiLfTNeK3JtGIBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QIMvcoex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QIMvcoex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36EBC4CECE;
	Thu, 12 Dec 2024 17:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022987;
	bh=jDiilNXGbDBsqdz0QSYwuMK923mgqjZo3A62LsUJ+vE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QIMvcoexl4vOY5b69hQcMFyb9YrexIQCbIUWuyH9md1K1fK5nCKUmijgLhhU3dhwz
	 BXfPqEGcLNn2M4nvS2upRWNPqUifk9QsJodKWGf1ZS5X4kXgs8L3I0oXTuQnU77PVB
	 LnxkZb4az7oLqk9NpwTF95yXnjxiGvqP7ZmZ2bGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 358/565] rtc: st-lpc: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Thu, 12 Dec 2024 15:59:13 +0100
Message-ID: <20241212144325.760751206@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d04d46f9cc65a..23fbe25edeff1 100644
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
 
 	rtc->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(rtc->clk)) {
-- 
2.43.0



