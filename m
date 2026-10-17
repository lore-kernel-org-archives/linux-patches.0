Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB58B3AE198;
	Sat, 17 Oct 2026 16:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255180; cv=none; b=EqUTbcBEI4C9VzFRl+iR3kLKQZW5JuLsjBlMvvYArL5uaAe719BxwjbBUefYwVSXx3qWrfAZVrwgi0MNjiufmnApMgSC7S+BCIm9qUZe/jqKsrsC8x2YCn0Ij9MOBVovOSjHSDQNnDOKvZYRJl71xbi/jw2j6gAIvoN+Q6daoFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255180; c=relaxed/simple;
	bh=rDMns8J3duTds4kxSqRF2BU3P630KMKUCS/Cc6il8v4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ANqXTAP6KSqZtm3rA/+2xpSdg79dqvfqaCtu3yagCoDipyLMUhuYX/XNuAMzMg3k/lqm4R5W+AoBe62ho07YSBOmu/NoAnKmmonlvrrlyzcnCWMyblkl90j8UwNC89UnXQiJXe3XQ2e14y8eTkCSF9y8EQS6DsVDDB4J4Ug7C6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bWwwdG5k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bWwwdG5k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5FE1F000C6;
	Sat, 17 Oct 2026 16:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255179;
	bh=FqftUvtXA/koyOsiyHZKrHIRP9AKqKeXu2+DKeosH0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bWwwdG5kyHBuVaG9Vqqn4rZr8erUzCv17hvJv0yb3FIQhoXEUGdaGqn7OwBMOPM5B
	 6ty4DsE47Zo8hV/ZSgJjRHSd8SFB8vR2udqHXCw4PICDoEYMQRM+ii0BebeUM8U0O9
	 /04wva6q4dM/UdUkt0yexGsPKSII7b1Nh8nZO/Zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 690/869] iommu/tegra241-cmdqv: Dont fall back to a freed smmu after devm_krealloc()
Date: Sat, 17 Oct 2026 17:58:51 +0200
Message-ID: <20261017160054.665953302@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
index 335928aa0ef59..3207fa9836063 100644
--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -805,16 +805,22 @@ static int tegra241_cmdqv_init_structures(struct arm_smmu_device *smmu)
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
@@ -823,25 +829,28 @@ __tegra241_cmdqv_probe(struct arm_smmu_device *smmu, struct resource *res,
 
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
 
 	regval = readl_relaxed(REG_CMDQV(cmdqv, PARAM));
 	cmdqv->num_vintfs = 1 << FIELD_GET(CMDQV_NUM_VINTF_LOG2, regval);
@@ -850,8 +859,10 @@ __tegra241_cmdqv_probe(struct arm_smmu_device *smmu, struct resource *res,
 
 	cmdqv->vintfs =
 		kcalloc(cmdqv->num_vintfs, sizeof(*cmdqv->vintfs), GFP_KERNEL);
-	if (!cmdqv->vintfs)
+	if (!cmdqv->vintfs) {
+		ret = -ENOMEM;
 		goto iounmap;
+	}
 
 	ida_init(&cmdqv->vintf_ids);
 
@@ -880,38 +891,37 @@ __tegra241_cmdqv_probe(struct arm_smmu_device *smmu, struct resource *res,
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
-- 
2.53.0



