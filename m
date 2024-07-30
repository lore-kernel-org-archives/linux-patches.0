Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FE818B466;
	Tue, 30 Jul 2024 17:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359243; cv=none; b=jK+cMVsJH1P31WZHb0njp7fwF5YWdAXWfMxu70q4FWAs2XaSaGyN3wdmfQ92smR/bp9+ZLK//JsG9tykI+smwFzzAgm8OAVhtBACu9Zd0OVhEGZJfNF1QEwjSEjthdIjVa5XVPkrIIj11JQKnYKyuM7XsFn0Xc1IIYXnv1FsNKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359243; c=relaxed/simple;
	bh=+8IBsdfCXLWlhSnjp/AI8dIitIwLJPW84xxxpzu25so=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=StMzER768XT40hdh9d2YbmV0ZqmEsT+orTvI/zNcptdcSAyqTjhGK7Pd6a1pSedkNNlCCTBytXCtbuPouWbh2NrvN5HfgIYXigze1jG3PKb8CvEmf7fM2U2ad9rwNeTVbEFi2qtWyb3K2UZJoCB49qYw57lllHMt9jjoFDW4Tes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W1udu94B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W1udu94B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912FCC32782;
	Tue, 30 Jul 2024 17:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359243;
	bh=+8IBsdfCXLWlhSnjp/AI8dIitIwLJPW84xxxpzu25so=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W1udu94BrDcSOOdHpz4iGVLmv6J5BxNGVGXq9zSWpOgO1hFHhLLG1wyWVNk34vfsj
	 bUL8Khtk8bGCtalDsCyhOvk+QkOStioHWE57Pky4DVpWCMZaOVF8kqb0ZAFntnye4S
	 ABL9o71VaseCThnySbbjlG13cbNzEqe5J+BhofLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 456/809] iommu/vt-d: Limit max address mask to MAX_AGAW_PFN_WIDTH
Date: Tue, 30 Jul 2024 17:45:32 +0200
Message-ID: <20240730151742.739940613@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit c420a2b4e8be06f16f3305472bd25a1dd12059ec ]

Address mask specifies the number of low order bits of the address field
that must be masked for the invalidation operation.

Since address bits masked start from bit 12, the max address mask should
be MAX_AGAW_PFN_WIDTH, as defined in Table 19 ("Invalidate Descriptor
Address Mask Encodings") of the spec.

Limit the max address mask returned from calculate_psi_aligned_address()
to MAX_AGAW_PFN_WIDTH to prevent potential integer overflow in the
following code:

qi_flush_dev_iotlb():
    ...
    addr |= (1ULL << (VTD_PAGE_SHIFT + mask - 1)) - 1;
    ...

Fixes: c4d27ffaa8eb ("iommu/vt-d: Add cache tag invalidation helpers")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20240709152643.28109-2-baolu.lu@linux.intel.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/cache.c b/drivers/iommu/intel/cache.c
index e8418cdd8331b..0a3bb38a52890 100644
--- a/drivers/iommu/intel/cache.c
+++ b/drivers/iommu/intel/cache.c
@@ -245,7 +245,7 @@ static unsigned long calculate_psi_aligned_address(unsigned long start,
 		 * shared_bits are all equal in both pfn and end_pfn.
 		 */
 		shared_bits = ~(pfn ^ end_pfn) & ~bitmask;
-		mask = shared_bits ? __ffs(shared_bits) : BITS_PER_LONG;
+		mask = shared_bits ? __ffs(shared_bits) : MAX_AGAW_PFN_WIDTH;
 	}
 
 	*_pages = aligned_pages;
-- 
2.43.0



