Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AFA34CF6
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4B9C433EF;
	Wed,  7 Jun 2023 20:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169263;
	bh=VWMbQlVBTydQfOAgcWyJNsnZoDMc+LJxmrmPknC6Bpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OW9hSJy6+OYkq9BRDKBuXyEOZwayaE/qKBpX5+F5pDgOpv/tWPelF/OS8qXdT3JGb
	 inKEiDxJwV740b+HaDlfP7FHdKsdej3tSM6QF7Y0ieaTlT9LWKoHFM2N1jHdqTPEIC
	 lBnqQnS7yS5+nvbxZfVJTmWWZQ+koK6Bw/rHjFic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 015/286] iommu/amd: Add missing domain type checks
Date: Wed,  7 Jun 2023 22:11:54 +0200
Message-ID: <20230607200923.507514222@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 29f54745f24547a84b18582e054df9bea1a7bf3e ]

Drivers are supposed to list the domain types they support in their
domain_alloc() ops so when we add new domain types, like BLOCKING or SVA,
they don't start breaking.

This ended up providing an empty UNMANAGED domain when the core code asked
for a BLOCKING domain, which happens to be the fallback for drivers that
don't support it, but this is completely wrong for SVA.

Check for the DMA types AMD supports and reject every other kind.

Fixes: 136467962e49 ("iommu: Add IOMMU SVA domain support")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/0-v1-2ac37b893728+da-amd_check_types_jgg@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 478da9b4a1b14..8bd5390808784 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2065,7 +2065,7 @@ static struct protection_domain *protection_domain_alloc(unsigned int type)
 {
 	struct io_pgtable_ops *pgtbl_ops;
 	struct protection_domain *domain;
-	int pgtable = amd_iommu_pgtable;
+	int pgtable;
 	int mode = DEFAULT_PGTABLE_LEVEL;
 	int ret;
 
@@ -2082,6 +2082,10 @@ static struct protection_domain *protection_domain_alloc(unsigned int type)
 		mode = PAGE_MODE_NONE;
 	} else if (type == IOMMU_DOMAIN_UNMANAGED) {
 		pgtable = AMD_IOMMU_V1;
+	} else if (type == IOMMU_DOMAIN_DMA || type == IOMMU_DOMAIN_DMA_FQ) {
+		pgtable = amd_iommu_pgtable;
+	} else {
+		return NULL;
 	}
 
 	switch (pgtable) {
-- 
2.39.2



