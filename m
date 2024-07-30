Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F3218B495;
	Tue, 30 Jul 2024 17:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359250; cv=none; b=Hd84DRSIs28qMk2qd06r7+wiFSc3Ky0RZduE643fWDfY4CH7+vah9whMIQ/Rb8idGyRAW/Ga8SmnaU/gMxhv5kygSKynE3bKe9l58oeHL4n7VVADEz1PoSKHp9jkQcl5RWN82kVZfYOACB2qBI5iE5Dvi+yTWNBNda/2+mN3OUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359250; c=relaxed/simple;
	bh=q1GgclGHPF5MHEYHRDQMXlD6K7HMKZvoG6G8abfhtdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cmajPuAZW0Ul1sQs2MBJElkoASeUXTFL/xjIqX/oj4sJzyHZRxSPkH7vFg/jq5SooQTA5fn7n0w6YvHOVd6+5ps5Q7r4KNePcxmfavx1iJ9iAQ9XFKzoE+i3cIL0/T6j1CKZQfECrN9eI/cjLaH+VUx2KLqckOpb7BFUPDBDjTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EoLP55Ra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EoLP55Ra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85FCDC4AF0F;
	Tue, 30 Jul 2024 17:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359250;
	bh=q1GgclGHPF5MHEYHRDQMXlD6K7HMKZvoG6G8abfhtdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EoLP55RafryjdTFmy2BGYSMtw9/kYcXZD4VpL8f535Z6Ylb95dHicQd2WFZ4PnL8J
	 TUSNEUMT9POd1LW09CxFiFSnP1lWjMshrZ9ZqM1SoJ0CypPJ/GIR5vXRiM6EFzNave
	 lEJKKKQM/Q91eQCwPOE8JY5ZuwI3OpKr2nK5W5dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 457/809] iommu/vt-d: Fix aligned pages in calculate_psi_aligned_address()
Date: Tue, 30 Jul 2024 17:45:33 +0200
Message-ID: <20240730151742.778879931@linuxfoundation.org>
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

[ Upstream commit 0a3f6b3463014b03f6ad10eacc4d1d9af75d54a1 ]

The helper calculate_psi_aligned_address() is used to convert an arbitrary
range into a size-aligned one.

The aligned_pages variable is calculated from input start and end, but is
not adjusted when the start pfn is not aligned and the mask is adjusted,
which results in an incorrect number of pages returned.

The number of pages is used by qi_flush_piotlb() to flush caches for the
first-stage translation. With the wrong number of pages, the cache is not
synchronized, leading to inconsistencies in some cases.

Fixes: c4d27ffaa8eb ("iommu/vt-d: Add cache tag invalidation helpers")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20240709152643.28109-3-baolu.lu@linux.intel.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/cache.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/intel/cache.c b/drivers/iommu/intel/cache.c
index 0a3bb38a52890..44e92638c0cd1 100644
--- a/drivers/iommu/intel/cache.c
+++ b/drivers/iommu/intel/cache.c
@@ -246,6 +246,7 @@ static unsigned long calculate_psi_aligned_address(unsigned long start,
 		 */
 		shared_bits = ~(pfn ^ end_pfn) & ~bitmask;
 		mask = shared_bits ? __ffs(shared_bits) : MAX_AGAW_PFN_WIDTH;
+		aligned_pages = 1UL << mask;
 	}
 
 	*_pages = aligned_pages;
-- 
2.43.0



