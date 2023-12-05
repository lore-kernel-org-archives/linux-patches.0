Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC376FAF;
	Tue,  5 Dec 2023 03:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXofBF/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F28FC433C8;
	Tue,  5 Dec 2023 03:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746683;
	bh=dmM//OIyfjfJiBLxi6eJEvF+tZKlfPhUcNtojNN3rZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UXofBF/lEet8M5nICRw/1MEt39uL1ken7Pk4EzyZI2N3GoG8UXNsyh5ymZCmesyoX
	 mpClfRMj21GJhD9ctyOCY9BCjjUaaXjBfkr2laAUOUSL30lYIjyIKARTA5uk51+L4o
	 EMfioysBmgv57vUQC6ypA5AFco/HvXIVWZvVju+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 118/134] iommu/vt-d: Disable PCI ATS in legacy passthrough mode
Date: Tue,  5 Dec 2023 12:16:30 +0900
Message-ID: <20231205031542.956006931@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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
index 8e878c3beec5c..18fa71aadc903 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2487,7 +2487,8 @@ static int dmar_domain_attach_device(struct dmar_domain *domain,
 		return ret;
 	}
 
-	iommu_enable_pci_caps(info);
+	if (sm_supported(info->iommu) || !domain_type_is_si(info->domain))
+		iommu_enable_pci_caps(info);
 
 	return 0;
 }
-- 
2.42.0



