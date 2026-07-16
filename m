Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0A73CC9E8;
	Thu, 16 Jul 2026 14:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212412; cv=none; b=t9/GiV/RiTsTWllt8S2XxaNS0gSa1Lnryyl/vAbgR3y76Izo1LMImVc6lYX7DkU6pUGD4SFBMdxsxZZ1aF2aI+ohwP15h+Y2zP3nyazj3UajuuatKwmZ+yB7lqr1Km8+5atjTZt7euoLR7SrUoYzDbhsrAn2IPdxaEKxgDXQrro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212412; c=relaxed/simple;
	bh=Pno6lJtAuQa+790X41hnj/eMKWa4zUjv0Q8mEH0i9dI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYGovrCEzKnWRDibYgy4r/qfX70lOIQANLGYXUWEkPSvgZnQnEo6Vd/bTFF+PUXLJwxvY4a4Wk6GC3tamETnSA55GwccowIKS5vwnkZehCO1ynYJvVMAJCXSW8PxdmfBa4QWfWcfrxp7wcMC7QKrT04M3AIojuLCi4B+Rs5ELAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fj2mMcy1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fj2mMcy1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326E21F000E9;
	Thu, 16 Jul 2026 14:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212410;
	bh=7u8rSh8F9v2esazYyNZoJiyS+K4cFKSc8TbfamHDCcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fj2mMcy1gsPSon18uiG3ayM7+TMpoTq7Q+drVv4JOYeJ2FaXBQc4fMnYcfbpjuA8B
	 L9VNaE8tXJIJLFmYfLpB71Vt9vDr4U+dKqOqlxFvw94j0ZLR33MdOvt00WmdyUTbtj
	 9fhQlKpAF9ACbf+8fW7I4QKTN5QSImK52ssDBWGo=
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
Subject: [PATCH 6.12 316/349] iommu/amd: Dont split flush for amd_iommu_domain_flush_all()
Date: Thu, 16 Jul 2026 15:34:10 +0200
Message-ID: <20260716133040.389804312@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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
@@ -1702,7 +1702,8 @@ void amd_iommu_domain_flush_pages(struct
 {
 	lockdep_assert_held(&domain->lock);
 
-	if (likely(!amd_iommu_np_cache)) {
+	if (likely(!amd_iommu_np_cache) ||
+		size >= (1ULL<<52)) {
 		__domain_flush_pages(domain, address, size);
 
 		/* Wait until IOMMU TLB and all device IOTLB flushes are complete */


