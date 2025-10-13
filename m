Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E8630E0DD;
	Mon, 13 Oct 2025 15:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368543; cv=none; b=mIo/giTFtbk+/AnV+S+tI3OR1hH5eXulMI5pDWovECVDrrxcbJFukulgCxxOXKFbURom3Mnaqp/N4NUc7NjQ89KKaokclosQuzCJ5BSubjnADPnO3KdNv+TGXHMbpXEmAVin56HUoe/cV4P6cHARdGpKqsBx26lJ+ppwDEez6TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368543; c=relaxed/simple;
	bh=gf8GYvBS6J11Y+5ePzigVfCF1QTnLRzipV1J3Ed1Aig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qBWrAEKYbJ5RX775vu+Ta+rumZizW7NzWOTcyOLBDfQq+2uau8MqAahaZMzz9wzDdMyGbhtWRx2Y77bGyfdivePhMNUkqZrsZZ2w4UPGjUHrAxZJeBkOOi/RCinL0GQUAn0VoweIm5MXbQOnnXUOcF/nS44io2ZU2KdOpcrVQgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cRn2W9nB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cRn2W9nB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F59AC4CEE7;
	Mon, 13 Oct 2025 15:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368543;
	bh=gf8GYvBS6J11Y+5ePzigVfCF1QTnLRzipV1J3Ed1Aig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cRn2W9nBZhxY0Z1IEzZ2VVuGZfPhYmFjUMASJCBZSZaXRuYCz0R0x2x/hC6tuz6Hd
	 YW8FQfBYLi0uUNR44aBmc3j+ohrfeEGfnzuUA8R82KKD7Rykrk3cHWfkzEKYDA3Gxl
	 mHkBwGyclk5BP9S95Il5AlWcdNJRGR/dsskGgipk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 197/262] iommu/vt-d: Disallow dirty tracking if incoherent page walk
Date: Mon, 13 Oct 2025 16:45:39 +0200
Message-ID: <20251013144333.342210122@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 57f55048e564dedd8a4546d018e29d6bbfff0a7e ]

Dirty page tracking relies on the IOMMU atomically updating the dirty bit
in the paging-structure entry. For this operation to succeed, the paging-
structure memory must be coherent between the IOMMU and the CPU. In
another word, if the iommu page walk is incoherent, dirty page tracking
doesn't work.

The Intel VT-d specification, Section 3.10 "Snoop Behavior" states:

"Remapping hardware encountering the need to atomically update A/EA/D bits
 in a paging-structure entry that is not snooped will result in a non-
 recoverable fault."

To prevent an IOMMU from being incorrectly configured for dirty page
tracking when it is operating in an incoherent mode, mark SSADS as
supported only when both ecap_slads and ecap_smpwc are supported.

Fixes: f35f22cc760e ("iommu/vt-d: Access/Dirty bit support for SS domains")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20250924083447.123224-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index f521155fb793b..df24a62e8ca40 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -541,7 +541,8 @@ enum {
 #define pasid_supported(iommu)	(sm_supported(iommu) &&			\
 				 ecap_pasid((iommu)->ecap))
 #define ssads_supported(iommu) (sm_supported(iommu) &&                 \
-				ecap_slads((iommu)->ecap))
+				ecap_slads((iommu)->ecap) &&           \
+				ecap_smpwc(iommu->ecap))
 #define nested_supported(iommu)	(sm_supported(iommu) &&			\
 				 ecap_nest((iommu)->ecap))
 
-- 
2.51.0



