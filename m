Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7690A13AA40;
	Wed, 19 Jun 2024 13:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802243; cv=none; b=s7qRbY+5cVOl3YdDTFzkhHoJOkMjs683lIavLJQ4OMxXazfoZ2mmxhlxa3Bdk4Tcb/dg4wYYRQYi+GR+4sMl9J/ZV3KDCqtei/+TFg85PNa/jsCxemMVhitkfFlLkdy8pw2WolVAAmyI7LgI8IfE3CSL9PVPy4+wnGIXf0FZlJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802243; c=relaxed/simple;
	bh=ZF3Vx7UBM/0DkLPn/Ml+tD9orP250VGBMrKb0xUjAvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GK0A3JwEyp/+KhYmtrtkAbxVZpGlX8/8W6rgXCGFRxVBP8C99oAMwD4L00fxW6JqF48gVfKCpUp1wZCpWC+qmTHXKW8G76gHXpTAFkVVMnbGwOdFrwaXcmf1SM/+zv7q5nfpK357ChBeQrcFf+cMkjUU5UWHjUuG6EzvCcZo5N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1M1rPGa3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1M1rPGa3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED33BC2BBFC;
	Wed, 19 Jun 2024 13:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802243;
	bh=ZF3Vx7UBM/0DkLPn/Ml+tD9orP250VGBMrKb0xUjAvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1M1rPGa34w6EQ/kp0Om9H40tKxwLdcEt0AtBVJFriUnWWuI7jDjMoUm+m9f8q6ABG
	 2mQ0sYxESvqwwr3TL8HOYPIbhYOJ+fKaJJkhdFP45II1kx6JncFjHEZ+qYWtIfR5/t
	 9hXKBdCmNJ4aTnIAL+a50h2d9/nLvv3GrElntxaw=
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
Subject: [PATCH 6.6 131/267] iommu: Return right value in iommu_sva_bind_device()
Date: Wed, 19 Jun 2024 14:54:42 +0200
Message-ID: <20240619125611.379185011@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0225cf7445de2..b6ef263e85c06 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -1199,7 +1199,7 @@ u32 iommu_sva_get_pasid(struct iommu_sva *handle);
 static inline struct iommu_sva *
 iommu_sva_bind_device(struct device *dev, struct mm_struct *mm)
 {
-	return NULL;
+	return ERR_PTR(-ENODEV);
 }
 
 static inline void iommu_sva_unbind_device(struct iommu_sva *handle)
-- 
2.43.0



