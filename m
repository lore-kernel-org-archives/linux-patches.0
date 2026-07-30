Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6D644D6AB;
	Thu, 30 Jul 2026 16:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427994; cv=none; b=bGlyB13fH6Z8r0NaekmWH5a3R4ziACK6+5BB5/Uf5dPy/EfVLue35nKXZiISsh7eb7K/ePbaHxGdtrj2Ql/1ulbfEsgD9HQAmk9ASj9g8tlyObIhqADDfyE76n2BsLI6BSddO8FdzHF1VQFoLom++Po+qnGdNUSF4/O2yYzb12E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427994; c=relaxed/simple;
	bh=iHSC6LbGiPfaJMC2GeRrg8NfigTlRafXD8tLyeQCIAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ciMdV1Jbh6mEgFTlQh+n3El4BdemyKQzEo5wJYO1WCToj51kc2x4tuGMh+GSDa4b5kKZd+qweoQfjqrxQ9/au7/3sf/YOMiyvqm226WUNEVfdiE9Dl767sCriBjIjPQUlF+is8jF2tx+L8AwMl62IEtXx24tTBaQmm4sEOA45b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JSICKJyT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JSICKJyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2341F000E9;
	Thu, 30 Jul 2026 16:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427993;
	bh=7eDIhs5gW625NQh5fcg+xCR1KqWvADyCqIVr6QQtqrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JSICKJyTlArJonHztQr7iDyzDPf2k1ly2Yi0IwPEhvY1cDfCi1G359LrUkzVNrQh7
	 gca9Q5tRhCjwgwUW896aK1kRh9ShbMFfzmMOQzF5OiNaXEXmAu3lha5URTq7rqJOv7
	 0HNSL0lFr9I0PzOZvvxD/XiIIkCTAhIA2/U+5/I0=
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
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 364/484] iommu/amd: Dont split flush for amd_iommu_domain_flush_all()
Date: Thu, 30 Jul 2026 16:14:21 +0200
Message-ID: <20260730141431.381741320@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Weinan Liu <wnliu@google.com>

[ Upstream commit 69fe699afe1afcb730164b86c228483c2da05f94 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/iommu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1441,7 +1441,8 @@ static void __domain_flush_pages(struct
 static void domain_flush_pages(struct protection_domain *domain,
 			       u64 address, size_t size, int pde)
 {
-	if (likely(!amd_iommu_np_cache)) {
+	if (likely(!amd_iommu_np_cache) ||
+		size >= (1ULL<<52)) {
 		__domain_flush_pages(domain, address, size, pde);
 		return;
 	}


