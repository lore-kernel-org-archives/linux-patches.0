Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0683F2628C;
	Mon, 23 Jun 2025 21:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713361; cv=none; b=gp/rBP7K9/BuQXTvEFzWxhAxBGR6HvEa2BIqshG3yvSsMAaY9IuCJIyZZmR5ZgojPuh6vjf+NuiBO++fcK1kgzBOHnFZOM+U9senHZLuhXPoyPxnJzGCWXQXCf+ORmAKg0Wj0ZU3MVz3w8ynBejTxX2lBe6xn7sNW4f7We+gWyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713361; c=relaxed/simple;
	bh=hQTFpyCcnptHsbqDaTG0LES4YhcjNCx5KpmXGMQqL9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7ry0/X3eDu+o0uTbaY/fgwjorhzJ+ECQGXWTklRKAdS2ljun0fnSM5GH7xasoXICA8kkpBdInflCWP26IOuOV58jDK7jOx6bTdrdYUy0RJTtfybS54DrFmQxjBmDfSTX81RlIYeWQcjtoiGbfCswhNzUh2Cp9KUt1SSNwqHlOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A4vk5/+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A4vk5/+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC31C4CEEA;
	Mon, 23 Jun 2025 21:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713360;
	bh=hQTFpyCcnptHsbqDaTG0LES4YhcjNCx5KpmXGMQqL9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A4vk5/+zT61hfqmIf59Pe1/+pIyPoIRWeQ2mAm0i2IweqAWouBavESwQTyU0zFce6
	 hrXOk+UBUioTwHvs4o0KduCgEOlNbM4ub8iM2o44HE7VRO7Feqz9LGAB2v6mUi/NLT
	 RVDh212Ml/QXT6QqgvbhLtLatk6QoPNWQ2W9/Xm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/508] vfio/type1: Fix error unwind in migration dirty bitmap allocation
Date: Mon, 23 Jun 2025 15:02:17 +0200
Message-ID: <20250623130647.519560294@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 4518e5a60c7fbf0cdff393c2681db39d77b4f87e ]

When setting up dirty page tracking at the vfio IOMMU backend for
device migration, if an error is encountered allocating a tracking
bitmap, the unwind loop fails to free previously allocated tracking
bitmaps.  This occurs because the wrong loop index is used to
generate the tracking object.  This results in unintended memory
usage for the life of the current DMA mappings where bitmaps were
successfully allocated.

Use the correct loop index to derive the tracking object for
freeing during unwind.

Fixes: d6a4c185660c ("vfio iommu: Implementation of ioctl for dirty pages tracking")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://lore.kernel.org/r/20250521034647.2877-1-lirongqing@baidu.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio_iommu_type1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 18a2dbbc77799..26fac124231f5 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -299,7 +299,7 @@ static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu, size_t pgsize)
 			struct rb_node *p;
 
 			for (p = rb_prev(n); p; p = rb_prev(p)) {
-				struct vfio_dma *dma = rb_entry(n,
+				struct vfio_dma *dma = rb_entry(p,
 							struct vfio_dma, node);
 
 				vfio_dma_bitmap_free(dma);
-- 
2.39.5



