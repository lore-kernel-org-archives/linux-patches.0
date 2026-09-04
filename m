Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F55E412BE7;
	Fri,  4 Sep 2026 05:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501436; cv=none; b=AiMDSZ+XgQ4dsVMdBWf4fNvR8OI7zxPD0yRp7f4TeImxmZb4NKZrDBT+Rv4Ky6HtpYlSm9Qrpm9hzbyti9QUTkAtC1LQYUOqdT1GFJGsOzND6WLGEZjr2AgXU0xZa/acjQOzAqY2t8txqh5tS6x9pu/WUf0Z6tQwV351bi+wBXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501436; c=relaxed/simple;
	bh=evntsyDps8KY1Ij9ZQ5FJ1fkM9npf5DZGFlxLSlqoxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkq0Vdwdix5r1VntVt90WB5LCWFBWZQQggVzYrgTk73JDYP5g81TFOGyE2IFvuDJggDR7Jgmn2vSfvM9sVUKdSIS9wl58OkXSNwFrHf8qBbehy79g71tQhQOJAnBgDkeCpI1RwGN71ydYFpkO9AGJfaAG7kl+wYvs5Nr5L2Nrtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=01vFt2M/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="01vFt2M/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050381F00A3D;
	Fri,  4 Sep 2026 05:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501435;
	bh=EAOQsvhI8zp4j9jIg9uo3W9kHfpmlsBJEBM09gcoyXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=01vFt2M/gKESf37IhUjFPwYA1+aCrIp5oqVw4xI9VEGFQhi2jlI7O8T8gL8mhr8z6
	 bjA/+Dx2hmEpIF61s3mM8iuW+HSXnYjSWL1boiVmuQV92TM7jEjXWT5ZX4Z2Fi8Az3
	 ySUo9k4QRHRxQVPs3hIVrqzv//+a8rJ/M4s4PEX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.18 410/552] iommufd: Avoid locking internal accesses during unmap
Date: Fri,  4 Sep 2026 06:59:27 +0200
Message-ID: <20260904045759.915006195@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuai Xue <xueshuai@linux.alibaba.com>

commit 0dbcdf4473a614adbd732d567c9b39ac0e040e0c upstream.

iommufd_access_notify_unmap() skips internal accesses because they do
not have an external unmap callback to invoke.

However, the current test calls iommufd_lock_obj() before checking
whether the access is internal. If iommufd_lock_obj() succeeds, the loop
then sees the internal access and continues, bypassing the matching
iommufd_put_object() used by the normal unmap path. This leaks the
object reference taken by iommufd_lock_obj().

Check for internal accesses first so skipped entries are never locked.

Fixes: 27b77ea5feaa ("iommufd/access: Bypass access->ops->unmap for internal use")
Cc: stable@vger.kernel.org
Assisted-by: Qoder:Qwen-3.8-MAX-Preview
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 170a7005f0bc..e4537db724d5 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -1307,8 +1307,8 @@ void iommufd_access_notify_unmap(struct io_pagetable *iopt, unsigned long iova,
 
 	xa_lock(&ioas->iopt.access_list);
 	xa_for_each(&ioas->iopt.access_list, index, access) {
-		if (!iommufd_lock_obj(&access->obj) ||
-		    iommufd_access_is_internal(access))
+		if (iommufd_access_is_internal(access) ||
+		    !iommufd_lock_obj(&access->obj))
 			continue;
 		xa_unlock(&ioas->iopt.access_list);
 
-- 
2.55.0



