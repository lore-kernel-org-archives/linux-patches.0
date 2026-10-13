Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4AD1397B09;
	Tue, 13 Oct 2026 12:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894167; cv=none; b=Reg/Drm28YJfm/17YoXMjY1TdHVfleUEQ4/7mpP9CsOFlaodMAlTh+ydm5Pt/x5dNAMizLVMO+aH8kh7Yd99b9ZB2YB5s1hS6IuTQPuAMOzb0elOqCOq/K9OI6X5qJI8VGecPpQG1h59bC9hOMG2cT4aqB9t/9VEJPXUt4XQYv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894167; c=relaxed/simple;
	bh=HCNW2jrDgSfDCnpoM/dMem4bhU0IVAX739Y/snD+Mbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KpHdkvezDHVmPWKHWhCIUMVMnneSfsJj4L0kQFkN2bdADVKlXm1jJM+bLEExAZuz7g9dTUOP3rpJT5y+n5GVLi9Q0ieFfKfxlCWyiWg2pFGTtYll7yh0GknGEhss+4A1dWZ+gpCKdJtcRsxe62jXBH0l7/rsEQGkUauis+12pb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zXd+H5VF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zXd+H5VF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0071F000FF;
	Tue, 13 Oct 2026 12:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894166;
	bh=zlnevuVGxuKiGRKNYfNG97LQugfC3GugpZzs6Th3NdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zXd+H5VFFksHQlygn+HI4eZUhOGbDSLw+HKTbrs0NYIin63fVt9+8BzSEyx1rLxTL
	 JGpJi7lum4YCsabmM2CnrBB6zT8sH4UVpg7qtpebShLxMglFPUAQuy9jMf0cDVHU1R
	 kMa03uT5KxkzPEqyhZLKu8SD80gzJa/kib7bd3lY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 468/621] iommu/tegra241-cmdqv: Dont fall back to a freed smmu after devm_krealloc()
Date: Tue, 13 Oct 2026 13:37:43 +0200
Message-ID: <20261013112931.939079186@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Nicolin Chen <nicolinc@nvidia.com>

[ Upstream commit d4d05f55e9da646ec03adfa77260eb46f4163749 ]

__tegra241_cmdqv_probe() uses devm_krealloc() to grow @smmu into the larger
tegra241_cmdqv, which frees the original @smmu once it relocates. A failure
after that returned NULL, and the caller then dereferenced the freed @smmu
on its fallback path.

Return an int and take @smmu by reference instead, then update *smmu to the
reallocated pointer after devm_krealloc() succeeds, so the caller and its
fallback path both use the live @smmu rather than the freed original.

Fixes: 918eb5c856f6 ("iommu/arm-smmu-v3: Add in-kernel support for NVIDIA Tegra241 (Grace) CMDQV")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../iommu/arm/arm-smmu-v3/tegra241-cmdqv.c    | 54 +++++++++++--------
 1 file changed, 32 insertions(+), 22 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
index 2b55a221c35a6..fdbd487848e64 100644
--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -1015,16 +1015,22 @@ static int tegra241_cmdqv_init_structures(struct arm_smmu_device *smmu)
 static struct dentry *cmdqv_debugfs_dir;
 #endif
 
