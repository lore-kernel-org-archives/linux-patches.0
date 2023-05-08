Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3306168D1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6608DC433D2;
	Mon,  8 May 2023 11:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545182;
	bh=rOH1ss8kEGYw0aRvGuspzfaz6QYauXSlvNI3STWi7A4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0O1VwPU2GfqLpKcDPZMV4VaryubKye4Bv92WXgPh6twWnQjvGgbQRzh8H+XzZvxZ
	 KNEuV8LfoEBhsShcZpFNEvRYEDlq7UBEmjMDsgEL7wSMwlRgeQ1pQ7SJRX6IxnAHY5
	 Ak6t2oXU8DtOwdbgdMaZMu8KOQWumDSLQq22RoFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 652/694] dmaengine: at_xdmac: disable/enable clock directly on suspend/resume
Date: Mon,  8 May 2023 11:48:07 +0200
Message-Id: <20230508094457.061648530@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 2de5ddb5e68c94b781b3789bca1ce52000d7d0e0 ]

Runtime PM APIs for at_xdmac just plays with clk_enable()/clk_disable()
letting aside the clk_prepare()/clk_unprepare() that needs to be
executed as the clock is also prepared on probe. Thus instead of using
runtime PM force suspend/resume APIs use
clk_disable_unprepare() + pm_runtime_put_noidle() on suspend and
clk_prepare_enable() + pm_runtime_get_noresume() on resume. This
approach as been chosen instead of using runtime PM force suspend/resume
with clk_unprepare()/clk_prepare() as it looks simpler and the final
code is better.

While at it added the missing pm_runtime_mark_last_busy() on suspend before
decrementing the reference counter.

Fixes: 650b0e990cbd ("dmaengine: at_xdmac: add runtime pm support")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20230214151827.1050280-2-claudiu.beznea@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/at_xdmac.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/at_xdmac.c b/drivers/dma/at_xdmac.c
index 1f0fab180f8f1..f654ecaafb906 100644
--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -2130,7 +2130,11 @@ static int __maybe_unused atmel_xdmac_suspend(struct device *dev)
 	atxdmac->save_gim = at_xdmac_read(atxdmac, AT_XDMAC_GIM);
 
 	at_xdmac_off(atxdmac);
-	return pm_runtime_force_suspend(atxdmac->dev);
+	pm_runtime_mark_last_busy(atxdmac->dev);
+	pm_runtime_put_noidle(atxdmac->dev);
+	clk_disable_unprepare(atxdmac->clk);
+
+	return 0;
 }
 
 static int __maybe_unused atmel_xdmac_resume(struct device *dev)
@@ -2142,10 +2146,12 @@ static int __maybe_unused atmel_xdmac_resume(struct device *dev)
 	int			i;
 	int ret;
 
-	ret = pm_runtime_force_resume(atxdmac->dev);
-	if (ret < 0)
+	ret = clk_prepare_enable(atxdmac->clk);
+	if (ret)
 		return ret;
 
+	pm_runtime_get_noresume(atxdmac->dev);
+
 	at_xdmac_axi_config(pdev);
 
 	/* Clear pending interrupts. */
-- 
2.39.2



