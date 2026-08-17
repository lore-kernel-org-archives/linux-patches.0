Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1792271456;
	Mon, 17 Aug 2026 15:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979538; cv=none; b=ZKJzbEd42vqQwkSJjtdDPGL0sJKuaKrElUkG6uZxRvKwUmG1lWPZbh0BEUp+G/tjarq1Leri82ekYqKZHCJzhVy98b/6h5d6Yqcazi7tPwN8neyCNTcw79T/h83KujjC6Jz48Si1tr2yRiIevZroWYMOxmNh0DFQPiPxZdbjxIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979538; c=relaxed/simple;
	bh=U8rAofqABPWOd+TIuNKLAGs0Gz3eIHHneSuwt/U+KBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b8W9+kpx46w2SLHczrWugQZPbu2qjTGAM376SEpcnd5nxHJOUg19aWXvGOUnJT1N9x0NdJht9HzVO7C4LrvzSPjbnAcxRnTiucT6b92Urp2pV8bqhBDQGqX5gwLbp0/3mP29UHz6a5jMhVQ6x6Badi1aT2mfLx5a/+aucxCr7n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=amVGQym3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="amVGQym3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451431F000E9;
	Mon, 17 Aug 2026 15:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979536;
	bh=mHIpHNv09bzAhjVYLrCfn+tfSqsEyzpuxzV42qc59rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=amVGQym3AiHLLuYfBa2aOrtlRk3NVkNOocCmGqakjgkz6CbGTrx3cOH51oNPbqcg1
	 40wyQgVC291Is/jxyTdSri36O8pzbSI8aFMcv9d+d0tQbF5xggZIRNWumdm+OMsXxb
	 b+9G+qMyxSRZhh3wZWiVFWO+a6evA+R/2/wvInk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 260/609] iommu/vt-d: Disallow SVA if page walk is not coherent
Date: Mon, 17 Aug 2026 15:29:16 +0200
Message-ID: <20260817132552.807776097@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -153,7 +153,7 @@ int intel_svm_finish_prq(struct intel_io
 
 void intel_svm_check(struct intel_iommu *iommu)
 {
-	if (!pasid_supported(iommu))
+	if (!pasid_supported(iommu) || !ecap_smpwc(iommu->ecap))
 		return;
 
 	if (cpu_feature_enabled(X86_FEATURE_GBPAGES) &&


