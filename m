Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DC8259CBD;
	Tue, 17 Feb 2026 20:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361365; cv=none; b=mcZsnehF8l8ojqsGcfEj4pIIxuugVHTcVCoE5JUuMgghTQ1KA5XLJxW/PXz8NRN9nPa2OnEZSMxsVFYQbIrg9lWGXpL6ggs6QgadORU2YXGpt9XWVA/Q29GdiPqimzZMIXEZN57bWI+qM4JzhZFsazx4l+KpS+fbf9NAX9GnoA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361365; c=relaxed/simple;
	bh=y+ZfkNuSXKRsyuZuk+Wko8VKrOV9znMlSmVElEAG+G0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8oTMDkN0YZVA1jE95gVs3XR+jA8/e/o3Rxx56F26VeYR/eSuG8CQk+aTMRk2UmQbQD9gZD6yk59oppkWUB/y1Ky8niGLgS/uy7i8Fo7Q3y5EAh144QtkeNNHAq2JeOPUn5Zz1NzonpkNdbwVyrPgwhlpJ7ggVU3YVk2XKfzPLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hjlwYwqo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hjlwYwqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E84C4CEF7;
	Tue, 17 Feb 2026 20:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361365;
	bh=y+ZfkNuSXKRsyuZuk+Wko8VKrOV9znMlSmVElEAG+G0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hjlwYwqo1t7VoQHfR1hDSmw7CCgGKzXmI8zn9TilxtAD3oKwNWAhC1Pfu9nrVOGAU
	 qQrf8Pp8pOC6uzBP+BQ8W06lMFYvjS2Xf7qcYHLscLaa3Kl2xxFs2+D18b0p8FsxMi
	 ugkvGQDjdbcW8KWi/wH3ABc2jyE+C/fB8r9gi8yE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Wang Jiayue <akaieurus@gmail.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH 6.19 14/18] iommu/arm-smmu-qcom: do not register driver in probe()
Date: Tue, 17 Feb 2026 21:32:10 +0100
Message-ID: <20260217200003.243294668@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200002.683975158@linuxfoundation.org>
References: <20260217200002.683975158@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

commit ed1ac3c977dd6b119405fa36dd41f7151bd5b4de upstream.

