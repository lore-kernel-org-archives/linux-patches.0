Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7733214;
	Thu, 15 Aug 2024 14:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732680; cv=none; b=CkCX6fI5pdL/I194+Iu7Q3+pKH4yemOgU0nsu8sPaUYtCcnsOInZLjbeayj94jZjAOCB4J4jSeRq7lh8KG43f4Pn6qWrFvDlaElE5ows1BnCk/SpQJbbiLwZHFX3qG2/0o3xiQCBlTWVhJOI+NCGoD6Stm9eGKCHD/FmnNSPf3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732680; c=relaxed/simple;
	bh=/yHR+mQqfDHBt4ub6P/pGI5A6/Y5ffglNtiqhs4lYb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLGYnUeNuIPOReFNKZWeDxh8JwJQgnifRQdPVGbIUuddDn2wK1TYX+XPtRkKM9Cn6NEXw62s8uraXf3hvjaN88cr/imagqjh06MM/qAyV3idp6vVJL3DB2YakWJgGwkbt75jHbZBjUlp4rm1Zqw84EjSz2eacXFlAYlww6eyiXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jj33AuLq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jj33AuLq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8DC4C32786;
	Thu, 15 Aug 2024 14:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732680;
	bh=/yHR+mQqfDHBt4ub6P/pGI5A6/Y5ffglNtiqhs4lYb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jj33AuLqnVxj3FY7LN15CAnhFtsgZrq+m6d/j9JUyP8AaQGtt9W5R+Oa7k7oB77SS
	 VDMcpCG3zuKaP5PPrqVjhvsQiPMewtCwpIbheIBXOjSUm+pRQdJ2iXvdcDCMER6Q1n
	 e2RSXoMwrmc3K/6yWenkzSXxq4mXhY7XOcjWRSRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Tretter <m.tretter@pengutronix.de>,
	Michal Simek <michal.simek@xilinx.com>,
	Rajan Vaja <rajan.vaja@xilinx.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 222/352] soc: xilinx: move PM_INIT_FINALIZE to zynqmp_pm_domains driver
Date: Thu, 15 Aug 2024 15:24:48 +0200
Message-ID: <20240815131928.011853885@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Tretter <m.tretter@pengutronix.de>

[ Upstream commit 7fd890b89dea55eb5866640eb8befad26d558161 ]

PM_INIT_FINALIZE tells the PMU FW that Linux is able to handle the power
management nodes that are provided by the PMU FW. Nodes that are not
requested are shut down after this call.

Calling PM_INIT_FINALIZE from the zynqmp_power driver is wrong. The PM
node request mechanism is implemented in the zynqmp_pm_domains driver,
which must also call PM_INIT_FINALIZE.

Due to the behavior of the PMU FW, all devices must be powered up before
PM_INIT_FINALIZE is called, because otherwise the devices might
misbehave. Calling PM_INIT_FINALIZE from the sync_state device callback
ensures that all users probed successfully before the PMU FW is allowed
to power off unused domains.

Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
Acked-by: Michal Simek <michal.simek@xilinx.com>
Acked-by: Rajan Vaja <rajan.vaja@xilinx.com>
Link: https://lore.kernel.org/r/20210825150313.4033156-2-m.tretter@pengutronix.de
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Stable-dep-of: 9b003e14801c ("drivers: soc: xilinx: check return status of get_api_version()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/xilinx/zynqmp_pm_domains.c | 16 ++++++++++++++++
 drivers/soc/xilinx/zynqmp_power.c      |  1 -
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/xilinx/zynqmp_pm_domains.c b/drivers/soc/xilinx/zynqmp_pm_domains.c
index 226d343f0a6a5..81e8e10f10929 100644
--- a/drivers/soc/xilinx/zynqmp_pm_domains.c
+++ b/drivers/soc/xilinx/zynqmp_pm_domains.c
@@ -152,11 +152,17 @@ static int zynqmp_gpd_power_off(struct generic_pm_domain *domain)
 static int zynqmp_gpd_attach_dev(struct generic_pm_domain *domain,
 				 struct device *dev)
 {
+	struct device_link *link;
 	int ret;
 	struct zynqmp_pm_domain *pd;
 
 	pd = container_of(domain, struct zynqmp_pm_domain, gpd);
 
+	link = device_link_add(dev, &domain->dev, DL_FLAG_SYNC_STATE_ONLY);
+	if (!link)
+		dev_dbg(&domain->dev, "failed to create device link for %s\n",
+			dev_name(dev));
+
 	/* If this is not the first device to attach there is nothing to do */
 	if (domain->device_count)
 		return 0;
@@ -299,9 +305,19 @@ static int zynqmp_gpd_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static void zynqmp_gpd_sync_state(struct device *dev)
+{
+	int ret;
+
+	ret = zynqmp_pm_init_finalize();
+	if (ret)
+		dev_warn(dev, "failed to release power management to firmware\n");
+}
+
 static struct platform_driver zynqmp_power_domain_driver = {
 	.driver	= {
 		.name = "zynqmp_power_controller",
+		.sync_state = zynqmp_gpd_sync_state,
 	},
 	.probe = zynqmp_gpd_probe,
 	.remove = zynqmp_gpd_remove,
diff --git a/drivers/soc/xilinx/zynqmp_power.c b/drivers/soc/xilinx/zynqmp_power.c
index c556623dae024..f8c301984d4f9 100644
--- a/drivers/soc/xilinx/zynqmp_power.c
+++ b/drivers/soc/xilinx/zynqmp_power.c
@@ -178,7 +178,6 @@ static int zynqmp_pm_probe(struct platform_device *pdev)
 	u32 pm_api_version;
 	struct mbox_client *client;
 
-	zynqmp_pm_init_finalize();
 	zynqmp_pm_get_api_version(&pm_api_version);
 
 	/* Check PM API version number */
-- 
2.43.0



