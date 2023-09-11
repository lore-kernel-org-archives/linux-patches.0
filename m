Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F90311710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCFBC433C7;
	Mon, 11 Sep 2023 15:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445730;
	bh=GZmjSkEO8+xeg9DhtcjQ3vgvIe4alrK02M/7fQCcc8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0O5XoTgr9uvvApiSwN23leQX4uXVK6dBT5JVG9r9FbFY4dFZVJ6s6PG25BRfokaQO
	 Ntx+AE6RtFdo0QaVAgXKKxFDmTlNaPjfNdFMCRD0xQQvIr8U9kBG8xn1/wyaTbhWa3
	 wTHvqAlVXNeFlAi5XGzv1g1NG29XI4IysTgbSXrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Yanfei Xu <yanfei.xu@intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 451/600] iommu/vt-d: Fix to flush cache of PASID directory table
Date: Mon, 11 Sep 2023 15:48:04 +0200
Message-ID: <20230911134646.960177238@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

From: Yanfei Xu <yanfei.xu@intel.com>

[ Upstream commit 8a3b8e63f8371c1247b7aa24ff9c5312f1a6948b ]

Even the PCI devices don't support pasid capability, PASID table is
mandatory for a PCI device in scalable mode. However flushing cache
of pasid directory table for these devices are not taken after pasid
table is allocated as the "size" of table is zero. Fix it by
calculating the size by page order.

Found this when reading the code, no real problem encountered for now.

Fixes: 194b3348bdbb ("iommu/vt-d: Fix PASID directory pointer coherency")
Suggested-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Yanfei Xu <yanfei.xu@intel.com>
Link: https://lore.kernel.org/r/20230616081045.721873-1-yanfei.xu@intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/pasid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index a39aab66a01b1..3f03039e5cce5 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -127,7 +127,7 @@ int intel_pasid_alloc_table(struct device *dev)
 	info->pasid_table = pasid_table;
 
 	if (!ecap_coherent(info->iommu->ecap))
-		clflush_cache_range(pasid_table->table, size);
+		clflush_cache_range(pasid_table->table, (1 << order) * PAGE_SIZE);
 
 	return 0;
 }
-- 
2.40.1



