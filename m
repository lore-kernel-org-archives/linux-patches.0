Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7F329BDB4;
	Tue, 17 Feb 2026 20:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361556; cv=none; b=JSf9PN1mPYug84TX8kOJfA9yOcESEU4jQwSTJLMHqr2uTidD0LK81pNNZKkeFW5tuQKy7g6wXuNiRlYYqxunCPEw/Lt9HLgAm07zShzLkoJ4qB5WBt2hCfs04ppm7ssB5f25VYVKh7jJo4DqUE+wEEuZNSA9g/Zsi8Ugpb7h8g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361556; c=relaxed/simple;
	bh=KkM4qlseatZ6C6qzfQlyx0f3C7SRZIa5Q+CIT2qUkeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDnEOHwHXL/YWIBEhZEM24RuUuEip7z7ULR9BaQXPMj0mYqtBS2p9KOnJ+YXIR01g4dGjcH5OsosnBxmawif0ai2eo8SzFu7dMVJoBIIHFVdwzZMbp0kRkQyX3kY8XPhKKovysohx5PtRDkJ4Ua/QOu8YI8IWIDEPpM3tregzIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rYF7UKF2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rYF7UKF2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5176C4CEF7;
	Tue, 17 Feb 2026 20:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361556;
	bh=KkM4qlseatZ6C6qzfQlyx0f3C7SRZIa5Q+CIT2qUkeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rYF7UKF2u9v/p7zTBwxd6GDnnEeFlQsOHJ/7S24aABBT84Y7El6zIHCQYJVlin5B7
	 mhXeQSPGnpLAtIxaV/G1/LEbbMQ0ZZe07CelLxTSdsyBlFgyub5kS/lVh4PCiuWosI
	 p+oPRRXzy67NlIVFxir5m+Sr8YPDW4xwaY6d4nZ8=
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
Subject: [PATCH 6.18 40/43] iommu/arm-smmu-qcom: do not register driver in probe()
Date: Tue, 17 Feb 2026 21:32:20 +0100
Message-ID: <20260217200008.002408015@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200006.470920131@linuxfoundation.org>
References: <20260217200006.470920131@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -773,10 +773,6 @@ struct arm_smmu_device *qcom_smmu_impl_i
 {
 	const struct device_node *np = smmu->dev->of_node;
 	const struct of_device_id *match;
-	static u8 tbu_registered;
-
-	if (!tbu_registered++)
-		platform_driver_register(&qcom_smmu_tbu_driver);
 
 #ifdef CONFIG_ACPI
 	if (np == NULL) {
@@ -801,3 +797,13 @@ struct arm_smmu_device *qcom_smmu_impl_i
 
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
@@ -2362,7 +2362,29 @@ static struct platform_driver arm_smmu_d
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
 


