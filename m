Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F0C3750BE;
	Sat, 12 Sep 2026 08:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200018; cv=none; b=ckXb/cq0mLX9DFMnHeYwNY31ZVo+EeP3WZ5NSucgahi3dTm1MTPo9Yt/tdPGlEpbdr5rb7dAuOlYAOqcdFC4eDCbINLH0eCuY8Hi8JfSmFi8HVeK1sPXMeEWJCSe1NFua/fcZWopr9Vqi0KYL7CpzkxBUrxXK+xbiHlcKwFLWEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200018; c=relaxed/simple;
	bh=FPZXhj2mhyMs897s0jLx83J0GZpiKPx8q0bMcqKQUzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iq7moLotA+udBYEV6rbKrtp30wEIncQTcqKSfisIFQx7KuxTwOrQnHo8/FcTIcIRFW3ZOq/CyUxbia8GHp8n+e4qVngGkRn8WLdSi6LRnl08bbf8BF/oNdafri/XIBH0gzTP9tCf0TZZzuh6l3BTZgzuqGPqgNuPwLVyjG6Cd14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YbnZWXXu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YbnZWXXu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279E21F000FF;
	Sat, 12 Sep 2026 08:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200017;
	bh=Do8IQI9TpPv6Fj4+/gVAJQfJYaBFHmGa74/P7514er8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YbnZWXXuPkpFhHKa4pw129HWgrrkI41WjTMJGZ7+yQLJHIG3nucBtvr9ab9yf4p0d
	 AxyB8HxSN5riPmuAmNvy0vSVIOMKayN4fMWBSo3Fbc4M3lFig1luTUmCQghjZPEgX9
	 7W9WrFUJ6thWZ9QNd4TZ/onai5Y5+g8oDDOtkVII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0704/1815] iommu/tegra241-cmdqv: Dont run the error ISR before probe sets up vintfs
Date: Sat, 12 Sep 2026 08:40:54 +0200
Message-ID: <20260912065705.419312177@linuxfoundation.org>
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

[ Upstream commit 5acd67ceb38debe2fbf70ea35e2dec9f7ab01bbd ]

__tegra241_cmdqv_probe() requests the error IRQ before it has allocated the
cmdqv->vintfs array and set cmdqv->num_vintfs. A CMDQV left enabled with a
latched error across a kexec fires the IRQ as soon as it is requested, and
tegra241_cmdqv_isr() then walks the uninitialized cmdqv->vintfs array.

Request the IRQ only after cmdqv->vintfs is allocated and zeroed, so that
a latched interrupt firing early runs the ISR against a valid array of NULL
slots that it safely skips.

Fixes: 918eb5c856f6 ("iommu/arm-smmu-v3: Add in-kernel support for NVIDIA Tegra241 (Grace) CMDQV")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../iommu/arm/arm-smmu-v3/tegra241-cmdqv.c    | 34 +++++++++++--------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
index f6f2eb693e07a..f017593fe3ddc 100644
--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -977,17 +977,6 @@ __tegra241_cmdqv_probe(struct arm_smmu_device *smmu, struct resource *res,
 	cmdqv->dev = smmu->impl_dev;
 	cmdqv->base_phys = res->start;
 
-	if (cmdqv->irq > 0) {
-		ret = request_threaded_irq(irq, NULL, tegra241_cmdqv_isr,
-					   IRQF_ONESHOT, "tegra241-cmdqv",
-					   cmdqv);
-		if (ret) {
-			dev_err(cmdqv->dev, "failed to request irq (%d): %d\n",
-				cmdqv->irq, ret);
-			goto iounmap;
-		}
-	}
-
 	regval = readl_relaxed(REG_CMDQV(cmdqv, PARAM));
 	cmdqv->num_vintfs = 1 << FIELD_GET(CMDQV_NUM_VINTF_LOG2, regval);
 	cmdqv->num_vcmdqs = 1 << FIELD_GET(CMDQV_NUM_VCMDQ_LOG2, regval);
@@ -998,10 +987,25 @@ __tegra241_cmdqv_probe(struct arm_smmu_device *smmu, struct resource *res,
 	cmdqv->vintfs =
 		kzalloc_objs(*cmdqv->vintfs, cmdqv->num_vintfs);
 	if (!cmdqv->vintfs)
-		goto free_irq;
+		goto iounmap;
 
 	ida_init(&cmdqv->vintf_ids);
 
+	/*
+	 * Request the IRQ only after cmdqv->vintfs is allocated and zeroed, so
+	 * the ISR would not walk an uninitialized array.
+	 */
+	if (cmdqv->irq > 0) {
+		ret = request_threaded_irq(irq, NULL, tegra241_cmdqv_isr,
+					   IRQF_ONESHOT, "tegra241-cmdqv",
+					   cmdqv);
+		if (ret) {
+			dev_err(cmdqv->dev, "failed to request irq (%d): %d\n",
+				cmdqv->irq, ret);
+			goto free_vintfs;
+		}
+	}
+
 #ifdef CONFIG_IOMMU_DEBUGFS
 	if (!cmdqv_debugfs_dir) {
 		cmdqv_debugfs_dir =
@@ -1016,9 +1020,9 @@ __tegra241_cmdqv_probe(struct arm_smmu_device *smmu, struct resource *res,
 
 	return new_smmu;
 
-free_irq:
-	if (cmdqv->irq > 0)
-		free_irq(cmdqv->irq, cmdqv);
+free_vintfs:
+	ida_destroy(&cmdqv->vintf_ids);
+	kfree(cmdqv->vintfs);
 iounmap:
 	iounmap(base);
 	return NULL;
-- 
2.53.0



