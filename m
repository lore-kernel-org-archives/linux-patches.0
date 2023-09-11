Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A191211706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B6CC433C9;
	Mon, 11 Sep 2023 14:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444200;
	bh=wniMVd1Ab9YMOLjSDrTD4Xd/8+xtbCB7+HtF+7ZUC0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fk2a3ftEsqnUmdk1Z7kpwVODSp9HRT+wEnUw7N6P7zrarJDnN/GMbAlWuki7t4+sK
	 Onwkit2j3pw9L811jPdUJ7RehrV2+o7BXCT6hVQv8PN9Iv3A5neeeatu16vrm+tBhY
	 htrFLoWoFixA2uRNw5eH6KbAZo8mdmz18FyV9RFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Marek Vasut <marex@denx.de>,
	Peng Fan <peng.fan@nxp.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 617/737] thermal/drivers/imx8mm: Suppress log message on probe deferral
Date: Mon, 11 Sep 2023 15:47:56 +0200
Message-ID: <20230911134707.766813407@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

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
index d8005e9ec992b..1f780c4a1c890 100644
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



