Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91FF35C6BD;
	Sat, 12 Sep 2026 08:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200023; cv=none; b=YURyY6DR61sisrL6ThG99EMqwrv7w/+5C2bCoEvPKOF8WTffmxoZtTp+iirqsZ9KjG/K8w5v5lOMwnLAi+QukSBXENc2SWnB72nIiokgkmaGBNu6yUVZFKpRHf67vFBS+dhZj3VS3xxbiKRwvkJ/WLkS3VTBxuJ2ijCzCK7unIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200023; c=relaxed/simple;
	bh=XQ8qA9zV/I4wTAAVNehJiBqe9rmpn5WX4kvLjwgQNdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lhb/Sfde1Dan55pfaaddCTgkLIcHgLTeOkdwTNs2zbMjL5fCUI1pYsJI2KU0xGBKQma60UugOr1oh1E7EpPuzkSowZ0J8ZEGqnTHWgNJedKsm4uEQB9IZjuIARHPdng3mS/GUiem51/kLuBhvScOVeTnI9pZ0gWvoLQTCxgMr+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MDVdwXzC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MDVdwXzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4751F00893;
	Sat, 12 Sep 2026 08:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200021;
	bh=zR00hfwwbnXyVazseT+mQ3sD3Is8FCpTYci5WyTXbHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MDVdwXzCLQIHZDe6GH3HFS2tTMGv1rw7+gxuISl8TakIDvglhadLrOSgRXBjWddMI
	 H5EmJ/ceNEOnITKwshSSz4GBMI+IrLxruzZ92FRDhyv6Q3U1bO8oM3Ue06xMll4i43
	 VLAfowrfpzMCURQ0AkIyAoZSAjmrrVYcKd3R0n0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0705/1815] iommu/tegra241-cmdqv: Dont fall back to a freed smmu after devm_krealloc()
Date: Sat, 12 Sep 2026 08:40:55 +0200
Message-ID: <20260912065705.444995577@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index f017593fe3ddc..3d9554de5da27 100644
--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -938,16 +938,22 @@ static int tegra241_cmdqv_init_structures(struct arm_smmu_device *smmu)
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
@@ -956,25 +962,28 @@ __tegra241_cmdqv_probe(struct arm_smmu_device *smmu, struct resource *res,
 
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
@@ -986,8 +995,10 @@ __tegra241_cmdqv_probe(struct arm_smmu_device *smmu, struct resource *res,
 
 	cmdqv->vintfs =
 		kzalloc_objs(*cmdqv->vintfs, cmdqv->num_vintfs);
-	if (!cmdqv->vintfs)
+	if (!cmdqv->vintfs) {
+		ret = -ENOMEM;
 		goto iounmap;
+	}
 
 	ida_init(&cmdqv->vintf_ids);
 
@@ -1016,24 +1027,23 @@ __tegra241_cmdqv_probe(struct arm_smmu_device *smmu, struct resource *res,
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
 	struct platform_device *pdev = to_platform_device(smmu->impl_dev);
-	struct arm_smmu_device *new_smmu;
 	struct resource *res;
-	int irq;
+	int irq, ret;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
@@ -1046,15 +1056,15 @@ struct arm_smmu_device *tegra241_cmdqv_probe(struct arm_smmu_device *smmu)
 		dev_warn(&pdev->dev,
 			 "no interrupt. errors will not be reported\n");
 
-	new_smmu = __tegra241_cmdqv_probe(smmu, res, irq);
-	if (new_smmu)
-		return new_smmu;
+	ret = __tegra241_cmdqv_probe(&smmu, res, irq);
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



