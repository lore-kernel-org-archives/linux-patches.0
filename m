Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0071FBEA6;
	Sat, 12 Sep 2026 19:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242698; cv=none; b=WsLgcHwlRek7dGSvLhdFHG8Q+TmO42rDUsOGZAv6dwVCbP8QP/vmO76p8nCy2PLND0FMgFoETmz68+Hi5VtUKYpWCVNZE3MCQbZLkqfx7c7pqKx+GS+Y7YgXcJixDGkumaqxxqBiA7tltS7QRWFxMdlZptqH8tZAf6yqpU66EZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242698; c=relaxed/simple;
	bh=pxZ0ZsFZ0k8e958h0ilV/ppSqnK1evxu3+1SfqFzAMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6qk36Z5dPqhuExmVamAgMaNNQcRHuiVi1DbHbL2zP93cCC4y5E578F9XAVJAWS+aIjOCqu6C7APkxXy+eHKZArGQ6/t/7/KI6RdkCEDLMQ6IEnTMoeVee0igFDPW5FBiMrLm3iEUOkrgXUi6AKVKVOb4g6JDZEDhpZD7BwneY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aGAQRgk+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aGAQRgk+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30031F000FF;
	Sat, 12 Sep 2026 19:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242697;
	bh=tXU6BQ9RB8e7uCjy4UDgXFexkjnNl9hZhaYOFzKDgh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aGAQRgk+XoaDtvdHv2GWvZcSlXEpN7626hGxPabb2WqpZcealTRjhkGYd00zXvpoA
	 0kLSOeeVXvitMnPLFwGmusrFCadr0V7YgEg9VJAyB089x737pimtnwhL6eEYwaK/WA
	 XGRcnM8wWIvgazSY/pVCpNOtoeFAtBWfMqOZW3to=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 495/798] iommu/arm-smmu: Add missing pm_runtime_disable() in qcom_iommu_device_probe
Date: Sat, 12 Sep 2026 09:02:03 +0200
Message-ID: <20260912065528.482930167@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 369a34cb75b51..6f782f8342561 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -853,14 +853,14 @@ static int qcom_iommu_device_probe(struct platform_device *pdev)
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
 
 	iommu_device_set_ops(&qcom_iommu->iommu, &qcom_iommu_ops);
@@ -869,7 +869,7 @@ static int qcom_iommu_device_probe(struct platform_device *pdev)
 	ret = iommu_device_register(&qcom_iommu->iommu);
 	if (ret) {
 		dev_err(dev, "Failed to register iommu\n");
-		return ret;
+		goto err_pm_disable;
 	}
 
 	bus_set_iommu(&platform_bus_type, &qcom_iommu_ops);
@@ -881,6 +881,10 @@ static int qcom_iommu_device_probe(struct platform_device *pdev)
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



