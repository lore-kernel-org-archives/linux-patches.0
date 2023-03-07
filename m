Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4E9BA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:33:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD9BC433EF;
	Tue,  7 Mar 2023 17:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210405;
	bh=bNdLOrut/MxMwffJRAd7KmhP+FhXy8QO33dC+Y1UdKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aWo5lBWlnOo1MngGK4R47LktRq6l5tH8W5PZnYTNkFH7IRqnvjerJmDz98w8YRCuw
	 6uEjsuNdJCJO4nSLjlxzMzXa3CohtEe2M5bsoO9PYDBlYlDSddIcUWb94dqPOAksZE
	 CWmXaahoeu2+w8x+C5FGY6UQJtUMRcc3uYHT6JUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Sam Protsenko <semen.protsenko@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0523/1001] iommu/exynos: Fix error handling in exynos_iommu_init()
Date: Tue,  7 Mar 2023 17:54:55 +0100
Message-Id: <20230307170044.144071812@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 53719876e064643a6e58b5e6067a149a0fd191ec ]

If platform_driver_register() fails, it don't need unregister and call
kmem_cache_free() to free the memory allocated before calling register.

Fixes: bbc4d205d93f ("iommu/exynos: Fix driver initialization sequence")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Sam Protsenko <semen.protsenko@linaro.org>
Link: https://lore.kernel.org/r/20230104095702.2591122-1-yangyingliang@huawei.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/exynos-iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index b0cde22119875..c1d579c24740b 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -1446,7 +1446,7 @@ static int __init exynos_iommu_init(void)
 
 	return 0;
 err_reg_driver:
-	platform_driver_unregister(&exynos_sysmmu_driver);
+	kmem_cache_free(lv2table_kmem_cache, zero_lv2_table);
 err_zero_lv2:
 	kmem_cache_destroy(lv2table_kmem_cache);
 	return ret;
-- 
2.39.2



