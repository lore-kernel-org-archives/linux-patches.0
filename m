Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57659445;
	Mon, 15 Apr 2024 14:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192196; cv=none; b=TN1jgfmKbNF6sfGcrzm3cKfEi4Q1oQ+iaoXkpLSJMre0AsiurRaJPNHWKYJHhga5PVNK0wP7DKZgKdf/JHyjhQtHlUXB/ginpatJqWDscv42wQP3LCMKuH2WL7y8FJ/ujktOdHOINxZOM9pcXWTkbCAcPpzjckWtkGugVDGXcr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192196; c=relaxed/simple;
	bh=oZy1HnfVyjQRn+gbm19hcU3KbJmAd2pmqBnXFrvCmUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KAdZixT236zNOVUqiRMiocTZTMMwG9caE5a2W/X0x0Wob5xtj9YZEqMDKSjX46lIaaZPX9SgHXt3sJoiYvzMmdu+DZObMBwTCU9ws65wUXeTnhFgpR1lWVazDmWPc+bWD0zajy64lWsUNafgPina7r3N7fhzpDMtb+jlAksQE4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rPByCCbI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rPByCCbI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A0ACC113CC;
	Mon, 15 Apr 2024 14:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192196;
	bh=oZy1HnfVyjQRn+gbm19hcU3KbJmAd2pmqBnXFrvCmUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rPByCCbIp6INR41jEB0Hhl6WHdc3bYzvaptT2EnIWz1wALLIBkOcA1/Sxiw0aEorC
	 Ky9asHscc9BA0rIGP6DZcz5A1PpCYMRIdRrjhAN5MI4Ae89DSBBfeSkVkzVbuDTNhV
	 2aGIe8yyREP72W4cT605RG9YSnQci5TAjRAus0n0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 28/45] iommu/vt-d: Allocate local memory for page request queue
Date: Mon, 15 Apr 2024 16:21:35 +0200
Message-ID: <20240415141943.087418061@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141942.235939111@linuxfoundation.org>
References: <20240415141942.235939111@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3a9468b1d2c3c..a96c9a15c9fee 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -88,7 +88,7 @@ int intel_svm_enable_prq(struct intel_iommu *iommu)
 	struct page *pages;
 	int irq, ret;
 
-	pages = alloc_pages(GFP_KERNEL | __GFP_ZERO, PRQ_ORDER);
+	pages = alloc_pages_node(iommu->node, GFP_KERNEL | __GFP_ZERO, PRQ_ORDER);
 	if (!pages) {
 		pr_warn("IOMMU: %s: Failed to allocate page request queue\n",
 			iommu->name);
-- 
2.43.0



