Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F47F229690;
	Thu, 12 Dec 2024 16:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022538; cv=none; b=Enxyi73QlH8GD/vLbG7awwWNbP4uJq/+vpmlmVxsq7iZhS733bam0x3ccVwPgHLblAQeGIv2lcgl1UtEbvYizwPRzkr8i1jZWfcIoeIDfL5NDcmGxdbBCo5fXbVeLIoH5J8e4IMLcFtyuA7CgDghjQex08hDHFwGmUTQbBbFPWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022538; c=relaxed/simple;
	bh=xP4rYi+Z2R4DTcec58hHdZb+HY8q1uWHt+uifxx7Vl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fb07srTEIRgvfPmoLqtCypIM/LOh+iLY7TJMgk+F/5XmgmdTaGN7tSrwMe+85YPBP/10N4c2XW1rrFrJ3o+xDaWzEa8B69nmcKmbnEfyszXpOSelKgMoEG4N0I1VpcnZtPGEVrH8vORftOb3kFkAoBgZApnP5bmtZYVPshF6eN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lUEMpTRd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lUEMpTRd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3A0C4CEDF;
	Thu, 12 Dec 2024 16:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022537;
	bh=xP4rYi+Z2R4DTcec58hHdZb+HY8q1uWHt+uifxx7Vl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lUEMpTRdBKIV11L7zxCAntfRrlZ8x9tkkFnJmDFXsoVdzQ8Q1ypT433yLQJ6Caba3
	 3/GprldvIV/qOzK1fuw64PwUiXv6XynHaEkqxg0yhyHpybMLWJsZ5bQynVrXW3HdPM
	 rNJnxogYPJLz3gO+3iP4YFRHh+4t1edG376/xDco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Si-Wei Liu <si-wei.liu@oracle.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 269/565] vdpa/mlx5: Fix suboptimal range on iotlb iteration
Date: Thu, 12 Dec 2024 15:57:44 +0100
Message-ID: <20241212144322.099661567@linuxfoundation.org>
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
index 8b21f564678c9..32ce1a6aae0d2 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -227,7 +227,6 @@ static int map_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr
 	unsigned long lgcd = 0;
 	int log_entity_size;
 	unsigned long size;
-	u64 start = 0;
 	int err;
 	struct page *pg;
 	unsigned int nsg;
@@ -238,10 +237,9 @@ static int map_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr
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



