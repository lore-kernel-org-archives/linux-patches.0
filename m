Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C1947ACD7;
	Thu, 20 Aug 2026 16:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243301; cv=none; b=cyBJPZaAU2G+3KH5OzEjDk4mCRmMqrwwebx69hduzj0TwMWKtSXLmYt49IlSZj5nsor4KMJDoZk1gmy4FUYApV/dhzDUwOyna4jtarpkZZYFndnbFIy1lCXrFCfgg1uMbo2Em3rGSzuc9Xw3NCobmAMxf1q8u9wM4Hq6jWRwfko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243301; c=relaxed/simple;
	bh=rduTiLR8dQJeQyyRhGAQHf8h3ouHS1MeWk7YCv9DXuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0hvn34gKoGtbAFFkYKLYzPexA9wKBLrRR3ADGCUVMdzy5Ia7bWBJrvKiFj/ewYcCWAKmK/XFfoVndncLJS9qgs6mqh26V2qN5pMv+Z3Ng0+LsOYUmPVotuXq6PNIotHF6W9+oCDkdSwyxTHxzHCjvOHEx7DmPEj7eQftsmw8vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TY4rdHH4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TY4rdHH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6531F000E9;
	Thu, 20 Aug 2026 16:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243300;
	bh=GLyjanNRdaXMlWCfmId7ehhipjANhNSY0Jgz//LbPCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TY4rdHH4/2BGRD3c3zGIOb71kAXKi2sEmn3PF+eFuW/rK3FWP1YYA1YTTMxNNHwMD
	 ozP1sDVUo+JKcfT8I2vlznHGStiS90w/dXXhJXa0GAVHm2lt3wOoP8mJxIs/AX3aQd
	 eeAdy+4pG/d1lO4yOCz92TfvriEX4HW53IS8MSCw=
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
Subject: [PATCH 5.15 048/272] iommu/amd: Dont split flush for amd_iommu_domain_flush_all()
Date: Thu, 20 Aug 2026 16:53:52 +0200
Message-ID: <20260820145232.664880667@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1284,7 +1284,8 @@ static void __domain_flush_pages(struct
 static void domain_flush_pages(struct protection_domain *domain,
 			       u64 address, size_t size, int pde)
 {
-	if (likely(!amd_iommu_np_cache)) {
+	if (likely(!amd_iommu_np_cache) ||
+		size >= (1ULL<<52)) {
 		__domain_flush_pages(domain, address, size, pde);
 		return;
 	}


