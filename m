Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5A91A5A4;
	Fri, 24 Nov 2023 18:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P515aNdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487CDC433C9;
	Fri, 24 Nov 2023 18:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850965;
	bh=WCAXu3pHUwT66qwx+dJpQT9DhkTcC/rEc6FKF74NHg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P515aNddvOIkkTi5bMvBrgdRDLWCUwH0ksOF/XcJ1+DSVAgCyphOQgHu2GdPhDxRr
	 Uzu5vslh6Un2otWLVOYRzMO3tAPSLsDIeQROFdQYwpP1Q4gzUfozt1Y+6emojiBcDK
	 Z5iVIGIo/oBL36D0n0Wikmn1bz6EZkhBucBRdIBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.5 260/491] iommufd: Fix missing update of domains_itree after splitting iopt_area
Date: Fri, 24 Nov 2023 17:48:16 +0000
Message-ID: <20231124172032.377211476@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

From: Koichiro Den <den@valinux.co.jp>

commit e7250ab7ca4998fe026f2149805b03e09dc32498 upstream.

In iopt_area_split(), if the original iopt_area has filled a domain and is
linked to domains_itree, pages_nodes have to be properly
reinserted. Otherwise the domains_itree becomes corrupted and we will UAF.

Fixes: 51fe6141f0f6 ("iommufd: Data structure to provide IOVA to PFN mapping")
Link: https://lore.kernel.org/r/20231027162941.2864615-2-den@valinux.co.jp
Cc: stable@vger.kernel.org
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/io_pagetable.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -1060,6 +1060,16 @@ static int iopt_area_split(struct iopt_a
 	if (WARN_ON(rc))
 		goto err_remove_lhs;
 
+	/*
+	 * If the original area has filled a domain, domains_itree has to be
+	 * updated.
+	 */
+	if (area->storage_domain) {
+		interval_tree_remove(&area->pages_node, &pages->domains_itree);
+		interval_tree_insert(&lhs->pages_node, &pages->domains_itree);
+		interval_tree_insert(&rhs->pages_node, &pages->domains_itree);
+	}
+
 	lhs->storage_domain = area->storage_domain;
 	lhs->pages = area->pages;
 	rhs->storage_domain = area->storage_domain;


