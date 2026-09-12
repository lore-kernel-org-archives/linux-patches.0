Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBB832B126;
	Sat, 12 Sep 2026 18:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239022; cv=none; b=ZtINFJlC/9/Wna83wb7y7Ug1lzhC3uJnqDbC8ds+YDqvTQLXCQP8r9ofWAc0C1RwdVtSmYoKG50jX/6pO6fm5bpsS0Py0koArBvmBcadAaPau62WwKSZSGDwiYOfF8y1U+NaReU0rCkX+6XYRtCs3TnoXqAW0VU7mXg2T1y0Oiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239022; c=relaxed/simple;
	bh=G6qoFVdy/msHfuZqQ9xcSiFI1No0AiQGXIRqwRR7fQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CmWZI7lgfiQAs8q3QSgRXrUgOrUF0VFEHqwVIndHTNXaZqqSS37GvOOHvcmitwdlMkvbZe9osFEmu2e7leuQm/4t24+zb//lKZ818FI8Jp6fYFgEOCcUqPGVEku2GNgZN50Kjbhfwc+Og0yZk1qWiyUCYuGNiUSPco3vLLAQQHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BU2ogibr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BU2ogibr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EABB71F000FF;
	Sat, 12 Sep 2026 18:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239021;
	bh=V2V71B0kh9c/i6BZ+QDNzThlCMWL0pych80dlGqxLE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BU2ogibrqVRxVkcTxSTGu/yHxPsCgpBxR6zlVBxn5jgTPc+YzPTNMWTqRWAQ1v9SX
	 7wUJuYtXJlFEQAKC+MAyfoKW827EKmZoRNyZ/PM4NR1DTGKT/LeWIZXg9nWz4p44mQ
	 QeXaeDaeA3485VS2ym5EhjsHcK+7UvxzprPRnn4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 578/935] iommu/qcom: Remove sysfs device on probe failure path
Date: Sat, 12 Sep 2026 09:00:08 +0200
Message-ID: <20260912065540.095471187@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

[ Upstream commit c579f18e79599c16168925cb149e1db3f29eea5f ]

In qcom_iommu_device_probe(), if iommu_device_register()
fails, the sysfs device created by iommu_device_sysfs_add()
is not released. Add a goto label to do the cleanup.

Fixes: 0ae349a0f33f ("iommu/qcom: Add qcom_iommu")
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/qcom_iommu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu/qcom_iommu.c b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
index 9a95587159ca0..55a2440cb44fe 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -848,7 +848,7 @@ static int qcom_iommu_device_probe(struct platform_device *pdev)
 	ret = iommu_device_register(&qcom_iommu->iommu, &qcom_iommu_ops, dev);
 	if (ret) {
 		dev_err(dev, "Failed to register iommu\n");
-		goto err_pm_disable;
+		goto err_sysfs_remove;
 	}
 
 	bus_set_iommu(&platform_bus_type, &qcom_iommu_ops);
@@ -861,6 +861,8 @@ static int qcom_iommu_device_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_sysfs_remove:
+	iommu_device_sysfs_remove(&qcom_iommu->iommu);
 err_pm_disable:
 	pm_runtime_disable(dev);
 	return ret;
-- 
2.53.0



