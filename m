Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB376FB1;
	Tue,  5 Dec 2023 03:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oOGoGEc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B53FEC433C7;
	Tue,  5 Dec 2023 03:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747240;
	bh=+hNOsNlTIfQ53t/kEvYdb8MTo+8zauOKBQXF93s7hIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oOGoGEc3YpzSGAIH2PEeIKGXT0CxgTu0O/31Ra3lK9UxtCZ0xEsHNjzUAVgZmJbPl
	 8UnVqrn/D107bDYdRHGwnH//CnzBr4DFkN+EADS3V4V8sPXXTbIdowxRR3hf4KgkCa
	 ESwjQXU03mZY79Q75xKfpgQiplLwaJ7+63G0zA/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 093/107] iommu/vt-d: Disable PCI ATS in legacy passthrough mode
Date: Tue,  5 Dec 2023 12:17:08 +0900
Message-ID: <20231205031537.529943261@linuxfoundation.org>
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

[ Upstream commit da37dddcf4caf015c400a930301d2ee27a7a15fb ]

When IOMMU hardware operates in legacy mode, the TT field of the context
entry determines the translation type, with three supported types (Section
9.3 Context Entry):

- DMA translation without device TLB support
- DMA translation with device TLB support
- Passthrough mode with translated and translation requests blocked

Device TLB support is absent when hardware is configured in passthrough
mode.

Disable the PCI ATS feature when IOMMU is configured for passthrough
translation type in legacy (non-scalable) mode.

Fixes: 0faa19a1515f ("iommu/vt-d: Decouple PASID & PRI enabling from SVA")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20231114011036.70142-3-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index de76272d0fb02..807abf4707be7 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2517,7 +2517,8 @@ static int domain_add_dev_info(struct dmar_domain *domain, struct device *dev)
 		return ret;
 	}
 
-	iommu_enable_pci_caps(info);
+	if (sm_supported(info->iommu) || !domain_type_is_si(info->domain))
+		iommu_enable_pci_caps(info);
 
 	return 0;
 }
-- 
2.42.0



