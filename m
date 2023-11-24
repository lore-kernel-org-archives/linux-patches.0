Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDF728DBB;
	Fri, 24 Nov 2023 18:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v39pK6V0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B1BC433C8;
	Fri, 24 Nov 2023 18:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852129;
	bh=06A43bp/l66xYbC8oS8e8J3w4fp21ouVHXr8ApRzRPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v39pK6V0ItX3V0ljfQY0FRGIt7Vd0X2r5NDsm2Nz/vIPyJSItVF8NLy8xS4VLZXyr
	 Pki1FgQCeHTn38fdgH61DGoFh4RXdC9FDBjB2qJcNoJJAcvoTutwQekwAJEWSxG4du
	 HVubgzwuYIC7sv5BjeyIafRJE2nrhMmtArHgHwz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.1 232/372] mfd: qcom-spmi-pmic: Fix revid implementation
Date: Fri, 24 Nov 2023 17:50:19 +0000
Message-ID: <20231124172018.240840798@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 7b439aaa62fee474a0d84d67a25f4984467e7b95 upstream.

The Qualcomm SPMI PMIC revid implementation is broken in multiple ways.

First, it assumes that just because the sibling base device has been
registered that means that it is also bound to a driver, which may not
be the case (e.g. due to probe deferral or asynchronous probe). This
could trigger a NULL-pointer dereference when attempting to access the
driver data of the unbound device.

Second, it accesses driver data of a sibling device directly and without
any locking, which means that the driver data may be freed while it is
being accessed (e.g. on driver unbind).

Third, it leaks a struct device reference to the sibling device which is
looked up using the spmi_device_from_of() every time a function (child)
device is calling the revid function (e.g. on probe).

Fix this mess by reimplementing the revid lookup so that it is done only
at probe of the PMIC device; the base device fetches the revid info from
the hardware, while any secondary SPMI device fetches the information
from the base device and caches it so that it can be accessed safely
from its children. If the base device has not been probed yet then probe
of a secondary device is deferred.

Fixes: e9c11c6e3a0e ("mfd: qcom-spmi-pmic: expose the PMIC revid information to clients")
Cc: stable@vger.kernel.org      # 6.0
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Acked-by: Caleb Connolly <caleb.connolly@linaro.org>
Link: https://lore.kernel.org/r/20231003152927.15000-3-johan+linaro@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/qcom-spmi-pmic.c |   69 +++++++++++++++++++++++++++++++++----------
 1 file changed, 53 insertions(+), 16 deletions(-)

--- a/drivers/mfd/qcom-spmi-pmic.c
+++ b/drivers/mfd/qcom-spmi-pmic.c
@@ -30,6 +30,8 @@ struct qcom_spmi_dev {
 	struct qcom_spmi_pmic pmic;
 };
 
+static DEFINE_MUTEX(pmic_spmi_revid_lock);
+
 #define N_USIDS(n)		((void *)n)
 
 static const struct of_device_id pmic_spmi_id_table[] = {
@@ -76,24 +78,21 @@ static const struct of_device_id pmic_sp
  *
  * This only supports PMICs with 1 or 2 USIDs.
  */
-static struct spmi_device *qcom_pmic_get_base_usid(struct device *dev)
+static struct spmi_device *qcom_pmic_get_base_usid(struct spmi_device *sdev, struct qcom_spmi_dev *ctx)
 {
-	struct spmi_device *sdev;
-	struct qcom_spmi_dev *ctx;
 	struct device_node *spmi_bus;
 	struct device_node *child;
 	int function_parent_usid, ret;
 	u32 pmic_addr;
 
-	sdev = to_spmi_device(dev);
-	ctx = dev_get_drvdata(&sdev->dev);
-
 	/*
 	 * Quick return if the function device is already in the base
 	 * USID. This will always be hit for PMICs with only 1 USID.
 	 */
-	if (sdev->usid % ctx->num_usids == 0)
+	if (sdev->usid % ctx->num_usids == 0) {
+		get_device(&sdev->dev);
 		return sdev;
+	}
 
 	function_parent_usid = sdev->usid;
 
@@ -118,10 +117,8 @@ static struct spmi_device *qcom_pmic_get
 			sdev = spmi_device_from_of(child);
 			if (!sdev) {
 				/*
-				 * If the base USID for this PMIC hasn't probed yet
-				 * but the secondary USID has, then we need to defer
-				 * the function driver so that it will attempt to
-				 * probe again when the base USID is ready.
+				 * If the base USID for this PMIC hasn't been
+				 * registered yet then we need to defer.
 				 */
 				sdev = ERR_PTR(-EPROBE_DEFER);
 			}
@@ -135,6 +132,35 @@ static struct spmi_device *qcom_pmic_get
 	return sdev;
 }
 
+static int pmic_spmi_get_base_revid(struct spmi_device *sdev, struct qcom_spmi_dev *ctx)
+{
+	struct qcom_spmi_dev *base_ctx;
+	struct spmi_device *base;
+	int ret = 0;
+
+	base = qcom_pmic_get_base_usid(sdev, ctx);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	/*
+	 * Copy revid info from base device if it has probed and is still
+	 * bound to its driver.
+	 */
+	mutex_lock(&pmic_spmi_revid_lock);
+	base_ctx = spmi_device_get_drvdata(base);
+	if (!base_ctx) {
+		ret = -EPROBE_DEFER;
+		goto out_unlock;
+	}
+	memcpy(&ctx->pmic, &base_ctx->pmic, sizeof(ctx->pmic));
+out_unlock:
+	mutex_unlock(&pmic_spmi_revid_lock);
+
+	put_device(&base->dev);
+
+	return ret;
+}
+
 static int pmic_spmi_load_revid(struct regmap *map, struct device *dev,
 				 struct qcom_spmi_pmic *pmic)
 {
@@ -210,11 +236,7 @@ const struct qcom_spmi_pmic *qcom_pmic_g
 	if (!of_match_device(pmic_spmi_id_table, dev->parent))
 		return ERR_PTR(-EINVAL);
 
-	sdev = qcom_pmic_get_base_usid(dev->parent);
-
-	if (IS_ERR(sdev))
-		return ERR_CAST(sdev);
-
+	sdev = to_spmi_device(dev->parent);
 	spmi = dev_get_drvdata(&sdev->dev);
 
 	return &spmi->pmic;
@@ -249,16 +271,31 @@ static int pmic_spmi_probe(struct spmi_d
 		ret = pmic_spmi_load_revid(regmap, &sdev->dev, &ctx->pmic);
 		if (ret < 0)
 			return ret;
+	} else {
+		ret = pmic_spmi_get_base_revid(sdev, ctx);
+		if (ret)
+			return ret;
 	}
+
+	mutex_lock(&pmic_spmi_revid_lock);
 	spmi_device_set_drvdata(sdev, ctx);
+	mutex_unlock(&pmic_spmi_revid_lock);
 
 	return devm_of_platform_populate(&sdev->dev);
 }
 
+static void pmic_spmi_remove(struct spmi_device *sdev)
+{
+	mutex_lock(&pmic_spmi_revid_lock);
+	spmi_device_set_drvdata(sdev, NULL);
+	mutex_unlock(&pmic_spmi_revid_lock);
+}
+
 MODULE_DEVICE_TABLE(of, pmic_spmi_id_table);
 
 static struct spmi_driver pmic_spmi_driver = {
 	.probe = pmic_spmi_probe,
+	.remove = pmic_spmi_remove,
 	.driver = {
 		.name = "pmic-spmi",
 		.of_match_table = pmic_spmi_id_table,


