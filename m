Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E921631A069;
	Fri,  9 Jan 2026 12:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963201; cv=none; b=XJCWNq+UP21aS0e7QPYPZZ0W8D9K7T/gtdPci3URfs7bXZfSr5ddLUyDSorA6dIOBwqeRHAg+BlA79QCFASJLlVeczc2DL+x4ejiBCPceUNh4vadmoMIz7h99kjZ2cvfG77LtnSogmoIsH1YyUFkkXmk5lrpyDwnuDQlOEnFtdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963201; c=relaxed/simple;
	bh=F/eG3PtCPE9SBCs2b3M0a1BGkbZjb3fRqjWjoRw0qvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=grk5S5EblxVF2glzSKbP9j7MjBzvdV3oAzBhZY9S8IgvvzOpk/C9hAk92VEjYrLZCaP/drxi1eD4gHVZsP7uh0XDowCgQp9XtafV3+5aR5SmUB7Hb5nVto0OVsk9gSEhuv/dVJFbGr1mRbMQRr1DZmsqpFiUr8TVWn5P60ruQs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TEEXlRlB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TEEXlRlB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79193C19421;
	Fri,  9 Jan 2026 12:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963200;
	bh=F/eG3PtCPE9SBCs2b3M0a1BGkbZjb3fRqjWjoRw0qvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TEEXlRlB7mgaFrrW5w9yu9c6dvSTtlPT7/mAs/7PTqLAuncQMRlz2D2o8FnmEPEbS
	 9xYujRP67sA0rlOcFqZ4EsW7+40cvoAel4FkWeeVP2AcTkGyWD8XokmLGIrGcxFbdG
	 sYM1KiB225yuqIOPXCUggYfS/DLXZU7F0Hb9yq9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 600/634] iommu/arm-smmu: Drop if with an always false condition
Date: Fri,  9 Jan 2026 12:44:38 +0100
Message-ID: <20260109112140.202555034@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit a2972cb89935160bfe515b15d28a77694723ac06 ]

The remove and shutdown callback are only called after probe completed
successfully. In this case platform_set_drvdata() was called with a
non-NULL argument and so smmu is never NULL. Other functions in this
driver also don't check for smmu being non-NULL before using it.

Also note that returning an error code from a remove callback doesn't
result in the device staying bound. It's still removed and devm allocated
resources are freed (among others *smmu and the register mapping). So
after an early exit to iommu device stayed around and using it probably
oopses.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/20230321084125.337021-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: 6a3908ce56e6 ("iommu/qcom: fix device leak on of_xlate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
@@ -2209,9 +2209,6 @@ static void arm_smmu_device_shutdown(str
 {
 	struct arm_smmu_device *smmu = platform_get_drvdata(pdev);
 
-	if (!smmu)
-		return;
-
 	if (!bitmap_empty(smmu->context_map, ARM_SMMU_MAX_CBS))
 		dev_notice(&pdev->dev, "disabling translation\n");
 
@@ -2232,9 +2229,6 @@ static int arm_smmu_device_remove(struct
 {
 	struct arm_smmu_device *smmu = platform_get_drvdata(pdev);
 
-	if (!smmu)
-		return -ENODEV;
-
 	iommu_device_unregister(&smmu->iommu);
 	iommu_device_sysfs_remove(&smmu->iommu);
 


