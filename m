Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08561741C4;
	Wed,  3 Jul 2024 11:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005475; cv=none; b=LfyA2FiuElkf1R6cnWPsnoJnmEvD2UczXzzDoJ8BFzKkRhYmEHVSgREjyeU1hIJEtpVC7awKXnQfON7ul7EE3iTYWJ2Y8Xsf0fVWYxyQSZcTH0oxPj78q1pCrCSxi+D3BKC+73pMXVSzDdNO1b5ZIsN9r6EZ8TT5tBt9pqE472w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005475; c=relaxed/simple;
	bh=blAGvcPMcc0KMPmfIA1UCuOuQ61Pxr9HSAS+Y3hvvUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDELC7jdF9dxRhm3u8dayYdGtaaHrCIuc2jsZojyCdD//FnY+WQAKQh9aLHhCII1gOZszdzTyTh4RpaJ+1EdFt1WrPoTp28UY8kugmXPnCrP0xuzgXkrWUvgbPep7dk3CNTdGXBWVNMttErdsOC/h4L7zKwNVnraLB+5h6mNc7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l9IUDYyO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l9IUDYyO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4635FC2BD10;
	Wed,  3 Jul 2024 11:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005475;
	bh=blAGvcPMcc0KMPmfIA1UCuOuQ61Pxr9HSAS+Y3hvvUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l9IUDYyOxg1wzL9v6q8EQT9jTUfrL47+7n3ZVZR+eM9UQSOxi0jDgXzXeV0KjCC5r
	 U97J26PXjnLxbj/I7ByUvycDlYNep6oT+wC3zAhpoAn6v5VqSX1ztIemVXQ4rA3E8z
	 M6uFxMx1FP/oZKXJfXRKJ0+F0ckkGcZ2+TNdr6zs=
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
Subject: [PATCH 5.15 094/356] iommu: Return right value in iommu_sva_bind_device()
Date: Wed,  3 Jul 2024 12:37:10 +0200
Message-ID: <20240703102916.660695579@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d2f3435e7d176..2202a665b0927 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -1038,7 +1038,7 @@ iommu_aux_get_pasid(struct iommu_domain *domain, struct device *dev)
 static inline struct iommu_sva *
 iommu_sva_bind_device(struct device *dev, struct mm_struct *mm, void *drvdata)
 {
-	return NULL;
+	return ERR_PTR(-ENODEV);
 }
 
 static inline void iommu_sva_unbind_device(struct iommu_sva *handle)
-- 
2.43.0



