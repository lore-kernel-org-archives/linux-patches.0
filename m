Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100E4173336;
	Wed,  3 Jul 2024 10:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004018; cv=none; b=KQ9cOx/hZ6YXK3cI/j7/YnrKt6dpuYhQQU8FGJ4QtAdaoqzXX4uBh3DvhltZuhUg65dcfgMZWpvqo/mby86Zw6/tfcJgX+ZeRjU0yuXVHaWycYn5WFUgWrp5i2IwVv2RrLmi/27riMA3HlrkWi0GE/M/oiQO6HhVBoiu9YEs4mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004018; c=relaxed/simple;
	bh=FQsRUDpSFj8n+vvJdxmq971k0rlWufiQ6wgNQXBxuWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDO1AfPCvh0MlVt/wl9zrL9jzT9wkyUnEMviYt3gJD6RNW3B8C63fHyiqPHISuE/iap3Bx+VlMgIsTyWYLiD/5AN2wqqIhXeYqb8FRrN0bGn29ZpW4sILQoYqQb+7fkHzLz8V5eKZ+sv4eiqK4HBE317X7d/j1gCKyii3ISX3i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j7Efgxyn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j7Efgxyn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4603BC2BD10;
	Wed,  3 Jul 2024 10:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004017;
	bh=FQsRUDpSFj8n+vvJdxmq971k0rlWufiQ6wgNQXBxuWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j7EfgxynQ3eENh+Ug/Zrj3Vo6/bNbooYbDRjajkpUJBlWiTvN1qRQtzuK8oKsZcBD
	 3ncRn4cBjlc6G95a23hrmbznKpsvIJb34UthEgJdF6ygOaJDuBIMmMFlwXQl6j7m1i
	 0/d0c5T5MPrge7OezuSs3ajvetoS1Ciz9hYfo/oI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 055/189] iommu: Return right value in iommu_sva_bind_device()
Date: Wed,  3 Jul 2024 12:38:36 +0200
Message-ID: <20240703102843.589811494@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 89e8a2366e3bce584b6c01549d5019c5cda1205e ]

iommu_sva_bind_device() should return either a sva bond handle or an
ERR_PTR value in error cases. Existing drivers (idxd and uacce) only
check the return value with IS_ERR(). This could potentially lead to
a kernel NULL pointer dereference issue if the function returns NULL
instead of an error pointer.

In reality, this doesn't cause any problems because iommu_sva_bind_device()
only returns NULL when the kernel is not configured with CONFIG_IOMMU_SVA.
In this case, iommu_dev_enable_feature(dev, IOMMU_DEV_FEAT_SVA) will
return an error, and the device drivers won't call iommu_sva_bind_device()
at all.

Fixes: 26b25a2b98e4 ("iommu: Bind process address spaces to devices")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Link: https://lore.kernel.org/r/20240528042528.71396-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/iommu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 6ca3fb2873d7d..9246521bd627f 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -1006,7 +1006,7 @@ iommu_aux_get_pasid(struct iommu_domain *domain, struct device *dev)
 static inline struct iommu_sva *
 iommu_sva_bind_device(struct device *dev, struct mm_struct *mm, void *drvdata)
 {
-	return NULL;
+	return ERR_PTR(-ENODEV);
 }
 
 static inline void iommu_sva_unbind_device(struct iommu_sva *handle)
-- 
2.43.0



