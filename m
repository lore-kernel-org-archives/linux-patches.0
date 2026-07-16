Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213D931D381;
	Thu, 16 Jul 2026 14:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211387; cv=none; b=d9e/xR0HTEDk2VNzHzzeiQ5kveHQJyUfmwkuZDfzRgnpLLYvhVApapOLvJ2fPpKT8lHdswY4I7qsC9VcS1yoAQN/8274UsBzwFVHntB9dLly78u12Fsi5fPsy2zYmlmaYvhDKzGOAbbbXFAV7GWoLWKlIQILB9ChqVwiDIn/cd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211387; c=relaxed/simple;
	bh=6a9k8mRDj/+oQr0PB9yQFaDaRUdjnP6IulrdH1Cy/xM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IGeiFycsbDRWjrrDfpZZTflrZFC7/akZQRZRn0WJHZx83uIRDxDo6PATE9Lo8q4Md5/2b+N8ozoWpDuA78MdpHXZnhJKKHV2swbbpSOsnvDwqCnJ4aybSzsEkwLKkTv6Pb/Xjin7t4sGdfaLBHVgrTp9YEs0nq6id9Y6DxWevYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X1z1r5Ld; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X1z1r5Ld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3798A1F00A3A;
	Thu, 16 Jul 2026 14:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211385;
	bh=j83Is8w/spco17VRx+uJzsVCg0ik5KiABXw3AjjNYeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X1z1r5LdC0vCCFyDKjCeSwEFRU+mrYAgrOOx15w2aKFjJy0VwLMdspOtXcTcYMQYE
	 V0f1Zw5zUm3W2C8YGP1MrGxD8tHDzgUkXl+oLHZhhBj58M8ydflJIugnbuvA82ul06
	 EyiX4z6SsuUSvf1QQlNSV+6lCOoYqrGwReEgEMTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Weinan Liu <wnliu@google.com>,
	Wei Wang <wei.w.wang@hotmail.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.18 407/480] iommu/amd: Dont split flush for amd_iommu_domain_flush_all()
Date: Thu, 16 Jul 2026 15:32:34 +0200
Message-ID: <20260716133053.616187940@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Weinan Liu <wnliu@google.com>

commit 69fe699afe1afcb730164b86c228483c2da05f94 upstream.

We have observed multiple full invalidations occurring during device
detach when we are done using the vfio-device.

blocked_domain_attach_device()
  -> detach_device()
    -> amd_iommu_domain_flush_all()
      -> amd_iommu_domain_flush_pages(..., CMD_INV_IOMMU_ALL_PAGES_ADDRESS)

      	while (size != 0) {

          -> __domain_flush_pages( flush_size /* power of 2 flush_size */)
            -> domain_flush_pages_v1()
              -> build_inv_iommu_pages()
                -> build_inv_address()

         }

build_inv_address() will trigger a full invalidation  if the chunk
size > (1 << 51). Consequently, the guest will issue multiple full
invalidations for a single call to  amd_iommu_domain_flush_all()

Without this patch, we will see 10 time instead of 1 time full
invalidations for every amd_iommu_domain_flush_all().

Cc: stable@vger.kernel.org
Fixes: a270be1b3fdf ("iommu/amd: Use only natural aligned flushes in a VM")
Suggested-by: Josef Bacik <josef@toxicpanda.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Weinan Liu <wnliu@google.com>
Reviewed-by: Wei Wang <wei.w.wang@hotmail.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/iommu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1689,7 +1689,8 @@ void amd_iommu_domain_flush_pages(struct
 {
 	lockdep_assert_held(&domain->lock);
 
-	if (likely(!amd_iommu_np_cache)) {
+	if (likely(!amd_iommu_np_cache) ||
+		size >= (1ULL<<52)) {
 		__domain_flush_pages(domain, address, size);
 
 		/* Wait until IOMMU TLB and all device IOTLB flushes are complete */


