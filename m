Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776852F2C6C;
	Tue, 17 Jun 2025 15:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175042; cv=none; b=GVg/PPd0QZ23xDRxGs541YiD3Kz0YP2UIq64WmH605dA1bD45eQvdVeOQtOk35Wn9PI+gsdwi+qnBLh8l02Q4ATwm8K9nTAziaenuSkttK+hCS0D2Wt7+txoJHy+zMwS+oGU/1t56F0do3B/EhbHcTLr89tBBwESu8X+NKdIwuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175042; c=relaxed/simple;
	bh=TIFh533UVKSpw+EFnSZRWCeB06UJj5tcGiiEwKFO9JM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hrK0Jt4w5qjJLsHuO2Ib5mn6KifcYdbMHcwGEZJlXcrcUIMHl6vOUThM0qbnC2zx7WPTHuA7jcwrSJNdeWPKBT/mAf9p/KB+Nzk2m+Zdx3Zk8sN3XJ/Au8KLU6p9YH7srad1/XAXJQOpNfSo8gGiu+1WmWRx1HhTZ3L+AmGDRpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c8HKS8e1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c8HKS8e1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC21C4CEF0;
	Tue, 17 Jun 2025 15:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175042;
	bh=TIFh533UVKSpw+EFnSZRWCeB06UJj5tcGiiEwKFO9JM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c8HKS8e1A7TY8FDpI5VC048u19nndmc/v5oiED1j2NE5YGQWg4FRTtnLQdBLrN/Fr
	 AYw27k+m7D8eS9drwHmFBWQCdEolYWfw+opOK2j+CqmLcaj3nVrUxSX3SMrXnSF4Yo
	 yFTZ467Iq5lVmuYbAfDEsmKatbqXW76nRXxh8Xp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 138/356] vfio/type1: Fix error unwind in migration dirty bitmap allocation
Date: Tue, 17 Jun 2025 17:24:13 +0200
Message-ID: <20250617152343.786814540@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index eacd6ec04de5a..5fe7aed3672ee 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -294,7 +294,7 @@ static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu, size_t pgsize)
 			struct rb_node *p;
 
 			for (p = rb_prev(n); p; p = rb_prev(p)) {
-				struct vfio_dma *dma = rb_entry(n,
+				struct vfio_dma *dma = rb_entry(p,
 							struct vfio_dma, node);
 
 				vfio_dma_bitmap_free(dma);
-- 
2.39.5



