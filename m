Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6A523CE;
	Tue,  3 Dec 2024 16:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241866; cv=none; b=H33qh0kck73CuKFIvCoqoVvokG92wa5oClMQk6PKJFqPDLxPST05LBFGFxeklvHtlOSA7IvmGBKpWSxxQ0ZdzOycZyvF5aApRhsjTAaj7rjD+MKYom2MeQZKp+wONgJRsVmDgd5SYChAwN9otLcUc/DRjXUtZRNVI0HdQ3oifaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241866; c=relaxed/simple;
	bh=JCfa3tgqE9sahJh4/FQ7mNktWUNB8vdrziI/lsxkysE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tcpDIsqPE1DmzG+PqooriBDMDy5Ew4htjGyNZfZ4CeoOPwsII21YXtvwtBQ6Z7DohsOksV7rDW5vXntbbeBQNEJqU+HcQPl/ANNJx3LkLqoEx1Gt6R/JyqMpiGERVv8P+Js3S8LZJdfJAoTVus7J6snLzfGk8grkWdqVNQFYuqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QkArPHkh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QkArPHkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3784EC4CECF;
	Tue,  3 Dec 2024 16:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241866;
	bh=JCfa3tgqE9sahJh4/FQ7mNktWUNB8vdrziI/lsxkysE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QkArPHkhBAiCLWwWag7cJOCWPFrhkckCy3uwKXcV3pumAL9yY484+n/9C+uxeZ8Ci
	 NtESm344AYiE8V3Wu3z036jUSGpyY/6Jon9t7V0WcipzhJG/Un9ESaLKspG9mF31DN
	 15oiYQI/V/a5dXH3uy9v+B2HYu3F7CXdGRDebpUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Si-Wei Liu <si-wei.liu@oracle.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 539/826] vdpa/mlx5: Fix suboptimal range on iotlb iteration
Date: Tue,  3 Dec 2024 15:44:26 +0100
Message-ID: <20241203144804.780052724@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Si-Wei Liu <si-wei.liu@oracle.com>

[ Upstream commit 35025963326e44d8bced3eecd42d2f040f4f0024 ]

The starting iova address to iterate iotlb map entry within a range
was set to an irrelevant value when passing to the itree_next()
iterator, although luckily it doesn't affect the outcome of finding
out the granule of the smallest iotlb map size. Fix the code to make
it consistent with the following for-loop.

Fixes: 94abbccdf291 ("vdpa/mlx5: Add shared memory registration code")
Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Message-Id: <20241021134040.975221-3-dtatulea@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/core/mr.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 7d0c83b5b0715..8455f08f5d406 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -368,7 +368,6 @@ static int map_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr
 	unsigned long lgcd = 0;
 	int log_entity_size;
 	unsigned long size;
-	u64 start = 0;
 	int err;
 	struct page *pg;
 	unsigned int nsg;
@@ -379,10 +378,9 @@ static int map_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr
 	struct device *dma = mvdev->vdev.dma_dev;
 
 	for (map = vhost_iotlb_itree_first(iotlb, mr->start, mr->end - 1);
-	     map; map = vhost_iotlb_itree_next(map, start, mr->end - 1)) {
+	     map; map = vhost_iotlb_itree_next(map, mr->start, mr->end - 1)) {
 		size = maplen(map, mr);
 		lgcd = gcd(lgcd, size);
-		start += size;
 	}
 	log_entity_size = ilog2(lgcd);
 
-- 
2.43.0



