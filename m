Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855A7364A8
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0f2xGNhC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30ED3C433C9;
	Wed, 15 Nov 2023 19:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076591;
	bh=o7mAkOFgRGHG2VukXwztSVInYoB7QXewpyVweqaRKHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0f2xGNhCQVWXpmfCc/iYPC6MtYqNTMQ8qCGPRZ+ID2ll6yQQkDG5mc01lDdvZmngS
	 KTSuDdT4Rn+hLvP8ikVj0llvzfhB+jhTpL6SRicci2rLDqTGdYN/Ujfl9YI++v14k8
	 63WA5r9gJDRFRtaa/ms+3tltyaqJbPaQiDvGPAqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 303/550] iommufd: Add iopt_area_alloc()
Date: Wed, 15 Nov 2023 14:14:47 -0500
Message-ID: <20231115191621.814083188@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 361d744ddd61de065fbeb042aaed590d32dd92ec ]

We never initialize the two interval tree nodes, and zero fill is not the
same as RB_CLEAR_NODE. This can hide issues where we missed adding the
area to the trees. Factor out the allocation and clear the two nodes.

Fixes: 51fe6141f0f6 ("iommufd: Data structure to provide IOVA to PFN mapping")
Link: https://lore.kernel.org/r/20231030145035.GG691768@ziepe.ca
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/io_pagetable.c | 18 +++++++++++++++---
 drivers/iommu/iommufd/pages.c        |  2 ++
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index 724c4c5742417..9b3935042459e 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -221,6 +221,18 @@ static int iopt_insert_area(struct io_pagetable *iopt, struct iopt_area *area,
 	return 0;
 }
 
+static struct iopt_area *iopt_area_alloc(void)
+{
+	struct iopt_area *area;
+
+	area = kzalloc(sizeof(*area), GFP_KERNEL_ACCOUNT);
+	if (!area)
+		return NULL;
+	RB_CLEAR_NODE(&area->node.rb);
+	RB_CLEAR_NODE(&area->pages_node.rb);
+	return area;
+}
+
 static int iopt_alloc_area_pages(struct io_pagetable *iopt,
 				 struct list_head *pages_list,
 				 unsigned long length, unsigned long *dst_iova,
@@ -231,7 +243,7 @@ static int iopt_alloc_area_pages(struct io_pagetable *iopt,
 	int rc = 0;
 
 	list_for_each_entry(elm, pages_list, next) {
-		elm->area = kzalloc(sizeof(*elm->area), GFP_KERNEL_ACCOUNT);
+		elm->area = iopt_area_alloc();
 		if (!elm->area)
 			return -ENOMEM;
 	}
@@ -1005,11 +1017,11 @@ static int iopt_area_split(struct iopt_area *area, unsigned long iova)
 	    iopt_area_start_byte(area, new_start) & (alignment - 1))
 		return -EINVAL;
 
-	lhs = kzalloc(sizeof(*area), GFP_KERNEL_ACCOUNT);
+	lhs = iopt_area_alloc();
 	if (!lhs)
 		return -ENOMEM;
 
-	rhs = kzalloc(sizeof(*area), GFP_KERNEL_ACCOUNT);
+	rhs = iopt_area_alloc();
 	if (!rhs) {
 		rc = -ENOMEM;
 		goto err_free_lhs;
diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index 8d9aa297c117e..528f356238b34 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -1507,6 +1507,8 @@ void iopt_area_unfill_domains(struct iopt_area *area, struct iopt_pages *pages)
 				area, domain, iopt_area_index(area),
 				iopt_area_last_index(area));
 
+	if (IS_ENABLED(CONFIG_IOMMUFD_TEST))
+		WARN_ON(RB_EMPTY_NODE(&area->pages_node.rb));
 	interval_tree_remove(&area->pages_node, &pages->domains_itree);
 	iopt_area_unfill_domain(area, pages, area->storage_domain);
 	area->storage_domain = NULL;
-- 
2.42.0



