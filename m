Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9C620CCFB;
	Tue, 17 Jun 2025 16:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177454; cv=none; b=awwcpgcqTc0gua8ty4vkk7zLEGmjkZ7FCYhvLKKlbtlNZtpfnGMttH7ERoWYF0EHb4MNbU1AOJjS80J1HrfrokA/VOS+FC1mXYhZCBEwTwFphoMHMidjk6RIWbMJH4Kz3y4anyBW1tWShVOhziUbjcUelJf8KqhJa96B8hZSRzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177454; c=relaxed/simple;
	bh=MldG18YYgjL8IkxqjAzFZd6cXz+bDnJ4bg1Y3TEkwt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIzkD6Zb/ZuU2u1agZX9CDXB2cmue1hi07EsDLXCdNL+j+h0rfx28FTU8Ifj9bHkk2xVmHFd5mn4oJX19m1YBJAahpHiZmxp1hlRTzb7o9ys2BXZVgLmNzuXgr5tmT8XPNiVcsuwtmWcAE/OUwAaYziCVOQsMWFJEc45nssDAe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=owjq/piS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="owjq/piS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5107C4CEE3;
	Tue, 17 Jun 2025 16:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177454;
	bh=MldG18YYgjL8IkxqjAzFZd6cXz+bDnJ4bg1Y3TEkwt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=owjq/piSXSB2Kn0HC6tOnCQnfDNLvM8ofvYO9D61A8FInUcxuemgU/5NTwHmn5PrM
	 rpKXQ/YblFU52khRpWlB6N4GpXazH3uPFYVXxEAAEiLnT8odakh75PRtahDNpOndky
	 DarHTjPtRQH4BI7g0c5CKqZF7QVmXXJU/waMYz8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 309/780] vfio/type1: Fix error unwind in migration dirty bitmap allocation
Date: Tue, 17 Jun 2025 17:20:17 +0200
Message-ID: <20250617152504.047644595@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0ac56072af9f2..ba5d91e576af1 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -293,7 +293,7 @@ static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu, size_t pgsize)
 			struct rb_node *p;
 
 			for (p = rb_prev(n); p; p = rb_prev(p)) {
-				struct vfio_dma *dma = rb_entry(n,
+				struct vfio_dma *dma = rb_entry(p,
 							struct vfio_dma, node);
 
 				vfio_dma_bitmap_free(dma);
-- 
2.39.5



