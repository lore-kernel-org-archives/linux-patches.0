Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11EA74422;
	Mon, 15 Apr 2024 14:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192023; cv=none; b=LFzIizgruekIbqOGhdNXBtBIKND7zbeVYz1ru2RH73/2ahW8sRImXSAZy6luNc3SupXiMq7oahZMgUX3fFNDgk2L1zIesboUgmYxeCqiuzhvQyeIKpjOa7JpruKhV8NB5D2hK6wnDQYc6Kschy0dlOmV7StGttRGuCywNUhhT3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192023; c=relaxed/simple;
	bh=KE9feLmLFJ06EUkklTQgKDa+dk4/OsSk3zSCRSRAx8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhSZswgJppwnB+IpV/AV2YFj5WFO/2WrkZ18Z45Xw7LNRKZghdtC1i6cE17kTBYNRQhwqxVaa0WXXqJ3EzeAdDBZ4ApJDyok7yhb/kUs1apL+uywLrS5x75SzO569VzKUJ8zjRzmPY+OfwXVccP9CxPl1cO48awn3tZYwLx8FuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B6TlLHBx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B6TlLHBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5446EC113CC;
	Mon, 15 Apr 2024 14:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192023;
	bh=KE9feLmLFJ06EUkklTQgKDa+dk4/OsSk3zSCRSRAx8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B6TlLHBxpB0lIyG2W+Gq8eBOidQs7bXqOUcLQuVJkDjPNzL23rfFWuSOlo2mygbXB
	 /sJzma/XMF/Wfvwv6yAdKeTPbFCggM+HclS7AkhGnLVDXzdKzLgkHWK3SDOISoTj8C
	 xrAk2z8svC0vXhHYHnatVT3LFFp0/vWwbzDlKAlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 40/69] iommu/vt-d: Allocate local memory for page request queue
Date: Mon, 15 Apr 2024 16:21:11 +0200
Message-ID: <20240415141947.371324692@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141946.165870434@linuxfoundation.org>
References: <20240415141946.165870434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 03b25358946c4..cb862ab96873e 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -71,7 +71,7 @@ int intel_svm_enable_prq(struct intel_iommu *iommu)
 	struct page *pages;
 	int irq, ret;
 
-	pages = alloc_pages(GFP_KERNEL | __GFP_ZERO, PRQ_ORDER);
+	pages = alloc_pages_node(iommu->node, GFP_KERNEL | __GFP_ZERO, PRQ_ORDER);
 	if (!pages) {
 		pr_warn("IOMMU: %s: Failed to allocate page request queue\n",
 			iommu->name);
-- 
2.43.0



