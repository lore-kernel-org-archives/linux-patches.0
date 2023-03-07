Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8345EBA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD52C433EF;
	Tue,  7 Mar 2023 18:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213356;
	bh=zMTdZEKp+7Q0EH+mzraBpgIp4GVZpxamBZLKhrgd0rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AIcHCIB1N90LhZMBQO+dxCnme8dSOuevpAGUd/+hcDtfcleBoH3AEEayJePo8GaVQ
	 D9bt1UD+Rm9TZW2zUgkN2xnONyhb+TANZri7ASBek59EKSj9FtB6jjFlC0bDNM45Yq
	 htSr9s7ZN53ViuJyEGpxfwxauXzIXOFML3kS7hyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 482/885] iommu: Fix error unwind in iommu_group_alloc()
Date: Tue,  7 Mar 2023 17:56:56 +0100
Message-Id: <20230307170023.418833672@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

[ Upstream commit 4daa861174d56023c2068ddb03de0752f07fa199 ]

If either iommu_group_grate_file() fails then the
iommu_group is leaked.

Destroy it on these error paths.

Found by kselftest/iommu/iommufd_fail_nth

Fixes: bc7d12b91bd3 ("iommu: Implement reserved_regions iommu-group sysfs file")
Fixes: c52c72d3dee8 ("iommu: Add sysfs attribyte for domain type")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/0-v1-8f616bee028d+8b-iommu_group_alloc_leak_jgg@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 959d895fc1dff..fd8c8aeb3c504 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -749,12 +749,16 @@ struct iommu_group *iommu_group_alloc(void)
 
 	ret = iommu_group_create_file(group,
 				      &iommu_group_attr_reserved_regions);
-	if (ret)
+	if (ret) {
+		kobject_put(group->devices_kobj);
 		return ERR_PTR(ret);
+	}
 
 	ret = iommu_group_create_file(group, &iommu_group_attr_type);
-	if (ret)
+	if (ret) {
+		kobject_put(group->devices_kobj);
 		return ERR_PTR(ret);
+	}
 
 	pr_debug("Allocated group %d\n", group->id);
 
-- 
2.39.2



