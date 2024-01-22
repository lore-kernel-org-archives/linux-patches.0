Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E9567E69;
	Tue, 23 Jan 2024 02:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975308; cv=none; b=QHXpFZHBuYyX1ShKNLvqQfLyttrd196RvYj2ri6FDRxjgdx+SrhH4rdGPcGsQ9b9VtlHNxGIAZDuHNBOWrnJhpxIF5hWKU5MvmySYYccPH/af2WGGMwEKjoW+xbTQAZysaT/E3B5OdOl1oJDpuPpkFsnDQqXch6/HCsPBe9bg2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975308; c=relaxed/simple;
	bh=UVurAeQAsQZwZJl3+QQFMuLaUBATAXUZWOQl2jICaAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SqHumr49meEXrWBBrO3UEBTl5xcwdL5FDhrRjy9RRi2Cg6zwGEn3uwYO00SLWwMQRvvtXHpCtHNFUltSgNebtv6t+m6jHUtfAAI4gB6sk8xWMQCq0rGJWhWjyVM2SMTfRqz2TOwFok/kmzBvWt+CcSmQydhWzBSkD2WdWcDhlmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RqWrzrXl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RqWrzrXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8FBC43394;
	Tue, 23 Jan 2024 02:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975308;
	bh=UVurAeQAsQZwZJl3+QQFMuLaUBATAXUZWOQl2jICaAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RqWrzrXlC6zonaVb/hLilt7CvkthZyUUd1bdiK63P9RUmjVxaeaewqm/nW/K5rYS3
	 GmGdmAQQkTYKILh76/j3qNVGA+YL/oCvodwxaq/RsFYWnIk5vdZK6e1pfDECFfXUpS
	 vAE0NjBI0mLBg6cgAO5kqowI1tz9wXblYSslWBMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 271/583] media: imx-mipi-csis: Drop extra clock enable at probe()
Date: Mon, 22 Jan 2024 15:55:22 -0800
Message-ID: <20240122235820.285695728@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit fb387fcb5cdd0384ba04a5d15a3605e2dccdab2a ]

The driver always enables the clocks at probe() and disables them only
at remove(). It is not clear why the driver does this, as it supports
runtime PM, and enables and disables the clocks in the runtime resume
and suspend callbacks. Also, in the case runtime PM is not available,
the driver calls the resume and suspend callbacks manually from probe()
and remove().

Drop the unnecessary clock enable, thus enabling the clocks only when
actually needed.

Link: https://lore.kernel.org/r/20231122-imx-csis-v2-2-e44b8dc4cb66@ideasonboard.com

Fixes: 7807063b862b ("media: staging/imx7: add MIPI CSI-2 receiver subdev for i.MX7")
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/nxp/imx-mipi-csis.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/nxp/imx-mipi-csis.c b/drivers/media/platform/nxp/imx-mipi-csis.c
index e7629c9f5746..142ac7b73e14 100644
--- a/drivers/media/platform/nxp/imx-mipi-csis.c
+++ b/drivers/media/platform/nxp/imx-mipi-csis.c
@@ -1437,24 +1437,18 @@ static int mipi_csis_probe(struct platform_device *pdev)
 	/* Reset PHY and enable the clocks. */
 	mipi_csis_phy_reset(csis);
 
-	ret = mipi_csis_clk_enable(csis);
-	if (ret < 0) {
-		dev_err(csis->dev, "failed to enable clocks: %d\n", ret);
-		return ret;
-	}
-
 	/* Now that the hardware is initialized, request the interrupt. */
 	ret = devm_request_irq(dev, irq, mipi_csis_irq_handler, 0,
 			       dev_name(dev), csis);
 	if (ret) {
 		dev_err(dev, "Interrupt request failed\n");
-		goto err_disable_clock;
+		return ret;
 	}
 
 	/* Initialize and register the subdev. */
 	ret = mipi_csis_subdev_init(csis);
 	if (ret < 0)
-		goto err_disable_clock;
+		return ret;
 
 	platform_set_drvdata(pdev, &csis->sd);
 
@@ -1488,8 +1482,6 @@ static int mipi_csis_probe(struct platform_device *pdev)
 	v4l2_async_nf_unregister(&csis->notifier);
 	v4l2_async_nf_cleanup(&csis->notifier);
 	v4l2_async_unregister_subdev(&csis->sd);
-err_disable_clock:
-	mipi_csis_clk_disable(csis);
 
 	return ret;
 }
@@ -1508,7 +1500,6 @@ static void mipi_csis_remove(struct platform_device *pdev)
 		mipi_csis_runtime_suspend(&pdev->dev);
 
 	pm_runtime_disable(&pdev->dev);
-	mipi_csis_clk_disable(csis);
 	v4l2_subdev_cleanup(&csis->sd);
 	media_entity_cleanup(&csis->sd.entity);
 	pm_runtime_set_suspended(&pdev->dev);
-- 
2.43.0



