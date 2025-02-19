Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEED1DF259;
	Wed, 19 Feb 2025 09:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956797; cv=none; b=bQALfo9vWgaxRKz7/DhnBg5g2BIsFzk5wqsXIcfNvbJ75lqJ6PgV3Ovn5eY8qMKLvH1/Ms6uol3wfVmG+6Ar9ha1OsCiNsmPCXRYnkRSIK8AkvLvTVj7Yb9pDTUei0QqPQD/fxp7ZYpwSDZUcKZW7ISMuGEgDsDYlWO07c11lck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956797; c=relaxed/simple;
	bh=Dn+C9jwpzNw1um8mrKQunYHTnCdfLJ2NzuGFulqdUDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbFO3XBjNGlfZnnAsY+FyyihvhbZ2h+tbEyHY36CTV85lj2e2z+eYwu8mQMvDOXH/2I+RxgYu4w5bly9Y22OUA6Vpcqg6F7fyrY39uSfngRX4qcyPGdWEm21zYUCvZJwfOJBIesxGTNc49GujBJdDHtXIwJn0PCkeZMFEB88ITk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CxEiVNn3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CxEiVNn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0355CC4CED1;
	Wed, 19 Feb 2025 09:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956797;
	bh=Dn+C9jwpzNw1um8mrKQunYHTnCdfLJ2NzuGFulqdUDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CxEiVNn3sH4LQlcwCKX9DF8uueAqQpJg0vCTXeP46xRkBE5QshiAWIFrm7pqEG9IP
	 bpFEp8VdMujIuR+10m1cok1iXgb2jjkyxLofzv0BD1MSf7BMzDt4CuJVgNNgtkosu6
	 oYxKSQNYhZrCL53nYIuA+RTp2pIrJ+1hoTJqnm+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 303/578] iommu/arm-smmu-v3: Clean up more on probe failure
Date: Wed, 19 Feb 2025 09:25:07 +0100
Message-ID: <20250219082704.938366281@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit fcbd621567420b3a2f21f49bbc056de8b273c625 ]

kmemleak noticed that the iopf queue allocated deep down within
arm_smmu_init_structures() can be leaked by a subsequent error return
from arm_smmu_device_probe(). Furthermore, after arm_smmu_device_reset()
we will also leave the SMMU enabled with an empty Stream Table, silently
blocking all DMA. This proves rather annoying for debugging said probe
failure, so let's handle it a bit better by putting the SMMU back into
(more or less) the same state as if it hadn't probed at all.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/5137901958471cf67f2fad5c2229f8a8f1ae901a.1733406914.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 45b43f729f895..96b72f3dad0d0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3880,7 +3880,7 @@ static int arm_smmu_device_probe(struct platform_device *pdev)
 	/* Initialise in-memory data structures */
 	ret = arm_smmu_init_structures(smmu);
 	if (ret)
-		return ret;
+		goto err_free_iopf;
 
 	/* Record our private device structure */
 	platform_set_drvdata(pdev, smmu);
@@ -3891,22 +3891,29 @@ static int arm_smmu_device_probe(struct platform_device *pdev)
 	/* Reset the device */
 	ret = arm_smmu_device_reset(smmu, bypass);
 	if (ret)
-		return ret;
+		goto err_disable;
 
 	/* And we're up. Go go go! */
 	ret = iommu_device_sysfs_add(&smmu->iommu, dev, NULL,
 				     "smmu3.%pa", &ioaddr);
 	if (ret)
-		return ret;
+		goto err_disable;
 
 	ret = iommu_device_register(&smmu->iommu, &arm_smmu_ops, dev);
 	if (ret) {
 		dev_err(dev, "Failed to register iommu\n");
-		iommu_device_sysfs_remove(&smmu->iommu);
-		return ret;
+		goto err_free_sysfs;
 	}
 
 	return 0;
+
+err_free_sysfs:
+	iommu_device_sysfs_remove(&smmu->iommu);
+err_disable:
+	arm_smmu_device_disable(smmu);
+err_free_iopf:
+	iopf_queue_free(smmu->evtq.iopf);
+	return ret;
 }
 
 static int arm_smmu_device_remove(struct platform_device *pdev)
-- 
2.39.5



