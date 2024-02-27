Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B392213B2B8;
	Tue, 27 Feb 2024 14:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043596; cv=none; b=WiLEu7A0LW2N4/axI2BWN9nypmMF858j9rqiOhcb0Un0lUGMTGfwoI/s3jdGU3TyvO/XLfrhU3KoshPSiKu7L13QXoZKbrPcbLlvEO4SFy4juI4HC0XHKxF5/zlTBUejpVS+WRE3fbIY+HclLs8A5LRHq3ZavHfwMnB0UoywoFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043596; c=relaxed/simple;
	bh=XG2vy/wvC6p9cHozqC3L7G4xnqkaX7gEvx2HvMqhWA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jzF07Tx37eJkq5zEvDPEvOlpZ6Fe4moy4P9aRy5WZyWKYN4CCRUTVjdPNKve9WgiOKgzAiofyqoYVJb1txgG4cZwxYGxi6gLpNEg6rvmxzOWoT3WyXpG996XgFGekm3n5GPDPeVmkA1nY/HKz61g16ryrZTLPC7Yon7MS/e5PhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qW3uYKVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qW3uYKVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432A3C433C7;
	Tue, 27 Feb 2024 14:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043596;
	bh=XG2vy/wvC6p9cHozqC3L7G4xnqkaX7gEvx2HvMqhWA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qW3uYKVxeoMmu573k0oJaEXbY7usKor1JqM8TW/bICfRjEjqPsXbMogrtoknz8c32
	 pZmUCf8x3rMq9SRX7X5LvW5YBBRCvrjNPfCUVJXpW5GcaEvEYqGZy3v03XeoZa2MBv
	 Vry1ULrTUdurM2SmEmBtRPd+19otXrHtHP3lDIf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joao Martins <joao.m.martins@oracle.com>,
	Avihai Horon <avihaih@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 137/195] iommufd/iova_bitmap: Bounds check mapped::pages access
Date: Tue, 27 Feb 2024 14:26:38 +0100
Message-ID: <20240227131614.960474056@linuxfoundation.org>
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
index 0f19d502f351b..5b540a164c98f 100644
--- a/drivers/vfio/iova_bitmap.c
+++ b/drivers/vfio/iova_bitmap.c
@@ -405,6 +405,7 @@ void iova_bitmap_set(struct iova_bitmap *bitmap,
 			mapped->pgshift) + mapped->pgoff * BITS_PER_BYTE;
 	unsigned long last_bit = (((iova + length - 1) - mapped->iova) >>
 			mapped->pgshift) + mapped->pgoff * BITS_PER_BYTE;
+	unsigned long last_page_idx = mapped->npages - 1;
 
 	do {
 		unsigned int page_idx = cur_bit / BITS_PER_PAGE;
@@ -413,6 +414,9 @@ void iova_bitmap_set(struct iova_bitmap *bitmap,
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



