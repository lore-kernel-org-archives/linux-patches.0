Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9BF3C68C
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:32:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DFBC433C8;
	Wed, 20 Sep 2023 12:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213137;
	bh=h/jWimNCVhclO8eoV3HAkBK3+uIdBLerCWnf3sYdB1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MepNQaUU4+ELudVggeNFur6A+JQWJplCZnstyWDX1q5IXTGOsTi3SRHuGIqWbmcxx
	 JhkQOwHIl4kBgKQLPg0L/MPe5hRIb4KCa3l1J8/DCuF10GjOWgLzsAEli32BLUtxrW
	 TwQoBObw0e/h3F73+tlxNZegkbJ3fDeaC154P/0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Yanfei Xu <yanfei.xu@intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 174/367] iommu/vt-d: Fix to flush cache of PASID directory table
Date: Wed, 20 Sep 2023 13:29:11 +0200
Message-ID: <20230920112903.144324635@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/iommu/intel-pasid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel-pasid.c b/drivers/iommu/intel-pasid.c
index 58f060006ba31..9641eaa19e08e 100644
--- a/drivers/iommu/intel-pasid.c
+++ b/drivers/iommu/intel-pasid.c
@@ -167,7 +167,7 @@ int intel_pasid_alloc_table(struct device *dev)
 	device_attach_pasid_table(info, pasid_table);
 
 	if (!ecap_coherent(info->iommu->ecap))
-		clflush_cache_range(pasid_table->table, size);
+		clflush_cache_range(pasid_table->table, (1 << order) * PAGE_SIZE);
 
 	return 0;
 }
-- 
2.40.1



