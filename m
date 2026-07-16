Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3352F22301;
	Thu, 16 Jul 2026 13:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210089; cv=none; b=L+x6cgIGhL05bmfon4bk88yblIE9DbTURkYTS0I7v7cREJ6jCGY3pmvZw6GYGlvjGwh3A5J5o7K2e/FGveFoSFYW9xRFAqfyfnceXZsvorPxU8h5pSpjYxb823MfA1qhR42af5r6xUHhzumVeTWWwVmM68+CBogSVHyhEk814wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210089; c=relaxed/simple;
	bh=N8Ryppdf2sUFgC5wmPWdRJcdI2c7gH5k+FgyEejceaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDrRMdpVRMHe/bJw/YGVOqc19fgWEG36gU0kQqngQ7/PPKaW3e0nYLPb5ywkajwOrLtQBkwPE16FFqWoc7xLeIwKgTOp3cC7Iv2SRBWTw2NwkRFypDMfyES+JpVS0HR9hg9E/uF7s90HBe/sYOu/zCsT90nKoqZS3CoOVDZoVwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1de1xq7z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1de1xq7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712071F000E9;
	Thu, 16 Jul 2026 13:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210087;
	bh=Ipu7B+ZVZ1Lw425KiRCN4XcYQ7NgFjJLWV2ByCGOmoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1de1xq7zN4IkRGImlQkizdUCUh2BxU2NxGFg2QHS9n7bV+g0fxTGXfoucsb0oqQXC
	 1Vd4/m7gKoUrEw9wiWNfW+tKHmWqL98GK+etRlXSV1Pb4tIwQrDIiETe9cGXtHbRvO
	 lX+d/zLiA8Nbjcj6d02qx92iBtFlYaQPdjklY+9M=
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
Subject: [PATCH 7.1 432/518] iommu/amd: Dont split flush for amd_iommu_domain_flush_all()
Date: Thu, 16 Jul 2026 15:31:40 +0200
Message-ID: <20260716133057.294834336@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1774,7 +1774,8 @@ void amd_iommu_domain_flush_pages(struct
 {
 	lockdep_assert_held(&domain->lock);
 
-	if (likely(!amd_iommu_np_cache)) {
+	if (likely(!amd_iommu_np_cache) ||
+		size >= (1ULL<<52)) {
 		__domain_flush_pages(domain, address, size);
 
 		/* Wait until IOMMU TLB and all device IOTLB flushes are complete */


