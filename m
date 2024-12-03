Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812A51F7545;
	Tue,  3 Dec 2024 15:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238868; cv=none; b=ai+WCkz1fVNDt9HzGFnyoqVPk4ee9vOYes63pUXLU3e9Qz6He9tsgk8aMWKZMaDvojCewhnkIs3u8t1oX9WoBroI9QOAp9CLW6RjIJ9RCvxgjjX1KRQ3orSLnQQlyKmNW9StL7wBW7r7eHAhX7EPOHpSkUVs72FQ9cz1eVe5T3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238868; c=relaxed/simple;
	bh=cORNmTO4W6jF0OmNvYAy2nAdgjequoI6Qiq+HoC0gqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZrxqE5FpELLqewGzXzJpJccKKe0KkHBnJIK8i/xvPo1pCkJd8GBCHKFoCcFCq320PU1k6qewlboUJClnXOeh5z/9GYwAtBsxbmodZINds3cFJSaCpeQIJqTtvYfDIAfKu0FGWmUBcM6bsNNcgdD6TnfX9x+BMg1rFEUvl1lVls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=imP6SSsV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="imP6SSsV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A155C4CECF;
	Tue,  3 Dec 2024 15:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238868;
	bh=cORNmTO4W6jF0OmNvYAy2nAdgjequoI6Qiq+HoC0gqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=imP6SSsVh3iAto2Rg/rUPFffOU/KKnOct2hHv6QtJgtPxdN39kAUHP0/FxsRsHrWm
	 f9GC7W33hCN73+R7e+/UmKLe0MYqF/hiyE2nuuz91wy2xiITfh1wPX/6rTUYDAahEu
	 22FK8OWLd71XiMFUj96KUYGLGZcONmD/f7XZH/zM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 407/817] iommu/amd: Remove amd_iommu_domain_update() from page table freeing
Date: Tue,  3 Dec 2024 15:39:39 +0100
Message-ID: <20241203144011.763029639@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 322d889ae7d39f8538a6deac35869aa3be1855bd ]

It is a serious bug if the domain is still mapped to any DTEs when it is
freed as we immediately start freeing page table memory, so any remaining
HW touch will UAF.

If it is not mapped then dev_list is empty and amd_iommu_domain_update()
does nothing.

Remove it and add a WARN_ON() to catch this class of bug.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/4-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: 016991606aa0 ("iommu/amd/pgtbl_v2: Take protection domain lock before invalidating TLB")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/io_pgtable.c | 3 ---
 drivers/iommu/amd/iommu.c      | 2 ++
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 05aed3cb46f1b..b3991ad1ae8ea 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -578,9 +578,6 @@ static void v1_free_pgtable(struct io_pgtable *iop)
 
 	/* Update data structure */
 	amd_iommu_domain_clr_pt_root(dom);
-
-	/* Make changes visible to IOMMUs */
-	amd_iommu_domain_update(dom);
 }
 
 static struct io_pgtable *v1_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 1a61f14459e4f..881f6c589257c 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2262,6 +2262,8 @@ void protection_domain_free(struct protection_domain *domain)
 	if (!domain)
 		return;
 
+	WARN_ON(!list_empty(&domain->dev_list));
+
 	if (domain->iop.pgtbl_cfg.tlb)
 		free_io_pgtable_ops(&domain->iop.iop.ops);
 
-- 
2.43.0



