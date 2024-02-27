Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F3413F007;
	Tue, 27 Feb 2024 13:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042228; cv=none; b=dkEU8m0VkGl+CjfxWsln/Lz66ztsns6pFoFFCipz3iBnh1BKKFnNylMZQn2keenIERLmECjhOVRfh79Zzh6V9uB3JjEhUDv0DIvO8qBGB0V9zTOnd1JBSRSXxbxHcYa4WVHXKBcbgEQmn+QkHD3rmAxbzd8CndlJ4EbcK+ngtDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042228; c=relaxed/simple;
	bh=PHBpo3aQz7r+ccAEmJgNMkwTiIDX5Jm3lJeC78tlQv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BmiXSxWGI3Ju89w4G3C/09nYyEIo7rYBThJWHWMZL4iplMBo+6v5XjFTPIlmFRTp7kMCTrHdb+ndV68/q9f5OMit29gm24cvJ8h2wfzjTTb7IByLDR/FYfrCtl1LQuDRkADIduTFvovN2BoG9js184nYLcpnQD0Kk5lsnDifygg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eSuBcnQp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eSuBcnQp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A987C433C7;
	Tue, 27 Feb 2024 13:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042228;
	bh=PHBpo3aQz7r+ccAEmJgNMkwTiIDX5Jm3lJeC78tlQv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eSuBcnQp10cQodksWQmRzTI/Y8x66AN4qF+XZ+Scazv1L33LC4cIK1AVJoqaVZhdw
	 KWA46KAzo/KdfgOdoLty6aAP/W4sPOeDZzYzy7axo7KTv6FWPnp3Ai4BJPxBcX18jg
	 EKfgfeYLC0HQalXyu1KKpYMdvauVBsvU/kPBvPAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joao Martins <joao.m.martins@oracle.com>,
	Avihai Horon <avihaih@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 224/299] iommufd/iova_bitmap: Switch iova_bitmap::bitmap to an u8 array
Date: Tue, 27 Feb 2024 14:25:35 +0100
Message-ID: <20240227131632.969425697@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Joao Martins <joao.m.martins@oracle.com>

[ Upstream commit d18411ec305728c6371806c4fb09be07016aad0b ]

iova_bitmap_mapped_length() don't deal correctly with the small bitmaps
(< 2M bitmaps) when the starting address isn't u64 aligned, leading to
skipping a tiny part of the IOVA range. This is materialized as not
marking data dirty that should otherwise have been.

Fix that by using a u8 * in the internal state of IOVA bitmap. Most of the
data structures use the type of the bitmap to adjust its indexes, thus
changing the type of the bitmap decreases the granularity of the bitmap
indexes.

Fixes: b058ea3ab5af ("vfio/iova_bitmap: refactor iova_bitmap_set() to better handle page boundaries")
Link: https://lore.kernel.org/r/20240202133415.23819-3-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Tested-by: Avihai Horon <avihaih@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/iova_bitmap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/iova_bitmap.c b/drivers/vfio/iova_bitmap.c
index 997134a24c025..26ad0912cfea4 100644
--- a/drivers/vfio/iova_bitmap.c
+++ b/drivers/vfio/iova_bitmap.c
@@ -100,7 +100,7 @@ struct iova_bitmap {
 	struct iova_bitmap_map mapped;
 
 	/* userspace address of the bitmap */
-	u64 __user *bitmap;
+	u8 __user *bitmap;
 
 	/* u64 index that @mapped points to */
 	unsigned long mapped_base_index;
@@ -162,7 +162,7 @@ static int iova_bitmap_get(struct iova_bitmap *bitmap)
 {
 	struct iova_bitmap_map *mapped = &bitmap->mapped;
 	unsigned long npages;
-	u64 __user *addr;
+	u8 __user *addr;
 	long ret;
 
 	/*
@@ -247,7 +247,7 @@ struct iova_bitmap *iova_bitmap_alloc(unsigned long iova, size_t length,
 
 	mapped = &bitmap->mapped;
 	mapped->pgshift = __ffs(page_size);
-	bitmap->bitmap = data;
+	bitmap->bitmap = (u8 __user *)data;
 	bitmap->mapped_total_index =
 		iova_bitmap_offset_to_index(bitmap, length - 1) + 1;
 	bitmap->iova = iova;
@@ -302,7 +302,7 @@ static unsigned long iova_bitmap_mapped_remaining(struct iova_bitmap *bitmap)
 
 	remaining = bitmap->mapped_total_index - bitmap->mapped_base_index;
 	remaining = min_t(unsigned long, remaining,
-			  bytes / sizeof(*bitmap->bitmap));
+			  DIV_ROUND_UP(bytes, sizeof(*bitmap->bitmap)));
 
 	return remaining;
 }
-- 
2.43.0



