Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2342182877;
	Mon, 15 Apr 2024 14:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191316; cv=none; b=Exuqul24BiPP5LKnJbuefcdyB+WD6JyqHfZQu1fIBu4PATsx74x3/uJHqrQKbu1zTvdbMWDxLnshbs+MHfNwsm3sb3H9sGvGl/y9MQkydAb/cOlC9xhe9ih+z/psyUeAa3CE/hzl8gnLIWYtSh+2DUczitaK0qBCBdVjYHRgALI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191316; c=relaxed/simple;
	bh=CTe2lPgO3PkHs4ZGkiNRzuTRUwT+ocjUFPD8VmfC0MQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NciwZcfKSVU1b32/OSevhe0mr8xNztqFUNFdHSN6nvUbe1LFtci4f88dg3eCHrdC3N/8CHhXLMb+x1DddSz1XpFDfEECo5gBAE0OcTpBkgeomMKTBN1dNoSRZ9aZORopMG5+UoCxMkb66L96tKyIRJy35+1qMPruRPwnjVANnQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TipV9D3a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TipV9D3a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5AFC113CC;
	Mon, 15 Apr 2024 14:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191316;
	bh=CTe2lPgO3PkHs4ZGkiNRzuTRUwT+ocjUFPD8VmfC0MQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TipV9D3ajAfyXpmu3+jwwzQYlfxo+9pasDECBrzrSsPDGdkrMhayn5zjjGUYu/50U
	 YWmIAPo7aPcphZa7gdZTD4dTxqZbl1qPYmMT0d1L2JZ8YcWvSl0puIU+SvdNIBFdZh
	 Xe8eL2aHevEAeFp1WkuR6fgfySLQFCRQTNWtRiVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 104/172] iommu/vt-d: Allocate local memory for page request queue
Date: Mon, 15 Apr 2024 16:20:03 +0200
Message-ID: <20240415142003.553143076@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index ec47ec81f0ecd..4d269df0082fb 100644
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



