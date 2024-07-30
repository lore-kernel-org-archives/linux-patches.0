Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A11E18C92B;
	Tue, 30 Jul 2024 17:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359301; cv=none; b=GwtsUdEZFB+hA2Lt/dq7JXHfWiL/sxzB4HovUqzwecMJ2irr4+4ZtN130d0cXdIUwdRfnEFZoNc8rd1SFQemyQdqHnjuHsG64HISpmhnAsXYCmsdX5yTCjgOfm0SrfD9K30eLWNq4PVi6WhRDfSNuZmaN1VHACm1HeDpeqevVoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359301; c=relaxed/simple;
	bh=DEwTG81nhJpFxmqTRTihp2rN5tcg3SSrghK7i3o5PT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFF2kX30I35YEkslJx/RTpchUtcIY/Qh01CbNDlHVhyZJJXgdpeJJabEg8FxtEYTOoyUlkYpfvNs1PdZppjIlcnWH7m62/frL7JYNPycdILuJph6vVTnx99AGPosxnfeL7+0WL36Ht90waB0Ug4JOidJG7uTzTcEcD8XV5UQUs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKwNIpZU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKwNIpZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A326C32782;
	Tue, 30 Jul 2024 17:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359301;
	bh=DEwTG81nhJpFxmqTRTihp2rN5tcg3SSrghK7i3o5PT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jKwNIpZUuLWbiDR4G/Rr//VRHWv925r+nzanJX2NfHuag4MVftWqfIFW0wrKRXW2y
	 a9kSG098Ajro5v1dX8QQAnVFzuXmbZFh63ovQM+P9cA8tcGOuUztG/ClWgWVe7+9sY
	 GGXtB7WzFIPsJIrpXxKurFtjRPVwFjYNZMSgqHRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Georgi Djakov <quic_c_gdjako@quicinc.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 441/809] iommu/arm-smmu-qcom: Register the TBU driver in qcom_smmu_impl_init
Date: Tue, 30 Jul 2024 17:45:17 +0200
Message-ID: <20240730151742.120093637@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Georgi Djakov <quic_c_gdjako@quicinc.com>

[ Upstream commit 0b4eeee2876f2b08442eb32081451bf130e01a4c ]

Currently the TBU driver will only probe when CONFIG_ARM_SMMU_QCOM_DEBUG
is enabled. The driver not probing would prevent the platform to reach
sync_state and the system will remain in sub-optimal power consumption
mode while waiting for all consumer drivers to probe. To address this,
let's register the TBU driver in qcom_smmu_impl_init(), so that it can
probe, but still enable its functionality only when the debug option in
Kconfig is enabled.

Reported-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Closes: https://lore.kernel.org/r/CAA8EJppcXVu72OSo+OiYEiC1HQjP3qCwKMumOsUhcn6Czj0URg@mail.gmail.com
Fixes: 414ecb030870 ("iommu/arm-smmu-qcom-debug: Add support for TBUs")
Signed-off-by: Georgi Djakov <quic_c_gdjako@quicinc.com>
Link: https://lore.kernel.org/r/20240704010759.507798-1-quic_c_gdjako@quicinc.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../iommu/arm/arm-smmu/arm-smmu-qcom-debug.c  | 17 +-------
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c    | 39 +++++++++++++++++++
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.h    |  2 +
 3 files changed, 42 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom-debug.c b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom-debug.c
index 552199cbd9e25..482c40aa029b4 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom-debug.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom-debug.c
@@ -488,7 +488,7 @@ irqreturn_t qcom_smmu_context_fault(int irq, void *dev)
 	return ret;
 }
 
-static int qcom_tbu_probe(struct platform_device *pdev)
+int qcom_tbu_probe(struct platform_device *pdev)
 {
 	struct of_phandle_args args = { .args_count = 2 };
 	struct device_node *np = pdev->dev.of_node;
@@ -530,18 +530,3 @@ static int qcom_tbu_probe(struct platform_device *pdev)
 
 	return 0;
 }
-
-static const struct of_device_id qcom_tbu_of_match[] = {
-	{ .compatible = "qcom,sc7280-tbu" },
-	{ .compatible = "qcom,sdm845-tbu" },
-	{ }
-};
-
-static struct platform_driver qcom_tbu_driver = {
-	.driver = {
-		.name           = "qcom_tbu",
-		.of_match_table = qcom_tbu_of_match,
-	},
-	.probe = qcom_tbu_probe,
-};
-builtin_platform_driver(qcom_tbu_driver);
diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
index 25f034677f568..13f3e2efb2ccb 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
@@ -8,6 +8,8 @@
 #include <linux/delay.h>
 #include <linux/of_device.h>
 #include <linux/firmware/qcom/qcom_scm.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 
 #include "arm-smmu.h"
 #include "arm-smmu-qcom.h"
@@ -561,10 +563,47 @@ static struct acpi_platform_list qcom_acpi_platlist[] = {
 };
 #endif
 
+static int qcom_smmu_tbu_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	int ret;
+
+	if (IS_ENABLED(CONFIG_ARM_SMMU_QCOM_DEBUG)) {
+		ret = qcom_tbu_probe(pdev);
+		if (ret)
+			return ret;
+	}
+
+	if (dev->pm_domain) {
+		pm_runtime_set_active(dev);
+		pm_runtime_enable(dev);
+	}
+
+	return 0;
+}
+
+static const struct of_device_id qcom_smmu_tbu_of_match[] = {
+	{ .compatible = "qcom,sc7280-tbu" },
+	{ .compatible = "qcom,sdm845-tbu" },
+	{ }
+};
+
+static struct platform_driver qcom_smmu_tbu_driver = {
+	.driver = {
+		.name           = "qcom_tbu",
+		.of_match_table = qcom_smmu_tbu_of_match,
+	},
+	.probe = qcom_smmu_tbu_probe,
+};
+
 struct arm_smmu_device *qcom_smmu_impl_init(struct arm_smmu_device *smmu)
 {
 	const struct device_node *np = smmu->dev->of_node;
 	const struct of_device_id *match;
+	static u8 tbu_registered;
+
+	if (!tbu_registered++)
+		platform_driver_register(&qcom_smmu_tbu_driver);
 
 #ifdef CONFIG_ACPI
 	if (np == NULL) {
diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.h b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.h
index 9bb3ae7d62da6..3c134d1a62773 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.h
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.h
@@ -34,8 +34,10 @@ irqreturn_t qcom_smmu_context_fault(int irq, void *dev);
 
 #ifdef CONFIG_ARM_SMMU_QCOM_DEBUG
 void qcom_smmu_tlb_sync_debug(struct arm_smmu_device *smmu);
+int qcom_tbu_probe(struct platform_device *pdev);
 #else
 static inline void qcom_smmu_tlb_sync_debug(struct arm_smmu_device *smmu) { }
+static inline int qcom_tbu_probe(struct platform_device *pdev) { return -EINVAL; }
 #endif
 
 #endif /* _ARM_SMMU_QCOM_H */
-- 
2.43.0



