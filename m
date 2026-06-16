Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB8D478E26;
	Tue, 16 Jun 2026 17:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630117; cv=none; b=aZM8GlG+rhmIfDxNoHGMJy0LTkITudA/zSvqh1boV7e9zIeBijciyZ854NYk4DGsDlJ+ngU+eonHaDhKJMEBS7xoF9348veupn9Pw/iHOl4k9kiem7u2NZX6X/xsH8LvZUBVxTvp/fBvq5UF1pdVuSFWQaFiTDe6qxlf413dL8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630117; c=relaxed/simple;
	bh=TUrM+eNSjJXiII/6rViXGSImMZZGgQpOogt/jGg+C6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fODLsjgVZVHOEZyAg/f2brQNvj9UKXA6w8UEs7PApwFmOwM33H1yX2Kmu3TPjQCgSQYy5PyIms5vdcLId0Q9rtkpiAQvjARnyH0TJWGoWmVKg9WoyrbITyms215RpQH1SmeEyWhqaMjBSAyiKF0bz6iJlCSpxSllrUbvml1/4Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ys0EfYBH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ys0EfYBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812D71F000E9;
	Tue, 16 Jun 2026 17:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630116;
	bh=QztpJ8Uatzkqu7WWJz0r7f8NE+AFIBT9kTW6Wk/Wox0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ys0EfYBHCWT1bbJnSPAmdLh0YZdU4AvzaXH46F5g872wOl7D4zKND2WwVLYWgxgUj
	 Uu2lg3O44AOJxMnzeWeEPlxCSREsdP4QSRFdxhCPIIH7BRw9wcH4kNdw8jE/7gKJiT
	 drI58r9hcqIUtxv++pG+ZBjNxEFIHAqgACkSg/dM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 371/452] soc: qcom: ice: Fix race between qcom_ice_probe() and of_qcom_ice_get()
Date: Tue, 16 Jun 2026 20:29:58 +0530
Message-ID: <20260616145136.512671496@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit d922113ef91e6e7e8065e9070f349365341ba32e ]

The current platform driver design causes probe ordering races with
consumers (UFS, eMMC) due to ICE's dependency on SCM firmware calls. If ICE
probe fails (missing ICE SCM or DT registers), devm_of_qcom_ice_get() loops
with -EPROBE_DEFER, leaving consumers non-functional even when ICE should
be gracefully disabled. devm_of_qcom_ice_get() doesn't know if the ICE
driver probe has failed due to above reasons or it is waiting for the SCM
driver.

Moreover, there is no devlink dependency between ICE and consumer drivers
as 'qcom,ice' is not considered as a DT 'supplier'. So the consumer drivers
have no idea of when the ICE driver is going to probe.

To address these issues, store the error pointer in a global xarray with
ice node phandle as a key during probe in addition to the valid ice pointer
and synchronize both qcom_ice_probe() and of_qcom_ice_get() using a mutex.

If the xarray entry is NULL, then it implies that the driver is not
probed yet, so return -EPROBE_DEFER. If it has any error pointer, return
that error pointer directly. Otherwise, add the devlink as usual and return
the valid pointer to the consumer.

Xarray is used instead of platform drvdata, since driver core frees the
drvdata during probe failure. So it cannot be used to pass the error
pointer to the consumers.

Note that this change only fixes the standalone ICE DT node bindings and
not the ones with 'ice' range embedded in the consumer nodes, where there
is no issue.

Fixes: 2afbf43a4aec ("soc: qcom: Make the Qualcomm UFS/SDCC ICE a dedicated driver")
Reported-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Tested-by: Sumit Garg <sumit.garg@oss.qualcomm.com> # OP-TEE as TZ
Acked-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Cc: stable@vger.kernel.org # 6.4
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260518-qcom-ice-fix-v7-1-2a595382185b@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
[ changed `.remove` to `.remove_new` for the void callback and replaced the `__free(device_node)` direct-return with an explicit `goto out` in `of_qcom_ice_get()` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/ice.c | 36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index d6e205e3812a96..94e91835062b26 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -15,6 +15,7 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
+#include <linux/xarray.h>
 
 #include <linux/firmware/qcom/qcom_scm.h>
 
@@ -49,6 +50,9 @@ struct qcom_ice {
 	struct clk *core_clk;
 };
 
+static DEFINE_XARRAY(ice_handles);
+static DEFINE_MUTEX(ice_mutex);
+
 static bool qcom_ice_check_supported(struct qcom_ice *ice)
 {
 	u32 regval = qcom_ice_readl(ice, QCOM_ICE_REG_VERSION);
@@ -288,6 +292,8 @@ struct qcom_ice *of_qcom_ice_get(struct device *dev)
 		return qcom_ice_create(&pdev->dev, base);
 	}
 
+	guard(mutex)(&ice_mutex);
+
 	/*
 	 * If the consumer node does not provider an 'ice' reg range
 	 * (legacy DT binding), then it must at least provide a phandle
@@ -304,12 +310,11 @@ struct qcom_ice *of_qcom_ice_get(struct device *dev)
 		goto out;
 	}
 
-	ice = platform_get_drvdata(pdev);
-	if (!ice) {
-		dev_err(dev, "Cannot get ice instance from %s\n",
-			dev_name(&pdev->dev));
+	ice = xa_load(&ice_handles, pdev->dev.of_node->phandle);
+	if (IS_ERR_OR_NULL(ice)) {
 		platform_device_put(pdev);
-		ice = ERR_PTR(-EPROBE_DEFER);
+		if (!ice)
+			ice = ERR_PTR(-EPROBE_DEFER);
 		goto out;
 	}
 
@@ -378,24 +383,40 @@ EXPORT_SYMBOL_GPL(devm_of_qcom_ice_get);
 
 static int qcom_ice_probe(struct platform_device *pdev)
 {
+	unsigned long phandle = pdev->dev.of_node->phandle;
 	struct qcom_ice *engine;
 	void __iomem *base;
 
+	guard(mutex)(&ice_mutex);
+
 	base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(base)) {
 		dev_warn(&pdev->dev, "ICE registers not found\n");
+		/* Store the error pointer for devm_of_qcom_ice_get() */
+		xa_store(&ice_handles, phandle, (__force void *)base, GFP_KERNEL);
 		return PTR_ERR(base);
 	}
 
 	engine = qcom_ice_create(&pdev->dev, base);
-	if (IS_ERR(engine))
+	if (IS_ERR(engine)) {
+		/* Store the error pointer for devm_of_qcom_ice_get() */
+		xa_store(&ice_handles, phandle, engine, GFP_KERNEL);
 		return PTR_ERR(engine);
+	}
 
-	platform_set_drvdata(pdev, engine);
+	xa_store(&ice_handles, phandle, engine, GFP_KERNEL);
 
 	return 0;
 }
 
+static void qcom_ice_remove(struct platform_device *pdev)
+{
+	unsigned long phandle = pdev->dev.of_node->phandle;
+
+	guard(mutex)(&ice_mutex);
+	xa_store(&ice_handles, phandle, NULL, GFP_KERNEL);
+}
+
 static const struct of_device_id qcom_ice_of_match_table[] = {
 	{ .compatible = "qcom,inline-crypto-engine" },
 	{ },
@@ -404,6 +425,7 @@ MODULE_DEVICE_TABLE(of, qcom_ice_of_match_table);
 
 static struct platform_driver qcom_ice_driver = {
 	.probe	= qcom_ice_probe,
+	.remove_new	= qcom_ice_remove,
 	.driver = {
 		.name = "qcom-ice",
 		.of_match_table = qcom_ice_of_match_table,
-- 
2.53.0



