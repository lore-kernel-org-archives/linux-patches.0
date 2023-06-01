Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3D9E54A
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:24:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6FCC433D2;
	Thu,  1 Jun 2023 13:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685625845;
	bh=XJ+N4XuCt8nbzf6Xq447rADOVYBS3SJmKWnLuyNMcBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jGykFJ9knc4+msBz+MxgB6oqIs+ibBR4HRvLeMPzWzo5mDwIfbE3Nxvk3s05yme5/
	 hauj3uDfEAvV25CLdr5KuLRHogAvZ2XUuLiPmyFD5xdb80AuGMtNYXEw2F6BQrq7Nn
	 AizDzWMkHFxGk3VdtbvsaFABMZuQPIp/YB/IRpQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 16/42] dmaengine: at_xdmac: disable/enable clock directly on suspend/resume
Date: Thu,  1 Jun 2023 14:21:03 +0100
Message-Id: <20230601131937.458641957@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131936.699199833@linuxfoundation.org>
References: <20230601131936.699199833@linuxfoundation.org>
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
Stable-dep-of: 44fe8440bda5 ("dmaengine: at_xdmac: do not resume channels paused by consumers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/at_xdmac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/at_xdmac.c b/drivers/dma/at_xdmac.c
index f9aa5396c0f8e..af52429af9172 100644
--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -1992,6 +1992,7 @@ static int atmel_xdmac_suspend(struct device *dev)
 
 	at_xdmac_off(atxdmac);
 	clk_disable_unprepare(atxdmac->clk);
+
 	return 0;
 }
 
@@ -2008,6 +2009,8 @@ static int atmel_xdmac_resume(struct device *dev)
 	if (ret)
 		return ret;
 
+	pm_runtime_get_noresume(atxdmac->dev);
+
 	at_xdmac_axi_config(pdev);
 
 	/* Clear pending interrupts. */
-- 
2.39.2



