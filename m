Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E68A466B57;
	Tue, 16 Jun 2026 16:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627122; cv=none; b=XRHoRqpeUpWdgtg7BGgspuMe5de4EGxfqQWcZCTdD9drN3GJcp2Yf2mCcFG/LkTATqnF4pkv80W3P1T57yE5WEmMRLskAnSqNDSe/CP2nron/o5XBCtJspkd4uML/o1A+Sr8g9MdsTR7PdA5CxTmeqbaObBUnmxvnXIRdJ9IWnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627122; c=relaxed/simple;
	bh=sXmyHbCHU/J55V2L6EYxllGCC9voTopEehn5YDaKxmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UOPWNwAh4k2IEDDLMELqDlgI7AzoRhCbeedPejqHNPEAlA9hUgJDH0wF2wl0G+Blpi4E97jh1IET/+cR3TvmGca9rH2ZLbf/Rwt4P9Cwo9d7hfmfr7dPdvZ9XOU+mInr/SXYJCiJkTw29Rg+ctGoQjUMzCNv6m+B+HcCPFFoR70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CH+i/s/y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CH+i/s/y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1545C1F000E9;
	Tue, 16 Jun 2026 16:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627121;
	bh=TZjH+1nEXAfwzEO/PjB0D+grZF5fnd9JOVEjdWY01g0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CH+i/s/yGxkhqTBeoOMcdXNrml3o2cOD+myWGyO2IHpelJpumCvTFsygjdsuZYYtF
	 j9WEMYqVkv5R0NFD5VCPEwiDdHzlBaCQIuEgnfN5JOxgUOuBdeyxE7hrg0ev9F5w/j
	 2U7GputOJW9u0HgHi3o2h94z4f859Tt0+6VOBe1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 124/261] soc: qcom: ice: Fix race between qcom_ice_probe() and of_qcom_ice_get()
Date: Tue, 16 Jun 2026 20:29:22 +0530
Message-ID: <20260616145050.824938493@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

commit d922113ef91e6e7e8065e9070f349365341ba32e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/ice.c |   38 +++++++++++++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 7 deletions(-)

--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -16,6 +16,7 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
+#include <linux/xarray.h>
 
 #include <linux/firmware/qcom/qcom_scm.h>
 
@@ -50,6 +51,9 @@ struct qcom_ice {
 	struct clk *core_clk;
 };
 
+static DEFINE_XARRAY(ice_handles);
+static DEFINE_MUTEX(ice_mutex);
+
 static bool qcom_ice_check_supported(struct qcom_ice *ice)
 {
 	u32 regval = qcom_ice_readl(ice, QCOM_ICE_REG_VERSION);
@@ -288,6 +292,8 @@ struct qcom_ice *of_qcom_ice_get(struct
 		return qcom_ice_create(&pdev->dev, base);
 	}
 
+	guard(mutex)(&ice_mutex);
+
 	/*
 	 * If the consumer node does not provider an 'ice' reg range
 	 * (legacy DT binding), then it must at least provide a phandle
@@ -304,12 +310,13 @@ struct qcom_ice *of_qcom_ice_get(struct
 		return ERR_PTR(-ENODEV);
 	}
 
-	ice = platform_get_drvdata(pdev);
-	if (!ice) {
-		dev_err(dev, "Cannot get ice instance from %s\n",
-			dev_name(&pdev->dev));
+	ice = xa_load(&ice_handles, pdev->dev.of_node->phandle);
+	if (IS_ERR_OR_NULL(ice)) {
 		platform_device_put(pdev);
-		return ERR_PTR(-EPROBE_DEFER);
+		if (!ice)
+			return ERR_PTR(-EPROBE_DEFER);
+		else
+			return ice;
 	}
 
 	ice->link = device_link_add(dev, &pdev->dev, DL_FLAG_AUTOREMOVE_SUPPLIER);
@@ -374,24 +381,40 @@ EXPORT_SYMBOL_GPL(devm_of_qcom_ice_get);
 
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
@@ -400,6 +423,7 @@ MODULE_DEVICE_TABLE(of, qcom_ice_of_matc
 
 static struct platform_driver qcom_ice_driver = {
 	.probe	= qcom_ice_probe,
+	.remove	= qcom_ice_remove,
 	.driver = {
 		.name = "qcom-ice",
 		.of_match_table = qcom_ice_of_match_table,


