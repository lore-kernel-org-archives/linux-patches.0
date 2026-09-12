Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6880D214A84;
	Sat, 12 Sep 2026 12:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216303; cv=none; b=sRyL/BFDFMkTVPrkvPVxd47iVB23IgAoyLiNDo1KO1hH0MYjIWWfT8338XeWHsK0+ce85ACPFx6bmHKxelsrrP/I5tUh2coUQPPdgPaDWPykcRn2lbfdgyxg7hs+G/9h8XAybw5VB16FZaYi706NYHgjGAvdq9oySHs31HquzIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216303; c=relaxed/simple;
	bh=+gZCPDjSrCtNd9bK/1yCtJLkS+dlQhZneq1rA7CpeNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JtaEh6/JOKVtr6uUL6qcBWitg5fO/L4HWgYvVEDKetPUz4L2iHMhIv358ahk4gNdXIw8ZNAzj+eEPl/M27gtt9lPpMIRVZkqpNBzc+g5j7VbsJs6ZFY3Z23KrwAnxSahjDkGiXFqHfLaGqM516kXfHW/xal6axGEkM+CZsSrdMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ps9zsLo/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ps9zsLo/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846EF1F000FF;
	Sat, 12 Sep 2026 12:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216302;
	bh=ipzjzlyqK0Sob5p6qIa+zyCzNZCjWc9HR804ZGtGmW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ps9zsLo/8ad8oyVh3dNOYlQFXrDP/gdxAPXmBZge+8H3g0pKFAMbNl4mOWCdxuoiL
	 prI1E7Co57+zqhGoG7etW+ZLV/8+lk8YsdpQ4Kr4WbjNNwKRamuMzWDazpqBPsRnr7
	 1LGaXfvv6zBJex/8kn+ZIYv8W4J2QfnhbXRDJq98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0710/1376] iommu/tegra241-cmdqv: Free the error IRQ before tearing down VINTFs
Date: Sat, 12 Sep 2026 08:52:16 +0200
Message-ID: <20260912065623.367462706@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

[ Upstream commit 61f0d437988e5730b04442f6a7d30a9907339f2a ]

tegra241_cmdqv_remove() tears each VINTF down first, then calls free_irq().
Tearing a VINTF down frees vintf0 and clears cmdqv->vintfs[0]. An error in
that window makes tegra241_cmdqv_isr() read the stale slot and hand it to
tegra241_vintf0_handle_error(), which dereferences a NULL or freed pointer.

Free the IRQ before tearing the VINTFs down. free_irq() waits for in-flight
handlers to finish and blocks new ones, so no ISR can observe a VINTF as it
is torn down.

Note: a user-owned VINTF (viommu) could outlive this teardown, which unmaps
cmdqv->base and frees cmdqv->vintfs, so a later viommu close then touches
freed memory. This is neither introduced nor fixed here: a physical IOMMU
is not a pluggable device, so iommufd by design holds no reference on the
one behind a viommu, and this teardown is not expected while that viommu is
still alive.

Fixes: 918eb5c856f6 ("iommu/arm-smmu-v3: Add in-kernel support for NVIDIA Tegra241 (Grace) CMDQV")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
index 51aca5269de9b..8d42c63717b6e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -659,6 +659,14 @@ static void tegra241_cmdqv_remove(struct arm_smmu_device *smmu)
 		container_of(smmu, struct tegra241_cmdqv, smmu);
 	u16 idx;
 
+	/*
+	 * Free the IRQ before tearing down the VINTFs. free_irq() waits for any
+	 * in-flight tegra241_cmdqv_isr() to finish and blocks new ones, so the
+	 * ISR cannot dereference a VINTF that is freed by the loop below.
+	 */
+	if (cmdqv->irq > 0)
+		free_irq(cmdqv->irq, cmdqv);
+
 	/* Remove VINTF resources */
 	for (idx = 0; idx < cmdqv->num_vintfs; idx++) {
 		if (cmdqv->vintfs[idx]) {
@@ -671,8 +679,6 @@ static void tegra241_cmdqv_remove(struct arm_smmu_device *smmu)
 	/* Remove cmdqv resources */
 	ida_destroy(&cmdqv->vintf_ids);
 
-	if (cmdqv->irq > 0)
-		free_irq(cmdqv->irq, cmdqv);
 	iounmap(cmdqv->base);
 	kfree(cmdqv->vintfs);
 	put_device(cmdqv->dev); /* smmu->impl_dev */
-- 
2.53.0



