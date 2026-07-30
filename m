Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB03332629;
	Thu, 30 Jul 2026 15:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426403; cv=none; b=uZHk6SZUd0zlPHsMROrOjTItBUi4qN1ay7+Y3aBEqPJMt3J15l5DmM1GPGeWUSYcElC7lYO8OqbE5fMNMavNdY9MVjwddK19pniEwgvmWMHWle0flPU4yNfrcq8nv6dKhN40SwKP1bb4hSzUXKiFj92GG4IHgAci/8FxRHX0GU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426403; c=relaxed/simple;
	bh=9iGtxEF3tcXJN3r5Ioujntq8775CzW8qOWzQvBiLygo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tzHE6Bpq3XtqDqqHuMoc04FnOI/3r10WI4YnYCXcpGtQWsmkyvX7XU6tFQ56bH3dJtHE6wbTN4acRcgNwx7oxNQeBCAwRdQBYVXJ8Q5QOmC1dYHbiODezMIuXcYcdsa+dXVu5uGcAMloZZybidiSQTPfpcCs4fOYi6/82YPRJ4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZBfbXwmp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZBfbXwmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F1D1F000E9;
	Thu, 30 Jul 2026 15:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426402;
	bh=snyF4ClrqiuCAyRX+OnRyxCFDmgXhv0i9IKrYJ1ie44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZBfbXwmpU+yZpBSTz38zWIf+fLzf19ODlqexDYOAXFqIZOddXWCKDWjX/3AOlvbpm
	 iK0uZICwmRenvoVKsvJTk85/7zMrO6XHsHbQOjA3yPr+vGovt3DXF6XVtF60FEidfZ
	 fOhKDoMjDfcIYMBQg4rIMpHsE3sO0lQlUgidi0Uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.12 406/602] iommu/vt-d: Disallow SVA if page walk is not coherent
Date: Thu, 30 Jul 2026 16:13:18 +0200
Message-ID: <20260730141444.495909117@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
@@ -27,7 +27,7 @@
 
 void intel_svm_check(struct intel_iommu *iommu)
 {
-	if (!pasid_supported(iommu))
+	if (!pasid_supported(iommu) || !ecap_smpwc(iommu->ecap))
 		return;
 
 	if (cpu_feature_enabled(X86_FEATURE_GBPAGES) &&


