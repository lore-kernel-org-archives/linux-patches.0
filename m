Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DF62080FC;
	Thu, 12 Dec 2024 15:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017042; cv=none; b=tOxKZHaQNPlV9jn2qmFprcdA89v+paNbeM5gbCKcA33K8UrF7FX9FzBsaGvqPGPzrzoMwTK118g6ru8zg4iKUU4aRZxDO/hnMJWVCI684xq/AdzWVaU+hR6NM+yibwNb+9+3GvmfnAAvd7UPmnSJNRSmKx3eQzHkXf2zNtKJhmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017042; c=relaxed/simple;
	bh=iGoN12MLWWHpGBrnP6UmWIMeJKC5IftWuosEudDSjz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqcethZXX0BDVU0PLJ9x6G5H9gQzOCNgT1UV+VWLy/+42iur5sZut88/Fa0R/M9v3FWTCzXoGTcqK1LQ74cxNf0+0paPLtZnc0/0tTfAFSaHJXSjeUUDYfVRHQCDZ866I1r1UPspr3kSHTd5UDhln1rChY4ZfYxTlOWFjEIykho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H0W92gGH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H0W92gGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91502C4CECE;
	Thu, 12 Dec 2024 15:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017042;
	bh=iGoN12MLWWHpGBrnP6UmWIMeJKC5IftWuosEudDSjz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H0W92gGHJ8cVKbCVRWVQwNsd4SqQjd8EmwJvMzMcMahil8yDK9/qR8sX9bZrcIZVc
	 pN+OTtMRh0FBUXrc4qM4p7gwf6z+N7oGFgaBEXRRJxoZbtlvUJrIRSj0kXA57JH7I/
	 OQZVzjxAzpfGqjFMn87vVnTPxQvVHxH/BVg7WGCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 366/466] iommu/amd: Fix corruption when mapping large pages from 0
Date: Thu, 12 Dec 2024 15:58:55 +0100
Message-ID: <20241212144321.237726470@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit e3a682eaf2af51a83f5313145ef592ce50fa787f ]

If a page is mapped starting at 0 that is equal to or larger than can fit
in the current mode (number of table levels) it results in corrupting the
mapping as the following logic assumes the mode is correct for the page
size being requested.

There are two issues here, the check if the address fits within the table
uses the start address, it should use the last address to ensure that last
byte of the mapping fits within the current table mode.

The second is if the mapping is exactly the size of the full page table it
has to add another level to instead hold a single IOPTE for the large
size.

Since both corner cases require a 0 IOVA to be hit and doesn't start until
a page size of 2^48 it is unlikely to ever hit in a real system.

Reported-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/0-v1-27ab08d646a1+29-amd_0map_jgg@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/io_pgtable.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 804b788f3f167..f3399087859fd 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -118,6 +118,7 @@ static void free_sub_pt(u64 *root, int mode, struct list_head *freelist)
  */
 static bool increase_address_space(struct amd_io_pgtable *pgtable,
 				   unsigned long address,
+				   unsigned int page_size_level,
 				   gfp_t gfp)
 {
 	struct io_pgtable_cfg *cfg = &pgtable->pgtbl.cfg;
@@ -133,7 +134,8 @@ static bool increase_address_space(struct amd_io_pgtable *pgtable,
 
 	spin_lock_irqsave(&domain->lock, flags);
 
-	if (address <= PM_LEVEL_SIZE(pgtable->mode))
+	if (address <= PM_LEVEL_SIZE(pgtable->mode) &&
+	    pgtable->mode - 1 >= page_size_level)
 		goto out;
 
 	ret = false;
@@ -163,18 +165,21 @@ static u64 *alloc_pte(struct amd_io_pgtable *pgtable,
 		      gfp_t gfp,
 		      bool *updated)
 {
+	unsigned long last_addr = address + (page_size - 1);
 	struct io_pgtable_cfg *cfg = &pgtable->pgtbl.cfg;
 	int level, end_lvl;
 	u64 *pte, *page;
 
 	BUG_ON(!is_power_of_2(page_size));
 
-	while (address > PM_LEVEL_SIZE(pgtable->mode)) {
+	while (last_addr > PM_LEVEL_SIZE(pgtable->mode) ||
+	       pgtable->mode - 1 < PAGE_SIZE_LEVEL(page_size)) {
 		/*
 		 * Return an error if there is no memory to update the
 		 * page-table.
 		 */
-		if (!increase_address_space(pgtable, address, gfp))
+		if (!increase_address_space(pgtable, last_addr,
+					    PAGE_SIZE_LEVEL(page_size), gfp))
 			return NULL;
 	}
 
-- 
2.43.0