-static struct arm_smmu_device *
-__tegra241_cmdqv_probe(struct arm_smmu_device *smmu, struct resource *res,
-		       int irq)
+/*
+ * Probe the CMDQV and reallocate @smmu into the larger cmdqv->smmu.
+ *
+ * devm_krealloc() may relocate and free the original @smmu, so update *smmu to
+ * the new pointer once it succeeds. The error paths after it do the same, so a
+ * caller falling back keeps a live @smmu instead of the freed original.
+ */
+static int __tegra241_cmdqv_probe(struct arm_smmu_device **smmu,
+				  struct resource *res, int irq)
 {
 	static const struct arm_smmu_impl_ops init_ops = {
 		.init_structures = tegra241_cmdqv_init_structures,
 		.device_remove = tegra241_cmdqv_remove,
 	};
-	struct tegra241_cmdqv *cmdqv = NULL;
-	struct arm_smmu_device *new_smmu;
+	struct device *dev = (*smmu)->dev;
+	struct tegra241_cmdqv *cmdqv;
 	void __iomem *base;
 	u32 regval;
 	int ret;
@@ -1033,25 +1039,28 @@ __tegra241_cmdqv_probe(struct arm_smmu_device *smmu, struct resource *res,
 
 	base = ioremap(res->start, resource_size(res));
 	if (!base) {
-		dev_err(smmu->dev, "failed to ioremap\n");
-		return NULL;
+		dev_err(dev, "failed to ioremap\n");
+		return -ENOMEM;
 	}
 
 	regval = readl(base + TEGRA241_CMDQV_CONFIG);
 	if (disable_cmdqv) {
-		dev_info(smmu->dev, "Detected disable_cmdqv=true\n");
+		dev_info(dev, "Detected disable_cmdqv=true\n");
 		writel(regval & ~CMDQV_EN, base + TEGRA241_CMDQV_CONFIG);
+		ret = -ENODEV;
 		goto iounmap;
 	}
 
-	cmdqv = devm_krealloc(smmu->dev, smmu, sizeof(*cmdqv), GFP_KERNEL);
-	if (!cmdqv)
+	cmdqv = devm_krealloc(dev, *smmu, sizeof(*cmdqv), GFP_KERNEL);
+	if (!cmdqv) {
+		ret = -ENOMEM;
 		goto iounmap;
-	new_smmu = &cmdqv->smmu;
+	}
+	*smmu = &cmdqv->smmu;
 
 	cmdqv->irq = irq;
 	cmdqv->base = base;
-	cmdqv->dev = smmu->impl_dev;
+	cmdqv->dev = (*smmu)->impl_dev;
 	cmdqv->base_phys = res->start;
 
 	regval = readl_relaxed(REG_CMDQV(cmdqv, PARAM));
@@ -1063,8 +1072,10 @@ __tegra241_cmdqv_probe(struct arm_smmu_device *smmu, struct resource *res,
 
 	cmdqv->vintfs =
 		kcalloc(cmdqv->num_vintfs, sizeof(*cmdqv->vintfs), GFP_KERNEL);
-	if (!cmdqv->vintfs)
+	if (!cmdqv->vintfs) {
+		ret = -ENOMEM;
 		goto iounmap;
+	}
 
 	ida_init(&cmdqv->vintf_ids);
 
@@ -1093,40 +1104,39 @@ __tegra241_cmdqv_probe(struct arm_smmu_device *smmu, struct resource *res,
 #endif
 
 	/* Provide init-level ops only, until tegra241_cmdqv_init_structures */
-	new_smmu->impl_ops = &init_ops;
+	cmdqv->smmu.impl_ops = &init_ops;
 
-	return new_smmu;
+	return 0;
 
 free_vintfs:
 	ida_destroy(&cmdqv->vintf_ids);
 	kfree(cmdqv->vintfs);
 iounmap:
 	iounmap(base);
-	return NULL;
+	return ret;
 }
 
 struct arm_smmu_device *tegra241_cmdqv_probe(struct arm_smmu_device *smmu)
 {
-	struct arm_smmu_device *new_smmu;
 	struct resource *res = NULL;
-	int irq;
+	int irq, ret;
 
 	if (!smmu->dev->of_node)
 		res = tegra241_cmdqv_find_acpi_resource(smmu->impl_dev, &irq);
 	if (!res)
 		goto out_fallback;
 
-	new_smmu = __tegra241_cmdqv_probe(smmu, res, irq);
+	ret = __tegra241_cmdqv_probe(&smmu, res, irq);
 	kfree(res);
 
-	if (new_smmu)
-		return new_smmu;
+	if (!ret)
+		return smmu;
 
 out_fallback:
 	dev_info(smmu->impl_dev, "Falling back to standard SMMU CMDQ\n");
 	smmu->options &= ~ARM_SMMU_OPT_TEGRA241_CMDQV;
 	put_device(smmu->impl_dev);
-	return ERR_PTR(-ENODEV);
+	return smmu;
 }
 
 /* User space VINTF and VCMDQ Functions */
-- 
2.53.0



