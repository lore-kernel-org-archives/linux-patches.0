Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9548E47791;
	Mon,  8 Jan 2024 15:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1EPPs5M+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F9EC433C9;
	Mon,  8 Jan 2024 15:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726850;
	bh=YluVniGv/PTTKe9dtMK+7xUmXOTHxh+cez6UBRQaaew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1EPPs5M+aGlYG8GWfc2h8+ebRL6x7PENPtfPpKHVO0jucNsSFlgYRUsuBc4u2k3oz
	 d49cHZv5MHdtiiByJp3tzMhOudmz/WTOSnzmsGVtgePB7WuVHN5iELk3olO2keRW78
	 UNp47j4HKvVpMwap9d3fVQa7dKGO4ThfwvxsiXGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmytro Adamenko <dmytro.adamenko@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 099/124] kernel/resource: Increment by align value in get_free_mem_region()
Date: Mon,  8 Jan 2024 16:08:45 +0100
Message-ID: <20240108150607.528720157@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

From: Alison Schofield <alison.schofield@intel.com>

[ Upstream commit 659aa050a53817157b7459529538598a6449c1d3 ]

Currently get_free_mem_region() searches for available capacity
in increments equal to the region size being requested. This can
cause the search to take giant steps through the resource leaving
needless gaps and missing available space.

Specifically 'cxl create-region' fails with ERANGE even though capacity
of the given size and CXL's expected 256M x InterleaveWays alignment can
be satisfied.

Replace the total-request-size increment with a next alignment increment
so that the next possible address is always examined for availability.

Fixes: 14b80582c43e ("resource: Introduce alloc_free_mem_region()")
Reported-by: Dmytro Adamenko <dmytro.adamenko@intel.com>
Reported-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20231113221324.1118092-1-alison.schofield@intel.com
Cc: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/resource.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index b1763b2fd7ef3..e3f5680a564cf 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1847,8 +1847,8 @@ get_free_mem_region(struct device *dev, struct resource *base,
 
 	write_lock(&resource_lock);
 	for (addr = gfr_start(base, size, align, flags);
-	     gfr_continue(base, addr, size, flags);
-	     addr = gfr_next(addr, size, flags)) {
+	     gfr_continue(base, addr, align, flags);
+	     addr = gfr_next(addr, align, flags)) {
 		if (__region_intersects(base, addr, size, 0, IORES_DESC_NONE) !=
 		    REGION_DISJOINT)
 			continue;
-- 
2.43.0



