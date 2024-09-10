Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A49546444;
	Tue, 10 Sep 2024 09:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961620; cv=none; b=bvQOBBIoujrFVVK7lsoH+nWcUuLBdetkySydoND9s+d+hs56+HQre3Ht9IbqczGKS7twPK23lG2QS0osU4+w/HaISnk55qBCkiq2Bn4D4zUEGxXqPuvj4c9ZEjizgkucvCfwx8tM2pTEKcabBoPnx7CoA3ub3OpKkfejW2gb7Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961620; c=relaxed/simple;
	bh=wZDqG4MooDvhyH+hFfdtFKum8P3AlvGC1yf4D1/3Vcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qxt7k8/WQ4k+YvsPS5Sm8sJQq5vdjiogLQpSl29kig3ZOcLz/WsgQxM+MdoSa7vizXTmkPkG2JolS5xvekojUF6D3kYiROk9fT0Z3yo9CaGCfn2v8PajE66lE7X5vHOopgIAaAR44kyqgyk9w4o/jfSxyybi12J3pjbMkcr+geA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=twX7IK+C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="twX7IK+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C64C4CEC3;
	Tue, 10 Sep 2024 09:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961620;
	bh=wZDqG4MooDvhyH+hFfdtFKum8P3AlvGC1yf4D1/3Vcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=twX7IK+CJRTki503b75XBu50MKsh856OTwGFzGil2/14PiZhsEoRF4fPMKcXgzDfj
	 CS735KecLXZUreM4mIfQXWeMT5w3rJTBhAPQmytq49AHmM3ZNXCiS4VYlAR6HKfJlQ
	 kJOhQuDN9a0Xbg889+oUOgd0krlrTososftIA4J8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 131/375] vfio/spapr: Always clear TCEs before unsetting the window
Date: Tue, 10 Sep 2024 11:28:48 +0200
Message-ID: <20240910092626.833176406@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



