Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9364499BB;
	Thu, 30 Jul 2026 16:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427855; cv=none; b=G3B/n6ZcdLREEKThXgzsWQDJMwGqobBYc7Ma1CRHMPW2dk2CLbgYVLSrZrF3OIEhzxRYDqbFTye0qNJybroCi4J7sxSbjSOTD2JhB0QJogCYhgEE9dzygVSsLvffMNK65QM83JsPD6Ek8kCq8gdqc2x69VJBkaB9voBPn7l3uB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427855; c=relaxed/simple;
	bh=/7fdyM6WaVlN2lat8mnz55WrEjuFtUN95xjBA6bBvCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ntOZR+87Th3vBJg8Tqb6Et4QZUELn4nZ5nBJ77tI6O1j0+zqxeHYZ7pwKkQW/PiPDY/aD7astTfV58F2LKj5PZv32Le6QaJIoX8TkRmeeopYG5Z77LW2jLuyx+wMlN0Runy/0TpwE32P3SVBuNJAN2+s6vi0N1RhVM1lKthI2n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=09zooP9n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="09zooP9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41A31F000E9;
	Thu, 30 Jul 2026 16:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427854;
	bh=4UDQO0HOvQFVvFf1Ytpd2Y38wpWCYyoStdJ4ca51HDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=09zooP9nkx8C9Rrq5QkaZmv/ZE4w2i/UgkhZTYOHy1oz4ttkRDPV9+M9NDtw7FYF7
	 sRFq7VfXB0qfL1ZnP/HRPm65h8+k3jqbla9zjFZfscpt553NEMvwz66NU0f5nh5jML
	 4Oo45C6rDPOggRnd+gqKyXFoafT/tfLz4k7rV9Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.6 315/484] iommu/vt-d: Disallow SVA if page walk is not coherent
Date: Thu, 30 Jul 2026 16:13:32 +0200
Message-ID: <20260730141430.329798552@linuxfoundation.org>
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
@@ -149,7 +149,7 @@ int intel_svm_finish_prq(struct intel_io
 
 void intel_svm_check(struct intel_iommu *iommu)
 {
-	if (!pasid_supported(iommu))
+	if (!pasid_supported(iommu) || !ecap_smpwc(iommu->ecap))
 		return;
 
 	if (cpu_feature_enabled(X86_FEATURE_GBPAGES) &&


