Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11AF1AB6F8;
	Wed, 20 Nov 2024 13:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107687; cv=none; b=TD23dKzojhfI2MBKN5SpYkvkIbgXHQdfQJHom19CwW95NatW8s/ZZlv/F2lewhe9Tj1Q3x+EYNKSlV0UI7tP7Wk0fqr+zLLYYcEeNyftRYE9PtmUC6BWFE4+8LpPjbwaxpxr1WOBAJp5OzyFo651XoNleO0dlQbBi7xk95Ba404=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107687; c=relaxed/simple;
	bh=7gYsEI4+5DOEKtkKY8w6W6Z+cVMoXR7hstHGwwxtisg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYF5sHUuRmmgst9fjBHAz/EFVLN6z4P+1i2Vx5K1/E5mzBkd0a3a/TZsdjp1z3QRB7BTL09Nau208xt5iStLMyn/rYMQc6llz1zPtRwf3nlSq930zj7Lq9VfnRQnqiICXBOYrQLOvLI7cF6IEdlDR4n6KJQmMo1jtP4ZhUs7buo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LbPMC3RX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LbPMC3RX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7E8C4CECD;
	Wed, 20 Nov 2024 13:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107687;
	bh=7gYsEI4+5DOEKtkKY8w6W6Z+cVMoXR7hstHGwwxtisg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LbPMC3RXvPrkI36NO05Exq8rf+euGCRDT9Dz49unTbQMI5oBk7ksgKHE5J9nJTlyc
	 GlAXRiqf1ck8PSEs9dKsofzZFXADf8Z/PMGMTL0KV/T5yswA2Vh3V6xGZKqS/9GGDz
	 nZWFIqZYHHmWHzcFDljM+ic4m2oQNyjdHwTlKdDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Si-Wei Liu <si-wei.liu@oracle.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>
Subject: [PATCH 6.1 19/73] vdpa/mlx5: Fix PA offset with unaligned starting iotlb map
Date: Wed, 20 Nov 2024 13:58:05 +0100
Message-ID: <20241120125810.080744391@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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


