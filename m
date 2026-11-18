Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018045;
	b=pOUIrHwW9pGuGRJ0dBqJZZOQ1mH4CxywZgMG5deJpmozfehNicNzDR7SC8k2XvhVEMK3
	 wOg+ufokefPAnUlRfTllfzhdoLgWTr/XqlYxJ3jBT3fjuc1Fhi5/Wp3+upkOUfLuWahxF
	 pyp93kS5B5smMPlO3MC5+ZE0lblHAxCmUVB4x3ZVRWXralTNP7xloH4ocgJYQY285hO+V
	 jXejP1eijDs6/dzh697PzTLvIbY+rQbcaJbzAxZ+UeSLt6/B2OQlo5jOufxMCWnN98pB+
	 EBCc5WqFqB3KsNfFLy8vZhM4ZUwk5aOFOtOmwYYgX9FV45Hrmsq7cgGYzQ2HT+d9aTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018045;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dVgFTfe80RXAnqk7xuxJFO7vXOdBpS0etVdJawaaaa8=;
	b=BppNMkZKYLD4PHp9pUyxyIkZLlPoZt/MQQ50uVdvguyJqwXLbn1h8t2OSXcLx5Q5ILy0
	 oM7qrCsTcyTRH2od+rQ38/fQT93YCUkwj6qffnEXF/A9Qa3ANsrGsMeJ/2Hn6sLQpuGxV
	 YKo6weVQXNtyyqwuxsXPHVNEdTf3j6P46ViYrXo1+wQOLGWnIcJyst/o+Vk3j0jbtRErb
	 bA60ZJ10U/yh5co64KrPhuJ+Og7dF7aU+3Q5htMACuYPZkae15PgTOItHHH6pSzvWlM1G
	 5duyV/Ee73YcmQwBUJMgHvx5eDecwbdG4g9/v/9C6JS13pk2294WulhZ157Cr1X+Ahg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xctYe1dx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138EE606A320;
	Wed, 18 Nov 2026 16:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xctYe1dx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67BC41F000C4;
	Wed, 18 Nov 2026 16:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018044;
	bh=dVgFTfe80RXAnqk7xuxJFO7vXOdBpS0etVdJawaaaa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xctYe1dx2c0W9B0mImGYZl30LixmPGkC5/w7ofegW2zF0a+Zm1Gm/mgH2NDAJK1mL
	 ldHODKOmisjx4RT3rS1QL9bvhD7JpB6I6mUmWPZAfqPyHG4qtWp+IVgsrD08e0XPFT
	 WBsdvBB7Blz+sAd+QAVpZxNTc1cKYAIxPuGIRZck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Dalin <liudalin@kylinsec.com.cn>,
	Linus Walleij <linusw@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1101/2651] rtc: ftrtc010: use devm clock APIs to fix use-after-disable in remove
Date: Wed, 18 Nov 2026 15:39:01 +0100
Message-ID: <20261118150327.632288221@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Dalin <liudalin@kylinsec.com.cn>

[ Upstream commit d41ee317c9907d714014d0d5e4726fbd6acf338e ]

The driver mixes devm_rtc_register_device() with manual clock
disabling in ftrtc010_rtc_remove(). Because the RTC device was
registered via devm, it remains registered until devres cleanup
runs after .remove() returns. An unprivileged process holding an
open /dev/rtc0 file descriptor could issue ioctl(RTC_RD_TIME)
during this window, triggering MMIO reads on clock-gated hardware
and causing a synchronous external abort.

Replace devm_clk_get() + clk_prepare_enable() with
devm_clk_get_enabled() to tie clock lifecycle to devres. Remove
the manual .remove() callback and the corresponding error handling
labels in ftrtc010_rtc_probe().

Fixes: 1d61d2592c1f ("rtc: ftrtc010: Rename to Faraday FTRTC010")
Assisted-by: Sashiko AI [static analysis]
Signed-off-by: Liu Dalin <liudalin@kylinsec.com.cn>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Tested-by: Liu Dalin <liudalin@kylinsec.com.cn>
Link: https://patch.msgid.link/0238203A74C9B9F6+20260827080320.3351155-3-liudalin@kylinsec.com.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ftrtc010.c | 67 +++++++++-----------------------------
 1 file changed, 16 insertions(+), 51 deletions(-)

