Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1239C31B828;
	Sat, 17 Oct 2026 18:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260537; cv=none; b=CXl226F9n02vJNZ+HaXxtf1uzecrj+ubUrO2eDF3B3F5Egzfrj+J7jPSBgiVVFgy+/nLT4hTOm6cuP4iPy4AELlBx+dMsDA58/BrziW4OOtqlDmDh/K19AvzMjuGw70OWZHy+8P3WAYtqSjsHLLYndU/vPu0aplAHHkDFW/gTEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260537; c=relaxed/simple;
	bh=JPKtgsyj0Rt6cnQNcmONmGD6bNRZKOuFXD3NNWb+jbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JY0YM9+6mUeQOYnru2EkjnIs8mDZ8QESQVMydmpmrwTh2ETxbJhblWp9uwUKt++BRXNvEjUMQl5LWnw9fB3gb6mLtet5R9S4O73tgrJr3bTwW5HLZqNOjSO6vkTymctdTMSPWmIbZXprbU23J8qlPIrPJIA1bOQRmW4F6o13S80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aRCzH+gP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aRCzH+gP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680AA1F000C4;
	Sat, 17 Oct 2026 18:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260536;
	bh=gDAFlukj87k48y/BVgfEivauJaH6B9Q0bokYuRjQewQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aRCzH+gPefd0Yn2uifjreBbRJ0fe5XbTXR/xf3eOrRXIGRXqSxuU9J3PQezG2H1Xq
	 E9GC5H0U8DJ1VMMtLu52PJyiApoxEMlshu5KfcUqxe7kw0OVaJaFBWluFs/Jvj2bra
	 NeT8Vm7vYzRdzrvwss9HoG38S6CB+JUfMvecL3nQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1576/1674] iommu/sva: Set handle->dev before the SVA handle is visible
Date: Sat, 17 Oct 2026 18:04:08 +0200
Message-ID: <20261017160511.548569633@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuai Xue <xueshuai@linux.alibaba.com>

[ Upstream commit 530f8f9c3546cb3ebee1b135375aaee08a073ebb ]

iommu_attach_device_pasid() installs the new SVA attach handle in the
group PASID lookup before iommu_sva_bind_device() returns. A concurrent
bind can therefore find and reuse the same handle after iommu_sva_lock is
dropped.

handle->dev was initialized after dropping iommu_sva_lock. This leaves a
window where a racing bind can return a handle whose dev pointer is still
NULL. A subsequent iommu_sva_unbind_device() can then dereference it via
handle->dev->iommu_group.

Initialize handle->dev before releasing iommu_sva_lock so any visible SVA
handle is fully initialized.

Fixes: be51b1d6bbff ("iommu/sva: Refactoring iommu_sva_bind/unbind_device()")
Cc: stable@vger.kernel.org
Assisted-by: Qoder:Qwen-3.8-MAX-Preview
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu-sva.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
index a340b805b82b7..efe491deaf61f 100644
--- a/drivers/iommu/iommu-sva.c
+++ b/drivers/iommu/iommu-sva.c
@@ -100,10 +100,9 @@ struct iommu_sva *iommu_sva_bind_device(struct device *dev, struct mm_struct *mm
 		goto out_free_domain;
 	domain->users = 1;
 out:
-	mutex_unlock(&iommu_sva_lock);
 	handle->dev = dev;
 	handle->domain = domain;
-
+	mutex_unlock(&iommu_sva_lock);
 	return handle;
 
 out_free_domain:
-- 
2.53.0



