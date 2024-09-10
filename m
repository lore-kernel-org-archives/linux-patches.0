Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693ED17BB0C;
	Tue, 10 Sep 2024 10:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964211; cv=none; b=JCMrTl/s3k8jDcn0PN68xso1b6FSQRIUPxVmfM6XN01fHRzJIyg5tEpak8hKpfr70Cg5CExMlZ8Qdz515+t63RhQQnl1e2Zs5yDv9zsnamLkwZLArzmQhSj8DMA5OKGOw5MMbL8G9n7Cb3h+sIRdo1aUMiAsFF0fyEpl4I3PnIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964211; c=relaxed/simple;
	bh=l27zFQaenzKLLNNiKssM0jamu2280H9eJ+MHyVZ95I8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFSjSo2y6jFXVAvwazyGTU6WGTDXOu+fv5VxT2F/nnJSCKo2NNmJRLB5mmSxxDerLjjnifSshWSUYzs4t24CoUpL3AosPPHplDkr0eHkGvSYA887V3CMFgIWwWCV5rUu2ucxKmJI7AAnAwm+PBVB4jQu8dGSQPK9/54jWXIta0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xyvtAAGc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xyvtAAGc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DB4C4CEC6;
	Tue, 10 Sep 2024 10:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964211;
	bh=l27zFQaenzKLLNNiKssM0jamu2280H9eJ+MHyVZ95I8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xyvtAAGcCO3N8N3P8kfI9OGtCg2NTMFEU/2D4MzsobRb2UQQBocapzb9KXVRfsCGU
	 pvtXDm0l61OLi+jNeys7lw+q+jgf/vFNaIAOEeJWSln7RcRJ4bE4sjdWOPMAr66cGH
	 r40S8Zl/fDWhln+MRL44PkzrmlAuvO51vpBbtesI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/269] vfio/spapr: Always clear TCEs before unsetting the window
Date: Tue, 10 Sep 2024 11:31:15 +0200
Message-ID: <20240910092611.343253550@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Shivaprasad G Bhat <sbhat@linux.ibm.com>

[ Upstream commit 4ba2fdff2eb174114786784926d0efb6903c88a6 ]

The PAPR expects the TCE table to have no entries at the time of
unset window(i.e. remove-pe). The TCE clear right now is done
before freeing the iommu table. On pSeries, the unset window
makes those entries inaccessible to the OS and the H_PUT/GET calls
fail on them with H_CONSTRAINED.

On PowerNV, this has no side effect as the TCE clear can be done
before the DMA window removal as well.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/171923273535.1397.1236742071894414895.stgit@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio_iommu_spapr_tce.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index a94ec6225d31..5f9e7e477078 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -364,7 +364,6 @@ static void tce_iommu_release(void *iommu_data)
 		if (!tbl)
 			continue;
 
-		tce_iommu_clear(container, tbl, tbl->it_offset, tbl->it_size);
 		tce_iommu_free_table(container, tbl);
 	}
 
@@ -720,6 +719,8 @@ static long tce_iommu_remove_window(struct tce_container *container,
 
 	BUG_ON(!tbl->it_size);
 
+	tce_iommu_clear(container, tbl, tbl->it_offset, tbl->it_size);
+
 	/* Detach groups from IOMMUs */
 	list_for_each_entry(tcegrp, &container->group_list, next) {
 		table_group = iommu_group_get_iommudata(tcegrp->grp);
@@ -738,7 +739,6 @@ static long tce_iommu_remove_window(struct tce_container *container,
 	}
 
 	/* Free table */
-	tce_iommu_clear(container, tbl, tbl->it_offset, tbl->it_size);
 	tce_iommu_free_table(container, tbl);
 	container->tables[num] = NULL;
 
@@ -1197,9 +1197,14 @@ static void tce_iommu_release_ownership(struct tce_container *container,
 		return;
 	}
 
-	for (i = 0; i < IOMMU_TABLE_GROUP_MAX_TABLES; ++i)
-		if (container->tables[i])
+	for (i = 0; i < IOMMU_TABLE_GROUP_MAX_TABLES; ++i) {
+		if (container->tables[i]) {
+			tce_iommu_clear(container, container->tables[i],
+					container->tables[i]->it_offset,
+					container->tables[i]->it_size);
 			table_group->ops->unset_window(table_group, i);
+		}
+	}
 }
 
 static long tce_iommu_take_ownership(struct tce_container *container,
-- 
2.43.0