diff --git a/drivers/rtc/rtc-ftrtc010.c b/drivers/rtc/rtc-ftrtc010.c
index 512790bc3f2b5..19e6333bfbab8 100644
--- a/drivers/rtc/rtc-ftrtc010.c
+++ b/drivers/rtc/rtc-ftrtc010.c
@@ -119,51 +119,33 @@ static int ftrtc010_rtc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	platform_set_drvdata(pdev, rtc);
 
-	rtc->pclk = devm_clk_get(dev, "PCLK");
-	if (IS_ERR(rtc->pclk)) {
+	rtc->pclk = devm_clk_get_enabled(dev, "PCLK");
+	if (IS_ERR_OR_NULL(rtc->pclk)) {
 		dev_err(dev, "could not get PCLK\n");
-	} else {
-		ret = clk_prepare_enable(rtc->pclk);
-		if (ret) {
-			dev_err(dev, "failed to enable PCLK\n");
-			return ret;
-		}
+		return PTR_ERR_OR_ZERO(rtc->pclk);
 	}
-	rtc->extclk = devm_clk_get(dev, "EXTCLK");
-	if (IS_ERR(rtc->extclk)) {
+	rtc->extclk = devm_clk_get_enabled(dev, "EXTCLK");
+	if (IS_ERR_OR_NULL(rtc->extclk)) {
 		dev_err(dev, "could not get EXTCLK\n");
-	} else {
-		ret = clk_prepare_enable(rtc->extclk);
-		if (ret) {
-			dev_err(dev, "failed to enable EXTCLK\n");
-			goto err_disable_pclk;
-		}
+		return PTR_ERR_OR_ZERO(rtc->extclk);
 	}
 
 	rtc->rtc_irq = platform_get_irq(pdev, 0);
-	if (rtc->rtc_irq < 0) {
-		ret = rtc->rtc_irq;
-		goto err_disable_extclk;
-	}
+	if (rtc->rtc_irq < 0)
+		return rtc->rtc_irq;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		ret = -ENODEV;
-		goto err_disable_extclk;
-	}
+	if (!res)
+		return -ENODEV;
 
 	rtc->rtc_base = devm_ioremap(dev, res->start,
 				     resource_size(res));
-	if (!rtc->rtc_base) {
-		ret = -ENOMEM;
-		goto err_disable_extclk;
-	}
+	if (!rtc->rtc_base)
+		return -ENOMEM;
 
 	rtc_dev = devm_rtc_allocate_device(dev);
-	if (IS_ERR(rtc_dev)) {
-		ret = PTR_ERR(rtc_dev);
-		goto err_disable_extclk;
-	}
+	if (IS_ERR(rtc_dev))
+		return PTR_ERR(rtc_dev);
 
 	rtc_dev->ops = &ftrtc010_rtc_ops;
 
@@ -178,29 +160,13 @@ static int ftrtc010_rtc_probe(struct platform_device *pdev)
 	ret = devm_request_irq(dev, rtc->rtc_irq, ftrtc010_rtc_interrupt,
 			       IRQF_SHARED, pdev->name, dev);
 	if (unlikely(ret))
-		goto err_disable_extclk;
+		return ret;
 
 	ret = devm_rtc_register_device(rtc_dev);
 	if (ret)
-		goto err_disable_extclk;
+		return ret;
 
 	return 0;
-
-err_disable_extclk:
-	clk_disable_unprepare(rtc->extclk);
-err_disable_pclk:
-	clk_disable_unprepare(rtc->pclk);
-	return ret;
-}
-
-static void ftrtc010_rtc_remove(struct platform_device *pdev)
-{
-	struct ftrtc010_rtc *rtc = platform_get_drvdata(pdev);
-
-	if (!IS_ERR(rtc->extclk))
-		clk_disable_unprepare(rtc->extclk);
-	if (!IS_ERR(rtc->pclk))
-		clk_disable_unprepare(rtc->pclk);
 }
 
 static const struct of_device_id ftrtc010_rtc_dt_match[] = {
@@ -216,7 +182,6 @@ static struct platform_driver ftrtc010_rtc_driver = {
 		.of_match_table = ftrtc010_rtc_dt_match,
 	},
 	.probe		= ftrtc010_rtc_probe,
-	.remove		= ftrtc010_rtc_remove,
 };
 
 module_platform_driver_probe(ftrtc010_rtc_driver, ftrtc010_rtc_probe);
-- 
2.53.0



