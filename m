Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5EC832B126;
	Sat, 12 Sep 2026 18:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239017; cv=none; b=qOtYwyFBtKN5RXzLQ5uc1qNgwSNiCwMzlr2Yn5+y/BR1txm20Nlh37Pb4fqKMX/9voRfV0oCDCx4nu+H0GjMlwbdndIwDIObDaClIGLhk9za39jg6U8RuuJ8+TXsNF+PsmkpUQyiMYXVsLClkl+5rRJjK7Hl42GfsjfTceHGWPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239017; c=relaxed/simple;
	bh=H3I5RoN5pES4PJDbVhBCI9W7ufoIQRRcnwFxZdDQe+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJR8ceP5Fndt6NkvzAmx8VezObyoIQT4RN+awwh2HcBNHQd0OCIqT2gkVlckRFeqJLtt9rj9uKtVBzuCWIsoslRfC107BcSLYyQSzhh+Fx85mHLz/e1pqFnpIQx3DfMj/VvoHcs4hXdA2AD90SXGJJmetdVt9dFeD5of0U9Slrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ngyERuBd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ngyERuBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235CB1F000FF;
	Sat, 12 Sep 2026 18:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239016;
	bh=zyk+Qu01XVyhI0ai0p9fQOiDf1QRXzacBbrzRKCnPkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ngyERuBdmJtaBiEKa0juK+O5gMvzzQ4VQKbaqn6oWNzLJPqMItSdp0nVsGhVBXTd5
	 q/e2ENNaSHODalYjgIePX7h+tOImdKptKLVtI3G4LVC8heL0fY9bnMIvaV5C9nbC+2
	 jZedVvCX+nuY7xUH7m/73Aw8FIDSLKmQhFN+gTwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 577/935] iommu/arm-smmu: Add missing pm_runtime_disable() in qcom_iommu_device_probe
Date: Sat, 12 Sep 2026 09:00:07 +0200
Message-ID: <20260912065540.072288480@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 93665e0275a2e2badfcfca5ada3b78b22df4a01a ]

If the probe fails, we should use pm_runtime_disable() to balance
pm_runtime_enable().
Add missing pm_runtime_disable() for error handling.

Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220105101619.29108-1-linmq006@gmail.com
Signed-off-by: Will Deacon <will@kernel.org>
Stable-dep-of: c579f18e7959 ("iommu/qcom: Remove sysfs device on probe failure path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/qcom_iommu.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu/qcom_iommu.c b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
index c4379109f11d0..9a95587159ca0 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -835,20 +835,20 @@ static int qcom_iommu_device_probe(struct platform_device *pdev)
 	ret = devm_of_platform_populate(dev);
 	if (ret) {
 		dev_err(dev, "Failed to populate iommu contexts\n");
-		return ret;
+		goto err_pm_disable;
 	}
 
 	ret = iommu_device_sysfs_add(&qcom_iommu->iommu, dev, NULL,
 				     dev_name(dev));
 	if (ret) {
 		dev_err(dev, "Failed to register iommu in sysfs\n");
-		return ret;
+		goto err_pm_disable;
 	}
 
 	ret = iommu_device_register(&qcom_iommu->iommu, &qcom_iommu_ops, dev);
 	if (ret) {
 		dev_err(dev, "Failed to register iommu\n");
-		return ret;
+		goto err_pm_disable;
 	}
 
 	bus_set_iommu(&platform_bus_type, &qcom_iommu_ops);
@@ -860,6 +860,10 @@ static int qcom_iommu_device_probe(struct platform_device *pdev)
 	}
 
 	return 0;
+
+err_pm_disable:
+	pm_runtime_disable(dev);
+	return ret;
 }
 
 static int qcom_iommu_device_remove(struct platform_device *pdev)
-- 
2.53.0



