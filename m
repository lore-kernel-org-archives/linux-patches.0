Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D19421ADAE;
	Tue,  8 Apr 2025 11:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110764; cv=none; b=i/0wtsCNJ9vq1IaD1J8P/9TfRo0PE9zl2c/D6ik4EZLU+9xtXhewJLsXZ3tvdsRpz20I/rtNIj7JU+iT4VBxUrLz83J3qL2o66WbjhcwBx/vQccI9844oEjfsyJtCoCD4LcsFIe8RZoK83W2RjfKrkSkZp6MZMqZMvSH3leA+mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110764; c=relaxed/simple;
	bh=wx5Ey+A+A4DsIB/QCeEphmL/vCQs0PWwibkSjjTVqQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3vBvtZqCJWpF+c+DmTSuWSm4EssbqedpryOjulNx5bZ/qnTTg3VcpzqV34+JOTLahnRRcdaeImBBkyvv2c9u90Vx7cE1YVp7afOTZ9OW6chcEo9Mp8Whk6BLCUvH/UPM6QASbp1ushCIhSm2lUY27cfZatqkZSe7yAeQxvRjto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CnPCT2Mb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CnPCT2Mb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9755C4CEE7;
	Tue,  8 Apr 2025 11:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110764;
	bh=wx5Ey+A+A4DsIB/QCeEphmL/vCQs0PWwibkSjjTVqQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CnPCT2MbSZvc8qPuMFlrnYUNy7QCBIqyxv1gmEvdJvL8G/E/MwR+fmiBJx5iEooEW
	 oQJLQLA9MYHWbnUyUDn2HGbfJwoV8ztlLJMS/vpc/sz2j85bRGkNRF2YbWjA6V4kwO
	 ZhbKftaSCpKY3cjCSnl8uk8XcnlFBRb1sxIbMJ9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 186/731] bus: qcom-ssc-block-bus: Fix the error handling path of qcom_ssc_block_bus_probe()
Date: Tue,  8 Apr 2025 12:41:23 +0200
Message-ID: <20250408104918.604254557@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit f41658cd081ad7697796b3dacd9a717a57919268 ]

If qcom_ssc_block_bus_pds_enable() fails, the previous call to
qcom_ssc_block_bus_pds_attach() must be undone, as already done in the
remove function.

In order to do that, move the code related to the power domains management
to the end of the function, in order to avoid many changes in all the error
handling path that would need to go through the new error handling path.

Fixes: 97d485edc1d9 ("bus: add driver for initializing the SSC bus on (some) qcom SoCs")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/1b89ec7438c9a893c09083e8591772c8ad3cb599.1740932040.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/qcom-ssc-block-bus.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/bus/qcom-ssc-block-bus.c b/drivers/bus/qcom-ssc-block-bus.c
index c95a985e34988..7f5fd4e0940dc 100644
--- a/drivers/bus/qcom-ssc-block-bus.c
+++ b/drivers/bus/qcom-ssc-block-bus.c
@@ -264,18 +264,6 @@ static int qcom_ssc_block_bus_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, data);
 
-	data->pd_names = qcom_ssc_block_pd_names;
-	data->num_pds = ARRAY_SIZE(qcom_ssc_block_pd_names);
-
-	/* power domains */
-	ret = qcom_ssc_block_bus_pds_attach(&pdev->dev, data->pds, data->pd_names, data->num_pds);
-	if (ret < 0)
-		return dev_err_probe(&pdev->dev, ret, "error when attaching power domains\n");
-
-	ret = qcom_ssc_block_bus_pds_enable(data->pds, data->num_pds);
-	if (ret < 0)
-		return dev_err_probe(&pdev->dev, ret, "error when enabling power domains\n");
-
 	/* low level overrides for when the HW logic doesn't "just work" */
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mpm_sscaon_config0");
 	data->reg_mpm_sscaon_config0 = devm_ioremap_resource(&pdev->dev, res);
@@ -343,11 +331,30 @@ static int qcom_ssc_block_bus_probe(struct platform_device *pdev)
 
 	data->ssc_axi_halt = halt_args.args[0];
 
+	/* power domains */
+	data->pd_names = qcom_ssc_block_pd_names;
+	data->num_pds = ARRAY_SIZE(qcom_ssc_block_pd_names);
+
+	ret = qcom_ssc_block_bus_pds_attach(&pdev->dev, data->pds, data->pd_names, data->num_pds);
+	if (ret < 0)
+		return dev_err_probe(&pdev->dev, ret, "error when attaching power domains\n");
+
+	ret = qcom_ssc_block_bus_pds_enable(data->pds, data->num_pds);
+	if (ret < 0) {
+		dev_err_probe(&pdev->dev, ret, "error when enabling power domains\n");
+		goto err_detach_pds_bus;
+	}
+
 	qcom_ssc_block_bus_init(&pdev->dev);
 
 	of_platform_populate(np, NULL, NULL, &pdev->dev);
 
 	return 0;
+
+err_detach_pds_bus:
+	qcom_ssc_block_bus_pds_detach(&pdev->dev, data->pds, data->num_pds);
+
+	return ret;
 }
 
 static void qcom_ssc_block_bus_remove(struct platform_device *pdev)
-- 
2.39.5



