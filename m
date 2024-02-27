Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D7678B61;
	Tue, 27 Feb 2024 13:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041258; cv=none; b=DvRsHgUtSR4dCn0rx3w7JMegsdI6M6Z5q1z0Z8H8GUHxbK2cWWaevWaDJpDqKljSVXme1fktCfzuzZWSlF+p79D1Z0BoQ8JU58Y3qSvVn4OvGrF8iKf0w8FpW11jA7GmVSajbu7NnyT+qD9+7sxt8pYi6ixJ8mnAOOB4t48PdVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041258; c=relaxed/simple;
	bh=ifMaEGFbFIfB0Gdg7aSdF/Pxap9tRiyjCpRk/VGTpXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQRj/4sLwph954Guoiw5/43gvUPvCnjr9uCTI66hKkBmzS+d8Mz5vFltCwoXQbAZ49E3gyy5oZR71NnppdL+lOiUzmv+GL3lVEGYelaF4+M3wNGt5/H1ZabQ90EYhvGtVo5TrmsEyVOcXR9KCp1NQu/LbNP2riAakhDp/6RxgFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PwPhCrMx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PwPhCrMx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3053DC433F1;
	Tue, 27 Feb 2024 13:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041258;
	bh=ifMaEGFbFIfB0Gdg7aSdF/Pxap9tRiyjCpRk/VGTpXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PwPhCrMxbWc/LFZUenWqrwLW8mVwSmvpbNw8pUvZL2q1nCwt7ATRp3mcuCc1gPXUQ
	 AJqaM3RpAxCzzO4V1H0FACBqddan5zH83/jHFxXZQJWzejVuKCSg5+taG2c3I2EoAs
	 rOiBJux7vkV2yYJiq4watRUx0UmESIIpCvc6+fQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joao Martins <joao.m.martins@oracle.com>,
	Avihai Horon <avihaih@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 247/334] iommufd/iova_bitmap: Consider page offset for the pages to be pinned
Date: Tue, 27 Feb 2024 14:21:45 +0100
Message-ID: <20240227131638.868489511@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joao Martins <joao.m.martins@oracle.com>

[ Upstream commit 4bbcbc6ea2fa379632a24c14cfb47aa603816ac6 ]

For small bitmaps that aren't PAGE_SIZE aligned *and* that are less than
512 pages in bitmap length, use an extra page to be able to cover the
entire range e.g. [1M..3G] which would be iterated more efficiently in a
single iteration, rather than two.

Fixes: b058ea3ab5af ("vfio/iova_bitmap: refactor iova_bitmap_set() to better handle page boundaries")
Link: https://lore.kernel.org/r/20240202133415.23819-10-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Tested-by: Avihai Horon <avihaih@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/iova_bitmap.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/iommufd/iova_bitmap.c b/drivers/iommu/iommufd/iova_bitmap.c
index b370e8ee88665..db8c46bee1559 100644
--- a/drivers/iommu/iommufd/iova_bitmap.c
+++ b/drivers/iommu/iommufd/iova_bitmap.c
@@ -178,18 +178,19 @@ static int iova_bitmap_get(struct iova_bitmap *bitmap)
 			       bitmap->mapped_base_index) *
 			       sizeof(*bitmap->bitmap), PAGE_SIZE);
 
-	/*
-	 * We always cap at max number of 'struct page' a base page can fit.
-	 * This is, for example, on x86 means 2M of bitmap data max.
-	 */
-	npages = min(npages,  PAGE_SIZE / sizeof(struct page *));
-
 	/*
 	 * Bitmap address to be pinned is calculated via pointer arithmetic
 	 * with bitmap u64 word index.
 	 */
 	addr = bitmap->bitmap + bitmap->mapped_base_index;
 
+	/*
+	 * We always cap at max number of 'struct page' a base page can fit.
+	 * This is, for example, on x86 means 2M of bitmap data max.
+	 */
+	npages = min(npages + !!offset_in_page(addr),
+		     PAGE_SIZE / sizeof(struct page *));
+
 	ret = pin_user_pages_fast((unsigned long)addr, npages,
 				  FOLL_WRITE, mapped->pages);
 	if (ret <= 0)
-- 
2.43.0



