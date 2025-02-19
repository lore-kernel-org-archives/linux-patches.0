Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053311DED5C;
	Wed, 19 Feb 2025 08:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954443; cv=none; b=CVei9YFBjek5OALCF2n2u7dJINB8mZ5TvbH1Lx7bEKQVHw6qCFBxl5+FyfZAZeR5s9D0OIRd9ZpqLN+N3U4yXFKIgXwGy94tPAtWj33bDwta4X8GY4Ok73AJNrthI25fB+ZMnzU7kMBY4kfQ1yb8zggVSF7KJnpa/F7Irma98zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954443; c=relaxed/simple;
	bh=XLPJMM5tgTCtNmVxQY67jXNJY8A5s9rwCq9fJRuoM5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iLC8o4/v9Ha26j1n2z1EVTYZnoKxeL6cSvY/MdrmsH52nKxxVaa09kgZ0QfWX6d4+pzpajUz5lc6Z1RJs1wLiErt8CYgG+GCymnPz96k0/jsha/2t5gGwFlN0V8SABxex1Ldk5M6BmMElRAjvhGPWTw0QgZW3mfrzRilmgYQCyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LVZGBJ3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LVZGBJ3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6573EC4CEE8;
	Wed, 19 Feb 2025 08:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954442;
	bh=XLPJMM5tgTCtNmVxQY67jXNJY8A5s9rwCq9fJRuoM5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LVZGBJ3uPU/MRw/PFuxptrIRduq4hNWy/DRum5wz/cxDFNpRmnPk/aGXQW8quNcBt
	 1AlN6VzmaHa0x8XYxHZL98o0xnQywuycl5OC0105N+FkibvdDtkaVfpHR3/Gw4w0ig
	 gO49qmgbGz5cVdaSBqOzodSmPAfYqCEbpGNjLt5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.13 175/274] iommu/vt-d: Make intel_iommu_drain_pasid_prq() cover faults for RID
Date: Wed, 19 Feb 2025 09:27:09 +0100
Message-ID: <20250219082616.437902018@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

commit add43c4fbc92f8b48c1acd64e953af3b1be4cd9c upstream.

This driver supports page faults on PCI RID since commit <9f831c16c69e>
("iommu/vt-d: Remove the pasid present check in prq_event_thread") by
allowing the reporting of page faults with the pasid_present field cleared
to the upper layer for further handling. The fundamental assumption here
is that the detach or replace operations act as a fence for page faults.
This implies that all pending page faults associated with a specific RID
or PASID are flushed when a domain is detached or replaced from a device
RID or PASID.

However, the intel_iommu_drain_pasid_prq() helper does not correctly
handle faults for RID. This leads to faults potentially remaining pending
in the iommu hardware queue even after the domain is detached, thereby
violating the aforementioned assumption.

Fix this issue by extending intel_iommu_drain_pasid_prq() to cover faults
for RID.

Fixes: 9f831c16c69e ("iommu/vt-d: Remove the pasid present check in prq_event_thread")
Cc: stable@vger.kernel.org
Suggested-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20250121023150.815972-1-baolu.lu@linux.intel.com
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Link: https://lore.kernel.org/r/20250211005512.985563-2-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/prq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/prq.c b/drivers/iommu/intel/prq.c
index c2d792db52c3..064194399b38 100644
--- a/drivers/iommu/intel/prq.c
+++ b/drivers/iommu/intel/prq.c
@@ -87,7 +87,9 @@ prq_retry:
 		struct page_req_dsc *req;
 
 		req = &iommu->prq[head / sizeof(*req)];
-		if (!req->pasid_present || req->pasid != pasid) {
+		if (req->rid != sid ||
+		    (req->pasid_present && pasid != req->pasid) ||
+		    (!req->pasid_present && pasid != IOMMU_NO_PASID)) {
 			head = (head + sizeof(*req)) & PRQ_RING_MASK;
 			continue;
 		}
-- 
2.48.1



