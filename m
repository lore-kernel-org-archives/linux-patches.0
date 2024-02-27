Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08FC13AA50;
	Tue, 27 Feb 2024 13:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041215; cv=none; b=h5voe2gylNzOjYBURPh8mdbefKTZJfsJxUlQhQg/Cw4PusOJSiR6ziR3/SKU4X7Wni8+PUmezXvNitSALNRjcRgC2uJvESECddvp4caLJXb5H+vE3yc+i6UtB1ECanzeDC7AkbFa/U6xOwbWREnNrNLwicc/DITYt74IRkyYp20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041215; c=relaxed/simple;
	bh=GwSB29VyHojcvQqBIo4oM5s9fuzt6TPPdM5J+WOEfDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rWX+pDx16HTWp710+X4JP7lIbShrAd2iatXWxd3txjkEOx9p03JsuvC+hHcJmGrKYG88PZIsD2Afpk7odWfcduuAlil9iJtltPh0rvzDy64hJx9BXyLEI2OLdIp3OE+E9dCJYcPAy58GoXmMmbQjbP1fAarBAUtWxaplY3Jp6Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=owzp3rtS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="owzp3rtS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5E9C433C7;
	Tue, 27 Feb 2024 13:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041214;
	bh=GwSB29VyHojcvQqBIo4oM5s9fuzt6TPPdM5J+WOEfDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=owzp3rtSl5lmtvRn25S3ZsN2L+ybjlL0IUJ4wm5bacWGKadrYqsdbiKn7yAOeqa3K
	 lV+sV0vcLyiKibNct93Mq1ZymtFUcdJ+0Ar7GEo62Dt2Dnl9U9mUzYPv5kFlGR8HTo
	 EIcyk+ziVM9dqbJHuqj03xEQhEz9yOgwdwVYdE4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joao Martins <joao.m.martins@oracle.com>,
	Avihai Horon <avihaih@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 244/334] iommufd/iova_bitmap: Bounds check mapped::pages access
Date: Tue, 27 Feb 2024 14:21:42 +0100
Message-ID: <20240227131638.749206398@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joao Martins <joao.m.martins@oracle.com>

[ Upstream commit a4ab7dedaee0e39b15653c5fd0367e420739f7ef ]

Dirty IOMMU hugepages reported on a base page page-size granularity can
lead to an attempt to set dirty pages in the bitmap beyond the limits that
are pinned.

Bounds check the page index of the array we are trying to access is within
the limits before we kmap() and return otherwise.

While it is also a defensive check, this is also in preparation to defer
setting bits (outside the mapped range) to the next iteration(s) when the
pages become available.

Fixes: b058ea3ab5af ("vfio/iova_bitmap: refactor iova_bitmap_set() to better handle page boundaries")
Link: https://lore.kernel.org/r/20240202133415.23819-2-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Tested-by: Avihai Horon <avihaih@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/iova_bitmap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/iommu/iommufd/iova_bitmap.c b/drivers/iommu/iommufd/iova_bitmap.c
index 0a92c9eeaf7f5..a3606b4c22292 100644
--- a/drivers/iommu/iommufd/iova_bitmap.c
+++ b/drivers/iommu/iommufd/iova_bitmap.c
@@ -409,6 +409,7 @@ void iova_bitmap_set(struct iova_bitmap *bitmap,
 			mapped->pgshift) + mapped->pgoff * BITS_PER_BYTE;
 	unsigned long last_bit = (((iova + length - 1) - mapped->iova) >>
 			mapped->pgshift) + mapped->pgoff * BITS_PER_BYTE;
+	unsigned long last_page_idx = mapped->npages - 1;
 
 	do {
 		unsigned int page_idx = cur_bit / BITS_PER_PAGE;
@@ -417,6 +418,9 @@ void iova_bitmap_set(struct iova_bitmap *bitmap,
 					 last_bit - cur_bit + 1);
 		void *kaddr;
 
+		if (unlikely(page_idx > last_page_idx))
+			break;
+
 		kaddr = kmap_local_page(mapped->pages[page_idx]);
 		bitmap_set(kaddr, offset, nbits);
 		kunmap_local(kaddr);
-- 
2.43.0



