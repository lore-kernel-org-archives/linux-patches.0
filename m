Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2924933B6F4;
	Mon, 17 Aug 2026 14:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977095; cv=none; b=qhryCXzDERKp9Lmy78HJzReIY2wXNaPacxB4pilOTe6y6m6rPZskuy9MfIoh/E4ojJ0lHe2VWc+NBIWIdluFDx29VRwQV7Fdkz5SeALDV6MAxvPrct+8zmnvNtjpUuxYRzUsnB6ht8CEpaQMhdFU+gw/eXmxsOZ2eKWGH8BS0nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977095; c=relaxed/simple;
	bh=ycfNw4xzGjNIR0gyWcyG+xFXu7/cATO12b05odGU6EM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gl4zn0xDCwNz16EPcF8wgoBbNmOhsSuRxP1CIeSnE0ZysT77+0BNwpWUWwXeqoDn4yUU6Kph/N71GtJlax+7nqqkrigGin2rUDcELj0PxMJE4naWV88+FBm5Tz5HLgjIGaRd852btdU9tn0fKx7jmYoOTbP1SgLnJoolPH4AWCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g1RK+ukz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g1RK+ukz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C381F000E9;
	Mon, 17 Aug 2026 14:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977094;
	bh=ld86mQjNRc3WEiO4vwLor5hp4PLKN0K+qMXInj5dKUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g1RK+ukz/eLF2RR59CY53d6G9xDgHePtqnvz2qzAebkZewIQSalw8QGTWV5vyUWmC
	 0mU3WPqK7qptGvPL9nIV6t+FPMknr3kzLt59XDs0zQ589X8dNYfT9pxO74pRtGNG5V
	 eMZArFjlscsCK6B1hyYv+KtlJlmC8ePaElXkk6ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 5.15 210/456] iommu/vt-d: Disallow SVA if page walk is not coherent
Date: Mon, 17 Aug 2026 15:30:00 +0200
Message-ID: <20260817132548.374236813@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

From: Lu Baolu <baolu.lu@linux.intel.com>

commit 780dfed688622ea01be3c9c2c55eec2207f05e04 upstream.

Hardware implementations report Scalable-Mode Page-walk Coherency Support
via the SMPWCS field in the extended capability register. If the hardware
does not support page-walk coherency, a clflush is required every time
the page table entries (which are walked by the IOMMU hardware) are
updated.

In the SVA case, page tables are managed by the CPU mm core, not by the
IOMMU driver. Because the IOMMU driver has no way of knowing whether the
CPU page table management code has ensured coherency via clflush, the
driver must deny SVA if the hardware does not support coherent paging.

Fixes: ff3dc6521f78 ("iommu/vt-d: Fix CPU and IOMMU SVM feature matching checks")
Cc: stable@vger.kernel.org
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/svm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -175,7 +175,7 @@ static inline bool intel_svm_capable(str
 
 void intel_svm_check(struct intel_iommu *iommu)
 {
-	if (!pasid_supported(iommu))
+	if (!pasid_supported(iommu) || !ecap_smpwc(iommu->ecap))
 		return;
 
 	if (cpu_feature_enabled(X86_FEATURE_GBPAGES) &&


