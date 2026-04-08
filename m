Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9985432692B;
	Wed,  8 Apr 2026 19:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775675010; cv=none; b=jRBnXnFfw/+aZhE4xFtfyNTKolrhP65u9PXYYYCq6KD2jaU34v+KPMXgM0A+ImDWgXuVswCNQTORXel4OI+E/GeZYgQUBhyqqToR94AICTRwfAQQWW1YVpBKYy0hYKSJDksuwUBkm+vl7pUN+mECVLgkuJ2Rrr7B1axHVFvUzJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775675010; c=relaxed/simple;
	bh=o1xlz7N++Crd6aWIXkib9iqSXgmAHcUM9KuLTRVs9wY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DfRxYWdgGPPWsnUPJEJMMODMRDAHing6kRertnbaqCAsuCCBvWNi8vi99RU9It+z+7YkSxoRMnzeG0yFPoYimXcRjcN3obqywjxuvtmwIpXcAkfBcM0aVHGZ4Eh66wwrn/C7pF0PM4FRHThfy13qr7GX8RgUFX4eUtZr+AngpLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dg+Pr6XJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dg+Pr6XJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E24C19421;
	Wed,  8 Apr 2026 19:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775675010;
	bh=o1xlz7N++Crd6aWIXkib9iqSXgmAHcUM9KuLTRVs9wY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dg+Pr6XJOQPdEPhyLeO6XVMPdkw8FSkxhK52vB3X8pCCSAslsPv9dFqYMnrAaC5IU
	 wRqGsgm5cMuQeOmd33bzrPb8My6fDuLNWyNQz8Som4sHxesPMxG22+wi6YrmTgCc/L
	 idjefoON1Aq3sZ/qqBeVuo0UzXYxlcPTznvu/wUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.19 278/311] iommupt: Fix short gather if the unmap goes into a large mapping
Date: Wed,  8 Apr 2026 20:04:38 +0200
Message-ID: <20260408175949.760110605@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

commit ee6e69d032550687a3422504bfca3f834c7b5061 upstream.

unmap has the odd behavior that it can unmap more than requested if the
ending point lands within the middle of a large or contiguous IOPTE.

In this case the gather should flush everything unmapped which can be
larger than what was requested to be unmapped. The gather was only
flushing the range requested to be unmapped, not extending to the extra
range, resulting in a short invalidation if the caller hits this special
condition.

This was found by the new invalidation/gather test I am adding in
preparation for ARMv8. Claude deduced the root cause.

As far as I remember nothing relies on unmapping a large entry, so this is
likely not a triggerable bug.

Cc: stable@vger.kernel.org
Fixes: 7c53f4238aa8 ("iommupt: Add unmap_pages op")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/generic_pt/iommu_pt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 3e33fe64feab..7e7a6e7abdee 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -1057,7 +1057,7 @@ size_t DOMAIN_NS(unmap_pages)(struct iommu_domain *domain, unsigned long iova,
 
 	pt_walk_range(&range, __unmap_range, &unmap);
 
-	gather_range_pages(iotlb_gather, iommu_table, iova, len,
+	gather_range_pages(iotlb_gather, iommu_table, iova, unmap.unmapped,
 			   &unmap.free_list);
 
 	return unmap.unmapped;
-- 
2.53.0



