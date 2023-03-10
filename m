Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECB3847F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:55:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4659DC433D2;
	Fri, 10 Mar 2023 13:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456544;
	bh=G5Tt5UtAX9wH11AZdDhFBNI+5/gV5rrhZrVOdn0oV9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VY3aPBxZSqnxeSAPnem2+ddkjswse5zJIIcyu/GvT0MCKPKJORDPyrDuOM5mcOz1b
	 NSioq7zOkmK1Gsz0TgaPc2VPrWCmzTsp3kKBtseaCZm8WQGaS6oX36UeDCvvAB2TzR
	 s0/Tj4acNim44c80r9ykuc1mrpfmFCl1eYJyt+h0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 012/211] soc: mediatek: mtk-svs: Enable the IRQ later
Date: Fri, 10 Mar 2023 14:36:32 +0100
Message-Id: <20230310133719.098447739@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit b74952aba6c3f47e7f2c5165abaeefa44c377140 ]

If the system does not come from reset (like when is booted via
kexec()), the peripheral might triger an IRQ before the data structures
are initialised.

Fixes:

[    0.227710] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000f08
[    0.227913] Call trace:
[    0.227918]  svs_isr+0x8c/0x538

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Link: https://lore.kernel.org/r/20221127-mtk-svs-v2-0-145b07663ea8@chromium.org
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mtk-svs.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/soc/mediatek/mtk-svs.c b/drivers/soc/mediatek/mtk-svs.c
index 0469c9dfeb04e..75b2f534aa9d0 100644
--- a/drivers/soc/mediatek/mtk-svs.c
+++ b/drivers/soc/mediatek/mtk-svs.c
@@ -2385,14 +2385,6 @@ static int svs_probe(struct platform_device *pdev)
 		goto svs_probe_free_resource;
 	}
 
-	ret = devm_request_threaded_irq(svsp->dev, svsp_irq, NULL, svs_isr,
-					IRQF_ONESHOT, svsp->name, svsp);
-	if (ret) {
-		dev_err(svsp->dev, "register irq(%d) failed: %d\n",
-			svsp_irq, ret);
-		goto svs_probe_free_resource;
-	}
-
 	svsp->main_clk = devm_clk_get(svsp->dev, "main");
 	if (IS_ERR(svsp->main_clk)) {
 		dev_err(svsp->dev, "failed to get clock: %ld\n",
@@ -2414,6 +2406,14 @@ static int svs_probe(struct platform_device *pdev)
 		goto svs_probe_clk_disable;
 	}
 
+	ret = devm_request_threaded_irq(svsp->dev, svsp_irq, NULL, svs_isr,
+					IRQF_ONESHOT, svsp->name, svsp);
+	if (ret) {
+		dev_err(svsp->dev, "register irq(%d) failed: %d\n",
+			svsp_irq, ret);
+		goto svs_probe_iounmap;
+	}
+
 	ret = svs_start(svsp);
 	if (ret) {
 		dev_err(svsp->dev, "svs start fail: %d\n", ret);
-- 
2.39.2



