Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A01140391;
	Tue, 27 Feb 2024 14:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043599; cv=none; b=FcxyYY7KRvSvhR85L5hsgLbeddEkPrPir+xppQCanv6NzQDeNwqTe1VKVFEz+WNs3mSuvtsnMNbjKAnHE6eWzrCf/d/Wh3PDVYFypwki+ILdnD4OEeVhNFCHdGkDig9rasjdZ0qbgmQuxrrAZfnhfZZcwqrMzp3LWNoH+3ieShI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043599; c=relaxed/simple;
	bh=hpNSePuvY15S0a96m7rf4IP/jyjZFcrr7DctFsxY5Ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6gQN/sOb9M6o0TT5T4yoystUw/vwJpVGwRixMsP92RSQ1eSCaktLsdcmB/XYZgrOq9Y2ZBL4gEWSCgj8pnDVJUc8I/zPpXeCdJOywYHOBJ2w2P3BAFrO0+BehQUDjEmVgjvs3pYgm0h8L9owF/dwNP5+1ZPW/AeIjoBFMaG3mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0whwnCAb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0whwnCAb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03349C433C7;
	Tue, 27 Feb 2024 14:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043599;
	bh=hpNSePuvY15S0a96m7rf4IP/jyjZFcrr7DctFsxY5Ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0whwnCAbHLvlqZRtvICGEqyQtdIzoCQxnn/oG5xHKQ5PrpFjL3zW82n4iNueQr/sw
	 iI46VKCGeVePcubJqNtfcDXp2Ua2e/SXSLV4S9LzyEtFG5rhbmpIQG5sGFnMBv6gZq
	 f3lidA0rf/0v6cCuEdOiEbsCMFg2Z+Vw059FGJSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joao Martins <joao.m.martins@oracle.com>,
	Avihai Horon <avihaih@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 138/195] iommufd/iova_bitmap: Switch iova_bitmap::bitmap to an u8 array
Date: Tue, 27 Feb 2024 14:26:39 +0100
Message-ID: <20240227131614.991744986@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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
index 5b540a164c98f..c748a1e3ba53a 100644
--- a/drivers/vfio/iova_bitmap.c
+++ b/drivers/vfio/iova_bitmap.c
@@ -99,7 +99,7 @@ struct iova_bitmap {
 	struct iova_bitmap_map mapped;
 
 	/* userspace address of the bitmap */
-	u64 __user *bitmap;
+	u8 __user *bitmap;
 
 	/* u64 index that @mapped points to */
 	unsigned long mapped_base_index;
@@ -161,7 +161,7 @@ static int iova_bitmap_get(struct iova_bitmap *bitmap)
 {
 	struct iova_bitmap_map *mapped = &bitmap->mapped;
 	unsigned long npages;
-	u64 __user *addr;
+	u8 __user *addr;
 	long ret;
 
 	/*
@@ -246,7 +246,7 @@ struct iova_bitmap *iova_bitmap_alloc(unsigned long iova, size_t length,
 
 	mapped = &bitmap->mapped;
 	mapped->pgshift = __ffs(page_size);
-	bitmap->bitmap = data;
+	bitmap->bitmap = (u8 __user *)data;
 	bitmap->mapped_total_index =
 		iova_bitmap_offset_to_index(bitmap, length - 1) + 1;
 	bitmap->iova = iova;
@@ -301,7 +301,7 @@ static unsigned long iova_bitmap_mapped_remaining(struct iova_bitmap *bitmap)
 
 	remaining = bitmap->mapped_total_index - bitmap->mapped_base_index;
 	remaining = min_t(unsigned long, remaining,
-			  bytes / sizeof(*bitmap->bitmap));
+			  DIV_ROUND_UP(bytes, sizeof(*bitmap->bitmap)));
 
 	return remaining;
 }
-- 
2.43.0



