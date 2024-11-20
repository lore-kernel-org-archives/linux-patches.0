Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0EC1AB53F;
	Wed, 20 Nov 2024 12:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107520; cv=none; b=RYO8uh/BLV6hlmkOVwT83gVyNcSd5677Mx6nGYz9Ll/W/qXwFa4Zld20JM8dcQ+gvGk7YQk9jbM6G7BAjPnBy5qrkmG2XKEpmlraIHJ59s8C86nYVCE3G4sin3RM47NDfhFRyHA8yJjwF3Sw9FXHj6yCCv9CxKPsqxLVYI5H2u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107520; c=relaxed/simple;
	bh=TRDuHAZJEtQGtkeVGaeeZoCOeCyopJyJB9hSXTj6niU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUtEa5qmvvTTiAco00/52B2Pgc30GPSU2QsbHr6gl5edG/ra2f+xh9vicx/1Yvmfc4lvQxJm3fIQBNXpKv3Y2WFAJpj/9Lwjs4nXB2fq9IPcWMbROlamLUbE5bz5YABiKEb9uO6DpON3d1XlGRl8sKTepPDoG8tRJEwM5SsDLaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P14EG1I3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P14EG1I3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FC0C4CED6;
	Wed, 20 Nov 2024 12:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107520;
	bh=TRDuHAZJEtQGtkeVGaeeZoCOeCyopJyJB9hSXTj6niU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P14EG1I34pnAKHihw2xoQgsVKoGh+JrZt66vc5FaspjdI0IV8N2VHZozVLVXlC3Hi
	 tthG0bVh7+CaCeRw2iZlxbLkmg8PCinoThI7ddlNliWrA4kYH8j6oZ0gSed4VSCArV
	 lUt5NmXnS34oag4NGxgmEDlWvforPZ5XN7PL3vGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Si-Wei Liu <si-wei.liu@oracle.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>
Subject: [PATCH 6.11 050/107] vdpa/mlx5: Fix PA offset with unaligned starting iotlb map
Date: Wed, 20 Nov 2024 13:56:25 +0100
Message-ID: <20241120125630.804203227@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


