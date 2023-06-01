Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D8AFBE8
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7165DC4339B;
	Thu,  1 Jun 2023 13:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685626080;
	bh=aIRWzSgdRmLNSwJ8rLV2x/VY9GBq7Je7dQpOWb89LHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rt/YXvsZqT+E03IPJkoL/0D4Tavqbi7lWax4g8pD5L/g3g/TufkkDqbZVqW7HiJj+
	 yU1QfxQcf2Ek3bj0IiE8kYZy9WOFfwGq3es3lbPY982g2+DylVQpURFmX+wOqVl2Fr
	 XPb73O/7t5XClyVCqqKKoExm0ySjNH+ewbvCd8GU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 23/42] vfio/type1: check pfn valid before converting to struct page
Date: Thu,  1 Jun 2023 14:21:32 +0100
Message-Id: <20230601131940.062697128@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131939.051934720@linuxfoundation.org>
References: <20230601131939.051934720@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yan Zhao <yan.y.zhao@intel.com>

[ Upstream commit 4752354af71043e6fd72ef5490ed6da39e6cab4a ]

Check physical PFN is valid before converting the PFN to a struct page
pointer to be returned to caller of vfio_pin_pages().

vfio_pin_pages() pins user pages with contiguous IOVA.
If the IOVA of a user page to be pinned belongs to vma of vm_flags
VM_PFNMAP, pin_user_pages_remote() will return -EFAULT without returning
struct page address for this PFN. This is because usually this kind of PFN
(e.g. MMIO PFN) has no valid struct page address associated.
Upon this error, vaddr_get_pfns() will obtain the physical PFN directly.

While previously vfio_pin_pages() returns to caller PFN arrays directly,
after commit
34a255e67615 ("vfio: Replace phys_pfn with pages for vfio_pin_pages()"),
PFNs will be converted to "struct page *" unconditionally and therefore
the returned "struct page *" array may contain invalid struct page
addresses.

Given current in-tree users of vfio_pin_pages() only expect "struct page *
returned, check PFN validity and return -EINVAL to let the caller be
aware of IOVAs to be pinned containing PFN not able to be returned in
"struct page *" array. So that, the caller will not consume the returned
pointer (e.g. test PageReserved()) and avoid error like "supervisor read
access in kernel mode".

Fixes: 34a255e67615 ("vfio: Replace phys_pfn with pages for vfio_pin_pages()")
Cc: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/20230519065843.10653-1-yan.y.zhao@intel.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio_iommu_type1.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 7fa68dc4e938a..009ba186652ac 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -936,6 +936,11 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 		if (ret)
 			goto pin_unwind;
 
+		if (!pfn_valid(phys_pfn)) {
+			ret = -EINVAL;
+			goto pin_unwind;
+		}
+
 		ret = vfio_add_to_pfn_list(dma, iova, phys_pfn);
 		if (ret) {
 			if (put_pfn(phys_pfn, dma->prot) && do_accounting)
-- 
2.39.2



