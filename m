Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C601F22689C;
	Thu, 12 Dec 2024 16:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021766; cv=none; b=g3xpVAMxrGIerMCuSWlAFXIoLj6QZsoj1sCUlmTUwvWWH5VRbK/qLyoJ6zYoS0VZ7u2MtvkICRsr63mYIWHH3EtGzqwT35V79I5ZcbkuleJ9mFOGQYWCk4v8+6OHdQiWqC9QA/3Cx3M/iulUGiGZS4Y0TxLIbvIAUP2muOKc1Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021766; c=relaxed/simple;
	bh=SQj51b5sYxOt+OsST4mIHos7uvsAMGa07CC0pO72ep4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFUlCFIbrO84Udo3EuFWkb8HvE9JHQvncocoY0gc8vQmOlbITHo3ppLVzD9fe2LV/XULYjQXiSZABq2nrP3MGZLhscDP7m86z9OLmdcITdavK70hRHO5J2hcUjzQonGz9Vmzshw0XbfQYdoYA1eJj0eJNtgQM5yz60pQMaDhoQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nd1jleaH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nd1jleaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418F8C4CECE;
	Thu, 12 Dec 2024 16:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021766;
	bh=SQj51b5sYxOt+OsST4mIHos7uvsAMGa07CC0pO72ep4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nd1jleaHk39v0UnlvvdgKFLRTwkrq3sN6aWVZE2YbYuc0VzFGstD91Wu1V6bVwJSo
	 uwnggxFbH4wVbeRiFXZqVWHR6us3xliV5wUD1lQDv8wuQh4dBFa05ABgK8u9dNlNLS
	 Lp+cFmSv27trgoadOEvKstcpui2Qh+Im8adzYJ5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Si-Wei Liu <si-wei.liu@oracle.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>
Subject: [PATCH 5.15 027/565] vdpa/mlx5: Fix PA offset with unaligned starting iotlb map
Date: Thu, 12 Dec 2024 15:53:42 +0100
Message-ID: <20241212144312.525742019@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Si-Wei Liu <si-wei.liu@oracle.com>

commit 29ce8b8a4fa74e841342c8b8f8941848a3c6f29f upstream.

When calculating the physical address range based on the iotlb and mr
[start,end) ranges, the offset of mr->start relative to map->start
is not taken into account. This leads to some incorrect and duplicate
mappings.

For the case when mr->start < map->start the code is already correct:
the range in [mr->start, map->start) was handled by a different
iteration.

Fixes: 94abbccdf291 ("vdpa/mlx5: Add shared memory registration code")
Cc: stable@vger.kernel.org
Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Message-Id: <20241021134040.975221-2-dtatulea@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/mlx5/core/mr.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -232,7 +232,7 @@ static int map_direct_mr(struct mlx5_vdp
 	struct page *pg;
 	unsigned int nsg;
 	int sglen;
-	u64 pa;
+	u64 pa, offset;
 	u64 paend;
 	struct scatterlist *sg;
 	struct device *dma = mvdev->vdev.dma_dev;
@@ -255,8 +255,10 @@ static int map_direct_mr(struct mlx5_vdp
 	sg = mr->sg_head.sgl;
 	for (map = vhost_iotlb_itree_first(iotlb, mr->start, mr->end - 1);
 	     map; map = vhost_iotlb_itree_next(map, mr->start, mr->end - 1)) {
-		paend = map->addr + maplen(map, mr);
-		for (pa = map->addr; pa < paend; pa += sglen) {
+		offset = mr->start > map->start ? mr->start - map->start : 0;
+		pa = map->addr + offset;
+		paend = map->addr + offset + maplen(map, mr);
+		for (; pa < paend; pa += sglen) {
 			pg = pfn_to_page(__phys_to_pfn(pa));
 			if (!sg) {
 				mlx5_vdpa_warn(mvdev, "sg null. start 0x%llx, end 0x%llx\n",


