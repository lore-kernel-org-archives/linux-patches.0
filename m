Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03D73769F5;
	Thu, 30 Jul 2026 15:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424830; cv=none; b=Rw9lJ//YQvUKxi262VxgKTZRnqpgrmBq+vy8qxsi+QXc7UhxsnmoFjbDVXUwF9C+LIrAh8MDqbrSUs39jxlXj8Noo7EnyjTTd59FtwGjt2oCW+0VWtkcRzEn9mYnIuaMCKRWK8QqrurXzF9oKFS86zbpwBSa3R9i2RmTuc4FCzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424830; c=relaxed/simple;
	bh=4t7Ci3Md/GYf0FGconRI227yBJ2SubnNJ47PsgYAKxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cuLCi3++6z00UCFW12wp7nDNr1LY3P5NbXik0W0UvDYKR9cFALOTuyQoJKe9oIUCOLloH2HWjzcJfqcyy84g+jAFbnHlXhEtt+P2jXMmMjoLz9UV0FQRRqxOAHOSeFgb8QyKumqvjPG/ggC41TILpOg8X/Nhv2atTmcfJON2IGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WaLjI30K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WaLjI30K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 471931F000E9;
	Thu, 30 Jul 2026 15:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424828;
	bh=+Rfiq7pGC7EeNrBp3+vQTIV1SBhp1Wh/3/FrWWT0khc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WaLjI30KCLYMaRTa5zdD1tOlWVAPEnJa2Q2lgy0anQlpfg3dRsspNkKZoKblyCoar
	 ZSELo7p17LXRL5uHsZKIJkrzzB5Ku0iEhnUylI0hmHyLc2sGQ210IsQQL93UmLp997
	 R3CBRYwsRFp4WuFogFYfDrfIAcAVyoUJjj05ezhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.18 531/675] iommu/vt-d: Disallow SVA if page walk is not coherent
Date: Thu, 30 Jul 2026 16:14:21 +0200
Message-ID: <20260730141456.429848521@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


