Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B45342538
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301790; cv=none; b=VCMjpSQbwe0D6VCJ5I7Oyn8bH9Q5FweXctE8mvJ94HVqL3MRFEWyMzquWTgCzDFwM9wmDfsCgkSJfFHTa5yTD7EUobPq2QzNNI4Pw0rOzAM5Y7z59hkjEokqg0CUCzIsqMSF35lD6TBDrl2s3APLMM5zlkL4c2bM22WCefY4l1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301790; c=relaxed/simple;
	bh=5XqUcN3C17NhN0paxfvWXJ1w8pq6SNS2QEOb308TB1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTCxib/VuyKwBW1eqtU6SDQvqE+HwlC3l9vaA9VJ5JVyIgBiP4YcY0+nKzIkBJQxGhnYTxrQwN1Y1RAh5O1srfXhP0OP91AcP4pKLrMV6kiJqmipeIw51wE/+kSBud0KsMx6JhmdqViOIZrYrNmdkCgTN0kh8e8eI+O59z9L/4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m1zpXv2I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m1zpXv2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058A5C19423;
	Sat, 28 Feb 2026 18:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301790;
	bh=5XqUcN3C17NhN0paxfvWXJ1w8pq6SNS2QEOb308TB1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m1zpXv2I8+ZbMuJQzd6QBG+tzzu5iaJ7CsxSDJj1MO/DAVfaqJfJaZ5p+vDgEcw0t
	 jnMxVUrlPyKMrWauNpOkbVoQitqVnmbiv40Qs5zBSv311U2PIQaApI3irM+esEC6MN
	 7dAE7Z54bPiXESIj17rydiHTh+PrNu83Gi+FAgktYViZTj5+wKabicU5XhBoGMb84O
	 7VrEpPiLzW/4ipJtNRQv7RHyI8xYLDJnrTND8Wc6iH0v8AXvWQ0ayM41hxq41bsaBM
	 a9zS2yrfPD3fn2bu/6gXl88eiRFF8pr2bP9TuwgOx3F3B1dZHfCvf6wwB20pAV18o6
	 R/WBydOf4uhhA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 200/385] iommu/vt-d: Avoid draining PRQ in sva mm release path
Date: Sat, 28 Feb 2026 12:57:02 -0500
Message-ID: <20260228180011.1568201-200-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit dda2b8c3c6ccc50deae65cc75f246577348e2ec5 ]

When a PASID is used for SVA by a device, it's possible that the PASID
entry is cleared before the device flushes all ongoing DMA requests and
removes the SVA domain. This can occur when an exception happens and the
process terminates before the device driver stops DMA and calls the
iommu driver to unbind the PASID.

There's no need to drain the PRQ in the mm release path. Instead, the PRQ
will be drained in the SVA unbind path.

Unfortunately, commit c43e1ccdebf2 ("iommu/vt-d: Drain PRQs when domain
removed from RID") changed this behavior by unconditionally draining the
PRQ in intel_pasid_tear_down_entry(). This can lead to a potential
sleeping-in-atomic-context issue.

Smatch static checker warning:

	drivers/iommu/intel/prq.c:95 intel_iommu_drain_pasid_prq()
	warn: sleeping in atomic context

To avoid this issue, prevent draining the PRQ in the SVA mm release path
and restore the previous behavior.

Fixes: c43e1ccdebf2 ("iommu/vt-d: Drain PRQs when domain removed from RID")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-iommu/c5187676-2fa2-4e29-94e0-4a279dc88b49@stanley.mountain/
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20241212021529.1104745-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: 75ed00055c05 ("iommu/vt-d: Clear Present bit before tearing down PASID entry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/pasid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 4e4d167720ba8..57969ba2d3975 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -266,7 +266,8 @@ void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
 		iommu->flush.flush_iotlb(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH);
 
 	devtlb_invalidation_with_pasid(iommu, dev, pasid);
-	intel_iommu_drain_pasid_prq(dev, pasid);
+	if (!fault_ignore)
+		intel_iommu_drain_pasid_prq(dev, pasid);
 }
 
 /*
-- 
2.51.0

