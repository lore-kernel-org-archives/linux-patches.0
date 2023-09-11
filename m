Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C87A1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17D9C433C8;
	Mon, 11 Sep 2023 14:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442048;
	bh=Xc9SSexNzep9L+H+EJveJBdndh2/+7x24j3XzEECMF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bIuLwo4yFCM2t4SdsSl0AtrSNEtkLmXSWgbqfkqKcH7v9+ak/mpgCjSPNbGH6uCSx
	 Mlm6Lsov8sxu0I+vcpTwKYgQvYFdaQKxwZcU1gDzALTgaVDeNdJz8bnwheVLYD4R9L
	 njYavMA+NzwI1AIEE0XlidwTJOG+Jw6NxGM/0JPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Marek Vasut <marex@denx.de>,
	Peng Fan <peng.fan@nxp.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 610/739] thermal/drivers/imx8mm: Suppress log message on probe deferral
Date: Mon, 11 Sep 2023 15:46:49 +0200
Message-ID: <20230911134708.138002070@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

[ Upstream commit 4afcb58ea47e66c025d2b0a5f091dce5aaf95b0f ]

nvmem_cell_read_u32() may return -EPROBE_DEFER if NVMEM supplier has not
yet been probed. Future reprobe may succeed, so printing:

  i.mx8mm_thermal 30260000.tmu: Failed to read OCOTP nvmem cell (-517).

to the log is confusing. Fix this by using dev_err_probe. This also
elevates the message from warning to error, which is more correct: The
log message is only ever printed in probe error path and probe aborts
afterwards, so it really warrants an error-level message.

Fixes: 403291648823 ("thermal/drivers/imx: Add support for loading calibration data from OCOTP")
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Reviewed-by: Marek Vasut <marex@denx.de>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20230708112647.2897294-1-a.fatoum@pengutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/imx8mm_thermal.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/imx8mm_thermal.c b/drivers/thermal/imx8mm_thermal.c
index d4b40869c7d7b..dd474166ca671 100644
--- a/drivers/thermal/imx8mm_thermal.c
+++ b/drivers/thermal/imx8mm_thermal.c
@@ -179,10 +179,8 @@ static int imx8mm_tmu_probe_set_calib_v1(struct platform_device *pdev,
 	int ret;
 
 	ret = nvmem_cell_read_u32(&pdev->dev, "calib", &ana0);
-	if (ret) {
-		dev_warn(dev, "Failed to read OCOTP nvmem cell (%d).\n", ret);
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to read OCOTP nvmem cell\n");
 
 	writel(FIELD_PREP(TASR_BUF_VREF_MASK,
 			  FIELD_GET(ANA0_BUF_VREF_MASK, ana0)) |
-- 
2.40.1



