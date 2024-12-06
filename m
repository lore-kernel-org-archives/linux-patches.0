Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EB620C004;
	Fri,  6 Dec 2024 15:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497875; cv=none; b=LiHjkYl/l7zSDVI4RTctEz+05tS/d5V1NLUnSpqxMsuBtXBRoq2YIqEqQUFlPk6fYhTr6lZLEbl5GtpU2AW5UG9lfgXLs9GOtXefe95A1gKij4otTp7+Y+QvJLuHofsEx2yb2BBKMM4zIldCZ+BcTWC+l9Wg3z45QhbgpxJlh9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497875; c=relaxed/simple;
	bh=F98rUsCAimqMKj4UcodlXk4A1cLvODZh/0gXAmeYXdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQKI1DrZyS0/99pWfPg1pVjG6Fn1/fLxkekgovkIPHT6Gpw6wNQWMaEZjpDqTA3NgBpF7M2yoa4UKU0/b7dKahp06046X+o+Ud2OBNf1SAPCTJb7HMuDGkKh1U4lcIlqnznSukGz1qD8mdk/Zr3e3LvCU+SyvaUifQ4iQf/GnHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YEqAOk4r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YEqAOk4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75020C4CEEE;
	Fri,  6 Dec 2024 15:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497873;
	bh=F98rUsCAimqMKj4UcodlXk4A1cLvODZh/0gXAmeYXdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YEqAOk4rYFsWPyyrVePl9OLsL5tUA6wOAXenrMwl7YWAQw1VHRgmRpMCoD9KzVB2Q
	 sW5fTyWrZjM5TdkomH/5hz/QM1ltGsa4BH1t6a7t9/BITnegV+HktMOxVlG6zerEPz
	 3bo08oH6rVOKLza92wghdlRJ2AaPww8oSZ5YFYns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Si-Wei Liu <si-wei.liu@oracle.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 387/676] vdpa/mlx5: Fix suboptimal range on iotlb iteration
Date: Fri,  6 Dec 2024 15:33:26 +0100
Message-ID: <20241206143708.462635330@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 59fa9f3d5ec87..aa4ab4c847fdc 100644
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



