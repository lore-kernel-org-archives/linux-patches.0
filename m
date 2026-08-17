Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0FD303C97;
	Mon, 17 Aug 2026 14:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975842; cv=none; b=LlhbQZ/z4pAR3LrKzXySG4s1WVWuXXVty7ISlV+aJ8iTWDtaBDFkHsariIcMNUK7F70GEfRHNpn8Kf8LMqftNp+CM61IDE6s+uHWRNhe5LLFLsbZQC9liNZXvpmA+nBGsKf37SbbMkVd+r5TkxEnJPhdrO6ZCTa4rsEA4gSJunI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975842; c=relaxed/simple;
	bh=v+HYmy72dAZTfPVrW4iaVRnMswS9Y2RchKrD9nBuUtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjuxGZY2qbSYjW/cE5rZXOb7TWt1aH+phZqjEyjosZA5yx/Yir2CQutpnp/aBnQm8k/EU3omoPDwMWxZyNb6TxdSJuEYSMo1I//FmWHACGtPX7Jq6YjldDUTOQy0s5oaXTmVoqx7IQZbiKlnQv2TluE0OO4vOlm0G3ey6aon3OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tb+P6uPO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tb+P6uPO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8441F000E9;
	Mon, 17 Aug 2026 14:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975841;
	bh=9Gh1FxyKjL6boUND48mPp7q4LAXh5QAOSzn2wBHnxT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tb+P6uPOfHDVmhbCLD+/6xY3/hSJarRlfJXF1t55g8ZZKMemORrGn3lQL823EIZcR
	 y3bSsb82bT+rdaVOns0lpEL353h24cU1LcwQ4egIV3e7HKDo8vwkWpswsMGzdO7E1Q
	 c9iwyeGWD8zN76MCaLpy7lEn999P/DE5kLHxAsQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 5.10 168/389] iommu/vt-d: Disallow SVA if page walk is not coherent
Date: Mon, 17 Aug 2026 15:30:07 +0200
Message-ID: <20260817132545.732121650@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -98,7 +98,7 @@ static inline bool intel_svm_capable(str
 
 void intel_svm_check(struct intel_iommu *iommu)
 {
-	if (!pasid_supported(iommu))
+	if (!pasid_supported(iommu) || !ecap_smpwc(iommu->ecap))
 		return;
 
 	if (cpu_feature_enabled(X86_FEATURE_GBPAGES) &&


