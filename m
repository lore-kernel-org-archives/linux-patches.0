Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7CEBA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09B7C433D2;
	Tue,  7 Mar 2023 18:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213469;
	bh=lftiFON32ns5sG/ore+XaPFuMZmxfIP7c0s+fs7HcHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Je8rzS3joyds4qLy22U9uKt2fNc1/Pr7mcNzZhOKLDPTxFTxlBP7pb4X3XRNLT+3j
	 OYTXMei8vNJ9L2OwrWRaX/HJ03It2ew1tVFr0yWGRCfZw3/in8WUEe9VWyTnOmF/Rf
	 mw1Sk5K3K2WAZndoC8jc42+2cr6SwKMnwxr5SKAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 517/885] media: imx-jpeg: Apply clk_bulk api instead of operating specific clk
Date: Tue,  7 Mar 2023 17:57:31 +0100
Message-Id: <20230307170024.930707593@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit 61fe43dc9f454bc3caa99dbdd8f5fa3ba813981a ]

using the api of clk_bulk can simplify the code.
and the clock of the jpeg codec may be changed,
the clk_bulk api can be compatible with the future change.

Fixes: 4c2e5156d9fa ("media: imx-jpeg: Add pm-runtime support for imx-jpeg")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/nxp/imx-jpeg/mxc-jpeg.c    | 35 +++++--------------
 .../media/platform/nxp/imx-jpeg/mxc-jpeg.h    |  4 +--
 2 files changed, 10 insertions(+), 29 deletions(-)

diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
index 32fd04a3d8bb7..81a44702a5413 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -2202,19 +2202,12 @@ static int mxc_jpeg_probe(struct platform_device *pdev)
 	jpeg->mode = mode;
 
 	/* Get clocks */
-	jpeg->clk_ipg = devm_clk_get(dev, "ipg");
-	if (IS_ERR(jpeg->clk_ipg)) {
-		dev_err(dev, "failed to get clock: ipg\n");
-		ret = PTR_ERR(jpeg->clk_ipg);
-		goto err_clk;
-	}
-
-	jpeg->clk_per = devm_clk_get(dev, "per");
-	if (IS_ERR(jpeg->clk_per)) {
-		dev_err(dev, "failed to get clock: per\n");
-		ret = PTR_ERR(jpeg->clk_per);
+	ret = devm_clk_bulk_get_all(&pdev->dev, &jpeg->clks);
+	if (ret < 0) {
+		dev_err(dev, "failed to get clock\n");
 		goto err_clk;
 	}
+	jpeg->num_clks = ret;
 
 	ret = mxc_jpeg_attach_pm_domains(jpeg);
 	if (ret < 0) {
@@ -2311,32 +2304,20 @@ static int mxc_jpeg_runtime_resume(struct device *dev)
 	struct mxc_jpeg_dev *jpeg = dev_get_drvdata(dev);
 	int ret;
 
-	ret = clk_prepare_enable(jpeg->clk_ipg);
-	if (ret < 0) {
-		dev_err(dev, "failed to enable clock: ipg\n");
-		goto err_ipg;
-	}
-
-	ret = clk_prepare_enable(jpeg->clk_per);
+	ret = clk_bulk_prepare_enable(jpeg->num_clks, jpeg->clks);
 	if (ret < 0) {
-		dev_err(dev, "failed to enable clock: per\n");
-		goto err_per;
+		dev_err(dev, "failed to enable clock\n");
+		return ret;
 	}
 
 	return 0;
-
-err_per:
-	clk_disable_unprepare(jpeg->clk_ipg);
-err_ipg:
-	return ret;
 }
 
 static int mxc_jpeg_runtime_suspend(struct device *dev)
 {
 	struct mxc_jpeg_dev *jpeg = dev_get_drvdata(dev);
 
-	clk_disable_unprepare(jpeg->clk_ipg);
-	clk_disable_unprepare(jpeg->clk_per);
+	clk_bulk_disable_unprepare(jpeg->num_clks, jpeg->clks);
 
 	return 0;
 }
diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h
index c508d41a906f4..d742b638ddc93 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h
@@ -114,8 +114,8 @@ struct mxc_jpeg_dev {
 	spinlock_t			hw_lock; /* hardware access lock */
 	unsigned int			mode;
 	struct mutex			lock; /* v4l2 ioctls serialization */
-	struct clk			*clk_ipg;
-	struct clk			*clk_per;
+	struct clk_bulk_data		*clks;
+	int				num_clks;
 	struct platform_device		*pdev;
 	struct device			*dev;
 	void __iomem			*base_reg;
-- 
2.39.2



