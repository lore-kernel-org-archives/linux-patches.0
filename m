Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC4954BD4;
	Tue, 27 Feb 2024 13:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042226; cv=none; b=qbPeEMKOHlexeGmvsotYmIm/iCECQChzby9ZNSlkDqx84wW4ug60OObnIU8tTyVUaquGXWC01J3cJiGdrUXuXaddy+NQgpdFEwN70voRUZS4aamZZVMK3nEd51Z0Q+Dv/DeVzD3RHUxmq0N2YfV+WaXUlqaSzxEo0UL01acJhvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042226; c=relaxed/simple;
	bh=MQlifOGa5JfunQ5wcmyFAJ+0SftqrH8emq1znIpci+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=noX17pu+hcjFs5eb1/HQhzk7LztRvecV3df2mU0Uskh2/zcCyek0cicxhf5iVS4TOpbekavi/aDQk57zOdnb438ydfqVAodFThtu7wE7RPBCTLHxsXzGMqcX+uDnmOZEixDgQytNGoeHLsWDR5eIqh7GHtMsIp1oEhXdW4WITXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LnefQSe1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LnefQSe1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666B7C433C7;
	Tue, 27 Feb 2024 13:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042225;
	bh=MQlifOGa5JfunQ5wcmyFAJ+0SftqrH8emq1znIpci+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LnefQSe1dp8WyPHxw/UD7L/asPHqXQwbiM/I0zNh9n1nz26jk4Nyc1KbCElcHUnZO
	 Lq5QlQoZ2riIXDbYVrrO0PHZsFc4QNSbtQ0BDBfDAQvlMuNnN2CMOARqDfawmG75GX
	 ZvfpLeOKTN2iFEqiG32kc5nGEfJK2pYp1kaErwcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joao Martins <joao.m.martins@oracle.com>,
	Avihai Horon <avihaih@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 223/299] iommufd/iova_bitmap: Bounds check mapped::pages access
Date: Tue, 27 Feb 2024 14:25:34 +0100
Message-ID: <20240227131632.939756745@linuxfoundation.org>
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
 drivers/vfio/iova_bitmap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/vfio/iova_bitmap.c b/drivers/vfio/iova_bitmap.c
index 0848f920efb7c..997134a24c025 100644
--- a/drivers/vfio/iova_bitmap.c
+++ b/drivers/vfio/iova_bitmap.c
@@ -406,6 +406,7 @@ void iova_bitmap_set(struct iova_bitmap *bitmap,
 			mapped->pgshift) + mapped->pgoff * BITS_PER_BYTE;
 	unsigned long last_bit = (((iova + length - 1) - mapped->iova) >>
 			mapped->pgshift) + mapped->pgoff * BITS_PER_BYTE;
+	unsigned long last_page_idx = mapped->npages - 1;
 
 	do {
 		unsigned int page_idx = cur_bit / BITS_PER_PAGE;
@@ -414,6 +415,9 @@ void iova_bitmap_set(struct iova_bitmap *bitmap,
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



