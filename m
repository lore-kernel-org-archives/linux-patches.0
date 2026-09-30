Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33585531B06;
	Wed, 30 Sep 2026 17:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789723; cv=none; b=OoY26wVnhm+v8pyxjV9SIZFaDs1Yx+yPrhVPLH0hu9aiKb8Y58x/gAGIdIIbX+7j85J69tfrA4NWQH8kkQ0p9gM8+thh6eDIAN+ZfvcJjReMI6YINF0lDNEO9h/e9aculcXohUp2XadylXnrc2rGqOjGbmjNf1tBacy3c2i+EZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789723; c=relaxed/simple;
	bh=4HfR1FJfd4H0jcEP61J4XjON5irDD+cwdWHLvNxILo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTVCXjxnlaQEUz+0roQUmHTx/x2eXkxV0YBScNe48ZtMBKqb5Fo54L7n7/+MDhmzVFk/gC+05SP7BorKPqfcAigjo3B0jso38xHDaxfWt7JWREM04EFowilpwvaVFw3XuFAS7+P9ZA9tyFwQDui+ZSKMvU89s+PFRsE7cSAiYi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhRSy8sT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhRSy8sT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 520A11F00921;
	Wed, 30 Sep 2026 17:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789720;
	bh=P1wrR4xYx9MSjnhuBw0ORfSIiaL3PiwQkG9i53+0pkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bhRSy8sTV/j1xAbxIGOjz2XPAAFf+me17ce53UqKG5SN4iQdgE0Wh5xVP8Q32u6Qa
	 2cXdxC5NVCp6Az+8GIM6j4nuY6KoumCNlxkaQ88ajssyspnkiY6UJwh/nAM8dla65p
	 SVHefKnoeLezUq+kqPXwLad/9jQIZA4cO+tZzfKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Weimin Xiong <xiongwm2026@163.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 576/877] iommu/msm: Unwind probe state on registration failure
Date: Wed, 30 Sep 2026 17:24:47 +0200
Message-ID: <20260930152427.071728616@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Weimin Xiong <xiongwm2026@163.com>

[ Upstream commit 535a200220ca2c83bc8bf54bd2cbe045d6ee70c4 ]

msm_iommu_probe() adds its devm-managed IOMMU object to
qcom_iommu_devices before adding the IOMMU sysfs device and registering
it with the IOMMU core.

If iommu_device_sysfs_add() fails, probe returns with the object still on
qcom_iommu_devices. The driver core then releases the devm allocation,
leaving a dangling list entry that later list walks may dereference.

If iommu_device_register() fails, the same dangling list entry remains
and the sysfs device is left registered as well.

Unwind the sysfs device and global list entry in reverse setup order on
the corresponding failure paths.

Fixes: 42df43b36163 ("iommu/msm: Make use of iommu_device_register interface")
Cc: stable@vger.kernel.org
Reviewed-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Signed-off-by: Weimin Xiong <xiongwm2026@163.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/msm_iommu.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/iommu/msm_iommu.c
+++ b/drivers/iommu/msm_iommu.c
@@ -784,19 +784,25 @@ static int msm_iommu_probe(struct platfo
 				     "msm-smmu.%pa", &ioaddr);
 	if (ret) {
 		pr_err("Could not add msm-smmu at %pa to sysfs\n", &ioaddr);
-		return ret;
+		goto err_remove_list;
 	}
 
 	ret = iommu_device_register(&iommu->iommu, &msm_iommu_ops, &pdev->dev);
 	if (ret) {
 		pr_err("Could not register msm-smmu at %pa\n", &ioaddr);
-		return ret;
+		goto err_remove_sysfs;
 	}
 
 	pr_info("device mapped at %p, irq %d with %d ctx banks\n",
 		iommu->base, iommu->irq, iommu->ncb);
 
 	return ret;
+
+err_remove_sysfs:
+	iommu_device_sysfs_remove(&iommu->iommu);
+err_remove_list:
+	list_del(&iommu->dev_node);
+	return ret;
 }
 
 static const struct of_device_id msm_iommu_dt_match[] = {


