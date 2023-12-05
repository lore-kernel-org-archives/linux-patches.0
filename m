Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA3FA59;
	Tue,  5 Dec 2023 03:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lrZKbFbr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20798C433C7;
	Tue,  5 Dec 2023 03:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747231;
	bh=GywkC+3gS4Hc5v0rX3xmg/GwIwh3eaex4SwGmscHsAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lrZKbFbrhfF6dfgYahq3lQ2xub6gmwwvi84NxghrOPi22+ny5d2Cb50qhRB6pve66
	 hlLz+XM/aKIuHufr+JExp5MZaETQ1msbLo3V0vQuF8z2ARVd54XpyztnCn2oOmfDIa
	 yFKm0q+KTRmKbIY5NwRe7SucK5eKOYxVAI2iD9po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 090/107] iommu/vt-d: Omit devTLB invalidation requests when TES=0
Date: Tue,  5 Dec 2023 12:17:05 +0900
Message-ID: <20231205031537.305799153@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 0f5432a9b839847dcfe9fa369d72e3d646102ddf ]

The latest VT-d spec indicates that when remapping hardware is disabled
(TES=0 in Global Status Register), upstream ATS Invalidation Completion
requests are treated as UR (Unsupported Request).

Consequently, the spec recommends in section 4.3 Handling of Device-TLB
Invalidations that software refrain from submitting any Device-TLB
invalidation requests when address remapping hardware is disabled.

Verify address remapping hardware is enabled prior to submitting Device-
TLB invalidation requests.

Fixes: 792fb43ce2c9 ("iommu/vt-d: Enable Intel IOMMU scalable mode by default")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20231114011036.70142-2-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/dmar.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index f800989ea0462..418af1db0192d 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -1495,6 +1495,15 @@ void qi_flush_dev_iotlb(struct intel_iommu *iommu, u16 sid, u16 pfsid,
 {
 	struct qi_desc desc;
 
+	/*
+	 * VT-d spec, section 4.3:
+	 *
+	 * Software is recommended to not submit any Device-TLB invalidation
+	 * requests while address remapping hardware is disabled.
+	 */
+	if (!(iommu->gcmd & DMA_GCMD_TE))
+		return;
+
 	if (mask) {
 		addr |= (1ULL << (VTD_PAGE_SHIFT + mask - 1)) - 1;
 		desc.qw1 = QI_DEV_IOTLB_ADDR(addr) | QI_DEV_IOTLB_SIZE;
@@ -1560,6 +1569,15 @@ void qi_flush_dev_iotlb_pasid(struct intel_iommu *iommu, u16 sid, u16 pfsid,
 	unsigned long mask = 1UL << (VTD_PAGE_SHIFT + size_order - 1);
 	struct qi_desc desc = {.qw1 = 0, .qw2 = 0, .qw3 = 0};
 
+	/*
+	 * VT-d spec, section 4.3:
+	 *
+	 * Software is recommended to not submit any Device-TLB invalidation
+	 * requests while address remapping hardware is disabled.
+	 */
+	if (!(iommu->gcmd & DMA_GCMD_TE))
+		return;
+
 	desc.qw0 = QI_DEV_EIOTLB_PASID(pasid) | QI_DEV_EIOTLB_SID(sid) |
 		QI_DEV_EIOTLB_QDEP(qdep) | QI_DEIOTLB_TYPE |
 		QI_DEV_IOTLB_PFSID(pfsid);
-- 
2.42.0



