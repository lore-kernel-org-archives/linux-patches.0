Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDAC2571AC;
	Tue, 25 Mar 2025 12:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906237; cv=none; b=qRSN6SMG2DrCCjxFAeE+CZFru7alu3RYbmyHhOpQ2tnl++sNf/2UXwHcLU9dNosbq1V+sE6U4Dt97hJ8oOHMochgm7GP48KGvfZtFxcAEMleVZ4m1+Fb9XAJSIOT2DXQgxyrxYgh60Ydm2t1XxF709ZyJRSk3/e7/cDONnLF2wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906237; c=relaxed/simple;
	bh=RJaps78MBrTyQGsIfifw6Yz01oAIoAGWjDhtg/CVyYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gWTmahdH8qSMNmt0rTx8N+4v2nwz4JCY24PjAuZC0BO5gcV5x+5SNcxyC1TvjhThpH3bix79KqLeWRbYNIxZdtygm7SQwgerFyCV1Z9ZVC8JvQU+uRsNTz2jQejm2/iFhvZqRPSXAkNYpwZws4zarMJFYXe/3cgD42P0zr2Hdnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHSooyut; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHSooyut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C11ECC4CEE4;
	Tue, 25 Mar 2025 12:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906236;
	bh=RJaps78MBrTyQGsIfifw6Yz01oAIoAGWjDhtg/CVyYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHSooyutj6Sln4eUo4OM0w6dKHbAQipsSTKOgoXTM2mQanPqqsSGRmEQLXref6Jo7
	 l3j7hRu8z0pwP1XlLqU0IzOZ/z6XvGOjp786ao4HsV8gHcE3aUAhzmKxN8qxMJw8zC
	 TxamGJfdszxrYL/mAbM3KoBhifm5kOUGxaUsFbck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Felsch <m.felsch@pengutronix.de>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/116] soc: imx8m: Unregister cpufreq and soc dev in cleanup path
Date: Tue, 25 Mar 2025 08:21:37 -0400
Message-ID: <20250325122149.478462685@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit cf7139aac463880cbd5c5e999c118fbe91631411 ]

Unregister the cpufreq device and soc device when resource unwinding,
otherwise there will be warning when do removing test:
sysfs: cannot create duplicate filename '/devices/platform/imx-cpufreq-dt'
CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.13.0-rc1-next-20241204
Hardware name: NXP i.MX8MPlus EVK board (DT)

Fixes: 9cc832d37799 ("soc: imx8m: Probe the SoC driver as platform driver")
Cc: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/soc-imx8m.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/imx/soc-imx8m.c b/drivers/soc/imx/soc-imx8m.c
index 8ac7658e3d525..3ed8161d7d28b 100644
--- a/drivers/soc/imx/soc-imx8m.c
+++ b/drivers/soc/imx/soc-imx8m.c
@@ -192,9 +192,20 @@ static __maybe_unused const struct of_device_id imx8_soc_match[] = {
 	devm_kasprintf((dev), GFP_KERNEL, "%d.%d", ((soc_rev) >> 4) & 0xf, (soc_rev) & 0xf) : \
 	"unknown"
 
+static void imx8m_unregister_soc(void *data)
+{
+	soc_device_unregister(data);
+}
+
+static void imx8m_unregister_cpufreq(void *data)
+{
+	platform_device_unregister(data);
+}
+
 static int imx8m_soc_probe(struct platform_device *pdev)
 {
 	struct soc_device_attribute *soc_dev_attr;
+	struct platform_device *cpufreq_dev;
 	const struct imx8_soc_data *data;
 	struct device *dev = &pdev->dev;
 	const struct of_device_id *id;
@@ -239,11 +250,22 @@ static int imx8m_soc_probe(struct platform_device *pdev)
 	if (IS_ERR(soc_dev))
 		return PTR_ERR(soc_dev);
 
+	ret = devm_add_action(dev, imx8m_unregister_soc, soc_dev);
+	if (ret)
+		return ret;
+
 	pr_info("SoC: %s revision %s\n", soc_dev_attr->soc_id,
 		soc_dev_attr->revision);
 
-	if (IS_ENABLED(CONFIG_ARM_IMX_CPUFREQ_DT))
-		platform_device_register_simple("imx-cpufreq-dt", -1, NULL, 0);
+	if (IS_ENABLED(CONFIG_ARM_IMX_CPUFREQ_DT)) {
+		cpufreq_dev = platform_device_register_simple("imx-cpufreq-dt", -1, NULL, 0);
+		if (IS_ERR(cpufreq_dev))
+			return dev_err_probe(dev, PTR_ERR(cpufreq_dev),
+					     "Failed to register imx-cpufreq-dev device\n");
+		ret = devm_add_action(dev, imx8m_unregister_cpufreq, cpufreq_dev);
+		if (ret)
+			return ret;
+	}
 
 	return 0;
 }
-- 
2.39.5



