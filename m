Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0E739FD9;
	Fri, 24 Nov 2023 18:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZccXdnTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555BFC433C8;
	Fri, 24 Nov 2023 18:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849674;
	bh=97xw6AOSTMw0Rsmce7DfeEUR6h1T7HVS5pLdrMWXWAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZccXdnTGDhXFuuZX2jv4mBamPBBofh4SelRnjj0Pc6MPINXhLrNsRgOIfjJmFSNqB
	 427ciJnfZPumt7fRw5s5PhbVeFsrPsxMpWdVIWVA0I0GFpJWAPbdpQKyLObH7wco27
	 pDu/OcoxXuNPG463ojPWrBHyB/1QlEulpaBKJo7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.6 276/530] iommufd: Fix missing update of domains_itree after splitting iopt_area
Date: Fri, 24 Nov 2023 17:47:22 +0000
Message-ID: <20231124172036.442468376@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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