Commit 0b4eeee2876f ("iommu/arm-smmu-qcom: Register the TBU driver in
qcom_smmu_impl_init") intended to also probe the TBU driver when
CONFIG_ARM_SMMU_QCOM_DEBUG is disabled, but also moved the corresponding
platform_driver_register() call into qcom_smmu_impl_init() which is
called from arm_smmu_device_probe().

However, it neither makes sense to register drivers from probe()
callbacks of other drivers, nor does the driver core allow registering
drivers with a device lock already being held.

The latter was revealed by commit dc23806a7c47 ("driver core: enforce
device_lock for driver_match_device()") leading to a deadlock condition
described in [1].

Additionally, it was noted by Robin that the current approach is
potentially racy with async probe [2].

Hence, fix this by registering the qcom_smmu_tbu_driver from
module_init(). Unfortunately, due to the vendoring of the driver, this
requires an indirection through arm-smmu-impl.c.

Reported-by: Mark Brown <broonie@kernel.org>
Closes: https://lore.kernel.org/lkml/7ae38e31-ef31-43ad-9106-7c76ea0e8596@sirena.org.uk/
Link: https://lore.kernel.org/lkml/DFU7CEPUSG9A.1KKGVW4HIPMSH@kernel.org/ [1]
Link: https://lore.kernel.org/lkml/0c0d3707-9ea5-44f9-88a1-a65c62e3df8d@arm.com/ [2]
Fixes: dc23806a7c47 ("driver core: enforce device_lock for driver_match_device()")
Fixes: 0b4eeee2876f ("iommu/arm-smmu-qcom: Register the TBU driver in qcom_smmu_impl_init")
Acked-by: Robin Murphy <robin.murphy@arm.com>
Tested-by: Bjorn Andersson <andersson@kernel.org>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Acked-by: Konrad Dybcio <konradybcio@kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Tested-by: Ioana Ciornei <ioana.ciornei@nxp.com> #LX2160ARDB
Tested-by: Wang Jiayue <akaieurus@gmail.com>
Reviewed-by: Wang Jiayue <akaieurus@gmail.com>
Tested-by: Mark Brown <broonie@kernel.org>
Acked-by: Joerg Roedel <joerg.roedel@amd.com>
Link: https://patch.msgid.link/20260121141215.29658-1-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu-impl.c |   14 ++++++++++++++
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c |   14 ++++++++++----
 drivers/iommu/arm/arm-smmu/arm-smmu.c      |   24 +++++++++++++++++++++++-
 drivers/iommu/arm/arm-smmu/arm-smmu.h      |    5 +++++
 4 files changed, 52 insertions(+), 5 deletions(-)

--- a/drivers/iommu/arm/arm-smmu/arm-smmu-impl.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-impl.c
@@ -228,3 +228,17 @@ struct arm_smmu_device *arm_smmu_impl_in
 
 	return smmu;
 }
+
+int __init arm_smmu_impl_module_init(void)
+{
+	if (IS_ENABLED(CONFIG_ARM_SMMU_QCOM))
+		return qcom_smmu_module_init();
+
+	return 0;
+}
+
+void __exit arm_smmu_impl_module_exit(void)
+{
+	if (IS_ENABLED(CONFIG_ARM_SMMU_QCOM))
+		qcom_smmu_module_exit();
+}
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
@@ -774,10 +774,6 @@ struct arm_smmu_device *qcom_smmu_impl_i
 {
 	const struct device_node *np = smmu->dev->of_node;
 	const struct of_device_id *match;
-	static u8 tbu_registered;
-
-	if (!tbu_registered++)
-		platform_driver_register(&qcom_smmu_tbu_driver);
 
 #ifdef CONFIG_ACPI
 	if (np == NULL) {
@@ -802,3 +798,13 @@ struct arm_smmu_device *qcom_smmu_impl_i
 
 	return smmu;
 }
+
+int __init qcom_smmu_module_init(void)
+{
+	return platform_driver_register(&qcom_smmu_tbu_driver);
+}
+
+void __exit qcom_smmu_module_exit(void)
+{
+	platform_driver_unregister(&qcom_smmu_tbu_driver);
+}
--- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
@@ -2365,7 +2365,29 @@ static struct platform_driver arm_smmu_d
 	.remove = arm_smmu_device_remove,
 	.shutdown = arm_smmu_device_shutdown,
 };
-module_platform_driver(arm_smmu_driver);
+
+static int __init arm_smmu_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&arm_smmu_driver);
+	if (ret)
+		return ret;
+
+	ret = arm_smmu_impl_module_init();
+	if (ret)
+		platform_driver_unregister(&arm_smmu_driver);
+
+	return ret;
+}
+module_init(arm_smmu_init);
+
+static void __exit arm_smmu_exit(void)
+{
+	arm_smmu_impl_module_exit();
+	platform_driver_unregister(&arm_smmu_driver);
+}
+module_exit(arm_smmu_exit);
 
 MODULE_DESCRIPTION("IOMMU API for ARM architected SMMU implementations");
 MODULE_AUTHOR("Will Deacon <will@kernel.org>");
--- a/drivers/iommu/arm/arm-smmu/arm-smmu.h
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.h
@@ -540,6 +540,11 @@ struct arm_smmu_device *arm_smmu_impl_in
 struct arm_smmu_device *nvidia_smmu_impl_init(struct arm_smmu_device *smmu);
 struct arm_smmu_device *qcom_smmu_impl_init(struct arm_smmu_device *smmu);
 
+int __init arm_smmu_impl_module_init(void);
+void __exit arm_smmu_impl_module_exit(void);
+int __init qcom_smmu_module_init(void);
+void __exit qcom_smmu_module_exit(void);
+
 void arm_smmu_write_context_bank(struct arm_smmu_device *smmu, int idx);
 int arm_mmu500_reset(struct arm_smmu_device *smmu);
 


