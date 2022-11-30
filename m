Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8656FA1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B6AC433C1;
	Wed, 30 Nov 2022 18:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669832938;
	bh=0UE29nwUynVKzO0dAM11rnMEA4+fasz6dd8cQikoU7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=juXerGe78KYbSiZa2NJzKaKtCV7AgjLS+EqTnrkkAtFF/5cG+xZDhhN8HUtRErIM8
	 oKUo9KVIng3oMd2jlLFXWUfoG/cDeEP39L9OmWjvPVujodogub4E55+N/p3VYQaD5L
	 0nzhBGrIU4KZK/MpEAfMqDqkWWK78lY9gi1TLtn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sam Protsenko <semen.protsenko@linaro.org>
Subject: [PATCH 5.10 093/162] usb: dwc3: exynos: Fix remove() function
Date: Wed, 30 Nov 2022 19:22:54 +0100
Message-Id: <20221130180531.017006140@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit e0481e5b3cc12ea7ccf4552d41518c89d3509004 upstream.

The core DWC3 device node was not properly removed by the custom
dwc3_exynos_remove_child() function. Replace it with generic
of_platform_depopulate() which does that job right.

Fixes: adcf20dcd262 ("usb: dwc3: exynos: Use of_platform API to create dwc3 core pdev")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc: stable@vger.kernel.org
Reviewed-by: Sam Protsenko <semen.protsenko@linaro.org>
Link: https://lore.kernel.org/r/20221110154131.2577-1-m.szyprowski@samsung.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-exynos.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/drivers/usb/dwc3/dwc3-exynos.c
+++ b/drivers/usb/dwc3/dwc3-exynos.c
@@ -37,15 +37,6 @@ struct dwc3_exynos {
 	struct regulator	*vdd10;
 };
 
-static int dwc3_exynos_remove_child(struct device *dev, void *unused)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-
-	platform_device_unregister(pdev);
-
-	return 0;
-}
-
 static int dwc3_exynos_probe(struct platform_device *pdev)
 {
 	struct dwc3_exynos	*exynos;
@@ -142,7 +133,7 @@ static int dwc3_exynos_remove(struct pla
 	struct dwc3_exynos	*exynos = platform_get_drvdata(pdev);
 	int i;
 
-	device_for_each_child(&pdev->dev, NULL, dwc3_exynos_remove_child);
+	of_platform_depopulate(&pdev->dev);
 
 	for (i = exynos->num_clks - 1; i >= 0; i--)
 		clk_disable_unprepare(exynos->clks[i]);


