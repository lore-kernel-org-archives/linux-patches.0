Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358C720C488;
	Tue, 29 Apr 2025 18:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950176; cv=none; b=QtBIaMlUKBfG8P6tOpqnyqMwg7hSpC3C+kVKQ3yUSDPiQ0rf5u1BIZ0R6dAIeMperR6y9MMllMGFdY8a/cHKjEPKwF+ujm+HOviHbfqOPjXERW5ECbtmuUJJEPM3itn6q/AU6/I+LR6VLw1v5zULu4oXirpCJ/GyoPjN1K1tlDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950176; c=relaxed/simple;
	bh=2ju8fdc9RMW7J2103NuV6TQvXzKUj++Kmx05fMZhcTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SjoocKvTmCZ/B2jEuapF7bwrPZyFzBi/RvL7Jj51wnUIzpbATVX4Xy28P35JQLxY36K+8T5OEOH8yhQfXifZBxvUlQNiQQQrGREnOkk+ZQEQFUzIuIrZoGCYSg9icYc9LjmgqO9YUMjAVqQRT5+VGnuk9fITQ2aTAvxNdIcInHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tdto9L4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tdto9L4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C297C4CEE3;
	Tue, 29 Apr 2025 18:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950175;
	bh=2ju8fdc9RMW7J2103NuV6TQvXzKUj++Kmx05fMZhcTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tdto9L4+aC2DYfTsUkc14PenKM8PH0BAiMwv/f7Pjnbn3atJLMV2MvPEGfMZQZxbW
	 A/MOj4Wo9ua5RL2AD1gfdXWA/QxBkhMmFQ3FC3fUM+MPop3veWvjoWOJTPe6T9oFz2
	 iWRJ5H5xCdWXsEUWiKqoaO4T1N2UF+KtKAEhY2rY=
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
Subject: [PATCH 6.6 012/204] soc: qcom: ice: introduce devm_of_qcom_ice_get
Date: Tue, 29 Apr 2025 18:41:40 +0200
Message-ID: <20250429161059.903587522@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index fbab7fe5c652b..d6e205e3812a9 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -10,6 +10,7 @@
 #include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
+#include <linux/device.h>
 #include <linux/iopoll.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
@@ -328,6 +329,53 @@ struct qcom_ice *of_qcom_ice_get(struct device *dev)
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



