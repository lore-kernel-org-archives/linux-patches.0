Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B71254875;
	Tue, 29 Apr 2025 16:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945669; cv=none; b=LBSgSvoO/B2Udyk1ASVaKVD4+93M5jzS8VqSMAsvVkJYI6fv4LB1n8iWdxs3GzN23uYKeB2fZdksaVXFV4FPs+v2NqxrymkNEzX76lXnjaT9Jo9hFmUagULSVp0NQIKm7afKbBQa7uFiXHeaSPlaV1hNZsxEBznWoWs1TpFSb50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945669; c=relaxed/simple;
	bh=bWeyDxkvkm7mtz1kJ2fqMpQUoIfHr5yCJf5ukfIysTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hN2pG3+itf87SucD8ndb9QshHvh7cl48dBB1imuJzO1IFw0F2jj9ccHHyZgyWdqiXdUHp8y/f9ZoMbkD9T0sjnFp2E72UnvqB0cwd/f3OSqFqCB1ln2I2MsvDaTlw2jicL7d0ObeAcd0cmvcI711HPoAZWUuH1IOX5N2x7NdFEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uiR1rCOW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uiR1rCOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE570C4CEE3;
	Tue, 29 Apr 2025 16:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945669;
	bh=bWeyDxkvkm7mtz1kJ2fqMpQUoIfHr5yCJf5ukfIysTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uiR1rCOWSwFOIZRFfFfsAIRGBB78CPaoGqq87d/ndW7S/0GhmERWafGo2dXANpdTf
	 B+4qskEFkeOpgZ6o2LtzAncqwI7VAjDq4jUcLW0CIu485RWoPzLV9rrp/h8mrYgMim
	 cjpuRzmE6QK2SvBTLA+J6lYn7RJ7R166luCzkdNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 002/311] soc: qcom: ice: introduce devm_of_qcom_ice_get
Date: Tue, 29 Apr 2025 18:37:19 +0200
Message-ID: <20250429161121.118356185@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

From: Tudor Ambarus <tudor.ambarus@linaro.org>

[ Upstream commit 1c13d6060d612601a61423f2e8fbf9e48126acca ]

Callers of of_qcom_ice_get() leak the device reference taken by
of_find_device_by_node(). Introduce devm variant for of_qcom_ice_get().
Existing consumers need the ICE instance for the entire life of their
device, thus exporting qcom_ice_put() is not required.

Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20250117-qcom-ice-fix-dev-leak-v2-1-1ffa5b6884cb@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: cbef7442fba5 ("mmc: sdhci-msm: fix dev reference leaked through of_qcom_ice_get")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/ice.c | 48 ++++++++++++++++++++++++++++++++++++++++++
 include/soc/qcom/ice.h |  2 ++
 2 files changed, 50 insertions(+)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index 393d2d1d275f1..79e04bff3e331 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -11,6 +11,7 @@
 #include <linux/cleanup.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
+#include <linux/device.h>
 #include <linux/iopoll.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
@@ -324,6 +325,53 @@ struct qcom_ice *of_qcom_ice_get(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(of_qcom_ice_get);
 
+static void qcom_ice_put(const struct qcom_ice *ice)
+{
+	struct platform_device *pdev = to_platform_device(ice->dev);
+
+	if (!platform_get_resource_byname(pdev, IORESOURCE_MEM, "ice"))
+		platform_device_put(pdev);
+}
+
+static void devm_of_qcom_ice_put(struct device *dev, void *res)
+{
+	qcom_ice_put(*(struct qcom_ice **)res);
+}
+
+/**
+ * devm_of_qcom_ice_get() - Devres managed helper to get an ICE instance from
+ * a DT node.
+ * @dev: device pointer for the consumer device.
+ *
+ * This function will provide an ICE instance either by creating one for the
+ * consumer device if its DT node provides the 'ice' reg range and the 'ice'
+ * clock (for legacy DT style). On the other hand, if consumer provides a
+ * phandle via 'qcom,ice' property to an ICE DT, the ICE instance will already
+ * be created and so this function will return that instead.
+ *
+ * Return: ICE pointer on success, NULL if there is no ICE data provided by the
+ * consumer or ERR_PTR() on error.
+ */
+struct qcom_ice *devm_of_qcom_ice_get(struct device *dev)
+{
+	struct qcom_ice *ice, **dr;
+
+	dr = devres_alloc(devm_of_qcom_ice_put, sizeof(*dr), GFP_KERNEL);
+	if (!dr)
+		return ERR_PTR(-ENOMEM);
+
+	ice = of_qcom_ice_get(dev);
+	if (!IS_ERR_OR_NULL(ice)) {
+		*dr = ice;
+		devres_add(dev, dr);
+	} else {
+		devres_free(dr);
+	}
+
+	return ice;
+}
+EXPORT_SYMBOL_GPL(devm_of_qcom_ice_get);
+
 static int qcom_ice_probe(struct platform_device *pdev)
 {
 	struct qcom_ice *engine;
diff --git a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h
index 5870a94599a25..d5f6a228df659 100644
--- a/include/soc/qcom/ice.h
+++ b/include/soc/qcom/ice.h
@@ -34,4 +34,6 @@ int qcom_ice_program_key(struct qcom_ice *ice,
 			 int slot);
 int qcom_ice_evict_key(struct qcom_ice *ice, int slot);
 struct qcom_ice *of_qcom_ice_get(struct device *dev);
+struct qcom_ice *devm_of_qcom_ice_get(struct device *dev);
+
 #endif /* __QCOM_ICE_H__ */
-- 
2.39.5



