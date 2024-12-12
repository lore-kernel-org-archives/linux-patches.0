Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C3F211493;
	Thu, 12 Dec 2024 17:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024312; cv=none; b=L2mrtpIAHwTQ61ATvZ/V1up9OGtIJ76Ozi4TJv4Ipo2MqUbpS2NB6swjlqEIrgYp1yl5N8wq58wyjwZ7IDYSdB/FK3OZWT3W0wzmq/yWZ0z6G/CfljiHPRJSGcVcCmKWCrQiQ6IUGk/tzrrH9xsSNu3/A1RIsXHRFVJXvNq37Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024312; c=relaxed/simple;
	bh=BxSdHezyxRvY2TiJk7vvFahtQebubTiuc5WI6jxQWQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlDkuqNWVuTmf5rUGLb1hQNFLpp83axRnykRFGfaCSXEBMHtY9t6oOCNEBfr5OxTX8il1xg1FmM6qXk8y4A6rZxbQdANeUjV9pA/eMUyQ1uYlzlKEYYfVyupDzINke3burTbC8mD+/zHANtO2a3PuIpoKrt5e30444ov2PR9aH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y3tV/aSa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y3tV/aSa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FB3C4CECE;
	Thu, 12 Dec 2024 17:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024311;
	bh=BxSdHezyxRvY2TiJk7vvFahtQebubTiuc5WI6jxQWQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y3tV/aSa2KJmSHaQ34jV6UzPwFog8427L6UklgUpX9PuCeS1YC3/X+dGnuZ39btFN
	 X2lIeO60vb+ed+Cyf9jy07k1VK7Ygx05/wS/fqBMBBDIMjPVyGkzoF7zIf0X4S/Mne
	 j7iX/9Lp4Pnm158VExmME7nLIPzf379+g3Uf4Vio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Si-Wei Liu <si-wei.liu@oracle.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 214/459] vdpa/mlx5: Fix suboptimal range on iotlb iteration
Date: Thu, 12 Dec 2024 15:59:12 +0100
Message-ID: <20241212144302.024428766@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 48489beb6e0a7..4615f827cd0cb 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -226,7 +226,6 @@ static int map_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr
 	unsigned long lgcd = 0;
 	int log_entity_size;
 	unsigned long size;
-	u64 start = 0;
 	int err;
 	struct page *pg;
 	unsigned int nsg;
@@ -237,10 +236,9 @@ static int map_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr
 	struct device *dma = mvdev->mdev->device;
 
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



