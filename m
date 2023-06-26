Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9972D134B3
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:21:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16800C433C9;
	Mon, 26 Jun 2023 18:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803702;
	bh=qJnEFAY/vVPuLcjvZ1NZQT2IYN/SI9qiXmPm0kMiciM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UqTsz+6VKhqABGKZmCXOXqqD+HGrYOkwru0qwiYskaEfdP+PkOitwEHWh23wRHwqv
	 gGA53BZnquMPuKcIGuIpOQ5oDn4s1zV7lf3R64k66e1pqO3r0sM4BjWIegywB64qnI
	 kjscXycLKWuSfJaxSbpYLbxFZ11pmPZ0e5VXjo6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 148/199] iommu/amd: Fix possible memory leak of domain
Date: Mon, 26 Jun 2023 20:10:54 +0200
Message-ID: <20230626180812.121825464@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 5b00369fcf6d1ff9050b94800dc596925ff3623f ]

Move allocation code down to avoid memory leak.

Fixes: 29f54745f245 ("iommu/amd: Add missing domain type checks")
Signed-off-by: Su Hui <suhui@nfschina.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Link: https://lore.kernel.org/r/20230608021933.856045-1-suhui@nfschina.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index cd0e3fb78c3ff..e9eac86cddbd2 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2069,10 +2069,6 @@ static struct protection_domain *protection_domain_alloc(unsigned int type)
 	int mode = DEFAULT_PGTABLE_LEVEL;
 	int ret;
 
-	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
-	if (!domain)
-		return NULL;
-
 	/*
 	 * Force IOMMU v1 page table when iommu=pt and
 	 * when allocating domain for pass-through devices.
@@ -2088,6 +2084,10 @@ static struct protection_domain *protection_domain_alloc(unsigned int type)
 		return NULL;
 	}
 
+	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
+	if (!domain)
+		return NULL;
+
 	switch (pgtable) {
 	case AMD_IOMMU_V1:
 		ret = protection_domain_init_v1(domain, mode);
-- 
2.39.2



