Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791C51420A8;
	Tue, 27 Feb 2024 13:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041303; cv=none; b=IXgxuwTH6Q5xIF9yKALVpg3ZheqwviFyTkpPxdXAVl7Nk2QCupe+Xv1EqyPof9ZuufJEsnWf/8JOXrmM5n152qjgCQbnPHXzZvhjO7HiHB0T0m4JCuqWvwSRBSgOJZgTZLZ/FdRMVfm+1SQfTGsW9D02EoQLle5sx1y5opDSA0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041303; c=relaxed/simple;
	bh=xXWOOYCL0LSFKppksqUDYK051GxK+3YEYo3WuPBbGtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMeajPjqsOLY8Rg4OOjbKsHZ7SLACZ+fmCkWgud9hxLMMtDsJjqZCxyJ2JpsARSBps/7RqFQGoyYa3jFb5RAo1tG6fzKZx17oKS6oDnaAFG3aZgkyB6MyCNMBSOFKX/3AoevpKIQVMSPFv3nI01rok6F1MUD5tWOcpXVYeXGbu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IeKHKzGH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IeKHKzGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058AEC43390;
	Tue, 27 Feb 2024 13:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041303;
	bh=xXWOOYCL0LSFKppksqUDYK051GxK+3YEYo3WuPBbGtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IeKHKzGHvNbdkeYV5iotdbPo9JAR7ji+n8nXFiAK4+/jeRd03tQNDc7PL7iGpLjw9
	 C1CsL/lvnECFbmiluFYFX+iY66wRKVnatdKMsRmdw8DNyEU97NVfvyeR4zsfR1LwCE
	 FlGkdPEwgrtdmvFAQRw3UUubFXxySgypghchtrso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Liu <yi.l.liu@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 292/334] iommu/vt-d: Wrap the dirty tracking loop to be a helper
Date: Tue, 27 Feb 2024 14:22:30 +0100
Message-ID: <20240227131640.442207711@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Liu <yi.l.liu@intel.com>

[ Upstream commit 0c7f2497b39da44253d7bcf2b41f52b0048859ad ]

Add device_set_dirty_tracking() to loop all the devices and set the dirty
tracking per the @enable parameter.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Link: https://lore.kernel.org/r/20240208082307.15759-8-yi.l.liu@intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: f1e1610950ea ("iommu/vt-d: Add missing dirty tracking set for parent domain")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 88f9b4ffd5774..e3b3ab506b185 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4865,23 +4865,38 @@ static void *intel_iommu_hw_info(struct device *dev, u32 *length, u32 *type)
 	return vtd;
 }
 
+/*
+ * Set dirty tracking for the device list of a domain. The caller must
+ * hold the domain->lock when calling it.
+ */
+static int device_set_dirty_tracking(struct list_head *devices, bool enable)
+{
+	struct device_domain_info *info;
+	int ret = 0;
+
+	list_for_each_entry(info, devices, link) {
+		ret = intel_pasid_setup_dirty_tracking(info->iommu, info->dev,
+						       IOMMU_NO_PASID, enable);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
 static int intel_iommu_set_dirty_tracking(struct iommu_domain *domain,
 					  bool enable)
 {
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
-	struct device_domain_info *info;
 	int ret;
 
 	spin_lock(&dmar_domain->lock);
 	if (dmar_domain->dirty_tracking == enable)
 		goto out_unlock;
 
-	list_for_each_entry(info, &dmar_domain->devices, link) {
-		ret = intel_pasid_setup_dirty_tracking(info->iommu, info->dev,
-						       IOMMU_NO_PASID, enable);
-		if (ret)
-			goto err_unwind;
-	}
+	ret = device_set_dirty_tracking(&dmar_domain->devices, enable);
+	if (ret)
+		goto err_unwind;
 
 	dmar_domain->dirty_tracking = enable;
 out_unlock:
@@ -4890,10 +4905,8 @@ static int intel_iommu_set_dirty_tracking(struct iommu_domain *domain,
 	return 0;
 
 err_unwind:
-	list_for_each_entry(info, &dmar_domain->devices, link)
-		intel_pasid_setup_dirty_tracking(info->iommu, info->dev,
-						 IOMMU_NO_PASID,
-						 dmar_domain->dirty_tracking);
+	device_set_dirty_tracking(&dmar_domain->devices,
+				  dmar_domain->dirty_tracking);
 	spin_unlock(&dmar_domain->lock);
 	return ret;
 }
-- 
2.43.0



