Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1967D1D556;
	Mon, 15 Apr 2024 14:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191764; cv=none; b=DVgdfT8uK2PdWTz2pzz7G/1ywtjBO75R25zFZRbU7GCl8Gj5MvIo3xsCc9jTLbIHcfbOcIyws7e0cpfSoeO2P6KXoR1+IJ9nvCzYlCirXOn2TCZJwPRCP3Abbgmta9ZeQHJbSInf7Zkg0k3dF2ROecX0BXqUCFuWOyrjdZeRSr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191764; c=relaxed/simple;
	bh=yWLN8KV2/F82m4BAbnURnt/hijY9kyOdlgpYUAS8Yxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ku1DNMdEzXlvwYru6s7LlWSGblzZ9xxNQrlH2Ve41kEvYQBLPSquq2OVtRUakzI2Xpofnv71EF49VOJ3vnUQoXzkrErKLtDuhtUX+4iZWF2hFX2cX/GlRiyaooH+BPOKWBk+vUu5jU2lH6lQJyxoAh70o06a6ykhDRbLNIe0Tuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O0PfS/Q5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O0PfS/Q5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832E6C2BD11;
	Mon, 15 Apr 2024 14:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191764;
	bh=yWLN8KV2/F82m4BAbnURnt/hijY9kyOdlgpYUAS8Yxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O0PfS/Q5gleScPTYva6filalX2YlyZf/kylhGsvMDlU9YhzFES1ctjbPRC0knEjCP
	 dZs1svocq9bv+sT+0ZnOhn9gCcFR1cWGG7ClsaYBkkGMek5LKPmMkGflTEGLRuFmYY
	 zhE+x8eicZn+Z5SS6BHLGJpr1tqAXPSqjhhrbxKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/122] iommu/vt-d: Allocate local memory for page request queue
Date: Mon, 15 Apr 2024 16:20:42 +0200
Message-ID: <20240415141955.687483509@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

[ Upstream commit a34f3e20ddff02c4f12df2c0635367394e64c63d ]

The page request queue is per IOMMU, its allocation should be made
NUMA-aware for performance reasons.

Fixes: a222a7f0bb6c ("iommu/vt-d: Implement page request handling")
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20240403214007.985600-1-jacob.jun.pan@linux.intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index ac12f76c1212a..6010b93c514c5 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -67,7 +67,7 @@ int intel_svm_enable_prq(struct intel_iommu *iommu)
 	struct page *pages;
 	int irq, ret;
 
-	pages = alloc_pages(GFP_KERNEL | __GFP_ZERO, PRQ_ORDER);
+	pages = alloc_pages_node(iommu->node, GFP_KERNEL | __GFP_ZERO, PRQ_ORDER);
 	if (!pages) {
 		pr_warn("IOMMU: %s: Failed to allocate page request queue\n",
 			iommu->name);
-- 
2.43.0



